---
title: CloneVmFromSnapshot
category: feature
authors: yair zaslavsky
wiki_category: Feature
wiki_title: Features/CloneVmFromSnapshot
wiki_revision_count: 30
wiki_last_updated: 2012-04-01
---

# Clone VM from snapshot

### Summary

This feature will let users of oVirt engine to create a VM based on a given snapshot

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>

### Current status

*   Last updated date: Wed Jan 18 2012

### Detailed Description

#### User interface

1.A user will be able to create snapshots for a given virtual machine, and then to select a given snapshot and perform a clone of the VM.
2.The user will also be able to provide VM information (such as VM name) which will be based on the VM information of the original VM.
3.The original VM configuration for a given snapshot will be retrieved by the UI , using a dedicated query carried out on oVirt-engine core
4.The user will be be able to select different storage domains to hold the destination disks and to change their drive mapping,volume type and format.

#### Cloning of images behavior

5.The disks of the cloned VM will represent a "collapsed" state of the selected snapshot
6.A clone can be performed on a VM regardless of its status (i.e - can be performed if a VM is UP or down as long as the images are available)
7.In order to prevent concurrent flows from modifying the original images that relate to the snapshot chain will the clone is taking place, these images should be locked
8. If a disk that an image of it appeared in the snapshot chain is deleted, upon clone vm from snapshot, the images of the disk will not be copied
(the cloned VM will not have a copy of the disk) and a proper event should be logged.

#### Shared disks and direct LUN diskes behavior

9. For cloning a VM from snapshot that has shared disks, there are several options (one of them should be considered - this is still an open issue):
9.1. Block the taking a snapshot in such a situation (as shared disk do not support snapshotting)
9.2. Creating a cloned disk, marking it plugged and available for usage. This may yield data corruption
9.3. Marking the clone disk at the destination VM as unplugged. Allowing the user to plug it.
10. For a disk residing on direct LUN, the feature still need to be defined - it might be similar

### Benefit to oVirt

If we look at snapshots as "checkpoints" of VM state + data , and "checkpoints" are made in significant points of time, the feature allows a user to create a VM based on a significant point of time of another VM, and use the cloned VM, without interfering with the original VM (i.e - no need to perform collapse on images of the source VM).

### Dependencies / Related Features

Dependencies on features:

*   LiveSnapshot [Features/CloneVmFromSnapshot](Features/CloneVmFromSnapshot)
*   Hotplug disk
*   Stable device addresses
*   Multiple storage domains

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API

### Comments and Discussion

<Category:Feature>
