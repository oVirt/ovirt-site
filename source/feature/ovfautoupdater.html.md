---
title: OvfAutoUpdater
category: feature
authors: abaron, laravot
wiki_category: Feature
wiki_title: Feature/OvfAutoUpdater
wiki_revision_count: 25
wiki_last_updated: 2012-12-17
---

# OvfAutoUpdater

### Summary

The OvfAutoUpdater introduces a change to the system-wide behaviour of vm/template ovf update, instead of performing it as a synchronous vdsm operation after this change the update would be performed periodically for all updated vms/templates of the same data-center in a single vdsm call.

### Owner

*   Name: [ Liron Aravot](User:Laravot)

<!-- -->

*   Email: <laravot@redhat.com>

### Detailed Description

Ovf is being used for a copy of the vm/template configuration (including disks info) to the master storage domain for backup purposes and gives the user an abillity to run the vm without having a running engine/db. Currently ovf update is being done when performing various operations on vms/templates - update, save, adding/removing a disk..etc. As of today, ovf update is basically being done per one vm/template (on which we performed the operation) and furthermore, this vdsm call is usually being done within a transcation.

The idea behined to OvfAutoUpdater is to perform batch ovf update operation of all neccessary updates per data center in specifed time interval - this will reduce XML-RPC calls (as we will send one call only for some vms/templates of specific data center) and will ease the removal of this syncronous vdsm call from all over the code.

The time interval (minutes) between OvfAutoUpdater runs can be configured by the config value 'OvfUpdateIntervalInMinutes', defaults to 5.

### Benefit to oVirt

*   Reduce vdsm xml-rpc calls.
*   Removal of ovf update call from all flows.
*   Prevent running ovf update within transcation.

### Detailed Design

#### DB Changes

vm_static table:

       add column - ovf_generation (DEFAULT 0)
       add column - db_generation  (DEFAULT 1)

vdc_options table:

       add row for OvfUpdateIntervalInMinutes config value.

#### Engine

*   New singleton - OvfDataUpdater with an instance iniated during class loading - the constructor schedules a quartz job with interval as configured in the 'OvfUpdateIntervalInMinutes' config value.
*   When timer time has elapsed, performs the following:

1.  1. Get all Storage Pool in status 'UP' (meaning we have a valid master domain and spm)
2.  2. For each storage pool in status 'UP' - Get all VM's/Templates within that storage pool that were changed since last run (db_generation > ovf_generation) which are not locked and none of their disks are locked .
3.  3. Try to run UpdateVmInSpm for all those vms together in a single call (it might be neccassary to split the update execution into chunks in order to avoid perform the operation on too many vms/templates at the same time).
4.  4. If succesfull - Update for each vm the ovf_generation to be as the db_generation.

*   Replace updateVmInSpm call in commands with an increment to the db_generation version.
*   Increment to the db_generation column in vm_static should be performed in the same transcation of the vm unlock operation after succesfull flow.

### Possible improvements

1.  1. in case the operation in vdsm has succeeded on part of the sent vms/templates - we might get it back together with the result from vdsm so we won't run the update for it again.
2.  2. Split into chunks in case of large number of vms.
3.  3. Add caching to OvfDataUpdate.

### Comments and Discussion

<Category:Feature>
