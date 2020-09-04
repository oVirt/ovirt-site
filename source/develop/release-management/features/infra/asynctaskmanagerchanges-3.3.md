---
title: AsyncTaskManagerChanges 3.3
category: feature
authors: yair zaslavsky
---

# Async Task manager changes for oVirt 3.3

## Summary

The following feature page deals with improvements added to the engine async task manager mechanism.

## Owner

*   Name: Yair Zaslavsky


## Current status

*   Last updated date: May 25, 2013

For oVirt 3.3 we would like to improve the current SPM tasks mechanism in the following areas:

*   Better handling of engine/vdsm crashes in cases of mismatch in the number of tasks (expected vs actual running tasks).
*   Providing better mechanism to query if an entity (i.e - StorageDomain, VM, Disk, etc...) has running tasks on.
*   Improving the mechanism for determining whether endAction (the last step of command invocation in case the command/its children created tasks) should be run.

## Detailed Description

### **Better handling of engine crashes in cases of mismatch in the number of tasks (expected vs actual running tasks)**.

*   Problem: Engine can crash, causing a wrong successful completion of commands due to mismatch between expected tasks and created tasks.
*   Example:

RemoveVM is run on a VM with 4 disks. After 2 out of the 4 disks are created at VDSM, and stored at engine, engine crashes. Engine restarts, the command ends successfully although 2 out of the 4 disks were not removed.

*   Detailed explanation of problem:

A parent command (for example - RemoveVmCommand) may create child commands that each one of them in turn creates a task (for example - RemoveImageCommand is a child command that is responsible for creating a task at VDSM for removing one of the images associated with the VM). The tasks information is kept at database at async_tasks table, and is used if engine crashes in order to restore association between tasks and commands and coordinate the endAction execution when all the tasks for the parent command have ended.

Currently, a new record is inserted into the async_tasks table only after the task is created at VDSM (TaskCreationInfo is returned from the VDSBroker with the vdsm tadk ID). The return tasked ID serves as a primary key for the table. If engine crashes- it may be that not all vdsm calls for creating all the tasks were issues, hence not all async_tasks records were added. Engine restarts and both vdsm and engine are aware only to a partial amount of the expected tasks , causing the parent command (for example, RemoveVm) to be successfully completed (for example - RemoveVm is successfully completed when only 2 out of 4 disks where removed).

*   Solution:

The suggested fix will distinguish between the vdsm task ID and the DB task ID, in addition, it will add all the expected tasks at the parent command, in a single transaction - when a VDSM task ID is obtained from vds broker, it will be associated to the proper aync_tasks record. If engine crashes , and for some aysnc_tasks records there is no VDSM task ID (in the given example - for each one of the 4 disks, a async_tasks record is added to the DB, and for 2 out of 4, there is no VDSM taskd ID), the parent command (RemoveVm in the example) will be ended with "failure" state.

### **Providing better mechanism to query if an entity (i.e - StorageDomain, VM, Disk, etc...) has running tasks on.**

*   Problem: The mechanism of querying an entity for running task is limited
*   Example: It is impossible to query for disk entity if there are running tasks, if the command is VM related.
*   Detailed explanation of problem:

Currently there are two mechanisms for querying whether a task is associated with a given entity - a. VdcActionParametersBase which is the base class for all commands parameters has a field that holds the entityID for which the task is created. There is no indication the entity type and in addition, only one entity ID can be associated with the task, so usually this is the top-most entity (VM, Template,Disk). b. async_task_entities table was introduced to overcome the issue - it contains an association between task id, and entity ID (and its type),

for example: 40fd52b-3400-4cdd-8d3f-c9d03704b0aa | 72e3a666-89e1-4005-a7ca-f7548004a9ab | Storage Indicates that task 40fd52b-3400-4cdd-8d3f-c9d03704b0aa is associated with entity 72e3a666-89e1-4005-a7ca-f7548004a9ab which is a storage domain. The current mechanism (both at DAO and BLL ) is incomplete in a sense that only one entity type can be associated with the usage of async_tasks table to varying number of entity IDs.

*   Solution:

The suggested fix will allow association of multiple entity types with multiple entity IDs. This mechanism can help in improving canDoAction checks, and behavior of compensation (for example - don't perform compensation to the initial state, if there are running tasks).

### **Improving the mechanism for determining whether endAction (the last step of command invocation in case the command/its children created tasks) should be run**

*   Problem: Current mechanism of endAction mechanism is limiting
*   Example: Two READ-ONLY commands (tasks that perform READ ONLY storage-related operations) cannot run on the same entity in parallel (Engine will start polling tasks of a command only after the first command has finished).
*   Detailed explanation of problem:

The current mechanism uses the combination of CommandType (i.e RemoveVm) and the entity ID (i.e the ID of the VM) in order to coordinate the execution of endAction when all tasks related for the command (i.e - all tasks created by the children of RemoveVm command are done). The current mechanism is problematic as it prevents the engine to start polling tasks for the same entity of different commands - for example, if there are two READ-ONLY asynchronous operations on the same entity (in case of read/write- this should be handled by canDoAction and the in-memory locking mechanism).

*   Solution:

Reach the decision of whether endAction should be executed based on the parent command Id. Async Task Manager should not postpone polling of commands - for READ-ONLY asynchronous operations there is no point. For write operation - it is the responsibility of canDoAction and the locking mechanism to approve such commands.

## Benefit to oVirt

The benefit for oVirt from these changes is to have better usage of SPM tasks in the system - by giving better handling of cases of engine crashes , providing a better mechanism for execution validation of commands and and to give better association between tasks and the command execution flows.

## Testing

This feature is mostly code change and introduces changes that should be implemented by various commands. Currently, 3 commands/flows in the system use the new mechanism:

*   Hibernate VM
*   Create Template
*   Create snapshot

The things that can be tested are: 1. Test case 1 (Check for regression) Make sure that the 3 commands are normally , as they did in oVirt 3.3 After each flow execution make sure that async_tasks table is clear.

2. Test case 2 (Restart ) Try to restart engine during execution of commands. The commands should not suceed, unless all tasks were executed on VDSM.

## Dependencies / Related Features

These fixes are a part of the on going effort around the Async Task Manager changes. See also [1](/develop/release-management/features/infra/asynctaskmanagerchanges.html)

## Documentation / External references

