---
title: CloneVmFromSnapshot
category: feature
authors: yair zaslavsky
wiki_category: Feature
wiki_title: Features/CloneVmFromSnapshot
wiki_revision_count: 30
wiki_last_updated: 2012-04-01
---

### Clone VM from snapshot

#### Summary

This feature will let users of oVirt engine to create a VM based on a given snapshot

#### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>

#### Current status

*   Last updated date: Wed Jan 18 2012

#### Detailed Description

A user will be able to create snapshots for a given virtual machine, and then to select a given snapshot and peform a clone of the VM.
The disks of the cloned VM will represent a "collapsed" state of the selected snapshot
(i.e: If the user selected to clone from the N-th snapshot, the disks of the cloned VM will be created by copying images from the snapshot chain of the first snapshot till the Nth snapshot, and then collapsing them).
The user will be be able to select different storage domains to hold the destination disks and to change their volume type and format.
The user will also be able to provide VM information (such as VM name) which will be based on the VM information of the original VM.

#### Benefit to oVirt

If we look at snapshots as "checkpoints" of VM state + data , and "checkpoints" are made in significant points of time, the feature allows a user to create a VM based on a significant point of time of another VM, and use the cloned VM, without interfering with the original VM (i.e - no need to perform collapse on images of the source VM).

#### Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API

#### Comments and Discussion

### Example of cloning from snapshot

Let's assume we have a VM with two disks. Each disk has an image, as can be seen in the next figure:

The next figure shows a snapshot was made, having now two images serving as the active images:

In a similar way, more snapshots are created (Snaphost2 will be the one used for performing the clone):

The Clone from snapshot will perform:

.1. copy & collapse all images at snaphsot2 and their ancestors .2. copy the vm and disks entities .3. Associate the copies of the disk to the copy of the vm, and the collpased images to the copied disks

This can be seen in the next figure:

# Backend requirements

.1. The snapshot that will be used for the VM will be collapsed in order to have the full data on disk required for a correct execution of the VM. .2. The snaphost that will be used for collapsing will be a clone of the original snapshot. This is required in order to let the VM that is originally associated with the snapshot continue to be associated with it. .3. The images that will be involved in the collapsing are all the images associated with the copy of the given snapshot, and their ancestors (direct and indirect parents). .4. A VM that is cloned from a snapshot of a VM that was created from a template, will not be associated with that template. .5. It will be available to change drive mapping , format type and disk types for the cloned disks. .6. It will be possible to provide different storage domains than the original ones used for the original VM to store the disks. .7. Upon running the command, all images in the snapshot chain should be locked. .8. If a disk that an image of it appeared in the snapshot chain is deleted, upon clone vm from snapshot, the images of the disk will not be copied (the cloned VM will not have a copy of the disk) and a proper event should be logged. .9. If a shared disk that an image of it appears in the snapshot chain becomes non shared after snapshot is performed, the clone will not contain a copy of the disk .10. For a disk residing on direct LUN, the disk is recognized as VM device, and should be copied as VM device as a part of copying all other VM devices of the source VM .11. It will be possible to clone a VM from snapshot when both when a VM is up or down (or in any state in which the relevant images are not locked and available for copying).

# UI requirements

      .1. Two approaches should be considered for passing the new VM data:<
      >

      .1.1. User will provide information for the created VM. The information will be based on VM configuration retrieved from the snapshot. The VM configuration (including the disks information) should be displayed for the user, so he will be able to use it as a basis for the VM configuration passed to the clone command.
      .1.2. The information will be copied from the original vm, and will undergo some transformation in the fields that should be changed (i.e - the VM name will undergo a transformation adding it a prefix of "copy_of_" at the target VM). <
      >

# Open issues

<Category:Feature>
