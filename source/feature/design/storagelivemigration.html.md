---
title: StorageLiveMigration
authors: abaron, fsimonce, mkolesni, sming
wiki_title: Features/Design/StorageLiveMigration
wiki_revision_count: 22
wiki_last_updated: 2012-04-16
---

# Storage Live Migration

Live block migration is the operation in charge of moving a running VM and its disks from one storage domain to another.

### GUI

No major gui modifications are required. The action to move a VM from one storage to another should be enabled also when the VM is running, in which case the engine will issue a live block migration.

![](StorageLiveMigrationGUI.png "StorageLiveMigrationGUI.png")

### Pre-Copy and Post-Copy

*   **Pre-Copy:** copy all the internal volumes and then live copy the leaf volume, when the task is completed live migrate the VM
    -   **Pros:** safer and simpler to manage in the oVirt engine and VDSM
    -   **Cons:** if the snapshots are no longer needed then a lot of data is copied needlessly.
*   **Post-Copy:** live migrate the VM with a live snapshot to the new domain, copy the internal volumes and when the task is completed switch the leaf backing file
    -   **Pros:** better approach for HA/load balancing
    -   **Cons:** complex management in the oVirt engine and VDSM

Reference: [<http://wiki.qemu.org/Features/LiveBlockMigration>](http://wiki.qemu.org/Features/LiveBlockMigration)

### Post-Copy Execution Diagrams and Description

![](StorageLiveMigration1.png "StorageLiveMigration1.png")

*   **Note on [3]**: when the SPM finishes the operation it's also responsible to set the 'Snapshot 2 Volume' metadata to point to 'Snapshot 1 Volume' on 'Source Domain' even if the real swap happens in the next step.

![](StorageLiveMigrationAPIDiagram1.png "StorageLiveMigrationAPIDiagram1.png")

#### Limitations and Risks

*   VDSM doesn't have the proper metadata to describe a VM running on volumes stored on two different storage domains
*   missing libvirt operation to change the volume backing file on the fly, new design and patches:
    -   <https://www.redhat.com/archives/libvir-list/2012-January/msg01448.html>
    -   <https://www.redhat.com/archives/libvir-list/2012-February/msg00014.html>

#### Engine Flow

[Pseudocode](http://en.wikipedia.org/wiki/Pseudocode)

      def vm_live_block_migrate(vm, destDomain):
          for drive in vm_get_drives(vm):
              createVolumeCrossSD(drive) # to the SPM
          # Retry until it succeed or fails with a known error
          while True:
              ret = blockMigrate(driveParams) # to the HSM
              if ret == SUCCESS
                  break
              elif ret == VM_NOT_RUNNING:
                  # rollback the createVolumeCrossSD operations
                  return VM_NOT_RUNNING
          for drive in vm_get_drives(vm):
              while True:
                  ret = cloneInternalVolumes(drive)
                  if ret == SUCESS:
                      break
          finalizeBlockMigrate() # to the HSM
