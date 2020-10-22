---
title: DetailedHotPlugNic
category: feature
authors: danken, ecohen, ilvovsky, moti, ovedo, roy
---

# Detailed Hot Plug Nic

## Hotplug/Hotunplug of Network Interface Cards

### Summary

Allow to hot plug and unplug a NIC to/from running guest.

### Owner

*   Name: Igor Lvovsky
*   Email: ilvovsky@redhat.com

### Current status

*   Target Release: 3.1
*   Status: ...
*   Last updated date: Feb 1 2012

### Detailed Description

The following feature will allow to hot plug/unplug NIC on running vm.
The feature will be allowed only on 3.1 clusters and above
This feature will be restricted to operating systems that support this action – Windows7, Windows7 x64, Windows2008, Windows2008 x64, Windows2008R2 x64, RHEL5, RHEL5 x64, RHEL6 and RHEL6 x64

#### User Experience

*   VMs main tab -> NICs sub-tab:
    -   New buttons: **Activate** and **Deactivate** will be added
    -   New status (icon) column should be added.
    -   A "Activate" check-box (checked by default) should be added to the "New NIC" dialog.

![](/images/wiki/Vms_nics_subtab.png)

![](/images/wiki/Newedit_vm_nic_dialog.png)

The NIC adding to the VM will be performed as two steps procedure:
#Add new NIC - will only add the proper entry to DB
#Activate NIC - will actually plug NIC to VM
 The NIC removing from the VM will be performed as two steps procedure:
#Deactivate NIC - will actually unplug NIC from VM
#Remove NIC - will remove the proper entry from DB
 The same behavior should be applied on stopped and running VM's.

#### Engine Flows

##### Add nic

*   when adding a nic as activated, if the VM is up, plug it.

##### Update nic

*   throw canDo when trying to update a nic when the vm is running and the nic is plugged.

##### Remove nic

*   remove the nic only if the VM is down or nic is deactivated

##### Run VM

*   when running a VM, include only nics which are 'activated' in the parameters

sent to VDSM.

##### Plug nic

*   plugging a nic when a VM is down updates its plugged flag in

vm_device table to 'true'. If the VM is up then the VDSM is also being called to plug it.

##### Unplug nic

*   when unplugging a nic update its plugged flag in vm_device table to 'false' and clear the address

#### REST API

2 new actions on nics collection:

      /api/vms/xxx/nics/yyy/activate
      /api/vms/xxx/nics/yyy/deactivate

#### Engine API

* plug or unplug a nic

      VdcAction.java
      ...
      plugUnplugNic(1000)

      plugUnplugVmNicParameters.java
      Guid vmId;
      Guid nicId;
      boolean plug;

#### Model

      vm_interface_view:
      join vm_device.isPlugged as active

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


### Open Issues

NA

