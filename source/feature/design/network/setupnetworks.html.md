---
title: SetupNetworks
authors: drankevi, mkolesni, moti, roy, ykaul
wiki_title: Features/Design/Network/SetupNetworks
wiki_revision_count: 45
wiki_last_updated: 2013-11-28
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Setup Networks

## Network features design

### Abstract

Setup networks api will enable complex network provisioning of a host i.e. add/remove/bond network with a single call.
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

![File:Diagram1.png](Diagram1.png "File:Diagram1.png")

#### Added classes

1.  SetupNetworksCommand.java
2.  SetupNetworksVdsCommand.java
3.  SetupNetworksCommandParameters.java
4.  SetupNetworksVdsCommandParameters.java

##### Class Diagram

![File:SetupNetworksClassDiagram.png](SetupNetworksClassDiagram.png "File:SetupNetworksClassDiagram.png")

### VDSM changes

**configNetwork.py** `  def setupNetworks(networks={}, bondings={}, **options):`

The changes we need to communicate are in the "network" structure for bridge and MTU fields

**network business entity**

![File:Diagram2.png](Diagram2.png "File:Diagram2.png")

     note:  integer types are serialized to an xml String type on the wire - its up to the VDSM network dict to handle.

### GUI

![File:general.png](general.png "File:general.png") ![File:more_cases.png](more_cases.png "File:more_cases.png")

### UI Alternative Suggestion

I would like to describe a suggestion for a dialog, where the state of the network elements will be described using Blocks and Links.

The Networking Elements here are taken from the RHEV Technical guide: [RHEV Technical Reference Guide](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Technical_Reference_Guide/sect-Technical_Reference_Guide-Network_Architecture-Networking_in_Hosts_and_Virtual_Machines.html)

The UI Blocks describe the following networking elements: (Each element will be represented by a block, with a specific color)

1.  Network Interface Card (NIC) (eth0, eth1)
2.  Bond between two or more network Interfaces (bond01, bond1)
3.  Virtual Network (either bridge or bridgeless)
4.  VLAN on one Virtual Network.

*   Blocks can be connected to each-other by a visible line.
*   The scenarios for connecting block are specified below
*   Dbl-click or Click on each block will open it's setting dialog.
*   A block that can be removed (like a bond, or a VLAN) will have a red X icon.
*   A line can be removed by right clicking on it.
*   Lines will be automatically removed when their connecting elements are deleted.
*   There is a possibility to reconnect lines when they are automatically deleted (when a bond is removed, reconnect the line to one of the unbonded NICs).

#### What cannot be connected

The connection of the following elements will be prevented:

1.  Connecting a Network with no VLAN to a NIC/Bond that is already connected to a Network.
2.  Connecting a Network to a NIC/Bond that is already connected to a Bridgeless Network

#### What can be connected

It will be possible to drag blocks on one another. The following connections are supported:

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Drag Action</th>
<th align="left">Result</th>
<th align="left">Illustration</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Drag a Network on a NIC, Drag a NIC on a Network</td>
<td align="left">Create a connection between the NIC and the Bridge</td>
<td align="left">1-3</td>
</tr>
<tr class="even">
<td align="left">Right-click on the Network?</td>
<td align="left">Create a VLAN on the Logical Network</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">Drag a VLAN/Network on a NIC, Drag a NIC on a VLAN/Network</td>
<td align="left">Create a connection between the NIC and the VLAN</td>
<td align="left">4-6</td>
</tr>
<tr class="even">
<td align="left">Drag an unbonded NIC onto another unbonded NIC</td>
<td align="left">Create a new Bond element for the two NICS</td>
<td align="left">7,8</td>
</tr>
<tr class="odd">
<td align="left">Drag a Bond on a VLAN/Network</td>
<td align="left">Create a connection between the Bond and the VLAN/Network</td>
<td align="left">11</td>
</tr>
</tbody>
</table>

#### Images

------------------------------------------------------------------------

![File:SetupNetworks10.png](SetupNetworks10.png "File:SetupNetworks10.png") ***Illustration 1: No Connections***

------------------------------------------------------------------------

![File:SetupNetworks14.png](SetupNetworks14.png "File:SetupNetworks14.png") ***Illustration 2: Dragging Network on a NIC***

------------------------------------------------------------------------

![File:SetupNetworks1.png](SetupNetworks1.png "File:SetupNetworks1.png") ***Illustration 3: NIC connected to a Network***

------------------------------------------------------------------------

![File:SetupNetworks20.png](SetupNetworks20.png "File:SetupNetworks20.png") ***Illustration 4: Dragging VLAN on a NIC***

------------------------------------------------------------------------

![File:SetupNetworks2.png](SetupNetworks2.png "File:SetupNetworks2.png") ***Illustration 5: VLAN connected to a NIC***

------------------------------------------------------------------------

![File:SetupNetworks21.png](SetupNetworks21.png "File:SetupNetworks21.png") ***Illustration 6: Several VLANs connected to the same NIC***

------------------------------------------------------------------------

![File:SetupNetworks11.png](SetupNetworks11.png "File:SetupNetworks11.png") ***Illustration 7: Dragging a NIC on a nother NIC***

------------------------------------------------------------------------

![File:SetupNetworks7.png](SetupNetworks7.png "File:SetupNetworks7.png") ***Illustration 8: Bonded NICs***

------------------------------------------------------------------------

![File:SetupNetworks6.png](SetupNetworks6.png "File:SetupNetworks6.png") ***Illustration 9: Network dragged on a Bond***

------------------------------------------------------------------------

![File:SetupNetworks5.png](SetupNetworks5.png "File:SetupNetworks5.png") ***Illustration 10: Network connected to a Bond***

------------------------------------------------------------------------

![File:SetupNetworks17.png](SetupNetworks17.png "File:SetupNetworks17.png") ***Illustration 11: Several VLANs connected to the same Bond***

### REST

#### Resource representation

     TODO Ori Liel

### Open issues

1.  input validation: whats the MTU max value? how do we calculate it?

A (ykaul): You don't know what the MTU max value is. Theoretically, around 9000 bytes, perhaps 9216 in some cases. Practically, some interfaces may support less, some may (in the future?) support more. The max. frame size is vendor-dependent. I wouldn't bother with limiting it. Note also that since it's interface specific (hw+firmware+driver), no validation would really work apart from setting it up for real and hoping for an error code if it's not supported.
