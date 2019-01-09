---
title: oVirt 4.2.8 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.8 Third Release Candidate as of January 09, 2019.

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

To learn about features introduced before 4.2.8, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



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

## What's New in 4.2.8?

### Release Note

#### oVirt Engine

 - [BZ 1651227](https://bugzilla.redhat.com/1651227) <b>[downstream clone - 4.2.8] Require Ansible 2.7.2+</b><br>Ansible 2.7.2 or higher is required to run oVirt Ansible roles.
 - [BZ 1659650](https://bugzilla.redhat.com/1659650) <b>Periodically check existing data centers and raise alert that 3.6/4.0 data center levels are not supported in RHV 4.3</b><br>Support for 3.6 and 4.0 data centers and cluster levels is removed in RHV 4.3, so this fix adds a service which will go over existing data centers periodically (once per week) and it will raise an alert to audit about inability to upgrade to 4.3 if data center with compatibility version 3.6 or 4.0 is found.

### Enhancements

#### VDSM

 - [BZ 1648624](https://bugzilla.redhat.com/1648624) <b>[downstream clone - 4.2.8] [RFE] - Certify ODL via Neutron API with external OSP 13 provider on RHV 4.2.z</b><br>Neutron from OSP 13 configured to use ODL can be used as an external network provider on RHV 4.2.z with the limitation described in bug 1655906 .
 - [BZ 1630861](https://bugzilla.redhat.com/1630861) <b>[downstream clone - 4.2.8] [RFE] - Certify OVN from OSP 13 via Neutron API with external OSP provider on RHV 4.2.z</b><br>Neutron from OSP 13 configured to use OVN can be used as an external network provider on RHV 4.2.z with the limitation described in bug 1655906 .

#### oVirt Engine

 - [BZ 1649267](https://bugzilla.redhat.com/1649267) <b>[downstream clone - 4.2.8] [RHEL76] libvirt is unable to start after upgrade due to malformed UTCTIME values in cacert.pem, because properly renewed CA certificate was not passed to hosts by executing "Enroll certificate" or "Reinstall"</b><br>Internal CAs generated in the past (<= 3.5) can contain UTCTIME values without timezone indication and this is not acceptable anymore with up to date openssl and gnutls libraries.<br>engine-setup was already checking it proposing a remediation but the user can postpone it, making it more evident since now postponing can cause serious issues.
 - [BZ 1639460](https://bugzilla.redhat.com/1639460) <b>[RFE] inter-mac-pool or intra-mac-pool overlapping ranges: warn if found</b><br>Feature: Provide a WARN message in the engine log on engine startup if overlapping ranges are found within a MAC pool or between MAC pools.<br><br>Reason: Overlapping ranges between MAC pools may cause undefined behaviour in engine on startup. This message records the cause of this undefined behaviour so the user may find it easier to rectify the situation. Overlapping ranges within a MAC pool have no ill effect on engine's behaviour but a warning is issued for consistency. Each warning also details the outcome as applicable, see comment #10<br><br>Result: Messages will appear in the engine log.
 - [BZ 1663632](https://bugzilla.redhat.com/1663632) <b>[downstream clone - 4.2.8] [RFE] allow to create vm from blank template when datacenter is enforcing quota</b><br>
 - [BZ 1477599](https://bugzilla.redhat.com/1477599) <b>[RFE] [UI+REST][Hosts>Network Interfaces] - Add indication that setup network operation is currently running on the host and not finished yet</b><br>Feature: As long as setup networks has not completed on a host, an indication of 'updating' is displayed in the webadmin. see comment #5<br><br>Reason: <br><br>Result:
 - [BZ 1598447](https://bugzilla.redhat.com/1598447) <b>Provide a tool to find changed config values</b><br>Feature: <br><br>In previous versions there was no easy way how administrators could found out, which changes they have made to options exposed via engine-config tool, which could cause them issues after performing y-stream upgrades (for example 4.1 -> 4.2).<br><br>Reason: <br><br>Result: <br><br>We have added option -d/--diff to engine-config tool which will display administrators all differences between their current option values and default value provided by engine.<br>The differences are displayed using following format:<br><br> $ engine-config --diff<br> Name: vdsConnectionTimeout<br> Version: general<br> Current: 40<br> Default: 20
 - [BZ 1592990](https://bugzilla.redhat.com/1592990) <b>Cannot set number of IO threads via the UI</b><br>Feature: <br>The number of IO threads can be set in the web UI in the new/edit VM dialog.<br><br>Reason: <br>Some users may need to set the number of IO threads and using web UI can be easier than REST API.
 - [BZ 1651649](https://bugzilla.redhat.com/1651649) <b>[downstream clone - 4.2.8] Cannot set number of IO threads via the UI</b><br>Feature: <br>The number of IO threads can be set in the web UI in the new/edit VM dialog.<br><br>Reason: <br>Some users may need to set the number of IO threads and using web UI can be easier than REST API.

#### oVirt Engine Metrics

 - [BZ 1645515](https://bugzilla.redhat.com/1645515) <b>[RFE] Add ansible-inventory file required for OCP/Origin 3.11 to metrics store machine</b><br>

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1662921](https://bugzilla.redhat.com/1662921) <b>[downstream clone - 4.2.8] After increase of ClusterCompatibilityVersion, an additional API-change will persist CustomerCompatibilityVersion to previous ClusterCompatibility Version</b><br>
 - [BZ 1655027](https://bugzilla.redhat.com/1655027) <b>[downstream clone - 4.2.8] RemoveVmCommand doesn't log the user</b><br>
 - [BZ 1662923](https://bugzilla.redhat.com/1662923) <b>[downstream clone - 4.2.8] Old 'Intel Haswell Family-IBRS' cluster CPU type not renamed during the upgrade</b><br>Previous RHV installations of 3.6 ELS and 4.1 introduced "Intel Haswell Family-IBRS" Cluster CPU type for Meltdown/Spectre mitigations. This name has been changed in 4.2 to "Intel Haswell IBRS Family" but the existing name was not properly updated and it couldn't be properly fixed in UI. This is now corrected and any such old cluster CPU type is changed automatically on upgrade.

### Bug Fixes

#### VDSM

 - [BZ 1526025](https://bugzilla.redhat.com/1526025) <b>VM configured with resume_behavior='AUTO_RESUME' is not resumed if it was previously manually attempted for resume</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1659096](https://bugzilla.redhat.com/1659096) <b>[downstream clone - 4.2.8] Hosted-Engine VM failed to start mixing ovirt-hosted-engine-setup from 4.1 with ovirt-hosted-engine-ha from 4.2</b><br>
 - [BZ 1658054](https://bugzilla.redhat.com/1658054) <b>[downstream clone - 4.2.8] Removing a non-HE Host recommends user to undeploy HostedEngine on it first</b><br>

#### oVirt Engine

 - [BZ 1647025](https://bugzilla.redhat.com/1647025) <b>[downstream clone - 4.2.8] RESTAPI listing diskprofiles only shows 1 href for the same QoS even if there are more domains with the same QoS</b><br>
 - [BZ 1648625](https://bugzilla.redhat.com/1648625) <b>Removal of one of the snapshot memory disks (memory / metadata) will cause a failure to create/update storage domain OVF</b><br>
 - [BZ 1655659](https://bugzilla.redhat.com/1655659) <b>Engine failed to retrieve images list from ISO domain.</b><br>
 - [BZ 1646992](https://bugzilla.redhat.com/1646992) <b>[downstream clone - 4.2.8] Move Disk dialog keeps spinning - API method works</b><br>

#### oVirt Engine Metrics

 - [BZ 1620595](https://bugzilla.redhat.com/1620595) <b>Update README files to use etc/ovirt-engine-metrics/config.yml.d/ to update variables</b><br>

#### imgbased

 - [BZ 1649658](https://bugzilla.redhat.com/1649658) <b>RHV-H upgrade from 4.1 to 4.2 will fail with error "not writing through dangling symlink" if server is registered to insight</b><br>
 - [BZ 1655489](https://bugzilla.redhat.com/1655489) <b>[downstream clone - 4.2.8] RHVH enters emergency mode when updated to the latest version and rebooted twice</b><br>
 - [BZ 1652940](https://bugzilla.redhat.com/1652940) <b>[downstream clone - 4.2.8] NTP config is migrated to chrony on every upgrade</b><br>
 - [BZ 1654147](https://bugzilla.redhat.com/1654147) <b>[downstream clone - 4.2.8] [upgrade] Post upgrade, new options are not available in virt profile</b><br>

### Other

#### VDSM

 - [BZ 1632759](https://bugzilla.redhat.com/1632759) <b>Guest agent info is not reported with latest vdsm</b><br>
 - [BZ 1656815](https://bugzilla.redhat.com/1656815) <b>[downstream clone - 4.2.8] vdsm fails with Invalid index metadata (invalid magic: 0) when trying to add a VM lease</b><br>
 - [BZ 1651552](https://bugzilla.redhat.com/1651552) <b>[downstream clone - 4.2.8] vdsm-client has missing dependecy to PyYAML</b><br>
 - [BZ 1637549](https://bugzilla.redhat.com/1637549) <b>[downstream clone - 4.2.8] Exception on unsetPortMirroring makes vmDestroy fail.</b><br>
 - [BZ 1612917](https://bugzilla.redhat.com/1612917) <b>Adding an IP address to a logical network wipes IP on other logical network</b><br>

#### oVirt Engine

 - [BZ 1647388](https://bugzilla.redhat.com/1647388) <b>[downstream clone - 4.2.8] Power on on already powered on host sets VMs as down and results in split-brain</b><br>
 - [BZ 1647384](https://bugzilla.redhat.com/1647384) <b>[downstream clone - 4.2.8] During cold reboot treatment, RunVm did not run for some VMs</b><br>
 - [BZ 1585950](https://bugzilla.redhat.com/1585950) <b>[downstream clone - 4.2.8] Live Merge failed on engine with "still in volume chain", but merge on host was successful</b><br>
 - [BZ 1661876](https://bugzilla.redhat.com/1661876) <b>[downstream clone - 4.2.8] No exclamation icon when bond with an LACP is misconfigured</b><br>
 - [BZ 1659960](https://bugzilla.redhat.com/1659960) <b>[downstream clone - 4.2.8] After upgrade to 4.2, admin portal host interface view does not load</b><br>
 - [BZ 1646417](https://bugzilla.redhat.com/1646417) <b>Can't restore snapshot with disks as user</b><br>
 - [BZ 1639618](https://bugzilla.redhat.com/1639618) <b>UI Exception observed while syncing geo-rep session from RHVM UI</b><br>
 - [BZ 1660529](https://bugzilla.redhat.com/1660529) <b>[downstream clone - 4.2.8] LSM encountered WELD-000049 exception and never issued live merge</b><br>
 - [BZ 1641622](https://bugzilla.redhat.com/1641622) <b>link for cluster's networkfilters returns 404</b><br>
 - [BZ 1635844](https://bugzilla.redhat.com/1635844) <b>Initialization does overwrite host sshkeys</b><br>
 - [BZ 1660055](https://bugzilla.redhat.com/1660055) <b>[downstream clone - 4.2.8] Incorrect behavior of IOThreads text box in edit VM dialog</b><br>
 - [BZ 1658653](https://bugzilla.redhat.com/1658653) <b>[downstream clone - 4.2.8] Scheduler computes incorrect CPU load of the host where the scheduled VM is running</b><br>
 - [BZ 1662669](https://bugzilla.redhat.com/1662669) <b>Can't log in to engine UI with:  JBWEB004038: An exception occurred processing JSP page /WEB-INF/login.jsp at line 41</b><br>
 - [BZ 1631215](https://bugzilla.redhat.com/1631215) <b>Upgrade of hosts causes no warning/error/change of status when running VMs are pinned to hosts</b><br>
 - [BZ 1658589](https://bugzilla.redhat.com/1658589) <b>[downstream clone - 4.2.8] Engine sent duplicate SnapshotVDSCommand, causing data corruption</b><br>
 - [BZ 1640225](https://bugzilla.redhat.com/1640225) <b>Failed to migrate VM disk: unsupported configuration: nothing selected for snapshot</b><br>
 - [BZ 1658095](https://bugzilla.redhat.com/1658095) <b>[core performance enhancement] - number of db calls on update of logical networks' status too large</b><br>
 - [BZ 1658117](https://bugzilla.redhat.com/1658117) <b>[downstream clone - 4.2.8] GetAllVmStatsVDSCommand sent host to Not-Responding status after upgrade</b><br>
 - [BZ 1655087](https://bugzilla.redhat.com/1655087) <b>[downstream clone - 4.2.8] Command entities left in ACTIVE state after HostUpgradeCheckCommand</b><br>
 - [BZ 1649615](https://bugzilla.redhat.com/1649615) <b>[downstream clone] engine fails to imports external VMs</b><br>
 - [BZ 1639650](https://bugzilla.redhat.com/1639650) <b>Hosted Engine VM is selected for balancing even though the BalanceVM command is not enabled for HE</b><br>
 - [BZ 1657764](https://bugzilla.redhat.com/1657764) <b>[downstream clone - 4.2.8] Updating template of VM Pool leaves tasks stuck after VMs shutdown</b><br>
 - [BZ 1651132](https://bugzilla.redhat.com/1651132) <b>[downstream clone - 4.2.8] Managing tags fails with ConcurrentModificationException</b><br>
 - [BZ 1506547](https://bugzilla.redhat.com/1506547) <b>Provisioning discovered host from oVirt via Foreman doesn't work</b><br>
 - [BZ 1641326](https://bugzilla.redhat.com/1641326) <b>NPE while querying for an ancestor image with no entry on 'images' table</b><br>
 - [BZ 1637818](https://bugzilla.redhat.com/1637818) <b>[downstream clone - 4.2.8] engine-vacuum fails with 'vacuumdb: command not found'</b><br>
 - [BZ 1635196](https://bugzilla.redhat.com/1635196) <b>[downstream clone - 4.2.8] Pool does not appear for user in group until refresh</b><br>
 - [BZ 1639742](https://bugzilla.redhat.com/1639742) <b>After importing KVM VM, removing the VM and re-importing, the re-importing fails</b><br>
 - [BZ 1658514](https://bugzilla.redhat.com/1658514) <b>[downstream clone - 4.2.8] Clone VM with Direct LUN fails on UI but succeeds on backend.</b><br>

#### oVirt Ansible cluster upgrade role

 - [BZ 1632257](https://bugzilla.redhat.com/1632257) <b>[ansible-playbook cluster-upgrade] Hosts upgrade resets the scheduling policy values</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1651516](https://bugzilla.redhat.com/1651516) <b>Installation hangs/fails late when SSH host keys are not in ~/.ssh/known_hosts</b><br>
 - [BZ 1640063](https://bugzilla.redhat.com/1640063) <b>Remove RAID 10 under Raid Type from Cockpit UI</b><br>
 - [BZ 1626501](https://bugzilla.redhat.com/1626501) <b>Stripe size and data disk count should be hidden, if JBOD disk type is chosen</b><br>
 - [BZ 1649655](https://bugzilla.redhat.com/1649655) <b>[cockpit] Editing the generated gdeploy configuration file doesn't have effect on deployment</b><br>
 - [BZ 1630689](https://bugzilla.redhat.com/1630689) <b>Provide checkbox in Host wizard if user has same host/ip for FQDN to auto add 2nd and 3rd hosts</b><br>
 - [BZ 1643621](https://bugzilla.redhat.com/1643621) <b>[text] Please correct "fiber channel" as "fibre channel"</b><br>
 - [BZ 1638629](https://bugzilla.redhat.com/1638629) <b>[RHHI] The gdeployConf file isn't visible untill the reload button is pressed in Single node Deployment</b><br>
 - [BZ 1640071](https://bugzilla.redhat.com/1640071) <b>Gluster Deployment - Step 4 | Logical Size(GB) - Incorrect Tool Tip</b><br>
 - [BZ 1638679](https://bugzilla.redhat.com/1638679) <b>Auto add the device name under the LV Cache column for 2nd and 3rd host</b><br>
 - [BZ 1638636](https://bugzilla.redhat.com/1638636) <b>The default option "backup-volfile-servers" under Storage tab needs to be removed for single node HE deployment</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1644748](https://bugzilla.redhat.com/1644748) <b>Engine not correctly constructing the OVF_STORE disks content.</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1651521](https://bugzilla.redhat.com/1651521) <b>[downstream clone - 4.2.8] [RFE] provide a sorted list of available boot-iso in "run once" dialog for virtual machines</b><br>

#### Contributors

50 people contributed to this release:

	Ales Musil
	Andrej Krejcir
	Bell Levin
	Benny Zlotnik
	Bohdan Iakymets
	Dan Kenigsberg
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Edward Haas
	Ehud Yonasi
	Eitan Raviv
	Eyal Shenitzky
	Francesco Romani
	Greg Sheremeta
	Javier Coscia
	Kaustav Majumder
	Marcin Mirecki
	Marcin Sobczyk
	Martin Nečas
	Martin Perina
	Martin Sivak
	Miguel Duarte Barroso
	Miguel Martin
	Milan Zamazal
	Moti Asayag
	Nir Soffer
	Olimp Bockowski
	Ondra Machacek
	Ori_Liel
	Petr Balogh
	Petr Kubica
	Ravi Nori
	Ryan Barry
	Sahina Bose
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Shirly Radco
	Shmuel Melamud
	Simone Tiraboschi
	Steven Rosenberg
	Tal Nisan
	Tomáš Golembiovský
	Yuval Turgeman
	emesika
	godas
	parthdhanjal
