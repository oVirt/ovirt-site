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

# Design

### User Experience and control flows

#### Main tab "Volumes"

A new action group "Volume Snapshot" would be introduced under actions for a volume as a drop down. The set of actions under this action group would be -

*   Take Snapshot
*   Restore

![](VolumeList.png "VolumeList.png")

<big>1. Taking a snapshot</big>

There are two scenarios while taking snapshots for the volumes -

*   User selects a volume from the list and click the menu option "Volume Snapshot --> Create Snapshot". A dialog pops up asking for the snapshot name and optional description. User would provide the required details and click the button "OK" to trigger the creation of snapshot.

![](CreateVolumeSnapshot1.png "CreateVolumeSnapshot1.png")

*   User does not select a volume from the volume list table and clicks the menu option "Volume Snapshot --> Create Snapshot". In this scenario a dialog pops up with lists of individual volumes. User can select an individual volume and create a snapshot.

![](CreateSnapshot1.png "CreateSnapshot1.png")

User is prompted a dialog asking for snapshot name and then triggers the snapshot creation.

<big>2. Restore a Snapshot</big>

There are two scenarios while restoring a snapshot -

*   User selects an individual volume from the volume list table and clicks the menu "Volume Snapshot --> Restore". In this scenario a dialog pops up listing all the snapshots taken for the said volume. User can snapshot to restore to and click "OK".

![](RestoreSnap.png "RestoreSnap.png")

*   User does not select anything from the volume list table and clicks the menu option "Volume Snapshot --> Restore". In this scenario a dialog pops up listing all the snapshots taken for all the volumes. This dialog allows the user to select a volume name from a combo and all the corresponding snapshots get listed. User an select the snapshot to restore to click "OK".

![](RestoreSnap2.png "RestoreSnap2.png")

#### Sub-tab "Volumes --> Snapshot"

This sub-tab under the main tab "Volumes" lists the snapshots created for individual volumes. The set of supported actions are -

*   Restore
*   Remove
*   Configure

![](VolumeSnapsList.png "VolumeSnapsList.png")

<big>1. Restoring a snapshot</big>

This action is same as restoring a snapshot for a single volume mentioned above.

<big>2. Remove a snapshot</big>

This action asks for a confirmation and then removes the selected snapshot(s).

<big>3. Snapshot related Configuration Parameters for volume</big>

This actions sets / edits the snapshot related configuration parameters for the specific volume. On click of the action, a pop up dialog opens with values already set for the configuration parameters. User has option to change the values and update them.

![](SnapshotConfiguration.png "SnapshotConfiguration.png")

### Limitations

NA

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterVolumeSnapshots> for detailed design of the feature.

# Dependencies / Related Features and Projects

<<Volume creation has dependencies as they could be marked for snapshot creation later>>

# Test Cases

# Documentation / External references

<https://forge.gluster.org/snapshot/pages/Home>

<http://sources.redhat.com/lvm/>

<http://www.gluster.org/community/documentation/index.php/Features/snapshot>

# Comments and Discussion

<http://www.ovirt.org/Talk:Features/GlusterVolumeSnapshots>

# Open Issues

<Category:Feature>
