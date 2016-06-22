---
title: GlusterVolumeAdvancedDetails
category: feature
authors: kmayilsa
wiki_category: Feature
wiki_title: Features/GlusterVolumeAdvancedDetails
wiki_revision_count: 5
wiki_last_updated: 2012-09-27
---

# Gluster Volume Advanced Details

## Summary

This feature provides the ability to see the advanced details about the gluster volumes. It includes the different services running in the hosts of the cluster like NFS,SHD and the details about the bricks of a volume.

## Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   REST Component owner: Shireesh Anjal
    -   Engine Component owner: Dhandapani Gopal <dgopal@redhat.com>
    -   VDSM Component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Design Stage
*   Last updated date: Fri Sep 7 2012

## Detailed Description

This feature aims to provide to advanced details about the services and volumes in a gluster supported gluster. The currently supported service are NFS and SHD. SHD is the Self Heal Daemon used by the GlusterFS for replicated volumes. The Services sub tab will be shown only if the selected cluster supports gluster. The status, port and process related details for all the running services will be shown. In future this view will show other services as well.

The Bricks sub tab of volumes will have a new action to show the advanced details about a particular brick. The details are divided into four parts namely General, Clients, Memory Statistics and Memory Pools.

## Design

### Services tab in Cluster

![](Clusterservicestab.png "Clusterservicestab.png")

### Brick Advanced Views

![](Gluster_Brick_Advanced_View_1.png "fig:Gluster_Brick_Advanced_View_1.png") ![](Gluster_Brick_Advanced_View_2.png "fig:Gluster_Brick_Advanced_View_2.png") ![](Gluster_Brick_Advanced_View_3.png "fig:Gluster_Brick_Advanced_View_3.png") ![](Gluster_Brick_Advanced_View_4.png "fig:Gluster_Brick_Advanced_View_4.png")

