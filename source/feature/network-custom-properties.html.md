---
title: Network Custom Properties
category: feature
authors: apuimedo, danken, lvernia, sandrobonazzola
wiki_category: Feature
wiki_title: Features/Network Custom Properties
wiki_revision_count: 37
wiki_last_updated: 2014-09-24
feature_name: Network Custom Properties
feature_modules: engine,network,vdsm
feature_status: To be Released
---

# Network Custom Properties

### Summary

Define special parameters per network, and pass them down to Vdsm hooks when the network is set up on a host.

### Owner

*   Name: [ Lior Vernia](User:lvernia)
*   Email: <lvernia@redhat.com>
*   IRC: lvernia at #ovirt (irc.oftc.net)

### Current Status

*   To be proposed to oVirt-3.5
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

This feature affects the **setupNetwork** Vdsm verbs. setupNetwork accepts an **options** dictionary of type @SetupNetworkOptions beyond the dictionaries describing networks and bonds to be set up. A new optional key "custom" would be added to SetupNetworkOptions. Its value is a dictionary of custom properties and their string value. E.g. based on one of the usages described below:

    {'storagenet':
        {'bonding': {'bond0', 'vlan': '10', 'bootproto': 'dhcp',
                     'custom': {'ethtool_opts': '--offload em2 rx on --offload em1 tx on'}}}

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

### Usages

This section describes features that use the infrastructure above.

#### Ethtool options

This feature provides a way for the administrator to specify ethtool options for oVirt-defined networks.

##### Benefit to oVirt

Having a simple way for the network administrator to set ethtool options for the oVirt defined networks will allow oVirt to cover a wider range of configurations and tweakings that can make managing a datacenter network a much more enjoyable experience.

Up until now, oVirt used to persist its network configuration in Fedora/EL specific files handled by the initscripts package. These files, known as ifcfg, contained a series of shell definitions that were read and applied by the ifup-eth executable. oVirt auto-generates and writes these ifcfg files and as such, if the network admin wanted to tweak the ETHTOOL_OPTS definition that precluded the continued care-free modification of the network, as some of the configuration would be living only in the hypervisor node and would not be exposed to oVirt for persistence.

##### User experience

With the proposed solution, ethtool options will be a property that can be set per logical network as well as be defined on the assignment of a network on a physical device, just like ip addressing.

![](ethtool_networks.png "ethtool_networks.png")

Above you can see that in the networks tab, in the dialog for creating a new logical network, it is possible to define custom network properties, one of which will be ethtool options. These ethtool options will apply to any assignment of the network to a NIC on a host unless overridden as in the next two images.

![](Override_setupNetworks.png "fig:Override_setupNetworks.png") ![](Override setupNetworks 01.png "fig:Override setupNetworks 01.png")

When assigning a network to a NIC it will be possible to click on "edit" (icon marked in red in the first of these two images) and:

*   Add new ethtool opts,
*   Edit the ethtool opts defined at the logical level,
*   Remove any ethtool configuration.

##### Ethtool options format

The proposed format is just the command line ethtool syntax

    --coalesce ethX rx-usecs 14 sample_interval 3 --offload ethX rx on lroon tcp-segmentation-offload off --change ethX speed 1000 duplex half 

If the property is being set on a bond, the user should make sure to specify the proper ethX/ethY/ethZ for each of the bond's nics that ethtool options should be set for. E.g., we have a bond with em1 and em2 and em2 should offload only rx and em1 only tx:

    --offload em2 rx on --offload em1 tx on

In the bonding case, the UI/Engine/vdsm code may want to check that there is no reference to a NIC that isn't enslaved to the bond.

##### Testing

To test this feature the tester should:

*   set up ethtool options at the logical level, assign the network to a nic and use the cli tool ethtool to check that the options are properly applied to the NIC.
*   Override (editing or removing) the ethtool options set at the logical level and see, like in the previous step that the options are properly applied to the NIC.
*   Define at the network assignment level ethtool options for a network with no ethtool options at the logical level and see that they are properly applied to the NIC.

#### Bridge options

### Documentation / External references

*   TBD

### Comments and Discussion

*   Refer to [Talk:Network Custom Properties](Talk:Network Custom Properties)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
