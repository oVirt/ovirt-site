---
title: GlusterVolumeSnapshots
category: feature
authors: sahina, sandrobonazzola, shtripat
wiki_category: Feature|GlusterVolumeSnapshots
wiki_title: Features/GlusterVolumeSnapshots
wiki_revision_count: 136
wiki_last_updated: 2015-01-20
---

# Gluster Volume Snapshots

## Summary

This feature allows the administrators to maintain the snapshots of a Gluster volume. Administrator can create, start, stop, delete and restore to a given snapshot. Gluster volume snapshot provides an online crash consistency mechanism for the Gluster volumes. The volume snaps provide a point in time view of the volume. In a case of inconsistency, these snaps could be used to restore the volume to a consistent stage. The snaps are also a mechanism of volume backup for future references.

Using this feature, an admin can take scheduled or unscheduled snapshots of and thereby backup a Gluster volume. This also provides a check-point in time to restore to, if and when necessary.

To read more about Gluster volume snapshot feature, see <https://forge.gluster.org/snapshot/pages/Home>.

## Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner:
    -   QA Owner:

## Current Status

*   Status: Inception
*   Last updated date: Thu Dec 26 2013

## Detailed Description

An online snapshot is a feature where the file-system and associated data continue to be available for the clients, while the snapshot is being taken. Here the onus lies on the application to periodically sync data, so that the snap created has the desired data consistent view.

On the other hand, an offline snapshot makes the file-system offline or unavailable for a deterministic time-window till the snapshot is taken. While offline snapshots are relatively easy to administer, the inaccessibility to the volume(s)/data is a major disadvantage.

### Consistency Group

Applications might consume multiple Gluster volumes and might require the resulting snapshot of these volumes to be from the same point in time view. This group of volumes forms a consistency group. If a volume belongs to a consistency group, then that volume can only be snapped as part of the named consistency group. Restore would also be permitted only on the consistency group. Addition or removal of volumes to/from a consistency group is allowed.

With this feature the user will be able to

*   Create snaps of volumes
*   View all the snaps taken for a volume
*   Restore a volume to a given snapshot
*   Define a consistency group
*   Delete an existing snapshot
*   Start / Stop a snapshot
*   View the current status of snapshot
*   Define the values for the snapshot configuration parameters
*   List view the snapshot configuration parameters

## Design

### User Experience and control flows

#### Main Tab "Consistency Groups"

An additional main tab item would be introduced for "Consistency Groups". This tab would list the consistency group in the cluster in tabular form having the columns -

*   Name
*   Cluster
*   Volumes (# of volumes in the consistency group)
*   Snaps (# of snaps taken for the consistency group)

Actions supported for the main tab are -

*   New - creates a new consistency group
*   Remove - removes the consistency group
*   Create Snap - takes a snapshot of the consistency group
*   Add Volumes - add new volumes to the consistency group
*   Remove Volumes - removes volumes from the consistency group

The sub-tabs for the individual consistency groups would be having tabs -

*   Configurations
*   Snapshots

#### Sub-tab "Consistency Groups --> Configurations"

This sub-tab lists the snapshot configuration values set for the consistency group. The configuration parameters are listed in tabular form having two columns -

*   Parameter Name
*   Parameter Value

Actions supported for this sub-tab are -

*   Add - to add a new configuration parameter
*   Edit - Edit the value of a configuration parameter
*   Reset - Reset the value of the configuration parameter to system value
*   Reset All - Reset the value of all the configuration parameters to system values

#### Sub-tab "Consistency Groups --> Snapshots"

This sub-tab lists the snapshots for the consistency group in a tabular form. The details listed for a snapshot in the list are -

*   Status (as an icon)
*   Name
*   Description
*   Creation Time (makes easy for administrator to decide while restore)

Actions supported for this sub-tab are -

*   Start - starts the snapshot
*   Stop - stops the snapshot
*   Restore - restores the consistency group to the said snapshot
*   Remove - removes the selected snapshots

### Limitations

NA

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterVolumeSnapshots> for detailed design of the feature.

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<https://forge.gluster.org/snapshot/pages/Home>

<http://sources.redhat.com/lvm/>

<http://www.gluster.org/community/documentation/index.php/Features/snapshot>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/GlusterVolumeSnapshots>

## Open Issues

<Category:Feature>
