---
title: "Self-Hosted Web Analytics Solution for AngularJS"
date: 2015-06-03T19:05:12
comments: true
tags:
  - javascript
  - angularjs
  - web
categories:
  - programming
---
There are situations when you need to analyze user's experience but can't use a third-party web analytics solutions like Google Analytics or Yandex Metrika.
For example, if your production environment is [PCI DSS][pci-dss] compliant.
In this case you have to deploy self-hosted analytics engine and inside your environment and configure user actions tracking in your application.

One of the possible solutions is the [piwik][piwik] as analytics engine + [Angulartics][angulartics] or [angular-piwik][angular-piwik] for tracking events inside AngularJS application.
In addition to web analytics features, piwik offers a [log analytics](http://piwik.org/log-analytics/).
![piwik screenshot](/assets/2015/06/piwik.png)
[Piwik Demo][piwik-demo]

Another option is to use [Open Web Analytics (OWA)][openwebanalytics] and write a plugin for [Angulartics][angulartics].
[OWA Demo][openwebanalytics-demo]
 
[pci-dss]: https://www.pcisecuritystandards.org/security_standards/ "PCI SSC Data Security Standards"
[piwik]: http://piwik.org
[piwik-demo]: http://demo.piwik.org/
[openwebanalytics]: http://demo.openwebanalytics.com/
[openwebanalytics-demo]: http://demo.openwebanalytics.com/
[angulartics]: http://luisfarzati.github.io/angulartics/
[angular-piwik]: https://github.com/mike-spainhower/angular-piwik
