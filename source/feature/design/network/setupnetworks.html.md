---
title: SetupNetworks
authors: drankevi, mkolesni, moti, roy, ykaul
wiki_title: Features/Design/Network/SetupNetworks
wiki_revision_count: 45
wiki_last_updated: 2013-11-28
---

# Setup Networks

## Network features design

### Abstract

Setup networks api shall enable complex network provisioning of a host i.e. add/remove/bond network with one call.
Hereby we describe code POV changes for Engine as well as VDSM API implications.

#### Scope

1.  add/remove network/s
2.  add/remove bond/s
3.  attach/detach networks to/from bonds
4.  **check connectivity & connectivity timeout:**

    after the new topology layed by VDSM, it tests if any client(i.e engine) has interacted with it in a given period timeout.
     When no activity seen, it reverts to the previously backed-up topology and fail the command.

5.  **force:** VDSM will not validate parameters passed to set the network configuration.

#### Backward compatibility

Cluster version is 3.1. Add record in the action_version_map table:

| action_id | cluster_minimal_version | storage_pool_minimal_version |
|------------|---------------------------|---------------------------------|
| 158        | 3.1                       | 3.1                             |

#### Setup Networks sequence diagram

![](Diagram1.png "Diagram1.png")

#### Added classes

1.  SetupNetworksCommand.java
2.  SetupNetworksVdsCommand.java
3.  SetupNetworksCommandParameters.java
4.  SetupNetworksVdsCommandParameters.java

##### Class Diagram

![](SetupNetworksClassDiagram.png "SetupNetworksClassDiagram.png")

### Bridge-less Networks

#### Feature summary

All VMs today are connected through a software bridge, which naturally has a performance hit.
Bridge-less NICs can serve for heavy traffic channels like migration, storage or the engine's management network.

#### Code Change

1.  Add bridged : boolean to network entity
2.  Add deserialization to bridged field in VdsBrokerObjectsBuilder.java
3.  DB - add field in to network and network_view
4.  DAO - add field to NetworkDao CRUD actions

#### Backward Compatibility

Its compatibility version is 3.1 and enforced by the enclosed command as mentioned already. Bridge-less network will be edited via the SetupNetworks command only, which will eventually deprecate add/edit networks commands.

### Jumbo frames

Typically, just another parameter for a network configuration to determine the [MTU](http://en.wikipedia.org/wiki/Maximum_transmission_unit).

#### Code Change

1.  Add MTU : String to network entity
2.  Add deserialization to MTU field in VdsBrokerObjectsBuilder.java. Serialise as String and not Int.
3.  DB - add field in to vds_interface and vds_interface_view
4.  DAO - add field to VdsInterfaceDao CRUD actions

#### Backward Compatibility

Same as for bridge-less feature.

### VDSM changes

**configNetwork.py** `
 def setupNetworks(networks={}, bondings={}, **options):
`

The changes we need to communicate are in the "network" structure for bridge and MTU fields

**network business entity**

![](Diagram2.png "Diagram2.png")

<span style="color:red">**`note:`**` `</span>` integer types are serialized to an xml String type on the wire - its up to the VDSM network dict to handle.`

### GUI

![](general.png "fig:general.png") ![](more_cases.png "fig:more_cases.png")

### REST

#### Resource representation

      TODO Ori Liel

### Open issues

1.  input validation: whats the MTU max value? how do we calculate it?

A (ykaul): You don't know what the MTU max value is. Theoretically, around 9000 bytes, perhaps 9216 in some cases. Practically, some interfaces may support less, some may (in the future?) support more. The max. frame size is vendor-dependent. I wouldn't bother with limiting it. Note also that since it's interface specific (hw+firmware+driver), no validation would really work apart from setting it up for real and hoping for an error code if it's not supported.
