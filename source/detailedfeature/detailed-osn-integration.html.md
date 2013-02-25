---
title: Detailed OSN Integration
category: detailedfeature
authors: danken, lvernia, mkolesni, moti, mpavlik
wiki_category: DetailedFeature
wiki_title: Features/Detailed OSN Integration
wiki_revision_count: 72
wiki_last_updated: 2014-03-24
---

# Detailed OSN Integration

## Overview

A network provider is an external provider that can provide networking capabilities for consumption by oVirt hosts and/or virtual machines. The network provider has the knowledge about the networks that it manages, and works autonomously from oVirt. The provider should enable integration on 3 points:

*   Discovery of networks
*   Provisioning of networks
*   Provisioning of virtual NICs on the network

## Required capabilities

### Network discovery

There should be a way for oVirt to discover what networks are available on the provider. An oVirt user could then decide to import a network, that is provided by the provider, as a new one into a data center, or attach it to an existing data center network, marking that the network is also provided by this provider (in addition to any other provider that provides it).

Currently, we assume that the networks provided by the provider are available on all hosts in the data center, but it is possible to have this capability added so that we would be able to query the provider if a specific host provides a given network or not.

### Network provisioning

The network can be exported from oVirt into the network provider, but from that moment on it will be as if the network was discovered from the provider - i.e. if it goes out of sync, that's OK from oVirt's perspective.

### Virtual NIC provisioning

The network provider should be able to provision a virtual NIC's data (name, MAC, etc) on a network that it provides. oVirt would send the virtual NIC details over to the provider, and it should return the NIC connection details. These connection details should be used when the VM is run, or the NIC is plugged.

There should also be an option to "un-provision" a virtual NIC so that is being provisioned by the provider.

## Integrating external providers

The integration of network providers into oVirt will be incremental.

### Phase 1

#### Network provider entity

*   Introducing a 'Network Provider' entity that will have the following properties:
    -   Name
    -   Description
    -   Type (Technology?)
    -   URI
    -   User/Password ?
*   Possibly, different providers can have additional properties that are needed by them.

#### Changes in network entity

*   Each network can be provided **either** by oVirt or by the external provider.
*   This requires that each network has a link to the provider:
    -   If the link is set, then this network is provided by the external provider.
    -   If the link is not set, the network is not provided externally.
*   There need also be an ID property of the network on the external provider.
*   In this phase, only VM networks can be provided by an external provider.
*   Currently. only one external provider will be supported for a network.
*   If a network is externally provided, it will **not** be editable in oVirt, since the external provider is responsible for managing the actual network configuration.

#### Integration with virtual NIC lifecycle

*   Integration will be done at this phase for running virtual machine only, so other operations (hot-plug, rewire, etc) will **not** be supported for externally provided networks.
*   When VM is being run we need to include all hosts in the cluster for scheduling decision of available networks.
*   For each virtual NIC that is using an externally provided network, we would need to provision the NIC on the provider and receive the NIC connection details prior to running the VM.
    -   Once we have all the details available, we would need to pass those details to VDSM.
        -   This requires API change in the 'create' verb that would pass the connection details for each NIC.
*   On VM stop, we need to "un-provision" the NIC of each externally provided network from the relevant provider

### Future phases

#### Allow provisioning networks on external providers

*   It would be possible to define a network in oVirt and "push" it to external providers. This network will then be treated as is it was discovered on the provider, and will be the sole responsibility of the provider.
*   The provider will be responsible for providing the connectivity of the network.

#### Auto-Discovery of networks

*   An external provider would be set up as the provider of networking for a DC, such that any network defined on the provider will be discovered by oVirt and automatically set-up on the DC.

## Proof of Concept

A POC was done with the proposed ideas in "Phase 1" section, integrating [Openstack Quantum](https://wiki.openstack.org/wiki/Quantum) as an external network provider. the POC is available for review & testing.

### POC Sources

The POC sources can be found in the oVirt gerrit under a topic branch: <http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:POC_NetworkProvider,n,z>

### Demo Videos

Demo videos of the POC in action are available on youtube.

#### The 1st part (the providers tab, discovery, etc)

<http://www.youtube.com/watch?v=yXqN17KktjE>

#### The 2nd part (VM connectivity)

<http://www.youtube.com/watch?v=uW3vrY2Y3xc>
