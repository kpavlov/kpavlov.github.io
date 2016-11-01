---
layout: post
title: "Migrating Logback Configuration from XML to Groovy"
date: 2013-11-21 15:44:14 +0300
comments: true
alias: /2013/11/moving-to-groovy-logback-config.html
categories:
  - devops
tags:
  - java
---
I've recently switched [logback](http://logback.qos.ch/) configuration of our application [from XML to Groovy](http://logback.qos.ch/manual/groovy.html).

Configuration file is not about 5 times smaller and can be displayed on one screen!

Groovy helped to remove duplicating parts of configurations by using for loop.

The moving was easy thanks to [online conversion tool](http://logback.qos.ch/translator/asGroovy.html).
And don't forget to add a groovy-all runtime dependency to your project config.
