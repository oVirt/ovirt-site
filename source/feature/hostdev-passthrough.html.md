---
title: hostdev passthrough
category: feature
authors: mbetak, mpolednik
wiki_category: Feature
wiki_title: Features/hostdev passthrough
wiki_revision_count: 65
wiki_last_updated: 2015-05-07
---

# VM device hostdev passthrough

### Summary

This feature will allow passthrough of host devices to guest

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpoledni@redhat.com>

### Current status

*   Last updated date: Fri Jul 18 2014

### Host requirements

*   hardware IOMMU support (AMD-Vi, Intel VT-d enabled in BIOS)
*   enabled IOMMU support (intel_iommu=on for Intel, iommu=on for AMD in kernel cmdline)
*   RHEL7 or newer (kernel >= 3.6)
*   either support

### Troubleshooting

    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: error opening /dev/vfio/X: Permission denied
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device 'vfio-pci' could not be initialized

Error on VDSM side, /dev/vfio/X does not have o+rw permissions

    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: vfio: error, group X is not viable, please ensure all devices within the iommu_group are bound to their vfio bus driver.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M.addr=0xM: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device 'vfio-pci' could not be initialized

You are trying to pass through device that is in IOMMU group with other devices. There are 2 possibilities: either add all other devices from the group or enable unsafe interrupts in vfio_iommu_type1 with allow_unsafe_interrupts=1 (append vfio_iommu_type1.allow_unsafe_interrupts=1 to kernel cmdline). The second solution might lead to vulnerability/instability.

### VDSM side

Unlike virtual devices, host passthrough uses real host hardware, making the number of such assigned devices limited. The passthrough capability itself requires hardware that supports intel VT-d or AMD-vi. This capability can be reported through the parsing of kernel cmdline, where intel_iommu or iommu option appears. Please note that this cannot guarantee that the feature is in fully working condition, but should be sufficient on correctly configured passthrough hosts.

In order to report state of these devices, two new verbs are introduced: hostDeviceLookupByDomain and hostDeviceLookupByCapability. Both of these verbs return devices in the format stated below, the only difference are the devices returned.

    vdsCapabilities: 'hostPassthrough': 'true'
    devices: ['deviceName': [{capability': '...', 'product': '', 'vendor': ''}, vmId]]

In order to add these devices to VM, it needs to be appended to vmCreate's devices section, where device = 'hostdev' and type = 'hostdev'. Host's vdsm takes care of detaching the device and making it available to use by calling libvirt's virNodeDevice.dettach().

Reattaching of these devices is also handled by VDSM and by service verb hostDeviceReattach().

### Migration

Migration should be disabled for any VM with hostdev device.

<Category:Feature>
