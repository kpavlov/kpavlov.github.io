---
layout: post
title: DevMode Javascript Exception Handler
date: 2016-02-11T23:09:16
categories:
  - programming
tags:
  - javascript
  - web
  - fun
---
StackOverflow-driven JS development:
```javascript
try {
    something
} catch (e) {
     window.open('https://stackoverflow.com/search?q=[js]+"' + e.message + '"');
}
```
