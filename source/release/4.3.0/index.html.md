---
title: oVirt 4.3.0 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.0 Alpha release as of November 26, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.0, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL



## ALPHA RELEASE

In order to install this Alplha Release you will need to enable pre-release repository.



In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### Fedora Tech Preview

With oVirt 4.3 we are reintroducing Fedora 28 as platform for running oVirt in tech preview.
More recent builds for Fedora are built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
For some of the work to be done to completely restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.3.0?

### Release Note

#### oVirt Engine

 - [BZ 1599321](https://bugzilla.redhat.com/1599321) <b>Config values inconsistency between RHV versions</b><br>There are inconsistencies in the following internal configuration options:<br>- HotPlugCpuSupported<br>- HotUnplugCpuSupported<br>- HotPlugMemorySupported<br>- HotUnplugMemorySupported<br>- IsMigrationSupported<br>- IsMemorySnapshotSupported<br>- IsSuspendSupported<br>- ClusterRequiredRngSourcesDefault<br>Systems that have upgraded from RHV 4.0 to RHV 4.1/4.2 and are experiencing problems with these features should upgrade to RHV 4.2.5 or later.

#### oVirt Release Package

 - [BZ 1609884](https://bugzilla.redhat.com/1609884) <b>ovirt-release-master for centos doesn't contain current ovirt-web-ui</b><br>oVirt Release package for master is now enabling a new repository hosted on COPR service for delivering ovirt-web-ui packages.

### Enhancements

#### VDSM

 - [BZ 1598391](https://bugzilla.redhat.com/1598391) <b>[RFE] - Certify OSP 14 with OVN as an external network provider on RHV 4.3</b><br>
 - [BZ 1587892](https://bugzilla.redhat.com/1587892) <b>After importing KVM VM the actual size is bigger than the virtual size</b><br>Feature: <br><br>Added KVM Sparseness support to KVM to oVirt Virtual Machine Importing so that when Thin Provisioning is enabled, the Disk Size of the original KVM Image will be preserved after importing to oVirt.   <br><br>Reason: <br><br>Unless the user specifically specifies pre-allocation, the Disk Size of the Virtual Machine should be no larger than required during initial allocation of Disk Space when the VM is running. Previously when choosing Thin Provisioning for KVM to oVirt Importing, the Disk Size of the VM within the Storage Domain of oVirt was inflated to the Volume Size or Larger when the original KVM VM was much smaller.  <br><br>Result: <br><br>Now when Importing Virtual Machines from KVM to oVirt with Thin Provisioning selected, the original Disk Size of the VM is preserved.
 - [BZ 1510856](https://bugzilla.redhat.com/1510856) <b>[RFE] Time sync in VM after resuming from PAUSE state</b><br>Feature: <br><br>Added optional Guest Time Synchronization to the snapshot functionality via the time_sync_snapshot_enable option and other un-pausing scenarios via the time_sync_cont_enable option for synchronizing and correcting the time on the VM after long pauses. The defaults for the option are turned off for backward compatibility.<br><br>Reason: <br><br>This becomes especially critical when there are heavy loads on the VM to ensure time stamps for example are accurate.<br><br>Result: <br><br>When the options are enabled, the VDSM shall attempt to synchronize the time either during pauses that occur via during snapshots and/or during other un-pausing functionality.

#### oVirt Engine

 - [BZ 1111783](https://bugzilla.redhat.com/1111783) <b>[RFE][TestOnly] Provide SCSI reservation support for virtio-scsi via rhev-guest-tools for win-8 and win-2012 guests using Direct-Lun as disks</b><br>With this release Windows clustering is supported for iSCSI based direct attached LUNs.
 - [BZ 1598391](https://bugzilla.redhat.com/1598391) <b>[RFE] - Certify OSP 14 with OVN as an external network provider on RHV 4.3</b><br>
 - [BZ 1327846](https://bugzilla.redhat.com/1327846) <b>[RFE] Q35: Support booting virtual machines via UEFI</b><br>
 - [BZ 1590202](https://bugzilla.redhat.com/1590202) <b>[RFE] Disable Event notification popup in admin portal</b><br>This adds a feature to control toast notifications. Once 3 or more notifications are showing, "Dismiss" and "Do not disturb" buttons will appear that allow the user to silence notifications.
 - [BZ 1571399](https://bugzilla.redhat.com/1571399) <b>[RFE] Improve UI plugin API for adding action buttons</b><br>Feature: When adding custom action buttons (located above main or details tab grid) via UI plugin API, it's now possible to specify the relative position of the button and whether it should be placed in the "more" menu.<br><br>Reason: Give UI plugins more control over plugin-contributed action button placement.<br><br>Result: When calling addMenuPlaceActionButton/addDetailPlaceActionButton API functions, you can now pass "index" and "moreMenu" options to customize the relative position of the button and whether it should be placed in the "more" menu. By default, the button will be placed at the end (after all existing buttons) and outside the "more" menu.
 - [BZ 1559694](https://bugzilla.redhat.com/1559694) <b>RFE: warn user if VM does not fit in a single numa node of the host</b><br>If a VM does not use virtual NUMA nodes, it is better if its whole memory can fit into a single NUMA node on the host. Otherwise, there may be some performance overhead.<br><br>There are two additions in this RFE:<br>1. New warning message is shown in the audit log, if a VM is run on a host where its memory cannot fit to a single host NUMA node.<br><br>2. A new policy unit is added to the scheduler, 'Fit VM to single host NUMA node'. When starting a VM, this policy prefers hosts where the VM can fit to a single NUMA node. This unit is not active by default, because it can cause undesired edge cases.<br><br>For example, the policy unit would cause the following behavior when starting multiple VMs.<br>It the following setup:<br>- 9 hosts with 16 GB per NUMA node<br>- 1 host with 4 GB per NUMA node<br><br>When multiple VMs with 6 GB of memory are scheduled, the scheduling unit would prevent them from starting on the host with 4 GB per NUMA node. No matter how overloaded the other hosts are. It would use the last host only when all the others does not have enough free memory to run the VM.
 - [BZ 1009608](https://bugzilla.redhat.com/1009608) <b>[RFE] Limit east-west traffic of VMs with network filter</b><br>Feature: <br><br>Limit east-west traffic of VMs. <br><br>Reason: <br><br>To enable traffic only between VM and gateway. <br><br>Result: <br><br>The new filter 'clean-traffic-gateway' has been added to libvirt. With parameter called 'GATEWAY_MAC' user can specify MAC address of gateway that is allowed to communicate with the VM and vice versa. Please note that user can specify multiple 'GATEWAY_MAC'. <br><br>There are two possible configurations of VM:<br><br>1) VM with static IP<br><br>This is recommended setup. It is also recommended setting of parameter 'CTRL_IP_LEARNING' to 'none', any other value will result in leak of initial traffic. This is caused by libvirt learning mechanism (see https://libvirt.org/formatnwfilter.html#nwfelemsRulesAdvIPAddrDetection and https://bugzilla.redhat.com/show_bug.cgi?id=1647944 for more details).<br><br>2) VM with DHCP<br><br>DHCP is working partially. It is not usable in production currently (https://bugzilla.redhat.com/show_bug.cgi?id=1651499).<br><br><br>The filter has general issue with ARP leak (https://bugzilla.redhat.com/show_bug.cgi?id=1651467). Peer VMs are able to see that the VM using this feature exists (in their arp table), but are not able to contact the VM, as the traffic from peers is still blocked by the filter.
 - [BZ 1454673](https://bugzilla.redhat.com/1454673) <b>[RFE] Changes that require Virtual Machine restart: name</b><br>Feature: <br>When a request to rename a virtual machine arrives, change the name of the virtual machine immediately also when the QEMU process is running and is set with the previous name.<br><br>Reason: <br>Users typically want to see and use the new name a virtual machine is set with even when it is running.<br><br>Result: <br>When renaming a running virtual machine, the new name is applied immediately. In this case, the user is provided with a warning that indicates that the running instance of the virtual machine uses the previous name.
 - [BZ 1553902](https://bugzilla.redhat.com/1553902) <b>[RFE] Update UI plugin API to reflect current UI design</b><br>Starting with oVirt 4.3, the UI plugin API is updated to reflect recent web administration UI design changes.<br><br>In general, there are two types of changes:<br><br>(1) new API functions:<br>- addPrimaryMenuContainer & addSecondaryMenuPlace that allow plugins to add custom secondary menu items to the vertical navigation menu<br><br>(2) renaming of existing API functions:<br>- addMainTab => addPrimaryMenuPlace<br>- addSubTab => addDetailPlace<br>- setTabContentUrl => setPlaceContentUrl<br>- setTabAccessible => setPlaceAccessible<br>- addMainTabActionButton => addMenuPlaceActionButton<br>- addSubTabActionButton => addDetailPlaceActionButton<br><br>The reason for renaming API functions (2) is to stay consistent with current web administration UI design - most notably, the absence of "main" and "sub" tabs.<br><br>All existing API functions are still supported. For API functions that were renamed (2), it's still possible to use the original ones, but doing so will yield a warning in the browser console, for example:<br><br>"addMainTab is deprecated, please use addPrimaryMenuPlace instead."<br><br>Additionally, for functions [addPrimaryMenuPlace, addPrimaryMenuContainer, addSecondaryMenuPlace, addDetailPlace] and their deprecated equivalents, the options object no longer supports alignRight (boolean) parameter. This is because PatternFly tabs widget [1] expects all tabs to be aligned next to each other, flowing from left to right.<br><br>[1] http://www.patternfly.org/pattern-library/widgets/#tabs<br><br>For details, please consult the oVirt UI plugins feature page.
 - [BZ 1518697](https://bugzilla.redhat.com/1518697) <b>engine-setup upgrade of postgres to pg95 env variables not stored to answer file</b><br>engine-setup now uses otopi's new functionality to generate its answer files, which should automatically cover all future added questions without requiring specific code for handling them. The option '--config-append' is compatible with both kinds of files, although the actual behavior will be somewhat different.
 - [BZ 1530031](https://bugzilla.redhat.com/1530031) <b>[RFE] engine-backup should have defaults for most options</b><br>engine-backup now has defaults for most options, so they do not need to be supplied usually.<br><br>TODO update with the new defaults once we decide what these are.
 - [BZ 1131178](https://bugzilla.redhat.com/1131178) <b>[RFE] Include storage domain UUID in Storage Domain 'General' tab</b><br>
 - [BZ 1570077](https://bugzilla.redhat.com/1570077) <b>[RFE] Add UI plugin API function to allow tab/place resource cleanup</b><br>Feature: After adding custom primary/secondary menu item or details tab via UI plugin API, it's now possible to attach "unload" handler to perform any UI-plugin-specific cleanup once the user navigates away from the given primary/secondary menu item or details tab.<br><br>Reason: Allow UI plugins to attach "unload" handler for each plugin-contributed WebAdmin UI application place, i.e. custom primary/secondary menu item or details tab.<br><br>Result: After adding the custom application place via addPrimaryMenuPlace/addSecondaryMenuPlace/addDetailPlace API functions, you can attach "unload" handler for that place by calling api.setPlaceUnloadHandler(place, handler) function.
 - [BZ 1651255](https://bugzilla.redhat.com/1651255) <b>Cannot set number of IO threads via the UI</b><br>Feature: <br>The number of IO threads can be set in the web UI in the new/edit VM dialog.<br><br>Reason: <br>Some users may need to set the number of IO threads and using web UI can be easier than REST API.
 - [BZ 1560132](https://bugzilla.redhat.com/1560132) <b>[RFE] Add finer grained monitoring thresholds for memory consumption on Hypervisors to RHV</b><br>In the Administration Portal, it is possible to set a threshold for cluster level monitoring as a percentage or an absolute value, for example, 95% or 2048 MB. When usage exceeds 95% or free memory falls below 2048 MB, a "high memory usage" or "low memory available" event is logged. This reduces log clutter for clusters with large (1.5 TB) amounts of memory.

#### oVirt Host Dependencies

 - [BZ 1598318](https://bugzilla.redhat.com/1598318) <b>Require SCAP in ovirt-host</b><br>The openscap, openscap-utils and scap-security-guide packages have been added to oVirt Node in order to help hardening the oVirt Node deployments.

#### oVirt Hosted Engine Setup

 - [BZ 1209881](https://bugzilla.redhat.com/1209881) <b>[RFE] remove iptables from hosted-engine.spec file to be able to deploy hosted-engine without firewall services installed</b><br>Feature: Remove iptables dependency <br><br>Reason: to be able to deploy hosted-engine without firewall services installed

#### oVirt Release Package

 - [BZ 1598318](https://bugzilla.redhat.com/1598318) <b>Require SCAP in ovirt-host</b><br>The openscap, openscap-utils and scap-security-guide packages have been added to oVirt Node in order to help hardening the oVirt Node deployments.

#### oVirt Windows Guest Tools

 - [BZ 1620569](https://bugzilla.redhat.com/1620569) <b>Include linux qemu-guest-agent on RHV Guest Tools iso for v2v offline conversion</b><br>Qemu Guest Agent packages for several Linux distributions have been added to ease offline installation of the guest agent
 - [BZ 1578782](https://bugzilla.redhat.com/1578782) <b>[RFE] Add smbus driver in windows guest tools</b><br>Feature: virtio-smbus driver installer has been added to RHV Windows Guest Tools<br><br>Reason: When a guest running Windows 2008 with Q35 bios an unknown device is listed in Device Manager being the smbus device unrecognized<br><br>Result: smbus device is now recognized.

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1638675](https://bugzilla.redhat.com/1638675) <b>Drop OpenStack Neutron deployment</b><br>The deployment of OpenStack hosts can be done by OpenStack Platform Director/TripleO, the Open vSwitch interface mappings are managed by VDSM, and the deployment of ovirt-provider-ovn-driver is managed as the attribute "Default Network Provider" on cluster level.
 - [BZ 1627636](https://bugzilla.redhat.com/1627636) <b>Drop ovirt-engine-cli dependency</b><br>ovirt-engine-cli uses v3 API which are deprecated and unsupported.<br>We'll keep shipping the package but we are not depending on it anymore.
 - [BZ 1533086](https://bugzilla.redhat.com/1533086) <b>deprecate and remove disks scan alignment feature</b><br>The "Scan Alignment" feature in the webadmin was only relevant to outdated guest OSes, which are no longer supported anyway.<br><br>The feature is now removed from the webadmin, along with histoprical records of disks being aligned or malaligned.

#### oVirt Host Deploy

 - [BZ 1638675](https://bugzilla.redhat.com/1638675) <b>Drop OpenStack Neutron deployment</b><br>The deployment of OpenStack hosts can be done by OpenStack Platform Director/TripleO, the Open vSwitch interface mappings are managed by VDSM, and the deployment of ovirt-provider-ovn-driver is managed as the attribute "Default Network Provider" on cluster level.

### Known Issue

#### OTOPI

 - [BZ 1381135](https://bugzilla.redhat.com/1381135) <b>[FC28] otopi fails to detect firewalld if python2-firewall is not available</b><br>In fedora 24, python3 is used by default in most of the system commands.<br>In particular firewall-cmd is now runing on python3 so python2-firewall is not installed by default.<br>OTOPI runs on python2 so it can't use the python3 module.<br>In order to allow OTOPI to detect and use firewalld the python2-firewall package has to be installed on the system.

### Bug Fixes

#### VDSM

 - [BZ 1593568](https://bugzilla.redhat.com/1593568) <b>Unexpected behaviour of HA VM when host VM was running ended up Non-responsive.</b><br>
 - [BZ 1583038](https://bugzilla.redhat.com/1583038) <b>[HE] Failed to deploy RHV-H on Hosted engine</b><br>
 - [BZ 1617745](https://bugzilla.redhat.com/1617745) <b>startUnderlyingVm fails with exception resulting in split-brain</b><br>
 - [BZ 1575777](https://bugzilla.redhat.com/1575777) <b>RHV import fails if VM has an unreachable floppy defined</b><br>
 - [BZ 1548846](https://bugzilla.redhat.com/1548846) <b>Hot unplug succeeds but warnings are seen in VDSM:  WARN  (libvirt/events) [virt.vm] (vmId='05361b2e-1ae3-40df-a159-cb4688b303c5') Removed device not found in conf: scsi0-0-0-3</b><br>
 - [BZ 1589612](https://bugzilla.redhat.com/1589612) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>

#### oVirt Engine

 - [BZ 1619474](https://bugzilla.redhat.com/1619474) <b>Pending change IO thread disable is not applied on shutdown</b><br>
 - [BZ 1619866](https://bugzilla.redhat.com/1619866) <b>IO-Threads is enabled inadvertently by editing unrelated configuration</b><br>
 - [BZ 1306659](https://bugzilla.redhat.com/1306659) <b>[CodeChange] - split ovirt-engine-lib package into separated packages for python2 and python3</b><br>
 - [BZ 1594615](https://bugzilla.redhat.com/1594615) <b>Unable to perform upgrade from 4.1 to 4.2 due to selinux related errors.</b><br>
 - [BZ 1598131](https://bugzilla.redhat.com/1598131) <b>OVN network synchronization not working after replacing the RHV-M tls certificate with a commercial one</b><br>
 - [BZ 1520848](https://bugzilla.redhat.com/1520848) <b>Hit Xorg Segmentation fault while installing rhel7.4 release guest in RHV 4.2 with QXL</b><br>
 - [BZ 1167675](https://bugzilla.redhat.com/1167675) <b>[GUI]>[SetupNetworks]> misleading message about unmanaged/unsynced network</b><br>
 - [BZ 1210717](https://bugzilla.redhat.com/1210717) <b>[RFE] - Show a warning when commiting a previewed snapshot.</b><br>
 - [BZ 1115607](https://bugzilla.redhat.com/1115607) <b>Edit Domain dialogue box fails to resize for over 13 lines on the vertical</b><br>
 - [BZ 1643476](https://bugzilla.redhat.com/1643476) <b>Wrong 'maxBandwidth' sent to vdsm on migration</b><br>
 - [BZ 1632055](https://bugzilla.redhat.com/1632055) <b>PowerSaving keeps VMs on over-utilized hosts while a host is empty and on.</b><br>
 - [BZ 1603020](https://bugzilla.redhat.com/1603020) <b>Indicate that RHV-H hosts have to be rebooted always after upgrade</b><br>
 - [BZ 1595489](https://bugzilla.redhat.com/1595489) <b>Virtual machine lost its cdrom device</b><br>
 - [BZ 1589612](https://bugzilla.redhat.com/1589612) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>
 - [BZ 1069269](https://bugzilla.redhat.com/1069269) <b>Allocation Policy changed by engine to its default from user defined after changing to another storage domain</b><br>

### Other

#### VDSM

 - [BZ 1634765](https://bugzilla.redhat.com/1634765) <b>Guest agent info is not reported with latest vdsm</b><br>
 - [BZ 1631624](https://bugzilla.redhat.com/1631624) <b>Exception on unsetPortMirroring makes vmDestroy fail.</b><br>
 - [BZ 1602047](https://bugzilla.redhat.com/1602047) <b>vdsm-tool upgrade-networks fails with KeyError: 'defaultRoute'</b><br>
 - [BZ 1590063](https://bugzilla.redhat.com/1590063) <b>VM was destroyed on destination after successful migration due to missing the 'device' key on the lease device</b><br>
 - [BZ 1502083](https://bugzilla.redhat.com/1502083) <b>Live storage migration completes but leaves volume un-opened.</b><br>
 - [BZ 1537148](https://bugzilla.redhat.com/1537148) <b>Guests not responding periodically in Manager</b><br>
 - [BZ 1511891](https://bugzilla.redhat.com/1511891) <b>qemu-img: slow disk move/clone/import</b><br>
 - [BZ 1560460](https://bugzilla.redhat.com/1560460) <b>getFileStats fails on NFS domain in case or recursive symbolic link (e.g., using NetApp snapshots)</b><br>
 - [BZ 1429286](https://bugzilla.redhat.com/1429286) <b>RAW-Preallocated disk is converted to RAW-sparse while cloning a VM in file based storage domain</b><br>
 - [BZ 1508375](https://bugzilla.redhat.com/1508375) <b>[RFE] use vdsm-client from Engine host</b><br>
 - [BZ 1562602](https://bugzilla.redhat.com/1562602) <b>VM with special characters failed to start</b><br>
 - [BZ 1629065](https://bugzilla.redhat.com/1629065) <b>Enable libvirt dynamic ownership</b><br>
 - [BZ 1615822](https://bugzilla.redhat.com/1615822) <b>[RFE] Report QEMU guest agent in app list</b><br>
 - [BZ 1547960](https://bugzilla.redhat.com/1547960) <b>Use qemu-img measure to estimate image size</b><br>
 - [BZ 1607952](https://bugzilla.redhat.com/1607952) <b>Kdump Status is disabled after successful fencing of host.</b><br>
 - [BZ 1592187](https://bugzilla.redhat.com/1592187) <b>Failed to stop vm with spice + vnc</b><br>
 - [BZ 1471138](https://bugzilla.redhat.com/1471138) <b>Creating VM from template no longer allows specification of Preallocated disks, only "RAW" or "QCOW2"</b><br>
 - [BZ 1579252](https://bugzilla.redhat.com/1579252) <b>KeyError: 'rx' on VM shutdown</b><br>
 - [BZ 1530724](https://bugzilla.redhat.com/1530724) <b>Vdsm gluster is broken on Fedora 27 because of python-blivet1</b><br>

#### oVirt Setup Lib

 - [BZ 1624599](https://bugzilla.redhat.com/1624599) <b>websocket-proxy package setup fails because of missing netaddr package</b><br>

#### oVirt Engine

 - [BZ 1641430](https://bugzilla.redhat.com/1641430) <b>During cold reboot treatment, RunVm did not run for some VMs</b><br>
 - [BZ 1554369](https://bugzilla.redhat.com/1554369) <b>Live Merge failed on engine with "still in volume chain", but merge on host was successful</b><br>
 - [BZ 1527249](https://bugzilla.redhat.com/1527249) <b>[DR] - HA VM with lease will not work, if SPM is down and power management is not available.</b><br>
 - [BZ 1638422](https://bugzilla.redhat.com/1638422) <b>[REST API] Networks link point to 'datacenters' instead of 'networks'</b><br>
 - [BZ 1609839](https://bugzilla.redhat.com/1609839) <b>Foreign key constraint violation on upgrade to 4.2.5</b><br>
 - [BZ 1600573](https://bugzilla.redhat.com/1600573) <b>add AMD EPYC SSBD CPU</b><br>
 - [BZ 1579008](https://bugzilla.redhat.com/1579008) <b>ovirt-engine fails to start when having a large number of stateless snapshots</b><br>
 - [BZ 1574346](https://bugzilla.redhat.com/1574346) <b>Move disk failed but delete was called on source sd, losing all the data</b><br>
 - [BZ 1578357](https://bugzilla.redhat.com/1578357) <b>[SCALE] Listing users in Users tab overloads the postgresql DB (CPU)</b><br>
 - [BZ 1648190](https://bugzilla.redhat.com/1648190) <b>[RHEL76] libvirt is unable to start after upgrade due to malformed UTCTIME values in cacert.pem, because properly renewed CA certificate was not passed to hosts by executing "Enroll certificate" or "Reinstall"</b><br>
 - [BZ 1646861](https://bugzilla.redhat.com/1646861) <b>Update gluster volume options set on the volume</b><br>
 - [BZ 1583009](https://bugzilla.redhat.com/1583009) <b>[RFE] Balancing does not produce ideal migrations</b><br>
 - [BZ 1640016](https://bugzilla.redhat.com/1640016) <b>UI Uncaught exception on New Cluster flow when choosing DC lower than 4.3 once the CPU type was set</b><br>
 - [BZ 1619233](https://bugzilla.redhat.com/1619233) <b>prepareMerge task is stuck when executing a cold merge on illegal image</b><br>
 - [BZ 1612877](https://bugzilla.redhat.com/1612877) <b>engine-setup with python3, returns No module named 'async_tasks_map'</b><br>
 - [BZ 1459502](https://bugzilla.redhat.com/1459502) <b>oVirt can not upgrade JDBC driver due to a postgres-jdbc driver regression issue</b><br>
 - [BZ 1582824](https://bugzilla.redhat.com/1582824) <b>[UI] - VM's network interface name and icon too large and wrap</b><br>
 - [BZ 1574508](https://bugzilla.redhat.com/1574508) <b>Space used icon in RHV-M not showing the actual space</b><br>
 - [BZ 1526032](https://bugzilla.redhat.com/1526032) <b>[RFE] Allow uploading a pre-existing VM template image (OVA) into the environment</b><br>
 - [BZ 1558709](https://bugzilla.redhat.com/1558709) <b>VM remains migrating forever with no Host (actually doesn't exist) after StopVmCommand fails to DestroyVDS</b><br>
 - [BZ 1548205](https://bugzilla.redhat.com/1548205) <b>Very slow UI if Host has many (~64) elements (VFs or dummies or networks)</b><br>
 - [BZ 1565673](https://bugzilla.redhat.com/1565673) <b>ovirt-engine loses track of a cancelled disk</b><br>
 - [BZ 1628484](https://bugzilla.redhat.com/1628484) <b>When moving host to maintenance, migrate also manually migrateable VMs</b><br>
 - [BZ 1640977](https://bugzilla.redhat.com/1640977) <b>RESTAPI listing diskprofiles only shows 1 href for the same QoS even if there are more domains with the same QoS</b><br>
 - [BZ 1496395](https://bugzilla.redhat.com/1496395) <b>[Memory hot unplug] After commit snapshot with memory hot unplug failed since device not found</b><br>
 - [BZ 1576134](https://bugzilla.redhat.com/1576134) <b>Failed to remove host xxxxxxxx</b><br>
 - [BZ 1622068](https://bugzilla.redhat.com/1622068) <b>Network type shows both rt8319 and virtio when import guest from ova on rhv4.2</b><br>
 - [BZ 1613845](https://bugzilla.redhat.com/1613845) <b>[OVN][TUNNEL] Non-existent ovirt network name causes tunnel network revert to ovirtmgmt</b><br>
 - [BZ 1631360](https://bugzilla.redhat.com/1631360) <b>use "Red Hat" manufacturer in SMBIOS for RHV VMs</b><br>
 - [BZ 1583217](https://bugzilla.redhat.com/1583217) <b>engine-backup verify with plain format does not work</b><br>
 - [BZ 1611617](https://bugzilla.redhat.com/1611617) <b>On rollback of failed upgrade from 4.2.1+, engine-setup outputs errors about the uuid-ossp extension</b><br>
 - [BZ 1539576](https://bugzilla.redhat.com/1539576) <b>ovn localnet - Engine should schedule VMs only on hosts where phys_net is attached</b><br>
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
 - [BZ 1511522](https://bugzilla.redhat.com/1511522) <b>ImportVmFromConfiguration fails with NullPointerException after domain import between 4.1 and 4.2 env</b><br>
 - [BZ 1517245](https://bugzilla.redhat.com/1517245) <b>[ALL_LANG] Truncated column names appear on volumes -> bricks -> advanced details -> memory pools page</b><br>
 - [BZ 1369407](https://bugzilla.redhat.com/1369407) <b>NPE while trying to remove user</b><br>
 - [BZ 1540921](https://bugzilla.redhat.com/1540921) <b>[RFE] Deprecate and remove support for Conroe and Penryn CPUs</b><br>
 - [BZ 1403653](https://bugzilla.redhat.com/1403653) <b>[RFE] Should accept any bond name starting with bond</b><br>
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
 - [BZ 1563580](https://bugzilla.redhat.com/1563580) <b>Missing whitespace in 'Current kernel CMD line'</b><br>
 - [BZ 1536397](https://bugzilla.redhat.com/1536397) <b>CloudInit: DNS search parameter is passed incorrectly</b><br>
 - [BZ 1558539](https://bugzilla.redhat.com/1558539) <b>activating a tag takes too long, shows tall empty VM grid</b><br>
 - [BZ 1537095](https://bugzilla.redhat.com/1537095) <b>[DNS] multi-host SetupNetworks command is not sent when a DNS entry is removed from network</b><br>
 - [BZ 1643813](https://bugzilla.redhat.com/1643813) <b>Managing tags fails with ConcurrentModificationException</b><br>
 - [BZ 1583968](https://bugzilla.redhat.com/1583968) <b>Hosted Engine VM is selected for balancing even though the BalanceVM command is not enabled for HE</b><br>
 - [BZ 1561413](https://bugzilla.redhat.com/1561413) <b>[RFE] Remove option should be grayed out for delete protected VMs</b><br>
 - [BZ 1562602](https://bugzilla.redhat.com/1562602) <b>VM with special characters failed to start</b><br>
 - [BZ 1643921](https://bugzilla.redhat.com/1643921) <b>Incorrect behavior of IOThreads text box in edit VM dialog</b><br>
 - [BZ 1630243](https://bugzilla.redhat.com/1630243) <b>[RFE] Show live migration progress bar also in virtual machine tab in host page</b><br>
 - [BZ 1645007](https://bugzilla.redhat.com/1645007) <b>Foreman response is limited to 20 entries per call</b><br>
 - [BZ 1591801](https://bugzilla.redhat.com/1591801) <b>uutils.ssh.OpenSSHUtils - the key algorithm 'EC' is not supported on Fedora 28</b><br>
 - [BZ 1644636](https://bugzilla.redhat.com/1644636) <b>Engine failed to retrieve images list from ISO domain.</b><br>
 - [BZ 1645890](https://bugzilla.redhat.com/1645890) <b>[REST] vnicprofiles point to "networks/[NET-ID]/vnicprofiles/" instead of: "/vnicprofiles/[VNIC-PROFILE-ID]"</b><br>
 - [BZ 1635405](https://bugzilla.redhat.com/1635405) <b>Move Disk dialog keeps spinning - API method works</b><br>
 - [BZ 1530616](https://bugzilla.redhat.com/1530616) <b>create new pool doesn't close dialog until all VMs are created</b><br>
 - [BZ 1637815](https://bugzilla.redhat.com/1637815) <b>engine-vacuum fails with 'vacuumdb: command not found'</b><br>
 - [BZ 1631392](https://bugzilla.redhat.com/1631392) <b>"New Pool" and "Edit Pool" windows have different labels for "Prestarted VMs"</b><br>
 - [BZ 1599732](https://bugzilla.redhat.com/1599732) <b>Failed to start VM with LibVirtError "Failed to acquire lock: No space left on device"</b><br>
 - [BZ 1625591](https://bugzilla.redhat.com/1625591) <b>After importing KVM VM, removing the VM and re-importing, the re-importing fails</b><br>
 - [BZ 1633645](https://bugzilla.redhat.com/1633645) <b>Old 'Intel Haswell Family-IBRS' cluster CPU type not renamed during the upgrade</b><br>
 - [BZ 1612978](https://bugzilla.redhat.com/1612978) <b>Extending VM disk fails with message "disk was successfully updated to 0 GB"</b><br>
 - [BZ 1624219](https://bugzilla.redhat.com/1624219) <b>Pool does not appear for user in group until refresh</b><br>
 - [BZ 1638124](https://bugzilla.redhat.com/1638124) <b>VM fails to start if maxMemory >= 2048 GB</b><br>
 - [BZ 1628150](https://bugzilla.redhat.com/1628150) <b>Snapshot deletion fails with "MaxNumOfVmSockets has no value for version"</b><br>
 - [BZ 1626907](https://bugzilla.redhat.com/1626907) <b>Live Snapshot creation on a "not responding" VM will fail during "GetQemuImageInfoVDS"</b><br>
 - [BZ 1635830](https://bugzilla.redhat.com/1635830) <b>Upload disk fail trying to write 0 bytes after the end of the LV</b><br>
 - [BZ 1628909](https://bugzilla.redhat.com/1628909) <b>Engine marks the snapshot status as OK before the actual snapshot operation</b><br>
 - [BZ 1633310](https://bugzilla.redhat.com/1633310) <b>Entries for snapshot creations in the command_entities table in the database prevented access to the Admin Portal</b><br>
 - [BZ 1609718](https://bugzilla.redhat.com/1609718) <b>allow search for memory guaranteed</b><br>
 - [BZ 1631249](https://bugzilla.redhat.com/1631249) <b>Make sure RHV Manager will use OpenJDK 8 even when newer versions are available</b><br>
 - [BZ 1602968](https://bugzilla.redhat.com/1602968) <b>[RFE] Add "power off VM" to the right-click popup menu in the GUI</b><br>
 - [BZ 1591828](https://bugzilla.redhat.com/1591828) <b>Stop bundling nimbus-jose-jwt 4.13.1, rebase on latest 5.12.</b><br>
 - [BZ 1615287](https://bugzilla.redhat.com/1615287) <b>Allow to create VM template with preallocated file-based disk via the UI</b><br>
 - [BZ 1512901](https://bugzilla.redhat.com/1512901) <b>[CodeChange] Refactor DeactivateStorageDomainWithOvfUpdateCommand to use CoCo framework and steps</b><br>
 - [BZ 1620916](https://bugzilla.redhat.com/1620916) <b>Starting engine service on fc28 with python3 fails on Cannot detect JBoss version</b><br>
 - [BZ 1615423](https://bugzilla.redhat.com/1615423) <b>Require python3 packages in fedora</b><br>
 - [BZ 1608291](https://bugzilla.redhat.com/1608291) <b>[RFE] Should be able to change the Port number of NoVnc</b><br>
 - [BZ 1612931](https://bugzilla.redhat.com/1612931) <b>[CodeChange] switch to using libpwquality instead of cracklib</b><br>
 - [BZ 1609552](https://bugzilla.redhat.com/1609552) <b>[UI] Disk storage domain drop down list appeared to be in the wrong place in 'create VM from template' dialog window</b><br>
 - [BZ 1609011](https://bugzilla.redhat.com/1609011) <b>Creating transient disk during backup operation is failing with error "No such file or directory"</b><br>
 - [BZ 1554922](https://bugzilla.redhat.com/1554922) <b>Failures creating a storage domain via ansible module/REST API doesn't report a meaningful error message</b><br>
 - [BZ 1535603](https://bugzilla.redhat.com/1535603) <b>Importing a template will fail with error "Template's image doesn't exist" if the template disk was copied from another storage domain</b><br>
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
 - [BZ 1576862](https://bugzilla.redhat.com/1576862) <b>Uploaded image: Virtual Size of qcow2 image is not reflected at guest OS level</b><br>
 - [BZ 1573421](https://bugzilla.redhat.com/1573421) <b>An exception is thrown when creating a template from snapshot with less disks then the active VM</b><br>
 - [BZ 1471138](https://bugzilla.redhat.com/1471138) <b>Creating VM from template no longer allows specification of Preallocated disks, only "RAW" or "QCOW2"</b><br>
 - [BZ 1561052](https://bugzilla.redhat.com/1561052) <b>The Active VM snapshots table entry does not exist for a specific VM</b><br>
 - [BZ 1545153](https://bugzilla.redhat.com/1545153) <b>No Storage Domain error while restoring a snapshot</b><br>
 - [BZ 1544229](https://bugzilla.redhat.com/1544229) <b>Exception in UI when editing a VM (without changing anything) @ org.ovirt.engine.ui.common.widget.uicommon.storage.DisksAllocationView_DriverImpl.getEventMap(DisksAllocationView_DriverImpl.java:20)</b><br>
 - [BZ 1452361](https://bugzilla.redhat.com/1452361) <b>VM import is possible to clusters where permissions to create VMs are not granted</b><br>

#### oVirt Host Dependencies

 - [BZ 1633975](https://bugzilla.redhat.com/1633975) <b>User cannot login to RHV-H if a security profile is applied during installation</b><br>
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

#### oVirt Log Collector

 - [BZ 1360621](https://bugzilla.redhat.com/1360621) <b>log-collector should collect detailed yum/dnf history</b><br>
 - [BZ 1555449](https://bugzilla.redhat.com/1555449) <b>[RFE] Reduce Archive Size by using filters message via flags unclear</b><br>
 - [BZ 1614304](https://bugzilla.redhat.com/1614304) <b>spec: require the python2/3-ovirt-engine-lib instead of ovirt-engine-lib</b><br>

#### imgbased

 - [BZ 1645395](https://bugzilla.redhat.com/1645395) <b>Imgbase check FAILED in redhat-virtualization-host-4.3-20181018.0.el7_6</b><br>
 - [BZ 1638606](https://bugzilla.redhat.com/1638606) <b>NTP config is migrated to chrony on every upgrade</b><br>

#### oVirt Engine Data Warehouse

 - [BZ 1639006](https://bugzilla.redhat.com/1639006) <b>[CodeChange] - DWH setup should support python 3</b><br>
 - [BZ 1546486](https://bugzilla.redhat.com/1546486) <b>(Fedora 27) Talend is not working properly with dom4j - 2.0.0</b><br>
 - [BZ 1507037](https://bugzilla.redhat.com/1507037) <b>Race condition on starting DWH on fresh install.</b><br>

#### oVirt Engine Metrics

 - [BZ 1651588](https://bugzilla.redhat.com/1651588) <b>Update oVirt metrics so that host deploy will not fail due to missing Fluentd package</b><br>

#### oVirt Release Package

 - [BZ 1645159](https://bugzilla.redhat.com/1645159) <b>change master dependencies for ovirt-web-ui rpm</b><br>
 - [BZ 1544481](https://bugzilla.redhat.com/1544481) <b>Provide missing dependencies for Fedora 28</b><br>

#### oVirt vmconsole

 - [BZ 1641356](https://bugzilla.redhat.com/1641356) <b>Package for python2/3  compatibility</b><br>

### Removed functionality

#### VDSM

 - [BZ 1601873](https://bugzilla.redhat.com/1601873) <b>Remove dependency on gluster-gnfs to support Gluster 4.1</b><br>gluster-gnfs is no longer available with Gluster 4.1. Users that require nfs access for gluster volumes are advised to use nfs-ganesha. Please refer https://gluster.readthedocs.io/en/latest/Administrator%20Guide/NFS-Ganesha%20GlusterFS%20Integration/

### No Doc Update

#### oVirt Engine

 - [BZ 1591751](https://bugzilla.redhat.com/1591751) <b>Recreate engine_cache dir during start and host deployment flows</b><br>
 - [BZ 1589270](https://bugzilla.redhat.com/1589270) <b>ovirt-engine-setup-plugin-ovirt-engine %pre fails on Fedora 28</b><br>
 - [BZ 1553425](https://bugzilla.redhat.com/1553425) <b>Number of "Prestarted VMs" is ignored and all VMs of Pool starts after editing existing Pool.</b><br>
 - [BZ 1636981](https://bugzilla.redhat.com/1636981) <b>[RFE] provide a sorted list of available boot-iso in "run once" dialog for virtual machines</b><br>
 - [BZ 1533389](https://bugzilla.redhat.com/1533389) <b>[UI] - 'Manage Networks' dialog - Fix minor issue with the radio buttons and headers focus</b><br>
 - [BZ 1641954](https://bugzilla.redhat.com/1641954) <b>engine python files are not compiled in fc28</b><br>
 - [BZ 1568447](https://bugzilla.redhat.com/1568447) <b>Moving StorageDomain to Maintenance releases lock twice</b><br>

#### oVirt ISO Uploader

 - [BZ 1627200](https://bugzilla.redhat.com/1627200) <b>Fix ovirt-iso-uploader for python 3 compatibility</b><br>

