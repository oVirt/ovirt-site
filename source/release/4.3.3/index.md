---
title: oVirt 4.3.3 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.3.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.3 release as of April 16, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.3, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



If you are upgrading from older versions please upgrade to 4.2.8 before upgrading to 4.3.3

If you're upgrading from oVirt Engine 4.2.8 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup

If you're upgrading from oVirt Node NG 4.2 you just need to execute:

      # yum install https://resources.ovirt.org/pub/ovirt-4.3/rpm/el7/noarch/ovirt-node-ng-image-update-4.3.3-1.el7.noarch.rpm
      # reboot

If you're upgrading from oVirt Node NG 4.3 please use oVirt Engine Administration portal for handling the upgrade.




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

#### VDSM

 - [BZ 1631587](https://bugzilla.redhat.com/1631587) <b>[RFE] Improve vdsm client to add correlation_id</b><br>In this release, the Correlation-Id can be passed to the vdsm-client by using the '--flow-id' argument with the vdsm-client tool.

#### oVirt Engine

 - [BZ 1664490](https://bugzilla.redhat.com/1664490) <b>VM's time and TZ changes to GMT Standard Time after moving VM to another cluster.</b><br>This release enhancement preserves a virtual machine's time zone setting of a virtual machine when moving the virtual machine from one cluster to a different cluster.

#### oVirt Host Dependencies

 - [BZ 1693279](https://bugzilla.redhat.com/1693279) <b>Require v2v-conversion-host-wrapper on ovirt-host</b><br>v2v-conversion-host-wrapper is now installed by default on hypervisor hosts

### Bug Fixes

#### oVirt Cockpit Plugin

 - [BZ 1622550](https://bugzilla.redhat.com/1622550) <b>cockpit-wizard doesn't show a proper error message when no available valid interfaces are present on the host</b><br>
 - [BZ 1693257](https://bugzilla.redhat.com/1693257) <b>Setup wizard: Deployment can be started even if values are missing or incorrect</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1694034](https://bugzilla.redhat.com/1694034) <b>Hosted engine deploy failed with RHVH STIG security profile</b><br>
 - [BZ 1660595](https://bugzilla.redhat.com/1660595) <b>Hosted Engine Deploy fails with SSO authentication errors</b><br>
 - [BZ 1691173](https://bugzilla.redhat.com/1691173) <b>During HE deploy, rhvm-appliance installs even if ova file is presented</b><br>

#### oVirt Engine

 - [BZ 1686537](https://bugzilla.redhat.com/1686537) <b>Migration of VM with 'Pass-Through host CPU' results with VM's Pause state and exception on the following attempt to run.</b><br>
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
 - [BZ 1403183](https://bugzilla.redhat.com/1403183) <b>Cloned VMs created from template with "Raw" format are having "Thin Provision" Allocation Policy</b><br>This release ensures that virtual machines with file-based storage created from a template where the Resource Allocation > Storage Allocation > Clone > Format setting is set to Raw results in virtual machines having an Allocation Policy set to "Preallocated."
 - [BZ 1696968](https://bugzilla.redhat.com/1696968) <b>Activating a Pre 4.1(V3) ANY(ISCSI,NFS,gluster,fcp) storage domain failes - VDSM formatconverter.py", line 432, in _getConverter     return self._convTable[(sourceFormat, targetFormat)] KeyError: ('3', '5')</b><br>
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

 - [BZ 1686445](https://bugzilla.redhat.com/1686445) <b>hosted-engine deploy (restore-from-file) fails if certificates are not up to date in backup file.</b><br>hosted-engine deploy (restore-from-file) was failing if certificates in backup file are not up to date or expiring.<br>Optionally renew them at restore time to be able to complete the process.
 - [BZ 1692460](https://bugzilla.redhat.com/1692460) <b>Let the user specify the host address also deploying from CLI</b><br>
 - [BZ 1690160](https://bugzilla.redhat.com/1690160) <b>Hosted-engine-setup fails deploying over an NFS share with a visible IPv6 address</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1696229](https://bugzilla.redhat.com/1696229) <b>ovirt-ansible-hosted-engine-setup is not clearing a leftover local maintenance mode from a previous deployment on the same host</b><br>

#### oVirt Engine

 - [BZ 1690159](https://bugzilla.redhat.com/1690159) <b>NPE in LibvirtVmXmlBuilder</b><br>
 - [BZ 1696174](https://bugzilla.redhat.com/1696174) <b>Cloned VMs created from template with "Raw" format and "sparse" type on NFS are having "Preallocated" allocation policy</b><br>
 - [BZ 1672859](https://bugzilla.redhat.com/1672859) <b>Cannot correctly upgrade an hosted engine env from 4.2 to 4.3 if the specific CPU type disappeared in 4.3</b><br>
 - [BZ 1613833](https://bugzilla.redhat.com/1613833) <b>[RFE] - Use SHA256 for engine-backup</b><br>
 - [BZ 1668720](https://bugzilla.redhat.com/1668720) <b>[RHV][REST api] Cluster href had changed in RHV-4.3 - It fails for some RHV-4.3 environments the CFME refresh.</b><br>This release ensures the process to provision of a virtual machine from a template completes correctly.
 - [BZ 1663626](https://bugzilla.redhat.com/1663626) <b>[RFE] block simultaneously running cluster upgrades</b><br>
 - [BZ 1644159](https://bugzilla.redhat.com/1644159) <b>Set Preallocated disk to default option in HC environments</b><br>
 - [BZ 1690268](https://bugzilla.redhat.com/1690268) <b>[UI] Uncaught exception occurred on Edit host</b><br>
 - [BZ 1403183](https://bugzilla.redhat.com/1403183) <b>Cloned VMs created from template with "Raw" format are having "Thin Provision" Allocation Policy</b><br>This release ensures that virtual machines with file-based storage created from a template where the Resource Allocation > Storage Allocation > Clone > Format setting is set to Raw results in virtual machines having an Allocation Policy set to "Preallocated."
 - [BZ 1679109](https://bugzilla.redhat.com/1679109) <b>Inappropriate user warnings reported when trying to add more bricks to the existing gluster volume</b><br>
 - [BZ 1676822](https://bugzilla.redhat.com/1676822) <b>Cannot change Empty network profile of a running VM(default MTU)</b><br>
 - [BZ 1600788](https://bugzilla.redhat.com/1600788) <b>Engine allows deleting HE volumes.</b><br>This release provides a check to evaluate self-hosted engine volumes prior to deleting the self-hosted engine volumes.
 - [BZ 1698948](https://bugzilla.redhat.com/1698948) <b>Error during UI action displays a dialog that the request to the server failed with error code 500</b><br>
 - [BZ 1586126](https://bugzilla.redhat.com/1586126) <b>After upgrade to RHV  hosts can no longer be set into maintenance mode.</b><br>This release ensures that hosts can be set to maintenance mode after upgrading Red Hat Virtualization from 4.1 to 4.2.3.
 - [BZ 1692332](https://bugzilla.redhat.com/1692332) <b>virt-v2v: Import from VMware and Xen failed with NPE.</b><br>
 - [BZ 1694740](https://bugzilla.redhat.com/1694740) <b>Hosted Engine disks content types are showing unlocalized in the disks tab</b><br>
 - [BZ 1693191](https://bugzilla.redhat.com/1693191) <b>Snapshot creation might fail due to a transaction timeout if takes too long to process the reply from vdsm</b><br>
 - [BZ 1555116](https://bugzilla.redhat.com/1555116) <b>Merge retry validation fails with NPE after previous commit/destroyImage timeout</b><br>
 - [BZ 1552540](https://bugzilla.redhat.com/1552540) <b>Webadmin- misleading error appears trying to extend a disk with MaxBlockDiskSize (8192G) with a value of 1 or more</b><br>
 - [BZ 1687645](https://bugzilla.redhat.com/1687645) <b>[RFE] on cluster upgrade, warn the user if the cluster scheduling policy is 'cluster_maintenance'</b><br>
 - [BZ 1692134](https://bugzilla.redhat.com/1692134) <b>[Webadmin] - New virtual disk - Enable incremental backup checkbox is possible although it is not supported</b><br>
 - [BZ 1690833](https://bugzilla.redhat.com/1690833) <b>host is not upgraded when already in maintenance mode</b><br>
 - [BZ 1571285](https://bugzilla.redhat.com/1571285) <b>RAW-Preallocated file-based disk convert to raw-sparse after cold migrating it to another storage domain</b><br>
 - [BZ 1685818](https://bugzilla.redhat.com/1685818) <b>IPv6 gateway removal from old default route role network alert is shown also for only IPv4 bootproto network</b><br>
 - [BZ 1685110](https://bugzilla.redhat.com/1685110) <b>Error inserting event into audit_log when VM template name is bigger than 40 characters</b><br>

#### oVirt Ansible cluster upgrade role

 - [BZ 1689949](https://bugzilla.redhat.com/1689949) <b>instead of "Hosts [] will be updated in cluster xy" should be "Hosts [] are marked to be updated in cluster xy"</b><br>

#### imgbased

 - [BZ 1693710](https://bugzilla.redhat.com/1693710) <b>katello.facts gets invalid hostname while updating RHV hypervisor</b><br>
 - [BZ 1674265](https://bugzilla.redhat.com/1674265) <b>Can't use AMD EPYC IBPD SSBD on 4.3 upgrade without clearing libvirt cache</b><br>

#### oVirt Engine Metrics

 - [BZ 1693560](https://bugzilla.redhat.com/1693560) <b>Initial validations fail on Set fluentd_base_packages_available fact</b><br>
 - [BZ 1693569](https://bugzilla.redhat.com/1693569) <b>Missing variable when trying to install the metrics store machine</b><br>
 - [BZ 1693296](https://bugzilla.redhat.com/1693296) <b>Unable to Add new Hosts to the Engine</b><br>
 - [BZ 1677246](https://bugzilla.redhat.com/1677246) <b>ovirt-host-deploy-ansible fails on isolated (offline) nodes</b><br>
 - [BZ 1692702](https://bugzilla.redhat.com/1692702) <b>In d/s if user did not set qcow_url then the Centos image instead of RHEL guest image</b><br>
 - [BZ 1677996](https://bugzilla.redhat.com/1677996) <b>Encrypt passwords for Metrics installation</b><br>
 - [BZ 1691363](https://bugzilla.redhat.com/1691363) <b>Curator failes in metrics store installation</b><br>
 - [BZ 1697521](https://bugzilla.redhat.com/1697521) <b>When installing metrics-store the playbook fails on generate vars.yaml task</b><br>
 - [BZ 1690388](https://bugzilla.redhat.com/1690388) <b>Missing IP attribute when creating metrics installer machine</b><br>
 - [BZ 1687492](https://bugzilla.redhat.com/1687492) <b>Metrics installation fails on not provided nic name</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1441741](https://bugzilla.redhat.com/1441741) <b>[Docs][REST][Python][Ruby][Java] v4 API - Document the proper way to retrieve IP-addresses of a VM</b><br>
 - [BZ 1679918](https://bugzilla.redhat.com/1679918) <b>Use print() function in both Python 2 and Python 3</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1684140](https://bugzilla.redhat.com/1684140) <b>Import OVA failed to parse the OVF - Error loading ovf, message Content is not allowed in prolog</b><br>
 - [BZ 1697232](https://bugzilla.redhat.com/1697232) <b>Extend length of value columns in vdc_options table</b><br>
 - [BZ 1684554](https://bugzilla.redhat.com/1684554) <b>Host activation task gets stuck after many retries</b><br>

#### Contributors

65 people contributed to this release:

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
	Denis Chaplygin
	Douglas Schilling Landgraf
	Edward Haas
	Eitan Raviv
	Emil Natan
	Eyal Shenitzky
	Fabien Dupont
	Fred Rolland
	Greg Sheremeta
	Ido Rosenzwig
	Jiri Macku
	Joey
	Juan Hernandez
	Kaustav Majumder
	Ken Schmidt
	Kobi Hakimi
	Lars Seipel
	MLotton
	Marcin Sobczyk
	Marek Aufart
	Marek Libra
	Martin Perina
	Michal Skrivanek
	Michele Zuccala
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
	Sharon Gratch
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
	fdupont-redhat
	godas
	imjoey
	irosenzw
	iterjpnic
	jenkins CI
	parthdhanjal
