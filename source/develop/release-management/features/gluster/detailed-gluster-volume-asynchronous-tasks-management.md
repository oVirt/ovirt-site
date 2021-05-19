---
title: Detailed Gluster Volume Asynchronous Tasks Management
category: feature
authors: sahina
---

# Detailed Gluster Volume Asynchronous Tasks Management

## Gluster Volume Asynchronous Tasks

### Summary

This feature provide the support for managing the asynchronous tasks on Gluster volumes. See: [Gluster Volume Asynchronous Tasks Management](/develop/release-management/features/gluster/gluster-volume-asynchronous-tasks-management.html)

### Owner

*   Name: Sahina Bose (Sahina)
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

#### Entity Changes

<big>gluster_volumes</big>

| Column | Type          | Change   | Description                                                     |
|--------|---------------|----------|-----------------------------------------------------------------|
| taskid | int, nullable | Addition | stores the gluster task id for operation in progress on volume. |

<big>gluster_volume_bricks</big>

| Column | Type          | Change   | Description                                                    |
|--------|---------------|----------|----------------------------------------------------------------|
| taskid | int, nullable | Addition | stores the gluster task id for operation in progress on brick. |

### Class Diagram

![](/images/wiki/GlusterAsyncTaskClassDiagram.png)

*   GlusterTasksSyncJob - a periodic background job that queries for list of tasks along with status

*uses*

*   GlusterTaskService - to get the list of running tasks in cluster

*which returns*

*   GlusterAsyncTask - encapsulates information about the Gluster task
    -   GlusterTaskType
        -   REBALANCE
        -   REMOVE_BRICK
    -   GlusterTaskStatus
        -   RUNNING
        -   FAILED
        -   COMPLETED
        -   ABORTED
        -   PAUSED

If GlusterTaskService returns a task that is not currently in the database, the information related to the task needs to be persisted in the engine database for further monitoring.

*   AddInternalJobCommand to be introduced to achieve this

All long running commands will inherit from

*   GlusterAsyncCommandBase
    -   Creates a SUB-STEP on execution of command and associate the step with external task id
    -   Abstract method getStepType - inheriting classes to return the StepEnum to be added as Sub step when executing the command
    -   Abstract method executeAndReturnTask which inheriting classes should implement by calling the corresponding VDS command. The method should return a GlusterAsyncTask object that holds the id of the gluster task that was started due to the command.
    -   Start of async operations will acquire a lock. The lock will be released when Stop of corresponding command is called by the user or when the tasks sync job discovers that the task has been completed.

The following sequence diagram explains the Gluster tasks monitoring mechanism ![](/images/wiki/GlusterTasksSeqDiagram.png)

### REST API

*   Add startrebalance action on the gluster volumes resource

      /api/clusters/{id}/glustervolumes/{id}/rebalance

This will return a step id which can be monitored from jobs/step api url

*   Add stoprebalance action on the gluster volumes resource

      /api/clusters/{id}/glustervolumes/{id}/stoprebalance

This will stop the rebalance action that is currently in progress

*   Modify the delete verb for bricks

      DELETE /api/clusters/{id}/glustervolumes/{id}/bricks/

Deletes a collection of bricks without data migration.

*   Add migrate action to the gluster bricks resource

       /api/clusters/{id}/glustervolumes/{id}/bricks/migrate

Allow data on collection of bricks to be migrated. This will return a step id which can be monitored from jobs/step api url. If false, data is lost and remove returns synchronously.

*   Add stop migrate action to the gluster bricks resource

      /api/clusters/{id}/glustervolumes/{id}/bricks/stopmigrate

This will stop the migration of data from the bricks that is currently in progress

*   Add commit action to the gluster bricks resource

      /api/clusters/{id}/glustervolumes/{id}/bricks/commit

This will commit the removal of brick. This can be called only when data is successfully migrated from the brick

How do we monitor the status of the rebalance and remove-brick operations?

*   -   Step id will be used to monitor the status of the rebalance and migrate operation. This will be returned once remove or migrate is called
    -   api/jobs/{id}/steps/{id} will contain detailed status if All-Content is set to true

