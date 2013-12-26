---
title: GlusterVolumeSnapshots
category: feature
authors: sandrobonazzola, shtripat
wiki_category: Feature
wiki_title: Features/Design/GlusterVolumeSnapshots
wiki_revision_count: 110
wiki_last_updated: 2014-12-23
---

# Gluster Volume Snapshots

## Summary

This document describes the design for the volume snapshot feature under Gluster. GlusterFS provides crash recoverability for the vloumes through snapshot feature and RHS-C needs to provide a web based mechanism to achieve the same feature.

This feature allows the administrators to create, start, stop, delete and restore to a given snapshot. With this administrators can view all the available snaps taken for a volume and in case of crash can opt to restore to a point in time view using the existing snapshots.

## Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner:

## Current Status

*   Status: Inception
*   Last updated date: Thu Dec 26 2013

## Design

The snapshot feature is being designed to enable administrators to define a consistency group, create and maintain volume snapshots. It also provides mechanism to restore a volume to a point in time snap of the volume in a crash situation.

### New Entities

#### GlusterVolumeConsistencyGroup

This entity stores the details of a Gluster volume consistency group. While definition of a consistency group different volumes are assigned the newly created consistency group's identity to make sure they belong to the said consistency group.

| Column name | Type   | Description                          |
|-------------|--------|--------------------------------------|
| Id          | UUID   | Primary Key                          |
| CGName      | String | Name of the consistency group        |
| Description | String | Description of the consistency group |

#### GlusterVolumeSnapshots

This entity stores the snapshot details created on gluster volumes. Different volumes can have snapshots with same names.

| Column name | Type   | Description                    |
|-------------|--------|--------------------------------|
| VolumeId    | UUID   | Id of the reference volume     |
| SnapId      | UUID   | Id of the new snapshot         |
| SnapName    | String | Name of the snapshot           |
| SanpTime    | Date   | Creation time of the snapshot  |
| description | String | Description                    |
| Status      | String | Current status of the snapshot |

*   GlusterVolumeSnapshotStatus
    -   IN_USE
    -   STOPPED
    -   DECOMMISSIONED

#### GlusterVolumeSnapshotConfig

This entity stores the details of a configuration parameter for volume snapshot. Volume specific values for the parameters would be maintained as part of this entity, whereas the system level configuration parameters would be maintained as part of vdc_options only.

| Column name | Type   | Description                          |
|-------------|--------|--------------------------------------|
| VolumeId    | UUID   | Id of the reference volume           |
| ParamName   | String | Name of the configuration parameter  |
| ParamValue  | String | Value of the configuration parameter |

### Entities changes

*   Change to store consistency group id for a volume
    -   Add a field cgId of UUID type in gluster_volumes table to store a consistency group id, if volume is part of a consistency group

<big>gluster_volumes</big>

| Column | Type           | Change   | Description                                                              |
|--------|----------------|----------|--------------------------------------------------------------------------|
| cgId   | UUID, nullable | Addition | stores the consistency group id if volume is part of a consistency group |

### Sync Jobs

The Gluster volume snapshot and consistency group details would be periodically fetched and updated into engine using the GlusterSyncJob's lightweight sync mechanism.

### BLL commands

*   <big>AddGlusterVolumeSnapshot</big> - adds a snapshot
*   <big>AddGlusterVolumeConsistencyGroup</big> - adds a consistency group
*   <big>RestoreGlusterVolumeSnapshot</big> - restore a given volume to a snapshot
*   <big>RestoreGlusterVolumeConsistencyGroup</big> - allows for all the volumes which have a snapshot in the mentioned CG to be restored that point in time. This provides roll-back mechanisms for the multiple volumes which were snapped together
*   <big>RemoveGlusterVolumeSnapshot</big> - removes the given snapshot
*   <big>RemoveGlusterVolumeConsistencyGroup</big> - removes the given consistency group
*   <big>StopGlusterVolumeSnapshot</big> - stops the given snapshot
*   <big>StartGlusterVolumeSnapshot</big> - starts the given snapshot
*   <big>RenameGlusterVolumeSnapshot</big> - renames the given snapshot
*   <big>StopGlusterVolumeConsistencyGroup</big> - stops the given consistency group
*   <big>StartGlusterVolumeConsistencyGroup</big> - starts the given consistency group
*   <big>RenameGlusterVolumeConsistencyGroup</big> - renames the given consistency group

### Engine Queries

*   <big>GetGlusterVolumeSnapshotsByVolumeId</big> - lists all the snapshot for a given volume
*   <big>GetGlusterVolumeSnapshotByVolumeIdAndSnapshotId</big> - lists snapshot for the given snapshot id and volume id
*   <big>GetGlusterVolumeConsistencyGroupById</big> - lists the consistency group by id
*   <big>GetGlusterVolumeSnapshotConfigDetails</big> - lists all the snapshot configuration details
*   <big>GetGlusterVolumeSnapshotConfigDetailsForVolume</big> - lists all the snapshot configuration details for a volume
*   <big>GetAllGlusterVolumeSnapshotStatus</big> - lists all the snapshot with their status
*   <big>GetGlusterVolumeSnapshotStatusForSnapshot</big> - gets the status of a specific snapshot
*   <big>GetGlusterVolumeSnapshotStatusForConsistencyGroup</big> - lists snapshot status for a consistency group
*   <big>GetGlusterVolumeSnapshotStatusForVolume</big> - lists snapshot status details for a volume and its snapshots

### VDSM Verbs

*   glusterVolumeSnapshotCreate - creates a volume snapshot
    -   Input
        -   volumeName
        -   snapName
        -   [description]
    -   Output
        -   Success/Failure

<!-- -->

*   glusterConsistencyGroupCreate - creates a consistency group
    -   Input
        -   volumeNames
        -   cgName
        -   [description]
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSanpshotList - gets the list of snapshots for a volume
    -   Input
        -   volumeName
        -   [option -d]
    -   Output
        -   snapsList

<!-- -->

*   glusterConsistencyGroupsList - gets the details of a consistency group
    -   Input
        -   cgName
        -   [option -d]
    -   Output
        -   cgList

<!-- -->

*   glusterVolumeSnapshotRename - renames a given snapshot with new name
    -   Input
        -   oldSnapName
        -   newSnapName
    -   Ouptut
        -   Success/Failure

<!-- -->

*   glusterConsistencyGroupRename - renames a given consistency group with new name
    -   Input
        -   oldCgName
        -   newCgName
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSnapshotRestore - restores the given volume to the given snapshot
    -   Input
        -   volumeName
        -   snapshotName
    -   Output
        -   Success/Failure

<!-- -->

*   glusterConsistencyGroupRestore - allows for all the volumes which have a snapshot in the mentioned CG to be restored that point in time
    -   Input
        -   cgName
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSnapshotSetConfig - sets the snapshot configuration parameters for the given volume
    -   Input
        -   volumeName
        -   configList(name=value pair)
    -   Output
        -   Success/Failure

Note: volumeName can be passed as ALL and the configurations would be set for all the volumes

*   glusterVolumeSnapshotGetConfig - gets the value of the given snapshot configuration parameter for the given volume
    -   Input
        -   volumeName
        -   [optionName]
    -   Ouptut
        -   Name=Value pair list

Note: volumeName can be passed as ALL and it would list system level configurations set for snapshot. If option-name is passed only that value is returned

*   glusterVolumeSnapshotCancel - cancels the given snapshot
    -   Input
        -   snapName/cgName/taskId
        -   optionType (-s, -t)
    -   Output
        -   Success/Failure

<!-- -->

*   glusterConsistencyGroupCancel - cancels the given consistency group
    -   Input
        -   cgName/taskId
        -   optionType (-c, -t)
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSnapshotStatus - gets the status of the given snapshot
    -   Input
        -   [snapName/volumeName]
        -   optionType (-s, -v)
    -   Output
        -   SUCCESS/FAILED/IN_PROGRESS/OFFLINE

Note: If no input passed at all, status details of all the snapshots is listed

*   glusterConsistencyGroupStatus - gets the status of given consistency group
    -   Input
        -   cgName/taskId
        -   optionType (-c, -t)
    -   Output
        -   SUCCESS/FAILED/IN_PROGRESS/OFFLINE

<!-- -->

*   glusterVolumeSnapshotDelete - deletes the given snapshot
    -   Input
        -   volumeName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed all the snaps would be deleted for the volume

*   glusterConsistencyGroupDelete - deletes the consistency group
    -   Input
        -   cgName
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSnapshotStop - stops the given snapshot
    -   Input
        -   snapName/volumeName
        -   [optionType (-v)]
    -   Output
        -   Success/Failure

Note: the optionType value -v is required if volumeName is passed as first parameter

*   glusterConsistencyGroupStop - stops the given consistency group
    -   Input
        -   cgName
    -   Output
        -   Success/Failure

<!-- -->

*   glusterVolumeSnapshotStart - starts the given snapshot
    -   Input
        -   snapName/volumeName
        -   [optionType (-v)]
    -   Output
        -   Success/Failure

Note: the optionType value -v is required if volumeName is passed as first parameter

*   glusterConsistencyGroupStart - starts the given consistency group
    -   Input
        -   cgName
    -   Output
        -   Success/Failure

### REST APIs

The details of the REST for Gluster Volume Snapshot feature are as below -

#### Listing APIs

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots|rel=get - lists all the snapshots for a given volume

Output:

    <glustersnapshots>
        <glustersnapshot href="" id="">
            <actions>
            </actions>
            <name>{name}</name>
            <link>{link}</link>
            <volume href="" id=""/>
            <description>{description}</description>
            <status>{status}</status>
        </glustersnapshot>
    </glustersnapshots>

*   /api/clusters/{cluster-id}/consistencygroups|rel=get - lists all the consistency groups

Output:

    <consistencygroups>
        <consistencygroup href="" id="">
            <actions>
            </actions>
            <name>{name}</name>
            <link>{link}</link>
            <volumes>
                <volume href="" id=""/>
                <volume href="" id=""/>
            </volumes>
            <description>{description}</description>
            <status>{status}</status>
        </consistencygroup>
    </consistencygroups>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}|rel=get - lists the details of a specific snapshot

Output:

    <glustersnapshot href="" id="">
        <actions>
        </actions>
        <name>{name}</name>
        <link>{link}</link>
        <volume href="" id=""/>
        <description>{description}</description>
        <status>{status}</status>
    </glustersnapshot>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}|rel=get - lists the detail of an individual consistency group

Output:

    <consistencygroup href="" id="">
        <actions>
        </actions>
        <name>{name}</name>
        <link>{link}</link>
        <volumes>
            <volume href="" id=""/>
            <volume href="" id=""/>
        </volumes>
        <description>{description}</description>
        <status>{status}</status>
    </consistencygroup>

*   /api/clusters/{cluster-id}/glustervolumes|rel=get - Gluster volume listing would be updated to list the snapshot configuration parameters as well

Output:

    <glustervolume>
    ........
    <snapshot_config>
        <option name="" value=""/>
        <option name="" value=""/>
    </snapshot_config>
    </glustervolume>

#### Actions Supported

*   /ap/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots|rel=add - creates and adds a new snapshot for the given volume
    -   Parameters
        -   name - String
        -   volume_name - String
        -   description - string

Input:

    <action>
        <snapshot>
            <name>{name}</name>
            <volume_name>{volume-name}</volume_name>
            <description>{description}</description>
        </snapshot>
    </action>

*   /api/clusters/{cluster-id}/consistencygroups|rel=add - creates and adds a new consistency group
    -   Parameters
        -   name - String
        -   volumes - list of volume names
        -   description - String

Input:

    <action>
    <consistencygroup>
        <name>{name}</name>
        <volumes>
            <volume>
                           <name>{name}</name>
                    </volume>
            <volume>
                           <name>{name}</name>
                    </volume>
        </volumes>
        <description>{description}</description>
    </consistencygroup>
    </action>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshot|rel=delete - deletes snapshots
    -   Parameters
        -   snapshot-id / snapshot-name / volume-name

Input:

    <snapshot id="{id}" />

or

    <snapshot>
        <name>{name}</name>
    </snapshot>

or

    <snapshot>
        <volume_name>{vol-name}</volume_name>
    </snapshot>

*   /api/clusters/{cluster-id}/consistencygroups|rel=delete - deletes consistency group
    -   Parameters
        -   cg-id / cg-name

Input:

    <consistencygroup id="id" />

or

    <consistencygroup>
        <name>{name}</name>
    </consistencygroup>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}/start|rel=start - starts the given snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/consistencygroups/{consistency-group-id}/start|rel=start - starts a consistency group

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}/stop|rel=stop - stops the given snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/consistencygroups/{consistency-group-id}/stop|rel=stop - stops the given consistency group

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}/restore|rel=restore - restores the given volume to the given snapshot

Input:

    <action/>

*   /api/clusters/{clusters-id}/consistencygroups/{consistency-group-id}/restore|rel=restore - allows for all the volumes which have a snapshot in the mentioned CG to be restored that point in time. This provides roll-back mechanisms for the multiple volumes which were snapped together.

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/setsnapshotconfig|rel=setsnapshotconfig - sets a snapshot configuration parameter value for the given volume
    -   Parameters
        -   Option-name
        -   Option-value

Input:

    <action>
        <option_name>{name}</name>
        <option_value>{value}</option_value>
    </action>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}|rel=rename - renames the given snspshot
    -   Parameters
        -   New snapshot name

Input:

    <snapshot>
        <name>{name}</name>
    </snapshot>

*   /api/clusters/{cluster-id}/consistencygroups/{consistency-group-id}|rel=rename - renames the given consistency group
    -   Parameters
        -   New consistency group name

Input:

    <consistencygroup>
        <name>{name}</name>
    </consistencygroup>

[Category: Feature](Category: Feature)
