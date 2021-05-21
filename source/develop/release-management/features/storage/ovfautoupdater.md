---
title: OvfAutoUpdater
category: feature
authors:
  - abaron
  - laravot
---

# OvfAutoUpdater

## Summary

The OvfAutoUpdater introduces a change to the system-wide behaviour of VM/template OVF updates. Currently every change in the VM configuration entails a synchronous vdsm call to update the OVF in the master domain. With OvfAutoUpdater OVF updates would be performed periodically for multiple OVFs of the same data-center in a single vdsm call. OVF deletions in case of VM/Template removal will be done by the OvfAutoUpdater as well periodically instead of during the execution of VM/Template removal by the user, which will make the operations execution faster.

## Owner

*   Name: Liron Aravot
*   Email: <laravot@redhat.com>

## Detailed Description

VM/template configurations (including disks info) are stored on the master storage domain for backup purposes and in order to provide the ability to run VMs without having a running engine/db. Currently OVF update/removal is done synchronously when performing various operations on VMs/templates - update, save, remove, adding/removing a disk, etc. What's more, currently updating/removing the OVF (vdsm call) is usually done within a transaction.

The idea behind OvfAutoUpdater is to perform batch OVF update operations that aggregate all outstanding updates per data center. These updates will be done in specified time intervals which will reduce XML-RPC calls and will enable the removal of this synchronous vdsm call from all over the code.

The time interval (minutes) between OvfAutoUpdater runs can be configured by the config value `OvfUpdateIntervalInMinutes`, defaults to `60`. The items count per update (in single vdsm update call) can be configured by the config value `OvfItemsCountPerUpdate`, defaults to `100`.

## Benefit to oVirt

*   Reduce vdsm xml-rpc calls.
*   Removal of OVF update call from all flows.
*   Prevent running OVF update within transactions.

## Detailed Design

### DB Changes

`vm_static` table:

       add column - `db_generation BIGINT default 1`

`vm_ovf_generations` table - newly add table

       vm_guid UUID PRIMARY KEY,
       storage_pool_id UUID REFERENCES storage_pool(id) ON DELETE CASCADE,
       ovf_generation BIGINT DEFAULT 0

Add to this table records for all the pre-exiting VMs/templates with initial `ovf_generation` of `1` (as their OVF should be already up to date from before)

`vdc_options` table:

       add row - OvfUpdateIntervalInMinutes config value.
       add row - OvfItemsCountPerUpdate config value

### Engine

*   New singleton - `OvfDataUpdater` with an instance initiated during server startup - the constructor schedules a quartz job with interval as configured in the `OvfUpdateIntervalInMinutes` config value.
*   When timer time has elapsed, performs the following:

1. Get all Storage Pool in status 'UP' (meaning we have a valid master domain and SPM)
2. For each storage pool in status 'UP' - Get all VM's/Templates within that storage pool that were changed since last run (`db_generation > ovf_generation`) which are not locked and none of their disks are locked.
3. Try to run `UpdateVmInSpm` for all those VMs together in a single call (it might be necessary to split the update execution into chunks in order to avoid performing the operation on too many VMs/templates in the same call).
4. If successful - for each VM update the `ovf_generation` to equal the `db_generation` that was returned in the VM entity when we performed the query to get the VMs for update.
5. Load all id's of VMs/templates that were deleted since last OvfAutoUpdater run and issue vdsm command to delete their OVFs.

*   Replace `updateVmInSpm` call in commands with an increment to the `db_generation` version.
*   Increment the `db_generation` column in `vm_static` should be performed in the start of the db transaction to prevent possible db deadlocks.
*   Remove `removeVmInSpm` call in commands (removed VMs/templates will be "collected" automatically after removal in the next OvfAutoUpdater run).

### NOTES

OVFs of VMs/Templates that are being/were updated exactly during their processing by OvfAutoUpdater run will have their OVF updated in the storage the next OvfAutoUpdater run, DB updates will occur regularly.
