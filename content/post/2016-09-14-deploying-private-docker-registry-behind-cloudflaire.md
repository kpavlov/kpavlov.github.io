---
layout: post
title: Deploying Private Docker Registry Behind Cloudflaire
date: 2016-09-14T10:15:51
updated: 2016-09-14T10:26:13
categories:
  - devops
tags:
  - docker
  - nginx
  - cloudflaire
---

This is a short instruction how to deploy private docker registry on private cloud virtual servers behind [Cloudflaire][cloudflare] proxy.
<!--more-->
Suppose, we have two virtual servers on private cloud:

 * WAF (web application firewall) with Nginx installed
 * Internal server which will host a Docker private registry.

Cloudflaire will serve as HTTPS proxy and forward unencrypted traffic to private WAF which will provide authentication and authorization and dispatch user requests to docker registry server.

## 1. Start docker registry server on internal docker host

Login to your virtual server and start docker registry:

    docker run -d -p 5000:5000 --restart=always --name registry registry:2

Setup firewall to allow access to docker registry server from WAF

    iptables -A INPUT -p tcp -s <waf-ip> -i eth1 --dport 5000 -m state --state NEW,ESTABLISHED -j ACCEPT

## 2. Configure Nginx on WAF

We need to setup BASIC authorization and request forwarding:

Create password for your docker user (`dockeruser`) basic authentication on nginx.

    sudo htpasswd -c /etc/nginx/.htpasswd dockeruser

`htpasswd` you may find in the package apache2-utils (`sudo yum -y install apache2-utils`)


Now configure nginx (`/etc/nginx.conf`):

```nginx

server {
    listen          80;       # Listen on port 80 for IPv4 requests

    server_name r.newage.io;

    ignore_invalid_headers off;

    location / {

        # disable any limits to avoid HTTP 413 for large image uploads
        client_max_body_size 0;

        # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
        chunked_transfer_encoding on;

        add_header                  Docker-Distribution-Api-Version registry/2.0 always;
        auth_basic                  "Restricted";
        auth_basic_user_file        /etc/nginx/.htpasswd;
        proxy_pass                  http://<upstream-host>:5000/;

        proxy_set_header            X-Original-URI       $request_uri;
        proxy_set_header            Proxy                "";
        proxy_set_header            Host                 $host;
        proxy_set_header            X-Real-IP            $remote_addr;
        proxy_set_header            X-Forwarded-For      $proxy_add_x_forwarded_for;
        proxy_set_header            X-Forwarded-Proto    "https";
        proxy_read_timeout          900;
        proxy_max_temp_file_size    0;
    }
}
```
and reload nginx configuration:

    sudo nginx -s reload

## 3. Configure Cloudflaire

Now we need to login to [cloudflaire][cloudflare] console, create DNS A-record pointing to your WAF server-ip

    registry.mydomain.com => WAF public IP

Also we need to setup "Always Use HTTPS" [page rule](https://support.cloudflare.com/hc/en-us/articles/224509547-Recommended-Page-Rules-to-Consider) for the domain.

## 4. Testing repository

Execute from your local machine:

```
$ docker login -u=dockeruser -p=secret https://registry.mydomain.com
Password:
Login Succeeded
$ docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world

c04b14da8d14: Pull complete
Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
Status: Downloaded newer image for hello-world:latest
$ docker tag hello-world:latest registry.mydomain.com/hello-world:latest
$ docker push registry.mydomain.com/hello-world:latest
The push refers to a repository [registry.mydomain.com/hello-world]
a02596fdd012: Pushed
latest: digest: sha256:a18ed77532f6d6781500db650194e0f9396ba5f05f8b50d4046b294ae5f83aa4 size: 524
```

## References

 * [Authenticating proxy with nginx](https://docs.docker.com/registry/recipes/nginx/)
 * [Running Secured Docker Registry 2.0](http://container-solutions.com/running-secured-docker-registry-2-0/)
 * [StackOverflow: docker authentication issue](http://stackoverflow.com/a/39483840/3315474)

[cloudflare]: https://www.cloudflare.com
