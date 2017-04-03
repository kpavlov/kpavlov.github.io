---
title: "Netty: How to Initiate SSL Handshake From Client"
date: "2013-04-23T12:55:57"
comments: true
aliases:
  - /2013/04/netty-ssl-handshake-initiation-from-client.html
categories:
  - programming
tags:
  - java
  - netty
---

I have had spent some time recently making netty 3.6 sending some message when connection has been established.

What documentation suggests to do is to extend `SimpleChannelUpstreamHandler` and override method `channelConnected(...)`.
It works fine unless `SslHandler` is used in the pipeline.
If handler is present, `channelConnected()` was never called on my handler.
<!--more-->
The problem was caused by client, which did not initialized SSL handshake on connection.
Until handshake completed, no other `ChannelHandlers` are notified.
Hopefully, there is a convenient way to initiate handshake on the client. Netty documentation states:

> ## Handshake
> If `isIssueHandshake()` is `false` (default) you will need to take care of
calling `handshake()` by your own. In most situations were `SslHandler` is
used in 'client mode' you want to issue a handshake once the
connection was established. if `setIssueHandshake(boolean)` is set to
`true` you don't need to worry about this as the SslHandler will take
care of it.
> http://netty.io/3.6/api/org/jboss/netty/handler/ssl/SslHandler.html

So, you should set `isIssueHandshake` on `SslHandler` before establishing the connection:

```java
SslHandler sslHandler = new SslHandler(engine);
setIssueHandshake(true);
pipeline.addLast("ssl", sslHandler);
```

After that, server got hadshaked and `SslHandler` fired connected `ChannelStateEvent` to other `UpstreamHandlers`.
