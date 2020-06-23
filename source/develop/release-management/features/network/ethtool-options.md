---
title: Ethtool options
category: feature
authors: apuimedo, danken
feature_name: Device ethtool options
feature_modules: engine,network,vdsm
feature_status: To be Released
---

# Ethtool options

## Device ethtool options

### Summary

This feature provides a way for the administrator to specify ethtool options for oVirt-defined networks.

### Owner

*   Name: Antoni Segura Puimedon (apuimedo)
*   Email: <asegurap At redhat.com>

### Current status

*   Design

### Detailed Description

TODO

### Benefit to oVirt

Having a simple way for the network administrator to set ethtool options for the oVirt defined networks will allow oVirt to cover a wider range of configurations and tweakings that can make managing a datacenter network a much more enjoyable experience.

Up until now, oVirt used to persist its network configuration in Fedora/EL specific files handled by the initscripts package. These files, known as ifcfg, contained a series of shell definitions that were read and applied by the ifup-eth executable. oVirt auto-generates and writes these ifcfg files and as such, if the network admin wanted to tweak the ETHTOOL_OPTS definition that precluded the continued care-free modification of the network, as some of the configuration would be living only in the hypervisor node and would not be exposed to oVirt for persistence.

### User experience

With the proposed solution, ethtool options will be a property that can be set per logical network as well as be defined on the assignment of a network on a physical device, just like ip addressing.

![](/images/wiki/Ethtool_networks.png)

Above you can see that in the networks tab, in the dialog for creating a new logical network, it is possible to define custom network properties, one of which will be ethtool options. These ethtool options will apply to any assignment of the network to a NIC on a host unless overridden as in the next two images.

![](/images/wiki/Override_setupNetworks.png) ![](/images/wiki/Override_setupNetworks_01.png)

When assigning a network to a NIC it will be possible to click on "edit" (icon marked in red in the first of these two images) and:

*   Add new ethtool opts,
*   Edit the ethtool opts defined at the logical level,
*   Remove any ethtool configuration.

### Ethtool options format

The proposed format is just the command line ethtool syntax

    --coalesce ethX rx-usecs 14 sample_interval 3 --offload ethX rx on lroon tcp-segmentation-offload off --change ethX speed 1000 duplex half 

If the property is being set on a bond, the user should make sure to specify the proper ethX/ethY/ethZ for each of the bond's nics that ethtool options should be set for. E.g., we have a bond with em1 and em2 and em2 should offload only rx and em1 only tx:

    --offload em2 rx on --offload em1 tx on

In the bonding case, the UI/Engine/vdsm code may want to check that there is no reference to a NIC that isn't enslaved to the bond.

### Dependencies / Related Features

In order to define device ethtool options, [Network Custom Properties] must be completed, as it is the infrastructure this feature builds upon.

### Testing

To test this feature the tester should:

*   set up ethtool options at the logical level, assign the network to a nic and use the cli tool ethtool to check that the options are properly applied to the NIC.
*   Override (editing or removing) the ethtool options set at the logical level and see, like in the previous step that the options are properly applied to the NIC.
*   Define at the network assignment level ethtool options for a network with no ethtool options at the logical level and see that they are properly applied to the NIC.



