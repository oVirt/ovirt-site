---
title: Normalized ovirtmgmt Initialization
category: feature
authors: danken, lpeer, moti, sandrobonazzola
---

# Normalized ovirtmgmt Initialization

## Summary

Generate `ovirtmgmt` network based on DC definitions using `setupNetworks` and not during new host deployment.

## Owner

*   Name: Moti Asayag (masayag)

<!-- -->

*   Email: <masayag@redhat.com>

## Current status

*   Feature is merged (14/1/2013) and moved back to development as a requirement (reboot after install) raised (7/5/2013)
*   Last updated: ,

## Detailed Description

### Current condition

The management network, named ovirtmgmt, is created during host bootstrap. It consists of a bridge device, connected to the network device that was used to communicate with Engine (nic, bonding or vlan). It inherits its ip settings from the latter device.

### Why Is the Management Network Needed?

Understandably, some may ask why do we need to have a management network - why having a host with IPv4 configured on it is not enough. The answer is twofold:

1.  In oVirt, a network is an abstraction of the resources required for connectivity of a host for a specific usage. This is true for the management network just as it is for VM network or a display network. The network entity is the key for adding/changing nics and IP address.
2.  In many occasions (such as small setups) the management network is used as a VM/display network as well.

### Problems in current condition

According to alonbl of ovirt-host-deploy fame, and with no conflict to my own experience, creating the management network is the most fragile, error-prone step of bootstrap.

Currently it always creates a bridged network (even if the DC requires a non-bridged ovirtmgmt), it knows nothing about the defined MTU for ovirtmgmt, it uses ping to guess on top of which device to build (and thus requires Vdsm-to-Engine reverse connectivity), and is the sole remaining user of the `addNetwork`/`vdsm-store-net-conf` scripts.

### Suggested feature

Bootstrap would avoid creating a management network. Instead, after bootstrapping a host, Engine would send a `getVdsCaps` probe to the installed host, receiving a complete picture of the network configuration on the host. Among this picture is the device that holds the host's management IP address.

Engine would send `setupNetwork` command to generate `ovirtmgmt` with details devised from this picture, and according to the DC definition of ovirtmgmt. For example, if Vdsm reports:

*   vlan bond4.3000 has the host's IP, configured to use dhcp.
*   bond4 is comprises eth2 and eth3
*   ovirtmgmt is defined as a VM network with MTU 9000

then Engine sends the likes of:

       setupNetworks(ovirtmgmt: {bridged=True, vlan=3000, iface=bond4,
                     bonding=bond4: {eth2,eth3}, MTU=9000)

A call to `setSafeNetConfig` would wrap the network configuration up.

Currently, the host undergoes a reboot as the last step of bootstrap. This allows us to verify immediately if the host would be accessible post-boot using its new network configuration. If we want to maintain this, Engine would need to send a `fenceNode` request.

## Benefit to oVirt

*   Simplified bootstrapping
*   Simplified `ovirt-node` registration (similar ovirtmgmt-generation logic lies there).
*   Host installation ends with an ovirtmgmt network that matches DC definition (bridged-ness, mtu, vlan).
*   vdsm-to-engine connectivity is not required.

## Dependencies / Related Features

### Vdsm

Already reports all relevant network devices, as well lastClientIface (the interface used to receive the current client communication). According to this information, `Engine` can deduce the structure of the management network `ovirtmgmt`.

### ovirt-host-deploy

Already has `VDSM/managementBridgeName ` environment variable defined. If missing, no management network would be created.

### Engine

Most of the work lies here, where the output of `getVdsCaps` should be parsed, and a `setupNetworks` command should be transmitted after a new host is added to the data center.

1.  start host deployment with
    -   ODEPLOY/forceReboot = False
    -   VDSM/managementBridgeName undefined

2.  after `otopi` finishes, start to poll host with `getVdsCaps` or `ping`. If timeout expires, fail host deployment.
3.  Host deployment ends here, by trying to configure the management network the newly-added host.

When a management network is being configured on the the host Engine should

1.  Wait VDSM to become responsive
2.  call getVdsCaps
3.  check if management network `ovirtmgmt` configured on host
    1.  if already defined, confirm network compliance and declare success.
    2.  else acquire `lastClientInterface` and devise network definition for `ovirtmgmt`. Simon suggested that the Engine learns the vlan ID of `ovirtmgmt` from the first host added to the DC, but with no consensus about this, Engine would use its DB definition of network as configured on DC level. If `lastClientInterface` is none of host nic, bond or vlan, network configuration should fail. Network configuration fails also if it is a vlan with a mismatching vlan tag.
    3.  send `setupNetworks` with the new management network definition with the `lastClientInterface` only.
    4.  on success, send `setSafeNetConfig`. On failure show an event to the user. the host would be left non-operational, and may need manual network configuration.

### ovirt-node

Still needs **TODO**: drop bridge-creation logic from `ovirt-node`.
There is an open bug for ovirt-node for allowing bridgeless networks: [Bug 967866](https://bugzilla.redhat.com/show_bug.cgi?id=967866)

### Behavioral Changes

The updated host installation flow is described in the chart below, where each flow ends with setting the host status to reflect the current host status:

![](/images/wiki/Installation-flowchart.png)

The noticeable changes from the previous installation flow are:
\* We added support in creating a bridgless management network during installation.

*   The behaviour up until 3.3 was to reboot host after installation, in release 3.3 we are changing this behaviour and reboot will no longer take place after installation, this change holds for all host from cluster level 3.1 and up.
*   In Add-Host / Re-install host - rebootAfterInstallation property is deprecated (ignored for clusters 3.1 and up). The reboot will no longer take place, regardless of the provided value of rebootAfterInstallation property. This property was available only via the API.
*   ovirt-node - during the registration of ovirt-node, the management network is created as part of the bootstrap process as a bridged network. ATM there is no support in configuring the management network for ovirt-node according to its logical network definition. Therefore if the logical network definition of the management network is bridgeless network, the ovirt-node will be added with its management network marked as 'not synced' (event log) and the admin will have to use the 'setup networks' dialogue to sync the network.
*   For 3.1 hosts and above, if the creation of the management network fails, the host will move to non-operational.
*   At the end of a successful installation, the host moves to 'initializing' status instead of former 'non responsive'.
*   After the ovirt-host-deploy ends, the engine will await to VDSM to become responsive for 2 minutes. If it fails, the host will move to 'non responsive'.
*   After VDSM is up, the engine will invoke the first GetVdsCapabilities in order to get the host's network configuration and the lastClientIface.
*   The lastClientIface (reported by GetVdsCapabilities) is the interface which is used for communication between the engine to the host. The lastClientIface wasn't in use in previous releases by the engine.
*   For lastClientIface which represents a bridge, configuring management network is not supported and manual innervation is required (using setup networks)

### Additional event logs

*   INVALID_INTERFACE_FOR_MANAGEMENT_NETWORK_CONFIGURATION
*   VLAN_ID_MISMATCH_FOR_MANAGEMENT_NETWORK_CONFIGURATION
*   SETUP_NETWORK_FAILED_FOR_MANAGEMENT_NETWORK_CONFIGURATION
*   PERSIST_NETWORK_FAILED_FOR_MANAGEMENT_NETWORK

## Testing

Cover all methods for installing a host in oVirt Engine

| Test                                                                     | Steps                                                                                           | Expected Result                                                                                     | Status                                                                           | Version                                                      |
|--------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|--------------------------------------------------------------|
| New host (with plan interface+dhcp only) installation                    | Add host to a 3.1 and above system                                                              | Host should show up in Engine                                                                       | [BZ# 987813](https://bugzilla.redhat.com/show_bug.cgi?id=987813)                | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |
| New 3.0 host installation                                                | Add host to a 3.0 cluster                                                                       | Host should show up in Engine (with management network as bridge)                                   | [BZ# 987813](https://bugzilla.redhat.com/show_bug.cgi?id=987813), host rebooted | Fedora 19, nightly - git0c5620a, 3.0 cluster and dc          |
| New host (with plan interface+static ip only) installation               | Add host to a 3.1 and above system                                                              | Host should show up in Engine                                                                       | [BZ #987832](https://bugzilla.redhat.com/show_bug.cgi?id=987832)                | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |
| New host (with bond only) installation                                   | Add host to a 3.1 and above system                                                              | Host should show up in Engine                                                                       |                                                                                  |                                                              |
| New host (with ovirtmgmt exists) installation                            | Add host to a 3.1 and above system                                                              | Host should show up in Engine                                                                       | verified                                                                         | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |
| New host (with nic + networks on other nics) installation                | Add host to a 3.1 and above system                                                              | Host should show up in Engine, existing networks should be preserved                                |                                                                                  |                                                              |
| New host (with plan interface) installation, ovirtmgmt is non-VM network | Add host to a 3.1 and above system                                                              | Host should show up in Engine, ovirtmgmt on host is non-VM network.                                 | verified                                                                         | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |
| New ovirt-node installation (ovirtmgmt is a VM network)                  | Add ovirt-node to a 3.1 system                                                                  | Host should show up in Engine, ovirtmgmt on host is a VM network.                                   | [BZ #987950](https://bugzilla.redhat.com/show_bug.cgi?id=987950)                | Fedora 19, nightly - git0c5620a, 3.3 cluster and 3.2 cluster |
| New ovirt-node installation (ovirtmgmt is a non-vm network)              | Add ovirt-node to a 3.1 system                                                                  | Host should show up in Engine, ovirtmgmt on host is a VM network and marked is 'out-of-sync'        | [BZ #987950](https://bugzilla.redhat.com/show_bug.cgi?id=987950)                | Fedora 19, nightly - git0c5620a, 3.3 cluster and 3.2 cluster |
| Negative: New host with bridge (other than ovirtmgmt) installation       | Add host to cluster 3.1 and above                                                               | Installation failed, host in Non-Operational status, event log informs wrong nic for mgmt network   | verified                                                                         | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |
| Negative: New host installation with non-responsive VDSM                 | Add host to cluster 3.1 and above, after Termination message appears, shutdown VDSM on the host | Installation failed, host in Non-Responsive status, event log informs error communicating with VDSM | verified                                                                         | Fedora 19, nightly - git0c5620a, 3.3 cluster                 |

## Documentation / External references

*   mailing-list discussion about this feature: <https://lists.ovirt.org/pipermail/arch/2012-December/001101.html>



