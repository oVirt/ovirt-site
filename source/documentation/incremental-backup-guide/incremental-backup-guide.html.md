---
title: Incremental Backup
category: feature
authors: nsoffer, derez, sgoodman
feature_name: Incremental Backup
feature_modules: imageio,engine,vdsm
feature_status: Implementation
---

# Incremental Backup

Previously, to back up a virtual machine’s disk, you needed to:

1. Create a temporary snapshot.
1. Copy the snapshot file in its current format, either RAW guest data or QCOW2 file data.
1. Delete the temporary snapshot.

It was possible to do a limited version of an incremental backup by creating one snapshot every time a backup ran, copying the snapshot disk, and deleting the previous snapshot. But the copied data was in QCOW2 format, so restoring it required merging QCOW2 files before uploading to storage.

Now, using the Incremental Backup API, you can:

* Perform full or incremental backups for disks using QCOW2 format without any temporary snapshots
* Backup raw guest data instead copying QCOW2 data for QCOW2 disks
* Restore raw guest data to disk onto raw or QCOW2 disks

Backups are simpler, faster and more robust, and integration with backup applications is improved, with new support for backing up and restoring raw guest data, regardless of the underlying disk format.

## Limitations

* Only disks in QCOW2 format can be backed up incrementally, not RAW format disks. The backup process saves the backed up data in RAW format.
* Only backed up data in RAW format can be restored.
* Incremental restore does not support restoring snapshots as they existed at the time of the backup. This limit is common in backup solutions for other systems.


## Creating a Virtual Machine With Incremental Backup Enabled

For a backup application to be able to include a disk during incremental backups, you must enable incremental backup for that disk. When adding a disk, you should enable incremental backup for every disk. You can back up disks that are not enabled for incremental backup in the same way you did previously.

Because incremental backup requires disks to be formatted in QCOW2, use QCOW2 format instead of RAW format. For more information, see [Disk Format](#disk-format).

## Enabling Incremental Backup on an Existing Virtual Machine

Because incremental backup is not supported for disks in RAW format, a QCOW2 format layer must exist on top of any RAW format disks in order to use incremental backup. Creating a snapshot generates a QCOW2 layer, so creating a snapshot enables incremental backup on all disks that are included in the snapshot, from the point at which the snapshot is created.

**WARNING**
If the base layer of a disk uses RAW format, deleting the last snapshot and merging the top QCOW2 layer into the base layer converts the disk to RAW format, thereby disabling incremental backup. To re-enable incremental backup, you can create a new snapshot, including this disk.

## Disk Format

The following table shows how enabling incremental backup affects disk format:

| foo | bar |
| --- | --- |
| baz | bim |
| Storage | Provisioning | Incremental | Format |
| --- | --- | --- | --- |
| block | thin | enabled | qcow2 |
| block | preallocated | enabled | qcow2 (preallocated) |
| file | thin | enabled | qcow2 |
| file | preallocated | enabled | qcow2 (preallocated) |
| block | thin | disabled | qcow2 |
| block | preallocated | disabled | raw (preallocated) |
| file | thin | disabled | raw (sparse) |
| file | preallocated | disabled | raw (preallocated) |
| network | Not applicable | disabled | raw |
| lun | Not applicable | disabled | raw |

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
