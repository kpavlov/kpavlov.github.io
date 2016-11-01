---
layout: post
title: Installing Ansible 2.1.1 on Debian 8 (Jessie)
date: 2016-09-09T10:12:48
categories:
  - devops
tags:
  - ansible
  - debian
---

Recently I faced some dependency issues trying to install [Ansible 2](https://ansible.com) on Debian 8 (Jessie).
Googling a bit I found a solution which was a basically to upgrade or install missing dependencies.
Following script automates the installation procedure:
<!--more-->
```bash
sudo apt-get update
sudo apt-get install build-essential libssl-dev libffi-dev python-dev python-pip python-dev git -y
sudo pip install PyYAML jinja2 paramiko
sudo pip install pyasn1 --upgrade
sudo pip install c

git clone https://github.com/ansible/ansible.git
cd ansible

## This is important since core and extra modules are in separate repositories!
git submodule update --init --recursive

## I want to get a stable release, so I checkout a specific tag
git tag -l
git checkout tags/v2.1.1.0-1

## Build Ansible from sources
sudo make install

## If Build fails, then cleanup before retry
sudo make clean

sudo mkdir /etc/ansible
sudo cp ~/ansible/examples/hosts /etc/ansible/
```

## References
 * [Debian 8 - Install Ansible](http://blog.programster.org/debian-8-install-ansible)
 * [Upgrading setuptools version](http://stackoverflow.com/a/19102614/3315474)
 * [Ansible Documentation - Installation](https://docs.ansible.com/ansible/intro_installation.html)
 * [Installing missing 'cryptography' dependencies](http://stackoverflow.com/a/19102614/3315474)
