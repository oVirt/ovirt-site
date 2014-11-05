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
feature_status: Inception
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
*   Last updated date: Mon Oct 27 2014

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

A new action-group "Snapshot" would be introduced under actions for a volume. This would consist two actions namely "New" and "Options".

The action "New" could be performed on a selected volume from the list to create a new snapshot. If no volume selected in the list, the action remains disabled.

The action "Options" could be used for setting the configuration parameters related to snapshot for a specific volume or cluster. Details about the action is provided in below sections.

![](VolumeList1.png "VolumeList1.png")

An additional column would list the no of snapshots available for the said volume at the moment. If there is a breach of soft limit for the no of snapshots for a volume, an alert would be shown in General sub-tab of the volumes.

<big>Taking a snapshot</big>

If user selects a volume from the list and click the menu option "Snapshot --> New", a dialog pops up asking for the snapshot name and optional description. User would provide the required details and click the button "OK" to trigger the creation of snapshot. Snapshot name is pre-populated with suggested name in the format <Vol Name>-<Time Stamp (YYYYMMDDHHMMSS)>.

![](CreateVolumeSnapshot1.png "CreateVolumeSnapshot1.png")

User can also opt for forceful creation of the snapshot and auto activation of the created snapshot using the check-boxes provided in the dialog. If the force option is selected and server side quorum is met for the volume, snapshot is created even if some of the bricks are down for the volume.

If the auto activate option is selected, the created snapshot gets activated post creation.

<big>Configuring snapshot parameters</big>

Snapshot related configuration parameters for a specific volume / cluster can be set by clicking the menu option "Snapshot --> Options". A dialog pops up with pre-populated values and user can change the values and update. There are three configuration parameters which could be set using the dialog -

*   Hard Limit for the maximum no of the snapshots
*   Soft limit percentage (of hard limit) for no of snapshots
*   Auto deletion for snapshots (applicable only at system level i.e. for cluster)

<small>Use Case - 1</small>

If a volume is selected from the list and menu option "Snapshot --> Options" is selected, the configurations parameters specific to the volume are listed and can be updated. The parameter "Auto Delete" is disabled as its applicable only at system(cluster) level.

![](SnapshotConfiguration.png "SnapshotConfiguration.png")

<small>Use Case - 2</small>

If no specific volume is selected the configuration parameters for cluster are listed and can be modified. If no specific cluster selected from left tree menu and also no volume selected from the list, the menu "Snapshot --> Options" remains disabled.

![](SnapshotConfiguration1.png "SnapshotConfiguration1.png")

#### Sub-tab "Volumes --> Snapshots"

This sub-tab under the main tab "Volumes" lists the snapshots created for individual volumes. The set of supported actions are -

*   Restore
*   Remove
*   Remove All
*   Activate
*   De-activate

![](VolumeSnaps1.png "VolumeSnaps1.png")

<big>1. Restoring a Snapshot</big>

If user selects an individual snapshot from the volume snapshots list table and clicks the menu "Restore", a dialog pops up asking for a confirmation for restoring the volume to the state of the selected snapshot. User clicks "OK" to restore the snapshot.

![](RestoreSnapConfirmation.png "RestoreSnapConfirmation.png")

If the volume is in UP state for which the restore is getting triggered, a confirmation dialog pops up asking whether to stop the volume and and then execute the snapshot restore. If user confirms, the volume is first brought to DOWN state and then restored to mentioned snapshot. Once restore is successful, the volume is brought back to UP state again.

![](RestoreSnapVolUPConfirmation.png "RestoreSnapVolUPConfirmation.png")

<big>2. Remove a snapshot</big>

This action asks for a confirmation and then removes the selected snapshot(s).

![](RemoveSnapshotConfirmation.png "RemoveSnapshotConfirmation.png")

<big>3. Remove all the snapshots</big>

This action asks for a confirmation and then removes all the snapshots for the selected volume.

![](RemoveAllSnapshots.png "RemoveAllSnapshots.png")

<big>4. Activating a snapshot</big>

This action makes the snapshot on-line for further activities. User selects a snapshot from the list and clicks the menu option "Activate" to perform the action. A dialog opens up asking for confirmation and if to activate the snapshot forcefully. If the force option is selected, the snapshot gets activated even if some of the bricks are down for the said snapshot. The down bricks are brought up as part of activate action.

![](ActivateSnapshot.png "ActivateSnapshot.png")

<big>5. De-activating a snapshot</big>

If a snapshot is already activated, the same can be de-activated by this action. Snapshot becomes read only after the de-activation and no changes would be possible. User selects a snaspshot from the list and clicks the menu "Deactivate" to perform the action. A dialog pops up for confirmation.

![](DeactivateSnapshot.png "DeactivateSnapshot.png")

#### Dashboard changes

Dashboard would provide a consolidated view of the snapshots for a volume (activated and de-activated). There would be alerts available in case of soft limit breach for the no of snapshots and reaching the limit of maximum possible snapshots for a volume.

### Limitations

NA

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterVolumeSnapshots> for detailed design of the feature.

# Dependencies / Related Features and Projects

None

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
