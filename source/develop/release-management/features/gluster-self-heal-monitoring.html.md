---
title: Gluster Self-Heal Monitoring
category: feature
authors: rnachimu
wiki_category: Feature
wiki_title: Features/Gluster Self-Heal Monitoring
wiki_revision_count: 1
wiki_last_updated: 2016-04-29
feature_name: Gluster Self-Heal Monitoring
feature_modules: Gluster
feature_status: WIP
---

# Gluster Self Heal Monitoring

## Summary

Gluster Self Heal helps to heal data on the gluster bricks when there are some inconsistencies among the replica pairs in the volume. Pro-active self-heal daemon runs in the background, diagnoses issues and automatically initiates self-healing every 10 minutes on the files which require healing. Ovirt needs to monitor gluster self heal status so that user can know that his volume needs healing. Also it is important to prevent hosts from moving to maintenance when there are some unsynced entries in the bricks which needs to be healed. This document talks about the design of Gluster Self Heal monitoring from oVirt and how this can be used in host maintenance flows.

## Owner

*   Name: [Ramesh Nachimuthu](User:rnachimu)
*   Email: <rnachimu@redhat.com>

## Current status
*   Target Release: 4.0
*   Status: In development.

## Monitoring Self Heal
We will monitor self heal status at the volume level. ‘gluster volume heal VOLNAME info’ command will be used to get the heal info. If there are some unsynced entries in the volume then volume will be marked as ‘Needs Healing’ and bricks which are having unsynced entries will be marked accordingly. Ovrit will sync self heal info for all the gluster volumes with frequency of 10 minutes.

## Host Maintenance and Fencing
Self-Heal status and Cluster quorum should be considered while moving the host to maintenance or fencing the host. Host will not be allowed to move to maintenance/fence when there are some unsynced entries present on the bricks from the particular host. Considering Heal info sync interval is 10 minutes, we will fetch heal info before moving the host to maintenance. If brick processes are dwon on the node then maintenance will be allowed. Also, we will provide a force option in the UI which can be used to move the host to maintenance even when there are some unsynced entries in the host. 

Host Maintenance and Fencing will be enabled/disabled based on the following criteria.

| Heal Status | Quorum Status | Maintenance/Fencing |
| --- | --- | --- |
| Bricks are Down | --- | Allowed |
| Unsynced Entries present | --- | Not Allowed |
| No Unsynced Entries | Quorum available without this Node | Allowed |
| No Unsynced Entries | Quorum not available without this Node | Not Allowed |

## Entity Changes
Following entities will be changed as part of Gluster self heal monitoring.

### Gluster_volume_bricks
  Following columns will be added to gluster_volume_bricks table.
  unsynced_entries  - integer - No.of unsynced entries in the brick.
  unsynced_entires_history - text - History of unsynced entries in the brick. It will a list of comma separated values.
  
### Gluster_volumes_view
‘heal_status’ column will be be added to gluster_volumes_view. It will be computed based on unsynced_entries in the brick. If there is any unsynced_entry in any of the bricks in the volume then ‘heal_status’ will be ‘Needs_Healing’.

## UI Changes

### Volumes Tab
‘Info’ column will be used to show the self heal status. New icon will be shown in the info column when there are unsynced entries in the bricks.

### Bricks Sub Tab
‘Unsynced Entries’ column will be added to bricks sub tab under Volumes and Hosts tab. This will show the number of unsynced entries present in the brick with a trending. Trending helps to understand whether the unsynced entires are getting reduced are keep increasing.
