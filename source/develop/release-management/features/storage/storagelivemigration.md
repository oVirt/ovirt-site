---
title: StorageLiveMigration
authors:
  - abaron
  - fsimonce
  - amureini
  - derez
category: feature
---

# Storage Live Migration

Live block migration is the operation in charge of moving a running VM and its disks from one storage domain to another.

## GUI

No major GUI modifications are required. The action to move a VM from one storage to another should be enabled also when the VM is running, in which case the engine will issue a live block migration.

![](/images/wiki/StorageLiveMigrationGUI.png)

## Pre-Copy, Post-Copy and Mirrored-Snapshot

*   **Pre-Copy:** copy all the internal volumes and then live copy the leaf volume, when the task is completed live migrate the VM.
    -   **Pros:** safer and simpler to manage in the oVirt engine and VDSM.
    -   **Cons:** if the snapshots are no longer needed then a lot of data is copied needlessly. NB. Not implemented upstream yet.
*   **Post-Copy:** live migrate the VM with a live snapshot to the new domain, copy the internal volumes and when the task is completed switch the leaf backing file.
    -   **Pros:** better approach for HA/load balancing.
    -   **Cons:** complex management in the oVirt engine and VDSM. Disk is split across multiple domains.
*   **Mirrored-Snapshot:** mirror a new live snapshot on both source and destination, copy the parent volume to the destination and when completed switch to the new image.
    -   **Pros:** no need to implement cross-domain volume chains in VDSM.

Reference: [<http://wiki.qemu.org/Features/LiveBlockMigration>](http://wiki.qemu.org/Features/LiveBlockMigration)

## Pre-Copy Execution Diagrams and Description

![](/images/wiki/StorageLiveMigration3.png)

The **preliminary snapshot** in **step 2** is not mandatory but it's preferable since it will allow almost the entire copy to be done externally by the SPM (and not by the qemu-kvm process).

![](/images/wiki/StorageLiveMigrationAPIDiagram3.png)

### REST API

The REST API should take advantage of the `POST` operation on a VM disk, specifying the new storage domain.

```xml
POST /api/vms/{vm:id}/disks/{disk:id} HTTP/1.1
Accept: application/xml
Content-type: application/xml

<disk>
    <storage_domains>
        <storage_domain id="{storage_domain:id}"/>
    </storage_domains>
</disk>
```

### Engine Flow

Pseudocode (work in progress):

```python
def storageLiveMigration(spmHost, vmHost):
    # Start moving the image to the destination (leaf not included)
    spmTask = spmHost.moveImage(spUUID, srcDomUUID, dstDomUUID, imgUUID, None, LIVECOPY_OP)
    # Wait for the empty leaf to appear on the destination
    while True:
        status = spmHost.getTaskStatus(spmTask)
        # If the task got interrupted try to delete the image on the destination and fail
        if status == Failed:
            spmHost.deleteImage(spUUID, dstDomUUID, imgUUID)
            raise FailureException
        # Check that the new leaf has been created on the destination
        status = spmHost.getVolumeInfo(spUUID, dstDomUUID, imgUUID, leafUUID)
        if status == Done:
            break
        # Timeout?
    # Initiate the block migration in qemu-kvm
    hsmTask = vmHost.blockMigrateStart(vmUUID, {
        "srcDomUUID": srcDomUUID,
        "dstDomUUID": dstDomUUID,
        "imgUUID":    imgUUID,
    })
    spmStatus = None
    hsmStatus = None
    # Wait for both the spm copy and the hsm copy/mirroring to finish
    while True:
        if spmStatus != Done:
            spmStatus = spmHost.getTaskStatus(spmTask)
        if hsmStatus != Done:
            hsmStatus = hsmHost.getBlockMigrateStatus(vmUUID, hsmTask)
        if spmStatus == Done and hsmStatus == Done:
            break
        if spmStatus == Failure or hsmStatus == Failure:
            # FIXME: we probably need more here
            # Reopen the leaf only on the source
            vmHost.blockMigrateEnd(vmUUID, hsmTask, srcDomUUID)
            spmHost.deleteImage(spUUID, dstDomUUID, imgUUID)
            raise FailureException
    # Finalize the migration to the destination
    vmHost.blockMigrateEnd(vmUUID, hsmTask, dstDomUUID)
```

### VDSM SPM

Add a new `moveImage` operation: **`LIVECOPY_OP`** (`0x03`):

    moveImage(spUUID, srcDomUUID, dstDomUUID, imgUUID, vmUUID, op, postZero=False, force=False)

*   **`spUUID`:** storage pool UUID
*   **`srcDomUUID`:** source domain UUID
*   **`dstDomUUID`:** destination domain UUID
*   **`imgUUID`:** image UUID (it will be maintained on the destination)
*   **`vmUUID`:** unused
*   **`op`:** must be LIVECOPY_OP (0x03)
*   **`postZero`:** unused
*   **`force`:** unused

Description of **LIVECOPY_OP**:

*   it copies all the volumes up to the leaf (not included)
*   it prepares an empty volume for the leaf on the destination
*   it doesn't automatically rollback (because the SPM doesn't know if the qemu-kvm process is already mirroring the new leaf)

### VDSM HSM

Add the new block migrate commands:

    blkTask = blockMigrateStart(vmUUID, blkMigParams)
    blkStatus = getBlockMigrateStatus(vmUUID, blkTask)
    blockMigrateEnd(vmUUID, blkTask, tgtDomUUID)

The only format supported for **`blkMigParams`** at the moment is:

    blkMigParams = {
        "srcDomUUID": "`<srcDomUUID>`",
        "dstDomUUID": "`<dstDomUUID>`",
        "imgUUID":    "`<imgUUID>`",
    }

*   **`vmUUID`:** VM UUID
*   **`srcDomUUID`:** source domain UUID
*   **`dstDomUUID`:** destination domain UUID
*   **`imgUUID`:** image UUID (it will be maintained on the destination)
*   **`blkTask`:** a block task UUID
*   **`tgtDomUUID`:** the target domain UUID to switch to (can be source or destination)

Description of **`blockMigrateStart`**:

*   It should resize the new leaf on the destination to the size of the leaf on the source (using `lvExtend`), this might not always result in an extension if a preliminary snapshot has been taken before the mirroring
*   When the block device has been extended it relies on `virDomainBlockRebase` to start the mirroring and streaming

Description of **`getBlockMigrateStatus`**:

*   It relies on `virDomainBlockJobInfo` to get the status of the block job

Description of **blockMigrateEnd**:

*   It relies on `virDomainBlockJobAbort` both to pivot to the destination or fallback to the source

#### Libvirt Function Calls

    virDomainBlockRebase(dom, disk, "/path/to/copy",
        VIR_DOMAIN_BLOCK_REBASE_COPY | VIR_DOMAIN_BLOCK_REBASE_SHALLOW |
        VIR_DOMAIN_BLOCK_REBASE_REUSE_EXT)

The `virDomainBlockRebase` function call is used to start the mirroring and streaming. This call assumes that **/path/to/copy** is already present (and initialized) and only the leaf content will be streamed to the new destination (no squashing).

    virDomainBlockJobAbort(dom, disk, 0)

The `virDomainBlockJobAbort` function call with the `flags=0` is used to safely switch back on the source (it can be used at any time).

    virDomainBlockJobAbort(dom, disk, VIR_DOMAIN_BLOCK_JOB_ABORT_PIVOT)

The `virDomainBlockJobAbort` function call with the `flags=VIR_DOMAIN_BLOCK_JOB_ABORT_PIVOT` is used to pivot to the destination (drive-reopen). It will fail if there is a streaming in progress. Eventually (probably not in VDSM) it can be used as polling mechanism to switch to the destination.

#### Watermark and LV Extend

On block domains VDSM is monitoring the qemu-kvm process watermark on the disks (how much space is actually used on the block devices). During the mirroring the logical volumes extension should be replicated on the destination (with a 20% size increase because of the bitmap used during mirroring).

# Storage Live Migration Alternatives

## Post-Copy Execution Diagrams and Description

![](/images/wiki/StorageLiveMigration1.png)

*   **Note on [3]**: when the SPM finishes the operation it's also responsible to set the 'Snapshot 2 Volume' metadata to point to 'Snapshot 1 Volume' on 'Source Domain' even if the real swap happens in the next step.

![](/images/wiki/StorageLiveMigrationAPIDiagram1.png)

### Limitations and Risks

*   VDSM doesn't have the proper metadata to describe a VM running on volumes stored on two different storage domains
*   missing libvirt operation to change the volume backing file on the fly, new design and patches:
    -   <https://www.redhat.com/archives/libvir-list/2012-January/msg01448.html>
    -   <https://www.redhat.com/archives/libvir-list/2012-February/msg00014.html>

### Engine Flow

Pseudocode:

```python
def vm_live_block_migrate(vm, destDomain):
    for drive in vm_get_drives(vm):
        createVolumeCrossSD(drive) # to the SPM
    # Retry until it succeed or fails with a known error
    while True:
        ret = blockMigrate(driveParams) # to the HSM
        if ret == SUCCESS
            break
        elif ret == VM_NOT_RUNNING:
            # rollback the createVolumeCrossSD operations
            return VM_NOT_RUNNING
    for drive in vm_get_drives(vm):
        while True:
            ret = cloneInternalVolumes(drive)
            if ret == SUCESS:
                break
    finalizeBlockMigrate() # to the HSM
```

## Mirrored-Snapshot Execution Diagrams and Description

![](/images/wiki/StorageLiveMigration2.png)

![](/images/wiki/StorageLiveMigrationAPIDiagram2.png)

### VDSM API

The command `copyVolume(...)` is used in step 2 and 4 to copy the volumes from the source to the destination. For maximum flexibility it's possible to change the volume and image UUIDs (on the destination) and update the parent volume UUID (so that it's possible to rebuild a consistent chain on the destination).

```python
def copyVolume(srcDomUUID, dstDomUUID, srcImgUUID, dstImgUUID,
               srcVolUUID, dstVolUUID, dstBakImgUUID, dstBakVolUUID):
    """
    Copies a single volume from a source (domain, image, volume) to a new
    destination (domain, image, volume).
    If dstBakVolUUID is specified it will be used to rebase (unsafe) the
    volume (if dstBakImgUUID is not specified, dstImgUUID will be used).
    If dstBakVolUUID is not specified and the source volume has a parent,
    then the same srcImgUUID and srcVolUUID will be reused.
    :param srcDomUUID: The source storage domain UUID
    :type srcDomUUID: UUID
    :param dstDomUUID: The destination storage domain UUID
    :type dstDomUUID: UUID
    :param srcImgUUID: The source image UUID
    :type srcImgUUID: UUID
    :param dstImgUUID: The destination image UUID
    :type dstImgUUID: UUID
    :param srcVolUUID: The source volume UUID
    :type srcVolUUID: UUID
    :param dstVolUUID: The destination volume UUID
    :type dstVolUUID: UUID
    :param dstBakImgUUID: The new backing image UUID for the destination
                          (optional parameter)
    :type dstBakImgUUID: UUID
    :param dstBakVolUUID: The new backing volume UUID for the destination
                          (optional parameter)
    :type dstBakVolUUID: UUID
    """
```

### Engine Flow

*   Copy over all non-leaf volumes from source to destination (Step 2).
*   Create a new volume for the disk on source and destination.
*   Mark "Snapshot 1" (old leaf) as `MERGE_PENDING`.
*   Mark "Snapshot 2" (new leaf) with the same `SNAPSHOT_ID` of "Snapshot 1" (NB. do **not** mark with `MERGE_PENDING`) - So that we know that this is the snapshot to work with.
*   Call live snapshot with all (other disks) existing volumes the same, but this disk in mirroring mode with the new volumes on source and destination.
*   Copy over the old leaf (it is merge pending).
*   When finished, reopen on destination and delete disk on source. If the VM is down, do the next step.
*   When VM stops/Disk is deactivated (unplugged) and the migration had finished - the Disk will go to locked state and cold merge for all pending merges of same snapshots will begin (ie if we have 1 volume that is merge pending for snapshot id S1, and 1 volume that is merge pending for snapshot id S2). In this state you can't run the VM with the disk, so you can run without it, or have to wait for merge to finish.

#### Engine flow diagram

![](/images/wiki/SLM.png)
