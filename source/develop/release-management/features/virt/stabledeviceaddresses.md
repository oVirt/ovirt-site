---
title: StableDeviceAddresses
authors: emesika, ilvovsky, shahar, ykaul
---

# Stable Device Addresses

## Summary

This document describes the design for the stable Device addresses feature.

In the term Device we include PCI, VirtIO Serial, SCSI, IDE, CCID and actually anything libvirt supports.

Allow devices in guest virtual machines to retain the same device address allocations as other devices are added or removed from the guest configuration.
This is particularly important for Windows guests in order to prevent warnings or reactivation when device addresses change.

This feature is supported by libvirt and should be implemented by oVirt Engine and VDSM.

When creating a VM, QEMU allocates device addresses to the guest devices, these addresses are being reported by libvirt to VDSM and VDSM should report it back to oVirt Engine. oVirt Engine should persist the device addresses and report it as part of the VM configuration on the next run. If a change to the VM devices occurred oVirt Engine should detect the change and persist the new device addresses.

## Owner

*   Feature owner: Eli Mesika (emesika)
*   GUI Component owner: Not Relevant
*   REST Component owner: Not Relevant
*   Engine Component owner: Eli Mesika (emesika)
*   QA Owner: Yaniv Kaul (ykaul)

## Current status

*   Target Release: 3.1
*   Status: Done
*   Last updated date: Wed Mar 14 2012
*   Email: <emesika@redhat.com>

**The general implementation concepts are:**

1. The 'create' verb should get a new parameter in the XML describing the device addresses of the VM.
   This parameter is optional and if not given VDSM should learn the device addresses from libvirt.
2. The device addresses are not being parsed by oVirt Engine, they are persisted as is without manipulations of the data.
3. The 'getAllVmStats' verb should report the hash of the device addresses of the VMS.
4. If a change is detected by RHEVM to the device addresses (the reported hash was changed), it should query VDSM 
   for the full VM configuration by using the 'list' verb with the 'long' format and the list of changed VMs.
5. The list verb should report the device addresses as part of the VM configuration.

**Notes:**

1. Export - the device addresses should be part of the exported configuration of the VM.
2. Import - the device addresses should be part of the imported configuration of the VM.
3. The 'list' verb reports the full configuration of all the VMs on the host. 
   This verb was extended to support a given list of VMs to avoid the overhead of reporting all VMs 
   configuration while only a small group is needed.

## GUI

Feature is not exposed currently to the GUI.

### Mockups

### Design

## REST Design (Modeling)

Feature is not exposed currently to the REST API.

## Engine

This section describes the backend design for this feature.

### API

Old API will be supported for Clusters with Compatibility Version under 3.1 Sample:
{% highlight json %}
     'bridge': 'rhevm,rhevm,rhevm,rhevm,rhevm,rhevm,rhevm',
     'acpiEnable': 'true',
     'emulatedMachine': 'rhel6.2.0',
     'vmId': '27c61cea-f4fd-47e9-84e8-d1598f32ccc0',
     'transparentHugePages': 'true',
     'spiceSslCipherSuite': 'DEFAULT',
     'cpuType': 'Nehalem',
     'smp': '1',
     'macAddr':'00:1a:4a:16:99:42,00:1a:4a:16:99:43,00:1a:4a:16:99:44,00:1a:4a:16:99:45,00:1a:4a:16:99:46,00:1a:4a:16:99:47,00:1a:4a:16:99:48',
     'boot': 'cdn',
     'custom': {},
     'vmType': 'kvm',
     'memSize': 512,
     'smpCoresPerSocket': '1',
     'vmName': 'ingale',
     'spiceMonitors': '4',
     'nice': '0',
     'floppy':'/rhev/data-center/4996348b-0199-435a-b01d-94cdf67d2d83/c37e94b2-b130-49b4-a7aa-b30e8a372878/images/11111111-1111-1111-1111-111111111111/win2k3.vfd',
     'drives': [
            {'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
             'format': 'cow',
             'bus': '0',
             'boot': 'true',
             'volumeID': 'be4d8588-8771-47cd-8954-b67566b6bd55',
             'imageID': '5f6852c8-844c-40ff-ac9c-cac5d00cbf1b',
             'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
             'propagateErrors': 'off',
             'if': 'virtio'},
            {'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
             'format': 'raw',
             'bus': '1',
             'boot': 'false',
             'volumeID': '9dd6b03a-2391-4537-8247-1bd786f60bdc',
             'imageID': 'f6bdcc45-bb73-45d1-975d-15d6eefe7eda',
             'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
             'propagateErrors': 'off',
             'if': 'virtio'},
            {'index': '0',
             'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
             'format': 'raw',
             'volumeID': '1745eb41-1432-422b-af6f-8b8c8dd3365c',
             'imageID': '8904d42d-c974-4055-a973-e6d7eb75e4ee',
             'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
             'propagateErrors': 'off',
             'if': 'ide'}],/home/emesika/backup/db/engine/
     'cdrom':'/rhev/data-center/4996348b-0199-435a-b01d-94cdf67d2d83/c37e94b2-b130-49b4-a7aa-b30e8a372878/images/11111111-1111-1111-1111-111111111111/en_windows_7_enterprise_x64_dvd_x15-70749.iso',
     'nicModel': 'pv,pv,pv,pv,rtl8139,e1000,e1000',
     'keyboardLayout': 'en-us',
     'kvmEnable': 'true',
     'displayNetwork': 'rhevm',
     'soundDevice': 'ich6',
     'timeOffset': '0',
     'spiceSecureChannels': 'smain,sinputs',
     'display': 'qxl'
{% endhighlight %}

### New API

New API will be used for Clusters with Compatibility Version 3.1 or upper

VDSM will distinguish if a new format or old format was sent according to existence/absence of the 'devices' key

Sample :
{% highlight json %}
     'vmId': '27c61cea-f4fd-47e9-84e8-d1598f32ccc0',
     'vmName': 'myVM',
     'acpiEnable': 'true', 
     'emulatedMachine': 'rhel6.2.0', 
     'vmType': 'kvm',
     'memSize': 512,
     'smpCoresPerSocket': '1',
     'transparentHugePages': 'true',
     'cpuType': 'Nehalem',
     'smp': '1',
     'keyboardLayout': 'en-us',
     'kvmEnable': 'true',
     'nice': '0',
     'timeOffset': '0',
     'spiceSslCipherSuite': 'DEFAULT',
     'spiceSecureChannels': 'smain,sinputs',
     'displayNetwork': 'rhevm',
     'display': 'qxl|vnc',
     'custom': {},
     'devices': [   
            {'type': 'disk',
             'device': 'disk',
             'index':
{% endhighlight %}
     DB Design

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

### DB Upgrade

In order to prevent data duplication we will tend to upgrade some old data to new format and still be backward compatible. Examples : boot order,floppy/CDROM as a disk ...

## Logic Design

We will keep a hash the database, the hash will enable us distinguish when a change occurs, if hash changed we have to get the new full structured data using the List (full) verb and save it to the database.

### Migration

We will use cluster level decision, since we will have to support migration from host to host in the same Cluster. New API for both sending (create) and receiving (get\*VmStats, List) information will use VM parameters as a structured dictionary

create/run

------------------------------------------------------------------------

Upon VM creation , send structure with empty string in missing information (addresses etc.) Otherwise, fill structure with persistent values and send it to VDSM

update

------------------------------------------------------------------------

refreshVdsRunTimeInfo is called

      GetAllVMStats is called 
         For each VM info 
           if (hash from vdsm  hash from db)
                  add VM to changed-vm-list
         next
      if (changed-vm-list length > 0)
         Issue a call to vdsm list command with 'long' & changed-vm-list[1]
         For each VM in list 
            persist all changed data in db.
            update hash for VM in db
         next 
      end

[1] New vdsm list command syntax allows that :

vdsClient 0 list --help list

            [view] [vms:vmId1,vmId2]
            Lists all available machines on the specified server.
            Optional vms list, should start with 'vms:' and follow with 'vmId1,vmId2,...'
            Optional views:
                "long"   all available configuration info (Default).
                "table"  table output with the fields: vmId, vmName, Status and IP.
                "ids"    all vmIds.

export

------------------------------------------------------------------------

OVFWriter should be extended to write the information retrieved in the new structure from VDSM to the OVF file. Change should be coordinated with OVF team.

import

------------------------------------------------------------------------

OVFReader should be extended to read the information retrieved in the new structure from VDSM from the OVF file.


### API Design

VM/vm_dynamic entities should have additional hash properties
 New VmDevice BE and VmDeviceDAO to handle all changes on vm_device

### Unmanaged Device

Unmanaged Device will be supported in the new format and will include all unhandled devices as sound/controller/etc and future devices. Those devices will be persistent and will have Type , SubType (device specific) and an Address. For 3.1 an unmanaged Device is not exposed to any GUI/REST API. Unmanaged devices are passed to vdsm inside a Custom property. VDSM in it turn is passing this as is for possible hook processing.

### Floppy / CDROM

Floppy and CDROM will be typed as disk where its subtype is 'floppy' or 'cdrom'

### Boot Order

Boot order is a device property (just for subgroup of all available devices), We should add and persist boot order to all relevant entities

### Managed and un-managed devices

In general, each device that backend knows to recognize by itself is a managed device (its is_managed flag in vm_device is set to true) Each device that we are learning via vdsm is considered as un-managed device. There is one exception for this rule, we will handle a SpecialManagedDevices white-list in vdc-options. This list will include a list of <type></type><device></device> that are special. It means that even if we learn this device from vdsm, still his is_managed flag will be set to true. When passing information to vdsm, backend will pass all managed devices in the device map while un-managed devices are passed in the Custom Properties as a string (with the same format as in the device section) When getting information from vdsm, we will consider only devices in the device map. We assume that if a hook was activated on the Custom Properties we have sent for a VM and adds any device, we will get it from vdsm on the next refresh as a device in the device map from vdsm.

### Action Table Map

The following table summarizes the possible scenarios when getting data from VDSM and comparing it with backend data stored in the database

Note also that if a device is sent by backend but VDSM don't get it from libvirt, it will not be returned by VDSM to the backend.

Attach /Detach and Plug/Unplug will update vm_device in the appropriate commands as follows:
 Attach /Detach - Add/Remove from vm_device
 Plug/Unplug - Set/Reset address field of the device in vm_device

## VDSM

Adding support for hash parameter in Create. Return the hash value for each VM when calling GetAllVMStats. Return the full VM structure for each VM when calling List with 'long' format Enable to pass additional parameter specifying VM ids.

## Tests

Add tests for new VM device DAL
 Modify all tests to track new added properties

### Expected unit-tests

Verify that all new Device DAO tests pass Verify that all VM DAO tests pass Verify that all Disk DAO and Disk VM mapping DAO tests pass Test both old & new OVFs for export/import

### Pre-integration needs

This feature requires pre-integration since we have to play with devices on various VM configuration. Extensive check of Import/Export of both new & old formats. In addition backward compatibility should be tested as well in order to verify that 3.0 VMs preserve and restore all properties under the new implementation.

## Design check list

This section describes issues that might need special consideration when writing this feature. Better sooner than later :-)

     1. Installer / Upgrader
      a. ....
     1. DB Upgrade
      a. Add hash & domxml new columns to vm_dynamic.
     1. MLA
      a. ....
     1. Migrate
      a. ...
     1. Compatibility levels
      a. Supported DC versions ....
      a. Supported Cluster versions ....
     1. Backward compatibility issues
     1. API changes (changes required in the API between components (GUI/REST  Backend  VDSM  libvirt))
      a. Backend  VDSM (See VDSM section)
       1. ....
     1. Effected features - Other features that might be effected by the change (workflow changes, utilities, ...)
      a. .....
     1. Performance requirements / tests
      a. Is there a special performance requirement for this feature?
      a. Are there special performance tests we want to make on this feature?
     1. Test cases
      a. Describe here the basic test cases for the feature
     1. Feature tracker bugs
     1. References
      a. Bugzilla
         https://bugzilla.redhat.com/show_bug.cgi?id=745274
      a. Mailing lists
      a. Other relevant wiki pages
         http://fedoraproject.org/wiki/Features/KVM_Stable_PCI_Addresses
      a. Other relevant technical documents

## Open Issues

     1. Direct LUN considerations.
     2. What happens to a Hot Plug device if the Cluster is downgraded from 3.1 to 3.0 ?
     3. Regarding boot sequence: We currently have default boot sequence in the template level. 
        The question is how this is handled in moving from 3.0 to 3.1 and vice verse
        a) 3.0 to 3.1 - we will have to write the logic that tries to match the conversion from current Enum BootSequence value to the new format
        b) 3.1 to 3.0 - we have a problem here either we :
          I) Do Best Effort and covert to the closet BootSequence Enum
          II)or , we can store the templates default boot sequence in the vm_device table as well

## Known Issues / Risks

Main issues are backward compatibility and affect of new 3.1 features.

### Index

Manage internal unique index for 'iface' virtio' or 'ide' Same ordering as in old format should be kept in order to support 3.0 VMs that starts to run on 3.1 cluster When a VM that run perviously on 3.0 cluster starts to run for the first time on a 3.1 cluster, we must send its devices in the same order to VDSM, if this is not done, libvirt can not guarantee that devices will preserve their addresses.
 We currently maintain an index only for Floppy (index 0) and CD (index 2)

### Hot Plug Disk/Nic

Since managing this is via backend, we always assume that we get the exact Disk/Nic number as we know already. In case that we got a device that is not recognized (even if it a Hot Plug) , it will be handled as a unmanaged Device

### Optional Disk

We should support and persist an optional disk , this is implemented as a new attribute of the disk entry in the API. Optional flag is passed as static false in 3.1

### Direct LUN

Direct LUN enables adding a block device to the system either by its GUID or UUID TBD

### Live Snapshots

This 3.1 feature does not affect directly the Stable Device Addresses feature, however, it does affect the import/export and the OVF structure. Details about that will be added as part of 3.1 snapshot changes documentation.

## Implementation needs

     1. None

## Needed documentation

     1. OVF Documentation
     2. Release Notes
