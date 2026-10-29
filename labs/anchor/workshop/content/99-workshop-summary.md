---
title: Workshop Summary
---

In this workshop, you took one application through a realistic security incident and saw where TrueSource saves time.

- You saw that a "small" Spring Boot application runs on well over a hundred open source libraries, and you generated an **SBOM** to know exactly what you run.
- You found vulnerabilities in **Spring Framework 6.2.19** whose only open source fix requires a major upgrade, on a Spring Boot line that's out of open source support.
- You used **Spring Application Advisor** to see what that upgrade involves, the "break or breach" dilemma in practice.
- You applied a **CVE-only patch** from **Spring Enterprise** instead: a change to a single file that kept the application on its release line and closed the findings.
- You verified a scanner's own release with Sigstore, then verified the **signature, SLSA Build Level 3 provenance, and evidence bundle** of **Bitnami Secure Images**, part of **TrueSource Trusted Artifacts**.
- You applied the same checks to the **data tier**, the domain of **TrueSource Data Services**.

The speed didn't come from patching faster. It came from the quality of the artifacts you run, patches you can take without an upgrade, and fixes that come from the maintainers of the code.

#### Learn more

- [TrueSource by Broadcom](https://www.broadcom.com/products/software/truesource)
- [Spring Enterprise](https://enterprise.spring.io/)
- [Spring Application Advisor](https://enterprise.spring.io/spring-application-advisor), and the hands-on [Spring Application Advisor Introduction](https://spring.academy/guides/app-advisor-intro) guide on Spring Academy
- [Bitnami Secure Images: verifying signatures](https://techdocs.broadcom.com/us/en/vmware-tanzu/bitnami-secure-images/bitnami-secure-images/services/bsi-doc/using-verify-signatures.html)
- [Spring security advisories](https://spring.io/security)
