---
title: Live Snapshots
authors: eblake, fsimonce
wiki_title: Live Snapshots
wiki_revision_count: 9
wiki_last_updated: 2012-03-07
---

# Live Snapshots

## Introduction

Given a virtual disk image [img1] the elements (files or block devices) used to store its data in raw or cow format are called volumes.

A raw volume always contains the entire data of an image while a cow volume might contain just the differences from its parent element (a preexisting raw or cow volume).

The cow format is used mainly for three tasks:

*   create a thin provisioned image: the content is not preallocated and the new data is appended to the volume only when needed
*   implement the snapshots: a cow volume with a base volume could be used to separate new changes from a previous state that later on can be reused
*   use a template: the same raw/cow base volume can be shared between more images to save space

An example of a thin provisioned image:

![](/images/wiki/LiveSnapshot_ThinProvisionImage.png "LiveSnapshot_ThinProvisionImage.png")

An example of a snapshots:

![](/images/wiki/LiveSnapshot_SnapshotImage.png "LiveSnapshot_SnapshotImage.png")

## Live Tasks in VDSM Architecture

Live snapshots and merges have 2 components:

*   **storage level:** prepare the new volume (cow snapshot), deleting an old volume (cow snapshot)
*   **vm level:** switching from one volume to another or move data from one snapshot to another

Given the current VDSM architecture the storage actions should run on the SPM host (in charge of the image manipulations) and the vm actions should run on the HSM host where the vm is located.

### VDSM Images and Current Limitations

The main VDSM problems and limitations today are:

*   The resource manager is used on HSM hosts to lock the images when in use by a vm.
    -   **Problem:** when the vm is running on the SPM it is impossible to create a new volume because the image is locked.
    -   **Solution:** using the resource manager to lock the image on HSM is wrong (since its scope is only local), don't use the resource manager on the HSM.
    -   **VDSM Patch:** <http://gerrit.ovirt.org/554>

<!-- -->

*   It's not possible to create a new volume without accessing the parent.
    -   **Problem:** since the parent volume is in use by the VM it shouldn't be accessed.
    -   **Solution:** the only thing needed from the parent is the image size, read it from the metadata.
    -   **VDSM Patch:** <http://gerrit.ovirt.org/570>

<!-- -->

*   Each VM is exclusively using one or more images and should be able to set the permissions of each volume according to its needs.
    -   **Problem:** lvm updates the metadata when you change an lv permission; this operation can't be performed on HSM hosts since is going to corrupt the lvm mda.
    -   **Solution:** make the lvm ro/rw permissions local (don't update the mda)
    -   **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=769293>
    -   VDSM Patch: n/a

<!-- -->

*   A live snapshot shouldn't reconfigure the backing file path in the new image
    -   **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=785683> (qemu-kvm)
    -   VDSM Patch: n/a

<!-- -->

*   Specifying the entire image chain as a qemu drive.
    -   **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=760547> (libvirt)
    -   **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=750801> (qemu-kvm)
    -   VDSM Patch: n/a

<!-- -->

*   Libvirt should make sure that the snapshot operation is consistent (fail or succeed for all the drives)
    -   **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=782457>
    -   VDSM Patch: (not required)

<!-- -->

*   Live merge is not present in the upstream component yet (libvirt/qemu)
    -   Bugzilla: [...]
    -   VDSM Patch: n/a

## Live Snapshot GUI

At the moment there is no suggestion to change the interface, the backend is responsible to treat the snapshot as a "live" when the VM is running.

## Live Snapshot Flow

![](/images/wiki/LiveSnapshot_RequestFlow.png"LiveSnapshot RequestFlow.png")

*   **createVolume:** regular SPM calls to create snapshot volumes (one for each image the VM is using)
*   **snapshot:** HSM call used to let the VM switch to the new volumes

#### Snapshot HSM API

*   **snapshot(vmId, snapParams)**

Snapshot Parameters Format:

      snapParams = [
          {"domainID": "`<sdUUID>`",
           "imageID": "`<imgUUID>`",
           "baseVolumeID": "`<baseVolUUID>`",
           "volumeID": "`<volUUID>`"},
         ...
      ]

## Live Snapshot Backend

Live snapshots operation extend regular snapshots as follow:

*   Create a locked snapshot in DB
*   Create images for all disks in DB
*   Create volumes for all disks in VDSM

<!-- -->

*   Async wait for all volumes to be created successfully

<!-- -->

*   If the VM is up and running (as far as engine knows):
    -   Issue the snapshot command on the VDSM host running the VM:
        -   Success, no operation required
        -   Failure, can't switch disks (snapErr): rollback on VDSM and DB
        -   Failure, the VM is not running (noVM): retry the operation [1]
        -   Failure, the VM is busy (eg: migration): rollback on VDSM and DB
        -   Failure, any other reason: retry the operation at a later time

<!-- -->

*   Update the VM to point to new image leafs
*   Unlock the snapshot

[1] the VM state in the engine is going to reflect the vdsm status (down) in the next cycle and then the flow will terminate successfully (this avoids races between vdsm and engine).

**Notes:**

*   While snapshot is being taken, you cannot do certain actions:
    -   Run the VM
    -   Delete the any snapshot of the VM
    -   Preview a different snapshot (you can't do this live anyway)
    -   Possibly other places that care if VM is locked

<!-- -->

*   If the user will try to do a prohibited action, he will get a "can do action" failure that describes that it can't be done while snapshot is in progress, so he should wait.

### Snapshots Actions matrix

|        | VM Running            | VM Paused             | VM Stopped       | VM Hibernated      |
|--------|-----------------------|-----------------------|------------------|--------------------|
| Create | Live Snapshot         | Live Snapshot         | Regular Snapshot | Regular Snapshot   |
| Commit | Live Merge            | Live Merge            | Regular Commit   | Regular Commit     |
| Revert | **Not Permitted** [1] | **Not Permitted** [1] | Regular Revert   | Regular Revert [2] |

[1] This might be permitted if the user agrees to stop the VM.

[2] The hibernated information must be discarded and the VM should be moved to stopped.

### Libvirt Flow

Internal Libvirt flow using [pesudocode](http://en.wikipedia.org/wiki/Pseudocode), **Bugzilla:** <https://bugzilla.redhat.com/show_bug.cgi?id=782457>

      def vm_live_snapshot(vm):
          vm_suspend(vm)
          for d in vm_drives(vm):
              r = vm_drive_snapshot(vm, d)
              if r == FAILURE:
                  for j in c:
                      vm_drive_rollback(vm, j)
                  vm_resume(vm)
                  return FAILURE
              c += d
          vm_resume(vm)
          return SUCCESS

Libvirt API usage flow for live storage migration, from [upstream message](https://www.redhat.com/archives/libvir-list/2012-January/msg01448.html)

      start with:
      vda: template <- current1

      create a disk-only snapshot, with:
       tmpsnap = virDomainSnapshotCreateXML(dom,
       "`<domainsnapshot>`\n"
       "  `<disks>`\n"
       "    `<disk name='vda'>`\n"
       "      

    /path/to/current2

\\n"

       "    `</disk>`\n"
       "  `<disks>`\n"
       "`</domainsnapshot>`", VIR_DOMAIN_SNAPSHOT_CREATE_DISK_ONLY)
      where the xml calls out the destination file name, resulting in:
      vda: template <- current1 <- current2

      perform the block rebase, with:
       virDomainBlockRebase(dom, "vda", "/path/to/template", 0)
      as well as waiting for the event (or polling status) to wait for
      completion, resulting in:
      vda: template <- current2

      delete the disk-only snapshot metadata as no longer useful, with:
       virDomainSnapshotDelete(tmpsnap,
       VIR_DOMAIN_SNAPSHOT_DELETE_METADATA_ONLY)

### QEMU Requirements and Limitations

*   **Drive backend change**: snapshot_blkdev (or a new verb) should support a way to re-use a pre-existing qcow2 volume. This is required for the **vm_drive_rollback** verb described in the Libvirt Flow.

### Recovery Paths: Live Snapshot

*   **Scenario 1:** one of the createVolume calls fails. The manager should decide to keep trying or rollback the created volumes.

<!-- -->

*   **Scenario 2:** all the createVolume calls succeed but the VM died before the snapshot command VDSM returns noVM (code: 1) and the manager should decide to keep the volumes or not.

<!-- -->

*   **Scenario 3:** libvirt dies during the snapshot, the vm is paused Libvirt stored why the vm was paused (virDomainGetState, status: VIR_DOMAIN_PAUSED_FROM_SNAPSHOT)
