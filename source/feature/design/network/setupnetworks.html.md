---
title: SetupNetworks
authors: drankevi, mkolesni, moti, roy, ykaul
wiki_title: Features/Design/Network/SetupNetworks
wiki_revision_count: 45
wiki_last_updated: 2013-11-28
---

# Setup Networks

## 3.1 Network features design

### Abstract

      Setup networks api shall enable complex network provisioning of a host i.e. add/remove/bond network at one call.<
      >
      Hereby we describe code POV changes for backend and also VDSM api implications.

<<TableOfContents(4)>>

#### Scope

While on going discussions on vnlink and USC manager take place, <
> they are out of the api and we're left with trivial operations:

      1. add/remove network
      1. add/remove bonds
      1. attach/detach networks to/from bonds

**added functionality:**

      1. check connectivity & connectivity timeout.
      1. after the new topology layed by VDSM, they test if any client(i.e engine) has interacted with them,  in the given period timeout.<
      >  When no activity seen, they revert to the baked-up topology and fail the command.
      1. force - VDSM will not validate parameters passed to set the network configuration .

#### Backward compatibility

Cluster version is 3.1. Add record in the action_version_map table:

      || action_id || cluster_minimal_version || storage_pool_minimal_version ||
      || 158 || 3.1 || 3.1 ||

#### Setup Networks sequence diagram

#### Added classes

      1. SetupNetworksCommand.java
      1. SetupNetworksVdsCommand.java
      1. SetupNetworksCommandParameters.java
      1. SetupNetworksVdsCommandParameters.java

##### Class Diagram

### Bridge-less Networks

#### Feature summary

      All VMs today are connected through a software bridge, which has naturally performance take.<
      >
      Bridge-less nics can serve for heavy traffic channels like migration, export or the engine management network.<
      >

#### Code Change

      1. Add bridged : boolean to network entity
      1. Add deserialization to bridged field in VdsBrokerObjectsBuilder.java
      1. DB - add field in to vds_interface and vds_interface_view
      1. DAO - add field to VdsInterfaceDao CRUD actions

#### Backward Compatibility

      Its compatibility version is 3.1 and enforced by the enclosed command as mentioned already.
      Bridge-less network shall be edited throw SetupNetworks command only, which will  eventually deprecate add/edit networks commands.

### Jumbo frames

Typically, just another parameter for a network configuration to determine the [MTU](http://en.wikipedia.org/wiki/Maximum_transmission_unit).

#### Code Change

      1. Add MTU : String to network entity
      1. Add deserialization to MTU field in VdsBrokerObjectsBuilder.java. Serialise as String and not Int.
      1. DB - add field in to vds_interface and vds_interface_view
      1. DAO - add field to VdsInterfaceDao CRUD actions

#### Backward Compatibility

      Same as for bridge-less feature.

### VDSM changes

      setupNetworks verb is already implemented upstream:

**`configNetwork.py`**

      The changes we need to communicate are in the "network" structure for bridge and MTU fields

**`network` `business` `entity`**

### GUI

### REST

#### Resource representation

      TODO Ori Liel

### Open issues

      1.input validation: whats the MTU max value? how do we calculate it?
