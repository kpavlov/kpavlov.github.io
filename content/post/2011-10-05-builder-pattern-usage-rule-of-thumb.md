---
layout: post
title: "Builder Pattern Usage: Rule of Thumb"
date: 2011-10-05T12:37:37
comments: true
categories:
  - programming
tags:
  - design patterns
alias: /2011/10/builder-pattern-usage-rule-of-thumb.html
---

[Builder Pattern][builder] is a creational design pattern. But, like any other pattern, it should be used judiciously.
<!--more-->

It is good when:
 1. Creating complex immutable objects
 2. Preventing objects being created to be used before initialization is complete.

## Complex Immutable Objects

It's important that object being created should be Complex enough and Immutable.
Overwise it may be an overkill to use a Builder for simple cases.

 - If object is not complex enough — you may use more simple ways of creating new object, e.g. use static [factory method](https://en.wikipedia.org/wiki/Factory_method).
 - If object is not immutable — use setter methods

What kind of object are complex? Much depends on context, of course.
But if object has less than than 2-3 constructor parameters is unlikely to be complex enough to use the Builder.
I.e, if object can be created with factory method with up to 3 parameters, than object is simple and using Builder pattern is overkill.

One more pattern should be recalled here is [Value Object](https://en.wikipedia.org/wiki/Value_object) or [Data Transfer Object (DTO)](https://en.wikipedia.org/wiki/Data_transfer_object).
Value objects or DTOs may be passed as a constructor parameters to simplify object creation.

## Preventing early object access

Builder may be used to create an object which should not be used unless fully initialized.
Initializing object using setter methods does not prevent client from calling other object business methods. To handle this incomplete state correctly you normally should perform object state check in the beginning of every business method and throw `IllegalStateException`... or just prevent object to be created in inconsistent state.
One of the way to to this it is to use Builder.
But anyway, you should check if all the parameters are initialized inside `builder.build()` method or inside object constructor:

```java
import org.apache.commons.lang3.Validate;
public class PingResponseBuilder {
    private String serverName;
    private long timestamp;

    public void setServerName(String name) {
        this.serverName = name;
    }

    public void setTimestamp(long millis) {
        this.timestamp = millis;
    }

    private void validate() {
        Validate.notBlank(serverName, "The serverName must not be blank");
        Validate.isTrue(timestamp>0, "The timestamp must be greater than zero: %s", timestamp);
    }

    public PingResponse build() {
        validate();
        return new PingResponse(serverName, timestamp);
    }
}
```
Please keep in mind, that although memory is cheap and processors are fast, creating the new Builder instance for every created object instance is not very efficient. You may re-use single builder object (in a thread-safe manner!!!) for creating multiple object instances by setting differing properties, e.g.:

```java
PingResponseBuilder builder = new PingResponseBuilder();
builder.setServerName("A Test Server");
builder.setFoo("foo");
builder.setBar("bar");
builder.setBaz("baz");

PingResponse firstResponse = builder.setTimestamp(System.currentTimeMillis()).build();

PingResponse nextResponse = builder.setTimestamp(System.currentTimeMillis()).build();
```

[builder]: http://en.wikipedia.org/wiki/Builder_pattern "Builder Design Pattern"

