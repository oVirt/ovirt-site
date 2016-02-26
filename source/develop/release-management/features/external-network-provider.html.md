---
title: External Network Providers
category: feature
authors: mmirecki
wiki_category: Feature
wiki_title: Features/External Network Providers
wiki_revision_count: 1
wiki_last_updated: 2016-01-25
feature_name: External Network Providers
feature_modules: engine,vdsm
feature_status: In Development
---

# External Network Providers


## Summary

The purpose of this feature is to enable support for networks not defined by oVirt, but supplied by an external provider.


### Owner

*   Feature Owner: Marcin Mirecki: [ mmirecki](User:mmirecki)

<!-- -->

*   Email: <mmirecki@redhat.com>

### Detailed Description

Currently the networks used in oVirt deployments are managed internally by oVirt. Many organizations however, use centralized network management systems to handle all their networking, and would like them to cover their oVirt managed environments. The puprose of this feature is to provide an API over which oVirt can communicate with external network management systems, and use the networks defined in them in provisioned VMs.

#### Main functional parts of the system
The API for external network providers consists of 3 main parts:
##### External network provider administration
This allows to perform admistrative tasks like:
* connecting to a new network provider
* importing networks from an external provider
* basic administration tasks, like adding a new subnet pool

##### Communication with external provider at VM provisioning time.
This is reponsible for exchanging information with the external provider when a new VM NIC is created/changed/removed and is connected/disconnected to/from and external networks.
oVirt engine will request

##### VIF Driver
The virtual interface driver is a driver provided by the external provider which implements the connecting of VM NICs to external networks.



### Benefit to oVirt

oVirt will be able to use networks definded by external providers.
oVirt will provide an API for the external providers allowing to easily integrate with oVirt.

## User work-flows

The user flows in the UI will mostly match the flows of "OpenStack Networking"

### External network provider administration

#### Adding an external network provider

The external provider will be added from "External Providers".
The UI Panel for adding a new external network provider will look as follows:
![](external_network_provider_add.png "fig:external_network_provider_add.png")

###### Read only option
When the read only option is chosen, all the configuration items related to this provider will be read-only.
This includes:

*   no subnetworks can be added or removed

*   when an external network is deleted, the option to remove it from a provider will be disabled.

Creating and deleting of ports must be allowed as it is required to create and distroy VM NICs.

#### Importing networks from external provider into oVirt (UI)
Same as "OpenStack Networking"

#### Importing networks from external provider into oVirt (UI)
Same as "OpenStack Networking"

An import network dialog is show and used to import external provider networks.

#### Subnets management (UI)
Same as "OpenStack Networking"

The oVirt "Networks" tab has a "Subnets" subtab (only available for external networks), which can be used to list/add/remove the subnets of an external network.

#### Setup networks dialog (UI) - optional
The setup network dialog could be used to modify external networks. Some of the possible operations might include:

* binding external network to a host NIC

* binding external network to a bond, and modifying the bond properties

* modyfing external network properties

This option can however be quite problematic, as it would limit the allowed implementations of how an external network is provided by an external party. Modifications of networks set up by the external provider could also lead to unexpected problems.

### VM NIC provisioning

The most important function of this feature is to enable the provisioning of a VM NIC connected to a network defined outside of oVirt.
This will be done in the following steps:

* the user will import the external network into oVirt

* the user will add a NIC to a VM

* the engine will issue a REST request to the external network provider, requesting to create a new NIC. The external network provider will create the NIC (port in Openstack Neutron nomenclature) and return its <PORT ID> to the engine. Note that the detail of how the external provider implements this are the resposibility of the party implementing it.

* the engine will send a request to VDSM to create a NIC, passing the <PORT ID> as one of the parameters.

* on VDSM, the VIF Driver, invoked using VDSM hooks, will connect the VM NIC to the network provided by the external provider

![](external_network_provider_schema1.jpg "fig:external_network_provider_schema1.jpg")

## External networks REST API

The communication between the engine and the external network provider is done using a REST API based on this of OpenStack neutron. Only a subset of the Neutron API is used.

The REST API uses the following operations:

Authentication:

* authenticate: POST: http://host:35357/v2.0/tokens

* tets connection: GET: http://host:9696/v2.0/

Networks:

* network details: GET: http://host:9696/v2.0/network/<network id>

* list networks: GET: http://host:9696/v2.0/networks

* delete a network: DELETE: http://host:9696/v2.0/networks

Ports:

* list ports: GET: http://host::9696/v2.0/ports   (Check if port exists)

* port details:  GET: http://host::9696/v2.0/ports/<port id>

* add a port: POST:  http://host::9696/v2.0/ports/<port id>

* delete port: DELETE:  http://host::9696/v2.0/ports/<port id>

Subnets:

* list subnets: GET: http://host:9696/v2.0/subnets

* adding a subnet: POST: http://host:9696/v2.0/subnets

* deleting a subnet: DELETE: http://host:9696/v2.0/network/<network id>

## VIF driver (prepared by the external network provider)

The "virtual interface driver" will be a set of scripts provided by the external network provider which will facilitate the network operations related to an external network on a host (VDSM).
The operations include:

* setting up the external network on the host

* creating and attaching a VM NIC to an external network

* deleteing and detaching a VM NIC from an external network

* hotplugging a NIC

* unplugging a NIC

* VM migration

* reporting the external network and it's relations to any host NIC to the engine

* reporting VM NIC statistics to the engine

The VIF driver will be notified about any life-cycle events relevant to external networks by means of the VDSM "hooks".
VDSM Hooks are a means to insert arbitrary commands and scripts at certain point in a VM's lifecycle as well as in VDSM daemon's lifecycle.

The following hooks are relevant to the external networks:

#### before_device_create/after_device_create
Called before/after a device (in this case a NIC) is created.
Network provider reponsibilities:

* make sure the network exists on this host

* connect the VM NIC to the specified external network

#### before_nic_hotplug/after_nic_hotplug
Called before/after a nic is hot plugged.
Network provider reponsibilities:

* make sure the network exists on this host

* connect the VM NIC to the specified external network

#### before_nic_hotunplug
Called before a nic is hot unplugged.
Network provider reponsibilities:

* unplug the VM NIC from the external network (if required)

#### before_vm_migration_source
Called on the source host before a VM is migrated.
Network provider reponsibilities:

* unplug the VM NIC from the external network (if required)

#### before_vm_migration_destination
Called on the destination host before a VM is migrated.
Network provider reponsibilities:

* make sure the network exists on this host

* connect the VM NIC to the specified external network

#### after_get_stats
Called after generating the network statistics which are to be send to the engine
Network provider reponsibilities:

* provide the statistics for the VM NIC attached to the external network

#### after_get_caps
Called after generating the host capabilites (host configuration) which are to be send to the engine.
Network provider reponsibilities:

* provider information about the host network configuration related to the external network. Depending on the implementation, the provider might want report the external network being attached to any of the host NICS, report the external network being attached to a virtual host NIC, hide some host NICs used by the external network implementation, or report any other implemented configuration.

#### before_network_setup/after_network_setup
Called before and after the network setup operation on the host.
Network provider reponsibilities:

* if needed, the network provider might prevent network setup actions which would interfere with the external networks on the host.

### Dependencies / Related Features

This feature is strongly related to the "Openstack Neutron provider" feature. It is providing a similar functionality, but not limited to only Openstack.
The implementation is based mostly on the functionality/code of the "Openstack Neutron provider" feature.

### Documentation / External references

### Open Issues



<Category:Feature> <Category:Template>
