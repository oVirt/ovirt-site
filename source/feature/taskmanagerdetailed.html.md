---
title: TaskManagerDetailed
category: feature
authors: lpeer, moti, sandrobonazzola
wiki_category: Feature|TaskManager
wiki_title: Features/TaskManagerDetailed
wiki_revision_count: 101
wiki_last_updated: 2015-01-16
---

## Task Manager

### Summary

A Task Manager is a monitor which shows the current actions running in ovirt-engine and tracks their progress. It also capable of presenting completed commands. The current design describes tasks monitoring and sequential command.
[http://ovirt.org/wiki/Features/TaskManager Task Manager feature page](http://ovirt.org/wiki/Features/TaskManager Task Manager feature page)

### Owner

*   Name: [ Moti Asayag](User:Moti)
*   Email: <masayag@redhat.com>

### Current status

*   Target Release: 3.1
*   Status: Design Review
*   Last updated date: 30/11/2011

### Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their progress and status.
The actions will be represented in the Tasks view of the Webadmin, where the status and progress are monitored. The Task Manager will monitor actions both synchronous and asynchronous tasks.
An action might be a chain of commands depended on each other and monitored in respect to the action which triggered the commands sequence.
 The requirements for feature are as follow:
# Providing a mechanism for tasks management/monitoring via UI (i.e - monitor task status, monitor tasks of given action, stop task, stop all tasks of command, restart of failed command).

1.  Defining a task dependency/task chaining mechanism (Task B will not start before completion of Task A).
2.  Providing a mechanism to invoke commands asynchronously.
3.  Defining a "best effort task" - The success of the parent command of this task will not be dependent on the result of a task).
4.  Providing permission mechanism for the task management.

The feature will also contain some changes that are required internally for backend development and to improve task management functionality and correctness of behavior:

1.  Changing serialization of task parameters to JSON - will ease on tasks flow debugging.
2.  Improving task recovery mechanism - in case JBoss restart (there might be a mismatch between last stored task info and the current task status in VDSM).
3.  Abstracting the Tasks representation in backend (e.g. VDSM, authentication)

#### Entity Description

The following entities/components will be added to the backend:  

**CommandEntity** a representation of a command in the system. Using this entity, a concrete instance inherited of *CommandBase* could be created (e.g. 'resurrection' of a command). **CommandSequence** an entity which composes the *CommandEntity*, representing whether the current command entity is a part of a sequential command (e.g. depended on other commands to be completed before being executed). **CommandRepository** uses to store and fetch command entities from the database. Later implementation might use internal cache for commands in progress and upon completion to flush the 'CommandEntity'' from memory to database.
**CommandDAO** a DAO interface which defines the DML operations for the command entities.
**CommandDAODbFacadeImpl** an implementation of the CommandDAO interface.
**GetCommandsQuery** a query which fetches selective or entire command entities from the database.
**GetModifiedCommandsQuery** a query which fetches only commands which were updated since a given time. It is designed to pull only tasks which where updated since the last query invoked by a client.
**SequentialCommandRunnerFactory** a factory which creates a runner for sequential commands.
**SequentialCommandRunner** a sequential command runner is responsible to to create a sequence of commands which includes order and dependencies (in the future 'best effort' command could be integrated with the sequence creation process) and to invoke the sequence.
**CommandExecuter** an abstraction of command execution method. **SyncCommandExecuter** a synchronous implementation of the *CommandExecuter* interface. Designed to invoke commands synchronously.

**Main Task Manager Class Diagram**
The following class diagrams describe the entities participating in the the Task Manager feature: ![](async-task-main-class-diagram.jpeg "fig:async-task-main-class-diagram.jpeg")

------------------------------------------------------------------------

**Command Entity Class Diagram**
![](command-entity-class-diagram.jpeg "fig:command-entity-class-diagram.jpeg")

**Detailed entity description:**
 <span style="color:Teal">**command_entity**</span> table description:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |entity_id ||UUID ||not null ||The command entity ID |- |entity_name ||String ||not null ||The command entity name |- |command_id ||UUID ||not null ||The associated command ID |- |action_state ||TinyInt ||not null ||The command state |- |owner_id ||UUID ||not null ||The user which triggered the command |- |owner_type ||TinyInt ||not null ||The type user which triggered the command |- |parameters ||text ||not null ||A JSON representation of the parameters associated with the command |- |action_type ||integer ||not null ||A JSON representation of the parameters associated with the command |- |message ||text ||null ||Stores the can-do-action message |- |return_value ||text ||null ||Stores the command return value as JSON |- |visible_to_ui ||bool ||default 'true' ||Describes if current entity should be presented to UI (relevant for sequential command) |- |start_time || Datetime ||not null ||Command start time |- |end_time || Datetime ||null ||Command end time |- |last_update_time || Datetime ||not null ||Command last update time |- |}

<span style="color:Teal">**command_sequence**</span> table description:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |entity_id ||UUID ||not null ||The command entity ID |- |sequence_id ||UUID ||not null ||The sequence ID which the command is part of |- |next_command_id ||UUID ||null ||The next-in-chain command ID |- |order_in_sequence ||integer ||not null ||The order of the command in the sequence |- |initiator_command_id ||UUID ||not null ||The ID of the command which initiated the sequence |- |}

The command entity should be associated with the events related to it. The relation is represented by a map table as described below.
Once the command entity is cleared from the database, there is a need to disable that association (clear the entry from map table as well).

<span style="color:Teal">**command_entity_audit_log_map**</span> table description:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |command_entity_id ||UUID ||not null ||The command entity ID |- |audit_log_id ||UUID ||not null ||The sequence ID which the command is part of |- |}

<span style="color:Teal">**command_entity_sequence_view**</span> A view over command_entity and command_sequence. The view is used for sequence related operations.

#### CRUD

**Stored procedures**

*   <span style="color:#006400">*InsertCommandEntity*</span> - insert command entity entirely
*   <span style="color:#006400">*GetCommandEntityByCommandId*</span> - returns a command entity by a given id
*   <span style="color:#006400">*GetAllCommandEntity*</span> - returns a list of all commands [should be restricted rownum]
*   <span style="color:#006400">*GetAllCommandSinceDate*</span> - returns a list of commands which were modified since a given date
    -   input: a start datetime to search from
    -   output: all commands which their last update date is later than the given date
*   <span style="color:#006400">*UpdateCommandEntity*</span> - updates command entity entirely
*   <span style="color:#006400">*UpdateCommandEntity*</span> - partial updates to the command entity
    -   input: command entity id, status, last update date
*   <span style="color:#006400">*DeleteCommandEntityOlderThanDate*</span> - deletes command entities which are older than a given date.
*   <span style="color:#006400">*DeleteCommandEntity*</span> - deletes specific command entity
*   <span style="color:#006400">*GetCommandTaskInfo*</span> - returns a list of tasks which associated with a command

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

When a user sends a request to the backend for running an action, the backend creates a command by the type and parameters provided by the client. The idea is to create a persisted entity which describes the command so it could be monitored, followed and referred in any step during the command's lifetime till cleared from database.

There are several APIs exposed by the Backend bean which are the entry point of the clients for performing actions or querying the database:

1.  *Backend.RunAction* which is a synchronous command invocation
2.  *Backend.RunMultipleAction* which is a partially synchronous command invocation - the canDoAction validation result is returned to the user and then the commands proceed to execution.
3.  *Backend.RunQuery* a synchronous request to fetch information.

The backend commands are divided into two categories:

1.  Synchronous commands - the command ends when the executeAction ends.
2.  Asynchronous commands - the command is ended when the endAction ends. The endAction is triggered by the AsyncTaskManager when the command tasks are reported as completed.

The following sequence diagrams describe how the new component should interact in order to manage the commands:
 **Sync Command Invocation Sequence Diagram**
![](Sync-action-invocation-sequence-diagram.jpeg "fig:Sync-action-invocation-sequence-diagram.jpeg")
**The sequence above describes invocation of sync-action:**

*   The *Backend* receive a request from a client, provided by action type and parameters.
*   The *Backend* uses the *CommandFactory* for creating a concrete command instance.
*   The *Backend* uses the *CommandRepository* for creating a *CommandEntity*. The new entity is being initialized with status 'Waiting for launch', the command id, type and parameters it represents, command creation time and the user which invoked the command. The *CommandRepository* persist the *CommandEntity* to the database, letting the command queries be noticed about the command in the system.
*   The *Backend* uses the *SyncCommandExecuter* for executing the command in a synchronous method.
*   The *SyncCommandExecuter* invokes the command and returns the command return value to the user.
*   The *CommandBase.executeAction()* updates the status of the command entity to state 'INITIALIZING' and set the last update time to current.
*   Once *CommandBase.canDoAction()* is started, the status of the command entity is updated to 'VALIDATING'.
*   The *CommandBase.Execute()* update the command entity status to 'EXECUTING'.
*   A completion without failure will update the *CommandEntity* status to 'COMPLETED'.

**Async Command Invocation Sequence Diagram**
![](Async-action-type-invocation-sequence-diagram.jpeg "fig:Async-action-type-invocation-sequence-diagram.jpeg")
When command has tasks, it shares the same sequence as the previous sequence, except the last step. The async command will be resurrected by the AsyncTaskManager once there are no more active tasks for the command and will execute the *CommandBase.endAction()* for that command, in which the final state of the command will be set.

#### Events

The events log should be associated with the command which created the event. The association of the command with the events will enable viewing all of the events related to the specific command. Event logs will be created when command tasks (*TaskInfo*) are created.

### Dependencies / Related Features and Projects

The Task Manager is depended on the Internal Locking Mechanism feature [Features/DetailedLockMechanism](Features/DetailedLockMechanism).

### Documentation / External references

### Comments and Discussion

### Open Issues

1.  SearchEngine and command entity - do we wish to add support for this?
2.  

<Category:Template> <Category:Feature>
