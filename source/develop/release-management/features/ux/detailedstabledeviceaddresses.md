---
title: DetailedStableDeviceAddresses
category: feature
authors: doron, ekohl, emesika
---

# Detailed Stable Device Addresses

## Stable Device Addresses

### Summary

Allow devices in guest virtual machines to retain the same device address allocations as other devices are added or removed from the guest configuration. This is particularly important for Windows guests in order to prevent warnings or reactivation when device addresses change.
In the term Device we include PCI, VirtIO Serial, SCSI, IDE, CCID and actually anything libvirt supports.

### Owner

*   Feature owner: Eli Mesika (emesika)

    * GUI Component owner: Not Relevant

    * REST Component owner: Not Relevant

    * Engine Component owner: Eli Mesika (emesika)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Done
*   Last updated date: Wed Mar 14 2012

### Detailed Description

When creating a VM, QEMU allocates device addresses to the guest devices, these addresses are being reported by libvirt to VDSM and VDSM should report it back to RHEVM. RHEVM should persist the device addresses and report it as part of the VM configuration on the next run. If a change to the VM devices occurred RHEVM should detect the change and persist the new device addresses.

### Entity Description

A new BE VmDevice that represents video/controller/any-other-device

#### VM Device
`VmDevice` will have the following properties

* `vmId` - VM or template Id
* `type` - The device type (for example 'sound')
* `device` - The device (for example 'ich6')
* `address` - A string reprenting all address details (for example "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'")
* `bootOrder` - The device boot order
* `specparams` - Any device specific parameters (for example memory allocation per monitor in video device)
* `isManaged` - Is the device managed
* `isPlugged` - Is the device plugable
* `isReadOnly` - The device access mode

### CRUD

New table vm_device:

       device_id           -- Unique identifier of the VM device
       vm_id               -- The VM/Template id (FK of vm_static)
       type                -- The type  (for example : disk, interface etc.)
       device              -- The device (for example : floppy, cdrom etc.)
       address             -- The device address as a string
       boot_order          -- The device boot order
       spec_params         -- The device special parameters, for example ('display': 'vnc')
       is_managed          -- Indicates if the device is managed 
       is_plugged          -- Indicates if device is plugable
       is_readonly         -- Indicates if device is read-only.

Adding a column to vm_dynamic:

       hash                -- holds the md5 like hash indicating a change 

Generation CRUD SPs for the new vm_device table Modify all relevant views & SP to have the hash field.

#### image_vm_map table

This table becomes redundant since all information is already contained in vm_device.
Upgrade will drop this table after data is ported to vm_device table.
A view with the same name (image_vm_map) will be created on top of vm_device to support current code.

### DAL

Adding VmDeviceDAO, VmDeviceDAODbFacadeImpl , VmDeviceDAOHibernateImpl
Adding VmDeviceDAOTest that extends BaseGenericDaoTestCase
Adding Hash property to VmDynamic
Updating VmDynamicDAOTest to include the new Hash property

#### Metadata

Adding test data for vm_device in fixtures.xml

### Business Logic

All places in which we send/receive VM details are affected:

       CreateVDSCommand           - called when running a VM
       GetAllVmStatsVDSCommand    - called to get basic information (status) on all VMs
       GetVmStatsVDSCommand       - called to get basic information (status) on all one VM
       ListVDSCommand             - called to get all VM details, will be used when recognizing that hash has been changed on a VM
       refreshVdsRunTimeInfo      - called periodically to refresh VMs information and persist it to db.

In order to support both old (under 3.1) structure and new structure (3.1 and above), we will have to re-factor current code in above classes. This will be done by creating a VMInfoManagerHelper class that will implement all shared code as device indexing etc.
We will have to create VMOldInfoManager and VMInfoManager VM30InfoManager stands for old (under 3.1) structure
VMInfoManager stands for new structure (3.1 and above)
Both VMOldInfoManager and VMInfoManager implement a common VMInfoManagerInterface interface
We will have a factory method in the relevant CreateVDSCommand and refreshVdsRunTimeInfo that will create the proper class instance depending on VM Cluster Compatibility version.
Those classes will handle both composing the right structure for VDSM when a VM is created and getting VM information from VDSM in order to update our persistent layer after calling Get\*VdsStatsComamnd , ListVdsCommand

![](/images/wiki/Vmmanagerinfo.png)

#### Flow

create:

       query cluster to get version comparability value
       3.0 and below => create VMOldInfoManager and calls methods in it to compose structural info for VDSM
       3.1 and above => create VMInfoManager and calls methods in it to compose structural info for VDSM

refreshVdsRunTimeInfo:

       query cluster to get version comparability value
       3.0 and below => create VMOldInfoManager and calls methods in it to persist data from structural info from VDSM
         run on all VMs and do old logic 
       3.1 and above => create VMInfoManager and calls methods in it to persist data from structural info from VDSM
         run on all VMs 
         compare hash value if different add VM to change list
         call List requesting long format for all VMs in the changed list
         persist changes in DB

![](/images/wiki/Flow.png)

#### Migration

We will use cluster level decision, since we will have to support migration from host to host in the same Cluster. New API for both sending (create) and receiving (get\*VmStats, List) information will use VM parameters as a structured dictionary

#### Boot Order

Boot order is currently managed as a int field in vm_dynamic table, the reflects an enumerator in the BLL having values 1-14 representing comminations of boot sources (Hard Drive, CD, Network) This is changed as we will handle boot sequence in both disks & vm_interface table as a running number representing the order of the device in the boot process.

#### Device Index

Manage internal unique index for 'iface' virtio' or 'ide' Same ordering as in old format should be kept in order to support 3.0 VMs that starts to run on 3.1 cluster
Relevant only for Floppy and CD

#### Managing Addresses

Addresses are kept in the database as a plain-text strings. However, when passed to VDSM addresses should be structured as dictionaries.
Example
DB:

       "type='drive' controller='0' bus='0' unit='0'"

Structure:

       { type='drive',
         controller='0',
         bus='0',
         unit='0' }

#### Video Cards

In new format we will have to add some logic when handling video cards.
Up to 3.1, we were passing spiceMonitors, this described the number of monitors used by the VM and memory allocation calculation per video card was sone by VDSM
In new format, we will have to send each video card as a VM device and calculate the memory allocation, the result will be passed to vdsm as the specparams value.

#### Import/Export

OvfVmReader and OvfVmWriter should be enhanced to support:

       is_plugged flag
       access_mode
       boot order
       address
       manage Floppy/CDROM as a device

Those changes should bee coordinated with the OVF team.


### User Experience

This feature is not exposed to the GUI in 3.1

### Installation/Upgrade

In order to prevent data duplication we will tend to upgrade some old data to new format and still be backward compatible.
issues:

       Boot Order    - migrate boot order info to new format even from VMs that are in old (under 3.1) clusters
       Floppy/CDROM  - migrate Floppy/CDROM to be stored as a disk
       Sound/Video   - migrate as Vm Device

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

*   Engine-core
*   VDSM

#### Hot Plug Disk/Nic

Since managing this is via backend, we always assume that we get the exact Disk/Nic number as we know already.
In case that we got a device that is nor recognized (even if it a Hot Plug) , it will be handled as a Generic Device

*   Note that there's a difference between Attach / Detach, Plug / Unplug.
    1.  Attach / Detach should cause addition / deletion of entries to vm_device table.
    2.  Plug / Unplug should change the isPlug flag (default is null).
        -   When a device is unplugged, it's flag is set to False, and its address should be deleted.

#### Optional Disk

We should support and persist an optional disk , this is implemented as a new attribute of the disk entry in the API.
Optional flag is passed as **hard-coded False** in 3.1

#### Direct LUN

Direct LUN enables adding a block device to the system either by its GUID or UUID

### Documentation / External references

[Features/Design/StableDeviceAddresses](/develop/release-management/features/virt/stabledeviceaddresses.html)

### Open Issues


