---
title: Provider Physical Network
category: feature
authors: phoracek,amusil
feature_name: Provider Physical Network
feature_modules: engine,vdsm,ovn-provider
feature_status: In Development
---

# Provider Physical Network

## Summary

This feature extends [ovirt-ovn-provider](https://www.ovirt.org/develop/release-management/features/network/ovirt-ovn-provider/) supporting physical network access. With this feature, user will be able connect external OVN network to a physical (oVirt native) network.

Progress of the feature is tracked on [ovn-localnet Trello](https://trello.com/b/lxIBEn0A/ovn-localnet). Related patches could be found on [gerrit topic:localnet](https://gerrit.ovirt.org/#/q/topic:localnet).

### Owner

- Feature Owner: Petr Horáček (phoracek)
- E-mail: <phoracek@redhat.com>

### Benefit to oVirt

With this feature existing OVS VM networking could be replaced with OVN, providing traditional oVirt networking. That would also allow us to drop a part of VM live migration hook.

Physical network access will be required once NAT and routing are introduced OVN provider.

## Usage

### Set cluster network switch type to OVS

This feature requires cluster switch type set to OVS. You can enable OVS networking with following steps.

1) **Enable OVS hook for live migration on all vdsm hosts.** Add `migration_ovs_hook_enabled = true` to `[vars]` section in `/etc/vdsm/vdsm.conf`. And restart vdsm with `systemctl restart vdsmd supervdsmd`.

1) **Set Cluster switch type to OVS.** Open `Edit` on selected cluster and set `Switch Type` to `OVS (experimental)`.

1) **Set OVS networking on all vdsm hosts.** Go over each Host, put it to `Maintenance`, `Sync All Networks` and `Activate`.

### Create an external network on top of a physical network

There are several ways how to use this feature.

- **Select physical network via custom values.** When creating a new external network, fill physical network name to `Physical Network`. If the physical network has VLAN tagging enabled, also check `Enable VLAN tagging` and copy physical network's tag there. Please note, that physical network name references to VDSM network name, which is not necessarily the same as oVirt network name (in case it has more than 15 characters or contains special characters).

- **Select physical network from data center networks.** When creating a new external network, in `Physical Network` section, select `Data Center Network` and pick desired oVirt network from drop down list. Engine then uses VDSM network name and VLAN ID from the selected network. This can also be done via REST API using `<external_provider_physical_network id="123"/>`, see [ovirt-engine-api-model documentation](http://ovirt.github.io/ovirt-engine-api-model/4.2/#types/network).

- **Create external network implicitly with physical network.** To make this feature more exposed, we implicitly create a matching external OVN network for each new OVS network marked as `VM Network`. However, there is no connection between them afterwards, they behave as separate units.

- **Attach external network via custom values in ManageIQ**. This option is similar to the first one. In ManageIQ a user can set network type `flat` and specify physical network name (VDSM network name), in case physical network is on VLAN, set type to `vlan` and specify VLAN ID as well.

### Attach VM to the external network

Finally add a new NIC to a VM and select a profile of an external network. L2 connectivity should be provided to the VM. In case there is DHCP server running, VM should obtain an IP.

## Caveat

User needs to make sure that physical network used by external network is available on the host used by VM. There is currently now way for Engine how to enforce it. Easiest way how to accomplish this is to set physical network as required for the cluster.

## Implementation

### OpenStack Neutron API

OpenStack Neutron API used by Engine to control external providers already provides means to specify physical network – attributes `provider:network_type`, `provider:physical_network` and `provider:segmentation_id`. Network types we use are `flat` and `vlan`. Physical network is matched by VDSM network name. Segmentation ID is used with VLAN networks and matches VLAN ID defined for selected network.

### oVirt Provider OVN

Provider reads attributes described above. If physical network is defined, provider implicitly creates `localnet` port on given network and attaches it to passed physical network. In case segmentation ID was passed, it uses it as a VLAN tag on the port.

### VDSM

Localnet port is attached to an abstract network name. This name is mapped to an OVS bridge name on each host via OVS DB attribute `external-ids:ovn-bridge-mappings`. This attribute is configured after each `setupNetworks` command and also during upgrade (after reboot or upgrade of vdsm package).

### Engine

`ProviderNetwork` object in Engine is extended with a link to its physical network (`Network`). In database, `provider_physical_network_id` is added as a new column to `network` table.

Physical network is used to find VDSM network name and VLAN ID, these values are then passed to network provider.

Engine also covers validation: physical network is on the same Data Center as the external network, custom values (physical network and VLAN ID) are not specified when provider physical network is set.

### Engine UI

Without this feature, there is already a way how to set physical network name and VLAN ID for an external network from `New Network` dialog. Physical network has its separate field, VLAN is obtained from shared `Network Attributes` section. However, this way requires user to know VDSM name of the network and also manually copy VLAN ID of the network.

For better user experience, this feature exposes an option to select desired provider physical network from Data Center networks to UI.

![add an external network connected to a physical network dialog](/images/features/network/provider-physical-network_new-network-dialog.png)

To expose this feature, external OVN network is created implicitly when user adds a new VM network on OVS cluster. When selecting a network profile for a VM NIC, we list only external networks, not native oVirt networks that triggered their creation.

### REST API

`Network` object in REST API is now extended with two new links:

`<external_provider id="123"/>` points to a `OpenStackNetworkProvider`. If this link is specified, new network is defined on the selected provider. This mimics Engine UI `New Network` dialog with `Create on external provider` checked.

`<external_provider_physical_network id="123"/>` points to a `Network`. This link is allowed only if `external_provider` is specified.

## Packaging and installation

This feature is integrated into 4.2 version of ovirt-provider-ovn, ovirt-engine and vdsm packages. The only extra requirement is to use Cluster with `Switch Type` set to `OVS`.

## Testing

Testing of this feature should cover:

- Addition/removal of locally attached external network via all UI methods and via REST.
- VM connectivity to physical network, with both VLAN tagged and untagged networks.
- Live migration of VMs attached to external networks.
- In case OVS cluster was configured on 4.1 and only then upgraded to 4.2 (without any `setupNetworks` calls after the upgrade was done), previous tests should also pass.
