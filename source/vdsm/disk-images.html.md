---
title: Vdsm Disk Images
category: vdsm
authors: danken, dcaroest, vered
wiki_category: Vdsm
wiki_title: Vdsm Disk Images
wiki_revision_count: 6
wiki_last_updated: 2013-08-02
---

# Vdsm Disk Images

Vdsm exposes image repositories, each named "Storage Domain", which may be implemented by a local files system, an NFS export, or an LVM Virtual Group. Image comprises of 1 or more volumes.

## Volume Types

Volumes have 2 major properties:

1.  **type** - How are the bits written to the underlying volume.
    -   *raw* - means a simple raw access a write to offset X will be written on offset X
    -   *qcow2* - means that the storage will be accessed as a qcow2 image and all that this entails

2.  **allocation** - How should VDSM allocated the storage
    -   *preallocated* - VDSM will try it's best to guaranty that the all the storage that was requested. Some storage configuration may render preallocation pointless.
    -   *sparse* - space will be allocated for the volume as needed

|--------|--------------|------------|
| |      | Preallocated | Sparse     |
| | Raw  | \*file/block | file       |
| |qcow2 | \*file/block | file/block |

      *  Preallocating on file domains will cause Vdsm to write zeroes to the file.
         This might not actually preallocate on some file system.

## Snapshots

Raw and qcow2 volumes can be the basis of a snapshot but only qcow2 volumes can be snapshots themselves.

<Category:Vdsm>
