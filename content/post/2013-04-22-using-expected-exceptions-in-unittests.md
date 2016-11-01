---
layout: post
title: "Using Expected Exceptions in UnitTests"
date: 2013-04-22 11:17:01 +0300
comments: true
categories:
 - programming
tags:
 - java
 - tdd
---

Sometimes, reviewing code, I see misunderstanding of using _Expected Exception_ concept in unit tests.

<!--more-->
Let's consider following test class:

{{% gist kpavlov 4f2fd37058d66744893c "ExpectedExceptionTest.java" %}}

There are two test methods here and only first one is not correct.
When service throws `SomeException`, `Mockito.verifyZeroInteraction(bar)` is not invoked,
although expected exception is catched and test framework reports test passed.

The Rule of Thumb is:
**You may use `ExpectedException` only if call of the _method under test_ is the last operator of test method.**

