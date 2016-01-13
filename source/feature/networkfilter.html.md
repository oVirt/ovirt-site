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

Network filter will enhance the admin ability to manged the network packets traffic from\\to the participated virtual machines (or "VMs" in short).

### Owner

Eliraz Levi

*   Name: [ Eliraz Levi](User:MyUser)

<!-- -->

*   Email: <elevi@redhat.com>

### Detailed Description

oVirt lets its user to create a Local area network (LAN) among different VMs running on different hosts. The Network representing this LAN is being defined as part of the data center.

Network filtering is the ability to choose what kind of packets a certain VM is able to send/received to/from the LAN. [<https://libvirt.org/firewall.html>| libvirt API] allows assigning a filter to each of the VM's virtual network interface (or "Vnic" for short). Those are connected to the host's bridge that represents the LAN network on a specific host. The Libvirt API is offering different filters such as no-mac-spoofing, no-ip-spoofing and more. For more details please confer the mentioned link.

Currently, Engine is using a single vdsm-no-mac-spoofing filter composed of no-mac-spoofing and no-arp-mac-spoofing filters for all of the networks. More details can be found in the following [|link](http://www.ovirt.org/Features/Design/Network/NetworkFiltering).

One of the main motivation for using a network filter is of security aspects as it is preventing VMs from sending/receiving illegal packets that abuse networks protocols, such as letting a VM controlled by a malicious customer impersonate an unrelated device.

The usage of the network filter has drawbacks though. One of them is the fact that they induce performances degradation. Another is that it prohibit usage of in-guest bonding devices or bridges. The latter are necessary for nested virtualization. Currently, the only way to disable the filter is by installing [1](https://libvirt.org/firewall.html|vdsm-hook-macspoof)

The feature will enable the user to choose the most suitable filter per network fits to his needs. The filter will be defined as part of the network's vnic profile.
It is important to mentioned that additional [feature](https://wiki.ovirt.org/Feature/linux_bridges_libvirt_management|vdsm) , which dropping all the packets that their MAC address doesn't belong to any vnic connected to bridge may has amplification on this feature. For example, though clean-traffic filter was chosen, some packets will not being forward to the VM's vnic, as those packets will be dropped in the host's bridge.

### Benefit to oVirt

Will improve the admin ability to adjust the network's vnic network filter matching best for his needs. Instead of manually installing and tweaking a Vdsm hook, he would have proper API and GUI. This would expose smart libvirt nwfilter features at the oVirt level.

### High Level Feature Description

#### Vdsm

1.  Vdsm-Engine API already includes a 'filter' argument per vnic, and Vdsm uses it to set the network filter of the libvirt `<interface>`. Please note, that if Engine passes a filter that is unknown to Vdsm, the VM would fail to start.
2.  Vdsm-Engine API needs to introduce parameters specification. Some of libvirt's filters allow to modify their behavior based on parameters such as
        <parameter name='IP' value='10.0.0.1'/>

    These parameters should be sent from Engine.

#### Engine

##### Data Base

1.  Add new table for network filters. The table will contain the name of each filter, version and possibly its uuid, as described in libvirt API. The table content may change only after upgrade, so we may cache its content on Engine start. The alternative is to fetch whenever the content is needed.

""TODO"" do we want to add description? if so, note for internationalize issues. *TODO* consider saving satellite table for variables validation (saving regex for example for ip)

1.  Add new network_filter_id column to vnic_profile table.
2.  Should consider adding ip_addr column in vm_interface table for representing the valid ip address for the specific VM's interface. Please note that it is possible for a malicious guest to mislead libvirt regarding its ip address. More details can be found in the following [<https://libvirt.org/formatnwfilter.html#nwfconceptsvars>| link]. Note that when defining a new VM cloud-init allows the admin to set an IP address per interface (or ask the interface to request an address via DHCP). We should extract the data from there, and not duplicate it in vm_interface.

**TODO**: find where cloud-init stores the IP info in the database.

1.  profile may have params (e.g. CTLR_IP_LEARNING, DHCPSERVER). where should they be stored?
2.  vm_interface may have params (no example except of IP). do we want to support them in this version? if so we need to decide where would they be stored.

##### Upgrade Script

Will consist the following parts:

1.  Creating and filling network_filter table.
2.  Adding network_filter_id column to vnic_profile set with the current default value of `vdsm-no-mac-spoofing` filter and also to the value configured in MacAntiSpoofingFilterRulesSupported option value in vdc_options
3.  Existing VMs would not have start to care about their IP addresses, as their existing (default) filter has no `IP` parameter.

##### Command

1.  Modify VM's NIC creation to set its filter based on its vNIC profile definition
2.  Vdsm does not allow changing the filter of currently-running VMs. We need to decide whether to allow changing the filter of a vNIC profile while it is used by running VMs.
    1.  Pro: Allowing change is a more agile usage. Admin can modify the filter while VMs are running.
    2.  Con: the admin may be surprised to find currently-running VMs that have an effectively out-of-date filter. E.g., he applied `clean-traffic` on the vNIC profile, but running VMs are still able to emit malicious packets.

#### Rest API

1.  Add command for listing all network filters:
    1.  Introduce **<network_filter>** element:

` `<network_filter>
`    `<name>`xxx`</name>
` `</network_filter>

1.  1.  add command <http://localhost:8080/ovirt-engine/api/cluster/><id>/networkfilter for displaying all network filters.

2.  Add vnic_profile network_filter id change.

for example: <http://localhost:8080/ovirt-engine/api/vnicprofiles/fcce2dae-f2e0-47d7-bbcc-12a0a8f7188e>

<vnic_profile href="/ovirt-engine/api/vnicprofiles/fcce2dae-f2e0-47d7-bbcc-12a0a8f7188e" id="fcce2dae-f2e0-47d7-bbcc-12a0a8f7188e">
`   `<name>`VNIC0`</name>
`   `<link href="/ovirt-engine/api/vnicprofiles/fcce2dae-f2e0-47d7-bbcc-12a0a8f7188e/permissions" rel="permissions"/>
`   `<pass_through>
`       `<mode>`disabled`</mode>
`   `</pass_through>
`   `<port_mirroring>`false`</port_mirroring>
`   `<network_filter>`xxxx`</network_filter>
`   `<network href="/ovirt-engine/api/networks/5768f4d0-ae35-4304-9c79-d68d88370a39" id="5768f4d0-ae35-4304-9c79-d68d88370a39"/>
</vnic_profile>

For back port compatibility:

1.  In case no filter was mentioned, the default vdsm-no-mac-spoofing will be added.
2.  In case no filter is desired, the user must explicitly set the value as NONE **<network_filter>NONE</network_filter>**

**TODO** add an example for defining a vNIC with a filter, and associated parameters.

#### Web Admin

1.  Add drop-down menu of available network filters to NewNetworkModel vNIC Profiles main tab.
2.  Sub Tab Network vNIC profile:
    1.  Add network filter column to the table.
    2.  Add drop-down menu of available network filters to VM Interface Profile. The user must be able to select no filter at all.

3.  Consider to add network filter column to the table of Sub Tab VM Network interface.

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

1.  Network will be defined at cluster level as data center will be deprecated. Validation should add
2.  Do we want to allow user custom user defined filters?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

1.  Upgrade script test:
    1.  Older data base no AntiMacSpoofing override Scenario:
        1.  Configure 3 data centers with version < 4.0 , with versions 3.0, 3.1 and one more version.
        2.  Add a Network with vNIC and assign it to the datacenter's default cluster (Do not assign the network to any other clusters).
        3.  Try to upgrade to 4.0
        4.  Expected result:
            1.  For all vNICs of network assign to cluster with 3.1 < version < 4.0 the filter will be configured to 'vdsm-no-mac-spoofing' with their corresponding assigning cluster's version.
            2.  For all vNICs of network assign to cluster with 3.1 or 3.0 the filter will be configured to 'ovirt-no-filter' with their corresponding assigning cluster's version.

<!-- -->

1.  1.  Older data base no AntiMacSpoofing override Scenario:

expected result: for all version different then

1.  1.  Older data base AntiMacSpoofing override Scenario:
    2.  Upgrade an already existing database with the follow configuration:

<!-- -->

1.  1.  First data base:
        1.  version: 3.6
        2.  

<!-- -->

1.  1.  data base version 3.5

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
