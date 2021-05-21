---
title: Hot Plug and Unplug Disk
category: feature
authors:
  - derez
  - mkublin
  - ykaul
---

# Hot Plug Disk

## Summary

Allow hot addition and removal of virtio-blk and virtio-scsi disks to a running guest.

## Owner

*   Michael Kublin
*   Email: mkublin@redhat.com

### Current status

Supported since oVirt 3.1. VirtIO-SCSI support added in oVirt 3.3.

## Detailed Description

The following feature will allow to hot plug/unplug disks to a running VM. Note that this feature will require the guest's cooperation, so it will be restricted to operating systems that support it, e.g.m RHEL 5 and above, Windows Server 2003 and above, etc.

### User Experience

The following UI mockup contain guidelines for VMs->Disks sub-tab:

![](/images/wiki/Vm_disks_hotplug.png)

### User work-flows

New actions will allow the user to plug or unplug a disk to/from a running VM in 3.1 clusters and above.

HotPlug will be allowed only on:

1. The guest OS supports the operation
2. VirtIO/VirtIO-SCSI disk
3. Disk should be unplugged
4. VM should be up

HotUnPlug will be allowed in the following cases:

1. The guest OS supports the operation
2. VirtIO/VirtIO-SCSI disk
3. Disk should be plugged
4. VM should be up

In order to perform this operation new verbs will be added to the VDSM side - `hotplugDisk` and `hotunplugDisk` (see VDSM's schema for the full details).

New vdsm errors will be added - `HotplugDiskFailed` (45) and `HotunplugDiskFailed` (46).
Note that unplugged disks will not be passed to the `createVM` operation.
