---
title: Virtio-SCSI
authors: derez
feature_name: Virtio-SCSI
feature_modules: engine, vdsm
feature_status: Released in oVirt 3.3
---

# Virtio-SCSI

## Summary

The virtio-scsi feature is a new para-virtualized SCSI controller device. It is the foundation of an alternative storage implementation for KVM Virtualization's storage stack replacing virtio-blk and improving upon its capabilities. It provides the same performance as virtio-blk, and adds the following immediate benefits:

*   Improved scalability—virtual machines can connect to more storage devices (the virtio-scsi can handle multiple block devices per virtual SCSI adapter).
*   Standard command set—virtio-scsi uses standard SCSI command sets, simplifying new feature addition.
*   Standard device naming—virtio-scsi disks use the same paths as a bare-metal system. This simplifies physical-to-virtual and virtual-to-virtual migration.
*   SCSI device passthrough—virtio-scsi can present physical storage devices directly to guests.

Virtio-SCSI provides the ability to connect directly to SCSI LUNs and significantly improves scalability compared to virtio-blk. The advantage of virtio-SCSI is that it is capable of handling hundreds of devices compared to virtio-blk which can only handle approximately 30 devices and exhausts PCI slots.

Designed to replace virtio-blk, virtio-scsi retains virtio-blk’s performance advantages while improving storage scalability, allowing access to multiple storage devices through a single controller, and enabling reuse of the guest operating system’s SCSI stack.

## Owner

*   Name: Daniel Erez (Derez)
*   Email: <derez@redhat.com>

## Current status

*   Target Release: 3.3
*   Status: released

## Detailed Description

The virtio SCSI host is the basis of an alternative storage stack for KVM. This stack would overcome several limitations of the current solution, virtio-blk:

1) scalability limitations: virtio-blk-over-PCI puts a strong upper limit on the number of devices that can be added to a guest. Currently virtio-blk imposes a limitation of ~30 disks per guest. Each virtio-blk virtual adapter can only handle one block device so the number of block devices is limited by the number of virtual PCI slots in the guest. While this can be worked around by implementing a PCI-to-PCI bridge, or by using multifunction virtio-blk devices, these solutions either have not been implemented yet, or introduce management restrictions. On the other hand, the SCSI architecture is well known for its scalability and virtio-scsi supports advanced feature such as multiqueueing.

2) limited flexibility: virtio-blk does not support all possible storage scenarios. For example, it does not allow SCSI passthrough or persistent reservations. In principle, virtio-scsi provides anything that the underlying SCSI target (be it physical storage, iSCSI or the in-kernel target) supports.

3) limited extensibility: over the time, many features have been added to virtio-blk. Each such change requires modifications to the virtio specification, to the guest drivers, and to the device model in the host. The virtio-scsi spec has been written to follow SAM conventions, and exposing new features to the guest will only require changes to the host's SCSI target implementation.

### Guest Support

The following Guest OS drivers are available:

*   Fedora / Other Linuxes
*   Windows Server 2003 / 2007 / 2008 / 2012, Windows 7/8
    -   Windows XP is not supported

      Note: Windows drivers should be added to guest tools.

### VDSM

#### Adding an image Disk

```xml
<devices>
 <disk type='file' device='disk'>
  <target dev='sda' bus='scsi'/>
  <address type='drive' controller='0' bus='0' target='0' unit='0'/>
 </disk>
 <controller type='scsi' index='0' model='virtio-scsi'/>
</devices>
```

#### Adding a DirectLUN Disk (lun passthrough)

```xml
<devices>
 <disk type='block' device='lun' rawio='no' sgio='unfiltered'>
  <target dev='sda' bus='scsi'/>
  <address type='drive' controller='0' bus='0' target=0' unit='0'/>
 </disk>
 <controller type='scsi' index='0' model='virtio-scsi'/>
</devices>
```

### Backend

*   DiskInterface enum: VirtIO_SCSI
*   Affected commands: AddDisk/UpdateVmDisk/HotPlugDisk
*   'VirtIOScsiEnabled' configuration value.
*   BaseDisk: sgio field.
*   VmInfoBuilder:
    -   Add "scsi" interface to struct.
    -   Add "virto-scsi" controller.
    -   Add 'sgio' propety to device.
*   Permissions:
    -   CONFIGURE_SCSI_GENERIC_IO ActionGroup
    -   Check on Disk entity
    -   Add to SuperUser/DataCenterAdmin roles
*   VirtIO-SCSI enabled flag:
    -   When enabled, a VirtIO-SCSI controller device is added to vm_device table.
    -   Used for maintaining stable address to the pci controller.
    -   Necessary for hot-plugging a disk with VirtIO-SCSI interface.
    -   The flag is defaulted to true on cluster >= 3.3.

### REST-API

#### Create/Update an image Disk

```xml
<disk>
        ...
 <interface>virtio_scsi</interface>
        ...
</disk>
```

#### Create/Update a DirectLUN Disk

```xml
<disk>
        ...
 <interface>virtio_scsi</interface>
 <sgio>unfiltered</sgio>
        ...
</disk>
```

#### VirtIO_SCSI flag

```xml
<vm>
        ...
 <virtio_scsi enabled="true|false"/>
        ...
</vm>
```

### UI

#### Add Disk

![](/images/wiki/Virtio-scsi-adddisk.png)

#### New Role

![](/images/wiki/Virtio-scsi-role.png)

#### New/Edit VM

![](/images/wiki/Virtio-scsi-enable.png)

### Sequence diagram

![](/images/wiki/Virtio-scsi_sequence-diagram.png)

## Benefit to oVirt

Virtio-SCSI will add the following abilities to oVirt:

*   Allow the usage of hundreds of devices per guest
*   Attach a virtual hard drive or CD through the virtio-scsi controller
*   pass-through a physical SCSI device from the host to the guest via the QEMU scsi-block device

## Dependencies / Related Features and Projects

*   virtio-scsi ioctl

## Testing

*   Run all tests on disks with the new disk interface (Virtio-SCSI).
*   Hot-Plug: at the moment, hot plug would succeed only if there's already at least one virtio-scsi disk (i.e. a scsi controller should be available on running vm).
*   SGIO: for DirectLUN disks, check that 'sgio' property is passed correctly (filtered/unfiltered).
*   MLA: Disk -> 'Manipulate SCSI I/O Privilages'.

## Documentation / External references

*   virtio-scsi Fedora feature page [KVM]: <http://fedoraproject.org/wiki/Features/virtio-scsi>
*   virtio scsi host draft specification, v3 [QEMU]: <http://lists.gnu.org/archive/html/qemu-devel/2011-06/msg00754.html>
*   virtio scsi libvirt: <http://libvirt.org/formatdomain.html#elementsControllers>

## Comments and Discussion

*   There are a number of use cases where the virtual machine would need to run SG_IO commands that are considered 'dangerous' such as persistent reservations.
*   Today the kernel blocks commands unless the calling application has CAP_SYS_RAWIO.
*   Giving this facility to the qemu process (or run as root) raises a number of security concerns.
*   Consider to define a certain set of commands upfront - such as persistent reservations, TRIM/DISCARD, etc however since storage vendors can define their own commands this may not be enough.
*   A filter mechanism is need to be able to define filters for SG_IO commands to allow an administrator to define what privileged commands should be permitted for a given process.

This should not require the process to run as root.

*   Filtered vs. unfiltered sg commands (i.e. the mechanism is currently all or nothing – can't filter specific commands).

        Filtering is done on disk level (not on VM level).

*   Mapping of disk vs. lun in libvirt to disk image and direct lun appropriately.
*   The feature is enabled for cluster 3.3 and up.

## Open Issues

*   How to use virtio-scsi controllers:
    -   One SCSI controller for all disks? Or, a SCSI controller per disk?
        -   Note: Each device on a virtio-scsi controller is represented as a logical unit, or LUN. The LUNs are grouped into targets. Each device can have a maximum of 256 targets per controller and 16,384 logical units per target.
*   How hot-plug is affected:
    -   Hot-plugging a disk with virtio-scsi interface should attach a new controller? Or, reuse the current SCSI controller?
        -   Assume that a controller already exists in the VM?
        -   Or, how to verify that a controller already exists in the VM (try/catch or using virDomainGetXMLDesc)?
    -   Hot-unplugging a disk should remove the controller as well? (currently, not supported by libvirt)
*   Should virtio-scsi be set as default for 3.3 clusters?

## Future Work

*   Decouple disk interface (IDE/Virtio/Virtio-scsi) from Disk entity. I.e. disk interface should be defined in the connection between disk and VM (vm device), as opposed to the current situation whereas disk interface is a property of the disk.
*   Support CDs as well.
