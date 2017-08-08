---
title: Avoid IP Spoofing
category: feature
authors: danken
feature_name: Avoid IP Spoofing
feature_modules: engine,network,vdsm
feature_status: Not impemented
---

# Avoid IP Spoofing

## Summary

We should limit traffic that originates from an non-trusted guests to a closed set of source IP addresses.

## Owner

*   Name: Dan Kenigsberg (Danken)

<!-- -->

*   Email: <danken@redhat.com>

## Current status

*   Not implemented.
*   `clean-taffic` filter in vNIC profile prevents IP spoofing.
*   There is a workaround with [Network Filter Parameters](http://www.ovirt.org/develop/release-management/features/network/networkfilterparameters/):
    -   Parameter `IP` used to list allowed IP addresses on network interface.
    -   `CTRL_IP_LEARNING` can be used to specify IP address learning method.
    -   `DHCPSERVER` to avoid DHCP spoofing.   

## Detailed Description

Now that [Features/Cloud-Init_Integration](/develop/release-management/features/cloud/cloud-init-integration/) is available, users have the ability to set the IP address of their guest from within Engine. However, nothing binds a rogue guest to do as it wishes, and impersonate 173.255.252.138 (current address of www.ovirt.org). With this feature implemented, administrators could apply stricter security rules that avoids that.

## Benefit to oVirt

When used to host a public cloud, oVirt should trust its guest operating less, and protect the local network from impersonation.

## Dependencies / Related Features

This small feature is a follow-up of [Features/Cloud-Init_Integration](/develop/release-management/features/cloud/cloud-init-integration/) and of [Bug 809814 Add nwfilter rules to all VMs](https://bugzilla.redhat.com/809814)

## Implementation

### UI

On the ["cloud-init" dialog](/File:Cloud-init-webadmin-screenshot.png), where IP addresses can be set, we shall add another checkbox labeled "restrict".

### Engine core

When a new VM is defined, the user-supplied IP addresses (and boot protocol) should be kept per vNIC. For each vNIC with the "restrict" checkbox set, Engine would request the "clean-traffic" filter, and would supply the relevant parameters (CTRL_IP_LEARNING=dhcp, or a list of IP addresses).

### Vdsm

When defining interface devices (in the create and hotplug verbs), a filter name can already be supplied. To the filter, we should add the ability to pass a list of keys and values.

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

## Testing

*   Start a VM with anti-spoofing on, and verify that it cannot emit illegitimate traffic.
*   Start a VM defined before this feature is introduced, and verify that it can still emit any IP traffic

## Comments and Discussion

*   Setting IP filtering has costs on the host's CPU and latency. Despite that, and due to the security implications, the default value for new VMs would be to filter IP traffic.
*   Existing VMs, which have been defined by previous versions of oVirt do not have filtering set for them. This should be maintained during upgrade, as the guest may depend on this fact.
*   If no IP address was defined, traffic would be unfiltered.
*   There is an open issue on how to map the cloud-init identity of vNIC to libvirt's identity thereof. The problem exists regardless of this feature, but may become more acutic.

<!-- -->


