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

The backwared live merge is the most important implementation since it's capable of maintaing the backing volume format (eg: raw).

# GUI

No major gui modification is required. The action to merge a snapshot should be enabled also when the VM is running, in such case the engine will issue a live merge command.

# Engine-VDSM Flow

![](LiveMergeAPIDiagram.png "LiveMergeAPIDiagram.png")

# VDSM API

      merge(vmId, driveParams)
      driveParams = [
         { 'domainID': '`<sdUUID>`',
           'volumeID': '`<volUUID>`'
         },
         [...]
      ]

# Limits and Risks

*   QEMU/Libvirt must support the backward live merge
    -   **Problem:** without the proper support in qemu/libvirt it is impossible to implement this feature in VDSM
    -   **Bugzilla:**
*   Change the logical volume permissions on the HSM
    -   **Problem:** VDSM must be able to change any internal volume to read-write at any time
    -   **Solution:** LVM should be able to activate read-only the read-write LVs
    -   **Bugzilla:** [<https://bugzilla.redhat.com/show_bug.cgi?id=769293>](https://bugzilla.redhat.com/show_bug.cgi?id=769293)
*   The default LV permissions for the internal volumes are read-only
    -   **Problem**: VDSM can't change the internal volume to read-write
    -   **Solution**: update the LVM metadata switching all the LVs permissions to read-write (**WARN:** this might require a new domain version)
*   The SPM must be able to remove an internal volume both in the case where the VM is running locally (resourceManager problems?) and in the case where the VM is running remotely (HSM)
*   In the backward live merge the base snapshot is inconsistent until the merge completes
    -   **Problem**: the base snapshot is inconsistent and shouldn't be accessible (no reverts)
    -   **Solution**: the base snapshot should be accessed only through the layer above

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
