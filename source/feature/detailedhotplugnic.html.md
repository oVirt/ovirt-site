---
title: DetailedHotPlugNic
category: feature
authors: danken, ecohen, ilvovsky, moti, ovedo, roy
wiki_category: Feature
wiki_title: Features/Design/DetailedHotPlugNic
wiki_revision_count: 19
wiki_last_updated: 2013-03-07
---

# Detailed Hot Plug Nic

## Hotplug/Hotunplug of Network Interface Cards

### Summary

Allow to hot plug and unplug a NIC to/from running guest.

### Owner

*   Name: [ Igor Lvovsky](User:MyUser)

<!-- -->

*   Email: ilvovsky@redhat.com

### Current status

*   Target Release: 3.1
*   Status: ...
*   Last updated date: Feb 1 2012

### Detailed Description

The following feature will allow to hot plug/unplug NIC on running vm.
The feature will be allowed only on 3.1 clusters and above

#### User Experience

The new buttons **Plug** and **UnPlug** should be added to the VM's **Network Interfaces** tab.
 The NIC adding to the VM will be performed as two steps procedure:
#Add new NIC - will only add the proper entry to DB
#Plug NIC - will actually plug NIC to VM
 The NIC removing from the VM will be performed as two steps procedure:
#Unplug NIC - will actually unplug NIC from VM
#Remove NIC - will remove the proper entry from DB
 The same behavior should be applied on stopped and running VM's.

#### Engine Flows

##### Add nic

when adding a nic, store its plugged status as disabled, regardless if the VM is running or not. The api will not implicitly plug it to a running VM.

##### Run VM

when running a VM, include only nics which are plugged in the parameters sent to VDSM.

##### Plug nic

plugging a nic when a VM is down updates its plugged flag in vm_device table to 'true'. If the VM is up then the VDSM is also being called to plug it.

##### Unplug nic

unplugging a nic when a VM is down updates its plugged flag in vm_device table to 'false'

##### Host monitoring

during monitoring and gathering vm stats, the nic's address should be saved in vm_device table.

##### Remove nic

when a nic is removed from a VM, remove its address from vm_device

#### REST API

2 new actions on nics collection:

      /api/vms/xxx/nics/yyy/plug
      /api/vms/xxx/nics/yyy/unplug

#### Engine API

* plug or unplug a nic

      VdcAction.java
      ...
      plugUnplugNic(1000)

      plugUnplugVmNicParameters.java
      Guid vmId;
      Guid nicId;
      boolean plug;

##### Error codes

translate VDSM error codes: TODO

#### VDSM API

A new API is added for this feature.

    hotplugNic (params)
    hotunplugNic (params)

    params = {
    'vmId': vmUUID, 
    'nic':  
           {'type': 'interface',
            'device': 'bridge|sriov|vnlink|bridgeless',
            'network': 'network name',                      <--- bridge name
            'address': 'PCI address dictionary',            <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'}
            'macAddr': 'mac address',
            'bootOrder': <int>,                             <--- global boot order across all bootable devices
            'promisc': <blue,red>,                          <--- promisc mirror mode, the interface will mirror all red and blue bridge traffic
            'specParams': params dictionary,
            'nicModel': 'pv|rtl8139|e1000'}
     }

New vdsm errors will be added:

    'Failed to hotplug NIC' - code 49
    'Failed to hotunplug NIC' - code 50

**Note:** To avoid PCI addresses collisions Engine should clean NIC's address entry in DB when unplug the NIC.
The new address will be assigned to NIC with next plugging.

#### Events

### Dependencies / Related Features and Projects

The changes will be done at vdsm side and GUI and API.
At vdsm side will be addded support for a new verbs as defined above.
At GUI and API will be added new changes in order to support the new functionality at engine side.

### Documentation / External references

### Comments and Discussion

### Open Issues

NA

<Category:Template> <Category:Feature>
