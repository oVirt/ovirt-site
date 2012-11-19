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

The OvfAutoUpdater introduces a change to the system-wide behaviour of vm/template ovf updates. Currently every change in the VM configuration entails a synchronous vdsm call to update the ovf in the master domain. With OvfAutoUpdater ovf updates would be performed periodically for multiple OVFs of the same data-center in a single vdsm call.

### Owner

*   Name: [ Liron Aravot](User:Laravot)

<!-- -->

*   Email: <laravot@redhat.com>

### Detailed Description

vm/template configurations (including disks info) are stored on the master storage domain for backup purposes, import/export and also to provide the abillity to run VMs without having a running engine/db. Currently ovf update is done synchronously when performing various operations on vms/templates - update, save, adding/removing a disk, etc. What's more, currently updating the ovf (updateVM vdsm call) is usually done within a transcation.

The idea behined OvfAutoUpdater is to perform batch ovf update operations that aggregate all outstanding updates per data center. These updates will be done in specifed time intervals which will reduce XML-RPC calls and will enable the removal of this syncronous vdsm call from all over the code.

The time interval (minutes) between OvfAutoUpdater runs can be configured by the config value 'OvfUpdateIntervalInMinutes', defaults to 5.

### Benefit to oVirt

*   Reduce vdsm xml-rpc calls.
*   Removal of ovf update call from all flows.
*   Prevent running ovf update within transcations.

### Detailed Design

#### DB Changes

vm_static table:

       add column - db_generation INTEGER default 1
       add column - ovf_generation INTEGER default 0

vdc_options table:

       add row - OvfUpdateIntervalInMinutes config value.

#### Engine

*   New singleton - OvfDataUpdater with an instance initiated during class loading - the constructor schedules a quartz job with interval as configured in the 'OvfUpdateIntervalInMinutes' config value.
*   When timer time has elapsed, performs the following:

1.  1. Get all Storage Pool in status 'UP' (meaning we have a valid master domain and spm)
2.  2. For each storage pool in status 'UP' - Get all VM's/Templates within that storage pool that were changed since last run (db_generation > ovf_generation) which are not locked and none of their disks are locked .
3.  3. Try to run UpdateVmInSpm for all those vms together in a single call (it might be neccassary to split the update execution into chunks in order to avoid performing the operation on too many vms/templates in the same call).
4.  4. If succesfull - for each vm update the ovf_generation to equal the db_generation.

*   Replace updateVmInSpm call in commands with an increment to the db_generation version.
*   Increment the db_generation column in vm_static should be performed in the same transcation of the vm unlock operation after succesfull flow.

### Possible improvements

1.  In case the operation in vdsm has succeeded on part of the sent vms/templates - we might get it back together with the result from vdsm so we won't run the update for it again.
2.  Split into chunks in case of large number of vms.

### Comments and Discussion

<Category:Feature>
