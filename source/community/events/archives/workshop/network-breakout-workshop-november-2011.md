---
title: Network breakout - oVirt workshop November 2011
category: event/workshop
authors: adrian15, quaid
---

# Network breakout - oVirt workshop November 2011

[Quantum Ovirt discussion](https://resources.ovirt.org/old-site-files/wp/Quantum_Ovirt_discussion.pdf)

Quantum basic API approach:

1.  Create a network
2.  Create a port
3.  Create an interface (VNIC)

"Infinite capacity NIC you can plug in to the port, which then has limitations - speed, reliance, etc."

VNIC = simple entity

Port = sophistication

vnic, vport, vnet (vlan)

oVirt's world today is pretty static - quantum allows for logical designs but pushes those implementation details down to plugins

quantum model doesn't do provisioning/discovery ; system administrator needs to tell quantum what is available to use (physical nics/connectivity). They can add properties associated with that port ("blue" network, "public" network, 10Gb, etc), and make that available to tenents.

VLANs are a static resource in the datacenter - datacenter is the view of what is static (physical or virtual)

VLANs w/ meaning outside the cloud need to be treated specially/predefined by administrator vs a pool of available VLANs used as conumable resources inside the cloud.

Open vSwitch & Cisco UCS/Nexus plugins are shipped w/ the quantum source; there are others that exist but haven't been released by the owners yet. HP has publicly said they've done a plugin others have privately committed to it.

## NetStack L3 Service

*   Quantum addressees L2 abstraction
*   This is an L3 abstraction/API
*   Enables routing to/from tenant networks
*   Seperation allows you to mix/match L2/L3 management
*   Support for one or more public subnets
    -   w/ support for customer's IP address space
    -   VMs within this subnet have access to/from the public network via gateway
*   Support for one or more private subnets
    -   VMs w/ thi ssubnet do not have direct access to the public network
*   NAT
*   Gateway
*   Route tables in addition to dfeault
*   ACLs

Will have a consumer API - mapping to physical infrastructure will likely be a plugin setup

### Open Questions

Lots currently under discussion

## Quantum API

python plugin interface

Plugins handle the datastore; both opensource plugins use mysql database

Example: VLAN pool

administrator edits a config file (let's say) and lists out available vlan range...petered off

existing quantum implementation handles one plugin; combining openvswitch/nexus plugins means writing a new plugin that knows of both.

Design of quantum was to start small; thus the name. Consumer API reached consensus and allowed the project to get off the ground; expanding scope to provide a good API on the backend could be considered.

[Category:Workshop November 2011](/community/events/archives/workshop/workshop-november-2011.html)
