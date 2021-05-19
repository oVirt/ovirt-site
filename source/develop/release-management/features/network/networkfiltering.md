---
title: NetworkFiltering
category: feature
authors: lpeer, moti
---

# Networking Filtering

## Summary

Network filtering provides to the host the capability to control the network traffic.
The initial implementation is focused on preventing from a VM running on the host to impersonate other VMs by spoofing their MAC addresses.

## Owner

*   Name: Moti Asayag (Moti)
*   Email: <masayag@redhat.com>

## Current status

*   Status: Finalizing requirements.

## Detailed Description

In order to prevent mac spoofing, the Engine will use custom libvirt rules consist of the following filters:
\* no-mac-spoofing

*   no-arp-mac-spoofing

The custom rule will be defined by vdsm on libvirt named *vdsm-no-mac-spoofing*. Once the system is configured for network filtering, that rule will be sent to VDSM upon running VMs, reported for each VM network interface.
VDSM will extent the DOM network interface element sent to libvirt:

`  `<interface type="bridge">
`      `<mac address="aa:aa:aa:aa:aa:aa"/>
`      `<model type="virtio"/>
            

            ...
`      `<filterref filter='vdsm-no-mac-spoofing'/>
`   `</interface>

libvirt will use the rule to configure the ebtables to prevent mac spoofing and arp mac spoofing.

### Installation/Upgrade

A new configuration value will be added:

*   **EnableMACAntiSpoofingFilterRules** - a system level config to enable/disable this feature. It will be exposed via the engine-config tool.
    -   Its default value will be set to 'true'.

### User work-flows

The feature will be enabled for **3.2 cluster level** and above, as required VDSM API change.

### Engine

'Run VM' process will be changed as follow:

        For each VM network interface being sent to VDSM
          If `*`EnableMACAntiSpoofingFilterRules`*` is enabled  and cluster level equals/greater than 3.2:
            Add vdsm-no-mac-spoofing filter name for the VM interface

Changes will be made in *VmInfoBuilder.addNetworkInterfaceProperties()*

*Hot Plug Nic* will also provide list of filter names, if system is configure to prevent mac-spoofing.

### VDSM

VDSM will define a custom nwfilter rule on libvirt - vdsm-no-mac-spoofing, consists of out-of-the-box rules no-mac-spoofing and no-arp-mac-spoofing.

#### Create VM API

The VM creation API will be extended to support network filtering for VM nics.

        nicModel
        device
        network
        type
        macAddr
        ....
        filters

Where *filters* is a List of filters (as per libvirt-10-21 libvirt supports a single filter only).

A new python tool named *define-filter.py* will be added under vdsm/vdsm-tool.
It will be used to get a path of the filter file (xml) and define it on libvirt.

The filer xml file *vdsm-no-mac-spoofing.xml* will be stored on vdsm/vdsm-tools/nwfilter

#### HotPlug Nic API

The device which reprenests the nic is extended with a list of filter.

## Dependencies / Related Features and Projects

libvirt which includes no-arp-mac-spoofing rule.

## Documentation / External references

[Firewall and network filtering in libvirt](http://libvirt.org/firewall.html)

[Guest MAC Spoofing DoS and its preventation](http://berrange.com/posts/2011/10/03/guest-mac-spoofing-denial-of-service-and-preventing-it-with-libvirt-and-kvm/)

## Open Issues

libvirt version to depend on.
Do the rules being cleared by libvirt from ebtables once the VM is destroyed?
* I assume it does otherwise we should report a bug on libvirt, same apply for migration

