---
title: Migration Enhancements
category: feature
authors: mpolednik, mskrivan, ofrenkel, sandrobonazzola, tjelinek
wiki_category: Feature|Migration Enhancements
wiki_title: Features/Migration Enhancements
wiki_revision_count: 112
wiki_last_updated: 2015-09-14
---

# Migration Enhancements

## Summary

The idea is to remove all the policies handling migrations from VDSM and move them to oVirt engine. Engine will than expose couple of well defined and well described policies from which the user will be able to pick the specific one per cluster with an option to override it per VM. Engine will than monitor the migration and change the parameters of the migration according to the policy defined.

## Migration Policies

### VDSM

*   Remove the downtime thread from migration.py
*   Make the migration_progress_timeout as a migration parameter and consider it as a hard limit (the timeout after which VDSM aborts migration even no other commands from engine arrives. This acts as a hard limit which will abort the migration in case the connection between engine and VDSM is lost for a long time so the engine policies will not apply)
*   Add a new verb migrateChangeParams with the following parameters:
    -   downtime: VM max downtime
    -   migrationTechniques: pre-copy or post-copy
    -   migrationCompression: enables quemu migration compression (true/false)
    -   auto convergence: enables quemu migration convergence (true/false)

## Network Bandwidth

### Expose Parameters from VM Level to Cluster Level

On VM level we already have under the host side tab of the edit VM dialog the:

*   Use custom migration downtime (e.g. how long the VM can be down in the last stage of migration)

We should expose this parameter to cluster level

### Expose some parameters available in VDSM conf to cluster level config

*   Max bandwidth (since this depends on the HW of the hosts and the admin should be able to set it)
*   Max timeout without convergence (migration_progress_timeout from conf)
*   Action when max timeout without convergence reached:
    -   Currently VDSM aborts the migration when the timeout is reached, we should add the support for choose between two actions:
        -   Abort (original behavior)
        -   Turn to post-copy mode (more risky but guaranteed to converge (if not fails...))

### Change logic on vdsm side

*   Allocate the bandwidth to the VMs according to the number of running migrations (e.g. if only one, allocate the full bandwidth, if two, allocate 50%/50%)
*   Don't pre-calculate the migration downtime but calculate it as a reaction to stalling. The current algorithm is:
    -   min_downtime = max_downtime / steps
    -   base = (max_downtime - min_downtime) \*\* (1 / (steps - 1))
    -   current_downtime = min_downtime + base \*\* current_step
    -   The current_step is in range from 1 to (steps -1). So the smallest downtime is max_downtime/steps and the biggest is max_downtime. The problem is that this algorithm does not take into account if the remaining memory can be migrated given the current bandwidth in the time of current_downtime. So the change will be to:
        -   If the migration progresses, leave the downtime algorithm as is. If it starts stalling, than set the min_downtime = data_remaining / bandwidth_available_for_the_vm. If the data_remaining / bandwidth_available_for_the_vm > max_downtime than the current_downtime == max_downtime. The base \*\* current_step will than give more time for the migration to progress.

## UI Changes

The cluster dialog will contain the Migration Policy part which. ![](ClusterDialogMigrationPolicy.png "fig:ClusterDialogMigrationPolicy.png")

The edit VM dialog will be able to override the following parameters:

*   Max time without convergence
*   When not converging (abort or turn to post-copy mode)
*   Max downtime
*   Enable auto convergence
*   Enable migrate compression
