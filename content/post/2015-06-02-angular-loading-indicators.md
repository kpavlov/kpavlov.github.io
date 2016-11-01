---
title: "Loading Indicators for AngularJS"
date: 2015-06-02T18:44:43
comments: true
tags:
  - javascript
  - angularjs
categories:
  - programming
---

Modern web application should be user friendly and notify the User when time consuming operation is on the way, e.g. uploading file or downloading data.
There are a some solutions for AngularJS which are fairy easy to integrate.

First one is [Angular Loading Bar][angular-loading-bar]. It can be attached to your application with almost zero configuration and does not affect application design.
It attaches the interceptor to `$http` service and displays a thin progressbar on the top edge of the page.
[Demo][angular-loading-bar]

Another component is [angular-busy][angular-busy]. It is more customizable and can show a spinner with backdrop above any page element. Just wrap it with `<div cg-busy="..."/>`.
But it may require some customization.
[Demo][angular-busy-demo]

Also, there are some [examples][ui-router-resolve] how to add loading indicator to [ui-router][].

[angular-loading-bar]: http://chieffancypants.github.io/angular-loading-bar
[angular-busy]: https://github.com/cgross/angular-busy
[angular-busy-demo]: http://cgross.github.io/angular-busy/demo
[ui-router]: https://github.com/angular-ui/ui-router
[ui-router-resolve]: https://github.com/angular-ui/ui-router/issues/456 "Apply a custom animation to ui-view during resolve"
