---
title: NetworkFiltering
category: template
authors: lpeer, moti
wiki_category: Template
wiki_title: Features/Design/Network/NetworkFiltering
wiki_revision_count: 7
wiki_last_updated: 2012-08-19
---

# Networking Filtering

### Summary

Network filtering provides to the host the capability to control the network traffic.
The initial implementation is focused on preventing from a VM running on the host to impersonate other VMs by spoofing their MAC addresses.

### Owner

*   Name: [ Moti Asayag](User:Moti)
*   Email: <masayag@redhat.com>

### Current status

*   Status: Finalizing requirements.

### Detailed Description

In order to prevent mac spoofing, the Engine will enhance the OOB rules provided by libvirt and specifically:
\* no-mac-spoofing

*   no-arp-mac-spoofing.

Once the system is configured for network filtering, those rules will be sent to VDSM upon running VMs, reported for each VM network interface.
VDSM will extent the DOM network interface element sent to libvirt:

`  `<interface type="bridge">
`      `<mac address="aa:aa:aa:aa:aa:aa"/>
`      `<model type="virtio"/>
            

            ...
`      `<filterref filter='no-arp-mac-spoofing'/>
`      `<filterref filter='no-mac-spoofing'/>
`   `</interface>

libvirt will use rules to configure the ebtables to prevent mac spoofing.

#### Installation/Upgrade

A new configuration value will be added:

*   **EnableMACAntiSpoofingFilterRules** - a system level config to enable/disable this feature. It will be exposed via the engine-config tool.
    -   Its default value will be set to 'true'.

#### User work-flows

The feature will be enabled for **3.2 cluster level** and above, as required VDSM API change.

#### Engine

'Run VM' process will be changed as follow:

        For each VM network interface being sent to VDSM
          If `*`EnableMACAntiSpoofingFilterRules`*` is enabled  and cluster level equals/greater than 3.2:
            Add no-mac-spoofing, no-arp-mac-spoofing filter names for the VM interface

Changes will be made in *VmInfoBuilder.addNetworkInterfaceProperties()*

#### VDSM

The VM creation API will be extended to support network filtering for VM nics.

        nicModel
        device
        network
        type
        macAddr
        ....
        filters

Where *filters* is a List of filters.

### Dependencies / Related Features and Projects

libvirt which includes no-arp-mac-spoofing rule.

### Documentation / External references

[Firewall and network filtering in libvirt](http://libvirt.org/firewall.html) [Guest MAC Spoofing DoS and its preventation](http://berrange.com/posts/2011/10/03/guest-mac-spoofing-denial-of-service-and-preventing-it-with-libvirt-and-kvm/)

### Open Issues

libvirt version to depend on. Do the rules being cleared by libvirt from ebtables once the VM is destroyed?

<Category:Template> <Category:DetailedFeature>
