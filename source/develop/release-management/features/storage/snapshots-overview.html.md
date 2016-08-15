---
title: Snapshots Overview
authors: derez
feature_name: Snapshot Overview
feature_modules: engine
feature_status: Released in oVirt 3.5
wiki_title: Features/Snapshots Overview
wiki_revision_count: 8
wiki_last_updated: 2014-05-12
---

# Snapshots Overview

## Summary

Snapshots overview and management in context of a storage domain.

## Owner

*   Name: [ Daniel Erez](User:Derez)
*   Email: <derez@redhat.com>

## Current status

*   Target Release: 3.5
*   Status: work in progress
*   Last updated: ,

## Benefit to oVirt

*   Improving the display of storage consumption details in order to identify which entities (disks/snapshots) could be removed for freeing space.
*   Ability to remove a specific disk from a snapshot (instead of to current support which forces deletion of the entire VM snapshot).
*   Ability to remove disks snapshots in storage domain context; i.e. merging a specified set of snapshots in order the allow regaining space on a storage domain.

## Detailed Description

Currently, only a VM snapshot removal is supported - i.e. removing snapshots of disks requires removal of the entire set of disks in the VM snapshots. Hence, in order to furtherly decouple disks snapshots from VM snapshots, adding a new functionality of removing disks from snapshots. The UI will expose a flattened list of disks snapshots that reside on a specific storage domain in a new sub-tab. In which, the new action of removal should be available.

## UI

### Sub-Tabs concept

#### Storage -> Snapshots Sub-Tab

![](storage_snapshots_subtab.png "storage_snapshots_subtab.png")

#### [Future Work?] Storage Resources Usage Sub-Tab [Disks (active volumes) / Snapshots / Free space]

![](storage_resources_usage_subtab.png "storage_resources_usage_subtab.png")

### [DEPRECATED] Manage Snapshots concept

The solution is being neglected in favor of the sub-tabs concept as removing snapshot disks (merging) is a long operation; i.e. sub-tabs is the way to go when status indication is needed. Furthermore, since the interesting operation on snapshots in context of storage is merging, having a dedicate dialog seems redundant.

#### [DEPRECATED] Manage Snapshots Dialog

[http://i.imgur.com/8EV9NfA.png Sketch](http://i.imgur.com/8EV9NfA.png Sketch)

## REST-API

Introducing new functionality of deleting a disk from a snapshot.

### Get disk snapshots by storage domain

      GET /api/storagedomains/{storage_id}/disksnapshots

### Delete a disk snapshot from storage domain

      DELETE /api/storagedomains/{storage_id}/disksnapshots/{image_id}

### Delete a snapshot disk:

      DELETE /api/vms/{vm_id}/snapshots/{snapshot_id}/disks/{disk_id}

## Backend

*   RemoveDiskSnapshotsCommand -> RemoveDiskSnapshotTaskHandler:
    -   A new command (and task handler) for removing specific images from snapshots.
    -   The command accepts as an argument a list of multiple images (of the same disk) to remove.
    -   The command utilizes [SEAT](http://wiki.ovirt.org/Features/Serial_Execution_of_Asynchronous_Tasks_Detailed_Design) infrastructure for removing multiple images from a disk consecutively (as merging multiple snapshots of a specific disk must be done separably - to avoid volume chain breakage).

<!-- -->

*   GetAllDiskSnapshotsByStorageDomainIdQuery:
    -   A new query for retrieving all snapshot disks that resides on a specified storage domain.
    -   Needed for fetching data of Storage -> Snapshots sub-tab.

<!-- -->

*   DiskImage -> vmSnapshotDescription member:
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
*   Verify snapshot removal from rest-api.

## Comments and Discussion

*   

## Future Work

*   Mentioned inline above.
