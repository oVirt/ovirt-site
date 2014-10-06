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

*   Last update date: 05/10/2014

### Introduction

SR-IOV enables a Single Root Function (for example, a single Ethernet port), to appear as multiple, separate, physical devices. SR-IOV uses two PCI functions:

*   Physical Functions (PFs)- Full PCIe device that includes the SR-IOV capabilities.
*   Virtual Functions (VFs)- ’lightweight’ PCIe functions that contain the resources necessary for data movement but have a carefully minimized set of configuration resources.

VM's nic (vNic) can be connected directly to a VF (1-1) instead of to virtual network bridge (vm network). Bypassing the virtual networking devices on the host reduces latency and CPU utilization.
![](Sr-iov.png "fig:Sr-iov.png")

#### High Level Feature Description

In order to connect a vNic directly to a VF of SR-IOV enabled nic the vNic's profile should be marked as a "passthrough" one. The properties that should be configured on the VF are taken from the vNic's profile/network (vlan tag, mtu, custom properties). Each SR-IOV enabled host-nic should have VF configuration which will define its allowed networks. When starting the VM, the vNic will be directly connected to one of the free VFs of a host's SR-IOV enabled nic (the host-nic should contain the vNic's network in its allowed networks list).

<b> Note: this feature is about exposing a virtualized (or VirtIO) vNic to the guest, and not about exposing the PCI device to it. This restriction is necessary for migration to be supported.</b>

#### Affected Flows

##### add/edit profile

*   <b>passthrough</b>
    -   new property that will be added to the profile.
    -   passthrough property cannot be changed on edit profile if the profile is attached to a vNic.
    -   port-mirroring is not enabled on passthrough profile.
    -   QoS is not enabled on passthrough profile.

##### add/update network on cluster

*   management, display and migration properties are not relevant for the VFs configuration (e.g if a migration network is attached to nic1 via the PF configuration and also exists in the VFs configuration of nic2- the migration will take place on nic1 and NOT on the VF on nic2).
*   Same for the required property. It doesn't relevant for the VFs configuration and related just to the regular network attachments.

##### add/edit vNic

*   <b> if the selected vNic profile is marked as passthrough</b>
    -   it means that the vNic will bypass the software network virtualization and will be connected directly to the VF.
    -   just <b>virtio</b> vNic type will be supported .
    -   the vNic profile/network represents set of properties that will be applied on the VF.

##### hot plug nic

*   <b>plugging</b>
    -   hot plug of passthough vNic is possible if there is an available VF on one of the PFs that the vNic's network has in its sr-iov configuration.
*   <b>unplugging</b>
    -   if the vNic is passthrough the VF will be released (and free for use).

##### vNic linking

*   <b>linking</b>
    -   linking of passthough vNic is possible if there is available VF on the one of the PFs the vNic's network is in its sr-iov configuration.
*   <b>unlinking</b>
    -   if the vNic is passthrough the VF will be released (and free for use).

##### sr-iov host nic management

*   new command that will be responsible for updating the SR-IOV related data on the nic.
*   <b>num of VFs</b>
    -   num of VFs is a new property that will be added to sr-iov capable host nic.
    -   it configures the number of VFs enabled on the nic.
    -   valid value is 0 or bigger (up to the maximum supported number by this nic, as reported by getVdsCaps).
    -   this property can be updated just on nics that support sr-iov (as reported by getVdsCaps).
    -   this property can be updated just if all the VFs on the PF are free (as reported by getVdsCaps).
*   <b>networks</b>
    -   list of the network names that their configuration can be applied on the nic's VFs.
    -   just vm networks are allowed to appear in this list.
        -   it means that if the network of a passthrough vNic is in the list, the vNic can be connected to a free VF on this physical nic.
    -   the same network can appear in more than one nic's sr-iov network list.
    -   in case 'all networks allowed' is true this list is ignored.
*   <b>all networks allowed</b>
    -   a boolean property that means there are no network restrictions and all the networks are allowed to be configured on the nic.
*   <b> labels</b>
    -   a list of labels
    -   all the networks that their label is in the list will be attached to the sr-iov networks list of the nic.
    -   the same sr-iov label can be on more than one nic.
    -   in case all networks allowed is true this list is ignored.
*   configuring SR-IOV related data on nics that are slaves of a bond is permitted.

##### run vm

*   <b>scheduling host</b>
    -   if the VM has a passthrough vNic, the physical nics to which the vNic's network is attached to are being checked.
        -   if there are no available VFs on none of the nics, the host is filtered out from the scheduling.
        -   if all the hosts were filtered out from the scheduling the running of the VM fails and an appropriate error message is displayed.
*   the engine will pass the following to the vdsm-
    -   the PF the vNic should be connected to one of its VFs.
    -   the network configuration that should be applied on the VF (vlan, mtu).

##### migration

*   scheduling the host- same as in run vm.
*   the engine will pass to vdsm the PF the vNic should be connected to one of its VFs.

#### VDSM API

##### create

     create(Map createInfo) 

    params = {
     (Network VM device struct should be extended)
     {
      type: INTERFACE
      ..
      pf_name: string  <---  new property- the name of the PF the vNic should be connected to one of its VFs.
      vf_vlan: int <---  new property- the vlan id that should be applied on the VF the vnic will be connected to.
      vf_mtu: int <---  new property- the mtu that should be applied on the VF the vnic will be connected to.
     }
    }

*   the selection of VFs should be done on the vdsm side, before calling the libvirt module.
*   vf_vlan and vf_mtu should be applied on the VF before starting the vm.

##### migrate

     migrate(Map<String, String> migrationInfo, Map<String, Object>> vnics) 

    vnics = {
       alias {
        pf_name: string  <---  the name of the PF the vnic should be connected to one of its VFs on the dst host.
     }
    }

*   For each vnic the <b>src host</b> should pass to the <b>dst host</d> the <b>PF</b> to which's VF the vnic should be connected (as passed on the <b>migrate</b> verb from the engine).
*   All the parameters (vlan, mtu, etc...) are copied from the src nic to the dst nic, so there is no need to also pass the vlan and the mtu that were applied on the VF during create vm.

##### updateSriovNumVfs

    updateSriovNumVfs(Map<String, Integer> devices)

    params = {
     device_name {
         num_vfs: int <---  the number of VFs that should be enabled on the device
        }
     }

*   this verb updates 'sriov_numvfs' file in sysfs (/sys/class/net/'device name'/device/sriov_numvfs) which contains the number of VFs that are enabled on this PF.
    -   The update is done by first changing the current value to 0 in order to remove all the existing VFs and then changing it to the desired value.
    -   Since changes in the 'sriov_numvfs' are not persistent across reboots the value should be stored in the vdsm's db and re-applied after each reboot.
*   the update should be blocked if-
    -   one or more of the VFs on the nic are not free.
    -   the desired value is bigger than sriov_totalvfs.

##### getVdsCaps

*   vdsCaps should report for each host-nic that supports sr-iov:
    -   sriov_totalvfs - contains the maximum number of VFs the device could support.
    -   sriov_numvfs- contains the number of VFs currently enabled on this device.
    -   sriov_freevfs- contains the number of VFs on the nic that are free.
    -   today free VFs are reported by the vdsm on getVdsCaps. It should be avoided. Just PFs should be reported.
        -   free VF considered as VF that a vm can be connected directly to it (no ip, no device [tap, bridge, etc]).

#### User Experience

##### Setup networks

<b>Option 1</b>

*   SR-IOV capable nics
    -   should have sr-iov enabled icon ![](Nic_sr_iov.png "fig:Nic_sr_iov.png")
    -   edit nic dialog should be expended to contain VFs managenet tab
         ![](Sriovvirtual.png "fig:Sriovvirtual.png")
    -   Edit PF labels
         ![](Sriovphisical.png "fig:Sriovphisical.png")
    -   Edit num of VFs
         ![](Sriovnumsetting.png "fig:Sriovnumsetting.png")
    -   Edit VFs networks and labels
         ![](Sriovcustom network.png "fig:Sriovcustom network.png")
*   SR-IOV capable nics which are slaves of a bond should have the same edit dialog as regular SR-IOV capable nics just without the PF tab.
*   Nic which don't support sr-iov shouldn't have tab at all (should look the same as they look now, before the feature).

<b>Option 2</b>

*   Adding new 'sr-iov configuration' tab to setup network dialog.
    -   The tab will display just sr-iov capable nics.
    -   The 'unassiged networks' section will be called just 'Networks'
        -   It will contain all the vm networks.
        -   Since the same network can be attach to more than one nic, it won't be possible to detach a network from this section (if a network from the 'Networks' section is dragged to a nic, it will be presented on both the nic and the 'Networks' section).
    -   If there are no networks attached to the nic the default is 'all networks in cluster'.
    -   Each nic will have edit dialog for updating num of vfs.
    -   Hosts with no SR-IOV enabled nic will have the regular display and won't have tabs.
    -   TBD: mock for option 2

##### Add/Edit vNic profile

*   Passthrough property is added to the dialog.
*   If passthrough is true, port mirroring and QoS should be disabled.

![](Vm_interface_profile.jpg "Vm_interface_profile.jpg")

#### REST API

##### Vnic profile

    api/vnicprofiles/[profile_id]

Adding 'passthrough' boolean property.

##### SR-IOV host nic management

The <b>VFs configuration</b> on a SR-IOV enabled nic is represented as a sub resource of a nic.

    api/hosts/[host_id]/nics/manageVfs

*   Supported actions:
    -   <b>GET</b> return the VFs configuration of the nic (num of VFs, allowed networks and labels).
    -   <b>PUT</b> updating the <b>num of vfs</b> enabled on the nic

<!-- -->

    <num_of_vfs>num</num_of_vfs>

The <b>networks</b> on the VF configuration of a host-nic are represented as a sub-collection of the vfsConfig resource:

     /api/hosts/{host:id}/nics/{nic:id}/vfsConfig/networks

*   Supported actions:
    -   <b>GET</b> returns the network list of the VFs configuration.
    -   <b>POST</b> adds a new network to the VFs configuration.

<!-- -->

     /api/hosts/{host:id}/nics/{nic:id}/vfsConfig/network/{networkl:id}

*   Supported actions:
    -   <b>GET</b> returns a specific network of the VFs configuration.
    -   <b>DELETE</b> removes a network from the VFs configuration.

 The network <b>labels</b> on the VF configuration of a host-nic are represented as a sub-collection of the vfsConfig resource:

     /api/hosts/{host:id}/nics/{nic:id}/vfsConfig/labels

\*Supported actions:

*   -   <b>GET</b> returns the label's list of the VFs configuration.
    -   <b>POST</b> adds a new label (and all the network managed by it) to the VFs configuration.

<!-- -->

     /api/hosts/{host:id}/nics/{nic:id}/vfsConfig/labels/{label:id}

\*Supported actions:

*   -   <b>GET</b> returns a specific label fn the vfs configuration.
    -   <b>DELETE</v> removes a label (and all the networks managed by it) from the VFs configuration.

### Benefit to oVirt

*   Configuration of vNics in 'passthrough' mode directly from the gui/rest.
*   Configuring max-vfs on a sr-iov enabled host nic via setup networks.
*   migration of vms using sr-iov.

### Limitations

In order for migration to be supported the passthrough vNic should be of VirtIo type. That means the vNic is not connected in a PCI passthrough mode directly to the VF, but connected to a macVTap device which is connected to the VF.
TBD- adding a performance comparison between connecting directly to the VF vs connecting to the VF via macVTap.

### Future features

*   "Nice to have passthrough"
    -   Add a property to passthrough vNic (a vNic with passthrough profile) that indicates whether connecting the vNic directly to VF is mandatory or the vNic can be connected to a regular network bridge in case there are no available VFs on any host.
*   Displaying on passthrough vNic the VF to which it is connected, and the corresponding PF.
*   Create a common infrastracture for SR-IOV and VM-FEX.
*   Applying on VF the QoS configured on profile/network.
*   Support port mirroring on passthrough vNics.

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
    -   how should the sriov_numvfs update be sent to the vdsm?
        -   on of the setupNetworks verb (by adding a nics dictionary to the setup networks parameters).
        -   on a new verb- updateSriovNumVfs.
*   Is applying MTU on VF supported by libvirt?
*   Setup network gui- which option to choose 1 (editing sr-iov config of a nic on edit nic dialog) or 2 (tabed setup networks dialog)?

### Notes

*   setting properties on VF-
     ip link set {DEVICE} vf {NUM} [ mac LLADDR ] [ vlan VLANID [ qos VLAN-QOS ] ] [ rate TXRATE ] [ spoofchk { on | off } ] [ state { auto | enable | disable} ]
*   Update num of VFs
    -   /sys/class/net/'device name'/device/sriov_totalvfs
        -   contains the num of vfs supported by the device
        -   just sr-iov supported nics contain this file.
    -   /sys/class/net/'device name'/device/sriov_numvfs
        -   contains num of VFs enabled by the nics.
        -   In order to update the file the value should first be changed to 0 (i.e all the VFs should first be removed).
            -   for example- echo '0' > /sys/class/net/eth0/device/sriov_numvfs ==> echo '7' > /sys/class/net/eth0/device/sriov_numvfs
        -   just sr-iov supported nics contain this file.

<Category:Feature> <Category:Networking>
