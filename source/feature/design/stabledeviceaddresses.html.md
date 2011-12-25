---
title: StableDeviceAddresses
authors: emesika, ilvovsky, shahar, ykaul
wiki_title: Features/Design/StableDeviceAddresses
wiki_revision_count: 62
wiki_last_updated: 2012-03-14
---

# Stable Device Addresses

This document describes the design for the stable Device addresses feature.

In the term Device we include PCI, VirtIO Serial, SCSI, IDE, CCID and actually anything libvirt supports.

Allow devices in guest virtual machines to retain the same device address allocations as other devices are added or removed from the guest configuration. This is particularly important for Windows guests in order to prevent warnings or reactivation when device addresses change.

This feature is supported by libvirt and should be implemented by RHEVM and VDSM.

When creating a VM, QEMU allocates device addresses to the guest devices, these addresses are being reported by libvirt to VDSM and VDSM should report it back to RHEVM. RHEVM should persist the device addresses and report it as part of the VM configuration on the next run. If a change to the VM devices occurred RHEVM should detect the change and persist the new device addresses.

**The general implementation concepts are:**

      1. The 'create' verb should get a new parameter in the XML describing the device addresses of the VM.
         This parameter is optional and if not given VDSM should learn the device addresses from libvirt.
      2. The device addresses are not being parsed by RHEVM, they are persisted as is without manipulations of the data.
      3. The 'getAllVmStats' verb should report the hash of the device addresses of the VMS.
      4. If a change is detected by RHEVM to the device addresses (the reported hash was changed), it should query VDSM 
         for the full VM configuration by using the 'list' verb with the 'long' format and the list of changed VMs.
      5. The list verb should report the device addresses as part of the VM configuration.

**Notes:**

      1. Export - the device addresses should be part of the exported configuration of the VM.
      2. Import - the device addresses should be part of the imported configuration of the VM.
      3. The 'list' verb reports the full configuration of all the VMs on the host. 
         This verb was extended to support a given list of VMs to avoid the overhead of reporting all VMs 
         configuration while only a small group is needed.

### GUI

Feature is not exposed currently to the GUI.

#### Mockups

#### Design

### REST Design (Modeling)

Feature is not exposed currently to the REST API.

### Backend

This section describes the backend design for this feature.

#### API

Old API will be supported for Clusters with Compatibility Version under 3.1 Sample:

      'bridge': 'rhevm,rhevm,rhevm,rhevm,rhevm,rhevm,rhevm',
      'acpiEnable': 'true',
      'emulatedMachine': 'rhel6.2.0',
      'vmId': '27c61cea-f4fd-47e9-84e8-d1598f32ccc0',
      'transparentHugePages': 'true',
      'spiceSslCipherSuite': 'DEFAULT',
      'cpuType': 'Nehalem',
      'smp': '1',
      'macAddr':'00:1a:4a:16:99:42,00:1a:4a:16:99:43,00:1a:4a:16:99:44,00:1a:4a:16:99:45,00:1a:4a:16:99:46,00:1a:4a:16:99:47,00:1a:4a:16:99:48',
      'boot': 'cdn',
      'custom': {},
      'vmType': 'kvm',
      'memSize': 512,
      'smpCoresPerSocket': '1',
      'vmName': 'ingale',
      'spiceMonitors': '4',
      'nice': '0',
      'floppy':'/rhev/data-center/4996348b-0199-435a-b01d-94cdf67d2d83/c37e94b2-b130-49b4-a7aa-b30e8a372878/images/11111111-1111-1111-1111-111111111111/win2k3.vfd',
      'drives': [
             {'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
              'format': 'cow',
              'bus': '0',
              'boot': 'true',
              'volumeID': 'be4d8588-8771-47cd-8954-b67566b6bd55',
              'imageID': '5f6852c8-844c-40ff-ac9c-cac5d00cbf1b',
              'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
              'propagateErrors': 'off',
              'if': 'virtio'},
             {'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
              'format': 'raw',
              'bus': '1',
              'boot': 'false',
              'volumeID': '9dd6b03a-2391-4537-8247-1bd786f60bdc',
              'imageID': 'f6bdcc45-bb73-45d1-975d-15d6eefe7eda',
              'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
              'propagateErrors': 'off',
              'if': 'virtio'},
             {'index': '0',
              'domainID': '25cf0e1e-236a-4889-91db-8de1aca9440e',
              'format': 'raw',
              'volumeID': '1745eb41-1432-422b-af6f-8b8c8dd3365c',
              'imageID': '8904d42d-c974-4055-a973-e6d7eb75e4ee',
              'poolID': '4996348b-0199-435a-b01d-94cdf67d2d83',
              'propagateErrors': 'off',
              'if': 'ide'}],
      'cdrom':'/rhev/data-center/4996348b-0199-435a-b01d-94cdf67d2d83/c37e94b2-b130-49b4-a7aa-b30e8a372878/images/11111111-1111-1111-1111-111111111111/en_windows_7_enterprise_x64_dvd_x15-70749.iso',
      'nicModel': 'pv,pv,pv,pv,rtl8139,e1000,e1000',
      'keyboardLayout': 'en-us',
      'kvmEnable': 'true',
      'displayNetwork': 'rhevm',
      'soundDevice': 'ich6',
      'timeOffset': '0',
      'spiceSecureChannels': 'smain,sinputs',
      'display': 'qxl'

New API will be used for Clusters with Compatibility Version 3.1 or upper

VDSM will distinguish if a new format or old format was sent according to existence/absence of the 'devices' key

Sample :

      'vmId': '27c61cea-f4fd-47e9-84e8-d1598f32ccc0',
      'vmName': 'myVM',
      'acpiEnable': 'true', 
      'emulatedMachine': 'rhel6.2.0', 
      'vmType': 'kvm',
      'memSize': 512,
      'smpCoresPerSocket': '1',
      'transparentHugePages': 'true',
      'cpuType': 'Nehalem',
      'smp': '1',
      'keyboardLayout': 'en-us',
      'kvmEnable': 'true',
      'nice': '0',
      'timeOffset': '0',
      'spiceSslCipherSuite': 'DEFAULT',
      'spiceSecureChannels': 'smain,sinputs',
      'displayNetwork': 'rhevm',
      'custom': {},
      'devices': {   
             {'device': 'disk',
              'subType': 'disk',
              'index': `<int>`,                                 
               <--- disk index unique per 'iface' virtio|ide
              'address': 'PCI|IDE address string',            
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'", IDE = "type='drive' controller='0' bus='0' unit='0'"
              'format': 'cow',
              'bootOrder': `<int>`,                             
               <--- global boot order across all bootable devices
              'propagateErrors': 'off',
              'iface': 'virtio|ide',
              'shared': 'True|False'                          
               <--- whether disk is shared
              'optional': 'True|False'                        
               <--- whether disk is optional (VM can be run without optional disk if inaccessible)
              'poolID': 'pool UUID',                         |
              'domainID': 'domain UUID',                     | 
              'imageID': 'image UUID',                       |
               <--- Should be passed on of 3 options: (poolID, domainID, imageID, volumeID) or GUID or UUID   
              'volumeID': 'volume UUID',                     |
              'UUID': 'shared disk UUID',                     
               <--- Should be passed on of 3 options: (poolID, domainID, imageID, volumeID) or GUID or UUID    
              'GUID': 'shared disk GUID'},                    
               <--- Should be passed on of 3 options: (poolID, domainID, imageID, volumeID) or GUID or UUID   
              .....
              any number of disks
              .....
             {'device': 'disk',
              'subType': 'cdrom',
              'index': `<int>`,                                 
               <--- disk index unique per 'iface' virtio|ide
              'address': 'PCI|IDE address string',            
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'" ,  IDE = "type='drive' controller='0' bus='0' unit='0'"
              'bootOrder': `<int>`,                             
               <--- global boot order across all bootable devices
              'iface': 'virtio|ide',
              'poolID': 'pool UUID',
              'domainID': 'domain UUID',
              'imageID': 'image UUID',
              'volumeID': '.iso file'},
             {'device': 'disk',
              'subType': 'floppy',
              'index': `<int>`,                                 
               <--- floppy index unique per 'iface' fdc
              'address': 'address string',                    
               <--- "type='drive' controller='0' bus='0' unit='0'"
              'iface': 'fdc',
              'poolID': 'pool UUID',
              'domainID': 'domain UUID',
              'imageID': 'image UUID',
              'volumeID': '.vfd file'},
             {'device': 'interface',
              'network': 'network name',                      
               <--- bridge|sriov|vnlink|bridgeless.  Rest device's parameters depends on network.
              'address': 'PCI address string',                
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'"
              'macAddr': 'mac address',
              'bootOrder': `<int>`,                             
               <--- global boot order across all bootable devices
              'nicModel': 'pv|rtl8139|e1000'},
              .....
              any number of network cards
              .....
             {'device': 'sound',
              'soundDevice':'ich6',
              'address': 'PCI address string'},               
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'"
             {'device': 'video',
              'index': `<int>`,
              'display': 'qxl|vnc',
              'address': 'PCI address string'},               
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'"
              .....
              up to 'spiceMonitors' of video cards
              .....
             {'device': 'TBD - any device that has address',
              'address': 'PCI|IDE address string'},           
               <--- PCI = "type='pci' domain='0x0000' bus='0x00' slot='0x0c' function='0x0'", IDE = "type='drive' controller='0' bus='0' unit='0'"

#### DB Design

Adding two columns to vm_dynamic

      1. domxml text -- holds the full xml description of all devices 
      2. hash varchar(30) -- holds the md5 like encryption for the xml value

Modify all relevant views & SP to have the hash[/domxml] field[s]. (see create/run section below for explanation why domxml marked as optional)

#### Logic Design

create/run

------------------------------------------------------------------------

Upon VM creation , send domxml as empty string. otherwise (run) send stored domxml value.[1]

[1] We have two options here

         a. Get the domxml as part of the VM entity
         b. Get the domxml from DAL for each VM we are running (creating) 
            This will insure that our VM entities are not keeping the domxml inside them, 
            rather, they will got it on demand

update

------------------------------------------------------------------------

refreshVdsRunTimeInfo is called

       GetAllVMStats is called 
          For each VM info 
            if (hash from vdsm <> hash from db)
                   add VM to changed-vm-list
          next
       if (changed-vm-list length > 0)
          Issue a call to vdsm list command with 'long' & changed-vm-list[2]
          For each VM in list 
             update domxml & md5 for VM in db
          next 
       end
         

[2] New vdsm list command syntax allows that :

vdsClient 0 list --help list

             [view] [vms:vmId1,vmId2]
             Lists all available machines on the specified server.
             Optional vms list, should start with 'vms:' and follow with 'vmId1,vmId2,...'
             Optional views:
                 "long"   all available configuration info (Default).
                 "table"  table output with the fields: vmId, vmName, Status and IP.
                 "ids"    all vmIds.

export

------------------------------------------------------------------------

OVFWriter should be extended to write the information retrieved in the domxml value from VDSM to the OVF file. Change should be coordinated with OVF team.

import

------------------------------------------------------------------------

OVFReader should be extended to read the information retrieved in the domxml value from VDSM from the OVF file.

#### API Design

VM/vm_dynamic entities should have additional hash[/domxml] properties

### VDSM

Adding support for hash parameter in Create. Return the hash value for each VM when calling GetAllVMStats. Return the domxml for each VM when calling List with 'long' format Enable to pass additional parameter specifying VM ids.

### Tests

#### Expected unit-tests

Verify that all VM DAO tests pass Test both old & new OVFs for export/import

#### Special considerations

External resources, mocking, etc..

      1.

#### Jenkins setup (if needed) for tests

      1.

#### Pre-integration needs

This feature requires pre-integration since we have to play with devices on various VM configuration. Extensive check of Import/Export of both new & old formats

### Design check list

This section describes issues that might need special consideration when writing this feature. Better sooner than later :-)

      1. Installer / Upgrader
       a. ....
      1. DB Upgrade
       a. Add hash & domxml new columns to vm_dynamic.
      1. MLA
       a. ....
      1. Migrate
       a. ...
      1. Compatibility levels
       a. Supported DC versions ....
       a. Supported Cluster versions ....
      1. Backward compatibility issues
      1. API changes (changes required in the API between components (GUI/REST <--> Backend <--> VDSM <--> libvirt))
       a. Backend <--> VDSM (See VDSM section)
        1. ....
      1. Effected features - Other features that might be effected by the change (workflow changes, utilities, ...)
       a. .....
      1. Performance requirements / tests
       a. Is there a special performance requirement for this feature?
       a. Are there special performance tests we want to make on this feature?
      1. Test cases
       a. Describe here the basic test cases for the feature
      1. Feature tracker bugs
      1. References
       a. Bugzilla
`    `[`https://bugzilla.redhat.com/show_bug.cgi?id=745274`](https://bugzilla.redhat.com/show_bug.cgi?id=745274)
       a. Mailing lists
       a. Other relevant wiki pages
`    `[`http://fedoraproject.org/wiki/Features/KVM_Stable_PCI_Addresses`](http://fedoraproject.org/wiki/Features/KVM_Stable_PCI_Addresses)
       a. Other relevant technical documents
          

### Open Issues

      1. Do we have to append the domxml in Export to OVF as is (as recieved from VDSM as xml) or wrap it with CDATA
      2. Decide if to embed the domxml as part of the VM entity or get it from DB on demand (recommended)

### Known Issues / Risks

      1. None

### Implementation needs

      1. None

### Needed documentation

      1. OVF Documentation
      2. Release Notes
