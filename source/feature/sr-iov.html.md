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

#### High Level Feature Description

In order to connect a vnic directly to a sr-iov enabled nic the vnic should be marked as a passthrough. The properties that should be configured on the vf are taken from the vnic's profile/network ( vlan, mtu, qos, custom properties ((open issue- what properties are supported?))). When starting the vm the vnic will be directly connected to one of the availiable vfs on the host's sr-iov enabled nic (the nic that the vnic's network is attached to).

#### Affected Flows

##### add/edit network

*   <b>passthrough </b>
    -   new property that will be added to the network.
    -   passthrough property cannot be changed on edit network.
*   If the network is passthrough, just passthrough supported properties can be edited in the network (open issue- what properties?).

##### add/edit profile

*   If the profiles network is passthrough, just passthrough supported properties can be edited in the profile (open issue- what properties?).

##### add/edit vNic

*   <b>passthrough </b>
    -   new property that will be added to the vnic.
    -   it means that the vnic will bypass the software network virtualization and will be connected directly to the vf. (what should happen if the are no nics that support sr-iov on the host? if there are no available vfs? what about ucs- vm fex- should it have a separate passthrough property or should the technology (vm fex or sr-iov) should be transparent to the user at this stage?)
    -   it will be supported just for <b>virtio</b> vnic type
*   <b>vnic profile/network</b>
    -   just networks that are marked as 'passthrough' are allowed to be configured on 'passthrough' vnic.
    -   represents set of properties that will be applied on the vf (open issue: what properties are supported ? vlan, mtu, qos, custom properties)
    -   required/non required

##### hot plug nic

##### vnic linking

##### run vm

##### network labeling

##### starting the vm

*   -   if a vnic has passthrough property

##### setup networks

*   sr-iov enabled nic
*   configuring max vfs
*   attaching passthrough netywork to a nic

##### migration

#### User Experience

#### REST API

### Benefit to oVirt

*   Configuration of vnics in 'passthrough' mode directly from the gui/rest without the need of using vdsm-hook [2](http://www.ovirt.org/VDSM-Hooks/sriov)
*   Configuring max-vfs on a sr-iov enabled host nic via setup networks.
*   (migration of vms using sr-iov?)

### Dependencies / Related Features

*   [hostdev passthrough](http://www.ovirt.org/Features/hostdev_passthrough)
*   [UCS integration](http://www.ovirt.org/Features/UCS_Integration)

### Documentation / External references

*   [BZ 869804](https://bugzilla.redhat.com/869804): [RFE] [HP RHEV FEAT]: SR-IOV enablement in RHEV
*   [BZ 984601](https://bugzilla.redhat.com/984601): [RFE] [HP RHEV 3.4 FEAT]:Containment of error when an SR-IOV device encounters an error and VFs from the device are assigned to one or more guests (RHEV-M component)
*   [BZ 848202](https://bugzilla.redhat.com/848202): [RFE] Virtio over macvtap with SRIOV - RHEV Support
*   [BZ 848200](https://bugzilla.redhat.com/848200): [RFE] MAC Programming for virtio over macvtap - RHEV support

### Comments and Discussion

<Category:Feature> <Category:Networking>
