---
title: Bridgeless Networks
category: feature
authors: adrian15, danken, roy, ykaul
wiki_category: Feature
wiki_title: Features/Design/Network/Bridgeless Networks
wiki_revision_count: 33
wiki_last_updated: 2013-01-29
---

# Bridgeless Networks

## Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: rgolan@redhat.com

## Functionality

An admin can now set a logical network as "VM network" so when attaching a Network to an Host's NIC,
a "Vm network" is implemented over a bridge, otherwise bridgeless

## create logical network

*   create network under the DC - check the "VM network" box.
*   GUI may have the VM network box checked by default
*   to edit this property a network should be detached from all clusters

## Modified flows

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

*   refresh caps (when host is activated)- detect if there are VM networks that are implemented as bridgeless - if yes set host non-operational with reason VM_NETWORK_IS_BRIDGELESS
*   afterRefreshTreatment (runtime info) - same as above

## Modelling

#### Entities

*   VdsNetworkInterface.java

      VdsNetworkInterface
       bridged : boolean

*   vds_interface table

      vds_interface
       bridged BOOLEAN NOT NULL DEFAULT true

*   network.java

      vmNetwork : boolean

*   network table

      vm_network BOOLEAN NOT NULL DEFAULT true

## Enums

*   AuditLogType.java

       IMPORTEXPORT_IMPORT_VM_INTERFACES_ON_NON_VM_NETWORKS(9600,MINUTE)
      VDS_SET_NON_OPERATIONAL_VM_NETWORK_IS_BRIDGELESS(9601, MINUTE)

*   VdcBLLMessages

      ACTION_TYPE_FAILED_NOT_A_VM_NETWORK

*   NonOperationalReason.java

      VM_NETWORK_IS_BRIDGELESS(8)

## Messages

*   AuditLogMessage.properties

      IMPORTEXPORT_IMPORT_VM_INTERFACES_ON_NON_VM_NETWORKS=Trying to import VM ${VmName} with the interface/s ${Interfaces} attached to non VM network/s ${Networks}.
      VDS_SET_NON_OPERATIONAL_VM_NETWORK_IS_BRIDGELESS=Host ${VdsName} does not comply with the cluster ${VdsGroupName} networks, the following VM networks are bridgeless: '${Networks}'

*   AppErrors.properties

      ACTION_TYPE_FAILED_NOT_A_VM_NETWORK=Failed ${action} ${type} the network/s ${Networks} is/are not a VM network.
