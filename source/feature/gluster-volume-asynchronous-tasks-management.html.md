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

*   Rebalance volume
*   Remove brick

User should be able to start any of these operations as follows:

*   Select a volume and click on the button "Start Rebalance"
*   Select a brick and click on the button "Remove"
    -   When removing a brick, select/un-select a checkbox "Migrate data". If selected, the remove brick operation will be triggered in asynchronous fashion by first migrating the data from the brick to be removed.This is the default option. If not checked, the remove is performed with the "force" option to "gluster volume remove-brick" command. This is a synchronous operation

**Task Monitoring**

*   Tasks can be monitored using the Tasks sub-tab in the bottom pane of the UI
*   A child step is added to the Executing step, the status of which is periodically updated for as long as the task is in progress
*   If rebalance or remove-brick operations are started from the Gluster CLI, these can also be monitored using the Tasks sub-tab. A job entry is created for any such operation which is associated with the gluster task id.
*   User can also check the status of the task from the Volume/Bricks tabs by selecting the volume/brick.

**Task Operations**

Once started, a rebalance volume or remove-brick can be stopped while in progress. This can be done from the Volumes/Bricks tab depending on the operation.

*   For rebalance volume, clicking on the volume which is being rebalanced will enable a UI option to stop the task
*   For remove brick, clicking on one or more bricks that have a remove brick operation in progress will enable a UI option to stop the task.

## Dependencies / Related Features

## User Flows

### Rebalance Volume

*   Users can initiate a rebalance operation on a volume using the following UI

![](Start vol rebalance.png "Start vol rebalance.png")

*   If volume rebalance is in progress, the UI will be updated as follows:

![](View vol rebalance.png "View vol rebalance.png")

*   -   The icon in the Activities column indicates that "Rebalance" operation is in progress
    -   User can check status/ stop operation from the Rebalance menu. Rebalance --> Start, Rebalance --> Stop
    -   The tasks tab in the bottom pane is updated periodically with short summary status of task
    -   **\1**

<!-- -->

*   User can check the detailed status of the rebalance operation using Rebalance --> Status, which will invoke the following UI

![](Vol rebalance status.png "Vol rebalance status.png")

*   -   The status dialog gets refreshed automatically (a periodic refresh for as long as dialog is open) When the rebalance operation is done, it would also append the string "(Rebalance Completed)" to 'Status at' field.
    -   User can stop rebalance from the status window by clicking on "Stop Rebalance" button. User will be prompted for confirmation and after confirmation, it will stop the rebalance operation and show the Stop dialog as below

<!-- -->

*   To stop, the rebalance operation, user can use the Rebalance --> Stop option, which will ask for confirmation and once stopped display the status of rebalance operation as below:

![](Stop vol rebalance.png "Stop vol rebalance.png")

### Remove Brick

*   Remove Brick can be initiated from the Bricks sub tab as below:

![](StartRemovebrick.png "StartRemovebrick.png")

*   -   In Gluster CLI, remove brick is a two-step process - where data is first migrated using **remove-brick start** and then user calls **remove-brick commit** to remove the brick
    -   In the engine UI, once a user clicks on Remove -> Start, he/she is presented with a dialog that has 2 checkboxes
        -   Migrate data from bricks is ON by default. This is needed to ensure data migration before brick is removed. If unchecked, the engine will call a remove-brick force, which could lead to data loss on the bricks being removed
        -   Auto commit. If checked, once the migration of data is complete, the engine will automatically call commit on remove-brick in CLI, which removes the brick.

<!-- -->

*   -   If the user chooses to Remove brick without auto commit option, once migration of data is complete, the Tasks tab is updated with message that user needs to commit for the remove brick operation to take effect.

<!-- -->

*   Once remove brick operation is started, the UI is updated as follows (similar to Rebalance volume in progress)

![](Removebrickview.png "Removebrickview.png")

*   User can check the detailed status of the remove brick operation using Remove --> Status (it will invoke a UI similar to volume rebalance status)

![](Removebrickstatus.png "Removebrickstatus.png")

*   -   The dialog is periodically refreshed when open. If Migration of data is complete, the commit button will be enabled.
    -   User can choose to stop the remove brick operation by clicking on the "Stop Remove" button. This will ask for confirmation and display the Stop dialog as below

<!-- -->

*   To stop the remove brick operation while in progress, user can use the Remove --> Stop option. This will ask for confirmation, and if confirmed will display a dialog as below

![](Removebrickstop.png "Removebrickstop.png")

## Detailed Design

Please see [ Detailed Gluster Volume Asynchronous Tasks Management](Features/Detailed_Gluster_Volume_Asynchronous_Tasks_Management)

<Category:Feature>
