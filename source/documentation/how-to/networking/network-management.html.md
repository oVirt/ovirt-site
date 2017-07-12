---
title: Network Management
authors: lpeer, mkolesni
---

<!-- TODO: Content review -->

# Network Management

## Definitions

### Network

## The big picture

| Area                             | Action                    | Internal impl.                                                          | Quantum API                                                                              | Notes                                                                           |
|----------------------------------|---------------------------|-------------------------------------------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| Logical network                  | Create network            | AddNetwork                                                              | <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Network>                   | Quantum API accept network name returns id, needs to be persisted in the engine |
| Update network                   | UpdateNetwork             | <http://wiki.openstack.org/Quantum/APIv2-specificationv#Update_Network> | Quantum API updates network name, admin. state and sharing status                        |
| Delete network                   | RemoveNetwork             | <http://wiki.openstack.org/Quantum/APIv2-specification#Delete_Network>  |                                                                                          |
| Attachment of network to cluster | Attach to cluster         | AttachNetworkToVdsGroup                                                 | ?                                                                                        |                                                                                 |
| Update attachment                | UpdateNetworkOnCluster    | ?                                                                       |                                                                                          |
| Detach from cluster              | DetachNetworkToVdsGroup   | ?                                                                       |                                                                                          |
| Apply networking on host         | Apply network             | SetupNetworks
                                                                Deprecated:
                                                                UpdateNetworkToVdsInterface
                                                                AttachNetworkToVdsInterface
                                                                DetachNetworkFromVdsInterface
                                                                AddBond
                                                                RemoveBond                                                               | <http://wiki.openstack.org/ConfigureOpenvswitch>                                         | This is specific to OVS plugin, need to figure out for other plugin types.      |
| Commit changes on host           | CommitNetworkChanges      | ?                                                                       | Perhaps same rollback mechanism used today can be used for plugin configuration as well? |
| vNICs on VM Templates            | Create vNIC on Template   | AddVmTemplateInterface                                                  |                                                                                          |                                                                                 |
| Update vNIC on Template          | UpdateVmTemplateInterface |                                                                         |                                                                                          |
| Delete vNIC on Template          | RemoveVmTemplateInterface |                                                                         |                                                                                          |
| vNICs on VMs                     | Create vNIC on VM         | AddVmInterface                                                          |                                                                                          |                                                                                 |
| Update vNIC on VM                | UpdateVmInterface         |                                                                         |                                                                                          |
| Delete vNIC on VM                | RemoveVmInterface         |                                                                         |                                                                                          |
| Activate vNIC on running VM      | RunVm
                                    HotPlugUnplugVmNic         | <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Port>     |                                                                                          |
| Deactivate vNIC on running VM    | StopVm (on callback)
                                    HotPlugUnplugVmNic         | <http://wiki.openstack.org/Quantum/APIv2-specification#Delete_Port>     |                                                                                          |

## What Quantum has to offer

*   VM-network centric.
*   Connectivity to a variety of networking (L2) solutions (bridge, OVS, UCS, etc).
*   IPAM (IP Address Mmanagement, L3) for vNICs.

## How can this be integrated into oVirt

*   Need to have proprietary L2 network implementations live side by side with Quantum plugin.

<!-- -->

*   In engine, there should be a designation of network type, either 'oVirt internal' style, or 'Quantum: OVS' (or drop the quantum?)

<!-- -->

*   -   It should be possbile to mix & match ovirt internal network with others, but not sure the others can be mixed.

<!-- -->

*   -   Some functionality, such as bond management, will have to remain in oVirt network management since it is not part of quantum API.

<!-- -->

*   Quantum will be installed on the oVirt-engine host machine.

<!-- -->

*   Plugin needs to be installed (either part of bootstrap or part of VDSM command) on the Hosts.

<!-- -->

*   VDSM would need to support configuration of the quantum plugin on the Hosts,

<!-- -->

*   VDSM would need to support sending port data to libvirt on run VM/hot-plug vNIC.

<!-- -->

*   We can utilize Quantum's IPAM for vNICs:

<!-- -->

*   -   Should we define a "subnet" entity to be under a logical network, which corresponds to Quantum's "subnet" entity?

## Integrating UCSM into oVirt

#### Configuration Provider entity

This entity represents a configuration provider, and will exist on a system-wide level, The new configuration Provider entity should have these properties:

*   Name
*   Description
*   Type (currently UCSM, going forward we expect to have more like BLADE Harmony Manager etc.)
*   Management IP / URI
*   User
*   Password

#### Network entity

Network entity should have additional properties added:

*   Configuration provider

The network should be created on Quantum as part of the "create network" operation in case a quantum provider was chosen.

Alternatively, we would create the port profile on UCSM directly & configure the VLAN for it.

It is possible that we would need to get the port profile name from Quantum to use in several scenarios, i.e. when determining which networks are available on a host.

In this case, we would need to get this info from Quantum after the network has been created there. Quantum should have this API available.

Question: How would we allow to configure the network on more than one UCSM?

Answer: It is possible to have the network linked to several UCSMs, in this case the port profile of the network should be created on each one.

Question: How would UCSM support MTU?

Answer: It is possible to set at the UCSM level, for the entire fabric, at the "QoS System Class"es.

Question: Does Quantum support setting VLAN ID?

Answer: Doesn't seem to do that, just use the fixed IP in the plugin conf.

Question: Does this mean the network now has a state (Locked, OK, etc)?

#### Network to Cluster attachment

The network can then be attached to a cluster as any other network would. No change is necessary at this level.

#### Host provisioning

A host that has the Palo Adapter (M81KR) installed will reveal itself as part of the vdsCaps. SetupNetwork for attaching VM networks to dynamic vnic is not needed, we'll assume all networks with configuration provider 'UCSM' that are attached to this cluster are available via the Palo card.

Info that needs to be provided by VDSM as part of the adapter info:

*   Which or How many virtual NICs are available
*   Which vNICs are static (vs. dynamic)?

The Palo adapter will appear in the setup networks dialog.

*   Identified by vendor id 0x1137 device id 0x0023

The dynamic virtual NICs exposed by the Palo adapter should NOT be assignable in setup networks.

*   Identified by vendor id 0x1137 device id 0x0044

The static virtual NICs exposed by the Palo adapter should appear as "regular" NICs which allow networks attached to them.

#### VM Scheduling

If the network is optional (& not Build-in?) then the scheduling algorithm should ignore it when picking a host to run the VM on (or migrate the VM to).

Scheduling should, however, make sure that the selected host has a free dynamic vNIC.

#### Mixed technologies

Generally we do not recommend supporting mixed technologies within the same cluster. - It seems like migration won't work (libvirt does not support that) - It seems like VMware does not support this option Maybe it is not that common or not really needed.

Having said that, if we insist on supporting Mixed technologies within the same cluster, we think the only valid combination to support is a MIX of a native technology (currently Linux bridge) with one external provider like UCSM OR UFM (Mellanox) etc.

This requires blocking migration between incompatible hosts. We should consider that even if the host has the network available on the Palo adapter (in the UCSM example), the user might implement it using the native technology and use setup networks.

Note: A host that is moved from one cluster to the other won't necessarily fail the network checks, but will have to be se-synched in order to provision the network correctly.
