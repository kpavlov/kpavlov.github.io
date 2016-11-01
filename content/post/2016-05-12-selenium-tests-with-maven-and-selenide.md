---
layout: post
title: Selenium Tests with Maven and Selenide
date: 2016-05-12T16:26:25
tags:
  - quality assurance
categories:
  - programming
---

[Selenide](http://selenide.org) is nice wrapper around selenium web driver allowing to simplify writting UI tests with Selenium.

Some of the cook features are:

1. jquery-like selector syntax, e.g. `$("div.myclass").is(Condition.visible)`
2. Automatic screenshots on assertion failure
3. Easy starting Selenium WebDriver
4. And [others](http://selenide.org/quick-start.html)

So, let's write some tests on selenide and make it run from maven in a normal browser or in headless mode.<!--more-->

First, let's create [_pom.xml_](https://raw.githubusercontent.com/kpavlov/selenide-maven-sample/master/pom.xml):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.github.kpavlov</groupId>
    <artifactId>selenide-sample</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <java.version>1.8</java.version>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>
        <selenium.hub.url>http://local.example.com:4444/wd/hub</selenium.hub.url>
        <holdBrowserOpen>false</holdBrowserOpen>
        <surefire.argLine>-Dbrowser=${browser} -Dselenide.holdBrowserOpen=${holdBrowserOpen}</surefire.argLine>
    </properties>

    <prerequisites>
        <maven>3.3</maven>
    </prerequisites>

    <profiles>
        <profile>
            <id>firefox</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <browser>firefox</browser>
            </properties>
        </profile>
        <profile>
            <id>chrome</id>
            <properties>
                <browser>chrome</browser>
            </properties>
        </profile>
        <profile>
            <id>phantomjs</id>
            <properties>
                <browser>phantomjs</browser>
            </properties>
        </profile>
        <profile>
            <id>ie</id>
            <properties>
                <browser>ie</browser>
            </properties>
        </profile>
        <profile>
            <id>htmlunit</id>
            <properties>
                <browser>htmlunit</browser>
            </properties>
            <dependencies>
                <dependency>
                    <groupId>org.seleniumhq.selenium</groupId>
                    <artifactId>selenium-htmlunit-driver</artifactId>
                    <version>LATEST</version>
                    <scope>test</scope>
                </dependency>
            </dependencies>
        </profile>
        <profile>
            <id>ci-server</id>
            <properties>
                <surefire.argLine>-Dremote=${selenium.hub.url} -Dbrowser=${browser}</surefire.argLine>
            </properties>
        </profile>
        <profile>
            <id>local</id>
            <properties>
                <holdBrowserOpen>true</holdBrowserOpen>
            </properties>
        </profile>
    </profiles>

    <build>
        <defaultGoal>clean test</defaultGoal>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>2.19.1</version>
                <configuration>
                    <argLine>${surefire.argLine}</argLine>
                </configuration>
            </plugin>
        </plugins>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-surefire-plugin</artifactId>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>

    <dependencies>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.13</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.codeborne</groupId>
            <artifactId>selenide</artifactId>
            <version>3.5.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

Notice the properties:

1. **surefire.argLine** -- defines a command line parameters for running tests.
2. **browser** -- specifies a browser to use.
3. **selenium.hub.url** -- URL where selenium hub is running, for tests with remote web driver, e.g. on CI server.
4. **holdBrowserOpen** -- should the browser be closed after tests.

Also there are a fistful of profiles to use as a shortcuts, e.g.

* `mvn clean test -Pphantomjs` -- run tests locally with phantomjs headless browser. Requires phantomjs to be installed
* `mvn clean test -Pfirefox,local` -- run tests locally with Firefox and leaves a browser open after tests
* `mvn clean test -Pci-server,chrome` -- run tests on selenium hub with Chrome

You may find working example in my [GitHub repository](https://github.com/kpavlov/selenide-maven-sample).
