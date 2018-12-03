---
title: IPv6 subnets on ovirt-provider-ovn
category: feature
authors: mdbarroso
feature_name: Support IPv6 subnets on ovirt-provider-ovn
feature_modules: ovirt-provider-ovn
feature_status: In Development
---

# IPv6 subnets on ovirt-provider-ovn

## Summary

This feature provides support for IPv6 addresses on guest virtual machines
whose networking is provided by OVN.

Address auto-configuration is - despite being desirable - not a must at this
stage, and its implementation will take place at a later stage.

Related patches can be found on [gerrit topic:provider_ipv6_subnets](https://gerrit.ovirt.org/#/q/topic:provider_ipv6_subnets).

### Owner
* Feature Owner: [Miguel Duarte Barroso](https://github.com/maiqueb) (mbarroso in #ovirt)
* Email: <mdbarroso@redhat.com>

### Terminology

* Networking API: [OpenStack RESTful Networking API](https://developer.openstack.org/api-ref/network/v2/)
* OVN: Open Virtual Network. OVN is an OVS (Open vSwitch) extension that
brings Software Defined Networking to OVS.
* oVirt OVN provider: a proxy that implements a subset of the Networking API
and interacts with OVN.
* Subnet: a layer 3 concept, created on top of a network. As per openstack's documentation it is a 'block of IP addresses and associated configuration state. Subnets are used to allocate IP addresses when new ports are created on a network.'
* Network: an isolated Layer 2 networking segment.
* DHCP: dynamic host configuration protocol. Client server protocol that assigns an IP address - along with other configuration parameters to the client.
* MTU: maximum transmission unit. The maximum frame size on an L2 network.
* MAC: medium access control. Unique identifier assigned to a network interface.
* RA: router advertisements.
* IPAM: IP Address Management.
* guests: Virtual Machines running on an hypervisor.

### Benefit to oVirt

IPv6 addresses are currently supported in oVirt, but the L3 capabilities on OVN
provided networks are severely limited, since it is missing IPAM and routing
capabilities.
This feature addresses those gaps, by providing IPv6 IPAM capabilities to oVirt
logical networks, provided by OVN.
With IPv6 IPAM in place, routing amongst different IPv6 subnets will be
possible, and achieved through an OVN logical router.

## Objectives

Provide IPv6 address support to guests (virtual machines) attached to OVN networks.
The following configurations, which are explained in the [IPAM types](#ipam-types) section will be available:

* static addresses
* stateful DHCPv6

## IPAM

### IPAM types

IPv6 provides the following IPAM options:

* slaac: neighbor discovery is provided through router advertisement messages - *RA*s. Both the IP address and the connection parameters (such as hop limit, MTU, etc) are configured from these router advertisement messages. Specified in [SLAAC rfc](https://tools.ietf.org/html/rfc4862).

* dhcpv6-stateless: IP addresses are assigned by OVN's IPv6 stack, based on the port's mac address and the advertised prefix - in the RA messages.The connection parameters (MTU, max hops, DNS, etc) are configured through the subnet's native DHCPv6 service.

* dhcpv6-stateful: Both the IP addresses and the connection parameters are assigned from the subnet's native DHCPv6 service.

Take into account that only the stateful DHCPv6 IPAM type is in this feature's scope.

### IPAM configuration requirements

* slaac: this IPAM configuration does not rely on OVN's subnet DHCP service, which means a DHCP_Options object is **not** required. The RA messages are sent by an OVN Logical_Router, thus one is required.

* dhcpv6-stateless: this IPAM configuration relies on OVN's subnet DHCP services to get its IP address, and on the Logical_Router's RA message's connection parameters to properly configure the connection. Thus, a DHCP_Options entry is required, as is a Logical_Router object.

* dhcpv6-stateful: this IPAM configuration relies exclusively on OVN's subnet DHCP services, and is very close to the IPv4 configuration counterpart - a DHCP_Options object is required, having both an IPv6 cidr, and ip_version set to IPv6.

### IPAM configuration

This section explains how to configure the supported IPAM options.

* dhcpv6-stateful
  - create an ovn DHCP_Options object, having an ipv6 cidr configured.
    It requires the user to specify the ethernet address for the DHCPserver
    to use in the *options:server_id* DHCP_Options attribute.
  - to enable IPAM for IPv6, the logical switch (ovn entity) where the ports are
    created has to include the **other_config: ipv6_prefix** key defined.
    The value should be the the IP prefix featured in the provisioned cidr
    parameter, ending in '::' - e.g. 8230:5678::, for instance.

### Alignment with networking API

The ovirt-provider-ovn provides an opinionated subset of OpenStack's networking API v2. In it's [subnet definition](https://developer.openstack.org/api-ref/network/v2/?expanded=create-subnet-detail#create-subnet), it can be seen that the API features two parameters to influence IPv6 related configurations: **ipv6_ra_mode**, and **ipv6_address_mode**. Both of these attributes accept the following values:

* slaac
* dhcpv6-stateful
* dhcpv6-stateless

Given the priorities stated in [Objectives](#objectives), the ovirt-provider-ovn should only accept the 'dhcpv6-stateful' configuration, and fail for the other 2 options. When not provided, this parameter will of course default to the only accepted value.

## Routing

Routing among IPv6 subnets is seemlessly provided by an OVN logical router
entity.

Since the scope of the feature is just to implement stateful DHCPv6, no router
changes are required.

If, in a given future, stateless address auto-configuration becomes a goal,
the logical router ports have to be configured, setting its
**ipv6_ra_configs:address_mode** to 'slaac'.

The above change would be implemented in the following way:
1. when a subnet is created, it's **ipv6_address_mode** parameter is stored in
the subnet's external ids
2. when that subnet is attached to a router, its **ipv6_ra_configs:address_mode**
should be set from the subnet's external ids address mode value.

## User flows

### Current state, assumptions, and limitations

The ovirt-provider-ovn is limited to having a **single** subnet per network.
This means that in order to have a VM connected to both ipv4 and ipv6 subnets,
it needs to connect to 2 different networks (through 2 different logical ports),
one with an IPv4, other with an IPv6 subnet defined on top.

### Configuring stateful DHCPv6 on the subnet

To configure the native dhcpv6 service of OVNs subnet, the user should
provision the following networking API entities, represented in yaml:

~~~~~
- name: create a network
  os_network:
    cloud: "{{ cloud_name }}"
    state: present
    name: netv6
  register: ipv6_network

- name: create an IPv6 subnet
  os_subnet:
    cloud: "{{ cloud_name }}"
    state: present
    network_name: "{{ ipv6_network.id }}"
    name: subnet1
    ip_version: 6
    cidr: "bef0:1234:a890:5678::/64"
    enable_dhcp: yes
    gateway_ip: bef0:1234:a890:5678::1
  register: ipv6_subnet

- name: create a logical switch port
  os_port:
    cloud: "{{ cloud_name }}"
    state: present
    name: lport1
    network: "{{ ipv6_network.id }}"
    fixed_ips:
      - subnet_id: "{{ ipv6_subnet.id }}"
~~~~~

## Testing

Two scenarios are recommended:
  - single IPv6 subnet
  - multiple IPv6 subnets connected by router

