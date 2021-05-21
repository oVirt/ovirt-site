---
title: Vdsm Storage Terminology
category: vdsm
authors:
  - abonas
  - amureini
  - danken
  - quaid
---

# Vdsm Storage Terminology

## Storage Pool

A group of domains that are managed together. Currently domains grouped and can only be managed while being a part of a pool. We plan to remove the limitations created by using storage pools.

## Storage Domain

An atomic storage unit. On file domains it's either a mount point or a folder. On block devices on the other hand this can be a group of LUNs. There is no hard limitation but it is highly recommended that all the LUNs composing a block domain are on the same physical host. This is done because when only parts of the domain disappear in case of failure there is a real issue with detecting problems.

Storage domains contains the images that the VMs will use.

Storage domains split to 2 distinct groups.

1.  *File Based Storage*
    (NFS and Local FS targets)
    -   pros:
        -   Usually takes care of safe access to files across the cluster
        -   Faster setup
    -   cons:
        -   Slower

2.  ''Block Based Storage
    (SAN Storage and in the future Local Disks)
    -   pros:
        -   Faster
    -   cons:
        -   VDSM has to do some extra work to make sure consistency
        -   Slower setup

Vdsm tries to keep feature parity between the two major types. There are a few things to note:

*   Some operations may differ in performance between the two types.
*   RAW/SPARSE images are currently only supported on file domains. This feature is implemented using sparse files and this feature currently has no equivalent in the block/LVM world.

## Image

A group of one or more volumes comprising a disk image to be used by VMs.

## Volume/Snapshot

Currently volumes and snapshots are the same. On block domain each volume is translated to an LV (logical volume) and on file domains to a separate file. Base volumes can be either raw or qcow but snapshots must be in qcow format.

