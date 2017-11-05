---
title: Setting up multiple networks is going to be much faster in oVirt 4.2
author: phoracek
tags: ovirt, 4.2.0, network
date: 2017-11-05 09:00:00 CET
comments: true
published: true
---
Assume you have an oVirt cluster with hundreds of VM networks. Now you add a
new host to the cluster. In order for it to move to the `Operational` state,
it must have all required networks attached to it. The easiest way to do it is
to attach networks to a label, and then place that label on a NIC of the added
host. However, if there are too many networks, Engine could fail to setup them
all at once. This is caused by a slow VDSM setupNetworks call that is not able
to finish within the 180 seconds long `vdsTimeout` of Engine.

READMORE

VDSM performance changes would be included in ovirt-4.2, currently in
ovirt-master.

Initscripts performance [patch][1] is targeted for EL 7.5.

The following table shows maximal number of networks that can be handled within
the vdsTimeout. The measured setupNetworks command handles one network with
static IP and **N** VLAN+bridge networks with no IP. Edit covered a move of all
networks from one NIC to another.

Please note that given numbers are for reference only.

|             installed              |  N  | add      | edit     | del |
|------------------------------------|:---:|---------:|---------:|----:|
| ovirt-4.2                          | 190 | **180s** | 127s     | 67s |
| ovirt-4.2 and patched initscripts  | 350 | 138s     | **176s** | 89s |
| ovirt-4.1                          | 150 | **179s** | 164s     | 93s |
| ovirt-4.1 and patched initscripts  | 215 | 111s     | **172s** | 79s |

The best improvement could be achieved with the initiscripts [patch][1]. It is
not distributed in repositories yet, but you can apply it manually without much
effort. However, even with bare ovirt-4.2 there is a significant speed-up.

[1]: https://github.com/fedora-sysv/initscripts/pull/132/commits/cf896bf9310a902912e0c6a4c4be5581ba8a1135
