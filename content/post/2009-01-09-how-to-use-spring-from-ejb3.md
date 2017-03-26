---
title: "How to Use Spring from EJB3"
date: 2009-01-09T17:23:00
alias: /2007/05/configuring-ws-security-for-axis-14.html
categories:
 - programming
tags:
 - java
 - spring
---

This is a short instruction how to inject a spring-managed bean into EJB3 component<!--more-->:

1. Read <a href="http://www.springsource.org/">SpringFratamework's</a> reference here: <a href="http://static.springframework.org/spring/docs/2.5.x/reference/ejb.html#ejb-implementation-ejb3">http://static.springframework.org/spring/docs/2.5.x/reference/ejb.html#ejb-implementation-ejb3</a>
2. Place to ejb module's classpath a file _beanRefContext.xml_:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd">
    <beans>

     <bean id="myBeanFactory" class="org.springframework.context.support.ClassPathXmlApplicationContext">
      <constructor-arg value="myApplicationContext.xml"/>
     </bean>

    </beans>
    ```
3. Create application context file named `myApplicationContext.xml` and define you beans there. Place this file to the ejb module's classpath.
4. Annotate your Stateless Session Bean:

    ```java
    @Stateless
    @Interceptors(org.springframework.ejb.interceptor.SpringBeanAutowiringInterceptor.class)
    public class MyFacadeBean implements MyFacade {

      @Autowired
      private MySpringComponent component;
          ...
          public void foo() {
              component.foo();//invocation
           }
      }
    ```

5. Deploy and test Your application.
