---
title: "How To Export Spring Managed Bean To JNDI"
date: 2009-01-01T00:01:00
alias: /2009/01/how-to-export-spring-managed-bean-to.html
categories:
 - programming
tags:
 - java
 - spring
---
Sometimes it is necessary to export a spring managed bean to JNDI context. Here I want to show how do it.

In spring, there is a bean that provides a similar functionality for exporting to MBean server: MBeanExporter. Unfortunately, there is no standard JNDI bean exporter implementation in Spring Framework (current version is 2.5.6) - (Why?).
But it's easy to write it yourself<!--more-->:

```java
package com.example.spring.jndi.export;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.jndi.JndiTemplate;

public class JndiExporter implements InitializingBean, DisposableBean {

    private String jndiName;
    private Object bean;
    private final JndiTemplate jndiTemplate = new JndiTemplate();
    
    public String getJndiName() {
        return jndiName;
    }
    
    public void setJndiName(String jndiName) {
        this.jndiName = jndiName;
    }
    
    public Object getBean() {
        return bean;
    }
    
    public void setBean(Object bean) {
        this.bean = bean;
    }
    
    
    public void afterPropertiesSet() throws Exception {
        jndiTemplate.bind(jndiName, bean);
    }
    
    public void destroy() throws Exception {
        if (bean != null && jndiName != null && bean == jndiTemplate.lookup(jndiName)) {
            jndiTemplate.unbind(jndiName);
        }
    }
}
```

Add following fragment to spring configuration (_applicationContext.xml_):

```xml
<bean id="myBean" class="com.example.MyBean"/>

<bean class="com.example.spring.jndi.export.JndiExporter">
    <property name="bean" ref="myBean" />
    <property name="jndiName" value="MyJNDIName"/>
</bean>
```

Don't forget to make your bean implementing `java.io.Serializable` interface.
Now we can lookup exported bean by adding to the spring config file (_applicationContext.xml_):

```xml 
<jee:jndi-lookup id="myJndiBean" jndi-name="MyJNDIName" proxy-interface="com.example.IMyBean" lookup-on-startup="false"/>
```

If you have another bean depending on JNDI resource you may try to load you that bean lazily by setting `lazy-init="true"`.
You may also try to set `lazy-init="false"` for the `JndiExporter` to ensure that the Exporter will be loaded before JNDI-dependent bean or play with `"depends-on"` bean attributes. 
