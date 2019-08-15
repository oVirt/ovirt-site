---
title: Custom Network Properties
---

# Appendix B: Custom Network Properties

## Explanation of bridge_opts Parameters

**bridge_opts parameters**

| Parameter | Description |
|-
| forward_delay | Sets the time, in deciseconds, a bridge will spend in the listening and learning states. If no switching loop is discovered in this time, the bridge will enter forwarding state. This allows time to inspect the traffic and layout of the network before normal network operation. |
| gc_timer | Sets the garbage collection time, in deciseconds, after which the forwarding database is checked and cleared of timed-out entries. |
| group_addr | Set to zero when sending a general query. Set to the IP multicast address when sending a group-specific query, or group-and-source-specific query. |
| group_fwd_mask | Enables bridge to forward link local group addresses. Changing this value from the default will allow non-standard bridging behavior. |
| hash_elasticity | The maximum chain length permitted in the hash table. Does not take effect until the next new multicast group is added. If this cannot be satisfied after rehashing, a hash collision occurs and snooping is disabled. |
| hash_max | The maximum amount of buckets in the hash table. This takes effect immediately and cannot be set to a value less than the current number of multicast group entries. Value must be a power of two. |
| hello_time | Sets the time interval, in deciseconds, between sending 'hello' messages, announcing bridge position in the network topology. Applies only if this bridge is the Spanning Tree root bridge. |
| hello_timer | Time, in deciseconds, since last 'hello' message was sent. |
| max_age | Sets the maximum time, in deciseconds, to receive a 'hello' message from another root bridge before that bridge is considered dead and takeover begins. |
| multicast_last_member_count | Sets the number of 'last member' queries sent to the multicast group after receiving a 'leave group' message from a host.  |
| multicast_last_member_interval | Sets the time, in deciseconds, between 'last member' queries. |
| multicast_membership_interval | Sets the time, in deciseconds, that a bridge will wait to hear from a member of a multicast group before it stops sending multicast traffic to the host. |
| multicast_querier | Sets whether the bridge actively runs a multicast querier or not. When a bridge receives a 'multicast host membership' query from another network host, that host is tracked based on the time that the query was received plus the multicast query interval time. If the bridge later attempts to forward traffic for that multicast membership, or is communicating with a querying multicast router, this timer confirms the validity of the querier. If valid, the multicast traffic is delivered via the bridge's existing multicast membership table; if no longer valid, the traffic is sent via all bridge ports. Broadcast domains with, or expecting, multicast memberships should run at least one multicast querier for improved performance. |
| multicast_querier_interval | Sets the maximum time, in deciseconds, between last 'multicast host membership' query received from a host to ensure it is still valid. |
| multicast_query_use_ifaddr | Boolean. Defaults to '0', in which case the querier uses 0.0.0.0 as source address for IPv4 messages. Changing this sets the bridge IP as the source address. |
| multicast_query_interval | Sets the time, in deciseconds, between query messages sent by the bridge to ensure validity of multicast memberships. At this time, or if the bridge is asked to send a multicast query for that membership, the bridge checks its own multicast querier state based on the time that a check was requested plus multicast_query_interval. If a multicast query for this membership has been sent within the last multicast_query_interval, it is not sent again. |
| multicast_query_response_interval | Length of time, in deciseconds, a host is allowed to respond to a query once it has been sent. Must be less than or equal to the value of the multicast_query_interval. |
| multicast_router | Allows you to enable or disable ports as having multicast routers attached. A port with one or more multicast routers will receive all multicast traffic. A value of 0 disables completely, a value of 1 enables the system to automatically detect the presence of routers based on queries, and a value of 2 enables ports to always receive all multicast traffic. |
| multicast_snooping | Toggles whether snooping is enabled or disabled. Snooping allows the bridge to listen to the network traffic between routers and hosts to maintain a map to filter multicast traffic to the appropriate links. This option allows the user to re-enable snooping if it was automatically disabled due to hash collisions, however snooping will not be re-enabled if the hash collision has not been resolved. |
| multicast_startup_query_count | Sets the number of queries sent out at startup to determine membership information. |
| multicast_startup_query_interval | Sets the time, in deciseconds, between queries sent out at startup to determine membership information. |

## How to Set Up oVirt Engine to Use Ethtool

You can configure ethtool properties for host network interface cards from the Administration Portal. The **ethtool_opts** key is not available by default and needs to be added to the Manager using the engine configuration tool. You also need to install the required VDSM hook package on the hosts.

**Adding the ethtool_opts Key to the Engine**

1. On the Engine, run the following command to add the key:

        # engine-config -s UserDefinedNetworkCustomProperties=ethtool_opts=.* --cver=4.0

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine.service

3. On the hosts that you want to configure ethtool properties, install the VDSM hook package. The package is available by default on oVirt Host but needs to be installed on Enterprise Linux hosts.

        # yum install vdsm-hook-ethtool-options

The **ethtool_opts** key is now available in the Administration Portal. See [Editing host network interfaces](Editing_host_network_interfaces) to apply ethtool properties to logical networks.

## How to Set Up oVirt Engine to Use FCoE

You can configure Fibre Channel over Ethernet (FCoE) properties for host network interface cards from the Administration Portal. The **fcoe** key is not available by default and needs to be added to the Engine using the engine configuration tool. You can check whether **fcoe** has already been enabled by running the following command:

    # engine-config -g UserDefinedNetworkCustomProperties

You also need to install the required VDSM hook package on the hosts. Depending on the FCoE card on the hosts, special configuration may also be needed.

**Adding the fcoe Key to the Engine**

1. On the Engine, run the following command to add the key:

        # engine-config -s UserDefinedNetworkCustomProperties='fcoe=^((enable|dcb|auto_vlan)=(yes|no),?)\*$'

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine.service

3. Install the VDSM hook package on each of the Enterprise Linux hosts on which you want to configure FCoE properties. The package is available by default on oVirt Node.

        # yum install vdsm-hook-fcoe

The **fcoe** key is now available in the Administration Portal. See [Editing host network interfaces](Editing_host_network_interfaces) to apply FCoE properties to logical networks.

**Prev:** [Appendix A: VDSM and Hooks](appe-VDSM_and_Hooks)<br>
**Next:** [Appendix C: oVirt User Interface Plugins](appe-oVirt_User_Interface_Plugins)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/appe-custom_network_properties)
