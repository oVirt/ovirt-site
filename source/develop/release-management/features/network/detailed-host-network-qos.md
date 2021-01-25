---
title: Detailed Host Network QoS
category: feature
authors: amuller, apuimedo, danken, lvernia
feature_name: Host Network QoS
feature_modules: engine,vdsm, api
feature_status: Implementation
---

# Detailed Host Network QoS

## Host Network QoS - Detailed

#### Summary

This feature provides means by which to control the traffic of a specific network through a host's physical interface. It is a natural extension of the [VM Network QoS](/develop/sla/network-qos.html) feature, which provided the same functionality for a VM network through a VM's virtual interface.

You may also refer to the [simple feature page](/develop/release-management/features/network/host-network-qos.html).

#### Owner

*   Name: Lior Vernia (previously owned by Giuseppe Vallarelli)

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a vNIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   Cluster/DC (Data Center) - control the traffic related to a specific logical network throughout the entire cluster/DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](/develop/sla/network-qos.html) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

Cluster/DC-wide QoS remains to be handled in the future.

Implementation-wise, two different approaches naturally arise from the existing state of QoS in oVirt:

*   Proceed with the VM Network QoS paradigm, that is creating Network QoS entities that can be shared between different networks - let's refer to this as "named" QoS. The advantages here are that the administrator is accustomed to the same QoS usage flow across VM and host networking, and that a few QoS configurations could be easily shared by many instances of networks on host interfaces. This also requires very little changes to the existing code, rendering it easier to implement. However, this leads to a non-trivial relationship between host network entities and QoS entities, giving rise to inconvenient questions such as what happens when a QoS entity, that had been attached to any host networks, is updated. A further disadvantage is the awkwardness of the process of defining QoS on a host network when a fitting QoS entity doesn't yet exist, which would force the user to change context to create a new QoS entity first; this could however be relieved in several different ways, discussed below.
*   Define QoS parameters directly on the host's interfaces when networks are attached to them (similarly to boot protocol, for example) - let's refer to this as "anonymous" QoS. The advantage in this approach is when there's a low amount of hosts and host NICs, and their QoS configurations differ (i.e. there's not much value in sharing the configurations), configuring the NICs directly will save the extra step of defining the QoS entities. This also greatly simplifies the relation between host network entities and QoS entities, but at the cost of not being able to share the same QoS configuration between different instances of networks attached to host interfaces.

It is best take on a hybrid approach, where users could EITHER configure an "anonymous" QoS on a host network OR attach a pre-existing QoS entity. This would probably be the preferred approach, as it provides users with flexibility and accommodates any use case. This is what's planned for 3.6 - a QoS entity may be attached to the network on the DC level, but the QoS configuration on each host interface may be overridden from within the Setup Host Networks dialog.

##### Host QoS important considerations

*   The traffic shaping is done at the logical link level, i.e., a bond, for networks that do use link aggregation or a nic, for those networks that don't.
*   The oVirt-defined networks will each get a network [traffic class](http://www.tldp.org/HOWTO/html_single/Traffic-Control-HOWTO/#c-class) to be shaped according to the limits (if any) set by the administrator (in a similar fashion as it is now for vNIC traffic). They will be classified by vlan id or the lack of thereof.
*   The different network traffic classes set over a logical link will contend for the device sending queue in a proportional manner to the bandwidth they are assigned. This means that if my bandwidth is 35mbps and I have network A assigned 3mbps, network B assigned 1 mbps and network C unshaped, what I should expect to see is:
    -   A: 15mbps
    -   B: 5mbps
    -   C: 15mbps
*   From the above it is easy to see that there is borrowing of extra bandwidth between the networks.
*   Network bandwidths can be capped so that they do not exceed a certain consumption regardless of extra bandwidth being available.
*   It is generally possible to define bursts to throttle some relatively latency insensitive networks (like storage) and favor highly latency sensitive networks (like VoIP or graphical consoles). However, for simplicity's sake, initially this configuration won't be exposed via the engine.
*   It is relatively easy to achieve unpredictable network behavior via QoS configuration, either by having mixed QoS configuration on a logical link (i.e. some networks with QoS, some without) or by over-committing (i.e. having the sum of "real time" traffic required by networks on a logical link surpass the link's capabilities). Therefore, these situations will be blocked by the engine; either none or all the networks on a logical link must have QoS configured, and the sum of the networks' committed rate must not surpass 75% of the link's effective speed.

##### Entity Description

Since the Host Network QoS is most relevant in the context of a specific host interface (i.e. it could have completely different a QoS setup on each host interface), the most natural place to configure it would be when editing a network attached to a host interface, similarly to boot protocol configuration. However, as the most likely use case would be to enforce the same bandwidth limitations on all interfaces to which the network is attached, we'd like to implement the QoS configuration as part of the Network entity, and copy the configuration to the host's interfaces as the network is attached to them. This is not unlike what we do with VLAN tagging at the moment. Similarly to VLAN tagging, some users might prefer to have better granularity and apply different QoS configurations to different hosts using the same network; this will be made possible the moment we also implement "anonymous" QoS configuration at the level of a host interface, which should override the QoS configuration attached to the DC-wide Network entity.

A new HostNetworkQos entity will be implemented - it won't be valuable to re-use the existing NetworkQoS, as we plan to expose a different set of parameters from that exposed by libvirt (as we don't use libvirt, see VDSM implementation). This entity will extend QosBase, as any other QoS entity. Similarly to other QoS entities, a specific DAO will be implemented to mirror CRUD operations. Commands will check permissions on the DC, similarly to the existing VM Network QoS entities.

The parameters initially stored on this entity will be a "Weighted Share" (corresponding to "link share" in vdsm terms, see below), "Rate Limit" ("upper limit" in vdsm terms) and "Committed Rate" ("real time" in vdsm terms):

*   Weighted Share is a unit-less number, signifying how much of the logical link's capacity a specific network should be allocated. It is only important in relative terms to other networks attached to the same logical link. For example, a network given 20 shares will receive twice as much bandwidth (typically) than a network given 10 shares on the same logical link; however, the exact share of the link's capacity depends on the sum of shares of all networks on that link. By default, shares must be a number in the range 1-100, but the upper limit of this range is configurable by setting the value of "MaxHostNetworkQosShares" via engine-config.
*   Rate Limit is the hard capping of bandwidth to be used by a network, in Mbps (same as the outbound limit of VM network QoS). The maximum value to input here is determined by the "MaxAverageNetworkQoSValue" configuration value.
*   Committed Rate is the minimum bandwidth required by a network, in Mbps. Setting this doesn't guarantee the bandwidth, but guarantees a "best effort" (this still depends on the network's infrastructure on the physical layer and on the Committed Rate requested by other networks on the same logical link). The maximum value to input here is determined by the "MaxAverageNetworkQoSValue" configuration value.

Other existing entities will have to be modified. The Network entity should be changed to include a HostNetworkQos member, which would refer to the QoS configuration to be applied to host interfaces carrying this network. The VdsNetworkInterface should be similarly changed to include a HostNetworkQos member, which in this case would refer to the actual QoS configuration reported by VDSM. These two entities could then be compared, in order to check whether the QoS configuration is "in sync"; if the QoS configuration is out-of-sync, the host network itself would also be marked as out-of-sync (similarly to what is done today with MTU, VLAN and so forth).

Like other QoS entities, HostNetworkQos entities will be stored in the gigantic sparse table qos. Columns representing the exposed parameters will be added to this table - initially these will be linkshare_rate, upperlimit_rate and realtime_rate (but as the VDSM API exposes more configurable values, this could be extended in the future). The HostNetworkQos entities will be referred to, in the form of foreign keys, by qos_id columns of type UUID in both the network and the vds_interface tables. Those reported by VDSM and referred to by the vds_interface table could have a "null" name and filtered out of queries, as they should be of no interest to the users (e.g. they should not be able to attach these entities to a network); they should be maintained (added, removed or updated) when collecting network data from the host.

As for the handling of permissions, it remains to be shown that the current permission model on Network QoS isn't broken:

*   Attaching a pre-existing Host Network QoS entity to a network is not a problem, as a user editing a network has usage permissions on the DC and therefore the QoS entities in it.
*   Creating a new "named" Host Network QoS to be attached to a network will be performed by a separate call to the AddHostNetworkQos action (and not as part of the Add/Edit Network action), therefore the user's permissions will be properly checked; the operation will fail if they don't have sufficient permissions on the DC.
*   Creating/updating the "anonymous" QoS configuration on a host's interface will be performed as part of the SetupNetworks action, so as long as the user has proper permissions of the host they'll be able to edit the interfaces' "anonymous" QoS values.

##### VDSM

The proposed engine-vdsm api is a very fine grained API that allows for more shaping options than will originally be provided. There are three service curves with three components each:

*   Link share: Establishes a proportion between networks. E.g., if the sum of the network link share allocation matched the outbound capabilities, we'd see that the real traffic approximately matches what is set as link share.
*   Upper limit: Since link share allows the networks to take more traffic if more capacity is available, this curve serves to put an absolute cap to what a network can take.
*   Real time: Allows a network to steal the share of other networks in order to "guarantee" some amount of traffic for itself.

For each of these curves there are three parameters:

*   m1: Burst amount. The amount of traffic that we can send in burst. Unit: kilobytes per second
*   d: The maximum length of bursts. The burst will only happen if the network is backlogged and there is more data to send that fits in the burst within this time than another competing backlogged network has to send. Unit: milliseconds.
*   m2: The usual rate of the network. Unit: kilobytes per second

With the above definitions, an example networks definition would be:

         {'storage': {'nic': 'eth2', 'bootproto': 'dhcp', 'hostQos': {'out': {
             'ls': {'m2': 2000}. 'ul':  {'m2': 10000}}}},
          'display': {'nic': 'eth2', 'bootproto': 'dhcp': 'hostQos': {'out': {
             'ls': {'m1': 5000, 'd': 300, 'm2': 1500}}}}}

It's possible to retrieve the QoS defined for an host's network with the following code:

    from vdsm import vdscli
    connection = vdscli.connect()
    connection.getVdsCapabilities()['info']['networks']['whatever']

the expected result should be something similar to:
```json
    {'addr': '',
     'bridged': True,
     'cfg': {'DELAY': '0',
             'DEVICE': 'goofy',
             'NM_CONTROLLED': 'no',
             'ONBOOT': 'yes',
             'TYPE': 'Bridge'},
     'gateway': '0.0.0.0',
     'iface': 'goofy',
     'ipv6addrs': ['fe80::210:18ff:fee1:6d2a/64'],
     'ipv6gateway': '::',
     'mtu': '1500',
     'netmask': '',
     'ports': ['p1p2'],
     'qos': {'out': {'ls': {'m1': 5000, 'd': 300, 'm2': 1500}}},
     'stp': 'off'}
```

###### Implementation

![](/images/wiki/Qos_hfsc.png)

As depicted in the picture, there are four oVirt networks.all the leaf nodes would have an stochastic fair queuing (sfq) qdics to prevent connections from taking all the bandwidth of a traffic class):

*   Storage: Vlanned network with tag value 10. It is a non-shaped network for the host to access nfs. This traffic class has its fair share automatically set to the maximum of any shaped class and if extra bandwidth is available it just takes it. Filter to match it:

         tc filter add dev eth2 parent 1: prio 20 protocol 802.1q u32 match u16 10 0xFFF at -4 flowid 1:10

class definition:

         tc class add dev eth2 parent 1: classid 1:10 hfsc ls rate $(max_shaped_net)mbps

*   Databse: Vlanned network with tag value 20. It is a shaped network with outbound traffic share of 3mbps (capped at 5mbps) that serves for the VMs that run postgresql instances. If there is extra bandwidth available it will take more than it's 3mbps share, but never more than 5mbps (on average). Filter to match it:

         tc filter add dev eth2 parent 1: prio 20 protocol 802.1q u32 match u16 20 0xFFF at -4 flowid 1:20

class definition:

         tc class add dev eth2 parent 1: classid 1:20 hfsc ls rate 3mbps ul rate 5mbps

*   Web servers: Vlanned network with tag value 30. It is a shaped network with outbound traffic share of 20mbps (capped at 30mbps) that serves for VMs that run apache/nginx instances. The shaping is just like that in the database network but with different limits. Filter to match it:

         tc filter add dev eth2 parent 1: prio 30 protocol 802.1q u32 match u16 30 0xFFF at -4 flowid 1:30

class definition:

         tc class add dev eth2 parent 1: classid 1:30 hfsc ls rate 20mbps ul rate 30mbps

*   Display: Non-vlanned network. It is shaped, just as in the case of the web servers network, but with a tweak. Since it is important that the latency of the network is low, after all, nobody wants a laggy display, we set a burst period 1.5ms during which the network is allowed to transmit up to 40mbps. Filter to match:

         tc filter add dev eth2 parent 1: prio 5000 protocol all u32 match u32 0 0 flowid 1:5000  # Note that 5000 is chosen so that it is a catch all traffic of the device outside of the vlan range

class definition:

         tc class add dev eth2 parent 1: classid 1:5000 hfsc ls m1 40mbps d 1.5ms m2 20mbps ul rate 30mbps

All the leaf classes have a Stochastic queuing discipline to guarantee fairness between different connections inside each network. For example for the database network it would look like:

         tc qdisc add dev eth2 handle 20:0 parent 1:0 sfq perturb 10

##### RESTful API

Since QoS API has been added in oVirt 3.5, it will be possible to expose Host Network QoS API as part of this feature. However, as another 3.6 feature will likely be a makeover for the Setup Networks API, it is not completely clear how this feature's API will be exposed. Assuming this feature will be the first to be implemented, an element of type QoS will be added to both the HostNIC type and the Network type. In the new proposed API, it should be part of a NetworkConnection/NetworkConfiguration (or instead of HostNIC).

##### User Experience

<b>Slightly out of date - should be similar, but other values will appear in the dialogs. A new category should appear under the DC/QoS subtab.</b>

![ thumb | right](/images/wiki/NetworkDialogQos.png) ![ thumb | right](/images/wiki/InterfaceQosOverride.png)

As mentioned earlier, to improve the common user experience, we'd like to initially configure Host Network QoS on the DC-wide Network entity. This means adding some ability to configure it in the Add/Edit Network dialog. Since we'd like to start with the ability to attach a "named" QoS configuration, the straightforward thing to do would be to add a list box to the dialog, where users could choose one of the pre-configured Network QoS entities in the DC.

However, we would like to enable users to also create a new Network QoS entity from this dialog, in case they had neglected to create a fitting QoS configuration beforehand (through the DC/QoS subtab). To this end, we could add a button that would allow users to create a new QoS entity. Pressing on this button will open the same "Add Network QoS" dialog as in the DC/QoS subtab, and upon creation of a new QoS entity through it, it will be added to the list box.

The most natural place for configuring "anonymous" QoS directly on one of the host's interfaces is in the existing dialog for editing networks as they are attached to the host's interfaces. This is accessible through the "Setup Host Networks" dialog, and clicking the "Edit" icon that appears when hovering over a specific network attached to an interface. Following is a short discussion of how QoS would be configured in that dialog. It is only required to somehow incorporate the QoS widget into the "Edit Host Network" dialog, for example like this (fancier possibilities exist to make the widget less intimidating):

##### User Work-flows

In the "named" QoS approach, the standard work-flow for an administrator to configure QoS on a host network would be as follows:

*   Create a new Network QoS entity in the DC/QoS subtab.
*   Head to the Networks main tab.
*   Edit the desired network.
*   In the dialog that opens, choose the pre-configured Network QoS entity by its name (or create a new QoS entity as desired via a dedicated button).

In the "anonymous" QoS approach, the flow would be as follows:

*   Start from the "Setup Host Networks" dialog.
*   Edit the desired network.
*   Directly configure average/peak/burst values for the network on the host's interface.

### Comments and Discussion

On the devel@ovirt.org and users@ovirt.org mailing lists.

