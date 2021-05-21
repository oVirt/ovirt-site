---
title: TaskManagerDetailed
category: feature
authors:
  - lpeer
  - moti
  - sandrobonazzola
---

## Task Manager

### Summary

A Task Manager is a monitor which shows the current actions running in ovirt-engine and tracks their progress.
It also capable of presenting completed commands for a period of time. The current design describes tasks monitoring.
[Task Manager feature page](/develop/release-management/features/infra/taskmanager.html)

### Owner

*   Name: Moti Asayag (Moti)
    -   Email: <masayag@redhat.com>
*   GUI Component owner: Gilad Chaplik
*   REST Component owner: Michael Pasternak
*   QA Owner: Yaniv Kaul <ykaul@redhat.com>

### Current status

*   Target Release: 3.1
*   Status: Coding ( Engine-done, UI-coding, API-Not started )
*   Last updated date: 01/01/2012

### Detailed Description

A Task Manager is a monitor which shows the current actions running in ovirt-engine server. It provides transparency for the administrator regarding the actions, their progress and status.
The actions will be presented in the WebAdmin a Tasks view, where the status and progress are monitored. The Task Manager will monitor actions and their synchronous and asynchronous tasks.

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

The requirements for feature are as follow (V2 refers to future version):
# Provide a mechanism for jobs monitoring via UI (i.e - monitor job status and progress, monitor tasks of given action, jobs of a given entity).

1.  Define a correlation-id which used to identify an action spread cross-layers (Client--> Backend --> VDSM).
2.  Provide the admin the option to remove jobs from the monitoring view (Job execution continues without monitoring).
3.  Provide a mechanism for tasks management: cancel task, stop all tasks of command, restart of failed command, setting priority for a task. (V2)
4.  Define a task dependency/task chaining mechanism (Task B will not start before completion of Task A).(V2)
5.  Provide a mechanism to invoke commands asynchronously. (V2)
6.  Define a "best effort step" - The success of the parent command of this step will not depend on the result of a step).(V2)
7.  Provide a permission mechanism for the task management.(V2)

*   The first version will include a default implementation for all commands and specific flow monitoring for the following commands:
    1.  AddVdsCommand
    2.  MaintenanceNumberOfVds
    3.  RunVmCommand
    4.  StopVmCommand

### Backend

This section describes the backend design for this feature.

#### Entity Description

The following entities/components will be added:

*   **Job** An entity which encapsulates a client action in the system. The *Job* contains a collection of steps which describes portions of the entire Job. A Job contains all of the information required for defining and running the client action: Using Job entity a concrete instance of *CommandBase*(Job's main command) could be created (by action type and parameters). The Job entity also capable to produce a descriptive tree of steps, reflecting the action parts to be delivered to UI for presentation.
*   **Step** represents a meaningful phase of the Job. A Step could be a parent of other steps (e.g. step named EXECUTION could have a list of steps beneath it which are also part of the job).
*   **JobRepository** is the persistence mechanism for *Job* and *Step* entities. It used for CRUD operations for Job and Step, when a Job is created, it is being persistent to the database in order to reflect immediate Job status to the user. The *JobRepository* is responsible to maintain obsolete jobs in the database.
*   **JobDao** a DAO interface which defines the CRUD operations for the Job entities.
*   **JobDaoDbFacadeImpl** an implementation of the *JobDao* interface.
*   **StepDao** a DAO interface which defines the CRUD operations for the *Step* entities.
*   **StepDaoDbFacadeImpl** an implementation of the *StepDao* interface.
*   **ExecutionContext** an object which encapsulates the context in which an action should be executed. It determines level of command monitoring and a way to present a given command to the User (e.g. as a job, step). Providing *ExecutionContext* will override the default monitoring behavior of the Task Manager.

<!-- -->

*   **GetModifiedJobsQuery** a query which fetches only commands which were updated since a given time. It is designed to pull only tasks which where updated since the last query invoked by a client.

##### Enumerators

''' New Enumerators *'
*StepEnum'' specifies system's steps
*ExecutionStatus* specifies which statuses are eligible for *Step* and *Job*
 **Updated Enumerators**
The *VdcActionType* will be used in a resource bundle to correlate between the action type to the description of a job.
The resource bundle will contain description for both Jobs and Steps (combines *VdcActionType* and *StepEnum*):

    job.RunVm=Running a VM
    job.AddVds=Add new Host
    step.EXECUTION=Executing
    step.VALIDATION=Validating

**Tentative:**
*ActionCategory* specifies categories of actions, e.g. storage, network, host maintenance...
*VdcActionType* will be extended with a new field storing a list of categories (Set<ActionCategory>) to which a specific action type belongs to.
The *categories* field will enable filtering jobs by categories. An action type could be associated with multiple categories.

##### Annotations

*@NonMonitored* declared on a successor of *CommandBase* clsas. Defines whether a command should not be monitored.

##### Main Task Manager Class Diagram

The following class diagrams describes the entities participating in the the Task Manager feature:
 ![](/images/wiki/Async-task-main-class-diagram.png)

------------------------------------------------------------------------

##### Command Entity Class Diagram

The following class diagram focuses on the *Job* and *Step* entities:
![](/images/wiki/Command-entity-class-diagram.png)

------------------------------------------------------------------------

##### Async Vds Commands Class Diagram

*   By inheriting *IVdsAsyncCommand* commands are treated asynchronously, regardless having asynchronous tasks (e.g. VDSM task).
*   Async Commands are being registered to the *VDSBrokerFrontendImpl.AsyncRunningCommands*, and by relevant event of the monitor (processed by *VdsEventListener*) will be completed.
*   Since the delay between cycles of the *VdsUpdateRunTimeInfo* and possibly implications on synchronized *VDSCommand*s, an alternative for regenerating and processing the completion of the commands will be triggering events which will be processed asynchronously, detached from the flow of the monitor.

![](/images/wiki/Async-Vds-Commands-class-diagram.png)

------------------------------------------------------------------------

#### DB Design

<span style="color:Teal">**JOB**</span> represents the job entity:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||not null ||The job ID |- |command_id ||UUID ||not null ||The associated command ID |- |status ||String ||not null ||The status of the job |- |description ||String ||not null ||The step description |- |owner_id ||UUID ||not null ||The user which triggered the command |- |parameters ||text ||not null ||A JSON representation of the parameters associated with the command |- |action_type ||String ||not null ||The type of the command as defined by *VdcActionType* |- |visible ||bool ||default 'true' ||Describes if current entity should be presentable, overrides defaults visibility criteria of the job |- |start_time || Timestamp ||not null ||Job start time |- |end_time || Timestamp ||null ||Job end time |- |last_update_time || Timestamp ||not null ||Command last update time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |}

<span style="color:Teal">**STEP**</span> represents a step of a job:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |step_id ||UUID ||not null ||The step ID |- |parent_step_id ||UUID ||null ||The successor step, null if none. |- |job_id ||UUID ||not null ||The job ID which the step was created for |- |step_type ||String ||not null ||The step name, values taken from *StepEnum* |- |description ||String ||not null ||The step description |- |order ||Integer ||not null ||The step order in current job hierarchy level |- |status ||String ||not null ||The status of the step |- |start_time || Timestamp ||not null ||The step start time |- |end_time || Timestamp ||null ||The step end time |- |correlation_id || String ||not null ||correlation identifier for cross system logging |- |external_id || Guid ||null ||identifier of the step in external system (e.g. VSDM task-id) |- |external_system_type || String ||null ||The type of the external system (e.g. VSDM) |- |}

<span style="color:Teal">**JOB_SUBJECT_ENTITIES_MAP**</span> Describes a relations between entities (VM, Host...) to a job:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||not null ||The job ID |- |entity_id ||UUID ||not null ||The entity id which was provided to the Job main command |- |entity_type ||String ||not null ||The type of the entity |- |}

<span style="color:Teal">**AUDIT_LOG**</span> An extension to the existing table to denote the job which the event participate in:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |job_id ||UUID ||null ||The job ID |- |correlation_id ||UUID ||null ||The correlation ID provided from the client to identify the scope in which the event occurred |- |}

<span style="color:Teal">**ASYNC_TASK**</span> An extension to the existing table to associate a task with its Step:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |step_id ||UUID ||null ||The job ID |- |}

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

#### User work-flows

When a user sends a request to the backend for running an action, the backend creates a command(s) according to the type and parameters provided by the client. A persisted Job entity is created to describe and monitor the command and the rest of the action, followed and referred in any step during the command's lifetime till job is completed. Once completed, the job will be cleared from database in respect to the maintenance configuration of the Jobs.

The backend commands are divided into two categories:

1.  Synchronous commands - the command ends when the *executeAction* ends.
2.  Asynchronous commands
    1.  The command is ended when the *endAction* ends. The *endAction* is triggered by the *AsyncTaskManager* when the tasks created by the command are reported as completed.
    2.  The command ends, but the action is completed by the event listener.

The following sequence diagrams describe how the interaction of the new entities in the existing flow in order to support the monitoring:

##### Simple Command Invocation Sequence Diagram

![](/images/wiki/Sync-action-invocation-sequence-diagram.png)
**The sequence above describes invocation of sync-action:**

*   The *Backend* receives a request from a client, provided by action type, parameters and optionally correlation-id (encapsulated by the parameters).
    -   Correlation-ID is a pass-thru identifier of an action which the client defines.
    -   A client can associate any action with that ID which will appear as part of the *Job* and its *Step*s in *Backend* for action related logging and in VDSM logs.
    -   If the client does not provide a correlation-id, the Backend will generate one.
    -   The correlation-ID is passed by Parameters of the Action (a successor of *VdcActionParameterBase*).
*   The *Backend* uses the *CommandFactory* to create a concrete command instance.
*   The *Backend* creates a *Job* entity with the given parameters and bind it to the command.
*   A default implementation will be provided (A command with 2-3 tasks representing VALIDATION, EXECUTION and tentative FINALIZATION for *endAction*).
    -   The new Job entity is created with status STARTED, command id, action type, parameters, correlation-id, start time, subject entities and the user which invoked the command. The *JobRepository* persists the *Job* to the database, letting the command queries be noticed about the new command in the system.
*   The *CommandBase.executeAction()* adds new step for the job: VALIDATING step which created with status started and current time.
    -   The *CommandBase.InternalCanDoAction()* determines how the validation step ends:

    1.  Upon failure, the VALIDATING *Step* is marked as failed and the *Job* is marked as failed as well.
    2.  Upon successful completion of validation step, the step is marked as FINISHED, and set the end-time.
*   The *CommandBase.executeAction()* adds new step 'EXECUTING' with status STARTED.
    1.  Upon execution failure, the Step is marked as failed and the Job is marked as failed as well.
    2.  Upon successful execution, the command will verify there are no tasks for it. If no tasks, the Job is marked as completed successfully.
*   A scheduler of the *JobRepository* will clear obsolete Job entities and their Steps.

##### Async Command Invocation Sequence Diagram

![](/images/wiki/Async-action-type-invocation-sequence-diagram.png)
\* When command has tasks, it shares the same sequence as the previous sequence, except the last step. The async command will be resurrected by the *AsyncTaskManager* once there are no more active tasks for the command and will execute the *CommandBase.endAction()* for that command, in which the final state of the command will be set.

*   The tasks polling started after the command execution in ended.

##### Multiple Action Sequence Diagram

*   When invoking Multiple Actions, the runner will be the responsible for creating a Job for each of the commands.
*   In multiple command execution the *canDoAction* of each command is executed explicitly prior to the command execution.
*   The Job will be created only for commands which pass the *canDoAction*.

![](/images/wiki/Multiple-action-runner-sequence-diagram.png)

#### Job Description by Command Types

##### Default job metadata (a simple command)

*   The next example describes the default job metadata created for commands with default implementation.
*   The Job will represent the descriptive name of the action.
*   Short commands which follows this default behavior could be set for non-monitored since ended quickly.
    -   login and logout command should be non-monitored

<!-- -->

    Job----Start time----End time----Status----[Entity Name----Entity Type]
        |
        ------ VALIDATION -----Start time----End time----Status
        |
        ------ EXECUTION -----Start time----End time----Status

##### Job for a command with VDSM tasks

The following skeleton describes the information which should be presented for a Job which describes a command with tasks. Each task will be presented as a step. By default the VDSM tasks will be added under the execution step, but this could be customized. Each step holds the id of the task it represents and the opposite. The mutual reference enables each completed VDSM task to update the Step with its status, and in the future to control from the Task Manager how the task should operate: change priority, cancel or other management action. The FINALIZATION step appears since some commands perform additional actions once all tasks are completed which we'd might like to reflect to the user.

    Job----Start time----End time----Status----[Entity Name----Entity Type]
        |
        ------ VALIDATION -----Start time----End time----Status
        |
        ------ EXECUTION -----Start time----End time----Status
        |          |
        |          -----Task Step 1 ------Start time----End time----Status
        |          |
        |          -----Task Step 2 ------Start time----End time----Status
        |
        ------ FINALIZATION -----Start time----End time----Status

##### Job which describes command that invokes internal commands

By default, internal commands won't be presented as Steps of the Job, unless specified. Therefore the job description of a command which invokes internal commands is the same as the default one (or the one above if the main command has tasks). The only exceptions is commands which invoke internal commands which create VDSM tasks. In that case the default behavior will be to add only the VDSM tasks as steps under the Job EXECUTION step. It is possible to override this behavior either for not presenting internal commands VDSM tasks or for specifying other Step to which the VDSM tasks of the internal command should appear for.

    Job----Start time----End time----Status----[Entity Name----Entity Type]
        |
        ------ VALIDATION -----Start time----End time----Status
        |
        ------ EXECUTION -----Start time----End time----Status
        |          |
        |          -----Main Command Task Step 1 ------Start time----End time----Status
        |          |
        |          -----Main Command Task Step 2 ------Start time----End time----Status
        |          |
        |          -----Internal Command Task Step 3 ------Start time----End time----Status
        |          |
        |          -----Internal Command Task Step 4 ------Start time----End time----Status
        |
        ------ FINALIZATION -----Start time----End time----Status

##### Job for customized command #1

*   In the next example, a metadata creation for the *AddVdsCommand* will be described.
*   The *AddVdsCommand* has the default steps of VERIFICATION and EXECUTION.
*   In addition it has the TEST_POWER_MANAGEMENT task, a synchronous step invoked from the command itself and its status is determined immediately.
*   The last step is the INSTALL_HOST. This step is being executed in a new thread, detached from the *AddVdsCommand* thread. The completion of the INSTALL_HOST step will determine how the *AddVdsCommand* action ended. For that purpose the resolution of the action is delegated to the *InstallVdsCommand*. The *InstallVdsCommand* will update the task which represents it. Since this is the last step of the action, it notifies the completion of the entire job.

<!-- -->

    Add new host ----Start time----End time----Status----[Entity Name----Entity Type]
        |
        ------ VALIDATION -----Start time----End time----Status
        |
        ------ EXECUTION -----Start time----End time----Status
                            |
                            |------ TEST_POWER_MANAGEMENT-----Start time----End time----Status
                            |
                            |------ INSTALLING_HOST-----Start time----End time----Status

##### Job for customized command #2

*   In the example below, the job of *MaintenanceNumberOfVdssCommand* is described.
*   A single Job will be created for several hosts.
*   Each host maintenance execution will be described as a step under the Job execution step.
*   Having entity-ids associated with the job will enable using the *IVdsAsyncCommand* interface to invoke the command once again upon completion or failure of the command. For example, reporting on migrated VMs:
    -   *VdsEventListner.RunningSucceeded* and *VdsEventListner.RemoveAsyncCommand* provides control over the *MigrateVm* commands hence for the steps they represents.
*   When step ends, an event is triggered for the Job, to notify upon step completion.

<!-- -->

         // Maintenance command metadata (each level should have also the Correlation-ID)
         Job----Start time----End time----Status----[Entity Name----Entity Type]
              |
              ------ VALIDATION -----Start time----End time----Status
              |
              ------ EXECUTION -----Start time----End time----Status
                         |
                         ---- PREPARE_FOR_MAINTENANCE-----Start time----End time----Status
                         |
                         ---- MAINTENANCE_HOST_A -----Start time----End time----Status
                         |    |
                         |    ---- MIGRATION_OF_VM_X -----Start time----End time----Status
                         |    |
                         |    ---- MIGRATION_OF_VM_Y -----Start time----End time----Status
                         |    |
                         |    ---- DISCONNECT_FROM_STORAGE-----Start time----End time----Status
                         |
                         ---- MAINTENANCE_HOST_B -----Start time----End time----Status
                         |
                         ---- MIGRATION_OF_VM_Z -----Start time----End time----Status
                         |
                         ---- DISCONNECT_FROM_STORAGE-----Start time----End time----Status

##### Job for System Monitors

System monitors are capable to invoke actions internally which the user might have interest in.
Providing an *ExecutionContext* to the internal command invocation with monitoring flag will cause the internal command to be reflected as *Job*.
The supported events are:

*   VM migrations
*   Host fencing
*   SPM election

##### Maintenance of the Job

When Backend is initialized, the non-completed jobs are being examined for their statuses:

*   If the job represents a command with tasks, the tasks status is being examined and upon completion of tasks, the command will be finalized (by *CommandBase.endAction()*).
*   If the command has no tasks, the Job status should be set to UNKNOWN.

<!-- -->

*   A scheduler will be responsible for clearing obsolete Jobs and Steps from the database.
*   Two configuration values will determine the frequency of clearing completed jobs:
    -   *Time-to-keep-successful-jobs* - the duration for holding a successfully completed jobs in the database.
        -   Default is 10 minutes.
        -   -1 emphasis manual maintenance of the successful jobs.
    -   *Time-to-keep-failed-jobs* - the duration for holding failed jobs in the database.
        -   Default is 60 minutes.
        -   -1 emphasis manual maintenance of the failed jobs.
*   Updating the Job information in the database will be executed in a new transaction.

#### Events

Event log will be extended with two fields:
*job_id* field designed to describe the job which the current event is part of. Once the Job is cleared from the database, the job_id will point for non-existing job.
*correlation_id* associates the event with the global identifier of the action, which the event participate in.

### REST API

No REST API support for Task Manager in v1.

### User Experience

A Tasks sub-view will be created in the Webadmin for presenting the Tasks. The following images mocks the Tasks sub-views:
 **General view of the Tasks:**
![](/images/wiki/Tasks-Sub-View-1.png)

------------------------------------------------------------------------

**Tasks sub-view for a specific entity:**
![](/images/wiki/Tasks-Sub-View-For-Specific-Entity.png)

------------------------------------------------------------------------

**Real layout of the Tasks sub-view:**
![](/images/wiki/Semi-real-mockup.png)

------------------------------------------------------------------------

**Sorting Jobs in Tasks view by criteria of *started-time*, *last-update-time* and *status*:**
![](/images/wiki/Sorted-criteria-tasks-mockup.png)

------------------------------------------------------------------------

### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

### Dependencies / Related Features and Projects

The Task Manager is depended on the Internal Locking Mechanism feature [Features/DetailedLockMechanism](/develop/release-management/features/infra/detailedlockmechanism.html).

### Documentation / External references


### Open Issues

1.  Search-Engine and command entity - should commands be searchable?
2.  Paging - restriction of returned number of records.
3.  Commands monitoring and permission model, adding Tasks view to users.

[TaskManager](/develop/release-management/features/) [TaskManager](/develop/release-management/releases/3.1/feature.html)
