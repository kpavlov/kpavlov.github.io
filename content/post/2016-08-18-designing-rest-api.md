---
layout: post
title: Links on REST API Design
tags:
  - web-services
categories:
  - programming
date: 2016-08-18T22:48:14
---

Here you will find a small collection of links on REST API design.

<!--more-->

- [Designing a Beautiful REST+JSON API](https://www.youtube.com/watch?v=5WXYw4J4QOU) -- In this presentation, Les Hazlewood (@lhazlewood) - Stormpath CTO and Apache Shiro PMC Chair - will share all of the golden nuggets learned while designing, implementing and supporting JSON-based REST APIs, using examples from a clean real-world REST+JSON API built with Java technologies. He covers:
    - JSON-based data formats in a RESTful API
    - References to other JSON-based resources (aka 'linking')
    - Resource collections and pagination
    - How to map (and how not to map) HTTP methods to Resource CRUD
    - Resource partial updates
    - Supporting HTTP Method Overloading for clients that don't support HTTP PUT and DELETE
    - API versioning strategies
    - Meaningful Error responses
    - Many-to-many resource relationships
    - HTTP Caching and Optimistic concurrency control
    - Authentication and Security
  {{% youtube 5WXYw4J4QOU %}}

-  [Secure Your API - Tips for REST + JSON Developers](https://www.youtube.com/watch?v=FeSdFhsKGG0) -- Technical overview on how to secure your API, from Les Hazlewood (@lhazlewood), CTO of Stormpath and PMC Chair of Apache Shiro. (Excerpt from Les' talk on API design at Silicon Valley Java Users Group)
  {{% youtube FeSdFhsKGG0 %}}
- https://stormpath.com/blog/secure-your-rest-api-right-way/
- http://stackoverflow.com/questions/319530/restful-authentication
- https://stormpath.com/blog/designing-rest-json-apis/
- http://docs.stormpath.com/guides/api-key-management/
- http://en.wikipedia.org/wiki/Hash-based_message_authentication_code -- keyed-hash message authentication code (HMAC)
- https://www.coinbase.com/docs/api/authentication
- http://broadcast.oreilly.com/2009/12/principles-for-standardized-rest-authentication.html -- Query Authentication consists in signing each RESTful request via some additional parameters on the URI.
- http://blog.synopse.info/post/2011/05/24/How-to-implement-RESTful-authentication
