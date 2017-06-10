---
date: "2017-03-28"
lastmod: "2017-03-30T09:02:00+03:00"
title: "Logging Policy"
description: "One point of view on how logging levels should be used in code."
categories:
  - programming
  - devops
tags:
  - java
---
There are different points of view on how logging levels should be used in code. I will share mine.

My assumption is: **"There should be no errors in logs when everything is fine."**

The idea is that *the strongest log level should trigger alarm causing immediate notification (push or SMS) to operations team.*

Accordingly, that's how logging levels should be used:

* `error` -- Some action should be taken **immediately!** Ops team should enable email or sms notifications when a message of that king appears in logs.
* `warn` -- Some action should be taken, but **later.**
* `info` (enabled by default) -- Use this to print information you want to see in logs when your application works normally.
* `debug` (disabled by default) -- Use it to trace application business logic. Normally this should be disabled on production.
* `trace` (disabled by default) -- Use it to print raw messages (requests and responses). This is dangerous when you deal with confidential information since you may print it to logs causing security leak.

I saw other approaches to logging:

* *Using separate logger for alerts.* -- In this case only explicitly specified alerts will be sent. You will never receive an alert from third party component since it does not know about your alert logger.
* *Abusing exceptions, throwing them even in expected cases.* -- It will cause a lot of information noise in logs making difficult to find really important messages.
* *Not using `warn` level at all. Just "Black or White" approach.* -- Why not make use of this logging level making logs more fine-grained?

How the logging is used depends much on type of the business and SLAs required and also on agreements and collaboration between developers and operations team. The mentioned policy may not fit your project and it's OK :-)
