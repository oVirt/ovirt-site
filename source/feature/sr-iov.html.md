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

VM's nic (vNic) can be connected directly to a VF (1-1) instead of to virtual network bridge (vm network). Bypassing the virtual networking devices on the host reduces latency and CPU utilization.
![](Sr-iov.png "fig:Sr-iov.png")

#### High Level Feature Description

In order to connect a vnic directly to a sr-iov enabled nic the vnic should be marked as a passthrough. The properties that should be configured on the VF are taken from the vnic's profile/network ( vlan, mtu, qos, custom properties ((open issue- what properties are supported?))). When starting the vm the vnic will be directly connected to one of the availiable VFs on the host's sr-iov enabled nic (the nic that the vnic's network is attached to).

#### Affected Flows

##### add/edit network

*   <b>passthrough </b>
    -   new property that will be added to the network.
    -   passthrough property cannot be changed on edit network.
    -   If the network is passthrough, just passthrough supported properties can be edited in the network (open issue- what properties?).
*   A network can be defined as- vm network <b>or</b> passthrough network <b>or</b> none.
*   (open issue- is label on passthrough network supported?)

##### add/edit profile

*   If the profiles network is passthrough, just passthrough supported properties can be edited in the profile (open issue- what properties?).

##### add/update network on cluster

*   (open issue- should passthrough network be always required?).
*   (open issue- can passthrough network be management, display or migration network).

##### add/edit vNic

*   <b>passthrough </b>
    -   new property that will be added to the vnic.
    -   it means that the vnic will bypass the software network virtualization and will be connected directly to the VF. (what should happen if the are no nics that support sr-iov on the host? if there are no available vfs? what about ucs- vm fex- should it have a separate passthrough property or should the technology (vm fex or sr-iov) should be transparent to the user at this stage?)
    -   it will be supported just for <b>virtio</b> vnic type
*   <b>vnic profile/network</b>
    -   just networks that are marked as 'passthrough' are allowed to be configured on 'passthrough' vnic.
    -   represents set of properties that will be applied on the vf (open issue: what properties are supported ? vlan, mtu, qos, custom properties)

##### hot plug nic

##### vnic linking

##### run vm

##### network labeling

##### starting the vm

*   -   if a vnic has passthrough property

##### setup networks

*   <b>max_vfs</b>
    -   max_vfs is a new propery that will be added to host nic.
    -   editing the propery
        -   setting 0
            -   means sr-iov will not be enabled for this nic
            -   if there are passthrough networks attached to it the will be automatically detached
                -   if there are running vms on the host that are using those networks the operation (of changing max_vfs to 0) will fail.
        -   setting other value than 0
            -   enables sr-iov on the physical nic.
            -   if sr-iov is not supported on the phisycal nic, the operation will fail with explanation error message.
            -   limits the number of its VFs to max_vfs value.
            -   if the updated value is bigger than the max_vfs that can be supported by the phisycal nic, the operation will fail with explanation error message.
            -   (open issue- consider having max_vfs and sriov_supported properties on the nic host, so the user won't have to wait for the error message to see there is a problem).
*   <b>passthrough network</b>
    -   can be attached just to sr-iov enabled nic (nic with max_vfs > 0 set on it).
    -   passthrough networks with and without vlan can co-exist together on the same sr-iov enabled nic.
*   <b>regular network</b>\*
    -   regular network can be attached to a sr-iov enabled nic (also if there are passthrough networks attached to it).
    -   the logic for the co-exsistence of regular networks on the same nic won't be changed- passthrough networks will be ignored in this validation.
*   <b>label on sr-iov enabled nic</b>\*
    -   (open issue- is it supported?)
*   bonding of sr-iov enable nics- no supported (?).
*   setting max_vfs on a bond- no supported (?).
*   setting boot-protocol on passthrough network is not supported.

##### migration

#### User Experience

#### REST API

*   <b>setup networks</b>
    -   should VF be sent as a separate nic?

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

### Open issues

*   what properties can be configured on VF- vlan, mtu, qos, custom properties?
*   should passthrough network be always required?
*   can passthrough network be management, display or migration network?
*   consider having max_vfs and sriov_supported properties on the nic host, so the user won't have to wait for the error message to see there is a problem.
*   there is an issue that the mac address of a VF is re-generated after each host reboot.
*   are labels on sr-iov enabled nic supported?
*   is label on passthrough network supported?

<Category:Feature> <Category:Networking>
