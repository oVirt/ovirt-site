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

#### Owner

*   Name: Lior Vernia
*   E-mail: lvernia@redhat.com
*   IRC: lvernia at #ovirt (irc.oftc.net)

#### Original Owner

*   Name: [ Giuseppe Vallarelli](User:gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

#### Current Status

*   Target Release: 3.4
*   Status: design
*   Last updated: November 6th, 2013.

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a virtual NIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   DC (Data Center) - control the traffic related to a specific logical network throughout the entire DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](Features/Network_QoS) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

DC-wide QoS remains to be handled in the future.

Implementation-wise, we could take one of two different approaches:

*   Proceed with the VM Network QoS paradigm, that is creating named Network QoS entities that can be shared between different networks. The advantages here are that the administrator is accustomed to the same QoS usage flow across VM and host networking, and that a few QoS configurations could be easily shared by many instances of networks on host interfaces.
*   Define QoS parameters directly on the host's interfaces when networks are attached to them (similarly to boot protocol, for example). The advantage in this approach is added simplicity when the number of different QoS configurations is similar to the number of host NICs where QoS needs to be configured.

It seems that the advantages of the first approach outweigh those of the second approach, therefore I will from now on assume that the first has been chosen (I will remark though that some of its advantage may be offset by a Host Template feature, if that is introduced in the near future).

##### Entity Description

No new entities need to be implemented, but VdsNetworkInterface should be changed to include a reference to an attached NetworkQoS entity's GUID, as well as the QoS parameters retrieved from VDSM; both of them would be needed to check whether the interface is in sync, from a QoS point of view (similarly to what is done with networks).

NetworkQoS could either be changed to include a type (i.e. VM QoS or Host QoS) or not. The question is whether these two types could actually be different or not, and therefore if there's good reason to not enable one NetworkQoS configuration to be shared by both VMs and hosts. Even if in the future some features would be implemented first for, say, VM QoS and not for host QoS, it would probably be okay to just not apply the feature-specific parameters when the NetworkQoS entity is attached to a host's network. Either way we go, if we change our mind in the future the upgrade script would be reasonably straightforward:

*   Going from typeless to typed, each typeless NetworkQoS entity could be copied to a new typed one with an identical name according to the entities using it. If both types use it, two copies will made, one for each type. If no entity uses it, any behavior would be fine (but removing it would probably be cleanest).
*   Going from typed to typeless, each typed NetworkQoS entity would be duplicated as typeless by the same name. Here a problem would arise if a NetworkQoS by the same name existed for each type, in which case we would need some name generating algorithm.

Since at the moment I see no reason to differentiate between VM and host QoS, and seeing as the upgrade script is simpler moving from typeless to typed (the price of an error is lower), the preference should probably be to stick with typeless NetworkQoS entities that may be shared by VM and host networks.

##### User experience

A user can define traffic shaping during creation of a logical network. Traffic shaping can be redefined when attaching a logical network to the physical host interfaces during a Setup Host Networks task (see images below):

![](new_lnetwork_bandwidth.png "new_lnetwork_bandwidth.png")

Selecting the checkbox (Incoming/Outgoing or both) a user can shape the related kind of traffic using the needed parameters. A user needs to specify all three parameters: average, burst and peak.

![](Ledit_network.png "Ledit_network.png")

An icon should be associated with the network in Logical Networks list and the "Setup Host Networks" UI in order to provide a visual feedback for bandwidth shaped networks.

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
    connection.addNetwork('whatever', '', '', ['p1p4'], {'qosInbound':{'average': '10000', 'burst': '48000', 'peak':'12000' }})

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
     'qosInbound': {'average': '10000' , 'burst': '48000', 'peak': '12000'},
     'qosOutbound': '',
     'stp': 'off'}

## Comments and Discussion

*   Refer to [Talk: Host Network Traffic Shaping](Talk: Host Network Traffic Shaping)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
