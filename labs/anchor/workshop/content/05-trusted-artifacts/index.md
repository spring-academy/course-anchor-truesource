---
title: "Trusted Artifacts: Verify Before You Pull"
---

Patching your dependencies only helps if you can trust what you download. Attackers increasingly target the **build and distribution pipeline itself**: typo-squatted packages, tampered manifests, compromised maintainer accounts, and hijacked CI systems.

A recent example hit very close to this workshop. On March 19, 2026, attackers used a token leaked from a misconfigured GitHub workflow to force-push 76 of the 77 version tags of the `aquasecurity/trivy-action` GitHub Action to malicious commits, and published a backdoored Trivy v0.69.4 binary. Every pipeline that pulled the action by tag ran the attacker's code on its next run. The scanner you've been using was, briefly, the attack.

#### Verify your own tools first

The Trivy you used in this workshop is version 0.75.0. Its download was checked against the SHA-256 published with the release. Release checksums only help if the release page itself is trustworthy, though, so Trivy also signs every release artifact with [Sigstore](https://www.sigstore.dev). Verify that the archive was built by Trivy's own release workflow for that exact tag.

```execute
cd ~/tools && cosign verify-blob trivy_0.75.0_Linux-64bit.tar.gz \
  --bundle trivy_0.75.0_Linux-64bit.tar.gz.sigstore.json \
  --certificate-identity https://github.com/aquasecurity/trivy/.github/workflows/reusable-release.yaml@refs/tags/v0.75.0 \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

`Verified OK` means the signature is valid, the signing certificate was issued to Trivy's release workflow on GitHub Actions, and the signature is recorded in Sigstore's public transparency log.

Doing this for every library and image your teams pull is a lot of work. **TrueSource Trusted Artifacts** does it for you: every artifact is rebuilt from verified source in an isolated, clean-room environment, scanned and tested version by version, and shipped with cryptographic provenance validated to **SLSA Build Level 3** and an SBOM. Verification happens before you pull, so your pipeline doesn't have to stop to prove what it's running.

Let's look at what that means for a container image, using the free, public catalog of **Bitnami Secure Images** on Docker Hub.

#### Compare a community image with a Bitnami Secure Image

Start with the PostgreSQL database. First, scan the popular community image.

```execute
cd ~ && trivy image --quiet --image-src remote --platform linux/amd64 --scanners vuln --format json docker.io/library/postgres:latest > postgres-community.json && jq -r '[.Results[]?.Vulnerabilities[]?.Severity] | group_by(.) | map("\(.[0]): \(length)") | join("   ")' postgres-community.json
```

Now scan the Bitnami Secure Image.

```execute
trivy image --quiet --image-src remote --platform linux/amd64 --scanners vuln --format json docker.io/bitnamisecure/postgresql:latest > postgres-bsi.json && jq -r '[.Results[]?.Vulnerabilities[]?.Severity] | group_by(.) | map("\(.[0]): \(length)") | join("   ")' postgres-bsi.json
```

The exact numbers change every day as new CVEs are published and images are rebuilt, but the difference is usually dramatic. When we wrote this workshop, the community image had hundreds of findings, including critical ones, and the Bitnami Secure Image had one.

Bitnami Secure Images start from a minimal, hardened base and ship only what the application needs. They're rebuilt continuously as fixes land, and Broadcom fixes the components it can at the source, working with upstream maintainers.

#### Verify the signature

A low CVE count only matters if the image is really the one Broadcom built. Bitnami Secure Images are signed with cosign. Verify the signature with Broadcom's published public key.

```execute
cosign verify --key https://app-catalog.vmware.com/.well-known/cosign.pub --insecure-ignore-tlog docker.io/bitnamisecure/postgresql:latest | jq .
```

The signed payload contains the exact digest of the image. If a single byte of the image changed, verification would fail.

{{< note >}}
These images are signed with a key instead of Sigstore's keyless flow, so there's no transparency log entry to check, which is what `--insecure-ignore-tlog` tells cosign.
{{< /note >}}

Before you trust a key you downloaded, compare its fingerprint with the one published in the [Bitnami Secure Images documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/bitnami-secure-images/bitnami-secure-images/services/bsi-doc/using-verify-signatures.html), `D0:C7:C4:58:04:A0:A2:45:87:14:FE:8B:A8:AB:1B:58:DC:23:B6:8F:B0:33:91:53:6C:69:DB:75:50:52:F2:4E`.

```execute
curl -sSL https://app-catalog.vmware.com/.well-known/cosign.pub | openssl pkey -pubin -outform DER | openssl dgst -sha256 -c
```

#### Verify the SLSA provenance

The signature tells you *who* signed the image. **Provenance** tells you *how it was built*: which build system, from which inputs. Verify the signed SLSA provenance attestation and look inside it.

```execute
cosign verify-attestation --key https://app-catalog.vmware.com/.well-known/cosign.pub --insecure-ignore-tlog --type slsaprovenance1 docker.io/bitnamisecure/postgresql:latest 2>/dev/null | jq -r .payload | base64 -d | jq '{predicateType, builder: .predicate.runDetails.builder.id, baseImage: .predicate.buildDefinition.externalParameters.baseImage, inputs: [.predicate.buildDefinition.resolvedDependencies[].uri], built: .predicate.runDetails.metadata.finishedOn}'
```

The provenance names the SLSA Build Level 3 builder, the pinned base image digest the build started from, and when the build ran. Policy engines in your pipeline or cluster can check these fields automatically before an image is admitted.

#### Pull the evidence

Every Bitnami Secure Image also ships with an evidence bundle, published next to the image as an OCI artifact. Pull it with [ORAS](https://oras.land).

```execute
mkdir -p ~/evidence && cd ~/evidence && oras pull docker.io/bitnamisecure/postgresql:latest-metadata && ls -1
```

Here's what you get with every build:

| File | What it gives you |
|---|---|
| `spdx.json`, `cyclonedx.json` | The SBOM, in both common formats |
| `slsa-provenance.json` | The build provenance you verified above |
| `vex.json` | A VEX document, Broadcom's statements on whether listed CVEs actually affect the image |
| `cve-trivy-scanner-output-*.json`, `vulnerability-cvrf-report-*.xml` | The vulnerability scan results for each architecture |
| `clamav-antivirus-scan-*.log` | The antivirus scan results |
| `stig-reports.tar.gz` | Security Technical Implementation Guide (STIG) compliance reports |
| `test-results.tar.gz` | The functional test results for the build |
| `source-container.tar.gz` | The source of the image, for license compliance |

This is the evidence your auditors ask for, generated for every build, instead of gathered by hand.

```execute
jq -r '.packages[] | select(.name | test("^(postgresql|pgvector|postgis|wal2json)$")) | "\(.name) \(.versionInfo)"' spdx.json | sort -u
```

The SBOM shows not only the PostgreSQL engine but also the extensions built into the image, such as `pgvector` for vector search and `postgis` for geospatial data. Each of these is open source software that needs patching too. That brings us to the data tier.
