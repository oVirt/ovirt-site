---
title: Single Disk Snapshot
authors: amureini, derez, vered
wiki_title: Features/Single Disk Snapshot
wiki_revision_count: 14
wiki_last_updated: 2014-05-25
---

# Single Disk Snapshot

### Summary

Customization of snapshots with regards to VM configuration and disks.

### Owner

*   Name: [ Daniel Erez](User:Derez)
*   Email: <derez@redhat.com>

### Current status

*   Target Release: 3.4
*   Status: work in progress
*   Last updated: ,

### Benefit to oVirt

*   Allow creation of a customized snapshot. I.e. selecting which disks to take snapshot on.
*   Custom snapshot preview:
    -   Previewing a new state by selecting VM configuration and disks from various snapshots.
    -   Support commit to the new state and undo to the previous one.
*   Features based on specific disks snapshots, such as LSM, will benefit from the new support
    -   E.g. LSM will take a snapshot only on the migrated disks - as opposed to the current situation in which a snapshot is taken on all disks.

### Detailed Description

Currently, a Snapshot represents a single point of time which contains the configuration of the VM and all attached disks.

I.e. creating/previewing/committing a snapshot must be done on the entire VM - including all the disks.

This feature introduces the ability to remove the constraint by allowing to exclude disks from a snapshot.

In addition, adds a new functionality of creating a customized snapshot composed of configuration and disk from multiple snapshots.

#### UI

##### Create Snapshot Dialog

![](create_snapshot_dialog.png "create_snapshot_dialog.png")

##### Custom Preview Button

![](custom_preview_button.png "custom_preview_button.png")

##### Custom Preivew Dialog

###### Screenshot

![](custom_preview_dialog.png "custom_preview_dialog.png")

###### Video

<file:custom_preview_dialog_video.odp>

#### REST-API

Add <disks> tag to create/restore snapshot.

Note: preview only is not available from rest (restore = preview + commit).

E.g. POST /api/vms/{vm_id}/snapshots:

` `<snapshot>
`   `<vm id="{vm_id}"/>
`   `<disks>
`     `<disk id="{disk_id}"/>
`   `</disks>
` `</snapshot>

#### Backend

*   CreateAllSnapshotsFromVmCommand
    -   The command should support handling a specified disks list.
    -   Disks not included in specified list should be 'fast-forwarded' to active snapshot (i.e. update snapshot id without creating a new snapshot).
*   TryBackToAllSnapshotsOfVmCommand
    -   The command should support handling a specified disks list.
    -   Ability to preview a subset of VM disks.
    -   Allow previewing to various points of time (each specified image can define a different snapshot).
    -   Support previewing only disks while keeping the current VM configuration.
    -   Keeping old API from 'regular' preview.
*   RestoreAllSnapshotsCommand
    -   Identify on which disks to perform snapshot undo/commit.
    -   Skip restore for excluded disks (but keep updating snapshot id accordingly).
*   GetAllVmSnapshotsByVmIdQuery
    -   Configurable support to return the snapshots with appropriate images list.
    -   Fetch disks data from VM configuration which resides in the OVF (depending on UI design).
*   Snapshot
    -   Add a list of disk images.

#### VDSM

Already supported.

### Open Issues

*   Custom Preview Dialog
    -   What to display at the bottom section?
        -   "Result" - i.e. the state to preview.
        -   VM configuration - i.e. the bottom section updates on configuration selection.
    -   Memory (applicable only for live snapshot)
        -   Should we allow configuration/memory decoupling?
        -   Or, configuration selection enforces the selection of memory from same snapshot (and vice versa)?
    -   Allow excluding a disk from preview (deselecting entire column)?
        -   Excluding a disk implications are similar to deleting a disk (will result with an illegal disk on previous snapshots).

### Testing

### Comments and Discussion

### Future Work

*   Revise error flows
    -   E.g. failing to take a snapshot on one disk shouldn't rollback the entire snapshot, instead, just exclude the disk from the snapshot.
*   Continue the decoupling of snapshot components and use single disks snapshots when needed, as in LSM flow.
*   Create a snapshot form disk context
    -   Select a disk -> create snapshot (still requires including the VM configuration).
*   Preview/commit/undo a snapshot from disk context
    -   Only a subset of the disks at a time, since creating a preview snapshot locks most VM operations (adding/removing disks, etc).
*   Exclude VM configuration
    -   Do we want to allow creating a snapshot without VM configuration?
*   Detach/Attach of disks with snapshots
    -   How to represent/display snapshots of a floating disk?
    -   How to handle attach of a disk with snapshots to a different VM?
*   Profiles
    -   Creating a snapshot profiles (which allows single click snapshot). E.g. 'VM configuration + OS disk profile' / etc.
