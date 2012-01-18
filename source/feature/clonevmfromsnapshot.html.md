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

A user will be able to create snapshots for a given virtual machine, and then to select a given snapshot and peform a clone of the VM.
The disks of the cloned VM will represent a "collapsed" state of the selected snapshot
(i.e: If the user selected to clone from the N-th snapshot, the disks of the cloned VM will be created by copying images from the snapshot chain of the first snapshot till the Nth snapshot, and then collapsing them).
The user will be be able to select different storage domains to hold the destination disks and to change their volume type and format.
The user will also be able to provide VM information (such as VM name) which will be based on the VM information of the original VM.

### Benefit to oVirt

If we look at snapshots as "checkpoints" of VM state + data , and "checkpoints" are made in significant points of time, the feature allows a user to create a VM based on a significant point of time of another VM, and use the cloned VM, without interfering with the original VM (i.e - no need to perform collapse on images of the source VM).

### Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API

### Comments and Discussion

<Category:Feature>
