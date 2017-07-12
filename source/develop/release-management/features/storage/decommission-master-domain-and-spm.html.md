---
title: Decommission Master Domain and SPM
category: feature
authors: aglitke, fsimonce, sandrobonazzola
---

# Decommission Master Domain and SPM

## Summary

By introducing advanced flows (live snapshots, live storage migration, live merge) engine orchestration and VDSM commands implementation grew in complexity because of the SPM-HSM roles differences. In addition the concept of Storage Pool (initially introduced to simplify cross-domain operations) became an obstacle in managing and scaling storage domains.

The goal of this feature is to remove the SPM role and the Storage Pool concept from the oVirt storage subsystem. As a consequence the Master Domain and its special content will disappear as well (pool metadata, asynchronous tasks persistency and ovf backups) simplifing the implementation and getting rid of several known problems. A set of [New Storage API](/develop/release-management/features/storage/decommission-master-domain-and-spm/#new-storage-api) will be introduced to address the new architecture (no task persistency and short-lived sanlock metadata lock).

More information:

*   Remove Master Domain and File-System: stop designating a master domain and maintaining a file-system for asynchronous tasks peristency and ovf backups
    -   [Decommission Storage Pool Metadata](/develop/release-management/features/storage/storagepool-metadata-removal/)
    -   [Store OVF on Regular Volumes](/develop/release-management/features/storage/ovfonanydomain/)
    -   Drop task persistency with the [New Storage API](/develop/release-management/features/storage/decommission-master-domain-and-spm/#new-storage-api)
*   Remove SPM: the SPM role is replaced with a short-lived domain metadata lock on the relevant storage domain(s)
    -   [New Storage API](/develop/release-management/features/storage/decommission-master-domain-and-spm/#new-storage-api)

## Owner

*   Name: Federico Simoncelli (Fsimonce)
*   Email: <fsimonce@redhat.com>
*   Name: Liron Aravot (Laravot)
*   Email: <laravot@redhat.com>
*   Name: Adam Litke (Aglitke)
*   Email: <alitke@redhat.com>
*   PM Requirements : Scott Herold
*   Email: <sherold@redhat.com>

## Current status

*   Target Release: 4.0
*   Status: in development.

## Background

## Connect Storage Pool

     connectStoragePool(spUUID, hostID, msdUUID, masterVersion, domainsMap)

For backward compatibility with running VMs we must maintain the volume links in /rhev/data-center (and also to support live migration without any additional change). The only purpose to keep this API is to communicate the list of domains to monitor and the spUUID used to maintain the symlinks (/rhev/data-center/spUUID).

VDSM will allow a connectStoragePool request using a blank msdUUID:

     msdUUID = 00000000-0000-0000-0000-000000000000
     masterVersion = 0

In this case:

*   connectStoragePool with blank msdUUID will fail if the host is the SPM (incompatible with this request)
*   in this state the host will refuse to become an SPM
*   the mailbox won't be active (sending/receiving)
*   all the major flows involving the master domain will be prevented (masterMigrate, reconstructMaster, etc.)
*   the refresh flow will still be valid and the links will be maintained (except for the masterd symlink)

This API may be removed in the future but at the moment it's not strictly related to (nor required by) the Master Domain and SPM removal. In order to allow incremental achievable changes connectStoragePool will be addressed in the future with a solution that also covers running VMs.

## New Task Infrastructure and the taskUUID Argument

The old SPM verbs are tightly coupled with the Asynchronous Tasks persisted on the master domain. In fact all the volume operations (creation, deletion, etc.) are updating their status in the master domain in order to rollback when interrupted. The new tasks infrastructure won't provide any persistency for the ongoing Asynchronous Tasks, therefore the new storage API should be designed in such a way that all operations when interrupted should leave garbage that is easy to identify and clean up.

Relevant RFE:

*   <https://bugzilla.redhat.com/show_bug.cgi?id=1080379>
*   <https://bugzilla.redhat.com/show_bug.cgi?id=1080384>

In the future when JSON-RPC will be introduced all the incoming requests from the engine will automatically have an UUID that can be used to identify asynchronous operations.

## New Storage API

Goals of the new storage API are:

*   **Splitting Metadata and Data Operations** (allowing to decouple short metadata changes and long data operations)
*   **Replace SPM with a Short-Lived Domain Metadata Lock** (non-atomic metadata changes will require a domain metadata lock)
*   **Consolidate API** (API should be minimal and allow composition for complex flows)
*   **No Task Peristency** (storage operations must drop the old tasks persistency)
*   **Garbage Collection** (leftovers of partial operations should be easy to identify and collect)

The old API commands that should be re-implemented are:

VDSM API Changes

New API

cloneImageStructure

multiple createVolumeContainer

copyImage

multiple createVolumeContainer and copyVolumeData (similar to cloneImageStructure)

createVolume

createVolumeContainer + allocateVolume (to preallocate a volume when needed)

deleteImage

multiple removeVolume + wipeVolume (to post-zero the volume)

deleteVolume

removeVolume

downloadImage

createVolumeContainer + copyVolumeData

downloadImageFromStream

createVolumeContainer + copyVolumeData

extendVolumeSize

extendVolumeSize

mergeSnapshots

createVolumeContainer + mergeSnapshotsV2

moveImage

N/A (to be removed, engine will use copyImage + deleteImage)

moveMultipleImages

N/A (to be removed, engine will use copyImage + deleteImage)

syncImageData

multiple copyVolumeData

uploadImage

copyVolumeData

### Create Volume

     createVolumeContainer(sdUUID, imgUUID, size, volFormat, diskType, volUUID, desc, srcImgUUID, srcVolUUID)

**Parameters:**

*   **sdUUID**, **imgUUID**, **volUUID**: domain, image and volume uuids
*   **size**: The intended capacity of the new volume (in sectors)
*   **volFormat**: Request either cow (4) or raw (5)
*   **diskType**: (Legacy) Set the type of disk to be created: unknown (0), system (1), data (2), shared (3), swap (4), temporary (5)
*   **desc**: Set a volume description
*   **srcImgUUID**, **srcVolUUID**: parent image and volume uuids

This (synchronous) API will allow to create a volume in a storage domain. The operation mostly involves metadata changes and it should leave the volume fully prepared and ready to be used or in an inconsistent way easily identifiable from the garbage collector.

Overview of the flow on block domains:

*   create a new volume (marked as not-ready)
*   allocate the new volume metadata and lease area
*   initialize the qcow2 format (when needed)
*   mark the parent as internal volume
*   mark the volume as ready

Overview of the flow on file domains:

*   prepare a new image directory (when needed)
*   hard-link the template volume, metadata and lease files (when needed)
*   create a new volume (marked as not-ready)
*   create the new volume metadata and lease files
*   initialize the qcow2 format (when needed)
*   mark the parent as internal volume
*   mark the volume as ready

**Completion check**: on success getVolumeInfo will return the new volume info (on failure VolumeDoesNotExist will be raised)

Garbage collection (for unfinished volumes):

*   for files use two simple garbage collectors
*   volumes that are marked as not-ready will be removed
*   unmark the parent as internal volume (when needed)

### Delete Volumes

     removeVolumes(sdUUID, imgUUID, volumeList)

**Parameters:**

*   **sdUUID**, **imgUUID**, **volumeList**: domain UUID, image UUID, and volume UUID list

This (synchronous) API will allow to delete one or more volumes from an image. The volume list must be in ascendant order (beginning with the leaf and including additional consecutive volumes as desired).

To allow retry of a partially-completed compound delete without requiring engine to poll for what has already been removed, this API will not fail when volumeList contains volume UUIDs that do not belong to the image.

Overview of the flow on file and block domains:

*   Rename the volume using a special removing postfix
*   Invoke the garbage collector which will:
    -   mark the parent as leaf volume or update the chain (e.g. live merge case)
    -   remove the volume metadata and lease files
    -   remove the volume

**Completion check**: on success getVolumeInfo will raise VolumeDoesNotExist (on failure the volume info are returned)

     removeImage(sdUUID, imgUUID)

**Parameters:**

*   **sdUUID**, **imgUUID**: domain UUID, image UUID

This (synchronous) API will cause an image to be removed from a storage domain. All volumes are removed (as if removeVolumes were called with the complete list of volumes in the image). On error, some volumes may have been removed.

**Completion check**: on success getImagesList will not contain *imgUUID*

### Allocate Volume

     allocateVolume(sdUUID, imgUUID, volUUID, wipeData)

**Parameters:**

*   **sdUUID**, **imgUUID**, **volUUID**: domain, image and volume uuids
*   **wipeData**: whether to allocate the volume wiping the data (faster) or maintaining it (slower)

This call is used to preallocate the volume area (relevant only for file domains and raw volumes). In conjunction with createVolumeV2 this API can be used to implement the old behavior of createVolume with preallocated=True.

In the future it may be implemented using fallocate(2):

> fallocate() allows the caller to directly manipulate the allocated disk space for the file referred to by fd for the byte range starting at offset and continuing for len bytes. After a successful call, subsequent writes into this range are guaranteed not to fail because of lack of disk space.

Since fallocate is currently not supported on NFS (it may be introduced in v4.2) the implementation will rely on the old behavior of writing zeroes to the volume.

Overview of the flow on file domains:

*   allocate the volume
*   mark the volume as preallocated (for backward compatibility)

**Completion check**: getVolumeInfo will report the volume as preallocated

It seems that to preserve the fallocate/allocateVolume semantic we should not simply write zeroes, but actually preallocate the volume space maintaining all the previous data (read/write). This behavior may be slow for new created volumes that we want just to preallocate with zeroes. For this reason I suggest to add a **wipeData** flag in the API that eventually can be used to specify to delete the data in the volume.

### Isolate Volumes

     isolateVolumes(sdUUID, srcImgUUID, dstImgUUID, volumeList)

**Parameters:**

*   **sdUUID**, **srcImgUUID**, **dstImgUUID**, **volumeList**: domain UUID, source image UUID, destination image UUID, and volume UUID list

This (synchronous) API allows you to move one or more volumes into a new image in order to isolate them during a subsequent operation (eg. wipeVolume). The volume list must be in ascendant order (beginning with the leaf and including additional consecutive volumes as desired).

To allow retry of a partially-completed compound call without requiring engine to poll for what has already been isolated, this API will skip volumes which already belong to the destination image.

Overview of the flow on block domains:

*   Update the LV tag for each volume to set the new imgUUID

Overview of the flow in fileDomains:

*   Check if the image dir exists
    -   If so, it must only contain volumes mentioned in volumeList
    -   If not, create the image dir
*   Hardlink the metadata, lease, and volume files into the new image
*   Call removeVolumes to remove the volume from the original image

### Wipe Volume

     wipeVolume(sdUUID, imgUUID, volUUID)

**Parameters:**

*   **sdUUID**, **imgUUID**, **volUUID**: domain, image and volume uuids

Wipe volume is used to remove the data stored in the volume (mostly for security reasons, relevant for block domains).

In conjunction with isolateVolumes, this API can be used to replicate the old behavior of deleteVolume(..., postZero=True).

Eventually a set of different wiping algorithms can be supported similarly to [virStorageVolWipeAlgorithm](http://libvirt.org/html/libvirt-libvirt.html#virStorageVolWipeAlgorithm)

|------------|----------------------------------------------------------------------------------------|
| ZERO       | 1-pass, all zeroes                                                                     |
| NNSA       | 4-pass NNSA Policy Letter NAP-14.1-C (XVI-8)                                           |
| DOD        | 4-pass DoD 5220.22-M section 8-306 procedure                                           |
| ALG_BSI   | 9-pass method recommended by the German Center of Security in Information Technologies |
| GUTMANN    | The canonical 35-pass sequence                                                         |
| SCHNEIER   | 7-pass method described by Bruce Schneier in "Applied Cryptography" (1996)             |
| PFITZNER7  | 7-pass random                                                                          |
| PFITZNER33 | 33-pass random                                                                         |
| RANDOM     | 1-pass random                                                                          |

Overview of the flow on block domains (file domains are not relevant):

*   Acquire the volume lease
*   mark volume as illegal
*   wipe the content of the volume
*   rebuild the qcow2 header (when needed)
*   mark volume as legal
*   Release the volume lease

**Completion check**: getVolumeInfo will report the volume as legal

Provided some assumptions and flags this API may be unified with allocateVolume. At the moment given the two different semantics it makes sense to keep them separated.

### Copy Volume

     copyVolumeData(srcImage, dstImage, collapsed)

**Parameters:**

*   **srcImage**, **dstImage**: source and destination items to copy (luns, vdsm images, remote images)
*   **collapsed**: whether the source volume chain should be collapsed or not

This API will allow copy between different image repositories. The parameters srcImage and dstImage describe

     lunItem = {
       'type': 'lun',
       'guid': ,
     }

     vdsmImageItem = {
       'type': 'image',
       'sduuid': ,
       'imguuid': ,
       'voluuid': ,
     }

     httpImageItem = {
       'type': 'http',
       'url': ,
       'headers': ,
     }

This API will cover the old copyImage, moveImage, downloadImage, uploadImage and cloneImageStructure/syncImageData.

Overview of the flow on file and block domains:

*   mark the volume as illegal
*   copy the data from source to destination
*   mark the volume as legal

**Completion check**: getVolumeInfo will report the volume as legal and unlocked

At the moment this API assumes that the destination container should be already prepared (e.g. destination volume was created). This behavior allows cloneImageStructure to be reimplemented with a series of createVolumeContainer and syncImageData with a series of (eventually concurrent) copyVolumeData requests.

### Extend Volume Size

     extendVolumeSize(sdUUID, imgUUID, volUUID, size)

**Parameters:**

*   **sdUUID**, **imgUUID**, **volUUID**: domain, image and volume uuids
*   **size**: new volume size in bytes

### Merge Snapshots

**Parameters:**

     mergeSnapshotsV2(sdUUID, imgUUID, ancVolUUID, sucVolUUID, postZero)

*   **sdUUID**, **imgUUID**: domain and image uuids
*   **ancVolUUID'**, **sucVolUUID**: ancestor and successur volumes uuids

## New Storage API Status

VDSM API Status

Block Domains

File Domains

createVolumeContainer style="background-color: yellow;" Completed - Requires Testing style="background-color: yellow;" Completed - Requires Testing

removeVolume style="background-color: yellow;" Completed - Requires Testing style="background-color: yellow;" Completed - Requires Testing

allocateVolume style="background-color: lightgreen;" N/A -

wipeVolume - style="background-color: lightgreen;" N/A

copyVolumeData (VDSM images) style="background-color: yellow;" Completed - Requires Testing style="background-color: yellow;" Completed - Requires Testing

copyVolumeData (Glance images) - -

extendVolumeSize - -

mergeSnapshotsV2 - -

Engine Flows Status

VDSM API

Engine Flow Status

AddImageFromScratchCommand createVolumeContainer -

HibernateVmCommand createVolumeContainer -

LiveSnapshotMemoryImageBuilder createVolumeContainer -

DestroyImageCommand removeVolume -

RestoreFromSnapshotCommand removeVolume -

CopyImageGroupCommand copyVolumeData -

CreateCloneOfTemplateCommand copyVolumeData -

CreateImageTemplateCommand copyVolumeData -

ImportRepoImageCopyTaskHandler copyVolumeData -

ExportRepoImageCommand copyVolumeData -

CreateSnapshotCommand createVolumeContainer -

RemoveSnapshotSingleDiskCommand mergeSnapshotsV2 -

ActivateStorageDomainCommand (none, related to connectStoragePool) -

DeactivateStorageDomainCommand (none, related to connectStoragePool)) -

RemoveImageCommand removeVolume -

RemoveTemplateSnapshotCommand removeVolume -

VmCommand (removeMemoryVolumes) removeVolume -

CreateImagePlaceholderTaskHandler createVolumeContainer, removeVolume -

VmReplicateDiskFinishTaskHandler removeVolume -

MemoryImageRemover removeVolume -

VmReplicateDiskStartTaskHandler copyVolumeData -

ExtendImageSizeCommand extendVolumeSize -
