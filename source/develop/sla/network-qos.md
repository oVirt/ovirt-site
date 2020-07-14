---
title: Network QoS
category: sla
authors: danken, moti, ofri, ovedo
---

# Network QoS

#### Summary

Network Quality of Service feature will be added to oVirt from version 3.3 and will support cluster version 3.3 or higher.
The feature will allow the user to limit the inbound and outbound network traffic in virtual NIC level.
In order to define more natural coupling of the QoS to a VNIC we define a new concept called **[VNIC Profile](/develop/release-management/features/sla/vnic-profiles.html)**. The VNIC profile will be introduced in oVirt 3.3 to all clusters and will wrap few of the properties currently defined directly on the VNIC

#### Owner

*   Name: Ofri Masad
*   Email: <omasad at redhat dot com>

#### Current status

*   Status: Network QoS done.
*   Last updated: ,

#### Detailed Description

Traffic shaping is a very common practice in network management. Traffic shaping allows the network administrator to prevent over consumption of network resources by limiting the bandwidth in several layers. Current implementation of libvirt allows limiting the bandwidth in the virtual NIC level for both inbound and outbound traffic. The Network QoS on oVirt make use of that API and allows the network administrator to define network limitations on specific VNICs.

The QoS properties are properties which defines the traffic shaping applied on the virtual NIC . QoS properties currently include:

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

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC. The Network QoS feature will add this ability to the engine.

## Design and Implementation

see : [Network QoS - detailed design Implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

#### GUI

The UI for setting of QoS properties will be added to the Add/Edit Profile dialog.
 **Network QoS sub tab**
![](/images/wiki/Qos_new_tab.png)

The Network QoS will be added as sub tab of Data Center (administrator port6al only) . The administrator will be able to Add/Remove/Edit Network QoS entities. The QoS name and all 6 properties will be viewed in the table.

**Add/Edit Network QoS dialog**
![](/images/wiki/Qos_neq_dialog.png)

The Add/Edit Network QoS dialog will include text field for name and six text fields for the values.
The administrator could enable/disable the QoS properties (for each inbound / outbound). Disabled QoS will mean no limitation on the traffic in this direction
Once inbound/outbound was enabled all three field must be filled (This will be verified before allowing to close the dialog). The Peak and Burst fields will be automatically filled when entering Average value (and could be edited manually).

#### Backend

We define a new entity called "NetworkQoS" - the QoS properties will be contained in this object.
A NetworkQoS object will be added to NetworkProfile entity.
see : [Network QoS - detailed design Implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

#### DB Change

Add network_qos table.
see : [Network QoS - detailed design Implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

#### REST API

Not supported in this version

#### VDSM

libvirt version 1.0.1 or higher is required to enable the QoS feature (vdsm 3.3 will use higher version).

*   Add support of QoS properties in VDSM API: run VM, hot plug and update VM device verbs (update in schema)
*   Add support in the vnic object and the vnic to_xml()

see : [Network QoS - detailed design Implementation details](/develop/release-management/features/network/network-qos-detailed-design.html) for detailed design

### Tests

#### Expected unit-tests

* Unit test for Dao - Unit test for Commands (add/update/remove) - Unit test for query

### Special considerations

### Dependencies / Related Features

*   Dependent on the feature [Vnic Profiles](/develop/release-management/features/sla/vnic-profiles.html)

Affected ovirt projects:

*   API
*   backend
*   Webadmin
*   User Portal

Others projects:

*   vdsm

### Documentation / External references

*   See: <http://libvirt.org/formatdomain.html#elementQoS> for documentation of the VM level network QoS XML.


