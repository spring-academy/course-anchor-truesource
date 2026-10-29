---
title: Find the Exposure
---

To know whether a vulnerability affects you, you first need to know exactly what you run. That inventory is a **Software Bill of Materials (SBOM)**: a machine-readable list of every component in a piece of software, with its version and origin. Regulations such as the EU Cyber Resilience Act, and many procurement rules, now expect you to produce one.

#### Generate an SBOM

Use the CycloneDX Maven plugin to generate an SBOM for the application.

```execute
./mvnw -q org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom -DoutputFormat=json -DoutputName=bom
```

Have a quick look at what's inside.

```execute
jq '{format: .bomFormat, spec: .specVersion, components: (.components | length)}' target/bom.json
```

```execute
jq -r '.components[] | select(.name=="spring-webmvc" or .name=="tomcat-embed-core") | "\(.name) \(.version)  \(.purl)"' target/bom.json
```

Each component has a *package URL* (`purl`) that scanners use to match it against vulnerability databases.

#### Scan the SBOM

Scan the SBOM with [Trivy](https://trivy.dev), an open source vulnerability scanner, and keep only the high and critical findings.

```execute
trivy sbom --quiet --severity HIGH,CRITICAL target/bom.json
```

Look at the results for `spring-webmvc` and `tomcat-embed-core`, and in particular the **Fixed Version** column.

- **Apache Tomcat 10.1.55** has findings that are fixed in an open source Tomcat release. You could override the Tomcat version yourself, but you'd then be running a combination of Spring Boot and Tomcat that nobody tested together.
- **Spring Framework 6.2.19** has findings such as **CVE-2026-47884** and **CVE-2026-47890** whose only open source fix is **7.0.9**. There is no open source 6.2 release that fixes them.

You'll probably also see findings in libraries such as Jackson or the PostgreSQL JDBC driver. Those have fixes in open source patch releases on the lines the application already uses, so they're the easy part.

To see the detail for one of them, filter the scan output.

```execute
trivy sbom --quiet --format json target/bom.json | jq -r '.Results[].Vulnerabilities[]? | select(.PkgName | test("spring-webmvc")) | "\(.VulnerabilityID)  installed=\(.InstalledVersion)  fixed=\(.FixedVersion // "none")  \(.Title)"' | sort -u
```

The official advisories on [spring.io/security](https://spring.io/security) list a 6.2 fix as well, **6.2.20**, marked **Enterprise Support Only**.

{{< note >}}
The severity in your scanner comes from public vulnerability databases such as the GitHub Advisory Database and the NVD. It can differ from the severity the maintainers assign in their advisory, because only the maintainers have the full report. That's one more reason a fix validated against the original report matters.
{{< /note >}}

So you have a choice to make. In the next step, you'll see what the open source path costs.
