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

### Summary

In order to provide better control of networks traffic, we need to define traffic boundaries for incoming and outgoing traffic. This goal is achieved by providing a general traffic shaping template which can be applied to an abstract network entity and can optionally be redefined on a per host network basis.

### Owner

*   Name: [ Giuseppe Vallarelli](User:gvallarelli)
*   Email: <gvallare@redhat.com>
*   IRC: gvallarelli at #ovirt (irc.oftc.net)

### Current Status

*   Status: design
*   Last updated: ,

### Detailed description

[Current implementation of libvirt](http://libvirt.org/formatnetwork.html) allows shaping of incoming (inbound) and outgoing (outbound) traffic in a network, both types of traffic can be shaped independently. Shaping a network traffic requires the definition of 3 attributes:

*   Average: Average bit rate on the interface being shaped (Mbps).
*   Burst: Burst, amount of Mb that can be burst at peak speed(Mb).
*   Peak: Maximum rate at which interface can send data (Mbps).

For example defining a network "Students" with outbound traffic defined with average, burst and peak respectively 20, 200, 40 means that traffic will flow at 20 Mbps on average and the interface will be able to send a maximum of 200 Mb at the peak speed of 40 Mbps.

### Benefit to Ovirt

Shaping network traffic is useful for network administrators, where they can provide a different class of service according to the different kind of usages they need to satisfy. It might be also useful to limit the bandwidth of a [migration network](Features/Migration_Network) or in general to every network who could possibly saturate the overall network bandwidth.
