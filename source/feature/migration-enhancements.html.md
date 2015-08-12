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

There are two main problems with the current migrations: (1) all the policies are in VDSM and are simple and not tunable and (2) the migration bandwidth is set in initialization of migration and is not adjusted during migration. The proposed solution to enhance the (1) is to remove all the policies handling migrations from VDSM and move them to oVirt engine. Engine will than expose couple of well defined and well described policies from which the user will be able to pick the specific one per cluster with an option to override it per VM. Engine will than monitor the migration and change the parameters of the migration according to the policy defined. The policies will differ in aggressiveness and in safety (e.g. switch to post-copy is dangerous but guarantees the VM to be migrated). The proposed solution to enhance the (2) is to take into account the current situation (max bandwidth, num of migrating VMs) while calculating the max bandwidth of the specific VM and to keep adjusting it in the monitoring thread.

## Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

## VDSM Changes

### Policies

Currently the policies handling migrations are in VDSM - the monitor thread which aborts a migration after a certain time of stalling and the downtime thread which is enlarging the downtime. The proposal is to make the VDSM to fire events on migration stalling and to expose the settings of the migration parameters during migration. This way the engine will be able to implement number of different policies and also to expose the creation of the policies to user.

*   Enrich the migrate verb so it will contain the following parameters
    -   Current parameters:
        -   **dst**: remote host or hibernation image filename
        -   **dstparams**: hibernation image filename for vdsm parameters
        -   **mode** remote/file
        -   **method**: online
        -   **downtime**: allowed down time during online migration
        -   **consoleAddress**: remote host graphics address
        -   **dstqemu**: remote host address dedicated for migration
        -   **compressed**: compress repeated pages during live migration
        -   **autoConverge**: force convergence during live migration
    -   Newly proposed:
        -   **migrationProgressTimeout**: a hard limit of migration progress (the timeout after which VDSM aborts migration even no other commands from engine arrives. This acts as a hard limit which will abort the migration in case the connection between engine and VDSM is lost for a long time so the engine policies will not apply). Optional argument, default: migration_progress_timeout from conf
        -   **downtime**: initial downtime. Optional argument, default: DowntimeThread. Its meaning is that when this value is set explicitly, the downtime thread is disabled and the engine wishes to take care of the downtime adjustments
        -   **stallingLimit**: initial value (if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to). Optional argument, default: 0 (e.g. disabled)
        -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **downtime**: VM max downtime
    -   **migrationTechnique**: pre-copy or post-copy
    -   **stallingLimit**: if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to

### Bandwidth

Currently, the bandwidth is set in migration_max_bandwidth in the vdsm conf and can not be tuned. It does not take into account the num of outgoing migrations nor the incoming migrations. The proposed changes are:

*   Add a new config value to vdsm conf min_migration_bandwidth. Since the bandwidth will be dynamically set, we need to guarantee it will not fall down to very low values effectively stopping it.
*   Calculate the bandwidth as: maxBandwidth / (max(numOfAllSrcMigrations, numOfAllDestMigrations)), where numOfAllSrcMigrations = (allOutgoingMigrations + allIncomingMigrations) from the source and numOfAllDestMigrations is the same for destination. The minimal bandwidth will be min_migration_bandwidth from vdsm conf
*   The numOfAllDestMigrations will be taken by getStats from the destination host
*   If the destination host will not answer, we expect it is overloaded and will slow down to half of the currently set speed. The minimal speed to which to slow down is min_migration_bandwidth from vdsm vconf.
*   Recalculate the bandwidth of the migrating vms in each monitoring cycle of the MonitorThread.

## Engine Changes

Engine will be listening to the the events sent from VDSM if the VM is stalling. Specific policies TBD when the VDSM side will be discussed/finalized.
