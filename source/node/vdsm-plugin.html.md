---
title: Node vdsm plugin
category: node
authors: mburns
wiki_category: Feature
wiki_title: Features/Node vdsm plugin
wiki_revision_count: 5
wiki_last_updated: 2013-05-23
---

# Node vdsm plugin

## oVirt Node VDSM plugin

### Summary

This feature converts the generic oVirt Node image into an image customized use with oVirt Engine.

### Owner

*   Name: [ Mike Burns](User:mburns)

<!-- -->

*   Email: mburns AT redhat DOT com
*   IRC: mburns

### Current status

*   Initial code base uploaded, initial test images [available](http://resources.ovirt.org/releases/node-base/beta/iso/), should be ready for oVirt 3.3 beta
*   Last updated: 2013-05-22

### Detailed Description

An offshoot of the [Universal Node Image](Features/Universal Image) feature. This plugin can be used to convert a generic oVirt Node image into an image ready for use with oVirt Engine.

### Benefit to oVirt

Because of the [Universal Node Image](Features/Universal Image) feature, there would be no more oVirt Node image available with the oVirt Project. This plugin is simply the moving of the logic for interacting with oVirt Engine from oVirt Node into a plugin.

### Dependencies / Related Features

*   [Universal Node Image](Features/Universal Image)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-vdsm (Name TBD)

### Documentation / External references

*   Coming Soon

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Node vdsm plugin](Talk:Node vdsm plugin)

<Category:Feature> <Category:Template> <Category:Node>
