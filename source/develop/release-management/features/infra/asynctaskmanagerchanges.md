---
title: AsyncTaskManagerChanges
category: feature
authors:
  - ravi nori
  - yair zaslavsky
---

# Async Tasks improvements

## Summary

This Wiki page is going to summarize required changes for Async Task mechanism.

The current design is still a **draft**. There are other ideas for design for the task manager. The motivations should guide us via the changes process.

## Owner

*   Name: Yair Zaslavsky (Yair Zaslavsky)


## Current status & Motivation

We should invest an ongoing effort to improve our Async Tasks mechanism at engine side.
The following bullets present topics we should handle, based on current status + what we would like to obtain.

*   Modularization - all of Async Tasks code is located at BLL package. We should extract this to a different module/jar
*   Separation of the Async Tasks monitoring (i.e - job/step framework) from the Async Task Management part (AsyncTaskManager class and the VDSM tasks monitoring) - this should be revisited.
*   Task parameters - task parameters are actually parameters of parent commands that invoke the child commands that create the tasks. Upon endAction, there is a calculation at the parent command on the persisted parameters that re-creates the child command parameters and ends them as well.

This mechanism is too complex and is error prone. We should instead persist the commands and their parameters - have a commands table, and for each command keep its parameters.

*   Command objects are re-created at endAction stage - the commands are created using Reflection and the parameters that are associate with the task - once again, this is error prone.

We should reuse command objects, and consider having Commands repository (hold in memory structure to hold ) - commands should be retrieved and re-used from this in memory data structure using their identifier (i.e - command ID)

*   Simultaneous command group vs sequential execution - Currently we have the live storage migration feature which uses the serial execution mechanism - the code of this mechanism should be modified according to other improvements that are suggested in this page.
*   Provide a mechanism for a command to know the number of tasks it is supposed to create - see [this bug](https://bugzilla.redhat.com/show_bug.cgi?id=873546) in order to not have a "premature end" of commands.
*   Handling compensation issues with Async Tasks - for example - <https://bugzilla.redhat.com/873697> (although marked as closed wontfix we should revisit this issue - and make sure that endCommand does not rely on information which may reside at compensation table)
*   Support backwards compatibility of command parameters - currently, due to the fact that Java is strongly typed + we have a hierarchy of command parameters. Changes to parameters classes may yield problems when performing system upgrade in cases where parameters information is persisted based on old parameters class structure, and needs to be deserialized in newer version with newer code of the class.

## Details

This section will provide more details on the highlights explained above.

### Modularization and interfaces

oVirt Engine is dividing into modules. The Async Task Manager code is concentrated mainly in the following modules:

1.  Common - holds the AsyncTasks entity
2.  VdsBroker - holds the communication broker to VDSM + the types of VDS verbs that create tasks.
3.  DAL - holds the DAOs (AsyncTaskManagerDao, JobDao, StepDao)
4.  BLL - the Business logic module that holds the Task Manager code and logic (Adding tasks, Polling, Command completion based on task completion logic and more)

The current module dependency is described by the following diagram: ![](/images/wiki/Async_tasks_original_module_diagram.png)

At first, we should separate Async Task manager logic from bll, and create a new module for it. To create the new module the following steps should be taken care of:

1.  Create a new maven project (the compilation result should be jar)
2.  Create a new package - org.ovirt.engine.core.bll.tasks
3.  Create a new JBoss module - (read about JBoss modules [here](https://docs.jboss.org/author/display/MODULES/Introduction?focusedCommentId=23036152#comment-23036152))

At this point, the modularization diagram should look like: ![](/images/wiki/Async_task_modules_diagram_alternative_a.png)

However, This can be improved by having AsyncTaskManager depends on interfaces , as presented at the following diagram - ![](/images/wiki/Async_tasks_modules_diagram_with_interfaces.png)

At this point , it is the responsibility of BLL to inject/pass Vds Broker and DAO objects to Async TaskManager module.

The last step would be to work with a service locator module that will be responsible for producing VdsBroker and DAO objects both for Bll and AsyncTaskManager. The service locator will also provide an Async Task Manager object to the BLL (hence AsyncTaskManager would require to have an interface as well).

![](/images/wiki/Async_tasks_modules_diagram_with_interfaces_and_service_locator.png)

## Detailed design

### Command Coordinator and interaction with Async Task Manager

Command Coordinator is a new class that is responsible for creating tasks, caching command entities, recieving callbacks from taskmgr and returning status of tasks. The work on the command coordinator will be iterative as well, and this WIKI page will change accordingly. Currently Command Coordinator will accomplish it roles the following way:

1.  Creating new tasks : Most of the code from AsyncTaskManager will be moved to command manager. A new interface Task is passed into the taskmgr from the CommandManager.
2.  Caching commands : Command Entities which contain the parameters, command id and parent command id are cached using CommandEntityDAO. CommandEntityDAOImpl uses ehcache to cache command entities.
3.  DecoratedCommand : We use the decorator pattern to intercept endAction on the command and call handleEndActionResult which was previously called from EntityAsyncTask
4.  CallBack : A new interface with one method endAction. The Command Manager implements this interface and registers itself with the taskmgr. When the command ends the taskmgr calls the endAction method on the callback.
5.  Poller : A new interface Poller with methods for returning the status of tasks. SPMPoller implements this interface and returns statuses by calling RunVdsCommand.

Phase 1 changes "end of command coordination" from "coordination by entity" to "coordination by flow command ID".#

1.  Coordination by entity - this means that all tasks that are related to a given entity (VM, TEMPLATE, DISK) should be ended before the command that initiated the flow that created the tasks (will be addressed as the "flow command") is ended.

The coordination by entity principal is used from previous version, and was introduced prior to the introduction of Command ID (during the development of the compensation feature at 3.0).

1.  Coordination by flow command - this means that all tasks will have access to information on the command that initiated the flow that created them.

End of the flow command will be executed when all tasks that were initiated by the flow are complete (of course, failure or success of tasks affects failure of success of the end of the flow command).

Phase 1 will have to support the two "end of command coordination" approaches (to allow gradual moves). Due to the gradual move, it may be that a child command creating tasks (i.e - RemoveImageCommand) will be used by more than one flow (i.e - RemoveVm, RemoveDisk). Each flow command that uses "coordination by flow command" should be marked (either by annotation or by a method at CommandBase that will be overriden at concrete commands). Indicating that a Command Entity should be created for the command and persisted for it using CommandEntityDAO. For example - for a flow of RemoveVM, the commands table (see further explanations) will have the records for the following commands - RemoveVM, RemoveAllVMImages (child of RemoveVM), N instances of RemoveImage (children of RemoveVM, one per image). The decision on which "end of command coordination" policy should be used can be passed to the child commands using the CommandContext of the command.

For each command that participates in a flow that used "coordination by flow command" the command entity will be kept in the command cache of the Command Coordinator. For each command that participates in a flow that uses "coordination by entity" - the SPM task will be kept at multiTasksByEnitites structure (as in the existing code).

When a task ends , either "SPMASyncTask.onTaskEndSuccess" or "SPMAsyncTask.onTaskEndFailure" will be invoked. These methods will check if there is an entry for the child command that created the task at the commands cache - if the check is positive, "coordination by flow" will be used, otherwise "coordination by entity" will be used.

![](/images/wiki/Async_task_manager_command_mamanger_phase1.png)

### Changed entities

Introduction of CommandEntity which contains the fields:

*   Guid commandId - ID of the command
*   Guid flowCommandId - ID of the command that started the flow that created the command.
*   Serializable data - data associated with the command. This can hold any serializable object (will be stored as JSON at the database). For example - for Phase 1 this can store the command parameters. For storage live migration and other sequential flows it can hold the sequence state.

### Database Changes

Introduction of commands table that will include the following records:

| field name    | field type |
|---------------|------------|
| commandId     | uuid       |
| flowCommandId | uuid       |
| data          | text       |

## Working on the changes

*   Working on the changes of this mechanism should be done in stages in such a way that we can graduately move commands , and not apply the changes to all commands at once.

## Feature tracking

*   Last updated date: Feb 17, 2013

