---
title: oVirt 4.1.7 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.7
Fourth Release Candidate
 as of October 19, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).


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

To learn about features introduced before 4.1.7, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



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

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.7?

### Enhancements

#### VDSM

 - [BZ 1490810](https://bugzilla.redhat.com/1490810) <b>print task list to log in TooManyTasks issue</b><br>Feature: To make the troubleshooting easier, emit in the logs a dump of pending tasks when the Vdsm Executor queue is full.<br><br>Reason: Vdsm performs periodic monitoring and periodic maintenance task using one async executor, based on a thread pool. If operations becomes too slow or blocks, the internal queue becomes full and the periodic operations are no longer performed. The "TooManyTasks" exception can be seen in the logs. In those circumstances, to make it easier understand what Vdsm was attempting, Vdsm dumps the content of the executor queue in the logs.<br><br>Result: new warning added in the logs. The warning is throttled, meaning that it is emitted the first time it happens, and at most once every ten seconds.

#### oVirt Engine Metrics

 - [BZ 1502931](https://bugzilla.redhat.com/1502931) <b>[RFE]  Allow passing extra ansible opts to oVirt Metrics shell script</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1471658](https://bugzilla.redhat.com/1471658) <b>[HC] Hosted engine deployment should enable gfapi access for cluster</b><br>Feature: Enabling gfapi during HE installation<br><br>Reason: For the HC deployment, we want the gfapi access to be enabled for the "Default" cluster during HE deployment. <br><br>Result: You could use additional config file with:<br><br>OVEHOSTED_ENGINE/enableLibgfapi=bool:True<br><br>to enable libgfapi during HE setup

### Bug Fixes

#### VDSM

 - [BZ 1496677](https://bugzilla.redhat.com/1496677) <b>[downstream clone - 4.1.7] NPE when get LLDP info from host interface via REST</b><br>

#### oVirt Engine

 - [BZ 1492723](https://bugzilla.redhat.com/1492723) <b>MAC address can be used after vNIC unplug - NO duplication is allowed in the cluster</b><br>
 - [BZ 1489463](https://bugzilla.redhat.com/1489463) <b>Leftover LUN in engine DB after restore with  --he-remove-storage-vm (seen on FC)</b><br>
 - [BZ 1485688](https://bugzilla.redhat.com/1485688) <b>[downstream clone - 4.1.7] [Pool] VMs are still created with duplicate MAC addresses after 4.0.7 upgrade</b><br>
 - [BZ 1497614](https://bugzilla.redhat.com/1497614) <b>RESTAPI- PUT request to update DC from 4.0->4.1 fails with REST response 'Cannot migrate MACs to another MAC pool, because that action would create duplicates in target MAC pool, which are not allowed. Problematic MACs are  00:1a:4a:16:25:b2'</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1490202](https://bugzilla.redhat.com/1490202) <b>[downstream clone - 4.1.7] [iSCSI] ovirt-hosted-engine-setup fails if none of the discovered target is associated to the accessed portal</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1493384](https://bugzilla.redhat.com/1493384) <b>[downstream clone - 4.1.7] Additional HE host deploy fails due to 'received downloaded data size is wrong'</b><br>

#### oVirt Engine Dashboard

 - [BZ 1489152](https://bugzilla.redhat.com/1489152) <b>ovirt dashboard shows 'NaN' values for mem, storage in different languages</b><br>

#### ovirt-engine-dwh

 - [BZ 1465825](https://bugzilla.redhat.com/1465825) <b>Dashboard: can't see utilization squares (for cluster: CPU, memory and storage)</b><br>

### Other

#### VDSM

 - [BZ 1483328](https://bugzilla.redhat.com/1483328) <b>[downstream clone - 4.1.7] [sos plugin] lvm commands need syntax change</b><br>Previously, incorrect LVM configuration resulted in incorrect LVM output. The LVM configuration has now been fixed so that the correct LVM output is generated. The names of the generated files are as follows:<br><br>lvm_lvs_-v_-o_tags_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r<br><br>lvm_pvs_-v_-o_all_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r<br><br>lvm_vgs_-v_-o_tags_--config_global_locking_type_0_use_lvmetad_0_devices_preferred_names_.dev.mapper._ignore_suspended_devices_1_write_cache_state_0_disable_after_error_count_3_filter_a_.dev.mapper.._r
 - [BZ 1497940](https://bugzilla.redhat.com/1497940) <b>[downstream clone - 4.1.7] Sanlock init failed with unhelpful error message "Sanlock exception"</b><br>
 - [BZ 1488878](https://bugzilla.redhat.com/1488878) <b>vdsm-client help should show all available commands</b><br>

#### oVirt Engine Metrics

 - [BZ 1493002](https://bugzilla.redhat.com/1493002) <b>[RFE] Set fluentd buffer parameters</b><br>
 - [BZ 1492188](https://bugzilla.redhat.com/1492188) <b>Add keepalive, max_retry_wait parameters to fluentd secure_forward configuration</b><br>
 - [BZ 1468895](https://bugzilla.redhat.com/1468895) <b>Add a playbook that changes collectd and fluentd services state and enable/disable on the engine and hosts</b><br>

#### oVirt Release Package

 - [BZ 1485788](https://bugzilla.redhat.com/1485788) <b>Missing Networking page in Admin Console</b><br>

#### oVirt Engine

 - [BZ 1496399](https://bugzilla.redhat.com/1496399) <b>[downstream clone - 4.1.7] Shutdown of a vm during snapshot deletion renders the disk invalid</b><br>
 - [BZ 1490089](https://bugzilla.redhat.com/1490089) <b>[downstream clone - 4.1.7] 03_06_0620_create_fence_agents_table.sql:60: ERROR:  null value in column "agent_user" violates not-null constraint</b><br>
 - [BZ 1487981](https://bugzilla.redhat.com/1487981) <b>[downstream clone - 4.1.7] Host enters to power management restart loop</b><br>
 - [BZ 1477700](https://bugzilla.redhat.com/1477700) <b>Host enters to power management restart loop</b><br>
 - [BZ 1489677](https://bugzilla.redhat.com/1489677) <b>[downstream clone - 4.1.7] If VM is down and 'run_on_vds' is still set, errors are reported in engine and server logs</b><br>
 - [BZ 1496681](https://bugzilla.redhat.com/1496681) <b>[downstream clone - 4.1.7] User cannot use non Public vNIC Profiles</b><br>
 - [BZ 1464765](https://bugzilla.redhat.com/1464765) <b>Set iothreads via REST does not update virtio-scsi devices</b><br>
 - [BZ 1496720](https://bugzilla.redhat.com/1496720) <b>[TEXT] - Fix minor error in ' Some MAC addresses had to be reallocated, but operation failed becaue of insufficient amount of free MACs.'</b><br>
 - [BZ 1497518](https://bugzilla.redhat.com/1497518) <b>An exception is thrown when importing a VM with memory snapshots for the second time ('duplicate key value violates unique constraint "pk_images"')</b><br>
 - [BZ 1497512](https://bugzilla.redhat.com/1497512) <b>Memory snapshots images of a VM imported as active=false instead of active=true</b><br>
 - [BZ 1487291](https://bugzilla.redhat.com/1487291) <b>Snapshots not displayed in date order in vm-snapshots window</b><br>
 - [BZ 1484825](https://bugzilla.redhat.com/1484825) <b>Auto generated snapshot remains LOCKED after concurrent LSM</b><br>
 - [BZ 1478296](https://bugzilla.redhat.com/1478296) <b>Health check on Host <UNKNOWN> indicates that future attempts to Stop this host using Power-Management are expected to fail.</b><br>
 - [BZ 1489795](https://bugzilla.redhat.com/1489795) <b>Importing a VM from 3.6 fails due to NPE @ org.ovirt.engine.core.bll.network.VmInterfaceManager.removeAll</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1492791](https://bugzilla.redhat.com/1492791) <b>Engine VM has no external connectivity due to unconfigured default gateway if deployed with static IP</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1463917](https://bugzilla.redhat.com/1463917) <b>value of disk type is set as raid6 even if  raid5 is chosen from cockpit UI</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1496954](https://bugzilla.redhat.com/1496954) <b>Can't add system permission</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1496846](https://bugzilla.redhat.com/1496846) <b>Crash when using the same connection from two threads</b><br>

#### oVirt Host Deploy

 - [BZ 1501761](https://bugzilla.redhat.com/1501761) <b>Add the additional host to the HostedEngine failed due to miss the package "qemu-kvm-tools"</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1471815](https://bugzilla.redhat.com/1471815) <b>SQL Exception while sorting columns of events subtab of Hosts main tab</b><br>
