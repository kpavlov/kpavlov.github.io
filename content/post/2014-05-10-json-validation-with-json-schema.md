---
title: "JSON Validation with JSON Schema"
date: 2014-05-10 15:48:12 +0300
comments: true
alias: /2013/10/json-validation.html
categories:
  - programming
tags:
  - java
  - json
---
JSON has became a de-facto standard for webservices, replacing XML web services.
It has native support in web browser clients.

That makes JSON is the standard of choice for UI-oriented services.
It has a good support on mobile devices.
Also, it provides smaller data payload size compared to XML and it's very sufficient for high-load systems as it saves a traffic.
But what is for data validation?
For XML web services there is a XML Schema.
It comes ti mind, that similar standard for JSON should be called ["JSON Schema"](http://json-schema.org/).
And it really exists!

<!--more-->
There are a number of [libraries](http://json-schema.org/implementations.html) for working with JSON Schema, including validators, documentation generators and data processing.

For java, there is a library which implements JSON message validation: [json-schema-validator](https://github.com/fge/json-schema-validator).
It uses [jackson](https://github.com/FasterXML/jackson) library as its' core and can be used in any java environment.

Here is demo application project: [json-schema-validator-demo](https://github.com/fge/json-schema-validator-demo)

Code sample:

```java
import com.fasterxml.jackson.databind.JsonNode;
import com.github.fge.jsonschema.main.JsonValidator;
import com.github.fge.jsonschema.main.JsonSchemaFactory;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.core.util.AsJson;
...

JsonValidator VALIDATOR  = JsonSchemaFactory.byDefault().getValidator();

JsonNode schemaNode = ...
JsonNode data = ...

ProcessingReport report = VALIDATOR.validateUnchecked(schemaNode, data);

final boolean success = report.isSuccess();

final JsonNode reportAsJson = ((AsJson) report).asJson();
```

Demo applicaiton: https://json-schema-validator.herokuapp.com/
