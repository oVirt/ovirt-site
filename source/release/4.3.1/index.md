---
title: oVirt 4.3.1 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.3.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.1 Release as of February 28, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.1, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you are upgrading from older versions please upgrade to 4.2.8 before upgrading to 4.3.1

If you're upgrading from oVirt Engine 4.2.8 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup

If you're upgrading from oVirt Node NG 4.2 you just need to execute:

      # yum install https://resources.ovirt.org/pub/ovirt-4.3/rpm/el7/noarch/ovirt-node-ng-image-update-4.3.1-1.el7.noarch.rpm
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
- [Bug 1666795 - VMs migrated to 4.3 are missing the appropriate virt XML for dynamic ownership, and are reset to root:root, preventing them from starting](https://bugzilla.redhat.com/show_bug.cgi?id=1666795) - Also affects 4.3.0, easy workaround is to chown vdsm:kvm the disks whigh got reowned to root:root.

## What's New in 4.3.1?

### Enhancements

#### oVirt Cockpit Plugin

 - [BZ 1598141](https://bugzilla.redhat.com/1598141) <b>[RFE] HE Node Zero should support 'tags' and 'skip-tags' properties</b><br>Feature: Support --tags and --skip-tags options on hosted-engine-setup<br><br>Reason: Have the ability to run ansible roles with tags.<br>Until now Hosted-engine run ansible playbooks with only variables.

#### oVirt Engine

 - [BZ 1467332](https://bugzilla.redhat.com/1467332) <b>[RFE][Default Route] [IPv6] - Allow and enable default route network with only ipv6 boot protocol</b><br>Feature: Support default route role on ipv6 only networks, but only for ipv6 static interface configuration.<br><br>Reason: oVirt engine should support ipv6 only networks for its existing capabilities<br><br>Result: <br>- it is now possible to set the default route role on an ipv6 only network provided it has an ipv6 gateway.<br>- for engine to correctly report the sync status of the interfaces, all interfaces should be configured with ipv6 static configuration only and an ipv6 gateway should be configured only on the network bearing the default route role. <br>- ipv6 dynamic configuration is currently not supported.<br>- the ipv6 gateway on the default route role network is applied as the default route for the v6 routing table on the host.<br>- it is now possible to set an ipv6 gateway on non-management networks (was previously possible only on the management network).<br>- if more that one ipv6 gateway is set on the interfaces of a host, engine will be in an undefined state: there will be more than one default route entry in the v6 routing table on the host which will cause the host to report that there are no v6 gateways at all meaning that the interfaces will appear as out of sync in engine.
 - [BZ 1671074](https://bugzilla.redhat.com/1671074) <b>[RFE] Disable anonymous ciphers for engine <-> VDSM communication</b><br>In this release, the available SSL ciphers used in communication between the Red Hat Virtualization Manager and VDSM have been limited, and now exclude weak or anonymous ciphers.
 - [BZ 1637015](https://bugzilla.redhat.com/1637015) <b>[RFE] add option to disable toast notifications per user</b><br>With this release, users can now silence toast notifications.<br>When a toast notification appears, the user can now:<br><br>Dismiss All<br>or<br>Do Not Disturb<br>  for 10 minutes<br>  for 1 hour<br>  for 1 day<br>  until Next Log In
 - [BZ 1669047](https://bugzilla.redhat.com/1669047) <b>Support creating a cinderlib data-base in the engine-setup process</b><br>In order to create and use Managed block storage domain, new database should be created for cinderlib to use.<br><br>As similar to the engine database creation, this new database can be created using the engine setup process.
 - [BZ 1673303](https://bugzilla.redhat.com/1673303) <b>Prevent setting ipv6 gw on a non default-route-role network</b><br>Feature: Manage the ipv6 default route of a host via restricting the ipv6 default gateways on the host interfaces.<br><br>Reason: Only a single ipv6 gateway should be allowed on all interfaces of a host and it should be on the network assigned the default route role of the network. Allowing to set multiple gateways causes multiple default route entries on the host routing tables which in turn might cause <br>- loss of connectivity with the host on some subnets <br>- host reporting no gateways at all on its interfaces<br>- engine reporting networks as being out of sync<br><br>Result: <br>1. When the default route role is moved away from a network, its ipv6 gateway is automatically removed from the interface.<br>2. After moving the default route role to a new network the user should set a static ipv6 gateway on this network.<br>3. If the host and engine are not on the same subnet, engine will loose connectivity with the host on moving the default route role between networks. This is due to result (1). The user should take precautions to avoid this situation.
 - [BZ 1561539](https://bugzilla.redhat.com/1561539) <b>[RFE] Allow adding a new host or reinstalling existing one and switching it to Maintenance without activation</b><br>Feature: <br><br>Allow adding, approving or reinstalling a host without automatically activating it afterwards.<br><br>Reason: <br><br>Sometimes there is performance overhead when activating a host after its addition / re-install / approval, especially when the connection to the storage-domain is problematic. Due to this it's necessary to enable users to add / re-install /approve a host without the host being automatically activated afterwards.<br><br>Result: <br><br>The API will support activate=false matrix<br>parameter in the URL of the request, relevant for add host, install host, approve host operations. <br><br>The WebAdmin will provide "Activate Host After Install" checkbox in add and install host dialogues, and propagate the value of the checkbox to the Engine. <br><br>The default behavior remains activating the host.

### Bug Fixes

#### VDSM

 - [BZ 1670370](https://bugzilla.redhat.com/1670370) <b>Messages log spammed with ovs|00001|db_ctl_base|ERR|no key "odl_os_hostconfig_hostid"</b><br>

#### oVirt Engine

 - [BZ 1658976](https://bugzilla.redhat.com/1658976) <b>[Backup restore API] restore VM (created from template with thin copy) from OVF data fails - ImportVmFromConfigurationCommand fails with Error during ValidateFailure.: java.lang.NullPointerException</b><br>
 - [BZ 1664342](https://bugzilla.redhat.com/1664342) <b>RHV WEB-GUI sorts disk Snapshots rows alphabetically.</b><br>
 - [BZ 1663616](https://bugzilla.redhat.com/1663616) <b>usb forwarding does not work on VMs/templates created in 3.6 after upgrading to 4.2.7</b><br>

### Other

#### oVirt image transfer daemon and proxy

 - [BZ 1519194](https://bugzilla.redhat.com/1519194) <b>ovirt-engine-rename should change ImageProxyAddress if hosted on same host as engine</b><br>
 - [BZ 1670312](https://bugzilla.redhat.com/1670312) <b>ovirt-imageio-daemon fails to start after reboot</b><br>

#### oVirt Release Package

 - [BZ 1672954](https://bugzilla.redhat.com/1672954) <b>Include gluster-ansible role from copr repo for CentOS and Fedora</b><br>

#### oVirt Log Collector

 - [BZ 1641341](https://bugzilla.redhat.com/1641341) <b>ovirt-log-collector python2/3  compatibility</b><br>
 - [BZ 1666796](https://bugzilla.redhat.com/1666796) <b>Manpage mention wrong path to logcollector.conf</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1679412](https://bugzilla.redhat.com/1679412) <b>Gateway address unreachable error displays on VM settings during hosted engine deployment.</b><br>
 - [BZ 1669928](https://bugzilla.redhat.com/1669928) <b>Hosted engine Wizard loading failed with static IPv6 network environment.</b><br>
 - [BZ 1655514](https://bugzilla.redhat.com/1655514) <b>Shift from gdeploy to ansible roles</b><br>
 - [BZ 1669108](https://bugzilla.redhat.com/1669108) <b>Gdeploy config file in RHEL based RHHI deployment is not generated as per requirement.</b><br>
 - [BZ 1673038](https://bugzilla.redhat.com/1673038) <b>Hosted-engine installation wizard does not open due to network issue</b><br>
 - [BZ 1679876](https://bugzilla.redhat.com/1679876) <b>Validate the availability of gluster-ansible-roles before deployment</b><br>
 - [BZ 1670492](https://bugzilla.redhat.com/1670492) <b>The hosted-engine wizard always forces he_host_ip to the value of ansible_default_ipv4 and this could fail the deployment if the two interfaces uses different vlans</b><br>
 - [BZ 1676426](https://bugzilla.redhat.com/1676426) <b>Text bugs in Cockpit HE Window</b><br>
 - [BZ 1679540](https://bugzilla.redhat.com/1679540) <b>HC Deployment fails at FQDN validation check</b><br>
 - [BZ 1679687](https://bugzilla.redhat.com/1679687) <b>Hyperconverged deployment on a single host fails instantly on cockpit</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1676928](https://bugzilla.redhat.com/1676928) <b>Add flags to let the user explicitly force IPv6 or IPv4</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1654697](https://bugzilla.redhat.com/1654697) <b>dmidecode ppc64</b><br>

#### VDSM

 - [BZ 1669466](https://bugzilla.redhat.com/1669466) <b>Allow setting 3 dns name servers instead of the current two</b><br>
 - [BZ 1676695](https://bugzilla.redhat.com/1676695) <b>"MOM not available, KSM stats will be missing" message on random hosts, after updating to ovirt-4.3.0</b><br>
 - [BZ 1658866](https://bugzilla.redhat.com/1658866) <b>[scale] adding storage domain creates significant load</b><br>
 - [BZ 1668727](https://bugzilla.redhat.com/1668727) <b>Cinderlib- implement ManagedVolume.volume_info</b><br>
 - [BZ 1610917](https://bugzilla.redhat.com/1610917) <b>External VMs automatically deleted when powered down</b><br>Vdsm takes ownership of all the VMs running on a given host. This includes any VM defined outside the System, for example by the user using command line tools.<br>Vdsm also undefines the VM when they are shut down - e.g. it removes their configuration from libvirt running on the host. <br>This is now done only for VMs created within the system. In other words, Vdsm now manages (stops, migrate...) externally defined VMs, but leaves them defined on shut down.
 - [BZ 1667978](https://bugzilla.redhat.com/1667978) <b>applicability of parameter migration_max_bandwidth is not obvious</b><br>

#### oVirt Host Dependencies

 - [BZ 1665073](https://bugzilla.redhat.com/1665073) <b>On hosts add collectd write_syslog plugin dependency</b><br>

#### oVirt Engine

 - [BZ 1676461](https://bugzilla.redhat.com/1676461) <b>engine-setup  should mention WA for upgrade issues (ovirt-vmconsole)</b><br>
 - [BZ 1665072](https://bugzilla.redhat.com/1665072) <b>On engine side add write_syslog collectd output plugin dependency</b><br>
 - [BZ 1672587](https://bugzilla.redhat.com/1672587) <b>VNC encryption is true on host after upgrade causing "Unsupported security types: 19"</b><br>
 - [BZ 1658544](https://bugzilla.redhat.com/1658544) <b>Add logging to of failed check-for-upgrade command</b><br>
 - [BZ 1658249](https://bugzilla.redhat.com/1658249) <b>Importing a VM from OVA that has been imported already fails and its disk status becomes illegal</b><br>
 - [BZ 1672251](https://bugzilla.redhat.com/1672251) <b>rename fails on KeyError  'changed'</b><br>
 - [BZ 1607118](https://bugzilla.redhat.com/1607118) <b>[IPv6] - Engine does not report out-of-sync on ipv6-enabled network</b><br>
 - [BZ 1609947](https://bugzilla.redhat.com/1609947) <b>Event notifications: distant position of Do Not Disturb dropdown</b><br>
 - [BZ 1613402](https://bugzilla.redhat.com/1613402) <b>Usage of sed -i in the dbscripts creates temporary files inside the directory</b><br>
 - [BZ 1669466](https://bugzilla.redhat.com/1669466) <b>Allow setting 3 dns name servers instead of the current two</b><br>
 - [BZ 1509178](https://bugzilla.redhat.com/1509178) <b>Wrapped provider URL in General tab of external provider</b><br>
 - [BZ 1676581](https://bugzilla.redhat.com/1676581) <b>[RFE] Make it possible to enable javax.net.debug in ovirt-engine-extensions-tool</b><br>
 - [BZ 1660902](https://bugzilla.redhat.com/1660902) <b>REST/SDK create VM snapshot with the same image id as an existing image id in that VM ->  Engine Error Image IDs ${ImageId} appear</b><br>
 - [BZ 1478854](https://bugzilla.redhat.com/1478854) <b>Edit Host/Kernel dialog should not accept blank char as value for Kernel command line</b><br>
 - [BZ 1674214](https://bugzilla.redhat.com/1674214) <b>Kernel command line does not allow spaces</b><br>
 - [BZ 1649285](https://bugzilla.redhat.com/1649285) <b>[RFE] Re-enroll host certificates during host upgrade</b><br>During host upgrade we do re-enroll host certificates in case the certificate is invalid.
 - [BZ 1667842](https://bugzilla.redhat.com/1667842) <b>Automatic Migration for Affinity Labels not working</b><br>
 - [BZ 1673319](https://bugzilla.redhat.com/1673319) <b>[CinderLib] failed updating managed block storage - in 'SetStorageDomainDescriptionVDS'</b><br>
 - [BZ 1429482](https://bugzilla.redhat.com/1429482) <b>Difference between VV file content and data received as a response for REST api call to get VV file content.</b><br>
 - [BZ 1648917](https://bugzilla.redhat.com/1648917) <b>New disks cloned from template get wrong quota-id, when quota is disabled on DC</b><br>
 - [BZ 1532016](https://bugzilla.redhat.com/1532016) <b>[UI] - Align 'Confirm Operation' checkbox in the 'Confirm Host has been rebooted' dialog</b><br>
 - [BZ 1662670](https://bugzilla.redhat.com/1662670) <b>REST: Disk creation on a block-based domain, with provisioned size 0 is initiated and fails on vdsm</b><br>

#### imgbased

 - [BZ 1652519](https://bugzilla.redhat.com/1652519) <b>host does not meet the cluster's minimum CPU level. Missing CPU features : spec_ctrl</b><br>
 - [BZ 1652795](https://bugzilla.redhat.com/1652795) <b>RHVH 4.3: There are warnings when running lvm commands</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1676704](https://bugzilla.redhat.com/1676704) <b>Cannot disable VNC Encryption in cluster</b><br>

#### Contributors

48 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Krejcir
	Asaf Rachmani
	Bell Levin
	Benny Zlotnik
	Bohdan Iakymets
	Dan Kenigsberg
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Douglas Schilling Landgraf
	Eitan Raviv
	Eyal Shenitzky
	Fedor Gavrilov
	Francesco Romani
	Fred Rolland
	Greg Sheremeta
	Ido Rosenzwig
	Marcin Sobczyk
	Martin Perina
	Michal Skrivanek
	Miguel Duarte Barroso
	Miguel Martin
	Milan Zamazal
	Miroslava Voglova
	Nir Soffer
	Ondra Machacek
	Ori_Liel
	Petr Balogh
	Ravi Nori
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Simone Tiraboschi
	Steffen Froemer
	Steven Rosenberg
	Tomasz Baranski
	Vojtech Juranek
	Yedidyah Bar David
	Yuval Turgeman
	bond95
	emesika
	godas
	gzaidman
	parthdhanjal
