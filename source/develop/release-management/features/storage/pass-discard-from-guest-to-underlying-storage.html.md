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

* How we use thin provisioned disks on block storage today - TODO.

* What we would like to achieve - TODO.

* For whom is this feature useful - TODO.

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
