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

*   <b>passthrough</b>
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

*   new command that will be resposible for updating the SR-IOV related data on the nic.
*   <b>num of VFs</b>
    -   num of VFs is a new property that will be added to sr-iov capable host nic.
    -   it configures the number of VFs enabled on the nic.
    -   valid value is 0 or bigger (up to the maximum supported number by this nic, as reported by the getVdsCaps).
    -   this property can be updated just on nics that support sr-iov (as reported by the getVdsCaps).
    -   the number of vfs that are occupied (connected to a vm or any other connection).
*   <b>networks</b>
    -   list of the networks names that their configuration can be applied on the nic's VFs.
    -   vnic with one of this networks and sr-iov profile can be connected to a VF on this nic.
    -   the same network can appear in more than one nic's sr-iov network list.
    -   in case all networks allowed is true this list is ignored.
*   <b>all networks allowed</b>
    -   a boolean property that means there are no network restrictions and all the networks are allowed to be configured on the nic.
*   <b> labels</b>
    -   a list of labels
    -   all the networks that their label is in the list will be attached to the passthrough networks of the nic.
    -   the same sr-iov label can be on more than one nic.
    -   in case all networks allowed is true this list is ignored.
*   configuring SR-IOV related data on nics that are slaves of a bond is permited.

##### run vm

*   <b>scheduling host</b>
    -   if the vm has passthrough vnic, the physical nics to which the vnic's network is attached to are being checked.
        -   if ithere are no available VFs on none of the nics, the host is filtered out from the scheduling.
        -   if all the hosts were filtered out from the scheduling the running of the VM will fail and an appropriate error message will be displayed.
*   the engine will pass the following to the vdsm-
    -   the PF the vnic should be connected to one of its VFs.
    -   the network configuration that should be applied on the VF (vlan).

##### migration

*   scheduling the host- same as in run vm.
*   the engine will pass to vdsm the pf the vnic should be connected to one of its vfs.

#### Affected Entities

TBD (add vf's section to nic)

#### VDSM API

##### create

     create(Map createInfo) 

    params = {
         (Network VM device struct should be extended)
                 {
                   type: INTERFACE
                   ..
                  pf_name: string  <---  new property- the name of the physical function the vnic should be connected to one of its VFs.
                   vf_vlan: int <---  new property- the vlan id that should be applied on the VF the vnic will be connected to.
                }
     }

*   the selection of VFs should be done on the vdsm side, before the libvirt hook.
*   applying the vlan on the VF
    -   should be applied before starting the vm
    -   is applied on the VF using 'ip link vf NUM [ mac LLADDR ] [ vlan VLANID [ qos VLAN-QOS ] ] [ rate TXRATE ] }'.

##### migrate

     migrate(Map<String, String> migrationInfo, Map<String, Object>> vnics) 

    vnics = { 
                    alias <--- vm device name {
                             pf_name: string  <---  the name of the physical function the vnic should be connected to one of its VFs on the dst host.
                             }
                }
     }

*   For each vNic the <b>src host</b> should pass to the <b>dst host</d> the <b>PF</b> to which's VF the vNic should be connected (as passed on the <b>migrate</b> verb from the engine).
*   All the parameters (vlan, mtu, qos, etc) are copied from the src nic to the dst nic, so there is no need to also pass the vlan that was applied on the VF during create vm.

##### updateSriovNumVfs

    updateSriovNumVfs(Map<String, Integer> devices)

    params = {
                   device_name {
                                num_vfs: int <---  the number of VFs that should be enabled on the device
                   }
                }

*   this verb updates 'sriov_numvfs' file in sysfs (/sys/class/net/'device name'/device/sriov_numvfs) which contains the number of VFs that are enabled on this PF.
    -   The update is done by first removing all the existing VFs by changing the current value to 0 and than changing it to the desired value.
    -   Since changes in the 'sriov_numvfs' are not persistent across reboots the value should be stored in the vdsm's db and re-applied after each reboot.
*   the update should be blocked if-
    -   one or more of the VFs on the nic are not free.
    -   the desired value is bigger than sriov_totalvfs.

##### getVdsCaps

*   vdsCaps should report for each host-nic that supports sr-iov:
    -   sriov_totalvfs- contains the maximum number of VFs the device could support.
    -   sriov_numvfs- contains the number of VFs currently enabled on this device.
    -   sriov_freevfs- contains the number of vfs on the nic that are free.
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

### Future features

*   "Nice to have passthrough"
    -   Add a property to vm's vnic with passthrough profile that indicates whether connecting the vnic directly to VF is mandatory or the vnic can be connected to a regular network bridge in case there are no availiable VFs on any host.
*   Applying MTU and QoS configured on profile/network on VF.
*   Displaying on passthrough vnic to which PF its VF belongs.
*   Create a common in infrastracture for SR-IOV and VM-FEX.

### Limitations

Configuring the MTU is donw via-

    ip link set eth<X> vf <VFN>  [parameters] 

The parameters that are supported by kernel:

    IFLA_VF_MAC,            /* Hardware queue specific attributes */
     IFLA_VF_VLAN,       
     IFLA_VF_TX_RATE,        /* Max TX Bandwidth Allocation */
     IFLA_VF_SPOOFCHK,       /* Spoof Checking on/off switch */
    IFLA_VF_LINK_STATE,     /* link state enable/disable/auto switch */
     IFLA_VF_RATE,           /* Min and Max TX Bandwidth Allocation */

*   MTU and Qos are not supported.
    -   Applying MTU and QoS can be done manually according to the spec of each interface module.

### Dependencies / Related Features

*   [hostdev passthrough](http://www.ovirt.org/Features/hostdev_passthrough)
*   [UCS integration](http://www.ovirt.org/Features/UCS_Integration)
*   [PCI: SRIOV control and status via sysfs](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1789382a72a537447d65ea4131d8bcc1ad85ce7b)
*   List of drivers that support SR-IOV configure:
    -   [rhel6](http://paste.fedoraproject.org/138021/41214685)
    -   [rhel7](http://paste.fedoraproject.org/138020/21468381)

### Documentation / External references

*   [BZ 869804](https://bugzilla.redhat.com/869804): [RFE] [HP RHEV FEAT]: SR-IOV enablement in RHEV
*   [BZ 984601](https://bugzilla.redhat.com/984601): [RFE] [HP RHEV 3.4 FEAT]:Containment of error when an SR-IOV device encounters an error and VFs from the device are assigned to one or more guests (RHEV-M component)
*   [BZ 848202](https://bugzilla.redhat.com/848202): [RFE] Virtio over macvtap with SRIOV - RHEV Support
*   [BZ 848200](https://bugzilla.redhat.com/848200): [RFE] MAC Programming for virtio over macvtap - RHEV support

### Open issues

*   sriov_numvfs
    -   how to keep in persistent after reboot? (vdsm db, dev rule)
    -   how should the sriov_numvfs update be sent to the vdsm
        -   on of the setupNetworks verb (by adding a nics dictionary to the setup networks parameters)
        -   on a new verb- updateSriovNumVfs.
*   can MTU and QoS be configured on VF? (ip link vf NUM [ mac LLADDR ] [ vlan VLANID [ qos VLAN-QOS ] ] [ rate TXRATE ] })
    -   if MTU is not supported, how will it be exposed to the user? Blocking adding passthrough profiles to networks with non-default mtu and blocking chainging the mtu of network with passtheough profiles?
*   should custom properties configured on the nic be passed to the vf on create vm?

<!-- -->

*   host nic namagement
    -   should be per nic or one command to update all the nics?
    -   should contain update of num of VFs and network? or should be separate commands?
*   names
    -   what should be the name of the passthrough property on the profile- sr-iov? passthrough?
    -   nic- sr-iov labels? sr-iov networks? maybe entity on the nic- vds config that contains networks and labels.
*   there is an issue that the mac address of a VF is re-generated after each host reboot.
*   gui

<Category:Feature> <Category:Networking>
