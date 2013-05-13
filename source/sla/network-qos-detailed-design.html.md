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

## Design

The QoS properties will be saved as properties of the NetworkInterface entity. The user could set the properties when creating/editing a VM NIC (in the future, this capability may be available for host physical NICs as well). The Qos properties (like the other NIC properties) will be kept in migration and when VM is saved as template and exported/imported.

## GUI

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

## Tests

### Expected unit-tests

1.  QuotaManager - consume quota
2.  QuotaManager - release quota
3.  QuotaManager - rollback quota
4.  QuotaManager - clear quota cache
5.  Check quota interface is implemented where VdcActionType suggests it should

## Special considerations

## Pre-integration needs

No needs.

## responded to next version

<Category:SLA> [Category: Feature](Category: Feature)
