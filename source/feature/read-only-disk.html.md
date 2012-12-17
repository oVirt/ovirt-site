---
title: Read Only Disk
category: feature
authors: sgotliv, vered
wiki_category: Feature
wiki_title: Features/Read Only Disk
wiki_revision_count: 41
wiki_last_updated: 2014-07-03
---

# Read Only Disk

### Summary

Add Read Only Disk Functionality to the engine.

### Owner

*   Name: [Vered Volansky](User:vvolansk)
*   Email: vered@redhat.com

### Current status

*   Target Release: 3.2
*   Status: work in progress
*   Last updated date: 12/17/2012

### Detailed Description

When adding/attaching a disk to a vm, add a property of RO. The RO property is not a disk property. It's a property of the VM-Disk relationship, and therefore is persisted through VMDevice (vm_device in the DB). A shareable disk could be attached to one VM as RO, and to another as RW. This is the case as long as the disk is not qCow. qCow disks currently cannot be shared. When that'll change, it shouldn't be allowed to attach a RW qCow disk to one VM while attaching it as RO to another.

### Benefit to oVirt

This features allows the usage of read only disks. This is useful where we'd like to expose the data but don't want it to be altered. This is a new feature in the engine, allowing the attachment of a disk to a VM to be done with read only rights. A shareable disk could be attached to one VM as RO, and to another as RW.

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature>
