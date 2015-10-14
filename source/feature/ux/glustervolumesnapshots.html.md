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

This feature allows the administrators to maintain the snapshots of a Gluster volume. Administrator can create, schedule, list, delete, start, stop and restore to a given snapshot. Gluster volume snapshot provides an online crash consistency mechanism for the Gluster volumes. The volume snapshots provide a point in time view of the volume. In a case of inconsistency, these snapshots could be used to restore the volume to a consistent stage. The snapshots are also a mechanism of volume backup for future references.

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
*   Schedule snapshot creation
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

A new action-group "Snapshot" would be introduced under actions for a volume. This would consist of actions namely "New", "Options" and "Schedule".

The action "New" could be performed on a selected volume from the list to create a new snapshot. If no volume selected in the list, the action remains disabled.

The action "Options" could be used for setting the configuration parameters related to snapshot for a specific volume or cluster. Details about the action is provided in below sections.

The option "Schedule" can be used for scheduling the snapshot for the selected volume.

![](VolumeList1.png "VolumeList1.png")

An additional column would list the no of snapshots available for the said volume at the moment. If there is a breach of soft limit for the no of snapshots for a volume, an alert would be shown in General sub-tab of the volumes.

<big>Taking a snapshot</big>

If user selects a volume from the list and click the menu option "Snapshot --> New", a dialog pops up asking for the snapshot name prefix and optional description. User would provide the required details and click the button "OK" to trigger the creation of snapshot. Snapshot name would be formed by engine in the format <Snapshot Name Prefix>-snap-<Time Stamp (YYYYMMDDHHMMSS)>.

![](CreateVolumeSnapshot.png "CreateVolumeSnapshot.png")

User can also opt to schedule the repetitive snapshot creation for the selected volume using this dialog. If there is not already existing snapshot schedule for the volume, the dialog contains two tabs namely "General" and "Schedule". If user wants to schedule snapshot creations for the volume, he/she can select the "Schedule" tab and provide the details of the recurrence. Default selected value for the recurrence type is None. In case of spot creation of snapshots, the recurrence type is set as None. Below screen shots show the different options available while snapshot scheduling.

![](CreateVolumeSnapshot1.png "fig:CreateVolumeSnapshot1.png") ![](CreateVolumeSnapshot2.png "fig:CreateVolumeSnapshot2.png")

![](CreateVolumeSnapsho3.png "fig:CreateVolumeSnapsho3.png") ![](CreateVolumeSnapshot4.png "fig:CreateVolumeSnapshot4.png")

![](CreateVolumeSnapshot5.png "CreateVolumeSnapshot5.png")

If there is already a schedule available for the volume, the dialog thrown on click of option "Volumes --> Snapshot --> New" shows only the general tab. So effectively now using this option only spot creation of snapshots are possible. If user wants to edit the schedule he/she needs to select the option "Volumes --> Snapshot --> Edit Schedule".

<big>Editing Schedule for snapshots</big>

The option "Volumes --> Snapshot --> Edit Schedule" can be used for editing or disabling the scheduled snapshots for a volume. A dialog opens with already set values for the schedule and user has an option to change or disable the schedule. This dialog shows both the tabs namely "General" and "Schedule" whereas "Schedule" is default selected. User can edit the schedule details and snapshot name prefix or description as well (if required).

To disable the snapshot schedule for the volume, user needs to select the option None for Recurrence Type.

![](EditSchedule.png "EditSchedule.png")

<big>Configuring snapshot parameters</big>

Snapshot related configuration parameters for a specific volume or whole cluster can be set by clicking the menu option "Snapshot --> Options - Volume" and "Snapshot --> Options - Cluster" respectively. A dialog pops up with pre-populated values and user can change the values and update. There are three configuration parameters which could be set using the dialog -

*   Hard Limit for the maximum no of the snapshots
*   Soft limit percentage (of hard limit) for no of snapshots (applicable only at system level i.e. for cluster)
*   Auto deletion for snapshots (applicable only at system level i.e. for cluster)

If a volume is not selected from the list, only the cluster level parameters can be modified and set. A confirmation dialog is thrown before updating the configurations. The option "Snapshot --> Options - Cluster" is always enabled and user can set the snapshot options for a cluster using this option. The option "Snapshot --> Options - Volume" gets enabled only if a volume is selected from the list.

<small>Use Case - 1</small>

User does not select a volume from the list and clicks the action "Snapshot --> Options - Cluster". In this case user can set the configurations parameters for a cluster. The dialog provides a list of clusters to select from and pre-populated configurations values are listed in tabular format. User can modify the values and opt to update them.

![](SnapshotOptions1.png "SnapshotOptions1.png")

<small>Use Case - 2</small>

User selects a volume from the list clicks the action "Snapshot --> Options - Volume". In this case user can set the configuration parameters for the volume. The pre-populated values are listed in tabular format and user can modify the values and opt to update them. Even the cluster level values for the option are listed for reference (and comparison).

![](SnapshotOptions2.png "SnapshotOptions2.png")

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

[GlusterVolumeSnapshots](Category:Feature) <Category:Gluster> [GlusterVolumeSnapshots](Category:oVirt 4.0 Proposed Feature)
