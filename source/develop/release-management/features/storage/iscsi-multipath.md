---
title: iSCSI-Multipath
category: feature
authors:
  - mlipchuk
  - sandrobonazzola
  - sgotliv
---

# iSCSI Multipath

## Configure iSCSI Multipathing

### Summary

Multipathing is a technique whereby there is more than one physical path between the server and the storage. This is a fault tolerant because in the case of a single path failure the operating system can route I/O through the remaining paths transparently to the application. In addition to path failover, multipathing provides load balancing by distributing I/O loads across multiple physical paths. This approach can reduce or remove potential bottlenecks.

Up until now the iSCSI connection between the Host and the iSCSI Storage Domain is being done using only one "default" physical path. In case of a failure of any element in that path, such as an adapter, switch or cable the storage can't be reached from the Host which immediately becomes a non operational. Another problem is that VDSM can't actually control which path to use in order to establish connection to the storage so there is a possibility that storage traffic is routed through the busy management network.

### Owner

*   Maor Lipchuk mlipchuk@redhat.com
*   Sergey Gotliv sgotliv@redhat.com

### Current status

*   Merged to 3.4 branch

### Detailed Description

This feature introduces a new managed entity, iSCSI Bond which groups networks and storage targets reachable via these networks.
User can configure an iSCSI Bond under the Data Center that contains at least one iSCSI Storage Domain.
The User selects logical networks and iSCSI targets.
The iSCSI bond must contain at least one logical network related to the Data Center.
Once the iSCSI multipathing is configured, all hosts in the Data Center will be connected to the selected iSCSI targets through the selected iSCSI networks.

### Permissions

Every user with permissions on the Data Center, can add/edit or remove the iSCSI Bond.

### iSCSI Bond behaviour

*   Each Data Center with iSCSI storage can have one or more iSCSI Bonds. The iSCSI bond is not obligated in the Data Center.
*   Each iSCSI bond can be configured with any of the networks configured in the Data Center.
*   iSCSI Bond name should be a unique name in the Data Center.
*   Once a network is being removed from a Data Center it should be automatically removed from the iSCSI Bond as well.
*   Once a Data Center is being removed all the iSCSI Bonds related to it should be removed as well.
*   Once a network is being added to the iSCSI Bond, all hosts are reconnected to the iSCSI targets related to the same Bond through all related networks including the newly added.
*   Once a host gets activated in the iSCSI Data Center it should connect to all available iSCSI targets with all the networks available in the iSCSI Bond
*   If the Host does not contain any of the networks configured in the iSCSI bond it should connect to the storage iSCSI with its default network
*   If the Host does contain the networks configured in the iSCSI bond and it does not succeed to connect to the iSCSI storage with them then the Host should become non operational.

### User Experience

For the user to start using the iSCSI bond, it will need to do the following:

1.  Add an iSCSI Storage to the Data Center
2.  Make sure the Data Center contains networks.
3.  Go to the Data Center main tab and choose the specific Data Center
4.  At the sub tab choose "iSCSI Multipathing"
5.  Press the "new" button to add a new iSCSI Bond
6.  Configure the networks you want to add to the new iSCSI Bond.

Once a new iSCSI bond is configured, The Hosts in the Data Center connects to the iSCSI storage using the networks configured in the bond.

### REST

**Creating a new iSCSI Bond:**

```xml
Method: POST
URL: /api/datacenters/{datacenter_id}/iscsibonds
HTTP/1.1
Content-type: application/xml
Body:

<iscsi_bond>
 <name>fromRest</name>
 <storage_connections>
  <storage_connection id={storageconnection_id} />
      ....
 </storage_connections>
 <networks>
  <network id={network_id} />
      ....
 </networks>
</iscsi_bond>
```

**Updating an iSCSI Bond, only name and description can be editing that way:**

```xml
Method: PUT
URL: /api/datacenters/{datacenter_id}/iscsibonds/{iscsibond_id}
HTTP/1.1
Content-type: application/xml
Body:

<iscsi_bond>
 <name>fromRest</name>
 <description>myDescription</description>
</iscsi_bond>
```

**Removing an iSCSI Bond:**

```xml
Method: DELETE
URL: /api/datacenters/{datacenter_id}/iscsibonds/{iscsibond_id}
HTTP/1.1
```

**Getting all iSCSI Bonds for the specified data center:**

```xml
Method: GET
URL: /api/datacenters/{datacenter_id}/iscsibonds HTTP/1.1
Content-type: application/xml
```

**Get a list of Storage Connections contained in the iSCSI bond:**

```xml
Method: Get
URL: /api/datacenters/{datacenter_id}/iscsibonds/{iscsibond_id}/storageconnections/
```

**Get a specific Storage Connection in the iSCSI bond:**

```xml
Method: Get
URL: /api/datacenters/{datacenter_id}/iscsibonds/{iscsibond_id}/storageconnections/{storage_id}/
```

**Adding a new Storage Connection to an existing iSCSI Bond:**

```xml
Method: POST
URL: /api/datacenters/{datacenter_id}/iscsibonds
HTTP/1.1
Accept: application/xml
Body:

<storage_connection id="{connection_id}"></storage_connection>

```

**Remove a Storage Connection from the existing iSCSi Bond:**

```xml
Method: DELETE
/api/datacenters/{datacenter_id}/iscsibonds/{iscsibond_id}/storageconnections/{storage_id}/
HTTP/1.1
```
