---
title: Gluster Volume Performance Statistics
category: feature
authors: kmayilsa, sahina
wiki_category: Feature
wiki_title: Features/Gluster Volume Performance Statistics
wiki_revision_count: 20
wiki_last_updated: 2014-12-22
---

# Gluster Volume Performance Statistics

## Summary

This feature provides the support for monitoring and measuring the performance of Gluster volumes and bricks.

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>
    -   GUI Component owner: Anmol Babu <anbabu@redhat.com>
    -   Engine Component owner: Sahina Bose <sabose@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: In Progress
*   Last updated date: ,

## Detailed Description

### Top

Display results of the 'gluster volume top' command on GUI

### Profile

Display results of 'gluster volume profile' command on the GUI.

Gluster volume profile can be used to diagnose performance issues with any gluster volume. To start diagnosis, the user needs to start profiling on the volume

Once profiling is enabled, the profile info can be viewed at intervals and can be used for diagnosis.

Once diagnosis is complete, profiling needs to be stopped on the volume.

#### User Flows

Volume profiling can be started from the Volumes tab, by selecting a volume

![](Vol-profile-start.png "Vol-profile-start.png")

User can start profiling, view profile info and stop profiling using this sub menu

To view the profile info, "Details" sub-menu of the Profiling menu needs to be clicked. This will show a pop-up dialog like below

![](Vol-Profile-Details-Bricks.png "fig:Vol-Profile-Details-Bricks.png") ![](Vol-Profile-Details-NFS.png "fig:Vol-Profile-Details-NFS.png")

*   User can choose to export the data returned for the sampling interval using the "Export" button
*   User can refresh the profile data using the "Refresh" icon

## Design

<Category:Feature>
