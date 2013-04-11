---
title: Node Puppet Plugin
category: node
authors: rbarry
wiki_category: Feature
wiki_title: Features/Node Puppet Plugin
wiki_revision_count: 2
wiki_last_updated: 2013-04-11
---

# oVirt Node Puppet plugin

### Summary

This feature converts the generic oVirt Node image into an image with support for Puppet provisioning.

### Owner

*   Name: [ Ryan Barry](User:rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Current status

*   Development 90% complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

A server-side puppet provider and type which identifies oVirt and allows for management of the features which can be set with the TUI, as well as a client-side TUI page suitable for configuring puppet parameters.

### Benefit to oVirt

Reduction in the number of kernel command line arguments necessary to automatically provision a node. Tighter integration with existing management infrastructure. Ease of management.

### Dependencies / Related Features

*   [Node Plugins](Node plugins)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-puppet (Name TBD)

### Documentation / External references

*   Coming Soon

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Node Puppet Plugin](Talk:Node Puppet Plugin)

<Category:Feature> <Category:Template> <Category:Node>
