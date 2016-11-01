---
layout: post
title: Crearing an array in JavaScript
date: '2013-01-27T17:26:00+02:00'
alias: /post/41619604653/how-to-clear-array-in-javascript
categories:
  - programming
tags:
  - javascript
tumblr_url: http://konstantinpavlov.net/post/41619604653/how-to-clear-array-in-javascript
---
Since it may be references to existing javascript array from other objects, the best way to clear array contents is assign its length to zero<!--more-->:
```javascript
var a = ['a', 'b', 'c']; //create some array
a.length = 0; // clear array
```
