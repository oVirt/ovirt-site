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

There are two main problems with the current migrations: (1) all the policies are in VDSM and are simple and not tunable and (2) the migration bandwidth is set in initialization of migration and is not adjusted during migration. The proposed solution to enhance the (1) is to remove all the policies handling migrations from VDSM and move them to oVirt engine. Engine will than expose couple of well defined and well described policies from which the user will be able to pick the specific one per cluster with an option to override it per VM. Engine will than monitor the migration and change the parameters of the migration according to the policy defined. The policies will differ in aggressiveness and in safety (e.g. switch to post-copy which guarantees that the migration will be completed with the risk that it may fail completely). The proposed solution to enhance the (2) is to take into account the current situation (max bandwidth, num of migrating VMs) while calculating the max bandwidth of the specific VM and to keep adjusting it. The logic of calculating the adjustments will be done in engine.

## Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

## VDSM Changes

### Policies

Currently the policies handling migrations are in VDSM - the monitor thread which aborts a migration after a certain time of stalling and the downtime thread which is enlarging the downtime. The proposal is to make the VDSM to fire events on migration stalling and to expose the settings of the migration parameters during migration. This way the engine will be able to implement number of different policies and also to expose the creation of the policies to user.

*   Enrich the migrate verb so it will contain the following parameters
    -   Current parameters:
        -   **dst**: remote host or hibernation image filename
        -   **dstparams**: hibernation image filename for VDSM parameters
        -   **mode** remote/file
        -   **method**: online
        -   **downtime**: allowed down time during online migration
        -   **consoleAddress**: remote host graphics address
        -   **dstqemu**: remote host address dedicated for migration
        -   **compressed**: compress repeated pages during live migration
        -   **autoConverge**: force convergence during live migration
    -   Newly proposed:
        -   **migrationProgressTimeout**: a hard limit of migration progress (the timeout after which VDSM aborts migration even no other commands from engine arrives. This acts as a hard limit which will abort the migration in case the connection between engine and VDSM is lost for a long time so the engine policies will not apply). Optional argument, default: migration_progress_timeout from conf
        -   **downtimesList**: list of downtimes calculated on engine. Optional argument, default: DowntimeThread. Its meaning is that when this value is set explicitly, the downtime thread is disabled and the engine wishes to take care of the downtime adjustments. The engine does not send only one downtime but a list of them (some kind of last will in case of the engine disappears). If the stalling event occurs, VDSM will pick the next downtime from the list and applies it. This way the VDSM will be able to converge even the engine disappears while all the logic of calculating the downtimes is still on engine. A reaction to the stalling event by engine may be to change the **downtimesList**. In case engine will be happy with the current downtime list, it will not adjust it.
        -   **endAction**: what to do on stalling event if no more downtimes specified in **downtimesList**. Possible values:
            -   **abort**: abort migration
            -   **postCopy**: change to post copy
        -   **stallingLimit**: initial value (if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to). Optional argument, default: 0 (e.g. disabled)
        -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **downtimesList**: new list of max downtimes
    -   **endAction**: what to do on stalling event if no more downtimes specified in **downtimesList**. Possible values:
        -   **abort**: abort migration
        -   **postCopy**: change to post copy
    -   **stallingLimit**: if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to
    -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf

When this verb will be called, the VDSM will store the new "last will" of the engine (e.g. the downtimeList, endAction and stallingLimit) and will apply the new value from "downtimeList" immediately.

### Bandwidth

Currently, the bandwidth is set in migration_max_bandwidth in the VDSM conf and can not be tuned. It does not take into account the num of outgoing migrations nor the incoming migrations. The proposed changes are:

*   Change the max_outgoing_migrations to max_migrations in VDSM conf. It will mean how many migrations (incoming and outgoing) are allowed on one host (e.g. if 3, than 3 incoming and 3 outgoing migrations are allowed).
*   The migrationCreate will guard to not have more than max_migrations. If it will, it will refuse to create the VM.
*   If the migrationCreate will refuse to create the VM, this VM will go back to the pool of VMs waiting for migrations (on the source host). It will be implemented only by releasing the lock and trying to acquire it again later (so other threads waiting on the same lock will have a chance to get the lock and possibly start migrating to a different host)
*   The incoming and outgoing migrations will have different semaphores
*   The bandwidth will be taken from the **migrate** verb's **maxBandwidth** parameter and will be adjusted by engine later using **migrateChangeParams**

## Engine Changes

Engine will be responsible for 2 parts:

*   Listening to the stalling events from VDSM and apply the given policy
*   In monitoring cycle of the host recalculate the max bandwidth
*   The max migration bandwidth will be set per cluster

### Policies

The policy will be basically a function calculating the list of **downtimesList** (which will be common for all policies) and a specific end action.

The function calculating the downtimesList will take two (configurable) parameters - the **limit for max downtime** and a **limit for stalling** (e.g. how long can the VM be stalling). On stalling event, the policy will than calculate a new list of **downtimesList** using the same exponential function than is presented on VDSM today but with the minimal downtime taken from the memory which needs to be transferred and the current bandwidth (e.g. it will start from something realistic).

On initialization (e.g. when no stalling happened yet), the same function as present today on VDSM will be used.

There will be 3 specific policies:

*   **Safe but not may not converge**: similar to the today's only one. The downtime will be increased until the **limit for max downtime**. If it will be stalling for more than **limit for stalling**, the migration will be aborted
*   **Guaranteed to converge but may make the VM to fail**: same function to the downtimesList as before, but the endAction will be "turn to postcopy mode".
*   **Should converge but with long pause**: it will take one more parameter, the hard limit. The downtime will be increased until the **limit for max downtime** and if reached, the hard limit will be applied for maxDowntime. This hard limit may be a very high number like 90 seconds. If it will be stalling also now, abort migration.

### Bandwidth

In each monitoring cycle of the host the engine will calculate the max bandwidth of the specific VMs migrating from it. It will try to distribute the bandwidth maximizing the outbound bandwidth while not breaking the inbound of the VMs to which it migrates to. For example, the picture below.

*   We get the monitoring cycle to the host H1. The migrations M1 and M2 could be set to 50%/50% of the max bandwidth.
*   But, the host H3 is having 3 incoming migrations so we should use only 33% of the max bandwidth for M2
*   The host H2 can accept all the bandwidth to incoming migration
*   The correct distribution for H1 is to set M1 to 70% and M2 to 30%
