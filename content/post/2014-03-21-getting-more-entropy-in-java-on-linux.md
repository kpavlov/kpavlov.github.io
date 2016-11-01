---
layout: post
title: "Getting More Entropy in Java on Linux"
date: 2014-03-21 12:30:27 +0300
comments: true
categories:
 - devops
tags:
 - java
 - linux
---

![](https://31.media.tumblr.com/4166367386765fe2b5f9845906898214/tumblr_inline_n2r2coHbTe1rx1usu.jpg)

Setting entropy pool for Java server on linux is fair simple. Just add a system property to specify a device to read from.
<!--more-->
### Blocking, but more Secure 

    -Djava.security.egd=file:///dev/random

This is secure but may block your application until enough entropy is available.

>When read, the /dev/random device will only return random bytes within the estimated number of bits of noise in the entropy pool. /dev/random should be suitable for uses that need very high quality randomness such as one-time pad or key generation. When the entropy pool is empty, reads from /dev/random will block until additional environmental noise is gathered.

### Non-Blocking But Less Secure

    -Djava.security.egd=file:///dev/urandom

> A read from the /dev/urandom device will not block waiting for more entropy. As a result, if there is not sufficient entropy in the entropy pool, the returned values are theoretically vulnerable to a cryptographic attack on the algorithms used by the driver. Knowledge of how to do this is not available in the current non-classified literature, but it is theoretically possible that such an attack may exist. If this is a concern in your application, use /dev/random instead.

If solution not working then take a look at workaround: http://bugs.java.com/view_bug.do?bug_id=6202721

### How to get more entropy

1. Involve an audio entropy daemon like [AED](http://www.vanheusden.com/aed/) to gather noise from your datacenter with an open microphone, maybe combine it with a webcam noise collector like VED. Other sources are talking about [“Cryptographic Randomness from Air Turbulence in Disk devices“](http://world.std.com/~dtd/random/forward.ps). 
2. Use the [Entropy Gathering Daemon](http://egd.sourceforge.net/) to collect weaker entropy from randomness of userspace programs.
3. Have a look at [haveged](http://www.issihosts.com/haveged/) (collecting good entropy on basis of CPU clock flutter)
4. Consider [installing a couple of parrots or canary next to your server.](http://www.usn-it.de/index.php/2009/02/20/oracle-11g-jdbc-driver-hangs-blocked-by-devrandom-entropy-pool-empty/#comment-40107)

Source: http://www.usn-it.de/index.php/2009/02/20/oracle-11g-jdbc-driver-hangs-blocked-by-devrandom-entropy-pool-empty/
