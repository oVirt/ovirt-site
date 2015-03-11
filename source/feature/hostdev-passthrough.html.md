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

This feature will add host device reporting and their passthrough to guests.

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpolednik@redhat.com>

### Current status

*   Last updated date: Wed Mar 4 2015

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

Unlike virtual devices, host passthrough uses real host hardware, making the number of such assigned devices limited. The passthrough capability itself requires hardware that supports intel VT-d or AMD-vi. This capability can be reported through reading /sys/class/iommu and looking for 'dmar' file. Iommu also needs to be allowed on the host, which can unreliably be detected by parsing /proc/cmdline for intel_iommu=on or iommu=on.

In order to report state of these devices, new verb is introduced: hostdevListByCaps. The verb takes list as an argument where each element of the list is a string identifying the class of devices caller wants to display (pci, usb_device, usb...). If no classes are specified, all of them are displayed. vdsClient supports hostdevFilterByCaps and displays the devices as a tree. Examples of the format are given below.

Generic:

    pci_0000_00_1f_2 = {'params': {'address': {'bus': '0',
                                            'domain': '0',
                                            'function': '2',
                                            'slot': '31'},
                                'capability': 'pci',
                                'iommu_group': '11',
                                'parent': 'computer',
                                'product': '82801JI (ICH10 Family) SATA AHCI Controller',
                                'product_id': '0x3a22',
                                'vendor': 'Intel Corporation',
                                'vendor_id': '0x8086'}}

PF:

    pci_0000_05_00_1 = {'params': {'address': {'bus': '5',
                                            'domain': '0',
                                            'function': '1',
                                            'slot': '0'},
                                'capability': 'pci',
                                'iommu_group': '15',
                                'parent': 'pci_0000_00_09_0',
                                'product': '82576 Gigabit Network Connection',
                                'product_id': '0x10c9',
                                'totalvfs': 7,
                                'vendor': 'Intel Corporation',
                                'vendor_id': '0x8086'}}

VF:

    pci_0000_05_10_1 = {'params': {'address': {'bus': '5',
                                            'domain': '0',
                                            'function': '1',
                                            'slot': '16'},
                                'capability': 'pci',
                                'iommu_group': '22',
                                'parent': 'pci_0000_00_09_0',
                                'physfn': 'pci_0000_05_00_1',
                                'product': '82576 Virtual Function',
                                'product_id': '0x10ca',
                                'vendor': 'Intel Corporation',
                                'vendor_id': '0x8086'}}

Known device classes:

    pci <- passthrough compatible
    usb
    usb_device <- passthrough compatible
    scsi <- passthrough compatible
    scsi_host
    scsi_target
    net
    storage

When domain with valid hostdev definition in devices section is started, VM tries to detach_detachable() the device. Due to libvirt's inability to automatically manage USB devices, problems with qemu not running under root user (https://bugzilla.redhat.com/show_bug.cgi?id=1196185) and possibility for more control on our side, the host devices are running in managed=no mode, meaning the handling of device reset is given to VDSM. The detach_detachable() call takes care of detaching the device from host (unbinding it from current drivers and binding to vfio, or pci-stub if old KVM is used - this behaviour is handled by libvirt's detachFlags call) and correctly setting permissions for /dev/vfio iommu group endpoint.

The valid hostdev definition is similar to other devices and is documented in vdsm/rpc/vdsmapi-schema.json.

Valid minimal host device definition for device pci_0000_05_10_1:

    {..., 'devices': [..., {'type': 'hostdev', 'device': 'pci_0000_05_10_1'}, ...], ...}

detach_detachable details: detachFlag() call spawns new device in /dev/vfio named after device's iommu group. The group can be read via link /sys/bus/pci/devices/$device_name/iommu_group or libvirt's nodeDev XML - so for example, /dev/vfio/12 can exist. Qemu needs an access to this device, which by default is set to root:root 0600 mode. VDSM chowns and chmods this file through udev rule to qemu:qemu 0600. *VFIO uses iommu group as atomic unit for passthrough*, meaning that the whole group has to be attached - this ranges from single device (SR-IOV VF) to multiple devices (GPU + sound card + hub). VDSM uses devices as atomic unit (due to possibility of running single device with unsafe interrupts), attachment of whole groups is left to engine.

When domain with specified hostdev is destroyed, the device is released back to host via the reattach_detachable() call. The call takes care of reattaching the device back to host (meaning unbinding from vfio driver) via libvirt's reAttach() call and removing udev rule file for given iommu group.

### Expected workflows

#### VM creation

1.  VDSM receives vmCreate command with valid host device definition,
2.  before XML is generated, the device is
3.  detached from the host
4.  and it's permissions are modified by generated udev rule,
5.  XML is constructed and VM is started.

The expected outcome is

*   Guest is running,
*   /dev/vfio/X (where X is iommu group of the device) exists and has qemu:qemu 0600 permissions,
*   /etc/udev/rules.d/99-vdsm-iommu_group_X.rules file exists.

#### VM removal

1.  VM is destroyed as ussual,
2.  cleanup routine takes care of reattaching the device back to host
3.  related udev rules are cleaned up

The expected outcome is:

*   Guest is correctly destroyed,
*   host devices are reattached back to the host (meaning no unused /dev/vfio/X endpoints exist),
*   udev rules related to iommu groups used are removed from the system.

#### Parsing libvirt XML of the device

Host device in the xml isn't different from other devices, therefore we have to parse it's

*   alias
*   address

The address indicates how the device is visible inside the guest.

1.  Find all host devices,
2.  construct libvirt name (pci_0000_05_10_1) from the address as seen in XML
3.  pair to existing device
4.  or if the device doesn't exist, add it to VM conf

### SR-IOV

SR-IOV capability can be found via /sys/bus/pci/devices/\`device_name\`/sriov_numvfs and sriov_totalvfs, that indicate the device SHOULD be capable of spawning multiple virtual functions. It is possible that the bus device is connected to doesn't have enough bandwidth for these virtual functions.

    echo 7 > sriov_numvfs                                                                                                                                                                    
    -bash: echo: write error: Cannot allocate memory

    dmesg | tail -n 1
    [ 9952.612558] igb 0000:07:00.0: SR-IOV: bus number out of range

VFs can be spawned by hostdevChangeNumvfs(device_name, number) call, which spawns number VFs for device_name PF. This call might fail for many reasons, resulting in failure to spawn the VFs. Reasons for failure include not enough bandwidth on the bus to handle multiple devices.

Passthrough of VF is similar to generic passthrough.

### Api

#### Structures

`
device_name
`

Structure that represents the libvirt name of the device. Such name looks like pci_0000_00_0 for pci devices, usb_usb1 for usb devices or scsi_0_0_0_0.

`
device_params
`

    {'params': {'address': {'bus': '5',
                                            'domain': '0',
                                            'function': '0',
                                            'slot': '0'},
                                'capability': 'pci',
                                'iommu_group': '15',
                                'parent': 'pci_0000_00_09_0',
                                'product': '82576 Gigabit Network Connection',
                                'product_id': '0x10c9',
                                'totalvfs': 7,
                                'vendor': 'Intel Corporation',
                                'vendor_id': '0x8086'}}

Dictionary containing all relevant information about the device as returned by libvirt.

#### Internal

`
pci_address_to_name -> domain -> bus -> slot -> function -> device_name
`

`
list_by_caps -> vmContainer -> [String] -> {device_name: device_params}
`

Where [String] is list of strings of device classes. See "known device classes".

`
get_device_params -> device_name -> device_params
`

`
detach_detachable -> device_name -> device_params
`

This call manages all actions required to successfully prepare the device for passthrough incl. detaching it and correcting ownership of the device.

`
reattach_detachable -> device_name -> ()
`

This call manages all actiosn required to successfully reattach the device back to host incl. reattaching it and removing udev files managing ownership.

`
change_numvfs -> device_name -> numvfs -> ()
`

#### External

`
hostdevListByCaps -> [device_caps] -> [vmDevice]
`

`
hostdevChangeNumvfs -> device_name -> Int -> status
`

### Cluster

Host device structure has 2 fields that are meant to be used as possible implementation of cluster support - vendor_id and product_id. Cluster model and UI could be modified to allow adding these fields as kind of "required devices" - only hosts with those devices would be cluster compatible. This would allow for a migration routine of hotunplug, migrate and hotplug. It might be possible to allow engine to create a device (defined by vendor_id and product_id and identified by name) that would be used as a required device for better UI/UX support.

### Migration

Migration should be disabled for any VM with hostdev device. This means that in order to migrate the VM, host devices need to be hotunplugged before migration and hotplugged after migration. Whether this routine should be handled by user, engine or VDSM is to be decided.

Migration of network devices IS possible using bonding but that is out of scope for the hostdev support.

### Related bugs

[Bug 1196185 - libvirt doesn't set permissions for VFIO endpoint](https://bugzilla.redhat.com/show_bug.cgi?id=1196185)

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

Other: In case of device assignment failure, you can try to allow kernel to reassign devices from BIOS by appending pci=realloc to command line (also solves "not enough MMIO resources for SR-IOV" and other "bad bios" problems).

### References

*   <https://www.kernel.org/doc/Documentation/vfio.txt>
*   <https://www.pcisig.com/specifications/iov/>
*   <http://libvirt.org/guide/html/Application_Development_Guide-Device_Config-PCI_Pass.html>
*   <https://bbs.archlinux.org/viewtopic.php?id=162768> (great post for troubleshooting)
*   <http://vfio.blogspot.cz/> (Alex Williamson's blog on VFIO)

<Category:Feature>
