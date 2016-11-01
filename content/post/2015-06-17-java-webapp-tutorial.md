---
layout: post
title: "Java Application Development Tutorial"
date: 2015-06-17T09:55:16
updated: 2016-10-27T18:13:32
featured: true
categories:
  - programming
tags:
  - java
  - architecture
  - web
---

I've been meaning to write a small tutorial for building web applications. Now it's time!
Let's define the steps and choose some solutions for developing back-end java web application.

I will give my design recommendations and list a technologies I would use. You may have your own opinion and you may share it in comment. Over time, this post may change since my favourites are also changing over time.<!--more-->


## Technologies Stack

### Server-Side Stack

1. Use latest stable JDK. Now it is Java 8.

2. Use lightweight web container, e.g. Jetty or Tomcat.

3. Use Spring stack instead of J2EE. It is more customizable and extensible. [Spring Boot][spring-boot] is a default choice.

4. Use embedded web server if possible. [Spring Boot Maven Plugin][spring-boot-maven-plugin] allows you easily repackage all your jars into single jar or war file.

5. Package your application as self-executing JARs instead of WARs and run them with `./app.jar`. Thus you will never depend on application server infrastructure managed by IT team. Manage your infrastructure yourself!

6. Use Spring Boot - it offers convention over configuration and many predefined `@Configuration`s.

6. Prefer Java-based Spring Configurations over XML-based. Java offers more restrictive type checking and visibility control.

7. Use Spring Transaction Management (spring-tx) with `@Transactional`. Don't set `autoCommit="true"`. It is more flexible.

8. Prefer [Jackson][jackson] with [Jackson XML][jackson-xml] + [Woodstox][woodstox] over JAXB, it's faster and more convenient. jackson-dataformat-xml offers support for JAXB annotations but you are not forced to use JAXB for marshalling.

9. Use mocks (Mockito) and spring-test for unit testing. Prefer singletons over statics and you'll not need a PowerMockito.

10. Use maven. I don't see any significant advantage of using Gradle in terms of performance. Project should be simple in structure and fast to build, so maven is still performs well.

### Front-End Stack

1. Use **professional** front-end frameworks and tools like React, AngularJS, SASS, Npm and Gulp. You're developing a high quality product and you should use proven solutions for front-end. Professional front-end developers do use this tools so you should not [re-invent the wheel][DRY].
[WebJars][webjars] is also a good solution if your application is simple enough.

2. Design your JS application to consume REST API

3. Design your server to be expose REST API.

## Design Order

Start from presentation layer and go down on the controllers and services layers.

Avoid starting with database schema design unless you know your business domain in depth.
Your interface (web or api) will dictate required data structure, so persistence layer interfaces will evolve in the future. You may minimize changes by introducing API level in the database, i.e. use views and stored procedures to fix the contract between DBMS and application.

**It's IMPORTANT: Delay making of important architectural solutions as much as possible!**
Making decision earlier may catch you in a trap of technologies and tools not suited well for solving your problem. But that knowledge came to yo too late. Typical example: you may have chosen RDBMS but now, when a project is nearly completed, NoSql storage seems to be better fit for your problem.

## Building Front-End

1. Start with UI without real data. Then create a test data (JSON files) and use simple nodejs http server to serve it together with other assets. When your data requirements are defined, start implementing service API. This approach saves a lot of time: You don't have to change both server and client when design has eventually changed. 

2. Create separate controllers for creating and amending your entities. Data models and validation rules are often different. Most likely you will have significantly different models. Also, edit controllers will be simpler if you'll have less mutable fields in the model.

## Building Server-Side

### Presentation Layer

#### Web Views (Templates)

This sub-layer includes web templates. Responsible for rendering of View Models.

There are a number of java template engines. Most notable of them are [Thymeleaf][thymeleaf] and [Freemarker][freemarker].
Thymeleaf offers designing the templates as pure html and then make them work as a template when deployed to web server. Use it if you want your designers to own the templates.
Freemarker is about three times faster than Thymeleaf but it may not be possible to open the template in a browser.

You may like to see the [presentation](http://www.slideshare.net/jreijn/comparing-templateenginesjvm) by Jeroen Reijn on JVM template engines with performance comparison.

I don't recommend using the JSPs because they don't enforce clear logic and view separation. Low-skilled developers tend to write a presentation or even a business logic in a JSP which will inevitably lead into trouble. De-facto, JSP is deprecated technology.

There are a doubts about unit testing this layer. It often changes and usually is tested manually (visually) by (system) integration tests.

#### Presentation Logic

This sub-layer includes web Controllers and View Helpers. Responsible for data syntax validation, preparing view model. Can be easily Unit-Tested.

Typical technology stack for presentation layer contains:

* [Spring Web MVC][spring-web-mvc]
* [Spring Security Web][spring-security]
* [Jackson][jackson]

Please consider following ideas when designing a components for this layer:

1. Use separate model for presentation layer.
2. Use the front-end test data files to test data conversion in server-side controller level. Your tests should fail when you change JSON format of your objects.
3. Do only validation and presentation-related business login in this layer. You'll have a Business Logic (Service) Layer for business logic.
3. Don't perform security (access control) checks in this layer. Leave it to Service Layer.
4. Don't manage the transactions in this layer. Leave it to Service Layer.
5. Use javax.validation API and hibernate-validator to annotate DTO beans.
6. Don't include any logic into DTO. It's just a POJOs with annotations.

Someone may argue: why not to manage transactions in controllers (presentation layer)? Now imagine you'll need to call the same operation from web UI, rest API and Message Driven Bean. You'll have to add transaction management to each controller and MDB and use Spring `TransactionTemplate` instead. Thus you'll end up with copy-pasting business logic to multiple classes and which is not acceptable from the application maintenance point of view. Same is true for security/access control. It should be handled on service layer.  

### Business Logic (Service) Layer

1. Perform access-control validation in this layer. Same services may be invoked from different controllers (e.g. html and REST ones) so you'll use the same logic.
2. Use `@Transactional` to annotate service classes and methods. Transactions are aged here. If you need a complex transaction management then use a `TransactionTemplate`.
3. Don't access `DataSource` or `JdbcTemplate` in this layer. Use DAOs instead.
4. When you call a `@Transactional` method from non-transactional one in the same spring bean use `self`-reference:

    ```java
    @Service
    public MyServiceImpl implements MyService {
    
        @Autowired
        private MyDao dao;
    
        @Autowired
        private MyServiceImpl self;
    
        @Override
        public void nonTxMethod() {
            self.txMethod(); // "self" is a proxy with transactional aspect support
        }
    
        @Override
        @Transactional
        public void txMethod() {
             dao.load(...);
             ...
        }
    }
    ```

### Data Access Layer

Access data storage such as relational and not relational databases. Usually supports transactions.

1. Don't manage transactions on this layers. Transactions are managed on Service layer.
2. Write integration tests that hit database on this layer. You're usually don't need a lot of unit tests here (hello, "Test Pyramid").
3. `AbstractTransactionalJUnit4SpringContextTests` is your friend. Extend your integration tests from this class and you'll have a transaction rollback for free.
4. Since integration tests may take time, make them run on `integration test` maven phase and exclude them from fast unit tests.
5. Prepare a test data before executing a test. It will be rolled-back automatically. If you need DB transaction to commit, put `@Rollback(false)` annotation.

### Integration Layer

Contains connectors to external systems. Usually non-transactional.

You may write some unit tests here.

### Messaging Layer

In modern event-driven architecture message processing is important for integration point of view. Messaging layer typically includes JavaEE Message Driven Beans or various event listeners. This layer is actually a presentation layer but it operates with message payloads as input/output model objects in contrast of View Models and templates used in web presentation layer. For web presentation layer the payload is html page content, whereas for messaging layer the payload is xml, json, protobuf or any other message format.


[webjars]: //www.webjars.org
[woodstox]: http://wiki.fasterxml.com/WoodstoxHome
[jackson]: http://wiki.fasterxml.com/JacksonHome
[jackson-xml]: https://github.com/FasterXML/jackson-dataformat-xml  "Extension for Jackson JSON processor that adds support for serializing POJOs as XML"
[spring]: http://projects.spring.io/spring-framework/
[spring-boot]: http://projects.spring.io/spring-boot/
[spring-boot-maven-plugin]: https://spring.io/guides/gs/spring-boot/
[spring-web-mvc]: http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html
[spring-webflow]: http://projects.spring.io/spring-webflow/ "Spring Web Flow allows implementing the step-by step flows or wizards in web application."
[spring-security]: http://projects.spring.io/spring-security/ "Spring Security is a powerful and highly customizable authentication and access-control framework."
[DRY]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself "Don't repeat yourself"
[thymeleaf]: http://www.thymeleaf.org/
[freemarker]: http://freemarker.org/
