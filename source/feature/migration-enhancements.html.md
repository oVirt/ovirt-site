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

There are two main problems with the current migrations:

1.  All the policies are in VDSM, are simple and not tunable
2.  The migration bandwidth is set during initialization of migration and is not adjusted during migration.

The proposed solution to enhance issue #1 is to remove all the policies handling migrations from VDSM and move them to oVirt engine.
Engine will then expose couple of well defined and well described policies, from which the user will be able to pick the specific one per cluster, with an option to override it per VM.
Engine will then monitor the migration and change the parameters of the migration according to the defined policy.
The policies will differ in aggressiveness and in safety (e.g. switch to post-copy which guarantees that the migration will be completed with the risk that it may fail completely).
The proposed solution to enhance issue #2 is to take into account the current situation (max bandwidth, num of migrating VMs)
while calculating the max bandwidth of the specific VM, and to keep adjusting it.
The logic of calculating the adjustments will be done in engine.

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
        -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf. It is an absolute value and applies only to the current migration

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **downtimesList**: new list of max downtimes
    -   **endAction**: what to do on stalling event if no more downtimes specified in **downtimesList**. Possible values:
        -   **abort**: abort migration
        -   **postCopy**: change to post copy
    -   **stallingLimit**: if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to
    -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf

When this verb will be called, the VDSM will store the new "last will" of the engine (e.g. the downtimeList, endAction and stallingLimit) and will apply the new value from "downtimeList" immediately. It is an absolute value and applies only to the current migration

#### Example Flow

Engine will decide to start a new migration so it will send the VDSM a migrate verb. According to the max downtime and the selected policy it will send a migrate verb which will contain:

*   **downtimesList**: [20, 40, 100, 120, 300, 500] - in milliseconds
*   **stallingLimit**: 5 seconds
*   **endAction**: abort

Now:

*   Migration will start, downtime will be set to 20ms (first value) and will be proceeding.
*   At some point it starts stalling.
*   When it will be stalling for 5 seconds (**stallingLimit**) VDSM will send an event to the engine and set the downtime to 40ms (second from the list)
*   Engine will grab the event and evaluate the situation
*   Lets say it will be happy with the current setting and will not change it (e.g. do nothing)
*   Migration will be stalling again for 5 seconds, VDSM will move to 100ms and send a message to engine
*   For example a new outgoing migration started in meanwhile, it means the bandwidth for the current migration is lower and the current downtime list is not correct since it is not possible to converge on the current bandwidth and downtime, so it calculates a new list where the minimum will be the first value the VM actually can converge, say it is 300. It will send a new list (for example like this): [300, 350, 400, 500]. Note that there are 4 new values since there were 4 values left in the original list.
*   engine will call the **migrateChangeParams** with this new list
*   VDSM will immediately apply the new downtime (first from list - 300) and will replace the current list of downtimes by the new one
*   lets say from now nothing changes and VDSM will eat up all the values from downtimesList and will still be stalling
*   this is the time for endAction - it will look at it and since it was "abort", it will cancel the migration

Please note that:

*   if the engine would disappear in any given moment, VDSM would still be able to autonomously converge according to the engine's "last will" while not having any policies hardcoded in it.
*   the engine does not send any additional commands to VDSM if the situation does not change reducing the communication overhead

### Bandwidth

Currently, the bandwidth is set in migration_max_bandwidth in the VDSM conf and can not be tuned. It does not take into account the num of outgoing migrations nor the incoming migrations. The proposed changes are:

*   Add next to the max_outgoing_migrations the max_incoming_migrations in VDSM conf. It will mean how many incoming migrations are allowed on one host
*   The migrationCreate will guard to not have more than max_migrations. If it will, it will refuse to create the VM.
*   If the migrationCreate will refuse to create the VM, this VM will go back to the pool of VMs waiting for migrations (on the source host). It will be implemented only by releasing the lock and trying to acquire it again later (so other threads waiting on the same lock will have a chance to get the lock and possibly start migrating to a different host)
*   The incoming and outgoing migrations will have different semaphores
*   The bandwidth will be taken from the **migrate** verb's **maxBandwidth** parameter and will be adjusted by engine later using **migrateChangeParams**

## Engine Changes

*   Listening to the stalling events from VDSM and apply the given policy
*   In monitoring cycle of the host recalculate the max bandwidth
*   The max migration bandwidth will be set per cluster

### Policies

The policy will be basically a function calculating the list of **downtimesList** (which will be common for all policies) and an end action and initial params specific for the policy.

#### Downtime List

The function calculating the downtimesList will take two (configurable) parameters - the **limit for max downtime** and a **limit for stalling** (e.g. how long can the VM be stalling). On stalling event, the policy will than calculate a new list of **downtimesList** using the same exponential function than is presented on VDSM today but with the minimal downtime taken from the memory which needs to be transferred and the current bandwidth (e.g. it will start from something realistic). The downtime function looks like this: [DowntimeFunction.png](DowntimeFunction.png) Where:

*   **max**:
*   **min**:
*   **x**:
*   **s**:

On migration start (e.g. when no stalling happened yet since the migration is just starting), the same function as present today on VDSM will be used.

#### Initial Params

*   compressed: compress repeated pages during live migration
*   autoConverge: force convergence during live migration

#### End Action

3 possible end actions which will be executed if the VM is stalling for longer than the configured limit:

*   Abort migration: current behavior
*   Switch to hard limit for downtime: very high downtime (like 90 seconds) and if does not help, abort
*   Turn to postcopy mode

#### Specific Policies

There will be 3 specific policies:

*   **Safe but not may not converge**: similar to the today's only one. The downtime will be increased until the **limit for max downtime**. If it will be stalling for more than **limit for stalling**, the migration will be aborted. The **autoConverge** and **compressed** will be turned off.
*   **Guaranteed to converge but may make the VM to fail**: same function to the downtimesList as before, but the endAction will be "turn to postcopy mode". The **autoConverge** and **compressed** will be turned on.
*   **Should converge but with long pause**: it will take one more parameter, the hard limit. The downtime will be increased until the **limit for max downtime** and if reached, the hard limit will be applied for maxDowntime. This hard limit may be a very high number like 90 seconds. If it will be stalling also now, abort migration. The **autoConverge** and **compressed** will be turned on.

The user will be allowed to create his own policy where he will be able to configure the **autoConverge**, **compressed** and **end action** with all due limits.

### Bandwidth

In each monitoring cycle of the host the engine will calculate the max bandwidth of the specific VMs migrating from it. It will try to distribute the bandwidth maximizing the outbound bandwidth while not breaking the inbound of the VMs to which it migrates to. For example, the picture below.

*   We get the monitoring cycle to the host H1. The migrations M1 and M2 could be set to 50%/50% of the max bandwidth.
*   But, the host H3 is having 3 incoming migrations so we should use only 33% of the max bandwidth for M2
*   The host H2 can accept all the bandwidth to incoming migration
*   The correct distribution for H1 is to set M1 to 70% and M2 to 30%

This way the bandwidth optimization will be keep enhanced in each monitoring cycle for each host. This way the whole cluster should adapt to the changing situation over time without expensive optimization over the whole cluster. ![](MigrationBandwidth.png "fig:MigrationBandwidth.png")

#### Possible Enhancements

*   To avoid flooding the hosts by keep adjusting the bandwidth the change could be sent only if the difference is more than a defined number (e.g. more than 10% at least for one migration)
*   The current migration priority could be used to modify the calculation having weights incorporated - VMs with higher priority will have more bandwidth.
