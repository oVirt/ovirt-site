---
title: Detailed Gluster Volume Asynchronous Tasks Management
category: detailedfeature
authors: sahina
wiki_category: DetailedFeature
wiki_title: Features/Detailed Gluster Volume Asynchronous Tasks Management
wiki_revision_count: 12
wiki_last_updated: 2013-10-15
---

# Detailed Gluster Volume Asynchronous Tasks Management

## Gluster Volume Asynchronous Tasks

### Summary

This feature provide the support for managing the asynchronous tasks on Gluster volumes. See: [ Gluster Volume Asynchronous Tasks Management](Features/Gluster_Volume_Asynchronous_Tasks_Management)

### Owner

*   Name: [ Sahina Bose](User:Sahina)
*   Email: <sabose@redhat.com>

### Current status

*   Target Release: TBD
*   Status: Development in progress
*   Last updated: ,

## Design

### Database changes

*   Change to stored procedure CheckIfJobHasTasks
    -   Add 'GLUSTER' as external system type to check if a job has tasks.
*   Add a stored procedure GetStepsByExternalTaskId
    -   Returns the Step entities associated with an external task id
        -   used to update status of step when external task status changes.

### Class Diagram

![](GlusterAsyncTaskClassDiagram.png "GlusterAsyncTaskClassDiagram.png")

*   GlusterTasksSyncJob - a periodic background job that queries for list of tasks along with status

*uses*

*   GlusterTaskService - to get the list of running tasks in cluster

*which returns*

*   GlusterAsyncTask - encapsulates information about the Gluster task
*   GlusterTaskType
    -   REBALANCE
    -   REPLACE_BRICK
*   GlusterTaskStatus
    -   RUNNING
    -   FAILED
    -   COMPLETED
    -   ABORTED
    -   PAUSED

If GlusterTaskService returns a task that is not currently in the database, the information related to the task needs to be persisted in the engine database for further monitoring. -- TODO -- Can we use External Tasks --> AddExternalJobCommand to create this?

All long running commands will inherit from

*   GlusterAsyncCommandBase
    -   Creates a SUB-STEP on execution of command and associate the step with external task id
    -   Abstract method getStepType - inheriting classes to return the StepEnum to be added as Sub step when executing the command
    -   Abstract method executeAndReturnTask which inheriting classes should implement by calling the corresponding VDS command. The method should return a GlusterAsyncTask object that holds the id of the gluster task that was started due to the command.

<Category:DetailedFeature>
