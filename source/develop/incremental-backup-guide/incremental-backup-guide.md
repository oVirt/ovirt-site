---
title: Incremental Backup
category: documentation
toc: true
---

# Incremental Backup

Previously, to back up a virtual machine’s disk, you needed to:

1. Create a temporary snapshot.
1. Copy the snapshot file in its current format, either RAW guest data or QCOW2 file data.
1. Delete the temporary snapshot.

It was possible to do a limited version of an incremental backup by creating one snapshot every time a backup ran, copying the snapshot disk, and deleting the previous snapshot. But the copied data was in QCOW2 format, so restoring it required merging QCOW2 files before uploading to storage.

## High level Design

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

For a backup application to be able to include a disk during incremental backups, you must enable incremental backup for that disk. When adding a disk, you should enable incremental backup for every disk. You can back up disks that are not enabled for incremental backup using full backup or in the same way you did previously.

Because incremental backup requires disks to be formatted in QCOW2, use QCOW2 format instead of RAW format. For more information, see [Disk Format](#disk-format).

## Enabling Incremental Backup on an Existing Virtual Machine

Because incremental backup is not supported for disks in RAW format, a QCOW2 format layer must exist on top of any RAW format disks in order to use incremental backup. Creating a snapshot generates a QCOW2 layer, so creating a snapshot will allow to enable incremental backup on all disks that are included in the snapshot, from the point at which the snapshot is created.

**WARNING**
If the base layer of a disk uses RAW format, deleting the last snapshot and merging the top QCOW2 layer into the base layer converts the disk to RAW format, thereby disabling incremental backup if it was set. To re-enable incremental backup, you can create a new snapshot, including this disk.

## Disk Format

The following table shows how enabling incremental backup affects disk format:

| Storage | Provisioning | Incremental | Format |
| :--- | :--- | :--- | :--- |
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

## The Incremental Backup Flow

1. The backup application uses the REST API to find virtual machine disks that should be included in the backup. Only disks that are enabled for incremental backup, using QCOW2 format, are included.
2. The backup application starts a backup using the [VmBackup API]: http://ovirt.github.io/ovirt-engine-api-model/4.3/#services/vm_backup "VmBackup API", specifying a virtual machine ID, an optional previous checkpoint ID, and a list of disks to back up. If you don't specify a previous checkpoint ID, all data in the specified disks is included in the backup, based on the state of each disk when the backup begins (full backup).
3. The engine prepares the virtual machine for backup. The virtual machine can continue running during the backup.
4. The backup application polls the engine for the backup status, until the engine reports that the backup is ready to begin.
5. When the backup is ready to begin, the backup application creates an image transfer for every disk included in the backup. For more information, see the [ImageTransfer API]: http://ovirt.github.io/ovirt-engine-api-model/4.3/#services/image_transfer "ImageTransfer API".
6. The backup application gets a list of changed blocks from ovirt-imageio for every image transfer. If a change list is not available, the backup application gets an error.
7. The backup application downloads changed blocks in RAW format from ovirt-imageio and stores them in the backup media. If a list of changed blocks is not available, the backup application can fall back to copying the entire disk.
8. The backup application finalizes all image transfers.
9. The backup application finalizes the backup using the REST API.

## The Incremental Restore Flow

1. The user selects a restore point based on available backups using the backup application (not part of oVirt).
2. The backup application creates a new disk or a snapshot with an existing disk to hold the restored data.
3. The backup application starts an upload image transfer for every disk, specifying `format=raw`. This enables format conversion when uploading RAW data to a QCOW2 disk.
4. The backup application transfers the data included in this restore point to imageio using the API.
5. The backup application finalizes the image transfers.

### Checkpoint deletion

1. Backup application finds the oldest checkpoint of a VM.

2. Backup application remove the checkpoint

### Restoring snapshots

Incremental restore will not support restoring snapshots as existed at
the time of the backup. This limit is common in backup solutions for
other systems.

### Handling an Unclean Shutdown or Storage Outage During Shutdown

If a virtual machine is shut down abnormally, bitmaps on the disk might be left in an invalid state. Creating an incremental backup using such bitmaps leads to corrupt virtual machine data after a restore.
To detect bitmap in invalid state we can use the in-use bit in the
bitmap, but this info is not exposed to the management layer.

To recover from an invalid bitmap, you need to delete the invalid bitmap and all previous bitmaps, and the next backup needs to include the entire disk contents (full backup).

## Backup REST API

### enable POST
_Enable incremental backup for a virtual machine’s disk._

For example, to enable incremental backup for a new disk on a virtual machine with id `123`, send a request like this:

```javascript
PUT /vms/123/diskattachments
```

With a request body like this:

```xml
<disk_attachment>
    ...
    <disk>
        ...
        <backup>incremental|none</backup>
        ...
    </disk>
</disk_attachment>
```

The response is:

```xml
<disk_attachment>
    ...
    <disk href="/ovirt-engine/api/disks/456" id="456"/>
    ...
</disk_attachment>
```
*Parameters Summary*

| Name	| Type	| Direction |	Summary |
| :---- |  :---- |  :---- |  :---- |
|`backup`| ? | out | Required. Possible values: `incremental`, `none` |



#### Finding disks enabled for incremental backup

## list GET
For the specified virtual machine, list the disks that are enabled for incremental backup, filtered according to the `backup` property.

For example, for a virtual machine with the id `123`, this request:

```javascript
GET /vms/123/diskattachments
```

Gets this response:

```xml
<disk_attachments>
  <disk_attachment>
        ...
        <disk href="/ovirt-engine/api/disks/456" id="456"/>
        ...
  </disk_attachment>
  ...
</disk_attachments>
```

*Parameters summary:*

| Name	| Type	| Direction |	Summary |
| :---- |  :---- |  :---- |  :---- |
| `backup`| ? | out | Required. Possible values: `incremental`, `none` |

### Start a full backup POST
Start full backup. The response phase indicates that the backup is `“initializing”`. You need to poll the backup until the phase is `“ready”`. Once the backup is ready the response will include `<to_checkpoint_id>` which should be used as the `<from_checkpoint_id>` in the next incremental backup.

For example, to start a full backup of a disk with id 456 on a virtual machine with id 123, send a request like this:

```javascript
POST /vms/123/backups
```

With a request body like this:

```xml
<backup>
    <disks>
        <disk id="456" />
        ...
    </disks>
</backup>
```

The response includes backup 789 with `<to_checkpoint_id>` 999:

```xml
<backup id="789">
    <disks>
        <disk id="456" />
        ...
        ...
    </disks>
    <phase>initializing</phase>
    <creation_date>
</backup>
```

*Parameters summary:*

| Name	| Type	| Direction |	Summary |
| :---- | :---- |  :---- |  :---- |
| `disk`| ? | out | Required. Specify the UUID of a disk. |


### Start an incremental backup POST
Start incremental backup since checkpoint id `<from_checkpoint_uuid>`. The response phase indicates that the backup is `“initializing”`. You need to poll the backup until the phase is `“ready”`. Once the backup is ready the response will include `<to_checkpoint_id>` which should be used as the `<from_checkpoint_id>` in the next incremental backup.

For example, to start an incremental backup of disk `222` on virtual machine `111`, send a request like this:

```javascript
POST /vms/111/backups
```

With a request body like this:

```xml
<backup>
    <from_checkpoint_id>333</from_checkpoint_id>
    <disks>
        <disk id="222" />
        ...
    </disks>
</backup>
```

The response includes backup `789` with `<from_checkpoint_id>` `999` and  `<to_checkpoint_id>` `666`:

```xml
<backup id="777">
    <from_checkpoint_id>999</from_checkpoint_id>
    <disks>
        <disk id="222" />
        ...
        ...
    </disks>
    <phase>initializing</phase>
    <creation_date>
</backup>
```

### Get backup info GET

*Gets information about a backup.*

Gets the following information about a specific backup:

* the id of each disk that was backed up
* the ids of the start and end checkpoints of the backup
* the id of the disk image of the backup, for each disk included in the backup
* the phase of the backup
* the date the backup was created

When the value of `<phase>` is `ready`,  the response will include `<to_checkpoint_id>` which should be used as the `<from_checkpoint_id>` in the next incremental backup and you can start downloading the disks to back up the virtual machine storage.

For example, to get info about a backup with id `456` of a virtual machine with id `123`, send a request like this:

```javascript
GET /vms/456/backups/123
```

The response includes the backup with id `456`, with `<from_checkpoint_id>` `999` and  `<to_checkpoint_id>` `666`. The disk included in the backup has id `444`, and the id of the disk image is `555`.

```xml
<vm_backup id="456">
    <from_checkpoint_id>999</from_checkpoint_id>
    <to_checkpoint_id>666</to_checkpoint_id>
    <disks>
        <disk id="444">
            <image_id>555</image_id>
        </disk>
        ...
    </disks>
    <phase>ready</phase>
    <creation_date>
</vm_backup>
```

### finalizing backup POST
To finalize a backup, use the finalize backup service method.

For example, to finalize backup with id `456` of a virtual machine with id `123`, send a request like this:

```javascript
POST /vms/123/backups/456/finalize

<action></action>
```


### Creating an image transfer object for downloading an incremental backup POST
When the backup is ready to download, an *imagetransfer* object should be created.
To correlate the transfer with the backup, `<backup>` property should be specified with the relevant backup id.
The transfer `<format>` property should be `raw` (this indicates that NBD is used as the ImageTransfer backend).
For information on creating an *imagetransfer* object, see the [`add` method for `ImageTransfers`]:http://ovirt.github.io/ovirt-engine-api-model/4.3/#services/image_transfers/methods/add "add method" in the REST API Guide.

For example, to initiate transfer for an incremental backup send a request like this:

```javascript
POST /imagetransfers
```
With a request body like this:

```xml
<image_transfer>
    <disk id="123"/>
    <backup id="456"/>
    <direction>download</direction>
    <format>raw</format>
</image_transfer>
```


### Creating an image transfer object for incremental restore POST
In order to restore raw data backed up using the incremental backup API to a QCOW2-formatted disk, an *imagetransfer* object should be created. To restore an incremental backup, specify the `<format>` key in the transfer. For information on creating an *imagetransfer* object, see the [`add` method for `ImageTransfers`]:http://ovirt.github.io/ovirt-engine-api-model/4.3/#services/image_transfers/methods/add "add method" in the REST API Guide.

For example, to initiate restoring an incremental backup send a request like this:

```javascript
POST /imagetransfers
```
With a request body like this:

```xml
<image_transfer>
    <disk id="123"/>
    <direction>upload</direction>
    <format>raw</format>
</image_transfer>
```
When uploading into a snapshot, replace `<disk id="123"/>` with `<snapshot id="456"/>`.

When the transfer format is RAW and the underlying disk format is QCOW2, uploaded data is converted on the fly to QCOW2 format when writing to storage.
Uploading data from a QCOW2 disk to a RAW disk is not supported.

### Checkpoints REST API

#### Get all created checkpoints for a VM GET

To get all the created checkpoints of a VM :

For example, to get all the created checkpoints of a virtual machine with id `123` send a request like this:

```javascript
GET /vms/123/checkpoints/
```

The response includes all the virtual machine checkpoints, each checkpoint contains the checkpoint's `disks`, `<parent_id>`, `<creation_date>` and the virtual machine it belongs to `<vm>`:

```xml
<checkpoints>
   <checkpoint id="456">
      <link href="/ovirt-engine/api/vms/vm-uuid/checkpoints/456/disks" rel="disks"/>
      <parent_id>parent-checkpoint-uuid</parent_id>
      <creation_date>xxx</creation_date>
      <vm href="/ovirt-engine/api/vms/123" id="123"/>
   </checkpoint>
</checkpoints>
```

#### Get a specific VM checkpoint GET

For example, to get a specific checkpoint with id `456` of a virtual machine with id `123` send a request like this:

```javascript
GET /vms/123/checkpoints/456/
```

Response:

```xml
<checkpoint id="456">
  <link href="/ovirt-engine/api/vms/v123/checkpoints/456/disks" rel="disks"/>
  <parent_id>parent-checkpoint-uuid</parent_id>
  <creation_date>xxx</creation_date>
  <vm href="/ovirt-engine/api/vms/123" id="123"/>
</checkpoint>
```

#### Remove the root checkpoint of a specific virtual machine DELETE

To remove a checkpoint of a virtual machine, the removed checkpoint should be the oldest checkpoint of the VM (root checkpoint).

For example, to remove the root checkpoint with id `456` of a virtual machine with id `123` send a request like this::

```javascript
DELETE /vms/123/checkpoints/456/
```

## imageio backup API

### Map request

Get a map of zeros and data ranges on storage.

Query options:
- `dirty=y` - return only ranges modified since backup checkpoint id

Returns list of JSON objects with these keys:
- `data`: true for allocated ranges, false for zero or unallocated ranges
- `start`: offset of range in bytes
- `length`: number of bytes

### Example - getting data and zero ranges

Request:
```javascript
GET /images/ticket-uuid/map
```

Response:
```json
[
    {"data": true, "start": 0, "length": 1048576},
    {"data": false, "start": 1048576, "length": 8192},
    {"data": true, "start": 1056768, "length": 1048576},
]
```

#### Example - getting only dirty data and zero ranges

Request:
```javascript
GET /images/ticket-uuid/map?dirty=y
```

Response:
```json
[
    {"data": true, "start": 0, "length": 1048576},
    {"data": false, "start": 1048576, "length": 8192},
]
```
