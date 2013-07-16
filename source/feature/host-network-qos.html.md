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

In order to provide traffic control of a network, we need to define boundaries for incoming and outgoing traffic. This goal is achieved by defining inbound and outbound traffic (as defined in [Features/Network_QoS#Detailed_Description Network QoS](Features/Network_QoS#Detailed_Description_Network_QoS)) for an abstract network entity.

#### Owner

*   Name: [ Giuseppe Vallarelli](User:gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

#### Current Status

*   Status: design
*   Last updated: ,

#### Detailed description

During creation of a new logical network or when editing a logical network associated to a physical interface (Setup host networks), the user (admin /network admin) should be able to select one of the available Network QoS in the DC or create a new Network QoS if the available ones don't satisfy his needs.

Applying traffic shaping to a logical network doesn't involve any change in the DC hosts. Traffic shaping on a host network is applied when a logical network is associated with the host interface or when editing a previously shaped network.

#### Benefit to Ovirt

Shaping network traffic is useful for network administrators, where they can provide a different class of service according to the different kind of usages they need to satisfy. It might be also useful to limit the bandwidth of a [migration network](Features/Migration_Network) or in general to every network who could possibly choke/saturate the overall interface bandwidth.

## User experience

A user can define traffic shaping during creation of a logical network. Traffic shaping can be redefined when attaching a logical network to the physical host interfaces during a Setup Host Networks task (see images below):

![](new_lnetwork_bandwidth.png "new_lnetwork_bandwidth.png")

Selecting the checkbox (Incoming/Outgoing or both) a user can shape the related kind of traffic using the needed parameters. A user needs to specify all three parameters: average, burst and peak.

![](edit_lnetwork_bandwidth.png "edit_lnetwork_bandwidth.png")

An icon should be associated with the network in Logical Networks list and the "Setup Host Networks" UI in order to provide a visual feedback for bandwidth shaped networks.

todo: replace network traffic limit label to host traffic limit - it might be misleading (2nd mockup).

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
