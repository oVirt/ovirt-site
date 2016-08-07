---
title: PassDiscardFromGuestToUnderlyingStorage
category: feature
authors: ishaby
feature_name: Pass discard from guest to underlying storage
feature_modules: engine/vdsm/api-model
feature_status: Work in progress for oVirt 4.1
---

# Pass discard from guest to underlying storage

## Summary

### How thinly provisioned disks are used today
Today, when the engine creates a thinly provisioned disk on a block domain, a logical volume with a preconfigured size is created, regardless its virtual size.<br/>
When the watermark comes near the LV's size, the *SPM* extends the LV, so that the disk grows again and again until it reaches its virtual size.<br/>
If the lun that is used to create the storage domain is also thinly provisioned, it behaves in a similar way. That is, when the engine extends a disk with one Gigabyte, it doesn't necessarily get 1G from the storage, but it does get 1G of virtual space. Therefore, like the LV, the underlying thinly provisioned lun will grow more and more until it reaches its virtual size.

Similarly, in file domains, the underlying thinly provisioned lun gets bigger as the corresponding disk's file grows.

### What can be improved
When files are removed from the disk by the guest, the LV does not shrink (it would if *vdsm* would have called `lvreduce`, but it can't since *vdsm* is not aware of file removals in the guest). Since the LV's size did not change, the thinly provisioned lun in the underlying storage did not change either.
So, in fact, although some of the disk's space was freed, the underlying storage was not aware of it, practically creating a situation where the underlying thinly provisioned luns can **only grow**, and can **never shrink**.

The same goes with file storage - when files are removed by the guest, the disk's actual size remains the same and so is the reported consumed space of the underlying thinly provisioned luns.

A better approach would be to "tell" the underlying storage that the guest freed some space that it doesn't need anymore, so that someone else can use it.

### For whom is this feature useful
This feature is useful for users that have thinly provisioned LUNs and wish to reclaim space released by their guests.


## Owner
* Idan Shaby
* Email: <ishaby@redhat.com>


## Current status
* Engine - work in progress for 4.1<br/>
    * For block storage, the engine should use the information reported by vdsm about the storage's `discard_max_bytes` and `discard_zeroes_data` values. Then it will decide whether to allow to enable *Pass Discard* or not.<br/>
    For more information see [General Functionality and Restrictions](#general-functionality-and-restrictions).
    * As discarding works also on file storage, the engine should not block the user from using it.
    * A few checks should be added to flows like moving or copying a disk from file to block storage with *Pass Discard* and *Wipe After Delete* enabled.
    * **Open Issue (pending discussion with UX experts)**: decide about the relationship between *Pass Discard* and *Enable SCSI Pass-Through* for direct LUNs.
* API-Model - released in 4.1.1
* Vdsm - work in progress for 4.19


## General Functionality and Restrictions

How it is done and under which conditions we can use it - TODO.


## Usage

### GUI Perspective

Details and screenshots - TODO.


### REST-API Perspective

Details and requests examples - TODO.


## Related Bugs
* Allow TRIM from within the guest to shrink thin-provisioned disks on iSCSI and FC storage domains([Bug 1241106](https://bugzilla.redhat.com/1241106)) 


## Related Features
* [Discard after delete](/develop/release-management/features/storage/discard-after-delete/)
* [Wipe volume using blkdiscard](/develop/release-management/features/storage/wipe-volume-using-blkdiscard/)
