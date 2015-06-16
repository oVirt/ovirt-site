---
title: LiveMerge
authors: fsimonce
wiki_title: Features/Design/LiveMerge
wiki_revision_count: 7
wiki_last_updated: 2012-03-12
---

# Live Merge

Given an image with one or more snapshots the merge command will squash the data of one volume into an other. Two merge directions are possible:

![](LiveMergeExample1.png "LiveMergeExample1.png")

*   **Backward Live Merge:** the data is pushed from the snapshot (Snapshot 1 Volume) into its base (Base Volume)
    -   **Pros:**
        -   When there is only one snapshot in the chain it is possible to squash it into its base (possibly fast) maintaining the volume format
    -   **Cons:**
        -   Hard to implement (at the moment no support in qemu-kvm/libvirt)
        -   The backing file is corrupted until the process is completed (you cannot revert to Base Volume if the process fails or stops)
*   **Forward Live Merge:** the data is pulled from the backing file (Snapshot 1 Volume) to the next snapshot (Snapshot 2 Volume)
    -   **Pros:**
        -   Easy to implement
        -   The backing file is not corrupted (you can always revert to Snapshot 1 Volume)
    -   **Cons:**
        -   When there is only one snapshot in the chain, the entire base (maybe a raw file) is pulled into the snapshot (it might change the volume format and take a long time)

In the long run the definitive solution will be to pick the correct method (backward/forward) depending on the situation, trying to minimize the amount of data moved from one volume to another.

# GUI

No major gui modification is required. The action to merge a snapshot should be enabled also when the VM is running, in such case the engine will issue a live merge command.

# Engine-VDSM Flow

![](LiveMergeAPIDiagram.png "LiveMergeAPIDiagram.png")

# VDSM API

      merge(vmId, mergeDrives)
      mergeDrives = [
          {"domainID": "`<sdUUID>`",
           "imageID": "`<imgUUID>`",
           "baseVolumeID": "`<baseVolUUID>`",
           "volumeID": "`<volUUID>`"},
          ...
      ]
      ret = mergeStatus(vmId)
      ret = {"status": {"message": "Done", "code": 0},
             "mergeStatus": [
                 {"status": "[Not Started|In Progress|Failed|Completed|Unknown]",
                  "domainID": "`<sdUUID>`",
                  "imageID": "`<imgUUID>`",
                  "baseVolumeID": "`<baseVolUUID>`",
                  "volumeID": "`<volUUID>`",
                  "disk": "`<diskname>`"},
                 ...
              ]}

At the moment VDSM is also returning the statuses "Drive Not Found" and "Base Not Found" in mergeStatus. These two errors must be moved to the merge command instead.

# Limits and Risks

*   **Phase 1**: support only forward live merge to the image leaf
*   **Phase 2**: support forward and backward live merge of any volume in the chain

### Limits and Risks Phase 1

*   The SPM must be able to remove an internal volume
    -   **Problem**: The current implementation of the resource manager is forbidding such operation
    -   **Problem**: A check (or synchronization) is required to ensure that the SPM won't remove a volume that is actually in use
*   QEMU is changing the snapshot backing file
    -   **Problem**: This might lead to a short time where the backing file and the metadata are inconsistent
*   QEMU is not closing the merged images files (block_stream)
    -   **Problem**: It's not possible to remove the open Logical Volumes (merged)
    -   **Solution**: QEMU should close the merged images files
    -   **Bugzilla**: [<https://bugzilla.redhat.com/show_bug.cgi?id=801449>](https://bugzilla.redhat.com/show_bug.cgi?id=801449)

### Limits and Risks Phase 2

*   QEMU/Libvirt must support the backward live merge
    -   **Problem:** without the proper support in qemu/libvirt it is impossible to implement a backward live merge
    -   **Bugzilla:**
*   Change the logical volume permissions on the HSM
    -   **Problem:** VDSM must be able to change any internal volume to read-write at any time
    -   **Solution:** LVM should be able to activate read-only the read-write LVs
    -   **Bugzilla:** [<https://bugzilla.redhat.com/show_bug.cgi?id=769293>](https://bugzilla.redhat.com/show_bug.cgi?id=769293)
*   The default LV permissions for the internal volumes are read-only
    -   **Problem**: VDSM can't change the internal volume to read-write
    -   **Solution**: update the LVM metadata switching all the LVs permissions to read-write (**WARN:** this might require a new domain version)
*   In the backward live merge the base snapshot is inconsistent until the merge completes
    -   **Problem**: the base snapshot is inconsistent and shouldn't be accessible (no reverts)
    -   **Solution**: the base snapshot should be accessed only through the layer above
*   During a live merge the required space to store the data grows
    -   **Problem**: on LVM the volume size is fixed and will require an extension
    -   **Solution 1**: VDSM should monitor the growth of internal volumes during the merge (qemu needs to support this)
    -   **Solution 2**: a possible trivial solution is to extend the target volume to the maximum amount of space required (base size + snapshot size) and eventually shrink it when the operation completes
    -   **Solution 3**: compute the exact size using a tool provided by qemu

# Engine Flow

Engine pseudocode:

      def live_merge(vm, driveParams):
          while True:
              merge(vm, driveParams)
              while True:
                  ret = mergeStatus(vm)
                  if ret != MERGE_IN_PROGRESS: # Check for each disk
                      break
                  # Inner while loop end, polling status again
              if ret == MERGE_COMPLETED:
                  # delete the volumes
                  break
          # While loop end, retrying

**Notes:**

*   The engine can merge multiple disks at the same time and each merge can independently fail or succeed
*   If any merge failed the engine should try again
*   If all the disk merge complete successfully the engine can remove the merged volumes
*   It's not possible to issue a new merge command (on the same VM) when there is another one that is not completed yet
