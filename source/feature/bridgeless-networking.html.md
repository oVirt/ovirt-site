---
title: Bridgeless Networking
category: feature
authors: fabiand
wiki_category: Feature
wiki_title: Features/Node/Bridgeless Networking
wiki_revision_count: 2
wiki_last_updated: 2013-06-06
---

# Bridgeless Node Networking

### Summary

This feature will allow Node to not require a bridge in it's network configuration. This change is very wide ranged and needs intensive testing.

### Owner

*   Name: [ Fabian Deutsch](User:fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

### Current status

*   Status: **In Progress**
*   Last updated: ,

### Detailed Description

Up to now the topology looked like:

    Node - Bridge - (Tagged) Nic

In future it can also be:

    Node - (Tagged) Nic

### Benefit to oVirt

Some consumers of oVirt Node don't require the bridge or even conflict with an existing bridge on the system By removing this (up to now) mandatory bridge, we open up Node to more consumers.

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-node
    -   vdsm (possibly)

### Documentation / External references

*   Coming Soon

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Urwid TUI](Talk:Urwid TUI)

<Category:Feature> <Category:Template> <Category:Node>
