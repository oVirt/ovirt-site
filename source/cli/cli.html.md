---
title: CLI
category: cli
authors: j.bittner, jfenal, mgoldboi, michael pasternak, val0x00ff
wiki_category: CLI
wiki_title: CLI
wiki_revision_count: 83
wiki_last_updated: 2014-03-24
---

oVirt CLI package is a command line interface for the oVirt engine.

[Notes from workshop in November 2011](API - oVirt workshop November 2011 Notes).

__TOC__

# CLI Concepts

*   Generic interface (list, show, create, update, action verbs).
*   Interactive prompt
*   Auto-completion.
*   Self descriptive.

# Repository

*   <git://gerrit.ovirt.org/ovirt-engine-cli>

# Usage

### Help

![](help.jpg "help.jpg")

### Running Query

![](query.jpg "query.jpg")

### Creating resource

![](create.jpg "create.jpg")

### Updating resource

![](update.jpg "update.jpg")

### Performing action on resource

![](action.jpg "action.jpg")

# TODO list

### parameters formatting

#### generic parameters asignment

       - right now parameters assign to parameters classes by static
         mapping in metadata, it should be done in a generic way.

### infrastructure

<Category:CLI>
