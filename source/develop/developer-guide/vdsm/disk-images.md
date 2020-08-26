---
title: Vdsm Disk Images
category: vdsm
authors: danken, dcaroest, vered
---

# Vdsm Disk Images

Vdsm exposes image repositories, each named "Storage Domain", which may be implemented by a local files system, an NFS export, or an LVM Virtual Group. Image comprises of 1 or more volumes.

## Volume Types

Volumes have 2 major properties:

1.  **type** - How are the bits written to the underlying volume.
    -   *raw* - means a simple raw access a write to offset X will be written on offset X
    -   *qcow2* - means that the storage will be accessed as a qcow2 image and all that this entails

2.  **allocation** - How should VDSM allocated the storage
    -   *preallocated* - VDSM will try it's best to guaranty that all the storage that was requested is allocated right away. Some storage configuration may render preallocation pointless.
    -   *sparse/thin provision* - space will be allocated for the volume as needed

|--------|--------------|-----------------------|
| |      | Preallocated | Sparse/Thin provision |
| | Raw  | \*file/block | file                  |
| |qcow2 | \*file/block | file/block            |

      *  Preallocating on file domains will cause Vdsm to write zeroes to the file.
         This might not actually preallocate on some file systems.

### Disk Type

A Virtual disk can be stored on disk using different formats. VDSM currently supports "raw" - offsets are mapped directly from guest FS to disk and ["qcow2"](http://en.wikipedia.org/wiki/Qcow#qcow2) which provides a logical mapping between blocks in guest and blocks on disk. Using qcow2 provides the ability to create snapshots as well avoid having to allocate all the storage ahead of time due to the fact that qcow2 writes linearly on disk.

### Allocation Mode

When creating a virtual disk there are normally two ways of allocating the storage blocks needed to store the data that will reside on the virtual disk -

*   allocate everything ahead of time (a.k.a preallocated) - has the benefit of having the storage blocks contiguous which can improve performance and does not require any layer that would translate logical to physical offsets (again, can be a performance improvement). This, however, comes at the cost of needing to dedicate all the potential disk space ahead of time, which is wasteful.

<!-- -->

*   allocate as you go (a.k.a sparse/thin provisioning) - similar to files in any modern file system, storage is allocated as data is being written to the file.
     Has the advantage of saving on disk space, but can cause defragmentation and have performance implications (not an issue on SSDs).

On file based storage domains, files thinly provisioned by design (the file system provides this). "Preallocation" is achieved by writing zeros to the file right after creating it which does not guarantee preallocation when using smart storage (compression / dedup would cause the zeros not to be written to disk and not to allocate the actual disk space).

On block devices thin provisioning requires either defining the LUNs as sparse on the storage array (transparent to Vdsm) or using Vdsm's Thin provisioning mechanism and formatting the volume with qcow2. Preallocated volumes are simply LVs which are created with the same size as the virtual disk. Preallocated volumes would normally not be formatted as qcow2 as it could affect performance and currently Vdsm does not take advantage of the compression and encryption capabilities so there is no advantage over raw devices.

## Snapshots

Raw and qcow2 volumes can be the basis of a snapshot but only qcow2 volumes can be snapshots themselves.

