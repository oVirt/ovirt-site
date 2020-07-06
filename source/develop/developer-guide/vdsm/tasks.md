---
title: Vdsm tasks
category: vdsm
authors: ybronhei
---

# Vdsm tasks

## oVirt Tasks

oVirt tasks are operations that have states. If an operation can begin, process something and finish it is a Task.

### General Overview

*   Sync operations returns immediately after the request from Vdsm. If failure occurred before the response retrieved, the operation fails. This scenario is not a task from engine prespective.
*   Async Operations are what called a Task are operations that Vdsm and engine contain states for it. Those states mean that the operation needs to pass some actions before returns, when returns the engine needs to read the full operation results and decide if the operation succeeded or failed. Most(\\All) of those operations are storage related. Engine should correlate with Vdsm task's IDs and states to distinguish the result by polling the information.

### Task States

Each operation in Engine starts from a command, each command can trigger sub commands as needed and when the all parts finish the parent gets a notification and finish the operation. For example RemoveVM calls removeAllVMImages that calls removeImage for each VM image. Lets say we have 4 Images for the vm we want to remove, the origin command needs to wait until all of the 4 removeImage finish.

### How We Manage To Do That - Async Task Mechanism

When starting the origin command as a Task we want to keep the internal parameters of it to allow calling to endCommand part when the process is done, as in regular command. When leaving the original command code, the object that holds the command is unused until the subcommands are done their parts. So when all done we need to create the object again and call its endCommand part. For each operation that leads to sub commands and run as a async operation we save the following in the database:

*   parentCommandParameters and parentCommandType – Allows as to create the command again when all sub processes are done.
*   Task ID, Result and AsyncTasksStatus – As returned from VDSM when the operation starts. Status can be [init, running, finished, aborting, cleaning], Results are [success, cleansucess, cleanfailure] (more detailed description in the illustration below).
*   Step ID – For UI purpose. [TODO: missing info]
*   AsyncTaskState – Initializing, Polling, Ended, AttemptingEndAction, ClearFailed, Cleared.

### Internal Implementation In Engine

#### New Design in Engine

[/Wiki/AsyncTaskManagerChanges Async Task Manger](/Wiki/AsyncTaskManagerChanges Async Task Manger)

### Internal Implementation In Vdsm

#### Task Flow

![](/images/wiki/Vdsmtasks.png)
