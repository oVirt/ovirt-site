---
title: GlusterHostDiskManagement
authors: rnahcimu
wiki_title: Features/Design/GlusterHostDiskManagement
wiki_revision_count: 34
wiki_last_updated: 2014-12-22
feature_name: Gluster Host Disk Management
feature_modules: Engine
feature_status: Inception
---

# Gluster Host Disk Management

# Summary

Disk Management feature was the long time awaited feature for Gluster in Ovirt. This helps the admin to provision the storage directly from Ovirt Web admin portal instead of going to the node and do all the stuffs manually. This feature enables to configure disk and storage devices in host. On Gluster cluster, this helps to identify bricks. The configuration includes

1.  identify disk and storage devices those are not having file system.
2.  create new brick by creating new Linux logical volume or expand existing brick by exapnding Linux logical volume used for the brick with those devices.
3.  format the logical volume with xfs or selected file system if necessary.
4.  update fstab entry for the logical volume.
5.  mount the logical volume.

This document describes the design of Disk Management feature for Gluster in Ovirt.

# Owner

*   Feature owner: Balamurugan Arumugam <rnacihmu@redhat.com>
*   Engine Component Owner: Ramesh Nachimuthu <rnachimu@redhat.com>
*   VDSM Owner: Timothy Asir <tjeyasin@redhat.com>

# Current Status

*   Status: Inception
*   Last updated date: Fri December 12th 2014

# Design

### New Entities

#### StorageDevice

This entity helps to store the details of a storage device in the host. A host will nave multiple instance of this storage device to represent the storage devices in the host.

| Column name | Type    | Description                                      |
|-------------|---------|--------------------------------------------------|
| name        | String  | Name of the device                               |
| model       | String  | Description about the device                     |
| devpath     | String  | Device Path                                      |
| mountPoint  | String  | Mount Point                                      |
| devuuid     | String  | Dev UUID (Primary Key).                          |
| fsType      | String  | File system type                                 |
| uuid        | String  | UUID for the file system in the device.          |
| isFree      | boolean | Is device is already used or its free for usage. |

### Sync Job

Information about the storage devices in the host will be fetched periodically and stored in the DB by a sync job. This sync job will run for once in 24 hours. There will be an option in the UI to force sync the storage device details.

### BLL commands

*   <big>CreateBrick</big> - creates a logical volume with the given set of storage devices and format it with XFS file system and mounts the LV at a pre configured path.
*   <big>ExtendBrick</big> - Add the selected block devices to the given LV to increase the storage space available in the LV.

### Engine Queries

*   <big>GetStorageDevices</big> - lists all the Storage Devices available in the Host
*   <big>HostGetUnusedBricksQuery</big> - lists all the Unused LVs in the Host.

### VDSM Verbs

#### VDSM verbs for Disk Provisioning

*   <big>GlusterStorageDevicesList</big> - Returns all the storage devices in the host

<TODO: explain verb's parameters and return structure>

*   <big>GlusterBrickCreate</big> - Create an LV which can be to create gluster volume

<TODO: explain verb's parameters and return structure>

*   <big>GlusterBrickExpand</big> - Expand the given LV by adding the selected disk

<TODO: explain verb's parameters and return structure>

### REST APIs

The details of the REST APIs for Disk Provisioning feature are as below -

#### storagedevices sub-collection of the host resource

*   A collection of storage devices that are attached to a specific host:

        /api/hosts/{host:id}/storagedevices|

*   Supported actions:
    1.  **GET** returns a list of storage devices attached to the host
