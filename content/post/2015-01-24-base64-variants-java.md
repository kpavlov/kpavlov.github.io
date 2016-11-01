---
title: "Base64 Variants in Java 8"
date: 2015-01-24T04:45:10
tags:
  - java
categories:
  - programming
---

You most likely used Base64 encoding. It's about encoding any sequence of data as a printable string (digits, lower case and upper case letters). But Base64 has variations. E.g., not every Base64 variant allows safe transfer of any data as URL parameters.
For that purpose there is a special dialect of Base64: Url-safe encoding.
<!--more-->
Since Java 8 you may use class [`java.util.Base64`](http://docs.oracle.com/javase/8/docs/api/java/util/Base64.html) for encoding and decoding. 
It supports Basic, URL and Filename Safe and MIME-encoded variants, as specified in [RFC 4648](http://www.ietf.org/rfc/rfc4648.txt) and [RFC 2045](http://www.ietf.org/rfc/rfc2045.txt).

```java
Base64.Encoder encoder = java.util.Base64.getUrlEncoder().withoutPadding();
String base64String = encoder.encodeToString(byteArray);
```
