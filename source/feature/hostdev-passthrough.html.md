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

### Terminology

*   SR-IOV - Single Root I/O Virtualization - technology that allows single device to expose multiple endpoints that can be passed to VMs
*   PF - Physical Function - refers to a physical device that supports SR-IOV
*   VF - Virtual Function - virtual function exposed by SR-IOV capable device
*   IOMMU group - I/O memory management unit group that incorporates multiple device DMAs on given bus
*   VFIO - Virtual Function I/O - virtualization device driver, replacement of the pci-stub driver

### Host requirements

*   hardware IOMMU support (AMD-Vi, Intel VT-d enabled in BIOS)
*   enabled IOMMU support (intel_iommu=on for Intel, iommu=on for AMD in kernel cmdline)
*   SR-IOV: SR-IOV capable hardware in bus with enough bandwidth to accomodate VFs
*   RHEL7 or newer (kernel >= 3.6)

### VDSM, host side

Unlike virtual devices, host passthrough uses real host hardware, making the number of such assigned devices limited. The passthrough capability itself requires hardware that supports intel VT-d or AMD-vi. This capability can be reported through the parsing of kernel cmdline (/proc/cmdline), where intel_iommu or iommu option appears. Please note that this cannot guarantee that the feature is in fully working condition, but should be sufficient on correctly configured passthrough hosts. SR-IOV capability can be found via /sys/bus/pci/devices/\`device_name\`/sriov_numvfs and sriov_totalvfs, that indicate the device SHOULD be capable of spawning multiple virtual functions. It is possible that the bus device is connected to doesn't have enough bandwidth for these virtual functions.

    echo 7 > sriov_numvfs                                                                                                                                                                    
    -bash: echo: write error: Cannot allocate memory

    dmesg | tail -n 1
    [ 9952.612558] igb 0000:07:00.0: SR-IOV: bus number out of range

In order to report state of these devices, new verb is introduced: hostdevListByCaps. The verb takes list as an argument where each element of the list is a string identifying the class of devices caller wants to display (pci, usb_device, usb...). If no classes are specified, all of them are displayed. vdsClient supports hostdevFilterByCaps and displays the devices as a tree. Verb return format is specified in (ref 1), tree in (ref 2).

When domain with valid hostdev definition in devices section is started, VM tries to detach_if_detachable() the device. Due to libvirt's inability to automatically manage USB devices and possibility for more control on our side, the host devices are running in managed=no mode, meaning the handling of device reset is given to VDSM. The detach_if_detachable() call takes care of detaching the device from host (unbinding it from current drivers and binding to vfio, or pci-stub if old KVM is used - this behaviour is handled by libvirt's detachFlags call).

The valid hostdev definition is similar to other devices and is documented in vdsm/rpc/vdsmapi-schema.json.

detach_if_detachable details: detachFlag() call spawns new device in /dev/vfio named after device's iommu group. The group can be read via link /sys/bus/pci/devices/$device_name/iommu_group or libvirt's nodeDev XML - so for example, /dev/vfio/12 can exist. Qemu needs an access to this device, which by default is set to root:root 0600 mode. VDSM chowns and chmods this file through udev rule to qemu:qemu 0600. *VFIO uses iommu group as atomic unit for passthrough*, meaning that the whole group has to be attached - this ranges from single device (SR-IOV VF) to multiple devices (GPU + sound card + hub). VDSM uses devices as atomic unit (due to possibility of running single device with unsafe interrupts), attachment of whole groups is left to engine.

When domain with specified hostdev is destroyed, the device is released back to host via the reattach_if_detachable() call. The call takes care of reattaching the device back to host (meaning unbinding from vfio driver) via libvirt's reAttach() call. This call is also exposed via hostdevRelease verb, which serves as an emergency release in case VDSM doesn't correctly release the device itself (you should never see this error case).

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

### SR-IOV

*   to be discussed
*   possibly report numvfs and totalvfs in PV definition
*   possibly report PV in VF definition
*   should VF spawning be handled by engine or user? (possible VT-d, iommu etc. complications)

### Engine side

(currently ideas, may be changed after someone with deeper understanding of engine takes a look)

Engine is given means of:

*   fetching host devices via hostdevListByCaps call
*   adding host devices via VM's device section
*   removing loose devices via hostdevRelease call

#### Fetching the devices and removing loose devices

The devices and their assignment to VMs should be visible in hosts tab - lower section of screen where General, Virtual Machines, Network Interfaces etc. tabs are. They could be listed in similar manner as network interfaces are, mentioning the device name, product and product_id, vendor and vendor_id and possibly iommu group along with VM they are attached to (left blank if none).

Information can be gathered via regular polling or refresh button (which should be present even while polling in order to speed up the process of hot(un)plug detection). Right clicking on the device could bring up "force release" option, that would propagate the hostdevRelease call.

#### Adding host devices

Host devices can be listed in New VM dialog as another tab on the left side (called probably host devices?). Clicking on this tab would bring table similar to one in hosts tab but showing only unassigned devices. User can select multiple devices (left to UI/UX - im not sure of the best way to accomplish this - maybe moving them like NICs from host to VM similar to "Setup Host Networks"?).

There are 2 kinds of additional information that can be helpful for UI: parent attribute of fetched devices allows for construction of a device tree. Another information is iommu_group mentioned in VDSM side: engine should implicitly auto-move iommu groups instead of devices, but still allow the user to somehow enable "device granularity", possibly through some small decouple button (on: moving a device to VM moves whole group, off: only a single device is moved) but there should be mention of additional host configuration required (vfio_iommu_type1.allow_unsafe_interrupts=1).

### Cluster

Host device structure has 2 fields that are meant to be used as possible implementation of cluster support - vendor_id and product_id. Cluster model and UI could be modified to allow adding these fields as kind of "required devices" - only hosts with those devices would be cluster compatible. This would allow for a migration routine of hotunplug, migrate and hotplug. It might be possible to allow engine to create a device (defined by vendor_id and product_id and identified by name) that would be used as a required device for better UI/UX support.

### Migration

Migration should be disabled for any VM with hostdev device. This means that in order to migrate the VM, host devices need to be hotunplugged before migration and hotplugged after migration. Whether this routine should be handled by user, engine or VDSM is to be decided.

Migration of network devices IS possible using bonding but that is out of scope for the hostdev support.

### Troubleshooting

    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: error opening /dev/vfio/X: Permission denied
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=NN:NN.N,id=hostdevN,bus=pci.N,addr=0xN: Device 'vfio-pci' could not be initialized

Error on VDSM side, /dev/vfio/X does not have correct permissions.

    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: vfio: error, group X is not viable, please ensure all devices within the iommu_group are bound to their vfio bus driver.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M.addr=0xM: vfio: failed to get group X
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device initialization failed.
    qemu-kvm: -device vfio-pci,host=MM:MM.M,id=hostdevM,bus=pci.M,addr=0xM: Device 'vfio-pci' could not be initialized

You are trying to pass through device that is in IOMMU group with other devices. There are 2 possibilities: either add all other devices from the group or enable unsafe interrupts in vfio_iommu_type1 with allow_unsafe_interrupts=1 (append vfio_iommu_type1.allow_unsafe_interrupts=1 to kernel cmdline). The second solution might lead to vulnerability/instability.

Device is stuck in acquired mode even if the VM isn't running: use service hostdevRelease <deviceName> call.

Other: In case of device assignment failure, you can try to allow kernel to reassign devices from BIOS by appending pci=realloc to command line (also solves "not enough MMIO resources for SR-IOV" and other "bad bios" problems)

### References

*   <https://www.kernel.org/doc/Documentation/vfio.txt>
*   <https://www.pcisig.com/specifications/iov/>
*   <http://libvirt.org/guide/html/Application_Development_Guide-Device_Config-PCI_Pass.html>
*   <https://bbs.archlinux.org/viewtopic.php?id=162768> (great post for troubleshooting)

<Category:Feature>
