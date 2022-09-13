---
title: oVirt OVN Provider
category: feature
authors:
  - mmirecki
  - dholler
---

# oVirt OVN Provider


## Summary

OVN - Open Virtual Network - is an OVS (Open vSwitch) extension, adding support
for virtual networks abstraction. It adds native OVS support for virtual L2 and
L3 overlays.

The goal of this feature is to allow using OVN provided networks from within
oVirt, using the external network provider mechanism. oVirt users will be able
to use/define logical overlays from within oVirt, and provision virtual machines
with network interfaces connected using these overlays.

The progress of the feature is tracked on [Trello](https://trello.com/b/lqNXh8uI/ovirt-4-1-ovn)

### Owner

*   Feature Owner: Marcin Mirecki: mmirecki (mmirecki)
*   Email: <mmirecki@redhat.com>

### Benefit to oVirt

This feature will add SDN (Software Defined Networking) support to oVirt.
oVirt VMs will be able to use logical networks overlays defined by OVN.

## OVN Architecture (mapped to oVirt)

A detailed description of OVN can be found here: [OVN Integration](http://openvswitch.org/support/dist-docs-2.5/ovn-architecture.7.html)

OVN components can be divided into two groups:
- OVN central server
- OVN controllers residing on each managed host

### OVN central

OVN central server consists of:
- Northbound DB - contains the logical network configuration
  this includes:
    - logical switches (equivalent of oVirt networks)
    - logical ports (equivalent of oVirt vNICs)
  Northbound DB is the part updated by the user (oVirt in our case)
  with the logical configuration

- Southbound DB - contains the physical network view
  this includes:
    - Physical Network (PN) tables - specifies how to reach each host
    - Logical Network (LN) tables - logical data path flows
    - Binding tables - a link between the Physical and Logical components.
  SouthDB is populated by OVN northd based on the changes made in NorthDB,
  and the OVN Controllers base on provisioned vNICs

- OVN northd - this translates the logical data from NorthDB to the physical
  data in SouthDB. Changes made to NorthDB are processed by northd and the
  SouthDB is updated accordingly.

The OVN databases can be accessed using a python API, which is part of OVS (`python/ovs/db/idl.py`).

The OVN central server is accessed by the oVirt engine using the oVirt OVN provider
as a proxy. The oVirt OVN provider translates oVirt HTTP requests to OVN database queries.

### OVN controller

Each oVirt host (chassis) needs to have OVS along with OVN controller installed.
An OVS integration bridge must be created on the host. This bridge
is used to connect all OVN managed NICs.
Each host is identified by its "chassis id". This chassis id is used to route
the network traffic to the appropriate host.

## oVirt OVN Provider architecture

The oVirt OVN provider consists of two parts:

*   The OVN provider - a proxy between the oVirt engine and
    the OVN North DB

*   The OVN VIF driver - connects the oVirt vNIC to the proper OVS bridge
    and OVN logical network

### oVirt OVN Provider

The oVirt OVN provider is a proxy between the oVirt engine and
the OVN North DB. The provider implements the OpenStack Rest API
to allow it to be used by oVirt using the external network provider
mechanism. REST queries from oVirt are translated into appropriate
OVN database queries.

The provider handles the following requests:

*   GET Networks - retrieves a list of all Logical Switches from the OVN north DB Logical_Switch table
*   GET Network - retrieves a specific Logical Switch from the OVN north DB Logical_Switch table
*   POST Network - updates a specific Logical Switch from the OVN north DB Logical_Switch table
*   DELETE Network - deletes a specific Logical Switch from the OVN north DB Logical_Switch table

*   GET Ports - retrieves a list of all Logical Switch Ports from the OVN north DB Logical_Switch_Port table
*   GET Port - retrieves a specific Logical Switch Port from the OVN north DB Logical_Switch_Port table
*   POST Port - updates a specific Logical Switch Port from the OVN north DB Logical_Switch_Port table
*   DELETE Port - deletes a specific Logical Switch Port from the OVN north DB Logical_Switch_Port table

*   GET Subnets - retrieves a list of all network subnets from the OVN north DB DHCP_Options table
*   GET Subnet - not implemented (no OVN implementation yet)
*   POST Subnet - not implemented (no OVN implementation yet)
*   DELETE Subnet - not implemented (no OVN implementation yet)

The oVirt OVN provider must be located on the same host as the OVN central server.


### oVirt OVN VIF Driver

The oVirt OVN VIF driver connects the oVirt vNIC to the proper OVS bridge and OVN logical network.

When an OVN port (added by the provider) is plugged into an OVS bridge, OVN Controller will retrieve information about the port
and the logical network it belongs to from OVN south DB, and create the required
open flows on the local OVS switch.

The OVN controller will also update the
binding tables on the OVN south DB, causing all other OVN controllers on other
hosts to update their open flow tables, to allow connections to the newly added
port (if ports belonging to this logical network are present on this OVS switch).

The oVirt OVN VIF driver will also take care of providing the data about the
OVN ports needed by the GetCapabilites VDSM command.

The `GetStatistics` VDSM command needs to be checked.

The driver must also protect the OVN switches, OVN ports and host NICs used for
OVN tunneling during the SetupNetworks command.

The oVirt OVN VIF driver must be located on each oVirt host which supports
OVN. The VIF driver is invoked by VDSM hooks, contacting the OVN databases to
fetch the required data and updating the hook XML passed libvirt or the
oVirt engine.

The following vdsm hooks will need to be implemented:

*   before_device_create - connect vNIC to OVN
*   before_nic_hotplug - connect vNIC to OVN
*   after_vm_start - unpause VM (if we choose to pause VM until all vNIC are up)
*   after_get_caps - add OVN vNIC info to capabilities
*   after_get_stats - (to be verified)
*   before_network_setup - protect host NICs used for OVN tunneling and protect OVN entities

## OVN provider lifecycle

### Listing entities

The provider provides a list of existing entities.
A list of all entities can be obtained using the command:
```console
# ovn-nbctl show
```
The provider will list the networks and ports in separate REST queries.

### Adding Network

The OVN representation of an oVirt network is a logical switch.
To add an oVirt network, a logical switch must be added to the OVN north db.
This is done by adding a record to the Logical_Switch table (equivalent of
command: `ovn-nbctl ls-add <network name>`).

### Removing Network

To remove an oVirt network, the equivalent logical switch record must be removed from the OVN north db.
This is done by removing a record from the Logical_Switch table
(equivalent of command: `ovn-nbct ls-del <network-name>`)

All logical ports belonging to this logical switch must be removed from the logical switch prior to this.

### vNIC add

The OVN representation of an oVirt vNIC is a logical port.
When a NIC is added in oVirt (just added, not plugged in), a logical port must be added to the north db
(we will actually use lazy initialization and create the port just before the port is plugged in).

The is added by adding a row to the Logical_Switch_Port table in the OVN north db and
associate it with the mac address of the oVirt NIC by setting the appropriate value in
the record.
Equivalent of commands:

```console
# ovn-nbctl lsp-add <lswtich name> <lport name (vif id)>
# ovn-nbctl lsp-set-addresses <lport name (vif id)> <mac of port>
```

As a result OVN will make the corresponding updates to the OVN Southbound
database,  by adding rows to the OVN Southbound database
Logical_Flow table to reflect the new port, e.g.  add  a  flow  to
recognize  that packets destined to the new port’s MAC address
should be delivered to it.
A record in the Binding table is made except the column that
identifies the chassis.
OVN controllers on the hosts will see the change in the southbound db,
but will take no action until the lport is actually plugged in (the vNIC
does not exist yet, so there is no need to act yet).

### vNIC remove

To remove an oVirt vNIC, the equivalent logical switch port record must be removed from the
OVN north db Logical_Switch_Port table.
This is the equivalent of:
```console
# ovn-nbctl lsp-del <lport-name (vif-id)>
```

OVN will remove all southbound entries appropriately.

### vNIC plug

When a NIC is plugged in (vm is powered on, or an unplugged nic is hot-plugged),
the NIC must be added to the OVN integration bridge.
This is task is performed automatically by libvirt, if the vNIC xml
is appropriately modified.
This is done by adding the following section to the xml:

```xml
         <source bridge='ovsbr0'/>
         <virtualport type='openvswitch'>
           <parameters interfaceid='<OVN logical switch port name>'/>
         </virtualport>
```

The value of the "bridge" attribute of the "source" element is the OVS switch to which
the vNIC should be added.
The "interfaceid" attribute of the "virtualport/parameters" element is the name
of the OVN logical switch port which should be associated with this vNIC, and sets
the value of the "external-ids:iface-id" column in the logical switch port record.
The complete xml would look as follows:

```xml
    <interface type='bridge'>
         ...
         <source bridge='ovsbr0'/>
         <virtualport type='openvswitch'>
           <parameters interfaceid='<OVN logical switch port name>'/>
         </virtualport>
         ...
    </interface>
```

This is the equivalent of executing the following OVS commands:

```console
# ovs-vsctl add-port br-int <nic name>
# ovs-vsctl set Interface <nic name> external_ids:iface-id=<OVN logical switch port name>
```

The "external-ids:iface-id" parameter allows OVN controller to associate
this nic with the logical port defined in the southbound db.
OVN controller will update the OVS OpenFlow tables in accordance with
the southbound db.
The binding in the southbound db is updated with the chassis id.

OVN controllers on different hosts notice the updated chassis id in the binding,
and knowing the physical location of the port update local OVS flows.

#### Detailed steps of vNIC plugging

*   The engine checks if the port for the VM NIC exists, issuing a GET port request to the provider. The provider
    in turn queries the Logical_Switch_Port table of the OVN north DB
*   if no port exists, the engine will create a new port by issuing a POST port request to the provider. The provider
    in turn adds a row to the Logical_Switch_Port table of the OVN north DB
*   if a port already exists, the engine will update the port by issuing a POST port request to the provider. The provider
    in turn updates the port row in the Logical_Switch_Port table of the OVN north DB
*   in both cases the new/updated port is identified by a `<PORT ID>`, which is the uuid of the port row in the Logical_Switch_Port table of the OVN north DB
*   the engine will send a nic plug request to VDSM, passing the `<PORT ID>`
    as one of the parameters. The `<PORT ID>` is passed to the VIF driver (VDSM hook) as  a "vnic_id" parameter.
*   on VDSM, the VIF Driver, invoked using the VDSM before_nic_hotplug/before_device_create hook,
    will connect the VM NIC to the network provided by the external provider by modifying the device xml

![](/images/wiki/external_network_provider_schema1.png)

### vNIC unplug

When a vNIC is unplugged, libvirt will automatically unplug the port from
the OVS bridge.
This is the equivalent of executing the following OVS command:
```console
ovs-vsctl del-port <nic name>
```

This deletes the port from the OVN integration bridge. OVN controller
modifies the local OpenFlows on the host and deletes the chassis id from the
bindings. Other OVN-controllers notice the binding change, and update their
local flows.

## Authentication of the provider

The identity of the provider can be authenticated by Transport Layer Security
(TLS). For this the provider has to be configured to accept HTTP requests over
TLS (HTTPS).
This way the provider has to present it's identity to the communication
partner, which is the oVirt engine or a cloud management software.

The oVirt engine manages the provider's identity by storing the provider's
certificate in the external providers trust store and check the provider's
certificate during connecting to the provider.

## Authentication and Authorization at the provider

The oVirt OVN provider is able to authenticate users and authorize requests
according a minimal subset of the [OpenStack API](https://developer.openstack.org/api-guide/quick-start/).
The procedure is that the client [authenticates](#authentication) itself to get
a token, which has to be used in the [subsequent requests](#ovirt-ovn-provider-1).

The behavior of authentication and authorization is defined by the
[plugin](#plugins) chosen in the provider's configuration.

### Authentication

Authentication is implemented by a single request of the OpenStack
[Identity API v2.0](https://web.archive.org/web/20170127173135/http://developer.openstack.org/api-ref/identity/v2/),
commonly known as keystone API.

The provider handles the following request for authentication:

*   POST tokens - authenticates and generates a token from username and
    password, using a subset of the parameters of the OpenStack
    [specification](https://web.archive.org/web/20170127173135/http://developer.openstack.org/api-ref/identity/v2/#authenticate).

### Authorization

The `X-Auth-Token` HTTP header in every request to the OpenStack Rest API is
used to authorize the request. If the authorization is given, is up to the
configured plugin of the provider.

### Plugins

There are various plugins available, which differentiate by their behavior.
Supported are the plugins to authorize by username or group membership:

*  AuthorizationByUserName - uses the oVirt engine's
   [SSO](/develop/release-management/features/infra/uniformssosupport.html) to
   create a token from the given username and password. So the user has to be a
   valid user of oVirt engine. The token in the requests to the OpenStack Rest
   API is authorized, if it is associated to the username defined in the
   provider's configuration. This plugin is the **default**, because after the
   installation of oVirt only the default user "admin@internal", but no groups,
   may be available.

*  AuthorizationByGroup - uses the oVirt engine's SSO to
   create a token from the given username and password. The token in the
   requests to the OpenStack Rest API is authorized, if it is associated to
   a user which is a member of the group defined in the provider's configuration.
   In the configuration file in the section `[OVIRT]`, the option
   `admin-group-atrribute-name` defines the name of the attribute in the
   directory server holds the group name. The option
   `admin-group-attribute-value` defines the name of the group, which grants
   authorization to it's members. The default configuration is to authorize
   members of the group `NetAdmin` in the default extension
   `ovirt-engine-extension-aaa-jdbc`. If oVirt engine uses an external LDAP
   provider, the two options has to be adopted in the ovn-provider's
   configuration.

Other plugins exists, but they are not supported:

*  NoAuthPlugin - generates a static token, independently from the provided
   username and password, and accepts every request to the OpenStack Rest API.
   Even requests, which does not contain the `X-Auth-Token` HTTP header are
   accepted.

*  MagicTokenPlugin - generates a static token, independently from the provided
   username and password. Request to the OpenStack Rest API must provide this
   static token.

*  AuthorizationByRole - uses the oVirt engine's SSO to
   create a token from the given username and password. The token in the
   requests to the OpenStack Rest API is authorized, if it is associated to
   a user with the role defined in the provider's configuration.

## Packaging and installation

### OVN Central Server

The OVN central server must be installed manually. It must be accessible via network to
the OVN provider and to all the hosts which use OVN.

### OVN Controller

The OVN Controller must be installed on each host using OVN.
After installation the OVN controller must be configured with the value of the OVN central
which it will be using and the local IP used for tunneling.
This could be automated using an otopi plugin, but this would require a one-time configuration
of the plugin. A way to establish the tunneling IP on the host should be provided, as well as
the IP of the OVN central.
A look at the plugin directory might be helpful to understand the process:
`/usr/share/ovirt-host-deploy/plugins/ovirt-host-deploy`

Another possibility would be to to use vdsm-tool configure.

The OVN controller will probably be installed together with the VIF driver.

### Provider packaging and installation

The provider will be delivered as an RPM.
The provider is the proxy between the oVirt engine, and the OVN north DB. The oVirt engine
will need the IP of the provider to connect to it. The provider in turn will need the IP of
the OVN north DB to be able to connect to it.
The provider IP is specified when adding a provider in the oVirt engine.
The OVN north DB IP must be specified when starting the OVN provider. If this is not specified,
the provider will assume the OVN north DB is running on the same host.

Note that running oVirt engine, the provider and OVN north DB on different hosts is possible,
the most common scenario will be running all three on the same host.

### Driver packaging

The VIF driver will be delivered as an rpm. As such, it will be installed manually
on the hosts. The VIF driver connects to the local OVS instance and OVN north DB instance used
by the local OVS. It needs no further configuration.

The VIF driver RPM could be made available in the VDSM repo, or a local repo available to the hosts.
It could then be installed by being added to:
`/usr/share/ovirt-host-deploy/plugins/ovirt-host-deploy/vdsmhooks/packages.d/`
All RPM files specified there will be installed on the host during the host deploy operation.
There should be a separate file for each linux distribution. The file extension
must be the name of the linux distribution on which the rpm's are to be installed
(fedora, redhat, ...).

### Installation issues

The provider and driver will need to access various system resources with limited access, such
as sockets, network and file access.
The following items must be taken care of to allow this:
*   create required firewalld and iptables rules
*   giving the `vdsm` user (user executing hooks) access to `root` owned OVS resources
*   setting required SELinux policies

## Further considerations

### IPAM

The IP assigned to OVN managed NICs is allocated from a subnet (pool of IPs) defined within OVN DHCP server.

### Migration

We must ensure a minimal NIC downtime during the live migration process. The switch over from the ports on the source and
destination host must be as quick as possible and also synchronized with the switch over of the VM itself.
The following BZ has been created to describe and track this issue:
[OVS bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1369362)

### High availability

The current plan for high availability is to run northd on the Engine host, which can be highly-available via hosted engine.
We hope that OVN gives us high availability so that northd can be run on any chassis.

## Testing

*   Network lifecycle (add/remove)
*   Port lifecycle (add/remove/plug/unplug/migrate)
*   Migration (migrate VM's with OVN ports, port should be pingable after migration)
*   Test connectivity between VMs on different hosts
*   Installation
*   Security - only the engine should be able to access the provider and access to OVN north DB should also be limited
*   Chassis security - chassis should connect to northd using a secure connection.

Items which will be tested once the appropriate OVN functionality is available:

*   Subnet lifecycle (add/remove/assign IP/unassign IP). IP's assigned to VMs should be
    within defined subnets and should ping each other
*   Test OVN central high availability. NICs within the same network should ping each
    other after a highly available OVN is restarted
