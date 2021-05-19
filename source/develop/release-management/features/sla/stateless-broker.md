---
title: Stateless Hosted Engine broker
category: feature
authors: dchaplyg
---

# Stateless Hosted Engine broker

**Stateless Hosted Engine broker**

## Summary

Replacing custom made agent-broker RPC implementation with python's standard xmlrpc

## Owners

#### Initial design and implementation

*   Name: Denis Chaplygin (dchaplyg)

#### Maintainers

*   Name: Denis Chaplygin (dchaplyg)
*   Name: Martin Sivak (msivak) msivak@redhat.com

## Current status

*   Target Release: 4.2
*   Status: Done
*   Last updated: December 11, 2017

## Detailed Description

With Hosted Engine operation expirience we realized, that some planned features was neither ever used nor even implemented. One of those features is ability of
the engine to handle several storage domains for several agents. 

Special stateful agent-broker RPC protocol was developed to enable those abilities. Unfortunately, it is useless now and hard to maintain. Problems with
maintaining and extension result to moving part ob broker's job to the agent.

Therefore, as most part of that functionality is not needed, we can get rid of multi-agent support and custom RPC protocol. To do that we need:

1. Make broker stateless, i.e. support just a single agent/storage. We need to replace `_backends` array with a single `backend` var in StorageBroker and remove mandatory `client` parameter. Same applies to the ConnectioHanlder calss: we do not need to keep client id in the handler's thread and do not need to pass it to the StorageBroker methods anymore. On the other hand, we still need to set storage info in a first call after connection.
2. Enable broker to get storage information from config on start up. Biggest part of the `_initialize_broker` code should be moved from agetn to StorageBroker.__init__ Broker should be able to read storage information from the hosted-engine config on startup and prepare itself accordingly. `set_storage_domain` call and `cleanup` calls should be removed.
3. Cleanup storage backend code - removal of `BlockStorageBackend` class
4. Refactoring `ConnectionHandler.dispatch` - as we don't need client information anymore, we can split large `dispatch` functions in to a set of small functions and call them using a dict.
5. Replace custom RPC with standard xmlrpc. `BrokerLink` classes and `ConnectionHandler` classes should be replaced with wrappers over python's standard xmlrpc
6. Remove broker initialization code. Broker is stateless now, so we do not need to establish and keep connection to it, neither from agent nor from the vdsm. We can throw away `_initialize_broker` function and remove it from the monitoring loop. Broker reconnection code should also be removed.

## Benefit to oVirt

Less code - less errors. Standard module is well tested and it is easier to suport code based on it. We will also move some heavy stuff from agent to broker, making agent react faster.

