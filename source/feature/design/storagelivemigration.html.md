---
title: StorageLiveMigration
authors: abaron, fsimonce, mkolesni, sming
wiki_title: Features/Design/StorageLiveMigration
wiki_revision_count: 22
wiki_last_updated: 2012-04-16
---

# Storage Live Migration

## Introduction

Live block migration is the operation in charge of moving a running VM and its disks from one storage domain to an other.

## GUI

No major gui modification are required. The action to move a VM from one storage to an other should be enabled also when the VM is running, in such case the engine will issue a live block migration.

![](StorageLiveMigrationGUI.png "StorageLiveMigrationGUI.png")

## Engine-VDSM Flow

      Engine                     HSM  SPM
      --+---                     ---  ---
        |  createVolumeCrossSD()  |    |
        X----------------------------->X
        |    ...                  |    |
        |  createVolumeCrossSD()  |    |
        X----------------------------->X
        |                         |    |
        |  blockMigrate()         |    |
        X------------------------>X    |
        |                         |    |
        |  cloneInternalVolumes() |    |
        X----------------------------->X
        |                         |    |
        |  finalizeBlockMigrate() |    |
        X------------------------>X    |
        |                         |    |
        V                         V    V
      Initial Status:
       domain1: [base(raw)]<-[snap1(qcow2)]<-(VM)
       domain2: [..empty..]
      createVolumeCrossSD():
       domain1: [base(raw)]<-[snap1(qcow2)]<-+-(VM)
       domain2:                              +-[snap2(qcow2)]
      blockMigrate():
       domain1: [base(raw)]<-[snap1(qcow2)]<-+
       domain2:                              +-[snap2(qcow2)]<-(VM)
      cloneInternalVolumes():
       domain1: [base(raw)]<-[snap1(qcow2)]<-+
       domain2: [base(raw)]<-[snap1(qcow2)]  +-[snap2(qcow2)]<-(VM)
      Note: when the SPM finishes the operation it's also responsible to set the
      snap2 metadata to point to snap1 on domain2 even if the real swap happens
      in the next step.
      finalizeBlockMigrate():
       domain1: [base(raw)]<-[snap1(qcow2)]
       domain2: [base(raw)]<-[snap1(qcow2)]<-[snap2(qcow2)]<-(VM)

A possible optimization: copy the base

## Limitations and Risks

*   VDSM doesn't have the proper metadata to describe a VM running on volumes stored on two different storage domains
*   missing libvirt operation to change the volume backing file on the fly, new design and patches:
    -   <https://www.redhat.com/archives/libvir-list/2012-January/msg01448.html>
    -   <https://www.redhat.com/archives/libvir-list/2012-February/msg00014.html>

## Engine Flow

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
