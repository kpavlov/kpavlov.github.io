---
title: Implementing Automatic Reconnection for Netty Client
keywords: netty,client,reconnect
date: 2015-07-08T07:48:05
updated: 2015-07-11T09:31:22
categories:
  - programming  
tags:
  - java
  - netty
  - jreactive-8583
---

One of the first requirement of [Netty ISO8588 client connector][jreactive-8583] was the support for automatic reconnect.

One of the first receipts I came across was [Thomas Termin's one][tterm]. He suggests adding a ChannelHandler which will schedule the calling of client's `connect()` method once a Channel becomes inactive. Plus adding ChannelFutureListener which will re-create a bootstrap and re-connect if initial connection was failed.

Although this is a working solution, I had a feeling that something is not optimal. Namely, the new Bootstrap is being created on every connection attempt.

So, I created a FutureListener which should be registered once a Channel is closed.<!--more-->

Here is the [`ReconnectOnCloseListener`][ReconnectOnCloseListener] code:

```java ReconnectOnCloseListener.java
    public class ReconnectOnCloseListener implements ChannelFutureListener {

        private final Logger logger = getLogger(ReconnectOnCloseListener.class);

        private final Iso8583Client client;
        private final int reconnectInterval;
        private final AtomicBoolean disconnectRequested = new AtomicBoolean(false);
        private final ScheduledExecutorService executorService;

        public ReconnectOnCloseListener(Iso8583Client client, int reconnectInterval, ScheduledExecutorService executorService) {
            this.client = client;
            this.reconnectInterval = reconnectInterval;
            this.executorService = executorService;
        }

        public void requestReconnect() {
            disconnectRequested.set(false);
        }

        public void requestDisconnect() {
            disconnectRequested.set(true);
        }

        @Override
        public void operationComplete(ChannelFuture future) throws Exception {
            final Channel channel = future.channel();
            logger.debug("Client connection was closed to {}", channel.remoteAddress());
            channel.disconnect();
            scheduleReconnect();
        }

        public void scheduleReconnect() {
            if (!disconnectRequested.get()) {
                logger.trace("Failed to connect. Will try again in {} millis", reconnectInterval);
                executorService.schedule(
                        client::connectAsync,
                        reconnectInterval, TimeUnit.MILLISECONDS);
            }
        }
    }
```

To establish the connection I use the following [code][Iso8583Client]:

```java
    reconnectOnCloseListener.requestReconnect();
    final ChannelFuture connectFuture = bootstrap.connect();
    connectFuture.addListener(connFuture -> {
        if (!connectFuture.isSuccess()) {
            reconnectOnCloseListener.scheduleReconnect();
            return;
        }
        Channel channel = connectFuture.channel();
        logger.info("Client is connected to {}", channel.remoteAddress());
        setChannel(channel);
        channel.closeFuture().addListener(reconnectOnCloseListener);
    });
    connectFuture.sync();// if you need to connect synchronously
```

When you want to disconnect, you'll need to disable automatic reconnection first:
```java
    reconnectOnCloseListener.requestDisconnect();
    channel.close();
```

The solution works fine so far ([integration test][test]).

Another option is to add a ChannelOutboundHandler which will handle disconnects.

### Links

- Sources: [ReconnectListener][ReconnectOnCloseListener], [Client][Iso8583Client]
- StackOverflow: [answer one][stackoverflow], [answer two](http://stackoverflow.com/a/9351628/3315474)

[jreactive-8583]: https://github.com/kpavlov/jreactive-8583
[tterm]: http://tterm.blogspot.com/2014/03/netty-tcp-client-with-reconnect-handling.html
[ReconnectOnCloseListener]: https://github.com/kpavlov/jreactive-8583/blob/master/src/main/java/org/jreactive/iso8583/netty/pipeline/ReconnectOnCloseListener.java
[Iso8583Client]: https://github.com/kpavlov/jreactive-8583/blob/master/src/main/java/org/jreactive/iso8583/client/Iso8583Client.java#L67
[test]: https://github.com/kpavlov/jreactive-8583/blob/master/src/test/java/org/jreactive/iso8583/example/ClientReconnectIT.java
[stackoverflow]: http://stackoverflow.com/a/20881135/3315474
