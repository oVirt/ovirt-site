---
title: External Network Providers
category: feature
authors: mmirecki
feature_name: External Network Providers
feature_modules: engine,vdsm
feature_status: In Development
---

# External Network Providers


## Summary

Currently it is possible to integrate oVirt with Openstack Neutron (using  the
"Openstack Neutron Integration" feature). The purpose of this feature is to
simplify this and to make it easier to add support for networks supplied by
external providers. The providers will be able to provide networks using a
simplified Neutron-like API.


### Owner

*   Feature Owner: Marcin Mirecki: mmirecki (mmirecki)
*   Email: <mmirecki@redhat.com>

### Benefit to oVirt

oVirt VMs will be able to use networks definded by external providers.
oVirt will provide an API for the external providers (vendors of Software Defined
Networking products) allowing them to easily integrate with oVirt.


## Detailed Description

Many organizations use centralized network management systems to handle all
their networking, and would like them to manage the network topology of
their oVirt environments. 
Currently the only option of using external networks in oVirt is to use the
OpenStack Neutron integration, which allows the import of OpenStack Neutron
networks and the provisioning of VM's connected to these networks. 
This feature is however very specific to OpenStack Neutron and tied to its Linux bridge and OVS plugins.. 
We would like to extend this functionality to other external network providers,
by making it simpler, more general and less dependant on OpenStack Neutron features. 
The result should be an API over which oVirt can communicate with an external
network management systems, and use the networks defined in them in provisioned VMs.

For information about OpenStack Neutron integration please refer to:
[OSN Integration](/develop/release-management/features/network/osn-integration.html)
[Detailed OSN Integration](/develop/release-management/features/network/detailed-osn-integration.html)

### Differences from OpenStack Neutron Integration

*   hiding of UI features related to OpenStack Neutron, such as tenants and OpenStack Neutron driver details
![](/images/wiki/external_network_provider_import_dialog_changes.png)

*   simplified REST API. Base on the OpenStack Neutron API, but simplified to contain
only a subset of its schema which is relevant to the external network providers.
This will require a rework of the UI and REST API layer.

*   read-only mode for external network

*   (optionally) read-only mode for subnets

*   VIF driver - the implementation of the VIF driver is now completely the responsibility 
of the external network provider

*   No special handling of OpenStack Neutron agent. - since the VIF driver implementation is provider dependent,
the OpenStack Neutron agent is not a part of the solution anymore (unless the provider
decides otherwise)

*   VIF driver reference implementation - a sample VIF driver showing a simple implementation is provided


### Main functional parts of the system
The API for external network providers consists of 3 main parts:

1. External network provider administration. 
  This allows to perform admistrative tasks:
  * connecting to a new network provider (External Providers -> Add)
  * importing networks from an external provider (External Providers -> Networks Subtab -> Import)
  * removing a network (Networks -> Remove)
  * adding a new subnet pool (Networks -> Subnets tab -> New)
  * removing a subnet pool (Networks -> Subnets tab -> Remove)

2. Communication with an external provider at VM provisioning time.
This is reponsible for exchanging information with the external provider when a new VM NIC is 
created/changed/removed and is connected/disconnected to/from and external networks.

3. VIF Driver
The virtual interface driver is a driver provided by the external provider which implements
the connecting of VM NICs to external networks.

### Data structure

The data structure of an external network provider:

```json
{
    provider:{
        name: "<network name>"
        url:
        networks: [
            {
                "status": "ACTIVE",
                "name": "public",
                "id": "<id of network in external provider>",
                "subnets": [
                    {
                        "name": "<subnet name>",
                        "enable_dhcp": true,
                        "network_id": "59b48a4c-893c-47d2-9df3-84102329bbb9",
                        "dns_nameservers": [],
                        "gateway_ip": "10.0.0.1",
                        "ipv6_ra_mode": null,
                        "allocation_pools": [
                            {
                                "start": "10.0.0.2",
                                "end": "10.0.0.254"
                            }
                        ],
                        "host_routes": [],
                        "ip_version": 4,
                        "ipv6_address_mode": null,
                        "cidr": "10.0.0.0/24",
                        "id": "6ed90628-5d9c-4eae-8665-0b2420e683d4",
                    },
                    ...
		],
                ports: [
                    {
                        "status": "DOWN",
                        "name": "nic5",
                        "device_owner": "oVirt",
                        "id": "49ccb785-eadb-469d-8c33-e7bc87d37e4e",
                        "network_id": "bf864bf3-81d8-438d-bf68-4b0c357309b3",
                        "device_id": "5cc10431-0b25-41bd-941c-3a1aed8edd87",
                        "mac_address": "00:1a:4a:16:01:59"
                        ...
                        <more to be added if required>
                    },
                    ...
                ]
            },
            ...
        ]
}
```

## User work-flows

The user flows in the UI will mostly match the flows of "OpenStack Networking"

### External network provider administration

#### Adding an external network provider

The external provider will be added from "External Providers".
The UI Panel for adding a new external network provider will look as follows:
![](/images/wiki/external_network_provider_add.png)
This will add the provider to the list of external providers.

###### Read only option
When the read only option is chosen, all the configuration items related to this provider will be read-only.
This includes:

*   no subnetworks can be added or removed

*   when an external network is deleted, the option to remove it from a provider will be disabled.

Creating and deleting of ports must be allowed as it is required to create and distroy VM NICs.

#### Importing networks from external provider into oVirt (UI)
This opens a dialog where networks from the external provider can be imported.
Each external network is identified by an "id" given by the external provider.

Same as OpenStack Neutron Integration

External network provider interactions:

* get all network from the external providers (GET networks)

#### Delete external network

An external network is deleted (Networks -> Remove).
Same as OpenStack Neutron Integration

External network provider interactions:
When the "Remove network(s) from the external provider(s) as well." ceckbox is checked:

* delete network (DELETE networks)

#### Subnets management (UI)
Same as OpenStack Neutron Integration

The oVirt "Networks" tab has a "Subnets" subtab (only available for external
networks), which can be used to list/add/remove the subnets of an external network.

External network provider interactions when adding a subnet (Networks -> Subnets tab -> New):

* Get network (GET networks/<id>)
* Add subnet (POST subnets)

External network provider interactions when removing a subnet (Networks -> Subnets tab -> Remove):
* Add subnet (DELETE subnets/<id>)

Opening the subnets subtab causes a request for the list of subnets
* Get subnets (GET subnets)

#### Setup networks dialog (UI) - optional

External network providers may depend on prior host-level connectivity. For example,
OpenStack Neutron needs to be configured to use a specific bond (or NIC) for its VM networks. The network partner may ship a network_setup vdsm hook to integrate this configuration into the setup network dialog. For example, a custom property named "underlay" may be added to a network, which is attached to a bond0. When applied to the host, the hook script would do the necessary configuration to Neutron plugin so the "underlay" network's bond is used.


### VM NIC lifecycle

The most important function of this feature is to handle the lifecycle of
VM NICs connected to a network defined outside of oVirt.


#### VM NIC provisioning

When a new nic is added to a VM the following actions are being executed:

Port allocation:

* the engine checks if the port for the VM NIC exists (GET ports)
* if no port exists, the engine will create a new port (POST ports)
* if the port already exists, the engine will update it with information
about new allocation (POST ports)
* in both cases the new/updated port is identified by a <PORT ID> returned
by the external network provider
* the engine will send a nic plug request to VDSM, passing the <PORT ID>
as one of the parameters. The <PORT ID> is passed to the VIF driver as  a "vnic_id"
parameter.
* on VDSM, the VIF Driver, invoked using the VDSM before_nic_hotplug hook,
will connect the VM NIC to the network provided by the external provider

![](/images/wiki/external_network_provider_schema1.png)


Additional parameters used to identify the external network provider and the specific
port which is to be connected are passed to the VIF driver when provisioning a nic.

* vnic_id - the external id of the port which is to be connected
* provider_type - type of provider, in case of external network providers this will always be "EXTERNAL_NETWORK"

Under consideration:

* custom properties defined when an external network provider is added
* a property used to identify the VIF driver used to handle the NIC provisioning. This would be helpful
in case of automatic deployment of VIF drivers on new hosts.

#### VM NIC unplug

When the nic is unplugged from the VM, the following actions are being executed:

* on VDSM, the VIF Driver, invoked using the VDSM before_nic_hotunplug hook,
will unplug the VM NIC from the network provided by the external provider.
The nic is identified by the same <PORT ID> a during nic plug

#### VM NIC delete

When a nic is already unplugged, it can be deleted from a VM. This will trigger the following actions:

* the engine will try to locate the port on the external provider (GET ports)
* the engine will delete the port from the external provider (DELTE ports)

#### Migrate a VM to another host

When a VM is migrated to another host the following actions are executed:

* the VIF driver, invoked by the VDSM before_migration_source disconnects the
NIC from the external network on the source VDSM
* the VIF driver, invoked by the VDSM before_migration_destination connects
the NIC ti\o the external network on the destination VDSM

#### VM NIC provisioning synchronization issues

Care must be taken for the VIF driver to leave the networking operations in a finished state before exiting. 
For example should a VIF driver just initiate connecting a VM NIC during VM
startup and exit, the connecting operation could still not be finished when
the VM starts up and leave it booting without a network connection.

A reference to the problem in OpenStack Neutron:
https://blueprints.launchpad.net/neutron/+spec/nova-event-callback 

## External networks REST API

The communication between the engine and the external network provider is
done using a REST API based on this of OpenStack neutron. Only a subset of
the Neutron API is used.

The REST API uses the following operations:

Required tokens:
headers={Content-Type=[application/json], x-openstack-request-id=[<authentication token>]}

Authentication (optional):

* authenticate: POST: http://host:35357/v2.0/tokens

Request:
```json
{"auth": {"passwordCredentials": {"username": "<user>", "password": "<password>"}}}
Response: {
"access":{
    "token":{
        "id": "<token>"
    }
}}
```


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

The VIF driver will be notified about any life-cycle events relevant to external
networks by means of the VDSM "hooks".
VDSM Hooks are a means to insert arbitrary commands and scripts at certain point
in a VM's lifecycle as well as in VDSM daemon's lifecycle.

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

* provider information about the host network configuration related to the external network.
Depending on the implementation, the provider might want report the external network being
attached to any of the host NICS, report the external network being attached to a virtual host
NIC, hide some host NICs used by the external network implementation, or report any other implemented configuration.

#### before_network_setup/after_network_setup
Called before and after the network setup operation on the host.
Network provider reponsibilities:

* if needed, the network provider might prevent network setup actions which would interfere with the external networks on the host.


## External provider reference implementation

A reference implementation of an external provider is prepared to show how.
The implementation show in the reference implementation is very simple (naive),
it's purpose is to show where rather than how different parts of the
functionality should be implemented.

The reference implementation consists of two parts:

* the REST API - implementing the external provider REST API

* VIF driver - implementing the driver which connects VM NICs on the hosts



## Features under discussion

### Provider custom properties

Custom properties for an external network provider will be added. The user will be able to add the custom properties when adding the provider. The changed UI will should look like this (best guess - this might still change):

![](/images/wiki/external_network_provider_custom_properties.png)

These properties will be passed to the VIF driver upon pluging of a nic, the same way the "vnic_id" property
is passed.
These properties might also be passed to the VIF driver when unplugging a nic (to be decided).

As an example, this would allow to add custom properties to native networks vNIC profiles. vNIC profiles are not available for external network; this subfeature would allow another means to pass provider-specific customization to starting up a vNIC.

### Automatic VIF driver deployment

In the later stages of the external network provider feature, support for automated deployment
of VIF drivers during host deploy will be added. This will be similar to the current OpenStack Neutron 
provider deployment.
In future versions VIF driver deployment should be integrated into ovirt-host-deploy.

### Multiple VIF drivers on a host

It should be possible to add more than one VIF driver automatically.

![](/images/wiki/external_network_provider_automated_deploy.png)

The id of the provider would then be passed each time a nic is provisioned to let the appropriate VIF driver
handle the connecting action.

#### Simple use case for having more than one VIF driver

A user might want to provision vm's having multiple VPN connections to different sites. Each such connection
could require a different external network provider. In such a case a host should handle multiple 
VIF drivers to establish each of these connections.


### VIF driver API

In order to be automatically provisioned, the VIF driver will have to implement a "VIF driver API".
This "VIF driver API" will be called by the hooks in reponse to NIC lifecycle events.

The VIF driver will not have to implement this API, instead it could use the hooks directly. This however
would disable the automatic deployment of the VIF driver and the paralel use of more than one external
network provider on the host (unless implemented by the user).

* plug_device(domxml, properties)
* unplug_device(domxml, properties)
* migration_source(domxml, properties)
* migration_destination(domxml, properties)
* get_caps(caps, properties)
* get_stats(stats, properties)

## Dependencies / Related Features

This feature is strongly related to the "Openstack Neutron provider" feature.
It is providing a similar functionality, but not limited to only Openstack.
The implementation is based mostly on the functionality/code of the "Openstack Neutron provider" feature.

### Documentation / External references

### Open Issues



