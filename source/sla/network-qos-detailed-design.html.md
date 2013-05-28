---
title: Network QoS - detailed design
category: sla
authors: lhornyak, ofri
wiki_category: SLA
wiki_title: Features/Design/Network QoS - detailed design
wiki_revision_count: 68
wiki_last_updated: 2013-06-10
---

# Network QoS - detailed design

### Owner

*   Name: [Ofri Masad](User:omasad)
*   Email: <omasad at redhat dot com>

### Current status

*   Status: design
*   Last updated: ,
*   patchset

## Motivation

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC and each network. The QoS properties are properties which defines the traffic shaping applied on the virtual NIC \\ network. QoS properties currently include:

*   Inbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)
*   Outbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)

For example: if average is set to 100 units, peak to 200 and burst to 50, after sending those 50 units of data at rate 200, the rate will fall down to 100.

In the planned implementation only Virtual Machine level network QoS will be supported. That is, the user could only set QoS properties for virtual NICs.

## Design

We define a new entity called "NetworkQoS" - the QoS properties will be contained in this object. A NetworkQoS object will be added to NetworkInterface entity and Network entity.

When editing a network (by a permitted user), the user could set the QoS properties for the network itself, as well as the QoS properties which would be used as default for each VNIC connected to the said network. Leaving the QoS properties empty will result in no traffic shaping for that network. When editing a VNIC (by a permitted user), the user could set the QoS properties for the VNIC itself, overriding the network's default QoS properties for VNIC (only for that specific VNIC). Leaving the QoS properties empty will result in using the default setting defined by the network. If no default setting were defined the VNIC traffic will not be shaped.

The QoS properties (like the other VNIC properties) will be kept in migration and when VM is saved as template and exported/imported.

Since the QoS properties can be inherited from the network to the VNIC, any change in the QoS properties on the network will require network to be synched (for the change to get to the hosts).

## GUI

The UI for setting the QoS properties will be added to the Add/Edit VNIC dialog. The QoS properties will be optional and the panel holding the properties will be collapsed by default (extendable panel). The user may can enter Inbound settings and/or outbound setting, but if one of the textbox for in/outbound was filled, all of the other textbox for that direction must be filled (This will be verified before allowing to close the dialog). If textbox remain empty the vales from ConfigValues will be used as default.

![](QoS.png "QoS.png")

## Backend

The new fields will be added to the NetworkInterface object (to support future reuse in physical NICs and other network interfaces). Fields values will be seved in DB and ovf.

### Classes

***engine.core.common.businessentities.network.NetworkInterface**'' - add fields: inboundAverage(Integer), inboundPeak(Integer), inboundBurst(Long), outboundAverage(Integer), outboundPeak(Integer), outboundBurst(Long)
***engine.core.vdsbroker.vdsbroker.VmInfoBuilder**'' - add support to the QoS properties
***engine.core.utils.ovf.OvfWriter**' - add support to the QoS properties
***engine.core.utils.ovf.OvfReader**' - add support to the QoS properties
***engine.core.dao.network.VmNetworkInterfaceDao*** - add support to the QoS properties

### DB Change

Add support to the QoS properties by adding 6 columns to the **vm_interface** - Represents the properties of the virtual NIC

| Column Name       | Column Type | Null? / Default |
|-------------------|-------------|-----------------|
| inbound_average  | Integer     |                 |
| inbound_peak     | Integer     |                 |
| inbound_burst    | Bigint      |                 |
| outbound_average | Integer     |                 |
| outbound_peak    | Integer     |                 |
| outbound_burst   | Bigint      |                 |

* alternatively, we can save average,peak,burst values in one string field, but we expect future uses to include mathematical calculations on the values.

### REST API

Change the Virtual Machine > Network Interfaces to support QoS properties Example of an XML representation of a network interface

<nic id="7a3cff5e-3cc4-47c2-8388-9adf16341f5e"  ref="/api/vms/cdc0b102-fbfe-444a-b9cb-57d2af94f401/nics/7a3cff5e-3cc4-47c2-8388-9adf16341f5e">
           `<link rel="statistics" href="/api/vms/082c794b-771f-452f-83c9-b2b5a19c0399/nics/7a3cff5e-3cc4-47c2-8388-9adf16341f5e/statistics"/>`   
`     `<name>`nic1`</name>
`     `<interface>`virtio`</interface>
`     `<mac address="00:1a:4a:16:84:07"/>
`     `<network id="00000000-0000-0000-0000-000000000009" href="/api/networks/00000000-0000-0000-0000-000000000009"/>
`     `<vm id="cdc0b102-fbfe-444a-b9cb-57d2af94f401" href="/api/vms/cdc0b102-fbfe-444a-b9cb-57d2af94f401"/>
`     `<bandwidth>
`       `<inbound average='1000' peak='5000' floor='200' burst='1024'/>
`       `<outbound average='128' peak='256' burst='256'/>
`     `</bandwidth>
</nic>

An API user modifies a network interface with a PUT request

<nic>
`      `<name>`nic2`</name>
`     `<network id="00000000-0000-0000-0000-000000000010"/>
`     `<type>`e1000`</type>
`     `<bandwidth>
`       `<inbound average='1000' peak='5000' floor='200' burst='1024'/>
`       `<outbound average='128' peak='256' burst='256'/>
`     `</bandwidth>
</nic>

### VDSM

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

## Tests

### Expected unit-tests

## Special considerations

*   Old libvirt versions that have the global driver lock may have performance problems. It would be nice to check what version of libvirt is this going to run on.

## Dependencies / Related Features

Affected ovirt projects:

*   API
*   backend
*   Webadmin
*   User Portal

Others:

*   vdsm

## Documentation / External references

*   See: <http://libvirt.org/formatdomain.html#elementQoS> for documentation of the VM level network QoS XML.
*   See: <http://libvirt.org/formatnetwork.html#elementsConnect> for documentation of the Host level network QoS XML.

## Comments and Discussion

*   libvirt version 1.0.1 or higher is required to enable the QoS feature.
*   Quantum network will not be supported at this stage.

To Be Determined:

*   Should all properties be exposed or only sum properties exposed and some calculated (i.e set 'peak' as function of 'average')
*   Should the engine set a default limitations if the user did not fill the QoS fields
*   Default values and default presented values
*   use of 'floor' property (available only in inbound traffic)

<Category:SLA> [Category: Feature](Category: Feature)
