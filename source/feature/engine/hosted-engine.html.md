---
title: Node Hosted Engine
category: node
authors: dougsland, fabiand, jboggs
wiki_category: Feature
wiki_title: Node Hosted Engine
wiki_revision_count: 3
wiki_last_updated: 2014-12-05
feature_name: Node Hosted Engine
feature_modules: node
feature_status: Completed
---

# Node Hosted Engine

### Summary

This feature introduces the ability to setup a hosted engine on an ovirt-node instance

### Owner

*   Name: [ Joey Boggs](User:jboggs)

<!-- -->

*   Email: jboggs AT redhat DOT com
*   IRC: jboggs

### Current status

Completed. Users can deploy Hosted Engine via oVirt Node Text User Interface.

*   Last updated: ,

### Detailed Description

This plugin will pull in ovirt-hosted-engine-setup and dependencies. A plugin page in the setup tui will be available to start the installation process. The screen package will also be pulled in to help with any possible installation disconnection issues.

### Benefit to oVirt

Lowers the bar for getting a engine/node setup up and running with the least amount of hardware

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-hosted-engine-setup
    -   screen

### Documentation / External references

[Hosted Engine documentation](http://documentation-devel.engineering.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.5-Beta/html-single/Installation_Guide/index.html#chap-The_Self-Hosted_Engine) [Feature Page Hosted Engine](http://www.ovirt.org/Features/Self_Hosted_Engine)

<Category:Feature> <Category:Template> <Category:Node>
