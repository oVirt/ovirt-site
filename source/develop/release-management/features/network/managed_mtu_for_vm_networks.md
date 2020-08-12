---
title: Managed MTU for VM Networks
category: feature
authors: dholler
feature_name: Managed MTU for VM Networks
feature_modules: engine,provider-ovn
feature_status: In Development
---

# Managed MTU for VM Networks

## Summary

VM networks, especially external logical [OVN networks][1], transport the
Ethernet frames through a physical host network. The MTU of the VM network has
to be configured small enough to respect the MTU of the physical network.
The feature introduced here adds the ability to manage the MTU in a centralized
way to assist the configuration of the MTU of each VM network.

Feature progress is tracked on [Trello][14]. Related patches can be found on
[gerrit topic:managed_mtu][15].


## Owner

*   Name: [Dominik Holler](https://github.com/dominikholler)

*   Email: <dholler@redhat.com>


## Detailed Description

The logical network traffic of the VMs has to be transported by physical
networks between the hosts. The Ethernet frames of the logical network are
transported either
* as plain Ethernet frames,
* encapsulated in a VLAN or
* encapsulated in [GENEVE][3] tunnels.

### Plain Ethernet Frames
If the Ethernet frames of the logical network are transported as a plain Ethernet
frames of the physical network, the MTU of the logical network must not be
grater than the MTU of the physical network.

### VLAN
The same rule applies, if the Ethernet frames of the logical network is
transported encapsulated in a VLAN, because the added VLAN header belongs to
the Ethernet header.

### Tunnels
If the Ethernet frames of the logical network are encapsulated in GENEVE
tunnels, the calculation of the MTU of the logical network is not that simple
anymore. While the VLAN is on data link layer, the GENEVE tunnels are using the
transport layer. This means that the hosts might not be in the same broadcast
domain. Although [GENEVE][6] and [OVN][7] supports IP fragmentation, this is
not used in oVirt's default configuration to avoid tunnels with hard to detect
performance issues.
Hence, a Path MTU (PMTU) Discovery in the mesh of all possible hosts, which
could serve VMs with access to the logical network, would be required to
determine the maximum size of the encapsulating packet.
There is a common maximal MTU for all OVN networks used in a cluster, because
all OVN networks are transported over the same tunnels.
This implies the requirement to manage MTU in a centralized way.

Subtracting the encapsulation overhead from the maximum size of the
encapsulating packet results in the MTU of the logical network.

OpenStack puts the [burden to the networking plugin][4] to calculate
the [largest possible MTU size that can safely be applied][5] to VMs,
but in oVirt there will be no automatic calculation of the MTU.

### MTU individually per Network
MTU has to be managed individually for each network, because:
* The MTU of the logical network are transported either as plain Ethernet
  frames or encapsulated in a VLAN is individual for each network.
* The MTU for the external logical networks depends on the MTU of the underlying
  network and for localnets on the MTU of the connected logical network, too.
  There might be no common underlying network for the tunnels and this way it
  the common MTU is not obvious.
An individual MTU per network requires that oVirt engine supports the MTU
property of external networks:
* On Importing a network created outside engine on a provider.
* During automatic synchronization of external networks.
This requires enhancements in ovirt-engine, [OpenStack Java SDK][11] and
ovirt-provider-ovn.

### Propagating the MTU into the VMs

#### Set the MTU by DHCP
The MTU can be propagated via DHCP into the VMs. Since oVirt implements L3
functionality only for external logical networks, this approach works only for
external logical networks with a subnet defined and the VM configuring the
network interface via DHCP.

The only DHCP server managed by oVirt is the OVN internal DHCP server, which
is utilized to implement OpenStack API's subnets. Currently the DHCP server is
able to propagate a common MTU for all networks, configured in the
configuration file of ovirt-provider-ovn.
If we would [support the property MTU][8] of external networks, we could
propagate the MTU from ovirt-engine via the ovirt-provider-ovn into OVN's DHCP
server. This would require enhancements in ovirt-engine, [OpenStack Java
SDK][11] and ovirt-provider-ovn.
An alternative approach is to disable setting the MTU via DHCP in default
configuration.

DHCP can only be used to reduce the MTU inside the guest to values smaller than
1500 bytes, because DHCP does not configure the tap devices of the VM.

#### Set the MTU by libvirt
Since Red Hat Enterprise Linux 7.4 it is possible to set the MTU in libvirt's
XML, which will be propagated to libvirt's tap devices, qemu and virtio drivers
inside the guest VM.

The MTU is respected by QEMU for rhel7.4.0 machine type and later.
It is ignored by QEMU with rhel7.3.0 machine type and earlier because the MTU
feature wasn't supported, so migration from a RHEL 7.4 host to a RHEL 7.3 host
would fail.

Beside the possibility to specify the machine type individually for each VM,
a default machine type for clusters of a certain level is configured.
In cluster level 4.3 machine type rhel7.4.0 or later will be configured by
default.
Users can opt-in for this feature by configuring a default machine type of
rhel7.4.0 for for new clusters of cluster level 4.2 or clusters which will be
upgraded to cluster level 4.2:
~~~~
engine-config --set "ClusterEmulatedMachines=pc-i440fx-rhel7.4.0,pc-i440fx-2.9,pseries-rhel7.5.0,s390-ccw-virtio-2.6" --cver=4.2
~~~~
They can also opt-in per VM, by selecting rhel7.4.0 machine type of an
individual VM or template.

If an oVirt VM with rhel7.4.0 machine type is connected to ovirtmgmt with a MTU of
1234 and an OVN network with a MTU of 1100 is running, the configuration on the
host looks like this:

~~~~
[root@host23 ~]# ip l
35: br-int: <BROADCAST,MULTICAST> mtu 1100 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether d6:fe:bc:ce:72:4c brd ff:ff:ff:ff:ff:ff
36: genev_sys_6081: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65000 qdisc noqueue master ovs-system state UNKNOWN mode DEFAULT qlen 1000
    link/ether 5e:fa:6f:20:b3:52 brd ff:ff:ff:ff:ff:ff
37: ovirtmgmt: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1234 qdisc noqueue state UP mode DEFAULT qlen 1000
    link/ether 52:54:00:4d:a1:11 brd ff:ff:ff:ff:ff:ff
54: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1234 qdisc pfifo_fast master ovirtmgmt state UNKNOWN mode DEFAULT qlen 1000
    link/ether fe:1a:4a:16:01:02 brd ff:ff:ff:ff:ff:ff
55: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1100 qdisc pfifo_fast master ovs-system state UNKNOWN mode DEFAULT qlen 1000
    link/ether fe:1a:4a:16:01:04 brd ff:ff:ff:ff:ff:ff
[root@host23 ~]# ovs-vsctl show
6861a627-a6c9-41dd-ab88-b0e0f74525b1
    Bridge br-int
        fail_mode: secure
        Port "vnet1"
            Interface "vnet1"
        Port br-int
            Interface br-int
                type: internal
        Port "ovn-a8086d-0"
            Interface "ovn-a8086d-0"
                type: geneve
                options: {csum="true", key=flow, remote_ip="192.168.122.53"}
    ovs_version: "2.9.0"
[root@host23 ~]# ovs-vsctl get Interface br-int mtu
1100
~~~~

## Prerequisites
Setting the MTU via libvirt will work only on hosts with RHEL 7.4 or later.
For hosts with RHEL 7.4 or later libvirt's XML is produced by engine, which will
contain the definition. On hosts running older software, vdsm will create
libvirt's XML without the MTU definition.
Setting the MTU via libvirt works only on VMs with machine type rhel7.4.0 or
later, so setting the MTU via libvirt will work transparent to the user if the
default machine type in oVirt is rhel7.4.0 or later.

Setting the MTU by DHCP individally per network will require an updated
version of [OpenStack Java SDK][11] used by oVirt-engine.

## Limitations

* MTU is applied during the start of the VM or when hot plugging the network
  interface, but not during an update of the network.

* Setting the MTU by DHCP requires that the relevant interface is configured
  via DHCP by the guest.

* Setting the MTU via libvirt requires that the machine type of the VM is
  rhel7.4.0 or later, which requires that the hosts are running RHEL 7.4 or
  later.

* Setting the MTU via libvirt requires that vNIC interface is of model type
  'virtio' and the VirtIO driver of the guest supports MTU negation.
  This is given for RHEL 7.4 or later and VirtIO-Win version 1.9.1-0 (netkvm
  build 139) or later, which is already given for the already released
  oVirt-toolsSetup 4.2-1.

* MTU cannot applied to pass-through vNICs.

* Currently the attributes link state, device type of the vNIC, port mirroring,
  custom properties, QoS, and the network of the vNIC profile cannot be updated
  for plugged vNICs. As a workaround, unplug the vNIC, change the attribute,
  and replug the vNIC.

## Benefit to oVirt

If oVirt assist to configure the MTU inside the guest VM helps to get the VM
working as intended by the user.

If the MTU inside the guest VM is set too large, too large Ethernet frames sent
by the VM are dropped without any hint to the user.
If the MTU inside the guest VM is set too small, the performance of the vNIC
might be below the users expectation.

## Entity Description

The MTU property has to be enabled for creating external networks in webadmin,
the related AddNetworkOnProviderCommand, and during import and synchronization.
Similar to network name, the MTU of an external network cannot be updated by
webadmin, but will be updated during synchronization

### Default Value for MTU
If no MTU is defined for a network, [DHCP](#set-the-mtu-by-dhcp) falls back on
a default value configured in [oVirt OVN Provider][1].

Inside oVirt Engine every logical network has a MTU. If the user does not
specify a MTU explicitly, the MTU has the value `default`.
During [defining the vNIC by libvirt](#set-the-mtu-by-libvirt) the value
`default` is mapped to the default MTU for host networks, usually 1500 bytes,
or a new configuration value to configure the MTU of external networks, usually
1442 bytes.
If the value of MTU is `default`, the MTU is not send to the external provider,
because [OpenStack's mtu property][16] is optional and may confuse the provider.

## User Experience

The already available MTU property of logical network is enabled for external
networks.
The value shown as default MTU value in UI is imprecise due to tunneling
overhead, but we did not find an easily understandable way to present the
default MTU value for tunneled networks in the UI.

## Installation/Upgrade

Setting the MTU via libvirt will work only on hosts with RHEL 7.4 or later.
For hosts with RHEL 7.4 or later libvirt's XML is produced by engine, which will
contain the definition. On hosts running older software, vdsm will create
libvirt's XML without the MTU definition.

The MTU offered by OVN's internal DHCP server might be changed from a common
value for all networks to an individual value or might be disabled. The [current
documentation][13] already mention that offering the MTU might be disabled in
future version.

### Example Flows to propagate the MTU to a VM

The first three flows present how to use jumbo frames for VMs, while the
[AutoSync flow](#autosync-flow) is relevant for MTUs reduced by tunneling, too.

#### Linux-bridge Flow

This is an example flow to use Jumbo Frames in a cluster with linux-bridge
switch type, while the Ethernet frames of the logical network are transported
encapsulated in a VLAN or as plain Ethernet frames:
1. Create a new logical VM network with the optional VLAN and the desired MTU,
   e.g. 8000 bytes.
2. Assign this network, to a host NIC. Ensure that the switch port connected
   to this NIC is configured to accept big frames and the VLAN, e.g. by using
   [LLDP][17].
3. Use the vNIC profile of this new logical network in a vNIC of the desired VM.
3. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM,](#set-the-mtu-by-libvirt), else the MTU has to be configured manually inside the guest.

#### OVN Physical Network Flow

This is an example flow to use Jumbo Frames in a cluster with OVS
switch type, while the Ethernet frames of the logical network are transported
encapsulated in a VLAN or as plain Ethernet frames:
1. Create a new logical network with the optional VLAN and the desired MTU,
   e.g. 8000 bytes.
2. Assign this network, to a host NIC. Ensure that the switch port connected
   to this NIC is configured to accept big frames and the VLAN, e.g. by using
   [LLDP][17].
3. Create a new logical VM network with the desired MTU, e.g. 8000 bytes.
   This new logical network has to be created on the external provider and
   reference the first network as its physical network according the
   screenshot. If the DHCP server of the physical network should be used, no
   subnet should be defined.
   ![Create new logical VM network](/images/features/network/managed-mtu-for-vm-networks_new-network-dialog.png)
4. Use the vNIC profile of this new logical network in a vNIC of the desired VM.
5. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM.](#set-the-mtu-by-libvirt), else the MTU has to be configured manually inside the guest.

#### Tunneled OVN Flow

This is an example flow which results in the Ethernet frames of the logical
network are encapsulated in tunnels by OVN.
1. Create a new logical host network with a MTU which is by at least the size of
   the tunneling overhead greater than the desired MTU, e.g. 8058 bytes. In the
   default configuration of ovirt-provider-ovn the tunneling overhead is 58 bytes.
2. Assign this network, to a host NIC of every host in the cluster. Ensure that
   the switch port connected to this NICs is configured to accept big frames, 
   e.g. by using [LLDP][17].
3. Configure OVN to use this new network to create the tunnels:
~~~~
ansible-playbook -i /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory --extra-vars " cluster_name=<cluster name> ovn_central=<ovn central ip> ovn_tunneling_interface=<vdsm network name of the new logical host network>" /usr/share/ovirt-engine/playbooks/ovirt-provider-ovn-driver.yml
~~~~
4. Create a new logical VM network with the desired MTU, e.g. 8000 bytes.
   This new logical network has to be created on the external provider and
   must not reference any physical network according. It is useful to define a
   subnet for this network to enable the internal DHCP server.
5. Use the vNIC profile of this new logical network in a vNIC of the desired VM.
6. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM,](#set-the-mtu-by-libvirt). If a subnet is defined for the network, the [MTU is offered via DHCP to the VM](#set-the-mtu-by-dhcp).

#### AutoSync Flow

This a flow where the MTU is set by the external provider.
1. Create a new external logical network with [default MTU](#default-value-for-mtu)
   on a provider.
2. If the provider supports the [MTU extension][16], it will expose the MTU
   that is guaranteed to pass through the data path of the segments in the
   network.
   During the [automatic synchronization][18] the MTU in the provider's network
   representation is applied to the external network on oVirt Engine.
3. Use the vNIC profile of this logical network in a vNIC of the desired VM.
4. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM,](#set-the-mtu-by-libvirt).

#### AutoDefine Flow

This is an example flow about the MTU is deduced from a host network.
1. In webadmin, create a new logical network in a data center with a cluster
   with OVS switch type and a default network provider. You may specify a
   non-default MTU during creating the network.
2. A new external network is [created automatically][19] with the original
   network as its physical network. This external network is created with the
   same MTU as its physical network. If the physical network was created
   with default MTU, e.g. 1500, the MTU of the external network will be 1500,
   too. Please note that this is not the default value for tunneled networks,
   which is usually 1442 for GENEVE tunneled networks or 1450 for VXLAN tunneled
   networks.
3. Use the vNIC profile of this new external network in a vNIC of the desired VM.
4. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM,](#set-the-mtu-by-libvirt).

#### Update MTU Flow

The MTU is applied during the start of the VM or hot plugging the network
interface, but not during an update of the network.
Therefore, the vNICs of running VMs have to be hot unplugged and hot re-plugged to apply the MTU update.
1. In webadmin, modify the MTU of an already available network.
2. Unplug and plug every vNIC which should apply the updated MTU.
3. [If requirements are fulfilled, libvirt tries to propagate the MTU into the VM,](#set-the-mtu-by-libvirt).

## Documentation & External references

[oVirt OVN Provider](/develop/release-management/features/network/ovirt-ovn-provider.html)

[Provider Physical Network](/develop/release-management/features/network/provider-physical-network.html)

[What is GENEVE?](https://www.redhat.com/en/blog/what-geneve)

[openstack](https://specs.openstack.org/openstack/neutron-specs/specs/kilo/mtu-selection-and-advertisement.html)

[openstack doc](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/12/html/networking_guide/sec-mtu)

[GENEVE](https://tools.ietf.org/html/draft-gross-geneve-00#section-4.1.1)

[option `df_default`  ovs-vswitchd.conf.db(5)](http://www.openvswitch.org//support/dist-docs/ovs-vswitchd.conf.db.5.html)

[Bug 1538465 - Support MTU property with OVN networks](https://bugzilla.redhat.com/show_bug.cgi?id=1538465)

[Bug 1451342 - configure guest MTU based on underlying network](https://bugzilla.redhat.com/show_bug.cgi?id=1451342)

[Network Details in OpenStack API](https://developer.openstack.org/api-ref/network/v2/?expanded=create-network-detail#show-network-details)

[OpenStack Java SDK](https://github.com/woorea/openstack-java-sdk)

[MTU support in libvirt](https://libvirt.org/formatnetwork.html#elementsConnect)

[Configuration of OVN's internal DHCP server by ovirt-provider-ovn](https://github.com/oVirt/ovirt-provider-ovn/#section-dhcp)

[Trello](https://trello.com/c/wTtoBph7/131-add-mtu-to-interface-elements-in-vdsm-proper-and-in-ovn-driver)

[Related patches](https://gerrit.ovirt.org/#/q/topic:managed_mtu)

[MTU extensions in OpenStack Networking API v2.0](https://developer.openstack.org/api-ref/network/v2/index.html#mtu-extensions)

[LLDP](/develop/release-management/features/network/lldp.html)

[AutoSync](http://ovirt.github.io/ovirt-engine-api-model/4.2/#types/open_stack_network_provider/attributes/auto_sync)

[Autodefine External Network](/develop/release-management/features/network/autodefine-external-network.html)

## Testing
All test have to be checked using a VM with machine type rhel7.4.0 or later and
with virtio vNIC for VLAN network and an OVN network.

* Define MTU < 1500 on logical network and check if it propagated to the guest.

* Define MTU > 1500 on logical network and check if it propagated to the guest.

* Define MTU > 1500 on logical network and the involved physical switch ports
  and check if it works by pinging the guest via `ping -M do -s`.

## Contingency Plan

Without this feature, the configuration process of configuring a MTU bigger than
1442 bytes for OVN networks is complex and undocumented, so that most users are
expect to use OVN networks with degraded throughput.

## Follow-Up Features
This feature is about propagating the MTU from oVirt Engine down to the VMs.
The automatic calculation of the MTU would be a follow-up feature.

## Release Notes

      == Managed MTU for VM networks ==
      The MTU of logical networks, including external ones, is propageted the
      whole path down to the guest's network interface. This will enable the
      usage of MTU > 1500 bytes for external networks.

