---
title: oVirt 4.3.3 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.3 First Release Candidate as of March 28, 2019.

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

To learn about features introduced before 4.3.3, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




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

## Known Issues
- oVirt Node and oVirt Engine Appliance are not available for Fedora 28 due to a bug in Lorax which has not yet been fixed in Fedora 28 (https://github.com/weldr/lorax/pull/612).



## What's New in 4.3.3?

### Release Note

#### VDSM

 - [BZ 1403674](https://bugzilla.redhat.com/1403674) <b>[IPv6] - allow and enable display network with only ipv6 boot protocol</b><br>This release allows Red Hat Virtualization Manager to set a display network and open a console to a virtual machine over an IPv6 only network.

### Enhancements

#### oVirt Engine

 - [BZ 1595536](https://bugzilla.redhat.com/1595536) <b>[RFE] Support VMs with VNC console on a FIPS enabled hypervisor</b><br>When a host is running in FIPS mode, VNC must use SASL authorization instead of regular passwords because of the weak algorithm inherent to the VNC protocol.<br><br>In order to facilitate that process, an Ansible role 'ovirt-host-setup-vnc-sasl' is provided. It must be run manually on all FIPS hosts. The role does the following:<br><br>* creates a (empty) SASL password database<br>* prepares SASL config file for qemu<br>* changes libvirt config file for qemu
 - [BZ 1664490](https://bugzilla.redhat.com/1664490) <b>VM's time and TZ changes to GMT Standard Time after moving VM to another cluster.</b><br>Feature: Previously changing the Cluster of a VM updated the VM Time Zone to its default depending upon the OS Type.<br><br>Reason: In order to make the UI more user friendly it was decided to change this functionality by preserving the VM's Time Zone so that the user can change the Cluster of the VM without also updating the Time Zone manually.<br><br>Result: Changing the Cluster of a VM during editing will now preserve the VM's Time Zone setting.

### Bug Fixes

#### oVirt Engine

 - [BZ 1312909](https://bugzilla.redhat.com/1312909) <b>Live disk migration fails noting "Failed to VmReplicateDiskFinishVDS"</b><br>

### Other

#### oVirt Engine UI Extensions

 - [BZ 1670701](https://bugzilla.redhat.com/1670701) <b>Could not fetch data needed for VM migrate operation</b><br>
 - [BZ 1687645](https://bugzilla.redhat.com/1687645) <b>[RFE] on cluster upgrade, warn the user if the cluster scheduling policy is 'cluster_maintenance'</b><br>

#### oVirt Log Collector

 - [BZ 1680555](https://bugzilla.redhat.com/1680555) <b>use plugin ovirt_node for RHV-H hosts</b><br>

#### oVirt ISO Uploader

 - [BZ 1676713](https://bugzilla.redhat.com/1676713) <b>ovirt-iso-uploader is very slow</b><br>

#### VDSM

 - [BZ 1676893](https://bugzilla.redhat.com/1676893) <b>[RFE] Recognize Windows Server 2019 when using qemu-ga</b><br>Windows 2019 guests running only QEMU Guest Agent were incorrectly reported as Windows 2016. Such guests are now correctly identified in UI.
 - [BZ 1403183](https://bugzilla.redhat.com/1403183) <b>Cloned VMs created from template with "Raw" format are having "Thin Provision" Allocation Policy</b><br>
 - [BZ 1631587](https://bugzilla.redhat.com/1631587) <b>[RFE] Improve vdsm client to add correlation_id</b><br>
 - [BZ 1687832](https://bugzilla.redhat.com/1687832) <b>Memory ballooning VM Stats remain unchanged upon host's memory allocation for when guest OS is RHEL8.</b><br>Memory statistic for guests running only QEMU Guest Agent were not properly reported which caused ballooning to fail and memory consumption was not available in UI. This is now fixed
 - [BZ 1665689](https://bugzilla.redhat.com/1665689) <b>sos plugin is running lvm commands without locking, risking VG metadata corruption</b><br>
 - [BZ 1683967](https://bugzilla.redhat.com/1683967) <b>Attaching network with dhcpv4 ends up as out-of-sync becasue of a IPv6 property</b><br>
 - [BZ 1687032](https://bugzilla.redhat.com/1687032) <b>Bad error handling when writing storage domain metadata may corrupt metadata</b><br>
 - [BZ 1571285](https://bugzilla.redhat.com/1571285) <b>RAW-Preallocated file-based disk convert to raw-sparse after cold migrating it to another storage domain</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1686259](https://bugzilla.redhat.com/1686259) <b>Creation of multiple bricks,one of them being arbiter, on the same disk without dedupe & compression, results in failure</b><br>
 - [BZ 1690756](https://bugzilla.redhat.com/1690756) <b>Insufficient space when creating thick LVs on top of VDO volume in certain way</b><br>
 - [BZ 1577039](https://bugzilla.redhat.com/1577039) <b>The DNS server plus button is still clicked when it displays disabled from cockpit using Chrome</b><br>
 - [BZ 1683318](https://bugzilla.redhat.com/1683318) <b>Incorrect value set for poolmetadatasize</b><br>
 - [BZ 1690160](https://bugzilla.redhat.com/1690160) <b>Hosted-engine-setup fails deploying over an NFS share with a visible IPv6 address</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1392051](https://bugzilla.redhat.com/1392051) <b>[RFE] STIG compliance for RHV-M appliance.</b><br>
 - [BZ 1692460](https://bugzilla.redhat.com/1692460) <b>Let the user specify the host address also deploying from CLI</b><br>
 - [BZ 1690160](https://bugzilla.redhat.com/1690160) <b>Hosted-engine-setup fails deploying over an NFS share with a visible IPv6 address</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1660595](https://bugzilla.redhat.com/1660595) <b>Hosted Engine Deploy fails with SSO authentication errors</b><br>
 - [BZ 1691173](https://bugzilla.redhat.com/1691173) <b>During HE deploy, rhvm-appliance installs even if ova file is presented</b><br>
 - [BZ 1392051](https://bugzilla.redhat.com/1392051) <b>[RFE] STIG compliance for RHV-M appliance.</b><br>

#### oVirt Engine

 - [BZ 1690159](https://bugzilla.redhat.com/1690159) <b>NPE in LibvirtVmXmlBuilder</b><br>
 - [BZ 1668720](https://bugzilla.redhat.com/1668720) <b>[RHV][REST api] Cluster href had changed in RHV-4.3 - It fails for some RHV-4.3 environments the CFME refresh.</b><br>This release ensures the process to provision of a virtual machine from a template completes correctly.
 - [BZ 1663626](https://bugzilla.redhat.com/1663626) <b>[RFE] block simultaneously running cluster upgrades</b><br>
 - [BZ 1644159](https://bugzilla.redhat.com/1644159) <b>Set Preallocated disk to default option in HC environments</b><br>
 - [BZ 1690268](https://bugzilla.redhat.com/1690268) <b>[UI] Uncaught exception occurred on Edit host</b><br>
 - [BZ 1403183](https://bugzilla.redhat.com/1403183) <b>Cloned VMs created from template with "Raw" format are having "Thin Provision" Allocation Policy</b><br>
 - [BZ 1679109](https://bugzilla.redhat.com/1679109) <b>Inappropriate user warnings reported when trying to add more bricks to the existing gluster volume</b><br>
 - [BZ 1676822](https://bugzilla.redhat.com/1676822) <b>cannot change Empty network profile of a running VM</b><br>
 - [BZ 1635337](https://bugzilla.redhat.com/1635337) <b>[Downstream Clone] Cannot assign VM from VmPool: oVirt claims it's already attached but it's not</b><br>
 - [BZ 1600788](https://bugzilla.redhat.com/1600788) <b>Engine allows deleting HE volumes.</b><br>
 - [BZ 1555116](https://bugzilla.redhat.com/1555116) <b>Merge retry validation fails with NPE after previous commit/destroyImage timeout</b><br>
 - [BZ 1552540](https://bugzilla.redhat.com/1552540) <b>Webadmin- misleading error appears trying to extend a disk with MaxBlockDiskSize (8192G) with a value of 1 or more</b><br>
 - [BZ 1692332](https://bugzilla.redhat.com/1692332) <b>virt-v2v: Import from VMware and Xen failed with NPE.</b><br>
 - [BZ 1687645](https://bugzilla.redhat.com/1687645) <b>[RFE] on cluster upgrade, warn the user if the cluster scheduling policy is 'cluster_maintenance'</b><br>
 - [BZ 1692134](https://bugzilla.redhat.com/1692134) <b>[Webadmin] - New virtual disk - Enable incremental backup checkbox is possible although it is not supported</b><br>
 - [BZ 1690833](https://bugzilla.redhat.com/1690833) <b>host is not upgraded when already in maintenance mode</b><br>
 - [BZ 1654889](https://bugzilla.redhat.com/1654889) <b>[RFE] Support console VNC for mediated devices</b><br>
 - [BZ 1571285](https://bugzilla.redhat.com/1571285) <b>RAW-Preallocated file-based disk convert to raw-sparse after cold migrating it to another storage domain</b><br>
 - [BZ 1685818](https://bugzilla.redhat.com/1685818) <b>IPv6 gateway removal from old default route role network alert is shown also for only IPv4 bootproto network</b><br>
 - [BZ 1685110](https://bugzilla.redhat.com/1685110) <b>Error inserting event into audit_log when VM template name is bigger than 40 characters</b><br>

#### oVirt Host Dependencies

 - [BZ 1693279](https://bugzilla.redhat.com/1693279) <b>Require v2v-conversion-host-wrapper on ovirt-host</b><br>

#### oVirt Engine Metrics

 - [BZ 1693296](https://bugzilla.redhat.com/1693296) <b>Unable to Add new Hosts to the Engine</b><br>
 - [BZ 1677246](https://bugzilla.redhat.com/1677246) <b>ovirt-host-deploy-ansible fails on isolated (offline) nodes</b><br>
 - [BZ 1692702](https://bugzilla.redhat.com/1692702) <b>In d/s if user did not set qcow_url then the Centos image instead of RHEL guest image</b><br>
 - [BZ 1677996](https://bugzilla.redhat.com/1677996) <b>Encrypt passwords for Metrics installation</b><br>
 - [BZ 1691363](https://bugzilla.redhat.com/1691363) <b>Curator failes in metrics store installation</b><br>
 - [BZ 1683157](https://bugzilla.redhat.com/1683157) <b>Logging not disabled for sensitive tasks</b><br>
 - [BZ 1690388](https://bugzilla.redhat.com/1690388) <b>Missing IP attribute when creating metrics installer machine</b><br>
 - [BZ 1687492](https://bugzilla.redhat.com/1687492) <b>Metrics installation fails on not provided nic name</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1441741](https://bugzilla.redhat.com/1441741) <b>[Docs][REST][Python][Ruby][Java] v4 API - Document the proper way to retrieve IP-addresses of a VM</b><br>
 - [BZ 1679918](https://bugzilla.redhat.com/1679918) <b>Use print() function in both Python 2 and Python 3</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1684140](https://bugzilla.redhat.com/1684140) <b>Import OVA failed to parse the OVF - Error loading ovf, message Content is not allowed in prolog</b><br>
 - [BZ 1684554](https://bugzilla.redhat.com/1684554) <b>Host activation task gets stuck after many retries</b><br>

#### Contributors

52 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Alexander Wels
	Barak Korren
	Benny Zlotnik
	Bohdan Iakymets
	Carlos Rodrigues
	Dana Elfassy
	Daniel Erez
	David Luong
	Douglas Schilling Landgraf
	Edward Haas
	Eitan Raviv
	Emil Natan
	Eyal Shenitzky
	Fabien Dupont
	Greg Sheremeta
	Ido Rosenzwig
	Kaustav Majumder
	Kobi Hakimi
	MLotton
	Marcin Sobczyk
	Marek Aufart
	Marek Libra
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Soffer
	Ondra Machacek
	Ori_Liel
	Pavel Bar
	Ravi Nori
	Ryan Barry
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shirly Radco
	Shmuel Melamud
	Simone Tiraboschi
	Steven Rosenberg
	Tal Nisan
	Tomasz Baranski
	Tomáš Golembiovský
	Vojtech Juranek
	Vojtech Szocs
	Yadnyawalkya Tale
	Yedidyah Bar David
	Yuval Turgeman
	bond95
	godas
	imjoey
	parthdhanjal
