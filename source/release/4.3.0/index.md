---
title: oVirt 4.3.0 Release Notes
category: documentation
toc: true
authors: sandrobonazzola, gregsheremeta
page_classes: releases
---

# oVirt 4.3.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.0 release as of February 04, 2019.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.3.0, see the [release notes for previous versions](/documentation/#previous-release-notes).


### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## Known Issues
- [Bug 1672587 - VNC encryption is true on host after upgrade causing "Unsupported security types: 19"](https://bugzilla.redhat.com/show_bug.cgi?id=1672587) causes VNC console to be broken. As a workaround, disable the vnc_tls flag on the Host and restart libvirt, or use SPICE. See the BZ for details.
- [Bug 1662047 – [UI] 2 dashboard icons after upgrade](https://bugzilla.redhat.com/show_bug.cgi?id=1662047) causes 2 dashboard icons after upgrade. An async fix has already been published. New standalone and hosted engine upgrades will catch the fix. If you have already upgraded to 4.3.0 and see the issue, run `yum update` and `engine-setup` on your Engine.

## What's New in 4.3.0?

### Release Note

#### VDSM

 - [BZ 1655115](https://bugzilla.redhat.com/1655115) <b>Drop 3.6 and 4.0 datacenter/cluster level</b><br>The current release removes the VDSM daemon's support for cluster levels 3.6/4.0 and Red Hat Virtualization Manager 3.6/4.0. This means that VDSM from RHV 4.3 cannot be used with the Manager from RHV 3.6/4.0. To use the new version of VDSM, upgrade the Manager to version 4.1 or higher.
 - [BZ 1514004](https://bugzilla.redhat.com/1514004) <b>[downstream clone - 4.3.0] [RFE] Drop TLSv1 and TLSv1.1 encryption protocols support</b><br>The TLSv1 and TLSv1.1 protocols are no longer secure. They have been forcefully disabled in the VDSM configuration and cannot be enabled.<br><br>Only TLSv1.2 and higher versions of the protocol are enabled. The exact version enabled depends on the underlying OpenSSL version.

#### oVirt Engine

 - [BZ 1627756](https://bugzilla.redhat.com/1627756) <b>On engine side replace fluentd dependencies with rsyslog</b><br>The current release replaces Fluentd with Rsyslog for collecting oVirt logs and collectd metrics. Systems running Red Hat Virtualization Manager and upgraded from 4.2 will still have Fluentd installed but it will be disabled and stopped.<br>After upgrading to 4.3, you can remove the Fluentd packages.
 - [BZ 1550634](https://bugzilla.redhat.com/1550634) <b>Drop 3.6 and 4.0 datacenter/cluster level</b><br>This release removes the Red Hat Virtualization Manager support for clusters levels 3.6 and 4.0. Customers must upgrade their data centers to Red Hat Virtualization Manager 4.1 or later before upgrading to Red Hat Virtualization Manager 4.3.
 - [BZ 1599321](https://bugzilla.redhat.com/1599321) <b>Config values inconsistency between RHV versions</b><br>There are inconsistencies in the following internal configuration options:<br>- HotPlugCpuSupported<br>- HotUnplugCpuSupported<br>- HotPlugMemorySupported<br>- HotUnplugMemorySupported<br>- IsMigrationSupported<br>- IsMemorySnapshotSupported<br>- IsSuspendSupported<br>- ClusterRequiredRngSourcesDefault<br>Systems that have upgraded from RHV 4.0 to RHV 4.1/4.2 and are experiencing problems with these features should upgrade to RHV 4.2.5 or later.
 - [BZ 1651220](https://bugzilla.redhat.com/1651220) <b>Require Ansible 2.7+</b><br>This release adds a requirement for Ansible version 2.7, the lowest version required to run oVirt Ansible roles.

#### oVirt Host Dependencies

 - [BZ 1627753](https://bugzilla.redhat.com/1627753) <b>On hosts replace fluentd dependencies with rsyslog</b><br>The current release replaces Fluentd with Rsyslog for collecting oVirt logs and collectd metrics.<br>Hosts upgraded from 4.2 will still have Fluentd installed, but the service is disabled and stopped.<br>After upgrading to 4.3, you can remove the fluentd packages.

#### oVirt Release Package

 - [BZ 1609884](https://bugzilla.redhat.com/1609884) <b>ovirt-release-master for centos doesn't contain current ovirt-web-ui</b><br>In this release, the oVirt release package for master, ovirt-release-master, enables a new repository hosted on the Cool Other Package Repositories (COPR) service for delivering ovirt-web-ui packages.

### Enhancements

#### VDSM

 - [BZ 1644693](https://bugzilla.redhat.com/1644693) <b>High Host CPU load for Windows 10 Guests (Update 1803)  when idle</b><br>Feature: Added enlightenment support in order to reduce CPU load by enabling the hyper-visor synic and stimer states.  <br><br>Reason: To improve performance when running Windows as a guest OS.<br><br>Result: Anticipated results are that CPU load will be reduced to 0-5% on Linux Virtual Machines.
 - [BZ 1641125](https://bugzilla.redhat.com/1641125) <b>[RFE] add a configuration policy for vGPU placement</b><br>It is now possible to set in host configuration preferred vGPU placement on physical cards. Separated placement prefers putting each vGPU on a separate physical card, consolidated placement prefers putting more vGPUs on available physical cards.
 - [BZ 1598391](https://bugzilla.redhat.com/1598391) <b>[RFE] - Certify OSP 14 with OVN as an external network provider on RHV 4.3</b><br>Neutron from OSP 14 configured to use OVN can be used as an external network provider on RHV 4.3 with the limitation described in bug 1655906 .
 - [BZ 1625612](https://bugzilla.redhat.com/1625612) <b>[RHV] failed to convert VMware ESX VM with snapshot</b><br>Feature: Removes the code within the VDSM blocking the importing of VMWare VMs with snap shots in order to take advantage of virt-v2v support for importing these types of VMs that was added to the virt-v2v-1.36.10-6.el7.x86_64.rpm package.<br><br>Reason: We would like to expose this feature for use by oVirt users.<br><br>Result: oVirt now supports the importing of VMware VMs that include snap shots.
 - [BZ 1587892](https://bugzilla.redhat.com/1587892) <b>After importing KVM VM the actual size is bigger than the virtual size</b><br>Feature: <br><br>Added KVM Sparseness support to KVM to oVirt Virtual Machine Importing so that when Thin Provisioning is enabled, the Disk Size of the original KVM Image will be preserved after importing to oVirt.   <br><br>Reason: <br><br>Unless the user specifically specifies pre-allocation, the Disk Size of the Virtual Machine should be no larger than required during initial allocation of Disk Space when the VM is running. Previously when choosing Thin Provisioning for KVM to oVirt Importing, the Disk Size of the VM within the Storage Domain of oVirt was inflated to the Volume Size or Larger when the original KVM VM was much smaller.  <br><br>Result: <br><br>Now when Importing Virtual Machines from KVM to oVirt with Thin Provisioning selected, the original Disk Size of the VM is preserved.
 - [BZ 1510856](https://bugzilla.redhat.com/1510856) <b>[RFE] Time sync in VM after resuming from PAUSE state</b><br>Feature: <br><br>Added optional Guest Time Synchronization to the snapshot functionality via the time_sync_snapshot_enable option and other un-pausing scenarios via the time_sync_cont_enable option for synchronizing and correcting the time on the VM after long pauses. The defaults for the option are turned off for backward compatibility.<br><br>Reason: <br><br>This becomes especially critical when there are heavy loads on the VM to ensure time stamps for example are accurate.<br><br>Result: <br><br>When the options are enabled, the VDSM shall attempt to synchronize the time either during pauses that occur via during snapshots and/or during other un-pausing functionality.
 - [BZ 1451297](https://bugzilla.redhat.com/1451297) <b>[RFE] Drop TLSv1 and TLSv1.1 encryption protocols support</b><br>TLSv1 and TLSv1.1 protocols are no longer secure, so they are forcefully disabled in VDSM configuration and cannot no longer be enabled within configuration.<br><br>Only TLSv1.2 and higher version of protocols are enabled, exact versions depends on underlying openssl version.

#### oVirt Engine

 - [BZ 1644693](https://bugzilla.redhat.com/1644693) <b>High Host CPU load for Windows 10 Guests (Update 1803)  when idle</b><br>Feature: Added enlightenment support in order to reduce CPU load by enabling the hyper-visor synic and stimer states.  <br><br>Reason: To improve performance when running Windows as a guest OS.<br><br>Result: Anticipated results are that CPU load will be reduced to 0-5% on Linux Virtual Machines.
 - [BZ 1661921](https://bugzilla.redhat.com/1661921) <b>ovirt-provider-ovn TLS hardening (Default use of TLSv1.2 and HIGH ciphers only)</b><br>Feature: <br> - internal OVN db connections are encrypted by TLS 1.2 with 'HIGH' chiphers in<br>   new RHV 4.3 installations by default<br> - Ciphers used on ovirt-provider's OpenStack REST API are configurable<br><br>Reason: <br> - bug 1459441 enables RHV to configure the encryption of OVN internal connections<br> - default OpenSSL config in RHEL 7 allows usage of insecure ciphers<br><br>Result: <br> - in RHV 4.3 default config internal OVN connections and<br>   ovirt-provider's OpenStack REST API uses TLS 1.2 and HIGH ciphers.
 - [BZ 1571371](https://bugzilla.redhat.com/1571371) <b>[RFE] Allow pinning a VM (specifically high-performance) with vNUMA to more than one host</b><br>Feature: A VM with NUMA pinning enabled can now be configured to run on a set of assigned/pinned hosts (one or more).<br><br>Reason: Up till now there was a limitation that only one host (and not more than one) can be assigned to a VM, in case of NUMA nodes pinning is enabled.<br><br>Result: A VM with NUMA pinning enabled can now be configured to run on a set of assigned/pinned hosts, one or more (by selecting the "Start running on: Specific Host" in "Host" side-tab). <br>Each one of this hosts should have the same pinning settings so that VM can run on each and this is verified by the engine.<br>This change is crucial for supporting High Availability for those VMs.
 - [BZ 1641125](https://bugzilla.redhat.com/1641125) <b>[RFE] add a configuration policy for vGPU placement</b><br>It is now possible to set in host configuration preferred vGPU placement on physical cards. Separated placement prefers putting each vGPU on a separate physical card, consolidated placement prefers putting more vGPUs on available physical cards.
 - [BZ 1539829](https://bugzilla.redhat.com/1539829) <b>[RFE] Provide support for adding security groups and rules using ovirt-provider-ovn</b><br>This feature provides security group support, as described by the OpenStack Networking API.
 - [BZ 1619210](https://bugzilla.redhat.com/1619210) <b>[RFE] Provide Live Migration for VMs based on "High Performance VM" Profile - automatic migrations</b><br>Feature: <br>This feature provides the ability to enable live migration for HP VMs (and in general to all VM types with pinning settings).<br><br>Reason: <br>n oVirt 4.2 we added a new “High Performance” VM profile type. This required configuration settings includes pinning the VM to a host based on the host specific configuration. Due to that pinning settings, the migration option for the HP VM type was automatically forced to be disabled.<br><br>Result: <br>in oVirt 4.3 we will provide the ability for live migration of HP VMs (and all other VMs with pinned configuration like NUMA pinning, CPU pinning and CPU pass-through enabled). <br><br>For more details, please refer to the [feature page](/develop/release-management/features/virt/high-performance-vm-migration.html)
 - [BZ 1648190](https://bugzilla.redhat.com/1648190) <b>[RHEL76] libvirt is unable to start after upgrade due to malformed UTCTIME values in cacert.pem, because properly renewed CA certificate was not passed to hosts by executing "Enroll certificate" or "Reinstall"</b><br>Internal CAs generated in the past (<= 3.5) can contain UTCTIME values without timezone indication and this is not acceptable anymore with up to date openssl and gnutls libraries.<br>engine-setup was already checking it proposing a remediation but the user can postpone it, making it more evident since now postponing can cause serious issues.
 - [BZ 1111783](https://bugzilla.redhat.com/1111783) <b>[RFE][TestOnly] Provide SCSI reservation support for virtio-scsi via rhev-guest-tools for win-8 and win-2012 guests using Direct-Lun as disks</b><br>With this release Windows clustering is supported for iSCSI based direct attached LUNs.
 - [BZ 1598391](https://bugzilla.redhat.com/1598391) <b>[RFE] - Certify OSP 14 with OVN as an external network provider on RHV 4.3</b><br>Neutron from OSP 14 configured to use OVN can be used as an external network provider on RHV 4.3 with the limitation described in bug 1655906 .
 - [BZ 1327846](https://bugzilla.redhat.com/1327846) <b>[RFE] Q35: Support booting virtual machines via UEFI</b><br>
 - [BZ 1590202](https://bugzilla.redhat.com/1590202) <b>[RFE] Disable Event notification popup in admin portal</b><br>This adds a feature to control toast notifications. Once 3 or more notifications are showing, "Dismiss" and "Do not disturb" buttons will appear that allow the user to silence notifications.
 - [BZ 1571399](https://bugzilla.redhat.com/1571399) <b>[RFE] Improve UI plugin API for adding action buttons</b><br>Feature: When adding custom action buttons (located above main or details tab grid) via UI plugin API, it's now possible to specify the relative position of the button and whether it should be placed in the "more" menu.<br><br>Reason: Give UI plugins more control over plugin-contributed action button placement.<br><br>Result: When calling addMenuPlaceActionButton/addDetailPlaceActionButton API functions, you can now pass "index" and "moreMenu" options to customize the relative position of the button and whether it should be placed in the "more" menu. By default, the button will be placed at the end (after all existing buttons) and outside the "more" menu.
 - [BZ 1527860](https://bugzilla.redhat.com/1527860) <b>[RFE] Q35: change piix3-usb controller (USB1) to qemu-xhci controller (USB3)</b><br>Feature: Adding USB qemu-xhci controller support to SPICE consoles.<br><br>Reason: For Q35 chipset support<br><br>Result: We expect when a Bios type using the Q35 chipset is chosen and usb is enabled that the USB controller shall be qemu-xhci.
 - [BZ 1611889](https://bugzilla.redhat.com/1611889) <b>Switch from ENI to OMP dumps network config to different file and breaks EL6 guests</b><br>Feature: Allow the user to select the cloud init protocol with which to create the network configuration for the VM<br><br>Reason: in odler versions of cloud-init, backward compatibility needs to be maintained with the ENI protocol whereas on newer cloud-init versions the Openstack-Metadata protocol is supported.<br><br>Result: engine now supports selection of the cloud-init protocol to use as part of the cloud-init parameter entry form, while creating a new VM or editing an existing one or starting a VM with Run Once.
 - [BZ 1388098](https://bugzilla.redhat.com/1388098) <b>[RFE] Prevent RHV-M from restarting hosts during large outage</b><br>
 - [BZ 1630243](https://bugzilla.redhat.com/1630243) <b>[RFE] Show live migration progress bar also in virtual machine tab in host page</b><br>During VM live migration, the migration progress bar is shown also in the host page on the virtual machine tab.
 - [BZ 1559694](https://bugzilla.redhat.com/1559694) <b>RFE: warn user if VM does not fit in a single numa node of the host</b><br>If a VM does not use virtual NUMA nodes, it is better if its whole memory can fit into a single NUMA node on the host. Otherwise, there may be some performance overhead.<br><br>There are two additions in this RFE:<br>1. New warning message is shown in the audit log, if a VM is run on a host where its memory cannot fit to a single host NUMA node.<br><br>2. A new policy unit is added to the scheduler, 'Fit VM to single host NUMA node'. When starting a VM, this policy prefers hosts where the VM can fit to a single NUMA node. This unit is not active by default, because it can cause undesired edge cases.<br><br>For example, the policy unit would cause the following behavior when starting multiple VMs.<br>It the following setup:<br>- 9 hosts with 16 GB per NUMA node<br>- 1 host with 4 GB per NUMA node<br><br>When multiple VMs with 6 GB of memory are scheduled, the scheduling unit would prevent them from starting on the host with 4 GB per NUMA node. No matter how overloaded the other hosts are. It would use the last host only when all the others does not have enough free memory to run the VM.
 - [BZ 1009608](https://bugzilla.redhat.com/1009608) <b>[RFE] Limit east-west traffic of VMs with network filter</b><br>Feature: <br><br>Limit east-west traffic of VMs. <br><br>Reason: <br><br>To enable traffic only between VM and gateway. <br><br>Result: <br><br>The new filter 'clean-traffic-gateway' has been added to libvirt. With parameter called 'GATEWAY_MAC' user can specify MAC address of gateway that is allowed to communicate with the VM and vice versa. Please note that user can specify multiple 'GATEWAY_MAC'. <br><br>There are two possible configurations of VM:<br><br>1) VM with static IP<br><br>This is recommended setup. It is also recommended setting of parameter 'CTRL_IP_LEARNING' to 'none', any other value will result in leak of initial traffic. This is caused by libvirt learning mechanism (see https://libvirt.org/formatnwfilter.html#nwfelemsRulesAdvIPAddrDetection and https://bugzilla.redhat.com/show_bug.cgi?id=1647944 for more details).<br><br>2) VM with DHCP<br><br>DHCP is working partially. It is not usable in production currently (https://bugzilla.redhat.com/show_bug.cgi?id=1651499).<br><br><br>The filter has general issue with ARP leak (https://bugzilla.redhat.com/show_bug.cgi?id=1651467). Peer VMs are able to see that the VM using this feature exists (in their arp table), but are not able to contact the VM, as the traffic from peers is still blocked by the filter.
 - [BZ 1454673](https://bugzilla.redhat.com/1454673) <b>[RFE] Changes that require Virtual Machine restart: name</b><br>Feature: <br>When a request to rename a virtual machine arrives, change the name of the virtual machine immediately also when the QEMU process is running and is set with the previous name.<br><br>Reason: <br>Users typically want to see and use the new name a virtual machine is set with even when it is running.<br><br>Result: <br>When renaming a running virtual machine, the new name is applied immediately. In this case, the user is provided with a warning that indicates that the running instance of the virtual machine uses the previous name.
 - [BZ 1553902](https://bugzilla.redhat.com/1553902) <b>[RFE] Update UI plugin API to reflect current UI design</b><br>Starting with oVirt 4.3, the UI plugin API is updated to reflect recent web administration UI design changes.<br><br>In general, there are two types of changes:<br><br>(1) new API functions:<br>- addPrimaryMenuContainer & addSecondaryMenuPlace that allow plugins to add custom secondary menu items to the vertical navigation menu<br><br>(2) renaming of existing API functions:<br>- addMainTab => addPrimaryMenuPlace<br>- addSubTab => addDetailPlace<br>- setTabContentUrl => setPlaceContentUrl<br>- setTabAccessible => setPlaceAccessible<br>- addMainTabActionButton => addMenuPlaceActionButton<br>- addSubTabActionButton => addDetailPlaceActionButton<br><br>The reason for renaming API functions (2) is to stay consistent with current web administration UI design - most notably, the absence of "main" and "sub" tabs.<br><br>All existing API functions are still supported. For API functions that were renamed (2), it's still possible to use the original ones, but doing so will yield a warning in the browser console, for example:<br><br>"addMainTab is deprecated, please use addPrimaryMenuPlace instead."<br><br>Additionally, for functions [addPrimaryMenuPlace, addPrimaryMenuContainer, addSecondaryMenuPlace, addDetailPlace] and their deprecated equivalents, the options object no longer supports alignRight (boolean) parameter. This is because PatternFly tabs widget [1] expects all tabs to be aligned next to each other, flowing from left to right.<br><br>[1] http://www.patternfly.org/pattern-library/widgets/#tabs<br><br>For details, please consult the oVirt UI plugins feature page.
 - [BZ 1518697](https://bugzilla.redhat.com/1518697) <b>engine-setup upgrade of postgres to pg95 env variables not stored to answer file</b><br>engine-setup now uses otopi's new functionality to generate its answer files, which should automatically cover all future added questions without requiring specific code for handling them. The option '--config-append' is compatible with both kinds of files, although the actual behavior will be somewhat different.
 - [BZ 1286219](https://bugzilla.redhat.com/1286219) <b>[RFE] Disk alias of cloned VM should be Alias_<Cloned-VM-Name></b><br>Feature: <br>Change the disk alias of cloned VM.<br><br>Reason:<br>Disk alias of cloned VM should be Alias_<Cloned-VM-Name>. <br><br>Result:<br>After cloning a VM, its disks are named as <br>Alias_<Cloned-VM-Name>.
 - [BZ 1540921](https://bugzilla.redhat.com/1540921) <b>[RFE] Deprecate and remove support for Conroe and Penryn CPUs</b><br>Feature: <br><br>Deprecated Conroe and Penryn CPU Types from Compatibility Version 4.3<br><br>Reason: <br><br>We no longer want to support them.<br><br><br>Result: <br><br>Conroe and Penryn CPU Types no longer appear for Compatibility Version 4.3 and a warning is displayed for older versions.
 - [BZ 968435](https://bugzilla.redhat.com/968435) <b>[RFE] Present in the UI the correlation between virtual disks in a VM and what the VM sees</b><br>
 - [BZ 1530031](https://bugzilla.redhat.com/1530031) <b>[RFE] engine-backup should have defaults for most options</b><br>engine-backup now has defaults for most options, so they do not need to be supplied usually.<br><br>TODO update with the new defaults once we decide what these are.
 - [BZ 1602968](https://bugzilla.redhat.com/1602968) <b>[RFE] Add "power off VM" to the right-click popup menu in the GUI</b><br>Feature: "Power Off VM" was missing from the context menu in the RHV-M administrator portal<br><br>Reason: This was present in previous versions, but removed as part of the new user interface.<br><br>Result: "Power Off VM" is present when a running VM is right-clicked
 - [BZ 1131178](https://bugzilla.redhat.com/1131178) <b>[RFE] Include storage domain UUID in Storage Domain 'General' tab</b><br>
 - [BZ 1570077](https://bugzilla.redhat.com/1570077) <b>[RFE] Add UI plugin API function to allow tab/place resource cleanup</b><br>Feature: After adding custom primary/secondary menu item or details tab via UI plugin API, it's now possible to attach "unload" handler to perform any UI-plugin-specific cleanup once the user navigates away from the given primary/secondary menu item or details tab.<br><br>Reason: Allow UI plugins to attach "unload" handler for each plugin-contributed WebAdmin UI application place, i.e. custom primary/secondary menu item or details tab.<br><br>Result: After adding the custom application place via addPrimaryMenuPlace/addSecondaryMenuPlace/addDetailPlace API functions, you can attach "unload" handler for that place by calling api.setPlaceUnloadHandler(place, handler) function.
 - [BZ 1580346](https://bugzilla.redhat.com/1580346) <b>Cluster properties 'Enable to set host/VM...' should be set by default (and hidden?)</b><br>
 - [BZ 1454389](https://bugzilla.redhat.com/1454389) <b>[RFE] add search query for cluster compatibility level override</b><br>Feature: <br>Added a search query to list all VMs with specific cluster compatibility override.<br><br>Result: <br>The new queries are:<br>- Vms: custom_compatibility_version = X.Y<br>- Vms: custom_compatibility_version != X.Y<br><br>The first lists all VMs with cluster compatibility override to version X.Y and the second lists VMs with different cluster compatibility override version or without any cluster compatibility override set.
 - [BZ 1408584](https://bugzilla.redhat.com/1408584) <b>[RFE] Host cpu type is not found anywhere in REST API</b><br>Feature: Added the CPU Type to the REST API's Host details. <br><br>Reason: The REST API should be consistent with the UI which does display the CPU Type.<br><br>Result: The REST API now returns the CPU Type with the rest of the Host data.
 - [BZ 1561413](https://bugzilla.redhat.com/1561413) <b>[RFE] Remove option should be grayed out for delete protected VMs</b><br>Feature: Since delete-protected VMs cannot be modified, including removal, destructive operations are now disabled.<br><br>Reason: Previously, this button was enabled, but did not perform any operations, leading to an inconsistent user experience.<br><br>Result: "Remove" is now disabled if a VM is delete protected
 - [BZ 1651255](https://bugzilla.redhat.com/1651255) <b>Cannot set number of IO threads via the UI</b><br>Feature: <br>The number of IO threads can be set in the web UI in the new/edit VM dialog.<br><br>Reason: <br>Some users may need to set the number of IO threads and using web UI can be easier than REST API.
 - [BZ 1560132](https://bugzilla.redhat.com/1560132) <b>[RFE] Add finer grained monitoring thresholds for memory consumption on Hypervisors to RHV</b><br>In the Administration Portal, it is possible to set a threshold for cluster level monitoring as a percentage or an absolute value, for example, 95% or 2048 MB. When usage exceeds 95% or free memory falls below 2048 MB, a "high memory usage" or "low memory available" event is logged. This reduces log clutter for clusters with large (1.5 TB) amounts of memory.

#### oVirt Host Dependencies

 - [BZ 1598318](https://bugzilla.redhat.com/1598318) <b>Require SCAP in ovirt-host</b><br>The openscap, openscap-utils and scap-security-guide packages have been added to oVirt Node in order to help hardening the oVirt Node deployments.

#### OTOPI

 - [BZ 1316950](https://bugzilla.redhat.com/1316950) <b>[RFE][CodeChange] - OTOPI should use python3 interpreter on Fedora</b><br>Feature: <br>OTOPI should use python3 interpreter on Fedora<br>Reason: <br><br>Result:

#### oVirt Hosted Engine Setup

 - [BZ 1372134](https://bugzilla.redhat.com/1372134) <b>[RFE] hosted-engine deployment should support IPv6</b><br>Support pure IPv6 deployments
 - [BZ 1529063](https://bugzilla.redhat.com/1529063) <b>[RFE] Allow to deploy HE with an Ansible role.</b><br>Allow the user to deploy HE with a pure ansible role.<br>The user should be able to deploy also on a remote host.
 - [BZ 1209881](https://bugzilla.redhat.com/1209881) <b>[RFE] remove iptables from hosted-engine.spec file to be able to deploy hosted-engine without firewall services installed</b><br>Feature: Remove iptables dependency <br><br>Reason: to be able to deploy hosted-engine without firewall services installed

#### oVirt Engine Data Warehouse

 - [BZ 1614818](https://bugzilla.redhat.com/1614818) <b>[RFE] Upgrade to Software Collections PostgreSQL 10</b><br>Documentation changes are being tracked in BZ1641460

#### oVirt Engine Metrics

 - [BZ 1629437](https://bugzilla.redhat.com/1629437) <b>Update ovirt-engine-metrics playbooks to use the linux-system-roles logging roles</b><br>Feature: <br>As part of replacing Fluentd wih Rsyslog we are basing the Rsyslog deployment on the linux-system-roles logging role, which is a rhel ansible role for deploying Rsyslog configuration files and service handling for multiple projects.<br><br>Reason:<br>This role will be maintained by RHEL and makes the Rsyslog deployment easier and more maintainable. <br><br>Result: <br>Rsyslog service and configurations are deployed on the oVirt engine and hosts during the ovirt metrics deployment.

#### oVirt Release Package

 - [BZ 1598318](https://bugzilla.redhat.com/1598318) <b>Require SCAP in ovirt-host</b><br>The openscap, openscap-utils and scap-security-guide packages have been added to oVirt Node in order to help hardening the oVirt Node deployments.

#### oVirt Windows Guest Tools

 - [BZ 1620569](https://bugzilla.redhat.com/1620569) <b>Include linux qemu-guest-agent on RHV Guest Tools iso for v2v offline conversion</b><br>Qemu Guest Agent packages for several Linux distributions have been added to ease offline installation of the guest agent
 - [BZ 1578775](https://bugzilla.redhat.com/1578775) <b>[RFE] Add qemufwcfg driver in windows guest tools</b><br>The virtio qemufwcfg driver has been added to oVirt Windows Guest Tools for Windows 10 and Windows Server 2016.<br>The driver doesn't provide any functionality but prevents Windows Device Manager to display the device as unrecognized.
 - [BZ 1578782](https://bugzilla.redhat.com/1578782) <b>[RFE] Add smbus driver in windows guest tools</b><br>Feature: virtio-smbus driver installer has been added to RHV Windows Guest Tools<br><br>Reason: When a guest running Windows 2008 with Q35 bios an unknown device is listed in Device Manager being the smbus device unrecognized<br><br>Result: smbus device is now recognized.

#### oVirt Engine Appliance

 - [BZ 1578835](https://bugzilla.redhat.com/1578835) <b>[RFE] Add  ovirt-engine-extension-aaa-ldap-setup and  ovirt-engine-extension-aaa-ldap to RHV-M Image</b><br>Feature: <br>Add engine-extensoin-aaa-ldap to the rhvm image<br><br>Reason: <br>Enable LDAP provider<br><br>Result: <br>engine-extensoin-aaa-ldap is shipped in the rhvm image
 - [BZ 1579000](https://bugzilla.redhat.com/1579000) <b>[RFE] Provide RHV-M Appliance image with LVM partitioning</b><br>

#### oVirt Node NG Image

 - [BZ 1527120](https://bugzilla.redhat.com/1527120) <b>[RFE][CodeChange] split the jenkins job and the gerrit repo if needed for nodectl tool and node-ng iso</b><br>

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1441528](https://bugzilla.redhat.com/1441528) <b>[RFE][Rebase] Rebase ovirt-engine on apache-sshd 2.1.0</b><br>

### Removed functionality

#### VDSM

 - [BZ 1601873](https://bugzilla.redhat.com/1601873) <b>Remove dependency on gluster-gnfs to support Gluster 4.1</b><br>In this release, gluster-gnfs is no longer available with Gluster 4.1. Users who require nfs access for gluster volumes are advised to use nfs-ganesha. Please refer to https://gluster.readthedocs.io/en/latest/Administrator%20Guide/NFS-Ganesha%20GlusterFS%20Integration/

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1399750](https://bugzilla.redhat.com/1399750) <b>[RFE] Make API v3 officially unsupported</b><br>Version 3 of the REST API has been deprecated as of RHV version 4.0. It will not be supported from RHV version 4.3, along with the ovirt-shell and version 3 of the Python SDK Guide, Ruby SDK Guide, and Java SDK Guide.
 - [BZ 1627636](https://bugzilla.redhat.com/1627636) <b>Drop ovirt-engine-cli dependency</b><br>The ovirt-engine-cli package uses the version 3 REST API which is deprecated and unsupported.<br>With this update, ovirt-engine-cli is no longer a dependency and is not installed by default.
 - [BZ 1533086](https://bugzilla.redhat.com/1533086) <b>deprecate and remove disks scan alignment feature</b><br>The "Scan Alignment" feature in the previous versions of the Administration Portal is only relevant to guest OSes that are outdated and unsupported.<br><br>The current release removes this "Scan Alignment" feature, along with historical records of disks being aligned or misaligned.

### Rebase: Bug Fixeses Only

#### oVirt Engine

 - [BZ 1625591](https://bugzilla.redhat.com/1625591) <b>After importing KVM VM, removing the VM and re-importing, the re-importing fails</b><br>Previously, after importing and removing a Kernel-based Virtual Machine (KVM), trying to re-import the same virtual machine fails with an error that the Job ID already exists.<br><br>This update ensures that import jobs are deleted in the VDSM after importing.

### Bug Fixes

#### VDSM

 - [BZ 1593568](https://bugzilla.redhat.com/1593568) <b>Unexpected behaviour of HA VM when host VM was running ended up Non-responsive.</b><br>
 - [BZ 1583038](https://bugzilla.redhat.com/1583038) <b>[HE] Failed to deploy RHV-H on Hosted engine</b><br>
 - [BZ 1617745](https://bugzilla.redhat.com/1617745) <b>startUnderlyingVm fails with exception resulting in split-brain</b><br>
 - [BZ 1575777](https://bugzilla.redhat.com/1575777) <b>RHV import fails if VM has an unreachable floppy defined</b><br>
 - [BZ 1548846](https://bugzilla.redhat.com/1548846) <b>Hot unplug succeeds but warnings are seen in VDSM:  WARN  (libvirt/events) [virt.vm] (vmId='05361b2e-1ae3-40df-a159-cb4688b303c5') Removed device not found in conf: scsi0-0-0-3</b><br>
 - [BZ 1297808](https://bugzilla.redhat.com/1297808) <b>vdsm-4.17.17 fails make distcheck</b><br>
 - [BZ 1589612](https://bugzilla.redhat.com/1589612) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>

#### oVirt Engine

 - [BZ 1663949](https://bugzilla.redhat.com/1663949) <b>Can't check for update on host after upgrade of engine</b><br>
 - [BZ 1626907](https://bugzilla.redhat.com/1626907) <b>Live Snapshot creation on a "not responding" VM will fail during "GetQemuImageInfoVDS"</b><br>
 - [BZ 1619474](https://bugzilla.redhat.com/1619474) <b>Pending change IO thread disable is not applied on shutdown</b><br>
 - [BZ 1660441](https://bugzilla.redhat.com/1660441) <b>rename breaks apache cert</b><br>
 - [BZ 1649685](https://bugzilla.redhat.com/1649685) <b>After increase of ClusterCompatibilityVersion, an additional API-change will persist CustomerCompatibilityVersion to previous ClusterCompatibility Version</b><br>
 - [BZ 1646861](https://bugzilla.redhat.com/1646861) <b>Update gluster volume options set on the volume</b><br>
 - [BZ 1635405](https://bugzilla.redhat.com/1635405) <b>Move Disk dialog keeps spinning - API method works</b><br>
 - [BZ 1640016](https://bugzilla.redhat.com/1640016) <b>UI Uncaught exception on New Cluster flow when choosing DC lower than 4.3 once the CPU type was set</b><br>
 - [BZ 1638124](https://bugzilla.redhat.com/1638124) <b>VM fails to start if maxMemory >= 2048 GB</b><br>
 - [BZ 1632055](https://bugzilla.redhat.com/1632055) <b>PowerSaving keeps VMs on over-utilized hosts while a host is empty and on.</b><br>
 - [BZ 1619866](https://bugzilla.redhat.com/1619866) <b>IO-Threads is enabled inadvertently by editing unrelated configuration</b><br>
 - [BZ 1306659](https://bugzilla.redhat.com/1306659) <b>[CodeChange] - split ovirt-engine-lib package into separated packages for python2 and python3</b><br>
 - [BZ 1594615](https://bugzilla.redhat.com/1594615) <b>Unable to perform upgrade from 4.1 to 4.2 due to selinux related errors.</b><br>
 - [BZ 1598131](https://bugzilla.redhat.com/1598131) <b>OVN network synchronization not working after replacing the RHV-M tls certificate with a commercial one</b><br>
 - [BZ 1640977](https://bugzilla.redhat.com/1640977) <b>RESTAPI listing diskprofiles only shows 1 href for the same QoS even if there are more domains with the same QoS</b><br>
 - [BZ 1496395](https://bugzilla.redhat.com/1496395) <b>[Memory hot unplug] After commit snapshot with memory hot unplug failed since device not found</b><br>
 - [BZ 1520848](https://bugzilla.redhat.com/1520848) <b>Hit Xorg Segmentation fault while installing rhel7.4 release guest in RHV 4.2 with QXL</b><br>
 - [BZ 1650422](https://bugzilla.redhat.com/1650422) <b>"Penalizing host <> because it is not preferred"  logs are shown for VMs even if there are no preferred hosts</b><br>
 - [BZ 1167675](https://bugzilla.redhat.com/1167675) <b>[GUI]>[SetupNetworks]> misleading message about unmanaged/unsynced network</b><br>
 - [BZ 1210717](https://bugzilla.redhat.com/1210717) <b>[RFE] - Show a warning when commiting a previewed snapshot.</b><br>
 - [BZ 1115607](https://bugzilla.redhat.com/1115607) <b>Edit Domain dialogue box fails to resize for over 13 lines on the vertical</b><br>
 - [BZ 1662321](https://bugzilla.redhat.com/1662321) <b>Clone VM from 'Active VM' snapshot shouldn't be allowed via REST API</b><br>
 - [BZ 1656092](https://bugzilla.redhat.com/1656092) <b>Importing OVA via Rest API failed</b><br>
 - [BZ 1583968](https://bugzilla.redhat.com/1583968) <b>Hosted Engine VM is selected for balancing even though the BalanceVM command is not enabled for HE</b><br>
 - [BZ 1643476](https://bugzilla.redhat.com/1643476) <b>Wrong 'maxBandwidth' sent to vdsm on migration</b><br>
 - [BZ 1644636](https://bugzilla.redhat.com/1644636) <b>Engine failed to retrieve images list from ISO domain.</b><br>
 - [BZ 1603020](https://bugzilla.redhat.com/1603020) <b>Indicate that RHV-H hosts have to be rebooted always after upgrade</b><br>
 - [BZ 1595489](https://bugzilla.redhat.com/1595489) <b>Virtual machine lost its cdrom device</b><br>
 - [BZ 1589612](https://bugzilla.redhat.com/1589612) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>
 - [BZ 1069269](https://bugzilla.redhat.com/1069269) <b>Allocation Policy changed by engine to its default from user defined after changing to another storage domain</b><br>

#### oVirt Host Dependencies

 - [BZ 1633975](https://bugzilla.redhat.com/1633975) <b>User cannot login to RHV-H if a security profile is applied during installation</b><br>

#### OTOPI

 - [BZ 1381135](https://bugzilla.redhat.com/1381135) <b>[FC28] otopi fails to detect firewalld if python2-firewall is not available</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1643663](https://bugzilla.redhat.com/1643663) <b>Hosted-Engine VM failed to start mixing ovirt-hosted-engine-setup from 4.1 with ovirt-hosted-engine-ha from 4.2</b><br>
 - [BZ 1636469](https://bugzilla.redhat.com/1636469) <b>Removing a non-HE Host recommends user to undeploy HostedEngine on it first</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1662878](https://bugzilla.redhat.com/1662878) <b>HE deployment fails - Failed executing ansible-playbook in get_network_interfaces</b><br>

#### imgbased

 - [BZ 1655003](https://bugzilla.redhat.com/1655003) <b>Failed to start OpenSSH server daemon</b><br>
 - [BZ 1636028](https://bugzilla.redhat.com/1636028) <b>RHVH enters emergency mode when updated to the latest version and rebooted twice</b><br>
 - [BZ 1645395](https://bugzilla.redhat.com/1645395) <b>Imgbase check FAILED in redhat-virtualization-host-4.3-20181018.0.el7_6</b><br>
 - [BZ 1638606](https://bugzilla.redhat.com/1638606) <b>NTP config is migrated to chrony on every upgrade</b><br>
 - [BZ 1643733](https://bugzilla.redhat.com/1643733) <b>[upgrade] Post upgrade, new options are not available in virt profile</b><br>

#### oVirt Engine Metrics

 - [BZ 1666886](https://bugzilla.redhat.com/1666886) <b>Install fluentd elasticsearch CA certificate task failed for host</b><br>

#### oVirt Node NG Image

 - [BZ 1634239](https://bugzilla.redhat.com/1634239) <b>No SCAP security guide on Anaconda security policy page</b><br>

### Other

#### VDSM

 - [BZ 1655276](https://bugzilla.redhat.com/1655276) <b>[SR-IOV] VFs are not released on hotunplug due to a premature libvirt event</b><br>
 - [BZ 1634765](https://bugzilla.redhat.com/1634765) <b>Guest agent info is not reported with latest vdsm</b><br>
 - [BZ 1645620](https://bugzilla.redhat.com/1645620) <b>vdsm-client has missing dependecy to PyYAML</b><br>
 - [BZ 1631624](https://bugzilla.redhat.com/1631624) <b>Exception on unsetPortMirroring makes vmDestroy fail.</b><br>
 - [BZ 1602047](https://bugzilla.redhat.com/1602047) <b>vdsm-tool upgrade-networks fails with KeyError: 'defaultRoute'</b><br>
 - [BZ 1502083](https://bugzilla.redhat.com/1502083) <b>Live storage migration completes but leaves volume un-opened.</b><br>
 - [BZ 1537148](https://bugzilla.redhat.com/1537148) <b>Guests not responding periodically in Manager</b><br>
 - [BZ 1530724](https://bugzilla.redhat.com/1530724) <b>Vdsm gluster is broken on Fedora 27 because of python-blivet1</b><br>
 - [BZ 1528971](https://bugzilla.redhat.com/1528971) <b>reserve port 54322 for ovirt-imageio-daemon</b><br>
 - [BZ 1511891](https://bugzilla.redhat.com/1511891) <b>qemu-img: slow disk move/clone/import</b><br>
 - [BZ 1560460](https://bugzilla.redhat.com/1560460) <b>getFileStats fails on NFS domain in case or recursive symbolic link (e.g., using NetApp snapshots)</b><br>
 - [BZ 1429286](https://bugzilla.redhat.com/1429286) <b>RAW-Preallocated disk is converted to RAW-sparse while cloning a VM in file based storage domain</b><br>
 - [BZ 1653258](https://bugzilla.redhat.com/1653258) <b>Failed to upload image with "Too many tasks" error and "Worker blocked" exceptions in VDSM</b><br>
 - [BZ 1654991](https://bugzilla.redhat.com/1654991) <b>[UI] - openvswitch version is [N/A] on the software's general host tab</b><br>
 - [BZ 1562602](https://bugzilla.redhat.com/1562602) <b>VM with special characters failed to start</b><br>
 - [BZ 1629065](https://bugzilla.redhat.com/1629065) <b>Enable libvirt dynamic ownership</b><br>
 - [BZ 1615822](https://bugzilla.redhat.com/1615822) <b>[RFE] Report QEMU guest agent in app list</b><br>
 - [BZ 1547960](https://bugzilla.redhat.com/1547960) <b>Use qemu-img measure to estimate image size</b><br>
 - [BZ 1607952](https://bugzilla.redhat.com/1607952) <b>Kdump Status is disabled after successful fencing of host.</b><br>
 - [BZ 1592187](https://bugzilla.redhat.com/1592187) <b>Failed to stop vm with spice + vnc</b><br>
 - [BZ 1471138](https://bugzilla.redhat.com/1471138) <b>Create template from a VM with preallocated file-based disk convert the disk to thin-provisioned allocation policy</b><br>
 - [BZ 1579252](https://bugzilla.redhat.com/1579252) <b>KeyError: 'rx' on VM shutdown</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1667795](https://bugzilla.redhat.com/1667795) <b>Error message "Validation for this host's FQDN failed" deploys in vm settings of Hosted engine Wizard</b><br>

#### oVirt Setup Lib

 - [BZ 1624599](https://bugzilla.redhat.com/1624599) <b>websocket-proxy package setup fails because of missing netaddr package</b><br>

#### oVirt Engine

 - [BZ 1654891](https://bugzilla.redhat.com/1654891) <b>Engine sent duplicate SnapshotVDSCommand, causing data corruption</b><br>
 - [BZ 1655482](https://bugzilla.redhat.com/1655482) <b>[engine-setup] Engine schema refresh failed when upgrading from/through 4.2.5 to 4.3</b><br>
 - [BZ 1641882](https://bugzilla.redhat.com/1641882) <b>Power on on already powered on host sets VMs as down and results in split-brain</b><br>
 - [BZ 1641430](https://bugzilla.redhat.com/1641430) <b>During cold reboot treatment, RunVm did not run for some VMs</b><br>
 - [BZ 1554369](https://bugzilla.redhat.com/1554369) <b>Live Merge failed on engine with "still in volume chain", but merge on host was successful</b><br>
 - [BZ 1527249](https://bugzilla.redhat.com/1527249) <b>[DR] - HA VM with lease will not work, if SPM is down and power management is not available.</b><br>
 - [BZ 1638422](https://bugzilla.redhat.com/1638422) <b>[REST API] Networks link point to 'datacenters' instead of 'networks'</b><br>
 - [BZ 1609839](https://bugzilla.redhat.com/1609839) <b>Foreign key constraint violation on upgrade to 4.2.5</b><br>
 - [BZ 1600573](https://bugzilla.redhat.com/1600573) <b>add AMD EPYC SSBD CPU</b><br>
 - [BZ 1579008](https://bugzilla.redhat.com/1579008) <b>ovirt-engine fails to start when having a large number of stateless snapshots</b><br>
 - [BZ 1574346](https://bugzilla.redhat.com/1574346) <b>Move disk failed but delete was called on source sd, losing all the data</b><br>
 - [BZ 1578357](https://bugzilla.redhat.com/1578357) <b>[SCALE] Listing users in Users tab overloads the postgresql DB (CPU)</b><br>
 - [BZ 1647018](https://bugzilla.redhat.com/1647018) <b>disk_attachment href contains "null" instead of "diskattachments" in REST API requests</b><br>
 - [BZ 1637593](https://bugzilla.redhat.com/1637593) <b>[RFE] cluster upgrade dialog</b><br>
 - [BZ 1647226](https://bugzilla.redhat.com/1647226) <b>Bad SQL Grammar error</b><br>
 - [BZ 1655375](https://bugzilla.redhat.com/1655375) <b>After upgrade to 4.2, admin portal host interface view does not load</b><br>
 - [BZ 1637846](https://bugzilla.redhat.com/1637846) <b>RemoveVmCommand doesn't log the user</b><br>
 - [BZ 1638540](https://bugzilla.redhat.com/1638540) <b>LSM encountered WELD-000049 exception and never issued live merge</b><br>
 - [BZ 1583009](https://bugzilla.redhat.com/1583009) <b>[RFE] Balancing does not produce ideal migrations</b><br>
 - [BZ 1628150](https://bugzilla.redhat.com/1628150) <b>Snapshot deletion fails with "MaxNumOfVmSockets has no value for version"</b><br>
 - [BZ 1635830](https://bugzilla.redhat.com/1635830) <b>Upload disk fail trying to write 0 bytes after the end of the LV</b><br>
 - [BZ 1513398](https://bugzilla.redhat.com/1513398) <b>rhv manager does not show the results of the search properly</b><br>
 - [BZ 1619233](https://bugzilla.redhat.com/1619233) <b>prepareMerge task is stuck when executing a cold merge on illegal image</b><br>
 - [BZ 1612877](https://bugzilla.redhat.com/1612877) <b>engine-setup with python3, returns No module named 'async_tasks_map'</b><br>
 - [BZ 1609011](https://bugzilla.redhat.com/1609011) <b>Creating transient disk during backup operation is failing with error "No such file or directory"</b><br>
 - [BZ 1459502](https://bugzilla.redhat.com/1459502) <b>oVirt can not upgrade JDBC driver due to a postgres-jdbc driver regression issue</b><br>
 - [BZ 1582824](https://bugzilla.redhat.com/1582824) <b>[UI] - VM's network interface name and icon too large and wrap</b><br>
 - [BZ 1574508](https://bugzilla.redhat.com/1574508) <b>Space used icon in RHV-M not showing the actual space</b><br>
 - [BZ 1526032](https://bugzilla.redhat.com/1526032) <b>[RFE] Allow uploading a pre-existing VM template image (OVA) into the environment</b><br>
 - [BZ 1558709](https://bugzilla.redhat.com/1558709) <b>VM remains migrating forever with no Host (actually doesn't exist) after StopVmCommand fails to DestroyVDS</b><br>
 - [BZ 1548205](https://bugzilla.redhat.com/1548205) <b>Very slow UI if Host has many (~64) elements (VFs or dummies or networks)</b><br>
 - [BZ 1565673](https://bugzilla.redhat.com/1565673) <b>ovirt-engine loses track of a cancelled disk</b><br>
 - [BZ 1499056](https://bugzilla.redhat.com/1499056) <b>Unreachable ISO/Export SD prevents hosts from activating</b><br>
 - [BZ 1670146](https://bugzilla.redhat.com/1670146) <b>[CodeChange][i18n] oVirt 4.3 translation cycle 1, part 2</b><br>
 - [BZ 1667295](https://bugzilla.redhat.com/1667295) <b>[CodeChange][i18n] oVirt 4.3 translation cycle 1</b><br>
 - [BZ 1653230](https://bugzilla.redhat.com/1653230) <b>Starting the HA VMs with lease is failing when using ovirt-ansible-disaster-recovery role</b><br>
 - [BZ 1650551](https://bugzilla.redhat.com/1650551) <b>Log out of VM portal only works at the second try</b><br>
 - [BZ 1624069](https://bugzilla.redhat.com/1624069) <b>[RFE] Custom RHV Bond Naming</b><br>
 - [BZ 1535009](https://bugzilla.redhat.com/1535009) <b>[UI] - Provide indication in the ui what is the vdsm name of the logical name</b><br>
 - [BZ 1595067](https://bugzilla.redhat.com/1595067) <b>[RFE] Improve Backup Storage Domain usability</b><br>
 - [BZ 1435636](https://bugzilla.redhat.com/1435636) <b>[RFE] [engine-backend] Running tasks should be listed upon storage domain deactivation</b><br>
 - [BZ 1619154](https://bugzilla.redhat.com/1619154) <b>[RFE] allow to create vm from blank template when datacenter is enforcing quota</b><br>
 - [BZ 1628484](https://bugzilla.redhat.com/1628484) <b>When moving host to maintenance, migrate also manually migrateable VMs</b><br>
 - [BZ 1631392](https://bugzilla.redhat.com/1631392) <b>"New Pool" and "Edit Pool" windows have different labels for "Prestarted VMs"</b><br>
 - [BZ 1635942](https://bugzilla.redhat.com/1635942) <b>Clone VM with Direct LUN fails on UI but succeeds on backend.</b><br>
 - [BZ 1612978](https://bugzilla.redhat.com/1612978) <b>Extending VM disk fails with message "disk was successfully updated to 0 GB"</b><br>
 - [BZ 1576134](https://bugzilla.redhat.com/1576134) <b>Failed to remove host xxxxxxxx</b><br>
 - [BZ 1622068](https://bugzilla.redhat.com/1622068) <b>Network type shows both rt8319 and virtio when import guest from ova on rhv4.2</b><br>
 - [BZ 1613845](https://bugzilla.redhat.com/1613845) <b>[OVN][TUNNEL] Non-existent ovirt network name causes tunnel network revert to ovirtmgmt</b><br>
 - [BZ 1585840](https://bugzilla.redhat.com/1585840) <b>Snapshot tab of a VM doesn't show any snapshots and reports java.lang.NullPointerException: html is null in UI.log</b><br>
 - [BZ 1628909](https://bugzilla.redhat.com/1628909) <b>Engine marks the snapshot status as OK before the actual snapshot operation</b><br>
 - [BZ 1631360](https://bugzilla.redhat.com/1631360) <b>use "Red Hat" manufacturer in SMBIOS for RHV VMs</b><br>
 - [BZ 1583217](https://bugzilla.redhat.com/1583217) <b>engine-backup verify with plain format does not work</b><br>
 - [BZ 1611617](https://bugzilla.redhat.com/1611617) <b>On rollback of failed upgrade from 4.2.1+, engine-setup outputs errors about the uuid-ossp extension</b><br>
 - [BZ 1539576](https://bugzilla.redhat.com/1539576) <b>ovn localnet - Engine should schedule VMs only on hosts where phys_net is attached</b><br>
 - [BZ 1535603](https://bugzilla.redhat.com/1535603) <b>Importing a template will fail with error "Template's image doesn't exist" if the template disk was copied from another storage domain</b><br>
 - [BZ 1597062](https://bugzilla.redhat.com/1597062) <b>setupNetworks holding vds lock for too long</b><br>
 - [BZ 1542328](https://bugzilla.redhat.com/1542328) <b>[de_DE,es_ES,fr_FR] String "Optimize for Virt Store" misaligned with check box on storage > volumes > new window</b><br>
 - [BZ 1542014](https://bugzilla.redhat.com/1542014) <b>[ALL_LANG] Text alignment correction needed on compute > virtual machine > guide me > attach virtual disk window</b><br>
 - [BZ 1593579](https://bugzilla.redhat.com/1593579) <b>all engine utilities should return 0 on printing help</b><br>
 - [BZ 1487657](https://bugzilla.redhat.com/1487657) <b>click on row doesn't select DC in attaching storage dialog</b><br>
 - [BZ 1580128](https://bugzilla.redhat.com/1580128) <b>[RFE] Need a way to track how many logical volumes consumed in a storage domain and alert when it gets full</b><br>The storage domain's general subtab in the Webadmin now shows the number of images on the storage domain under the rubric "Images", this corresponds to the number of LVs on a block domain
 - [BZ 1497355](https://bugzilla.redhat.com/1497355) <b>Live Storage Migration continued on after snapshot creation hung and timed out</b><br>
 - [BZ 1571247](https://bugzilla.redhat.com/1571247) <b>engine-backup creates backup file with too permissive mode</b><br>
 - [BZ 1545270](https://bugzilla.redhat.com/1545270) <b>[RFE] virtio nics are reported as '1gbit' nics, and should be '10gbit'</b><br>
 - [BZ 1550987](https://bugzilla.redhat.com/1550987) <b>link for cluster's networkfilters returns 404</b><br>
 - [BZ 1566060](https://bugzilla.redhat.com/1566060) <b>[UI] - VM > Start Running On host > Specific host field is disabled if pressing next to the 'Any Host In Cluster radio button</b><br>
 - [BZ 1520455](https://bugzilla.redhat.com/1520455) <b>The VM name resets to original value when switching tab in 'import virtual machine' dialog</b><br>
 - [BZ 1358295](https://bugzilla.redhat.com/1358295) <b>[i18n][ALL_LANG] wrong translation of error message canceling operation</b><br>
 - [BZ 1511522](https://bugzilla.redhat.com/1511522) <b>ImportVmFromConfiguration fails with NullPointerException after domain import between 4.1 and 4.2 env</b><br>
 - [BZ 1517245](https://bugzilla.redhat.com/1517245) <b>[ALL_LANG] Truncated column names appear on volumes -> bricks -> advanced details -> memory pools page</b><br>
 - [BZ 1369407](https://bugzilla.redhat.com/1369407) <b>NPE while trying to remove user</b><br>
 - [BZ 1656901](https://bugzilla.redhat.com/1656901) <b>Webadmin - select storage domain Disks tab window - Virtual size column can not be sorted</b><br>
 - [BZ 1537611](https://bugzilla.redhat.com/1537611) <b>Missing required check box highlighted in black when other missing fiels are highlighted in red</b><br>
 - [BZ 1636967](https://bugzilla.redhat.com/1636967) <b>Host-Upgrade dialog should be same</b><br>
 - [BZ 1503031](https://bugzilla.redhat.com/1503031) <b>Response body of file based storage domain creation due to dirty path does not have an indication of which domain resides on that path</b><br>
 - [BZ 1351157](https://bugzilla.redhat.com/1351157) <b>[RFE] [UI] - disable 'Save Network Configuration' checkbox from setup networks ui dialog</b><br>To improve dependability of setting up networks, saving the configuration will always be carried out upon completion of the setup. Therefore the checkbox is left intact to indicate to the user that saving is being done, but it is disabled and always selected.
 - [BZ 1640911](https://bugzilla.redhat.com/1640911) <b>wrong message when getting storages for non active host</b><br>
 - [BZ 1403653](https://bugzilla.redhat.com/1403653) <b>[RFE] Should accept any bond name starting with bond</b><br>
 - [BZ 1636256](https://bugzilla.redhat.com/1636256) <b>[RFE] - limit the number of simultaneous logon sessions per user on RHVM</b><br>
 - [BZ 1472161](https://bugzilla.redhat.com/1472161) <b>[RFE] add hover text with name on disk/storage in move/copy dialog form</b><br>
 - [BZ 1601208](https://bugzilla.redhat.com/1601208) <b>[UI] - Setup Host Networks - Scrolling isn't working properly if the NIC's tooltip is too long(off screen)</b><br>
 - [BZ 1636768](https://bugzilla.redhat.com/1636768) <b>[UI] - VM - Network Interfaces sub tab - Add <Empty> or [N/A] to the General  info for an empty vNIC profile</b><br>
 - [BZ 1636767](https://bugzilla.redhat.com/1636767) <b>[UI] - VM - Snapshots sub tab - Network Interfaces - Align (Mbps)/(Pkts) to the text</b><br>
 - [BZ 1609843](https://bugzilla.redhat.com/1609843) <b>[UI] Infiniband information not displaying correctly for hosts</b><br>
 - [BZ 1505402](https://bugzilla.redhat.com/1505402) <b>[CodeChange] - Remove SupportBridgesReportByVDSM related code</b><br>
 - [BZ 1609658](https://bugzilla.redhat.com/1609658) <b>[UI] - Edit External networks  - All external networks are set as connected to physical network</b><br>
 - [BZ 1538642](https://bugzilla.redhat.com/1538642) <b>[UI] - Adjust bond's icon and bad bond warning icon to the new NIC icon size</b><br>
 - [BZ 1537415](https://bugzilla.redhat.com/1537415) <b>engine complains about serving files > 1M</b><br>
 - [BZ 1552548](https://bugzilla.redhat.com/1552548) <b>Webadmin- trying to extend a disk with MaxBlockDiskSize (8192G) with a value of '0'   wrong error appears ' Cannot create disk more than ${max}_disk_size GB'</b><br>
 - [BZ 1543440](https://bugzilla.redhat.com/1543440) <b>CreateImageTemplateCommand failure needs to be be indicated with clearer message in GUI</b><br>
 - [BZ 1516473](https://bugzilla.redhat.com/1516473) <b>Don't display required networks in the iSCSI Bonding dialogs</b><br>
 - [BZ 1527817](https://bugzilla.redhat.com/1527817) <b>[UI] - Label list doesn't close after selection</b><br>
 - [BZ 1527101](https://bugzilla.redhat.com/1527101) <b>[UI] Network plugin list control under external network provider does not close after selection</b><br>
 - [BZ 1588634](https://bugzilla.redhat.com/1588634) <b>Hosts: UI exception is thrown when trying to open New Host dialog before hosts table is loaded</b><br>
 - [BZ 1431182](https://bugzilla.redhat.com/1431182) <b>engine-backup accepts same filename for backup archive and backup log</b><br>
 - [BZ 1446907](https://bugzilla.redhat.com/1446907) <b>[RFE] - link to engine's certificate on upload image network error event should display the actual engine url instead of <engine_url></b><br>
 - [BZ 1576862](https://bugzilla.redhat.com/1576862) <b>Uploaded image: Virtual Size of qcow2 image is not reflected at guest OS level</b><br>
 - [BZ 1563580](https://bugzilla.redhat.com/1563580) <b>Missing whitespace in 'Current kernel CMD line'</b><br>
 - [BZ 1536397](https://bugzilla.redhat.com/1536397) <b>CloudInit: DNS search parameter is passed incorrectly</b><br>
 - [BZ 1558539](https://bugzilla.redhat.com/1558539) <b>activating a tag takes too long, shows tall empty VM grid</b><br>
 - [BZ 1537411](https://bugzilla.redhat.com/1537411) <b>SEVERE: Warning: You're using an untyped slot!</b><br>
 - [BZ 1537095](https://bugzilla.redhat.com/1537095) <b>[DNS] multi-host SetupNetworks command is not sent when a DNS entry is removed from network</b><br>
 - [BZ 1570040](https://bugzilla.redhat.com/1570040) <b>[RFE] RH Single Sign-On or OpenID Connect integration with Administration/User Portal</b><br>
 - [BZ 1665922](https://bugzilla.redhat.com/1665922) <b>[CinderLib] - RESTAPI- Detaching managed storage fails with Internal Server Error - ERROR [io.undertow.request] (default task-62) UT005023: Exception handling request spi.UnhandledException: java.lang.NullPointerException</b><br>
 - [BZ 1664748](https://bugzilla.redhat.com/1664748) <b>[CinderLib] - remove and format managed storage via webadmin fails -  Failed to FormatStorageDomainVDS, error = Storage domain does not exist</b><br>
 - [BZ 1659026](https://bugzilla.redhat.com/1659026) <b>Drop requirement on sonatype-oss-parent</b><br>
 - [BZ 1656881](https://bugzilla.redhat.com/1656881) <b>Security scanner detects "Unvalidated Redirects and Forwards (spider-param-unchecked-redirect)" vulnerability in RHVM 4.2</b><br>
 - [BZ 1650574](https://bugzilla.redhat.com/1650574) <b>default graphics console SPICE+VNC for new VMs</b><br>
 - [BZ 1660062](https://bugzilla.redhat.com/1660062) <b>Rest-API: Link to disk-attachments under storage-domain contains 'null'</b><br>
 - [BZ 1641048](https://bugzilla.redhat.com/1641048) <b>Engine raises 'insufficient permissions' error when normal user try to access /datacenters?follow=storage_domains</b><br>
 - [BZ 1633777](https://bugzilla.redhat.com/1633777) <b>VM cloned from template remains locked, subsequent clones fail</b><br>
 - [BZ 1660378](https://bugzilla.redhat.com/1660378) <b>[RFE] Use sha256 for uninstall information in engine-setup, engine-cleanup etc.</b><br>
 - [BZ 1641703](https://bugzilla.redhat.com/1641703) <b>Importing VM template fails with ERROR: insert or update on table "vm_static" violates foreign key constraint "fk_vm_static_lease_sd_i d_storage_domain_static_id"</b><br>
 - [BZ 1646956](https://bugzilla.redhat.com/1646956) <b>Empty string on ovirtmgmt's label instead of null as should be</b><br>
 - [BZ 1481197](https://bugzilla.redhat.com/1481197) <b>Fencing default parameters for PPC PM requires administrator access</b><br>
 - [BZ 1647728](https://bugzilla.redhat.com/1647728) <b>[RFE] - Provide a tool for easier colletion of the engine thread dumps</b><br>
 - [BZ 1647912](https://bugzilla.redhat.com/1647912) <b>Using 'setupnetworks' restapi call to update an existing network attachment does not work</b><br>
 - [BZ 1639604](https://bugzilla.redhat.com/1639604) <b>engine fails to imports external VMs</b><br>Cause: A change in internal data structures related to virtual machines caused improperly initialized objects to contain empty lists.<br><br>Consequence: External VMs, specially vintage deployments of Hosted Engine, sometimes failed to import, with looping log messages about attempted imports.<br><br>Fix: Disk attachments from imported libvirt XML are now appropriately initialized.<br><br>Result: External VMs can be imported
 - [BZ 1624857](https://bugzilla.redhat.com/1624857) <b>[RFE] Snapshot memory and metadata disks names are not distinguishable</b><br>
 - [BZ 1643813](https://bugzilla.redhat.com/1643813) <b>Managing tags fails with ConcurrentModificationException</b><br>
 - [BZ 1645383](https://bugzilla.redhat.com/1645383) <b>GetAllVmStatsVDSCommand sent host to Not-Responding status after upgrade</b><br>
 - [BZ 1506547](https://bugzilla.redhat.com/1506547) <b>Provisioning discovered host from oVirt via Foreman doesn't work</b><br>
 - [BZ 1562602](https://bugzilla.redhat.com/1562602) <b>VM with special characters failed to start</b><br>
 - [BZ 1643921](https://bugzilla.redhat.com/1643921) <b>Incorrect behavior of IOThreads text box in edit VM dialog</b><br>
 - [BZ 1618984](https://bugzilla.redhat.com/1618984) <b>Host deploy from fc28 engine on fc28 host fails, ssh connection terminated</b><br>
 - [BZ 1648417](https://bugzilla.redhat.com/1648417) <b>Command entities left in ACTIVE state after HostUpgradeCheckCommand</b><br>
 - [BZ 1645007](https://bugzilla.redhat.com/1645007) <b>Foreman response is limited to 20 entries per call</b><br>
 - [BZ 1591801](https://bugzilla.redhat.com/1591801) <b>uutils.ssh.OpenSSHUtils - the key algorithm 'EC' is not supported on Fedora 28</b><br>
 - [BZ 1645890](https://bugzilla.redhat.com/1645890) <b>[REST] vnicprofiles point to "networks/[NET-ID]/vnicprofiles/" instead of: "/vnicprofiles/[VNIC-PROFILE-ID]"</b><br>
 - [BZ 1530616](https://bugzilla.redhat.com/1530616) <b>create new pool doesn't close dialog until all VMs are created</b><br>
 - [BZ 1643826](https://bugzilla.redhat.com/1643826) <b>Updating template of VM Pool leaves tasks stuck after VMs shutdown</b><br>
 - [BZ 1637815](https://bugzilla.redhat.com/1637815) <b>engine-vacuum fails with 'vacuumdb: command not found'</b><br>
 - [BZ 1599732](https://bugzilla.redhat.com/1599732) <b>Failed to start VM with LibVirtError "Failed to acquire lock: No space left on device"</b><br>
 - [BZ 1633645](https://bugzilla.redhat.com/1633645) <b>Old 'Intel Haswell Family-IBRS' cluster CPU type not renamed during the upgrade</b><br>
 - [BZ 1624219](https://bugzilla.redhat.com/1624219) <b>Pool does not appear for user in group until refresh</b><br>
 - [BZ 1633310](https://bugzilla.redhat.com/1633310) <b>Entries for snapshot creations in the command_entities table in the database prevented access to the Admin Portal</b><br>
 - [BZ 1609718](https://bugzilla.redhat.com/1609718) <b>allow search for memory guaranteed</b><br>
 - [BZ 1631249](https://bugzilla.redhat.com/1631249) <b>Make sure RHV Manager will use OpenJDK 8 even when newer versions are available</b><br>
 - [BZ 1591828](https://bugzilla.redhat.com/1591828) <b>Stop bundling nimbus-jose-jwt 4.13.1, rebase on latest 5.12.</b><br>
 - [BZ 1615287](https://bugzilla.redhat.com/1615287) <b>Allow to create VM template with preallocated file-based disk via the UI</b><br>
 - [BZ 1512901](https://bugzilla.redhat.com/1512901) <b>[CodeChange] Refactor DeactivateStorageDomainWithOvfUpdateCommand to use CoCo framework and steps</b><br>
 - [BZ 1620916](https://bugzilla.redhat.com/1620916) <b>Starting engine service on fc28 with python3 fails on Cannot detect JBoss version</b><br>
 - [BZ 1615423](https://bugzilla.redhat.com/1615423) <b>Require python3 packages in fedora</b><br>
 - [BZ 1608291](https://bugzilla.redhat.com/1608291) <b>[RFE] Should be able to change the Port number of NoVnc</b><br>
 - [BZ 1612931](https://bugzilla.redhat.com/1612931) <b>[CodeChange] switch to using libpwquality instead of cracklib</b><br>
 - [BZ 1374323](https://bugzilla.redhat.com/1374323) <b>Disk attachments of a VM from an export domain does not contain links</b><br>
 - [BZ 1609552](https://bugzilla.redhat.com/1609552) <b>[UI] Disk storage domain drop down list appeared to be in the wrong place in 'create VM from template' dialog window</b><br>
 - [BZ 1554922](https://bugzilla.redhat.com/1554922) <b>Failures creating a storage domain via ansible module/REST API doesn't report a meaningful error message</b><br>
 - [BZ 1598372](https://bugzilla.redhat.com/1598372) <b>Error message "Failed to plug disk X to VM Y" when running HA VM with disk right after its (VM) creation</b><br>
 - [BZ 1603195](https://bugzilla.redhat.com/1603195) <b>On 'Copy Disk' popup, the source storage domain appears twice, so the 'Disk Profile' column was pushed to another line</b><br>
 - [BZ 1536813](https://bugzilla.redhat.com/1536813) <b>iSCSI targets view is not refreshed upon DC field change in new direct LUN prompt</b><br>
 - [BZ 1598594](https://bugzilla.redhat.com/1598594) <b>Live merge fails on the RHV-M Engine with "Invalid UUID string: payload" followed by exception.</b><br>
 - [BZ 1586126](https://bugzilla.redhat.com/1586126) <b>After upgrade to RHV 4.2.3, hosts can no longer be set into maintenance mode.</b><br>
 - [BZ 1539755](https://bugzilla.redhat.com/1539755) <b>Domain name is cut in Move disk Window</b><br>
 - [BZ 1568265](https://bugzilla.redhat.com/1568265) <b>Skipped power management operation has misleading logs</b><br>
 - [BZ 1587961](https://bugzilla.redhat.com/1587961) <b>Can't extend storage domain (iSCSI)</b><br>
 - [BZ 1594552](https://bugzilla.redhat.com/1594552) <b>Can't extend iSCSI SD with an additional LUN</b><br>
 - [BZ 1588738](https://bugzilla.redhat.com/1588738) <b>JsonMappingException in businessentities.storage.DiskImage prevents access to Engine</b><br>
 - [BZ 1588589](https://bugzilla.redhat.com/1588589) <b>Allow to ignore the Postgres config auto-fixing</b><br>
 - [BZ 1486968](https://bugzilla.redhat.com/1486968) <b>misleading message for ￼Shareable disk parameter</b><br>
 - [BZ 1487939](https://bugzilla.redhat.com/1487939) <b>Hyper converge - Gluster does no support shared disks but are displayed as option when creating a shared disk</b><br>
 - [BZ 1586023](https://bugzilla.redhat.com/1586023) <b>Guarenteed space differing under storage domains in the RHV-M</b><br>
 - [BZ 1588461](https://bugzilla.redhat.com/1588461) <b>[backup-api] Amend of snapshot disk that attached to a backup VM  failed when updating the snapshot disk</b><br>
 - [BZ 1570486](https://bugzilla.redhat.com/1570486) <b>Creating VM template from snapshot is available only via the UI</b><br>
 - [BZ 1581503](https://bugzilla.redhat.com/1581503) <b>ovirt-engine won't start on Fedora 28, PostgreSQL JDBC drivers >= 42.2.2 are required to use PostgreSQL 10</b><br>
 - [BZ 1517286](https://bugzilla.redhat.com/1517286) <b>[RFE] Skylake-server and AMD EPYC support</b><br>Skylake-server and AMD EPYC processor families are now supported for virtualization
 - [BZ 1579366](https://bugzilla.redhat.com/1579366) <b>Can't Custom  Preview VM snapshot with lease when Un-checking the lease when the Domain is in maintenance</b><br>
 - [BZ 1577811](https://bugzilla.redhat.com/1577811) <b>NPE on various VM operations (update/power-off etc)</b><br>
 - [BZ 1573421](https://bugzilla.redhat.com/1573421) <b>An exception is thrown when creating a template from snapshot with less disks then the active VM</b><br>
 - [BZ 1471138](https://bugzilla.redhat.com/1471138) <b>Create template from a VM with preallocated file-based disk convert the disk to thin-provisioned allocation policy</b><br>
 - [BZ 1561052](https://bugzilla.redhat.com/1561052) <b>The Active VM snapshots table entry does not exist for a specific VM</b><br>
 - [BZ 1563114](https://bugzilla.redhat.com/1563114) <b>VM snapshots subtab doesn't show if a snapshot contains memory</b><br>
 - [BZ 1545153](https://bugzilla.redhat.com/1545153) <b>No Storage Domain error while restoring a snapshot</b><br>
 - [BZ 1544229](https://bugzilla.redhat.com/1544229) <b>Exception in UI when editing a VM (without changing anything) @ org.ovirt.engine.ui.common.widget.uicommon.storage.DisksAllocationView_DriverImpl.getEventMap(DisksAllocationView_DriverImpl.java:20)</b><br>
 - [BZ 1452361](https://bugzilla.redhat.com/1452361) <b>VM import is possible to clusters where permissions to create VMs are not granted</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1526032](https://bugzilla.redhat.com/1526032) <b>[RFE] Allow uploading a pre-existing VM template image (OVA) into the environment</b><br>
 - [BZ 1622043](https://bugzilla.redhat.com/1622043) <b>ovirt-engine-sdk-python use python 3.7 reserved words</b><br>

#### oVirt Host Dependencies

 - [BZ 1598085](https://bugzilla.redhat.com/1598085) <b>ovirt-host depends on postfix when it just wants a MTA</b><br>
 - [BZ 1573186](https://bugzilla.redhat.com/1573186) <b>add cockpit-machines-ovirt to RHVH hosts</b><br>

#### OTOPI

 - [BZ 1590723](https://bugzilla.redhat.com/1590723) <b>Running otopi on fedora fails on missing cli object</b><br>
 - [BZ 1365749](https://bugzilla.redhat.com/1365749) <b>[Fedora][CodeChange] otopi uses obsolete python module 'imp'</b><br>
 - [BZ 1542529](https://bugzilla.redhat.com/1542529) <b>dnf plugin is broken</b><br>

#### oVirt Host Deploy

 - [BZ 1588068](https://bugzilla.redhat.com/1588068) <b>[CodeChange][RFE] - Package ovirt-host-deploy for python3 compatibility on Fedora</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1579103](https://bugzilla.redhat.com/1579103) <b>RHV-H 4.2.3: hosted-engine agent fails to start after upgrade due to Permission denied: '/var/log/ovirt-hosted-engine-ha/broker.log' '/var/log/ovirt-hosted-engine-ha/agent.log'</b><br>
 - [BZ 1569593](https://bugzilla.redhat.com/1569593) <b>ERROR failed to retrieve Hosted Engine HA score '[Errno 2] No such file or directory' Is the Hosted Engine setup finished?</b><br>
 - [BZ 1639997](https://bugzilla.redhat.com/1639997) <b>Agent fails to start with error "Failed to start monitor ping"</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1665467](https://bugzilla.redhat.com/1665467) <b>Support host_name != host_address</b><br>
 - [BZ 1662582](https://bugzilla.redhat.com/1662582) <b>Missing colon in the user dialog at the hosted-engine setup via CLI</b><br>
 - [BZ 1665419](https://bugzilla.redhat.com/1665419) <b>Hosted engine wizard displays "System data could not be retrieved!" is eth0 is not available on the host</b><br>
 - [BZ 1643934](https://bugzilla.redhat.com/1643934) <b>Emit a warning before running vdsm-tool restore-nets</b><br>

#### oVirt Log Collector

 - [BZ 1360621](https://bugzilla.redhat.com/1360621) <b>log-collector should collect detailed yum/dnf history</b><br>
 - [BZ 1555449](https://bugzilla.redhat.com/1555449) <b>[RFE] Reduce Archive Size by using filters message via flags unclear</b><br>
 - [BZ 1614304](https://bugzilla.redhat.com/1614304) <b>spec: require the python2/3-ovirt-engine-lib instead of ovirt-engine-lib</b><br>

#### oVirt Engine UI Extensions

 - [BZ 1637593](https://bugzilla.redhat.com/1637593) <b>[RFE] cluster upgrade dialog</b><br>

#### imgbased

 - [BZ 1501236](https://bugzilla.redhat.com/1501236) <b>Grub2-prode failed to find the disk on LVM</b><br>

#### oVirt Engine Data Warehouse

 - [BZ 1639006](https://bugzilla.redhat.com/1639006) <b>[CodeChange] - DWH setup should support python 3</b><br>
 - [BZ 1546486](https://bugzilla.redhat.com/1546486) <b>(Fedora 27) Talend is not working properly with dom4j - 2.0.0</b><br>
 - [BZ 1507037](https://bugzilla.redhat.com/1507037) <b>Race condition on starting DWH on fresh install.</b><br>

#### oVirt Engine Metrics

 - [BZ 1667406](https://bugzilla.redhat.com/1667406) <b>Message of ovirt-engine-metrics about requiring a non existent collectd plugin during host-deploy is confusing</b><br>
 - [BZ 1664269](https://bugzilla.redhat.com/1664269) <b>[RFE] Add README to the oVirt.logging role and parameterise the omelasticsearch variables</b><br>
 - [BZ 1651588](https://bugzilla.redhat.com/1651588) <b>Update oVirt metrics so that host deploy will not fail due to missing Fluentd package</b><br>

#### ovirt-engine-extension-aaa-misc

 - [BZ 1570040](https://bugzilla.redhat.com/1570040) <b>[RFE] RH Single Sign-On or OpenID Connect integration with Administration/User Portal</b><br>

#### oVirt Release Package

 - [BZ 1661791](https://bugzilla.redhat.com/1661791) <b>[release package] Yum install of glusterfs failed because of broken repo link</b><br>
 - [BZ 1645159](https://bugzilla.redhat.com/1645159) <b>change master dependencies for ovirt-web-ui rpm</b><br>
 - [BZ 1544481](https://bugzilla.redhat.com/1544481) <b>Provide missing dependencies for Fedora 28</b><br>

#### oVirt Engine Appliance

 - [BZ 1654727](https://bugzilla.redhat.com/1654727) <b>Engine Appliance image (OVA) should be arch specific, not noarch</b><br>

#### oVirt Ansible infrastructure role

 - [BZ 1638380](https://bugzilla.redhat.com/1638380) <b>Document that ovirt.infra role needs to be executed on engine host if you want to add/modify users/groups with it</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1643512](https://bugzilla.redhat.com/1643512) <b>No exclamation icon when bond with an LACP is misconfigured</b><br>
 - [BZ 1591751](https://bugzilla.redhat.com/1591751) <b>Recreate engine_cache dir during start and host deployment flows</b><br>
 - [BZ 1589270](https://bugzilla.redhat.com/1589270) <b>ovirt-engine-setup-plugin-ovirt-engine %pre fails on Fedora 28</b><br>
 - [BZ 1553425](https://bugzilla.redhat.com/1553425) <b>Number of "Prestarted VMs" is ignored and all VMs of Pool starts after editing existing Pool.</b><br>
 - [BZ 1646375](https://bugzilla.redhat.com/1646375) <b>[Rest API] GET request ovirt-engine/api/instancetypes/[ID]/graphicsconsoles results with null</b><br>
 - [BZ 1636981](https://bugzilla.redhat.com/1636981) <b>[RFE] provide a sorted list of available boot-iso in "run once" dialog for virtual machines</b><br>
 - [BZ 1533389](https://bugzilla.redhat.com/1533389) <b>[UI] - 'Manage Networks' dialog - Fix minor issue with the radio buttons and headers focus</b><br>
 - [BZ 1354427](https://bugzilla.redhat.com/1354427) <b>[es, fr, pt] login form fields get truncated</b><br>
 - [BZ 1641954](https://bugzilla.redhat.com/1641954) <b>engine python files are not compiled in fc28</b><br>
 - [BZ 1568447](https://bugzilla.redhat.com/1568447) <b>Moving StorageDomain to Maintenance releases lock twice</b><br>

#### oVirt ISO Uploader

 - [BZ 1627200](https://bugzilla.redhat.com/1627200) <b>Fix ovirt-iso-uploader for python 3 compatibility</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1662632](https://bugzilla.redhat.com/1662632) <b>Missing the option to install hosted-engine without requirements check</b><br>

#### Contributors

112 people contributed to this release:

	Ahmad Khiet
	Ala Hino
	Ales Musil
	Alexander Wels
	Allon Mureinik
	Alona Kaplan
	Andrej Krejčír
	Anton Marchukov
	Arano-kai
	Ariel O. Barria
	Arik Hadas
	Asaf Rachmani
	Bell Levin
	Benjamin Merot
	Benny Zlotnik
	Bimal Chollera
	Bohdan Iakymets
	Christophe Fergeau
	Dafna Ron
	Dan Kenigsberg
	Dana Elfassy
	Daniel Belenky
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Douglas Schilling Landgraf
	Edward Haas
	Eitan Raviv
	Emil Natan
	Eyal Edri
	Eyal Shenitzky
	Francesco Romani
	Fred Rolland
	Germano Veit Michel
	Gobinda
	Greg Sheremeta
	Idan Shaby
	Ido Rosenzwig
	Jakub Niedermertl
	Javier Coscia
	Juan Hernandez
	Kaustav Majumder
	Kobi Hakimi
	Kyle Stapp
	Leon Goldberg
	Lev Veyde
	Malike
	Maor Lipchuk
	Marcin Mirecki
	Marcin Sobczyk
	Marek Libra
	Martin Perina
	Martin Polednik
	Martin Sivak
	Michal Skrivanek
	Miguel Duarte Barroso
	Miguel Martin
	Miguel R. Caudevilla
	Milan Zamazal
	Moti Asayag
	Mykhailo Kozlovskyy
	Nijin Ashok
	Nir Soffer
	Olimp Bockowski
	Ondra Machacek
	Ori Liel
	Petr Balogh
	Petr Horáček
	Petr Kotas
	Phillip Bailey
	Piotr Kliczewski
	Ravi Nori
	Rohan CJ
	Roman Hodain
	Roy Golan
	Ryan Barry
	Sahina Bose
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Shmuel Leib Melamud
	Shmuel Melamud
	Simone Tiraboschi
	Steven Rosenberg
	Sveta Haas
	Tal Nisan
	Tomas Jelinek
	Tomasz Baranski
	Tomasz Barański
	Tomáš Golembiovský
	Uri Lublin
	Viktor Mihajlovski
	Vishnu Sampath Kunda
	Vojtech Juranek
	Vojtech Szocs
	Yanir Quinn
	Yaniv Bronhaim
	Yaniv Kaul
	Yedidyah Bar David
	Yuval Turgeman
	bond95
	emesika
	fdupont-redhat
	godas
	gzaidman
	imjoey
	ocasek
	parthdhanjal
	vishnusampath
