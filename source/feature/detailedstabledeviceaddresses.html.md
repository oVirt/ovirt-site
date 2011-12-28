---
title: DetailedStableDeviceAddresses
category: feature
authors: doron, ekohl, emesika
wiki_category: Feature
wiki_title: Features/Design/DetailedStableDeviceAddresses
wiki_revision_count: 52
wiki_last_updated: 2012-03-14
wiki_warnings: list-item?
---

# Detailed Stable Device Addresses

## Stable Device Addresses

### Summary

Allow devices in guest virtual machines to retain the same device address allocations as other devices are added or removed from the guest configuration. This is particularly important for Windows guests in order to prevent warnings or reactivation when device addresses change.
In the term Device we include PCI, VirtIO Serial, SCSI, IDE, CCID and actually anything libvirt supports.

### Owner

*   Feature owner: [ Eli Mesika](User:emesika)

    * GUI Component owner: Not Relevant

    * REST Component owner: Not Relevant

    * Engine Component owner: [ Eli Mesika](User:emesika)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Design Stage
*   Last updated date: Wed December 28 2011

### Detailed Description

When creating a VM, QEMU allocates device addresses to the guest devices, these addresses are being reported by libvirt to VDSM and VDSM should report it back to RHEVM. RHEVM should persist the device addresses and report it as part of the VM configuration on the next run. If a change to the VM devices occurred RHEVM should detect the change and persist the new device addresses.

### Entity Description

A new BE GenericDevice that represents video/sound/any-other-device
==== Generic Device ==== GenericDevice will have the following properties
type - The device type (for example 'sound')
device - The device (for example 'ich6')
address - A string reprenting all address details (for example "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'")
specparams - Any device specific parameters (for example memory allocation per monitor in video device)

### CRUD

New table generic_device :

       device_id              -- Unique identifier of the generic device
       device                 -- The device type (for example : sound, video etc.)
       vm_id                  -- The VM id (FK of vm_static.vm_id)
       device_specparams      -- The device special parameters, for example ('display': 'vnc')
       device_address         -- The device address as a string

*   Adding CRUD SPs for generic_device table.

Adding hash column to vm_dynamic:

       hash                -- holds the md5 like encryption indicating a change 

*   Update relevant Views & SPs to include the hash column

Adding address and boot_order to disk_vm_map and vm_interface.
This should be done in the mapping table in order to support the Shared Disk feature when a disk can be shared by multiple VMs:

       address             -- The interface address string
       boot_order          -- The device boot order

*   Update relevant Views & SPs to include the address & boot_order columns

Adding shared flag to disks :

       shared              -- Indicates if disk is shared between multiple VMs

*   Update relevant Views & SPs to include the shared column

### DAL

Adding GenericDeviceDAO, GenericDeviceDAODbFacadeImpl , GenericDeviceDAOHibernateImpl
Adding GenericDeviceDAOTest that extends BaseGenericDaoTestCase
Adding Hash property to VmDynamic
Updating VmDynamicDAOTest to include the new Hash property Adding Address & BootOrder properties to DiskVmMap & VmNetworkInterface
Updating DiskVmMapDAOTest and VmNetworkInterfaceDAOTest to include the new Address & BootOrder properties

#### Metadata

Adding test data for generic_device in fixtures.xml

### Business Logic

All places in which we send/receive VM details are affected:

       CreateVDSCommand           - called when running a VM
       GetAllVmStatsVDSCommand    - called to get basic information (status) on all VMs
       GetVmStatsVDSCommand       - called to get basic information (status) on all one VM
       ListVDSCommand             - called to get all VM details, will be used when recognizing that hash has been changed on a VM
       refreshVdsRunTimeInfo      - called periodically to refresh VMs information and persist it to db.

In order to support both old (under 3.1) structure and new structure (3.1 and above), we will have to re-factor current code in above classes. This will be done by creating a VMInfoManagerBase class that will implement all shared code and define protected methods that can be overridden by its descendants.
We will have to create VMMixedInfoManager and VMDeviceInfoManager both extends VMInfoManagerBase.
VMMixedInfoManager stands for old (under 3.1) structure
VMDeviceInfoManager stands for new structure (3.1 and above)
We will have a factory method in the relevant classes that will return the relevant VMInfoManagerBase instance depending on VM Cluster Compatibility version. Those classes will handle both composing the right structure for VDSM when a VM is created and getting VM information from VDSM in order to update our persistent layer after calling Get\*VdsStatsComamnd , ListVdsCommand

#### Flow

create:

       query cluster to get version comparability value
       3.0 and below => create VMMixedInfoManager and calls methods in it to compose structural info for VDSM
       3.1 and above => create VMDeviceInfoManager and calls methods in it to compose structural info for VDSM

refreshVdsRunTimeInfo:

       query cluster to get version comparability value
       3.0 and below => create VMMixedInfoManager and calls methods in it to persist data from structural info from VDSM
         run on all VMs and do old logic 
       3.1 and above => create VMDeviceInfoManager aand calls methods in it to persist data from structural info from VDSM
         run on all VMs 
         compare hash value if different add VM to change list
         call List requesting long format for all VMs in the changed list
         persist changes in DB 

#### Migration

We will use cluster level decision, since we will have to support migration from host to host in the same Cluster. New API for both sending (create) and receiving (get\*VmStats, List) information will use VM parameters as a structured dictionary

#### Device Index

Manage internal unique index for 'iface' virtio' or 'ide' Same ordering as in old format should be kept in order to support 3.0 VMs that starts to run on 3.1 cluster

#### Managing Addresses

Addresses are kept in the database as a plain-text strings. However, when passed to VDSM addresses should be structured as dictionaries.
Example
DB:

       "type='drive' controller='0' bus='0' unit='0'"

Structure:

       { type='drive',
         controller='0',
         bus='0',
         unit='0' }

#### Video Cards

In new format we will have to add some logic when handling video cards.
Up to 3.1, we were passing spiceMonitors, this described the number of monitors used by the VM and memory allocation calculation per video card was sone by VDSM
In new format, we will have to send each video card as a generic device and calculate the memory allocation, the result will be passed to vdsm as the specparams value.

#### Import/Export

OvfVmReader and OvfVmWriter should be enhanced to support:

       shared disk flag
       boot order
       address
       manage Floppy/CDROM as a device

Those changes should bee coordinated with the OVF team.

### User Experience

This feature is not exposed to the GUI in 3.1

### Installation/Upgrade

In order to prevent data duplication we will tend to upgrade some old data to new format and still be backward compatible.
issues:

       Boot Order    - migrate boot order info to new format even from VMs that are in old (under 3.1) clusters
       Floppy/CDROM  - migrate Floppy/CDROM to be stored as a disk
       Sound/Video   - migrate as Generic Device

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

*   Engine-core
*   VDSM

#### Hot Plug Disk/Nic

Since managing this is via backend, we always assume that we get the exact Disk/Nic number as we know already.
In case that we got a device that is nor recognized (even if it a Hot Plug) , it will be handled as a Generic Device

#### Optional Disk

We should support and persist an optional disk , this is implemented as a new attribute of the disk entry in the API.
Optional flag is passed as static false in 3.1

#### Direct LUN

Direct LUN enables adding a block device to the system either by its GUID or UUID

### Documentation / External references

<http://www.ovirt.org/wiki/Features/Design/StableDeviceAddresses>

### Open Issues

[Category: Feature](Category: Feature)
