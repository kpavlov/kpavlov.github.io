---
title: "Jolokia: HTTP/JSON bridge for JMX"
date: 2014-06-09 13:17:37 +0300
comments: true
categories:
  - devops
tags:
  - jmx
  - tomcat
  - java
---
![Jolokia Logo][jolokia-pepper]

Very often there is a need to monitor the Java application server.
For example, external monitoring tool, like Nagious/Zenoss/Zabbix needs to get some metrics, like heap memory usage or thread count.

Usual way to get that metrics is to setup access to application server via JMX.

But, sometimes, it is not possible to leave some other port opened for JMX and the only port available is HTTP(80 or 8080) or HTTPS(443 or 8443).

Here the [Jolokia][jolokia] comes to rescue!
<!--more-->

Jolokia is a HTTP/JSON bridge for JMX server. It can be deployed as web archive (.war) to servlet container and expose MBeans via HTTP.

Also, it is quite lightweight - only 285K for webarchive.

## Configuration

Here is a small instruction how to get an access to JMX beans in [Tomcat][tomcat] via [Jolokia][jolokia].

1. [Download](http://www.jolokia.org/download.html) `jolockia.war` and deploy it to servlet container.
2. Run in command line:
{{< highlight bash >}}
$ curl localhost:8080/jolokia/read/java.lang:type=Memory/HeapMemoryUsage
{"request":{"mbean":"java.lang:type=Memory","attribute":"HeapMemoryUsage","type":"read"},"value":{"init":536870912,"committed":514850816,"max":514850816,"used":132049768},"timestamp":1402310991,"status":200}
$ curl localhost:8080/jolokia/read/java.lang:type=Memory/HeapMemoryUsage/used
{"request":{"path":"used","mbean":"java.lang:type=Memory","attribute":"HeapMemoryUsage","type":"read"},"value":132049736,"timestamp":1402310735,"status":200}
{{< /highlight >}}
You may also use your browser to see JSON response. I suggest installing [JSON Fromamter][json-formatter-extension] for better view. ![](/assets/2014/06/jolokia-heap.png)

 3. Now you can configure your monitoring software to ping server periodically and parse "value" attribute from JSON response.

Released version of Jolokia are available in [central maven repository][jolokia-maven]:
{{< highlight xml >}}
<dependency>
	<groupId>org.jolokia</groupId>
	<artifactId>jolokia-war</artifactId>
	<version>1.2.1</version>
</dependency>
{{< /highlight >}}

Also, Jolokia provides OSGi, Mule and JVM [agents](http://www.jolokia.org/reference/html/agents.html) as well as Webarchive (War) agent.

## Links

* [Jolokia Project Home][jolokia]
* [Jolokia Project on GitHub][jolokia-github]

 [jolokia]: http://www.jolokia.org "Jolokia Project"
 [jolokia-github]: https://github.com/rhuss/jolokia "Jolokia on GitHub"
 [jolokia-pepper]: https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/BhutJolokia09_Asit.jpg/640px-BhutJolokia09_Asit.jpg
 [jolokia-maven]: https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.jolokia%22
 [json-formatter-extension]: https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa "JSON Formatter Chrome Extension"
 [tomcat]: /tags/tomcat
