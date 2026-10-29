---
title: The Data Tier
---

Your application isn't only Java code. PetClinic stores its data in a relational database, and many real applications add a cache and a message broker. More than 95 percent of enterprises run at least one open source database, and these engines have seen the same rise in reported vulnerabilities as application frameworks.

Patching a data engine is harder than patching a library: a flawed patch can put the data itself at risk. The engine also isn't a single artifact. PostgreSQL alone has dozens of commonly used extension projects. Five supported major versions across 75 extension projects give about 375 possible combinations to build, test, and keep patched.

#### The same checks, for a cache

Run the same comparison for **Valkey**, the open source key-value store that many applications use as a cache.

```execute
cd ~ && for img in docker.io/valkey/valkey:latest docker.io/bitnamisecure/valkey:latest; do printf "%-42s " "$img"; trivy image --quiet --image-src remote --platform linux/amd64 --scanners vuln --format json "$img" | jq -r '[.Results[]?.Vulnerabilities[]?.Severity] | group_by(.) | map("\(.[0]): \(length)") | join("   ")'; done
```

Verify that the Bitnami Secure Image is signed by Broadcom.

```execute
cosign verify --key https://app-catalog.vmware.com/.well-known/cosign.pub --insecure-ignore-tlog docker.io/bitnamisecure/valkey:latest > /dev/null && echo "Signature verified"
```

#### What TrueSource Data Services adds

The public catalog gives you the `latest` builds of each image for development and evaluation. **TrueSource Data Services** turns the same discipline into an enterprise offering for **PostgreSQL, MySQL, Valkey, and RabbitMQ**:

- **Curated, enterprise-grade distributions** of the engines *and* their extensions, built with SLSA Level 3 provenance and signed SBOMs, with FIPS-validated cryptography for selected engines.
- **Patches that drop in without a regression cycle**, worked out with the upstream maintainers instead of in a private fork.
- **Helm charts and Kubernetes operators**, plus DBaaS automation with VMware Data Services Manager, to deploy on bare metal, VMs, or any conformant Kubernetes platform.
- **24x7 support** from the engineers who build products on these engines.

#### The whole stack, one standard

Look back at what you've touched in this workshop:

| Layer | What you did | TrueSource offering |
|---|---|---|
| Spring and its dependency tree | Applied a CVE-only patch on an out-of-support line | **Spring Enterprise** |
| Libraries and container images | Verified signatures, provenance, and evidence | **TrueSource Trusted Artifacts** |
| Data engines | Compared and verified PostgreSQL and Valkey images | **TrueSource Data Services** |

All three follow the same standard: clean-room builds, continuous CVE scanning, selective patching worked out upstream, early access to fixes, and evidence you can verify yourself.
