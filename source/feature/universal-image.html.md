---
title: Universal Image
category: feature
authors: mburns
wiki_category: Feature
wiki_title: Features/Universal Image
wiki_revision_count: 5
wiki_last_updated: 2013-05-22
---

The actual name of your feature page should look something like: "Your feature name". Use natural language to [name the pages](How to make pages#Page_naming).

# Universal oVirt Node Image

### Summary

This feature converts the oVirt Node image into a generic image that can be customized for many different projects using [Node Plugins](Node_plugins).

### Owner

*   Name: [ Mike Burns](User:mburns)

<!-- -->

*   Email: mburns AT redhat DOT com
*   IRC: mburns

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

A number of requests to use oVirt Node in projects other than oVirt have been received. This feature is the conversion of oVirt Node into a generic image that can be customized for use in other projects using specialized Plugins. A separate feature for moving the logic for working with oVirt Engine into a plugin is also filed [here](Features/Node_vdsm_plugin)

### Benefit to oVirt

Making oVirt Node more generic and available to other projects widens the user base for the model that oVirt Node uses. This model will then get additional testing and use outside of the oVirt Project and thus be more stable in the long term.

### Dependencies / Related Features

*   [Node VDSM Plugin](Features/Node_vdsm_plugin)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-image
    -   New Package for the plugin

### Documentation / External references

*   Coming Soon

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Universal Image](Talk:Universal Image)

<Category:Feature> <Category:Template> <Category:Node>
