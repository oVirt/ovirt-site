---
title: Host Network QoS
category: feature
authors:
  - amuller
  - danken
  - gvallarelli
  - lvernia
---

# Host Network QoS

### Summary

This feature provides means by which to control the traffic of a specific network through a host's physical interface. It is a natural extension of the [VM Network QoS](/develop/sla/network-qos.html) feature, which provided the same functionality for a VM network through a VM's virtual interface.

You may also refer to the [detailed feature page](/develop/release-management/features/network/detailed-host-network-qos.html).

### Owner

*   Name: Lior Vernia (previously owned by Giuseppe Vallarelli)
*   E-mail: lvernia@redhat.com
*   IRC: lvernia at #ovirt (irc.oftc.net)

### Detailed Description

Generally speaking, network QoS (Quality of Service) in oVirt could be applied on a variety of different levels:

*   VM - control the traffic passing through a virtual NIC (virtual Network Interface Controller).
*   Host - control the traffic from a specific network passing through a physical NIC.
*   DC (Data Center) - control the traffic related to a specific logical network throughout the entire DC, including through its infrastructure (e.g. L2 switches).

The VM level was taken care of as part of the [VM Network QoS](/develop/sla/network-qos.html) feature in oVirt 3.3, whereas this feature aims to take care of the host level in a similar manner; it will be possible to cap bandwidth usage of a specific network on a specific network interface of a host, both for average usage and peak usage for a short period of time ("burst"), so that no single network could "clog" an entire physical interface.

DC-wide QoS remains to be handled in the future.

### Benefit to oVirt

This feature would help to prevent situations in which two or more networks are attached to the same physical NIC of a host, where one of the two networks is prone to heavy traffic and could potentially overutilize the NIC to the point where the other network(s) don't function.

![](/images/wiki/Host_network_qos.png)

One oVirt 3.3 feature that could specifically benefit from host-level QoS is [Migration Network](/develop/release-management/features/network/migration-network.html), which enabled to designate a specific network to be used for VM migration, to avoid burdening the management network. For the management network to continue functioning properly, it would likely have to be attached to a different network interface on the host, otherwise migration-related traffic could easily lead to congestion. Being able to configure network QoS on the host level means that these two networks could now reside on the same physical NIC without fear of congestion, as can be seen in the diagram above.

### Testing

The following steps should be tested:

1.  Create a non-VM network and assign it to a host.
2.  Edit the network, create a new (non-empty) QoS entity from that dialog.
3.  Verify that the newly-created QoS entity is the default selection in the list box, and approve of the dialog.
4.  Verify that the network appears as out-of-sync in the host's Setup Networks dialog.
5.  Edit the network (hover + click on pencil icon), mark it to be synchronized and approve of the Setup Networks dialog.
6.  Verify that the network's QoS configuration is applied to the host (possibly by running "vdsClient [-s] 0 getVdsCaps" on the host's command line).
7.  Edit the network on the host again, this time checking the "QoS override" checkbox and configuring other QoS values directly on the interface.
8.  Again verify that the QoS configuration is applied to the host.
9.  Edit the network entity, and set its QoS configuration to "Unlimited".
10. Verify that the network does NOT appear as out-of-sync on the host.
11. Functional test - initiate usage of the network to which QoS had been applied, monitor the traffic on it and verify that it is capped according to the QoS limitations.
12. Move the host to a different cluster, whose compatibility version is smaller than 3.4; verify that it is no longer possible to override the QoS configuration on an interface via the Setup Networks dialog.

### Comments and Discussion

On the devel@ovirt.org and users@ovirt.org mailing lists.

