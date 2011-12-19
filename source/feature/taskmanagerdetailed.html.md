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
    -   Email: <masayag@redhat.com>
*   Name: [ Yair Zaslavsky](User:Yair)
    -   Email: <yzaslavs@redhat.com>
*   GUI Component owner: Gilad Chaplik <gchaplik@redhat.com>
*   REST Component owner: Michael Pasternak <mpasternak@redhat.com>
*   QA Owner: Yaniv Kaul <ykaul@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Design Review
*   Last updated date: 04/12/2011

### Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their progress and status.
The actions will be represented in the Tasks view of the Webadmin, where the status and progress are monitored. The Task Manager will monitor actions' both synchronous and asynchronous tasks.
A simple action describes a command which is consist of 2-3 tasks: verification (CanDoAction), execution and possible finalization (endAction). An complex action might be:

*   A command which has tasks and invokes additional commands internally which are reported as tasks.
*   A chain of commands depended on each other and monitored in respect to the action which triggered the commands sequence.

A task is a meaningful part of the command which the user should be aware of.

The requirements for feature are as follow:
# Providing a mechanism for tasks management/monitoring via UI (i.e - monitor task status, monitor tasks of given action, tasks of a given entity, stop task, stop all tasks of command, restart of failed command).

1.  Defining a global correlation-id which spread cross-systems representing an action (UI--> Backend --> VDSM).
2.  Defining a task dependency/task chaining mechanism (Task B will not start before completion of Task A).
3.  Providing a mechanism to invoke commands asynchronously.
4.  Defining a "best effort task" - The success of the parent command of this task will not be dependent on the result of a task).
5.  Providing permission mechanism for the task management.

The feature will also contain some changes that are required internally for Backend development and to improve task management functionality and correctness of behavior:

1.  Changing serialization of task parameters to JSON - will ease on tasks flow debugging.
2.  Improving task recovery mechanism - in case JBoss restart (there might be a mismatch between last stored task info and the current task status in VDSM).
3.  Abstracting the Tasks representation in Backend (e.g. VDSM, authentication)

### Backend

This section describes the backend design for this feature.

#### Entity Description

The following entities/components will be added:

*   **CommandEntity** a representation of a command in the system. Using this entity, a concrete instance of *CommandBase* could be created (e.g. command 'resurrection'). The *CommandEntity* contains list of internal commands which are part of the entire action. Command entity is capable to produce a descriptive tree of tasks which describes an action.
*   **CommandTaskInfo** a representation of a meaningful part of the action. The class could be a parent of other tasks (e.g. task named execution could have beneath it a list of tasks which are part of the execution).
*   **CommandRepository** uses to store and fetch command entities from the database. Also responsible to maintain obsolete entries.
*   **CommandDAO** a DAO interface which defines the DML operations for the command entities.
*   **CommandDAODbFacadeImpl** an implementation of the CommandDAO interface.
*   **GetCommandsQuery** a query which fetches selective or entire command entities from the database.
*   **GetModifiedCommandsQuery** a query which fetches only commands which were updated since a given time. It is designed to pull only tasks which where updated since the last query invoked by a client.

For future use:

*   **CommandSequence** an entity which might compose the *CommandEntity*, representing whether the current command entity is a part of a sequential command (e.g. depended on other commands to be completed before being executed).
*   **SequentialCommandRunnerFactory** a factory which creates a runner for sequential commands.
*   **SequentialCommandRunner** a sequential command runner is responsible to to create a sequence of commands which includes order and dependencies (in the future 'best effort' command could be integrated with the sequence creation process) and to invoke the sequence.
*   **CommandExecuter** an abstraction of command execution method.
*   **SyncCommandExecuter** a synchronous implementation of the *CommandExecuter* interface. Designed to invoke commands synchronously.

**Main Task Manager Class Diagram**
The following class diagrams describe the entities participating in the the Task Manager feature: ![](async-task-main-class-diagram.jpeg "fig:async-task-main-class-diagram.jpeg")

------------------------------------------------------------------------

**Command Entity Class Diagram**
![](command-entity-class-diagram.jpeg "fig:command-entity-class-diagram.jpeg")

------------------------------------------------------------------------

**Async Vds Commands Class Diagram**
\* By inheriting *IVdsAsyncCommand* commands are treated asynchronously, regardless having asynchronous tasks (e.g. VDSM task).

*   Async Commands are being registered to the *VDSBrokerFrontendImpl.AsyncRunningCommands*, and by relevant event of the monitor (*VdsEventListener*) will be completed.

![](Async-Vds-Commands-class-diagram.jpeg "Async-Vds-Commands-class-diagram.jpeg")

#### DB Design

<span style="color:Teal">**command_entity**</span> represents the command entity:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |command_entity_id ||UUID ||not null ||The command entity ID |- |entity_name ||String ||not null ||The command entity name |- |root_command_entity_id ||UUID ||null ||The root command ID of the action |- |command_id ||UUID ||not null ||The associated command ID |- |state ||TinyInt ||not null ||The command state |- |owner_id ||UUID ||not null ||The user which triggered the command |- |owner_type ||TinyInt ||not null ||The type user which triggered the command |- |parameters ||text ||not null ||A JSON representation of the parameters associated with the command |- |action_type ||integer ||not null ||A JSON representation of the parameters associated with the command |- |message ||text ||null ||Stores the can-do-action message - relevant if move to asynchronous invocation |- |return_value ||text ||null ||Stores the command return value as JSON |- |visible ||bool ||default 'true' ||Describes if current entity should be presentable, overrides defaults visibility criteria of the command |- |start_time || Datetime ||not null ||Command start time |- |end_time || Datetime ||null ||Command end time |- |last_update_time || Datetime ||not null ||Command last update time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |}

<span style="color:Teal">**command_sequence**</span> represents the command sequence association:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |entity_id ||UUID ||not null ||The command entity ID |- |sequence_id ||UUID ||not null ||The sequence ID which the command is part of |- |next_command_id ||UUID ||null ||The next-in-chain command ID |- |order_in_sequence ||Integer ||not null ||The order of the command in the sequence |- |initiator_command_id ||UUID ||not null ||The ID of the command which initiated the sequence |- |}

<span style="color:Teal">**command_task_info**</span> represents a task, a significant part of the command:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |task_id ||UUID ||not null ||The task ID |- |parent_task_id ||UUID ||null ||The previous-in-hierarchy task |- |command_entity_id ||UUID ||not null ||The command ID |- |task_name ||String ||not null ||The task name |- |order ||Integer ||not null ||The task order in current command entity |- |start_time || Datetime ||not null ||Task start time |- |end_time || Datetime ||null ||Task end time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |}

<span style="color:Teal">**command_entity_sequence_view**</span> A view over command_entity and command_sequence. The view is used for sequence related operations.

##### CRUD

**Stored procedures**

*   <span style="color:#006400">*InsertCommandEntity*</span> - insert command entity
*   <span style="color:#006400">*GetCommandEntityByCommandId*</span> - returns a command entity by a given id
*   <span style="color:#006400">*GetAllCommandEntity*</span> - returns a list of all commands [should be restricted rownum]
*   <span style="color:#006400">*GetAllCommandSinceDate*</span> - returns a list of commands which were modified since a given date
    -   input: a start datetime to search from
    -   output: all commands which their last update date is later than the given date
*   <span style="color:#006400">*UpdateCommandEntity*</span> - updates command entity entirely
*   <span style="color:#006400">*UpdateCommandEntity*</span> - partial updates to the command entity
    -   input: command entity id, status, last update date
*   <span style="color:#006400">*DeleteCommandEntityOlderThanDate*</span> - deletes command entities which are older than a given date.
    -   input: a start datetime to delete commands which are older than
*   <span style="color:#006400">*DeleteCommandEntity*</span> - deletes specific command entity
*   <span style="color:#006400">*GetCommandTaskInfo*</span> - returns a list of tasks which associated with a command
*   <span style="color:#006400">*InsertCommandTaskInfo*</span> - inserts command task info
*   <span style="color:#006400">*DeleteCommandTaskInfoByCommandId*</span> - deletes command task info associated with a specific command
*   <span style="color:#006400">*GetCommandTasksInfoByTaskId*</span> - returns a tasks by its ID
*   <span style="color:#006400">*GetCommandTasksInfoByCommandId*</span> - returns a tasks by its command ID
*   <span style="color:#006400">*GetCommandTaskInfoForEvent*</span> - Retrieves tasks for a specific entity.

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

When a user sends a request to the backend for running an action, the backend creates a command by the type and parameters provided by the client. The idea is to create a persisted entity which describes the command so it could be monitored, followed and referred in any step during the command's lifetime till cleared from database.

The backend commands are divided into two categories:

1.  Synchronous commands - the command ends when the executeAction ends.
2.  Asynchronous commands
    1.  The command is ended when the endAction ends. The endAction is triggered by the AsyncTaskManager when the command tasks are reported as completed.
    2.  The command ends, but the action is completed by the monitor.

The following sequence diagrams describe how the new components should interact in order to support the commands, by command type:
 **Sync Command Invocation Sequence Diagram**
![](Sync-action-invocation-sequence-diagram.jpeg "fig:Sync-action-invocation-sequence-diagram.jpeg")
**The sequence above describes invocation of sync-action:**

*   The *Backend* receive a request from a client, provided by action type, parameters and optionally correlation-id.
    -   Correlation-ID is a pass-thru identifier of an action which the user defines. A user can associate any action with that ID which will appear as part of the command entity and its tasks, in Backend for action related logging and in VDSM logs. If the user does not provide a correlation-id, the Backend will generate one.
*   The *Backend* uses the *CommandFactory* for creating a concrete command instance.
*   The *Backend* uses the *CommandRepository* for creating a *CommandEntity*. The *CommandEntity* will describe the metadata of the command, therefore a command is responsible for creating its own. The command metadata is basically a placeholders for the steps of the action. A default implementation will be provided (A command with 2-3 tasks representing VALIDATION, EXECUTION and FINALIZATION). The new entity is being initialized with status 'Waiting for launch', command id, action type, parameters, correlation-id, command creation time and the user which invoked the command. The *CommandRepository* persist the *CommandEntity* to the database, letting the command queries be noticed about the new command in the system.
*   The *Backend* uses the *SyncCommandExecuter* for executing the command in a synchronous method.
*   The *SyncCommandExecuter* invokes the command and returns the command return value to the user.
*   The *CommandBase.executeAction()* updates the status of the command entity to state 'VALIDATING' and set the last update time to current. Updates 'VALIDATION' task of the command (status IN_PROGRESS, start-time).
    -   The *CommandBase.InternalCanDoAction()* determines how the validation step ends:

    1.  Upon failure, the Task is marked as failed and the Command Entity is marked as failed as well.
    2.  Upon successful completion of validation step, the validation command task is marked as completed, and set the end-time.
*   The *CommandBase.executeAction()* updates the status of the command entity to state 'EXECUTING' and sets the last update time to current and also updates 'EXECUTION' task of the command (status IN_PROGRESS, start-time).
    1.  Upon execution failure, the command entity is marked as failed.
    2.  Upon successful execution, the command will verify there are no tasks for it. If no tasks, the command is marked as completed successfully.
*   A scheduler of the *CommandRepository* will clear obsolete command entities and their tasks.

**Command Metadata Pseudo-code examples:**
*Default command metadata:*

        // CommandEntity----Description----Start time----End time----Status----[Entity Name----Entity Type]
        //      |
        //      ------ VALIDATION -----Start time----End time----Status
        //      |
        //      ------ EXECUTION -----Start time----End time----Status
        public CommandEntity createCommandMetadata(){
            CommandEntity rootEntity = new CommandEntity(this); //this refers to CommandBase instance
            rootEntity.addTask(CommandTaskType.VALIDATION);
            rootEntity.addTask(CommandTaskType.EXECUTION);
            persist(entity);
            return entity;
        }

*Maintenance command metadata:*

        // Maintenance command metadata
        // CommandEntity----Description----Start time----End time----Status----[Entity Name----Entity Type]
        //      |
        //      ------ VALIDATION -----Start time----End time----Status
        //      |
        //      ------ EXECUTION -----Start time----End time----Status
        //      |           |
        //      |           ---- PREPARE_FOR_MAINTENANCE-----Start time----End time----Status
        //      |           |
        //      |           ---- MIGRATE_VMS -----Start time----End time----Status
        //      |               |
        //      |               ---- MIGRATION_OF_VM_X -----Start time----End time----Status
        //      |               |
        //      |               ---- MIGRATION_OF_VM_X -----Start time----End time----Status
        //      |
        //      ------ DISCONNECT_FROM_STORAGE-----Start time----End time----Status
        public CommandEntity createCommandMetadata(){
            CommandEntity rootEntity = super.createCommandMetadata(this); //this refers to CommandBase instance

            CommandTaskInfo executionTask = entity.getTask(CommandTaskType.EXECUTION);
            rootEntity.addTask(executionTask, CommandTaskType.PREPARE_FOR_MAINTENANCE);

            CommandTaskInfo migrateVmsTask = rootEntity.addTask(executionTask, CommandTaskType.MIGRATE_VMS);
            for (VM vm : getVmsToMigrate()) {
                CommandEntity migrateCommand = new CommandEntity(MigrateVmCommand.class); //concrete class details will be updated after actual command is created.
                migrateCommand.addTask(migrateVmsTask, CommandTaskType.MIGRATE_VM);
                rootEntity.addCommandEntity(migrateCommand);
            }
            // The actual number of command entities per VM migration will be created during command execution
            rootEntity.addTask(CommandTaskType.DISCONNECT_FROM_STORAGE);
            return rootEntity;
        }

**Async Command Invocation Sequence Diagram**
![](Async-action-type-invocation-sequence-diagram.jpeg "fig:Async-action-type-invocation-sequence-diagram.jpeg")
When command has tasks, it shares the same sequence as the previous sequence, except the last step. The async command will be resurrected by the *AsyncTaskManager* once there are no more active tasks for the command and will execute the *CommandBase.endAction()* for that command, in which the final state of the command will be set.

Maintenance of the command entity and command task info:  

When Backend is initialized, the commands which are in progress are being examined for their status. If the command has tasks, the tasks status is being examined and upon completion of tasks, the command will be finalized (by *CommandBase.endAction()*). If the command has no tasks, it status should be marked as failed command.

A scheduler will be responsible for clearing obsolete command entities and tasks info data from the database.
There will be two different configuration value:

1.  Successful command time-to-leave - the duration for holding command which ended with success in database.
2.  Failed command time-to-leave - the duration for holding command which ended with failure in database.

When command entity is being cleared from the database, all relevant data is being cleared as well: command task info and command sequence if exist.

Updating the command information in the database will be executed in a new transaction, with a different scope the the active one. Common command steps which tasks will be created for are: INIT, VALIDATION, EXECUTION.

*   INIT - the phase between the command creation till can-do-action, Should be a quick step, which consist of pre can-do-action operation (e.g. acquiring locks over entities).
*   VALIDATION - the can-do-action phase, a validation of the conditions for executing the command.
*   EXECUTION - the actual execution of the command.

Tasks and events won't be created for internal commands.

### Events

The events log should be associated with the command which created the event. The association of the command with the events will enable viewing all of the events related to the specific command.
Event logs will be created when command tasks (*TaskInfo*) are created.

### Dependencies / Related Features and Projects

The Task Manager is depended on the Internal Locking Mechanism feature [Features/DetailedLockMechanism](Features/DetailedLockMechanism).

### Documentation / External references

### Comments and Discussion

### Open Issues

1.  Search-Engine and command entity - should commands be searchable?
2.  Is cache required for the *CommandRepository* to hold the command entities and their command tasks?
3.  Paging - restriction of returned number of records.
4.  Commands monitoring and permission model, adding Tasks view to users.
5.  Do we care about first X commands which ended successfully in a sequence, if the sequence failed for the X+1 command
6.  If a command in sequence fails, should we create audit-log and *TaskInfo* for the remaining commands in sequence specifying commands won't be executed/started ?

<Category:Template> <Category:Feature>
