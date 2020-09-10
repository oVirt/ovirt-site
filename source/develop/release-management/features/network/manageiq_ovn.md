---
title: Integrating OVN with ManageIQ
category: feature
authors: Alona Kaplan
feature_name: Integrating OVN to ManageIQ
feature_modules: manageiq_providers_ovirt - infra_manager, network_manager, manageiq-ui-classic - network related controllers
feature_status: In Development
---

# Integrating OVN to ManageIQ

## Summary
Let the ManageIQ operator discover OVN as the network provider of oVirt. Adding the ability to get, add, update and remove networks and subnets and get ports directly from `ovirt-provider-ovn`.

## Owner

*   Name: [Alona Kaplan](https://github.com/AlonaKaplan)

*   Email: <alkaplan@redhat.com>

## Terminology
* OVN: Open Virtual Network. OVN is an OVS (Open vSwitch) extension that brings Software Defined Networking to OVS.
* oVirt OVN provider: is a proxy that interacts with OVN. The provider has 'Neutron like' API (only implements a subset of the 'Neutron' api).
* ManageIQ: is a cloud management platform that allows centralized management of various virtualization, private cloud, public cloud, containers, middleware and software defined networking technologies.

## Detailed Description
ManageIQ has an infra provider for oVirt. The feature adds automatic discovery of oVirt's network provider (OVN provider) once the infra provider is added/refreshed.
ManageIQ users will be able to perform CRUD actions on networks and subnets and getting ports directly from/on the OVN provider without passing through oVirt.
ManageIQ already supports automatic discovery of the OpenStack network provider (Neutron) and has all the functionality to communicate with it (CRUD actions for networks and subnets, showing ports and more).
Since oVirt's OVN provider has 'Neutron like' API, the purpose of the feature is to reuse the already existing ManageIQ code (fog-openstack, ManageIQ::Providers::Openstack::NetworkManager) to communicate with the oVirt's OVN provider.
Since there are some gaps between the 'Neutron like' API oVirt's OVN provider has and the desired API ManageIQ expects to get, some adjustments to the oVirt's OVN provider are done during the development process.

## Requirements
* Discovery of oVirt network provider on the infra provider add/refresh.
* CRUD actions on the OVN provider entities (networks, subnets).
* Displaying ports.
* Manual refresh of oVirt's network provider.
* Removing the network provider from ManageIQ in case it is removed from oVirt.

## Limitations
* ManageIQ supports only one network provider for one infra provider (such as oVirt infra provider). 
* In oVirt there is no way to distinguish between Openstack network provider and OVN provider. Therefore, ManageIQ has no way to find out what provider is the OVN one.
In case oVirt has more than one network provider, the first one (alphabetic order) will be used.

## Benefit to oVirt
* The ui and the communication code with the network provider is already written in ManageIQ (for Openstack-Neutron). Adding it from scratch to oVirt will take much more time than reusing the code of ManageIQ,

## Benefit to ManageIQ
* Adding more power to the oVirt's infra manager.
* oVirt users that want to use OVN provider (more than the basic operations oVirt supports) will have to use ManageIQ.

## Gaps with the OpenStack network provider

### Gaps
* Communication and authentication
  * The OpenStack infra manager added to ManageIQ has the Keystone URL. OpenStack infra manager discovers the other OpenStack services via Keystone. The Keystone returns a service catalog with all the URLs and other information about the services. This information is used to communicate with the other services.
  * The network manager is an ExtManagementSystem.
  * OpenStack's network manager delegates all its communication and authentication methods to the parent manager (infra manager => Keystone).
  * The oVirt's infra manager is communicating with oVirt but the network manager should communicate directly with OVN provider. Therefore, the delegation the OpenStack's network manager has is problematic for oVirt.
* Service Catalog
  * In oVirt when adding a new network provider, the user supplies two values - `provider_url` and `authentication_url` (the URL of 'Keystone').
First an authentication is done against 'Keystone' to get the `token` and then oVirt communicates with the provider using the `provider_url` (supplying the `token` for authentication).
  * In ManageIQ the 'services' URLs are not supplied by the user but determined from the 'Keystone'. When 'Keystone' is asked for the `token` it replies with the `token` and a `service_catalog` with all the services information (URLs, credentials, etc).
* Tenants
  * Neutron supports tenants.
  * oVirt's OVN provider doesn't.
  * ManageIQ expects the Neutron network provider to have tenants.
* oVirt's OVN provider has 'v2' Neutron like API. However, 'v2' API is already considered as legacy.


### Solving the gaps
* Communication and authentication
 * Creating network manager class that doesn't inherit from the OpenStack one.
 * oVirt's network manager will take responsibility for its communication and authentication reusing the communication and authentication code of the OpenStack infra manager.
 * The collector, parser, refresher and entities classes (cloud_network, cloud_subnet, network_port etc) inherit from the OpenStack ones.
 * Upon each update of the oVirt's infra manager
   * all the network providers will be retrieved from oVirt.
   * only the first network provider will be processed.
   * if a network manager doesn't exist it will be created.
   * the network's provider `authentication_url` will be parsed and the network manager will be updated accordingly. The fields that will be updated are: `hostname`, `port`, `api_version` and `security_protocol` ('ssl' for 'https' and 'non-ssl' for 'http').
* Service Catalog
  * oVirt's OVN provider was updated to send also `service_catalog` when it is asked for a `token`. Only the relevant services will be in the catalog - 'identity' (Keystone), 'network' and 'compute' (see open questions).
  * oVirt provider OVN will report a dummy tenant that will be stored in the 'cloud_tenant' table of ManageIQ.
    * When creating the network manager entities, the user will have to choose this tenant.

## Open Questions
* `ManageIQ::Providers::Openstack::legacy:OpenstackHandle` is responsible to communicate with the openstack-fog. It is placed in a 'legacy' directory. Why? Is it going to be replaced soon?
* Why does the `openstack_handle/handle.accessible_tenants` method first tries to connect to the 'compute' service?
  * Current workaround - the oVirt OVN provider reports the 'compute' service in the service catalog with the same URL and credentials as the network service.

## User Experience
### Network Manager menu
![Network Manager menu](/images/wiki/networks_menu.png)

### Network Managers list
![Network Managers list](/images/wiki/network_managers_list.png)

### Specific Network Manager Subnets list
![Specific Network Manager Subnets list](/images/wiki/specific_network_manager_subnets_list.png)

### Network Manager - general
![Network Manager - general](/images/wiki/network_manager_general.png)

### Networks list
![Networks list](/images/wiki/cloud_networks_list.png)

### Add Network
![Add Network](/images/wiki/add_cloud_network.png)

### Subnets list
![Subnets list](/images/wiki/cloud_subnets_list.png)

### Add Subnet
![Add Subnet](/images/wiki/add_cloud_subnet.png)

## Dependencies
* [OpenStack Networking API v2.0] (https://developer.openstack.org/api-ref/networking/v2/index.html)
* [ovirt-provider-ovn] (https://gerrit.ovirt.org/#/q/project:ovirt-provider-ovn)

## Documentation & External references
* [Bug 1449157 - (RHEV provider)(vm provision) - Specifying vnic profile on virtual nic instead of network](https://bugzilla.redhat.com/1449157)
* [oVirt Software Defined Networking, The OVN Network Provider](https://blogs.ovirt.org/2016/11/ovirt-software-defined-networking-the-ovn-network-provider/)

## Follow-Up Features
* Show/Add/Update of
  * Network Routers
  * Security Groups
  * Floating ips
  * Load Balancers
* Automatic refresh of oVirt's network provider.
* When an operator adds an OVN network via ManageIQ, ManageIQ would issue an auto-import of the new network into oVirt.
* Add network provider to oVirt's infra provider manually via ManageIQ.
* Currenty the OVN provider authorizes users through oVirt. Once authentication plugin will be added to the OVN provider, ManageIQ will have to support it.

