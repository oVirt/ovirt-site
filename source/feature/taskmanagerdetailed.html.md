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

A Task Manager is a monitor which shows the current actions running in ovirt-engine and tracks their progress. It also capable of presenting completed commands for a period of time. The current design describes tasks monitoring.
[http://ovirt.org/wiki/Features/TaskManager Task Manager feature page](http://ovirt.org/wiki/Features/TaskManager Task Manager feature page)

### Owner

*   Name: [ Moti Asayag](User:Moti)
    -   Email: <masayag@redhat.com>
*   GUI Component owner: Gilad Chaplik <gchaplik@redhat.com>
*   REST Component owner: Michael Pasternak <mpasternak@redhat.com>
*   QA Owner: Yaniv Kaul <ykaul@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Design Review
*   Last updated date: 28/12/2011

### Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their progress and status.
The actions will be presented in the WebAdmin a Tasks view, where the status and progress are monitored. The Task Manager will monitor actions and their synchronous and asynchronous tasks.

#### Terminology

*   Command - An execution unit which performs a business logic.
*   Job - An action API (RunAction) running in the system. The Job may extend beyond the life cycle of the Command which is the entry point for the action.
*   Step - A meaningful part of the job which the user should be aware of.

The job supports the following scenarios:

1.  A simple command - a command which consists of 2 steps: validation (*CanDoAction*) and execution.
    -   The job is ends when the command of the job ends.

2.  A command with VDSM tasks - a command which consists of 3 steps: validation (*CanDoAction*), execution and finalization (*endAction*).
    -   The job ends when the tasks are reported from VDSM as completed and the command *endAction* is invoked.

3.  A command which invokes internal commands
    -   By default, the internal command will not be presented as a step of the parent command.

4.  A customized command - an asynchronous job which its termination is decided by an event other than tasks. There are few types of scenarios for it:
    -   Commands which implements the *IVdcAsyncCommand* interface - triggered by *VDSBrokerFrontendImpl.RunAsyncVdsCommand*, the command instance is maintained with its context and finalized by the monitors (*VdsUpdateRuntimeInfo*).
    -   Invocation of command in a detached thread, e.g *AddVdsCommand* which delegates job resolution to the internal command *InstallVdsCommand*.
    -   The command execution is ended, but the resolution for the success of the Action is determined by other event in the system:
        -   Other events which reported by the *monitors* (e.g. Host Maintenance reported by *VdsEventListener*).
        -   Requires heuristic decision to select the correct Step for the Job.A Job has entity type and entity id associated with.

5.  Multiple Action Runner - describes multiple command invocations in a single API call. Each command will be reflected as a job.

#### Requirements

The requirements for feature are as follow (V2 refers to future version):
# Provide a mechanism for tasks monitoring via UI (i.e - monitor task status, monitor tasks of given action, tasks of a given entity)

1.  Define a global correlation-id which spread cross-systems representing an action (Client--> Backend --> VDSM).
2.  Provide a mechanism for tasks management: cancel task, stop all tasks of command, restart of failed command, setting priority for a task. (V2)
3.  Define a task dependency/task chaining mechanism (Task B will not start before completion of Task A).(V2)
4.  Provide a mechanism to invoke commands asynchronously. (V2)
5.  Define a "best effort task" - The success of the parent command of this task will not depend on the result of a task).(V2)
6.  Provide a permission mechanism for the task management.(V2)

*   The first version will include a default implementation for all commands and specific flow monitoring for the specific commands:
    1.  AddVdsCommand
    2.  MaintenanceNumberOfVds
    3.  RunVmCommand
    4.  StopVmCommand

### Backend

This section describes the backend design for this feature.

#### Entity Description

The following entities/components will be added:

*   **Job** An entity which encapsulates a client action in the system. The *Job* contains a collection of steps which describes portions of the entire Job. A Job contains all of the information requi,red for defining and running the client action: Using Job entity a concrete instance of *CommandBase*(Job's main command) could be created (by action type and parameters). The Job entity also capable to produce a descriptive tree of steps, reflecting the action parts to be delivered to UI for presentation.
*   **Step** represents a meaningful phase of the Job. A Step could be a parent of other steps (e.g. step named EXECUTION could have a list of steps beneath it which are also part of the job).
*   **JobRepository** is the persistence mechanism for *Job* and *Step* entities. It used for CRUD operations for Job and Step, when a Job is created, it is being persistent to the database in order to reflect immediate Job status to the user. The *JobRepository* is responsible to maintain obsolete jobs in the database.
*   **JobDao** a DAO interface which defines the CRUD operations for the Job entities.
*   **JobDaoDbFacadeImpl** an implementation of the *JobDao* interface.
*   **StepDao** a DAO interface which defines the CRUD operations for the *Step* entities.
*   **StepDaoDbFacadeImpl** an implementation of the *StepDao* interface.
*   **ExecutionContext** an object which encapsulates the context in which an action should be executed. It determines level of command monitoring and a way to present a given command to the User (e.g. as a job, step). Providing *ExecutionContext* will override the default monitoring behavior of the TaskManager.

<!-- -->

*   **GetModifiedJobsQuery** a query which fetches only commands which were updated since a given time. It is designed to pull only tasks which where updated since the last query invoked by a client.

##### Enumerators

''' New Enumerators *'
*StepEnum'' specifies system's steps
*ExecutionStatus* specifies which statuses are eligible for a *Step* and *Job*
 **Updated Enumerators**
*VdcActionType* will be extended with a new field storing a list of categories to which a specific action type belongs to.

##### Annotations

*@NonMonitored* defines which commands should not be monitored.

##### Main Task Manager Class Diagram

The following class diagrams describes the entities participating in the the Task Manager feature:
 ![](async-task-main-class-diagram.jpeg "fig:async-task-main-class-diagram.jpeg")

------------------------------------------------------------------------

##### Command Entity Class Diagram

The following class diagram focuses on the *CommandEntity* and its associated element *CommandTaskInfo*:
![](command-entity-class-diagram.jpeg "fig:command-entity-class-diagram.jpeg")

------------------------------------------------------------------------

##### Async Vds Commands Class Diagram

*   By inheriting *IVdsAsyncCommand* commands are treated asynchronously, regardless having asynchronous tasks (e.g. VDSM task).
*   Async Commands are being registered to the *VDSBrokerFrontendImpl.AsyncRunningCommands*, and by relevant event of the monitor (processed by *VdsEventListener*) will be completed.
*   Since the delay between cycles of the *VdsUpdateRunTimeInfo* and possibly implications on synchronized *VDSCommand*s, an alternative for regenerating and processing the completion of the commands will be triggering events which will be processed asynchronously, detached from the flow of the monitor.

![](Async-Vds-Commands-class-diagram.jpeg "Async-Vds-Commands-class-diagram.jpeg")

#### DB Design

<span style="color:Teal">**JOB**</span> represents the job entity:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||not null ||The job ID |- |command_id ||UUID ||not null ||The associated command ID |- |status ||TinyInt ||not null ||The status of the job |- |owner_id ||UUID ||not null ||The user which triggered the command |- |parameters ||text ||not null ||A JSON representation of the parameters associated with the command |- |action_type ||integer ||not null ||The type of the command as defined by *VdcActionType* |- ||visible ||bool ||default 'true' ||Describes if current entity should be presentable, overrides defaults visibility criteria of the job |- |start_time || Timestamp ||not null ||Job start time |- |end_time || Timestamp ||null ||Job end time |- |last_update_time || Timestamp ||not null ||Command last update time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |}

<span style="color:Teal">**STEP**</span> represents a step of a job:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |step_id ||UUID ||not null ||The step ID |- |parent_step_id ||UUID ||null ||The successor step, null if none. |- |job_id ||UUID ||not null ||The job ID which the step was created for |- |step_name ||String ||not null ||The step name |- |order ||Integer ||not null ||The step order in current job hierarchy level |- |status ||TinyInt ||not null ||The status of the step |- |start_time || Timestamp ||not null ||The step start time |- |end_time || Timestamp ||null ||The step end time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |external_id || String ||null ||identifier of the step in external system (e.g. VSDM task-id) |- |external_system_type || String ||null ||The type of the external system (e.g. VSDM) |- |}

<span style="color:Teal">**JOB_SUBJECT_ENTITIES_MAP**</span> Describes a relations between entities (VM, Host...) to a job:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||not null ||The job ID |- |entity_id ||UUID ||not null ||The entity id which was provided to the Job main command |- |entity_type ||Tinyint ||not null ||The type of the entity |- |}

<span style="color:Teal">**AUDIT_LOG**</span> An extension to the existing table to denote the job which the event participate in:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||null ||The job ID |- |correlation_id ||UUID ||null ||The correlation ID provided from the client to identify the scope in which the event occurred |- |}

##### CRUD

**Stored procedures**

*   <span style="color:#006400">*InsertJob*</span> - insert job entity
*   <span style="color:#006400">*GetJobByJobId*</span> - returns a job entity by a job id
*   <span style="color:#006400">*GetJobSubjectEntitiesByJobId*</span> - returns a job subject entities by a job id
*   <span style="color:#006400">*GetJobByCommandId*</span> - returns a list of job entities by a job id
*   <span style="color:#006400">*GetAllJobs*</span> - returns a list of all jobs
*   <span style="color:#006400">*GetAllJobsSinceDate*</span> - returns a list of jobs with a last_update_date greater than a given date.
*   <span style="color:#006400">*UpdateJob*</span> - updates the entire entity
*   <span style="color:#006400">*UpdateJob*</span> - partial updates to the command entity
    -   input: command entity id, status, last update date
*   <span style="color:#006400">*DeleteJobsOlderThanDate*</span> - deletes job entities which are older than a given date.
    -   input: a start datetime to delete commands which are older than
*   <span style="color:#006400">*DeleteJob*</span> - deletes specific job entity
*   <span style="color:#006400">*GetSteps*</span> - returns a list of steps which associated with a job
*   <span style="color:#006400">*InsertStep*</span> - inserts step entity
*   <span style="color:#006400">*DeleteStepsByJobId*</span> - deletes steps associated with a specific job
*   <span style="color:#006400">*GetStepByStepId*</span> - returns a step by its ID
*   <span style="color:#006400">*GetStepsByJobId*</span> - returns a list of steps of a given Job by Job ID.

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
    2.  The command ends, but the action is completed by the event listener.

The following sequence diagrams describe how the new components should interact in order to support the commands, by command category:

##### Sync Command Invocation Sequence Diagram

![](Sync-action-invocation-sequence-diagram.jpeg "fig:Sync-action-invocation-sequence-diagram.jpeg")
**The sequence above describes invocation of sync-action:**

*   The *Backend* receives a request from a client, provided by action type, parameters and optionally correlation-id.
    -   Correlation-ID is a pass-thru identifier of an action which the user defines. A user can associate any action with that ID which will appear as part of the command entity and its tasks, in Backend for action related logging and in VDSM logs. If the user does not provide a correlation-id, the Backend will generate one.
*   The *Backend* uses the *CommandFactory* to create a concrete command instance.
*   The *Backend* uses the *CommandRepository* to create a *CommandEntity*. The *CommandEntity* will describe the metadata of the command (detailed below), therefore a command is responsible for creating its own metadata. The command metadata is basically a placeholders for the steps of the action. A default implementation will be provided (A command with 2-3 tasks representing VALIDATION, EXECUTION and tentative FINALIZATION for endAction). The new entity is being initialized with PENDING status, command id, action type, parameters, correlation-id, command creation time and the user which invoked the command. The *CommandRepository* persist the *CommandEntity* to the database, letting the command queries be noticed about the new command in the system. The tasks which are related to the command will be initialized as well.
*   The *CommandBase.executeAction()* updates the status of the command entity to state 'VALIDATING' and set the last update time to current. It also updates 'VALIDATION' task of the command (status IN_PROGRESS, start-time).
    -   The *CommandBase.InternalCanDoAction()* determines how the validation step ends:

    1.  Upon failure, the Task is marked as failed and the *CommandEntity* is marked as failed as well.
    2.  Upon successful completion of validation step, the validation command task is marked as completed, and set the end-time.
*   The *CommandBase.executeAction()* updates the status of the command entity to state 'EXECUTING' and sets the last update time to current and also updates 'EXECUTION' task of the command (status RUNNING and start-time).
    1.  Upon execution failure, the task is marked as failed and the command entity is marked as failed as well.
    2.  Upon successful execution, the command will verify there are no tasks for it. If no tasks, the command is marked as completed successfully.
*   A scheduler of the *CommandRepository* will clear obsolete command entities and their tasks.

##### Async Command Invocation Sequence Diagram

![](Async-action-type-invocation-sequence-diagram.jpeg "fig:Async-action-type-invocation-sequence-diagram.jpeg")
\* When command has tasks, it shares the same sequence as the previous sequence, except the last step. The async command will be resurrected by the *AsyncTaskManager* once there are no more active tasks for the command and will execute the *CommandBase.endAction()* for that command, in which the final state of the command will be set.

*   The tasks polling started after the command execution in ended.

**Command Metadata Pseudo-code examples:**

##### Multiple Action Sequence Diagram

When invoking Multiple Actions, the runner will be the responsible for creating the metadata for the command: ![](Multiple-action-runner-sequence-diagram.jpeg "fig:Multiple-action-runner-sequence-diagram.jpeg")

##### Default command metadata

*   The next example describes the default command metadata created for commands with default implementation.
*   The CommandEntity will represent the descriptive name of the command which acts as the name of the action.

<!-- -->

        // CommandEntity----Description----Start time----End time----Status----[Entity Name----Entity Type]
        //      |
        //      ------ VALIDATION -----Start time----End time----Status
        //      |
        //      ------ EXECUTION -----Start time----End time----Status
        public CommandEntity createCommandMetadata(){
            CommandEntity rootEntity = new CommandEntity(this); //this refers to CommandBase instance
            rootEntity.addTask(CommandTaskType.VALIDATION);
            rootEntity.addTask(CommandTaskType.EXECUTION);
            return entity;
        }

##### AddVdsCommand metadata

*   In the next example, a metadata creation for the *AddVdsCommand* will be described.
*   The *AddVdsCommand* has the default steps of VERIFICATION and EXECUTION.
*   In addition it has the TEST_POWER_MANAGEMENT task, a synchronous step invoked from the command itself and its status is determined immediately.
*   The last step is the INSTALL_HOST. This step is being executed in a new thread, detached from the *AddVdsCommand* thread. The completion of the INSTALL_HOST step will determine how the *AddVdsCommand* action ended. For that purpose the resolution of the action is delegated to the *InstallVdsCommand*. The *InstallVdsCommand* will update the task which represents it. Since this is the last step of the action, it notifies the completion of the entire command.

<!-- -->

        // CommandEntity----Description----Start time----End time----Status----[Entity Name----Entity Type]
        //      |
        //      ------ VALIDATION -----Start time----End time----Status
        //      |
        //      ------ EXECUTION -----Start time----End time----Status
        //                  |
        //                  ------ TEST_POWER_MANAGEMENT-----Start time----End time----Status
        //                  |
        //                  ------ INSTALLING_HOST-----Start time----End time----Status
        public CommandEntity createCommandMetadata(){
            CommandEntity rootEntity = new CommandEntity(this);
            rootEntity.addTask(CommandTaskType.VALIDATION);
            CommandTaskInfo executionTask = rootEntity.addTask(CommandTaskType.EXECUTION);
            rootEntity.addTask(executionTask, CommandTaskType.TEST_POWER_MANAGEMENT);

            CommandEntity installVdsEntity = new CommandEntity(this, InstallVdsCommand.class);
            installVdsEntity.addTask(CommandTaskType.INSTALLING_HOST);
            rootEntity.addCommandEntity(executionTask, installVdsEntity);
        }

##### MaintenanceNumberOfVdssCommand metadata

*   In the example below, the metadata of *MaintenanceNumberOfVdssCommand* is created prior to the command execution, reflecting to user the expected flow of the action. When there is a Backend command as part of the execution sequence (e.g. MaintenanceVdsCommand), a *CommandEntity* is created, storing the entity type and entity id.
*   Having entity-ids associated with the command entity will enable using the *IVdsAsyncCommand* interface to invoke the command once again upon completion or failure of the command. This will grant the action to complete its tasks. Once command is completed, the associated task will be marked as completed. For example:
    -   *VdsEventListner.VdsMovedToMaintanance(vdsId)* will invoke the *MaintenanceVdsCommand* associated with the id. It will be executed by registering the *MaintenanceVdsCommand* with the host id to be notified when the monitor reach that point.
    -   *VdsEventListner.RunningSucceeded* and *VdsEventListner.RemoveAsyncCommand* provides control over the *MigrateVm* commands, therefore for the task representing the VM migration.
*   Since in *MaintenanceNumberOfVdssCommand* there are multiple tasks which might end in undefined order, and in order to prevent a need to synchronize tasks update in order to determine command completion, a scheduler will be set to monitor action in progress with asynchronous commands.

<!-- -->

        // Maintenance command metadata (each level should have also the Correlation-ID)
        // CommandEntity----Description----Start time----End time----Status----[Entity Name----Entity Type]
        //      |
        //      ------ VALIDATION -----Start time----End time----Status
        //      |
        //      ------ EXECUTION -----Start time----End time----Status
        //                 |
        //                 ---- PREPARE_FOR_MAINTENANCE-----Start time----End time----Status
        //                 |
        //                 ---- MAINTENANCE_HOST_A -----Start time----End time----Status
        //                 |    |
        //                 |    ---- MIGRATION_OF_VM_X -----Start time----End time----Status
        //                 |    |
        //                 |    ---- MIGRATION_OF_VM_Y -----Start time----End time----Status
        //                 |    |
        //                 |    ---- DISCONNECT_FROM_STORAGE-----Start time----End time----Status
        //                 |
        //                 ---- MAINTENANCE_HOST_B -----Start time----End time----Status
        //                      |
        //                      ---- MIGRATION_OF_VM_Z -----Start time----End time----Status
        //                      |
        //                      ---- DISCONNECT_FROM_STORAGE-----Start time----End time----Status
        //
        public CommandEntity createCommandMetadata(){
            CommandEntity rootEntity = super.createCommandMetadata(this); //this refers to CommandBase instance

            CommandTaskInfo executionTask = entity.getTask(CommandTaskType.EXECUTION);
            rootEntity.addTask(executionTask, CommandTaskType.PREPARE_FOR_MAINTENANCE);

            for (VDS vds : getVdsList()){
                CommandEntity maintenanceCommand = new CommandEntity(MaintananceVds.class);
                CommandTaskInfo migrateVmsTask = maintenanceCommand.addTask(executionTask, CommandTaskType.MAINTENANCE_HOST);

                // The actual number of command entities per VM migration will be created during command execution
                for (VM vm : vds.getVmsToMigrate()) {
                    CommandEntity migrateCommand = new CommandEntity(MigrateVmCommand.class); //concrete class details will be updated after actual command is created.
                    migrateCommand.addTask(migrateVmsTask, CommandTaskType.MIGRATE_VM);
                    maintenanceCommand.addCommandEntity(migrateCommand);
                }
                maintenanceCommand.addTask(CommandTaskType.DISCONNECT_FROM_STORAGE);
                rootEntity.addCommandEntity(maintenanceCommand);
            }
            return rootEntity;
        }

##### Maintenance of the command entity and command task info

When Backend is initialized, the commands which are in progress are being examined for their status. If the command has tasks, the tasks status is being examined and upon completion of tasks, the command will be finalized (by *CommandBase.endAction()*). If the command has no tasks, its status should be marked as failed.

*   A scheduler will be responsible for clearing obsolete command entities and tasks info data from the database.
*   There will be two different configuration value:
    1.  Successful command time-to-leave - the duration for holding commands which ended successfully in database.
    2.  Failed command time-to-leave - the duration for holding command which ended with failure in database. This period will be longer in order to provide the user a possibility to restart the action (in the future).
*   When command entity is being cleared from the database, all relevant data is being cleared as well: command task info and command sequence if exist.
*   Updating the command information in the database will be executed in a new transaction, with a different scope than the active one.
*   Tasks and events won't be created for internal commands by default, unless specifically asked for.
*   The *CommandEntity* could be set as monitored command per action: In action X it could be presentable where in other action it could be hidden.
    -   The visibility of the *CommandEntity* determines the visibility of its tasks and sub-tasks.

### Events

Event logs will be created when command tasks (*CommandTaskInfo*) are created.

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
7.  logging of Ids

<Category:Template> <Category:Feature>
