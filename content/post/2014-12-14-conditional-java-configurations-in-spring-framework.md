---
title: Conditional Java Configurations in Spring Framework
date: 2014-12-14T11:22:29
tags:
  - java
  - spring
categories:
  - programming
---

Spring Framework offers very flexible means for binding application components. 
Externalizable properties, composite configuration, nested application contexts and profiles.

<!-- 
profile
:    A profile is a named logical grouping that may be activated programmatically via [`ConfigurableEnvironment.setActiveProfiles(java.lang.String...)`](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/core/env/ConfigurableEnvironment.html#setActiveProfiles-java.lang.String...-) or declaratively through setting the `spring.profiles.active` property, usually through JVM system properties, as an environment variable, or for web applications as a Servlet context parameter in `web.xml` file.
 -->

Sometimes, it is necessary to control whether particular beans or [`@Configuration`][configuration] will be loaded or not. Spring Framework v.4.1.x does not provide that feature out of the box. But, hopefully, Spring allows conditional bean initialization (see [`@Profile`][profile] implementation and [`@Configurable`][configurable]).
So, I created the annotation [`@Enabled`][enabled] which allows me to control bean instantiation via properties.

`@Enabled` indicates that a component is eligible for registration when evaluated expression is true. This annotation should be used in conjunction with Configuration and Bean annotations.

<!--more-->
## Usage Example

Given property file `application.properties` with property values `my.service.enabled` and `my.config.enabled`. Following code will only instantiate and configure `MyService` and `MyConfig` if values of appropriate properties are evaluated as true.

```java
@Configuration
@PropertySource}("classpath:/application.properties")
@Import(MyConfig.class)
class AppConfig {

    @Bean
    @Enabled("${my.service.enabled}")
    MyService myService {
        return new MyService()
    }
}

@Configuration
@Enabled("${my.config.enabled}")
class MyConfig {
    ...
}
```

Link: [project on GitHub][github]

Update: [spring-boot-conditionals]

[github]: https://github.com/kpavlov/commons-spring "Project on GitHub"
[enabled]: https://github.com/kpavlov/commons-spring/blob/master/src/main/java/com/github/kpavlov/commons/spring/annotations/Enabled.java
[configuration]: http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html
[configurable]: http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Configurable.html
[profile]: http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/Profile.html
[spring-boot-conditionals]: http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-developing-auto-configuration.html
   
