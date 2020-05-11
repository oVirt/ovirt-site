---
title: oVirt 4.3.2 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 4.3.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.2 release as of March 19, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.2, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



If you are upgrading from older versions please upgrade to 4.2.8 before upgrading to 4.3.2

If you're upgrading from oVirt Engine 4.2.8 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup

If you're upgrading from oVirt Node NG 4.2 you just need to execute:

      # yum install https://resources.ovirt.org/pub/ovirt-4.3/rpm/el7/noarch/ovirt-node-ng-image-update-4.3.2-1.el7.noarch.rpm
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
[Upgrade Guide](/documentation/upgrade_guide/).

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



## What's New in 4.3.2?

### Release Note

#### oVirt Engine WildFly

 - [BZ 1671635](https://bugzilla.redhat.com/1671635) <b>Bump requirements to WildFly 15</b><br>oVirt now requires WildFly version 15.0.1 or later.

#### oVirt Engine

 - [BZ 1671635](https://bugzilla.redhat.com/1671635) <b>Bump requirements to WildFly 15</b><br>oVirt now requires WildFly version 15.0.1 or later.

### Enhancements

#### oVirt Engine Extension AAA-JDBC

 - [BZ 1619391](https://bugzilla.redhat.com/1619391) <b>ovirt-aaa-jdbc-tool detailed logging for users</b><br>This releases ensures the invocation of the ovirt-aaa-jdbc-tool logs the following three events to the syslog server: the user invoking ovirt-aaa-jdbc-tool; the parameters passed to ovirt-aaa-jdbc-tool, with the exception to filter passwords; and whether the invocation of the ovirt-aaa-jdbc-tool was successful.

#### oVirt Engine

 - [BZ 1656794](https://bugzilla.redhat.com/1656794) <b>Disable the ability to remove permissions to Everyone</b><br>This release disables the "Remove" button on the Everyone permissions page to prevent misconfiguring Red Hat Virtualization Manager permissions.

### Removed functionality

#### oVirt Engine

 - [BZ 1661823](https://bugzilla.redhat.com/1661823) <b>Snapshot creation for a VM with disks on iSCSI domain fails with NullPointerException in case an NFS domain in the DC becomes unreachable</b><br>

### Bug Fixes

#### oVirt Release Package

 - [BZ 1685203](https://bugzilla.redhat.com/1685203) <b>Missing dependency gluster-ansible</b><br>

#### oVirt Engine

 - [BZ 1291789](https://bugzilla.redhat.com/1291789) <b>ovirt-engine-rename tool uses hard-coded ca.crt</b><br>
 - [BZ 1314959](https://bugzilla.redhat.com/1314959) <b>Keep thin provisioning when migrating from thin provisioned glusterfs to iSCSI</b><br>
 - [BZ 1666958](https://bugzilla.redhat.com/1666958) <b>[SR-IOV] - Validate the update of SR-IOV vNIC profile with another SR-IOV vNIC profile while the VM's nic is plugged</b><br>
 - [BZ 1687301](https://bugzilla.redhat.com/1687301) <b>For verifying ovirt-imageio-proxy cert, engine uses internal truststore instead of https one</b><br>
 - [BZ 1552533](https://bugzilla.redhat.com/1552533) <b>change MaxBlockDiskSize to a more clear value as MaxBlockDiskSizeInGigaBytes or MaxBlockDiskSizeInGigiBytes</b><br>
 - [BZ 1654442](https://bugzilla.redhat.com/1654442) <b>"GET_ALL_VNIC_PROFILES failed query execution failed due to insufficient permissions." messages when user logs into VM Portal</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1650177](https://bugzilla.redhat.com/1650177) <b>During engine-setup (as past of engine update), ImageProxyAddress doesn't get updated with the engine FQDN</b><br>

### Other

#### VDSM

 - [BZ 1666795](https://bugzilla.redhat.com/1666795) <b>VMs migrated to 4.3 are missing the appropriate virt XML for dynamic ownership, and are reset to root:root, preventing them from starting</b><br>
 - [BZ 1684267](https://bugzilla.redhat.com/1684267) <b>Vdsm return GeneralError and log a traceback when a lease does not exit</b><br>
 - [BZ 1678373](https://bugzilla.redhat.com/1678373) <b>Vdsm creates unaligned memory metadata volumes</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1629543](https://bugzilla.redhat.com/1629543) <b>The LV size should be equal to the logical size on VDO enabled volumes</b><br>
 - [BZ 1683366](https://bugzilla.redhat.com/1683366) <b>Hosted Engine setup fails on storage selection - Retrieval of iSCSI targets failed.</b><br>
 - [BZ 1641534](https://bugzilla.redhat.com/1641534) <b>Single-node deploy UI shows replica type but creates dist</b><br>
 - [BZ 1680551](https://bugzilla.redhat.com/1680551) <b>Successful gluster deployment message is displayed when an ansible syntax error is encountered.</b><br>
 - [BZ 1683200](https://bugzilla.redhat.com/1683200) <b>SELinux labels are missing on the gluster bricks created using gluster-ansible-roles</b><br>

#### oVirt Engine Extension AAA-JDBC

 - [BZ 1685968](https://bugzilla.redhat.com/1685968) <b>ovirt-aaa-jdbc-tool return code 0 on failure</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1455440](https://bugzilla.redhat.com/1455440) <b>Add information about LDAP server, which we failed connect to, to ease problem investigation</b><br>
 - [BZ 1618699](https://bugzilla.redhat.com/1618699) <b>ovirt-engine-extension-aaa-ldap-setup fails with UnicodeDecodeError</b><br>
 - [BZ 1532568](https://bugzilla.redhat.com/1532568) <b>Authentication provider does not recover during runtime</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1684195](https://bugzilla.redhat.com/1684195) <b>[RFE] Add summary section at the end of the log files</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1594597](https://bugzilla.redhat.com/1594597) <b>hosted-engine deploy fails when root password starts with #</b><br>
 - [BZ 1678693](https://bugzilla.redhat.com/1678693) <b>[RFE] Share ssh sessions in ansible role</b><br>

#### oVirt Engine

 - [BZ 1666795](https://bugzilla.redhat.com/1666795) <b>VMs migrated to 4.3 are missing the appropriate virt XML for dynamic ownership, and are reset to root:root, preventing them from starting</b><br>
 - [BZ 1679399](https://bugzilla.redhat.com/1679399) <b>RHV upgrade from 4.2 to 4.3 fails in RHHI-V environment</b><br>
 - [BZ 1670715](https://bugzilla.redhat.com/1670715) <b>[UI] - IPv6 subnet - Validate input and create IPv6 subnet</b><br>
 - [BZ 1645229](https://bugzilla.redhat.com/1645229) <b>Export as ova fails in oVirt-engine</b><br>
 - [BZ 1676405](https://bugzilla.redhat.com/1676405) <b>Use ansible modules rather than gdeploy modules in brick creation flow from RHV-M</b><br>
 - [BZ 1679158](https://bugzilla.redhat.com/1679158) <b>[REST] Fix Link To Network Under Cluster</b><br>
 - [BZ 1678113](https://bugzilla.redhat.com/1678113) <b>'postgresql-setup initdb' is obsolete</b><br>
 - [BZ 1659099](https://bugzilla.redhat.com/1659099) <b>[UI] Can't see the whole IPv6 address</b><br>
 - [BZ 1684113](https://bugzilla.redhat.com/1684113) <b>Failed to start VM with LibVirtError "Failed to acquire lock: No space left on device" (code=1)</b><br>
 - [BZ 1589665](https://bugzilla.redhat.com/1589665) <b>WebAdmin: Upload image dialog - not informative enough when image is too small</b><br>
 - [BZ 1656752](https://bugzilla.redhat.com/1656752) <b>we do not run pyflakes on fedora</b><br>
 - [BZ 1368457](https://bugzilla.redhat.com/1368457) <b>Adding a new host to the gluster cluster, should not show up virt node related tabs</b><br>
 - [BZ 1403161](https://bugzilla.redhat.com/1403161) <b>Missing <certificate> node in ovirt-engine/api/vms/$vmid</b><br>
 - [BZ 1657977](https://bugzilla.redhat.com/1657977) <b>[UI] Gray out multiQueues check box in Instance Types 'New/Edit' option - make it clear that enabled by default</b><br>
 - [BZ 1677426](https://bugzilla.redhat.com/1677426) <b>[vNIC Profiles main tab] -  Port mirroring, passthrough and migratable properties are grayed out if the first network in the DC(alphabetic) is an external network</b><br>
 - [BZ 1684586](https://bugzilla.redhat.com/1684586) <b>[work around] engine-setup fails upgrading due constraint violations</b><br>
 - [BZ 1616442](https://bugzilla.redhat.com/1616442) <b>[UI] Disks representation in snapshots tab should be in rows</b><br>
 - [BZ 1673442](https://bugzilla.redhat.com/1673442) <b>Storage domain discard_after_delete default value it true, should be false</b><br>
 - [BZ 1530984](https://bugzilla.redhat.com/1530984) <b>No error event(UI)/auditlog(engine.log) is given after template import fails due to faulty glance server</b><br>
 - [BZ 1653752](https://bugzilla.redhat.com/1653752) <b>Scheduler computes incorrect CPU load of the host where the scheduled VM is running</b><br>
 - [BZ 1678200](https://bugzilla.redhat.com/1678200) <b>Q35: Cloned VM with Q35 chipset, failed to run (PCI controller model is null instead of pcie-root).</b><br>
 - [BZ 1659806](https://bugzilla.redhat.com/1659806) <b>Moving storage domain to maintenance during disk upload/download is allowed</b><br>
 - [BZ 1672065](https://bugzilla.redhat.com/1672065) <b>[cinderlib] - Add managed SD on HP3PAR fails with : [CinderlibExecutor]cinderlib output: /usr/lib/python2.7/site-packages/paramiko/kex_ecdh_nist.py:39: CryptographyDeprecationWarning: encode_point has been deprecated</b><br>
 - [BZ 1636331](https://bugzilla.redhat.com/1636331) <b>Return error when attempting to update disk from /api/disks/{disk_id}</b><br>
 - [BZ 1683955](https://bugzilla.redhat.com/1683955) <b>[UI] - "Host has no default route." exclamation icon consistently shown for all hosts under general sub tab</b><br>
 - [BZ 1669830](https://bugzilla.redhat.com/1669830) <b>[cinderlib] create known_hosts file for drivers which require it</b><br>
 - [BZ 1673035](https://bugzilla.redhat.com/1673035) <b>[cinderlib] Support snapshot operations</b><br>
 - [BZ 1679242](https://bugzilla.redhat.com/1679242) <b>engine-setup should not refer to cinderlib feature page</b><br>
 - [BZ 1683523](https://bugzilla.redhat.com/1683523) <b>ipv6 gateway removal from old default route role network - move message from alerts tab to main events tab</b><br>
 - [BZ 1680577](https://bugzilla.redhat.com/1680577) <b>engine-setup on a separate dwh machine fails due to missing cinderlib constants</b><br>
 - [BZ 1671564](https://bugzilla.redhat.com/1671564) <b>After upgrade to 4.2.8, Console Client Resources page doesn't look as expected</b><br>
 - [BZ 1676443](https://bugzilla.redhat.com/1676443) <b>add more informative error when session limit exceeded for the user</b><br>
 - [BZ 1654603](https://bugzilla.redhat.com/1654603) <b>[UI] SRIOV unmanaged networks cause setup networks window to not populate</b><br>
 - [BZ 1673028](https://bugzilla.redhat.com/1673028) <b>[cinderlib] Support live vm migration</b><br>
 - [BZ 1400351](https://bugzilla.redhat.com/1400351) <b>GetAllVmStatsVDS returns java.lang.InterruptedException when connection to router is lost</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1576500](https://bugzilla.redhat.com/1576500) <b>StreamingAPI - Transfer disk paused by system as adding a new ticket failed due proxy error  PUT /tickets/: [500] _strptime_time</b><br>

### No Doc Update

#### oVirt Cockpit Plugin

 - [BZ 1679873](https://bugzilla.redhat.com/1679873) <b>The linked documents on hosted engine page in cockpit UI are still 4.2 version</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1533575](https://bugzilla.redhat.com/1533575) <b>[RFE][Text] Provide example for mounting options during Node Zero deployment in otopi dialog syntax.</b><br>

#### oVirt Engine

 - [BZ 1642872](https://bugzilla.redhat.com/1642872) <b>a role with just VM/Basic Operations/* can delete VM's disk</b><br>
 - [BZ 1672860](https://bugzilla.redhat.com/1672860) <b>Whenever a new user clicks on the admin or user portal link to login before being granted system permission, a new entry with their name appears in the user list, one for each click</b><br>
 - [BZ 1589512](https://bugzilla.redhat.com/1589512) <b>[RFE] display all errors at once when  upgrading cluster compatibility level</b><br>

#### Contributors

53 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Krejcir
	Asaf Rachmani
	Benny Zlotnik
	Bohdan Iakymets
	Christophe Aubry
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Eitan Raviv
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Greg Sheremeta
	Ido Rosenzwig
	Kaustav Majumder
	Leif Madsen
	Marcin Sobczyk
	Martin Nečas
	Martin Perina
	Matt Williams
	Michal Skrivanek
	Milan Zamazal
	Nir Levy
	Nir Soffer
	Ondra Machacek
	Ori_Liel
	Pavel Bar
	Petr Balogh
	Ravi Nori
	Roman Hodain
	Roy Golan
	Ryan Barry
	Sahina Bose
	Sandro Bonazzola
	Shani Leviim
	Sharon Gratch
	Shmuel Melamud
	Simone Tiraboschi
	Steven Rosenberg
	Tomasz Baranski
	Tomasz Barański
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	Yuval Turgeman
	emesika
	fdupont-redhat
	godas
	kobihk
	parthdhanjal
