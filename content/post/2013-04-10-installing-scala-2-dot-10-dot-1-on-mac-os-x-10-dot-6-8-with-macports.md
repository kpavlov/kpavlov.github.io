---
title: "Installing Scala 2.10.1 on Mac OS X 10.6.8 with Macports"
date: 2013-04-10 13:22:43 +0300
comments: true
alias: /2013/04/scala-install-macosx-macports.html
categories:
  - programming
tags:
  - scala
---

There are few steps to follow to have Scala language installed on your Mac.
These works for me for scala scala 2.10.1 on Mac OS X 10.6.8.
<!--more-->
The easier way to install Scala on Mac is using [HomeBrew](/blog/2013/04/23/brewing-scala-on-mac-os-x/),
but this instruction for those guys, who prefer good-old MacPorts.

Install scala package from MacPorts:

    MyLaptop:~ user$ sudo port install scala2.10

Now Scala is installed to `/opt/local/share/scala-2.10/` and symlinks to scala jars were created under `/opt/local/share/java`

Some symlinks are missing so I created them:

    cd /opt/local/bin/
    sudo ln -s scala-2.10 scala
    sudo ln -s scalac-2.10 scala
    sudo ln -s scaladoc-2.10 scaladoc
    sudo ln -s scalap-2.10 scalap

Verify that scala is installed. Run inTerminal:

    MyLaptop:~ user$ scala
    Welcome to Scala version 2.10.1 (Java HotSpot(TM) 64-Bit Server VM, Java 1.7.0_17).
    Type in expressions to have them evaluated.
    Type :help for more information.

    scala> println(123)
    123

    scala> :q

Ok, that works! Great!

Now it’s time to setup your IDE!
