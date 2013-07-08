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

## Network traffic shaping

#### Summary

In order to provide better control of networks traffic, we need to define traffic boundaries for incoming and outgoing traffic. This goal is achieved by providing a general traffic shaping template which can be applied to an abstract network entity. User can optionally redefine the traffic shaping template on a per host network basis.

#### Owner

*   Name: [ Giuseppe Vallarelli](User:gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

#### Current Status

*   Status: design
*   Last updated: ,

#### Detailed description

[Current implementation of libvirt](http://libvirt.org/formatnetwork.html) allows shaping of incoming (inbound) and outgoing (outbound) traffic in a network, both types of traffic can be shaped independently. Shaping a network traffic requires the definition of 3 attributes:

*   Average: Average bit rate on the interface being shaped (Mbps).
*   Burst: Burst, amount of Mb that can be burst at peak speed (Mb).
*   Peak: Maximum rate at which interface can send data (Mbps).

For example defining a network "Students" with outbound traffic defined with average, burst and peak respectively 20, 200, 40 means that traffic will flow at 20 Mbps on average and the interface will be able to send a maximum of 200 Mb at the peak speed of 40 Mbps, for the shaped network.

#### Benefit to Ovirt

Shaping network traffic is useful for network administrators, where they can provide a different class of service according to the different kind of usages they need to satisfy. It might be also useful to limit the bandwidth of a [migration network](Features/Migration_Network) or in general to every network who could possibly choke/saturate the overall interface bandwidth.

## User experience

A user can define traffic shaping during creation of a logical network. Traffic shaping can be redefined when attaching a logical network to the physical host interfaces during a Setup Host Networks task (see images below):

![](new_lnetwork_bandwidth.png "new_lnetwork_bandwidth.png")

Selecting the checkbox (Incoming/Outgoing or both) a user can shape the related kind of traffic using the needed parameters. A user needs to specify all three parameters: average, burst and peak.

![](edit_lnetwork_bandwidth.png "edit_lnetwork_bandwidth.png")

An icon should be associated with the network in Logical Networks list and the "Setup Host Networks" UI in order to provide a visual feedback for bandwidth shaped networks.

todo: replace network traffic limit label to host traffic limit - it might be misleading.

## Implementation

### Backend / DB Change

We should reuse the entity NetworkQoS and network_qos database table as defined in [Network QoS for Vnic](http://www.ovirt.org/Features/Design/Network_QoS_-_detailed_design#Backend).

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

## Comments and Discussion

*   Refer to [Talk:Network Traffic Shaping](Talk:Network Traffic Shaping)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
