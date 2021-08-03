---
title: GlusterFS-Hyperconvergence
authors:
  - fsimonce
  - sahina
category: feature
---

# GlusterFS Hyperconvergence

> Hyperconvergence is a type of infrastructure system with a software-centric architecture that tightly integrates compute, storage, networking and virtualization resources and other technologies from scratch in a commodity hardware box supported by a single vendor[1].

## Owner

*   Name: Federico Simoncelli (Fsimonce)
*   Email: <fsimonce@redhat.com>
*   Name: Sahina Bose (sabose)
*   Email: <sabose@redhat.com>

## Current status

*   Version: 3.6.7 & above - support for HC with known caveats
*   Target Release: 4.1
*   Status: In Progress

## Overview

This feature page tracks the effort of integrating oVirt virtualization and GlusterFS storage resources in single commodity boxes that can scale horizontally.

### Architecture

Gluster and compute resources run on the same node as shown below. This setup requires a minimum of 3 hosts. The 3 host requirement is because all gluster volumes **MUST** be 3-way replica to avoid issues with storage (mainly files split-brain). Hosted engine and data storage domains are on gluster volumes created on these 3 hosts.

![HC arch](/images/wiki/hc-arch.png)

### What's available now

Since 3.6.7, users can set up a hyperconverged deployment using Gluster and oVirt. The steps to do this are covered in a separate [blog post](http://blogs-ramesh.blogspot.com/2016/01/ovirt-and-gluster-hyperconvergence.html)

*  Gluster sharding available from glusterfs 3.7.11. Sharding eliminates the issues seen while healing large files as files are now split into shards. Users need to enable sharding on gluster volumes in hyperconverged enviroments. For further information on sharding, refer [Glusterfs Sharding](http://blog.gluster.org/2015/12/introducing-shard-translator/)
*  Hosted engine deployment supports using glusterfs for storage domain [Feature Page](/develop/release-management/features/sla/self-hosted-engine-gluster-support.html)
*  Separate storage network for glusterfs traffic [Feature Page](/develop/release-management/features/gluster/select-network-for-gluster.html) - [Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1049994)
*  Host disks management and device provisioning [Feature Page](/develop/release-management/features/gluster/glusterhostdiskmanagement.html)
*  Simplified provisioning of the 3 hosts using gdeploy. See [gdeploy](http://gdeploy.readthedocs.io/) and a [Sample hc.conf](https://github.com/gluster/gdeploy/blob/2.0/examples/hc.conf)
*  Disaster recovery solution using gluster geo-replication (TBD: Feature page). Refer [DR script](https://github.com/sabose/ovirt-georep-backup)
*  Monitoring gluster storage and cluster using nagios

Since 4.0, following features are available in oVirt

*  Self-heal monitoring of gluster volumes [Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1205641)
*  Replacing bricks from UI when a host or disk has failed [Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1213309)
*  ovirt-node includes vdsm-gluster and gluster-server

### Planned features for 4.1

*   QEMU libfapi support [Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1177776)
*   Data-center power policies should be aware of hyperconverged nodes to avoid automatic shutdown for power saving

### Future plans

*   Improve UX when creating a Gluster Volume to be used as Storage Domain [Feature Page](/develop/release-management/features/storage/glusterfs-storage-domain.html#usability-enhancements-in-ovirt-36)
*   Data locality [Buzilla-1](https://bugzilla.redhat.com/show_bug.cgi?id=1177790) [Bugzilla-2](https://bugzilla.redhat.com/show_bug.cgi?id=1177791)
    -   Scheduling of disk creation: disks of the same VM on the same replica set
    -   Scheduling of the VM based on disk locality: start VM on the hosts of disks replica set

Feature pages TBD:

*   Brick scaling and balancing when adding storage [Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1177773)
    -   Best practices on how to scale by adding new hosts
*   Best practices to handle an entire host failure and replacement


## References


[1] <http://searchvirtualstorage.techtarget.com/definition/hyper-convergence>
