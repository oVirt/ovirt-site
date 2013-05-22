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

## Motivation

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC. The QoS properties are properties which defines the traffic shaping applied on the virtual NIC. QoS properties currently include:

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

The QoS properties will be saved as properties of the NetworkInterface entity. The user could set the properties when creating/editing a VM NIC (in the future, this capability may be available for host physical NICs as well). The Qos properties (like the other NIC properties) will be kept in migration and when VM is saved as template and exported/imported.

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

### VDSM

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

## Tests

### Expected unit-tests

## Special considerations

## Pre-integration needs

No needs.

## responded to next version

<Category:SLA> [Category: Feature](Category: Feature)
