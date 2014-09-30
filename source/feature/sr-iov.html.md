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

*   <b>sr-iov</b>
    -   new property that will be added to the profile.
    -   passthrough property cannot be changed on edit profile if the profile is attached to a vnic.
    -   port-mirroring is not enabled on passthrough profile.

##### add/update network on cluster

*   management, display and migration properties are not relevant for the VFs configuration (e.g if a migration network is attached to nic1 via the PF configuration and also exists in the VFs configuration of nic2- the migration will take place on nic1 and NOT on the VF on nic2).
*   Same for the required property. It doesn't relevant for the VFs configuration and related just to the regular network attachments.

##### add/edit vNic

*   <b> if the selected vnic profile is marked as passthrough</b>
    -   it means that the vnic will bypass the software network virtualization and will be connected directly to the VF.
    -   just <b>virtio</b> vnic type will be supported .
    -   the vnic profile/network represents set of properties that will be applied on the vf.

##### hot plug nic

*   <b>plugging</b>
    -   hot plug of passthough vnic is possible if there is available VF on the one of the PFs the vnic's network is in its sr-iov attachments.
*   <b>unplugging</b>
    -   if the vnic is pasthrough the VF will be released (and free for use).

##### vnic linking

*   <b>linking</b>
    -   linking of passthough vnic is possible if there is available VF on the one of the PFs the vnic's network is in its sr-iov attachments.
*   <b>unlinking</b>
    -   if the vnic is pasthrough the VF will be released (and free for use).

##### sr-iov host nic management

*   <b>vfs</b>
    -   <b>max vfs</b>
        -   max_vfs is a new property that will be added to sr-iov capable host nic.
        -   it configures the max_vfs value on the nic. The max_vfs parameter causes the driver to spawn, up to the value of the parameter in, Virtual Functions. (Since VF requires actual hardware resources, most of the times the practical max_vfs should be much lower than the theoretical number of supported vfs).
        -   setting this value is optional- if the value is not set- the number of vfs on the nic will be kept.
        -   valid value is 0 or bigger (up to the maximum supported number on this nic).
        -   changing this value requires reboot of the host.
        -   it should be enabled just on nics that support sr-iov.
        -   editing the value should be disabled in case there are running vms on the host.
    -   <b> maximum vfs supported</b>
        -   maximum number of vfs supported by the nic hardware.
        -   read only value.
        -   used to validate that max_vfs is lower than it.
    -   <b> vfs configured on the nic</b>
        -   indicates the number of vfs that are actually configured on the nic.
        -   this value is needed to know if max_vfs value was applied or the nic is out of sync and needs reboot.
    -   <b>vfs in use</b>
        -   the number of vfs that are occupied (connected to a vm or any other connection).
*   <b>networks</b>
    -   the networks that their configuration can be applied on the nic's vfs.
    -   vnic with one of this networks and sr-iov profile can be connected to a vf on this nic.
    -   the same network can appear in more than one nic's sr-iov network list.
*   <b> sr-iov labels</b>
    -   a list of labels
    -   all the networks that their label is in the list will be attached to the passthrough netwroks of the nic.
    -   the same sr-iov label can be on more than one nic.
    -   effects on setup networks
*   the same networks/labels can be configured on sr-iov configuration of the nic and via setup networks.
*   (open issue- can bond be configured on nics that are used as sr-iov nics?)

##### run vm

*   <b>scheduling host</b>
    -   if the vm has passthrough vnic, the physical nic to which the vnic's network is attached to is being checked.
        -   if ithere are no available VFs on the nic, the host is filtered out from the scheduling.
        -   if all the hosts were filtered out from the scheduling the running of the VM will fail and an appropriate error message will be displayed.
    -   on run vm the engine will pass to the vdsm-
        -   the pf the vnic should be connected to one of its vfs.
        -   the network configuration that should be applied on the vf (vlan, qos, mtu).
            -   the network configuration will be applied on the vf before starting the vm.

##### migration

*   scheduling the host- same as in run vm.
    -   the engine will pass followibng to the vdsm-
        -   the pf the vnic should be connected to one of its vfs.
        -   the network configuration that should be applied on the vf (vlan, qos, mtu).
            -   the network configuration values will be applied on the VFs of the scheduled host before the migration takes place.

#### VDSM API

*   TBD - fix this section!
*   setupNetworks verb will be extended (???)

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

*   start vm
*   the selection of VFs should be done on the vdsm, before the libvirt hook hook.

<!-- -->

*   migrate vm
*   vdsCaps should report for each host-nic:
    -   sriov_totalvfs- contains the maximum number of VFs the device could support.
    -   sriov_numvfs- contains the number of VFs currently enabled on this device.
    -   sriov_busyvfs- contains the number of vfs on the nic that are in use.
    -   today free VFs are reported by the vdsm on getVdsCaps. It should be avoided. Just PFs should be reported.
        -   free VF considered as VF that a vm can be connected directly to it (no ip, no device [tap, bridge, etc]).

#### User Experience

*   TBD

#### REST API

*   TBD

### Benefit to oVirt

*   Configuration of vnics in 'passthrough' mode directly from the gui/rest without the need of using vdsm-hook [2](http://www.ovirt.org/VDSM-Hooks/sriov)
*   Configuring max-vfs on a sr-iov enabled host nic via setup networks.
*   migration of vms using sr-iov.

### Dependencies / Related Features

*   [hostdev passthrough](http://www.ovirt.org/Features/hostdev_passthrough)
*   [UCS integration](http://www.ovirt.org/Features/UCS_Integration)
*   [PCI: SRIOV control and status via sysfs](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1789382a72a537447d65ea4131d8bcc1ad85ce7b)

### Documentation / External references

*   [BZ 869804](https://bugzilla.redhat.com/869804): [RFE] [HP RHEV FEAT]: SR-IOV enablement in RHEV
*   [BZ 984601](https://bugzilla.redhat.com/984601): [RFE] [HP RHEV 3.4 FEAT]:Containment of error when an SR-IOV device encounters an error and VFs from the device are assigned to one or more guests (RHEV-M component)
*   [BZ 848202](https://bugzilla.redhat.com/848202): [RFE] Virtio over macvtap with SRIOV - RHEV Support
*   [BZ 848200](https://bugzilla.redhat.com/848200): [RFE] MAC Programming for virtio over macvtap - RHEV support

### Open issues

*   names
    -   profile - sr-iov passthrough?
    -   nic- sr-iov labels? sr-iov networks? maybe entity on the nic- vds config that contains networks and labels.
*   should vf/pf be displayed in vm=>vnic table.
*   should the passthrough property mandatory or just a nice to have? (if there is no suitable host with sr-iov enabled nic- should running/migrating the vm fail?)
*   there is an issue that the mac address of a VF is re-generated after each host reboot.
*   what about ucs- vm fex- should it have a separate passthrough property or should the technology (vm fex or sr-iov) should be transparent to the user at this stage?
*   gui

#### Low level issues

*   max_vfs
    -   is all the logic around max_vfs is necessary or is it enough to pass comma separated string on the host level?
    -   do we support other modules than igb? how do we configure max_vfs on other modules?
    -   Is it possible to configure different max_vfs on each nic?
    -   Is it possible to set max_vfs on-the-fly, after the kernel module is already loaded?
    -   consider adding reboot verb to vdsm.
    -   Is it possible to tell if nic is sr-iov enabled?
    -   Is it possible to tell what is the max_vfs supported by each module/hardware?
    -   is it possible to provide the other three vfs related parameters as described on the sr-iov management section?
*   Is migration of vms connected to VFs possible? Is it possible to migrate from a bridge to a VF?
*   Is plugging/unplugging and linking/unlinking of vnic connected to VF possible?
*   can bond be configured on nics that are used as sr-iov nics?
*   what properties can be configured on VF- vlan, MTU, QoS, custom properties? (ip link vf NUM [ mac LLADDR ] [ vlan VLANID [ qos VLAN-QOS ] ] [ rate TXRATE ] })

<!-- -->

*   max vfs- is the change saved after reboot? if fails

<Category:Feature> <Category:Networking>
