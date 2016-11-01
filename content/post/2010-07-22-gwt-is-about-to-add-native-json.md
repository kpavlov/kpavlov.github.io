---
layout: post
title: "GWT is about to add Native JSON function support in version 2.1"
date: 2010-07-22T17:20:00
alias: /2013/05/gwt-is-about-to-add-native-json.html
categories:
 - programming
tags:
 - java
 - gwt
---

GWT 2.1 has reached Milestone 2.
One of the new features in version 2.1 is support for browser's native JSON function in `JSONParser` class.
<!--more-->
Now there are three methods JSONParser which may be used to parse JSON string:

  1. `JSONParser.parseNative(String)` - Uses native JSON browser's function, if browser supports it
  2. `JSONParser.parseLanient(String)` - Uses browser's eval() function
  3. `JSONParser.parse(String)` - Old method that is still supported and actually calls `JSONParser.parseLanient()`

Under Google Chrome `parseNative()` works usually 30-50% faster than `parseLanient()`: 450 vs 800 ms for parsing json string 10000 times.

    Chrome Native JSON Test:
    ------------------------
    JSON src length=3467 chars; 10000 iterations.
    Native JSON time: 1692ms
    Parser Native JSON time: 1728ms
    Parser Lanient JSON time: 853ms

Under Firefox, results are different from time to time (from 80 to 200ms).
Native function may be 2 times faster or 2 times slower.
So it seems there will be no significant speedup using native under Firefox.

But anyway, Firefox has faster evaluate json than Chrome.

    Firefox Native JSON Test:
    -------------------------
    JSON src length=3467 chars; 10000 iterations.
    Native JSON time: 1224ms
    Parser Native JSON time: 1208ms
    Parser Lanient JSON time: 974ms

Using new function has sense for browser like Chrome where performance can be improved.

P.S. All measurements are valid on June 2010
