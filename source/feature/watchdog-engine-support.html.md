---
title: Watchdog engine support
category: feature
authors: doron, lhornyak, mlipchuk
wiki_category: Feature
wiki_title: Features/Watchdog engine support
wiki_revision_count: 48
wiki_last_updated: 2014-06-16
---

# Watchdog support in Engine

### Summary

This feature adds [watchdog](https://en.wikipedia.org/wiki/Watchdog_Card) support to engine.

### Owner

*   Name: [Laszlo Hornyak](User:Lhornyak)
*   Email: <lhornyak at redhat dot com>

### Current status

*   Status: design and discussion
*   Last updated: ,

### Detailed Description

### Benefit to oVirt

Users will be able to add watchdog cards to their virtual machines. This will be especially important for highly available servers.

### Dependencies / Related Features

This feature depends on the VDSM support for the watchdog cards (merged) (where is the documentation for this?)

### Documentation / External references

#### User Interface

![](Neweditserverhawatchdogdisabled.png "Neweditserverhawatchdogdisabled.png")

![](Neweditserverhawatchdogenabled.png "Neweditserverhawatchdogenabled.png")

#### Backend changes

#### Databasechanges

#### REST Api changes

#### VDSM support

VDSM support for watchdog cards is already merged.

### Comments and Discussion

<Category:Feature> <Category:SLA>
