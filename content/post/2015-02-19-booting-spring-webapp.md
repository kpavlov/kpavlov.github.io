---
title: Booting Spring Webapp
tags:
  - java
  - web
  - spring
  - tomcat
categories:
  - programming
date: 2015-02-19T23:39:35
---

Spring Boot is an excellent tool to bootstrap java application.
Most of the references mention how to create a standalone java application, optionally with embedded web server (tomcat or jetty). But [Spring Boot][spring-boot] supports also creating web applications intended to run within servlet container.
<!--more-->
Here is example of maven _pom.xml_ file for Spring-Boot-enabled web application:

```xml
    ...
    <packaging>war</packaging>
    <properties>
        <!-- If web.xml is not used -->
        <failOnMissingWebXml>false</failOnMissingWebXml>
        <!-- Set Spring-Boot Version -->
        <spring-boot.version>1.2.1.RELEASE</spring-boot.version>
    </properties>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <!-- Import dependency management from Spring Boot -->
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-starter-tomcat</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <!-- Provided in Tomcat -->
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <!-- Provided in Tomcat -->
            <groupId>javax.el</groupId>
            <artifactId>javax.el-api</artifactId>
            <version>2.2.4</version>
            <scope>provided</scope>
        </dependency>
        <!-- Test dependencies -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>javax.el</artifactId>
            <version>2.2.4</version>
            <scope>test</scope>
        </dependency>        
    </dependencies>
    ...
```

You'll need a `SpringBootServletInitializer` to configure web application:

```java
@Configuration
@ComponentScan
@EnableAutoConfiguration
public class Application extends SpringBootServletInitializer {

    private static Class<Application> applicationClass = Application.class;

    public static void main(String... args) {
        SpringApplication.run(applicationClass, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(applicationClass);
    }
}
```
<!--more-->

## Tuning Configuration

If you want to have a configuration file hierarchy, e.g.:

1. Default properties (from classpath)
2. Environment-specific server properties (from `$CATALINA_BASE/conf`)
3. Environment-specific application properties (from `$CATALINA_BASE/conf`)

You may specify `spring.config.location` env-entries in `web.xml`. Spring Boot will read properties from JNDI.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
         version="3.0">
    <display-na>
    <env-entry>
        <env-entry-name>spring.config.location</env-entry-name>
        <env-entry-type>java.lang.String</env-entry-type>
        <env-entry-value>
            classpath:/default.properties,
            file:${catalina.base}/conf/common.properties,
            file:${catalina.base}/conf/my-application.properties
        </env-entry-value>
    </env-entry>
</web-app>
```

## References

* [Deploying Spring Boot Applications: What about the Java EE Application Server?][spring-boot-jee-server]
* [Spring Boot application properties][spring-boot-app-properties]

[spring-boot]: http://projects.spring.io/spring-boot/ "Spring Boot Project"
[spring-boot-jee-server]: http://spring.io/blog/2014/03/07/deploying-spring-boot-applications#what-about-the-java-ee-application-server "Deploying Spring Boot Applications: What about the Java EE Application Server?"
[spring-boot-app-properties]: http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html "Spring Boot: Common application properties"
