#!/bin/bash

set -x
set -e

# Session pods have no direct internet access (see the NetworkPolicies in the
# Workshop resource). Everything is either packaged in the workshop files at
# build time (./sources) or served by the in-cluster lab-services pod, which is
# populated once per workshop environment:
#   LAB_FILES_URL    - file service with the tools bundle
#   MAVEN_MIRROR_URL - read-only caching proxy of Maven Central
: "${LAB_FILES_URL:?}" "${MAVEN_MIRROR_URL:?}"
SOURCES_DIR="${WORKSHOP_DIR:-/opt/workshop}/sources"

# 1. Install cosign, Trivy and ORAS, plus the Trivy databases, from the tools
#    bundle. ~/bin is owned by root (the advisor CLI is mounted into it), so the
#    tools go into ~/.local/bin, which the workshop profile adds to the PATH.
#    The Trivy archive and its Sigstore bundle are in ~/tools so the learner can
#    verify them in the workshop.
for i in $(seq 1 90); do
    curl -sf --head "$LAB_FILES_URL/tools.tar.gz" > /dev/null && break
    echo "Waiting for $LAB_FILES_URL/tools.tar.gz ($i/90)"
    sleep 5
done
curl -sf "$LAB_FILES_URL/tools.tar.gz" | tar -xz -C "$HOME"

# The openssl command used in the workshop, with its libraries
for i in $(seq 1 90); do
    curl -sf --head "$LAB_FILES_URL/openssl.tar.gz" > /dev/null && break
    echo "Waiting for $LAB_FILES_URL/openssl.tar.gz ($i/90)"
    sleep 5
done
curl -sf "$LAB_FILES_URL/openssl.tar.gz" | tar -xz -C "$HOME"

# 2. Trust the lab proxy. It intercepts TLS for the few public hosts the
#    workshop teaches with, so the tools need its CA, which lab-services
#    publishes (public certificate only). The profile points the tools at this
#    bundle (system CAs plus the lab CA) for the learner's terminals.
for i in $(seq 1 90); do
    curl -sf --head "$LAB_FILES_URL/lab-ca.pem" > /dev/null && break
    echo "Waiting for $LAB_FILES_URL/lab-ca.pem ($i/90)"
    sleep 5
done
mkdir -p "$HOME/.lab-ca"
curl -sf -o "$HOME/.lab-ca/ca.pem" "$LAB_FILES_URL/lab-ca.pem"
SYSTEM_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt
[ -f "$SYSTEM_BUNDLE" ] || SYSTEM_BUNDLE=/etc/ssl/certs/ca-certificates.crt
cat "$SYSTEM_BUNDLE" "$HOME/.lab-ca/ca.pem" > "$HOME/.lab-ca/bundle.pem"

# 3. Point the Spring Enterprise repository at the pre-staged copy that the
#    download-spring-enterprise-repo initContainer placed in the session. In
#    your own environment this is https://packages.broadcom.com/artifactory/spring-enterprise
#    with a <server> entry holding your Spring Enterprise token. Everything else
#    resolves through the in-cluster Maven Central mirror.
mkdir -p "$HOME/.m2"
cat > "$HOME/.m2/settings.xml" <<SETTINGS
<settings>
  <mirrors>
    <mirror>
      <id>spring-enterprise-academy</id>
      <name>Pre-staged Spring Enterprise artifacts for this workshop</name>
      <url>file://${SPRING_ENTERPRISE_REPO_DIR:-/opt/spring-enterprise-repo}</url>
      <mirrorOf>spring-enterprise</mirrorOf>
    </mirror>
    <mirror>
      <id>lab-mirror</id>
      <mirrorOf>*,!spring-enterprise</mirrorOf>
      <url>${MAVEN_MIRROR_URL}</url>
    </mirror>
  </mirrors>
</settings>
SETTINGS
export MVNW_REPOURL="$MAVEN_MIRROR_URL"

# 4. Make the sample application available on the local git server
WORK=$(mktemp -d)
git clone -q "$SOURCES_DIR/spring-petclinic.bundle" "$WORK/spring-petclinic"
mkdir -p /opt/git/repositories
git clone -q --bare "$WORK/spring-petclinic" /opt/git/repositories/spring-petclinic
cd "$WORK/spring-petclinic"

# 5. Warm the local Maven repository so the first build in the workshop is fast.
./mvnw -B -q -DskipTests -Dcheckstyle.skip -Dspring-javaformat.skip package || true
./mvnw -B -q org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom -DoutputFormat=json -DoutputName=bom || true
cd "$HOME"
rm -rf "$WORK"
