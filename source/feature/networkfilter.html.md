---
title: NetworkFilter
category: feature
authors: elevi
wiki_category: Feature
wiki_title: Features/NetworkFilter
wiki_revision_count: 121
wiki_last_updated: 2016-02-02
feature_name: Network filter
feature_modules: engine,network
feature_status: new
---

# Network Filter

### Summary

Network filter will enhance the admin ability to manged the network packets traffic from\\to the participated virtual machines (or "vm" in short).

### Owner

Eliraz Levi

*   Name: [ Eliraz Levi](User:MyUser)

<!-- -->

*   Email: <elevi@redhat.com>

### Detailed Description

One of oVirt benefit is the ability to create a Local area network (LAN) among different vms running on different hosts.
The Network representing the described LAN is being defined in cluster level.
Network filtering is the ability to choose what kind of packets a certain vm, is being able to send\\received to\\from the LAN.
[<https://libvirt.org/firewall.html>| libvirt API] is enabling to assign a filter policy to each of the vm's virtual network interface (or "vnic" in short) being connected to a bridge that representing the LAN network. Libvirt API is offering different default types of filters such as no-mac-spoofing, no-ip-spoofing and more. For more details please follow the mentioned link.
Currently, engine is having a default custom vdsm-no-mac-spoofing filter composed of no-mac-spoofing and no-arp-mac-spoofing filters for all of the networks. More details can be found in the following [<http://www.ovirt.org/Features/Design/Network/NetworkFiltering>| link].
One of the main motivation for using a network filter is of security aspects as it is preventing from vms to send\\received illegal packets that abusing networks protocols drawbacks.
The usages of the network filter has one main drawback thought. The drawback related to the naive libvirt's network filtering implementation. When adding a filter to a vnic, libvirt will add a rule to ebtables and iptabels of the host, one for each vnic. The rule will enforce the required handling of the packets related to the vnic as described in the defined filter. As a result, the handling of each packet handling by the bridge is linear with the amount of vnic connected to the bridge, hurting preferences.
Currently the only way of disabling the default filter is by using a vdsm hook. //TODO complete this
The feature will enable the user to choose the most suitable filter per network matching his needs. The filter will be defined as part of the network's vnic profile. It is important to mentioned that additional vdsm feature, which dropping all packets doens't

### Benefit to oVirt

Will improve the admin ability to adjust the network's vnic network filter matching best for his needs.
Will also save the need of using vdsm hooks of changing the default network filter.

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
