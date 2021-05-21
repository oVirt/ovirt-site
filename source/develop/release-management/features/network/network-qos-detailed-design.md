---
title: Network QoS - detailed design
category: feature
authors:
  - lhornyak
  - ofri
---

# Network QoS - detailed design

#### Summary

Network Quality of Service feature will be added to oVirt from version 3.3 and will support cluster version 3.3 or higher.
The feature will allow the user to limit the inbound and outbound network traffic in virtual NIC level.
In order to define more natural coupling of the QoS to a VNIC we define a new concept called **VNIC Profile**. The VNIC profile will be applied in oVirt 3.3 to all clusters and will wrap few of the properties currently defined directly on the VNIC.
 see [/Features/Network_QoS](/develop/sla/network-qos.html) for detailed description of the feature

#### Owner

*   Name: Ofri Masad (omasad)


#### Current status

*   Status: design
*   patchset

## Design and Implementation

The Network QoS feature includes two main parts:

*   VNIC level QoS
*   VNIC Profiles

The two parts will be developed in parallel

### QoS

#### GUI

see : [QoS Feature overview](/develop/sla/network-qos.html)

#### Backend

We define a new entity called "NetworkQoS" - the QoS properties will be contained in this object.
A NetworkQoS object will be added as a property of the VnicProfile entity.

##### Classes

***engine.core.common.businessentities.network.NetworkQoS**' - new entity with fields: inboundAverage(Integer), inboundPeak(Integer), inboundBurst(Integer), outboundAverage(Integer), outboundPeak(Integer), outboundBurst(Integer)
***engine.core.dao.network.NetworkQoSDao**'' - new Dao
***engine.core.dao.network.VmVnicProfileDao*** - add support to the NetworkQoS field

#### DB Change

Add network_qos table with 7 columns.

| Column Name       | Column Type | Null? / Default |
|-------------------|-------------|-----------------|
| id                | UUID        |                 |
| inbound_average   | Integer     | Null            |
| inbound_peak      | Integer     | Null            |
| inbound_burst     | Integer     | Null            |
| outbound_average  | Integer     | Null            |
| outbound_peak     | Integer     | Null            |
| outbound_burst    | Integer     | Null            |

#### REST API

Not supported in this version

#### VDSM

libvirt version 1.0.1 or higher is required to enable the QoS feature (vdsm 3.3 will use higher version).

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

### VNIC Profiles

#### GUI (VNIC Profiles)

see : [QoS Feature overview](/develop/sla/network-qos.html)

#### Backend

##### Classes

***engine.core.common.businessentities.network.VnicProfile*** - new class holding the VNIC profile properties ***engine.core.common.businessentities.network.NetworkInterface**'' - add fields: vnicProfile(VnicProfile)
***engine.core.common.businessentities.network.Network**'' - add fields: nnicProfile(VnicProfile)
***engine.core.vdsbroker.vdsbroker.VmInfoBuilder**'' - add support to the QoS properties
***engine.core.utils.ovf.OvfWriter**' - add support to the QoS properties
***engine.core.utils.ovf.OvfReader**' - add support to the QoS properties
***engine.core.dao.network.VmVnicProfileDao**'' - new Dao
***engine.core.dao.network.VmNetworkInterfaceDao**'' - add support to the VnicProfile field
***engine.core.dao.network.VmNetworkDao**'' - add support to the VnicProfile field

#### DB Change

Add vnic_profiles table with 7 columns.

| Column Name        | Column Type | Null? / Default | comments                      |
|--------------------|-------------|-----------------|-------------------------------|
| id                 | UUID        | key             |                               |
| name               | String      | Not Null        |                               |
| network_id        | UUID        | Not Null        |                               |
| qos_id            | UUID        | Null            |                               |
| port_mirroring    | Boolean     | Null            | moved from network_interface |
| custom_properties | String      | Null            |                               |

Add network_profile_id(UUID | null) to the **vm_interface** table - Represents the properties of the virtual NIC.

#### REST API

Not supported in this version

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


