---
title: WipeVolumesUsingBlkdiscard
category: feature
authors: ishaby
---

# Wipe volumes using blkdiscard

## Summary

### How volumes are wiped today
When a disk on a block domain has its ***Wipe After Delete*** property enabled and it is removed, *vdsm* first wipes its volumes (writes zeros on them) and only then removes them.<br/>
Today, *vdsm* uses the `dd` linux command to wipe volumes.

### What can be improved
The problem with using `dd` to wipe volumes is that it is **very slow** (~ 7 minutes to wipe a 10GB volume on a storage that supports it).<br/>
To zero volumes more efficiently, *vdsm* can use the `blkdiscard` command from the *util-linux* package, which can run up to ~ 10 times faster.

### For whom is this feature useful
This feature is useful for security-conscious users who use *Wipe After Delete* and modern storage arrays that support *discard*.


## Owner
* Idan Shaby


## Current status
This feature is in research and is planned for oVirt 4.1.

* It seems like `blkdiscard -z` sometimes fails when it is run by *vdsm* instead of `dd`.
* The next thing that needs to be checked is whether the failure is related to the priority that *vdsm* gives it when running it using `execCmd`.
It's possible that since *vdsm* runs it with a low priority, it gets a lot of timeouts, and when it tries to do it in parallel for more than one or two disks - it fails.
* It can also be considered to use `sg_unmap` or `sg_write_same` if things don't work out with blkdiscard.


## General Functionality and Restrictions

### Under the hood
To understand what `blkdiscard` can do, let's first take a look at the following declarations:

* Let *lunX* be a device and *dm-X* be its corresponding dm device for a natural number X. Then *lunX* is considered to ***support write same*** iff the value of `/sys/block/dm-X/queue/write_same_max_bytes` is bigger than 0 [^1].
* A device that *supports write same* is a device that allows to write a single data block to a range of several contiguous blocks in the storage.<br/>
That means that instead of writing a 1MB block of zeros 1024 times to zero a volume of 1GB (as *vdsm* does with `dd` today), a single request to write that 1MB block of zeros to the right range is enough, and the rest is done by the storage array.

When calling `blkdiscard -z <block_device>`:

* If the block device *supports write same*, then the kernel quickly zeroes it using *write same*.
* Else, the kernel zeroes it by writing pages of zeros.

### Restrictions
There are no restrictions when using `blkdiscard -z`, although `blkdiscard` performs roughly the same as `dd` if the storage does not *support write same*.

## Usage
`blkdiscard` will completely replace `dd` for wiping disks, so the usage is the same as the usage of *Wipe After Delete* - the user should remove a disk that resides on a block storage domain with its *Wipe After Delete* property enabled.


## Future Plans
We might consider to use even a more efficient way to wipe volumes. To understand it, let's first take a look at the following declarations:

* Let *lunX* be a device and *dm-X* be its corresponding dm device for a natural number X. Then *lunX* supports the property that ***discard zeroes the data*** iff the value of `/sys/block/dm-X/queue/discard_zeroes_data` is 1 [^2].
* A lun that supports the property that *discard zeroes the data* guarantees that previously discarded blocks are read back as zeros from it.

A better way to wipe a volume would be:

* If the block device supports the property that *discard zeroes the data* - zero the disk by discarding its blocks.
* Else, if it *supports write same*, zero the disk using *write same*.
* Else, write zeros block by block.

## Related Bugs
* Wipe volumes using "blkdiscard" instead of "dd" ([Bug 1367806](https://bugzilla.redhat.com/1367806))


## Related Features
* [Pass discard from guest to underlying storage](/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage.html)
* [Discard after delete](/develop/release-management/features/storage/discard-after-delete.html)


## References
[^1]: See "write_same_max_bytes" in "Queue sysfs files" - [https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt](https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt)
[^2]: See "discard_zeroes_data" in "Queue sysfs files" - [https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt](https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt)
