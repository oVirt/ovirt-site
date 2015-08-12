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

The idea is to remove all the policies handling migrations from VDSM and move them to oVirt engine. Engine will than expose couple of well defined and well described policies from which the user will be able to pick the specific one per cluster with an option to override it per VM. Engine will than monitor the migration and change the parameters of the migration according to the policy defined. The policies will differ in aggressiveness and in safety (e.g. switch to post-copy is dangerous but guarantees the VM to be migrated).

## Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

## VDSM Changes

*   Enrich the migrate verb so it will contain the following parameters
    -   Current parameter:
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

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **downtime**: VM max downtime
    -   **migrationTechnique**: pre-copy or post-copy
    -   **stallingLimit**: if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to

## Engine Changes

Engine will be listening to the the evnts sent from VDSM if the VM is stalling. Specific policies TBD when the VDSM side will be discussed/finalized.
