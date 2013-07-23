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

Currently, the engine assumes that the networks provided by the provider are available on all hosts in the data center, but it might be possible to have this capability added so that we would be able to query the host and see if it is providing networks for a given provider.

#### Network provisioning

The network can be exported from oVirt into the network provider, which means a user will be able to add the network to Quantum via oVirt, instead of using the Quantum API directly. However, from that moment on it will be as if the network was discovered from the provider - i.e. if it goes out of sync, that's OK from oVirt's perspective.

#### Virtual NIC provisioning

The network provider should be able to provision a virtual NIC's data (name, MAC, etc) on a network that it provides. oVirt would send the virtual NIC details over to the provider, and it should return the NIC connection details. These connection details should be used when the VM is run, or the NIC is plugged.

There should also be an option to "un-provision" a virtual NIC so that is being provisioned by the provider.

#### More details

Please see [Features/Detailed_Quantum_Integration](Features/Detailed_Quantum_Integration)

### Benefit to oVirt

*   Ability to use various technologies that OpenStack Quantum provides for it's networks, such as IPAM, L3 Routing, Security Groups, etc.
*   Ability to use technologies that aren't supported natively in oVirt (OVS, various controllers) for VM networks.

### Dependencies / Related Features

Depends on:

*   [Features/Device_Custom_Properties](Features/Device_Custom_Properties)
*   [Add VDSM hooks for updateDevice](https://bugzilla.redhat.com/893576) or else, we cannot "rewire" a currently-running VM to an external network.

### Testing

In order to test the feature follow these steps:

*   Make sure to run the tests in the sequence they're written
*   Install Neutron server & 'Linux Bridge' plugin per the steps at [Features/Detailed_Quantum_Integration](Features/Detailed_Quantum_Integration)
    -   Make sure you're using 'noauth' authentication to make things easier - no need to install Keystone at this point

| Test                         | Steps                                                                                                                     | Expected Result                                                        | Status | Post action                                                              |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|--------|--------------------------------------------------------------------------|
| Providers in left tree       | Open "External Providers" in the left tree                                                                                | The Providers tab should open and be the only one                      |        |                                                                          |
| Add provider dialog          | In the Providers main tab, click the "Add" button to add a new provider                                                   | -   Add provider dialog should open                                    
                                                                                                                                                            -   There should be no "Agent Configuration" left tab                   |        |                                                                          |
| Add provider validation      | In the Add provider dialog click OK                                                                                       | -   The "name", "provider type", "url" fields should be painted red    
                                                                                                                                                            -   The dialog should remain open                                       |        | Enter the provider name                                                  |
| Agent left tab               | Select a "Openstack Network" provider type                                                                                | The "Agent Configuration" left tab should appear                       |        |                                                                          |
| Test button functionality    | Click the "Test" button                                                                                                   | You should get a negative result                                       |        |                                                                          |
| Valid URL                    | -   Enter a valid URL for the provider                                                                                    
                                -   Click the "Test" button                                                                                                | You should get a positive result                                       |        |                                                                          |
| No communication to provider | -   Block communication to the Neutron service (iptables, or disconnect the engine from the network, or stop the service) 
                                -   Click the "Test" button                                                                                                | You should get a negative result                                       |        | Restore communication to the Neutron service                             |
| Bad URL                      | -   Change the URL to an invalid one by adding "1" at the end                                                             
                                -   Click the "Test" button                                                                                                | You should get a negative result                                       |        | Change back to the valid URL and make sure you get a "green" test result |
| Agent configuration          | -   Select a "Linux Bridge" plugin type                                                                                   
                                -   Switch to the "Agent Configuration" left tab                                                                           | You should see QPID parameters and interface mappings fields (total 5) |        | Fill the fields with the values you want sent to the hosts               |
| Test name                    | how to do                                                                                                                 | result                                                                 |        |                                                                          |
| Test name                    | how to do                                                                                                                 | result                                                                 |        |                                                                          |
| Test name                    | how to do                                                                                                                 | result                                                                 |        |                                                                          |
| Test name                    | how to do                                                                                                                 | result                                                                 |        |                                                                          |
| Test name                    | how to do                                                                                                                 | result                                                                 |        |                                                                          |

### Documentation / External references

*   General purpose wiki: [Network_Provider](Network_Provider)

### Comments and Discussion

*   Refer to <Talk:Features/Quantum_Integration>

<Category:Feature>
