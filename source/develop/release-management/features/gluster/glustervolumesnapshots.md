---
title: GlusterVolumeSnapshots
category: feature
authors:
  - sandrobonazzola
  - shtripat
---

# Gluster Volume Snapshot

# Summary

This document describes the design for the volume snapshot feature under Gluster. GlusterFS provides crash recoverability for the volumes through snapshot feature and console needs to provide a web based mechanism to achieve the same feature.

This feature allows the administrators to create, schedule, list, delete, start, stop and restore to a given snapshot. With this administrators can view all the available snapshots taken for a volume and in case of crash can opt to restore to a point in time view using the existing snapshots.

# Owner

*   Feature owner: Shubhendu Tripathi
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi
    -   VDSM Component owner:

# Current Status

*   Status: Inception
*   Last updated date: Mon Oct 24 2014

# Design

The snapshot feature is being designed to enable administrators to create and maintain individual volumes snapshots. It also provides mechanism to restore a volume to a point in time snapshot in a crash situation.

## New Entities

### GlusterVolumeSnapshots

This entity stores the snapshots created for gluster volumes. Different volumes can have snapshots with same names.

| Column name    | Type   | Description                                                |
|----------------|--------|------------------------------------------------------------|
| snapshot_id   | UUID   | Id of the new snapshot                                     |
| volume_id     | UUID   | Id of the reference volume for which the snapshot is taken |
| snapshot_name | String | Name of the snapshot                                       |
| description    | String | Description                                                |
| status         | String | Current status of the snapshot                             |

*   `GlusterVolumeSnapshotStatus`
    -   `STARTED`
    -   `STOPPED`

### GlusterVolumeSnapshotConfig

This entity stores the details of a configuration parameter for volume related to snapshot feature. Volume specific values for the parameters would be maintained as part of this entity.

| Column name  | Type   | Description                                            |
|--------------|--------|--------------------------------------------------------|
| cluster_id  | UUID   | Id of the reference cluster to which volume belongs to |
| volume_id   | UUID   | Id of the reference volume                             |
| param_name  | String | Name of the configuration parameter                    |
| param_value | String | Value of the configuration parameter                   |

## Entities changes

None

## Sync Jobs

The Gluster volume snapshot details would be periodically fetched (frequency 5 minutes) and updated into engine using a sync job.

## BLL commands

* `CreateGlusterVolumeSnapshot` - creates a volume snapshot
* `RestoreGlusterVolumeSnapshot` - restore a given volume to a snapshot
* `RemoveGlusterVolumeSnapshot` - removes the given snapshot
* `UpdateGlusterVolumeSnapshotConfig` - sets the configuration values for a given volume
* `ActivateGlusterVolumeSnapshot` - activates the snapshot for further activities
* `DeactivateGlusterVolumeSnapshot` - deactivates an already activated snapshot

## Engine Queries

* `GetGlusterVolumeSnapshotsByVolumeId` - lists all the snapshot for a given volume
* `GetGlusterVolumeSnapshotsCountByVolumeId` - gets the no of snapshots for a given volume
* `GetGlusterVolumeSnapshotConfig` - gets the volume snapshot configurations for a given volume
* `GetGlusterVolumeSnapshotByVolumeIdAndSnapshotId` - lists snapshot for the given snapshot id and volume id
* `GetGlusterVolumeSnapshotConfigDetailsByVolumeId` - lists all the snapshot configuration details for the given volume id
* `GetAllGlusterVolumeSnapshotStatus` - lists all the snapshots with their status
* `GetGlusterVolumeSnapshotStatusByVolumeId` - gets the status of a snapshot for a specific volume
* `GetGlusterVolumeSnapshotStatusBySnapshotId` - gets the status of a specific snapshot

## VDSM Verbs

### VDSM verbs for Snapshot creation

*   `glusterSnapshotCreate` - creates a volume snapshot
    -   Input
        -   volumeName
        -   snapName
        -   [description]
        -   [force]
    -   Output
        -   UUID of the created snapshot

### VDSM verbs for restoring snaps

*   `glusterSnapshotRestore` - restores the given volume to the given snapshot
    -   Input
        -   snapshotName
    -   Output
        -   Success/Failure

### VDSM verbs for deleting snaps

*   `glusterSnapshotDelete` - deletes the given snapshot
    -   Input
        -   snapName
    -   Output
        -   Success/Failure

### VDSM verbs for listing snaps

*   `glusterSanpshotList` - gets the list of snapshots for a volume
    -   Input
        -   [volumeName]
    -   Output
        -   snapsList

Note: If volumeName is not passed, all the snaps are listed

### VDSM verbs for snapshot configuration

*   `glusterSnapshotConfigSet` - sets the snapshot configuration parameters for the given volume
    -   Input
        -   volumeName
        -   configList(name=value pair)
    -   Output
        -   Success/Failure

<!-- -->

*   `glusterSnapshotConfigGet` - gets the value of the snapshot configuration parameter for the given volume
    -   Input
        -   [volumeName]
    -   Ouptut
        -   Name=Value pair list

Note: If volumeName is not passed, configuration values for all the volumes are listed

### VDSM verbs for the snapshots status

*   `glusterSnapshotStatus` - gets the snapshot status details for a volume
    -   Input
        -   [volumeName]
        -   [snapName]
    -   Output
        -   snapshot status details

### VDSM verbs for activating a snapshot

*   `glusterSnapshotActivate` - activates the given snapshot
    -   Input
        -   snapName
        -   [force]
    -   Output
        -   Success/Failure

Note: If force is passed as true, even if some the bricks are down, they are brought up and snapshot is activated.

### VDSM verbs for deactivating the snapshots

*   `glusterSnapshotDeactivate` - deactivates the given snapshot
    -   Input
        -   snapName
    -   Output
        -   Success/Failure

### VDSM verbs for getting the snapshot info

*   `glusterSnapshotInfo` - gets the snapshot info
    -   Input
        -   [snapName]
        -   [volumeName]
    -   Output
        -   snapshot info details

## REST APIs

The details of the REST for Gluster Volume Snapshot feature are as below -

### Listing APIs

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots|rel=get` - lists all the snapshots for a given volume

Output:

```xml
    <volume_snapshots>
        <volume_snapshot href="" id="">
            <actions>
            </actions>
            <name>{name}</name>
            <link>{link}</link>
            <volume href="" id=""/>
            <description>{description}</description>
            <status>{status}</status>
                    <createdAt>{timestamp}</createdAt>
        </volume_snapshot>
    </volume_snapshots>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots/{volume-snapshot-id}|rel=get` - lists the details of a specific snapshot of a volume

Output:

```xml
    <volume_snapshot href="" id="">
        <actions>
        </actions>
        <name>{name}</name>
        <link>{link}</link>
        <volume href="" id=""/>
        <description>{description}</description>
        <status>{status}</status>
            <createAt>{timestamp}</createAt>
    </volume_snapshot>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}|rel=get` - Gluster volume listing would be updated to list the snapshot configuration parameters and scheduling details of snapshots (if any) as well

Output:

```xml
    <glustervolume>
    ........
    <volume_snapshot_configuration_parameters>
        <volume_snapshot_configuration_parameter>
        <name>snap-max-hard-limit</name>
            <value>{value}</value>
        </volume_snapshot_configuration_parameter>
    </volume_snapshot_configuration_parameters>
    <volume_snapshot_schedule>
        <cron_expression>{cron expression of the schedule}</cron_expression>
    </volume_snapshot_schedule>
    </glustervolume>
```

*   `/api/clusters/{cluster-id}|rel=get` - Cluster listing would be updated to list the snapshot configuration parameters as well

Output:

```xml
    <cluster>
    ........
    <volume_snapshot_configuration_parameters>
        <volume_snapshot_configuration_parameter>
        <name>snap-max-hard-limit</name>
            <value>{value}</value>
        </volume_snapshot_configuration_parameter>
        <volume_snapshot_configuration_parameter>
        <name>snap-max-soft-limit</name>
            <value>{value}</value>
        </volume_snapshot_configuration_parameter>
        <volume_snapshot_configuration_parameter>
        <name>auto-delete</name>
            <value>{value}</value>
        </volume_snapshot_configuration_parameter>
    </volume_snapshot_configuration_parameters>
    </cluster>
```

### Actions Supported

*   `/ap/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots|rel=add` - creates and adds a new snapshot for the given volume
    -   Parameters
        -   name - String
        -   [description] - string
        -   [force] - boolean
        -   [scheduling_det] - details of scheduling if snapshots to be scheduled

Input:

```xml
    <action>
        <volume_snapshot>
            <name>{name}</name>
            <description>{description}</description>
                    <force>{true/false}</force>
        </volume_snapshot>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots/{volume-snapshot-id}|rel=delete` - deletes snapshot

<!-- -->

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots/{volume-snapshot-id}/restore|rel=restore` - restores the given volume to the given snapshot

<!-- -->

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots/{volume-snapshot-id}/activate|rel=activate` - activates the given volume snapshot

<!-- -->

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/volumesnapshots/{volume-snapshot-id}/deactivate|rel=deactivate` - deactivates the given volume snapshot

<!-- -->

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/rel=post` - to schedule snapshot creation for a volume use the below POST request on volume

Input:

```xml
    <action>
        <gluster_volume>
            .
            .
            <volume_snapshot_schedule>
                <cron_expression>{cron expression of the schedule}</cron_expression>
            </volume_snapshot_schedule>
        <gluster_volume>
    </action>
```

*   `/api/clusters/{cluster-id}/rel=post` - to set snapshot configuration parameters value for the given cluster use the below POST request on cluster
    -   Parameters
        -   name-value pair of configuration parameters
        -   [force]

Input:

```xml
    <action>
        <cluster>
            .
            .
            <volume_snapshot_configuration_parameters>
                <volume_snapshot_configuration_parameter>
                <name>{name-1}</name>
                <value>{value-1}</value>
                </volume_snapshot_configuration_parameter>
                <volume_snapshot_configuration_parameter>
                   <name>{name-2}</name>
               <value>{value-2}</value>
                </volume_snapshot_configuration_parameter>
            </volume_snapshot_configuration_parameters>
        </cluster>
        <force>true/false</force>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/rel=post` - to set snapshot configuration parameters for the given volume use the below POST request on volume
    -   Parameters
        -   name-value pair of configuration parameters
        -   [force]

Input:

```xml
    <action>
        <gluster_volume>
            .
            .
            <volume_snapshot_configuration_parameters>
                <volume_snapshot_configuration_parameter>
                    <name>{name-1}</name>
                    <value>{value-1}</value>
                </volume_snapshot_configuration_parameter>
                <volume_snapshot_configuration_parameter>
                <name>{name-2}</name>
                <value>{value-2}</value>
                </volume_snapshot_configuration_parameter>
            </volume_snapshot_configuration_parameters>
        </gluster_volume>
        <force>true/false</force>
    </action>
```
