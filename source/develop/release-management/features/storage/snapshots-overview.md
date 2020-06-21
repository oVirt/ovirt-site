---
title: Snapshots Overview
authors: derez
feature_name: Snapshot Overview
feature_modules: engine
feature_status: Released in oVirt 3.5
---

# Snapshots Overview

## Summary

Snapshots overview and management in context of a storage domain.

## Owner

*   Name: Daniel Erez (Derez)
*   Email: <derez@redhat.com>

## Current status

*   Target Release: 3.5
*   Status: work in progress

## Benefit to oVirt

*   Improving the display of storage consumption details in order to identify which entities (disks/snapshots) could be removed in order to free up space.
*   Ability to remove a specific disk from a snapshot (instead of to current support which forces deletion of the entire VM snapshot).
*   Ability to remove disks snapshots in storage domain context; i.e. merging a specified set of snapshots in order the allow regaining space on a storage domain.

## Detailed Description

Currently, only a VM snapshot removal is supported - i.e. removing snapshots of disks requires the removal of the entire set of disks of the VM snapshot. Hence, in order to further decouple disks snapshots from VM snapshots, this proposed feature adds a new functionality of removing disks from snapshots. The UI will expose a flattened list of disks snapshots that reside on a specific storage domain in a new sub-tab in which, the new action of removal would be available.

## UI

### Sub-Tabs concept

#### Storage -> Snapshots Sub-Tab

![](/images/wiki/Storage_snapshots_subtab.png "storage snapshots subtab sketch")

#### [Future Work?] Storage Resources Usage Sub-Tab [Disks (active volumes) / Snapshots / Free space]

![](/images/wiki/Storage_resources_usage_subtab.png "storage resources usage subtab sketch")

### [DEPRECATED] Manage Snapshots concept

The solution is being neglected in favor of the sub-tabs concept as removing snapshot disks (merging) is a long operation; i.e. sub-tabs is the way to go when status indication is needed. Furthermore, since the interesting operation on snapshots in context of storage is merging, having a dedicate dialog seems redundant.

#### [DEPRECATED] Manage Snapshots Dialog

![](/images/wiki/Manage_snapshots_dialog_sketch.png "manage snapshots dialog sketch")

## REST-API

Introducing new functionality of deleting a disk from a snapshot.

### Get disk snapshots by storage domain

    GET /api/storagedomains/{storage_id}/disksnapshots

### Delete a disk snapshot from storage domain

    DELETE /api/storagedomains/{storage_id}/disksnapshots/{image_id}

### Delete a snapshot disk:

    DELETE /api/vms/{vm_id}/snapshots/{snapshot_id}/disks/{disk_id}

## Backend

*   `RemoveDiskSnapshotsCommand` -> `RemoveDiskSnapshotTaskHandler`:
    -   A new command (and task handler) for removing specific images from snapshots.
    -   The command accepts as an argument a list of multiple images (of the same disk) to remove.
    -   The command utilizes [SEAT](serial-execution-of-asynchronous-tasks/) infrastructure for removing multiple images from a disk consecutively (as merging multiple snapshots of a specific disk must be done separably - to avoid volume chain breakage).

*   `GetAllDiskSnapshotsByStorageDomainIdQuery`:
    -   A new query for retrieving all snapshot disks that resides on a specified storage domain.
    -   Needed for fetching data of Storage -> Snapshots sub-tab.

*   `DiskImage` -> `vmSnapshotDescription` member:
    -   Needed for displaying snapshot description in the UI (for easier image identification).

## VDSM

Already supported.

## Open Issues

*   Sorting in sub-tabs - wait for the generic client/server side sorting UI infrastructure?
*   Display additional information about the snapshot/VM on item selection?
*   Integrating a filter widget in sub-tab (as illustrated in manage snapshots dialog) or wait for a generic infrastructure?

## Testing

*   Verify that the sub-tab displays all disk snapshots that reside on the selected storage domain.
*   Verify removal of a single snapshots.
*   Verify removal of multiple snapshots (of the same disk).
*   Verify that removal of a snapshot that is attached to a running VM is blocked (until live snapshot merge is supported...).
*   Verify snapshot removal from REST-API.

## Future Work

*   Mentioned inline above.

## Related Bugzilla Items:

* [Bug 1086181 - OVIRT35 - [RFE] Snapshot Overview screen to manage storage](https://bugzilla.redhat.com/show_bug.cgi?id=1086181)
