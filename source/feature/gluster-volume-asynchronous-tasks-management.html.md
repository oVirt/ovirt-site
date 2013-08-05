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

<Category:Feature>
