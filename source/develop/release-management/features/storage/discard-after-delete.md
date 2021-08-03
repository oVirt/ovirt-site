---
title: DiscardAfterDelete
category: feature
authors: ishaby
---

# Discard after delete

## Summary

### How thinly provisioned luns were used so far
Generally, the underlying storage can provide two types of luns - *pre allocated* and *thinly provisioned*.

* When a *pre allocated* lun is created with a size of *x* Gigabytes, the storage array allocates those *x* Gigabytes for that lun, so that other luns are not able to use those blocks.<br/>
* When a *thinly provisioned* lun is created with a size of *x* Gigabytes, the storage array may allocate less than *x* Gigabytes for that lun, and each time it reaches a certain limit of used space, it is extended by the array until it reaches it's virtual size and cannot be extended anymore.

### What could be improved
Suppose that a VM contains a disk *disk1* on a block storage domain *sd1*, and that *disk1* is removed. Also suppose that *sd1* is built on a 20GB lun, *lun1*.

* If *lun1* is a *pre allocated* lun, then there's no reason to go and try to tell the storage array that some blocks were freed because *lun1* uses the whole 20GB anyway.
* If *lun1* is a *thinly provisioned* lun, and we could tell the storage array that some blocks were freed, it could have shrinked *lun1* so that other luns in the array could make use of those unused blocks.

This feature is about freeing (discarding) the whole disk space right before removing it.

### For whom is this feature useful
This feature is useful for users that have thinly provisioned luns and wish to reclaim space when removing a disk from a block storage domain that is built from them.


## Owner
* Idan Shaby


## Current status
* [First phase](#usage) - implemented in vdsm config file (per host) - released in oVirt 4.0.
* [Second phase](#future-plans) - implemented in the engine (per storage domain) - released in oVirt 4.1.


## General functionality and restrictions

### Under the hood

#### Using vdsm's configuration file
A new parameter was added to the *vdsm* configuration file, ***discard_enable***.<br/>
When it is *true* in a specific vdsm host, that host will issue a *blkdiscard* command on a logical volume right before removing it. That means that each disk or snapshot that this host removes, automatically triggers  it to inform the storage array that this logical volume's blocks were freed and can be used by other luns in the array.<br/>
Note that **this option will be dropped in oVirt 4.2** and thus it is not recommended to use it any more. The right way of using this feature is by configuring the storage domain in the engine's side.

#### Using engine's storage domain configuration
This feature adds a new storage domain property called ***Discard After Delete***.<br/>
If all the [restrictions](#restrictions) are met, a *blkdiscard* command will be issued on each logical volume before it is removed in two possible cases:

1. *Discard After Delete* is enabled for the relevant storage domain.<br/>
2. The disk is attached to at least one virtual machine with [*Pass Discard*](/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage.html) enabled.<br/>
The logic behind this is that if the user wanted "live" discarding, he will probably want to discard the whole disk when it is removed even if its storage domain's *Discard After Delete* property is disabled.

The consequences are the same as those from the previous section, when using vdsm configuration file. The differences between the two are:

* The configuration is per storage domain, and not per host.
* Any host in the data center is capable of issuing the *blkdiscard* command on a removed disk or snapshot.
* *Discard After Delete* cannot be enabled for unsupported storage domains, so users should know what to expect.

### Possible consumers of the discarded blocks
After a disk is removed from a block storage domain and its blocks are discarded, anything can use them:

* New and existing disks on the same storage domain (if there's enough free space in the storage domain, of course).
* New and existing disks on other storage domains that are built on luns from the same storage array.
* Other processes that use luns from the same storage array.

### Restrictions

#### The storage type
This feature is relevant only for **block** storage domains, i.e *iSCSI* and *Fibre Channel* storage domains.

#### The underlying storage
Let *lunX* be a device and *dm-X* be its corresponding dm device for a natural number X. Then *lunX* is considered to ***support discard*** iff the value of `/sys/block/dm-X/queue/discard_max_bytes` is bigger than 0 [^1].

The luns in the underlying storage must *support discard* in order for this to work.<br/>
If the underlying storage doesn't *support discard*:

* When using vdsm's configuration file - the *blkdiscard* command that *vdsm* tries to execute will fail with a log but will not break the lv removal. That is, the lv will be removed but the space will not be reclaimed.
* When using the storage domain's configuration - the *Discard After Delete* property cannot be enabled and thus disks and snapshots under that storage domain will not be discarded.

#### *Wipe After Delete* and *Discard After Delete*/*discard_enable*
These two properties are completely independent.<br/>
To understand it better, let's take a look at the flow of removing a disk from a block domain in *vdsm*:

1. If the disk's *Wipe After Delete* is enabled, then the disk is first wiped. If not, *vdsm* moves to phase 2.
2. If the the disk should be discarded (see [Under the hood](#under-the-hood)), then *vdsm* issues a *blkdiscard* command on that disk's logical volumes. If not, it moves to phase 3.
3. The disk's logical volumes are removed.


## Usage

### Using vdsm's configuration file
The administrator should set the *discard_enable* property in `/etc/vdsm/vdsm.conf` to ***true*** and then **restart the *vdsmd* service**.<br/>
The value of *discard_enable* is ***false*** by default.<br/>

### Using engine's storage domain configuration
The user should enable the *Discard After Delete* property of the relevant block storage domain.<br/>

#### GUI
The *Discard After Delete* checkbox can be found under the *"Advanced Parameters"* section in the "Manage Domain" and "New Domain" windows, right bellow the *Wipe After Delete* checkbox.

##### Manage Domain
![](/images/wiki/Manage_Domain_With_Discard_After_Delete_Bolded.png)

#### REST-API

##### Add a new block domain
```xml
POST api/storagedomains
Content-Type: application/xml

<storage_domain>
  <host id="123"/>
  <type>data</type>
  <discard_after_delete>true</discard_after_delete>
  <name>xtremio_sd</name>
  <storage>
    ...
  </storage>
</storage_domain>
```

##### Update an existing block domain
```xml
POST api/storagedomains/<storage_domain_id>
Content-Type: application/xml

<storage_domain>
  <discard_after_delete>true</discard_after_delete>
</storage_domain>
```


## Future Plans
* The support for *discard_enable* in vdsm's configuration file should be dropped in oVirt 4.2.


## Related Bugs
* Send discard when deleting virtual disks from block based storage domain to regain space in thin provisioned storage ([Bug 981626](https://bugzilla.redhat.com/show_bug.cgi?id=981626))
* Make discard configurable by a storage domain rather than a host ([Bug 1342919](https://bugzilla.redhat.com/show_bug.cgi?id=1342919))


## Related Features
* [Pass discard from guest to underlying storage](/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage.html)
* [Wipe volume using blkdiscard](/develop/release-management/features/storage/wipe-volumes-using-blkdiscard.html)


## References
[^1]: See "discard_max_bytes" in "Queue sysfs files" - [https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt](https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt)
