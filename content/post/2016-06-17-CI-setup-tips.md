---
layout: post
title: CI Setup Tips
date: 2016-07-17T17:00:00
categories:
  - devops
tags:
  - Jenkins
---
You may find following tips useful when setting up continuous integration infrastructure.

## Security

Use VPN or reverse proxy provider like [cloudflare.com](https://www.cloudflare.com/) to secure your CI infrastructure.
Never make your real IPs publicly available, otherwise you increase a risk of being hacked.

## Jenkins

Use master node and build agents. Master node acts only as web console. Nodes are for compiling and testing.

## Notifications

If you're using google apps for domain, you may use Google's restricted SMTP server to send notifications. You will be restricted to sending messages to Gmail or Google Apps users only, but it's ok in most cases. See this [reference page](https://support.google.com/a/answer/176600?hl=en) from Google.

## Versioning

- Disable redeploy of the artifacts with same versions to the artifact repository (e.g. Nexus)
- Use [semver](http://semver.org/) specification for versioning your software: _major.minor.build_number_.  
- Never reuse build numbers. New build => new software version.
- [Maven-release-plugin](https://maven.apache.org/maven-release/maven-release-plugin) will help you to increment versions of your project.
