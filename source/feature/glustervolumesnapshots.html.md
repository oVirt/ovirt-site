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

To read more about GlusterFS geo-replication, see <https://forge.gluster.org/snapshot/pages/Home>.

## Owner

*   Feature owner:
    -   GUI Component owner:
    -   Engine Component owner:
    -   VDSM Component owner:
    -   QA Owner:

## Current Status

*   Status:
*   Last updated date:

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

### User Experience

#### Geo-Replication Sessions

A new sub tab **Geo-Replication** will be added to the **Volumes** main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume. Geo-Replication Sessions subtab also provides actions for

*   Creating a new geo-replication session
*   Starting a geo-replication session
*   Stopping a geo-replication session
*   View details of a geo-replication session, this includes the list of individual geo-replication session and their respective status
*   Update configurations for a geo-replication session
*   Removing an existing geo-replication session

![](Georepsession1list.png "Georepsession1list.png")

#### Create a new Geo-Replication Session

The below dialog captures the details and creates the geo-replication session between source and destination gluster volumes.

![](Georepsession2new.png "Georepsession2new.png")

The user can manually enter the **Volume** or click on **Show Volumes** to fetch the list of existing volumes in the destination cluster and select a volume from that list.

![](Georepsession2newvolumes.png "Georepsession2newvolumes.png")

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication** tab, which will start the selected geo-replication session(s).

#### Stop a Geo-Replication Session

A new action named **Stop** will be shown in the **Geo-Replication** tab, which will stop the selected geo-replication session(s).

#### Remove a Geo-Replication Session

A new action named **Remove** will be shown in the **Geo-Replication** tab, which will remove the selected geo-replication session(s).

#### Configuration Options for Geo-Replication Session

The below dialog fetches and lists the default values of all the configurations for a geo-replication session. It provides an option to change the values of the configurations. User can change the values of the configuration properties at any point of time after creating the geo-replication session. The geo-replication session will be restarted automatically if the user changes any configuration when the session is already started.

![](Georepsession3config.png "Georepsession3config.png")

#### Geo-Replication Session Details

With the distributed geo-replication, when a geo-replication session is created for a volume, internally more than one session will be created depending on the type of the volume and where the bricks are residing. This view will list all the individual sessions, their status and Up time. Additionally this will also contain the detailed status of the geo-replication session.

![](Georepsession4details.png "Georepsession4details.png")

### Limitations

*   Showing the source volume information for a volume which is being used as destination is not supported
*   Cascaded viewing is not available. (Sometimes a volume can be used as both source as well as destination)

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterGeoReplication> for detailed design of the feature.

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<http://www.gluster.org/community/documentation/index.php/GlusterFS_Geo_Replication>

<http://gluster.org/community/documentation/index.php/Gluster_3.2:_Starting_GlusterFS_Geo-replication>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

*   Currently it is not possible to detect a volume is being used as a destination for a geo-replication session
    -   UUID of the source volume can retrieved from the gluster, but its not possible to determine which source cluster it belongs to.

<Category:Feature>
