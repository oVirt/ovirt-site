---
title: Node Diagnostic Page
category: node
authors: rbarry
wiki_category: Feature
wiki_title: Features/Node Diagnostic Page
wiki_revision_count: 1
wiki_last_updated: 2013-04-11
---

# oVirt Node Diagnostic Page

### Summary

This feature adds a diagnostic page for the TUI where users can view basic information without dropping to a shell. In addition, it adds scrollbars to widgets with long lists.

### Owner

*   Name: [ Ryan Barry](User:rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Current status

*   Development complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

A diagnostic TUI page where output from commands (currently: fdisk -l, parted -l, multipath -ll) can be viewed without going to the shell. Addition of scrollbars to TableWidgets in the TUI, and creation of a new ScrollBox TUI class.

### Benefit to oVirt

Reduction in need to leave the TUI to diagnose problems. The ScrollBox and scrollbar abrogate the need to suspend the UI to display long output from commands, and give the user an indication of length.

### Dependencies / Related Features

*   [Node Plugins](Node plugins)
*   Affected Packages
    -   ovirt-node

### Documentation / External references

*   Coming Soon

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Node Diagnostic Page](Talk:Node Diagnostic Page)

<Category:Feature> <Category:Template> <Category:Node>
