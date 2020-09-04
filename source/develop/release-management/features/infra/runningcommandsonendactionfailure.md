---
title: RunningCommandsOnEndActionFailure
category: feature
authors: yair zaslavsky
---

# Running commands on endAction failure

## Summary

This design discusses the need for running commands during the step of ending action on failure (as a part of rollback mechanism that does not depent on the VDSM verb RevertTask).

## Owner

*   Name: Yair Zaslavsky (Yair Zaslavsky)

## Current status

*   Last updated date: Sun Feb 26 2012

## Motivation

The motivation will be provided by an example (other flows may need this mechanism as well):

*   AddVmFromTemplate command creates a VM based on a given template.
*   The commands invokes internally for each image related with the template a CreateCloneFromTemplate command.
*   CreateCloneFromTemplateCommand invokes the CopyImage VDSM verb.
*   CopyImage is an asynchronous operation, and monitored by an async task.
*   If one of the of the tasks fails, all the sibling tasks should be reverted - this is usually done using the revert task mechanism.
*   The revert task mechanism performs the VDSM verb SPMRevertTask, but for there is no implementation of task reverting for CopyImage at VDSM.
*   Engine-core should implement a mechanism that will know how to issue an "opposite command" to the copy image for each successful sibling task to the failed task.

## Detailed Description

*   All tasks are created with the same entity ID (the cloned VM) ID - as a result, failure in one of them will yield invocation of AddVmFromTemplate.endWithFailure
*   endWithFailure will invoke in turn endWithFailure on each one of the child commands (CreateCloneFromTemplate).
*   CreateCloneFromTemplate will call revertTasks method.
*   The revertTasks method will invoke the RemoveImageCommand, setting the parent command to CreateCloneFromTemplate
*   In order to avoid invocation of CreateCloneFromTemplate.endSuccessfully upon successful image removal, and to invoke the endWithFailure instead the following will be added:

1.  a new field will be introduced to VdcActionParameterBase: ExecutionReason executionReason.
2.  ExecutionReason is an enum with values of REGULAR_FLOW (which is the default value) and ROLLBACK_FLOW (which is the flow for the current described scenario of invoking command from endWithFailure)
3.  AsyncTaskManager code will be changed in such a way that if the parameters include executionReason with value of ROLLBACK_FLOW, even in case of successful execution, endithFailure will be executed.
4.  In order to prevent endless loop of invocation of remove image, due to end less return to CreateCloneFromTemplate, a check for checking if the image exist in DB will be added (RemoveImage will be executed only in case the image does not exist in DB).

*   In order to have ROLLBACK_FLOW value persistent, it will be set on the parameters, prior to the task creation (which creates an entry in async_tasks table with serialized parameters).
*   As tasks are being pollled only during "executeAction" stage (command starts execution) it is required to add task polling at the end of the command that invokes the rollback command (after the rollback command is invoked).
*   The entity ID for which the rollback task is created should be the entity ID of the command creating the rollback command (i.e - destination image ID in case of CreateCloneOfTemplate that invokes RemoveImageCommand which in turn creates a task).

## Benefit to oVirt

Implementing such mechanism will contribute to resource consistency of engine-core, in a sense that no "leftover resources" will remain at VDSM.

## Dependencies / Related Features

Dependencies on features:

Affected oVirt projects:

*   Engine-core


