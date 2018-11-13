---
title: Incremental Backup
category: feature
authors: nsoffer, derez
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

## Future Work

- Support for full backup for raw disks. Libvirt supports full backup of
  raw disks without creating a new checkpoint.

- API for listing and deleting checkpoints.

## Detailed design

### Validating checkpoints before backup

Before starting a backup, the available bitmaps on every disk must be
compared to the stored checkpoints on engine database. If a bitmap is
missing in the image, or unknown bitmap exist, all the checkpoints on
the disk and engine database must be deleted, and the current backup
must be a full backup.

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
   database with "initializing" status.

1. engine creates a scratch disk using qcow2 format for every disk in
   the backup. The disk must have enough space to hold the current data
   in the top layer of an image.

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

1. engine changes the backup status to "ready". Once the user detects
   the change, the user can start transferring data.

### Finalizing backup

When backup succeeds, backup application copied all incremental data
successfully.

1. user ask to finalize the backup using oVirt API. engine change
   backup status to "finalizing".

1. engine end the backup using vdsm backup API, which will use libvirt
   backup API to end the backup.

1. libvirt uses qemu API to delete the temporary bitmaps and end the
   backup job.

1. engine tears down and deletes the scratch disks created fro the backup
   using vdsm storage APIs.

1. If running the special "backup" stripped down VM, tear down disks the
   VM disks using the existing storage APIs, and destroy the VM on the
   backup host.

### Checkpoints cleanup

Cleaning up checkpoints will be available later.

Checkpoints may be generated by multiple unrelated or partly related
users, deleting checkpoints cannot be done automatically by every user
after backup.

The backup API should allow specifying some range of checkpoint to
delete. Probably specifying a checkpoint that should be kept, deleting
all older snapshots.

#### Use case 1 - running 2 backup solutions in the same time

User is switching from backup solution A to B. During the transition,
both systems are performing backups of the same data. If one of the
systems will delete checkpoints after backup, it can prevent incremental
backup of the other system.

#### Use case 2 - running backups with different schedule

User is configuring both hourly and daily backup. If both jobs delete
the checkpoints after backup they may prevent the next job from
completing the next backup.

### Cancelling backup

When backup fail or aborted, backup application didn't complete to copy
all data.

1. Delete scratch disks created for this backup.
2. If the VM is not running, tear down the disks included in the backup.


### Engine database changes

Add backup column to disk_attachments table. Use to mark an image for
incremental backup.

- disk_attachments
  - backup: (incremental|null)

Add vm_backups table. This table keep the information about running
backups tasks. Use during backup to track and montior backup.

- vm_backups
  - id: UUID
  - status: "initializing" | "starting" | "ready" | "transferring" | "finalizing"
  - incremental_id: UUID | null
    - if specified, perform incremental including all checkpoints since
      that checkpoint.

Add disk_backup_map table. This table keeps the backup url for every
disk. This url will be used instead of the image path on the host when
creating an image transfer for a disk.

- disk_backup_map
  - backup_id: UUID
  - disk_id: UUID
  - backup_url: "nbd:unix:/tmp/<id>.sock:exportname=<sdb>" | "nbd://localhost:<12345>/<sdb>"

Add vm_checkpoints table. This table keeps the checkpoints created by
backup tasks. This info is used before backup to update libvirt about
the checkpoints list, since this info is not stored in the qcow2 images.

- vm_checkpoints
  - id: UUID
  - parent: UUID
  - vm_id: UUID
  - creation_date: date

Add disk_checkpoint_map table. This table keeps the disks included in
every checkpoint. Used when starting a backup to create checkpoint xml
for libvirt.

- disk_checkpoint_map
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


### REST

#### Enabling backup for VM disk

Specify 'backup' flag on 'disk_attachment' entity.

Request:
```
POST /vms/vm-uuid/diskattachments
```

Response:
```
<disk_attachment>
    ...
    <backup>incremental|full|none</backup>
    ...
</disk_attachment>
```

#### Finding disks enabled for incremental backup

For each VM, get 'diskattachments' list and filter according to
'backup' property.

Request:
```
GET /vms/vm-uuid/diskattachments
```

Response:
```
<disk_attachments>
    <disk_attachment>
        ...
        <backup>incremental|null</backup>
        ...
    </disk_attachment>
    ...
</disk_attachments>
```

#### Starting backup

Start incremental backup since backup id "previous-backup-uuid".

Request:
```
POST /vms/vm-uuid/backups

<backup>
    <incremental>previous-backup-uuid</incremental>
    <disks>
        <disk id="disk-uuid" />
        ...
    </disks>
</backup>
```

Response:
```
<backup id="backup-uuid">
    <incremental>previous-backup-uuid</incremental>
    <disks>
        <disk id="disk-uuid" />
        ...
        ...
    </disks>
    <status>initiailizing</status>
    <creation_date>...
</backup>
```

#### Getting backup info

When backup status is "ready", you can start downloading the disks.

Request:
```
GET /vms/vm-uuid/backups/backup-uuid
```

Response:
```
<backup id="backup-uuid">
    <incremental>previous-backup-uuid</incremental>
    <disks>
        <disk id="disk-uuid">
            <image_id>image-uuid</image_id>
        </disk>
        ...
    </disks>
    <status>ready</status>
    <creation_date>...
</backup>
```

#### Finalizing backup

```
POST /vms/vm-uuid/backups/backup-uuid/finalize

<action></action>
```

#### Canceling backup

```
POST /vms/vm-uuid/backups/backup-uuid/cancel

<action></action>
```

#### Creating image transfer for incremental restore

XXX Write me

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

- Add 'Enable Incremental Backup' checkbox on New/Edit/Attach Disk dialogs (in VM context).

- Removing last snapshot should be disabled if 'Enable Backup'
  is checked and the base image is raw. Backup must be disabled in order
  to remove the last snapshot.


### Open Issues

- On startup after unclean shutdown or storage outage during shutdown,
  bitmaps marked as "in-use" must be deactivated or deleted, and qemu
  must not use the bitmap for tracking additional changes. According to
  John Snow, loading qcow2 with such bitmaps will fail and the user must
  delete the corrupted bitmaps manually. This will fail HA VM flows and
  storage operations. (libvirt/qemu).

- When creating a snapshot, an active bitmap should be copied to the new
  top layer, and qemu should continue to track changes, writing into the
  copied bitmap (libvirt).

- Handle VM stop during a backup - should abort the backup, causing
  image transfers to fail (engine).

- Handle VM start during a backup of an offline VM - should abort the
  backup, causing image transfers to fail (engine).

- Locking disks during backup - currently image transfer lock the disk,
  but we need to lock the disk when creating the backup. Image transfer
  should skip locking if the disk is included in incremental backup
  (engine).

- How to handle failure on finalize and cancel? For example failure
  to delete a scratch disk. Should the system continue to track the
  items and retry to complete the operation later? (engine).

- Need to allocate extra space for qcow2 metedata when using
  preallocated qcow2 on block storage (vdsm).

- Need to allocate extra space for bitmaps, depends on image virtual
  size and bitmap granulity. cannot be calculated when creating an image
  (vdsm).

- 1.1 factor used in vdsm and engine to limit qcow2 actual size may not
  be enough when image contains lots of bitmaps.  with defaults, each
  bitmap uses 2M per TB (engine, vdsm).

- Are bitmaps copied when copying images with qemu-img convert? if not
  next backup after LSM or move disk must be full (qemu-img).

- Are bitmaps copied in block copy during LSM for the active layer?
  If not the next backup must be full (libvirt/qemu).

- How to handle hot plug disk? can we continue to track changes on a
  detached disk, or we should require a full backup in this case?

- Attaching disk with bitmaps to older qemu version will invalidate
  bitmaps, creating corrupted backups. how can we prevent this? (qemu).

- Are bitmaps are copied down from the active layer during live merge
  (libvirt/qemu) and cold merge (qemu-img)?

- Need libvirt API to list all bitmaps in an image in a running VM
  (libvirt).

- Do we need also qemu-img API to list all bitmaps in an image for
  managing bitmaps in floating disks?

- Test performance of preallocated qcow2 vs raw.
  https://www.jamescoyle.net/how-to/1810-qcow2-disk-images-and-performance

- Tune qcow2 images if needed
  https://www.slideshare.net/mobile/igalia/improving-the-performance-of-the-qcow2-format-kvm-forum-2017

## Links

- API - backup application can use
  [oVirt engine REST API](https://github.com/oVirt/ovirt-engine-api-model)
  or [oVirt engine SDK](https://github.com/oVirt/ovirt-engine-sdk)
  to start and stop backup operation and get backup status.

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

- Overview of libvirt incremental backup API
  - Part 1 (full pull mode): https://www.spinics.net/linux/fedora/libvir/msg174457.html
  - Part 2 (incremental/differential pull mode): https://www.spinics.net/linux/fedora/libvir/msg174790.html

- See also Eric's talk from KVM Forum 2018:
  [Facilitating Incremental Backup](https://events.linuxfoundation.org/wp-content/uploads/2017/12/Eric-Blake_2018-libvirt-incremental-backup.pdf)

- qemu - track changed blocks using dirty bitmaps. dirty bitmap support
  added in qemu-3.0, and backported to qemu-rhev in CentOS 7.6. See
  [qemu incremental backup feature page](https://wiki.qemu.org/Features/IncrementalBackup)
  and [qemu source](https://git.qemu.org/?p=qemu.git) for more info.

- For reference, here is VMWare CBT docs
  https://kb.vmware.com/s/article/1020128
