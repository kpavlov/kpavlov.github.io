---
#layout: post
title: How to Start Testing UI Before Backend is Ready
date: 2017-02-23
updated: 2017-03-01
description: How to develop and test UI before backend is completed
categories:
  - programming
tags:
  - quality assurance
---
Recently I was [asked](http://disq.us/p/1gfbdpc) how to start with testing UI before backend is completed.

It depends on the product a lot. But when we're talking about web, it is often not clear how the final solution should look like and behave.
If so, it is not reasonable to spend much time writing UI tests using tools like [Selenium](www.seleniumhq.org) before the first prototype is ready. It is not reasonable to write a presentation layer and, in some cases, a business logic on server side before it is clear what kind of data is required for UI.
To deal with it I suggest starting with UI mockups and use fake data to start prototyping. It is very easy if you're writing single page application (SPA): just put some JSON files as static resources and read this files in applications. For more complex cases like handling `POST` requests you may use simple mock server like [gulp-connect](https://www.npmjs.com/package/gulp-connect). This is required for development so your UI developers don't even need any server running.

Once you're a bit confident how your UI will look like and behave, it comes the time to cover it with some tests.
When using Selenium you will normally ends up with developing some DSL framework for your tests which will include some custom assertions and methods to execute common tasks like user login and filing some forms. Now you should prepare more test data and put it in the same JSON files. Most likely, you will need fake server like gulp-connect in this stage.
Use [PageObjects](http://selenide.org/documentation/page-objects.html) to abstract your tests from minor (or even major) future changes in the UI.

It is impossible to cover all the cases without real application server. Also, it is very difficult to test requests sent by UI application. But you can test a lot of cases like _"WHEN user requests some url THEN expected data is shown on page"._

You may start developing your server in parallel with UI when your contract is defined.
That's why I favor Contract-First approach over "Contract-Last". Over time, the contract will mutate for sure. But this should be not a dramatical changes.

The reason to start with UI is to define a contract from real UI requirements.
Initial prototype may be turned down by the clients so writing server-side logic is pointless.

When server is ready to serve some data to the client, you may start the integration. Create a test data in your database which produces the same data as your JSON files served by mock server. And you should parametric your UI application to get data either from mock server or from real server.
I'm sure there will be issues. But I hope, you'll get less issues since your UI is much more stable now. Happy integration! ;-)

There is another case: you develop not a SPA but a site with many server-generated pages. The idea is the same:

1. Separate presentation from business logic
2. Provide mock data for your pages
3. Create a prototype using mock data
3. Test your prototype with mock data
4. When you're confident and happy with the UI design and behavior -- then replace your fake DAO with real one and put test data to database. The same tests should still pass.

I hope this could help.
