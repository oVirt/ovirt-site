---
title: Live storage migration between mixed domains
category: feature
authors: nsoffer
---

# Live storage migration between mixed domains

## Summary

In oVirt 3.5, a VM's disk can be moved to another storage domain while the VM is running (live storage migration). However, the system only allows moving between same domain subtypes. If the disk is located on a block-based storage domain (e.g, iSCSI, FCP), it can only be moved to another block-based storage domain. If the disk is on a file-based storage domain (e.g, NFS, POSIX, GlusterFS), it can only be moved to another file-based storage domain. Moving disks between different storage domain subtypes was only supported for shut down VMs. This feature removes this limitation, allowing live storage migration between file-based storage domains and block-based storage domains and vice versa.

## Owner

*   Name: Nir Soffer
*   Email: <nsoffer@redhat.com>

## Detailed Description

On the vdsm side, a live migration live migration starts with creation of a live snapshot on the source disk. Then the disk's structure is copied to the destination domain and the contents of the non-active volumes are mirrored.

The hard part of live storage migration is moving the active layer volumes from one domain to another, while the VM is writing to those volumes. Libvirt supports this using the virDomainBlockRebase API. This API starts a replication operation, so data written to the source volume is written also to the destination volume. When both volumes contain the same data, the block job operation can be aborted, pivoting to the new disk.

The virDomainBlockRebase API assumes that the source and the destination volumes are of the same type - `<disk type="file">` or `<disk type="block">`, so this API cannot be used to migrate a block-based disk to a file-based one, as the result will be a disk with the wrong type. Libvirt 1.2.8 introduced a new virDomainBlockCopy API, allowing the specification of the destination volume. This new API will be utilized in this oVirt feature.

Another issue on the VDSM side is extending a snapshot volume on block storage. Vdsm is monitoring the allocated space on the snapshot volume via libvirt, and when the free space on the volume reaches the high write watermark (default 512MiB), the volume is extended by one chunk (default 1GiB). When replicating block-based volumes on two block-based storage domains, the source volume is monitored, and both the destination and source volumes are extended together. The destination volume is extended first, since we cannot monitor its write allocation, and when the extension is finished, the source volume is extended. Since this slows down the extend operation, a bigger chunk size is used when doing replication (default 2GiB).

When replicating a block-based volume to a file-based domain, the source volume is monitored and extended as usual, and extending the destination volume is skipped (as file-based volumes are extended automatically by the file system).

When replicating a file-based volume to a block-based domain, the allocation of the source volume is monitored but only the destination volume is extended. Allocation of the source volume is computed using both libvirt and the getVolumeSize API.

Except for these changes, the live storage migration flow is exactly the same as is when using block to block or file to file migrations.
