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

### Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: rgolan@redhat.com

### Code Changes

#### Model

1.  Add bridged : String to network, VdsNetworkInterface entity
2.  Add deserialization to bridged field in VdsBrokerObjectsBuilder.java
3.  DB - add field in to vds_interface,vds_interface_view, network,network_view
4.  DAO - add field to VdsInterfaceDao,networkDao CRUD actions
5.  DAO - update tests

#### BL

1.  extend non-operational API to accept more reasons
2.  remove redundant checking in monitoring code - same check for missing
3.  add tests for the API refactoring network in CollectVdsNetworkData and VdsManager
4.  refactor VdsManager to send the host to non-oper on bridge property difference with Cluster
5.  add tests to VdsManager for the new behaviour

### Backward Compatibility

Its compatibility version is 3.1 and enforced by the enclosed command as mentioned already. Bridge-less network will be edited via the SetupNetworks command only, which will eventually deprecate add/edit networks commands.
