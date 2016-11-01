---
title: JAX-WS with Custom SSLSocketFactory
description: How to configure custom SSLSocketFactory for JAX-WS web-service in Spring Framework
categories:
  - programming
tags:
  - java
  - spring
  - web services
date: 2014-12-01T14:34:00
---

It's very easy to configure custom [SSLSocketFactory](https://docs.oracle.com/javase/8/docs/api/javax/net/ssl/SSLSocketFactory.html) for JAX-WS web-service: just specify custom property referring to `SSLSocketFactory` bean.
But there is a nuance...<!--more-->

In SpringFramework you may setup web service port with following XML configuration:

```xml
<bean id="myPort" class="org.springframework.remoting.jaxws.JaxWsPortProxyFactoryBean">
    <property name="serviceInterface" value="com.example.ServicePortInterface"/>
    <property name="wsdlDocumentResource" value="classpath:wsdl/MyService.wsdl"/>
    <property name="namespaceUri" value="urn:MyServer"/>
    <property name="serviceName" value="MyServerService"/>
    <property name="endpointAddress" value="${my.service.url}"/>
    <property name="customProperties">
        <map key-type="java.lang.String">
            <entry key="com.sun.xml.ws.transport.https.client.SSLSocketFactory"
                   value-ref="mySslSocketFactoryBean"/>
        </map>
    </property>
</bean>

<!--  My bean implements javax.net.ssl.SSLSocketFactory -->
<bean id="mySslSocketFactoryBean" .../>
```

The code above will work if you are using JAX-WS reference implementation but will not work with JAX-WS bundled in Oracle JDK. For that case you need to set a custom property named `"com.sun.xml.internal.ws.transport.https.client.SSLSocketFactory"`.

That's confusing, but you should use a property name defined in the `JAXWSProperties` class of JAX-WS implementation of your choice. For example:

-  [`com.sun.xml.ws.developer.JAXWSProperties.SSL_SOCKET_FACTORY`](https://jax-ws.java.net/nonav/2.2.8/javadocs/rt/com/sun/xml/ws/developer/JAXWSProperties.html#SSL_SOCKET_FACTORY) -- if you're using JAXWS-RI implementation;
- `com.sun.xml.internal.ws.developer.JAXWSProperties.SSL_SOCKET_FACTORY` -- for Oracle JDK implementation;
- `weblogic.wsee.jaxws.JAXWSProperties.SSL_SOCKET_FACTORY` -- for WebLogic server's implementation.
...

So find a `JAXWSProperties` and use a value of constant `SSL_SOCKET_FACTORY` in JAX-WS binding custom properties.
