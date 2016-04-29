---
title: DetailedHotPlug
category: template
authors: derez, mkublin, ykaul
wiki_category: Template
wiki_title: Features/DetailedHotPlug
wiki_revision_count: 25
wiki_last_updated: 2014-07-13
feature_name: Disk Hot Plug
feature_modules: engine
feature_status: Released
---

# Detailed Hot Plug

## HotPlug / HotUnPlug Feature

### Summary

Allow to hot add and hot remove of a virtio-blk disks from or to running guest.

The short description is : <http://www.ovirt.org/wiki/Features/HotPlug>

### Owner

*   Michael Kublin
*   Email: mkublin@redhat.com

### Current status

*   Target Release: ...
*   Status: Almost finished
*   Last updated date: ...

### Detailed Description

The following feature will allow to hot plug/unplug of virtIO disks on running vm, also in scope of that feature will be added a new attribute to disk which will allow to run vm even the following disk is unaccesiable.
This feature will be restricted to operating systems that support this action – eg. RHEL 5/6, Windows Server 2003 and Windows server 2008.

#### Entity Description

The following changes on disk entity will be done: A new field should be added to the table image_vm_map which will indicate status of disk (plugged, unplugged) for current vm
A new field should be added to the table images, type boolean, which will indicate if a disk is plugged or unplugged

#### CRUD

No new operation will be added, an update will be done by using of existing stored procedures

#### User Experience

The following UI mockup contain guidelines for VMs->Disks sub-tab:

![](Vm_disks_hotplug.png "Vm_disks_hotplug.png")

#### Installation/Upgrade

An upgrade script will add a missed fields to the table disks and view images. The tables can be changed in the future, because of changes at schema which are currently is done due to development of different features.

#### User work-flows

New actions will allow the user to plug or unplug a disk to/from a running VM, it will be allowed only for disks which were added to vm by AddDiskToVMCommand . The feature will be allowed only on 3.1 clusters and above
Via UI or the API the user will have an option to plug or unplug a disk of a running VM.
The action will be allowed in the following flows:
HotPlug will be allowed only on:

1. Operation system of guest is supports operation
2. VirtIO disk
3. Disk should be unplugged
4. VM should be in status Up

HotUnPlug will be allowed in the following cases:

1. Operation system of guest is supports operation
2. VirtIO disk
3. VM should be in status Up
4. Disk should be plugged

In order to perform an operation new verbs will be added at VDSM side:
hotplug and hotunplug with the following dictionary to pass:
A call to vdsm will be done in synchronious way

    'device': [
      {'type': 'disk',
       'device': 'disk',
       'index': `<int>`,                          <--- disk index unique per 'iface' virtio|ide
       'address': 'PCI|IDE address dictionary',   <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'} ,  
                                                       IDE = {'type':'drive', 'controller':'0', 'bus':'0', 'unit':'0'}
       'format': 'cow',
       'bootOrder': `<int>`,                      <--- global boot order across all bootable devices
       'propagateErrors': 'off',
       'iface': 'virtio',
       'shared': 'True|False'                     <--- whether disk is shared
       'optional': 'True|False'                   <--- whether disk is optional (VM can be run without optional disk if inaccessible)
       'poolID': 'pool UUID',                         |
       'domainID': 'domain UUID',                     | 
       'imageID': 'image UUID',                   <--- Should be passed on of 3 options: (poolID, domainID, imageID, volumeID) or GUID or UUID   
       'volumeID': 'volume UUID',                     |
       'UUID': 'shared disk UUID',                <--- Should be passed on of 3 options: (poolID, domainID, imageID, volumeID) or GUID or UUID    
       'GUID': 'shared disk GUID'}]    

New vdsm errors will be added: `FailedToPlugDisk` (45) and `FailedToUnPlugDisk` (46)
 An additional change will be done during createVM operation :
A disk which is unplugged but attached to a VM will not be passed to vdsm in order to run VM without it

#### Events

### Dependencies / Related Features and Projects

The changes will be done at vdsm side and GUI and API.
At vdsm side will be addded support for a new verbs as defined above.
At GUI and API will be added new changes in order to support the new functionality at engine side.

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

NA
