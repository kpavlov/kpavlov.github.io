---
title: JDBC Driver Settings for Oracle RAC
date: 2014-12-07T21:22:41
categories:
  - programming
tags:
  - java
  - oracle
---
If you are modifying your java application to use Oracle Real Application Clustered (RAC) Database instead of standard single-node database server (Express or Standard edition), then you need to modify settings of your JDBC driver.
<!--more-->

## Oracle Thin Driver

Oracle thin driver's jdbc URL needs to be changed:

    jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(LOAD_BALANCE=OFF)(FAILOVER=ON)
    (ADDRESS=(PROTOCOL=TCP)(HOST=tst-db1.myco.com)(PORT=1604))
    (ADDRESS=(PROTOCOL=TCP)(HOST=tst-db2.myco.com)(PORT=1604)))
    (CONNECT_DATA=SERVICE_NAME=mydb1.myco.com)(SERVER=DEDICATED)))

Also, it is highly recommended to use LDAP directory server instead of hardcoding hostnames into configuration directly:

> The point of a tnsnames file, the older Oracle Names server, and the newer, recommended LDAP directory server method of resolving database names is to avoid having to hardcode hostnames, addresses, ports, etc. into your connection string. The DBAs should be able to move the database to a new host or port without breaking anything. The best way to set your thin connect URL is with the following syntax:
>
    jdbc:oracle:thin:@ldap://<OID server name>:<OID port>/<DB SID or Service Name>,cn=OracleContext,dc=<yourdomain>

[stackoverflow][stackoverflow-jdbc-url]

## Links

More detailed information on configuring JDBC driver for RAC you may find on the Oracle's site:

 - [Using UCP RAC Features][ucp-rac-features]
 - [OCI JDBC Driver Specific Features][oci-features]
 - [JDBC Developer's Guide][ojdbc]
 - [Universal Connection Pool(UCP) for JDBC Developer's Guide][ojdbc]

[oci-features]: https://docs.oracle.com/database/121/JJDBC/instclnt.htm#JJDBC28217
[ucp-rac-features]: https://docs.oracle.com/database/121/JJUCP/rac.htm#JJUCP8197 "UCP RAC Features"
[ojdbc]: https://docs.oracle.com/database/121/JJDBC/ "Database JDBC Developer's Guide"
[ucp]: https://docs.oracle.com/database/121/JJUCP/ "Universal Connection Pool for JDBC Developer's Guide"
[stackoverflow-jdbc-url]: http://stackoverflow.com/questions/1646630/jdbc-what-is-the-correct-jdbc-url-to-connect-to-a-rac-database
