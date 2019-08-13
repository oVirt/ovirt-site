---
title: Storage - oVirt workshop November 2011
category: event/workshop
authors: dannfrazier, quaid
---

When done, post these notes permanently on the wiki at [Storage - oVirt workshop November 2011](/community/events/archives/workshop/storage-workshop-november-2011/)

# Storage

*   Assumptions - disk image accessed only from one node (forget about shared images for now, will discuss later)
*   Big images - not a general purpose fs
*   centralized management (one node manages the rest, though that node can be HA)

# Guidelines

*   High level, image centered API
*   Clustersafe (though we don't currently protect against one node seeing a disk image from a VM running on another node)
*   High performance (not in data path)
*   Highly available
    -   no single pof
    -   continues working in the absence of the manager
*   Backing store agnostic

## Storage Domain

*   Standalone entity
*   Stores the images and assocated metadata (but not vms)
*   Only true persistent storage for VDSM

## Domain Classes

*   Data
    -   Master (will get to that)
*   ISO (NFS only) "abomination"
*   Backup (NFS only): export domain - used to move disk images around. exists due to "wrong design decision" called storage pool
*   Domain classes are planned for deprecation

## Domain Types

*   File Domains (NFS, local dir) - will be lustre or other shared filesystems
    -   Use file system features for segmentation
    -   Use file system for synchronizing access
*   Block Domains (iSCSI, FCP, FCoE, SAS, ...): we managed software iSCSI luns for you
    -   Use LVM for segmentation
    -   Use reserved space to ensure writes do not overlap
    -   Very specialized use of LVM
        -   we introduced clustering layer on top of it.
        -   unique to oVirt
    -   Sparse files
    -   Better image manipulation capabilities
        -   when we delete an image we guarnatee blocks are zero'd out (get that for free w/ fs-stored files)
            -   we don't release until we zero; we don't pre-zero (VMWare does - performance hit while running for them, just while deleting for us)
    -   Volumes and metadata are files
    -   1:1 Mapping between domain and dir / NFS export
        -   Cannot span across multiple exports
    -   NFS - Different error handling logic for data path and control path
        -   When a VM issues IO to its disk over NFS I/O might hang.
        -   we use soft mounts (unorthodox)
        -   When VM gets an -EIO (hung mount) it suspends VM

# Block Domains

*   Mail box
*   Thin provisioning
*   Slower image manipulation
    -   Everything done in 1G allocations
*   Devices managed by device-mapper & multipath
*   Domain is a VG
    -   store image on single LV
*   Metadata is stored in a single LV and in lvm tags- goes back to scalability issues w/ LVM. Minimal allocation size of a LV is 128 MB, can't create one for each to store metadata.
*   Volumes are LVs
    -   Use QCOW in files \*and\* block devices - directly over raw device

# Storage Pool (will be deprecated)

*   Original thinking is that we'd wantt o manage all of our disk images in a single place even if they span storage domains
*   Can't mix storage pools in data centers

Q: Can you tune nfs/fc settings/striping etc A: No. mount options are configurable at host level, will hopefully go into oVirt image

# Master Domain

*   Used to store:
    -   Pool metadata
    -   Backup of OVFs (treated as blobs)
    -   Async tasks persistent data)
    -   Each QCOW layer is a separate volume on the VG
*   Contains the clustered lock for the pool
    -   Safe lease mechanism used to prevent multiple masters; exists at pool level; only this host can create new volumes

= Storage Pool Manager (SPM) A role assigned to one host in a data center granting it sole authority over:

*   Creation, deletion, an dmanipulation of virtula disk images, snapshots and templates
    -   Templates: you can create on VM as a golden image and provision to multiple VMs (QCOW layers)
*   Allocation of storage for sparse block devices (on SAN)
    -   Thin provisinoing (see below)
*   Single metadata writer:
    -   SPM lease mechanism (Chockler and Malkhi 2004, Light-Weight Leases for Storage-Cnntric Coordination)
    -   Storage-centric mailbox
*   This role can be migrated to any host in data center

# Thin Provisioning

Over-commitment is a storage function which allows oVirt to loically allocate more storage than is physically avialable.

*   Generally vitual machines use much less storage than what has been defined for them
*   Over-commitment allows a vm to operate completely unaware of the resources that are actually available
*   Uses QCOW over LVM block devices
    -   QCOW will always allocate space sequentially. Once it has reached a certian threshold, we can behind teh scenes extend the logical volume. Monitored using polling; if we check too late, -ENOSPC to QEMU, VM automatically pauses in that case. Causes event to be sent to the monitor. Engine notifies SPM via a mailbox on another logical volume, SPM extends, returns response in mailbox, host refreshes device-mapper, then unpauses VM (if it was paused)
    -   Qemu supports API call that lets you know highest-offest written to on target device

Q: Why not use a filesystem? A: It doesn't work at these scales Q: why mailbox? A: only guaranteed communication mechanism across domains is storage

# Roadmap

*   SANLock: mechanism to take storage-centric leases, but not as slow as safeleases. sub-second, to take leases on disk images. Integrated into libvirt.
    -   SANLock is a misnomer; will work over files
*   SDM: get rid of storage pool concept and have storage domain manager.
    -   You will then be ablet o have a data center where you can mix/match storage domains
*   Live snapshots
*   Live storage migration (block copy/streaming)
*   Direct LUN - today there's no way for a VM to use this directly; patches should come soon
*   Support any shared file system (not just NFS)
*   NFS v4
*   NFS Hardmounts
*   Offload (snapshots, lun provisinion, thin provisioning, etc)
*   We want to discover capabilities of storage (can they find better snapshotting, etc). Want to have a common linux layer for that e.g. libstorage (current name, could change)
*   Image handling
    -   Image Manager
    -   Allocation policy (Space/Performance)
*   Dynamic Connection Management
*   Liveness monitoring through storage
*   So much more

[Category: Workshop November 2011](Category: Workshop November 2011)
