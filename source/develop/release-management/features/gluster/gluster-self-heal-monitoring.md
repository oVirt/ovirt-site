---
title: Gluster Self-Heal Monitoring
category: feature
authors: rnachimu
---

# Gluster Self Heal Monitoring

## Summary

Gluster Self Heal helps to heal data on the gluster bricks when there are some inconsistencies among the replica pairs in the volume. Pro-active self-heal daemon runs in the background, diagnoses issues and automatically initiates self-healing every 10 minutes on the files which require healing. oVirt needs to monitor gluster self heal status so that user can know that his volume needs healing. Also it is important to prevent hosts from moving to maintenance when there are some unsynced entries in the bricks which needs to be healed. This document talks about the design of Gluster Self Heal monitoring from oVirt and how this can be used in host maintenance and fencing flows.

## Owner

*   Name: Ramesh Nachimuthu (rnachimu)
*   Email: <rnachimu@redhat.com>

## Current status
*   Target Release: 4.0
*   Status: In development.

## Monitoring Self Heal
We will monitor self heal status at the volume level. ‘gluster volume heal VOLNAME info’ command will be used to get the heal info. If there are some unsynced entries in the volume then volume will be marked as ‘Needs Healing’ and bricks which are having unsynced entries will be marked accordingly. oVirt will sync self heal info for all the gluster volumes with frequency of 10 minutes. Synchronization frequency can be changed using engine-config option 'GlusterRefreshRateHealInfo'.

## Entity Changes
Following entities will be changed as part of Gluster self heal monitoring.

### Gluster_volume_bricks
Following columns will be added to gluster_volume_bricks table.

  unsynced_entries  - integer - No.of unsynced entries in the brick.

  unsynced_entries_history - text - History of unsynced entries in the brick. It will be a list of comma separated values. By default, last 40 entries will be stored in the field. The limit can be changed using engine-config option 'GlusterUnSyncedEntriesHistoryLimit'.

## Host Fencing
New fencing policies will be added for Gluster Quorum and Brick Status. These policies can be enabled at Cluster level.
These policies will be checked after all other existing policies. Similar to existing fencing policies, these policies will not prevent SSH Soft fencing. These police information will be passed to 'fenceNode' VDSM verb and following check will be executed before fencing the host.

    if (host supports both gluster & virt services)
      if(all bricks are down)
        allow host fencing
      else(some || all bricks are up)
        if ('skip fencing if Bricks are up is enforced)
          skip host fencing
        else
          if (quorum is not maintained without this host && 'skip fencing if Quorum is not met' is enforced)
            skip host fencing
          else
            allow host fencing

#### Note:
Current Self-Heal info command takes long time to respond so ware working on a better way to determine if a host is source of self healing. Until then, we will check just the brick status.

More info about standard host fencing is available at http://old.ovirt.org/Automatic_Fencing#Automatic_Fencing http://old.ovirt.org/Fence_kdump https://www.youtube.com/watch?v=V1JQtmdleaM
 
## Host Maintenance
Self-Heal status and Cluster quorum should be considered while moving the host to maintenance or fencing the host. Host will not be allowed to move to maintenance/fence when there are some unsynced entries present on the bricks from the particular host. Considering Heal info sync interval is 10 minutes, we will fetch heal info before moving the host to maintenance. If brick processes are down on the node then maintenance will be allowed. Also, we will provide a force option in the UI which can be used to move the host to maintenance even when there are some unsynced entries in the host. 

Host Maintenance will be enabled/disabled based on the following criteria.

| Heal Status | Quorum Status | Maintenance/Fencing |
| --- | --- | --- |
| Bricks are Down | --- | Allowed |
| Unsynced Entries present | --- | Not Allowed |
| No Unsynced Entries | Quorum available without this Node | Allowed |
| No Unsynced Entries | Quorum not available without this Node | Not Allowed | 

###MaintenanceNumberOfVdssCommand (for Host Maintenance)
  MaintenanceNumberOfVdssCommand is used for moving one or more number of hosts to maintenance. It will be enhanced to consider gluster self-heal and quorum before moving the host to maintenance. Following validations will be added to MaintenanceNumberOfVdssCommand.validate() method.
  
     if (host supports both gluster & virt services & not force-maintenance)
      if(all bricks are down)
        allow host maintenance
      else(some || all bricks are up)
        if (unsynced entries  > 0 for any up brick) //Entries needs to be healed from this host
          disable host maintenance
        else
          if (quorum is maintained (bricks and nodes for ALL volumes) with this host down)
            allow host maintenance
          else
            disable host maintenance
  
## UI Changes

### Volumes Tab
New icon with warning symbol will be shown on the status column for the volumes with unsynced entries and tool tip will show the text 'UP/Some Bricks Down, Unsynced entries present - Needs healing'

### Bricks Sub Tab
New icon with warning symbol will be shown on the status column for the bricks with unsynced entries and tool tip will show the text 'UP,  X unsynced entries present'

‘Self-Heal Info’ column will be added to bricks sub tab under Volumes and Hosts tab. This will show one of the following details based the available information.

- 'N/A' when there self-heal info is not available
- 'OK' when there is no unsynced entry present in the volume
- 'X unsynced entries present' when unsynced entries present and its not getting reduced (healed)
- Expected time to heal all the unsynced entries will be shown if more then two values found in 'unsynced_entries_history' for the brick and it shows.

#####Note: 
Expected time to heal is computed as follows:

1. Calculate the average heal rate using 'unsynced_entries_history'. For example, if we have values '1000, 800, 600' in 
'unsynced_entries_history' and self-heal info sync frequency is 10 minutes then average heal rate will be 20 minutes.
2. Expected time to heal is calculated using unSyncedEntries/average heal rate.

 
