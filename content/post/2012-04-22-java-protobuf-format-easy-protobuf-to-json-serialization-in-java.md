---
title: "Java-protobuf-format: Easy Protobuf-to-JSON Serialization in Java"
date: 2012-04-22T13:09:42
comments: true
alias: /2012/04/java-protobuf-format-easy-protobuf-to.html
categories:
  - programming
tags:
  - java
  - json
  - google protobuf
---

If you need Google Protobuf-to-JSON serialization (and vice versa) there is quick solution.
[Protobuf-java-format][protobuf-java-format] library provides serialization of protobuf-generated java classes to number of formats: JSON, XML, HTML, Java property file format, Smile, CoachDB.

Here is a step-by-step instruction.
<!--more-->
Configure maven protobuf compiler plugin and dependency in your maven's _pom.xml_:

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
Add the protobuf-java-format dependency to your maven project (_pom.xml_):
```xml
...
<dependency>
    <groupId>com.googlecode.protobuf-java-format</groupId>
    <artifactId>protobuf-java-format</artifactId>
    <version>1.2</version>
</dependency>
```

Create protobuf definition in `/src/main/protobuf/test.proto`:

```protobuf
package example;
option java_multiple_files = true;
option java_outer_classname = "Messages";

message Person {
    required string name = 1;
    required Gender gender = 2;
    optional sint32 age = 3;

    enum Gender {
        MALE = 1;
        FEMALE = 2;
    }
}
```
Now you may serialize and deserialize your Protobuf java objects:

```java
Person person = Person.newBuilder()
        .setName("Bob")
        .setAge(10)
        .setGender(Person.Gender.MALE)
        .build();

System.out.println("Original=[" + person + "]");
String jsonView = com.googlecode.protobuf.format.JsonFormat.printToString(person);

System.out.println("JSON='" + jsonView + "'");

Person.Builder personBuilder = Person.newBuilder();
com.googlecode.protobuf.format.JsonFormat.merge(jsonView, personBuilder);

Person person2 = personBuilder.build();
System.out.println("Deserialized=[" + person2 + "]");
System.out.println("Original.equals.Deserialized=" + person.equals(person2));
```

This code will produce following output:

```text
Original=[name: "Bob"
        gender: MALE
        age: 10
        ]
        JSON='{"name": "Bob","gender": "MALE","age": 10}'
Deserialized=[name: "Bob"
        gender: MALE
        age: 10
        ]
Original.equals.Deserialized=true
```

[Protobuf-java-format][protobuf-java-format] uses proto object metadata (`message.getAllFields()`) under the hood.
So, it maybe not a fastest solution and not optimized for mobile devices (sometimes it is not always desirable to include metadata into generated proto-classes to be used on mobile devices).
Though, it’s easy to implement...

   [protobuf-java-format]: http://code.google.com/p/protobuf-java-format/
