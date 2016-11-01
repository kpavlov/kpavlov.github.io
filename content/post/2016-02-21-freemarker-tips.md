---
layout: post
title: Spring+Freemarker Tips
date: 2016-02-21T18:15:00
updated: 2016-05-10T19:32:00
categories:
  - programming
tags:
  - spring
  - web
  - freemarker
---

I hope you will find following tips useful when developing [Spring Boot] application with [Freemarker].
<!--more-->

1. Enable auto-reload of freemarker templates

    - Create spring boot development profile (e.g. "local")

    - Disable template caching and enable file access rather than classpath resource access to templates (_application-local.properties_).

        ```properties
        spring.freemarker.cache=false
        spring.freemarker.prefer-file-system-access=true
        spring.freemarker.template-loader-path=file:${user.home}/projects/example/src/main/resources/templates
        ```

2. Add `src/main/resources/freemarker_implicit.ftl` to declare your oftenly used types (_freemarker_implicit.ftl_):

    ```freemarker
    [#ftl]
    [#-- @implicitly included --]
    [#-- @ftlvariable name="items" type="java.util.List<com.example.domain.Item>" --]
    ```

3. Set setting `url_escaping_charset` to avoid specifying it in templates (_application-local.properties_):

    ```properties
    spring.freemarker.settings.url_escaping_charset=UTF-8
    ```
4. You may want to import your default layout to all your pages automatically (_application.properties_)

    ```properties
    spring.freemarker.settings.auto_import=layout/defaultLayout.ftl as layout
    ```
    This is equivalent to adding explicitly to your page:

    ```freemarker
    <#import "../layout/defaultLayout.ftl" as layouts>
    ```

Why Freemarker and not a [Thymeleaf]? Because Thymeleaf is one of the [slowest][benchmark] template engines for Java. Freemarker is in the middle of the list, 1.5 times faster than Thymeleaf. [Velocity] or [JMustache] are even faster, but the difference is not as big and Freemarker has quite a lot of useful features.

[Spring Boot]: https://projects.spring.io/spring-boot
[Freemarker]: http://freemarker.org
[Thymeleaf]: http://www.thymeleaf.org/
[Velocity]: http://velocity.apache.org/
[JMustache]: https://github.com/samskivert/jmustache
[benchmark]: https://github.com/jreijn/spring-comparing-template-engines#benchmarks-2015
