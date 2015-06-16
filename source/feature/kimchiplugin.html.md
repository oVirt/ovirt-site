---
title: KimchiPlugin
category: feature
authors: rbarry
wiki_category: Feature
wiki_title: Features/Node/KimchiPlugin
wiki_revision_count: 2
wiki_last_updated: 2013-10-08
---

# Kimchi Plugin

## oVirt Node Kimchi plugin

### Summary

This feature allows the oVirt Node image to provide a web interface through [Kimchi](https://github.com/kimchi-project/kimchi) in order to manage VMs through libvirt directly on the node.

### Owner

*   Name: [ Ryan Barry](User:rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Current status

*   Development 0% complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

Kimchi is a HTML5 interface to KVM designed to make managing KVM easy without libvirt. Currently, oVirt Node images must be registered to an engine in order to provision VMs, but libvirt is functional without using VDSM as an intermediary. A Kimchi plugin would allow for Node images to manage their virtual machines directly.

### Benefit to oVirt

Essentially feature parity with XenServer and ESXi in providing a way to manage VMs on a single node with no external dependencies.

### Dependencies / Related Features

*   [Node Plugins](Node plugins)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-kimchi (Name TBD)

### Documentation / External references

*   Documentation can be found on [Kimchi's homepage](https://github.com/kimchi-project/kimchi)

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Node Kimchi Plugin](Talk:Node Kimchi Plugin)

<Category:Feature> <Category:Template> <Category:Node>
