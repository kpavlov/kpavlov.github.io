---
title: "Establishing Customizable Tomcat Configuration"
date: 2014-03-22 12:40:16 +0300
comments: true
categories:
 - devops
tags:
 - tomcat
 - spring
alias: [post/80352392033/establishing-customizable-tomcat-configuration]
---

Deploying to [Apache Tomcat](http://tomcat.apache.org) often requires making changes to default configuration.
These changes are often environment specific.
Also, when upgrading a Tomcat to new version you need to be sure that all your custom changes have not been lost and were applied to new configuration.
To deal with all that stuff Tomcat via separation of the configuration.
This post contains step-by-step instruction will help you to establish custom tomcat configuration.
<!--more-->
## 1. Installing tomcat
You download Tomcat distribution binary and extract it to some folder.
I put it to `~/java/apache-tomcat-7.0.52`.
It is desirable to create a symlink to it. It would allow to switch to another version of tomcat without changing your scripts
```bash    
ln -s ~/java/apache-tomcat-7.0.52 ~/java/tomcat
```
As alternative, you may install a tomcat from packages.

## 2. Create a folder to keep your custom configuration

1. Create a folder where you custom configuration will be located.

    ```bash
    mkdir -p ~/java/custom-tomcat/{bin,conf,logs,work,webapps,temp}
    ```
2. Copy default `server.xml`, `tomcat-users.xml` configuration file to custom location. If you already have a customized `server.xml` then put it there

    ```bash    
	cp -v ~/java/tomcat/conf/server.xml ~/java/tomcat/conf/tomcat-users.xml ~/java/custom-tomcat/conf/[](null)
    ```
3. Set system property `$CATALINA_BASE` referring to base directory for resolving dynamic portions of a Catalina installation.

    ```bash   
    export CATALINA_BASE=~/java/custom-tomcat
    ```
Now you can start the Tomcat and see that it uses your custom configuration folder:

    ```
    $ ./catalina.sh run
    Using CATALINA_BASE:   /Users/maestro/java/custom-tomcat
    Using CATALINA_HOME:   /Users/maestro/java/tomcat
    Using CATALINA_TMPDIR: /Users/maestro/java/custom-tomcat/temp
    ...
    ```

## 3. Tomcat runtime parameters customization

To specify JVM options to be used when tomcat server is run, create a bash script `$CATALINA_BASE/bin/setenv.sh`. It will keep environment variables referred in `catalina.sh` script to keep your customizations separate.

Define `$CATALINA_OPTS` inside `setenv.sh`.  Include here and not in JAVA_OPTS all options, that should only be used by Tomcat itself, not by the stop process, the version command etc. Examples are heap size, GC logging, JMX ports etc.

Example `setenv.sh`:

```bash
echo "Setting parameters from $CATALINA_BASE/bin/setenv.sh"
echo "_______________________________________________"

# discourage address map swapping by setting Xms and Xmx to the same value
# http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues
export CATALINA_OPTS="$CATALINA_OPTS -Xms1024m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx1025m"

# Increase maximum perm size for web base applications to 4x the default amount
# http://wiki.apache.org/tomcat/FAQ/Memoryhttp://wiki.apache.org/tomcat/FAQ/Memory
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=256m"

# Oracle Java as default, uses the serial garbage collector on the
# Full Tenured heap. The Young space is collected in parallel, but the
# Tenured is not. This means that at a time of load if a full collection
# event occurs, since the event is a 'stop-the-world' serial event then
# all application threads other than the garbage collector thread are
# taken off the CPU. This can have severe consequences if requests continue
# to accrue during these 'outage' periods. (specifically webservices, webapps)
# [Also enables adaptive sizing automatically]
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"

# The hotspot server JVM has specific code-path optimizations
# which yield an approximate 10% gain over the client version.
export CATALINA_OPTS="$CATALINA_OPTS -server"

# Disable remote (distributed) garbage collection by Java clients
# and remove ability for applications to call explicit GC collection
export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"

# Check for application specific parameters at startup
if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
  . "$CATALINA_BASE/bin/appenv.sh"
fi

echo "Using CATALINA_OPTS:"
for arg in $CATALINA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using JAVA_OPTS:"
for arg in $JAVA_OPTS
do
    echo ">> " $arg
done

echo "_______________________________________________"
echo ""
```

## 4. Migrate logging to Logback

Tomcat is configured to use Apache Commons Logging API by default.
If you are using [slf4j][slf4j] in your application and familiar with [Logback][logback], then it is reasonable to migrate your tomcat configuration to logback too. You may find details [here](http://hwellmann.blogspot.com/2012/11/logging-with-slf4j-and-logback-in.html)

## Links

- [https://github.com/kpavlov/tomcat-custom-env](https://github.com/kpavlov/tomcat-custom-env) - Custom tomcat installation example on GitHub
- https://github.com/terrancesnyder/tomcat - Tomcat Best Practices Shell
- http://hwellmann.blogspot.com/2012/11/logging-with-slf4j-and-logback-in.html
- https://gist.github.com/terrancesnyder/986029 - example setenv.sh with defaults set for minimal time spent in garbage collection
- http://wiki.apache.org/tomcat/FAQ/Memoryhttp://wiki.apache.org/tomcat/FAQ/Memory
- http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues

[slf4j]: http://slf4j.org
[logback]: http://logback.qos.ch
