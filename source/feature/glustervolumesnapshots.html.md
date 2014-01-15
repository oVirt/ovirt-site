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

This feature allows the administrators to maintain the snapshots of a Gluster volume. Administrator can create, list, delete and restore to a given snapshot. Gluster volume snapshot provides an online crash consistency mechanism for the Gluster volumes. The volume snapshots provide a point in time view of the volume. In a case of inconsistency, these snapshots could be used to restore the volume to a consistent stage. The snapshots are also a mechanism of volume backup for future references.

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

There are three scenarios for taking a snapshot

*   User selects a volume from the volume list table which is part of a snapshot group and clicks the menu option "Volume Snapshot --> Create Snapshot". In this scenario first a confirmation dialog would be popped saying that volume is part of a snapshot group and does user want to continue.

![](CreateCGSnapConfirmation.png "CreateCGSnapConfirmation.png")

If user confirms the snapshot creation, a dialog would pop up and asks for the snap name and optional description for creation of the snapshot.

![](CreateCGSnapshot.png "CreateCGSnapshot.png")

User provides the required details clicks the button "OK" and snapshot creation gets triggered.

*   User selects an individual volume and click the menu option "Volume Snapshot --> Create Snapshot". In this scenario a dialog pops up listing of all the individual volumes with selected volume auto checked in the list. User has option to create the snapshot of the selected volume as an individual by clicking the button "Create Snapshot". If the user wants to create snapshot of the selected volume with other volumes as snapshot group, he/she can click the button "Create Snapshot as group". In this scenario a fresh snapshot group would be formed and snapshot would be created for the group.

![](CreateVolumeSnapshot.png "CreateVolumeSnapshot.png")

If user opts for creation of snapshot for the individual volume another dialog pops asking for the snapshot name and optional description. User would provide the required details and click the button "OK" to trigger the creation of snapshot.

![](CreateVolumeSnapshot1.png "CreateVolumeSnapshot1.png")

If the user opts for snapshot creation as group, then a dialog pops asking for Snapshot Group Name and Snapshot Name. User provides the required details and snapshot creation is triggered,

![](CreateCGSnapshot1.png "CreateCGSnapshot1.png")

*   User does not select a volume from the volume list table and clicks the menu option "Volume Snapshot --> Create Snapshot". In this scenario a multi tabbed dialog pops up with lists of snapshot groups and individual volumes in two separate tabs. User can select a snapshot group or individual volume and create a snapshot.

![](CreateSnapshot.png "CreateSnapshot.png")

![](CreateSnapshot1.png "CreateSnapshot1.png")

Based on option selected by user for creation of snapshot above mentioned dialogs pop asking for snapshot name and then trigger the snapshot creation.

<big>2. Restore a Snapshot</big>

There are 3 scenarios while restoring a snapshot -

*   User selects a volume from the volume list table which part of a snapshot group and clicks the menu option "Volume Snapshot --> Restore". In this scenario a dialog would pop up saying volume part of a snapshot group and if the user wants to restore the snapshot group.

![](RestoreCGSnapshotConfirmation.png "RestoreCGSnapshotConfirmation.png")

If user opts for the restore of a snapshot group, a pop up listing the snapshots for the snapshot group pops up. User can select a snap t0 restore to and clicks "OK".

![](RestoreCGSnapshot.png "RestoreCGSnapshot.png")

*   User selects an individual volume from the volume list table and clicks the menu "Volume Snapshot --> Restore". In this scenario a dialog pops wu listing all the snapshots taken for the said volume. User can snapshot to restore to and click "OK".

![](RestoreSnap.png "RestoreSnap.png")

*   User does not select anything from the volume list table and clicks the menu option "Volume Snapshot --> Restore". In this scenario a multi-tabbed dialog pops up. This dialog allows the user to select either a snapshot group or a volume name from a combo and all the corresponding snapshots get listed. User an select the snapshot to restore to click "OK".

![](RestoreSnap1.png "RestoreSnap1.png")

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

<big>3. Configurations for volume snapshot</big>

This actions sets / edits the snapshot related configuration parameters for the specific volume. On click of the action, a pop up dialog opens with values set for the configuration parameters. User has option to edit the values using the Edit action in the pop up dialog.

![](SnapshotConfiguration.png "SnapshotConfiguration.png")

#### Sub Tab "Clusters --> Snapshot Groups"

An additional sub tab would be introduced for main tab "Clusters". This sub tab would list the snapshot groups in the cluster in a tabular form having the columns -

*   Name
*   Cluster
*   Description

![](ClusterSnapshotGroups.png "ClusterSnapshotGroups.png")

Actions supported for this sub tab are -

*   Remove - removes the snapshot group
*   Configure - lists and provides option to edit the snapshot related configuration parameters for snapshot group

<big>1. Removing Snapshot Group</big>

User can select snapshot groups and click Remove for deleting the same. A confirmation id popped up and if user confirms, the snapshot groups would be deleted.

<big>2. Configuring snapshot group</big>

This feature same as mentioned above in the case of single volume configuration. This allows to set the snapshot related configuration parameters for the said snapshot group.

On selecting a snapshot group from the list, it shows an extended sub tab listing the participating volumes and available snapshots for the snapshot group in the right half.

*   In the volumes volumes list there are actions available for adding or removing the participating volumes for the snapshot group.

![](ClusterSnapshotGroups1.png "ClusterSnapshotGroups1.png")

*   In the snapshots list there are actions available for removing and restoring the individual snapshot for the snapshot group.

![](ClusterSnapshotGroups2.png "ClusterSnapshotGroups2.png")

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
