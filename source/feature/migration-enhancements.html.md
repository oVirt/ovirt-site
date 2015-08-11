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

## VDSM Changes

*   Enrich the migrate verb with:
    -   **enableDowntimeThread**: since it will be handled by engine policy, a possibility to enable/disable the downtime thread
    -   **migrationProgressTimeout**: migration parameter and consider it as a hard limit (the timeout after which VDSM aborts migration even no other commands from engine arrives. This acts as a hard limit which will abort the migration in case the connection between engine and VDSM is lost for a long time so the engine policies will not apply)
    -   **downtime**: initial downtime
    -   **stallingLimit**: initial value (if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to)

<!-- -->

*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **downtime**: VM max downtime
    -   **migrationTechnique**: pre-copy or post-copy
    -   **migrationCompression**: enables quemu migration compression (true/false)
    -   **autoConvergence**: enables quemu migration convergence (true/false)
    -   **stallingLimit**: if the migration will be stalling for this amount of time, VDSM will send an event to which the engine will listen to

## Engine Changes

Engine will be listening to the the evnts set from VDSM if the VM is stalling. Specific policies TBD when the VDSM side will be decided.
