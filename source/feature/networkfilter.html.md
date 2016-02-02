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

The usage of the network filter has drawbacks though. One of them is the fact that they induce performances degradation. Another is that it prohibit usage of in-guest bonding devices or bridges. The latter are necessary for nested virtualization. Currently, there are two ways to disable the filter. The first is by installing [1](https://libvirt.org/firewall.html|vdsm-hook-macspoof). The second is by adding a tuple to "vdc_options" table with option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = false and version = the vm's pool compatibility version.

The feature will enable the user to choose the most suitable filter per network fits to his needs. The filter will be defined as part of the network's vnic profile.
It is important to mentioned that additional [feature](https://wiki.ovirt.org/Feature/linux_bridges_libvirt_management|vdsm) , which dropping all the packets that their MAC address doesn't belong to any vnic connected to bridge may has amplification on this feature. For example, though ovirt-no-filter filter was chosen, some packets will not being forward to the VM's vnic, as those packets will be dropped in the host's bridge.

### Benefit to oVirt

Will improve the admin ability to adjust the network's vnic network filter matching best for his needs. Instead of manually installing and tweaking a Vdsm hook, he would have proper API and GUI. This would expose smart libvirt nwfilter features at the oVirt level.

### High Level Feature Description

#### Vdsm

1.  Vdsm-Engine API already includes a 'filter' argument per vnic, and Vdsm uses it to set the network filter of the libvirt `<interface>`. Please note, that if Engine passes a filter that is unknown to Vdsm, the VM would fail to start.
2.  Please note that in case Engine did not mentioned any network-filter, vdsm will not configure any. When the user is choosing no network filter, Engine will later , when describing the VM's xml not mention any "filter" element.
3.  Vdsm-Engine API needs to introduce parameters specification. Some of libvirt's filters allow to modify their behavior based on parameters such as
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

1.  Upgrade script tests:
    1.  Data base upgrade no AntiMacSpoofing override Scenario:
        1.  Configure 3 data centers with 3.0, 3.1 and one additional 3.1 < version < 4.0
        2.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        3.  Try to upgrade to 4.0.
        4.  Success conditions:
            1.  The network filters of DC's networks 3.0 and 3.1 are set to 'ovirt-no-filter'.
            2.  The network filter of DC's network <4.0 is set to 'vdsm-no-mac-spoofing'.

<!-- -->

1.  1.  Data base upgrade with partial AntiMacSpoofing override Scenario:
        1.  Configure 3 data centers with 3.0, 3.1 and two additional versions 3.1 < V1,V2 < 4.0
        2.  Add tuple to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = V1.
        3.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of DC's networks 3.0 ,3.1 and V1 are set to 'ovirt-no-filter'.
            2.  The network filter of DC's V2 is set to 'vdsm-no-mac-spoofing'.

<!-- -->

1.  1.  Data base upgrade with full AntiMacSpoofing override Scenario:
        1.  Configure 7 data centers with 3.0, 3.1, 3.2, 3.3, 3.4, 3.5 and 3.6.
        2.  Add 5 tuples to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = [version] where version = [3.2, 3.3, 3.4, 3.5, 3.6].
        3.  Add A Network with a vNIC for each with vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of all networks are set to 'ovirt-no-filter'.

<!-- -->

1.  1.  Data base upgrade with full AntiMacSpoofing override using 'general' Scenario:
        1.  Configure 7 data centers with 3.0, 3.1, 3.2, 3.3, 3.4, 3.5 and 3.6.
        2.  Add 1 tuple to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = 'general'.
        3.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of all networks are set to 'ovirt-no-filter'.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

                   filter_id               |       filter_name       | version 

--------------------------------------+-------------------------+---------

      00000019-0019-0019-0019-000000000308 | vdsm-no-mac-spoofing    | 3.2
      0000001a-001a-001a-001a-000000000281 | allow-arp               | 3.6
      0000001b-001b-001b-001b-0000000001d5 | allow-dhcp              | 3.6
      0000001c-001c-001c-001c-0000000003a2 | allow-dhcp-server       | 3.6
      0000001d-001d-001d-001d-00000000031f | allow-incoming-ipv4     | 3.6
      0000001e-001e-001e-001e-000000000281 | allow-ipv4              | 3.6
      0000001f-001f-001f-001f-000000000283 | clean-traffic           | 3.6
      00000020-0020-0020-0020-000000000106 | no-arp-ip-spoofing      | 3.6
      00000021-0021-0021-0021-0000000000c1 | no-arp-mac-spoofing     | 3.6
      00000022-0022-0022-0022-0000000002e8 | no-arp-spoofing         | 3.6
      00000023-0023-0023-0023-000000000317 | no-ip-multicast         | 3.6
      00000024-0024-0024-0024-000000000328 | no-ip-spoofing          | 3.6
      00000025-0025-0025-0025-000000000112 | no-mac-broadcast        | 3.6
      00000026-0026-0026-0026-0000000003a2 | no-mac-spoofing         | 3.6
      00000027-0027-0027-0027-000000000403 | no-other-l2-traffic     | 3.6
      00000028-0028-0028-0028-000000000164 | no-other-rarp-traffic   | 3.6
      00000029-0029-0029-0029-00000000006b | qemu-announce-self      | 3.6
      0000002a-002a-002a-002a-000000000070 | qemu-announce-self-rarp | 3.6

<vnic_profile>

<name>`customize`</name>
<network id="3704076a-8b6e-4dc8-9c46-992e0320dc29"/>

<network_filter id="00000025-0025-0025-0025-000000000112"/> </vnic_profile>

<http://localhost:8080/ovirt-engine/api/networks/3704076a-8b6e-4dc8-9c46-992e0320dc29/vnicprofiles>

*   Represents a readonly network filter entity.

`*  `<network_filter id="00000019-0019-0019-0019-00000000026b">
`*      `<name>`example-network-filter-b`</name>
`*      `<version>
`*          `<build>`-1`</build>
`*          `<major>`4`</major>
`*          `<minor>`0`</minor>
`*          `<revision>`-1`</revision>
`*      `</version>
`*  `</network_filter>
      *  Please note that version is referring to the minimal support version for the specific filter.
      */

`* `<network_filters>
`*     `<network_filter id="00000019-0019-0019-0019-00000000026c">
`*         `<name>`example-network-filter-a`</name>
`*         `<version>
`*             `<build>`-1`</build>
`*             `<major>`4`</major>
`*             `<minor>`0`</minor>
`*             `<revision>`-1`</revision>
`*         `</version>
`*     `</network_filter>
`*     `<network_filter id="00000019-0019-0019-0019-00000000026b">
`*         `<name>`example-network-filter-b`</name>
`*         `<version>
`*             `<build>`-1`</build>
`*             `<major>`4`</major>
`*             `<minor>`0`</minor>
`*             `<revision>`-1`</revision>
`*         `</version>
`*     `</network_filter>
`*     `<network_filter id="00000019-0019-0019-0019-00000000026a">
`*         `<name>`example-network-filter-a`</name>
`*         `<version>
`*             `<build>`-1`</build>
`*             `<major>`3`</major>
`*             `<minor>`0`</minor>
`*             `<revision>`-1`</revision>
`*         `</version>
`*     `</network_filter>
`* `</network_filters>
      *

      * Since 4.0 it is possible to have a customize network filter to each vnic profile.
      * Please note that there is a default network filter to each vnic profile.
      * For more details of how the default network filter is calculated please refer to the documentation in NetworkFiltersService.
      *
      * The basic POST command of adding a new vnic profile is as followed:
`* `[`http://{engine_ip_address}:8080/ovirt-engine/api/networks/{network_id}/vnicprofiles`](http://{engine_ip_address}:8080/ovirt-engine/api/networks/{network_id}/vnicprofiles)
      *
      * The output of creating a new vnic profile depends in the BODY arguments that were given.
      * From network filter configuration prespecitve of view:
      * In case no network filter was mentioned, the default network filter will be configured. For example:
`*  `<vnic_profile>
`*      `<name>`use_default_network_filter`</name>
`*      `<network id="00000000-0000-0000-0000-000000000009"/>
`*  `</vnic_profile>
      *
      * In case en empty network filter was mentioned, no network filter will be configured for the specific vnic profile regardless of the vnic profile's default network filter.
      * For example:
`*  `<vnic_profile>
`*      `<name>`no_network_filter`</name>
`*      `<network id="00000000-0000-0000-0000-000000000009"/>
`*      `<network_filter/>
`*  `</vnic_profile>
      *
      * In case that a specific valid network filter id was mentioned, the vnic profile will be configured with the mentioned network filter regardless of the vnic profiles's default network filter.
      * For example:
`* `<vnic_profile>
`*     `<name>`user_choice_network_filter`</name>
`*     `<network id="00000000-0000-0000-0000-000000000009"/>
`*     `<network_filter id= "0000001b-001b-001b-001b-0000000001d5"/>
`* `</vnic_profile>

<Category:Feature> <Category:Template>
