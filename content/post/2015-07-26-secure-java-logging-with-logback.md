---
layout: post
title: 'Secure Java Logging with Logback'
keywords: java,logging,logback,security
date: 2015-07-26T14:01:33
updated: 2015-09-08T07:51:00
featured: true
categories:
  - programming
tags:
  - security
  - java
  - logging
  - logback
---
Deploying application into secure environment adds some restrictions on logging and log management. [OWASP community](https://www.owasp.org) gives some useful recommendations.

# OWASP Security Testing Guide Recommendations

[OWASP Security Testing Guide][otg] defines a number of questions to be answered when reviewing applciaiton logging configuration (see [OTG-CONFIG-002][otg]):

## 1. Do the logs contain sensitive information?

Log files should not contain any sensitive data. Anyway, log file access must be restricted:

> Event log information should never be visible to end users. Even web administrators should not be able to see such logs since it breaks 
separation of duty controls. Ensure that any access control schema that is used to protect access to raw logs and any applications providing capabilities to view or search the logs is not linked with access control schemas for other application user roles. Neither should any 
log data be viewable by unauthenticated users.

The consequence is that you should not use same authentication mechanism to access application and accessing the log files.

>Also, in some jurisdictions, storing some sensitive information in log files, such as personal data, might oblige the enterprise to apply the data protection laws that they would apply to their back-end databases to log files too. And failure to do so, even unknowingly, might 
carry penalties under the data protection laws that apply.

It's not easy to make sure that no sensitive information is not printed to log. When using [logback][logback] it is possible to conigure [regexp replace pattern](http://logback.qos.ch/manual/layouts.html#replace) to wipe certain data from log files being written, e.g. [mask passwords](http://stackoverflow.com/a/4624952/3315474).

To mask credit card number (PAN) you may use the following expression (`logback.xml`):
~~~xml
<pattern>%-5level - %replace(%msg){'\d{12,19}', 'XXXX'}%n</pattern>
~~~

This expression will replace all numbers with 12 to 19 digits with `XXXX`, so some other data will be masked. 

Another pattern variation honors only 16-digit card numbers (PANs) with selective [first digit](https://en.wikipedia.org/wiki/Bank_card_number#Issuer_identification_number_.28IIN.29) and supports spaces between digit groups:

~~~xml 
<pattern>%-5level - %replace(%msg){'[1-6][0-9]{3}[\s-]?[0-9]{4}[\s-]?[0-9]{4}[\s-]?[0-9]{4}|5[1-5][0-9]{2}[\s-]?[0-9]{4}[\s-]?[0-9]{4}[\s-]?[0-9]{4}', 'XXXX'}%n</pattern>
~~~

Masking PANs with Logback is the last resort to ensure the data is masked with a false-positive hits. It is preferrable to mask the data before it is being written to log in the applciation code.

You may read about securing coding practices in [my next post](/2015/08/01/secure-java-coding-best-practices/ "Secure Java Coding Best Practices"). 

## 2. Are the logs stored in a dedicated server?

It is advised to keep log files on the separate server to prevent removing/cleaning log files by attacker and to ease of centralized log file analysis.

Logback offers [`SocketAppender`](http://logback.qos.ch/manual/appenders.html#SocketAppender) with `SimpleSocketServer` and [`SSLSocketAppender`](http://logback.qos.ch/manual/usingSSL.html) with `SimpleSSLSocketServer` for logging on a remote server instance.

Second option is [`DBAppender`](http://logback.qos.ch/manual/appenders.html#DBAppender) to write logs to the database thus keeping them apart from application instance.

Other option is to use [`SyslogAppender`](http://logback.qos.ch/manual/appenders.html#SyslogAppender) and delegate logging to system syslog service. But is is not secure enougth: in the system will be hacked, the hacker may re-configure syslog not to send any events to remote log server. 

When using a [Logstash][logstash] server, you may send events via [Logstash Logback Encoder](https://github.com/logstash/logstash-logback-encoder). Thare are [handful of appenders](https://github.com/logstash/logstash-logback-encoder#usage).

Also, ypu may consider using [logback-audit](http://audit.qos.ch/) which provides logging vis dedicated log server or directly to the database.

## 3. Can log usage generate a Denial of Service condition?

In case of exceptions on production due to invalid data provided in the request, the exceptions may be printed to logs and cause high IO consumption. This may lead to server unavailability.

### Log Asynchronously

Logback offers some kind of protection against log overhead.
First is using [`AsyncAppender`](http://logback.qos.ch/manual/appenders.html#AsyncAppender) to queue log events and spread the load. Set [queueSize](http://logback.qos.ch/manual/appenders.html#asyncQueueSize) wisely. Default value is 256 which is not enougth.

If you're fine with loosing some less important details then use `AsyncAppender` with [`discardingThreshold`](http://logback.qos.ch/manual/appenders.html#asyncDiscardingThreshold). Uf the event queue has only 20% capacity remaining, events with fine-grained logging category will be dropped.

[Logstash][logstash] provides the [`AsyncDisruptorAppender`][AsyncDisruptorAppender] from the which is similar to logback's `AsyncAppender`, except that a [`LMAX Disruptors`](https://github.com/LMAX-Exchange/disruptor) `RingBuffer` is used as the queuing mechanism, as opposed to a `BlockingQueue` providing higher throughput and less GC overhead. These async appenders can delegate to any other underlying logback appender, including standard Logback file appenders. Set LMAX RingBuffer size wizely. Too low values may cause the the blocking of entire application.

**Think twice before enabling Async Logging!** As far as ensuring that a message has been successfully written before the app continues is concerned, you should not log asynchronously.

### Use Appropriate Logging Levels

Specifying inappropriate log levels in application and appenders may cause excessive load on production server.
You're not going to debug on production, right? Then why you are print valuable data with `DEBUG` level?
On production configuration, default appender's logging level shoud be **INFO**.
If you always need some information - use **INFO** level in the application and use the database to save data like raw requests.
Debugging should be enabled on produciton only in critical situations.

## 4. How are the log files rotated? Are logs kept for the sufficient time?

Log files should be rotated at least daily. Reasonable log history depth is 6 months. Some regulations may require to keep log files longer in case of investigations.

> Some servers might rotate logs when they reach a given size. If this 
happens, it must be ensured that an attacker cannot force logs to rotate in order to hide his tracks.

## 5. How are logs reviewed? Can administrators use these reviews to detect targeted attacks?

Log files can be used for attac detection. For example, the first phases of a SQL injection attack may producte 50x (server errors) or 40x (request errors) messages. 

> Log statistics or analysis should not be generated, nor stored, in the same server that produces the logs. Otherwise, an attacker might, through a web server vulnerability or improper configuration, gain access to them and retrieve similar information as would be disclosed by 
log files themselves.

## 6. How are log backups preserved?

### Make Log Files Append-only

Other type of attack is modification logging configuration file in order to hide the fact of attack.
Use [Mandatory Access Controls](https://en.wikipedia.org/wiki/Mandatory_access_control) on the log file to make it append-only to users of the app, to mitigate the possibility of tampering or removing existing messages.

The simplest way to make files append-only is probably [this](http://unix.stackexchange.com/a/59983): 
 
```bash    
sudo chattr +a *.log
```
or 
```bash    
sudo chattr +a *.log
```

Also don't forget to [set default file attributes](http://unix.stackexchange.com/a/1315/125877) for log directory

```bash 
# owner make the owner to be root and java group
sudo chown root:java /var/log/java
# set uid and gid   
sudo chmod ug+s /var/log/java  
# set group to w default 
sudo setfacl -d -m g::w /var/log/java  
# set nothing to other
sudo setfacl -d -m o::--- /var/log/java
```
### Make Backups
You need to backup the logs, defenitely, as well as other applicaiton data.

You could additionally take periodic backups of the log file to ensure that nothing has been changed or removed between backups. This assumes that access to your backups is also controlled -- a third party who can tamper with your backups can tamper with your log files in an undetectable fashion.

## 7. Is the data being logged data validated (min/max length, chars etc) prior to being logged?

Be carefull what are you writting to logs. Always ask yourself: _"Is it possible to produce big or huge logging output?"_ 

Be carefull when [implementing the method `toString()`](http://www.slideshare.net/KonstantinPavlov/playing-the-tostrings). 
Include only minimum necessary information `in toString()` method.

# Further steps: Protect your logging configuration

Logback configuration can be included inside application (jar file) or be located in external file (`logback.xml`). Hacker may try to modify or remove `logback.xml`.
In order to prevent this attack, `logback.xml` should be:

1. Can not be modified by application user.
2. Monitored by intrusion detection system.
3. Logback auto-reload feature must not be enabled to prevent replacing configuration of the running java applicaiton.

Although auto-reload is very attractive feature of logback, it is reasonable to sacrifice it in favor of security.

[otg]: https://www.owasp.org/images/5/52/OWASP_Testing_Guide_v4.pdf
[logback]: http://logback.qos.ch/
[AsyncDisruptorAppender]: https://github.com/logstash/logstash-logback-encoder/blob/master/src/main/java/net/logstash/logback/appender/LoggingEventAsyncDisruptorAppender.java
[logstash]: http://logstash.net/

