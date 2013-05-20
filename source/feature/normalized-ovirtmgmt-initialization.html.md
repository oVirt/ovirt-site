---
title: Normalized ovirtmgmt Initialization
category: feature
authors: danken, lpeer, moti, sandrobonazzola
wiki_category: Feature
wiki_title: Features/Normalized ovirtmgmt Initialization
wiki_revision_count: 36
wiki_last_updated: 2013-12-11
---

# Normalized ovirtmgmt Initialization

### Summary

Generate `ovirtmgmt` network based on DC definitions using `setupNetworks` and not during new host deployment.

### Owner

*   Name: [ Moti Asayag](User:masayag)

<!-- -->

*   Email: <masayag@redhat.com>

### Current status

*   Feature is merged (14/1/2013) and moved back to development as a requirement (reboot after install) raised (7/5/2013)
*   Last updated: ,

### Detailed Description

#### Current condition

The management network, named ovirtmgmt, is created during host bootstrap. It consists of a bridge device, connected to the network device that was used to communicate with Engine (nic, bonding or vlan). It inherits its ip settings from the latter device.

#### Why Is the Management Network Needed?

Understandably, some may ask why do we need to have a management network - why having a host with IPv4 configured on it is not enough. The answer is twofold:

1.  In oVirt, a network is an abstraction of the resources required for connectivity of a host for a specific usage. This is true for the management network just as it is for VM network or a display network. The network entity is the key for adding/changing nics and IP address.
2.  In many occasions (such as small setups) the management network is used as a VM/display network as well.

#### Problems in current condition

According to alonbl of ovirt-host-deploy fame, and with no conflict to my own experience, creating the management network is the most fragile, error-prone step of bootstrap.

Currently it always creates a bridged network (even if the DC requires a non-bridged ovirtmgmt), it knows nothing about the defined MTU for ovirtmgmt, it uses ping to guess on top of which device to build (and thus requires Vdsm-to-Engine reverse connectivity), and is the sole remaining user of the `addNetwork`/`vdsm-store-net-conf` scripts.

#### Suggested feature

Bootstrap would avoid creating a management network. Instead, after bootstrapping a host, Engine would send a `getVdsCaps` probe to the installed host, receiving a complete picture of the network configuration on the host. Among this picture is the device that holds the host's management IP address.

Engine would send `setupNetwork` command to generate `ovirtmgmt` with details devised from this picture, and according to the DC definition of ovirtmgmt. For example, if Vdsm reports:

*   vlan bond4.3000 has the host's IP, configured to use dhcp.
*   bond4 is comprises eth2 and eth3
*   ovirtmgmt is defined as a VM network with MTU 9000

then Engine sends the likes of:

       setupNetworks(ovirtmgmt: {bridged=True, vlan=3000, iface=bond4,
                     bonding=bond4: {eth2,eth3}, MTU=9000)

A call to `setSafeNetConfig` would wrap the network configuration up.

Currently, the host undergoes a reboot as the last step of bootstrap. This allows us to verify immediately if the host would be accessible post-boot using its new network configuration. If we want to maintain this, Engine would need to send a `fenceNode` request.

### Benefit to oVirt

*   Simplified bootstrapping
*   Simplified `ovirt-node` registration (similar ovirtmgmt-generation logic lies there).
*   Host installation ends with an ovirtmgmt network that matches DC definition (bridged-ness, mtu, vlan).
*   vdsm-to-engine connectivity is not required.

### Dependencies / Related Features

#### Vdsm

Already reports all relevant network devices, as well lastClientIface (the interface used to receive the current client communication). According to this information, `Engine` can deduce the structure of the management network `ovirtmgmt`.

#### ovirt-host-deploy

Already has `VDSM/managementBridgeName ` environment variable defined. If missing, no management network would be created.

#### Engine

Most of the work lies here, where the output of `getVdsCaps` should be parsed, and a `setupNetworks` command should be transmitted after a new host is added to the data center.

1.  start host deployment with
    -   ODEPLOY/forceReboot = False
    -   VDSM/managementBridgeName undefined

2.  after `otopi` finishes, start to poll host with `getVdsCaps` or `ping`. If timeout expires, fail host deployment.
3.  installation ends here, by trying to activate the newly-added host.

When a host is activated Engine should

1.  call getVdsCaps
2.  check if management network `ovirtmgmt` configured on host
    1.  if already defined, confirm network compliance and declare success.
    2.  else acquire `lastClientInterface` and devise network definition for `ovirtmgmt`. Simon suggested that the Engine learns the vlan ID of `ovirtmgmt` from the first host added to the DC, but with no consensus about this, Engine would use its DB definition of network as configured on DC level. If `lastClientInterface` is none of host nic, bond or vlan, activation should fail. Activation fails also if it is a vlan with a mismatching vlan tag.
    3.  send `setupNetworks` with the new management network definition with the `lastClientInterface` only.
    4.  on success, send `setSafeNetConfig`. On failure show an event to the user. the host would be left non-operational, and may need manual network configuration.

3.  if the user requested post-installation reboot, fence the newly-added host.

#### ovirt-node

Still needs **TODO**: drop bridge-creation logic from `ovirt-node`.

### Documentation / External references

*   mailing-list discussion about this feature: <http://lists.ovirt.org/pipermail/arch/2012-December/001101.html>

### Comments and Discussion

*   Refer to [Talk:Normalized ovirtmgmt Initialization](Talk:Normalized ovirtmgmt Initialization)

<Category:Feature>
