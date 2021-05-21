---
title: MultiHostNetworkConfiguration
category: feature
authors:
  - danken
  - didi
  - mkolesni
  - moti
  - mpavlik
---

## Multi-Host Network Configuration

### Summary

The feature allows the administrator to modify a network (i.e. vlan-id, mtu) which is already provisioned by the hosts and to apply the network changes to all of the hosts within the data-center to which the network is assigned.
The feature will be enabled for 3.1 data-centers and above, regardless cluster level in order to avoid inconsistency between hosts network configuration in various clusters.

### Owner

*   Name: Moti Asayag
*   Email: <masayag@redhat.com>

### Current status

*   Ready
*   Planned for ovirt-engine-3.4
*   Last updated on -- by

### Benefit to oVirt

Having this feature simplifies significantly the maintenance of hosts within the system:
It reduces the amount of actions required to reflect a logical network definition change by the administrator (a single 'Setup Network' action per host).
In addition, the feature reduces the risk of having hosts network configuration not synchronized with the logical network definition.

### Detailed Description

#### Phase 1

Updating a network will trigger sync the change to all of the hosts: The 'UpdateNetworkCommand' will be changed to a non-transactive. Its execution will be consisted of 2 steps:
# Updating the network logical definition on the DB and handles vnic profile accordingly (remove all if network changed to non-vm network) will run in a new transaction scope.

1.  Applying the network changes by executing a 'setup networks' command for each host which the network is assigned to.
2.  Save the network changes to the host upon a successful 'setup networks'

The Setup Networks command will use the 'sync network' for the modified network.
A dedicated multiple action runner will be added to run the 'Setup Networks' commands in parallel.
Currently, Updating the network is blocked for network which is used by VMs. As part of the feature we should permit the change in these cases:

*   Networks that aren't used by VMs
*   No running VMs using the network and the change doesn't include modifying a VM network to a non-VM network.

The feature will be enabled only for 3.1 data-center and above since it relies on the 'Setup Networks' which was introduced in 3.1. Renaming of network which is used by the hosts, vms or templates will be blocked, since it will make the network on hosts as "unmanaged" and leave the vm/templates without a required network.

1.  This will revert the fix for bug [Don't block removing/updating network "used" by host](https://bugzilla.redhat.com/show_bug.cgi?id=909820)
2.  The user should create a new network instead of renaming a used network.

#### Phase 2

1.  The same behaviour will be added to 'Remove Network' action as well in a similar manner:
    -   Removing a network from the system will attempt to remove it from all of the hosts it is defined on.

#### User Experience

The 'Edit Network' action will attempt to configure the network on all of the eligible hosts. No changes are required to the UI.

#### REST

No changes are required to the api.

#### Events

The following events will be logged for the command when applied to all hosts:

1.  For partial hosts update: "${TotalUpdatedHosts} are planned to be updated, however only ${ActualUpdatedHosts} could be updated."
2.  If a 'setup networks' action is not supported by data center version: "${Network} network changes will not be applied to data center: ${UnsupportedDCName} due to unsupported data center version."
3.  For each host being updated:
    1.  "1/3 applying network ${Network} on host ${Host}"
    2.  "2/3 applying network ${Network} on host ${Host}"
    3.  "3/3 applying network ${Network} on host ${Host}"

And for their completion:

1.  "1/3 network ${Network} were updated on host ${Host}"
2.  "2/3 failed to update ${Network} changes on host ${Host} due to: ${Failure}"
3.  "3/3 network ${Network} were updated on host ${Host}"

*   All the actions should contain the same correlation-id.

<!-- -->

*   UpdateNetworkCommand can-do-action messages should be modify to reflect the proper message:
    -   Changing A vm network to a non-vm network is not permitted while VMs or templates are using the VM.
    -   Changing A vm network properties while running VMs are using it is not permitted.
    -   Renaming a network which is configured on hosts is not supported.

### Dependencies / Related Features

The feature is purely engine-side related. It doesn't depended on any other package.
A reuse of a mass-operations on host should be consider for network labels.

### Testing

To test the feature, a setup should include at least one host within the data-center having a network 'red' attached to on of its interfaces.

1.  Edit the logical network definition of network 'red' (i.e. change vlan-id or any property but its name)
2.  Approve the command.
3.  Verify network 'red' was modified correctly on the relevant data-center's hosts.

