---
title: Gluster Volume Asynchronous Tasks Management
category: feature
authors: dusmant, kmayilsa, sahina, shireesh
wiki_category: Feature
wiki_title: Features/Gluster Volume Asynchronous Tasks Management
wiki_revision_count: 28
wiki_last_updated: 2014-12-22
---

# Gluster Volume Asynchronous Tasks Management

## Summary

This feature provide the support for managing the asynchronous tasks on Gluster volumes.

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Sahina Bose <sabose@redhat.com>
    -   VDSM component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   REST component owner: Sahina Bose <sabose@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Development in progress
*   Last updated date: Wed Feb 20 2013

## Detailed Description

Support managing the following gluster async tasks from the oVirt UI

*   rebalance volume
*   replace brick
*   remove brick

User should be able to start any of these tasks as follows:

*   Select a volume and click on the button "Start Rebalance"
*   Select a brick and click on the button "Replace"
*   When removing a brick, select/un-select a checkbox "Retain data". If selected, the remove brick operation should be triggered in asynchronous fashion. If not, it should be performed in a synchronous way by passing the "force" option to "gluster volume remove-brick" command

**Task Monitoring**

*   Introduce a new sub-tab "Tasks" under "Clusters", which lists all running gluster tasks on the selected cluster, along with the current status.
*   User should be able to select a task in this view, and perform any of the operations supported on that task. These could be any of

      - pause
      - resume
      - abort
      - commit

## Design

### Database changes

*   Change to stored procedure CheckIfJobHasTasks
    -   Add 'GLUSTER' as external system type to check if a job has tasks.
*   Add a stored procedure GetStepsByExternalTaskId
    -   Returns the Step entities associated with an external task id

      used to update status of step when external task status changes.

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

<Category:Feature>
