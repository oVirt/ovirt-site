---
title: 4k drive support
category: feature
authors: dchaplyg
feature_name: 4k drive support
feature_modules: vdsm
feature_status: Planning
---

# 4k drive support

# Summary

VDSM assumes, that 512 bytes is a minimally accessible block on the storage device, which can be written or read atomically. That was true for a long time, but now most of the storage devices changed their block size to the 4096 bytes (4 kilobytes). It is still compatible with VDSM, cause while we are requesting 512 atomic read or write, underlying storage will atomically read 4096 bytes, throw away 3584 bytes and return just 512. As it still acts same way, it has no impact on the VDSM. 

Unfortunately, some 4k block storage devices either refuse to read/write smaller blocks atomically (some SAN appliances) or have a performance impact while emulating 512 bytes block device (like VDO). 

Therefore without 4k block device support oVirt either can't use those devices as a storage domain or will have performance degradation on those domains.

## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)
*   Email: <dchaplyg@redhat.com>

## Current status

*   Target Release: 4.3
*   Status: Prototyping
*   Last updated: August 22, 2018

# Implementation details

VDSM heavily relies on 512 block support and it is hardcoded to a lots of places.

The general approach is to refactor all block size dependent code to use block size from the storage domain, while keeping it hardcoded to 512 bytes in it and in a second step, implement block size detection at the SD level and replace hardcoded value with actual value.

Subsystem specific notes are below:

## Sanlock

Sanlock is used by oVirt for locking and fencing shared resources. Latest released sanlock have native support for 4k devices, but it comes with price of great disk space overhead. 

Sanlock is planned to be extended with new on-disk formats, incluging:

 - ALIGN1M | SECTOR512: max_hosts 2000
 - ALIGN1M | SECTOR4K:  max_hosts 250
 - ALIGN2M | SECTOR4K:  max_hosts 500
 - ALIGN4M | SECTOR4K:  max_hosts 1000
 - ALIGN8M | SECTOR4K:  max_hosts 2000

Thus VDSM may use ALIGN1M | SECTOR512 format for 512 bytes devices, consuming 1MB for each sanlock file. On the 4k block devices VDSM could use ALIGN1M | SECTOR4K or ALIGN2M | SECTOR4K, thus consuming either 1MB or 2MB for each sanlock file. In case of ALIGN2M | SECTOR4K usage, all lockspace files will be bigger, comparing to 512 bytes format. 

With patch [1] it will be possible, to specify desired alignment, but it is not yet available in the python bindings (needs to be implemented).

## Blocksize detection

There is no reliable way to detect size of the logical block of the underlying device in case of a network filesystem. Both NFS (v3, v4, v4.1, v4.2) and Ceph have no aligment restrictions enforced, therefore they can't be probed for a mimally allowed block IO size. 

Therefore desired block size for a new storage domain must be specified explicitly, via oVirt UI or API during storage domain creation. StorageDomain.create verb needs to be extended with that information (actually a StorageDomainCreateArguments type needs to be extended)

## Metadata

VDSM needs to know size of block of the Storage domain and the best way to store it is metadata. Metadata for block device backed domains already includes corresponding fields:

* DMDK_LOGBLKSIZE
* DMDK_PHYBLKSIZE

But metadata for the filesystem backed storage domains do not have those fields.  Block/FS domains also differ in two other fields:

* DMDK_VGUUID - at block backed SD
* REMOTE_PATH - at filesystem backed SD

As those fields are unused, new version of storage domains needs to implemented, removing unused fields from the metadata and adding block size fields to the filesystems based SD, thus unifying metadata.

For readability reasons DMDK_LOGBLKSIZE can be renamed to just BLOCK_SIZE.

This also means, that manifests for both types of domains should include block size field. Block based domains already do that, but filesystem domains do not

## Locking

VDSM uses sanlock for all types of locking. At the moment domain metadata consists of following lock volumes:

* ids - sanlock delta lease
* leases - volume leases
* xleases - external leases

Those lease volumes use ~3.5GB for 512 block devices and will use ~25GB for 4096 block devices (worst case). Because of that huge overhead, a change to the locking scheme is proposed.

### xleases

Sanlock already supports add/remove/locate leases, based on vdsm index code, thus making VDSM implementation unneeded. Those new APIs needs to be implemented in Python bindings and VDSM should be provided with new APIs, that will be using those bindings. After that new storage domains could be switched to that new external leases

### Dynamic locks

With new external leases and new sanlock on-disk formats a new locking scheme, using dynamic lockspace allocations is proposed:

* VM leases will be covered by new external leases (create exlease per vm lease)
* Job leases will be covered by new external leases (Create xlease per job/volume when starting a job)
* SPM lease needs to be moved to new external lease
* HostedEngine volume lease should be switched to new external lease
* Leases volume and old xleases volume will be dropped

With that approach we may approximately need:

* 1500 leases (1 lease per vm)
* 50 concurrent jobs with leases

This will be using about ~1.55Gb for 512 bytes block devices or 4096 bytes block devices with 250 hosts per cluster or ~3.1GB for 4096 block devices with 500 hosts per cluster.

## Volumes

BlockVolume and FileVolume implementations must use block size from the StorageDomain. That should be done in two steps - first move implementations to use hardcoded block size at StorageDomain and after that make block size adjustable at the StorageDomain side. To achieve that, Volume create must be moved to the StorageDomain, where it belongs.

Image class also heavily relies on hardcoded block size. We can solve that by eliminating Image class at all and implementing it's functionality as a set of jobs under sdm/api

## Mailboxes

Desipte mailboxes code uses BLOCK_SIZE constant, it seems to be agnostic to actual BLOCK_SIZE and doesn't requires any modifications.

We may need to replace 512 byte BLOCK_SIZE here with 4096 byte IO to be sure, that we will never issue an unaligned IO.

# Implementation plan

## Sanlock

* Implement new on-disk formats
* Add format/alignment selectors to the sanlock python bindings
* Add new indexing APIs to the sanlock python bindings

## VDSM 

* Get rid of BLOCK_SIZE constant by moving it to the SD base class and making it a (read-only) property of that class
* Make a quick PoC, proving, that 4k domain can be implemented
* Reimplement Image class as a set of jobs under sdm/api
* Move volume creation code to the StorageDomain 
* Implement new external lease APIs
* Make mailboxes 4k friendly
--- at that stage we switch to the new storage domain format ---
* Create new storage domain metadata format (see above) for V5 domains
* Migrate to the new locking scheme (do we need a locking API, that will hide differences accessing old/new domains)
* Add block size to the StorageDomain.create verb and make StorageDomain block_size property writable
* Check, that 4k block support is working.

## HostedEngine

TBD

## Engine

Storage domain creation dialog should be extended with 512/4096 block size selector. In case of well known 4096 only deployments (hyperconverged on top of VDO for example), 4096 should be preselected and selector must be disabled.

oVirt API should accept desired block size in a StorageDomain creation endpoint.

# Benefit to oVirt

* Support for 4k only SAN
* Support for VDO native block size
* Support 4k based file based storage

# Open issues

* [BUG-1592916: (https://bugzilla.redhat.com/1592916) -  Support device block size of 4096 bytes for file based storage domains]

# External links
[1] https://pagure.io/sanlock/c/d5e4def0d087dda942e7ac4330b288715603cc61?branch=master