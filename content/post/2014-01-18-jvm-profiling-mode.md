---
layout: post
title: "JVM Profiling Mode"
date: 2014-01-18 12:33:12 +0300
comments: true
categories:
 - programming
tags:
 - java
 - performance
---

There is no sense to run profiler in instrumentation mode on a high load.

Instead of using instrumentation you should use sampling mode. 

[This article][article] describes the difference between instrumentation and sampling modes.
[JVisualVM][jvisualvm] is a good free tool for this task.

[article]: https://blog.codecentric.de/en/2011/10/measure-java-performance-sampling-or-instrumentation/ "Measure Java Performance – Sampling or Instrumentation?"
[jvisualvm]: http://docs.oracle.com/javase/6/docs/technotes/tools/share/jvisualvm.html "jvisualvm - Java Virtual Machine Monitoring, Troubleshooting, and Profiling Tool"
