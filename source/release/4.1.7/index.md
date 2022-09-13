---
title: oVirt 4.1.7 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.1.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.7
release as of November 7, 2017.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.1.7, see the [release notes for previous versions](/documentation/#previous-release-notes).


### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.7?

### Enhancements

#### VDSM

 - [BZ 1490810](https://bugzilla.redhat.com/show_bug.cgi?id=1490810) <b>print task list to log in TooManyTasks issue</b><br>Previously, while VDSM performed periodic monitoring and maintenance tasks, operations would occasionally become too slow or even become blocked. In this case, the internal queue became full and the periodic operations were no longer performed. A "TooManyTasks" warning  appeared in the log files at a maximum rate of once every 10 seconds.<br><br>In this release, if VDSM cannot perform its periodic operations, in addition to issuing a warning in the log files, VDSM also dumps the contents of the queue into the logs.

#### oVirt Engine Metrics

 - [BZ 1502931](https://bugzilla.redhat.com/show_bug.cgi?id=1502931) <b>[RFE]  Allow passing extra ansible opts to oVirt Metrics shell script</b><br>

#### oVirt Engine

 - [BZ 1502510](https://bugzilla.redhat.com/show_bug.cgi?id=1502510) <b>[downstream clone - 4.1.7] Rest API does not report network statistics host "data.current.tx, data.current.rx"</b><br>The precision of rx_rate, tx_rate, rx_drop, and tx_drop of virtual and host network interfaces have been increased. Network traffic 100 times smaller can now be detected on network interface statistics.<br><br>If traffic on the network interface is below the precision of the network interface statistics, it is not reflected in the statistics.

#### oVirt Hosted Engine Setup

 - [BZ 1471658](https://bugzilla.redhat.com/show_bug.cgi?id=1471658) <b>[HC] Hosted engine deployment should enable gfapi access for cluster</b><br>Feature: Enabling gfapi during HE installation<br><br>Reason: For the HC deployment, we want the gfapi access to be enabled for the "Default" cluster during HE deployment. <br><br>Result: You could use additional config file with:<br><br>OVEHOSTED_ENGINE/enableLibgfapi=bool:True<br><br>to enable libgfapi during HE setup

#### oVirt Hosted Engine HA

 - [BZ 1502653](https://bugzilla.redhat.com/show_bug.cgi?id=1502653) <b>[downstream clone - 4.1.7] HE host on EngineStarting -> EngineMaybeAway -> EngineDown cycle</b><br>This release adds caching of the OVF storage location. As the OVF storage location rarely changes, it does not need to be searched for on every monitoring loop iteration. Instead it can be saved and reused, and expired only in the case of an error. As a result, the monitoring loop execution time is decreased significantly.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Host

 - [BZ 1503124](https://bugzilla.redhat.com/show_bug.cgi?id=1503124) <b>Provide ovirt-host package in 4.1</b><br>A new package ovirt-host is introduced. It is required for a host to be added to a 4.2 engine.

### Bug Fixes

#### VDSM

 - [BZ 1503219](https://bugzilla.redhat.com/show_bug.cgi?id=1503219) <b>[downstream clone - 4.1.7] Handle copy of compressed QCOWs image (like rhel guest images) from one to block storage domain.</b><br>
 - [BZ 1496677](https://bugzilla.redhat.com/show_bug.cgi?id=1496677) <b>[downstream clone - 4.1.7] NPE when get LLDP info from host interface via REST</b><br>
 - [BZ 1474213](https://bugzilla.redhat.com/show_bug.cgi?id=1474213) <b>RHV-H defaults to localtime hardware clock</b><br>

#### oVirt Engine

 - [BZ 1492723](https://bugzilla.redhat.com/show_bug.cgi?id=1492723) <b>MAC address can be used after vNIC unplug - NO duplication is allowed in the cluster</b><br>
 - [BZ 1489463](https://bugzilla.redhat.com/show_bug.cgi?id=1489463) <b>Leftover LUN in engine DB after restore with  --he-remove-storage-vm (seen on FC)</b><br>
 - [BZ 1485688](https://bugzilla.redhat.com/show_bug.cgi?id=1485688) <b>[downstream clone - 4.1.7] [Pool] VMs are still created with duplicate MAC addresses after 4.0.7 upgrade</b><br>
 - [BZ 1497614](https://bugzilla.redhat.com/show_bug.cgi?id=1497614) <b>RESTAPI- PUT request to update DC from 4.0->4.1 fails with REST response 'Cannot migrate MACs to another MAC pool, because that action would create duplicates in target MAC pool, which are not allowed. Problematic MACs are  00:1a:4a:16:25:b2'</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1490202](https://bugzilla.redhat.com/show_bug.cgi?id=1490202) <b>[downstream clone - 4.1.7] [iSCSI] ovirt-hosted-engine-setup fails if none of the discovered target is associated to the accessed portal</b><br>
 - [BZ 1492791](https://bugzilla.redhat.com/show_bug.cgi?id=1492791) <b>Engine VM has no external connectivity due to unconfigured default gateway if deployed with static IP</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1493384](https://bugzilla.redhat.com/show_bug.cgi?id=1493384) <b>[downstream clone - 4.1.7] Additional HE host deploy fails due to 'received downloaded data size is wrong'</b><br>

#### oVirt Engine Dashboard

 - [BZ 1489152](https://bugzilla.redhat.com/show_bug.cgi?id=1489152) <b>ovirt dashboard shows 'NaN' values for mem, storage in different languages</b><br>

#### ovirt-engine-dwh

 - [BZ 1465825](https://bugzilla.redhat.com/show_bug.cgi?id=1465825) <b>Dashboard: can't see utilization squares (for cluster: CPU, memory and storage)</b><br>

### Other

#### VDSM

 - [BZ 1342550](https://bugzilla.redhat.com/show_bug.cgi?id=1342550) <b>while deleting vms created from a template, vdsm command fails with error VDSM command failed: Could not remove all image's volumes</b><br>
 - [BZ 1502213](https://bugzilla.redhat.com/show_bug.cgi?id=1502213) <b>[downstream clone - 4.1.7] [downstream clone - 4.2.0] while deleting vms created from a template, vdsm command fails with error VDSM command failed: Could not remove all image's volumes</b><br>
 - [BZ 1464002](https://bugzilla.redhat.com/show_bug.cgi?id=1464002) <b>Consume libvirt fixes fox RHEL7.4 [depends on bug 1461303; bug 1470127 - fixed for 7.4.z]</b><br>
 - [BZ 1483328](https://bugzilla.redhat.com/show_bug.cgi?id=1483328) <b>[downstream clone - 4.1.7] [sos plugin] lvm commands need syntax change</b><br>Previously, incorrect LVM configuration resulted in incorrect LVM output. The LVM configuration has now been fixed so that the correct LVM output is generated. The names of the generated files are as follows:<br><br>lvm_lvs_-v_-o_tags_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r<br><br>lvm_pvs_-v_-o_all_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r<br><br>lvm_vgs_-v_-o_tags_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r
 - [BZ 1506161](https://bugzilla.redhat.com/show_bug.cgi?id=1506161) <b>[downstream clone - 4.1.7] Cleanup thread for live merge executed continously if a block job failed in libvirtd side</b><br>
 - [BZ 1502206](https://bugzilla.redhat.com/show_bug.cgi?id=1502206) <b>Vdsm fails to start when logger conf file is invalid</b><br>
 - [BZ 1497940](https://bugzilla.redhat.com/show_bug.cgi?id=1497940) <b>[downstream clone - 4.1.7] Sanlock init failed with unhelpful error message "Sanlock exception"</b><br>
 - [BZ 1488878](https://bugzilla.redhat.com/show_bug.cgi?id=1488878) <b>vdsm-client help should show all available commands</b><br>

#### oVirt Engine Metrics

 - [BZ 1493002](https://bugzilla.redhat.com/show_bug.cgi?id=1493002) <b>[RFE] Set fluentd buffer parameters</b><br>
 - [BZ 1492188](https://bugzilla.redhat.com/show_bug.cgi?id=1492188) <b>Add keepalive, max_retry_wait parameters to fluentd secure_forward configuration</b><br>
 - [BZ 1468895](https://bugzilla.redhat.com/show_bug.cgi?id=1468895) <b>Add a playbook that changes collectd and fluentd services state and enable/disable on the engine and hosts</b><br>

#### oVirt Release Package

 - [BZ 1485788](https://bugzilla.redhat.com/show_bug.cgi?id=1485788) <b>Missing Networking page in Admin Console</b><br>

#### oVirt Engine

 - [BZ 1508327](https://bugzilla.redhat.com/show_bug.cgi?id=1508327) <b>Engine failed to start after upgrade caused by invocation of logFreeMacs()</b><br>
 - [BZ 1505242](https://bugzilla.redhat.com/show_bug.cgi?id=1505242) <b>Engine fails to start when AddVmComman (start VM) job exists</b><br>
 - [BZ 1507316](https://bugzilla.redhat.com/show_bug.cgi?id=1507316) <b>[downstream clone - 4.1.7] Engine and audit logs don't indicate if a commit or undo was issued during a snapshot preview</b><br>
 - [BZ 1383301](https://bugzilla.redhat.com/show_bug.cgi?id=1383301) <b>Snapshot remove Live-Merge failed, After vm shutdown, start again is not possible</b><br>
 - [BZ 1496399](https://bugzilla.redhat.com/show_bug.cgi?id=1496399) <b>[downstream clone - 4.1.7] Shutdown of a vm during snapshot deletion renders the disk invalid</b><br>
 - [BZ 1498478](https://bugzilla.redhat.com/show_bug.cgi?id=1498478) <b>[Bug RHV 4.1.7] VM snapshots "clone" button doesn't work.</b><br>
 - [BZ 1490089](https://bugzilla.redhat.com/show_bug.cgi?id=1490089) <b>[downstream clone - 4.1.7] 03_06_0620_create_fence_agents_table.sql:60: ERROR:  null value in column "agent_user" violates not-null constraint</b><br>
 - [BZ 1487981](https://bugzilla.redhat.com/show_bug.cgi?id=1487981) <b>[downstream clone - 4.1.7] Host enters to power management restart loop</b><br>
 - [BZ 1477700](https://bugzilla.redhat.com/show_bug.cgi?id=1477700) <b>Host enters to power management restart loop</b><br>
 - [BZ 1418165](https://bugzilla.redhat.com/show_bug.cgi?id=1418165) <b>[ja_JP] [Admin Portal] The tab name 'Scheduling policy' in Japanese appears slightly truncated in clusters->new window.</b><br>
 - [BZ 1489677](https://bugzilla.redhat.com/show_bug.cgi?id=1489677) <b>[downstream clone - 4.1.7] If VM is down and 'run_on_vds' is still set, errors are reported in engine and server logs</b><br>
 - [BZ 1496681](https://bugzilla.redhat.com/show_bug.cgi?id=1496681) <b>[downstream clone - 4.1.7] User cannot use non Public vNIC Profiles</b><br>
 - [BZ 1464765](https://bugzilla.redhat.com/show_bug.cgi?id=1464765) <b>Set iothreads via REST does not update virtio-scsi devices</b><br>
 - [BZ 1496720](https://bugzilla.redhat.com/show_bug.cgi?id=1496720) <b>[TEXT] - Fix minor error in ' Some MAC addresses had to be reallocated, but operation failed becaue of insufficient amount of free MACs.'</b><br>
 - [BZ 1507315](https://bugzilla.redhat.com/show_bug.cgi?id=1507315) <b>[downstream clone - 4.1.7] Engine logs don't indicate the option chosen for a snapshot preview</b><br>
 - [BZ 1497763](https://bugzilla.redhat.com/show_bug.cgi?id=1497763) <b>cannot import vm from data domain -  ERROR: duplicate key value violates unique constraint "pk_images"</b><br>
 - [BZ 1498580](https://bugzilla.redhat.com/show_bug.cgi?id=1498580) <b>Snapshot preview failure leaves jobs running and image locked</b><br>
 - [BZ 1417904](https://bugzilla.redhat.com/show_bug.cgi?id=1417904) <b>[fr_FR, es_ES] [Admin Portal] Text overlap and UI distortion observed on data center->QoS->storage->new page.</b><br>
 - [BZ 1488434](https://bugzilla.redhat.com/show_bug.cgi?id=1488434) <b>RestAPI documentation doesn't mention the image parameter for the upgrade call</b><br>
 - [BZ 1497518](https://bugzilla.redhat.com/show_bug.cgi?id=1497518) <b>An exception is thrown when importing a VM with memory snapshots for the second time ('duplicate key value violates unique constraint "pk_images"')</b><br>
 - [BZ 1497512](https://bugzilla.redhat.com/show_bug.cgi?id=1497512) <b>Memory snapshots images of a VM imported as active=false instead of active=true</b><br>
 - [BZ 1487291](https://bugzilla.redhat.com/show_bug.cgi?id=1487291) <b>Snapshots not displayed in date order in vm-snapshots window</b><br>
 - [BZ 1484825](https://bugzilla.redhat.com/show_bug.cgi?id=1484825) <b>Auto generated snapshot remains LOCKED after concurrent LSM</b><br>
 - [BZ 1478296](https://bugzilla.redhat.com/show_bug.cgi?id=1478296) <b>Health check on Host &lt;UNKNOWN&gt; indicates that future attempts to Stop this host using Power-Management are expected to fail.</b><br>
 - [BZ 1489795](https://bugzilla.redhat.com/show_bug.cgi?id=1489795) <b>Importing a VM from 3.6 fails due to NPE @ org.ovirt.engine.core.bll.network.VmInterfaceManager.removeAll</b><br>

#### imgbased

 - [BZ 1506550](https://bugzilla.redhat.com/show_bug.cgi?id=1506550) <b>[downstream clone - 4.1.7] File missing after upgrade of RHVH node from version RHVH-4.1-20170925.0 to latest.</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1463917](https://bugzilla.redhat.com/show_bug.cgi?id=1463917) <b>value of disk type is set as raid6 even if  raid5 is chosen from cockpit UI</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1496954](https://bugzilla.redhat.com/show_bug.cgi?id=1496954) <b>Can't add system permission</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1496846](https://bugzilla.redhat.com/show_bug.cgi?id=1496846) <b>Crash when using the same connection from two threads</b><br>

#### oVirt Host Deploy

 - [BZ 1501761](https://bugzilla.redhat.com/show_bug.cgi?id=1501761) <b>Add the additional host to the HostedEngine failed due to miss the package "qemu-kvm-tools"</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1503947](https://bugzilla.redhat.com/show_bug.cgi?id=1503947) <b>Failed to import the guest from export domain to data domain with error "General command validation failure</b><br>
 - [BZ 1471815](https://bugzilla.redhat.com/show_bug.cgi?id=1471815) <b>SQL Exception while sorting columns of events subtab of Hosts main tab</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1504150](https://bugzilla.redhat.com/show_bug.cgi?id=1504150) <b>[downstream clone - 4.1.7] Engine-health monitor should expect new sanlock error message</b><br>
