---
layout: post
title: "Brewing Scala on Mac OS X"
date: 2013-04-23 13:58:54 +0300
comments: true
alias: /2013/04/brewing-scala-on-mac-osx.html
categories:
  - programming
tags:
  - scala
---
Installing scala with [HomeBrew](http://brew.sh/) on Mac OS X was even more easy than [Installing Scala with MacPorts](/2013/04/10/installing-scala-2-dot-10-dot-1-on-mac-os-x-10-dot-6-8-with-macports/)<!--more-->:

    myMac:~ user$ brew search scala
    scala   scalate
    homebrew/versions/scala29
    homebrew/science/scalapack
    myMac:~ user$ brew install scala

    ==> Downloading http://www.scala-lang.org/downloads/distrib/files/scala-2.10.1.tgz
    ######################################################################## 100,0%
    ==> Downloading https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/com
    ######################################################################## 100,0%
    ==> Caveats
    Bash completion has been installed to:
    /usr/local/etc/bash_completion.d
    ==> Summary
    /usr/local/Cellar/scala/2.10.1: 94 files, 33M, built in 48 seconds
    myMac:~ user$ which scala
    /usr/local/bin/scala
    myMac:~ user$ scala
    Welcome to Scala version 2.10.1 (Java HotSpot(TM) 64-Bit Server VM, Java 1.7.0_17).
    Type in expressions to have them evaluated.
    Type :help for more information.

    scala> println ("hello");
    hello

    scala> :quit
    myMac:~ user$
