---
title: IPv6 subnets on ovirt-provider-ovn
category: feature
authors: maiqueb
---

# IPv6 subnets on ovirt-provider-ovn

## Summary

This feature provides support for IPv6 addresses on guest virtual machines
whose networking is provided by OVN.

IPv6 addresses will be automatically assigned by either OVN's internal dhcp
service (dhcpv6) or automatically configured through Router Advertisement
messages - sent by OVN logical routers - depending on the subnet configuration.

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
* Subnet: a layer 3 concept, created on top of a network.
  As per openstack's documentation it is a 'block of IP addresses and associated configuration state. Subnets are used to allocate IP addresses when new ports are created on a network.'
* Network: an isolated Layer 2 networking segment.
* DHCP: dynamic host configuration protocol. Client server protocol that assigns an IP address - along with other configuration parameters to the client.
* MTU: maximum transmission unit. The maximum frame size on an L2 network.
* MAC: medium access control. Unique identifier assigned to a network interface.
* RA: router advertisements.
* IPAM: IP Address Management.
* guests: Virtual Machines running on an hypervisor.
* RAs: Router Advertisement messages.
* RSs: Router Solicitacion messages.
* EL: Enterprise Linux - CentOS or Red Hat Enterprise Linux.

### Benefit to oVirt

IPv6 addresses are currently supported in oVirt, but the L3 capabilities on OVN
provided networks are severely limited, since it is missing IPAM and routing
capabilities.
This feature addresses those gaps, by providing IPv6 IPAM capabilities to oVirt
logical networks, provided by OVN.
With IPv6 IPAM in place, routing amongst different IPv6 subnets will be
possible, and achieved through OVN logical routers.

## Objectives

Provide IPv6 address support to guests (virtual machines) attached to OVN networks.
The following configurations, which are explained in the [IPAM types](#ipam-types) section will be available:

* static addresses
* stateful DHCPv6
* stateless DHCPv6

### Why OVN logical routers are required

The ISC DHCP client - dhclient - has up to now relied on an hardcoded prefix
length of 64 bits. That was in line with [RFC 5375](https://tools.ietf.org/html/rfc5375#section-3) concept of Global Unique Addresses and Unique Local Addresses.

Unfortunately, the use of an hardcoded prefix length will lead to clients
believing they are on-link, when in fact they are not, as discussed in
[RFC 5942](https://tools.ietf.org/html/rfc5942). This would happen for any
network whose prefix length is not 64 bits.

[This](https://kb.isc.org/docs/aa-01141) ISC's article clearly states that a
properly functioning system should use a prefix length of 128, and get any
on-link information from the RA messages sent by routers.

Ubuntu [bug](https://bugs.launchpad.net/ubuntu/+source/isc-dhcp/+bug/1609898) tracks that very same issue, and that behavior is now found
in EL8 systems - e.g. dhclient default to a /128 network prefix, and relies on
RA messages to properly configure it.
Red Hat bugs [1635181](https://bugzilla.redhat.com/show_bug.cgi?id=1635181) and [1673951](https://bugzilla.redhat.com/show_bug.cgi?id=1673951) track this behavior.
Please note that those fixes will/could be released anytime soon.

Thus, RA message support is required to properly configure the guest IPv6
addresses, and bug [1685983](https://bugzilla.redhat.com/show_bug.cgi?id=1685983) was opened to track its support in ovirt-provider-ovn.

On top of that, RA messages also allow for the configuration of the network's
MTU and default route / gateway configuration.

**TL;DR**

RA messages are required to properly configure dynamic IPv6 addresses in newer
dhclient versions - e.g. the one supplied on el8 - since dhcpv6 does not supply
the network prefix to use, and dhclient no longer defaults to a 64 bit prefix
length.

Since the RA messages are sent by OVN logical routers, any guest VM with a
recent dhclient version, **requires** the subnet to which it connects to be
attached to a router.

## IPAM

### IPAM types

IPv6 provides the following IPAM options:

* slaac: neighbor discovery is provided through router advertisement messages - *RA*s.
  Both the IP address and the connection parameters (such as hop limit, MTU, etc) are configured from these router advertisement messages. Specified in [SLAAC rfc](https://tools.ietf.org/html/rfc4862).

* dhcpv6-stateless: IP addresses are assigned by OVN's IPv6 stack, based on the port's mac address and the advertised prefix - in the RA messages.
  The connection parameters (MTU, max hops, DNS, etc) are configured through the subnet's native DHCPv6 service.

* dhcpv6-stateful: Both the IP addresses and the connection parameters are assigned from the subnet's native DHCPv6 service.
  DHCPv6 protocol does not send the network prefix in the **Reply** messages, which means that this configuration will only work if the network's prefix length is 64.

### IPAM configuration requirements

* slaac: this IPAM configuration does not rely on OVN's subnet DHCP service, which means a DHCP_Options object is **not** required.
  The RA messages are sent by an OVN Logical_Router, thus one is required.

* dhcpv6-stateless: this IPAM configuration relies on OVN's subnet DHCP services to get its IP address, and on the Logical_Router's RA message's connection parameters to
  properly configure the connection. Thus, a DHCP_Options entry is required, as is a Logical_Router object.

* dhcpv6-stateful: this IPAM configuration relies exclusively on OVN's subnet DHCP services, and is very close to the IPv4 configuration counterpart - a DHCP_Options object
  is required, having both an IPv6 cidr, and ip_version set to IPv6.
  On newer versions of dhclient, a router is also required, since the dhcpv6 messages **do not** feature the network prefix length.

### Alignment with networking API

The ovirt-provider-ovn provides an opinionated subset of OpenStack's networking API v2.
In it's [subnet definition](https://developer.openstack.org/api-ref/network/v2/?expanded=create-subnet-detail#create-subnet), it can be seen that the API
features two parameters to influence IPv6 related configurations: **ipv6_ra_mode**, and **ipv6_address_mode**. Both of these attributes accept the following values:

* slaac
* dhcpv6-stateful
* dhcpv6-stateless

Given the priorities stated in [Objectives](#objectives), the ovirt-provider-ovn
will accept either the 'dhcpv6-stateful' or 'dhcpv6-stateless' configuration,
while *slaac* is not yet supported. Despite that, it is described in the
document - along the supported features - for better understanding of the
subject.

Of the two parameters, only the **ipv6_address_mode** option will be
implemented, since their behaviors overlap - e.g. *slaac* and *dhcpv6-stateless*
**require** RAs to configure their IP addresses, thus a single setting can be
used to configure the subnet.
This behavior is consistent with OpenStack's Neutron implementation, since it
just forces both options to be equal when both are provided.

When not provided, this parameter will **default to dhcpv6-stateful**, to
preserve backwards compatibility, and that setting will work seemlessly for the
default configurations of the EL7 and EL8 operating systems.

## Routing

Routing among IPv6 subnets is seemlessly provided by an OVN logical router
entity.

OVN logical routers are required whenever the 'slaac' or
'dhcpv6-stateless' options are configured on the subnet, since they send the RA
messages that dhcp clients require to configure their IP addresses.

They are also necessary when using the 'dhcpv6-stateful' option **if** the
dhcp client running on the guest connecting to the network to which the subnet
is attached assigns a /128 prefix - since the network prefix length must be
configured via RA messages.

Provisioning a router and configuring its interfaces should thus be performed,
since it also automatically enables the guest VMs routes to be configured: it
adds some complexity during the network / subnet setup stage, but eases the
configuration of all VMs attached to the networks whose subnets are connected
to a router.

Just creating the logical router is indeed not enough; all subnets that require
RA messages to be multicasted into the connected VMs **must be** connected to
at least one OVN logical router.

That will create OVN logical flows that are responsible for generating the
Router Advertisements messages the clients require to configure their IP
addresses.
These RA messages are generated as replies to the Router Solicitation messages.

Periodic RA messages are also required, to prevent the default route on the
guest VM from expiring; it has a default value of 65536 seconds.
Simply activating the periodic flag on the logical router ports is enough, since
its min/max defaults are well below that +-18 hour interval.

### Routing - implementation detail

The above change would be implemented in the following way:

1. when a subnet is created, it's **ipv6_address_mode** parameter is stored in the subnet's external ids
2. when that subnet is attached to a router, its **ipv6_ra_configs:address_mode** should be set from the subnet's external ids address mode value.

## Guest VM configuration

There are three different ways to configure the guests, enabling them to have
IPv6 addresses, each with different advantages / drawbacks.

### DHCPv6

DHCPv6 is one option to configure the guests and it requires one dhcp client to
be installed in the guest VM. One example of a dhcp client on linux is
**dhclient**.

In dhcpv6_stateful, it is used to assign an IPv6 address to the specified
interface, whereas in dhcpv6_stateless it is used to simply configure
connection parameters - such as DNS.

The default network configuration in EL8 guests is not possible using only
DHCPv6, since its default NetworkManager configuration relies on dhclient,
which, relies on RA messages to configure the network prefix length. On EL8
guests, the guest will have to **also** accept RA messages, as indicated in the
[next option](#linux-kernel-ra-configuration).

### Linux Kernel RA configuration

This option can be seen as a complement needed for el8 based VMs using dhclient,
*or* a full fledged alternative to NetworkManager - with the advantage that it
does not require any additional package to be installed in the guest VM.

It involves configuring directy the behavior in the linux kernel, through the
[interface config files](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt).

To follow it, the following files have to be created, and have a '1' in them:
- accept_ra
- autoconf
- accept_redirects
- accept_ra_pinfo

And have the **forwarding** flag is disabled - write a '0' into the *forwarding*
file

All these files are located under the following folder:
  - `/proc/sys/net/ipv6/conf/<YOUR_IF_NAME>/`

### NetworkManager

To use NetworkManager to configure the IPv6 address assignment, *nmcli* should
be used. The recommended way can be found below:

```bash
nm-cli con modify <connection_name> ipv6.method auto		# tied to IPV6_AUTOCONF, IPV6INIT
nm-cli con modify <connection_name> connection.autoconnect yes 	# tied to ONBOOT
```

In case debugging is required, make sure the following appears in the interface
config scripts:

```bash
cat "/etc/sysconfig/network-scripts/ifcfg-<YOUR_IF_NAME>"
ONBOOT=yes
IPV6INIT=yes
IPV6_AUTOCONF=yes
```

## User flows

### Current state, assumptions, and limitations

The ovirt-provider-ovn is limited to having a **single** subnet per network.
This means that in order to have a VM connected to both ipv4 and ipv6 subnets,
it needs to connect to 2 different networks (through 2 different logical ports),
one with an IPv4, other with an IPv6 subnet defined on top.

### Networking API entity provisioning

Below you can find the steps required to have dynamic IPv6 addresses on the
guest VMs, along with the available methods of provisioning it.

1. create a logical network
    - oVirt UI
    - oVirt REST API
    - manageIQ UI (*)
    - ovirt-provider-ovn REST API. (*) [REST example](#create-a-logical-network)
2. add a subnet on top
    - oVirt UI - *requires changes*
    - manageIQ UI
    - ovirt-provider-ovn REST API. [REST example](#create-a-subnet)
3. provision a router
    - manageIQ UI
    - ovirt-provider-ovn REST API. [REST example](#create-a-logical-router)
4. attach the subnet to the router
    - manageIQ UI
    - oVirt ovirt-provider-ovn REST API. [REST example](#configure-the-router)
5. create a VM having the vNIC profile of the network created in step #1
   **or** assign the vNIC profile of the network created in #1 to an existing
   VM
    - oVirt UI
    - oVirt REST API

(*) - when the logical network is created via provider's REST API, of through
manageIQ, it is necessary to import the logical network into oVirt engine.

#### EL7 Guest VM configuration

For dhcpv6-stateless the guest VM can be configured using *either* of the 3
configuration options defined in the [Guest config section](#guest-vm-configuration).

It is important to state that if and when the dhcp client version supplied in
EL7 stops defaulting to /64 prefixes, the guest VMs have to be configured as
indicated for [EL8](#el8-guest-vm-configuration).

#### EL8 Guest VM configuration

On the version of dhcp client supplied in el8, dhcpv6 alone is **not enough** to
configure dynamic IP addresses on the guest VMs.

The guest networking configuration should work out of the box for both stateful
and stateless dhcp types, when the subnet is connected to a logical router.

## REST configuration examples

### Create a logical network

```bash
curl -X POST \
  http://localhost:9696/v2/networks/ \
  -H 'Content-Type: application/json' \
  -d '{
	"network": {
		"name": "skynet",
		"port-security-enabled": true
	}
}
'
```

### Create a subnet

```bash
curl -X POST \
  http://localhost:9696/v2/subnets/ \
  -H 'Content-Type: application/json' \
  -d '{
	"subnet": {
		"network_id": <YOUR_LOGICAL_NETWORK_ID>,
		"ip_version": 6,
		"cidr": "def0:4141:ab53::/64",
		"gateway_ip": "def0:4141:ab53::1",
		"ipv6_address_mode": "dhcpv6_stateless"
	}
}'
```

### Create a logical router

```bash
curl -X POST \
  http://localhost:9696/v2/routers/ \
  -H 'Content-Type: application/json' \
  -d '{
	"router": {
		"name": "ra_dispenser"
	}
}'
```

### Configure the router

```bash
curl -X PUT \
  http://localhost:9696/v2.0/routers/<YOUR_ROUTER_ID>/add_router_interface \
  -H 'Content-Type: application/json' \
  -d '{
    "subnet_id": <YOUR_SUBNET_ID>
}'
```

## Ansible configuration examples

### Configuring stateful DHCPv6 on the subnet

To configure the native dhcpv6 service of OVNs subnet, the user should
provision the following networking API entities, represented in yaml:

```yaml
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
    ipv6_address_mode: dhcpv6_stateful
  register: ipv6_subnet

- name: create a router to send RA messages
  os_router:
    cloud: "{{ cloud_name }}"
    state: present
    name: router0
    interfaces:
      - "{{ ipv6_subnet.id }}"
~~~~~
```

### Configuring stateless DHCPv6 on the subnet

To configure stateless dhcpv6 on the subnet, the user should provision
the following yaml based ansible playbook snippet:

```yaml
~~~~~
- name: create a network
  os_network:
    cloud: "{{ cloud_name }}"
    state: present
    name: netv6
  register: ipv6_network

- name: attach a subnet to the logical network
  os_subnet:
    cloud: "{{ cloud_name }}"
    state: present
    network_name: netv6
    name: subnet_ipv6
    ip_version: 6
    cidr: bef0:1234:a890:5678::/64
    gateway_ip: bef0:1234:a890:5678::1
    ipv6_address_mode: dhcpv6_stateless
  register: dhcpv6_subnet

- name: create a router to send RA messages
  os_router:
    cloud: "{{ cloud_name }}"
    state: present
    name: router0
    interfaces:
      - "{{ dhcpv6_subnet.id }}"
~~~~~
```

## UI considerations

To prevent networking inconsistencies, the UI should be adapted to only accept
64 bit long network prefixes, because that is required to provide dynamic IPs
by dhcp stateful, which is the default address mode.

## Testing

Two scenarios are recommended, each with two different configurations, leading
to four different tests:
  - single IPv6 subnet using dhcpv6-stateful configuration
  - single IPv6 subnet using dhcpv6-stateless configuration
  - multiple IPv6 subnets connected by router using dhcpv6-stateful configuration
  - multiple IPv6 subnets connected by router using dhcpv6-stateless configuration

All four scenarios on EL8 guest VMs require a router, whereas on EL7 guest VMs
only the dhcpv6-stateless configurations require it.

The aforementioned list of tests should be executed using both possible
configuration / provisioning alternatives: oVirt - e.g. using the UI and/or
the provider's RESTful API - and manageIQ's UI.

### Acceptance Criteria

The acceptance criteria for this feature are the first two items of the
[Testing](#testing) section: single IPv6 subnet using stateful / stateless
address mode configurations.

### Configuration mechanism used for each option

|        Option Name        | dhcpv6-stateful | dhcpv6-stateless |
|:-------------------------:|:---------------:|:----------------:|
| DNS recursive name server |       DHCP      |       DHCP       |
|     Domain Search List    |       DHCP      |       DHCP       |
|       Network Prefix      |       None      |        RA        |
|         IP address        |       DHCP      |  Auto generated  |
|   Network Prefix Length   |        RA       |        RA        |
|            MTU            |        RA       |        RA        |
|      Default Gateway      |        RA       |        RA        |

### Supported use cases per dhcpv6 configuration

| Tables                  |           dhcpv6-stateful           | dhcpv6-stateless |
|-------------------------|:-----------------------------------:|:----------------:|
| fixed IPs               |              supported              |   not supported  |
| dynamic IPs             |      supported, if prefix == 64     |     supported    |
| allowed prefix lengths  |            64 <= X <= 128           |      64 only     |
| ipv6 privacy extensions |            not supported            |     supported    |
| isolated subnet         | if guest routes manually configured |   not supported  |

A brief explanation of each of the use cases described in the tables can be
found below.

#### Fixed IPs

Fixed IPs are not supported on dhcpv6-stateless since the client itself
auto-generates the IP address based on the advertised network prefix.
This means the IP address ***is not*** sent in the DHCPv6 Reply message, thus
making the guest VM IP address configuration impossible.

#### Allowed prefix lengths and dynamic IPs

The [slaac](https://tools.ietf.org/html/rfc4862) RFC indicates that all network
prefixes **are** 64 bit long. Since on DHCPv6 stateless the IP prefix
configuration is done as in slaac, the IPv6 subnets having dhcpv6_stateless
address mode are thus limited to /64 prefixes.

On DHCPv6_stateful, the IP address is sent on the DHCPV6 Reply message, and the
network prefixes - and lengths - are communicated through RA messages.

Thus, the guest is able to configure its addresses - and routes - to communicate
with subnets having longer prefixes.

There is a caveat though: dynamic IP addresses cannot be used when the network
prefix length is different than 64,  meaning they will have to be configured
through the networking API [fixed IPs](https://developer.openstack.org/api-ref/network/v2/?expanded=create-subnet-detail,create-port-detail#create-port)
create port method - specifying both the subnet id, and the IP address.
Since fixed IP addresses are required, this feature would only be possible if
the logical switch ports are updated through the RESTful API.

This implies that dynamic IP addresses are **only possible** on dhcpv6_stateful
address mode **if** the network prefix length is 64 bit long.

#### IPv6 privacy extensions

Privacy extensions are defined in [rfc](https://tools.ietf.org/html/rfc4941).
They can **only** be applied to stateless address modes, and are a matter
of guest VM configuration.

NetworkManager could be used to configure the privacy extensions per interface:

```bash
nmcli conn modify <interface_name> ipv6.ip6-privacy 2
```

This setting will be applied automatically, and the new temporary IP address
will be used as the default.

A caveat about privacy extensions is that they **render impossible** IP spoofing
protection if used, since OVN central will not be able to know the port's IP
address during provisioning time.

#### Isolated subnet

Isolated subnets - not attached to OVN logical routers - can be achieved if the
address mode is set to dhcpv6_stateful.

## Future Features

The following is a list of (possible) future features:

- 'slaac' address mode
- network prefix lengths != 64 when address mode = 'dhcpv6_stateful'
  - this implies implementing fixed IPs in the UI for VMs
- address mode selector when creating a subnet through the UI enabling a
different address mode to be chosen

