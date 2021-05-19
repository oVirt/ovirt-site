---
title: Network Custom Properties
category: feature
authors: apuimedo, danken, lvernia, sandrobonazzola
---

# Network Custom Properties

## Summary

Define special parameters per network, and pass them down to Vdsm hooks when the network is set up on a host.

## Owner

*   Name: Lior Vernia (lvernia)

## Detailed Description

Just like we can define VM-wide and vNIC-profile-specific custom properties, we would like to set per-network ones. This would allow users to pass special parameters to tweak the way by which Vdsm sets up a network on a host.

Preset property keys will exist for bridge options. These will provide a way for the network administrator to easily set options for bridges which implement oVirt VM networks. In addition, the feature could be used, along with a preset VDSM hook, to specify ethtool options for any host interface to which an oVirt network is attached. It should be noted that ethtool options do not really "belong" to a network, but rather to an interface, therefore the property doesn't display by default. In the future, it is possible custom properties could be supplied for host interfaces, thereby obviating the need to configure ethtool_opts on a network.

## Benefit to oVirt

oVirt currently supports a limited set of network topologies: an optional bridge, connected via an optional vlan device to a host NIC or a bonding device.

Users want to allow funkier types of connection, or tighter control on the created devices:

*   Create a host nic (via Mellanox UFM) to implement a storage network.
*   Set special options on host nic (via ethtool)
*   Replace the Engine-specified nic with a dummy device, to implement VM-only network.

These extensions, and many others, can be made available by allowing per-network custom properties. Network custom properties are just like VM-wide device-specific ones, only that they are attached to a specific network, and can take effect when the network is set up.

Concerning specifically bridge and ethtool options, having a simple way for the network administrator to set bridge and ethtool options for the oVirt defined VM networks will allow oVirt to cover a wider range of configurations and fine tuning that will make oVirt networking a better fit for very tightly managed network setups.

Up until now, oVirt used to persist its network configuration in Fedora/EL specific files handled by the initscripts package. These files, known as ifcfg, contained a series of shell definitions that were read and applied by the ifup-eth executable. oVirt auto-generates and writes these ifcfg files and as such, if the network admin wanted to tweak the BRIDGING_OPTS and/or ETHTOOL_OPTS definition that precluded the continued care-free modification of the network, as some of the configuration would be living only in the hypervisor node and would not be exposed to oVirt for persistence.

## HOWTO: configure ethtool_opts on an interface

*   Using the engine-config utility, add an entry for a property called "ethtool_opts" in the configuration value "UserDefinedNetworkCustomProperties". Since the VDSM hook accepts the property value as the ethtool command line arguments (see details below), regular expression validation isn't very valuable. Don't forget to supply the cluster version in which you want the configuration to be applied. This snippet will work for 3.5 clusters:

<!-- -->

    `engine-config -s 'UserDefinedNetworkCustomProperties=ethtool_opts=.*' --cver='3.5'`

*   Restart the ovirt-engine service; as with any other change in configuration values, they only take effect the next time the engine is run.
*   Pick one of the networks attached to the interface whose ethtool options you want to configure. It'll work with ANY network attached to that interface (part of why this modelling is skewed).
*   Either via the webadmin console or via REST (see description how below), as part of a setup networks action, supply a custom property for the network of your choice, whose key is "ethtool_opts" and whose value is the arguments you'd like ethtool to apply.

Voila, you should be done!

## User Experience

The Setup Network dialog would have a list of custom properties for each assigned network (similarly to boot protocol and IP address configuration), to be set by the network administrator.

![](/images/wiki/Override_setupNetworks.png) ![](/images/wiki/Override_bridge_options.png)

When assigning a network to a NIC it will be possible to click on "edit" (icon marked in red in the first of these two images) and:

*   Add new custom properties,
*   Edit the existing custom properties,
*   Remove any custom properties.

Note that preset custom property keys will exist for bridge options (whenever the network is a VM network).

OPTIONAL: As part of the feature it might be a good idea to allow setting custom properties per logical network (on the DC level), and not only on the assignment of a network on a physical device. These custom properties on the logical network will serve as a "mold", to be used by default when assigning the network to a device. This ended up not being implemented for oVirt 3.5, but might be added in the future.

![](/images/wiki/Bridge_opts_networks.png)

Above you can see that in the networks tab, in the dialog for creating a new logical network, it is possible to define custom network properties, which will include bridge options (for VM networks) by default. These custom properties will be applied upon any assignment of the network to a NIC on a host, unless overridden as described before.

## Implementation

### Vdsm

This feature affects the **setupNetwork** Vdsm verbs. setupNetwork accepts an **options** dictionary of type @SetupNetworkOptions beyond the dictionaries describing networks and bonds to be set up. A new optional key "custom" would be added to SetupNetworkOptions. Its value is a dictionary of custom properties and their string value. E.g. based on one of the usages described below:

```json
    {'storagenet':
        {'bonding': 'bond0'}, 'vlan': '10', 'bootproto': 'dhcp',
                     'custom': {'ethtool_opts': '--offload em2 rx on --offload em1 tx on'}}
```

Vdsm would pass the network definition and their custom properties to setupNetwork's hook scripts.

In setupNetwork hooks scripts, the properties would be passed as environment variables of the hook scripts being executed.

Vdsm could either report the custom properties as part of getVdsCaps or not; it would probably be more consistent with other network properties to indeed report this information.

#### Bridge options format

The proposed format consists on 'key=value key2=value2', i.e., pairs of option-value separated among themselves by an equality symbol and from other pairs by whitespace. E.g.:

    forward_delay=1500 gc_timer=3765 group_addr=1:80:c2:0:0:0 group_fwd_mask=0x0 hash_elasticity=4 hash_max=512 hello_time=200 hello_timer=70 max_age=2000 multicast_last_member_count=2 multicast_last_member_interval=100 multicast_membership_interval=26000 multicast_querier=0 multicast_querier_interval=25500 multicast_query_interval=13000 multicast_query_response_interval=1000 multicast_query_use_ifaddr=0 multicast_router=1 multicast_snooping=1 multicast_startup_query_count=2 multicast_startup_query_interval=3125

#### Ethtool options format

The proposed format is just the command line ethtool syntax

    --coalesce ethX rx-usecs 14 sample_interval 3 --offload ethX rx on lroon tcp-segmentation-offload off --change ethX speed 1000 duplex half 

If the property is being set on a bond, the user should make sure to specify the proper ethX/ethY/ethZ for each of the bond's nics that ethtool options should be set for. E.g., we have a bond with em1 and em2 and em2 should offload only rx and em1 only tx:

    --offload em2 rx on --offload em1 tx on

In the bonding case, the UI/Engine/vdsm code may want to check that there is no reference to a NIC that isn't enslaved to the bond.

### Engine

#### Configuration

*   A configuration value will be added for the versions supporting the feature, whose value is 'false' for any version below 3.5 and 'true' otherwise.
*   A configuration value will be added for the predefined properties, and will include "bridge_opts".
*   A different configuration value will be added to hold user-defined properties, and should be initialized to be empty. It's better to distinguish between predefined and user-defined properties, to make it harder for users to accidentally overwrite predefined properties and to more easily handle upgrade scripts.

#### DB

The vds_interface table should be extended to include a custom properties (text) column. Potentially, the network table should be similarly extended to facilitate uniform custom properties across an entire DC - if that is deemed part of the feature. Create and update operations in InterfaceDao and NetworkDao should be modified accordingly.

#### Business Entities

VdsNetworkInterface should be extended to include a custom properties member (either String or Map<String, String>), and potentially the Network entity should as well. The CustomPropertiesUtils class could be used virtually as is, but might have to be extended slightly (via a subclass) to accommodate the difference between predefined and user-defined properties.

#### Business Logic

When executing Setup Networks, the VdsNetworkInterface custom properties member would have to be added as a map to a network's "custom" entry, as described in the section on VDSM. If the feature is implemented so that VDSM reports network custom properties as part of getVdsCaps, then the member should be reconstructed in the VdsBrokerObjectBuilder class and persisted to the DB; otherwise, it should be persisted before the properties are passed to the VDSM (as is done today with network labels).

### REST

Add a custom_properties field to api.xsd for the NIC type:

```xml
    <host_nic href="/api/hosts/517b98ee-386c-4538-8f9c-b3216663fb20/nics/e8c1764e-28bb-42a6-aa95-76ce73e944e2" id="e8c1764e-28bb-42a6-aa95-76ce73e944e2">
        <name>em1</name>
        <mac address="84:2b:2b:9f:29:b0"/>
        <ip address="10.35.7.23" netmask="255.255.254.0" gateway="10.35.7.254"/>
        <boot_protocol>dhcp</boot_protocol>
        .
        .
        .
        <custom_properties>
           <custom_property name="forward_delay" value="1500"/>
        </custom_properties>
    </host_nic>
```

If the extension to logical networks is implemented (which seems unlikely at the moment), then that entity will have be to extended as well. There will also be a need to modify the Setup Networks command in rsdl_metadata.yaml, but probably not the obsolete add/update NIC commands. Again, if the feature includes implementation of custom properties on logical networks, then the add/update network commands will need to be modified too. At last, mapping between the REST entities and the engine entities will have to be modified.

### Backwards Compatibility

As this is a 3.5 feature, its related GUI widgets should not be shown for hosts that are part of cluster whose compatibility version is lower. The engine backend needs to take special care at the canDoAction() method of SetupNetworksCommand to disallow custom network properties for 3.4 and below, to also block such operations via REST. Similar care should be taken when hosts are attempted to be moved from a >= 3.5 cluster to a < 3.5 cluster; since there is currently no infrastructure to send a Setup Networks command to VDSM upon cluster change, any non-empty custom properties on the host can't be wiped, therefore it would probably be best to block the operation.

## Testing

### Custom Properties

*   Use the engine-config tool to insert the property {'hostonly': 'True'} to networks. Specify the regex on the 'hostonly' property to 'True|False'.
*   Verify that the properties were inserted into the DB.
*   Restart the engine, for the configuration changes to take effect.
*   From the Engine, define a network and set the 'hostonly' property (Make sure the cluster level is 3.5+)
*   [Create a new VDSM hook](/develop/developer-guide/vdsm/hooks.html) that occurs during before (and after) setupNetwork that prints the value for the 'hostonly' environment variabls, and the network definition that the hook received.
*   Verify that 'True' is printed.

### Bridge options

To test this preset property the tester should:

*   set up bridge options at the logical level, assign the VM network to a nic/bond and use the following shell script to check that the options where applied:

<!-- -->

    for opt in `ls /sys/class/net/$bridge_name/bridge/ -w 1`; do
        echo -n "$opt=$(cat /sys/class/net/$bridge_name/bridge/$opt) "
    done

*   Override (editing or removing) the bridge options set at the logical level and see, like in the previous step that the options are properly applied to the bridge.
*   Define at the network assignment level bridge options for a network with no bridge options at the logical level and see that they are properly applied to the bridge.

### Ethtool options

To test this preset property the tester should:

*   Install the hook that provides the functionality on the vdsm hosts: package name vdsm-hook-ethtool-options
*   set up ethtool options at the logical level, assign the network to a nic and use the cli tool ethtool to check that the options are properly applied to the NIC.
*   Override (editing or removing) the ethtool options set at the logical level and see, like in the previous step that the options are properly applied to the NIC.
*   Define at the network assignment level ethtool options for a network with no ethtool options at the logical level and see that they are properly applied to the NIC.

##### Usage

In the oVirt UI edit custom network properties and, for the key 'ethtool_opts' set the command line parameters that one would pass to the ethtool command line application. E.g.:

         '--coalesce ethX rx-usecs 14 sample-interval 3 --offload ethX rx on lro on tso off --change ethX speed 1000 duplex half'

Note that it is possible to substitute the ethX name of the NIC with a '\*' and the hook will fill in the right nic name for you.

======= bonding ======= For bondings there are two options: a) Pick which devices to apply something on (subject to the command actually being appliable with a single ethtool call): If it is for a bond with em1 and em2, it could look like:

         '--offload em2 rx on --offload em1 tx on'

b) Apply to all the bond slaves:

         '--coalesce * rx-usecs 14 sample_interval 3'

This would execute an ethtool process for each slave.

## Documentation / External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=1080984>
*   <https://bugzilla.redhat.com/show_bug.cgi?id=1080987>

## Comments and Discussion

*   On the devel@ovirt.org mailing list.

