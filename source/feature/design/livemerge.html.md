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

At the moment only backward live merge are supported by the API, in the future will be possible to specify the merge direction with an additional parameter.

      merge(vmId, driveParams)
      driveParams = [
         { 'domainID': '`<sdUUID>`',
           'volumeID': '`<volUUID>`'
         },
         [...]
      ]

# VDSM Limits and Risks

*   qemu/libvirt must support the backward live merge **Bugzilla:**
*   the SPM must be able to remove an internal volume both in the case where the VM is running locally (resourceManager problems?) and in the case where the VM is running remotely (HSM)

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
