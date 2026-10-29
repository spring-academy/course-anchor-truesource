---
title: Meet the App
---

Let's start by cloning the application from the local Git server.

```execute
git clone {{< param git_protocol >}}://{{< param git_host >}}/spring-petclinic && cd spring-petclinic
```

Open the Maven POM to see which Spring Boot version the application uses.

```editor:open-file
file: ~/spring-petclinic/pom.xml
description: Open the Maven POM
line: 1
```

```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "<version>3.5.16</version>"
```

The application inherits from `spring-boot-starter-parent` **3.5.16**, which was released on June 25, 2026 and is the last open source release of Spring Boot 3.5. A few days later, on June 30, the 3.5 line left open source support. This is common: the Spring community moves quickly, and more than 60 percent of Spring Boot downloads are of versions outside the open source support window.

Scroll down to the `<repositories>` section.

```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "<id>spring-enterprise</id>"
```

Like many enterprise builds, this one already declares the **Spring Enterprise repository**, which is where Spring Enterprise customers get commercial releases of Spring. Keep that in mind. It will matter later.

#### Run the application

Start the application in the second terminal.

```terminal:execute
command: cd ~/spring-petclinic && ./mvnw -q spring-boot:run -Dcheckstyle.skip -Dspring-javaformat.skip
session: 2
```

Once the log shows `Started PetClinicApplication`, open it in the browser.

```dashboard:open-url
url: {{< param  ingress_protocol >}}://petclinic-{{< param  session_name >}}.{{< param  ingress_domain >}}
```

Click around: find an owner, add a pet, schedule a visit. This is a small application, but its stack is the same as many business-critical services: Spring MVC, Spring Data JPA, Thymeleaf, an embedded Apache Tomcat, and a database.

Stop the application.

```terminal:interrupt
session: 2
```

#### How much open source is in a "small" application?

The application has a handful of source files, but how many libraries does it really run on? Ask Maven for the full dependency tree.

```execute
./mvnw -q dependency:tree -DoutputFile=target/tree.txt && grep -c ":" target/tree.txt
```

That number counts every library, direct and transitive, that ends up in the application. Have a look at where Spring Framework and Tomcat appear in the tree.

```execute
grep -E "spring-webmvc|tomcat-embed-core" target/tree.txt
```

You didn't choose most of these libraries, and you probably don't track them, but a vulnerability in any one of them is a vulnerability in your application. A Spring Boot 4.0 application resolves about **1,768** dependencies across the Spring ecosystem, and Spring Enterprise verifies more than **5,000** Java libraries across the full Spring dependency tree, built and tested as one set for each supported Spring Boot line.

Next, let's find out what your security team sees.
