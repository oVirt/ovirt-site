---
title: Network Labels
authors: alkaplan, danken, moti
wiki_title: Features/Network Labels
wiki_revision_count: 12
wiki_last_updated: 2013-11-30
---

# Network Lables

### Summary

*   ability to flag a physical interface/bond with a label
*   ability to flag a logical network with a label
*   engine will automatically associate the logical network with the physical
*   interface on all hosts in cluser with same label.
*   tbd: when are hosts updated/sync'd with the configuration (automatic or manual).

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

In our RHEV installation we are going to have a lot of Networks/VLAN's in a cluster. This means that when adding a host to this cluster, it means a lot of work adding all the different networks. Also, when adding a logical network, it means a lot of work adding the network to all the hosts.

Giving a label to the networks and the host's nics will simplify these use cases. When adding a new host- the user will need just to set labels on host's physical interfaces. When adding a network - the user will need just to set label on the network.

For example if the labels are: NIC A NIC B NIC C

On host1 it can be specified for instance: eth0 = NIC A eth1 = NIC C eth2 = NIC B

And on host2: bond0 = NIC A eth0 = NIC B eth1 = NIC C

And for vlan10 for example assign NIC A => all hosts in the cluster will have vlan10 assigned to the right nic (with NIC A label), without having to add it manually to all the hosts in the cluster.

### GUI changes

### Benefit to oVirt

Simplify the process of adding a new host and new network to the cluster.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/666883>

### Comments and Discussion

<Category:Feature> <Category:Networking>
