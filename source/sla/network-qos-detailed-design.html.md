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

### Summary

Network Quality of Service feature will be added to oVirt from version 3.3 and will support cluster version 3.3 or higher.
The feature will allow the user to limit the inbound and outbound network traffic in two layers (in current implementation): host level, virtual NIC level.

*   Traffic shaping using the Network QoS feature will be available only for oVirt networks at this stage. Externally provided networks may be supported in future extensions.

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

The UI for setting of QoS properties will be added to the Add/Edit Network and VNIC dialogs.
In the Add/Edit Network two parts will be added - one for the QoS properties of the network, the other for the QoS properties preset for VNICs attached to the network.

**UI addition to the Add/Edit Network dialog**
![](Network_quality_of_service_2.png "fig:Network_quality_of_service_2.png")

**UI addition to the Add/Edit VNIC dialog**
![](QoS.png "fig:QoS.png")

The user could enable/disable the QoS properties (for each inbound / outbound).
The panel holding the properties will be collapsed by default (extendable panel).
Once inbound/outbound was enabled all three field must be filled (This will be verified before allowing to close the dialog). If QoS properties were set in the network dialog as preset for all VNICs - these setting will appear in the VNIC. The user can override them in the VNIC dialog.

## Permissions

Only a user permitted to edit the network may edit the QoS properties in the network dialog. In order to override the QoS properties in the VNIC dialog a user must have both UserVmManger permission and NetworkAdmin permission. UI of the QoS editing will only be presented to user with the above permissions.

## Backend

A new entity will be created (NetworkQoS) which will hold the QoS properties. NetworkQoS field will be added to NetworkInterface object and Network object. Fields values will be seved in DB and ovf.

### Classes

***engine.core.common.businessentities.network.NetworkQoS**' - new entity with fields: inboundAverage(Integer), inboundPeak(Integer), inboundBurst(Long), outboundAverage(Integer), outboundPeak(Integer), outboundBurst(Long)
***engine.core.common.businessentities.network.NetworkInterface**'' - add fields: networkQoS(NetworkQoS)
***engine.core.common.businessentities.network.Network**'' - add fields: networkQoS(NetworkQoS)
***engine.core.vdsbroker.vdsbroker.VmInfoBuilder**'' - add support to the QoS properties
***engine.core.utils.ovf.OvfWriter**' - add support to the QoS properties
***engine.core.utils.ovf.OvfReader**' - add support to the QoS properties
***engine.core.dao.network.VmNetworkQoSDao**'' - new Dao
***engine.core.dao.network.VmNetworkInterfaceDao**'' - add support to the NetworkQoS field
***engine.core.dao.network.VmNetworkDao*** - add support to the NetworkQoS field

### DB Change

Add NetworkQoS table with 7 columns.

| Column Name       | Column Type | Null? / Default |
|-------------------|-------------|-----------------|
| id                | UUID        |                 |
| inbound_average  | Integer     |                 |
| inbound_peak     | Integer     |                 |
| inbound_burst    | Integer     |                 |
| outbound_average | Integer     |                 |
| outbound_peak    | Integer     |                 |
| outbound_burst   | Integer     |                 |

Add network_QoS_id(UUID | null) to the **vm_interface** table - Represents the properties of the virtual NIC.
Add network_QoS_id(UUID | null) and network_QoS_default_for_vnic_id(UUID | null) to the **network** table.

### REST API

Not supported in this version

### VDSM

libvirt version 1.0.1 or higher is required to enable the QoS feature (vdsm 3.3 will use higher version).

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

## Tests

### Expected unit-tests

## Special considerations

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

<Category:SLA> [Category: Feature](Category: Feature)
