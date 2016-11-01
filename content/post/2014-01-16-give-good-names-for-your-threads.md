---
layout: post
title: "Give Good Names for Your Threads"
date: "2014-01-16T12:16:26"
comments: true
categories:
  - programming
tags:
  - java
  - code style
---

When configuring executors in multithreaded application, do not forget to assign names to your threads. It simplifies later profiling a lot, when you see a meaningful thread names in your profiler.

For example, you may use [`CustomizableThreadFactory`](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/scheduling/concurrent/CustomizableThreadFactory.html) from SpringFramework for that.
