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

      mergeDrives = [
          {"domainID": "`<sdUUID>`",
           "imageID": "`<imgUUID>`",
           "mergeVolumeID": "`<baseVolUUID>`",
           "volumeID": "`<volUUID>`"},
          ...
      ]
      merge(vmId, mergeDrives)

# Limits and Risks

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
*   The SPM must be able to remove an internal volumes
    -   **Problem**: The current implementation of the resource manager is forbidding such operation
    -   **Problem**: A check (or synchronization) is required to ensure that the SPM won't remove a volume that is actually in use
*   In the backward live merge the base snapshot is inconsistent until the merge completes
    -   **Problem**: the base snapshot is inconsistent and shouldn't be accessible (no reverts)
    -   **Solution**: the base snapshot should be accessed only through the layer above
*   QEMU is changing the snapshot backing file
    -   **Problem**: this might lead to a short time where the backing file and the metadata are inconsistent

# Engine Flow

Engine pseudocode:

      def live_merge(vm, driveParams):
          merge(vm, driveParams)
          while True:
              ret = mergeStatus(vm)
              if ret != MERGE_IN_PROGRESS:
                  break
          if ret == MERGE_COMPLETED:
               # delete the volumes
          else:
              return ret
