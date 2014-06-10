---
title: Detailed Host Network QoS
category: feature
authors: amuller, apuimedo, danken, lvernia
wiki_category: Feature
wiki_title: Features/Detailed Host Network QoS
wiki_revision_count: 52
wiki_last_updated: 2015-02-01
---

# Detailed Host Network QoS

## Host Network QoS - Detailed

#### Summary

This feature provides means by which to control the traffic of a specific network through a host's physical interface. It is a natural extension of the [VM Network QoS](Features/Network_QoS) feature, which provided the same functionality for a VM network through a VM's virtual interface.

You may also refer to the [simple feature page](Features/Host_Network_QoS).

#### Owner

*   Name: Lior Vernia (previously owned by Giuseppe Vallarelli)
*   E-mail: lvernia@redhat.com
*   IRC: lvernia at #ovirt (irc.oftc.net)

#### Current Status

*   Target Release: oVirt 3.5
*   Status: design
*   Last updated: May 1st, 2014.

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a vNIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   Cluster/DC (Data Center) - control the traffic related to a specific logical network throughout the entire cluster/DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](Features/Network_QoS) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

Cluster/DC-wide QoS remains to be handled in the future.

Implementation-wise, two different approaches naturally arise from the existing state of QoS in oVirt:

*   Proceed with the VM Network QoS paradigm, that is creating Network QoS entities that can be shared between different networks - let's refer to this as "named" QoS. The advantages here are that the administrator is accustomed to the same QoS usage flow across VM and host networking, and that a few QoS configurations could be easily shared by many instances of networks on host interfaces. This also requires very little changes to the existing code, rendering it easier to implement. However, this leads to a non-trivial relationship between host network entities and QoS entities, giving rise to inconvenient questions such as what happens when a QoS entity, that had been attached to any host networks, is updated. A further disadvantage is the awkwardness of the process of defining QoS on a host network when a fitting QoS entity doesn't yet exist, which would force the user to change context to create a new QoS entity first; this could however be relieved in several different ways, discussed below.
*   Define QoS parameters directly on the host's interfaces when networks are attached to them (similarly to boot protocol, for example) - let's refer to this as "anonymous" QoS. The advantage in this approach is when there's a low amount of hosts and host NICs, and their QoS configurations differ (i.e. there's not much value in sharing the configurations), configuring the NICs directly will save the extra step of defining the QoS entities. This also greatly simplifies the relation between host network entities and QoS entities, but at the cost of not being able to share the same QoS configuration between different instances of networks attached to host interfaces.

It is also possible to take on a hybrid approach, where users could EITHER configure an "anonymous" QoS on a host network OR attach a pre-existing QoS entity. This would probably be the preferred approach, as it provides users with flexibility and accommodates any use case. For the coming oVirt 3.4 feature, the plan is to make the existing paradigm - that of shareable, "named" QoS - a first priority; it is of the least risk to implement, and it draws upon the "already familiar" usage flows from oVirt 3.3.

**Aftermath: the hybrid approach had been taken, where a QoS entity may be attached to the network on the DC level, but the QoS configuration on each host interface may be overridden from within the Setup Host Networks dialog.**

#### Host QoS important considerations

*   The traffic shaping is done at the logical link level, i.e., a bond, for networks that do use link aggregation or a nic, for those networks that don't.
*   The oVirt-defined networks will each get a network [traffic class](http://www.tldp.org/HOWTO/html_single/Traffic-Control-HOWTO/#c-class) to be shaped according to the limits (if any) set by the administrator (in a similar fashion as it is now for vNIC traffic) and there will be an extra network traffic class for traffic that does not belong to oVirt networks.
*   The different network traffic classes set over a logical link will contend for the device sending queue in an egalitarian deficit round robin way, i.e., each network should get the same chance to send its traffic under normal conditions.
*   Each logical network for which there are limits will have an enforced ceiling without borrowing from other networks. E.g., if you set a 100mbps limit on a network that is defined on top of a 1gbps connection, no more than 100mbps would be used even if the rest of the bandwidth is silent.

##### Entity Description

Since the Host Network QoS is most relevant in the context of a specific host interface (i.e. it could have completely different a QoS setup on each host interface), the most natural place to configure it would be when editing a network attached to a host interface, similarly to boot protocol configuration. However, as the most likely use case would be to enforce the same bandwidth limitations on all interfaces to which the network is attached, we'd like to implement the QoS configuration as part of the Network entity, and copy the configuration to the host's interfaces as the network is attached to them. This is not unlike what we do with VLAN tagging at the moment. Similarly to VLAN tagging, some users might prefer to have better granularity and apply different QoS configurations to different hosts using the same network; this will be made possible the moment we also implement "anonymous" QoS configuration at the level of a host interface, which should override the QoS configuration attached to the DC-wide Network entity.

No new entities need to be implemented, but some existing entities will have to be changed. The Network entity should be changed to include a NetworkQoS member, which would refer to the QoS configuration to be applied to host interfaces carrying this network. The VdsNetworkInterface should be similarly changed to include a NetworkQoS member, which in this case would refer to the actual QoS configuration reported by VDSM. These two entities could then be compared, in order to check whether the QoS configuration is "in sync"; if the QoS configuration is out-of-sync, the host network itself would also be marked as out-of-sync (similarly to what is done today with MTU, VLAN and so forth).

Since NetworkQoS entities comprise quite a few numeric fields, it would probably be preferable to continue holding them in their own network_qos table in the database, rather than add six columns to the network and vds_interface tables. This approach would also enable better maintainability in the future, as the NetworkQoS entity evolves and potentially more columns are added - they would only have to be added in the network_qos table. The NetworkQoS entities will be referred to, in the form of foreign keys, by qos_id columns of type UUID in both tables. Those reported by VDSM and referred to by the vds_interface table could have a "null" name and filtered out of queries, as they should be of no interest to the users (e.g. they should not be able to attach these entities to a network); they should be maintained (added, removed or updated) when collecting network data from the host.

NetworkQoS could either be changed to include a type (i.e. VM QoS or Host QoS) or not. The question is whether these two types could actually be different or not, and therefore if there's good reason to not enable one NetworkQoS configuration to be shared by both VMs and hosts. Even if in the future some features would be implemented first for, say, VM QoS and not for host QoS, it would probably be okay to just not apply the feature-specific parameters when the NetworkQoS entity is attached to a host's network. Either way we go, if we change our mind in the future the upgrade script would be reasonably straightforward:

*   Going from typeless to typed, each typeless NetworkQoS entity could be copied to a new typed one with an identical name according to the entities using it. If both types use it, two copies will made, one for each type. If no entity uses it, any behavior would be fine (but removing it would probably be cleanest).
*   Going from typed to typeless, each typed NetworkQoS entity would be duplicated as typeless by the same name. Here a problem would arise if a NetworkQoS by the same name existed for each type, in which case we would need some name generating algorithm.

Since at the moment there's no apparent reason to differentiate between VM and host QoS, and seeing as the upgrade script is simpler moving from typeless to typed (the price of an error is lower), the preference should probably be to stick with typeless NetworkQoS entities that may be shared by VM and host networks.

As for the handling of permissions, it remains to be shown that the current permission model on Network QoS isn't broken:

*   Attaching a pre-existing Network QoS entity to a network is not a problem, as a user editing a network has usage permissions on the DC and therefore the QoS entities in it.
*   Creating a new "named" Network QoS to be attached to a network will be performed by a separate call to the AddNetworkQoS action (and not as part of the Add/Edit Network action), therefore the user's permissions will be properly checked; the operation will fail if they don't have sufficient permissions on the DC.
*   Creating/updating the "anonymous" QoS configuration on a host's interface will be performed as part of the SetupNetworks action, so as long as the user has proper permissions of the host they'll be able to edit the interfaces' "anonymous" QoS values.

##### VDSM

Proposed [vdsm api](http://gerrit.ovirt.org/#/c/15724/) allows to provide traffic shaping parameters as part of NetworkOptions or setupNetworkNetAttributes used respectively by the addNetwork and setupNetworks verbs. In order to apply the configuration on the host network the Engine should convert attributes' values from Mb to kb (Megabit to Kilobit). VDSM generates a similar libvirt xml definition.

        `<network>`                                          
`    `<name>`vdsm-FinalAnswer`</name>
          ...
`    `<bandwidth>
`      `<inbound average='30000' burst='200000'  peak='40000'/>
`      `<outbound average='30000' burst='200000'  peak='40000' />
`    `</bandwidth>
`  `</network>

Example vdscli:

    from vdsm import vdscli
    connection = vdscli.connect()
    connection.addNetwork('whatever', '', '', ['p1p4'], {'qosInbound':{'average': 10000, 'burst': 48000, 'peak':12000 }})

It's possible to retrieve the QoS defined for an host's network with the following code:

    from vdsm import vdscli
    connection = vdscli.connect()
    connection.getVdsCapabilities()['info']['networks']['whatever']

the expected result should be something similar to:

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
     'qosInbound': {'average': 10000 , 'burst': 48000, 'peak': 12000},
     'qosOutbound': '',
     'stp': 'off'}

###### Implementation

![](Qos_hfsc.png "Qos_hfsc.png")

As depicted in the picture, there are four oVirt networks.all the leaf nodes would have an stochastic fair queuing (sfq) qdics to prevent connections from taking all the bandwidth of a traffic class):

*   Storage: Vlanned network with tag value 10. It is a non-shaped network for the host to access nfs. This traffic class has its fair share automatically set to the maximum of any shaped class and if extra bandwidth is available it just takes it. Filter to match it:

         tc filter add dev eth2 parent 1: prio 20 protocol 802.1q u32 match u16 10 0xFFF at -4 flowid 1:10

class definition:

         tc class add dev eth2 parent 1: classid 1:10 hfsc ls rate $(max_shaped_net)mbps

*   Databse: Vlanned network with tag value 20. It is a shaped network with outbound traffic share of 3mbps (capped at 5mbps) that serves for the VMs that run postgresql instances. If there is extra bandwidth available it will take more than it's 3mbps share, but never more than 5mbps (on average). Filter to match it:

         tc filter add dev eth2 parent 1: prio 20 protocol 802.1q u32 match u16 20 0xFFF at -4 flowid 1:20

class definition:

         tc class add dev eth2 parent 1: classid 1:20 hfsc ls rate 3mbps ul rate 5mbps

*   Web servers: Vlanned network with tag value 30. It is a shaped network with outbound traffic share of 20mbps (capped at 30mbps) that serves for VMs that run apache/nginx instances. The shaping is just like that in the database network but with different limits. Filter to match it:

         tc filter add dev eth2 parent 1: prio 30 protocol 802.1q u32 match u16 30 0xFFF at -4 flowid 1:30

class definition:

         tc class add dev eth2 parent 1: classid 1:30 hfsc ls rate 20mbps ul rate 30mbps

*   Display: Non-vlanned network. It is shaped, just as in the case of the web servers network, but with a tweak. Since it is important that the latency of the network is low, after all, nobody wants a laggy display, we set a burst period 1.5ms during which the network is allowed to transmit up to 40mbps. Filter to match:

         tc filter add dev eth2 parent 1: prio 5000 protocol all u32 match u32 0 0 flowid 1:5000  # Note that 5000 is chosen so that it is a catch all traffic of the device outside of the vlan range

class definition:

         tc class add dev eth2 parent 1: classid 1:5000 hfsc ls m1 40mbps d 1.5ms m2 20mbps ul rate 30mbps

##### RESTful API

As part of the VM Network QoS feature, no API was defined for the DC-level QoS entities, for various reasons. If the "named" QoS entity paradigm is preserved in this feature, I do not see any reason to hurry the process and force the definition of that API. However, if the "anonymous" QoS is also implemented, the values that define the QoS entity could be passed in the Setup Networks command as part of the NIC properties, and doesn't have to rely upon the REST implementation of the DC-level Network QoS entitiyes. This hasn't been implemented for oVirt 3.4.

##### User Experience

![ thumb | right](NetworkDialogQos.png  "fig: thumb | right") ![ thumb | right](InterfaceQosOverride.png  "fig: thumb | right")

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

#### Comments and Discussion

On the arch@ovirt.org and users@ovirt.org mailing lists.

<Category:Feature>
