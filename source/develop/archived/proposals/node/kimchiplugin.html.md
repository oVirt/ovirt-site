---
authors: rbarry
---

# Kimchi Plugin

## oVirt Node Kimchi plugin

### Summary

This feature allows the oVirt Node image to provide a web interface through [Kimchi](https://github.com/kimchi-project/kimchi) in order to manage VMs through libvirt directly on the node.

### Owner

*   Name: Ryan Barry (rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Current status

*   Archived

### Detailed Description

Kimchi is a HTML5 interface to KVM designed to make managing KVM easy without libvirt. Currently, oVirt Node images must be registered to an engine in order to provision VMs, but libvirt is functional without using VDSM as an intermediary. A Kimchi plugin would allow for Node images to manage their virtual machines directly.

### Benefit to oVirt

Essentially feature parity with XenServer and ESXi in providing a way to manage VMs on a single node with no external dependencies.

### Dependencies / Related Features

*   [Node Plugins](/develop/release-management/features/node/plugins/)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-kimchi (Name TBD)

### Documentation / External references

*   Documentation can be found on [Kimchi's homepage](https://github.com/kimchi-project/kimchi)




