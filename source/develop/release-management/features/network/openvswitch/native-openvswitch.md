---
title: Native Open vSwitch
category: feature
authors: phoracek danken edwardh amusil
---

# Native Open vSwitch

## Summary
[Open vSwitch (OVS)](http://openvswitch.org/) is a production quality multilayer virtual switch that is widely used in virtualization and dedicated HW environments.
OVS is targeted to replace the native Linux networking solutions (mainly the bridge).
The integration of OVS into oVirt has begun by introducing a special hook that implemented the networking details using OVS.
OVS is to be fully integrated (natively) into oVirt through VDSM, becoming the default networking solution, deprecating the hook.

## Goals
1. Replace native Linux networking entities (e.g. bridge) with OVS on oVirt hosts.
2. Preserve current networking requirements from oVirt hosts.
3. Preserve or increase networking performance (latency, throughput, number of networks).
4. Keep both switching options available, letting end users of ovirt-4.0 decide when they would like to upgrade their existing 3.6 clusters.
5. Allow extending available networking features by integrating with OVS features natively or via 3rd party (e.g SDN).

## Overview
The introduction of OVS as an additional network switching solution raises the need to generalize and abstract the requirements from the system networking services and define a spec which considers both options (OVS & native Linux networking).
The OVS model of arranging networking entities is different from the native Linux networking, but is closer to industry networking modeling.
A VM can not be simply connected to an OvS bridge. In order to connect a VM to an OvS bridge, a user must first define an OvS VM network. 
This automatically creates an OVN network, which is built on top of an OvS integration bridge. The VM is then attached to the OVN network via the OvS integration bridge (see [Autodefine External Network](/develop/release-management/features/network/autodefine-external-network.html)).

### Network Entities
In the following table, networking entities are listed with their implementation options.

|     Entity       | Kernel |  OVS  |    Remark     |
| :----------------| :----: | :---: | ------------- |
| Interface        |   X    |   X*  | Interfaces may be created by OVS on the kernel and attached to OVS ports. |
| Port/NIC         |   X    |   X   |               |
| Bond             |   X    |   X   | kernel mod    |
| Bridge           |   X    |   X   |               |
| Tagging & Tunneling | X   |   X   |               |
| QoS              |   X    |   X   |               |
| IP routing       |   X    | w/Controller |        |
| TCP/UDP stack    |   X    |   -   |               |

### Linux legacy networking model
![Linux legacy networking model](/develop/release-management/features/network/openvswitch/linux_legacy_networking_model.svg)

### OVS networking model 
![OVS networking model](/develop/release-management/features/network/openvswitch/ovs_networking_model.svg)

## Limitations

Currently there are some limitations compared to Linux bridge [RFE OvS support](https://bugzilla.redhat.com/show_bug.cgi?id=1195208):

- [Multiple gateways](https://bugzilla.redhat.com/show_bug.cgi?id=1383035) - Source routing is not implemented for the OVS switch type. This means that only management network can have a gateway.
- [Port mirroring](https://bugzilla.redhat.com/show_bug.cgi?id=1362492) -  Should be done via OVN.
- [Host QoS](https://bugzilla.redhat.com/show_bug.cgi?id=1380271) - OvS supports different parameters for configuring QoS, which are incompatible with the ones used for a Linux bridge.
- [Setting bridge options](https://bugzilla.redhat.com/show_bug.cgi?id=1380273)
- [iSCSI Bond](https://bugzilla.redhat.com/show_bug.cgi?id=1441245)
- LLDP support
- Setting DNS
- Upgrade from Linux bridge to OvS and vice versa

## Specifications

### Solution Diagram
![Solution Diagram](/develop/release-management/features/network/openvswitch/solution_diagram.svg)

### NetSwitch
A generic switch interface, relaying setup or report requests to the relevant switch implementation (currently two, legacy Linux networking and OVS).

This aproach is prefered over having an additional configurator type under the existing switch scheme:

- Adding OVS as a configurator may require changes in the upper common levels, which may introduce instability in existing functionality.
The proposed abstraction level is aimed to leave existing logic isolated from OVS (and vice versa), reducing potential regression and instability.
- Different switches or domains should be decoupled, each having their own underling implementation options allowing full flexability on how they are implemented.
- The modeling of each switch is different, having it seperated reduces complex logic.

Switch implementations are registered per availability, with an identification and a callback. 
setupNetworks requests are expected to arrive from Engine with a switch type ID, based on which the request is forwarded to the switch implementation.

Each switch should have its own validation check in addition to a common one, handling switch specific rules.


### OVS Configurators
There are at least two ways to configure OVS: Using the command line utilities (i.e ovs-vsctl) and OVSDB protocol Python binding. The latter is considered faster.
To allow future optimizations, an abstraction is defined with the command line as its implementation. This adopts similar work done on openstack ovsdb agent.
API Ref: https://review.openstack.org/#/c/143709/20/neutron/agent/ovsdb.py

### IP Interface
Host IP settings are defined on the kernel stack, independent of the network switch type.
Current Linux-native networking implementation mixes between the two. For OVS, we would like to put things in better order: the IP setup actions are to be organized under the same “roof”, implemented using configurators.

### Persistence
OVS persistency is embedded in the switch.
IP settings are not included and may be implemented using the current persistence scheme.
- Note: An alternative may be to use a minimal persistent management settings and zero persistency for all the rest. Nevertheless these changes are out of scope and are to be handled under a zero persistency feature. 

### Rollback
VDSM networking uses rollback to recover from a setup request which failed to complete.
The network API setupNetworks verb has a complex rollback semantics.
In the VDSM api context, a rollback is detected and a command is issued to supervdsm for handling. This function is currently unused, because the ifcfg configurator never triggers it.
Handling the rollback as close as possible to the setupNetworks api implementation seems more reasonable, moving this rollback handler to the network api (currently in supervdsm context) is to be considered.
The OVS rollback is to be integrated into the existing rollback functionality without heavily affecting existing beahaviours:

- OVS configurators should trigger a rollback which is to be handled at the api level (as described above).
- The ifcfg configurator should keep the existing logic, but in addition it should inform the api level of the rollback which it handled.
Moving the handling of the rollback from the ifcfg configurator to the api level should be investigated, simplifying rollback logic.
- The api level should combine both ifcfg and OVS results in terms of the rollback, and issue relevant commands.
  - When upgrading from legacy to OVS, there is a need to tear down bridges and configure OVS in one transaction and during one rollback.

### VDSM API
Minimal changes in current API verbs are required:

- setupNetworks: Per network, add a switch_type key.
  - Currently it can have two values: ‘legacy’ and ‘ovs’.
  - If not explicitly set, assume ‘legacy’. (for compatability with Engine 3.6)
- oVirt currently differentiates between VM (bridged) networks and non-VM networks due to historical performance benefit of non-bridged networks for non-VM payloads (such as storage and migration). This differentiation is moot with OVS, but in order to keep Engine oblivious to the change, VDSM should lie to it, and report bridged=False for networks that requested it. Dropping the differentiation from Engine should happen in a later stage.

### Upgrade from native to OVS networking

Upgrade from native to OvS is currently not supported and vice versa. An upgrade will cause networks to be out-of-sync due to differences between native and OvS (see [Limitations](#limitations)). Only newly added hosts can be configured with OvS networking. Mixing native and OvS networks in a cluster is not supported. Plase note that the change is blocked only in UI but is still possible via REST api. 

~~Transition between switch types must be supported for the host as a whole. Nevertheless, if the user has defined his own networking configuration which is not controlled by VDSM, it should coexist with VDSM controlled networks.~~

~~Mixing between native and OVS controlled networks is not initially supported, therefore, when a network is marked with a different type from the existing, a validation check should make sure that all other networks are marked for the same network type.~~

~~The following sequence describes the transition steps @Engine:~~

- ~~Vdsm on hosts is upgraded to an OVS-supporting version (4.0). No change takes place to preexisting network configuration, which would still be bridge-based.~~
- ~~When all active hosts in the cluster have been upgraded, the user should upgrade the cluster to version 4.0 where OVS is supported.~~
- ~~The default switch type for the cluster should be set by the user to OVS (for new hosts).~~
  - ~~Newly-created 4.0 clusters should have OVS as the default switch.~~
- ~~Update individual hosts to transition to OVS:~~
  - ~~The host networking can be changed when no VM/s are connected to it. With this option oVirt must support VM migration between different switch types.~~
  - ~~We can further improve the user experience by a second approach:~~
~~The host networking can be changed in-place without the need to migrate the VM/s. With this option, migration between hosts that have different networking types is not needed (but can coexist).~~
~~Negligible service interruption to the VM networking is expected.~~

~~The following sequence describes the transition steps @Host:~~
- ~~Receive a setupNetworks call.~~
- ~~Detect that a network has been marked with a type that is different from the current.~~
- ~~Validate that all existing networks exist in the command and that all are marked with the same type.~~
  - ~~We would like to perform an atomic upgrade, and not to worry about codependent networks with differing switch types.~~
- ~~Tear down the pre-existing networks and bondings..~~
- ~~Create networks.~~

~~Note: Engine user may decide to take the reverse transition, from OVS to legacy, as well.~~

### VM Migration
VM migrations may occur between two hosts that have different types of networking. (See upgrade options above)

In order to support such a migration, libvirt migration hooks will be set at the hosts, allowing the target host to update the network source per the existing network type. 

- This libvirt hook is not available on 3.6 hosts, hence we block migration from OVS active host to 3.6 hosts. 
- Note: fallback to a 3.6 host (from 4.0) is not supported.

### Multi Bridge
Linux native bridges have no vlan awareness. Binding them to a VLAN is done by adding a VLAN interface to one of its ports. This model decoupled a bridge and vlan, allowing two bridges, both not bound to a vlan (or both bound to the same VLAN/s) yet each is isolated from the other.

An OVS bridge has VLANs embedded, its ports may be marked as trunk or as access of a specific vlan (including VLAN 0). In order to have multiple non-vlan (or with the same VLAN) networks, multiple OVS bridges need to be configured.

When a host works with an OVS switch type, VDSM is required to detect the need of multiple OVS bridges and setup the entities to support it.

Multiple OVS bridges are required in this network topology:

- Two or more non-vlan networks, connected to different nics/bonds.
- Two or more identical-vlan networks, connected to different nics/bonds.

### File Structure
Base path: vdsm/lib/vdsm/network/

- api.py
- netswitch.py
- legacy
  - switch.py
  - configurators
    - ifcfg.py
    - iproute2.py
    - netlink.py
  - validator.py
  - netinfo
- ovs
  - switch.py
  - configurators
    - vsctl.py
    - ovsdb.py
  - validator.py
  - netinfo
- ip
  - ip.py
  - configurators
    - iproute2.py
  - netinfo
- libvirt.py
- qos.py
- tc
- dhclient.py

### Dev Stages

1. VDSM Network API cleanup: Seperating current switch logic from the api and cleaning up.
2. Introduce a net-switch abstraction layer with the native Linux networking implementing it.
3. Create the IP module with iproute2 configurator.
4. Create the OVS module:
  - Normalize/Canonicalize
  - Validate request
  - ovs-vsctl configurator
  - Optional: OVS Python binding configurator


## Detail Design

### Persistence
KernelConfig should be modified to consider OVSInfo on top of native NetInfo.
