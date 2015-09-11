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

There are several problems with current migrations:

1.  All the policies are in VDSM, are simple and not tunable
2.  There is no way to configure the max incoming migrations; the max outgoing migrations and max bandwidth are set on VDSM side only

The proposed solution to enhance issue #1 is to remove all the policies handling migrations from VDSM and move them to oVirt engine.
Engine will then expose couple of well defined and well described policies, from which the user will be able to pick the specific one per cluster, with an option to override it per VM.
The policies will differ in aggressiveness and in safety (e.g. switch to post-copy which guarantees that the VM will be moved and start working on the destination with the risk that it may fail to complete later). For more details about post-copy migration see <https://en.wikipedia.org/wiki/Live_migration#Post-copy_memory_migration>
The proposed solution to enhance issue #2 is to expose the max incoming/outgoing migrations and the max bandwidth as configurable cluster level values and configure them from engine.

1.  There is no prevention of network overload in case the same network is shared for migration and other traffic (VM, display, storage, management)

## Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <tjelinek@redhat.com>
*   BZ: [https://bugzilla.redhat.com/show_bug.cgi?id=1252426 1252426](https://bugzilla.redhat.com/show_bug.cgi?id=1252426 1252426)

## VDSM Changes

### Policies

Currently the policies handling migrations are in VDSM - the monitor thread which aborts a migration after a certain time of stalling and the downtime thread which is enlarging the downtime. The proposal is to make the VDSM to send also the current maxDowntime in the stats and to expose the settings of the migration parameters during migration. This way the engine will be able to implement number of different policies and also to expose the creation of the policies to user.

*   Enrich the migrate verb so it will contain the following parameters
    -   Current parameters:
        -   **hiearchical**: remote host or hibernation image filename
        -   **dstparams**: hibernation image filename for VDSM parameters
        -   **mode** remote/file
        -   **method**: online
        -   **downtime**: allowed down time during online migration
        -   **consoleAddress**: remote host graphics address
        -   **dstqemu**: remote host address dedicated for migration
        -   **compressed**: compress repeated pages during live migration (XBZRLE)
        -   **autoConverge**: force convergence during live migration
    -   Newly proposed:
        -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf. It is an absolute value and applies only to the current migration (currently 32MiBps)
        -   **convergenceSchedule**: list of pairs: (stallingLimit, action) where
            -   **stallingLimit**: if the migration is stalling(not progressing) for this amount of time, execute the action and move to next pair
            -   **action**: one of:
                -   **setDowntime(N)**: sets the maximum downtime to N
                -   **abort**: abort migration
                -   **postCopy**: change to post copy
            -   This schedule will effectively replace the "migration_progress_timeout" from vdsm.conf (e.g. if the VM is stalling for this amount of time, VDSM aborts the migration). The whole **convergenceSchedule** is an optional argument, default: migration_progress_timeout from conf (150s)

An example how the **convergenceSchedule** would look like: [ (10, setDowntime(200)), (20, setDowntime(500)), (20, setDowntime(1000)), (50, abort) ]

The behavior of the VDSM in this case will be as follows:

*   Starts the migration with the **downtime** from the current parameters
*   In the monitor thread monitors the migration
*   If the migration progresses, does nothing, just keeps monitoring
*   If the migration starts stalling for more than 10 seconds, executes the action setDowntime 200 (e.g. sets the maximum allowed downtime to 200ms)
*   If the migration stalls for another 20 seconds, sets the timeout to 500
*   If the migration stalls for another 20 seconds, sets the timeout to 1000
*   If the migration stalls for another 50 seconds aborts the migration

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **convergenceSchedule**: list of pairs: (stallingLimit, action) where
    -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf (32 MiBps)

When this verb will be called, the VDSM will store the new "last will" of the engine (e.g. the **convergenceSchedule**) and apply the new **maxBandwidth** immediately.

### Bandwidth

Currently, the bandwidth is set in migration_max_bandwidth in the VDSM conf and can not be tuned from engine. There is also no way to set the max incoming migrations. The proposed changes are:

*   Add max_incoming_migrations (in addition to existing max_outgoing_migrations) to VDSM conf. It will mean how many incoming migrations are allowed on one host. This should help against migration storms (several hosts going NonOperational starting evacuating all VMs to the last few remaining hosts)
*   The migrationCreate will guard to not have more than max_incoming_migrations. It shall refuse to create the VM when exceeded.
*   When the migrationCreate refuse to create the VM, this VM will go back to the pool of VMs waiting for migrations (on the source host). It will be implemented only by releasing the lock and trying to acquire it again later (so other threads waiting on the same lock will have a chance to get the lock and possibly start migrating to a different host)
*   The incoming and outgoing migrations will have different semaphores
*   The bandwidth will be taken from the **migrate** verb's **maxBandwidth** parameter
*   A new verb **migrateChangeConcurrentMigrations** will be added which will change the current values of the num of concurrent migrations for the given host (e.g. override the ones from vdsm.conf). It will have the following params:
    -   **max_outgoing_migrations**: same meaning as in vdsm.conf
    -   **max_incoming_migrations**: same meaning as in vdsm.conf
*   The getVdsCaps will return also the **max_outgoing_migrations** and **max_incoming_migrations** which will serve as default for the engine.
*   By default, the engine will not send the **migrateChangeConcurrentMigrations** (e.g. the values from the vdsm.conf will be used).
*   If overridden by engine, the engine will call the migrateChangeConcurrentMigrations for all hosts in cluster (and make sure to call it every time any host gets to up state).

### Traffic shaping

At the moment, VDSM doesn't use traffic shaping or any other kind of traffic control. Traffic shaping can result in better migration performance (downtime, convergence, latency...) in most of network situations when using some kind of Active Queue Management (AQM) .e.g CODEL or FQ_CODEL. More importantly by guaranteeing a minimal QoS of the management traffic it should help preventing erratic communication between the host and the engine (timeouts/disconnects, hosts going NonResponsive)

VDSM should

*   ensure that AQM is used on outbound if,
*   possibly create hierarchical traffic shaping structure.

#### References

<https://bugzilla.redhat.com/show_bug.cgi?id=1255474>

## Engine Changes

*   The max migration bandwidth and max concurrent migrations will be set per cluster
*   Engine will implement policies which will calculate the **convergenceSchedule** according to max bandwidth, max concurrent migrations and aggressiveness of the policy

### Policies

The policy will basically be a configurable structure containing:

*   function for calculating the list of downtimes as reactions for stalling (which will be common for all policies)
*   an end action (specific for policy)
*   initial params (specific for policy)

#### Downtime List

The function calculating the list of downtime settings will take two (configurable) parameters - the **limit for max downtime** and a **limit for stalling** (e.g. how long can the VM be stalling).

To be more specific, the function calculating downtimesList function looks like this:

![](DowntimeFunction.png "DowntimeFunction.png")

Where:

*   **max**: limit for max downtime
*   **min**: minimal downtime where it is possible to transfer the remaining stalling data given the current bandwidth. At initialization **max / s** - same as currently present in VDSM
*   **x**: 0 .. (s -1). E.g. the index (zeroth, first, second...)
*   **s**: num of steps (values in the list). Will be calculated like: **migrationProgressTimeout** /**stallingLimit**. E.g. if the **migrationProgressTimeout** is going to be 150s and the **stallingLimit** 15s, than the **s** is going to be 10 which means there will be 10 values in the list (at initialization). When the VM is already stalling for some time **alreadyStalled**, than **(migrationProgressTimeout - alreadyStalled)** /**stallingLimit**
*   **migrationProgressTimeout**: is a value which will be configured per policy. Means how long the VM can be stalling before the migration will be aborted or turned to post-copy.

#### Initial Params

*   compressed: compress repeated pages during live migration
*   autoConverge: force convergence during live migration

#### End Action

3 possible end actions which will be executed if the VM is stalling for longer than the configured limit:

*   Abort migration: current behavior
*   Switch to hard limit for downtime: very high downtime (like 90 seconds) and if does not help, abort
*   Turn to post-copy mode. Please note that the migration always starts as pre-copy; turning to post copy can be triggered only during migration. We are making use of this by starting by safe pre-copy and if stalling, migrate the last bit using post-copy. The turn to post copy is a terminal state, after this VM is paused on the source so no more monitoring of the source is needed

#### Specific Policies

There will be 3 specific policies:

*   **Safe but not may not converge**: similar to the today's only one. The downtime will be increased until the **limit for max downtime**. If it will be stalling for more than **limit for stalling**, the migration will be aborted. The **autoConverge** and **compressed** will be turned off.
*   **Guaranteed to converge**: same function to the downtimesList as before, but the endAction will be "turn to postcopy mode". The **autoConverge** and **compressed** will be turned on.
*   **Should converge but guest may notice a pause**: it will take one more parameter, the hard limit. The downtime will be increased until the **limit for max downtime** and if reached, the hard limit will be applied for maxDowntime. This hard limit may be a very high number like 90 seconds. If it will be stalling also now, abort migration. The **autoConverge** and **compressed** will be turned on.

The user will be allowed to create his own policy where he will be able to configure the **autoConverge**, **compressed** and **end action** with all due limits.

### Bandwidth

2 new cluster level values will be introduced:

*   **maxMigrationBandwidth**: max bandwidth which can be used by migrations
*   **maxNumOfConcurrentMigrations**: how many migrations (incoming or outgoing) are allowed to run in parallel

The **maxBandwidth** param of the **migrate** verb will be simply calculated as **maxMigrationBandwidth** / **maxNumOfConcurrentMigrations**.

#### maxMigrationBandwidth

By default the engine finds the host with the smallest bandwidth on the migration network and use it. If the user overrides it, this overridden value will be used.

#### maxNumOfConcurrentMigrations

By default, the minimum from the caps of all hosts will be used. If overridden, the engine will send the **migrateChangeConcurrentMigrations** where both the **max_outgoing_migrations** and the **max_incoming_migrations** will be set to **maxNumOfConcurrentMigrations**. Engine will also make sure to set the **maxNumOfConcurrentMigrations** for all hosts which will turn into up state (e.g. after being in maintenance or added to cluster).

## Action Items

*   Add support for limiting of incoming migrations on VDSM side
*   Expose the **migrationProgressTimeout** and **maxBandwidth** to **migrate** verb and implement the **migrateChangeParams** verb with **maxBandwidth**
*   Implement the **convergenceSchedule** to both **migrate** and **migrateChangeParams** (without the support for post-copy migration)
*   Implement support for post-copy migrations (both engine and VDSM) - this may be a big change especially for the engine side
*   Add support for getting the **max_outgoing_migrations** and **max_incoming_migrations** from VDSM and setting it back (both engine and VDSM side) and **maxBandwidth** cluster level setting on engine
*   Implement specific policies on engine side
