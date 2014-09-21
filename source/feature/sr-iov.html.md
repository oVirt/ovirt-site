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

In order to connect a vnic directly to a sr-iov enabled nic the vnic's profile should be marked as a passthrough. The properties that should be configured on the VF are taken from the vnic's profile/network ( vlan, mtu, qos, custom properties). When starting the vm the vnic will be directly connected to one of the availiable VFs on the host's sr-iov enabled nic (the nic that contains the vnic's network in its sr-iov attachments).

#### Affected Flows

##### add/edit profile

*   <b>sr-iov passthrough </b>
    -   new property that will be added to the profile.
    -   passthrough property cannot be changed on edit profile if the profile is attached to a vnic.
    -   port-mirroring is not enabled on passthrough profile.

##### add/edit network

*   <b>sr-iov label </b>
    -   new property that will be added to the network.
    -   if the sr-iov label exists in the sr-iov labels list on a host's nic the network will be added to the nic's sr-iov attachments.

##### add/update network on cluster

*   (open issue- should passthrough network be always required?).
*   management, display and migration properties are not relevant for the sr-iov attachments.

##### add/edit vNic

*   <b>vnic profile/network is marked as passthrough</b>
    -   it means that the vnic will bypass the software network virtualization and will be connected directly to the VF.
    -   just <b>virtio</b> vnic type will be supported .
    -   the vnic profile/network represents set of properties that will be applied on the vf (open issue: what properties are supported ? vlan, MTU, QoS, custom properties).
    -   (open issue- should port mirroring be supported on passthrough vnic?).

##### hot plug nic

*   <b>plugging</b>
    -   hot plug of passthough vnic is possible if there is available VF on the PF.
*   <b>unplugging</b>
    -   if the vnic is pasthrough the VF will be released (and free for use).

##### vnic linking

*   <b>linking</b>
    -   linking of passthough vnic is possible if there is available VF on the PF.
*   <b>unlinking</b>
    -   if the vnic is pasthrough the VF will be released (and free for use).

##### network labelling

*   setting a label on a passthrough network should be supported.
*   the validation of the action should be according to the network co-existence rules (see setup networks flow fore more details).

##### setup networks

*   edit passthrough network-attachment via setup networks (?).
    -   setting boot-protocol on passthrough network is not supported (?).
    -   setting custom properties on passthrough network is not supported.
    -   sync passthrough network is not supported.
    -   <b>max_vfs</b>
        -   max_vfs is a new propery that will be added to host nic.
        -   it configure the max_vfs value on the nic.
        -   its value must be > 0.
        -   changing this value requires reboot of the host.
            -   if the max_vf value on the network-attachment is different that on the nic-network the nic will be marked as un-synced.
            -   just after the user will reboot the host manually the nic will be marked as synced.
        -   it should be enabled just on nics that support sr-iov.
    -   if the updated value is bigger than the max_vfs that can be supported by the physical nic, the operation will fail with explanation error message.
*   <b>passthrough network</b>
    -   can be attached just to sr-iov enabled nic.
    -   passthrough networks with and without vlan can co-exist together on the same sr-iov enabled nic.
    -   (open issue- since the configuration of the passthrough network will be applied just after starting the vm- are there any validation checks that need to be done in the setup networks stage to make sure there won't be any problem applying the configuration).
*   <b>regular network</b>
    -   regular network can be attached to a sr-iov enabled nic (also if there are passthrough networks attached to it).
    -   the logic for the co-exsistence of regular networks on the same nic won't be changed- passthrough networks will be ignored in this validation.
*   <b>label on sr-iov enabled nic</b>
    -   same as for regular nic- just with the coexistence rules of passthrough networks.
*   bonding of sr-iov enable nics- not supported (?).
*   setting max_vfs on a bond- not supported (?).

##### run vm

*   <b>scheduling host</b>
    -   if the vm has passthrough vnic, the physical nic to which the vnic's network is attached to is being checked.
        -   if it has the are no available VFs on the nic the host is filtered out from the scheduling.
    -   if all the hosts were filtered out from the scheduling the running of the VM will fail and an appropriate error message will be displayed.
*   just on run vm the relevant VF will be configured with the network configuration values.

##### migration

*   scheduling the host- same as in run vm.
*   the network configuration values will be set on the VFs of the scheduled host before the migration takes place.

#### VDSM API

*   setupNetworks verb will be extended

<!-- -->

    setupNetworks(Map networks, Map bonding, Map options)

    params = {
         network_name {
                   nic: nic name
                   vlan: vlan id
                   ..
                   max_vfs:<int> <---  new property- represents number of vfs to be configured on the nic
                }
     }

*   vdsCaps should report for each host-nic:
    -   max_vfs supported by the nic.
    -   max_vfs (num if) configured on the nic.
    -   num of vfs on the nic that are in use.

<!-- -->

*   setupNetworks verb should be expanded to have max_vfs on the struct.

#### User Experience

#### REST API

*   TBD

### Benefit to oVirt

*   Configuration of vnics in 'passthrough' mode directly from the gui/rest without the need of using vdsm-hook [2](http://www.ovirt.org/VDSM-Hooks/sriov)
*   Configuring max-vfs on a sr-iov enabled host nic via setup networks.
*   migration of vms using sr-iov.

### Dependencies / Related Features

*   [hostdev passthrough](http://www.ovirt.org/Features/hostdev_passthrough)
*   [UCS integration](http://www.ovirt.org/Features/UCS_Integration)

### Documentation / External references

*   [BZ 869804](https://bugzilla.redhat.com/869804): [RFE] [HP RHEV FEAT]: SR-IOV enablement in RHEV
*   [BZ 984601](https://bugzilla.redhat.com/984601): [RFE] [HP RHEV 3.4 FEAT]:Containment of error when an SR-IOV device encounters an error and VFs from the device are assigned to one or more guests (RHEV-M component)
*   [BZ 848202](https://bugzilla.redhat.com/848202): [RFE] Virtio over macvtap with SRIOV - RHEV Support
*   [BZ 848200](https://bugzilla.redhat.com/848200): [RFE] MAC Programming for virtio over macvtap - RHEV support

### Open issues

*   should passthrough profile on non-vm network be blocked?
*   should passthrough proeprty be configured on the network or on the vnic profile?
    -   if on the profile, how the following issues will be solved:
        -   coexistence of non-vlan networks on the same nic.
        -   configuring max_vfs on network_attachment.
*   should the passthrough property mandatory or just a nice to have? (if there is no suitable host with sr-iov enabled nic- should running/migrating the vm fail?)
*   what properties can be configured on VF- vlan, MTU, QoS, custom properties?
*   should passthrough network be always required?
*   can passthrough network be management, display or migration network?
*   there is an issue that the mac address of a VF is re-generated after each host reboot.
*   unplug/unlink passthrough vnic- is it suppoerted?
*   since the configuration of the passthrough network will be applied just after starting the vm- are there any validation checks that need to be done in the setup networks stage to make sure there won't be any problem applying the configuration?
*   should port mirroring be supported on passthrough vnic?
*   what about ucs- vm fex- should it have a separate passthrough property or should the technology (vm fex or sr-iov) should be transparent to the user at this stage?

#### Low level issues

*   Is it possible to set max_vfs on-the-fly, after the kernel module is already loaded? Is it possible programmatically reboot the host?
*   Is it possible to tell if nic is sr-iov enabled?
*   Is it possible to tell what is the max_vfs supported by each module/hardware?
*   Is migration of vms connected to VFs possible? Is it possible to migrate from a bridge to a VF?
*   Is plugging/unplugging and linking/unlinking of vnic connected to VF possible?

<Category:Feature> <Category:Networking>
