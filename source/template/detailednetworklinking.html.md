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
{|class="wikitable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |wired ||boolean ||not null ||Indicates wether the vnic is wired |- |}

<span style="color:Teal">**VM_INTERFACE_VIEW**</span>
{|class="wikitable" !border="1"| Column Name ||Column Type ||Definition |- |wired ||boolean ||Indicates wether the vnic is wired |- |}

#### Engine Flows

##### Add Vnic

*   'wired' property of VmNetworkInterface should be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- save

*   The 'wired' property is sent to the VDSM by ActivateDeactivateVmNicCommand command (for running VMs with the nic set to plugged)

##### Update Vnic

*   **shouldn't** throw canDo when trying to update a nic when the vm is running and the nic is plugged.
*   'wired' property of VmNetworkInterface should also be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- update

*   If the vm is up

    * plugged --> unplugged ('plugged' property was changed to false)

:\*\* Unplug should be sent to the VDSM

    * unplugged --> plugged

:\*\* Plug should be sent to the VDSM

    * plugged --> plugged

:\*\* If MAC Address or Driver Type were update

:\*\*\* Unplug followed by Plug should be sent to VDSM.

:\*\* Otherwise, if network is changed or disconnected

:\*\*\* updateVmInteface should be sent to the VDSM.

    * unplugged --> unplugged

:\*\* nothing should be sent to VDSM

##### Remove Vnic

*   no change (can be done only if the VM is down or the Vnic is unplugged)

##### Run VM

*   When running a VM, the VM's Vnics' 'wired' property should also be passed to the VDSM, for 3.2 cluster and above.

      VmInfoBuilder.addNetworkInterfaceProperties

##### Plug nic

*   no change.

##### Unplug nic

*   no change.

##### Error codes

Add translation to VDSM error codes: UPDATE_VNIC_FAILED = 'Failed to update VM Network Interface.'

#### VDSM API

##### New API

A new API is added for this feature.

    updateVmDevice (vmId, params)

    params = {
            'type': 'interface',
            'device': 'bridge|sriov|vnlink|bridgeless',
            'network': 'network name',                      <--- bridge name
            'wired': 'is network wired',
            'alias': <string>,      
            'promisc': <blue,red>,                          <--- promisc mirror mode, the interface will mirror all red and blue bridge traffic
     }

Vdsm would implement this using <http://libvirt.org/html/libvirt-libvirt.html#virDomainUpdateDeviceFlags> .

##### Updated APIs

*   **hotplugNic** - the vdsm should connect the Vnic's Network according to the 'wired' property passed on the Vnic.
*   **createVm** - the vdsm should connect each of the Vm's Vnics according to the 'wired' property passed on the each Vnic.

In both cases, 'wired' property would be implemented by setting libvirt's <link state> element <http://libvirt.org/formatdomain.html#elementLink> . New vdsm errors will be added:

    UPDATE_VNIC_FAILED- code 51

#### Events

#### Open Issues

1.  Should we deprecate the invocation of ActivateDeactivateVmNic command by the clients as we managed it by UpdateVmNetworkInterface command ?
2.  Should ActivateDeactivateVmNic be renamed to PlugUnplug ?

### Documentation / External references

### Stretch Goals

*   Enable hot changes in port mirroring (without plugging and unplugging)

### Comments and Discussion

### Open Issues

*   After the VM is connected to a new network, no one on that network is aware of the change. It was suggested, that much like in vm migration, the VM should emit a gratuitous arp packet, to notify the world about its existence. However note that in vm migration, the vm does not change its layer-2 subnet and telling the switch of its new location is all that is needed. This is NOT the case when the VM is connected to a different network, with its own vlan and ip limitations. One cannot assume that a guest server application would continue to operate uninterrupted.

<Category:Template> <Category:Feature>
