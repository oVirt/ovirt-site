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
The feature will allow the user to limit the inbound and outbound network traffic in virtual NIC level.
In order to define more natural coupling of the QoS to a VNIC we define a new concept called **VNIC Profile**. The VNIC profile will be applied in oVirt 3.3 to all clusters and will wrap few of the properties currently defined directly on the VNIC.
 see [http://www.ovirt.org/Features/Network_QoS Network QoS](http://www.ovirt.org/Features/Network_QoS Network QoS) for detailed description of the feature

#### Owner

*   Name: [Ofri Masad](User:omasad)
*   Email: <omasad at redhat dot com>

#### Current status

*   Status: design
*   Last updated: ,
*   patchset

## Design and Implementation

The Network QoS feature includes two main parts:

*   VNIC level QoS
*   VNIC Profiles

The two parts will be developed in parallel

### QoS

#### GUI

see : [QoS Feature overview](Features/Network_QoS)

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

### VNIC Profiles

#### GUI (VNIC Profiles)

see : [QoS Feature overview](Features/Network_QoS)

#### Backend

##### Classes

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
