---
title: GlusterFS-Hyperconvergence
authors: fsimonce
wiki_title: Features/GlusterFS-Hyperconvergence
wiki_revision_count: 1
wiki_last_updated: 2015-01-21
wiki_warnings: references
---

# GlusterFS Hyperconvergence

> Hyperconvergence is a type of infrastructure system with a software-centric architecture that tightly integrates compute, storage, networking and virtualization resources and other technologies from scratch in a commodity hardware box supported by a single vendor[1].

## Owner

*   Name: [Federico Simoncelli](User:Fsimonce)
*   Email: <fsimonce@redhat.com>

## Current status

*   Target Release: 3.6
*   Status: under design and discussion.

## Background

This feature page tracks the effort of integrating oVirt virtualization and GlusterFS storage resources in single commodity boxes that can scale horizontally.

The issues identified are:

*   Brick scaling and balancing when adding storage [Bugzilla](https://bugzilla.redhat.com/1177773)
    -   Best practices on how scalding adding new hosts
*   Monitoring disks health on the hosts
    -   Best practices to handle a disk failure
*   Brick replace and balancing when a host failed [Bugzilla](https://bugzilla.redhat.com/1177775)
    -   Best practices to handle an entire host failure and replacement
*   QEMU libfapi support [Bugzilla](https://bugzilla.redhat.com/1177776)
*   Separate storage network for glusterfs traffic [Feature Page](Features/Select_Network_For_Gluster) - [Bugzilla](https://bugzilla.redhat.com/1049994)
*   Host disks management and device provisioning [Feature Page](Features/GlusterHostDiskManagement)
*   Improve UX when creating a Gluster Volume to be used as Storage Domain [Feature Page](Features/GlusterFS_Storage_Domain#Usability_enhancements_in_oVirt_3.6)
*   Data locality [Buzilla-1](https://bugzilla.redhat.com/1177790) [Bugzilla-2](https://bugzilla.redhat.com/1177791)
    -   Scheduling of disk creation: disks of the same VM on the same replica set
    -   Scheduling of the VM based on disk locality: start VM on the hosts of disks replica set
*   ovirt-node must include vdsm-gluster and gluster-server
*   Hosted-Engine deployment including the first gluster brick [Bugzilla](https://bugzilla.redhat.com/1177789)
*   Data-center power policies should be aware of hyperconverged nodes to avoid automatic shutdown for power saving

### Brick Scaling and Balancing

### QEMU libgfapi Support

### Data Locality

### Hosted Engine

## References

<references />

[1] <http://searchvirtualstorage.techtarget.com/definition/hyper-convergence>
