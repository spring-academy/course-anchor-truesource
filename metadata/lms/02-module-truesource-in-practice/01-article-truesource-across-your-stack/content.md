## TrueSource covers every layer of a real application

Consider a typical claims processing application. Only a small part of it is your code; the rest is open source:

| Layer | Your code | Open source it runs on | TrueSource offering |
|---|---|---|---|
| Front end | Claims portal (React) | Node.js runtime, npm packages | Trusted Artifacts |
| Application services | Claims service, policy service (Spring Boot) | Spring, Apache Tomcat, the Java dependency tree | Spring Enterprise |
| Data | | PostgreSQL and extensions, Valkey for caching, RabbitMQ for messaging and streaming | Data Services |
| Backing services | | NGINX ingress, Keycloak, Helm charts, Kubernetes operators | Trusted Artifacts |

What TrueSource supplies across those layers:

* **Libraries and dependencies:** Java, Python, and Node.js libraries, with their full dependency trees
* **Runtimes and web servers:** Apache Tomcat and language runtime images
* **Data engines and extensions:** PostgreSQL, MySQL, Valkey, and RabbitMQ, with curated extensions, Helm charts, and operators
* **Other images:** hundreds of hardened container images and Helm charts

Every component in the stack is a potential attack surface. TrueSource rebuilds open source components from source, so you patch your code, and Broadcom patches the rest.

## Scenarios

Here are common situations, and how TrueSource helps in each.

### 1. A Spring vulnerability is reported privately

**Problem:** A researcher reports a flaw in Spring Framework. Once the CVE is public, attackers can exploit it within hours.
**Offering:** Spring Enterprise.
**Outcome:** Broadcom develops and validates the fix before disclosure, patches every supported release line at the same time, and offers an early release to customers who must remediate before the CVE is public. Application Advisor turns the patch into pull requests across your repositories.

### 2. Your applications are pinned to a release line that's out of open source support

**Problem:** Your services run on Spring Boot 3.5, which left open source support on June 30, 2026. A new Spring Framework advisory is fixed in open source only on the 7.0 line, which requires a move to Spring Boot 4.
**Offering:** Spring Enterprise.
**Outcome:** A CVE-only patch on the 3.5 line, such as Spring Boot 3.5.17 with Spring Framework 6.2.20, fixes the vulnerability with a change to the build file alone. You plan the Spring Boot 4 upgrade on your own schedule. You'll do exactly this in the lab.

### 3. The vulnerability is in a transitive dependency

**Problem:** A critical CVE lands in Apache Tomcat, embedded in every Spring Boot web application you run.
**Offering:** Spring Enterprise.
**Outcome:** Coverage extends to Spring's managed dependencies, including Tomcat, where Broadcom engineers contribute 75 percent of the fixes. The fixed version is built and tested together with the rest of the Spring Boot line, so you don't have to override versions and hope they work together.

### 4. Auditors want proof of what you run

**Problem:** Regulations such as the EU Cyber Resilience Act, DORA, and PCI DSS 4.0 expect you to know what's in your software, prove it, and remediate on a deadline.
**Offering:** All three, with Trusted Artifacts for images and libraries.
**Outcome:** Every artifact comes with an SBOM, cryptographic signatures, and SLSA Build Level 3 provenance. For Bitnami Secure Images, the evidence also includes VEX statements, scan results, antivirus scans, STIG reports, and test results, generated for every build instead of gathered by hand.

### 5. Your teams build in Python and Node.js too

**Problem:** Data science teams pull packages from PyPI and front-end teams pull from npm, two ecosystems with frequent package hijacking and typo-squatting.
**Offering:** Trusted Artifacts.
**Outcome:** Curated Python and Node.js libraries, rebuilt from verified source in a clean room and served from a private repository, so every package your teams pull is a verified build.

### 6. A data engine needs a security patch

**Problem:** A CVE lands in PostgreSQL, or in one of the extensions your teams use. Patching a database takes operational judgment, because a flawed patch can put the data itself at risk.
**Offering:** Data Services.
**Outcome:** A curated distribution of the engine and its extensions, with patches that drop in without a regression cycle, plus operators, Helm charts, and Data Services Manager to roll them out, and 24x7 support from engineers who build products on these engines.

### 7. You find a vulnerability yourself

**Problem:** Your red team finds a flaw in an open source library. Reporting it publicly could reveal an attack vector, and more about your infrastructure than you're comfortable sharing.
**Offering:** Any TrueSource offering.
**Outcome:** Licensed customers can bring not-yet-public vulnerabilities to Broadcom's private clearinghouse. Broadcom works on the fix with you, gives you early access to it, and handles responsible disclosure with the upstream project.

### 8. You operate critical infrastructure

**Problem:** You must remediate before anyone else, and you need to know how to mitigate in the meantime.
**Offering:** Any TrueSource offering.
**Outcome:** A dedicated program for critical infrastructure organizations provides access to patch insights and mitigation advice.

## Three immediate steps to a structural defense

Broadcom recommends three steps to get ahead of the threat:

1. **Cover Spring:** every Spring version you run, with Spring Enterprise.
1. **Cover language libraries,** plus containers and Helm charts, with TrueSource Trusted Artifacts.
1. **Plan upgrades:** check your application portfolio with a portfolio assessment, and plan upgrades with Application Advisor.
