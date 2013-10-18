---
title: UIRefreshSynchronization
category: feature
authors: awels
wiki_category: Feature
wiki_title: Features/Design/UIRefreshSynchronization
wiki_revision_count: 20
wiki_last_updated: 2014-04-30
---

# UI Refresh Synchronization

### Summary

Solve UI consistency issues related to the UI not being updated when certain actions/events happen.

### Owner

*   Name: [Alexander Wels](User:awels)
*   Email: <awels@redhat.com>

### Current status

*   In progress: Solution implementation in initial stages, dependent on merge of [Features/Design/FrontendRefactor](Features/Design/FrontendRefactor)
*   In progress: Identify existing issues
*   In progress: Design solution based on the existing issue.

# Existing problems

### Actions are not immediately shown in updated UI elements

Quite frequently it happens that one performs an action on lets say a VM, and after the action completes it takes the UI a few seconds to show the updated status. For instance if I delete an existing VM from my grid after I click the ok button, the dialog disappears, as illustrated by the following image.

but it takes a few seconds for VM to be removed from the VM grid, as illustrated by the following image.

This is especially noticeable if you have the refresh of the grid set to 30 or 60 seconds.

### The event log is updated, but the rest of the UI elements are not

<Category:Feature>
