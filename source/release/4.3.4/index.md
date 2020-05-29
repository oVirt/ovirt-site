---
title: oVirt 4.3.4 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 4.3.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.4 release as of June 11, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).


For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.4, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



If you are upgrading from older versions please upgrade to 4.2.8 before upgrading to 4.3.4

If you're upgrading from oVirt Engine 4.2.8 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup

If you're upgrading from oVirt Node NG 4.2 you just need to execute:

      # yum install https://resources.ovirt.org/pub/ovirt-4.3/rpm/el7/noarch/ovirt-node-ng-image-update-4.3.4-1.el7.noarch.rpm
      # reboot

If you're upgrading from oVirt Node NG 4.3 please use oVirt Engine Administration portal for handling the upgrade.




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


## What's New in 4.3.4?


Release has been updated on June 19th providing ovirt-ansible-vm-infra-1.1.18,
ovirt-ansible-image-template-1.1.11 and ovirt-engine-metrics-1.3.2
fixing metrics deployment with Ansible 2.8.


### Enhancements

#### VDSM JSON-RPC Java

 - [BZ 1689702](https://bugzilla.redhat.com/1689702) <b>GC overhead limit exceeded due to org.ovirt.vdsm.jsonrpc.client.events.SubscriptionHolder</b><br>A new configuration variable 'EventPurgeTimeoutInHours' has been added to set the number of hours an event can stay in the queue before being cleaned up. The variable can be modified using engine-config. The initial default value is 3 hours.

#### oVirt Provider OVN

 - [BZ 1685983](https://bugzilla.redhat.com/1685983) <b>[RFE] Support IPv6 for address type in subnets in rhel8 guests</b><br>This feature adapts the existing IPv6 address support for OpenStack Networking API subnets, making its address mode configurable, as per the networking API subnet 'address_mode' parameter. <br><br>The addresses can now be generated from RA messages, when the address mode parameter is set to 'dhcpv6_stateless'. This configuration also allows for the MTU of the logical network to be configured, which would be otherwise impossible for ipv6 logical networks.

#### oVirt Cockpit Plugin

 - [BZ 1704183](https://bugzilla.redhat.com/1704183) <b>[RFE] Allow to choose alternative to ICMP ping for hosted engine network test</b><br>Feature: Allow users to do a network test in other ways rather than ICMP (ping).<br>Users can choose to do a network test with:<br>1. DNS<br>2. ICMP<br>3. TCP<br>4. None of the above (do no test)

#### oVirt Engine

 - [BZ 1712253](https://bugzilla.redhat.com/1712253) <b>Add MDS CPU types</b><br>added MDS versions of the CPUs added MDS variants to 4.1,4.2,4.3 CPU types to mitigate https://access.redhat.com/security/vulnerabilities/mds
 - [BZ 1403677](https://bugzilla.redhat.com/1403677) <b>[IPv6] - allow and enable gluster network with only ipv6 boot protocol</b><br>Feature: Allow and enable a Gluster network with IPv6 boot protocol only<br><br>Reason: Enable users to work with a Gluster network on a pure IPv6 network<br><br>Result: Users can connect to a Gluster storage over IPv6 without need for IPv4.
 - [BZ 1689702](https://bugzilla.redhat.com/1689702) <b>GC overhead limit exceeded due to org.ovirt.vdsm.jsonrpc.client.events.SubscriptionHolder</b><br>A new configuration variable 'EventPurgeTimeoutInHours' has been added to set the number of hours an event can stay in the queue before being cleaned up. The variable can be modified using engine-config. The initial default value is 3 hours.
 - [BZ 1341161](https://bugzilla.redhat.com/1341161) <b>[RFE] Add "Other Linux (kernel 4.x)" to OS types</b><br>A new generic Linux x86 operating system selection named ‘Other Linux (kernel 4.x)’ has been added to the drop down list of operating systems available when creating a new virtual machine in Red Hat Virtualization.
 - [BZ 1655503](https://bugzilla.redhat.com/1655503) <b>[RFE]Add "windows 2019 x64" support</b><br>This release adds support for virtual machines to use Windows 2019 x64 in the Administration Portal.

#### VDSM

 - [BZ 1695567](https://bugzilla.redhat.com/1695567) <b>[downstream clone - 4.3.4] [RFE] Support VMs with VNC console on a FIPS enabled hypervisor</b><br>When a host is running in FIPS mode, VNC must use SASL authorization instead of regular passwords because of the weak algorithm inherent in the VNC protocol.<br><br>In order to facilitate that process, the Ansible role 'ovirt-host-setup-vnc-sasl' is provided. It must be run manually on all FIPS hosts. The role does the following:<br>* Creates an (empty) SASL password database<br>* Prepares an SASL configuration file for qemu<br>* Changes the libvirt configuration file for qemu

#### OTOPI

 - [BZ 1694423](https://bugzilla.redhat.com/1694423) <b>[RFE] disable dnf by default on EL7</b><br>OTOPI's DNF packager is now disabled on EL7 by default, even if dnf is installed. To enforce otopi to try it, add to the relevant tool's (e.g. engine-setup) answer file:<br><br>PACKAGER/dnfpackagerEnabled=bool:True

#### oVirt Windows Guest Tools

 - [BZ 1713705](https://bugzilla.redhat.com/1713705) <b>Rebase WGT on qxl-wddm-dod-0.19 / virtio-win 171</b><br>oVirt Guest Tools ISO has been updated including new virtio-win-prewhql drivers collection version 171, providing updated qxl-wddm-dod driver version 0.19 (see https://gitlab.freedesktop.org/spice/win32/qxl-wddm-dod/blob/master/Changelog for more information).

### Bug Fixes

#### oVirt Provider OVN

 - [BZ 1717769](https://bugzilla.redhat.com/1717769) <b>[downstream clone - 4.3.4] "after_get_caps" ovirt-provider-ovn-driver hook query floods /var/log/messages when ovs-vswitchd is disabled</b><br>

#### oVirt Engine

 - [BZ 1717434](https://bugzilla.redhat.com/1717434) <b>[downstream clone - 4.3.4] PCI address of NICs are not stored in the database after a hotplug of passthrough NIC resulting in change of network device name in VM after a reboot</b><br>
 - [BZ 1710740](https://bugzilla.redhat.com/1710740) <b>[downstream clone - 4.3.5] Do not change DC level if there are VMs running/paused with older CL.</b><br>
 - [BZ 1697706](https://bugzilla.redhat.com/1697706) <b>Null pointer exception observed while setting up remote data sync on the storage domain leads</b><br>

#### VDSM

 - [BZ 1714154](https://bugzilla.redhat.com/1714154) <b>[downstream clone - 4.3.4] When a storage domain is updated to V5 during a DC upgrade, if there are volumes with metadata that has been reset then the upgrade fails</b><br>
 - [BZ 1711792](https://bugzilla.redhat.com/1711792) <b>[downstream clone - 4.3.4] Migration aborted, probably due to stalling</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1627958](https://bugzilla.redhat.com/1627958) <b>engine-retry-score-penalty could be better used</b><br>

#### oVirt Host Dependencies

 - [BZ 1710918](https://bugzilla.redhat.com/1710918) <b>Require updated microcode_ctl on hosts</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1707739](https://bugzilla.redhat.com/1707739) <b>[OVN][NETWORK] Updating subnet's 'ipv6_address_mode' parameter returns 'OK' but does not update</b><br>
 - [BZ 1685534](https://bugzilla.redhat.com/1685534) <b>Fix IPv6 subnet gateway</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1710314](https://bugzilla.redhat.com/1710314) <b>Disable /var/log available size check from cockpit</b><br>
 - [BZ 1710245](https://bugzilla.redhat.com/1710245) <b>Hosted-Engine deployment via Cockpit uses 4vCPU w/ 16348 GB instead of 16384</b><br>
 - [BZ 1695610](https://bugzilla.redhat.com/1695610) <b>Prompt for applying default OpenSCAP profile is not present in hosted engine setup via cockpit</b><br>
 - [BZ 1697532](https://bugzilla.redhat.com/1697532) <b>[RFE] Add IDs to components in the HE wizard for testing purposes</b><br>
 - [BZ 1678390](https://bugzilla.redhat.com/1678390) <b>[RFE] Remove 'validate' buttons on HE wizard for validate FQDNs</b><br>

#### oVirt Engine

 - [BZ 1656683](https://bugzilla.redhat.com/1656683) <b>Show VDO savings in dashboard</b><br>
 - [BZ 1667723](https://bugzilla.redhat.com/1667723) <b>After setting SPM priority, DisconnectStorageServer sometimes fails with NullPointerException for an iSCSI disconnection</b><br>
 - [BZ 1704782](https://bugzilla.redhat.com/1704782) <b>[webadmin] -ovirt 4.3.3 doesn't allow creation of VM with "Thin Provision"-ed disk (always preallocated)</b><br>
 - [BZ 1711800](https://bugzilla.redhat.com/1711800) <b>Missing 'id' attributes in storage section.</b><br>
 - [BZ 1684170](https://bugzilla.redhat.com/1684170) <b>Can't provision a host from oVirt when medium is synced from CDN in Satellite 6.4</b><br>
 - [BZ 1710001](https://bugzilla.redhat.com/1710001) <b>[CodeChange][i18n] ovirt-engine 4.3 translation update (ja_JP only)</b><br>
 - [BZ 1613461](https://bugzilla.redhat.com/1613461) <b>CreateSnapshotFromTemplateCommand (VM creation as thin) fails with internal engine error</b><br>
 - [BZ 1698334](https://bugzilla.redhat.com/1698334) <b>Migration configuration doesn't work for HE VM - values are locked.</b><br>
 - [BZ 1600432](https://bugzilla.redhat.com/1600432) <b>Webadmin: 'Move' button is missing in storage domain's disks view</b><br>
 - [BZ 1709303](https://bugzilla.redhat.com/1709303) <b>[downstream clone - 4.3.4] Failure in creating snapshots during "Live Storage Migration" can result in a nonexistent snapshot</b><br>
 - [BZ 1717765](https://bugzilla.redhat.com/1717765) <b>[downstream clone - 4.3.4] [UI] warn users about different "Vdsm Name" when creating network with a fancy char or long name</b><br>
 - [BZ 1690328](https://bugzilla.redhat.com/1690328) <b>"Check for upgrade" not showing the update for redhat-virtualization-host-image</b><br>
 - [BZ 1662915](https://bugzilla.redhat.com/1662915) <b>Copy a shareable thin provisioned disk is allowed, leaving a new COW shareable disk. Hence, start VM with such a disk attached fails on vdsm</b><br>
 - [BZ 1683161](https://bugzilla.redhat.com/1683161) <b>No proper events or error message notified, when the host upgrade fails</b><br>
 - [BZ 1697301](https://bugzilla.redhat.com/1697301) <b>cluster upgrade fails on timeout after 30 minutes</b><br>
 - [BZ 1689942](https://bugzilla.redhat.com/1689942) <b>Event Host upgrade was completed successfully should be when host come up after reboot, not in the same time as event Host was restared</b><br>
 - [BZ 1698169](https://bugzilla.redhat.com/1698169) <b>[CodeChange][i18n] oVirt 4.3 translation update</b><br>
 - [BZ 1452031](https://bugzilla.redhat.com/1452031) <b>[engine-backend] Shared disk that is marked as bootable for one VM cause the disks of the other VM it is attached to be blocked from being bootable</b><br>
 - [BZ 1702597](https://bugzilla.redhat.com/1702597) <b>[downstream clone - 4.3.4] When a live storage migration fails, the auto generated snapshot does not get removed</b><br>
 - [BZ 1664045](https://bugzilla.redhat.com/1664045) <b>A failure to deactivate SPM due to uncleared tasks is not reported via any API</b><br>
 - [BZ 1635337](https://bugzilla.redhat.com/1635337) <b>[Downstream Clone] Cannot assign VM from VmPool: oVirt claims it's already attached but it's not</b><br>This release ensures that virtual machines within a virtual machine pool can be attached to a user.
 - [BZ 1698407](https://bugzilla.redhat.com/1698407) <b>console.vv file - set host FQDN in host field</b><br>
 - [BZ 1683281](https://bugzilla.redhat.com/1683281) <b>Hosts cert reenrolment in upgrade should be executed sooner than certs are expired</b><br>

#### VDSM

 - [BZ 1712250](https://bugzilla.redhat.com/1712250) <b>MDS mitigation dependencies bump up</b><br>
 - [BZ 1707932](https://bugzilla.redhat.com/1707932) <b>[downstream clone - 4.3.4] Moving disk results in wrong SIZE/CAP key in the volume metadata</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1705249](https://bugzilla.redhat.com/1705249) <b>The "datacenter name" input should be validated early</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1705249](https://bugzilla.redhat.com/1705249) <b>The "datacenter name" input should be validated early</b><br>
 - [BZ 1704323](https://bugzilla.redhat.com/1704323) <b>HE deployment fail with 'Not enough memory' when given the engine vm the maximum memory</b><br>
 - [BZ 1694666](https://bugzilla.redhat.com/1694666) <b>[TEXT] Description of RHVM Appliance should be in sync with docs.</b><br>

#### oVirt Engine Metrics

 - [BZ 1713223](https://bugzilla.redhat.com/1713223) <b>CI fails on ansible yumlock error</b><br>
 - [BZ 1686572](https://bugzilla.redhat.com/1686572) <b>In metrics-store-installation role need to get update the way we get the engine ssh public key</b><br>
 - [BZ 1680647](https://bugzilla.redhat.com/1680647) <b>Bug when setting  "collect_ovirt_collectd_metrics" to false</b><br>
 - [BZ 1704721](https://bugzilla.redhat.com/1704721) <b>OpenShift installation fails on Centos due to missing network manager</b><br>
 - [BZ 1679227](https://bugzilla.redhat.com/1679227) <b>Creation of bastion sometimes fails because of missing FQDN</b><br>
 - [BZ 1696795](https://bugzilla.redhat.com/1696795) <b>TODO comment in the main.yml file</b><br>
 - [BZ 1683157](https://bugzilla.redhat.com/1683157) <b>Logging not disabled for sensitive tasks</b><br>

#### oVirt Ansible ManageIQ role

 - [BZ 1672537](https://bugzilla.redhat.com/1672537) <b>Run ovirt-ansible-manageiq twice, without removing the manageiq, runs over the v2_key</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1689175](https://bugzilla.redhat.com/1689175) <b>NullPointerException in case of wrong parameters in api calls via java sdk</b><br>

#### oVirt Engine UI Extensions

 - [BZ 1697301](https://bugzilla.redhat.com/1697301) <b>cluster upgrade fails on timeout after 30 minutes</b><br>
 - [BZ 1698163](https://bugzilla.redhat.com/1698163) <b>[CodeChange][i18n] oVirt 4.3 translation update</b><br>
 - [BZ 1656683](https://bugzilla.redhat.com/1656683) <b>Show VDO savings in dashboard</b><br>

### No Doc Update

#### oVirt Cockpit Plugin

 - [BZ 1697795](https://bugzilla.redhat.com/1697795) <b>Hosted engine installation guide document opens failed as 404 error.</b><br>

#### oVirt Engine

 - [BZ 1695018](https://bugzilla.redhat.com/1695018) <b>[downstream clone - 4.3.4] Concurrent LSMs of the same disk can be issued via the REST-API</b><br>

#### Contributors

54 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Krejcir
	Asaf Rachmani
	Benny Zlotnik
	Bohdan Iakymets
	Dana Elfassy
	Daniel Erez
	Dominik Holler
	Eitan Raviv
	Evgeny Slutsky
	Eyal Shenitzky
	Fabien Dupont
	Fedor Gavrilov
	Gal Zaidman
	Greg Sheremeta
	Ido Rosenzwig
	Joey
	Kaustav Majumder
	Mark Chappell
	Martin Nečas
	Martin Perina
	Mauricio Teixeira
	Michal Skrivanek
	Miguel Duarte Barroso
	Milan Zamazal
	Moti Asayag
	Nir Soffer
	Ondra Machacek
	Orcun Atakan
	Ori_Liel
	Pavel Bar
	Piotr Kliczewski
	Ravi Nori
	Roman Hodain
	Roy Golan
	Sahina Bose
	Sandro Bonazzola
	Scott J Dickerson
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Simone Tiraboschi
	Steven Rosenberg
	Tomasz Baranski
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	Yuval Turgeman
	godas
	imjoey
	jenkins CI
	parthdhanjal
	solacelost
