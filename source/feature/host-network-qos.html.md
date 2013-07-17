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

In order to provide traffic control for a network, we need to define boundaries for incoming and outgoing traffic (Traffic Shaping - TS for simplicity). This goal is achieved by defining inbound and outbound traffic (as defined in [Features/Network_QoS#Detailed_Description Network QoS](Features/Network_QoS#Detailed_Description_Network_QoS)) for an host network by enabling TS when creating a new logical network or when editing a previously associated logical network, i.e. an host network.

#### Owner

*   Name: [ Giuseppe Vallarelli](User:gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

#### Current Status

*   Status: design
*   Last updated: ,

#### Detailed description

The admin /network admin is the only user who should be able to define Traffic Shaping. TS defined in a logical network in the DC acts like a template, so any changes to the TS in the host network doesn't affect the TS template in the logical network. If the user changes the TS definition in the Logical network this will not affect previously associated TS in the host network. Simply put the logical network definition is not tied to the running network definition, TS associated to a logical network definition is only copied over the operational host for the first time later on they are completely independent. In case an host with traffic shaping defined is moved over a different DC and for some reasons is marked as not operational (for example due to a different vlan id) before editing the network the running configuration should be synchronized to the logical one, before being able to edit the host network.

#### Benefit to Ovirt

Shaping network traffic is useful for network administrators, where they can provide a different class of service according to the different kind of usages they need to satisfy. It might be also useful to limit the bandwidth of a [migration network](Features/Migration_Network) or in general to every network who could possibly choke/saturate the overall interface bandwidth.

## User experience

A user can define traffic shaping during creation of a logical network. Traffic shaping can be redefined when attaching a logical network to the physical host interfaces during a Setup Host Networks task (see images below):

![](new_lnetwork_bandwidth.png "new_lnetwork_bandwidth.png")

Selecting the checkbox (Incoming/Outgoing or both) a user can shape the related kind of traffic using the needed parameters. A user needs to specify all three parameters: average, burst and peak.

![](Ledit_network.png "Ledit_network.png")

An icon should be associated with the network in Logical Networks list and the "Setup Host Networks" UI in order to provide a visual feedback for bandwidth shaped networks.

## Implementation

### Backend / DB Change

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

## Comments and Discussion

*   Refer to [Talk:Network Traffic Shaping](Talk:Network Traffic Shaping)
*   On the arch@ovirt.org mailing list.

<Category:Feature>
