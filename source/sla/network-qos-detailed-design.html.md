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

#### Summary

Network Quality of Service feature will be added to oVirt from version 3.3 and will support cluster version 3.3 or higher.
The feature will allow the user to limit the inbound and outbound network traffic in two layers (in current implementation): host level, virtual NIC level.

#### Owner

*   Name: [Ofri Masad](User:omasad)
*   Email: <omasad at redhat dot com>

#### Current status

*   Status: design
*   Last updated: ,
*   patchset

#### Detailed Description

Traffic shaping is a very common practice in network management. Traffic shaping allows the network administrator to prevent over consumption of network resources by limiting the bandwidth in several layers. Current implementation of libvirt allows limiting the bandwidth in the Host level and in the virtual NIC level for both inbound and outbound traffic. The Network QoS on oVirt make use of that API and allows the network administrator to define network limitations on specific VNICs and specific networks.

The QoS properties are properties which defines the traffic shaping applied on the virtual NIC \\ network. QoS properties currently include:

*   Inbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)
*   Outbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)

For example: if average is set to 100 units, peak to 200 and burst to 50, after sending those 50 units of data at rate 200, the rate will fall down to 100.

Traffic shaping using the Network QoS feature will be available only for oVirt networks at this stage. Externally provided networks (such as Quantum) may be supported in future extensions.

#### Benefit to oVirt

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC and each network.

## Design and Implementation

The Network QoS feature includes two main parts:

*   VNIC level QoS
*   Network level (host level) QoS

The two parts will be developed in two independent phases

### VNIC level QoS

Target release: 3.3 (p1)

QoS properties for VNIC will be attached to VNIC, but since not all users which can attach VNICs could edit those properties, we also define default QoS properties for VNIC which can be defined per each network. A user with a NetworkAdmin role would be able to define those default values for VNIC on each network. The default values will be inherited by each VNIC attached to the network, unless they have been overridden in the VNIC itself. only a user holding a NetworkAdmin role could override the default properties.

If QoS properties were overridden in the VNIC itself the set properties will be kept if the VM holding that VNIC when saved to Template, exported and imported. If the QoS properties were not overridden in the VNIC, they will remain at synch with the default values for VNIC set on the network.

#### GUI (VNIC level)

The UI for setting of QoS properties will be added to the Add/Edit VNIC dialog.
The newly added part will be visible only to user with the permission to edit QoS properties, both in Administrator and User portal.

**UI addition to the Add/Edit VNIC dialog**
![](QoS.png "fig:QoS.png")

In the Add/Edit Network two parts will be added:
* QoS properties of the network(discussed in the next phase)
* QoS properties default for VNICs attached to the network (discussed here).
 **UI addition to the Add/Edit Network dialog**
![](Network_quality_of_service_2.png "fig:Network_quality_of_service_2.png")

The user could enable/disable the QoS properties (for each inbound / outbound). Disabled QoS will mean no limitation on the traffic in this direction
The panel holding the properties will be collapsed by default (extendable panel).
Once inbound/outbound was enabled all three field must be filled (This will be verified before allowing to close the dialog).
If QoS properties were set in the network dialog as default for all VNICs attached to that network - these setting will appear in the VNIC. The user can override them in the VNIC dialog. If the default values were overridden a "Revert to network default" hyperlink will appear, allowing the user to easily revert to network defaults.

User with no permission to edit the QoS properties will see no change in the UI.

#### Backend

We define a new entity called "NetworkQoS" - the QoS properties will be contained in this object. A NetworkQoS object will be added to NetworkInterface entity A new entity will be created (NetworkQoS) which will hold the QoS properties. NetworkQoS field will be added to NetworkInterface object and Network object. Fields values will be seved in DB and ovf.

##### Classes

***engine.core.common.businessentities.network.NetworkQoS**' - new entity with fields: inboundAverage(Integer), inboundPeak(Integer), inboundBurst(Long), outboundAverage(Integer), outboundPeak(Integer), outboundBurst(Long)
***engine.core.common.businessentities.network.NetworkInterface**'' - add fields: networkQoS(NetworkQoS)
***engine.core.common.businessentities.network.Network**'' - add fields: networkQoS(NetworkQoS)
***engine.core.vdsbroker.vdsbroker.VmInfoBuilder**'' - add support to the QoS properties
***engine.core.utils.ovf.OvfWriter**' - add support to the QoS properties
***engine.core.utils.ovf.OvfReader**' - add support to the QoS properties
***engine.core.dao.network.VmNetworkQoSDao**'' - new Dao
***engine.core.dao.network.VmNetworkInterfaceDao**'' - add support to the NetworkQoS field
***engine.core.dao.network.VmNetworkDao*** - add support to the NetworkQoS field

#### DB Change

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

#### REST API

Not supported in this version

#### VDSM

libvirt version 1.0.1 or higher is required to enable the QoS feature (vdsm 3.3 will use higher version).

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

### Network level QoS

Target release: 3.3 (p2)

#### GUI (VNIC level)

**UI addition to the Add/Edit Network dialog**
![](Network_quality_of_service_2.png "fig:Network_quality_of_service_2.png")

### Backend

#### Classes

#### DB Change

#### REST API

Not supported in this version

#### VDSM

### Tests

#### Expected unit-tests

### Special considerations

### Dependencies / Related Features

Affected ovirt projects:

*   API
*   backend
*   Webadmin
*   User Portal

Others:

*   vdsm

### Documentation / External references

*   See: <http://libvirt.org/formatdomain.html#elementQoS> for documentation of the VM level network QoS XML.
*   See: <http://libvirt.org/formatnetwork.html#elementsConnect> for documentation of the Host level network QoS XML.

### Comments and Discussion

<Category:SLA> [Category: Feature](Category: Feature)
