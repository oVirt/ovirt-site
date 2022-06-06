---
title: Gluster Volume Asynchronous Tasks Management
category: feature
authors:
  - dusmant
  - kmayilsa
  - sahina
  - shireesh
---

# Gluster Volume Asynchronous Tasks Management

## Summary

This feature provide the support for managing the asynchronous tasks on Gluster volumes.

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy
    -   Engine Component owner: Sahina Bose <sabose@redhat.com>
    -   VDSM component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   REST component owner: Sahina Bose <sabose@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Completed
*   Last updated date: ,
*   Requires : glusterfs >= 3.5

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

User flow that's given in "Rebalance Volume" and "Remove Brick" section, has been slightly altered after the UX team's review. Though the functionality remains same, the menu and flows have been altered.

**Pls. take a look at the flow description ( no images attached - only description ) given bellow to know the changes...** Rebalance Operation related UI modifications

Now the "Rebalance" menu does not have any of the Start, Stop and Status sub-menu. And this menu would come before the "Optimization for Virt Store".

To Start Rebalance operation on a volume: User goes to the volume tab and selects one or more volume and clicks the "Rebalance" menu (Note : Rebalance menu will not be activated, when no row in the Volume table is selected. Currently no default row is selected when the user comes to the volume page ). This will start the rebalance operation on the selected Volume(s) and the "Activities" column for those volume will show an icon indicating that the rebalance operation is on progress on those volumes. The rebalance-progress icon will be changed to rebalance-completed-successfully icon, once the rebalance task on the volume is finished successfully. If the rebalance operation fails on any of the selected volumes, then the icon will change to rebalance-fail icon. If all the bricks of the selected volume is down ( volume status is shown with yellow-exclamation mark ), then the pressing Rebalance menu would give a proper warning, saying rebalance operation can not be started.

The rebalance progress icon, will also have a drop down arrow, which can be clicked by the end user to get the context sensitive menu. Upon clicking that, a menu will be shown. If the rebalance operation is in-progress on the volume, then the following two menu items will be shown. "Stop" and "Status". Otherwise, it will show only the "Status" menu.

If the user clicks the "Stop" menu, user will be given a confirmation dialogue, which would ask "Do you want to stop the rebalance operation on the selected volume?". If the user presses the "Yes", then the rebalance operation on that volume will be stopped and rebalance-status dialogue will be shown (no change in status dialogue). If the user presses the "No" button, then the rebalance operation will not be stopped and this dialogue will be closed.

If the user clicks the "Status" menu, then rebalance-status dialogue will be shown (it will be same as already given description bellow)

Smilarly the Remove brick

Few other items, that are modified in the course of Corbett are as follows : There is not a whole lot of change, but it makes sense to have them captured....

1. When one or more brick is down in a volume, volume status would be shown as Yellow-Up arrow ( volume service is still up )

2. If all the bricks are down in a volume, volume status would be shown as Yellow-Up Arrow + Yellow-exclamation mark ( volume service is till up )

### Rebalance Volume

*   Users can initiate a rebalance operation on a volume using the following UI

![](/images/wiki/Start_vol_rebalance.png)

*   If volume rebalance is in progress, the UI will be updated as follows:

![](/images/wiki/View_vol_rebalance.png)

*   -   The icon in the Activities column indicates that "Rebalance" operation is in progress
    -   User can check status/ stop operation from the Rebalance menu. Rebalance --> Start, Rebalance --> Stop
    -   The tasks tab in the bottom pane is updated periodically with short summary status of task
    -   **\1**

<!-- -->

*   User can check the detailed status of the rebalance operation using Rebalance --> Status, which will invoke the following UI

![](/images/wiki/Vol_rebalance_status.png)

*   -   The status dialog gets refreshed automatically (a periodic refresh for as long as dialog is open) When the rebalance operation is done, it would also append the string "(Rebalance Completed)" to 'Status at' field.
    -   User can stop rebalance from the status window by clicking on "Stop Rebalance" button. User will be prompted for confirmation and after confirmation, it will stop the rebalance operation and show the Stop dialog as below

<!-- -->

*   To stop, the rebalance operation, user can use the Rebalance --> Stop option, which will ask for confirmation and once stopped display the status of rebalance operation as below:

![](/images/wiki/Stop_vol_rebalance.png)

### Remove Brick

*   Remove Brick can be initiated from the Bricks sub tab as below:

![](/images/wiki/StartRemovebrick.png)

*   -   In Gluster CLI, remove brick is a two-step process - where data is first migrated using **remove-brick start** and then user calls **remove-brick commit** to remove the brick
    -   In the engine UI, once a user clicks on Remove -> Start, he/she is presented with a dialog that has 2 checkboxes
        -   Migrate data from bricks is ON by default. This is needed to ensure data migration before brick is removed. If unchecked, the engine will call a remove-brick force, which could lead to data loss on the bricks being removed
        -   Auto commit. If checked, once the migration of data is complete, the engine will automatically call commit on remove-brick in CLI, which removes the brick.

<!-- -->

*   -   If the user chooses to Remove brick without auto commit option, once migration of data is complete, the Tasks tab is updated with message that user needs to commit for the remove brick operation to take effect.

<!-- -->

*   Once remove brick operation is started, the UI is updated as follows (similar to Rebalance volume in progress)

![](/images/wiki/Removebrickview.png)

*   ''UX input required - Need a way in Bricks sub tab to indicate that remove brick is in progress on one or more bricks - Icon or colour coding rows? ''
*   User can check the detailed status of the remove brick operation using Remove --> Status (it will invoke a UI similar to volume rebalance status)

![](/images/wiki/Removebrickstatus.png)

*   -   The dialog is periodically refreshed when open. If Migration of data is complete, the commit button will be enabled.
    -   User can choose to stop the remove brick operation by clicking on the "Stop Remove" button. This will ask for confirmation and display the Stop dialog as below

<!-- -->

*   To stop the remove brick operation while in progress, user can use the Remove --> Stop option. This will ask for confirmation, and if confirmed will display a dialog as below

![](/images/wiki/Removebrickstop.png)

## Detailed Design

Please see [Detailed Gluster Volume Asynchronous Tasks Management](/develop/release-management/features/gluster/detailed-gluster-volume-asynchronous-tasks-management.html)

