---
title: MultiHostNetworkConfiguration
category: feature
authors: danken, didi, mkolesni, moti, mpavlik
wiki_category: Feature
wiki_title: Features/MultiHostNetworkConfiguration
wiki_revision_count: 35
wiki_last_updated: 2014-02-23
---

# Multi Host Network Configuration

Edit Provisioned Networks

## Your Feature Name

### Summary

The feature allows the administrator to modify a network (i.e. vlan-id, mtu) which is already provisioned by hosts and to apply the network changes to all of the hosts within the data-center to which the network is assigned.

### Owner

*   Name: Moti Asayag
*   Email: <masayag@redhat.com>

### Current status

*   Planned for ovirt-engine-3.4
*   Last updated: ,

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

Having this feature simplifies significantly the maintenance of hosts within the system:
It reduces the amount of actions required to reflect a logical network definition change by the administrator (a single 'Setup Network' action per host).
In addition, the feature reduces the risk of having hosts network configuration not synchronized with the logical network definition.

### Detailed Description

A new property 'apply' will be added to 'Update Network' command which triggers the hosts network configuration sync with the update network definition.
The 'UpdateNetworkCommand' will be changed to a non-transactive. Its execution will be consisted of 2 steps:
1. Updating the network logical definition on the DB and handles vnic profile accordingly (remove all if network changed to non-vm network). 2. Applying the network changes by executing a 'setup network' command for each host which the network is assigned to.

#### User Experience

A checkbox will be added to the 'Edit Network' dialog with caption 'Apply network change to all hosts'.
The only supported properties to be apply on the hosts are: vlan, mtu, network type (vm/non-vm) and STP.
Modifying the network name is permitted, but it will not be applied to hosts. Therefore attempt to modify network name and applying it to hosts will be blocked.
 We may consider as a lower priority to allow the user to specify the list of hosts on which to apply the changes instead of the entire hosts.

#### REST

Editing the network is done on rest via:

       api/networks/{network:id}

By providing the optional element apply:

` `<network>
`     `<apply>`true`</apply>
` `</network>
       

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features

The feature is purely engine-side related. It doesn't depended on any other package.
A reuse of a mass-operations on host should be consider for network labels.

### Testing

1. To test the feature, a setup should include at least one host within the data-center having a network 'red' attached to on of its interfaces.

       * Edit the logical network definition of network 'red' (i.e. change vlan-id)
       * Mark the 'apply to all hosts' checkbox
       * Approve the command.
       * Verify network 'red' was modified correctly on the relevant data-center's hosts.

<Category:Feature> <Category:Template>
