---
title: OSN Integration
category: feature
authors:
  - danken
  - lvernia
  - mkolesni
---

# OSN Integration

## Integrating OpenStack Neutron as a network provider in oVirt

### Summary

We intend to add support for OpenStack Neutron as a network provider.

A network provider is an external provider that can provide networking capabilities for consumption by oVirt hosts and/or virtual machines. The network provider has the knowledge about the networks that it manages, and works autonomously from oVirt. The provider should enable integration on 3 points:

*   Discovery of networks
*   Provisioning of networks
*   Provisioning of virtual NICs on the network

### Owner

*   Name: Mike Kolesnik (Mkolesni)
*   Email: <mkolesni@redhat.com>

### Current status

*   Available in oVirt 3.3 as tech preview
*   Last updated: ,

### Detailed Description

#### Network discovery

There should be a way for oVirt to discover what networks are available on the provider. An oVirt user could then decide to import a network, that is provided by the provider, as a new one into a data center, or attach it to an existing data center network, marking that the network is also provided by this provider (in addition to any other provider that provides it).

Currently, the engine assumes that the networks provided by the provider are available on all hosts in the data center, but it might be possible to have this capability added so that we would be able to query the host and see if it is providing networks for a given provider.

#### Network provisioning

The network can be exported from oVirt into the network provider, which means a user will be able to add the network to Neutron via oVirt, instead of using the Neutron API directly. However, from that moment on it will be as if the network was discovered from the provider - i.e. if it goes out of sync, that's OK from oVirt's perspective.

#### Virtual NIC provisioning

The network provider should be able to provision a virtual NIC's data (name, MAC, etc) on a network that it provides. oVirt would send the virtual NIC details over to the provider, and it should return the NIC connection details. These connection details should be used when the VM is run, or the NIC is plugged.

There should also be an option to "un-provision" a virtual NIC so that is being provisioned by the provider.

#### More details

Please see [Features/Detailed_OSN_Integration](/develop/release-management/features/network/detailed-osn-integration.html)

### Benefit to oVirt

*   Ability to use various technologies that OpenStack Neutron provides for it's networks, such as IPAM, L3 Routing, Security Groups, etc.
*   Ability to use technologies that aren't supported natively in oVirt (OVS, various controllers) for VM networks.

### Dependencies / Related Features

Depends on:

*   [Features/Device_Custom_Properties](/develop/release-management/features/network/device-custom-properties.html)
*   [Add VDSM hooks for updateDevice](https://bugzilla.redhat.com/893576) or else, we cannot "rewire" a currently-running VM to an external network.

### Testing

In order to test the feature follow these steps:

*   Make sure to run the tests in the sequence they're written
*   Install Neutron server & 'Linux Bridge' plugin per the steps at [Features/Detailed_OSN_Integration](/develop/release-management/features/network/detailed-osn-integration.html)
    -   Make sure you're using 'noauth' authentication to make things easier - no need to install Keystone at this point
    -   Make sure you're defining:
        -   tenant_network_type = vlan
        -   network_vlan_ranges = red:1:1000,blue:1001:2000,green
*   Make sure hosts run in selinux=permissive mode (Neutron limitation)
*   Add a couple of test networks to the neutron service via the API

| Test                               | Steps                                                                                                                             | Expected Result                                                                                        | Status | Post action                                                              |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|--------|--------------------------------------------------------------------------|
| Providers in left tree             | Open "External Providers" in the left tree                                                                                        | The Providers tab should open and be the only one                                                      |        |                                                                          |
| Add provider dialog                | In the Providers main tab, click the "Add" button to add a new provider                                                           | -   Add provider dialog should open                                                                    
                                                                                                                                                                          -   There should be no "Agent Configuration" left tab                                                   |        |                                                                          |
| Add provider validation            | In the Add provider dialog, clear all fields and click OK                                                                         | -   The "name" and "url" fields should be painted red                                                  
                                                                                                                                                                          -   The dialog should remain open                                                                       |        | Enter the provider name                                                  |
| Plugin Type                        | Select the "OpenStack Network" provider type                                                                                      | -   The "Plugin Type" field should appear and be empty.                                                
                                                                                                                                                                          -   When clicking on it, the options "Linux Bridge" and "Open vSwitch" should appear.                   |        |                                                                          |
| Agent left tab                     | Pick one of the two preset "Plugin Type" values.                                                                                  | The "Agent Configuration" left tab should appear                                                       |        |                                                                          |
| Test button functionality          | Click the "Test" button                                                                                                           | You should get a negative result                                                                       |        |                                                                          |
| Valid URL                          | -   Enter a valid URL for the provider                                                                                            
                                      -   Click the "Test" button                                                                                                        | You should get a positive result                                                                       |        |                                                                          |
| No communication to provider       | -   Block communication to the Neutron service (iptables, or disconnect the engine from the network, or stop the service)         
                                      -   Click the "Test" button                                                                                                        | You should get a negative result                                                                       |        | Restore communication to the Neutron service                             |
| Bad URL                            | -   Change the URL to an invalid one by adding "1" at the end                                                                     
                                      -   Click the "Test" button                                                                                                        | You should get a negative result                                                                       |        | Change back to the valid URL and make sure you get a "green" test result |
| Agent configuration                | -   Select a "Linux Bridge" plugin type                                                                                           
                                      -   Switch to the "Agent Configuration" left tab                                                                                   | You should see QPID parameters and interface mappings fields (total 5)                                 |        | Fill the fields with the values you want sent to the hosts               |
| Field consistency                  | Pick different values in the "Provider Type" and/or "Plugin Type" fields, then go back to "OpenStack Network" and "Linux Bridge". | Make sure the original values you filled in other fields haven't changed.                              |        |                                                                          |
| Saving the provider                | Click "OK"                                                                                                                        | -   The provider should appear in the main tab                                                         
                                                                                                                                                                          -   There should be an audit log message that the provider was added                                    |        |                                                                          |
| Edit provider dialog               | -   Select the provider you just added                                                                                            
                                      -   Click edit button                                                                                                              | -   The edit dialog should open                                                                        
                                                                                                                                                                          -   Make sure all fields are as you saved them                                                          |        |                                                                          |
| Test button functionality          | Check all the "new provider" tests for the test button                                                                            | You should get exactly the same results as in the "new provider" scenario                              |        | Exit the dialog in the end, making sure the URL is still valid           |
| Import networks dialog             | -   Select the provider in the main tab                                                                                           
                                      -   Switch to the "networks" sub tab                                                                                               
                                      -   Click on "Import" button                                                                                                       | -   The import networks dialog should open                                                             
                                                                                                                                                                          -   The provider should be selected and greyed out                                                      
                                                                                                                                                                          -   There should be a list of networks from the provider                                                
                                                                                                                                                                          -   The two arrow buttons should be disabled.                                                           |        |                                                                          |
| Choosing networks to be imported   | -   Select several networks in the top table.                                                                                     
                                      -   Click the "arrow down" button.                                                                                                 | -   Upon selection, the "arrow down" button should be enabled.                                         
                                                                                                                                                                          -   Upon clicking, the selected networks should be moved from the top table to the bottom one.          
                                                                                                                                                                          -   Selection in both tables should be cleared, and both buttons disabled.                              |        |                                                                          |
| Cancelling network import          | -   Select several networks in the bottom table.                                                                                  
                                      -   Click the "arrow up" button.                                                                                                   | -   Upon selection, the "arrow up" button should be enabled.                                           
                                                                                                                                                                          -   Upon clicking, the selected networks should be moved from the bottom table back to the top one.     
                                                                                                                                                                          -   Selection in both tables should be cleared, and both buttons disabled.                              |        |                                                                          |
| Importing a network                | -   Select a network from the provider and click the "arrow down" button                                                          
                                      -   Select a DC                                                                                                                    
                                      -   Click OK                                                                                                                       | -   The network should be imported as a VM network to the selected DC                                  
                                                                                                                                                                              -   The name should be as you entered                                                               
                                                                                                                                                                          -   The network should be automatically attached to all the clusters in the DC                          
                                                                                                                                                                              -   The attachment should be as a non-required, without any of the roles (display, migration)       |        |                                                                          |
| Import networks from Networks tab  | -   Head to the "System" node in the system tree.                                                                                 
                                      -   Click on the "Networks" main tab.                                                                                              
                                      -   Click the "Import" button.                                                                                                     | -   The same dialog should open as before, only now a provider can be freely selected in the list box. 
                                                                                                                                                                          -   Repeat earlier import tests, and make sure the results are the same.                                |        |                                                                          |
| Add new network on provider dialog | -   In the left tree, select the System node                                                                                      
                                      -   Switch to networks main tab                                                                                                    
                                      -   Click "Add"                                                                                                                    | -   The standard "Add network" dialog should open                                                      
                                                                                                                                                                          -   There should be a section for "external provider" with your provider in it                          |        |                                                                          |
| Selecting the provider             | Select your provider                                                                                                              | -   Once provider is selected, the MTU & VM network should be greyed out                               
                                                                                                                                                                              -   MTU should be unset                                                                             
                                                                                                                                                                              -   VM network should be set                                                                        |        |                                                                          |
| Adding the network                 | -   Fill the network name                                                                                                         
                                      -   Fill the VLAN ID 500                                                                                                           
                                      -   Fill the label red                                                                                                             
                                      -   Click OK                                                                                                                       | -   The network should be created in oVirt                                                             
                                                                                                                                                                          -   You should be able to see the network on neutron via the REST API                                   
                                                                                                                                                                          -   You should be able to see the network in the provider's "Import" dialog                             |        |                                                                          |
| Adding a host with the provider    | -   Go to the Hosts main tab                                                                                                      
                                      -   Click on "add" button                                                                                                          
                                      -   Fill the host details                                                                                                          
                                      -   Go to the "Network Provider" left tab                                                                                          
                                      -   Select your provider                                                                                                           
                                      -   Edit the interface mappings field to the one matching your host                                                                
                                      -   Click OK                                                                                                                       | -   The host installation should begin                                                                 
                                                                                                                                                                          -   The linux bridge agent should be installed & running                                                
                                                                                                                                                                          -   The openstacknet VDSM hook should be installed                                                      |        |                                                                          |
| Adding a vNIC                      | -   Add a VM                                                                                                                      
                                      -   Add a vNIC to the VM on the network you created                                                                                | -   The vNIC should be on the external network                                                         
                                                                                                                                                                          -   See that "port mirroring" (in advanced parameters) is disabled.                                     |        |                                                                          |
| Running the VM                     | Run the VM                                                                                                                        | -   The VM Should start correctly on your host                                                         
                                                                                                                                                                          -   The port representing the vNIC should be visible on the Neutron REST API                            
                                                                                                                                                                          -   SSH to the host and check that:                                                                     
                                                                                                                                                                              -   A new bridge brq\*\*\* was created                                                              
                                                                                                                                                                              -   The new bridge has an interface tap\*\*\*                                                       
                                                                                                                                                                              -   Optionally, check the XML in the VDSM logs to see the device that was created for the vNIC      |        |                                                                          |
| vNIC properties on running VM      | Pick the vNIC you added in the VM/interfaces subtab, and edit it.                                                                 | -   The network list box should be disabled.                                                           
                                                                                                                                                                          -   The "hot plug" radio button should be disabled.                                                     |        |                                                                          |
| Stopping the VM                    | Stop (forcefully) the VM                                                                                                          | -   The VM should be stopped                                                                           
                                                                                                                                                                          -   The port representing the vNIC shouldn't be visible on the Neutron REST API anymore                 
                                                                                                                                                                          -   SSH to the host and check that:                                                                     
                                                                                                                                                                              -   The brq\*\*\* bridge still exists                                                               
                                                                                                                                                                              -   The tap\*\*\* device is no longer on the bridge                                                 |        |                                                                          |
| Migrating the VM (advanced)        | Make sure the VM migrates correctly to another host that has the agent                                                            | The VM should migrate and the bridge and tap device should be on the other host                        |        |                                                                          |

### Documentation / External references

*   General purpose wiki: [Network_Provider](/develop/release-management/features/network/detailed-osn-integration.html)



