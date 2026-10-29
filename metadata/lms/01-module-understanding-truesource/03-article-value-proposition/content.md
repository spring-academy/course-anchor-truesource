## Where the patch comes from decides when it reaches you

There are three ways an enterprise can get a fix for an open source vulnerability.

| | AI-generated patches | Aftermarket forks | Patches from the upstream maintainers |
|---|---|---|---|
| **When work starts** | As soon as you run the tool | After the CVE is public, inside the exploit window | Before disclosure, through confidential intake |
| **Quality** | Fast to produce, but non-deterministic by design; only 17 in 100 were robust in independent testing | Written by a third party working backward from the CVE | Written by the engineers who maintain the code |
| **Validation** | Can't be checked against a security report you never received | Rarely checked against the original report | Validated against the original report, with the reporter |
| **Long-term cost** | A private change you have to carry | A private fork whose drift grows with every future release | Lands upstream; nothing extra to maintain |
| **Best used for** | Triage and finding issues | Stopgaps | The fix of record |

AI is excellent at finding issues, and Broadcom uses it heavily to do exactly that. But a patch you can't validate against the original report is a patch you're hoping about. An application on Spring Boot 4.0 resolves about 1,768 interlocking dependency versions; the right fix is one that doesn't disturb that structure. TrueSource delivers fixes from the upstream maintainers, the recommended path.

"Can we just wait for the open source release?" For many applications, yes. The gap is the window between the fix existing and the open source release landing, and whether the version you run still gets releases at all. A majority of Spring Boot downloads are of versions outside the open source support window.

## Three pillars

TrueSource's value rests on three pillars:

* **Maintainer-grade engineering.** Fixes are authored by the stewards of the open source project, or with its upstream maintainers when possible, to preserve community standards.
* **Upstream-first integrity.** Patches that actually work, and long-term stability, backed by maintainer-first principles and investment in open source.
* **Verifiable software lineage.** Comprehensive SBOMs, verifiable source origin, and dependency tracking help you meet strict compliance and security mandates.

Broadcom's investment in open source backs those pillars:

* **75%** of Apache Tomcat fixes come from Broadcom engineers.
* **100%** of open source Spring and RabbitMQ contributions are reviewed by Broadcom.
* **More than 300** Bitnami images, charts, and operators are maintained across open source.
* **Billions** of tokens are used for continuous scanning of open source software with frontier models.

## Six time sinks, six answers

Earlier in this module, you saw the six places enterprises lose time. Here's how TrueSource gives that time back.

| Where time is lost | What TrueSource does | Outcome |
|---|---|---|
| Waiting for the advisory | Confidential intake, private collaboration, and early access to fixes across all three offerings | You can be patched before the CVE is public |
| Retesting the upgrade | CVE-only patches on the version you already run, applied by Application Advisor as pull requests | Patches applied in hours, not weeks, without breaking changes |
| Versions that never get the patch | Current and long-term support lines patched together, including lines out of open source support | The versions you actually run keep receiving fixes |
| Verifying the build | Every artifact rebuilt from verified source in a clean room, with SLSA Build Level 3 provenance and an SBOM | Verification is done before you pull |
| Chasing the dependency tree | More than 5,000 verified libraries across the Spring dependency tree, built and tested as one set per Spring Boot line | Fixes reach transitive dependencies, with compatibility preserved |
| Covering everything else | Trusted Artifacts for Java, Python, Node.js, images, and Helm charts; Data Services for data engines | One standard across the stack, from one vendor |

## Value by role

* **Security and vulnerability management teams** get fixes before disclosure, scanners that recognize patched builds, and evidence (SBOMs, provenance, signatures) for every artifact, which shortens time to remediate and simplifies audits.
* **Developers** stop choosing between breaking changes and known vulnerabilities. Patches arrive as small, reviewable pull requests, and major upgrades happen on their schedule, with Application Advisor doing the mechanical work.
* **Platform teams** get a single catalog of verified libraries, base images, Helm charts, and data services to offer application teams, with deployment automation and 24x7 support.
* **Technical leaders** consolidate open source support under one standard and one vendor, and can show regulators and auditors what they run and how fast they fix it.

## Where TrueSource pays for itself

Beyond risk reduction, TrueSource has a direct financial case:

* **Consolidate support spend.** Oracle's own price list example puts Java SE Universal Subscription at **$2.27 million a year** for a company with 28,000 employees, at list price. Java runtime builds and support are included with Spring Enterprise, which leaves one Java budget line item.
* **Avoid do-it-yourself labor.** Better dependency data and upgrade decisions can recover about **1.5 months of team time per application, per year** (Sonatype, 9th Annual State of the Software Supply Chain). With verified builds and maintainer-authored patches, the research and retest work arrives done.
* **Reduce scan-and-fix costs.** Instead of paying to generate unverified, proprietary fixes, of which only 17 in 100 held up in testing, you consume more than 100,000 dependency builds that are already validated upstream. You pay for fixes once, upstream.
* **Recover runtime performance.** Netflix reported about **20 percent** less CPU and memory spent on garbage collection when moving roughly 3,000 Spring Boot services from JDK 8 to 17, with no code changes. Compatibility across the full Spring dependency tree, and Application Advisor, make that kind of upgrade safe to take.
* **Avoid hyperscaler DBaaS premiums.** Proprietary PostgreSQL DBaaS offerings can cost up to 74 percent more. Based on Broadcom research of public pricing, running 2,000 data services cores with TrueSource Data Services can save about **$870,000**, with the flexibility to run on-premises or on public cloud virtual machines with enterprise support.
