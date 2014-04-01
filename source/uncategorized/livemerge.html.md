---
title: LiveMerge
authors: aglitke
wiki_title: LiveMerge
wiki_revision_count: 20
wiki_last_updated: 2014-04-09
feature_name: Live Merge
feature_modules: engine,vdsm
feature_status: Development
---

# Live Merge

### Summary

Live merge makes it possible to delete VM disk snapshots that are no longer needed while the VM continues to run.

### Owners

*   Name: [ Adam Litke](User:AdamLitke) <alitke@redhat.com>
*   Name: [ Greg Padgett](User:GregPadgett) <gpadgett@redhat.com>

### Current status

Design and Development underway

Patches:

*   [LiveMerge: Add Image.getVolumeChain API](http://gerrit.ovirt.org/#/c/25918/)

<!-- -->

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

This feature hides the complexity of the Live Merge flows behind a simple clickable "Delete" button in the UI. This results in a symmetric create/delete snapshot operations regardless of whether the VM is running or not. This feature has been actively requested by users.

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Comments and Discussion

*   Refer to <Talk:LiveMerge>

<Category:Feature> <Category:Template>
