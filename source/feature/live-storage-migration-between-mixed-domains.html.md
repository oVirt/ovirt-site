---
title: Live storage migration between mixed domains
category: feature
authors: nsoffer
wiki_category: Feature
wiki_title: Features/Live storage migration between mixed domains
wiki_revision_count: 2
wiki_last_updated: 2015-08-03
feature_name: Live storage migration between mixed domains
feature_modules: engine,vdsm
feature_status: XXX
---

# Live storage migration between mixed domains

### Summary

In oVirt 3.5, we can move vm disk to another storage domain while the vm is running (live storage migration). However the system allows only moving between same domain types. If the disk is on block-based storage domain (e.g, iSCSI), you can move only only to another block-based storage domain (e.g, iSCSI, FCP). If the disk is on file-based storage domain (e.g, NFS), you can move it to other file-based storage domain. To move disk between different types of storage domains, the vm must be shutdown. This feature remove this limitation, allowing live storage migration between file-based storage domains and block-based storage domains.

### Owner

*   Name: [ Nir Soffer](User:Nsoffer)
*   Email: <nsoffer@redhat.com>

### Detailed Description

On the vdsm side, a live migration live migration starts with creation of a live snapshot on the source disk. Then we copy the disk structure to the destination domain, start copying the internal volumes, and start miroring the snaphot on the source and the destination, which is not the active layer volume.

The hard part of live storage migration is moving the active layer volumes from one domain to another, while the vm is writing to the volume. Libvirt support this using the virDomainBlockRebase api. This api starts a replication operation, so data written to the source volume is written also the the destination volume. When both volumes contains the same data, we can ask Libvirt to abort the block job operation, pivoting to the new disk.

virDomainBlockRebase api assume that the source and the destination volumes are of the same type <disk type="file"> or <disk type="block">. Using this api we cannot migrate disk on block-based disk to file-based disk, because the result will be a disk with the wrong type. In Libvirt 1.2.8, a new virDomainBlockCopy api was added, allowing sepcfication of the destination volume. We are going to use this api to migrated the active layer volume.

Another issue on the vdsm side is extending snapshot volume on block storage. Vdsm is monitoring the allocatted space on the snapshot volume via Libvirt, and when the free space on the volume reach the high write watermark (default 512MiB), the volume is extended by one chunk (default 1GiB). When replicating block-based volumes on two block-based storage domains, we are monitoing the source volume, and extend both the destination and source volumes. We extend first the destination volume, since we cannot monitor its write allocation, and when the extension is finished, we extend the source volume. Since this slow down the extend operation, we are using bigger chunk size when doing replication (default 2GiB).

When replicating block-based volume to file-based domain, we will monitor and extend the source volume as usual, and skip extending of the destination (file-based volumes are extended automatically by the file system).

When replicating file-based volume to block based domain, we will monitor the allocation of the source volume and extend only the destination volume. Allocation of the source volume is computed using both Libvirt and getVolumeSize api.

Except these changes, live storage migration flow is exactly the same as is when using block to block or file to file migrations.

### Benefit to oVirt

### Dependencies / Related Features

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
