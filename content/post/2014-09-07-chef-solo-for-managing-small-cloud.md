---
title: "Chef for Managing Small Cloud Infrastructure"
date: 2014-09-07T11:37:12
comments: true
categories:
 - devops
tags:
 - linux
---

I need to manage a small [cloud server infrastructure][ref-link].
I have no intention to edit configs by hand all the time, nor write deployment scripts myself.

Instead, I'll give a chance to [Chef-Solo][chef-solo] -- a smaller sibling of well-known configuration management tool Chef.
<!--more-->

I'm considering using a chef-client with [`--local-mode`][chef-client-local-mode], which requires _chef-zero_ which acts as local chef-server.

Chef-Solo uses a local repository to get receipts or can download receipt archive (tar.gz) from remote URL.

To manage configurations Chef uses _Cookbooks_ and _Receipts_.
A cookbook is the fundamental unit of configuration and policy distribution. A cookbook defines a scenario, such as install and configure MySql.
A receipt is a fundamental configuration element, which defines how to configure each part of the system.
Receipts are stored within a cookbooks and can be included into another receipts, allowing reuse.

OpsCode (the guys who supports Chef) supports a [repository of cookbooks][opscode-repo].

## Some Usefull Links

- [Chef Server vs Chef-Solo][server-vs-solo]
- [What are the benefits of running Chef-Server instead of Chef-Solo?][benefits]
- [Chef Solo tutorial: Managing a single server with Chef][solo-tutorial]
- [Deploy a basic lamp stack to Digital Ocean with Chef Solo][chef-digitalocean]
- [OpsCode Cookbook Repository][opscode-repo]

[chef-solo]: https://docs.getchef.com/chef_solo.html
[ref-link]: https://www.digitalocean.com/?refcode=3560cbe19651
[solo-tutorial]: http://www.opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/
[server-vs-solo]: https://serverfault.com/questions/514104/chef-server-vs-chef-solo
[benefits]: https://serverfault.com/questions/283470/what-are-the-benefits-of-running-chef-server-instead-of-chef-solo/403612#403612
[chef-client-local-mode]: https://docs.getchef.com/ctl_chef_client.html#run-in-local-mode
[chef-digitalocean]: http://adamcod.es/2013/06/04/deploy-a-basic-lamp-stack-digital-ocean-chef-solo.html
[opscode-repo]: https://community.opscode.com/cookbooks
