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
*   Last updated date: ,

## Detailed Description

Support managing the following gluster operations that run asynchronously, from the oVirt UI

*   rebalance volume
*   remove brick

User should be able to start any of these operations as follows:

*   Select a volume and click on the button "Start Rebalance"
*   Select a brick and click on the button "Remove"
    -   When removing a brick, select/un-select a checkbox "Migrate data". If selected, the remove brick operation will be triggered in asynchronous fashion by first migrating the data from the brick to be removed.This is the default option. If not checked, the remove is performed with the "force" option to "gluster volume remove-brick" command. This is a synchronous operation

**Task Monitoring**

*   Tasks can be monitored using the Tasks sub-tab in the bottom pane of the UI
*   A child step is added to the Executing step, the status of which is periodically updated as long as the task is in progress
*   User can also check the status of the task from the Volume/Bricks tabs by selecting the volume/brick.

**Task Operations**

Once started, a rebalance volume or remove-brick can be stopped while in progress. This can be done from the Volumes/Bricks tab depending on the operation.

*   For rebalance volume, clicking on the volume which is being rebalanced will enable a UI option to stop the task
*   For remove brick, clicking on one or more bricks that have a remove brick operation in progress will enable a UI option to stop the task.

## User Flows

### Rebalance Volume

*   Users can initiate a rebalance operation on a volume using the following UI

![](Start vol rebalance.png "Start vol rebalance.png")

*   If volume rebalance is in progress, the UI will be updated as follows:

![](View vol rebalance.png "View vol rebalance.png")

*   -   The icon in the Activities column indicates that "Rebalance" operation is in progress
    -   User can check status/ stop operation from the Rebalance menu. Rebalance --> Start, Rebalance --> Stop
    -   The tasks tab in the bottom pane is updated periodically with short summary status of task

<!-- -->

*   User can check the detailed status of the rebalance operation using Rebalance --> Status, which will invoke the following UI

![](Vol rebalance status.png "Vol rebalance status.png")

*   To stop, the rebalance operation, user can use the Rebalance --> Stop option, which will display the current status of rebalance operation and ask for confirmation, as below:

![](Stop vol rebalance.png "Stop vol rebalance.png")

### Remove Brick

*   Remove Brick can be initiated from the Bricks sub tab as below:

![](StartRemovebrick.png "StartRemovebrick.png")

<Category:Feature>
