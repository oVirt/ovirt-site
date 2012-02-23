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

An admin can now set a bridge/bridge less property on the Host Interface per specific Network.
When attaching a Network to an Host's NIC, user can define the bridge/bridgeless property using setupNetworks.
This implies that a given cluster may have one host implementing
network "pink" as bridged and another implementing it as bridge-less.

## Basic flow

*   attach a network as bridged or bridge-less
    The setupNetworks API shall enable setting the network as bridged or not, default to bridged.

REST examples:

*   bridge network red , vlan id 300, over a bond4

      application/yaml
       host_nics:
       - host_nic:
          name: bond4.300
          vlan_id: 300
          network_name: red
          bridged: true  

*   create bridgeless storage network on vlan 400 over eth5:0 (eth5:0 is an alias of eth5)

      application/yaml
      host_nics:
      - host_nic:
          name: eth5:0.400
          vlan_id: 400
          network_name: storage
          bridged: false

## Modified flows

#### Add a Nic to VM

*   validate the Nic's network is bridged on all running host in the cluster - fail with canDoAction

#### Import VM

*   validate each vm interface (either it is plugged or unplugged) is attached to a network that is bridged on all running host in the cluster - fire audit log when not.
*   don't fail the import

#### Run VM

*   validate each vm interface is attached to a network that is bridged on all running host in the cluster - fail with canDoAction

#### Un-bridge a host network via setupNetworks

*   validate that this network doesn't have any VMs running on it. otherwise this host
     will not be able to have VMs migrated to it and will be set to non-operational during monitoring.

#### Monitoring

*   when performing refresh capabilities during a host startup update the vdsInterface bridged flag.
*   if the "bridged" is changed from true to false, make sure the rest of the cluster's hosts have this network bridge-less as well
     if not, set to non-operational with reason NETWORK_IS_NOT_BRIDGED_ON_VDS

## Modelling

#### Entities

A bridged network is represented in VdsInterface.java and vds_interface table and is set using setupNetworks action.

<b>note:</b> there is no notion of bridged network on <b>network</b> and <b>network_cluster</b> entities. Its an implementation detail of the host.

*   VdsNetworkInterface.java

      VdsNetworkInterface
       bridged : boolean

*   vds_interface table

      vds_interface
       bridged BOOLEAN

#### stored procedures

*   **getHostsIdsWithBridgedNetwork** - get the ids of host interfaces with a given network that are bridged

      v_cluster_id
      v_network_name
      SELECT nic.vds_id FROM vds_interface as nic, network as net
      WHERE
      nic.network_name = net.name
      AND
      nic.bridged = true 
      AND
      nic.vds_id in (select vds_id FROM vds_static as vds WHERE vds.vsd_group_id = v_cluster_id )

*   **isNetworkBridgedOnRunningClusterHosts** - use the getHostsIdsWithBridgedNetwork procedure and check at least one host is running

      v_cluster_id
      v_network_name
      SELECT count(*) FROM vds 
      WHERE
      vds.status = 3 
      AND
      vds.id in (SELECT get_hosts_ids_with_bridged_network(v_cluster_id, v_network_name)) > 0 as value

*   **isVmsRunningOnClusterNetwork** - are there any running vms using the given network?

      v_cluster_id
      v_network_name
      return 
      SELECT count(*) FROM vms, vm_interface_view as ifaceView 
      WHERE
      vms.vds_group_id = v_cluster_id 
      AND
      vm.status = 1 // status up
      AND
      ifaceView.vm_id = vm.id
      AND
      ifaceView.network_name = v_network_name 
      > 0 as value

## Enums

*   AuditLogType.java

      VDS_NETWORK_IS_NOT_BRIDGED(9600,MINUTE)

*   NonOperationlreason.java

      NETWORK_IS_NOT_BRIDGED_ON_VDS

*   VdcBLLMessages

      CANNOT_UNBRIDGE_VDS_NETWORK_WITH_RUNNING_VMS

## Messages

*   AuditLogMessage.properties

      VDS_NETWORK_IS_NOT_BRIDGED=The network ${networkName} on Host ${vds} should be bridged otherwise it could not run virtual interfaces.

*   AppErrors.properties

      CANNOT_UNBRIDGE_NETWORK_WITH_RUNNING_VMS=the network ${networkName} cannot be bridgeless. Other hosts are running VMs on it.
