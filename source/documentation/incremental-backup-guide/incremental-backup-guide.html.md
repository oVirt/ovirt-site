---
title: Incremental Backup
category: documentation
layout: toc
---

# Incremental Backup


## Summary

This feature simplifies, speeds up, and improve robustness by backing up
only changed blocks, and avoiding temporary snapshots. Integration with
backup applications is improved by supporting backup and restore of raw
guest data regardless of the underlying disk format.

## High level Design

### What was available before this feature?

Before this feature, backing up a disk required creating a temporary
snapshot copying the snapshot file as is (either raw guest data or qcow2
file data), and deleting the temporary snapshot.

It was possible to do a limited version of incremental backup, by
creating one snapshot on every backup, copying the snapshot disk,
and deleting the previous snapshot. But the copied data was in qcow2
format, so restoring it require merging qcow2 files before uploading
to storage.

### Capabilities added with this feature

- Perform full or incremental backup for disks using qcow2 format
  without temporary snapshots.

- Backup raw guest data instead copying qcow2 data for qcow2 disks.

- Restore raw guest data into disk into raw or qcow2 disks.

### Creating VM

When adding a disk, the user should enable incremental backup for every
disk. If incremental backup is enabled for a disk, a backup application
can include the disk during incremental backups.

Since incremental backup requires qcow2 format, disks enabled for
incremental backup will use qcow2 format instead of raw format. See
[Disk Format](#disk-format) for more info.

Disks not marked for incremental backup can be backed in the same way
they were backed in the past.

### Enabling existing VM for incremental backup

Since raw disks are not supported, a user needs to create a snapshot
including the disks to enabled incremental backup for the disks. This
creates a qcow2 layer on top of the raw disk, that can be used to
perform incremental backups from this point.

### Deleting snapshots on existing VMs

If the base layer of a disk is using raw format, deleting the last
snapshot, merging the top qcow2 layer into the base layer will convert
the disk to raw, and disable incremental backup (should probably display
a warning first). The user can create a new snapshot including this
disk to re-enable back incremental backup.

### Disk format

Here is a table showing how enabling incremental backup affects disk
format.

```
storage     provisioning        incremental     format
====================================================================
block       thin                enabled         qcow2
block       preallocated        enabled         qcow2 (preallocated)
file        thin                enabled         qcow2
file        preallocated        enabled         qcow2 (preallocated)
--------------------------------------------------------------------
block       thin                disabled        qcow2
block       preallocated        disabled        raw (preallocated)
file        thin                disabled        raw (sparse)
file        preallocated        disabled        raw (preallocated)
--------------------------------------------------------------------
network     -                   disabled        raw
lun         -                   disabled        raw
```

### Incremental backup flow

1. Backup application finds VM disks that should be included in the
   backup using oVirt API. Currently only disks marked for incremental
   backup (using qcow2 format) can be included.

1. Backup application starts backup using oVirt API, specifying a VM id,
   optional previous backup id, and list of disks to backup.
   If previous backup uuid isn't specified, all data in the specified disks,
   at the point of the backup, will be included in the backup.

1. System prepares VM for backup. The VM may be running during the
   backup.

1. Backup application waits until backup is ready using oVirt SDK.

1. When backup is ready backup application creates image transfer for
   every disk included in the backup.

1. Backup application obtains changed blocks list from ovirt-imageio for
   every image transfer. If change list is not available, the backup
   application will get an error.

1. Backup application downloads changed blocks in raw format from
   ovirt-imageio and store them in the backup media. If changed blocks
   list is not available, backup application can fall back to copying
   the entire disk.

1. Backup application finalizes image transfers.

1. Backup application finalizes backup using oVirt API.

### Incremental restore flow

1. User selects restore point based on available backups using the
   backup application (not part of oVirt).

1. Backup application creates a new disk or a snapshot with existing disk
   to hold the restored data.

1. Backup application starts an upload image transfer for every disk,
   specifying format=raw. This enable format conversion when uploading
   raw data to qcow2 disk.

1. Backup application transfer the data included in this restore point
   to imageio using HTTP API.

1. Backup application finalize the image transfers.

### Restoring snapshots

Incremental restore will not support restoring snapshots as existed at
the time of the backup. This limit is common in backup solutions for
other systems.

### Handling unclean shutdown or storage outage during shutdown

If a VM is shut down abnormally, bitmaps on the disk may be left in
invalid state. Creating incremental backup using such bitmaps will
lead to corrupt guest data after restore.

To detect bitmap in invalid state we can use the in-use bit in the
bitmap, but this info is not exposed to the management layer.

To recover from invalid bitmaps, the invalid bitmap and all previous
bitmaps must be deleted. The next backup will have to include the entire
disk contents.

### Backup REST API

#### Enabling backup for VM disk

Specify 'backup' property on ```disk``` entity: 'incremental'/'none' (TBD: 'full')

Request:
```
POST /vms/vm-uuid/disks

<disk>
    ...
    <backup>incremental|none</backup>
    ...
</disk>
```

Response:
```
<disk>
    ...
    <backup>incremental|none</backup>
    ...
</disk>
```

#### Finding disks enabled for incremental backup

For each VM, get ```disks``` list and filter according to
'backup' property.

Request:
```
GET /vms/vm-uuid/disks
```

Response:
```
<disks>
    <disk>
        ...
        <backup>incremental|none</backup>
        ...
    </disk>
    ...
</disks>
```

#### Starting full backup

Start full backup. The response includes 'to_checkpoint_id' which
is created on the disks. It can be used in the next incremental backup.

Request:
```
POST /vms/vm-uuid/backups

<backup>
    <disks>
        <disk id="disk-uuid" />
        ...
    </disks>
</backup>
```

Response:
```
<backup id="backup-uuid">
    <to_checkpoint_id>new-checkpoind-uuid</to_checkpoint_id>
    <disks>
        <disk id="disk-uuid" />
        ...
        ...
    </disks>
    <phase>initiailizing</phase>
    <creation_date>
</backup>
```

#### Starting incremental backup

Start incremental backup since checkpoint id "previous-checkpoint-uuid".
The response include 'to_checkpoint_id' which should be used as the
'from_checkpoint_id' in the next incremental backup.

Request:
```
POST /vms/vm-uuid/backups

<backup>
    <from_checkpoint_id>previous-checkpoint-uuid</from_checkpoint_id>
    <disks>
        <disk id="disk-uuid" />
        ...
    </disks>
</backup>
```

Response:
```
<backup id="backup-uuid">
    <from_checkpoint_id>previous-checkpoint-uuid</from_checkpoint_id>
    <to_checkpoint_id>new-checkpoind-uuid</to_checkpoint_id>
    <disks>
        <disk id="disk-uuid" />
        ...
        ...
    </disks>
    <phase>initiailizing</phase>
    <creation_date>
</backup>
```

#### Getting backup info

When backup phase is "ready", you can start downloading the disks.

Request:
```
GET /vms/vm-uuid/backups/backup-uuid
```

Response:
```
<vm_backup id="backup-uuid">
    <from_checkpoint_id>previous-checkpoint-uuid</from_checkpoint_id>
    <to_checkpoint_id>new-checkpoind-uuid</to_checkpoint_id>
    <disks>
        <disk id="disk-uuid">
            <image_id>image-uuid</image_id>
        </disk>
        ...
    </disks>
    <phase>ready</phase>
    <creation_date>...
</vm_backup>
```

#### Finalizing backup

```
POST /vms/vm-uuid/backups/backup-uuid/finalize

<action></action>
```

#### Creating image transfer for incremental restore

To restore raw data backed up using the incremental backup API to qcow2
disk, you need to specify the "format" key in the transfer:

```
POST /imagetransfers

<image_transfer>
    <disk id="123"/>
    <direction>upload</direction>
    <format>raw</format>
</image_transfer>
```

When uploading into a snapshot, replace ```<disk id="123"/>``` with
```<snapshot id="456"/>```.

When the transfer format is "raw" and underlying disk format is "qcow2"
uploaded data will be converted on the fly to qcow2 format when writing
to storage.

Uploading "qcow2" data to "raw" disk is not supported.


### imageio backup API

#### Map request

Get map of zeros and data ranges on storage.

Query options:
- dirty=y - return only ranges modified since backup checkpoint id

Returns list of JSON objects with these keys:
- data: true for allocated ranges, false for zero or unallocated ranges
- start: offset of range in bytes
- length: number of bytes

##### Example - getting data and zero ranges

Request:
```
GET /images/ticket-uuid/map
```

Response:
```
[
    {"data": true, "start": 0, "length": 1048576},
    {"data": false, "start": 1048576, "length": 8192},
    {"data": true, "start": 1056768, "length": 1048576},
]
```

##### Example - getting only dirty data and zero ranges

Request:
```
GET /images/ticket-uuid/map?dirty=y
```

Response:
```
[
    {"data": true, "start": 0, "length": 1048576},
    {"data": false, "start": 1048576, "length": 8192},
]
```
