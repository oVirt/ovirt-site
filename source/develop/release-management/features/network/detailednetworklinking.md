---
title: DetailedNetworkLinking
category: feature
authors:
  - alkaplan
  - apuimedo
  - danken
  - lpeer
  - moti
---

# Detailed Network Linking

## Network Linking

### Summary

The network wiring feature is an enhancement for the VM Network Interface management. It supports the following actions without unplugging the Vnic, maintaining the address of the Vnic:

* Dynamically changing the network of a running VM (without unplugging the Vnic)
* Unwiring a network of a VM without unplugging the vnic

[Network Linking Feature Page](/develop/release-management/features/network/networklinking.html)

### Owner

*   Name: Alona Kaplan (alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last update date: 11/11/2012

### Detailed Description

#### Rest API

*   The user will enter link_state as a string ("up"/"down").
*   The link_state string will be translated to boolean before sending the entity to the backend.
*   Plug/Unplug actions will call UpdateVmInterfaceCommand instead of ActivateDeactivateVmNicCommand.

#### Engine API

      VmNetworkInterface:
        boolean linked;

#### Database Changes

<span style="color:Teal">**VM_INTERFACE**</span>

| Column Name | Column Type | Null? / Default | Definition                                               |
|-------------|-------------|-----------------|----------------------------------------------------------|
| linked      | boolean     | not null        | Indicates wether the vnic's link state is "up" or "down" |
{: .bordered}

<span style="color:Teal">**VM_INTERFACE_VIEW**</span>

| Column Name | Column Type | Definition                                               |
|-------------|-------------|----------------------------------------------------------|
|  linked     | boolean     | Indicates wether the vnic's link state is "up" or "down" |
{: .bordered}

#### Engine Flows

##### Add Vnic

*   canDoAction- allow 'null' network just for 3.2 or upper cluster compatibility version.
*   `linkState` property of `VmNetworkInterface` should be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- save

*   The `linkState` property is sent to the VDSM by `ActivateDeactivateVmNicCommand` command (for running VMs with the nic set to plugged)

##### Update Vnic

*   **shouldn't** throw canDo when trying to update a nic when the vm is running and the nic is plugged.
*   canDoAction- allow 'null' network.
*   'linkState' property of VmNetworkInterface should also be stored in the DB

      VmNetworkInterfaceDAODbFacadeImpl- update

*   If the vm is up
    * plugged --> unplugged ('plugged' property was changed to false)

        - Unplug should be sent to the VDSM

    * unplugged --> plugged

        -  Plug should be sent to the VDSM

    * plugged --> plugged

        - If MAC Address or Driver Type were updated

           -  Throw canDoAction "Cannot perform hot update when updating 'Type' or 'MAC', please Unplug and then Plug again."

        - Otherwise, if network is changed or disconnected

           - If cluster c. version is 3.2 or upper updateVmDevice should be sent to the VDSM.

           - Otherwise, throw canDoAction

    * unplugged --> unplugged

        - nothing should be sent to VDSM

##### Remove Vnic

*   no change (can be done only if the VM is down or the Vnic is unplugged)

##### Run VM

*   When running a VM, the VM's Vnics' `linkState` property should also be passed to the VDSM, for 3.2 cluster and above.
    ```python
    VmInfoBuilder.addNetworkInterfaceProperties
    ```

*   network should be sent to the VDSM just if it is not null.

##### Plug nic

*   Should be used just as internal command.
*   network should be sent to the VDSM just if it is not null.
*   canDoAction should allow null network.

##### Unplug nic

*   Should be used just as internal command.

##### Other effected flows

*   `ChangeVMClusterCommand`
*   `AddVmTemplateCommand`
*   `AddVmTemplateInterfaceCommand`
*   `UpdateVmTemplateInterfaceCommand`
*   `UpdateVmCommand`
*   `ImportVmCommand`
*   `ImportVmTemplateCommand`
*   `OvfVm`
*   `OvfTemplate`

##### Error codes

Add translation to VDSM error codes:
```python
UPDATE_VNIC_FAILED = 'Failed to update VM Network Interface.'
```

#### VDSM API

##### New API

A new API is added for this feature.

```python
    vmUpdateDevice (vmId, params)

    params = {
       'devicType': 'interface',
       'network': 'network name',    #  <--- bridge name. If not set, the vnic stays on the current network. If it equals to the empty string, it is taken to the dummy bridge.
       'linkActive': 'bool',
       'alias': <string>,
       'portMirroring': blue[,red],  #  <---  If not specified, the current portMirroring keeps in effect.
                                     #        Otherwise, only the specified networks will be mirrored to the vnic, e.g., empty list -> unset any mirroring.
     }
```

Vdsm would implement this using <https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainUpdateDeviceFlags> .

If the vnic doesn't have a network, the network will be omitted from the params sent to the vdsm.

##### Updated APIs

*   **hotplugNic**
    -   the vdsm should connect the Vnic's Network according to the `linkState` property passed on the Vnic.
    -   If the vnic doesn't have a network, the network will be omitted from the params sent to the vdsm.
*   **createVm**
    -   the vdsm should connect each of the Vm's Vnics according to the `linkState` property passed on the each Vnic.
    -   If the vnic doesn't have a network, the network will be omitted from the params sent to the vdsm.

In both cases, `linkState` property would be implemented by setting libvirt's `<link state>` element <http://libvirt.org/formatdomain.html#elementLink> .
New vdsm errors will be added:

* `UPDATE_VNIC_FAILED` - code 56

#### Events

##### Add Vnic

*   `AuditLogType.NETWORK_ADD_VM_INTERFACE`
*   `AuditLogType.NETWORK_ADD_VM_INTERFACE_FAILED`

##### Update Vnic

*   `AuditLogType.NETWORK_UPDATE_VM_INTERFACE`
*   `AuditLogType.NETWORK_UPDATE_VM_INTERFACE_FAILED`

##### Remove Vnic

*   `AuditLogType.NETWORK_REMOVE_VM_INTERFACE`
*   `AuditLogType.NETWORK_REMOVE_VM_INTERFACE_FAILED`

##### Plug nic

*   `AuditLogType.NETWORK_ACTIVATE_VM_INTERFACE_SUCCESS`
*   `AuditLogType.NETWORK_ACTIVATE_VM_INTERFACE_FAILURE`

##### Unplug nic

*   `AuditLogType.NETWORK_DEACTIVATE_VM_INTERFACE_SUCCESS`
*   `AuditLogType.NETWORK_DEACTIVATE_VM_INTERFACE_FAILURE`

#### Open Issues

1.  Should `ActivateDeactivateVmNic` be renamed to `PlugUnplug` ?

### Documentation / External references

### Stretch Goals

*   Enable hot changes in port mirroring (without plugging and unplugging)


### Comment

*   After the VM is connected to a new network, no one on that network is aware of the change.
    It was suggested, that much like in vm migration, the VM should emit a gratuitous arp packet, to notify the world about its existence.
    However note that in vm migration, the vm does not change its layer-2 subnet and telling the switch of its new location is all that is needed.
    This is NOT the case when the VM is connected to a different network, with its own vlan and ip limitations.
    One cannot assume that a guest server application would continue to operate uninterrupted.

