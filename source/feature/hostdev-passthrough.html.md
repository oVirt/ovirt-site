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
*   Email: <mpolednik@redhat.com>

### Current status

*   Last updated date: Thu Aug 28 2014

### Host requirements

*   hardware IOMMU support (AMD-Vi, Intel VT-d enabled in BIOS)
*   enabled IOMMU support (intel_iommu=on for Intel, iommu=on for AMD in kernel cmdline)
*   RHEL7 or newer (kernel >= 3.6)

### VDSM, host side

Unlike virtual devices, host passthrough uses real host hardware, making the number of such assigned devices limited. The passthrough capability itself requires hardware that supports intel VT-d or AMD-vi. This capability can be reported through the parsing of kernel cmdline (/proc/cmdline), where intel_iommu or iommu option appears. Please note that this cannot guarantee that the feature is in fully working condition, but should be sufficient on correctly configured passthrough hosts.

In order to report state of these devices, new verb is introduced: hostdevFilterByCaps. The verb takes list as an argument where each element of the list is a string identifying the class of devices caller wants to display (pci, usb_device, usb...). If no classes are specified, all of them are displayed. vdsClient supports hostdevFilterByCaps and displays the devices as a tree. Verb return format is specified in (ref 1), tree in (ref 2).

Internally, VDSM keeps the assignments of devices to VMs in a map. Each device also holds a reference to virNodeDevice, libvirt's internal hostdev representation. This includes it's XML description (ref 3) which is parsed in order to obtain device information.

When domain with valid hostdev definition in devices section is started, VM tries to acquire() the device from mapper. Due to libvirt's inability to automatically manage USB devices and possibility for more control on our side, the host devices are running in managed=no mode, meaning the handling of device reset is given to VDSM. The acquire() call takes care of detaching the device from host (unbinding it from current drivers and binding to vfio, or pci-stub if old KVM is used - this behaviour is handled by libvirt's dettach [not misspelled] call).

The valid hostdev definition is similar to other devices and is documented in vdsm/rpc/vdsmapi-schema.json.

Acquire details: dettach() call spawns new device in /dev/vfio named after device's iommu group. The group can be read via link /sys/bus/pci/devices/$device_name/iommu_group - so for example, /dev/vfio/12 can exist. Qemu needs an access to this device, which by default is set to root:root 0600 mode. VDSM chowns and chmods this file through superVdsm to root:qemu 0660 (!! possibly through udev rule !!). VFIO uses iommu group as atomic unit for passthrough, meaning that the whole group has to be attached - this ranges from single device (sr-iov VF) to multiple devices (GPU + sound card + hub). VDSM uses devices as atomic unit (due to possibility of running single device with unsafe interrupts), attachment of whole groups is left to engine.

When domain with acquired hostdev is destroyed, the device is released back to mapper via the release() in releaseVm(). The call takes care of reattaching the device back to host (meaning unbinding from vfio driver) via libvirt's reAttach call. This call is also exposed via hostdevRelease verb, which serves as an emergency release in case mapper doesn't correctly release the device itself (you should never see this error case).

ref 1:

    devices: ['deviceName': [{'params': {'capability': '...', 'product': '', product_id: '', 'vendor': '', 'vendor_id': '', 'iommu_group', 'parent': ''}, 'vmId': ''}]]

ref 2:

    pci_0000_00_1f_2 = {'params': {'capability': 'pci',
                            'iommu_group': '11',
                            'parent': 'computer',
                            'product': '82801JI (ICH10 Family) SATA AHCI Controller',
                            'product_id': '0x3a22',
                            'vendor': 'Intel Corporation',
                            'vendor_id': '0x8086'},
                 'vmId': ''}
        scsi_host1 = {'params': {'capability': 'scsi_host', 'parent': 'pci_0000_00_1f_2'}, 'vmId': ''}
            scsi_target1_0_0 = {'params': {'capability': 'scsi_target', 'parent': 'scsi_host1'}, 'vmId': ''}
                scsi_1_0_0_0 = {'params': {'capability': 'scsi', 'parent': 'scsi_target1_0_0'}, 'vmId': ''}
                    scsi_generic_sg1 = {'params': {'capability': 'scsi_generic', 'parent': 'scsi_1_0_0_0'},
                                        'vmId': ''}

ref 3:

    <device>
      <name>pci_0000_00_19_0</name>
      <path>/sys/devices/pci0000:00/0000:00:19.0</path>
      <parent>computer</parent>
      <driver>
        <name>e1000e</name>
      </driver>
      <capability type='pci'>
        <domain>0</domain>
        <bus>0</bus>
        <slot>25</slot>
        <function>0</function>
        <product id='0x1502'>82579LM Gigabit Network Connection</product>
        <vendor id='0x8086'>Intel Corporation</vendor>
      </capability>
    </device>

### Engine side

(currently ideas, may be changed after someone with deeper understanding of engine takes a look)

Engine is given means of:

*   fetching host devices via hostdevFilterByCaps call
*   adding host devices via VM's device section
*   removing loose devices via hostdevRelease call

#### Fetching the devices and removing loose devices

The devices and their assignment to VMs should be visible in hosts tab - lower section of screen where General, Virtual Machines, Network Interfaces etc. tabs are. They could be listed in similar manner as network interfaces are, mentioning the device name, product and product_id, vendor and vendor_id and possibly iommu group along with VM they are attached to (left blank if none).

Information can be gathered via regular polling or refresh button (which should be present even while polling in order to speed up the process of hot(un)plug detection). Right clicking on the device could bring up "force release" option, that would propagate the hostdevRelease call.

#### Adding host devices

Host devices can be listed in New VM dialog as another tab on the left side (called probably host devices?). Clicking on this tab would bring table similar to one in hosts tab but showing only unassigned devices. User can select multiple devices (left to UI/UX - im not sure of the best way to accomplish this - maybe moving them like NICs from host to VM similar to "Setup Host Networks"?).

There are 2 kinds of additional information that can be helpful for UI: parent attribute of fetched devices allows for construction of a device tree. Another information is iommu_group mentioned in VDSM side: engine should implicitly auto-move iommu groups instead of devices, but still allow the user to somehow enable "device granularity", possibly through some small decouple button (on: moving a device to VM moves whole group, off: only a single device is moved) but there should be mention of additional host configuration required (vfio_iommu_type1.allow_unsafe_interrupts=1).

### Migration

Migration should be disabled for any VM with hostdev device.

### Troubleshooting

    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: error opening /dev/vfio/X: Permission denied
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device 'vfio-pci' could not be initialized

Error on VDSM side, /dev/vfio/X does not have o+rw permissions.

    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: vfio: error, group X is not viable, please ensure all devices within the iommu_group are bound to their vfio bus driver.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M.addr=0xM: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device 'vfio-pci' could not be initialized

You are trying to pass through device that is in IOMMU group with other devices. There are 2 possibilities: either add all other devices from the group or enable unsafe interrupts in vfio_iommu_type1 with allow_unsafe_interrupts=1 (append vfio_iommu_type1.allow_unsafe_interrupts=1 to kernel cmdline). The second solution might lead to vulnerability/instability.

Other: In case of device assignment failure, you can try to allow kernel to reassign devices from BIOS by appending pci=realloc to command line.

<Category:Feature>
