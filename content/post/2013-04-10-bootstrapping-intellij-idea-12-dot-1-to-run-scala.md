---
title: "Bootstrapping IntelliJ Idea 12.1 to Run Scala"
date: 2013-04-10 13:48:43 +0300
comments: true
alias: /2013/04/bootstrapping-scala-in-jetbrains-idea-on-mac.html
categories:
  - programming
tags:
  - scala
---

After [installing Scala language on your Mac with MacPorts](/2013/04/scala-install-macosx-macports.html)
(although you may do it with HomeBrew), it’s time to do try to write something in your favorite [IDE](http://www.jetbrains.com/idea/).

<!--more-->
1. Install [IntelliJ Scala Plugin](http://plugins.jetbrains.com/plugin/?id=1347)
2. Create Scala project
3. Add Global Library (let’s call it “scala”) with classpath dir pointing to Scala installation Lib dir: `/opt/local/share/scala-2.10/lib/`
4. Setup scala module facet to use that created Global Library(“scala”) as “Compiler library”.
5. Create first Scala Object:

        object LaScala {
          def main(args: Array[String]) {
            val hello = "’O sole mio!"
            println(hello)
          }
        }
6. Run ‘LaScala’ from menu and and see the console:

        /Library/Java/JavaVirtualMachines/jdk1.7.0_17.jdk/Contents/Home/bin/java -Didea.launcher.port=... com.intellij.rt.execution.application.AppMain LaScala
        ’O sole mio!

Process finished with exit code 0

> Be aware of: Parallel compilation and Automake is not supported for Scala projects. Please turn off “Project Settings / Compiler / Compile independent modules in parallel”. “Automake is not supported for Scala projects. Please turn off “Project Settings / Compiler / Make project automatically”.
