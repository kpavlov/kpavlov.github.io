---
title: How to Run JetBrains Idea on Mac with JDK 1.8
date: 2015-01-10T11:51:10
categories:
  - programming
tags:
  - code style
  - idea
---

[JetBrains Idea](https://www.jetbrains.com/idea/) is the perfect IDE for Java. It requires JDK 1.6+ to run.
When you want to run it on Mac without Java 1.6 installed, OS will ask you to install it.
But if you have already newer Java version installed, you may run Idea under that newer JDK.

Execute in terminal:

    $open /Applications/IntelliJ\ IDEA\ 14.app/Contents/Info.plist

TextEdit app will be opened.

Find:

     <key>JVMVersion</key>
     <string>1.6*</string>

then replace 1.6 with 1.8 (assuming, you have JDK 1.8 installed):

     <key>JVMVersion</key>
     <string>1.8*</string>


That's it! Now run
