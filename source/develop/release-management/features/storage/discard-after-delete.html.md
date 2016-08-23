---
title: DiscardAfterDelete
category: feature
authors: ishaby
feature_name: Discard after delete
feature_modules: vdsm
feature_status: Partially implemented in oVirt 4.0
---

# Discard after delete

## Summary

### How thinly provisioned luns were used so far
Generally, the underlying storage can provide two types of luns - *pre allocated* and *thinly provisioned*.

* When a *pre allocated* lun is created with a size of *x* Gigabytes, the storage array allocates those *x* Gigabytes for that lun, so that other luns are not able to use those blocks.<br/>
* When a *thinly provisioned* lun is created with a size of *x* Gigabytes, the storage array may allocate less than *x* Gigabytes for that lun, and each time it reaches a certain limit of used space, it is extended by the array until it reaches it's virtual size and cannot be extended anymore.

### What can be improved
Suppose that a VM contains a disk *disk1* on a block storage domain *sd1*, and that *disk1* is removed. Also suppose that *sd1* is built on a 20GB lun, *lun1*.

* If *lun1* is a *pre allocated* lun, then there's no reason to go and try to tell the storage array that some blocks were freed because *lun1* uses the whole 20GB anyway.
* If *lun1* is a *thinly provisioned* lun, and we could tell the storage array that some blocks were freed, it could have shrinked *lun1* so that other luns in the array could make use of those unused blocks.

This feature is about freeing (discarding) the whole disk space right before removing it.

### For whom is this feature useful
This feature is useful for users that have thinly provisioned luns and wish to reclaim space when removing a disk from a block storage domain that is built from them.


## Owner
* Idan Shaby
* Email: <ishaby@redhat.com>


## Current status
* [Phase one](#usage) (implemented in vdsm config file) - released in oVirt 4.0.
* [Phase two](#future-plans) (configurable on engine side) - planned for oVirt 4.1.


## General functionality and restrictions

### Under the hood
A new parameter was added to the *vdsm* configuration file, ***discard_enable***.<br/>
When it is *true* in a specific vdsm host, that host will issue a *blkdiscard* command on a logical volume right before removing it. That means that each disk or snapshot that this host removes, automatically triggers  it to inform the storage array that this logical volume's blocks were freed and can be used by other luns in the array.

### Possible consumers of the discarded blocks
After a disk is removed from a block storage domain and its blocks are discarded, anything can use them:

* New and existing disks on the same storage domain (if there's enough free space in the storage domain, of course).
* New and existing disks on other storage domains that are built on luns from the same storage array.
* Other processes that use luns from the same storage array.

### Restrictions

#### The underlying storage
Let *lunX* be a device and *dm-X* be its corresponding dm device for a natural number X. Then *lunX* is considered to ***support discard*** iff the value of `/sys/block/dm-X/queue/discard_max_bytes` is bigger than 0 [^1].

The lun in the underlying storage must *support discard* in order for this to work.<br/>
If it does not, the *blkdiscard* command that *vdsm* tries to execute will fail with a log but will not break the lv removal. That is, the lv will be removed but the space will not be reclaimed.

#### *Wipe After Delete* and *discard_enable*
These two properties are completely independent.<br/>
To understand it better, let's take a look at the flow of removing a disk from a block domain in *vdsm*:

1. If the disk's *Wipe After Delete* is enabled, then the disk is first wiped. If not, *vdsm* moves to phase 2.
2. If the host that is going to remove it has its *discard_enable* enabled, then *vdsm* issues a *blkdiscard* command on that disk's logical volumes. If not, it moves to phase 3.
3. The disk's logical volumes are removed.


## Usage
To make this feature work, the administrator should set the *discard_enable* property in `/etc/vdsm/vdsm.conf` to ***true*** and then **restart the *vdsmd* service**.

> **Note**<br/>
> The value of *discard_enable* is ***false*** by default.<br/>


## Future Plans
The second phase of this feature is to make it configurable by a storage domain rather than a host ([Bug 1342919](https://bugzilla.redhat.com/1342919)).<br/>
Specifically:

* Add a new storage domain property called ***Discard After Delete***.
* The engine will allow to enable the *Discard After Delete* property for a storage domain iff all of the luns that it is built from *support discard*.
* If a storage domain's *Discard After Delete* property is enabled, then before removing a disk on that domain, *vdsm* will issue a *blkdiscard* command on it.
* If a lun is added to a storage domain with the *Discard After Delete* property enabled and that lun doesn't *support discard*, the storage domain's *Discard After Delete* property will be set to false.
* We might also want to support *Discard After Delete* in file storage domains.


## Related Bugs
* Send discard when deleting virtual disks from block based storage domain to regain space in thin provisioned storage ([Bug 981626](https://bugzilla.redhat.com/981626))
* Make discard configurable by a storage domain rather than a host ([Bug 1342919](https://bugzilla.redhat.com/1342919))


## Related Features
* [Pass discard from guest to underlying storage](/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage/)
* [Wipe volume using blkdiscard](/develop/release-management/features/storage/wipe-volume-using-blkdiscard/)


## References
[^1]: See "discard_max_bytes" in "Queue sysfs files" - [https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt](https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt)
