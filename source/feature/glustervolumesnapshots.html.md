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

*   <big>AddGlusterVolumeConsistencyGroup</big> - creates a consistency group
*   <big>AddGlusterVolumesToConsistencyGroup</big> - adds volumes to consistency group
*   <big>RemoveGlusterVolumeConsistencyGroup</big> - removes said volumes from the consistency group (if list of volumes passed as parameters). If no volumes passed, the consistency group itself is deleted.
*   <big>AddGlusterVolumeSnapshot</big> - creates a volume snapshot
*   <big>AddGlusterVolumeConsistencyGroupSnapshot</big> - creates a consistency group snapshot
*   <big>RestoreGlusterVolumeSnapshot</big> - restore a given volume to a snapshot
*   <big>RestoreGlusterVolumeConsistencyGroup</big> - allows for all the volumes which have a snapshot in the mentioned CG to be restored that point in time. This provides roll-back mechanisms for the multiple volumes which were snapped together
*   <big>RemoveGlusterVolumeSnapshot</big> - removes the given snapshot
*   <big>RemoveGlusterVolumeConsistencyGroupSnapshot</big> - removes the given consistency group snapshot
*   <big>UpdateGlusterVolumeSnapshotConfig</big> - sets the configuration values for a given volume snapshot
*   <big>UpdateGlusterVolumeConsistencyGroupSnapshotConfig</big> - sets the configuration values for a given consistency group
*   <big>StartGlusterVolumeSnapshot</big> - starts the given snapshot
*   <big>StartGlusterVolumeConsistencyGroupSnapshot</big> - starts the given consistency group
*   <big>StopGlusterVolumeSnapshot</big> - stops the given snapshot
*   <big>StopGlusterVolumeConsistencyGroupSnapshot</big> - stops the given consistency group

### Engine Queries

*   <big>GetGlusterVolumeSnapshotsByVolumeId</big> - lists all the snapshot for a given volume
*   <big>GetGlusterVolumeSnapshotByVolumeIdAndSnapshotId</big> - lists snapshot for the given snapshot id and volume id
*   <big>GetGlusterVolumeConsistencyGroupById</big> - lists the consistency group by id
*   <big>GetGlusterVolumeConsistencyGroupSnapshotByCgIdAndSnapId</big> - lists the consistency group snapshot by consistency group id and snap id
*   <big>GetGlusterVolumeSnapshotConfigDetailsByVolumeId</big> - lists all the snapshot configuration details for the given volume id
*   <big>GetGlusterVolumeConsistencyGroupConfigDetailsByCgId</big> - lists all the snapshot configuration details for the given cg id
*   <big>GetAllGlusterVolumeSnapshotStatus</big> - lists all the snapshot with their status
*   <big>GetGlusterVolumeSnapshotStatusByVolumeId</big> - gets the status of a snapshot for a specific volume
*   <big>GetGlusterVolumeSnapshotStatusBySnapId</big> - gets the status of a specific snapshot
*   <big>GetGlusterVolumeSnapshotStatusById</big> - lists snapshot status for a consistency group

### VDSM Verbs

#### VDSM Verbs for consistency group maintenance

*   <big>glusterConsistencyGroupCreate</big> - creates a consistency group
    -   Input
        -   cgName
        -   volumeNames
        -   [force]
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterConsistencyGroupAddVolume</big> - adds new volumes to the consistency group. Once a new volume is added to a CG then CG cannot be restored to older snaps.
    -   Input
        -   cgName
        -   volumeNames
        -   [force]
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterConsistencyGroupDeleteVolume</big> - deletes the volumes from the consistency group
    -   Input
        -   cgName
        -   [volumeNames]
    -   Output
        -   Success/Failure

Note: If no volumes passed, the consistency group would be deleted. if a volume gets deleted from the CG, it cannot be restore to a older snap.

*   <big>glusterConsistencyGroupsList</big> - lists the consistency groups
    -   Input
        -   [cgName]
    -   Output
        -   cgList

Note: If no consistency group name passed, it would list all the consistency groups.

#### VDSM verbs for Snapshot creation

*   <big>glusterVolumeSnapshotCreate</big> - creates a volume snapshot
    -   Input
        -   volumeName
        -   snapName
        -   [description]
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterCGSnapshotCreate</big> - creates a snapshot of the consistency group
    -   Input
        -   cgName
        -   snapName
        -   [description]
    -   Output
        -   Success/Failure

#### VDSM verbs for restoring snaps

*   <big>glusterVolumeSnapshotRestore</big> - restores the given volume to the given snapshot
    -   Input
        -   volumeName
        -   snapshotName
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterCGSnapshotRestore</big> - allows to restore a CG to the specified snap
    -   Input
        -   cgName
        -   snapName
    -   Output
        -   Success/Failure

#### VDSM verbs for deleting snaps

*   <big>glusterVolumeSnapshotDelete</big> - deletes the given snapshot
    -   Input
        -   volumeName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed all the snaps would be deleted for the volume

*   <big>glusterCGSnapshotDelete</big> - deletes the given consistency group snapshot
    -   Input
        -   cgName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If no snapName is passed, all the snaps would be deleted for the consistency group

#### VDSM verbs for listing snaps

=

*   <big>glusterVolumeSanpshotList</big> - gets the list of snapshots for a volume
    -   Input
        -   volumeName
        -   [snapName]
    -   Output
        -   snapsList

Note: If snapName is not passed, all the snaps of the volume are listed

*   <big>glusterCGSnapshotList</big>
    -   Input
        -   cgName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed, all the snaps for the consistency group are listed

#### VDSM verbs for snapshot configuration

*   <big>glusterVolumeSnapshotSetConfig</big> - sets the snapshot configuration parameters for the given volume
    -   Input
        -   volumeName
        -   configList(name=value pair)
        -   [force]
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterCGSnapshotSetConfig</big> - sets the snapshot configuration parameters for the given consistency group
    -   Input
        -   cgName
        -   configList(name=value pair)
        -   [force]
    -   Output
        -   Success/Failure

<!-- -->

*   <big>glusterVolumeSnapshotGetConfig</big> - gets the value of the snapshot configuration parameter for the given volume
    -   Input
        -   [volumeName]
    -   Ouptut
        -   Name=Value pair list

Note: If volumeName is not passed, configuration values for all the volumes are listed

*   <big>glusterCGSnapshotGetConfig</big> - gets the value of snapshot configuration parameter for the given consistency group
    -   Input
        -   [cgName]
    -   Output
        -   Name=Value pair list

Note: If cgName is passed, all the configurations for the all the consistency groups are listed

#### VDSM verbs for the snapshots status

*   <big>glusterAllVolumeSnapshotStatus</big> - gets the status of all the snapshots. This includes brick details, LVM details, process details etc.
    -   Input
    -   Output

<!-- -->

*   <big>glusterVolumeSnapshotStatus</big> - gets the snapshot status details for a volume
    -   Input
        -   volumeName
    -   [snapName]
    -   Output
        -   SUCCESS/FAILED/IN_PROGRESS/OFFLINE

Note: If snapName is not passed, status of all the snaps are listed

*   <big>glusterCGSnapshotStatus</big> - gets the snapshot status of given consistency group
    -   Input
        -   cgName
        -   [snapName]
    -   Output
        -   SUCCESS/FAILED/IN_PROGRESS/OFFLINE

Note: If snapName is not passed, status of all the snaps are listed for the consistency group

#### VDSM verbs for starting a snapshot

*   <big>glusterVolumeSnapshotStart</big> - starts the given snapshot
    -   Input
        -   volumeName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName not passed, all the snapshots of the volume are started

*   <big>glusterCGSnapshotStart</big> - starts the snapshots of the given consistency group
    -   Input
        -   cgName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed, all the snapshots of the consistency group are started

#### VDSM verbs for stopping the snapshots

*   <big>glusterVolumeSnapshotStop</big> - stops the given snapshot
    -   Input
        -   volumeName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed, all the snaps of the volume are stopped

*   <big>glusterCGSnapshotStop</big> - stops the snapshots of the given consistency group
    -   Input
        -   cgName
        -   [snapName]
    -   Output
        -   Success/Failure

Note: If snapName is not passed, all the snaps of the consistency group are stopped

### REST APIs

The details of the REST for Gluster Volume Snapshot feature are as below -

#### Listing APIs

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots|rel=get - lists all the snapshots for a given volume

Output:

    <snapshots>
        <snapshot href="" id="">
            <actions>
            </actions>
            <name>{name}</name>
            <link>{link}</link>
            <volume href="" id=""/>
            <description>{description}</description>
            <status>{status}</status>
        </snapshot>
    </snapshots>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots/{snapshot-id}|rel=get - lists the details of a specific snapshot of a volume

Output:

    <snapshot href="" id="">
        <actions>
        </actions>
        <name>{name}</name>
        <link>{link}</link>
        <volume href="" id=""/>
        <description>{description}</description>
        <status>{status}</status>
    </snapshot>

*   /api/clusters/{cluster-id}/glustervolumes|rel=get - Gluster volume listing would be updated to list the snapshot configuration parameters as well

Output:

    <glustervolume>
    ........
    <snapshot_config>
        <option name="" value=""/>
        <option name="" value=""/>
    </snapshot_config>
    </glustervolume>

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
                    <snapshot_config>
                    <option name="" value=""/>
                    <option name="" value=""/>
                    </snapshot_config>
        </consistencygroup>
    </consistencygroups>

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
            <snapshot_config>
            <option name="" value=""/>
            <option name="" value=""/>
            </snapshot_config>
    </consistencygroup>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/snapshots|rel=get - lists the snapshots of an individual consistency group

Output:

    <snapshots>
        <snapshot href="" id="">
            <actions>
            </actions>
            <name>{name}</name>
            <link>{link}</link>
            <consistencygroup href="" id=""/>
            <description>{description}</description>
            <status>{status}</status>
        </snapshot>
    </snapshots>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/snapshots/{snapshot-id}|rel=get - lists the individual snapshot of an individual consistency group

Output:

    <snapshot href="" id="">
        <actions>
        </actions>
        <name>{name}</name>
        <link>{link}</link>
        <consistencygroup href="" id=""/>
        <description>{description}</description>
        <status>{status}</status>
    </snapshot>

#### Actions Supported

*   /ap/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots|rel=add - creates and adds a new snapshot for the given volume
    -   Parameters
        -   name - String
        -   volume_name - String
        -   [description] - string

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
        -   [force] - boolean

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
        <force>true/false</force>
    </consistencygroup>
    </action>

*   /ap/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/snapshots|rel=add - creates and adds a new snapshot for the given volume
    -   Parameters
        -   name - String
        -   volume_name - String
        -   [description] - string

Input:

    <action>
        <snapshot>
            <name>{name}</name>
            <volume_name>{volume-name}</volume_name>
            <description>{description}</description>
        </snapshot>
    </action>

*   /ap/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/addvolume|rel=addvolume - adds set of volumes to the consistency group
    -   Parameters
        -   volumes - list of volume names

Input:

    <action>
        <volumes>
            <volume>
                           <name>{name}</name>
                    </volume>
            <volume>
                           <name>{name}</name>
                    </volume>
        </volumes>
    </action>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots|rel=delete - deletes snapshots
    -   Parameters
        -   snapshot-id / snapshot-name / volume-name

Input:

    <snapshot id="{id}" />

or

    <snapshot>
        <name>{name}</name>
    </snapshot>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/snapshots|rel=delete - deletes consistency group
    -   Parameters
        -   cg-id / cg-name

Input:

    <consistencygroup id="id" />

or

    <consistencygroup>
        <name>{name}</name>
    </consistencygroup>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/deletevolume|rel=deletevolume - removes volumes from the consistency group
    -   Parameters
        -   volumes - list of volume names

Input:

    <action>
        <volumes>
            <volume>
                           <name>{name}</name>
                    </volume>
            <volume>
                           <name>{name}</name>
                    </volume>
        </volumes>
    </action>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots/{snapshot-id}/restore|rel=restore - restores the given volume to the given snapshot

Input:

    <action/>

*   /api/clusters/{clusters-id}/consistencygroups/{consistencygroup-id}/snapshots/{snapshot-id}/restore|rel=restore - allows for all the volumes which have a snapshot in the mentioned CG to be restored that point in time. This provides roll-back mechanisms for the multiple volumes which were snapped together.

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/setsnapshotconfig|rel=setsnapshotconfig - sets a snapshot configuration parameter value for the given volume
    -   Parameters
        -   name-value pair of configuration parameters

Input:

    <action>
            <config>
            <name>{name-1}</name>
            <value>{value-1}</value>
            </config>
            <config>
            <name>{name-2}</name>
            <value>{value-2}</value>
            </config>
    </action>

*   /api/clusters/{cluster-id}/consistencygroups/{consistencygroup-id}/setsnapshotconfig|rel=setsnapshotconfig - sets a snapshot configuration parameter value for the given consistency group
    -   Parameters
        -   name-value pair of configuration parameters

Input:

    <action>
            <config>
            <name>{name-1}</name>
            <value>{value-1}</value>
            </config>
            <config>
            <name>{name-2}</name>
            <value>{value-2}</value>
            </config>
    </action>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}/start|rel=start - starts the given snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/consistencygroups/{consistency-group-id}/snapshots/{snapshot-id}/start|rel=start - starts a consistency group snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/glustersnapshots/{snapshot-id}/stop|rel=stop - stops the given snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/consistencygroups/{consistency-group-id}/snapshots/{snapshot-id}/stop|rel=stop - stops the given consistency group snapshot

Input:

    <action/>

[Category: Feature](Category: Feature)
