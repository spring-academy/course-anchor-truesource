#!/usr/bin/env bash
#
# Builds the pre-staged copy of the Spring Enterprise repository that the lab
# uses instead of authenticating against packages.broadcom.com.
#
# It runs the lab's patch step (`advisor patch apply`) against the real Spring
# Enterprise repository with a fresh local Maven repository, resolves everything
# the patched application needs, then keeps only the artifacts that came from
# the Spring Enterprise repository. Those are written in remote repository
# layout, with a maven-metadata.xml per artifact that only lists the versions in
# the snapshot, so the lab resolves exactly the same versions on every run.
#
# Requirements: JDK 17, git, python3, the Application Advisor CLI (`advisor`,
# same version as the lab) and a Spring Enterprise token:
#
#   export SPRING_ENTERPRISE_USERNAME=<your Broadcom support portal user>
#   export SPRING_ENTERPRISE_TOKEN=<your Spring Enterprise repository token>
#   ./scripts/build-spring-enterprise-repo.sh
#
# The result is spring-enterprise-repo-boot-<version>.tar.gz in the repository
# root (gitignored). Upload it to the academy bucket with the command printed
# at the end, and update SOURCE_FILE_NAME of the download-spring-enterprise-repo
# initContainer in resources/apply/spring-anchor.yaml if the name changed.
#
# Last run 2026-10-12 (archive for Spring Boot 3.5.17: 474 files, 74
# artifacts). Verified in a staging session: `advisor patch apply` resolves
# Spring Boot 3.5.17 / Spring Framework 6.2.20 through the lab's file://
# mirror, and the rescan comes back clean.
#
# TODO: replace this script with a GitHub Actions workflow, see
# https://github.com/spring-academy/course-anchor-truesource/issues/1
#
set -euo pipefail

: "${SPRING_ENTERPRISE_USERNAME:?set SPRING_ENTERPRISE_USERNAME}"
: "${SPRING_ENTERPRISE_TOKEN:?set SPRING_ENTERPRISE_TOKEN}"
command -v advisor >/dev/null || { echo "advisor CLI not found on PATH" >&2; exit 1; }

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="${WORK:-$ROOT_DIR/work}"
rm -rf "$WORK"
mkdir -p "$WORK"

# 1. Maven settings with the real Spring Enterprise credentials and an empty
#    local repository, so every artifact is downloaded and its origin recorded.
cat > "$WORK/settings.xml" <<EOF
<settings>
  <localRepository>$WORK/m2</localRepository>
  <servers>
    <server>
      <id>spring-enterprise</id>
      <username>${SPRING_ENTERPRISE_USERNAME}</username>
      <password>${SPRING_ENTERPRISE_TOKEN}</password>
    </server>
  </servers>
</settings>
EOF
chmod 600 "$WORK/settings.xml"
# Advisor and the Maven wrapper are Java programs: they read the settings.xml
# in the account's home directory (Java's user.home comes from the OS account,
# not from $HOME), so overriding HOME doesn't work. Swap ours into place and
# put the original back on exit.
USER_SETTINGS="$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f6)"
USER_SETTINGS="${USER_SETTINGS:-$HOME}/.m2/settings.xml"
mkdir -p "$(dirname "$USER_SETTINGS")"
if [ -f "$USER_SETTINGS" ]; then cp -p "$USER_SETTINGS" "$WORK/settings.xml.orig"; fi
restore_settings() {
  if [ -f "$WORK/settings.xml.orig" ]; then mv "$WORK/settings.xml.orig" "$USER_SETTINGS"; else rm -f "$USER_SETTINGS"; fi
}
trap restore_settings EXIT
cp "$WORK/settings.xml" "$USER_SETTINGS"

# 2. Same application as the lab, then the lab's patch step. Advisor needs the
#    build configuration first, so it resolves versions against the repositories.
bash "$ROOT_DIR/labs/anchor/workshop/scripts/prepare-petclinic.sh" "$WORK/spring-petclinic"
cd "$WORK/spring-petclinic"
TERM=dumb advisor build-config get
TERM=dumb advisor patch apply
git --no-pager diff pom.xml
BOOT_VERSION=$(python3 - <<'PY'
import re
pom = open("pom.xml").read()
print(re.search(r"<artifactId>spring-boot-starter-parent</artifactId>\s*<version>([^<]+)</version>", pom).group(1))
PY
)
echo "==> Patched to Spring Boot $BOOT_VERSION"

# 3. Resolve everything the lab does with the patched application.
./mvnw -B -q dependency:go-offline -Dcheckstyle.skip -Dspring-javaformat.skip
./mvnw -B -q -DskipTests -Dcheckstyle.skip -Dspring-javaformat.skip package
./mvnw -B -q dependency:tree -Dincludes=org.springframework:spring-webmvc
./mvnw -B -q org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom -DoutputFormat=json -DoutputName=bom

# 4. Keep the artifacts that came from the Spring Enterprise repository, in
#    remote repository layout, and write matching maven-metadata.xml files.
OUT="$WORK/spring-enterprise-repo"
python3 - "$WORK/m2" "$OUT" <<'PY'
import os, re, shutil, sys, time
from collections import defaultdict

local, out = sys.argv[1], sys.argv[2]
versions = defaultdict(set)   # (group path, artifact) -> versions
count = 0
for dirpath, _, files in os.walk(local):
    if "_remote.repositories" not in files:
        continue
    with open(os.path.join(dirpath, "_remote.repositories")) as f:
        enterprise = {line.split(">")[0] for line in f
                      if not line.startswith("#") and line.strip().endswith(">spring-enterprise=")}
    if not enterprise:
        continue
    rel = os.path.relpath(dirpath, local)
    os.makedirs(os.path.join(out, rel), exist_ok=True)
    for name in enterprise:
        for suffix in ("", ".sha1", ".md5", ".asc"):
            src = os.path.join(dirpath, name + suffix)
            if os.path.exists(src):
                shutil.copy2(src, os.path.join(out, rel, name + suffix))
                count += 1
    parts = rel.split(os.sep)
    versions[(os.sep.join(parts[:-2]), parts[-2])].add(parts[-1])

stamp = time.strftime("%Y%m%d%H%M%S", time.gmtime())
for (group_path, artifact), vs in versions.items():
    ordered = sorted(vs, key=lambda v: [(0, int(t)) if t.isdigit() else (1, t) for t in re.split(r"[.-]", v)])
    latest = ordered[-1]
    xml = ["<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "<metadata>",
           f"  <groupId>{group_path.replace(os.sep, '.')}</groupId>",
           f"  <artifactId>{artifact}</artifactId>", "  <versioning>",
           f"    <latest>{latest}</latest>", f"    <release>{latest}</release>", "    <versions>"]
    xml += [f"      <version>{v}</version>" for v in ordered]
    xml += ["    </versions>", f"    <lastUpdated>{stamp}</lastUpdated>", "  </versioning>", "</metadata>", ""]
    with open(os.path.join(out, group_path, artifact, "maven-metadata.xml"), "w") as f:
        f.write("\n".join(xml))
print(f"==> {count} files for {len(versions)} artifacts from spring-enterprise")
PY

ls "$OUT/org/springframework/spring-webmvc" "$OUT/org/springframework/boot/spring-boot-starter-parent"

ARCHIVE="$ROOT_DIR/spring-enterprise-repo-boot-${BOOT_VERSION}.tar.gz"
tar -czf "$ARCHIVE" -C "$OUT" .
echo
echo "==> Wrote $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
echo "==> Upload it with:"
echo "    gcloud storage cp \"$ARCHIVE\" gs://academy-artifacts/spring/anchor/$(basename "$ARCHIVE")"
