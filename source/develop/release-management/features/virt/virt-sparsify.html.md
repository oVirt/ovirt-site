---
title: virt-sparsify
authors: doron, shaharh, smelamud
wiki_title: Features/virt-sparsify
wiki_revision_count: 6
wiki_last_updated: 2017-02-06
feature_name: Sparsify VM disks
feature_modules: engine,vdsm
feature_status: Released
---

# Virt-Sparsify

## Summary

This feature enables the user to run [virt-sparsify](http://libguestfs.org/virt-sparsify.1.html) utility on the virtual machine disks. `virt-sparsify` removes unused space from a disk image and returns it to storage.

## Owner

*   Name: Shmuel Melamud
*   Email: <smelamud@redhat.com>

## Detailed Design

### VDSM

Previously VDSM supported `virt-sparsify` in a simple form that created a temporary disk. With the new approach, a temporary disk, location, and extra disk space are not needed, thanks to in-place operation mode of `virt-sparsify`.

The new `SDM.sparsify_volume` verb was created that runs `virt-sparsify` asynchronously using storage jobs mechanism. Storage jobs allow the operation to be performed on any host.

Since `virt-sparsify` tool cannot leave the volume in corrupted state, there is no need to mark the volume as ILLEGAL before running the tool. Otherwise, if the storage domain becomes unavailable during the operation, the volume will be left in ILLEGAL state and its futher usage will be impossible.

### Engine

Added `SparsifyImageCommand` to sparsify the given disk image. This command checks all prerequisites, locks the disk and invokes `SparsifyImageVDSCommand`. `SparsifyImageVDSCommand` uses `SDM.sparsify_inplace` VDSM API call to perform the actual work.

In the REST API, added the `sparsify` method to `DiskService` that invokes `SparsifyImageCommand` on the disk.

### UI

Added "Sparsify" button to Disks subtab of Virtual Machines main tab. This button opens a confirmation dialog to approve sparsification operation and, after the operation is confirmed, invokes SparsifyImageCommand for the disk selected.

### Limitations

*   Only the leaf volume of the image (the active snapshot) can be sparsified.
*   If some file existed in previous snapshots and was deleted in the latest snapshot, its space cannot be freed and returned to the storage. In such situations the virtual disk may even become slightly bigger (maximum 0.01% of its size), because sparsification may need more space in the disk's metadata. To sparsify effectively, merge all snapshots before sparsification.
*   The disk cannot have derived disks.
*   If the disk is attached to a VM, it must be down.
*   Direct LUNs cannot be sparsified.
*   Cinder disks cannot be sparsified.
*   Pre-allocated disks cannot be sparsified. `virt-sparsify` works on pre-allocated disks, but its usage is not justified for this case. User chooses pre-allocated option if she needs better performance, because no additional allocation and no fragmentation will occur when the disk is used. Deallocating some clusters as result of sparsification will overturn this advantage. If user wants to save space at cost of some performance decrease, she can select thin-provisioned option.
*   Disks on NFS storage may be sparsified only if NFS version >= 4.2.

## Future development

*   Display the actual size of disks (currently we display only the virtual size).
*   Add indication that disk needs to be sparsified, if amount of unused space passes a defined threshold.
*   Added a user-configurable periodic job that sparsifies disks when needed.

## Current status

*   vdsm: Released
*   engine: Released
*   UI: Released
