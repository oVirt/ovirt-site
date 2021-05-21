---
title: Bridgeless Networks
category: feature
authors:
  - adrian15
  - danken
  - roy
  - ykaul
---

# Bridgeless Networks

## Owner

*   Name: Roy Golan

*   Email: rgolan@redhat.com

## Functionality

An admin can now set a logical network as "VM network" so when attaching a Network to an Host's NIC,
a "VM network" is implemented over a bridge, otherwise bridgeless
If a host network is bridgeless but should be a VM network the host will be set to non-operational state.

Also, A cluster network can be set as "optional", meaning that host is operational as long as it have
all the non-optional networks attached.

## create logical network

*   create network under the DC - check the "VM network" box.
*   GUI may have the VM network box checked by default
*   to edit this property a network should be detached from all clusters

## Modified flows

#### Create management network

*   management network is always created as optional=false

#### Add a Nic to VM

*   validate the Nic's network is vmNetwork - fail with canDoAction ACTION_TYPE_FAILED_NOT_A_VM_NETWORK

#### Import VM

*   validate all Nic's networks are vmNetwork - fire audit log IMPORT_VM_INTERFACES_ON_NON_VM_NETWORKS
*   don't fail the import

#### Run VM

*   validate all Nic's networks is vmNetwork - fail with canDoAction ACTION_TYPE_FAILED_NOT_A_VM_NETWORK

#### setupNetworks

*   implicitly set VdsNetworkInterface as bridged when vmNetwork = true

#### Monitoring

*   refresh caps (when host is activated)-
    -   detect if there are VM networks that are implemented as bridgeless - if yes set host non-operational with reason VM_NETWORK_IS_BRIDGELESS
    -   if a host misses cluster networks which are not optional - set as non -operational
*   afterRefreshTreatment (runtime info) - same as above

#### REST API

*   Add a logical network to the Data Center and make it a VM network

      `POST /api/networks`
      
```xml
<network id='...'>
    <name>testrest1</name>
    <data_center id='...'/>
    <stp>false</stp>
    <usages>
        <usage>VM`</usage>
    </usage>
</network>
```
*   representation of non-bridged interface in Host NICs

      `GET /api/hosts/{host.id}/nics/{nic.id}`

```xml
<host_nic>
    <name>MyHostNIC</name>
    <bridged>false</bridged>
</host_nic>
```

#### Entities

*   VdsNetworkInterface.java

      VdsNetworkInterface
       boolean bridged

*   vds_interface table

      vds_interface
       bridged BOOLEAN NOT NULL DEFAULT true

*   network.java

      boolean vmNetwork

*   network table

      vm_network BOOLEAN NOT NULL DEFAULT true

*   network_cluster.java

      boolean optional

*   network_cluster table

      optional BOOLEAN

## Modelling

## Enums

*   AuditLogType.java

      IMPORTEXPORT_IMPORT_VM_INTERFACES_ON_NON_VM_NETWORKS(9600,MINUTE)
      VDS_SET_NON_OPERATIONAL_VM_NETWORK_IS_BRIDGELESS(9601, MINUTE)

*   VdcBLLMessages

      ACTION_TYPE_FAILED_NOT_A_VM_NETWORK

*   NonOperationalReason.java

      VM_NETWORK_IS_BRIDGELESS(8)

## Messages

*   AuditLogMessage.properties

      IMPORTEXPORT_IMPORT_VM_INTERFACES_ON_NON_VM_NETWORKS=Trying to import VM ${VmName} with the interface/s ${Interfaces} attached to non VM network/s ${Networks}.
      VDS_SET_NON_OPERATIONAL_VM_NETWORK_IS_BRIDGELESS=Host ${VdsName} does not comply with the cluster ${VdsGroupName} networks, the following VM networks are bridgeless: '${Networks}'

*   AppErrors.properties

      ACTION_TYPE_FAILED_NOT_A_VM_NETWORK=Failed ${action} ${type} the network/s ${Networks} is/are not a VM network.

