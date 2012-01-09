---
title: DetailedHotPlug
category: template
authors: derez, mkublin, ykaul
wiki_category: Template
wiki_title: Features/DetailedHotPlug
wiki_revision_count: 25
wiki_last_updated: 2014-07-13
---

# Detailed Hot Plug

## HotPlug / HotUnPlug Feature

### Summary

Allow to hot add and hot remove of a virtio-blk disks from or to running guest.

The short description is : <http://www.ovirt.org/wiki/Features/HotPlug>

### Owner

*   Michael Kublin:

<!-- -->

*   Email: mkublin@redhat.com

### Current status

*   Target Release: ...
*   Status: ...
*   Last updated date: ...

### Detailed Description

The following feature will allow to hot plug/unplug of virtIO disks on running vm, also in scope of that feature will be added a new attribute to disk which will allow to run vm even the following disk is unaccesiable.

#### Entity Description

The following changes on disk entity will be done: A new field should be added to the table disk which will indicate status of disk (plugged, unplugged)
A new field should be added to the table images, type boolean, which will indicate if a disk is plugged or unplugged

#### CRUD

No new operation will be added, an update will be done by using of existing storage procedures

#### User Experience

#### Installation/Upgrade

An upgrade script will add a missed fields.

#### User work-flows

A new actions will allow to user plug or un plug a disk at running vm .
Via gui or rest API user will have an option to plug or un plug a disk at running vm.
The action will be allowed in the following flows:
HotPlug will be allowed only on:
1. VirtIO disk
2. Disk should be unplugged
3. VM should be in status Up
HotUnPlug will be allowed in the following cases:
1. VirtIO disk
2. VM should be in status Up
3. Disk should be plugged
4. Disk can not be system
 In order to perform an operation a new verbs will be added at VDSM side:
hotplug and hotunplug with the following dictionary to pass:

'device': [

             {'type': 'disk',
              'device': 'disk',
              'index': `<int>`,                            <--- disk index unique per 'iface' virtio|ide
              'address': 'PCI|IDE address dictionary',   <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'} ,  
                                                              IDE = {'type':'drive', 'controller':'0', 'bus':'0', 'unit':'0'}
              'format': 'cow',
              'bootOrder': `<int>`,                        <--- global boot order across all bootable devices
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

A new vdsm errors will be added: FailedToPlugDisk(45) and FailedToUnPlugDisk(46)

#### Events

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

<Category:Template> <Category:Feature>
