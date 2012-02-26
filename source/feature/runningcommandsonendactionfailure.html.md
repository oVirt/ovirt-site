---
title: RunningCommandsOnEndActionFailure
category: feature
authors: yair zaslavsky
wiki_category: Feature
wiki_title: Main Page/features/RunningCommandsOnEndActionFailure
wiki_revision_count: 6
wiki_last_updated: 2012-02-28
---

# Running commands on endAction failure

### Summary

This design discusses the need for running commands during the step of ending action on failure (as a part of rollback mechanism that does not depent on the VDSM verb RevertTask).

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>

### Current status

*   Last updated date: Sun Feb 26 2012

### Motivation

The motivation will be provided by an example (other flows may need this mechanism as well):

*   AddVmFromTemplate command creates a VM based on a given template.
*   The commands invokes internally for each image related with the template a CreateCloneFromTemplate command.
*   CreateCloneFromTemplateCommand invokes the CopyImage VDSM verb.
*   CopyImage is an asynchronous operation, and monitored by an async task.
*   If one of the of the tasks fails, all the sibling tasks should be reverted - this is usually done using the revert task mechanism.
*   The revert task mechanism performs the VDSM verb SPMRevertTask, but for there is no implementation of task reverting for CopyImage at VDSM.
*   Engine-core should implement a mechanism that will know how to issue an "opposite command" to the copy image for each successful sibling task to the failed task.

### Detailed Description

### Benefit to oVirt

Implementing such mechanism will contribute to resource consistency of engine-core, in a sense that no "leftover resources" will remain at VDSM.

### Dependencies / Related Features

Dependencies on features:

Affected oVirt projects:

*   Engine-core

### Comments and Discussion

<Category:Feature>
