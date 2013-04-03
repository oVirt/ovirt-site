---
title: OSN Integration
category: feature
authors: danken, lvernia, mkolesni
wiki_category: Feature
wiki_title: Features/OSN Integration
wiki_revision_count: 13
wiki_last_updated: 2013-08-06
---

# OSN Integration

## Integrating OpenStack Quantum as a network provider in oVirt

### Summary

We intend to add support for OpenStack Quantum as a network provider.

A network provider is an external provider that can provide networking capabilities for consumption by oVirt hosts and/or virtual machines. The network provider has the knowledge about the networks that it manages, and works autonomously from oVirt. The provider should enable integration on 3 points:

*   Discovery of networks
*   Provisioning of networks
*   Provisioning of virtual NICs on the network

### Owner

*   Name: [ Mike Kolesnik](User:Mkolesni)
*   Email: <mkolesni@redhat.com>

### Current status

*   Planned for oVirt 3.3
*   Last updated: ,

### Detailed Description

#### Network discovery

There should be a way for oVirt to discover what networks are available on the provider. An oVirt user could then decide to import a network, that is provided by the provider, as a new one into a data center, or attach it to an existing data center network, marking that the network is also provided by this provider (in addition to any other provider that provides it).

Currently, the engine assumes that the networks provided by the provider are available on all hosts in the data center, but it is possible to have this capability added so that we would be able to query the provider if a specific host provides a given network or not.

#### Network provisioning

The network can be exported from oVirt into the network provider, but from that moment on it will be as if the network was discovered from the provider - i.e. if it goes out of sync, that's OK from oVirt's perspective.

#### Virtual NIC provisioning

The network provider should be able to provision a virtual NIC's data (name, MAC, etc) on a network that it provides. oVirt would send the virtual NIC details over to the provider, and it should return the NIC connection details. These connection details should be used when the VM is run, or the NIC is plugged.

There should also be an option to "un-provision" a virtual NIC so that is being provisioned by the provider.

#### More details

Please see [Network_Provider](Network_Provider)

### Benefit to oVirt

*   Ability to use various technologies that OpenStack Quantum provides for it's networks, such as IPAM, L3 Routing, Security Groups, etc.
*   Ability to use technologies that aren't supported natively in oVirt (OVS, various controllers) for VM networks.

### Dependencies / Related Features

Depends on:

*   [Features/Device_Custom_Properties](Features/Device_Custom_Properties)
*   [https://bugzilla.redhat.com/893576 Add VDSM hooks for updateDevice](https://bugzilla.redhat.com/893576 Add VDSM hooks for updateDevice) or else, we cannot "rewire" a currently-running VM to an external network.

### Documentation / External references

*   General purpose wiki: [Network_Provider](Network_Provider)

### Comments and Discussion

*   Refer to <Talk:Features/Quantum_Integration>

<Category:Feature>
