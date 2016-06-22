---
title: Serial Execution of Asynchronous Tasks Detailed Design
category: detailedfeature
authors: amureini
wiki_category: DetailedFeature
wiki_title: Features/Serial Execution of Asynchronous Tasks Detailed Design
wiki_revision_count: 11
wiki_last_updated: 2012-08-29
---

# Serial Execution of Asynchronous Tasks Detailed Design

## Summary

Currently, oVirt Engine has an abilitty to run an asynchronous task on the SPM. When the task completes, AsyncTaskManager re-creates the command and calls its EndAction(), which is pivoted to EndSuccessfully() or EndWithFailure(), depending on the result of the SPM task. This feature aims to extend this behaviour to allow an engine command to fire a series of aysnchronous SPM tasks in order to allow complex flows (e.g., Live Storage Migration, proper error handling in Move Disk) to be implemented.

See also the [main feature page](Features/Serial Execution of Asynchronous Tasks).

## Owner

*   Name: [ Allon Mureinik](User:amureini)
*   Email: amureini@redhat.com

## Current status

*   Target Release: 3.1
*   Status: Design Review
*   Last updated date: 09/08/2012

## Detailed Description

This feature will break the coupling where an engine command equals an SPM task. It will allow the engine to manage complicated asynchronous flows, possibly across several hosts.

### Entity Description

![](SEAT_classes.png "SEAT_classes.png")

#### SPMAsyncTask

A new property, executionIndex (int) will be added, to signify the position of this task in a command's flow.

#### SPMAsyncTaskHandler

This new entity will represent how oVirt engine handles a single SPMAsyncTask, instead of how it's handled by CommandBase today. Its methods:

*   beforeTask - the execution carried out on the engine side before firing an async task. This is analogous the today's executeAction() body, and includes updating BEs and persisting them in the databsae.
*   createTask - how to create the async task
*   endSuccessfully - the code to run when a task ends successfully
*   endWithFailure - the code to run when a task ends unsuccessfully
*   compensate - the code to run if a completed task needs to be undone - see below.

#### CommandBase

CommandBase will hold a List of SPMAsyncTaskHandler to manage executing of SPMAsyncTasks Basically, execute() will iterate over the handlers and execute each. See details below.

#### EntireCommandSPMAsyncTaskHandler

This is a dummy class to mimic the old behavior of command base under the new design. It holds a reference to the wrapping CommandBase object and implemented SPMAsyncTaskHandler as follows:

*   beforeTask - calls CommandBase.executeAction()
*   createTask - returns null - is handled in the beforeTask()
*   endSuccessfully - calls CommandBase.endSuccessfully()
*   endWithFailure - calls CommandBase.endWithFailure()
*   compensate - empty, implemented in endWithFailure()

### CRUD

SPMAsyncTask's CRUD operations should consider the new property. Other objects do not have interesting CRUD operations.

### User Experience

N / A

### Installation/Upgrade

N / A

### User work-flows

Flow chart: ![](SEAT_flow.png "fig:SEAT_flow.png")

DFD: ![](SEAT_DFD.png "fig:SEAT_DFD.png")

#### Successful Execution

instead of calling executeCommand() CommandBase will iterate over its SPMAsyncTaskHandlers and execute them. The defalut EntireCommandSPMAsyncTaskHandler will simply call the command's executeAction for backwards compatibility. For each one, CommandBase calls beforeTask(), and then fires an SPM command according to createTask(). When the command ends, AsyncTaskManager wakes up the handler, and it runs endSuccessfully(). CommandBase then starts the process over again with the next handler.

Note: the treatment of HSM commands remains synchronious, as has no bearing on this proposed feature's design.

#### Unsuccessful Execution

See the execution flow above. When an SPM task fails, the relevant handler is awoken, and it calls endWithFailure(). CommandBase then iterates in a *reverse* order, and calls each handler's compensate.

### Events

#### JBoss Restart/Crash

When JBoss starts, task polling is restarted (as before this change). The only change is that now tasks are now persisted with their executionIndex, so when a tasks completes the command issuing it can be resumed from the correct place.

## Dependencies / Related Features and Projects

Live Storage Migration depends on this feature. This feature will also allow for better error handling in various Move Disk scenarios.

## Documentation / External references

N / A at the moment

## Comments and Discussion

<Talk:Features/Serial_Execution_of_Asynchronous_Tasks_Detailed_Design>

## Open Issues

N / A

