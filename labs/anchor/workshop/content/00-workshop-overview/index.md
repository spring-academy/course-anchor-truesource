---
title: Workshop Overview
---

It's Monday morning and you're on the platform team. Over the weekend, Spring published a batch of Spring Framework security advisories, and your vulnerability scanner has lit up. One of the affected services is the team's **Spring PetClinic** application, which runs on **Spring Boot 3.5**.

There's a catch. Spring Boot 3.5 left open source support on June 30, 2026. The fixes for these advisories on the 6.2 line of Spring Framework, which Spring Boot 3.5 uses, are **Spring Enterprise only**. The only open source fix is on Spring Framework 7.0, which means moving the whole application to Spring Boot 4.

This is the situation TrueSource by Broadcom was built for. In this workshop, you'll work through it hands-on:

1. **Meet the app.** Clone and run Spring PetClinic on Spring Boot 3.5.16, the last open source 3.5 release, and see how many libraries it really runs on.
1. **Find the exposure.** Generate a Software Bill of Materials (SBOM) for the application and scan it, the way your security team does.
1. **The open source path.** Use *Spring Application Advisor* to see what the open source fix costs: a major upgrade.
1. **The TrueSource path.** Apply a **CVE-only patch** from Spring Enterprise instead, and watch the findings close with a change to a single file.
1. **Trusted Artifacts.** Verify the signature, SLSA provenance, and evidence that ship with a *Bitnami Secure Image*, and compare its scan results with a community image.
1. **The data tier.** Apply the same checks to the data engines your application depends on.

#### The workshop environment

Everything runs in your browser. On the right you have:

- Two **terminals**, stacked. The top one (session 1) is for the commands you run. The bottom one (session 2) is for running the application.
- An **editor** tab with Visual Studio Code, for reviewing files and changes.
- A local **Git server**, so you can commit and push changes like you would in your own pipeline.

Most commands are clickable. When you see a box like the one below, click it to run the command in the terminal.

```execute
echo "Ready to go! Lab version: $LAB_VERSION"
```

{{< note >}}
To keep the workshop self-contained, the Spring Enterprise releases you'll use are pre-staged in your session instead of being downloaded from `packages.broadcom.com` with a Spring Enterprise token. Everything else, including Maven Central, the vulnerability database, and the Bitnami Secure Images, comes from the same public sources you'd use yourself.
{{< /note >}}
