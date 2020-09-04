---
title: CloneVmFromSnapshot
category: feature
authors: yair zaslavsky
---

# Clone VM from snapshot

## Summary

This feature will let users of oVirt engine to create a VM based on a given snapshot

## Owner

*   Name: Yair Zaslavsky (Yair Zaslavsky)

## Current status

*   Last updated date: Wed Jan 18 2012

Engine-done, API-done, UI-coding

## Detailed Description

### User interface

1.  A user will be able to create snapshots for a given virtual machine, and then to select a given snapshot and perform a clone of the VM.
2.  The user will also be able to provide VM information (such as VM name) which will be based on the VM information of the original VM.
3.  The original VM configuration for a given snapshot will be retrieved by the UI , using a dedicated query carried out on oVirt-engine core
4.  The user will be be able to select different storage domains to hold the destination disks and to change their drive mapping,volume type and format.

### Cloning of images behavior

1.  The disks of the cloned VM will represent a "collapsed" state of the selected snapshot
2.  A clone can be performed on a VM regardless of its status (i.e - can be performed if a VM is UP or down as long as the images are available)
3.  In order to prevent concurrent flows from modifying the original images that relate to the snapshot chain will the clone is taking place, these images should be locked
4.  If a disk that an image of it appeared in the snapshot chain is deleted, upon clone vm from snapshot, the images of the disk will not be copied (the cloned VM will not have a copy of the disk) and a proper event should be logged.
5.  In order for the clone operation to succeed, the user must have a suitable quota per each destination storage domain involved in
6.  All image copies will be performed concurrently (due to the nature of the asynchronous handling of CopyImage verb at VDSM)
7.  In case of failure, the images that were successfully copied until the point of failure should be deleted. Other copy tasks should be aborted

the images cloning

### Hot plugged disks

1.  During creating a snapshot, the "pluggable" attribute of a disk will be stored in the VM configuration.

Clone VM from Snapshot will be indifferent to this attribute, in a sense the destination disk will be created with the same value
of the attribute as its corresponding source disk.

### Shared disks and direct LUN diskes behavior

1.  For shared disks and direct LUN based disks, the user who performs the snapshot will specify during snapshot creation whether the disk should be plugged or unplugged

upon performing the clone.

## Benefit to oVirt

If we look at snapshots as "checkpoints" of VM state + data , and "checkpoints" are made in significant points of time, the feature allows a user to create a VM based on a significant point of time of another VM, and use the cloned VM, without interfering with the original VM (i.e - no need to perform collapse on images of the source VM).

## Future work

1.  The ability to clone from a VM based on a template, without collapsing the template images (and continuning to point to the original template) should be added.

## Dependencies / Related Features

Dependencies on features:

*   LiveSnapshot
*   Hotplug disk
*   Stable device addresses
*   Multiple storage domains

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API


