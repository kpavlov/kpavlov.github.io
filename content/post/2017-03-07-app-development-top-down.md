---
date: "2017-03-07T08:48:34+02:00"
updated: 2017-03-12
slug: app-development-top-down
title: "Application Development Top-Down"
description: "Application Development Top-Down - from UI to API, services and data. How to start testing early. How to start with back-end later."
categories:
  - project-management
tags:
  - programming
  - quality-assurance
  - web
---

Typical management and technical mistake when developing web applications is building the system ground-up, from persistence level to web.
The development usually starts from data modeling, persistence and service layers and, finally, the UI.

The problem with ground-up approach is that Client can't see and play with the product on early development stages.
When a Client gets first working prototype a lot of work has been done both on front-end and back-end side. In worst case is a product which does not meet Client's expectations.

Now there may be two decisions for stakeholders to take: either to continue with development and change both front-end and a back-end, or to cancel the project. A signs of first decision are significant changes of data model or when data model does not match domain model well.

Hopefully, by using agile methodologies the problem may be mitigated. Let me show you a slide from Henrik Kniberg's [presentation][henrik-presentation]:
![](/assets/2017/03/what-isagile-henrik-kniberg.jpg)

It's a classical iterative development process with short iterations, each iteration adds value. Client, server and DB are changed together in order to add new functionality. And the Client is always happy, even having a part of MVP.

The question is: *"Will the Client be happy with a skateboard? Or she needs at least a bicycle? Is she OK with the application design?"*

In the real world the Client may not know if she like the first version or not.
Ok, we can build a UI "without design", using standard [Bootstrap](https://getbootstrap.com/) components.
But even then it's better to ask the Client: "Is it looks similar the product she would like to get at the end?"

That's why I propose to consider top-down approach -- ***Development from Web Prototype.***
I&nbsp;think it's even more agile way since client feedback is collected earlier thus minimizing unnecessary work.

## Development Plan

On following diagram I showed a common development phases on a timeline.
Vision and Analysis phases were left behind the scene.

![Application Development Schedule](/assets/2017/03/app-development-schedule-v1.svg)

Let's assume, we're going to develop a web application consuming REST API from back-end server.

### 1. UI Prototype
The actual development starts with web application prototyping.
First UI mockups are created and presented to Client.
This is typically an single page application (SPA) written using some component framework: Angular, React, whatever developers are confident with.
Hopefully, there is some visual prototype or screen mockups so initial version is created quickly.


### 2. Add Some Static Data

When initial application structure is clear, it's the time to add some data. This should not be a real data as there is no real backend to provide it. It's enough to create some json files and deploy them under `/assets` or `/data` folder along with application.


### 3. Start Defining API Contract

This static data is a foundation of future API specification (contract). The most popular format for writing API specifications is [OpenAPI/Swagger](https://swagger.io). It suites well for most common cases. Some aspects, like inheritance, are not clear enough in specification but the format is widely accepted in the industry so it's a default choice.

Alternative formats for describing API are:

- [API Blueprint](http://apiblueprint.org/)
- [Mashape](http://www.mashape.com)
- [Mashery I/O Docs](https://github.com/mashery/iodocs)  

When you have Specification, you can automatically generate and publish API reference documentation.
This will used often by your team internally and you will publish it later if you decide to make your API public.

There are tools on the market you can use to generate HTML documentation from API Specification.


### 4. It's Time for Testing

Now you have web application fed with static data. It's time to write some tests.
You may start testing some base functionality you're confident with.
Web Developers may start testing web components using JS-stuff like mocha, jasmine or similar framework.

It is impossible to cover all the cases without real application server. Also, it is very difficult to test requests sent by UI application. But you can test simple scenarios like: _"WHEN user requests some url THEN expected data is shown on page"._


### 5. …Even for System Integration Testing

Webapp functional end-to-end testing with test data can be done by web developers.

System integration testing is usually done together by QA team and employs both web and back-end developers.
It usually covers complex interaction scenarios between front-end and back-end.

Common tool used for system integration testing is Selenium.
Sometimes it is also necessary to develop some extra tools for direct access to underlaying data and external system emulators (test doubles).
And often the team will end up designing a custom test DSL to simplify writing this kind of tests

There is a long way to go but even now it's possible to star writing some simple tests

And it is now possible to start creating System Integration tests.
Even you have no back-end yet, you defined an expected data in static files so there is nothing preventing from using a heavy stuff like Selenium.


### 6. Starting Back-End: Mock Controllers

We have a contract (API specification) and test data in static files (data should match the contract).
We have also some system integration tests.

Let's concentrate on deployment and testing. We don't need to implement services and data layer so far.

Now we need a back-end and full deployment cycle to test both front-end and back-end together.
From a API specification we may generate data transfer objects and interfaces of front controllers.
Then we should implement controllers so they return the same test data.
Mock controllers are enough. They may serve the same static data as for webapp.

The most important that after completing this step our system integration tests should run against real UI working win real server. And tests should be green.

### 7. Continuing Back-End: Controllers and Mock DAO

Now it's time to implement services, one by one. Database is still not necessary - we may mock persistence (DAO) layer.
The tests still should be green and we may add more tests now since we have Services now.

### 8. Continuing Back-End: DB and Real DAO

Now we should design our persistence layer, create DAO add test data so the tests are still green.
After that we'll have all components in our system:

- Web Application
- REST API Specification
- Backend: Controllers, Services, DAO
- Database

Now let's continue with short interactions affecting all system layers.

## Final Notes

This not a methodology. It's just the idea of how to minimize unnecessary work in conditions of business uncertainty.

You should not use this instruction blindly. Some steps may be omitted or combined for your project.

## Links

- ["What is Agile" by Henrik Kniberg][henrik-presentation]

[markdown]: https://daringfireball.net/projects/markdown/
[henrik-presentation]: https://www.slideshare.net/RichardPDoerer/what-isagile-henrik-kniberg-august-20-2013/21
