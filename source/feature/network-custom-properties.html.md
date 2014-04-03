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

### Detailed Description

Just like we can define VM-wide and vNIC-profile-specific custom properties, we would like to set per-network ones. This would allow users to pass special parameters to tweak the way by which Vdsm sets up a network on a host. Preset property keys will exist for bridge options and for ethtool options.

It should be noted that ethtool options do not really belong to the properties of a network, but rather to those of an interface. However, implementation-wise it would be simpler to include them as part of network custom properties. This might be remedied in the future, if it turns out to be too confusing for users.

### Benefit to oVirt

oVirt currently supports a limited set of network topologies: an optional bridge, connected via an optional vlan device to a host NIC or a bonding device.

Users want to allow funkier types of connection, or tighter control on the created devices:

*   Create a host nic (via Mellanox UFM) to implement a storage network.
*   Set special options on host nic (via ethtool)
*   Replace the Engine-specified nic with a dummy device, to implement VM-only network.

These extensions, and many others, can be made available by allowing per-network custom properties. Network custom properties are just like VM-wide device-specific ones, only that they are attached to a specific network, and can take effect when the network is set up.

### User Experience

The Setup Network dialog would have a list of custom properties for each assigned network (similarly to boot protocol and IP address configuration), to be set by the network administrator.

![](Override_setupNetworks.png "fig:Override_setupNetworks.png") ![](Override setupNetworks 01.png "fig:Override setupNetworks 01.png")

When assigning a network to a NIC it will be possible to click on "edit" (icon marked in red in the first of these two images) and:

*   Add new custom properties,
*   Edit the existing custom properties,
*   Remove any custom properties.

Note that preset custom property keys will exist for ethtool options (shown) and bridge options.

OPTIONAL: As part of the feature it might be a good idea to allow setting custom properties per logical network (on the DC level), and not only on the assignment of a network on a physical device. These custom properties on the logical network will serve as a "mold", to be used by default when assigning the network to a device.

![](ethtool_networks.png "ethtool_networks.png")

Above you can see that in the networks tab, in the dialog for creating a new logical network, it is possible to define custom network properties, which will include ethtool options (shown) and bridge options by default. These custom properties will be applied upon any assignment of the network to a NIC on a host, unless overridden as described before.

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

This feature provides a way for the network administrator to easily set options for the bridges which implement VM networks.

##### Benefit to oVirt

Having a simple way for the network administrator to set bridge options for the oVirt defined VM networks will allow oVirt to cover a wider range of configurations and fine tuning that will make oVirt networking a better fit for very tightly managed network setups and/or those that require very specific behavior from the bridges.

Up until now, oVirt used to persist its network configuration in Fedora/EL specific files handled by the initscripts package. These files, known as ifcfg, contained a series of shell definitions that were read and applied by the ifup-eth executable. oVirt auto-generates and writes these ifcfg files and as such, if the network admin wanted to tweak the BRIDGING_OPTS definition that precluded the continued care-free modification of the network, as some of the configuration would be living only in the hypervisor node and would not be exposed to oVirt for persistence.

##### User experience

bridge options will be set per logical network and it will be possible to override the setting on assignment to the host, i.e., on a host per host basis. It will only be possible to set this value in the GUI when the logical network is defined as a VM network, as non VM networks are not implemented by means of bridges, so they do no have an entity upon which to configure the settings.

![](Bridge_opts_networks.png "Bridge_opts_networks.png")

The options set above will be applied when the logical network is assigned to a hosts device, be it nic or bond, so that the network administrator does not need to set it for each host of the cluster. However, if the network administrator wishes, he'll have the option, as shown below, to override the network custom properties by clicking on the edit 'pencil' button.

![](Override_setupNetworks.png "fig:Override_setupNetworks.png") ![](Override_bridge_options.png "fig:Override_bridge_options.png")

When assigning a VM network to a NIC or Bond it will be possible to click on "edit" (icon marked in red in the first of the two images directly above) and:

*   Add new bridge options,
*   Edit for this host only the bridge options previously defined at the logical level,
*   Remove any custom network property defined at the logical level.

##### Properties format

The proposed format consists on 'key=value key2=value2', i.e., pairs of option-value separated among themselves by an equality symbol and from other pairs by whitespace. E.g.:

    forward_delay=1500 gc_timer=3765 group_addr=1:80:c2:0:0:0 group_fwd_mask=0x0 hash_elasticity=4 hash_max=512 hello_time=200 hello_timer=70 max_age=2000 multicast_last_member_count=2 multicast_last_member_interval=100 multicast_membership_interval=26000 multicast_querier=0 multicast_querier_interval=25500 multicast_query_interval=13000 multicast_query_response_interval=1000 multicast_query_use_ifaddr=0 multicast_router=1 multicast_snooping=1 multicast_startup_query_count=2 multicast_startup_query_interval=3125

##### Testing

To test this feature the tester should:

*   set up bridge options at the logical level, assign the VM network to a nic/bond and use the following shell script to check that the options where applied:

<!-- -->

    for opt in `ls /sys/class/net/$bridge_name/bridge/ -w 1`; do
        echo -n "$opt=$(cat /sys/class/net/$bridge_name/bridge/$opt) "
    done

*   Override (editing or removing) the bridge options set at the logical level and see, like in the previous step that the options are properly applied to the bridge.
*   Define at the network assignment level bridge options for a network with no bridge options at the logical level and see that they are properly applied to the bridge.

### Documentation / External references

*   TBD

### Comments and Discussion

*   Refer to [Talk:Network Custom Properties](Talk:Network Custom Properties)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
