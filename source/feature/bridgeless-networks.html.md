---
title: Bridgeless Networks
category: feature
authors: adrian15, danken, roy, ykaul
wiki_category: Feature
wiki_title: Features/Design/Network/Bridgeless Networks
wiki_revision_count: 33
wiki_last_updated: 2013-01-29
---

# Bridge-less Networks

### Summary

Today by default every network is created with a software bridge,which is used to connect virtualized nics to a VM on top of it.
A bridg-less network will be a network created without that bridge and targeted to be attached on top of vNic or SRIOV nics
or for heavy traffic channels like migration, storage or the engine's management network i.e

### Benefit for oVirt

Networks will have better performance (no bridging overhead).

### Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: rgolan@redhat.com

### Basic Flow

#### create a bridgeless network

1.  Add a logical network to your DC ( DC tab for GUI or /api/datacenters/network - set the property "Allow to run VMs" to false
2.  Attach the network to your hosts in the new setupnetworks UI - attach a network to the target interface and uncheck the box "bridged" .
     in REST use the /api/hosts/XXX/nics/setupnetwork and specify the <bridged>false</bridged> on the target eth

* when the network "Allow to run VMs" is true the bridging option should be set automatically by the engine according to the interface type?

#### edit a bridged network to become unbridged

1.  a network with the flag "Allow to run VMs" set to false but the nic still was attached as bridged.
2.  attach the nic as uncheck the "bridged" option as described in the create flow above

#### monitoring

      Host monitoring pseudo-code
      logical network is defined as able to run VMs AND Host network is bridgeless {
       if iface type != SRIOV or VnLink
       set host to NON OPERATIONAL (REASON: network can't run VMs)
      }

### Code Changes

#### Model

1.  Add bridged : boolean VdsNetworkInterface entity
2.  Add allowToRunVms : boolean network entity

<!-- -->

1.  Add deserialization to bridged field in VdsBrokerObjectsBuilder.java
2.  DB - add field in to vds_interface,vds_interface_view, network,network_view
3.  DAO - add field to VdsInterfaceDao,networkDao CRUD actions
4.  DAO - update tests

#### BL

1.  extend non-operational API to accept more reasons
2.  remove redundant checking in monitoring code - same check for missing
3.  add tests for the API refactoring network in CollectVdsNetworkData and VdsManager
4.  refactor VdsManager to send the host to non-oper on bridge property difference with Cluster "allowToRunVms" property [1]
5.  add tests to VdsManager for the new behaviour

#### UI

1.  UI shall append the "allow to run VMs []" checkbox to the add/edit logical network
2.  UI shall user shall be able to attach the network as bridged/non-bridged network when "allowToRunVms" is false, in setup-networks UI [2]

##### sketches/mocks

TODO drankevi

### Backward Compatibility

Its compatibility version is 3.1 and enforced by the enclosed command as mentioned already. Bridge-less network will be edited via the SetupNetworks command only, which will eventually deprecate add/edit networks commands.

### open issues

[1] if a network is checked with "allowToRunVms" and an underlying host will need an un-bridged(SRIOV...) network to fulfil that
how do we treat that during monitoring? we should be able to distinguish on interfaces that can run vm with/without bridge
and deduce that cluster compatibility didn't break
[2] if, for some reason an admin wants a non VM network to be bridged, should we allow it?

<Category:Feature>
