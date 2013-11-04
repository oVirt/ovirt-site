---
title: Host Network QoS
category: feature
authors: amuller, danken, gvallarelli, lvernia
wiki_category: Feature
wiki_title: Features/Host Network QoS
wiki_revision_count: 76
wiki_last_updated: 2014-09-04
---

# Host Network QoS

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

*   Status: design
*   Last updated: ,

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a virtual NIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   DC (Data Center) - control the traffic related to a specific logical network throughout the entire DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](Features/Network_QoS) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

DC-wide QoS remains to be handled in the future.

#### Benefit to oVirt

This feature would help to prevent situations in which two or more networks are attached to the same physical NIC of a host, where one of the two networks is prone to heavy traffic and could potentially overutilize the NIC to the point where the other network(s) don't function.

One oVirt 3.3 feature that could specifically benefit from host-level QoS is [Migration Network](Features/Migration_Network), which enabled to designate a specific network to be used for VM migration, to avoid burdening the management network. For the management network to continue functioning properly, it would likely have to be attached to a different network interface on the host, otherwise migration-related traffic could easily lead to congestion. Being able to configure network QoS on the host level means that these two networks could now reside on the same physical NIC without fear of congestion.

# User experience

A user can define traffic shaping during creation of a logical network. Traffic shaping can be redefined when attaching a logical network to the physical host interfaces during a Setup Host Networks task (see images below):

![](new_lnetwork_bandwidth.png "new_lnetwork_bandwidth.png")

Selecting the checkbox (Incoming/Outgoing or both) a user can shape the related kind of traffic using the needed parameters. A user needs to specify all three parameters: average, burst and peak.

![](Ledit_network.png "Ledit_network.png")

An icon should be associated with the network in Logical Networks list and the "Setup Host Networks" UI in order to provide a visual feedback for bandwidth shaped networks.

# Implementation

### Backend / DB Change

A change in the network_qos table and in the related business entities might be needed in order to make a distinction of quality of service related to a vnic or to a network.

### Classes (not complete list yet)

*Reuse:*

*   **engine.core.common.businessentities.network.NetworkQoS**
*   **engine.core.dao.network.NetworkQoSDao**

*Update:*

*   **engine.core.common.businessentities.network.Network** - add field networkQos (NetworkQos)
*   **engine.core.common.businessentities.network.VdsNetworkInterface** - add field networkQos (NetworkQos)

### DB

For the purpose we can reuse the network_qos table as defined in [Network QoS](Features/Design/Network_QoS#DB_Change_2). Affected tables are the network table (logical network) and the vds_interface table (running host information). In particular we need to provide to both tables a reference to a definition of QoS available in the network_qos table.

### Rest API

TBD.

### VDSM

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

# Comments and Discussion

*   Refer to [Talk: Host Network Traffic Shaping](Talk: Host Network Traffic Shaping)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
