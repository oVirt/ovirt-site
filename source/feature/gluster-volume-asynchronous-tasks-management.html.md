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

<Category:Feature>
