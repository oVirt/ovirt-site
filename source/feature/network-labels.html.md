---
title: Network Labels
authors: alkaplan, danken, moti
wiki_title: Features/Network Labels
wiki_revision_count: 12
wiki_last_updated: 2013-11-30
---

The actual name of your feature page should look something like: "Your feature name". Use natural language to [name the pages](How to make pages#Page_naming).

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

In our RHEV installation we are going to have a lot of VLAN's in a cluster. This means that when adding a host to this cluster, it means a lot of work adding all the different networks. Also, when adding a VLAN, it means a lot of work adding the VLAN to all the hosts.

It would be a good feature to be able to have a host profile, where you have: NIC A NIC B NIC C

On host1 you then specify for instance: eth0 = NIC A eth1 = NIC C eth2 = NIC B And on host2: bond0 = NIC A eth0 = NIC B eth1 = NIC C

And then you assign a VLAN to for example NIC A, and all hosts in the cluster will have that VLAN assigned to the right NIC, without having to add it to all the hosts in the cluster 08:12, 30 April 2013 (GMT)08:12, 30 April 2013 (GMT)08:12, 30 April 2013 (GMT)08:12, 30 April 2013 (GMT)08:12, 30 April 2013 (GMT)[Alkaplan](User:Alkaplan) ([talk](User talk:Alkaplan))

3) Business Requirements Satisfied By Request: "We offer a Virtual DataCenter to our customors, based on RHEV, but with our own gui that connect through an api. For each customer we will have at least 2 VLAN's, this will mean a lot of vlan's. Suppose we have 30 hosts, and 60 vlans. - Now we add host 31, we will have to add all 60 VLANS to host 31. That is a lot of clicking in the gui. - we get a new customer, and add 2 vlans: on all 31 hosts we need to add those 2 vlans, again a lot of work.

with my proposal: add host 31: map physical interfaces to host profile interfaces and you are done. add customer: add 2 vlans to a NIC in host profile and you are done."

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

<https://bugzilla.redhat.com/666883>

### Comments and Discussion

<Category:Feature> <Category:Networking>
