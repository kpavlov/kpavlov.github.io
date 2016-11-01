---
layout: post
title: Secure Java Coding Best Practices
date: 2015-08-01T22:22:34
updated: 2015-09-09T07:50:10
featured: true
categories:
  - programming
tags:
  - security
  - java
  - web
---
Making your web application flawless against security attacks is a challenge for every java developer.
In this article I will briefly describe common practical development techniques that can help you to achieve it. 

[OWASP Top 10][owasp-top-10], a list of the 10 Most Critical Web Application Security Risks, includes following risks: 

 * A1 - Injection
 * A2 - Broken Authentication & Session Management
 * A3 - Cross-Site Scripting (XSS)
 * A4 - Insecure Direct Object References
 * A5 - Security Misconfiguration
 * A6 - Sensitive Data Exposure
 * A7 - Missing Function Level Access Control
 * A8 - Cross-Site Request Forgery (CSRF)
 * A9 - Using Components with Known Vulnerabilities
 * A10 - Unvalidated Redirects and Forwards

In this article I will highlight most important java coding techniques for building secure web applications.<!--more-->

## Use SQL Prepared Statements ([A1][a1])

Bind user data to request parameters of the `PreparedStatement`. Never construct dynamic sql queries directly, without escaping parameter escaping.  

Example: 
```sql
SELECT * FROM Users WHERE username = '" +  userName + "'";
```  
The query with input `foo OR 1=1` will select all data from table.

For plain JDBC use:

```java
String query = "SELECT * FROM Users WHERE name = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, userName);
```
For Hibernate use:

```java
String query = "SELECT * FROM USERS WHERE name = :userName";
TypedQuery<User> query = em.createQuery(query, User.class);
query.setParameter(“userName”, userName);
```

## Encode User Data ([A3][a3], [A10][a10])

When rendering user-generated content, always encode it properly. This prevents Cross-Site Scripting (XSS).

* In JSP use [JSTL tags][jstl]
Use `c:out` tag. Attribute `escapeXml` is **"true"** by default, so you may omit it:

```jsp
<c:out value="${variable}"/> 
```

* When using Spring Framework with JSP view, use [Spring's `form` tags](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/view.html#view-jsp)

    ```jsp
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <form:form>
    <table>
        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName" /></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName" /></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="Save Changes" />
            </td>
        </tr>
    </table>
    </form:form>
    ```

* When using Spring Framework with [Freemarker and Velocity](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/view.html#view-velocity), use `bindEscaped` and `form` macros.

## Check Access ([A4][a4], [A7][a7])

Always check data and functional access. Each use of a direct object reference from an untrusted source must include an access control check to ensure the user is authorized for the requested object. 
Spring Security provides the comprehensive methods to implement functional access.
Data access (SQL) usually requires correctly constructing of the SQL query.

## Use HTTP Headers ([A1][a1], [A3][a3])

Use browser headers to prevent XSS and data-injection attacks:

```http
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src https://myhost.com
```

Spring-Security provides a set of [header filters](http://docs.spring.io/autorepo/docs/spring-security/current/apidocs/org/springframework/security/config/annotation/web/builders/HttpSecurity.html) out of the box ():

```java
@Configuration
@EnableWebMvcSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .headers()
                .contentTypeOptions();
                .xssProtection()
                .cacheControl()
                .httpStrictTransportSecurity()
                .frameOptions()
                .and()
            ...;
    }
}
```

### Use Content-Security-Policy Header

[Content-Security-Policy](https://www.owasp.org/index.php/Content_Security_Policy) is an [W3C specification](https://w3c.github.io/webappsec/specs/content-security-policy/) offering the possibility to instruct the client browser from which location and/or which type of resources are allowed to be loaded. To define a loading behavior, the CSP specification use "directive" where a directive defines a loading behavior for a target resource type. 

Directives can be specified using HTTP response header (a server may send more than one CSP HTTP header field with a given resource representation and a server may send different CSP header field values with different representations of the same resource or with different resources) or HTML Meta tag, the HTTP headers below are defined by the specs:

* `Content-Security-Policy` : Defined by W3C Specs as standard header, used by Chrome version 25 and later, Firefox version 23 and later, Opera version 19 and later.
* `X-Content-Security-Policy` : Used by Firefox until version 23, and Internet Explorer version 10 (which partially implements Content Security Policy).
* `X-WebKit-CSP` : Used by Chrome until version 25

The supported directives you may find at [W3C specification](https://w3c.github.io/webappsec/specs/content-security-policy/#directives) page.

As fallback default you may use **`default-src`** directive. It defines loading policy for all resources type in case of a resource type dedicated directive is not defined.

## Use Spring-Security CSRF Protection ([A8][a8])

Spring-Security provides a [CSRF] protection out of the box using [Synchronizer Token Pattern][csrf-token-pattern]:

Configure CSRF token support:

```java
@Configuration
@EnableWebMvcSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf()
                .and()
            ...;
    }
}
```

Include `_csrf.token` hidden field to your forms:

```html
<form action="..." method="post">
<input type="hidden"
    name="${_csrf.parameterName}"
    value="${_csrf.token}"/>
...
</form>
```

## Disable XML External Entity (XXE) Processing ([A1][a1], [A6][a6])

Processing of 

```xml
<?xml version="1.0" encoding="ISO-8859-1"?> 
<!DOCTYPE request [ 
<!ENTITY 
include SYSTEM “file=/etc/passwd"
 > 
]> 
<request> 
<description> 
&include;
 </description> 
... 
</request>
```

The `&include;` will be replaced with a real data, like:

    root:x:0:0:root:/root:/bin/bash
    daemon:x:1:1:daemon:/usr/sbin:/bin/sh

To prevent data exposure ([A6][a6]) and injection ([A1][a1]) disable some [DocumentBuilderFactory][dbf-setFeature] features:

```java
DocumentBuilderFactory dbf = new DocumentBuilderFactory();

dbf.setFeature(javax.xml.XMLConstants.FEATURE_SECURE_PROCESSING);

// Do not include external entities
dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
 
// Disallow DTD inlining by setting this feature to true
dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
```

## Data Protection Coding Practices ([A6][a6])

Without proper server access protection, it is possible to take a whole dump of the process memory with `gdb` (`gdb --pid [pid]`).
So the developer should make an extra steps for securing data stored in memory.

The main idea is to keep sensitive data in memory as less time as possible.

### 1. Never hardcode passwords

**Don't store the passwords/keys in your code.**
Your code should be immediately available to be open-sourced without disclosing any sensitive data.

### 2. Avoid storing sensitive date in a heap

Objects allocated in a Heap memory whereas primitives can be allocated in stack are

Java uses Stack memory is used for execution of a thread. Stack contain method specific values that are short-lived and references to other objects in the heap that are getting referred from the method. Whenever a method is invoked, a new block is created in the stack memory for the method to hold local primitive values and reference to other objects in the method. As soon as method ends, the block becomes unused and become available for next method.
Stack memory size is very less compared to Heap memory. Stack memory is short-lived whereas heap memory lives from the start till the end of application execution.

You can have only values of primitive types (`int`, not an `Integer`) in a stack. So, you'll may need to specially convert the data.

### 3. Use char arrays instead of Strings where possible and wipe (zero) data after use

Consider following class:
```java
   class CreditCard {
      String cardNumber;
      String cvv2;
   }
```
You can't control how java handles the Strings containing card number and cvv2. If the particular string value is used frequently, JVM may decide to do a _string deduplication_:

>String de-duplication reduces the memory footprint of String objects on the Java heap by taking advantage of the fact that many String objects are identical.
Instead of each String object pointing to its own character array, identical String objects can point to and share the same character array.

Consider using following code to control the values explicitly:

```java
class CreditCard {
    private char[] cardNumber;
    private char[] cvv2;
    ...

    public void wipe() {
        if (cardNumber != null) {
            Arrays.fill(cardNumber, 'x');	
        };
        cardNumber = null;
        if (cvv2 != null) {
            Arrays.fill(cvv2, 'x');	
        }
        cvv2 = null;            
    }

    @Override
    protected void finalize() throws Throwable {
        wipe();
        super.finalize();
    }
}
```
Now you can wipe the data when you no longer need it.
Please note that even if you'll call a method `finalize()` explicitly, JVM [will call it again](http://stackoverflow.com/a/28906/3315474). There is no guarantee when finalize will be called by java GC or will it be called at all.  
So, it's better to call `wipe()` explicitly somewhere in the `finally` block.

**UPD: You may wipe a data in a String using Java Reflection (Peter Verhas's solution)**

```java
public static void wipeString(String password) {
    try {
        Field stringValue = String.class.getDeclaredField("value");
        stringValue.setAccessible(true);
        Arrays.fill((char[]) stringValue.get(password), '*');
    } catch (NoSuchFieldException | IllegalAccessException e) {
        throw new Error("Can't wipe string data");
    }
}
```
Following method replaces the content of internal `java.lang.String's` char array field `value` with '*' symbol.
You should call this method explicitly.

### 4. Encrypt data in the heap

Even if you keep sensitive data in a Heap, you can make reading and analyzing more difficult by using any encription. The encryption should be fast enough and not necessary be very strong since the risk is low.

One possible solution is to encrypt sensitive data with a key, generated once per JVM run (e.g. function of system time). When you'll need a decrypted data, use special function to decrypt it. It should be fast enough.
For example, you may use [Blowfish](https://en.wikipedia.org/wiki/Blowfish_%28cipher%29)[^1] ([algorithm performance comparison][encryption_perf]) or even simple [XOR](https://en.wikipedia.org/wiki/XOR_cipher) cipher:

```java
static final int key = (int)(System.currentTimeMillis() + System.nanoTime());
....
int b = a ^ key;
int c = b ^ key;
assert (c == a);
```

> Blowfish is fast symmetric cipher but [not perfect](https://en.wikipedia.org/wiki/Blowfish_(cipher)#Weakness_and_successors). In particular, it is vulnerable to [birthday attack](https://en.wikipedia.org/wiki/Birthday_attack).

### 5. Prevent data duplication

Make your class not-cloneable, non-serializable and non-deserializable. Thus you will protect your data from unexpected / unauthorized duplication.

```java
class CreditCard {
	...

    public final void clone() throws java.lang.CloneNotSupportedException {
		throw new java.lang.CloneNotSupportedException();
    }

    private final void readObject(ObjectInputStream in) throws java.io.IOException {
        throw new java.io.IOException("Class cannot be deserialized");
    }

    private final void writeObject(ObjectOutputStream out) throws java.io.IOException {
            throw new java.io.IOException("Object cannot be serialized");
    }
}
```

### 6. Prevent Logging of Sensitive Data

Secure data may leak to the logs if `toString()` method is implemented incorrectly.
E.g. using [`ToStringBuilder.reflectionToString(...)`](https://commons.apache.org/proper/commons-lang/javadocs/api-3.1/org/apache/commons/lang3/builder/ToStringBuilder.html#reflectionToString(java.lang.Object))

Log files should not contain any sensitive data. It may eventually become accessible to unauthorized persons. You may read about securing your logs with logback in [my previous post](/2015/07/26/secure-java-logging-with-logback/ "Secure Java Logging with Logback").

## Heapdump Prevention (A5)

It is possible to take a snapshot of the memory for further analysis and extracting confidential information.

First of all, **don't run your application on Windows**. Windows is far more vulnerable to the threats than Linux/Unix.

There are several ways to mitigate that risk by disabling some JVM heapdump features:

1. Make sure that java attach mechanism is disabled: `-XX:+DisableAttachMechanism`. Enables the option that disables the mechanism that lets tools attach to the JVM. By default, this option is disabled, meaning that the attach mechanism is enabled and you can use tools such as `jcmd`, `jstack`, `jmap`, and `jinfo`. See [java command line options](http://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html). 

2. Disable heapdump on `OutOfMemoryError`: `-XX:+HeapDumpOnOutOfMemory`. Set heapdump file location to `/dev/null` to avoid saving heapdump: `XX:HeapDumpPath=/dev/null`.
    > Making a heapdump on OOM is not a good idea on production environment. If heap is big enough (a Gigabites) it could take long time to save heap contents to disk. So I suggest using it for load testing only

## Check Your dependencies for known Vulnerabilities ([A9][a9])

* Check [ MITRE Common Vulnerabilities and Exposures Database](http://cve.mitre.org/) regularly.
* Integrate [OWASP Dependency Check tool](https://www.owasp.org/index.php/OWASP_Dependency_Check) into your CI pipeline. Run it daily.
  There is a [maven plugin](http://jeremylong.github.io/DependencyCheck/dependency-check-maven/) which can analyze your project dependencies for known vulnerabilities.
  You may consider adding following profile to your _pom.xml_: 
  
    ```xml
    ...
    <profiles>
        ...
        <profile>
            <id>security-check</id>
            <build>
                <plugins>
                    <plugin>
                        <groupId>org.owasp</groupId>
                        <artifactId>dependency-check-maven</artifactId>
                        <version>1.4.3</version>
                        <executions>
                            <execution>
                                <goals>
                                    <goal>check</goal>
                                </goals>
                                <phase>validate</phase>
                            </execution>
                        </executions>
                    </plugin>
                </plugins>
            </build>
        </profile>
        ...
    </profiles>
    ```

---

The list is not comprehensive, comments and suggestions are always welcome.

## References

* [OWASP Top 10][owasp-top-10]
* [Java JM Command Line Options][java-options]
* [Java Heap Memory vs Stack Memory Difference](http://www.journaldev.com/4098/java-heap-memory-vs-stack-memory-difference)
* [Twelve rules for developing more secure Java code][12rules] 
* [Performance Analysis of Data Encryption Algorithms][encryption_perf]
* [OWASP Enterprise Security API](https://www.owasp.org/index.php/Category:OWASP_Enterprise_Security_API) / [ESAPI 2.x on GitHub](https://github.com/ESAPI/esapi-java-legacy) -- ESAPI (The OWASP Enterprise Security API) is a free, open source, web application security control library that makes it easier for programmers to write lower-risk applications. The ESAPI libraries are designed to make it easier for programmers to retrofit security into existing applications. The ESAPI libraries also serve as a solid foundation for new development.
* [Dependency-Check: checking project dependencies][dependency-check]
* [Web App Security - OWASP Top 10 2013](https://speakerdeck.com/drissamri/web-app-security-owasp-top-10-2013) by Driss Amri
* [Java Magic. Part 4: sun.misc.Unsafe](http://mishadoff.com/blog/java-magic-part-4-sun-dot-misc-dot-unsafe/)

[dependency-check]: https://github.com/jeremylong/DependencyCheck
[owasp-top-10]: https://www.owasp.org/index.php/Top_10_2013-Table_of_Contents "OWASP Top 10"
[java-options]: (http://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html).
[12rules]: http://www.javaworld.com/article/2076837/mobile-java/twelve-rules-for-developing-more-secure-java-code.html "Twelve rules for developing more secure Java code"
[encryption_perf]: http://www.cs.wustl.edu/~jain/cse567-06/ftp/encryption_perf/ "Performance Analysis of Data Encryption Algorithms"
[dbf-setFeature]: http://docs.oracle.com/javase/8/docs/api/javax/xml/parsers/DocumentBuilderFactory.html#setFeature-java.lang.String-boolean-
[csrf-token-pattern]: https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)_Prevention_Cheat_Sheet#General_Recommendation:_Synchronizer_Token_Pattern
[jstl]: https://jstl.java.net/ "JSP Standard Tag Library"

[a1]: https://www.owasp.org/index.php/Top_10_2013-A1-Injection
[a2]: https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management
[a3]: https://www.owasp.org/index.php/Top_10_2013-A3-Cross-Site_Scripting_%28XSS%29
[a4]: https://www.owasp.org/index.php/Top_10_2013-A4-Insecure_Direct_Object_References
[a5]: https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration
[a6]: https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure
[a7]: https://www.owasp.org/index.php/Top_10_2013-A7-Missing_Function_Level_Access_Control
[a8]: https://www.owasp.org/index.php/Top_10_2013-A8-Cross-Site_Request_Forgery_%28CSRF%29
[a9]: https://www.owasp.org/index.php/Top_10_2013-A9-Using_Components_with_Known_Vulnerabilities
[a10]: https://www.owasp.org/index.php/Top_10_2013-A10-Unvalidated_Redirects_and_Forwards

