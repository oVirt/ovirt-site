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

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

In our oVirt installation we are going to have a lot of Networks/VLAN's in a cluster. This means that when adding a host to this cluster, it means a lot of work adding all the different networks. Also, when adding a logical network, it means a lot of work adding the network to all the hosts.

Giving a label to the networks and the host's nics will simplify these use cases. When adding a new host- the user will need just to set labels on host's physical interfaces. When adding a network - the user will need just to set label on the network.

For example if the labels are:

    NIC A
    NIC B
    NIC C

On host1 it can be specified for instance:

    eth0 = NIC A
    eth1 = NIC C
    eth2 = NIC B

And on host2:

    bond0 = NIC A
    eth0 = NIC B
    eth1 = NIC C

And for vlan10 for example assign `NIC A` => all hosts in the cluster will have vlan10 assigned to the right nic (with `NIC A` label), without having to add it manually to all the hosts in the cluster.

### GUI changes

*   Cluster Network sub tab
    -   Adding command- Assign network to hosts (available on single and multiple selection)
    -   Assign/Unassign Networks
        -   Adding a new column named "Label" (When Editing (double click) will show a suggest box otherwise will show the label name). (The suggest box will show already used network labels and will allow to add a new label ).
*   Network Cluster sub tab
    -   Adding command- Assign network to hosts (available on single selection)
    -   Assign/Unassign Network
        -   Adding a new column named "Label" (When Editing (double click) will show a suggest box otherwise will show the label name).
*   Host Network interfaces sub tab
    -   Adding command- Assign all networks
    -   Setup Networks dialog
        -   Add Edit command on nic
            -   Add table with 2 columns - 1. label (suggest box on editing) and 2. assign all networks check box (with header for assign all).
        -   Edit bond
            -   Same as edit nic.
*   Network Host sub tab
    -   Setup Networks dialog - same as for Host Network interfaces sub tab.

### Benefit to oVirt

Simplify the process of adding a new host and new network to the cluster.

### Dependencies / Related Features

### Documentation / External references

### Comments and Discussion

<Category:Feature> <Category:Networking>
