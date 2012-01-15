---
title: CLI
category: cli
authors: j.bittner, jfenal, mgoldboi, michael pasternak, val0x00ff
wiki_category: CLI
wiki_title: CLI
wiki_revision_count: 83
wiki_last_updated: 2014-03-24
---

# CLI

oVirt CLI package is a command line interface for the oVirt engine.

[Notes from workshop in November 2011](API - oVirt workshop November 2011 Notes).

__TOC__

## Maintainer

Michael Pasternak: mpastern@redhat.com

## CLI Concepts

*   Generic interface (list, show, create, update, action verbs).
*   Interactive prompt
*   Auto-completion.
*   Self descriptive.

## Repository

*   <git://gerrit.ovirt.org/ovirt-engine-cli>

## Usage

### Connect

1. access interactive shell

       ovirt-shell

2. issue connect command

       connect "`[`http://host:port/api`](http://host:port/api)`" "user@domain" "password"

### Help

1. help 'COMMAND', e.g:

![](help.jpg "help.jpg")

### Running Query

![](query.jpg "query.jpg")

### Creating resource

![](create.jpg "create.jpg")

### Updating resource

![](update.jpg "update.jpg")

### Performing action on resource

![](action.jpg "action.jpg")

## Deployment

### rpm

To build rpm and install it, from ovirt-engine-cli repo:

      yum install rpm-build

      yum install python-devel

      yum install python-setuptools

      make rpm

      yum localinstall rpmtop/RPMS/noarch/ovirt-engine-cli-x.y-z.noarch.rpm

### local deployment

For local install in site-packages, from ovirt-engine-cli repo:

      yum install python-ply

      python setup.py develop

*   note: both deployment procedures require super-user permissions

## TODO list

*   parameters formatting

<!-- -->

*   generic parameters assignment

       - right now parameters assign to parameters classes by static
         mapping in metadata, it should be done in a generic way.

<Category:CLI>
