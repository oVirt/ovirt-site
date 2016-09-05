---
title: oVirt OVN Provider
category: feature
authors: mmirecki
wiki_category: Feature
wiki_title: Features/oVirt OVN Provider
wiki_revision_count: 1
wiki_last_updated: 2016-09-01
feature_name: oVirt OVN Provider
feature_modules: engine,vdsm
feature_status: In Development
---

# oVirt OVN Provider


## Summary

OVN - Open Virtual Network - is an OVS (Open vSwitch) extension adding support
for virtual networks abstraction. It adds native OVS support for virtual L2 and
L3 overlays.
The goal of this feature is to allow using OVN provided networks from within
oVirt, using the external network provider mechanism. oVirt users will be able
to use/define logical overlays from within oVirt, and provision virtual machines
with network interfaces connected using these overlays.

### Owner

*   Feature Owner: Marcin Mirecki: [ mmirecki](User:mmirecki)

<!-- -->

*   Email: <mmirecki@redhat.com>

### Benefit to oVirt

This feature will add SDN (Software Defined Networking) support to oVirt.
oVirt VMs will be able to use logical networks overlays definded by OVN.

## OVN Architecture (mapped to oVirt)

A detailed description of OVN can be found here: [OSN Integration](http://openvswitch.org/support/dist-docs-2.5/ovn-architecture.7.html)

OVN components can be divided into two groups: 
- OVN central server
- OVN controllers residing on each managed host

### OVN central/ovirt engine

OVN central server consists of:
- Northbound DB - contains the logical network configuration
  this includes:
    - logical switches (equivalent of oVirt networks)
    - logical ports (equivalent of oVirt VNICs)
  Northbound DB is the part updated by the user (oVirt in our case) 
  with the logical configuration

- Southbound DB - contains the physical network view
  this includes:
    - Physical Network (PN) tables - specifies how to reach each host
    - Logical Network (LN) tables - logical datapath flows
    - Binding tables - a link between the Physical and Logical components.
  SouthDB is populated by OVN northd based on the changes made in NorthDB,
  and the OVN Controllers base on provisioned VNICs

- OVN northd - this translates the logical data from NorthDB to the physical
  data in SouthDB. Changes made to NorthDB are processed by northd and the
  SouthDB is updated accordingly.

The OVN databases can be accessed using a python API (part of OVS).


### OVN controller/ovirt host

Each oVirt host (chassis) needs to have OVS along with OVN controller installed.
An OVS integration bridge must be created on the host. This bridge
is used to connect all OVN managed nics.
Each host is identified by its "chassis id". This chassis id is used to route
the network traffic to the appropriate host.



## oVirt OVN Provider architecture

The oVirt OVN provider consists of two parts:

*   The OVN provider - a proxy between the oVirt engine and 
    the OVN North DB

*   The OVN VIF driver - connects the oVirt VNIC to the proper OVS bridge 
    and OVN logical network

### oVirt OVN Provider 

The oVirt OVN provider is a proxy between the oVirt engine and 
the OVN North DB. The provider implements the Openstack Rest API
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

*   GET Subnets - not implemented (no OVN implementation yet)
*   GET Subnet - not implemented (no OVN implementation yet)
*   POST Subnet - not implemented (no OVN implementation yet)
*   DELETE Subnet - not implemented (no OVN implementation yet)

The oVirt OVN provider can be located anywhere in the system. The address of the
provider is specified when the provider is added to oVirt, so the two can be on
any two hosts if needed.
The provider contacts OVN using a web socket, so the two can also be located on
separate hosts.

### oVirt OVN VIF Driver

The oVirt OVN VIF driver connects the oVirt VNIC to the proper OVS bridge 
and OVN logical network. When an OVN port (added by the provider) is plugged
into an OVS bridge, OVN Controller will retrieve information about the port
and the logical network it belongs to from OVN south DB, and create the required
open flows on the local OVS switch. The OVN controller will also update the
binding tables on the OVN south DB, causing all other OVN controllers on other
hosts to update their open flow tables, to allow connections to the newly added
port (if ports belonging to this logical network are present on this OVS switch).
The oVirt OVN VIF driver will also take care of providing the data about the
OVN ports needed by the GetCapabilites and GetStatistics VDSM commands, and
protect the OVN switches and ports during the SetupNetworks command.
The oVirt OVN VIF driver must be located on each oVirt host which supports
OVN. The VIF driver is invoked by VDSM hooks, contacting the OVN databases to
fetch the required data and updating the hook XML passed libvirt or the
oVirt engine.

The following vdsm hooks will need to be implemented:

*   before_device_create
*   before_nic_hotplug
*   after_vm_start
*   after_get_caps
*   after_get_stats


## VIF lifecycle

### Adding Network

The ovn representation of an ovirt network is a logical switch.
To add an oVirt network, a logical switch must be added to the OVN north db.
This is done by adding a record to the Logical_Switch table (equivalent of
command: ovn-nbctl ls-add <network name>).


### Removing Network

To remove an oVirt network, the equivalent logical switch record must be removed from the OVN north db.
This is done by removing a record from the Logical_Switch table
(equivalent of command: ovn-nbct ls-del <network-name>)

All logical ports belonging to this logical switch must be removed from the logical switch prior to this.

### Vnic add

The OVN representation of an oVirt VNIC is a logical port. 
When a nic is added in ovirt (just added, not plugged in), a logical port must be added to the north db
(we will actually use lazy initialization and create the port just before the port is plugged in).

The is added by adding a row to the Logical_Switch_Port table in the OVN north db and
associate it with the mac address of the oVirt nic by setting the appropriate value in
the record.
Equivalent of commands:
ovn-nbctl lsp-add <lswtich name> <lport name (vif id)>
ovn-nbctl lsp-set-addresses <lport name (vif id)> <mac of port>

As a result OVN will make the corresponding updates to the OVN Southbound
database,  by adding rows to the OVN Southbound database
Logical_Flow table to reflect the new port, e.g.  add  a  flow  to
recognize  that packets destined to the new port’s MAC address
should be delivered to it.
A record in the Binding table is made except the column that
identifies the chassis.
OVN contollers on the hosts will see the change in the southbound db,
but will take no action until the lport is actually plugged in (the vnic
does not exist yet, so there is no need to act yet).

### Vnic remove

To remove an oVirt VNIC, the equivalent logical switch port record must be removed from the
OVN north db Logical_Switch_Port table.
This is the equivalent of:
	ovn-nbctl lsp-del <lport-name (vif-id)>

OVN will remove all southbound entries appropriately.

### Vnic plug

When a nic is plugged in (vm is powered on, or an unplugged nic is hot-plugged),
the nic must be added to the OVN integration bridge.
This is task is performed automatically by libvirt, if the VNIC xml
is appropriately modified.
This is done by adding the following section to the xml:

         <source bridge='ovsbr0'/>
         <virtualport type='openvswitch'>
           <parameters interfaceid='<OVN logical switch port name>'/>
         </virtualport>

The value of the "bridge" attribute of the "source" element is the OVS switch to which
the VNIC should be added.
The  "interfaceid" attribute of the "virtualport/parameters" element is the name
of the OVN logical switch port which should be associated with this VNIC, and sets
the value of the "external-ids:iface-id" column in the logical switch port record.
The complete xml would look as follows:

    <interface type='bridge'>
         ...
         <source bridge='ovsbr0'/>
         <virtualport type='openvswitch'>
           <parameters interfaceid='<OVN logical switch port name>'/>
         </virtualport>
         ...
    </interface>

This is the equivalent of executing the following OVS commands:
	ovs-vsctl add-port br-int <nic name> -- set Interface <nic name> external_ids:iface-id=<OVN logical switch port name>

The "external-ids:iface-id" parameter allows OVN controler to associate 
this nic with the logical port defined in the southbound db. 
OVN controller will update the OVS OpenFlow tables in accordance with
the southbound db.
The binding in the southbound db is updated with the chassis id.

OVN controllers on different hosts notice the updated chassis id in the binding,
and knowing the physical location of the port update local ovs flows.

#### Detailed steps of nic plugging

* the engine checks if the port for the VM NIC exists, issuing a GET port request to the provider. The provider
in turn queries the Logical_Switch_Port table of the OVN north DB
* if no port exists, the engine will create a new port by issuing a POST port request to the provider. The provider
in turn adds a row to the Logical_Switch_Port table of the OVN north DB
* if a port already exists, the engine will update the port by issuing a POST port request to the provider. The provider
in turn updates the port row in the Logical_Switch_Port table of the OVN north DB
* in both cases the new/updated port is identified by a <PORT ID>, which is the uuid of the port row in the Logical_Switch_Port table of the OVN north DB
* the engine will send a nic plug request to VDSM, passing the <PORT ID>
as one of the parameters. The <PORT ID> is passed to the VIF driver (VDSM hook) as  a "vnic_id"
parameter.
* on VDSM, the VIF Driver, invoked using the VDSM before_nic_hotplug/before_device_create hook,
will connect the VM NIC to the network provided by the external provider by modifing the device xml

![](external_network_provider_schema1.jpg "fig:external_network_provider_schema1.jpg")

### Vnic unplug

When a VNIC is unplugged, libvirt will automatically unplug the port from
the OVS bridge.
This is the equivalent of executing the following OVS commands:
	ovs-vsctl del-port <nic name>

This deletes the port from the OVN integration bridge. OVN controller 
modifies the local OpenFlows on the host and deletes the chassis id from the
bindings. Other OVN-controllers notice the binding change, and update their
local flows.

## Further considerations

Items which needs further considering:

*   IPAM
*   migration
*   high availability

