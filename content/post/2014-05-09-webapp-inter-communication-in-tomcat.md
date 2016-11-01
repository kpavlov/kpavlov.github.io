---
layout: post
title: "Webapp Inter-Communication in Tomcat"
date: 2014-05-09 22:40:12 +0300
comments: true
sharing: true
categories:
 - programming
tags:
 - java
 - tomcat
 - spring
 - jmx
---

_Sometimes you need to access services deployed in one web application from another web application within same application server. For Tomcat there is not so many options to do it. In this article we'll discuss you how to use JMX for communication between web applications._
<!--more-->

When both web applications are deployed on the same [Tomcat server][tomcat] instance there are, at least, two options to communicate between them:

  1. Create a JAX-WS or RESTful webservice in A.war and invoke it via http client from B.war
  2. Expose a service as managed bean in A.war and invoke it via JMX from B.war

There are at least two disadvantage of the first approach:

 1. Your webservice becomes available to the public and there is a security risk unless you protect access to that service, if you care about this.
 2. Web service invocation is not free. Marshalling/unmarshalling is required.
 3. You'll have to write a service endpoint class.

But there is an advantage:

 1. You may choose deploy your service to different Tomcat. It will not require much work to reconfigure your services.
 2. You should not care about classloader issues.

Second solution uses existing server infrastructure. It also may cause a security risk if your JMX services are accessible by remote clients. But it is not often a case, or JMX is usually not as vulnerable as HTTP port.
Also, you may not warry about marshalling/unmarshalling or serialisation/deserializartion.

Let's discuss a third solution (JMX) in details.

## Exposing and Accessing Managed Beans with SpringFramework

Tomcat has it's own JMX Server and [SpringFramework][spring] has JMX exporter feature out of the box.

Let's start with simple example.
We'll create first web application `service.war` exposing [`EchoService`](https://gist.github.com/kpavlov/3e19dcec52b56d550e21#file-api-jar-echoservice) via JMX.
Then we'll access that service in a second web application `ui.war` from within a servlet.

Let's create a maven project with 3 modules:

```xml
<modules>
    <module>api.jar</module>
    <module>service.war</module>
    <module>ui.war</module>
</modules>
```
First module, *api.jar*, will contain a service interface, `EchoService` which is pretty simple
(here and later imports are omitted):

```xml
public interface EchoService {

    public static final String MBEAN_NAME = "com.example:type=service,name=EchoService";

    String echo(String input);
}
```

Second module, *service.war*, will contain a [service implementation class](https://gist.github.com/kpavlov/3e19dcec52b56d550e21#file-service-war-echoserviceimpl):

```java
@ManagedResource(objectName = EchoService.MBEAN_NAME)
public class EchoServiceImpl implements EchoService {

    @Override
    @ManagedOperation
    public String echo(String input) {
        return "You said: " + input;
    }
}
```
... as well as Spring configuration file _services-context.xml_:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>
    <context:mbean-export/>

    <bean id="echoService" class="com.example.service.EchoServiceImpl"/>

</beans>
```
Here the [JMX export feature](http://docs.spring.io/spring/docs/3.2.x/spring-framework-reference/html/jmx.html)
of [SpringFramework][spring] is used.

And a _web.xml_ descriptor is:
```xml
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
          http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
         version="3.0">

    <display-name>Servlet 3.0 Web Application</display-name>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:/services-context.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
</web-app>
```
Third module, *ui.war*, will contain a servlet, which will use the service:
```java
@WebServlet(urlPatterns = "/echo/*")
public class EchoServlet extends HttpServlet {

    @Autowired
    private EchoService echoService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this,
                config.getServletContext());
        System.out.println("Servlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        final String input = req.getPathInfo();

        final String output = echoService.echo(input);

        resp.setBufferSize(1024);
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.setContentType("text/plain");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(output);
        resp.getWriter().close();
    }
}
```
spring context configuration _web-context.xml_:
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:util="http://www.springframework.org/schema/util"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd   http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">

        <bean id="echoService" class="org.springframework.jmx.access.MBeanProxyFactoryBean" lazy-init="true">
            <property name="objectName">
                <util:constant static-field="com.example.service.EchoService.MBEAN_NAME"/>
            </property>
            <property name="proxyInterface" value="com.example.service.EchoService"/>
        </bean>

    </beans>
```
_web.xml_ descriptor:
```xml
    <web-app xmlns="http://java.sun.com/xml/ns/javaee"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
              http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
             version="3.0">

        <display-name>Servlet 3.0 Web Application</display-name>

        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>WEB-INF/web-context.xml</param-value>
        </context-param>

        <listener>
            <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
        </listener>
    </web-app>
```
When those two webapps are deployed to tomcat, a new JMX bean is created:
![EchoService exposed as Managed Bean](/assets/2014/05/tomcat-mbean-service.png)

and service is accessible from the servlet:
![EchoServlet showing results of EchoService invocation](/assets/2014/05/tomcat-service-invoked.png)

### Module dependencies

All web modules should depend on _api.jar_ module, because it contains a service interface.

While your service method signatures contains only standard java classes, available across the Tomcat server,
you may not care about classloading issues. In this case both _service.war_ and _ui.war_ should contain _api.jar_ as a dependency in their `WEB-INF/lib` directory.

But if you want to return from your service method some custom class,
you'll need to put that class to _api.jar_ and place that JAR to `${catalina.base}/lib` folder to make that classes available to all web applications. In this case _api.jar_ should be declared as _provided_ dependency in webapp modules.

Having sharing classes in a common classloader eliminates the need of data serialization/deserialization.

Sources from this article you may find [here][gist].

[tomcat]: http://tomcat.apache.org "Apache Tomcat"
[spring]: http://springframework.org
[gist]: https://gist.github.com/kpavlov/3e19dcec52b56d550e21
