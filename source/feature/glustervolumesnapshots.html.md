---
title: GlusterVolumeSnapshots
category: feature
authors: sandrobonazzola, shtripat
wiki_category: Feature
wiki_title: Features/Design/GlusterVolumeSnapshots
wiki_revision_count: 110
wiki_last_updated: 2014-12-23
feature_name: Gluster Volume Snapshot
feature_modules: engine
feature_status: Inception
---

# Gluster Volume Snapshot

# Summary

This document describes the design for the volume snapshot feature under Gluster. GlusterFS provides crash recoverability for the volumes through snapshot feature and console needs to provide a web based mechanism to achieve the same feature.

This feature allows the administrators to create, list, delete, start, stop and restore to a given snapshot. With this administrators can view all the available snapshots taken for a volume and in case of crash can opt to restore to a point in time view using the existing snapshots.

# Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner:

# Current Status

*   Status: Inception
*   Last updated date: Mon Oct 24 2014

# Design

The snapshot feature is being designed to enable administrators to create and maintain individual volumes snapshots. It also provides mechanism to restore a volume to a point in time snapshot in a crash situation.

### New Entities

#### GlusterVolumeSnapshots

This entity stores the snapshots created for gluster volumes. Different volumes can have snapshots with same names.

| Column name | Type   | Description                                                |
|-------------|--------|------------------------------------------------------------|
| SnapId      | UUID   | Id of the new snapshot                                     |
| SnapName    | String | Name of the snapshot                                       |
| ClusterId   | UUID   | Id of the reference cluster to which the volume belongs to |
| VolumeId    | UUID   | Id of the reference volume for which the snapshot is taken |
| CreatedAt   | Date   | Creation time of the snapshot                              |
| Description | String | Description                                                |
| Status      | String | Current status of the snapshot                             |

*   GlusterVolumeSnapshotStatus
    -   STARTED
    -   NOT_STARTED

#### GlusterVolumeSnapshotConfig

This entity stores the details of a configuration parameter for volume related to snapshot feature. Volume specific values for the parameters would be maintained as part of this entity.

| Column name | Type   | Description                                            |
|-------------|--------|--------------------------------------------------------|
| ClusterId   | UUID   | Id of the reference cluster to which volume belongs to |
| VolumeId    | UUID   | Id of the reference volume                             |
| ParamName   | String | Name of the configuration parameter                    |
| ParamValue  | String | Value of the configuration parameter                   |

#### GlusterVolumeSnapshotSchedule

This entity stores the scheduling details for snapshots specific to a volume.

| Column name    | Type      | Description                                                     |
|----------------|-----------|-----------------------------------------------------------------|
| ClusterId      | UUID      | Id of the reference cluster to which volume belongs to          |
| VolumeId       | UUID      | Id of the reference volume                                      |
| Occurence      | String    | Frequency of the snapshot (Immediate/Once/Daily/Weekly/Monthly) |
| EndByInstances | Number    | No of snapshots by which to stop the schedule                   |
| EndByDate      | Date      | Date by which to stop the snapshot schedule                     |
| Days           | String    | Command separated days on which to take snapshots               |
| Time           | Timestamp | Exact time at what to snapshot                                  |

### Entities changes

None

### Sync Jobs

The Gluster volume snapshot details would be periodically fetched (frequency 5 minutes) and updated into engine using the GlusterSyncJob's heavy weight sync mechanism.

### BLL commands

*   <big>AddGlusterVolumeSnapshot</big> - creates a volume snapshot
*   <big>RestoreGlusterVolumeSnapshot</big> - restore a given volume to a snapshot
*   <big>RemoveGlusterVolumeSnapshot</big> - removes the given snapshot
*   <big>UpdateGlusterVolumeSnapshotConfig</big> - sets the configuration values for a given volume
*   <big>ActivateGlusterVolumeSnapshot</big> - activates the snapshot for further activities
*   <big>DeactivateGlusterVolumeSnapshot</big> - deactivates an already activated snapshot

### Engine Queries

*   <big>GetGlusterVolumeSnapshotsByVolumeId</big> - lists all the snapshot for a given volume
*   <big>GetGlusterVolumeSnapshotByVolumeIdAndSnapshotId</big> - lists snapshot for the given snapshot id and volume id
*   <big>GetGlusterVolumeSnapshotConfigDetailsByVolumeId</big> - lists all the snapshot configuration details for the given volume id
*   <big>GetAllGlusterVolumeSnapshotStatus</big> - lists all the snapshots with their status
*   <big>GetGlusterVolumeSnapshotStatusByVolumeId</big> - gets the status of a snapshot for a specific volume
*   <big>GetGlusterVolumeSnapshotStatusBySnapshotId</big> - gets the status of a specific snapshot

### VDSM Verbs

#### VDSM verbs for Snapshot creation

*   <big>glusterVolumeSnapshotCreate</big> - creates a volume snapshot
    -   Input
        -   volumeName
        -   snapName
        -   [description]
        -   [force]
    -   Output
        -   UUID of the created snapshot

#### VDSM verbs for restoring snaps

*   <big>glusterVolumeSnapshotRestore</big> - restores the given volume to the given snapshot
    -   Input
        -   volumeName
        -   snapshotName
    -   Output
        -   Success/Failure

#### VDSM verbs for deleting snaps

*   <big>glusterVolumeSnapshotDelete</big> - deletes the given snapshot
    -   Input
        -   snapName
    -   Output
        -   Success/Failure

#### VDSM verbs for listing snaps

*   <big>glusterVolumeSanpshotList</big> - gets the list of snapshots for a volume
    -   Input
        -   [volumeName]
    -   Output
        -   snapsList

Note: If volumeName is not passed, all the snaps are listed

#### VDSM verbs for snapshot configuration

*   <big>glusterVolumeSnapshotSetConfig</big> - sets the snapshot configuration parameters for the given volume
    -   Input
        -   volumeName
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

#### VDSM verbs for the snapshots status

*   <big>glusterVolumeSnapshotStatus</big> - gets the snapshot status details for a volume
    -   Input
        -   volumeName
    -   [snapName]
    -   Output
        -   UNKNOWN/INIT/IN_USE/RESTORED/DECOMMISSIONED

Note: If snapName is not passed, status of all the snaps are listed

#### VDSM verbs for activating a snapshot

*   <big>glusterVolumeSnapshotActivate</big> - activates the given snapshot
    -   Input
        -   snapName
        -   [force]
    -   Output
        -   Success/Failure

Note: If force is passed as true, even if some the bricks are down, they are brought up and snapshot is activated.

#### VDSM verbs for deactivating the snapshots

*   <big>glusterVolumeSnapshotDeactivate</big> - deactivates the given snapshot
    -   Input
        -   snapName
    -   Output
        -   Success/Failure

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
                    <snaptime>{timestamp}</snaptime>
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
            <snaptime>{timestamp}</snaptime>
    </snapshot>

*   /api/clusters/{cluster-id}/glustervolumes|rel=get - Gluster volume listing would be updated to list the snapshot configuration parameters as well

Output:

    <glustervolume>
    ........
    <snapshot_config_params>
        <parameter>
        <name>snap-max-limit</name>
            <value>{value}</value>
        </parameter>
        <parameter>
        <name>snap-max-soft-limit</name>
            <value>{value}</value>
        </parameter>
    </snapshot_config_params>
    </glustervolume>

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

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots|rel=delete - deletes snapshot
    -   Parameters
        -   snapshot-id / snapshot-name

Input:

    <snapshot id="{id}" />

or

    <snapshot>
        <name>{name}</name>
    </snapshot>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots/{snapshot-id}/restore|rel=restore - restores the given volume to the given snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots/{snapshot-id}/activate|rel=activate - activates the given volume snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/snapshots/{snapshot-id}/deactivate|rel=deactivate - deactivates the given volume snapshot

Input:

    <action/>

*   /api/clusters/{cluster-id}/glustervolumes/{volume-id}/setsnapshotconfig|rel=setsnapshotconfig - sets a snapshot configuration parameter value for the given volume
    -   Parameters
        -   name-value pair of configuration parameters
        -   [force]

Input:

    <action>
        <configurations>
            <config>
            <name>{name-1}</name>
            <value>{value-1}</value>
            </config>
            <config>
            <name>{name-2}</name>
            <value>{value-2}</value>
            </config>
        </configurations>
        <force>true/false</force>
    </action>

[Category: Feature](Category: Feature)
