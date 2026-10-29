## Open source is everywhere, and so is its attack surface

Open source isn't a component of enterprise software; it *is* most of enterprise software:

* **97%** of enterprise applications use open source components.
* **75%+** of the code in a typical enterprise codebase is open source frameworks and libraries.
* **9 in 10** Fortune 500 companies run applications built with Spring.
* **95%+** of enterprises deploy at least one open source database.

Every one of those components is a potential way in. A vulnerability in any library your application resolves, including the ones you never chose directly, is a vulnerability in your application.

## AI has changed how fast vulnerabilities are found

Frontier AI models are very good at finding flaws in source code. That's good news for the people who maintain open source, and it has produced a surge in reported vulnerabilities, even in projects with strong security records.

Spring is a good example. Historically one of the safest frameworks, it saw monthly security advisory reports rise **more than 1,700 percent** from March to April 2026, and the number of identified security advisories for Spring was up **478 percent** year to date. Part of that increase comes from Broadcom's own scanning: its Spring engineering team has used more than **12 billion tokens** against frontier models to scan Spring and its dependency tree, and shipped the largest set of security patches in Spring's 23-year history.

## AI has also changed how fast vulnerabilities are exploited

The same models help attackers. In the legacy vulnerability lifecycle, there were weeks between disclosure and the first exploit attempt, enough time to develop, test, and deploy a patch. In the AI-driven lifecycle, that window shrinks to **hours**.

* CVEs are now regularly exploited within 24 hours of publication. One recent flaw, CVE-2026-33626 in LMDeploy, was exploited within 13 hours of disclosure.
* AI makes it much easier to find and *chain* combinations of low-severity vulnerabilities into a serious attack, so "low" no longer means "later."
* Unsupported software is the easiest target. Vulnerabilities in versions that no longer receive fixes simply stay open.

Meanwhile, the typical enterprise patch cycle still runs in weeks. That gap is the danger zone.

## Why not let AI write the patches?

The obvious response is to fight AI with AI and generate patches automatically. Independent research suggests that doesn't work yet. Off-by-1 Labs at 1Password tested **6,080** patches written by two frontier models for six recent high-impact CVEs. Out of every 100 patches:

* **54** failed to fix the vulnerability, introduced a new flaw, or both
* **20** fixed it, but changed what the application does
* **9** fixed it, but were fragile
* **17** fixed it robustly

A bad patch isn't faster; it can create a second incident. Building a safe patch takes more than a code change:

* **It takes knowing what the code is meant to do.** That knowledge lives with the engineers who maintain it.
* **Every private fix is a fork you must maintain.** Fixes that never land upstream have to be reapplied with every release, accumulating drift and breaking upgrade paths.
* **You can only verify a fix if you have the advisory.** The full picture of a flaw is shared privately with the maintainers. Everyone else works backward from the public CVE.

AI is excellent at *finding* issues, and Broadcom uses it heavily for exactly that. But the fix of record has to come from accountable engineers.

## It's not just the code, it's the whole supply chain

Attackers increasingly target how software is built and delivered, not just the source code. According to Black Duck's 2026 Open Source Security and Risk Analysis report:

* **98%** of codebases contain open source
* **65%** of organizations experienced a software supply chain attack in the past year
* **34%** of malicious packages in open source were hijacked packages

On March 19, 2026, attackers used a token leaked from a misconfigured GitHub workflow to force-push 76 of the 77 version tags of the `aquasecurity/trivy-action` GitHub Action to malicious commits, and published a backdoored binary of Trivy, itself a security scanner. Every pipeline that referenced the action by tag ran the attacker's code on its next run. Having the source code doesn't mean you know what's in the build.

## The data tier is exposed too

Open source data engines, such as PostgreSQL, MySQL, Valkey, and RabbitMQ, are seeing the same rise in reported vulnerabilities, with year-over-year CVE growth for these engines projected in the hundreds of percent from 2025 to 2026. And a data engine is not a single artifact: PostgreSQL alone has dozens of widely used extension projects. Five supported major versions across 75 extension projects give about **375 possible configurations** to build, test, and keep patched on any given day. A flawed patch can put the data itself at risk, so remediation takes operational judgment.

## Patch timelines are now audited

Regulators have noticed. Frameworks such as **PCI DSS 4.0**, **DORA**, and the **EU Cyber Resilience Act** set remediation time requirements for critical and high-severity vulnerabilities, and expect you to know, and prove, what you're running. Many organizations have responded with dedicated vulnerability management teams with executive ownership, measured on time to remediate.

## Six places enterprises lose time

If speed can't come from AI-written patches, it has to come from somewhere else: from the quality of what you run, and from getting the fix early. Enterprises typically lose time in six places:

1. **Waiting for the advisory.** If your first notice is the public CVE, you start at the same moment as the attackers.
1. **Retesting the upgrade.** In open source, the fix usually lands only on the newest release line. Most of a patch cycle isn't applying the fix; it's retesting the upgrade the fix came in. Teams are stuck choosing between **break or breach**.
1. **Running versions that never get the patch.** More than 60 percent of Spring Boot downloads are of versions outside the open source support window. No amount of speed helps a version that receives no fix.
1. **Verifying the build.** If you can't prove where an artifact came from and what's in it, your pipeline has to stop and check.
1. **Chasing the dependency tree.** A Spring application resolves thousands of libraries. A fix to Spring doesn't help if a transitive dependency beneath it is still exposed.
1. **Covering everything else.** Your teams also depend on Python and Node.js libraries, container images, and data engines, and every one of them can be exploited.

Next, you'll see how TrueSource gives that time back.
