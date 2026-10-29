---
title: "The Open Source Path: Break or Breach"
---

Without a commercial patch, the only way to get the open source fix for Spring Framework is to move to the release line that contains it, Spring Framework 7.0. That means upgrading the application from Spring Boot 3.5 to **Spring Boot 4.0**.

Teams in this position face what's often called **break or breach**: take a major upgrade under time pressure and risk breaking the application, or keep running with a known vulnerability and risk a breach.

#### Plan the upgrade

[Spring Application Advisor](https://enterprise.spring.io/spring-application-advisor) is part of Spring Enterprise. It upgrades Spring applications deterministically, using tested recipes built on OpenRewrite, and it can open pull requests from your CI pipeline. Let's ask it what the upgrade involves.

```execute
advisor --version
```

First, Advisor builds a configuration of the application: its build tool, Java version, and full dependency tree.

```execute
advisor build-config get
```

Then it computes an upgrade plan.

```execute
advisor upgrade-plan get
```

Read through the plan. Its first step, to Spring Boot 4.0, moves Spring Framework to 7.0, Spring Data to 4.0, Hibernate to 7.1, JUnit to 6.0, Testcontainers to 2.0, and more, and applies recipes that rewrite source code and configuration to match. A second step would continue to Spring Boot 4.1.

#### Apply it to see the size of the change

Let's apply the first step of the plan to see how big this "security fix" really is. This takes about three minutes.

```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

Look at the size of the change.

```execute
git --no-pager diff --stat
```

You can browse the changes in the *Source Control* view of the editor.

```editor:execute-command
command: workbench.view.scm
description: Open the "Source Control" view in the editor
```

Advisor did the mechanical work for you, which is exactly what it's for, and Spring Boot 4 is where this application should eventually go. But a major upgrade is still a release: every changed library and every rewritten file has to be reviewed, tested, and rolled out. For one application that might take days. For a portfolio of hundreds of applications, it takes months, while the CVE has been public since the day the advisory was published.

That's the problem in a nutshell: **the fix is in the upgrade, and the upgrade takes far longer than the exploit window.** Today, many vulnerabilities are exploited within 24 hours of disclosure.

#### Undo the upgrade

You'll take a different path, so discard the upgrade.

```execute
git reset -q --hard HEAD && git clean -q -fd && git --no-pager log --oneline -1
```

```execute
grep -A2 "spring-boot-starter-parent" pom.xml
```

The application is back on Spring Boot 3.5.16.
