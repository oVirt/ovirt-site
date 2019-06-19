---
title: oVirt 4.3.5 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.5 Second Release Candidate as of June 19, 2019.

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

To learn about features introduced before 4.3.5, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)


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

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.


## What's New in 4.3.5?

### Release Note

#### oVirt Release Package

 - [BZ 1718162](https://bugzilla.redhat.com/1718162) <b>Switch to glusterfs 6 repositories</b><br>oVirt Release package is now providing repository configuration for Glusterfs 6.<br>You can find more information about how to upgrade gluster to version 6 at https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_6/

### Enhancements

#### oVirt Engine

 - [BZ 1683965](https://bugzilla.redhat.com/1683965) <b>[RFE] Option to create a VM with VNC console and without any USB device</b><br>
 - [BZ 1719735](https://bugzilla.redhat.com/1719735) <b>[downstream clone - 4.3.5] [RFE] Add by default a storage lease to HA VMs</b><br>Feature: When HA is selected for a New VM we now set the Lease Storage Domain to a bootable Storage Domain automatically if the user did not already choose one.<br><br>Reason: To protect new HA VMs with leases when it has a bootable Storage Domain.<br><br>Result: Now a bootable Storage Domain is set as the lease Storage Domain for new HA VMs.
 - [BZ 1717336](https://bugzilla.redhat.com/1717336) <b>[downstream clone - 4.3.5] [RFE] OVF_STORE last update not exposed in the UI</b><br>
 - [BZ 1712353](https://bugzilla.redhat.com/1712353) <b>[downstream clone - 4.3.5] [RFE] Allow Maintenance of Host with Enforcing VM Affinity Rules (hard affinity)</b><br>

#### VDSM

 - [BZ 1715608](https://bugzilla.redhat.com/1715608) <b>[downstream clone - 4.3.5] [RFE] Create a VDSM hook to pass host disks as disk devices (today we support passing them as SCSI-generic devices)</b><br>hostdev_scsi Vdsm hook has been added, to transform some SCSI host devices for better performance.<br><br>See https://github.com/oVirt/vdsm/blob/master/vdsm_hooks/hostdev_scsi/README for more details.

#### oVirt Hosted Engine HA

 - [BZ 1659052](https://bugzilla.redhat.com/1659052) <b>[RFE] Consider alternative to ICMP ping for hosted engine network test</b><br>Feature: Currently the virtualization host checks it's network liveliness by pinging the gateway. Alternative ways of checking network connectivity are added.<br><br>Reason: In some scenarios, the gateway does not reply to ping, e.g. if ping is blocked on network level.<br><br>Result: During the installation of hosted engine, the admin can configure the way the network connectivity is checked. The options to choose are a check if the DNS resolution is working, ping the gateway, TCP connection to a configurable port on a configurable host, or no check at all.<br><br>https://github.com/oVirt/ovirt-site/pull/1985

#### oVirt Hosted Engine Setup

 - [BZ 1659052](https://bugzilla.redhat.com/1659052) <b>[RFE] Consider alternative to ICMP ping for hosted engine network test</b><br>Feature: Currently the virtualization host checks it's network liveliness by pinging the gateway. Alternative ways of checking network connectivity are added.<br><br>Reason: In some scenarios, the gateway does not reply to ping, e.g. if ping is blocked on network level.<br><br>Result: During the installation of hosted engine, the admin can configure the way the network connectivity is checked. The options to choose are a check if the DNS resolution is working, ping the gateway, TCP connection to a configurable port on a configurable host, or no check at all.<br><br>https://github.com/oVirt/ovirt-site/pull/1985

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1710696](https://bugzilla.redhat.com/1710696) <b>[downstream clone - 4.3.5] [RESTAPI] Adding ISO disables serial console</b><br>

### Bug Fixes

#### oVirt Engine

 - [BZ 1638674](https://bugzilla.redhat.com/1638674) <b>[Dalton] Optimize for virt store fails with distribute volume type</b><br>
 - [BZ 1697682](https://bugzilla.redhat.com/1697682) <b>'Error processing event data' errors seen in engine.log</b><br>
 - [BZ 1630824](https://bugzilla.redhat.com/1630824) <b>engine-backup should backup ovirt-provider-ovn</b><br>
 - [BZ 1716951](https://bugzilla.redhat.com/1716951) <b>[downstream clone - 4.3.5] Highly Available (HA) VMs with a VM lease failed to start after a 4.1 to 4.2 upgrade.</b><br>
 - [BZ 1699684](https://bugzilla.redhat.com/1699684) <b>vm_init wiped on cluster level upgrade</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1703678](https://bugzilla.redhat.com/1703678) <b>Passwords saved in clear-text variable files during HE deployment via cockpit-ovirt</b><br>

### Other

#### VDSM JSON-RPC Java

 - [BZ 1710818](https://bugzilla.redhat.com/1710818) <b>Connection to host is stucked and host stays NonResponsive until engine restart</b><br>

#### oVirt Engine

 - [BZ 1715877](https://bugzilla.redhat.com/1715877) <b>[downstream clone - 4.3.5] engine-setup should check for snapshots in unsupported CL</b><br>Now, on upgrade, engine-setup prompts about virtual machines that have snapshots that are incompatible with the version we are going to upgrade to. It's safe to let it proceed, but it's not safe to try using these snapshots after the upgrade, e.g. to preview them.
 - [BZ 1494531](https://bugzilla.redhat.com/1494531) <b>removing datacenter keep nfs mounted</b><br>
 - [BZ 1648623](https://bugzilla.redhat.com/1648623) <b>[UI] Warn that bond names >10 may explode with vlan</b><br>
 - [BZ 1716932](https://bugzilla.redhat.com/1716932) <b>NPE Failed to build cloud-init data when initialization object not provided</b><br>
 - [BZ 1717538](https://bugzilla.redhat.com/1717538) <b>[CodeChange][i18n] oVirt 4.3 webadmin - revert pt-BR translations</b><br>
 - [BZ 1651874](https://bugzilla.redhat.com/1651874) <b>Live merge failed with NPE on endAction of DestroyImage</b><br>
 - [BZ 1713371](https://bugzilla.redhat.com/1713371) <b>Attempting to endAction 'RemoveVm' throws ConcurrentModificationException.</b><br>
 - [BZ 1537464](https://bugzilla.redhat.com/1537464) <b>[UI] Unexpected exception: 'b is null' appears in Events window, when using "Host -> Management -> Configure Local Storage" window</b><br>
 - [BZ 1683363](https://bugzilla.redhat.com/1683363) <b>[UI] Long network names cause VM network interface new/edit window to deform</b><br>
 - [BZ 1700413](https://bugzilla.redhat.com/1700413) <b>Rename *Routing Prefix* to *Routing Prefix Length*</b><br>
 - [BZ 1718177](https://bugzilla.redhat.com/1718177) <b>Token based Userinfo API is giving Internal Server Error.</b><br>
 - [BZ 1664338](https://bugzilla.redhat.com/1664338) <b>Live storage migration fails during diskReplicateStart with VolumeDoesNotExist for the new snapshot created on the target domain</b><br>
 - [BZ 1696621](https://bugzilla.redhat.com/1696621) <b>NPE when migrating a VM with missing CPU load</b><br>
 - [BZ 1707372](https://bugzilla.redhat.com/1707372) <b>Upload Disk Snapshots problems with iSCSI storage and python SDK</b><br>
 - [BZ 1714587](https://bugzilla.redhat.com/1714587) <b>Able to delete VM snapshot even though rhv console shows image is locked</b><br>
 - [BZ 1688264](https://bugzilla.redhat.com/1688264) <b>[RFE] console.vv: add minimal version for rhel8 virt-viewer</b><br>
 - [BZ 1702230](https://bugzilla.redhat.com/1702230) <b>Converge content type filters in main disk tab</b><br>
 - [BZ 1716367](https://bugzilla.redhat.com/1716367) <b>[downstream clone - 4.3.5] [UI] add a tooltip to explain the supported matrix for the combination of disk allocation policies, formats and the combination result</b><br>
 - [BZ 1710818](https://bugzilla.redhat.com/1710818) <b>Connection to host is stucked and host stays NonResponsive until engine restart</b><br>

#### VDSM

 - [BZ 1690020](https://bugzilla.redhat.com/1690020) <b>Incorrect I/O when reading and writing OVF disks</b><br>
 - [BZ 1715026](https://bugzilla.redhat.com/1715026) <b>[downstream clone - 4.3.5] After live merge, top volume still has INTERNAL volume type due to unable to read lvm metadata properly</b><br>
 - [BZ 1719125](https://bugzilla.redhat.com/1719125) <b>[downstream clone - 4.3.5] lshw can take more than 15 seconds to execute depending on the system</b><br>
 - [BZ 1703132](https://bugzilla.redhat.com/1703132) <b>Prevent ABRT on RHVH nodes "phoning home" (contacting redhat.com) either in all cases or only by explicit approval, never do so by default.</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1715080](https://bugzilla.redhat.com/1715080) <b>Wrong port ":-1" being reported several times, while running "hosted-engine --add-console-password"</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1698643](https://bugzilla.redhat.com/1698643) <b>can't deploy hosted-engine when eth0 and the default libvirt network try to use the same subnet</b><br>

#### Contributors

31 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Krejcir
	Benny Zlotnik
	Dan Kenigsberg
	Dana Elfassy
	Daniel Erez
	Dominik Holler
	Eyal Shenitzky
	Francesco Romani
	Ido Rosenzwig
	Lucia Jelinkova
	Marcin Sobczyk
	Martin Nečas
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Soffer
	Ondra Machacek
	Piotr Kliczewski
	Sahina Bose
	Sandro Bonazzola
	Scott J Dickerson
	Shani Leviim
	Simone Tiraboschi
	Steven Rosenberg
	Tal Nisan
	Tomasz Baranski
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
