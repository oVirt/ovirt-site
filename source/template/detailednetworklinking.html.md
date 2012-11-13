---
title: DetailedNetworkLinking
category: template
authors: alkaplan, apuimedo, danken, lpeer, moti
wiki_category: Template
wiki_title: Feature/DetailedNetworkLinking
wiki_revision_count: 75
wiki_last_updated: 2012-12-18
wiki_warnings: list-item?
---

# Detailed Network Linking

## Network Wiring

### Summary

The network wiring feature is an enhancement for the VM Network Interface management. It supports the following actions without unplugging the Vnic, maintaining the address of the Vnic:

    * Dynamically changing the network of a running VM (without unplugging the Vnic)
    * Unwiring a network of a VM without unplugging the vnic
[Network Wiring Feature Page](http://ovirt.org/wiki/Feature/NetworkWiring)

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last update date: 11/11/2012

### Detailed Description

#### Engine API

      VmNetworkInterface:
        boolean wired;

#### Database Changes

<span style="color:Teal">**VM_INTERFACE**</span>
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |wired ||boolean ||not null ||Indicates wether the vnic is wired |- |}

#### Engine Flows

##### Add Vnic

*   'wired' property of VmNetworkInterface should be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- save

*   The 'wired' property will be passed to the VDSM through when ActivateDecativateVm will be done.

##### Update Vnic

*   **shouldn't** throw canDo when trying to update a nic when the vm is running and the nic is plugged.
*   'wired' property of VmNetworkInterface should also be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- update

*   If the vm is up

    * plugged->unplugged ('plugged' property was changed to false)

:\*\* Unplug should be sent to the VDSM

    * unplugged->plugged

:\*\* Plug should be sent to the VDSM

    * plugged->plugged

:\*\* updateVm should be sent to the VDSM.

    * unplugged->unplugged

:\*\* nothing should be sent to VDSM

##### Remove Vnic

*   no change (can be done only if the VM is down or the Vnic is unplugged)

##### Run VM

*   When running a VM, the VM's Vnics' 'wired' property should also be passed to the VDSM.

      VmInfoBuilder- addNetworkInterfaceProperties

##### Plug nic

*   no change.

##### Unplug nic

*   no change.

#### Model

      vm_interface_view: (.schema)
      join vm_interface.wired as active

##### Error codes

translate VDSM error codes: UPDATE_VNIC_FAILED = 'Failed to update VM Network Interface.'

#### VDSM API

A new API is added for this feature.

    updateVmInteface (params)

    params = {
    'vmId': vmUUID, 
    'nic':  
           {'type': 'interface',
            'device': 'bridge|sriov|vnlink|bridgeless',
            'network': 'network name',                      <--- bridge name
            'wired': 'is network wired',
            'address': 'PCI address dictionary',            <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'}
            'macAddr': 'mac address',
            'bootOrder': <int>,                             <--- global boot order across all bootable devices
            'promisc': <blue,red>,                          <--- promisc mirror mode, the interface will mirror all red and blue bridge traffic
            'specParams': params dictionary,
            'nicModel': 'pv|rtl8139|e1000'}
     }

Updated folowes:
:\*hotplugNic- the vdsm should connect the Vnic's Network according to the 'wired' property passed on the Vnic.
:\*createVm- the vdsm should connect each of the Vm's Vnics according to the 'wired' property passed on the each Vnic.
 New vdsm errors will be added:

    UPDATE_VNIC_FAILED- code 51

#### Events

### Documentation / External references

### Streched Goals

*   Enable hot changes in port mirroring (without plugging and unplugging)

### Comments and Discussion

### Open Issues

NA

<Category:Template> <Category:Feature>
