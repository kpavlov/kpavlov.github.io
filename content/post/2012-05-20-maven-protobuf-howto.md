---
layout: post
title: Configuring Protobuf to Java compiler in maven
date: '2012-05-20T21:51:00+03:00'
categories:
  - programming
tags:
  - java
  - google protobuf
tumblr_url: http://konstantinpavlov.net/post/32280743952/maven-protobuf-howto
---
Here are few steps to configure protobuf-to-java compilation in your maven project:

Install google protobuf compiler on your computer.

Configure maven protobuf compiler plugin and dependency in  _pom.xml_ <!--more-->:

```xml
<properties>
    <!-- You may need to specify path to protobuf compiler -->
    <protocCommand>/opt/local/bin/protoc</protocCommand>
</properties>

<build>
    <plugins>
        <plugin>
            <groupId>com.github.igor-petruk.protobuf</groupId>
            <artifactId>protobuf-maven-plugin</artifactId>
            <version>0.5.1</version>
            <executions>
                <execution>
                    <goals>
                        <goal>run</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

<dependencies>
    <dependency>
        <groupId>com.google.protobuf</groupId>
        <artifactId>protobuf-java</artifactId>
        <version>2.4.1</version>
    </dependency>
</dependencies>
```

Create protobuf definition files within _/src/main/protobuf/_ directory. You may want to specify the following options in .proto files.

```protobuf
package com.example;
option java_multiple_files = true;
option java_outer_classname = "Messages";
```

mvn generate-sources and you’re done!
