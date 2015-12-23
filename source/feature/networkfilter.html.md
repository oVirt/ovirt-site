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

oVirt lets its user to create a Local area network (LAN) among different VMs running on different hosts. The Network representing this LAN is being defined as part of the data center and used by each VM.

Network filtering is the ability to choose what kind of packets a certain VM is able to send/received to/from the LAN. [<https://libvirt.org/firewall.html>| libvirt API] allows assigning a filter to each of the VM's virtual network interface (or "Vnic" for short) being connected to a bridge that represents the LAN network on a specific host. The Libvirt API is offering different filters such as no-mac-spoofing, no-ip-spoofing and more. For more details please confer the mentioned link.

Currently, Engine is using a single vdsm-no-mac-spoofing filter composed of no-mac-spoofing and no-arp-mac-spoofing filters for all of the networks. More details can be found in the following [<http://www.ovirt.org/Features/Design/Network/NetworkFiltering>| link].

One of the main motivation for using a network filter is of security aspects as it is preventing VMs from sending/receiving illegal packets that abuse networks protocols, such as letting a VM controlled by a malicious customer impersonate an unrelated device.

The usage of the network filter has drawbacks though. One of them is the fact that they induce performances degradation. Another is that it prohibit usage of in-guest bonding devices or bridges. The latter are necessary for nested virtualization. Currently, the only way to disable the filter is by installing [<https://libvirt.org/firewall.html>| vdsm-hook-macspoof] The feature will enable the user to choose the most suitable filter per network fits to his needs. The filter will be defined as part of the network's vnic profile.
It is important to mentioned that additional [<https://wiki.ovirt.org/Feature/linux_bridges_libvirt_management>| vdsm feature] , which dropping all the packets that their MAC address doesn't belong to any vnic connected to bridge may has amplification on this feature. Though clean-traffic filter was chosen, some packets will not being forward to the VM's vnic, as those packets will be dropped in the host's bridge.

### Benefit to oVirt

Will improve the admin ability to adjust the network's vnic network filter matching best for his needs.
Will also save the need of using vdsm hooks of changing the default network filter.

### High Level Feature Description

#### Vdsm

1.  Vdsm sets the vnic network filter according to the received filter from Engine. Please note, that passing unsupported filter behavior is undefined.
2.  Vdsm will need to introduce variables values specification (etc. filter all packets by source address)

#### Engine

##### Data Base

1.  Add new table for network filters. The table will contains two columns - uuid and name as described in libvirt API.
2.  Add new network_filter_id column to vnic_profile table.
3.  Should consider adding ip_addr column in vm_interface table. The value there should represent the valid ip address for the specific VM's interface. Please note that it is possible for a VM to mislead libvirt regarding it's ip address. more details can be found in the following [<https://libvirt.org/formatnwfilter.html#nwfconceptsvars>| link].

##### Upgrade Script

Will consist the following parts:

1.  Creating and populating network_filter table.
2.  Adding network_filter_id column to vnic_profile set with the current default value of vdsm-no-mac-spoofing filter.
3.  In case VM's interface ip_addr allocation will be supported, further thoughts is required regarding the upgrade.

##### Command

1.  Modify VM's nic creation to configure the network's filter
2.  Should consider corner cases for logical network's network filter modification:
    1.  Network filter was modified - should all VM connected to the host should be modified?
    2.  Host H is in the data center. Network 'XXX' is not defined in the data center but was already configured in the host H (papers as un-managed network ). Network 'XXX' is now being added with different network filter.

#### Rest API

1.  Add command for listing all network filters
2.  Add vnic_profile network_filter id chage.

#### Web Admin

1.  Add drop down menu of available networks filter to NewNetworkModel vnic Profiles main tab.
2.  Sub Tab Network vnic profile:
    1.  Add network filter column to the table.
    2.  add drop down menu of available networks filter to VM Interface Profile.

3.  Consider to add network filter column to the table of Sub Tab VM Network interface.

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
