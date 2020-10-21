---
title: Incremental Backup
category: feature
authors: nsoffer, derez, eshenitz
feature_name: Incremental Backup
feature_modules: imageio,engine,vdsm
feature_status: Design
---

# Incremental Backup


## Summary

This feature simplifies, speeds up, and improve robustness by backing up
only changed blocks, and avoiding temporary snapshots. Integration with
backup applications is improved by supporting backup and restore of raw
guest data regardless of the underlying disk format.

## Owner

- Nir Soffer (<nsoffer@redhat.com>)
- Daniel Erez (<derez@redhat.com>)
- Eyal Shenitzky (<eshenitz@redhat.com>)


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

- Perform full backup for raw or qcow2 disks or incremental backup for disks 
  using qcow2 format without temporary snapshots.

- Backup raw guest data instead copying qcow2 data for qcow2 disks.

- Restore raw guest data into disk into raw or qcow2 disks.

### Creating VM

When adding a disk, the user should mark 'enable incremental backup' for every
disk that should be included in an incremental backup. If incremental backup is 
enabled for a disk, a backup application can include the disk during incremental
backups.

Since incremental backup requires qcow2 format, disks enabled for
incremental backup will use qcow2 format instead of raw format. See
[Disk Format](#disk-format) for more info.

Disks not marked for incremental backup can be backed using full backup or in the 
same way they were backed in the past.

### Enabling existing VM for incremental backup

Since raw disks are not supported for incremental backup, a user needs
to create a snapshot including the disks to enabled incremental backup
for the disks. This creates a qcow2 layer on top of the raw disk, that
can be used to perform incremental backups from this point.

### Deleting snapshots on existing VMs

If the base layer of a disk is using raw format, deleting the last
snapshot, merging the top qcow2 layer into the base layer will convert
the disk to raw, and disable incremental backup (should probably display
a warning first). The user can create a new snapshot including this
disk to re-enable back incremental backup.

### Disk format

Here is a table showing how enabling incremental backup affects disk
format when creating a new disk.

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
   backup (using qcow2 format) can be included in an incremental backup.

2. Backup application starts backup using oVirt API, specifying a VM id,
   optional previous checkpoint id, and list of disks to backup.
   If previous checkpoint uuid isn't specified, all data in the specified disks,
   at the point of the backup, will be included in the backup (full backup).

3. System prepares VM for backup. The VM may be running during the
   backup.

4. Backup application waits until backup is ready using oVirt SDK.

5. When backup is ready backup application creates image transfer for
   every disk included in the backup.

6. Backup application obtains changed blocks list from ovirt-imageio for
   every image transfer. If change list is not available, the backup
   application will get an error.

7. Backup application downloads changed blocks in raw format from
   ovirt-imageio and store them in the backup media. If changed blocks
   list is not available, backup application can fall back to copying
   the entire disk.

8. Backup application finalizes image transfers.

9. Backup application finalizes backup using oVirt API.

### Incremental restore flow

1. User selects restore point based on available backups using the
   backup application (not part of oVirt).

2. Backup application creates a new disk or a snapshot with existing disk
   to hold the restored data.

3. Backup application starts an upload image transfer for every disk,
   specifying format=raw. This enable format conversion when uploading
   raw data to qcow2 disk.

4. Backup application transfer the data included in this restore point
   to imageio using HTTP API.

5. Backup application finalize the image transfers.

### Checkpoint deletion

1. Backup application finds the oldest checkpoint of a VM.

2. Backup application remove the checkpoint

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
disk contents (full backup).

### Backup REST API

#### Enabling backup for VM disk

Specify 'backup' property on ```disk``` entity: 'incremental'/'none' (TBD: 'full')

Request:
```
PUT /vms/vm-uuid/diskattachments
```

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

Response:
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

#### Finding disks enabled for incremental backup

For each VM, get ```disks``` list and filter according to
'backup' property.

Request:
```
GET /vms/vm-uuid/diskattachments
```

Response:
```xml
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

Start a full backup.
The response will include the following fields:
- phase: the current phase of the backup.
- disks: link to the disks that participate in the backup.
         Each disk will contain a field called `backup_mode` that will indicate on
         the type of backup that was taken for the disk.
- creation_date: the date when the backup was created.
- to_checkpoint_id: the ID of the checkpoint that was created during the backup.

If the phase indicates that the backup is `"initializing"`,
you need to poll the backup until the phase is `"ready"`.
Once the backup is ready the response will include `<to_checkpoint_id>` which
should be used as the `<from_checkpoint_id>` in the next incremental backup.
When starting a full backup, the `backup_mode` for all the disks will be `full` (`backup_mode="full"`)

Request:
```
POST /vms/vm-uuid/backups
```

```xml
<backup>
    <disks>
        <disk id="disk-uuid" />
        ...
    </disks>
</backup>
```

Response:
```xml
<backup id="backup-uuid">
    <link href="/ovirt-engine/api/vms/vm-uuid/backups/backup-uuid/disks" rel="disks"/>
    <phase>initiailizing</phase>
    <creation_date>
</backup>
```

#### Starting incremental backup

Start incremental backup since checkpoint id `<from_checkpoint_uuid>`.
The response phase indicates that the backup is `"initializing"`.
You need to poll the backup until the phase is `"ready"`. 
Once the backup is ready the response will include `<to_checkpoint_id>` which
should be used as the `<from_checkpoint_id>` in the next incremental backup.

In case of starting an incremental backup which includes disks that weren't part
of the given `<from_checkpoint_uuid>`, or new disks that were attached
to the VM after the given `<from_checkpoint_uuid>` was taken, the system will detect
those disks and a full backup will be taken for them (`backup_mode="full"`).
The `backup_mode` for the rest of the the disks will be `incremental` (`backup_mode="incremental"`).

Request:
```
POST /vms/vm-uuid/backups
```

```xml
<backup>
    <from_checkpoint_id>previous-checkpoint-ucouid</from_checkpoint_id>
    <disks>
        <disk id="disk-uuid" />
        ...
    </disks>
</backup>
```

Response:
```xml
<backup id="backup-uuid">
    <from_checkpoint_id>previous-checkpoint-uuid</from_checkpoint_id>
    <link href="/ovirt-engine/api/vms/vm-uuid/backups/backup-uuid/disks" rel="disks"/>
    <phase>initiailizing</phase>
    <creation_date>
</backup>
```

#### Getting backup info

When backup phase is "ready", you can get the specific backup info.
The response will include `<to_checkpoint_id>` which should be used as the
`<from_checkpoint_id>` in the next incremental backup.
Now you can start downloading the disks.

Request:
```
GET /vms/vm-uuid/backups/backup-uuid
```

Response:
```xml
<vm_backup id="backup-uuid">
    <from_checkpoint_id>previous-checkpoint-uuid</from_checkpoint_id>
    <to_checkpoint_id>new-checkpoind-uuid</to_checkpoint_id>
    <disks>
        <disk id="disk-uuid" backup_mode="incremental">
            <image_id>image-uuid</image_id>
        </disk>
        ...
    </disks>
    <phase>ready</phase>
    <creation_date>
</vm_backup>
```

#### Finalizing backup

```
POST /vms/vm-uuid/backups/backup-uuid/finalize
```

```xml
<action></action>
```

### Creating an image transfer for downloading an incremental backup disk
When the backup is ready to download, an *imagetransfer* object should be created.
To correlate the transfer with the backup, `<backup>` property should be specified with the relevant backup id.
The transfer `<format>` property should be `raw` (this indicates that NBD is used as the ImageTransfer backend).

Request:

```
POST /imagetransfers
```

```xml
<image_transfer>
    <disk id="123"/>
    <backup id="456"/>
    <direction>download</direction>
    <format>raw</format>
</image_transfer>
```

#### Creating image transfer for incremental restore

To restore raw data backed up using the incremental backup API to qcow2
disk, you need to specify the "format" key in the transfer:

```
POST /imagetransfers
```
```xml
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

### Checkpoints REST API

#### Get all created checkpoints for a VM

To get all the created checkpoints of a VM :

Request:

```
GET /vms/vm-uuid/checkpoints/
```

Response:

```xml
<checkpoints>
   <checkpoint id="checkpoint-uuid">
      <link href="/ovirt-engine/api/vms/vm-uuid/checkpoints/checkpoint-uuid/disks" rel="disks"/>
      <parent_id>parent-checkpoint-uuid</parent_id>
      <creation_date>xxx</creation_date>
      <vm href="/ovirt-engine/api/vms/vm-uuid" id="vm-uuid"/>
   </checkpoint>
</checkpoints>
```

#### Get a specific VM checkpoint

To get a specific VM checkpoint:

Request:

```
GET /vms/vm-uuid/checkpoints/checkpoint-uuid/
```

Response:

```xml
<checkpoint id="checkpoint-uuid">
  <link href="/ovirt-engine/api/vms/vm-uuid/checkpoints/checkpoint-uuid/disks" rel="disks"/>
  <parent_id>parent-checkpoint-uuid</parent_id>
  <creation_date>xxx</creation_date>
  <vm href="/ovirt-engine/api/vms/vm-uuid" id="vm-uuid"/>
</checkpoint>
```

#### Remove the root checkpoint of a specific VM

To remove the root of the checkpoints chain a DELETE request should be used:

Request:

```
DELETE /vms/vm-uuid/checkpoints/checkpoint-uuid/
```

### imageio backup API

#### Disks backup_mode

Before downloading the data, the user must check if incremental
backup is available for a particular disk. If the system can provide
incremental backup data for a disk, the disk `backup_mode` will be
`incremetnal`. in this case the user can start an image transfer,
download the backup using dirty extents to preform incremental backup.

If the system cannot provide `incremetnal` backup data for a disk, the
disk backup_mode will be `full`. The user can start an image
transfer and download the backup using data and zero ranges to perform
`full` backup of this disk. The next backup for this disk can be incremental.

The system cannot provide incremental backup when:
- adding a new disk to a VM
- adding existing disk to a backup, which was not included in a
  previous backup specified by the `<from_checkpoint_uuid>`
- the system find that persistent dirty bitmaps are missing on
  storage

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


## Future Work

- Support incremental backup.
  Currently only full backup for raw and qcow2 disks is supported,
  to enable support for incremental backup (work in progress), 
  Engine config value 'IsIncrementalBackupSupported' must be set to 'true'.
  ```
  # engine-config -s "IsIncrementalBackupSupported=true"
  # systemctl restart ovirt-engine 
  ```
  
- API for listing and deleting checkpoints.

## Detailed design

### Validating checkpoints before backup

Before starting a backup, the available bitmaps on every disk must be
compared to the stored checkpoints on engine database. If a bitmap is
missing in the image, or unknown bitmap exist, all the checkpoints on
the disk and engine database must be deleted, and the current backup
must be a full backup.

### Setting the disks backup_mode before starting an incremental backup

Before starting an incremental backup, the system will validate that all
the disks that participate in the incremental backup already backed-up in
in the given checkpoint ID. For disks which are part of the given checkpoint ID
the backup mode will be `incremental`, if the disks are not part of the given
checkpoint, the backup mode will be `full`.
Also, if the Engine cannot synchronize the checkpoints with libvirt, all disks
will be marked as `backup_mode=full`.

### Incremental backup pipeline

When backing up incremental data, the user always reads raw guest data,
regardless of the underlying disk format.

qemu exposes the disks using internal NBD server, allowing reading from
every disk included in the incremental backup:

    http client (raw) <- imageio <- qemu <- image (raw or qcow2)

If the VM is not running, the system will create a paused, stripped-down
version of the VM, with only backup disks attached, and use libvirt API
to start and stop the backup.

We considered alternative solution using qemu-nbd, but According to Eric
Blake qemu-nbd does not support yet exposing bitmap info, so we would
not be able to provide the change block list.

Since creating special paused VM for backing up non-running VM is a lot
of work, we may defer support for backing up non-running VMs.

### Incremental restore pipeline

When restoring incremental data, the user always write raw guest data.
The system writes the data to storage using the underlying storage
format transparently.

The system will create qemu-nbd process for writing to  every disk:

    http client (raw) -> imageio -> qemu-nbd -> image (raw or qcow2)

### Preparing a VM for incremental backup

1. user starts backup using oVirt API. engine creates a backup in the
   database with "initializing" phase.

1. If the VM is not running, engine prepares a stripped down version of
   the VM, with only the backup disks attached, and create the VM on
   some host in paused mode.

1. engine configure and validate the checkpoints on the backup host
   using vdsm checkpoint API, which uses libvirt checkpoints API to
   update libvirt about the checkpoints stored in engine side, and
   validate that the image contain the same checkpoints.  This is
   required by libvirt backup API since checkpoint info is not stored in
   the qcow2 file.

1. If the VM is running, engine freeze the file systems on the guest for
   ensuring consistent backup. With help of qemu-guest-agent on the
   guest, pending I/O is flushed, and application make necessary changes
   to avoid inconsistent state.

1. engine begins the backup using vdsm backup API, which use libvirt
   backup API to begin the backup.

1. libvirt deactivates the active bitmap, and creates a new bitmap for
   tracking changes made after the backup was started.

1. libvirt uses qemu bitmap APIs to create a temporary bitmap for every
   disk, including the merged contents of all bitmaps included in this
   backup.

1. libvirt starts qemu internal NBD server, exposing the temporary
   bitmaps for every disk.

1. engine unfreezes the file systems on the guest. With help of
   qemu-guest-agent on the guest, applications are notified about the
   unfreeze, and I/O on the guest can continue normally now.  Any write
   at this point will be tracked by the new active bitmap, and will not
   be included in the incremental backup.

1. engine changes the backup phase to "ready". Once the user detects
   the change, the user can start transferring data.

### Finalizing backup

When backup succeeds, backup application copied all incremental data
successfully.

1. user ask to finalize the backup using oVirt API. engine change
   backup phase to "finalizing".

1. engine end the backup using vdsm backup API, which will use libvirt
   backup API to end the backup.

1. libvirt uses qemu API to delete the temporary bitmaps and end the
   backup job.

1. If running the special "backup" stripped down VM, tear down disks the
   VM disks using the existing storage APIs, and destroy the VM on the
   backup host.

### Checkpoints cleanup

Cleaning up checkpoints will be available later.

Checkpoints may be generated by multiple unrelated or partly related
users, deleting checkpoints cannot be done automatically by every user
after backup.

The checkpoints API allow the deletion of the oldest (root) checkpoint.

### Scratch disk

For now we'll use a scratch disk on the host (created by libvirt).
A scratch disk is created using qcow2 format for every disk in the 
backup. The disk must have enough space to hold the current data in
the top layer of an image.

#### Use case 1 - running 2 backup solutions in the same time

User is switching from backup solution A to B. During the transition,
both systems are performing backups of the same data. If one of the
systems will delete checkpoints after backup, it can prevent incremental
backup of the other system.

#### Use case 2 - running backups with different schedule

User is configuring both hourly and daily backup. If both jobs delete
the checkpoints after backup they may prevent the next job from
completing the next backup.

### Engine database changes

Add backup column to base_disks table. Use to mark an image for
incremental backup.

- base_disks
  - backup: (incremental/none)

Add vm_backups table. This table keep the information about running
backups tasks. Use during backup to track and montior backup.

- vm_backups
  - backup_id: UUID
  - phase: "initializing"/"starting"/"ready"/"finalizing"
  - from_checkpoint_id: UUID/null
    - if specified, perform incremental including all checkpoints since
      that checkpoint.
  - to_checkpoint_id: UUID/null
    - the newly created checkpoint.
  - vm_id: UUID
  - creation_date: TIMESTAMP

Add vm_backup_disk_map table. This table keeps the backup url and the backup mode
for every disk. The url will be used instead of the image path on the host when
creating an image transfer for a disk.

- vm_backup_disk_map
  - backup_id: UUID
  - disk_id: UUID
  - backup_url: ``nbd:unix:/tmp/<id>.sock:exportname=<sdb>`` | ``nbd://localhost:<12345>/<sdb>``

Add vm_checkpoints table. This table keeps the checkpoints created by
backup tasks. This info is used before backup to update libvirt about
the checkpoints list, since this info is not stored in the qcow2 images.

- vm_checkpoints
  - checkpoint_id: UUID
  - parent: UUID
  - vm_id: UUID
  - creation_date: TIMESTAMP
  - checkpoint_xml: TEXT

Add vm_checkpoint_disk_map table. This table keeps the disks included in
every checkpoint. Used when starting a backup to create checkpoint xml
for libvirt.

- vm_checkpoint_disk_map
  - disk_id: UUID
  - checkpoint_id: UUID


#### Example flow - backup

- add row to vm_checkpoints
- add row to disk_checkpoint_map for every disk
- add row to disk_backup_map for every disk
- add row to vm_backups
- start the backup
- update backup_url for every disk (returned from vdsm)
- user perform transfers...
- user finalize or cancel backup
- remove row from vm_backups
- remove rows from disk_backup_map


### Vdsm backup API

#### VM.start_backup

Start backup using libvirt API

#### VM.stop_backkup

End backup using libvirt API

#### VM.backup_info

Return backup info from libvirt.


### Vdsm checkpoints API

#### VM.redefine_checkpoints

Set libvirt checkpoints from engine database, without changing bitmaps
on storage.

Called before starting a backup, or once after starting a VM.

Libvirt will fail to redefine checkpoints if unknown bitmap exists on
storage, or a bitmap is missing on storage.

#### VM.list_checkpoints

Get from libvirt all the VM defined checkpoints.  

#### VM.delete_checkpoints

Delete checkpoints in libvirt and storage using libvirt API.


### Vdsm NBD API

#### NBD.start_server

Start NBD server using qemu-nbd for single volume, and return
```tranfer_url``` for this volume chain.

#### NBD.stop_server

Stop NBD server started using start_nbd_server API.


### Incremental backup ticket example

For running VM, qemu will serve the disk using NBD:
```
{
    "url": "nbd:localhost:1234:exportname=/sda"
}
```

For stopped VM, we will run one qemu-nbd instance per disk, using unix
socket:
```
{
    "url": "nbd:unix:/run/vdsm/nbd/xxxyyy-nbd.sock:exportname=/sda"
}
```

### UI

- Add 'Enable Incremental Backup' checkbox on New/Edit Disk dialogs.

- Removing last snapshot will disable 'Enable Incremental Backup' 
  if base image is raw. Snapshot must be created in order re-enable
  'Enable Incremental Backup'.


### Open Issues

- On startup after unclean shutdown or storage outage during shutdown,
  bitmaps marked as "in-use" must be deactivated or deleted, and qemu
  must not use the bitmap for tracking additional changes. According to
  John Snow, loading qcow2 with such bitmaps will fail and the user must
  delete the corrupted bitmaps manually. This will fail HA VM flows and
  storage operations. (libvirt/qemu).

- Need to allocate extra space for qcow2 metedata when using
  preallocated qcow2 on block storage (vdsm).

- Need to allocate extra space for bitmaps, depends on image virtual
  size and bitmap granulity. cannot be calculated when creating an image
  (vdsm).

- 1.1 factor used in vdsm and engine to limit qcow2 actual size may not
  be enough when image contains lots of bitmaps.  with defaults, each
  bitmap uses 2M per TB (engine, vdsm).

- Attaching disk with bitmaps to older qemu version will invalidate
  bitmaps, creating corrupted backups. how can we prevent this? (qemu).

- Do we need also qemu-img API to list all bitmaps in an image for
  managing bitmaps in floating disks?

- Test performance of preallocated qcow2 vs raw.
  https://www.jamescoyle.net/how-to/1810-qcow2-disk-images-and-performance

- Tune qcow2 images if needed
  https://www.slideshare.net/mobile/igalia/improving-the-performance-of-the-qcow2-format-kvm-forum(2017

## Links

- Overview of libvirt incremental backup API
  - [Part 1 (full pull mode)](https://www.spinics.net/linux/fedora/libvir/msg174457.html)
  - [Part 2 (incremental/differential pull mode)](https://www.spinics.net/linux/fedora/libvir/msg174528.html)

- API - backup application can use
  [oVirt engine REST API](https://github.com/oVirt/ovirt-engine-api-model)
  or [oVirt engine SDK](https://github.com/oVirt/ovirt-engine-sdk)
  to start and stop backup operation and get backup phase.

- ovirt-engine - the backup process is orchastracted and monitored by
  [ovirt-engine](https://github.com/oVirt/ovirt-engine).

- ovirt-imageio - backup application will access
  [ovirt-imageio](https://github.com/oVirt/ovirt-imageio) to transfer
  incremental backup data from the hypervisor running a VM, using
  [ovirt-imageio random I/O API](http://ovirt.github.io/ovirt-imageio/random-io.html).

- vdsm - on a hypervisor, [vdsm](https://github.com/oVirt/vdsm) will use
  libvirt backup and checkpoint API to start and stop backups, and
  prepare temporary volukes.

- libvirt - will use qemu API to start and stop backup jobs, and manage
  checkpoints.
  [Patches for incremental backup](https://www.redhat.com/archives/libvir-list/2018-October/msg01254.html)
  are in review in libvirt mailing list. The patches are also available
  in [Eric Blake's repository](https://repo.or.cz/libvirt/ericb.git).

- See also Eric's talk from KVM Forum 2018:
  [Facilitating Incremental Backup](https://events.linuxfoundation.org/wp-content/uploads/2017/12/Eric-Blake_2018-libvirt-incremental-backup.pdf)

- See also DevConf session about incremental backup talk from DevConf 2020:
  [Back to the future - incremental backup in oVirt - DevConf.CZ 2020](https://www.youtube.com/watch?v=foyi1UyadEc)

- qemu - track changed blocks using dirty bitmaps. dirty bitmap support
  added in qemu-3.0, and backported to qemu-rhev in CentOS 7.6. See
  [qemu incremental backup feature page](https://wiki.qemu.org/Features/IncrementalBackup)
  and [qemu source](https://git.qemu.org/?p=qemu.git) for more info.

- For reference, here is VMWare CBT docs
  https://kb.vmware.com/s/article/1020128
