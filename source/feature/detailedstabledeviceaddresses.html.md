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

#### Entity Description

A new BE GenericDevice that represents video/sound/any-other-device
==== Generic Device ==== GenericDevice will have the following properties
type - The device type (for example 'sound')
device - The device (for example 'ich6')
address - A string reprenting all address details (for example "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'")
specparams - Any device specific parameters (for example memory allocation per monitor in video device)

#### CRUD

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

#### Metadata

Adding test data for generic_device in fixtures.xml

#### DAL

Adding GenericDeviceDAO, GenericDeviceDAODbFacadeImpl , GenericDeviceDAOHibernateImpl
Adding GenericDeviceDAOTest that extends BaseGenericDaoTestCase
Adding Hash property to VmDynamic
Updating VmDynamicDAOTest to include the new Hash property Adding Address & BootOrder properties to DiskVmMap & VmNetworkInterface
Updating DiskVmMapDAOTest and VmNetworkInterfaceDAOTest to include the new Address & BootOrder properties

#### Business Logic

All places in which we send/recieve VM details are affected:

       CreateVDSCommand           - called when running a VM
       GetAllVmStatsVDSCommand    - called to get basic information (status) on all VMs
       GetVmStatsVDSCommand       - called to get basic information (status) on all one VM
       ListVDSCommand             - called to get all VM details, will be used when recognizing that hash has been changed on a VM
       refreshVdsRunTimeInfo      - called periodically to refresh VMs information and persist it to db.

#### User Experience

This feature is not exposed to the GUI in 3.1

#### Installation/Upgrade

#### User work-flows

#### Enforcement

### Dependencies / Related Features and Projects

<http://www.ovirt.org/wiki/Features/Design/StableDeviceAddresses>

### Open Issues

[Category: Feature](Category: Feature)
