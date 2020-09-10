---
title: NetworkFilter
category: feature
authors: elevi
feature_name: Network filter
feature_modules: engine,network
feature_status: new
---

# Network Filter

## Summary

Network filter will enhance the admin ability to manged the network packets traffic from\\to the participated virtual machines (or "VMs" in short).

## Owner

Eliraz Levi

*   Name: Eliraz Levi


## Detailed Description

oVirt lets its user to create a Local area network (LAN) among different VMs running on different hosts.
The Network representing this LAN is being defined as part of the data center.

Network filtering is the ability to choose what kind of packets a certain VM is able to send/received to/from the LAN.
[libvirt API](https://libvirt.org/firewall.html) allows assigning a filter to each of the VM's virtual network interface (or "Vnic" for short).
Those are connected to the host's bridge that represents the LAN network on a specific host.
The Libvirt API is offering different filters such as `no-mac-spoofing`, `no-ip-spoofing` and more. For more details please confer the mentioned link.

Currently, Engine is using a single `vdsm-no-mac-spoofing` filter composed of `no-mac-spoofing` and `no-arp-mac-spoofing` filters for all of the networks.
More details can be found in the following [link](/develop/release-management/features/network/networkfiltering.html).

One of the main motivation for using a network filter is of security aspects as it is preventing VMs from sending/receiving illegal packets that abuse networks protocols,
such as letting a VM controlled by a malicious customer impersonate an unrelated device.

The usage of the network filter has drawbacks though. One of them is the fact that they induce performances degradation.
Another is that it prohibit usage of in-guest bonding devices or bridges.
The latter are necessary for nested virtualization.
Currently, there are two ways to disable the filter.
The first is by installing [vdsm-hook-macspoof](https://libvirt.org/firewall.html).
The second is by adding a tuple to "vdc_options" table with option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = false and version = the vm's pool compatibility version.

The feature will enable the user to choose the most suitable filter per network fits to his needs.
The filter will be defined as part of the network's vnic profile.
It is important to mentioned that additional feature , which dropping all the packets that their MAC address doesn't belong to any vnic connected to bridge may has amplification on this feature. For example, though ovirt-no-filter filter was chosen, some packets will not being forward to the VM's vnic, as those packets will be dropped in the host's bridge.

## Benefit to oVirt

Will improve the admin ability to adjust the network's vnic network filter matching best for his needs. Instead of manually installing and tweaking a Vdsm hook, he would have proper API and GUI. This would expose smart libvirt nwfilter features at the oVirt level.

## High Level Feature Description

### Vdsm

1.  Vdsm-Engine API already includes a 'filter' argument per vnic, and Vdsm uses it to set the network filter of the libvirt `<interface>`. Please note, that if Engine passes a filter that is unknown to Vdsm, the VM would fail to start.
2.  Please note that in case Engine did not mentioned any network-filter, vdsm will not configure any. When the user is choosing no network filter, Engine will later , when describing the VM's xml not mention any "filter" element.
3.  Vdsm-Engine API needs to introduce parameters specification. Some of libvirt's filters allow to modify their behavior based on parameters such as
    ```xml
        <parameter name='IP' value='10.0.0.1'/>
    ```

    These parameters should be sent from Engine.

### Engine

#### Data Base

1.  Add new table for network filters. The table will contain the name of each filter, version and its uuid. The uuid will be randomly generated when the upgrade script will run. As a result, same network filter will probably has a different uuid in each data base. The read-only table content may change only after upgrade, so we may cache its content on Engine start. The alternative is to fetch whenever the content is needed.

**TODO** do we want to add description? if so, note for internationalize issues.

**TODO** consider saving satellite table for variables validation (saving regex for example for ip)

1.  Add new network_filter_id column to vnic_profile table.
2.  Should consider adding ip_addr column in vm_interface table for representing the valid ip address for the specific VM's interface. Please note that it is possible for a malicious guest to mislead libvirt regarding its ip address. More details can be found in the following [link](https://libvirt.org/formatnwfilter.html#nwfconceptsvars). Note that when defining a new VM cloud-init allows the admin to set an IP address per interface (or ask the interface to request an address via DHCP). We should extract the data from there, and not duplicate it in vm_interface.

<!-- -->

1.  `profile` may have params (e.g. `CTLR_IP_LEARNING`, `DHCPSERVER`). where should they be stored?
2.  `vm_interface` may have params (no example except of IP). do we want to support them in this version? if so we need to decide where would they be stored.

#### Upgrade Script

Will consist the following parts:

1.  Creating and filling network_filter table.
2.  Adding network_filter_id column to vnic_profile set with the current data center's default value. The default value can be `vdsm-no-mac-spoofing` filter or no filter at all. The default value is calculated as followed: in case vdc_options table containing a tuple with option_name='MacAntiSpoofingFilterRulesSupported' option_value='false' and version = network's data center compatibility version the default value is no network filter otherwise, `vdsm-no-mac-spoofing` is consider to be the default network filter.
3.  Existing VMs would not have start to care about their IP addresses, as their existing (default) filter has no `IP` parameter.

#### Command

1.  Modify `VmInfoBuilder` to set the VM's xml to add if needed the network filter based on its vNIC profile definition
2.  Modify `AddVnicProfileCommand` to resolve the default network filter. Please note that the reason for adding a new flag was chosen in order to keep the null semantics which amply to having no network filter at all. The flag was needed in order to distinguish between no network filter and use default network filter possible configuration.
3.  Vdsm does not allow changing the network filter of currently-running VMs. We need to decide whether to allow changing the filter of a vNIC profile while it is used by running VMs.
    1.  Pro: Allowing change is a more agile usage. Admin can modify the filter while VMs are running.
    2.  Con: the admin may be surprised to find currently-running VMs that have an effectively out-of-date filter. E.g., he applied `clean-traffic` on the vNIC profile, but running VMs are still able to emit malicious packets.

### Rest API

1.  Add NetworkFilter Type and Service. The network filter struct will be as followed:

```xml
 <network_filter id="00000019-0019-0019-0019-00000000026b">
     <name>example-network-filter-b</name>
     <version>
         <build>-1</build>
         <major>4</major>
         <minor>0</minor>
         <revision>-1</revision>
     </version>
 </network_filter>
```

1.  Add command for listing all network filters:
    1.  For example a GET request `http://localhost:8080/ovirt-engine/api/cluster/<id>/networkfilter` will display all network filters:

```xml
 <network_filters>
     <network_filter id="00000019-0019-0019-0019-00000000026c">
         <name>example-network-filter-a</name>
         <version>
             <build>-1</build>
             <major>4</major>
             <minor>0</minor>
             <revision>-1</revision>
         </version>
     </network_filter>
     <network_filter id="00000019-0019-0019-0019-00000000026b">
         <name>example-network-filter-b</name>
         <version>
             <build>-1</build>
             <major>4</major>
             <minor>0</minor>
             <revision>-1</revision>
         </version>
     </network_filter>
     <network_filter id="00000019-0019-0019-0019-00000000026a">
         <name>example-network-filter-a</name>
         <version>
             <build>-1</build>
             <major>3</major>
             <minor>0</minor>
             <revision>-1</revision>
         </version>
     </network_filter>
 </network_filters>
```

1.  Allow to add/update a vNIC profile's network filter.
    1.  POST will create a new vNIC profile and PUT will update an existing one.

The command will be as followed `http://{engine_ip_address}:8080/ovirt-engine/api/networks/{network_id}/vnicprofiles`

1.  1.  For POST the output depends on the BODY's arguments value:
        1.  In case no network filter was mentioned, the default network filter will be configured where the default value determination was described before. For example:

```xml
<vnic_profile>
     <name>use_default_network_filter</name>
     <network id="00000000-0000-0000-0000-000000000009"/>
 </vnic_profile>
```

1.  1.  In case en empty network filter was mentioned, no network filter will be configured for the specific vnic profile regardless of the vnic profile's default network filter. For example:

```xml
 <vnic_profile>
     <name>no_network_filter</name>
     <network id="00000000-0000-0000-0000-000000000009"/>
     <network_filter/>
 </vnic_profile>
```

1.  1.  In case that a specific valid network filter id was mentioned, the vnic profile will be configured with the mentioned network filter regardless of the vnic profiles's default network filter. For example:

```xml
<vnic_profile>
    <name>user_choice_network_filter</name>
    <network id="00000000-0000-0000-0000-000000000009"/>
    <network_filter id= "0000001b-001b-001b-001b-0000000001d5"/>
</vnic_profile>
```

### Web Admin

1.  Add drop-down menu of available network filters to NewNetworkModel vNIC Profiles main tab.
2.  Sub Tab Network vNIC profile:
    1.  Add network filter column to the table.
    2.  Add drop-down menu of available network filters to VM Interface Profile. The user must be able to select no filter at all.

3.  Consider to add network filter column to the table of Sub Tab VM Network interface.

## Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

1.  Network will be defined at cluster level as data center will be deprecated. Validation should add
2.  Do we want to allow user custom user defined filters?

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

## Testing

1.  Upgrade script tests:
    1.  Data base upgrade no MacAntiSpoofingFilterRulesSupported override Scenario:
        1.  Configure 3 data centers with 3.0, 3.1 and one additional 3.1 < version < 4.0
        2.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        3.  Try to upgrade to 4.0.
        4.  Success conditions:
            1.  The network filters of DC's networks 3.0 and 3.1 are set to null.
            2.  The network filter of DC's network <4.0 is set to 'vdsm-no-mac-spoofing'.

<!-- -->

1.  1.  Data base upgrade with partial MacAntiSpoofingFilterRulesSupported override Scenario:
        1.  Configure 3 data centers with 3.0, 3.1 and two additional versions 3.1 < V1,V2 < 4.0
        2.  Add tuple to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = V1.
        3.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of DC's networks 3.0 ,3.1 and V1 are set to null.
            2.  The network filter of DC's V2 is set to 'vdsm-no-mac-spoofing'.

<!-- -->

1.  1.  Data base upgrade with full AntiMacSpoofing override Scenario:
        1.  Configure 7 data centers with 3.0, 3.1, 3.2, 3.3, 3.4, 3.5 and 3.6.
        2.  Add 5 tuples to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = [version] where version = [3.2, 3.3, 3.4, 3.5, 3.6].
        3.  Add A Network with a vNIC for each with vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of all networks are set to null.

<!-- -->

1.  1.  Data base upgrade with full MacAntiSpoofingFilterRulesSupported override using 'general' Scenario:
        1.  Configure 7 data centers with 3.0, 3.1, 3.2, 3.3, 3.4, 3.5 and 3.6.
        2.  Add 1 tuple to vdc_options table as followed: option_name = 'MacAntiSpoofingFilterRulesSupported' , option_value = 'false' and version = 'general'.
        3.  Add A Network with a vNIC for each data center and assign it to the datacenter's default cluster (can base on ovirtmgmt network, better to test with additional network in order to cover all flows).
        4.  Try to upgrade to 4.0.
        5.  Success conditions:
            1.  The network filters of all networks are set to null.

<!-- -->

1.  1.  Test Rest scenario as described in the documentation.

## Contingency Plan

Explain what will be done in case the feature won't be ready on time

## Release Notes
```
      == Your feature heading ==
      A descriptive text of your feature to be included in release notes
```



                   filter_id               |       filter_name       | version 
      -------------------------------------+-------------------------+---------
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

