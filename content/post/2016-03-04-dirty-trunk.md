---
layout: post
title: Developing in "Dirty Trunk"
date: 2016-03-04T22:26:24
categories:
 - devops
tags:
---

I'm going to start a series of posts covering different aspects of DevOps.

Let's start today with branching strategy called _"dirty trunk"_. Actually, this is an attempt to avoid branching at all.
<!--more-->
The idea is that:

1. all developers commit their changes directly to _master_ branch or (_trunk_).
2. CI server is triggered a build on every commit and resulting artifact is accepted or rejected based on test results.
3. once all the tests are passed the artifacts are promoted thus making _Continuous Delivery (CD)_ possible.

This is a simple strategy to implement from the Ops point of view. But it requires significant effort from the developers to maintain stability of the build. When tests are failing the disrupting change should be immediately fixed or reverted. We used to practice this strategy for two years, but as the team and number of tests grow it was more and more difficult to keep build stability. Finally we switched to feature branching and it helped with a build stability a lot.<!--more-->

## Pros

- Easy to understand
- Simple CI/CD-friendly automation flow
- Sequential build number from subversion commit number
- This strategy fits well for both git and subversion

## Cons

- Requires discipline among developers to _not push the changes_ unless sanity (smoke) tests are passed on local machine.
- So, there should be _sanity (smoke) tests_ -- a subset of tests covering most important functionality.
  We've called them "cookies": The one who breaks that tests should bring a cookies to the team.
- Even if your tests passed, maybe somebody has pushed his/her changes while you were running your tests.
- Keep an eye on the build status after your push, be ready to revert.
- It may be painful to revert the changes when somebody has pushed a change over a destructing one.
- As a consequence, build is often broken. We had a dedicated developer who was _on duty_ fixing the build.

## Good Practices

- _Reproducible builds (common practice)._ It should be always possible to make a build again (e.g. if you lost your artifact repository). If you're using maven , use [maven-release-plugin] to increment version, commit, push and set a tag on this version. Later you'll be able to find a version by tag or create a new branch from the tag.
- Make a build in one step (remember p.2 from [Joel Test]).
- Don't rebuild artifacts. It saves time and ensures that you're deploying and testing the same artifact.
- Tag good commits: make a tag once tests passed ([maven-release-plugin] can do it for you).
- Automatically promote good build (Continuous Delivery)
- Implement auto-revert changes on test failure. At least if there are no newer commits.
- Make build and run tests in parallel on multiple build agents. This saves time a lot.

_I can recommend this strategy only when your team is small and disciplined and you can run all tests locally before commit, so you'll unlikely break a build. With a poor random tests it leads to fragile codebase and takes a lot of time to support._

Recommended reading: [Paul Hammant's blog]

---
Ideas, suggestions, comments are welcome.
Thank you.

[maven-release-plugin]: https://maven.apache.org/maven-release/maven-release-plugin/
[Paul Hammant's blog]: http://paulhammant.com/categories.html#Trunk_Based_Development
[Joel Test]: http://www.joelonsoftware.com/articles/fog0000000043.html "The Joel Test: 12 Steps to Better Code"
