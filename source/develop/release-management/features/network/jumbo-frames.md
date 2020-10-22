---
title: Jumbo frames
authors: drankevi, ecohen, roy
---

# Jumbo frames

## Summary

Typically, just another parameter for a network configuration to determine the [MTU](http://en.wikipedia.org/wiki/Maximum_transmission_unit).

## Owner

*   Name: Roy Golan
*   Email: rgolan@redhat.com

## definition

[<http://en.wikipedia.org/wiki/Jumbo_frame>| Jumbo frames] (Wikipedia citation): In computer networking, jumbo frames are Ethernet frames with more than 1500 bytes of payload. Conventionally, jumbo frames can carry up to 9000 bytes of payload, but variations exist and some care must be taken when using the term.

## Code Changes

### Model

*   Add MTU : int to both network and VdsNeworkEntity
*   Add deserialization to MTU field in VdsBrokerObjectsBuilder.java. Serialise as String and not Int.
*   DB - add field in to vds_interface,vds_interface_view, network,network_view
*   DAO - add field to VdsInterfaceDao,networkDao CRUD actions
*   DAO - update tests
*   config value - MaxMTU

### BL

*   Create logical network
    -   valid values: 0 - use OS default , 68 - minimum and maximum is configurable (MaxMTU)
    -   mtu is updateable only when the logical network is not attached to a cluster

<!-- -->

*   Add host to newtork via setupnetworks
    -   If network.mtu is 0 then don't send it to VDSM and the OS default will take place

<!-- -->

*   monitoring
    -   fire audit log if a the host reported MTU different than the logical network

### limitations

*   Vlan and non-Vlan networks cannot reside on the same nic although there is an RFE for that

If this limitation is removed we need to validate the MTU for the non-vlan network will allways is the lowest or equals to the the lowest vlan id (again, for networks on the same nic)

### REST API

mtu is a new optional parameter when creating a logical network. Not sending it defaults to 0 which api-wise means "use default value"

Endpoint: **POST** `/api/networks/`

```xml
<action>
  <network>
    <name>....</name>
    <mtu>9000</mtu>
  </network>
</action>
```

### implementation on host

*   The mtu on the bare interface is always the highest common between all pseudo-interfaces (vlan, bridge) on top of it
*   single network bridged mtu 1500

      eth0  mtu=1500
      br0  
       |
      eth0 mtu=1500

*   vlaned bridged mtu 1500 and vlaned non-bridged mtu 9000

      eth0 mtu=9000
      br0  mtu=1500
       |
      eth0.300 mtu=1500  
      eth0.500 mtu=9000

### Messages

*   Audit log

      VDS_SET_NONOPERATIONAL_NETWORK_MTU_DIFFER(605, HOUR)

*   AuditLogMessages.properies

      VDS_SET_NONOPERATIONAL_NETWORK_MTU_DIFFER=MTU on network ${NetworkName} is ${VDS_MTU} and expected to be ${CLUSTER_MTU}

*   Enums.properties

      AuditLogType___VDS_SET_NONOPERATIONAL_NETWORK_MTU_DIFFER=The MTU value of the Host network differs from Cluster

*   Enums.java

      AuditLogType___VDS_SET_NONOPERATIONAL_NETWORK_MTU_DIFFER

## UI

*   MTU is provisioned in logical network UI
*   add checkbox "override MTU" unchecked by default
*   once checked a blank input apears (valid input type is integers)
*   unchecking will clear the input box
*   if no overriden, send 0

![](/images/wiki/MTU_unchecked.png)

![](/images/wiki/MTU_checked.png)

![](/images/wiki/ClusterNetwork.png)

## Backward Compatibility

Same as for bridge-less feature.

The XML returned by VDSM may have or miss the element of "mtu" since this wasn't reported till now.

The code must check for existing elements and then try to deserialize to interface/bond/network entities.

Missing element is ignored for its implicitly regarded as non compatible.
