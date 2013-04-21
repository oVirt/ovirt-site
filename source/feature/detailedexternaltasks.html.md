---
title: DetailedExternalTasks
category: feature
authors: emesika
wiki_category: Feature
wiki_title: Features/Design/DetailedExternalTasks
wiki_revision_count: 35
wiki_last_updated: 2014-10-23
wiki_warnings: list-item?
---

# Detailed External Tasks

## Adding External Jobs/Steps Support

### Summary

Enable plug-in to inject tasks (Jobs) to the engine application using the REST API, change their statuses and track them from the UI. A task (Job) may have other nesting sub-tasks (Steps) under it.

### Owner

*   Feature owner: [ Eli Mesika](User:emesika)

    * GUI Component owner: [ Eli Mesika](User:emesika)

    * REST Component owner: [ Eli Mesika](User:emesika)

    * Engine Component owner: [ Eli Mesika](User:emesika)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.3
*   Status: Design
*   Last updated date: APR 15 2013

### Detailed Description

Enable plug-in to inject tasks (Jobs) to the engine application using the REST API, change their statuses and track them from the UI. A task (Job) may have other nesting sub-tasks (Steps) under it. A Job is actually a container of nexted steps. each Step may have sub-steps under it. A steps represents one of the following:
 An external command that is invoked and monitored by the plug-in

        A supported internal command that is invoked by the plug-in and monitored internally by the oVirt engine.

Each Job may have unlimited list of external/internal steps.

The following should be supported:

        Adding a job
        Adding a  step to a job or to a step (as sub-step)
        Ending a step 
        Eding a job
        Displaying all Jobs
        Displaying a specific Job
        Displaying all Steps under a specific Job
        Dislaying a specific Step under a Job

Job can be in one of the following statuses:

         STARTED   - Job was started
         FINISHED  - Job has been finished successfully
         FAILED       - Job had failed 

Step can be in one of the following statuses:

         VALIDATING  - Step is validating the requested operation
         EXECUTING  - Step is executing the requested operation
         FINALIZING   - Steps is finalysing the requested operation

### CRUD

Adding a flag named **is_external** to both **Job** and **Step** tables
This flag indicates that the Job/Step was invoked as part of a plug-in operation and may be used in future to filter such jobs/steps

#### DAO

Adding **isExternal** flag to both **JobDAODBFacadeImpl** and **StepDAODBFacadeImpl** and wrap it with getter/setter

#### Metadata

Adding **is_external** to **Job** and **Step** metadata in **fixtures.xml**

### Business Logic

Adding the following to **VdcActionParametersBase**

       jobId   - The Job UUID
       stepId  - The parent step UUID

This will be used by plug-ins in order to invoke internal oVirt commands and still let them appaer under the given Job/Step in the **task Monitor**
In case that such a command is invoked not in the context of an external Job, its **jobId** and **stepId** will be null
 The ExecutionHandler::getJob is modified to test if the **jobId** and **stepId** are null and according to the result generate a new job or use the given one.

#### New Supported Commands

      AddExternalJob - Adds an external Job and returns its UUID
      EndExternalJob - Ends the given Job
      AddExternalStep - Adds an external step to a Job directly or under an existing Step
`                  If command is an oVirt internal command, it cpould be added only if it is flagged as `**`Monitored`**
      EndExternalStep - Ends the given Step (For steps that represents plug-in operations only)

### Flow

*Add Job/Step* Flow:
 use api/jobs to add a new job using POST and giving a job **description** as a parameter

      use api/jobs/`<jobId>`/steps to add a new step using POST and giving a step `**`parentId`**` , `**`parentType`**`, `**`description`**` and `**`status`**` as parameters (The parentId is the UUID of the parent of the new created step, the parentType may be `**`Job`**` or `**`Step`**`)

''List Job(s)/Step(s):
 use api/jobs to list all jobs

`use api/jobs/`<jobId>` to list the job identified by `<jobId>
`use api/jobs/`<jobId>`/steps to list all steps of the job identified by `<jobId>
`use api/jobs/`<jobId>`/`<stepId>` to list a specific step identified by `<stepId>` under the job identified by `<jobId>

### Permissions

#### Command Permissions

A new permission to access those commands will be added by default only to superuser role. A new role that can inject External Tasks will be added and may be attached/added to any user in the system

#### Permissions on Entity Instances

Since each Job may have steps that invoke internal oVirt command or external plug-in comamnds, on internal oVirt command we have already permissions on entities and on external commands it is in teh plug-in scope. So, nothing have to be specifically written in oVirt to support that.

### API

We will add two new business entities: **Job** and **Steps**
\* Adding JobMapper to map backend to REST entities and vice versa

*   Adding StepMapper to map backend to REST entities and vice versa
*   Add JobsResource/BackendJobsResource implementation to handle add() & get operations
*   Add StepsResource/BackendStepsResource implementation to handle add() & get operations
*   Add JobResource implementation to handle actions on a specific resource
*   Add StepResource implementation to handle actions on a specific resource
*   Modify rsdl file
*   Add signatures to meta-data file (rsdl_metadata_v-3.1.yaml)
*   Add tests

**Note that no update is required.**

#### Get

Add support for the following:

      /api/jobs
`/api/jobs/`<job_id>
      /api/jobs/`<job_id>`/steps
`/api/jobs/`<job_id>`/steps/`<step_id>

#### Post

Adding a new Job/Step will be implemented by the POST operation
 Job:

<job>
`    `<description></description>
`    `<commands>
`        `<command></command>
              ...
`    `</commands>
</job>

Step:

<step>
`    `<job_id></job_id>
`    `<parent_step_id></parent_step_id>
`    `<description></description>
`   `<status></status>
<step>

Ending an existing Job/Step will be done via a supported **action** on the Job/Step business entity

      /api/Jobs/`<job_id>`/end - will end the given job
      /api/Jobs/`<job_id>`/steps/`<step_id>`/end - will end the given step

### User Experience

External Jobs and their Steps will be displayen in the oVirt Task Monitor

### Installation/Upgrade

Add additional fields to job and step tables upon upgrade Add the permission(ActionGroup) to manipulate External tasks to other admin roles already defined upon upgrade.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=872719)

[Features/ExternalTasks](Features/ExternalTasks)

### Future directions

[Category: Feature](Category: Feature)
