---
title: TaskManagerCancelTask
category: feature
authors: mkublin
---

# Task Manager Cancel Task

## Task Cancellation

### Summary

A Task Cancellation it is feature which should allow to cancel currently running tasks. It is not clear which task should be allow to cancel - the whole command or task which is running at vdsm side, what engine should do roll forward or revert

### Owner

*   Name: Michael Kublin
*   GUI Component owner: Michael Kublin
*   REST Component owner: Michael Kublin
*   QA Owner: Yaniv Kaul <ykaul@redhat.com>

### Current status

*   Target Release: 3.2
*   Status: Coding ( Engine-Not started, UI-Not started, API-Not started )
*   Last updated date: 3/12/2012

### Detailed Description

A Task Manager cancellation it is a feature which is build upon Task Manager and should allow to cancel a tasks/jobs/commands

#### Terminology

*   Command - An execution unit which performs a business logic.
*   Job - An action API (RunAction) running in the system. The Job may extend beyond the life cycle of the Command which is the entry point for the action.
*   Step - A meaningful part of the job which the user should be aware of.
*   Task - known as VDSM task, executed by VDSM.

The job supports the following scenarios:

1.  A simple command - a command which consists of 2 steps: validation (*CanDoAction*) and execution.
    -   The job ends when the command of the job ends.

2.  A command with VDSM tasks - a command which consists of 3 steps: validation (*CanDoAction*), execution and finalization (*endAction*).
    -   The job ends when the tasks are reported from VDSM as completed and the command *endAction* is invoked.

3.  A command which invokes internal commands
    -   By default, the internal command will not be presented as a step of the parent command.

4.  A customized command - an asynchronous job which its termination is decided by an event other than tasks. There are few types of scenarios for it:
    -   Commands which implements the *IVdcAsyncCommand* interface - triggered by *VDSBrokerFrontendImpl.RunAsyncVdsCommand*, the command instance is maintained with its context and finalized by the monitors (*VdsUpdateRuntimeInfo*).
    -   Invocation of command in a detached thread, e.g *AddVdsCommand* which delegates job resolution to the internal command *InstallVdsCommand*.
    -   The command execution is ended, but the resolution for the success of the Action is determined by other event in the system:
        -   Other events which reported by the *monitors* (e.g. Host Maintenance reported by *VdsEventListener*).
        -   Requires heuristic decision to select the correct Step for the Job by entity type and entity id associated with the Job.

5.  Multiple Action Runner - describes multiple commands invocation in a single API call. Each command will be reflected as a single job.

#### Requirements

Not defined yet

### Backend

This section describes the backend design for this feature.

#### Entity Description

A new command will be added CancelTaskCommand

##### Enumerators

**Updated Enumerators**
The new value will be added to VdcActionType

##### Annotations

#### DB Design

##### CRUD

#### User work-flows

User will send request to backend for cancel task and backend will try to cancel task. When we are running internal command which parent jobId is cancelled engine can try not to run it. If a job has tasks which is running on vdsm, engine can try to send a Stop/Revert verb to vdsm, at that case by default behaviour all command will be finished as failed.

##### Simple Command Invocation Sequence Diagram

Not provided, not clear what are requirements

##### Async Command Invocation Sequence Diagram

Not provided, not clear what are requirements

#### Events

### REST API

### User Experience

### Installation/Upgrade

### Dependencies / Related Features and Projects

The cancellation of the task is depend on VDSM API, on internal Async task manger, on correct handling of each command and on task monitoring. Most of these mechanism are independent and not related to each other, most of them has a lot of luck and problems in implementation, the cancellation of task which is build upon on it well not work well until those mechanism will be fixed.

### Documentation / External references

### Comments and Discussion

I suppose that a number of races, and unexpected behaviour will be extreme high
I suppose that part of the flows will be difficult or almost impossible to integrate with task cancellation
=== Open Issues ===

1.  What expected API should be called at VDSM side and what it suppose to do?
2.  What should be allowed to cancel? Maintenance host, Migrate VM? Hibernate VM or only storage flows

