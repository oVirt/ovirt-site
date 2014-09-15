---
title: SR-IOV
category: feature
authors: alkaplan, danken, ibarkan
wiki_category: Feature
wiki_title: Feature/SR-IOV
wiki_revision_count: 189
wiki_last_updated: 2015-06-03
---

# SR-IOV

### Summary

Currently SR-IOV in oVirt is only supported using vdsm-hook [1](http://www.ovirt.org/VDSM-Hooks/sriov). This feature adds SR-IOV support to oVirt management system.

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

[SR-IOV Detailed Design](http://wiki.ovirt.org/Feature/DetailedSRIOV)

*   Last update date: 09/09/2014

### Introduction

SR-IOV enables a Single Root Function (for example, a single Ethernet port), to appear as multiple, separate, physical devices. SR-IOV uses two PCI functions:

*   Physical Functions (PFs)- Full PCIe device that includes the SR-IOV capabilities.
*   Virtual Functions (VFs)- ’lightweight’ PCIe functions that contain the resources necessary for data movement but have a carefully minimized set of configuration resources.

A VM's vNic can be connected directly to a VF (1-1) instead of to virtual network bridge (vm network). ![](Sr-iov.png "fig:Sr-iov.png")

### High Level Feature Description

#### Affected Flows

#### <b>add/edit vNic</b>

*   <b>passthrough </b>
    -   new property that will be added to the vnic.
    -   it means that the vnic will bypass the software network virtualization and will be connected directly to the vf. (what should happen if the are no nics that support sr-iov on the host? if there are no available vfs? what about ucs- vm fex- should it have a separate passthrough property or should the technology (vm fex or sr-iov) should be transparent to the user at this stage?)
    -   it will be supported just for <b>virtio<b> vnic type
*   <b>vnic profile/network</b>
    -   represents set of properties that will be applied on the vf (open issue: what properties are supported ? vlan, mtu, qos, custom properties)
    -   required/non required

#### <b>hot plug nic</b>

#### <b>run vm</b>

*   starting the vm
    -   if a vnic has passthrough property

#### <b>setup networks</b>

#### <b>migration</b>

#### User Experience

#### REST API

### Benefit to oVirt

### Dependencies / Related Features

*   [hostdev passthrough](http://www.ovirt.org/Features/hostdev_passthrough)

### Documentation / External references

*   [BZ 869804](https://bugzilla.redhat.com/869804): [RFE] [HP RHEV FEAT]: SR-IOV enablement in RHEV
*   [BZ 984601](https://bugzilla.redhat.com/984601): [RFE] [HP RHEV 3.4 FEAT]:Containment of error when an SR-IOV device encounters an error and VFs from the device are assigned to one or more guests (RHEV-M component)
*   [BZ 848202](https://bugzilla.redhat.com/848202): [RFE] Virtio over macvtap with SRIOV - RHEV Support
*   [BZ 848200](https://bugzilla.redhat.com/848200): [RFE] MAC Programming for virtio over macvtap - RHEV support

### Comments and Discussion

<Category:Feature> <Category:Networking>
