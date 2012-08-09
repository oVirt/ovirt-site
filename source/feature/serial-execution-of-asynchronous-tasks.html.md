---
title: Serial Execution of Asynchronous Tasks
category: feature
authors: amureini, derez
wiki_category: Feature
wiki_title: Features/Serial Execution of Asynchronous Tasks
wiki_revision_count: 6
wiki_last_updated: 2014-07-13
---

**THIS DRAFT IS UNDER CONSTRUCTION. PLEASE DO NOT EDIT IT UNTIL THIS NOTE IS REMOVED**

# Serial Execution of Asynchronous Tasks

### Summary

Currently, oVirt Engine has an abilitty to run an asynchronous task on the SPM. When the task completes, AsyncTaskManager re-creates the command and calls its EndAction(), which is pivoted to EndSuccessfully() or EndWithFailure(), depending on the result of the SPM task. This feature aims to extend this behaviour to allow an engine command to fire a series of aysnchronous SPM tasks in order to allow complex flows (e.g., Live Storage Migration, proper error handling in Move Disk) to be implemented.

### Owner

*   Name: [ Allon Mureinik](User:amureini)
*   Email: amureini@redhat.com

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated date: ...

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
