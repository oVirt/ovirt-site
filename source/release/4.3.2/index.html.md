---
title: oVirt 4.3.2 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.2 First Release Candidate as of March 05, 2019.

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

To learn about features introduced before 4.3.2, see the [release notes for previous versions](/documentation/#previous-release-notes).


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



## What's New in 4.3.2?

### Release Note

#### oVirt Engine WildFly

 - [BZ 1671635](https://bugzilla.redhat.com/1671635) <b>Bump requirements to WildFly 15</b><br>oVirt 4.3.1 is now using WildFly 15.0.1

#### oVirt Engine

 - [BZ 1671635](https://bugzilla.redhat.com/1671635) <b>Bump requirements to WildFly 15</b><br>oVirt 4.3.1 is now using WildFly 15.0.1
 - [BZ 1403674](https://bugzilla.redhat.com/1403674) <b>[IPv6] - allow and enable display network with only ipv6 boot protocol</b><br>Setting a display network and opening a console to a VM is now possible over an IPv6 only network

### Enhancements

#### oVirt Engine Extension AAA-JDBC

 - [BZ 1619391](https://bugzilla.redhat.com/1619391) <b>ovirt-aaa-jdbc-tool detailed logging for users</b><br>Each invocation of ovirt-aaa-jdbc-tool is no logged to syslog with following information:<br><br>1. User who invoked the tool<br>2. All parameters passed to ovirt-aaa-jdbc-tool (passwords are filtered)<br>3. Result of the invocation (success or failure)

#### oVirt Engine

 - [BZ 1656794](https://bugzilla.redhat.com/1656794) <b>Disable the ability to remove permissions to Everyone</b><br>Feature: 'remove' button is disabled on the Everyone permissions page<br><br>Reason: avoid mistakes which might lead to unrecoverable corrupted engine permissions<br><br>Result: 'remove' button is disabled on Everyone permissions page (the ability to add permissions stays the same)

### Bug Fixes

#### oVirt Engine

 - [BZ 1666958](https://bugzilla.redhat.com/1666958) <b>[SR-IOV] - Validate the update of SR-IOV vNIC profile with another SR-IOV vNIC profile while the VM's nic is plugged</b><br>
 - [BZ 1654442](https://bugzilla.redhat.com/1654442) <b>"GET_ALL_VNIC_PROFILES failed query execution failed due to insufficient permissions." messages when user logs into VM Portal</b><br>
 - [BZ 1655911](https://bugzilla.redhat.com/1655911) <b>guest pinned to hostA is show as up on both host after migration to hostB</b><br>

### Other

#### oVirt Guest Agent

 - [BZ 1656346](https://bugzilla.redhat.com/1656346) <b>Get wrong "os-version" for win2019 guest via RHEV Agent</b><br>

#### VDSM

 - [BZ 1666795](https://bugzilla.redhat.com/1666795) <b>VMs migrated to 4.3 are missing the appropriate virt XML for dynamic ownership, and are reset to root:root, preventing them from starting</b><br>
 - [BZ 1678373](https://bugzilla.redhat.com/1678373) <b>Vdsm creates unaligned memory metadata volumes</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1683366](https://bugzilla.redhat.com/1683366) <b>Hosted Engine setup fails on storage selection - Retrieval of iSCSI targets failed.</b><br>
 - [BZ 1683200](https://bugzilla.redhat.com/1683200) <b>SELinux labels are missing on the gluster bricks created using gluster-ansible-roles</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1455440](https://bugzilla.redhat.com/1455440) <b>Add information about LDAP server, which we failed connect to, to ease problem investigation</b><br>
 - [BZ 1618699](https://bugzilla.redhat.com/1618699) <b>ovirt-engine-extension-aaa-ldap-setup fails with UnicodeDecodeError</b><br>
 - [BZ 1532568](https://bugzilla.redhat.com/1532568) <b>Authentication provider does not recover during runtime</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1684195](https://bugzilla.redhat.com/1684195) <b>[RFE] Add summary section at the end of the log files</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1678693](https://bugzilla.redhat.com/1678693) <b>[RFE] Share ssh sessions in ansible role</b><br>

#### oVirt Release Package

 - [BZ 1685203](https://bugzilla.redhat.com/1685203) <b>Missing dependency gluster-ansible</b><br>

#### oVirt Engine

 - [BZ 1670715](https://bugzilla.redhat.com/1670715) <b>[UI] - IPv6 subnet - Validate input and create IPv6 subnet</b><br>
 - [BZ 1679158](https://bugzilla.redhat.com/1679158) <b>[REST] Fix Link To Network Under Cluster</b><br>
 - [BZ 1678113](https://bugzilla.redhat.com/1678113) <b>'postgresql-setup initdb' is obsolete</b><br>
 - [BZ 1659099](https://bugzilla.redhat.com/1659099) <b>[UI] Can't see the whole IPv6 address</b><br>
 - [BZ 1657977](https://bugzilla.redhat.com/1657977) <b>[UI] multiQueuesLabel and multiQueuesInfo is shown in Instance Types 'New/Edit' option</b><br>
 - [BZ 1677426](https://bugzilla.redhat.com/1677426) <b>[vNIC Profiles main tab] -  Port mirroring, passthrough and migratable properties are grayed out if the first network in the DC(alphabetic) is an external network</b><br>
 - [BZ 1683955](https://bugzilla.redhat.com/1683955) <b>[UI] - "Host has no default route." exclamation icon consistently shown for all hosts under general sub tab</b><br>
 - [BZ 1669830](https://bugzilla.redhat.com/1669830) <b>[cinderlib] create known_hosts file for drivers which require it</b><br>
 - [BZ 1683523](https://bugzilla.redhat.com/1683523) <b>ipv6 gateway removal from old default route role network - move message from alerts tab to main events tab</b><br>
 - [BZ 1680577](https://bugzilla.redhat.com/1680577) <b>engine-setup on a separate dwh machine fails due to missing cinderlib constants</b><br>
 - [BZ 1671564](https://bugzilla.redhat.com/1671564) <b>After upgrade to 4.2.8, Console Client Resources page doesn't look as expected</b><br>
 - [BZ 1676443](https://bugzilla.redhat.com/1676443) <b>add more informative error when session limit exceeded for the user</b><br>
 - [BZ 1654603](https://bugzilla.redhat.com/1654603) <b>[UI] SRIOV unmanaged networks cause setup networks window to not populate</b><br>
 - [BZ 1400351](https://bugzilla.redhat.com/1400351) <b>GetAllVmStatsVDS returns java.lang.InterruptedException when connection to router is lost</b><br>

### No Doc Update

#### oVirt Hosted Engine Setup

 - [BZ 1533575](https://bugzilla.redhat.com/1533575) <b>[RFE][Text] Provide example for mounting options during Node Zero deployment in otopi dialog syntax.</b><br>

#### oVirt Engine

 - [BZ 1589512](https://bugzilla.redhat.com/1589512) <b>[RFE] display all errors at once when  upgrading cluster compatibility level</b><br>

#### Contributors

32 people contributed to this release:

	Ales Musil
	Andrej Krejcir
	Benny Zlotnik
	Bohdan Iakymets
	Dana Elfassy
	Denis Chaplygin
	Dominik Holler
	Eitan Raviv
	Eyal Shenitzky
	Fedor Gavrilov
	Ido Rosenzwig
	Marcin Sobczyk
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Soffer
	Ondra Machacek
	Ori_Liel
	Ravi Nori
	Roman Hodain
	Roy Golan
	Sahina Bose
	Sandro Bonazzola
	Sharon Gratch
	Shmuel Melamud
	Simone Tiraboschi
	Tomasz Barański
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	emesika
	godas
