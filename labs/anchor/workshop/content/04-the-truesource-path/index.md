---
title: "The TrueSource Path: A CVE-only Patch"
---

Because Broadcom is the maintainer of Spring, Spring Enterprise patches **every supported release line at the same time**, including lines that have left open source support, like Spring Boot 3.5. The fixes are published as **CVE-only patches**: the security changes and nothing else, so you can deploy them in hours instead of weeks.

The Spring Enterprise repository declared in the POM holds those releases. In your own environment, you'd add your Spring Enterprise token to your Maven `settings.xml`. In this workshop, a mirror points the repository at the pre-staged copy in your session.

```execute
cat ~/.m2/settings.xml
```

#### Apply the patch

`advisor patch apply` moves every dependency of the application to the latest **patch** release on the line it already uses. It never changes a major or minor version. With the Spring Enterprise repository available, those patch releases include the commercial ones.

```execute
advisor patch apply
```

{{< note >}}
Advisor checks the repositories for every single dependency of the application, so this takes a minute or two. In a real setup, it runs on a schedule in your CI pipeline and opens a pull request for each affected repository.
{{< /note >}}

When it finishes, Advisor lists the upgraded dependencies with their old and new versions.

#### Review the change

Look at what changed.

```execute
git status --short && git --no-pager diff pom.xml
```

This time, **only `pom.xml` changed**. The parent moved from Spring Boot 3.5.16 to **3.5.17**, a Spring Enterprise release, and some managed dependencies were pinned to their latest patch versions. Your source code wasn't touched.

Check which Spring Framework version the application uses now.

```execute
./mvnw -q dependency:tree -Dincludes=org.springframework:spring-webmvc
```

It's on **Spring Framework 6.2.20**, the release the advisories list as *Enterprise Support Only*. You can confirm it doesn't exist on Maven Central:

```execute
curl -s -o /dev/null -w "Maven Central: HTTP %{http_code}\n" https://repo1.maven.org/maven2/org/springframework/spring-webmvc/6.2.20/spring-webmvc-6.2.20.pom
```

```execute
ls $SPRING_ENTERPRISE_REPO_DIR/org/springframework/spring-webmvc/
```

#### Rescan

Generate a new SBOM and scan it again.

```execute
./mvnw -q org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom -DoutputFormat=json -DoutputName=bom && trivy sbom --quiet --severity HIGH,CRITICAL target/bom.json
```

The Spring Framework and Tomcat findings from the first scan are gone. The scanner recognizes the patched builds, so your security dashboard shows them as fixed. Any findings that remain are in other libraries. Spring Enterprise covers the Spring dependency tree, and **TrueSource Trusted Artifacts** extends the same approach to Java, Python, and Node.js libraries beyond it.

#### Run it and ship it

Because the change stays on the same release line, the application runs exactly as before.

```terminal:execute
command: cd ~/spring-petclinic && ./mvnw -q spring-boot:run -Dcheckstyle.skip -Dspring-javaformat.skip
session: 2
```

```dashboard:open-url
url: {{< param  ingress_protocol >}}://petclinic-{{< param  session_name >}}.{{< param  ingress_domain >}}
```

```terminal:interrupt
session: 2
```

Commit and push the patch, as your pipeline would.

```execute
git commit -q -am "Apply Spring Enterprise CVE-only patch (Spring Boot 3.5.17)" && git push -q && git --no-pager log --oneline -2
```

Compare the two paths you've taken:

| | Open source path | TrueSource path |
|---|---|---|
| Change | Spring Boot 3.5 → 4.0, source and configuration rewritten | Patch versions in `pom.xml` only |
| Review and test effort | A full upgrade cycle | A patch release |
| Time to production | Days to months | Hours |
| Release line | Forced to move | Stays where you planned it |

You still plan the move to Spring Boot 4, on your own schedule, with Advisor. In practice, teams do this at scale: one wealth management firm used Application Advisor to scan and upgrade 3,300 repositories in 42 days, and created more than 1,100 pull requests three days *before* the CVEs were published.

Stop the application if it's still running before you move on.

```terminal:interrupt
session: 2
```
