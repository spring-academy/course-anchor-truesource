**TrueSource by Broadcom** is a portfolio of commercially supported, mission-critical open source software built on a single, enterprise-grade security and delivery standard. It provides hardened, verifiably built open source components, backed by human-centered engineering and direct upstream stewardship.

TrueSource isn't a single product. It brings together three offerings, each sold separately with simple, tiered site licensing:

| Offering | Covers |
|---|---|
| **Spring Enterprise** (formerly VMware Tanzu Spring) | Spring and its full dependency tree |
| **TrueSource Trusted Artifacts** | Java, Python, and Node.js (npm) libraries, plus hardened container images and Helm charts built with Bitnami technology |
| **TrueSource Data Services** | PostgreSQL, MySQL, Valkey, and RabbitMQ, with VMware Data Services Manager |

## The TrueSource approach

Every offering follows the same four principles, shaped by Broadcom's experience as a steward and maintainer of open source software.

1. **Curate from deep domain expertise.** Broadcom is the steward of Spring and RabbitMQ, the maintainer of Bitnami, and has a decade of experience supporting PostgreSQL, MySQL, and Valkey. Artifacts are selected against a reference architecture for enterprise applications, then built and verified by Broadcom engineers.
1. **Work with maintainers, not around them.** Broadcom contributes fixes upstream rather than forking, and backs community maintainers with engineering time and funding.
1. **Collaborate in a private clearinghouse.** Licensed customers can bring vulnerabilities they discover, before they're public, and work on them with Broadcom engineers. The outcome is early access to fixes, with a dedicated path for critical infrastructure organizations to get patch insights and mitigation advice.
1. **Automate fixes and make them visible.** Tooling analyzes your repositories, assesses the impact of each release before you consume it, and opens pull requests with the lowest-risk remediation path. Dashboards that show your security team what's fixed and what remains, across repositories and pipelines, are coming soon.

## One standard, three offerings

The offerings cover different ecosystems, but they share the same build discipline:

* **Clean-room builds.** Every artifact is traced to authentic upstream source and rebuilt in an isolated, controlled environment, with cryptographic provenance validated to SLSA Build Level 3.
* **CVE scanning.** Components are scanned and tested continuously, version by version.
* **Selective patching, upstream.** Fixes are developed with, or by, the upstream maintainers, and delivered without dragging in unrelated changes.
* **Early access.** Fixes reach licensed customers before public disclosure where possible.
* **End-to-end dashboards** (coming soon), so you can see your security posture and patching progress.

The depth of each offering follows the reach of Broadcom's stewardship: deepest for Spring, which Broadcom maintains, and broad across the wider ecosystem.

## Spring Enterprise

Spring Enterprise provides production-ready Spring, plus security benefits that only the maintainer of Spring can deliver. All committers for Spring Boot, Spring Framework, and the broader Spring portfolio are part of Broadcom's Tanzu team.

* **Early, simultaneous patches for current and long-term support versions.** Because Broadcom maintains Spring, it patches every supported release line at the same time, including lines that have left open source support. Spring Boot 3.5 left open source support on June 30, 2026, and Spring Enterprise customers still receive patches for it.
* **CVE-only patches.** A full point release bundles fixes with changes that demand testing. A CVE-only patch carries the security fix alone, so you can push it to production in hours, not weeks.
* **The whole dependency tree, not just Spring.** Coverage extends to Spring's managed dependencies, including Apache Tomcat and Kotlin: more than **5,000** verified Java libraries, built with SLSA Level 3 provenance and signed at the exact versions each supported Spring Boot line pins. For comparison, a Spring Boot 4.0 application resolves about **1,768** dependencies.
* **Selective patching for dependencies,** when a fix is needed in a library below Spring.
* **Spring Application Advisor,** tooling that analyzes your repositories and automates patches and upgrades across your estate, deterministically, with tested recipes built on OpenRewrite instead of AI. `advisor patch apply` moves an application to the latest patch releases on its current lines; `advisor upgrade-plan apply` moves it step by step to newer release lines. It runs in your CI pipeline and opens pull requests.
* **Enterprise Spring Boot extensions** for compliance needs such as FIPS, governance actuators, and approved TLS ciphers, plus enterprise Spring components such as Spring Cloud Gateway and Tanzu tc Server.
* **24x7 support** from the core maintainers of the Spring ecosystem, covering more than 50 Spring projects, OpenJDK, and Apache Tomcat. Java runtime builds and support are included.

### How a Spring vulnerability gets fixed

Because Broadcom is the maintainer of Spring and issues the CVEs, it owns every step from receiving a report to releasing a validated patch:

1. **Confidential intake.** An independent researcher, a customer, or Broadcom's own red team identifies a potential flaw and reports it privately.
1. **Patch development.** The Spring engineering team develops the fix, with a closed loop between AI scanners and the engineers who know the code. Fixes are authored, reviewed, and verified by those engineers.
1. **Collaboration with the reporter.** The fix is validated with the original reporter.
1. **Early release.** Customers who must remediate before disclosure can get the patch early.
1. **Open source release.** The fix is incorporated into the next upstream Spring release.
1. **CVE published.** Only then are the CVE, advisory details, and attribution disclosed.

The result: the fix exists before the CVE is public, scanners recognize Broadcom's patched builds so remediation shows as fixed, and Application Advisor turns the patch into pull requests across your repositories.

## TrueSource Trusted Artifacts

TrueSource Trusted Artifacts, a new add-on offering, extends the same approach beyond Spring: secure, vetted, and provenance-verified open source software for your enterprise.

* **Language libraries:** curated Java libraries beyond Spring's dependency tree, plus Python (PyPI) and Node.js (npm) libraries, built in a clean room to SLSA Build Level 3.
* **Bitnami technology:** hardened container images and Helm charts for hundreds of open source projects, from the Bitnami Secure Images catalog. Bitnami has 19 years of hardening and clean-room build experience, more than 40 billion downloads, and is trusted by hundreds of thousands of companies.
* **Patched upstream:** where Broadcom develops fixes, it contributes them back upstream whenever possible.
* **Expertise:** access to Extended Experts and Resident Engineers, for analysis and patch delivery based on your application requirements.

Every artifact goes through the same verifiable pipeline:

1. **Verified source:** each component is traced to authentic, verified upstream source code.
1. **Scan and test:** dedicated security scanning and testing, version by version.
1. **Controlled build:** rebuilt in an isolated, controlled environment, where nothing enters unvetted.
1. **Signed, with SBOM:** cryptographically signed, with a full ingredient list for every build.
1. **Keep current:** continuously rebuilt and repatched as new CVEs land.

How fixes reach you depends on where they land. If a fix goes upstream, Broadcom rebuilds the artifact and you get it through the same repository. If a temporary fork is needed, Broadcom distributes it through the private repository and takes care of merging it back upstream. If you discover a new vulnerability, or need a patch for an out-of-support version, you can bring it to Broadcom through the clearinghouse.

## TrueSource Data Services

TrueSource Data Services brings the TrueSource standard to the data engines enterprise applications depend on: **PostgreSQL, MySQL, Valkey, and RabbitMQ**.

* **Curated, enterprise-grade distributions** of the engines and their critical extensions, with SLSA Level 3 builds, signed SBOMs, and validated FIPS cryptography for selected engines.
* **Patches that drop in without a regression cycle,** worked out with the upstream maintainers, and management of version sprawl across complex data environments.
* **Helm charts, container images, and Kubernetes operators.**
* **DBaaS automation and integration** with VMware Data Services Manager or Kubernetes operators, including management of Microsoft SQL Server (bring your own license).
* **Deploy anywhere:** bare metal, virtual machines, or any conformant Kubernetes platform, on-premises or in the public cloud.
* **24x7 support** from a single vendor, from engineers who build products on these engines.

## From CVE fatigue to continuous governance

Together, the offerings support a continuous flow, instead of a fire drill for each CVE:

1. **Access artifacts:** consume a catalog of secure libraries, images, and data services.
1. **Analyze and prioritize:** collect your open source inventory, assess your exposure, and prioritize patch and upgrade efforts.
1. **Automate patching:** merge patches into source code with the included tooling, from the command line, your IDE, or MCP.
1. **Build apps and containers:** build secure applications and hardened containers (with Build Service and Buildpacks, coming soon).
1. **Deploy and connect services:** deploy hardened images and data services to support your applications.

Next, let's look at what this is worth.
