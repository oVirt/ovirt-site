---
title: AsyncTaskManagerChanges
category: feature
authors: ravi nori, yair zaslavsky
wiki_category: Feature
wiki_title: Wiki/AsyncTaskManagerChanges
wiki_revision_count: 26
wiki_last_updated: 2013-04-10
---

# Async Tasks improvements

### Summary

This Wiki page is going to summarize required changes for Async Task mechanism.

The current design is still a **draft**. There are other ideas for design for the task manager. The motivations should guide us via the changes process.

### Owner

*   Name: [ Yair Zaslavsky](User: Yair Zaslavsky)

<!-- -->

*   Email: yzaslavs@redhat.com

### Current status & Motivation

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

### Details

This section will provide more details on the highlights explained above.

#### Modularization and interfaces

oVirt Engine is dividing into modules. The Async Task Manager code is concentrated mainly in the following modules:

1.  Common - holds the AsyncTasks entity
2.  VdsBroker - holds the communication broker to VDSM + the types of VDS verbs that create tasks.
3.  DAL - holds the DAOs (AsyncTaskManagerDao, JobDao, StepDao)
4.  BLL - the Business logic module that holds the Task Manager code and logic (Adding tasks, Polling, Command completion based on task completion logic and more)

The current module dependency is described by the following diagram: ![](Async_tasks_original_module_diagram.png‎ "fig:Async_tasks_original_module_diagram.png‎")

At first, we should separate Async Task manager logic from bll, and create a new module for it. To create the new module the following steps should be taken care of:

1.  Create a new maven project (the compilation result should be jar)
2.  Create a new package - org.ovirt.engine.core.bll.tasks
3.  Create a new JBoss module - (read about JBoss modules [here](https://docs.jboss.org/author/display/MODULES/Introduction?focusedCommentId=23036152#comment-23036152))

At this point, the modularization diagram should look like: ![](Async_task_modules_diagram_alternative_a.png‎  "fig:Async_task_modules_diagram_alternative_a.png‎ ")

However, This can be improved by having AsyncTaskManager depends on interfaces , as presented at the following diagram - ![](Async_tasks_modules_diagram_with_interfaces.png "fig:Async_tasks_modules_diagram_with_interfaces.png")

At this point , it is the responsibility of BLL to inject/pass Vds Broker and DAO objects to Async TaskManager module.

The last step would be to work with a service locator module that will be responsible for producing VdsBroker and DAO objects both for Bll and AsyncTaskManager. The service locator will also provide an Async Task Manager object to the BLL (hence AsyncTaskManager would require to have an interface as well).

![](Async_tasks_modules_diagram_with_interfaces_and_service_locator.png "Async_tasks_modules_diagram_with_interfaces_and_service_locator.png")

#### Detailed design

The following is a class diagram of Async Task Manager:

![](Async_Task_Manager_class_diagram.png "Async_Task_Manager_class_diagram.png")

A task in the suggested design is used to monitor/control a long duration flow at an external system (i.e - SPM, Gluster, Cinder) A task creation is initiated by a corresponding command at the engine.

*   Task providers and provider logic

Provider is an instance of represenation of external system (i.e - Gluster host, SPM host) that can be used by the task manager to get task information, and to control specific tasks. ProviderLogic implements the logic of how to get the task information and to control a specific task - Several providers that refer to instances of the same external system type have the same ProviderLogic object.

AsyncTaskManager has a methods for registering + providing the initial list of tasks form a provider and for unregistering a specific provider (for example - when "storage pool up event" occurs, the provide method for SPM provider is called).

*   TaskStatusEvent Handler

When engine restarts the CommandManager (which will be discussed later on) is registered as TaskStatusEventHandler at the TaskManager. TaskManager.poll method is being invoked periodically, and for each task status, the proper method at the TaskStatusEventHandler is executed. Currnely only "onTaskEnded" method is implemented.

#### Command Manager

Command Manager is a new class that is responsible for creating tasks, caching command entities, recieving callbacks from taskmgr and returning status of tasks.

1.  Creating new tasks : Most of the code from AsyncTaskManager will be moved to command manager. A new interface Task is passed into the taskmgr from the CommandManager.
2.  Caching commands : Command Entities which contain the parameters, command id and parent command id are cached using CommandEntityDAO. CommandEntityDAOImpl uses ehcache to cache command entities.
3.  DecoratedCommand : We use the decorator pattern to intercept endAction on the command and call handleEndActionResult which was previously called from EntityAsyncTask.
4.  CallBack : A new interface with one method endAction. The Command Manager implements this interface and registers itself with the taskmgr. When the command ends the taskmgr calls the endAction method on the callback.
5.  Poller : A new interface Poller with methods for returning the status of tasks. CommandManager implements this interface and returns statuses by calling RunVdsCommand.

![](CommandManager_class_diagram.png "CommandManager_class_diagram.png")

The changes from the current implementation are:

1.  Parameters - the task entity will no longer have parameters - as they are the parameters of the "Root command" (I.E - the parameters of the command which is first in the hierarchy )
2.  Both the direct parent and the root command Id are kept
3.  SPMAsyncTask should eventually be removed - all its logic should be moved to the AsyncTaskManager implementation and the CommandManager.

### Working on the changes

*   Working on the changes of this mechanism should be done in stages in such a way that we can graduately move commands , and not apply the changes to all commands at once.

### Feature tracking

*   Last updated date: Feb 17, 2013

<Category:Feature> <Category:Template>
