---
title: Incremental Backup
category: feature
authors: nsoffer, derez
feature_name: Incremental Backup
feature_modules: imageio,engine
feature_status: Design
---

# Incremental Backup


## Summary

Incremental backup allows a user to backup only the changed blocks in
all the disks belonging to a VM snapshot. The typical use case is backing
up the current changes in the active snapshot. Another use case may be
backing up the previous snapshot if a user added a snapshot since the
last backup.

Note: users using RAW files will have to create a snapshot on top to
allow incremental backup to start.


## Owner

*   Nir Soffer (<nsoffer@redhat.com>)
*   Daniel Erez (<derez@redhat.com>)


## Incremental backup flow
Backup flow is the same from the point of view of the user (backup
application), but will be implemented differently under the hood.

1. Backup application starts backup using oVirt API, specifying the last
backup. The backup will include blocks that changed since that backup.
2. System prepares VM for backup for running VM, or the VM disks for
backup for a stopped VM.
3. Backup application starts image transfer for download
4. Backup application obtains changed blocks list from ovirt-imageio
5. Backup application downloads changed blocks from ovirt-imageio
6. Backup application finalize image transfer
7. Backup application finish backup using oVirt API


## Create VM with incremental backup support
To allow incremental backup the user must enable the feature per VM.

### Open issues
Do we need to support per disk incremental backup?


## Restoring from incremental backup
Basically the backup vendor will build a snapshot image from the
incremental backups, and upload the snapshot using imageio. No change
in libvirt or qemu is needed.

Flow:
1. User select restore point based on available backups using the
backup application (not part of oVirt).
2. Backup application builds the complete snapshot from the available
backups.
3. Backup application upload the complete snapshot to storage using
imageio.

### Open issues
Do we have a need for incremental restore, modifying specific blocks
in a snapshot from incremental backups?


## Preparing running vm for incremental backup
Qemu supports now only the push mode - copying changed blocks to
external disk provided by the user, using qcow2 format. Theoretically
any format can be used but practically only qcow2 allows getting
changed blocks on any storage type.

A more efficient pull mode is being developed, when the user copy
changed blocks from the active layer. In this mode qemu may need to
copy only blocks that the running VM want to change after the
backup started.

Both push and pull models will either be in or not in RHEL 7.6,
since they both use the same libvirt API and both are done in QEMU.
We plan to start with the push mode.

From oVirt point of view the pull and push modes are mostly the same.
The difference is improved user experience in the pull mode because
qemu does not need to copy all the changed blocks before the user can
start downloading data.

### Push mode
1. oVirt creates a backup checkpoint, deactivating the current dirty
bitmap, and creating new dirty bitmap.
2. oVirt queries the disk size needed for a backup operation,
depending on the dirty bitmap included in the backup.
3. oVirt creates a temporary disk for copying the changed blocks.
The backing file of the temporary disk is the backed up snapshot.
4. <b>oVirt start backup operation with the external disk using
push mode.</b>
5. <b>Qemu copies changed blocks to the external disk, including
needed metadata</b>
6. oVirt starts local qemu-nbd, mounting the external disk at /dev/nbdX.
7. oVirt notify the user (e.g. backup application) that the backup
disk is ready.
8. Backup application starts a transfer with the relevant disks
9. Backup application obtains the changed blocks list from
ovirt-imageio via HTTPS.
10. Ovirt-imageio obtain the changed blocks using qemu-img map and
the external image
11. Backup application downloads the changed blocks (guest blocks)
from ovirt-imageio via HTTPS.
12. ovirt-imageio read the blocks from /dev/nbdX.

### Pull mode
Pull is not available yet, the following is based on the Libvirt pull
proposal ([RFC v2] external (pull) backup API).

1. oVirt creates a backup checkpoint, deactivating the current dirty
bitmap, and creating new dirty bitmap.
2. oVirt queries the disk size needed for a backup operation,
depending on the dirty bitmap included in the backup.
3. oVirt creates a temporary disk for copying changed blocks.
The backing file of the temporary disk is the backed up snapshot.
4. <b>oVirt start backup operation with the external disk using
pull mode.</b>
5. <b>Qemu watches writes to the active snapshot. If blocks included in
the a the backup are modified, the blocks are copied to the temporary
disk to the backup will copy the correct data.</b>
6. oVirt starts local qemu-nbd, mounting the external disk at /dev/nbdX.
7. oVirt notify the user (e.g. backup application) that the backup
disk is ready.
8. Backup application starts a transfer with the relevant disks
9. Backup application obtains the changed blocks list from
ovirt-imageio via HTTPS.
10. Ovirt-imageio obtain the changed blocks using qemu-img map and
the external image.
11. Backup application downloads the changed blocks (guest blocks)
from ovirt-imageio via HTTPS.
12. ovirt-imageio read the blocks from /dev/nbdX.


## Preparing stopped VM disks for incremental backup
This does not depend on the push or pull modes, but we need qemu
support for getting the changed blocks from an image.

Basically this is the same as push mode, after qemu pushed the
changed blocks to external image.

1. oVirt starts local qemu-nbd, mounting the external disk at /dev/nbdX.
2. oVirt notify the user (e.g. backup application) that the backup
disk is ready.
3. Backup application starts a transfer with the relevant disks
4. Backup application obtains the changed blocks list from
ovirt-imageio via HTTPS.
5. ovirt-imageio obtains the changed blocks using qemu-img map and
the external image.
6. Backup application downloads the changed blocks (guest blocks)
from ovirt-imageio via HTTPS.
7. ovirt-imageio reads the blocks from /dev/nbdX.


## Links
- RFC v2 external (pull) backup API:

    https://www.redhat.com/archives/libvir-list/2018-April/msg00115.html

- Vmware CBT docs:

    https://kb.vmware.com/s/article/1020128

- Eric Blake patches:

    https://www.redhat.com/archives/libvir-list/2018-June/msg01066.html


## Reference

#### How to connect image via nbd:

    qemu-nbd -c /dev/nbd0 -f qcow2 image.qcow2

#### How to connect to nbd unix socket:

    qemu-img create -f qcow2 -b nbd+unix://?socket=/tmp/nbd.sock overlay.qcow2
