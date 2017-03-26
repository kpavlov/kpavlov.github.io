---
title: "ng-grid: library for building dynamic data-grid for AngularJS"
date: 2014-06-09 11:51:21 +0300
comments: true
categories:
  - programming
tags:
  - javascript
  - angularjs
---

I was a curious if there is a solution for implementing dynamic grids for AngularJS.

In particular, it should provide following basic features like server-side filtering, sorting and paging.
<!--more-->

Google suggested a good [angular modules directory](http://ngmodules.org/) where I found the solution very quickly.

## [ng-grid](https://angular-ui.github.io/ng-grid/)

This library supports both client-side and [server-side](https://angular-ui.github.io/ng-grid/#/paging) data models.

In the example provided there is a function `getPagedDataAsync(pageSize, currentPage, searchText)` which is responsible for getting data from server. It should be customized to be able to send filtering and sorting options to server with JSON request, so it should work as expected.

Also, there is a support for cell and row templates, selection handling, excel-style data editing, column pinning and even for groupping (make sense for client side data model).

Example is also available [here](http://plnkr.co/edit/50vJrs?p=preview).
