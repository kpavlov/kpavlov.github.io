---
layout: post
title: "Chronicle"
date: '2014-02-19T12:30:42+02:00'
categories:
  - programming
tags:
  - java
  - performance
tumblr_url: http://konstantinpavlov.net/post/77168263587/peter-lawrey-java-chronicle
---

[Chronicle](https://github.com/peter-lawrey/Java-Chronicle) by Peter Lawrey:

  > This library is an ultra low latency, high throughput, persisted, messaging and event driven in memory database. The typical latency is as low as 80 nano-seconds and supports throughput of 5-20 million messages/record updates per second.
  
  > This library also supports distributed, durable, observable collections (Map, List, Set) The performance depends on the data structures used, but simple data structures can achieve throughput of 5 million elements or key/value pairs in batches (eg addAll or putAll) and 500K elements or key/values per second when added/updated/removed individually.
  
  > It uses almost no heap, trivial GC impact, can be much larger than your physical memory size (only limited by the size of your disk) and can be shared between processes with better than 1/10th latency of using Sockets over loopback. It can change the way you design your system because it allows you to have independent processes which can be running or not at the same time (as no messages are lost) This is useful for restarting services and testing your services from canned data. e.g. like sub-microsecond durable messaging. You can attach any number of readers, including tools to see the exact state of the data externally. e.g. I use; od -t cx1 {file} to see the current state.
