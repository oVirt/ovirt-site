---
title: GlusterVolumeSnapshots
category: feature
authors: sahina, sandrobonazzola, shtripat
wiki_category: Feature|GlusterVolumeSnapshots
wiki_title: Features/GlusterVolumeSnapshots
wiki_revision_count: 136
wiki_last_updated: 2015-01-20
feature_name: Gluster Volume Snapshot
feature_modules: engine
feature_status: Not Started
---

# Gluster Volume Snapshot

# Summary

This feature allows the administrators to maintain the snapshots of a Gluster volume. Administrator can create, list, delete, start, stop and restore to a given snapshot. Gluster volume snapshot provides an online crash consistency mechanism for the Gluster volumes. The volume snapshots provide a point in time view of the volume. In a case of inconsistency, these snapshots could be used to restore the volume to a consistent stage. The snapshots are also a mechanism of volume backup for future references.

Using this feature, an admin can take scheduled or unscheduled snapshots of and thereby backup a Gluster volume. This also provides a check-point in time to restore to, if and when necessary.

To read more about Gluster volume snapshot feature, see <https://forge.gluster.org/snapshot/pages/Home>.

# Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner:
    -   QA Owner:

# Current Status

*   Status: Inception
*   Last updated date: Thu Dec 26 2013

# Detailed Description

An on-line snapshot is a feature where the file-system and associated data continue to be available for the clients, while the snapshot is being taken. Here the onus lies on the application to periodically sync data, so that the snapshot created has the desired data consistent view.

On the other hand, an off-line snapshot makes the file-system off-line or unavailable for a deterministic time-window till the snapshot is taken. While off-line snapshots are relatively easy to administer, the inaccessibility to the volume(s)/data is a major disadvantage.

With this feature the user will be able to

*   Take snapshot of a volume
*   View all the snapshots taken for a volume
*   Restore a volume to a given snapshot
*   Delete an existing snapshot
*   View the current status of snapshot
*   Define the values for the snapshot related configuration parameters for a volume
*   List view the snapshot configuration parameters
*   Activate a snapshot
*   De-activate a snapshot

# Design

### User Experience and control flows

#### Main tab "Volumes"

A new action "Snapshot" would be introduced under actions for a volume. This action could be performed on a selected volume from the list -

![](VolumeList1.png "VolumeList1.png")

<big>Taking a snapshot</big>

If user selects a volume from the list and click the menu option "Snapshot", a dialog pops up asking for the snapshot name and optional description. User would provide the required details and click the button "OK" to trigger the creation of snapshot.

![](CreateVolumeSnapshot1.png "CreateVolumeSnapshot1.png")

#### Sub-tab "Volumes --> Snapshot"

This sub-tab under the main tab "Volumes" lists the snapshots created for individual volumes. The set of supported actions are -

*   Restore
*   Remove
*   Activate
*   De-activate
*   Configure

![](VolumeSnaps1.png "VolumeSnaps1.png")

<big>1. Restoring a Snapshot</big>

If user selects an individual snapshot from the volume snapshots list table and clicks the menu "Restore", a dialog pops up asking for a confirmation for restoring the volume to the state of the selected snapshot. User clicks "OK" to restore the snapshot.

![](RestoreSnapConfirmation.png "RestoreSnapConfirmation.png")

<big>2. Remove a snapshot</big>

This action asks for a confirmation and then removes the selected snapshot(s).

![](RemoveSnapshotConfirmation.png "RemoveSnapshotConfirmation.png")

<big>3. Activating a snapshot</big>

This action makes the snapshot on-line for further activities. User selects a snapshot from the list and clicks the menu option "Activate" to perform the action.

<big>4. De-activating a snapshot</big>

If a snapshot is already activated, the same can be de-activated by this action. Snapshot becomes read only after the de-activation and no changes would be possible. User selects a snaspshot from the list and clicks the menu "Deactivate" to perform the action.

<big>5. Snapshot related Configuration Parameters for volume</big>

This actions sets / edits the snapshot related configuration parameters for the specific volume. On click of the action, a pop up dialog opens with values already set for the configuration parameters. User has option to change the values and update them.

![](SnapshotConfiguration.png "SnapshotConfiguration.png")

### Limitations

NA

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterVolumeSnapshots> for detailed design of the feature.

# Dependencies / Related Features and Projects

Gluster volumes can be enabled for snapshots only if they are thinly provisioned volumes. Set of restrictions which are applicable for a volume to be enabled for snapshot are -

*   Each brick of the volume should be an LVM
*   There should not be more than 4 LVs in a Volume Group,

During volume creation, the dialog would have an additional check-box to mark the volume enabled for snapshots. If the check-box is selected during volume creation, set of pre-volume-creation hooks would validate if the volume bricks are thinly provisioned and then volume creation would go ahead. Additional flag would be maintained with each volume for snapshot feature enabled purpose.

![](CreateVolume.png "CreateVolume.png")

# Test Cases

# Documentation / External references

<https://forge.gluster.org/snapshot/pages/Home>

<http://sources.redhat.com/lvm/>

<http://www.gluster.org/community/documentation/index.php/Features/snapshot>

<http://lxadm.wordpress.com/2012/10/17/lvm-thin-provisioning/>

# Comments and Discussion

<http://www.ovirt.org/Talk:Features/GlusterVolumeSnapshots>

# Open Issues

<Category:Feature>
