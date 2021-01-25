---
title: Backup API
category: api
authors: mlipchuk
---

<!-- TODO: Content review -->

# Backup API

This document describes the design for the Backup API feature.

## Motivation

The motivation that stands behind this idea is to provide the user an API which can be used to backup different VM disks in the system. The user will be able to use externalized backup applications which will provide the ability to backup the data of any image disk into a predefined container disk which will be used as part of a backup container (VM).

## Current status

*   Target Release: 3.4
*   Status: Released
*   Last updated date: Fri Apr 21 2016

## Functionality

### General Functionality

When attaching a disk to a vm only the active volume was used, if the user wanted to see the disk content at some snapshot he had to preview that snapshot.
As part of the backup API feature, a snapshot of a disk can be attached to another vm, regardless of the disk not being marked as shareable - when doing so, VDSM should create a temp snapshot allowing read/write access above the selected snapshot, the above should happend when hotplugging a disk/ running a vm.
In case of hot unplug of the disk snapshot vdsm should delete the temp snapshot.

### Backup Disk Functionality

The new backup disk is not a regular disk and will be blocked from being exported/ use in a template/ or be part of the backup VM snapshot.

If the user will try to remove the backup disk snapshot it will remove the disk from the entire setup (also from the original VM)

The disk can be definied as bootable for the VM if it's attached as bootable and the VM does not contain another bootable disk yet this mostly doesn't make much sense.

## Example (using oVirt 4.x API)

1. Navigate to the wanted disk snapshot from REST by accessing: `SERVER:PORT:/api/vms/GUID/snapshots/GUID/disks`

2. POST a disk attachment with the disk id and the snapshot id and choose "false" for bootable and the desired disk interface `http://SERVER:PORT/api/vms/GUID/diskattachments/`

When attaching the disk you will have to pass the the disk id and the snapshot id and the disk interface as in the following example:

    <disk_attachment>
        <disk id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
           <snapshot id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"/>
        </disk>
        <bootable>false</bootable>
        <interface>virtio</interface>
    </disk_attachment>

After copying the data from the disk detach the disk snapshot from the VM using the REST with the following parameters:

      Method = DELETE
      URL indicates to the specific disk in the VM: http://SERVER:PORT/api/vms/GUID/diskattachments/GUID

## Example (Legacy oVirt 3.X API)
Note: Since prior to version 4.0 the disks themselves are defined as bootable, if the new backup disk will be a boot disk and will have an OS installed on it then there can be one of the other use cases:

* If the backup VM will already contain a boot disk with OS installed on it, then the original boot disk will be remained.
* If the backup VM will not contain a boot disk with OS installed on it, then the original boot disk will act as a boot disk which the VM will start the boot from.

1. Navigate to the wanted disk snapshot from REST by accessing: `SERVER:PORT:/api/vms/GUID/snapshots/GUID/disks`

2. POST the copied disk with the disk id and the snapshot id: `http://SERVER:PORT/api/vms/GUID/disks/`

When creating a disk you will have to pass the the disk id and the snapshot id such as the following example:

    <disk id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
        <snapshot id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"/>
    </disk>

After copying the data from the disk detach the disk snapshot from the VM using the REST with the following parameters:

      Method = DELETE
      URL indicates to the specific disk in the VM: http://SERVER:PORT/api/vms/GUID/disks/GUID
      Body=<action><detach>true</detach></action>


## The Backup Process

User can back up a virtual machine by an externalized application by the following steps:

*   Choose the disk snapshot which you want to use for back up.
*   Attach this disk snapshot to the target virtual machine for back up
*   Capture the virtual disk data and virtual machine configuration information (vim.vm.ConfigInfo).
*   Open and read the virtual disk and snapshot files. Copy them to backup media, along with configuration information.
*   Detach the disk

## Future Work

*   UI - would be handled in a following patch (the information is accessible through REST)
*   possibly further inspection of permissions

## Future work / Limitations

*   The created temp snapshots is stored on the host local storage (the host that the vm is running on) and not on the shared storage (domains) therefore the vm can't be migrated.
*   A disk snapshot can be attached to a different VM than the one of which the snapshot (VM snapshot) was taken of.
