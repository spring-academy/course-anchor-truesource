#!/bin/bash
#
# Creates the workshop's sample application in directory $1: upstream Spring
# PetClinic at the last commit on the Spring Boot 3.5 line, pinned to the last
# open source Spring Boot 3.5 release, with the Spring Enterprise repository
# declared like in a real customer build. The result is a fresh git repository
# with a single commit.
#
# Used by setup.d/01-workshop-setup.sh in the session and by
# scripts/build-spring-enterprise-repo.sh when the pre-staged Spring Enterprise
# artifacts are built, so both work on exactly the same application.

set -e

TARGET_DIR="${1:?usage: prepare-petclinic.sh <target-dir>}"
PETCLINIC_REPO=https://github.com/spring-projects/spring-petclinic
PETCLINIC_COMMIT=66747e344ec6d4ec5fce2c603c1b61eeeadda8ff
SPRING_BOOT_VERSION=3.5.16

git clone -q "${PETCLINIC_REPO}" "${TARGET_DIR}"
cd "${TARGET_DIR}"
git checkout -q "${PETCLINIC_COMMIT}"
rm -rf .git

python3 - "${SPRING_BOOT_VERSION}" <<'PY'
import re, sys
boot = sys.argv[1]
pom = open("pom.xml").read()
pom = re.sub(r"(<artifactId>spring-boot-starter-parent</artifactId>\s*<version>)[^<]+(</version>)",
             r"\g<1>" + boot + r"\g<2>", pom, count=1)
repos = """<repositories>
    <repository>
      <id>spring-enterprise</id>
      <name>Spring Enterprise</name>
      <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
    </repository>
  </repositories>
  <pluginRepositories>
    <pluginRepository>
      <id>spring-enterprise</id>
      <name>Spring Enterprise</name>
      <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
    </pluginRepository>
  </pluginRepositories>"""
# Replace the Spring snapshot/milestone repositories with the Spring Enterprise one
pom, n = re.subn(r"<repositories>.*?</pluginRepositories>", lambda m: repos, pom, count=1, flags=re.S)
if n != 1:
    pom = pom.replace("\n  <build>", "\n  " + repos + "\n\n  <build>", 1)
open("pom.xml", "w").write(pom)
PY

printf "\n.advisor\n" >> .gitignore
git init -q -b main
git add -A
git -c user.name="Platform Team" -c user.email="platform@example.com" \
    commit -q -m "Spring PetClinic on Spring Boot ${SPRING_BOOT_VERSION}"
