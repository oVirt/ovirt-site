---
title: oVirt 4.2.7 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.2.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.7 release as of November 02, 2018.

Release has been updated on November 13, 2018..

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.7, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
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

## What's New in 4.2.7?

### Release Note

#### oVirt Engine

 - [BZ 1632592](https://bugzilla.redhat.com/1632592) <b>Upgrade ovirt-engine-wildfly to 14.0.1 Final</b><br>This is upstream oVirt release notes only:<br><br>oVirt 4.2.7 requires WildFly 14, which is provided by ovirt-engine-wildfly and ovirt-engine-wildfly-overlay packages. The upgrade from WildFly 13 to 14 is automatic and it's performed during oVirt engine upgrade from 4.1.z/4.2.z to 4.2.7+

#### oVirt Engine WildFly

 - [BZ 1632592](https://bugzilla.redhat.com/1632592) <b>Upgrade ovirt-engine-wildfly to 14.0.1 Final</b><br>This is upstream oVirt release notes only:<br><br>oVirt 4.2.7 requires WildFly 14, which is provided by ovirt-engine-wildfly and ovirt-engine-wildfly-overlay packages. The upgrade from WildFly 13 to 14 is automatic and it's performed during oVirt engine upgrade from 4.1.z/4.2.z to 4.2.7+

### Enhancements

#### imgbased

 - [BZ 1613931](https://bugzilla.redhat.com/1613931) <b>[RFE] Add the ability to recover from failed upgrades</b><br>This release adds the recover verb to imgbase. While upgrading ovirt-node-ng, imgbase creates LVs. If for any reason imgbase fails, and those LVs remain on the system, rerunning the upgrade fails on "existing LVs".<br>Now, `imgbase --experimental recover` finds and removes stale LVs that remained on the system due to a failed upgrade. imgbase will prompt the user before removing LVs, unless used with --force.

#### oVirt Engine

 - [BZ 1590967](https://bugzilla.redhat.com/1590967) <b>[RFE] Display space savings when a VDO volume is used.</b><br>The current release has a 'VDO Savings' field that displays the savings percentage for the Gluster Storage Domain, Volume, and Brick views.
 - [BZ 1623259](https://bugzilla.redhat.com/1623259) <b>Mark clusters with deprecated CPU type</b><br>In the current release, for compatibility versions 4.2 and 4.3, a warning in the Cluster screen indicates that the CPU types currently used are not supported in 4.3. The warning enables the user to change the cluster CPU type to a supported CPU type.
 - [BZ 1610979](https://bugzilla.redhat.com/1610979) <b>[downstream clone - 4.2.7] [RHEL-7.6] Limit east-west traffic of VMs with network filter</b><br>In the current release, a filter for VNIC profiles, `clean-traffic-gateway`, supports private VLAN connections.

#### VDSM

 - [BZ 1628477](https://bugzilla.redhat.com/1628477) <b>[downstream clone - 4.2.7] After importing KVM VM the actual size is bigger than the virtual size</b><br>When a VM is running, the disk size of the virtual machine should be no larger than was required during the initial allocation of disk space, unless you specify pre-allocation. Previously, when you set thin provisioning for importing a KVM-based VM into a Red Hat Virtualizaton environment, the disk size of the VM within the Red Hat Virtualization storage domain was inflated to the volume size or larger, even when the original KVM-based VM was much smaller.<br>KVM Sparseness is now supported so that when you import a virtual machine with thin provisioning enabled into a Red Hat Virtualization environment, the disk size of the original virtual machine image is preserved.
 - [BZ 1620573](https://bugzilla.redhat.com/1620573) <b>[downstream clone - 4.2.7] [RFE] Time sync in VM after resuming from PAUSE state</b><br>Large snapshots can result in long pauses of a VM that can affect the accuracy of the System Time, upon which time stamps and other time related functions depend. Guest Time Synchronization enables synchronization of the VM’s System Time during the creation of snapshots when enabled. When this feature is enabled and the Guest Agent is running, the VDSM process on the Host attempts to synchronize the System Time of the VM with the Host’s System Time when snapshots are completed and the VM is un-paused. To turn on Guest Time Synchronization for snapshots, use the time_sync_snapshot_enable option. For synchronizing the VM’s System Time during abnormal scenarios that may cause the VM to pause, you can enable the time_sync_cont_enable option. By default, these features are disabled for backward compatibility.
 - [BZ 1621211](https://bugzilla.redhat.com/1621211) <b>[downstream clone - 4.2.7] qemu-img: slow disk move/clone/import</b><br>Copying volumes to preallocated disks is slower than it can be, and does not make optimal use of available network resources. In this release, qemu-img uses out of order writing. As a result, write operations, such as importing, moving or copying large disks to preallocated storage, can be up to 6 times faster.

#### oVirt Log Collector

 - [BZ 1620271](https://bugzilla.redhat.com/1620271) <b>enable rhv_analyzer plugin for sos >= 3.6</b><br>The ovirt-log-collector now includes the RHV Log Collector Analyzer report. This analysis is generated by the rhv-log-collector-analyzer tool, which analyzes the RHV environment and detects anomalies in the system.

#### oVirt Windows Guest Tools

 - [BZ 1637534](https://bugzilla.redhat.com/1637534) <b>[downstream clone - 4.2.7] Include linux qemu-guest-agent on RHV Guest Tools iso for v2v offline conversion</b><br>QEMU Guest Agent packages for several Linux distributions have been added to ease offline installation of the guest agent.

### Bug Fixes

#### imgbased

 - [BZ 1641543](https://bugzilla.redhat.com/1641543) <b>Upgrade again to newer build failed from the older build after the first upgrade</b><br>
 - [BZ 1632585](https://bugzilla.redhat.com/1632585) <b>lvremove command will fail if it asks for confirmation while removing old RHV-H layers</b><br>

#### oVirt Engine

 - [BZ 1639263](https://bugzilla.redhat.com/1639263) <b>[downstream clone - 4.2.7] VM fails to start if maxMemory >= 2048 GB</b><br>
 - [BZ 1623379](https://bugzilla.redhat.com/1623379) <b>'Clone' VM from snapshot via the UI is broken</b><br>
 - [BZ 1637066](https://bugzilla.redhat.com/1637066) <b>[downstream clone - 4.2.7] Live Snapshot creation on a "not responding" VM will fail during "GetQemuImageInfoVDS"</b><br>

#### VDSM

 - [BZ 1627289](https://bugzilla.redhat.com/1627289) <b>[downstream clone - 4.2.7] startUnderlyingVm fails with exception resulting in split-brain</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1568841](https://bugzilla.redhat.com/1568841) <b>Cant restore hosted-engine backup at deployment</b><br>

### Other

#### VDSM JSON-RPC Java

 - [BZ 1582379](https://bugzilla.redhat.com/1582379) <b>All hosts stuck in connecting/not responding state until engine restarted</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1621140](https://bugzilla.redhat.com/1621140) <b>add info logs to proxy (similar to daemon)</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1639160](https://bugzilla.redhat.com/1639160) <b>[day2] Expand cluster option not available in manage gluster dashboard.</b><br>
 - [BZ 1637474](https://bugzilla.redhat.com/1637474) <b>Hyperconverged deployment fails to proceed with lvcache details</b><br>
 - [BZ 1605075](https://bugzilla.redhat.com/1605075) <b>automatic creation of storage domain misses the :/ in storage connection value</b><br>
 - [BZ 1619256](https://bugzilla.redhat.com/1619256) <b>Set performance options on gluster volume</b><br>
 - [BZ 1619395](https://bugzilla.redhat.com/1619395) <b>Adjusting Create Volume and Exapnd Cluster for Single Node</b><br>
 - [BZ 1600883](https://bugzilla.redhat.com/1600883) <b>Remove Packages tab from gluster deployment  in cockpit ovirt</b><br>
 - [BZ 1574926](https://bugzilla.redhat.com/1574926) <b>Reusing the existing gluster configuration needs validation</b><br>
 - [BZ 1637417](https://bugzilla.redhat.com/1637417) <b>[cockpit] When disk for engine brick is changed, engine LV type becomes thin LV</b><br>
 - [BZ 1637374](https://bugzilla.redhat.com/1637374) <b>[cockpit] LV type selection - thinp checkbox should be greyed out for second and third host too</b><br>
 - [BZ 1590867](https://bugzilla.redhat.com/1590867) <b>Host names field should be flexible to hold longer host names in brick tab</b><br>
 - [BZ 1608660](https://bugzilla.redhat.com/1608660) <b>Support single node deployment from cockpit</b><br>
 - [BZ 1603162](https://bugzilla.redhat.com/1603162) <b>[day2] Editing the hosts in generated gdeploy config file, doesn't reflect on all the config files</b><br>

#### imgbased

 - [BZ 1614971](https://bugzilla.redhat.com/1614971) <b>Upgrading RHV-H from 4.0.X to 4.2 is failing during migrate_var</b><br>

#### oVirt Engine

 - [BZ 1639269](https://bugzilla.redhat.com/1639269) <b>[downstream clone - 4.2.7] [DR] - HA VM with lease will not work, if SPM is down and power management is not available.</b><br>
 - [BZ 1635189](https://bugzilla.redhat.com/1635189) <b>[downstream clone - 4.2.7] Engine marks the snapshot status as OK before the actual snapshot operation</b><br>In the current release, the snapshot's status is locked until snapshot creation is complete.
 - [BZ 1647032](https://bugzilla.redhat.com/1647032) <b>[downstream clone - 4.2.7] Update gluster volume options set on the volume</b><br>
 - [BZ 1619278](https://bugzilla.redhat.com/1619278) <b>Alert when guaranteed capacity reaches a threshold value for gluster volumes</b><br>
 - [BZ 1630744](https://bugzilla.redhat.com/1630744) <b>Allow configuring aio=native for gluster storage domains</b><br>
 - [BZ 1624349](https://bugzilla.redhat.com/1624349) <b>Reduce the frequency of polling gluster from 5 secs to 15s</b><br>
 - [BZ 1620599](https://bugzilla.redhat.com/1620599) <b>[RFE] Assign more than one mdev device to a VM from RHV web UI</b><br>
 - [BZ 1613339](https://bugzilla.redhat.com/1613339) <b>Stop/Start VDO service during host Maintenance/Activate</b><br>
 - [BZ 1519777](https://bugzilla.redhat.com/1519777) <b>[downstream clone - 4.2.7] rhv manager does not show the results of the search properly</b><br>In the Administration Portal, searching for virtual machines by network label, VM emulated machine, and CPU type are not supported due to the complexity of their implementation.
 - [BZ 1626157](https://bugzilla.redhat.com/1626157) <b>NPE parsing the configuration of the HE bootstrap VM created with virt-install</b><br>
 - [BZ 1631341](https://bugzilla.redhat.com/1631341) <b>[downstream clone - 4.2.7] prepareMerge task is stuck when executing a cold merge on illegal image</b><br>
 - [BZ 1589509](https://bugzilla.redhat.com/1589509) <b>[CodeChange] Drop calls to FullList</b><br>
 - [BZ 1636946](https://bugzilla.redhat.com/1636946) <b>[downstream clone - 4.2.7] use "Red Hat" manufacturer in SMBIOS for RHV VMs</b><br>
 - [BZ 1609319](https://bugzilla.redhat.com/1609319) <b>failed to update cluster compatibility to version 4.2</b><br>
 - [BZ 1516445](https://bugzilla.redhat.com/1516445) <b>[RFE] Change default MAC address range (increase) and do not hard-code it</b><br>
 - [BZ 1533149](https://bugzilla.redhat.com/1533149) <b>Webadmin-Volumes - update volume snapshot cluster options when no option is selected is allowed causing an exception  - Error during ValidateFailure.: java.lang.Inde xOutOfBoundsException: Index: 0, Size: 0</b><br>
 - [BZ 1613371](https://bugzilla.redhat.com/1613371) <b>Error message when attempting to change the MAC address pool is non descriptive.</b><br>
 - [BZ 1614016](https://bugzilla.redhat.com/1614016) <b>admin portal minor css issues with badges and drawers</b><br>
 - [BZ 1593239](https://bugzilla.redhat.com/1593239) <b>Starting VM through RestAPI doesn't add cdrom with cloud-init</b><br>
 - [BZ 1526794](https://bugzilla.redhat.com/1526794) <b>[UI] - Import network > Network provider should be set by default in the drop down list</b><br>
 - [BZ 1619353](https://bugzilla.redhat.com/1619353) <b>[UI] Bond slave total values have the wrong unit</b><br>
 - [BZ 1607175](https://bugzilla.redhat.com/1607175) <b>Bond stats in gui are incorrect, showing only stats of one slave member</b><br>
 - [BZ 1511409](https://bugzilla.redhat.com/1511409) <b>[Rest] + [UI] - Report data.current.tx/rx and data.current.tx/rx.bps for bond interfaces and not only for slaves</b><br>
 - [BZ 1614345](https://bugzilla.redhat.com/1614345) <b>configure ovn-central to listening on ipv6, too.</b><br>
 - [BZ 1642083](https://bugzilla.redhat.com/1642083) <b>GlusterFS only - BackupAPI: Failure to start VM with snapshot disk attached: libvirtError: unsupported configuration: native I/O needs either no disk cache or directsync cache mode, QEMU will fallback to aio=threads</b><br>
 - [BZ 1629641](https://bugzilla.redhat.com/1629641) <b>PSQLException ERROR: integer out of range - Storage Domains view</b><br>
 - [BZ 1639244](https://bugzilla.redhat.com/1639244) <b>[downstream clone - 4.2.7] Extending VM disk fails with message "disk was successfully updated to 0 GB"</b><br>
 - [BZ 1637078](https://bugzilla.redhat.com/1637078) <b>[downstream clone - 4.2.7] Snapshot deletion fails with "MaxNumOfVmSockets has no value for version"</b><br>
 - [BZ 1636724](https://bugzilla.redhat.com/1636724) <b>Status code from the API for unsupported reduce volume actions (for reduce a size of a floating disk when the dc version is under 4.2) is 400 (bad request) instead 409 (conflict)</b><br>
 - [BZ 1637488](https://bugzilla.redhat.com/1637488) <b>[UI] - 'Not Logged In' in the welcome page is broken</b><br>
 - [BZ 1618433](https://bugzilla.redhat.com/1618433) <b>REST API reports wrong address and path for NFS storage domain on IPv6</b><br>
 - [BZ 1627032](https://bugzilla.redhat.com/1627032) <b>Upload disk fail trying to write 0 bytes after the end of the LV</b><br>
 - [BZ 1633232](https://bugzilla.redhat.com/1633232) <b>can't add new storage domain with empty comment</b><br>
 - [BZ 1625283](https://bugzilla.redhat.com/1625283) <b>transfer_id should be included in image ticket</b><br>
 - [BZ 1634035](https://bugzilla.redhat.com/1634035) <b>[downstream clone - 4.2.7] Entries for snapshot creations in the command_entities table in the database prevented access to the Admin Portal</b><br>
 - [BZ 1603150](https://bugzilla.redhat.com/1603150) <b>Potential bugs not caught because of randomized unit tests on mapping conversion between api model entities and engine business entities</b><br>
 - [BZ 1631876](https://bugzilla.redhat.com/1631876) <b>Fix dependency between engine, wildfly and wildfly overlay to make upgrades in CI easier</b><br>
 - [BZ 1632244](https://bugzilla.redhat.com/1632244) <b>[downstream clone - 4.2.7] Make sure RHV Manager will use OpenJDK 8 even when newer versions are available</b><br>
 - [BZ 1622321](https://bugzilla.redhat.com/1622321) <b>Receiving Getlldpvds error when editing host networks</b><br>
 - [BZ 1612124](https://bugzilla.redhat.com/1612124) <b>Engine raises 'insufficient permissions' error when normal user try to access /ovirt-engine/api</b><br>
 - [BZ 1619303](https://bugzilla.redhat.com/1619303) <b>Importing OVA does not honor disk size allocationUnits defined in ovf file</b><br>
 - [BZ 1575586](https://bugzilla.redhat.com/1575586) <b>Active snapshot disks appears when creating VM template from snapshot instead of the snapshot disks</b><br>
 - [BZ 1623818](https://bugzilla.redhat.com/1623818) <b>[4.2.z Clone] An exception is thrown when creating a template from snapshot with less disks then the active VM</b><br>
 - [BZ 1598996](https://bugzilla.redhat.com/1598996) <b>deleteVolume task is not cleared after a failed LSM due to power off VM during snapshot creation</b><br>
 - [BZ 1613462](https://bugzilla.redhat.com/1613462) <b>When importing image from Glance, warning message is displayed</b><br>

#### VDSM

 - [BZ 1639136](https://bugzilla.redhat.com/1639136) <b>Revert fix for bug 1614430 as it breaks heal monitoring</b><br>
 - [BZ 1635687](https://bugzilla.redhat.com/1635687) <b>[downstream clone - 4.2.7] Guest agent info is not reported with latest vdsm</b><br>
 - [BZ 1633586](https://bugzilla.redhat.com/1633586) <b>hooks/before_device_create/50_openstacknet fails</b><br>
 - [BZ 1613339](https://bugzilla.redhat.com/1613339) <b>Stop/Start VDO service during host Maintenance/Activate</b><br>
 - [BZ 1637410](https://bugzilla.redhat.com/1637410) <b>KVM VM import failed when source or destination NFS version is lower than NFSv4.2 (no fallback from sparse streams to non-sparse)</b><br>
 - [BZ 1636042](https://bugzilla.redhat.com/1636042) <b>KVM VM import failed when libvirt version in KVM server is older than 3.4.0 (no fallback from sparse streams to non-sparse)</b><br>
 - [BZ 1594194](https://bugzilla.redhat.com/1594194) <b>Make vdsm-client schema cache part of the package</b><br>
 - [BZ 1627734](https://bugzilla.redhat.com/1627734) <b>Don't attempt unnecessary cleanups in vhostmd hook</b><br>
 - [BZ 1625098](https://bugzilla.redhat.com/1625098) <b>Wrong network threshold limit warnings on vdsm version 4.20.35-1.el7</b><br>
 - [BZ 1615414](https://bugzilla.redhat.com/1615414) <b>Unable to change CD for drivers installation while installing a system from CD</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1619365](https://bugzilla.redhat.com/1619365) <b>VM HostedEngine is unexpectedly down with qemu error on source host after migration is completed</b><br>
 - [BZ 1614814](https://bugzilla.redhat.com/1614814) <b>[SHE] Remove 'sudo' from _check_service on HE Hosts</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1642440](https://bugzilla.redhat.com/1642440) <b>HE restore code must base upon vds_unique_id table instead of hw_uuid</b><br>
 - [BZ 1620314](https://bugzilla.redhat.com/1620314) <b>[downstream clone - 4.2.7] SHE disaster recovery is broken in new 4.2 deployments as hosted_storage is master</b><br>
 - [BZ 1469908](https://bugzilla.redhat.com/1469908) <b>[RFE] - Support managed/automated restore</b><br>
 - [BZ 1622240](https://bugzilla.redhat.com/1622240) <b>"Unknown CPU model Broadwell-IBRS-SSBD"</b><br>
 - [BZ 1406067](https://bugzilla.redhat.com/1406067) <b>[RFE] have the option to install hosted engine on specific datacenter and cluster.</b><br>
 - [BZ 1630090](https://bugzilla.redhat.com/1630090) <b>hosted-engine --vm-start-paused is broken with xmlBase64</b><br>
 - [BZ 1624529](https://bugzilla.redhat.com/1624529) <b>hosted-engine-setup doesn't restore hostname entry of RHV manager under "/etc/hosts" at the end of the setup if the engine VM is configured with DHCP</b><br>
 - [BZ 1595384](https://bugzilla.redhat.com/1595384) <b>getent play in validate_hostname_tasks.yml results in failure when short hostname listed first in /etc/hosts</b><br>
 - [BZ 1622135](https://bugzilla.redhat.com/1622135) <b>Free space check on local bootstrap VM directory is not performed at ansible level</b><br>
 - [BZ 1645757](https://bugzilla.redhat.com/1645757) <b>VMs running on the deployed host are removed from the engine after backup/restore</b><br>
 - [BZ 1621015](https://bugzilla.redhat.com/1621015) <b>SHE 3.6 upgrade to 4.0 failed but engine is 4.0</b><br>

#### oVirt Ansible ManageIQ role

 - [BZ 1627020](https://bugzilla.redhat.com/1627020) <b>Role creates disks which aren't used when using ManageIQ qcow image</b><br>
 - [BZ 1627018](https://bugzilla.redhat.com/1627018) <b>Can't set region when using ManageIQ qcow image</b><br>
 - [BZ 1624836](https://bugzilla.redhat.com/1624836) <b>Specified miq_vm_disk_storage variable cause undefined disk_storage_domain variable</b><br>
 - [BZ 1613914](https://bugzilla.redhat.com/1613914) <b>engine_fqdn is undefined  in wait_for_api - while using engine_url</b><br>
 - [BZ 1614314](https://bugzilla.redhat.com/1614314) <b>ManageIQ role should support Dry Run</b><br>
 - [BZ 1592857](https://bugzilla.redhat.com/1592857) <b>ovirt-ansible-roles: Manageiq: Can't set region</b><br>
 - [BZ 1613723](https://bugzilla.redhat.com/1613723) <b>Exception during task: adding host alias of appliance cause crashing ansible</b><br>
 - [BZ 1584772](https://bugzilla.redhat.com/1584772) <b>ManageIQ role doesn't work with passed RHV Credentials from Ansible Tower</b><br>

#### oVirt Ansible virtual machine infrastructure role

 - [BZ 1639167](https://bugzilla.redhat.com/1639167) <b>'VmsModule' object has no attribute '_get_minor'</b><br>

#### oVirt Ansible image template role

 - [BZ 1576433](https://bugzilla.redhat.com/1576433) <b>Provide option to set engine FQDN as an addition to full engine URL for all roles</b><br>

#### oVirt Ansible Repositories role

 - [BZ 1548082](https://bugzilla.redhat.com/1548082) <b>[RFE] Role should find pool ids by self</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1635198](https://bugzilla.redhat.com/1635198) <b>[downstream clone - 4.2.7] ovirt-engine-extension-aaa-ldap-setup generates incorrect config for LDAP setup using multiple servers with round robin request distribution</b><br>

#### oVirt Log Collector

 - [BZ 1616370](https://bugzilla.redhat.com/1616370) <b>(EL7.6) STDERR: a non-existing plugin (general) was specified in the command line</b><br>

#### oVirt Engine WildFly

 - [BZ 1631876](https://bugzilla.redhat.com/1631876) <b>Fix dependency between engine, wildfly and wildfly overlay to make upgrades in CI easier</b><br>

#### oVirt Engine WildFly Overlay

 - [BZ 1631876](https://bugzilla.redhat.com/1631876) <b>Fix dependency between engine, wildfly and wildfly overlay to make upgrades in CI easier</b><br>

#### oVirt Ansible cluster upgrade role

 - [BZ 1619199](https://bugzilla.redhat.com/1619199) <b>Default timeout for upgrade flow is too short</b><br>
 - [BZ 1576433](https://bugzilla.redhat.com/1576433) <b>Provide option to set engine FQDN as an addition to full engine URL for all roles</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1614111](https://bugzilla.redhat.com/1614111) <b>Pysdk: can we search vnic profile by its name AND its datacenter</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1628883](https://bugzilla.redhat.com/1628883) <b>[BREW BUILD ENABLER] Rebase vdsm-jsonrpc-java for version 4.2.7</b><br>
 - [BZ 1618462](https://bugzilla.redhat.com/1618462) <b>UpdateVmCommand raises: "Exception: org.springframework.dao.DataIntegrityViolationException: CallableStatementCallback" after updating VM memory</b><br>

#### oVirt Release Package

 - [BZ 1613231](https://bugzilla.redhat.com/1613231) <b>goferd errors in /var/log/messages of Red Hat Virtualization Host</b><br>

