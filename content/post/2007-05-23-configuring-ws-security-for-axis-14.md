---
layout: post
title: "Configuring WS-Security for Axis 1.4 client"
date: 2007-05-23T14:13:00
alias: /2007/05/configuring-ws-security-for-axis-14.html
categories:
 - programming
tags:
 - java
 - web services
---

I was looking how to enable WS-Security features in the Axis client to my web service application. I have tested it with Axis 1.4 client.
<!--more-->
The things you need to configure axis client are:

1. Copy _wss4j.jar_ (rev. 1.5.1), _opensaml-1.1.jar_ and _xmlsec-20050514.jar_ (from the openSAML distribution) to classpath (`WEB-INF/lib`)

2. Add handler to _client.wsdd_:

    ```xml
    <!-- Using the WSDoAllSender security handler in request flow -->
    <deployment xmlns="http://xml.apache.org/axis/wsdd/" java="http://xml.apache.org/axis/wsdd/providers/java">
        <transport name="http" pivot="java:org.apache.axis.transport.http.HTTPSender">
            <globalconfiguration>
                <requestflow>
                    <handler type="java:org.apache.ws.axis.security.WSDoAllSender">
                        <parameter name="action" value="UsernameToken"/>
                        <parameter name="passwordType" value="PasswordDigest"/>
                        <parameter name="mustUnderstand" value="false"/>
                    </handler>
                </requestflow>
            </globalconfiguration>
        </transport>
    </deployment>
    ```

You don't need to hardcode username and password as a handler parameters.
Just call setUsername(...) and setPassword(...) methods of your Stub.

