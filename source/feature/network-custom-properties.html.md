---
title: Network Custom Properties
category: feature
authors: apuimedo, danken, lvernia, sandrobonazzola
wiki_category: Feature
wiki_title: Features/Network Custom Properties
wiki_revision_count: 37
wiki_last_updated: 2014-09-24
---

# Network Custom Properties

### Summary

Define special parameters per network, and pass them down to Vdsm hooks when the network is set up on a host.

### Owner

*   Name: [ Dan Kenigsberg](User:Danken)
*   Email: <danken@redhat.com>
*   IRC: danken at #ovirt (irc.oftc.net)

### Current Status

*   To be proposed to oVirt-3.4
*   Last updated: ,

### Detailed Description

Just like we can define VM-wide and vNIC-profile-specific custom properties, we would like to set per-network ones. This would allow users to pass special parameters to tweak the way by which Vdsm sets up a network on a host.

### Benefit to oVirt

oVirt currently supports a limited set of network topologies: an optional bridge, connected via an optional vlan device to a host NIC or a bonding device.

Users want to allow funkier types of connection, or tighter control on the created devices:

*   Create a host nic (via Mellanox UFM) to implement a storage network.
*   Set special options on host nic (via ethtool)
*   Replace the Engine-specified nic with a dummy device, to implement VM-only network.

These extensions, and many others, can be made available by allowing per-network custom properties. Network custom properties are just like VM-wide device-specific ones, only that they are attached to a specific network, and can take effect when the network is set up.

### User Experience

The Setup Network dialog would have a list of custom properties, to be set by the network administrator.

### Implementation

##### Vdsm

This feature affects the **setupNetwork** Vdsm verbs. setupNetwork accepts an **options** dictionary of type @SetupNetworkOptions beyond the dictionaries describing networks and bonds to be set up. A new optional key "custom" would be added to SetupNetworkOptions. Its value is a dictionary of custom properties and their string value.

Vdsm would pass the network definition and their custom properties to setupNetwork's hook scripts.

In setupNetwork hooks scripts, the properties would be passed as environment variables of the hook scripts being executed.

##### Dependencies / Related Features

With this feature, Engine would keep track of per-network custom properties.

We will insert a custom properties column into the networks table.

##### Configuration

TBD

##### CRUD

TBD

##### Business Entities

TBD

##### DAOs

TBD

##### Business Logic

TBD

##### VdsBroker

Update the setupNetwork VdsBroker commands to pass the custom properties into the options dictionary.

##### REST

Add a custom_properties field to api.xsd for networks: <custom_properties>
<custom_property value="wol m" name="eth_opts"/>
<custom_property value="host-local" name="true"/>
</custom_properties>

##### Backwards Compatibility

As this is a 3.4 feature, all 3.3 (and down) cluster related entities should not be allowed (at the GUI level) to customize network properties. Engine needs to take special care at canDoAction to disallow custom network properties for 3.3 and below.

### Testing

*   Use the engine-config tool to insert the property {'hostonly': 'True'} to networks. Specify the regex on the 'hostonly' property to 'True|False'.
*   Verify that the properties were inserted into the DB
*   From the Engine, define a network and set the 'hostonly' property (Make sure the cluster level is 3.4+)
*   [Create a new VDSM hook](Vdsm_Hooks) that occurs during before (and after) setupNetwork that prints the value for the 'hostonly' environment variabls, and the network definition that the hook received.
*   Verify that 'True' is printed.

### Documentation / External references

*   TBD

### Comments and Discussion

*   Refer to [Talk:Network Custom Properties](Talk:Network Custom Properties)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
