---
title: Provider Physical Network
category: feature
authors:
  - phoracek
  - amusil
  - dholler
---

# Provider Physical Network

## Summary

This feature extends [ovirt-ovn-provider](/develop/release-management/features/network/ovirt-ovn-provider.html) adding support for physical network access. It allows user to connect external OVN networks to a physical (oVirt native) network.

Feature progress is tracked on [ovn-localnet Trello](https://trello.com/b/lxIBEn0A/ovn-localnet). Related patches can be found on [gerrit topic:localnet](https://gerrit.ovirt.org/#/q/topic:localnet).

### Owner

- Feature Owner: Petr Horáček (phoracek)
- E-mail: <phoracek@redhat.com>

### Benefit to oVirt

This feature replaces OVS bridges networking in oVirt, later it will be extended with advanced OVN features. Physical network access will be required once NAT and routing are introduced to the OVN provider.

## Usage

### Create a cluster with Network Type set to OVS

This feature requires Cluster enabled with Open vSwitch networking. Create a new Cluster with `Switch Type` set to `OVS (experimental)`. Please note, that used Hosts must not have any pre-existing oVirt networks (e.g. ovirtmgmt bridge).

### Create an external network on top of a physical network

There are several ways to use this feature.

- **Select physical network from data center networks.** When creating a new external network, select `Data Center Network` in `Physical Network` section and pick the desired oVirt network from the drop down list. Note, that this network must be attached on all hosts in the cluster. Engine then uses the VDSM network name and VLAN ID from the selected network. This can also be done via REST API using `<external_provider_physical_network id="123"/>`, see [ovirt-engine-api-model documentation](http://ovirt.github.io/ovirt-engine-api-model/4.2/#types/network).

- **Create external network implicitly with physical network.** To make this feature more exposed, we implicitly create a matching external OVN network for each new OVS based oVirt network marked as `VM Network`. However, there is no connection between them afterwards, they behave as separate units.

- **Attach external network via custom values in ManageIQ**. This option is similar to the first one. In ManageIQ a user can set network type `flat` and specify physical network name (VDSM network name), in case physical network is on a VLAN, set type to `vlan` and specify VLAN ID as well.

![add an external network connected to a physical network ManageIQ dialog](/images/features/network/provider-physical-network_new-network-dialog-miq.png)

- **Select physical network via a custom physical network name and optional VLAN.** This option is mostly for backward compatibility and for external providers that are not integrated with oVirt Data Center Networks as described in the first option. When creating a new external network, set `Physical Network` to physical network name, it will be passed to provider as `provider:physical_network`. If the physical network has VLAN tagging enabled, check `Enable VLAN tagging` and set the physical network's tag there, it will be passed to provider as `provider:segmentation_id`. When VLAN is specified, `provider:network_type` is set to `vlan`, `flat` otherwise. In case a network name is longer than 15 characters or contains special characters, this option will not work with the OVN implementation, and using the first option is advised.

![add an external network connected to a physical network Engine dialog](/images/features/network/provider-physical-network_new-network-dialog-engine.png)

### Attach VM to the external network

Finally add a new NIC to a VM and select a profile of an external network. L2 connectivity should be provided to the VM. In case there is a DHCP server running, the VM should obtain an IP.

## Caveat

The user needs to make sure that the physical network used by the external network is available on the host used by the VM. There is currently now way for Engine to enforce it. The easiest way to accomplish this is to set physical provider network as required for the cluster.

## Implementation

### OpenStack Neutron API

OpenStack Neutron API used by Engine to control external providers already provides means to specify a physical network – attributes `provider:network_type`, `provider:physical_network` and `provider:segmentation_id`. The network types we use are `flat` and `vlan`. Physical network is matched by the VDSM network name. Segmentation ID is used with VLAN networks and matches the VLAN ID defined for the selected network.

### oVirt Provider OVN

The provider reads the attributes described above. If the physical network is defined, the provider implicitly creates a `localnet` port on the given network and attaches it to the received physical network. In case a segmentation ID was passed, it uses it as the VLAN tag on the port.

### VDSM

Localnet port is attached to an abstract network name. This name is mapped to an OVS bridge name on each host via OVS DB attribute `external-ids:ovn-bridge-mappings`. This attribute is configured after each `setupNetworks` command and during upgrades (after reboot or upgrade of vdsm package).

### Engine

The `ProviderNetwork` object in Engine is extended with a link to its physical network (`Network`). In the database, `provider_physical_network_id` is added as a new column to `network` table.

Physical network is used to find the VDSM network name and the VLAN ID. These values are then passed to the network provider.

Engine also covers the validation:

- Physical network must be on the same Data Center as the external network.
- The custom values (physical network and VLAN ID) must not be specified a when provider physical network is set.

### Import of a provider physical network
When importing a network with physical network access from an external network
provider into Engine, Engine must map this physical network to the corresponding
logical network in Engine.
If no corresponding logical network is found, the physical network is ignored
during import and synchronization.
The [external network provider][1] describes the physical network with three
attributes `provider:physical_network`, `provider:network_type` and
`provider:segmentation_id`.  
The corresponding logical network is detected by matching the three attributes:
* `provider:physical_network` to [VDSM name][2] of the network
* `provider:network_type` to the type of the network
* `provider:segmentation_id` to the VLAN ID of the network

### Engine UI

Even without this feature, it is already possible to set the physical network name and VLAN ID for an external network from `New Network` dialog. Physical network has a separate field, and the VLAN is obtained from the shared `Network Attributes` section. However, this way requires the user to know the VDSM name of the network and manually copy the VLAN ID of the network

For better user experience, this feature exposes an option to select desired provider physical network from Data Center networks to UI.

![add an external network connected to a physical network dialog](/images/features/network/provider-physical-network_new-network-dialog.png)

To expose this feature, an external OVN network is created implicitly when the user adds a new VM network on an OVS cluster. When selecting a network profile for a VM NIC, we list only external networks, not native oVirt networks that triggered their creation.

### REST API

`Network` object in REST API is now extended with two new links:

`<external_provider id="123"/>` points to an `OpenStackNetworkProvider`. If this link is specified, new network is defined on the selected provider. This mimics Engine UI `New Network` dialog with `Create on external provider` checked.

`<external_provider_physical_network id="123"/>` points to a `Network`. This link is allowed only if `external_provider` is specified.

## Packaging and installation

This feature is integrated into 4.2 version of ovirt-provider-ovn, ovirt-engine and vdsm packages. The only extra requirement is to use Cluster with `Switch Type` set to `OVS`.

## Testing

Testing of this feature should cover:

- Addition/removal of locally attached external network via all UI methods and via REST.
- VM connectivity to physical network, with both VLAN tagged and untagged networks.
- Live migration of VMs attached to external networks.
- In case OVS cluster was configured on 4.1 and only then upgraded to 4.2 (without any `setupNetworks` calls after the upgrade was done), previous tests should also pass.

## External references

[Provider Extended Attributes of Networks in OpenStack Networking API v2.0](https://developer.openstack.org/api-ref/network/v2/#provider-extended-attributes)

[Unrestricted Network Names](/develop/release-management/features/network/unrestricted-network-names.html)

