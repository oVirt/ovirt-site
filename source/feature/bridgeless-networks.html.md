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

All VMs today are connected through a software bridge, which naturally has a performance hit.
Bridge-less NICs can serve for heavy traffic channels like migration, storage or the engine's management network.

A logical network shell have a property indicating it could run VM on it ,e.i it should be bridged on regular nics and un-bridged in case of dedicated special nics [1]

### Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: rgolan@redhat.com

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
and deduce that cluster compatibility didn't break [2] if, for some reason an admin wants a non VM network to be bridged, should we allow it?
