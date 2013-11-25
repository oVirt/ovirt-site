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

You may also refer to the [detailed feature page](Features/Detailed_Host_Network_QoS).

#### Owner

*   Name: Lior Vernia (previously owned by Giuseppe Vallarelli)
*   E-mail: lvernia@redhat.com
*   IRC: lvernia at #ovirt (irc.oftc.net)

#### Current Status

*   Target Release: oVirt 3.4
*   Status: design
*   Last updated: November 25th, 2013.

#### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a virtual NIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   DC (Data Center) - control the traffic related to a specific logical network throughout the entire DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](Features/Network_QoS) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

DC-wide QoS remains to be handled in the future.

#### Benefit to oVirt

This feature would help to prevent situations in which two or more networks are attached to the same physical NIC of a host, where one of the two networks is prone to heavy traffic and could potentially overutilize the NIC to the point where the other network(s) don't function.

![](Host_network_qos.png "Host_network_qos.png")

One oVirt 3.3 feature that could specifically benefit from host-level QoS is [Migration Network](Features/Migration_Network), which enabled to designate a specific network to be used for VM migration, to avoid burdening the management network. For the management network to continue functioning properly, it would likely have to be attached to a different network interface on the host, otherwise migration-related traffic could easily lead to congestion. Being able to configure network QoS on the host level means that these two networks could now reside on the same physical NIC without fear of congestion, as can be seen in the diagram above.

#### Comments and Discussion

On the arch@ovirt.org and users@ovirt.org mailing lists.

<Category:Feature>
