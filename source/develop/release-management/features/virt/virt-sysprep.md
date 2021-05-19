---
title: virt-sysprep
authors: smelamud
category: feature
---

# Sealing a VM Template

## Summary

'Sealing' is an operation that erases all machine-specific configurations from a filesystem: This includes SSH keys, UDEV rules, MAC addresses, system ID, hostname, etc. It is useful for when you want to create a template from a virtual machine. Subsequent virtual machines made from this template will avoid configuration inheritance.

[`virt-sysprep`](http://libguestfs.org/virt-sysprep.1.html) tool is used for sealing a VM template. Sealing operates directly on a VM's filesystem, and the list of images is passed to it in parameters. The objective is to add the ability to run `virt-sysprep` from oVirt on a specified set of disk images. The best timing for this action is when a VM template is created from a VM.

The exact list of operations performed by `virt-sysprep` can be found on the tool's [manual page](http://libguestfs.org/virt-sysprep.1.html). oVirt runs `virt-sysprep` with a set of default operations. Currently, `virt-sysprep` only supports Linux guests and has only been tested on major distributions.

## Owner

*   Name: Shmuel Melamud (smelamud)
*   Email: <smelamud@redhat.com>

## Detailed Design

In UI, 'Seal template' checkbox will appear in 'New Template' dialog. If user checks this checkbox, the VM Template will be sealed just after creation.

Disk images marked as SHARED cannot be modified. Therefore, you cannot run `virt-sysprep` after `AddVmTemplateCommand` is finished. Sealing must be performed directly after the VM template's disks have been created, but before the disks are marked as SHARED. Here is the correct sequence:

1.   Create the template.
2.   Create all template disks as regular (LEAF) disks.
3.   Make the disks ILLEGAL.
4.   Seal the template (run `virt-sysprep` on the disks).
5.   Make the disks LEGAL and SHARED.

In the event of a mid-process failure, the whole process will fail and the template will be removed. If the disks are not removed after failure, they will be left ILLEGAL and unusable.

The `virt-sysprep` utility is executed on the VDSM side. The verb is `VM.seal`. The utility is executed asynchronously using host jobs mechanism. Storage jobs cannot be used for this, because `virt-sysprep` operates on all disks together, and not disk-by-disk. Therefore, another type of host jobs, named 'virt jobs', needs to be added. The engine will track the status of the job, using `VirtJobCallback`.

## List of code changes

### UI

*   Add a 'Seal template' checkbox to the 'New Template' dialog.

### REST

*   Add a `seal` flag to the virtual machine template creation operation.

### Backend

*   Create `VirtJobCallback`. Make `VirtJobCallback` and `StorageJobCallback` to be inherited from a common ancestor, `HostJobCallback`, that will contain the common functionality.
*   Create `UpdateVolumeCommand`, to change volume flags, making it ILLEGAL, LEGAL and SHARED.
*   Create `SealVmTemplateCommand` that invokes `VM.seal` verb on the VDSM side.
*   Modify `AddVmTemplateCommand` so that it can perform all the steps mentioned above.

### VDSM

*   Add `SDM.update_volume` verb that changes volume attributes.
*   Add `VM.seal` verb that runs `virt-sysprep` on the given list of disk images.

## Current status

*   engine: Released
*   vdsm: Released
