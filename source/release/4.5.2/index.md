---
title: oVirt 4.5.2 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.2 release planning

The oVirt 4.5.2 code freeze is planned for July 29, 2022.

If no critical issues are discovered while testing this compose it will be released on August 10, 2022.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.5.2](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.5.2%22%20-target_milestone%3A%22ovirt-4.5.2-%22)


# oVirt 4.5.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.2 First Release Candidate as of August 02, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for CentOS Stream 8 and Red Hat Enterprise Linux 8.6 (or similar).

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).

The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.



For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.5.2, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.


> IMPORTANT
> If you are going to install on RHEL 8.6 or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.


```bash
dnf install -y centos-release-ovirt45 centos-release-ovirt45-testing
```

```bash
dnf install -y python3-dnf-plugins-core
dnf config-manager --set-enabled centos-ovirt45-testing
dnf config-manager --set-enabled ovirt-45-upstream-testing
```


## What's New in 4.5.2?

### Release Note

#### oVirt Engine

 - [BZ 2104408](https://bugzilla.redhat.com/show_bug.cgi?id=2104408) **/var/cache/dnf fills up and will cause upgrades to fail**

   yum cache is now cleared always before upgrading a host to minimize issues with filling up available space in /var/tmp
 - [BZ 2090645](https://bugzilla.redhat.com/show_bug.cgi?id=2090645) **Host stuck in state 'Connecting' when certificates expire**

   Host should move to NonResposive status when VDSM certificate expires.
 - [BZ 2096523](https://bugzilla.redhat.com/show_bug.cgi?id=2096523) **Failed to run "Check for Upgrade"**

   It's now possible to install and upgrade hypervisors using non-standard SSH port

### Enhancements

#### VDSM

 - [BZ 1793207](https://bugzilla.redhat.com/show_bug.cgi?id=1793207) **[RFE] Notify if multipath User Friendly Names are used**

   Feature: 
   Protect users from using wrong multipath configuration
   by parsing the configuration in vdsm-tool, look for
   user_friendly_names setting occurrences, and print
   a warning if enabled.
   Reason: 
   It is not supported to use multipath User Friendly 
   Names(UFN) on oVirt hosts, but it is not enforced either.
   It may cause corruption in block SDs if a host is 
   running with UFN enabled.
   Result: 
   $ vdsm-tool is-configured --module multipath
   WARNING: Invalid configuration: 'user_friendly_names' is
   enabled in multipath configuration:
     section1 {
       key1 value1
       user_friendly_names yes
       key2 value2
     }
     section2 {
       user_friendly_names yes
     }
   This configuration is not supported and may lead to storage domain corruption.

### Bug Fixes

#### VDSM

 - [BZ 2103582](https://bugzilla.redhat.com/show_bug.cgi?id=2103582) **Failed to delete the second snapshot when deleting two snapshots of a running VM**

#### oVirt Hosted Engine Setup

 - [BZ 2105781](https://bugzilla.redhat.com/show_bug.cgi?id=2105781) **hosted-engine --clean-metadata fails because ovirt-ha-agent has changed location**

#### oVirt Engine

 - [BZ 1853924](https://bugzilla.redhat.com/show_bug.cgi?id=1853924) **Fails to import template as OVA from the given configuration if the VM is not removed**
 - [BZ 1955388](https://bugzilla.redhat.com/show_bug.cgi?id=1955388) **Auto Pinning Policy only pins some of the vCPUs on a single NUMA host**
 - [BZ 1257644](https://bugzilla.redhat.com/show_bug.cgi?id=1257644) **Starting VM with snapshot with memory conflicts with later VM properties changes**
 - [BZ 2104115](https://bugzilla.redhat.com/show_bug.cgi?id=2104115) **oVirt 4.5 cannot import VMs with cpu pinning**
 - [BZ 2096862](https://bugzilla.redhat.com/show_bug.cgi?id=2096862) **Certificate Warn period and automatic renewal via engine-setup do not match**
 - [BZ 2097725](https://bugzilla.redhat.com/show_bug.cgi?id=2097725) **Certificate Warn period and automatic renewal via engine-setup do not match**

### Other

#### VDSM

 - [BZ 2000046](https://bugzilla.redhat.com/show_bug.cgi?id=2000046) **Switch virdomain to virdomain.Disconnected when VM is shut down**
 - [BZ 2099321](https://bugzilla.redhat.com/show_bug.cgi?id=2099321) **Migration failure with "'IndexError' object is not iterable" error in ppc arch**
 - [BZ 2097614](https://bugzilla.redhat.com/show_bug.cgi?id=2097614) **Host goes to non-operational due to  15 - session exists error**

#### oVirt Cockpit Plugin

 - [BZ 2106419](https://bugzilla.redhat.com/show_bug.cgi?id=2106419) **Hosted Engine deployment fails with error 'he_admin_username' is undefined**

#### MOM

 - [BZ 1720976](https://bugzilla.redhat.com/show_bug.cgi?id=1720976) **[logging] limit getAllVmIoTunePolicies**

#### oVirt Engine UI Extensions

 - [BZ 2108612](https://bugzilla.redhat.com/show_bug.cgi?id=2108612) **oVirt Dashboard - Top Utilized Resources CPU dialog - percentage values are invalid (larger than 100%)**

#### oVirt Engine

 - [BZ 1912911](https://bugzilla.redhat.com/show_bug.cgi?id=1912911) **VM doesn't start again when reboot on a powering up vm with next-run configuration**
 - [BZ 2097717](https://bugzilla.redhat.com/show_bug.cgi?id=2097717) **Hot set of CPUs for dedicated VM must be blocked in UI**
 - [BZ 2111088](https://bugzilla.redhat.com/show_bug.cgi?id=2111088) **hotplug CPU error has been brought upon dedicated VM shutting down**
 - [BZ 2079903](https://bugzilla.redhat.com/show_bug.cgi?id=2079903) **Engine should not allow duplicate connection entries in DB which causes hosts move to 'Non-Operationl state**
 - [BZ 2106349](https://bugzilla.redhat.com/show_bug.cgi?id=2106349) **VM pool creation with SPICE display type from a template with VNC display type sets the pool's display type to VNC**
 - [BZ 2104858](https://bugzilla.redhat.com/show_bug.cgi?id=2104858) **CPU topology of the host has not been retrieved while first query VdsManager::initAvailableCpus()**
 - [BZ 2067104](https://bugzilla.redhat.com/show_bug.cgi?id=2067104) **NullPointerException while attempt to add a host using wrong affinity group ID**
 - [BZ 1991622](https://bugzilla.redhat.com/show_bug.cgi?id=1991622) **Creating conflicting Affinity Groups brings a message to user with VM Ids instead of names**
 - [BZ 2074525](https://bugzilla.redhat.com/show_bug.cgi?id=2074525) **Misleading validation error (related to static&amp;dynamic cpus conf) when nothing is changed in VM Edit window**
 - [BZ 2108012](https://bugzilla.redhat.com/show_bug.cgi?id=2108012) **Disk convert from sparse to preallocated doesn't work**
 - [BZ 2056950](https://bugzilla.redhat.com/show_bug.cgi?id=2056950) **VM with pinning policy=resize-and-pin should not start on NUMA-less hosts**
 - [BZ 2101503](https://bugzilla.redhat.com/show_bug.cgi?id=2101503) **Incorrect usage number in VDS_HIGH_MEM_USE warning**
 - [BZ 2104597](https://bugzilla.redhat.com/show_bug.cgi?id=2104597) **Error when importing templates from export domains**
 - [BZ 2108000](https://bugzilla.redhat.com/show_bug.cgi?id=2108000) **Moving a host with no running VMs to maintenance triggers an error on the client side**
 - [BZ 2100444](https://bugzilla.redhat.com/show_bug.cgi?id=2100444) **Blank template - Disable 'New' button for the Network Interfaces sub tab**
 - [BZ 2095215](https://bugzilla.redhat.com/show_bug.cgi?id=2095215) **Uploading disk with same ID causes sql errors and locked disk**
 - [BZ 2079361](https://bugzilla.redhat.com/show_bug.cgi?id=2079361) **Cluster upgrade fails with: Problem following 'gluster_volumes' link in Clusters entity.**
 - [BZ 1789389](https://bugzilla.redhat.com/show_bug.cgi?id=1789389) **"Internal Engine error" appears when using legacy affinity labels**
 - [BZ 2038694](https://bugzilla.redhat.com/show_bug.cgi?id=2038694) **[RFE] Replace vga with virtio-vga**
 - [BZ 2103620](https://bugzilla.redhat.com/show_bug.cgi?id=2103620) **isolate_thread VM configured with correct topology that must fit the host can't start**
 - [BZ 2094729](https://bugzilla.redhat.com/show_bug.cgi?id=2094729) **Cluster Compatibility Version upgrade break VM's with pending next config**
 - [BZ 2099225](https://bugzilla.redhat.com/show_bug.cgi?id=2099225) **Numa number configuration setting is unexpectedly reverted.**
 - [BZ 2097314](https://bugzilla.redhat.com/show_bug.cgi?id=2097314) **[MBS] - Need to change popup message "Managed Block Storage is not supporting this operation."**
 - [BZ 2081546](https://bugzilla.redhat.com/show_bug.cgi?id=2081546) **Disk Allocation has unaligned and empty option with no caption in resource allocation in clone vm dialog**
 - [BZ 2086561](https://bugzilla.redhat.com/show_bug.cgi?id=2086561) **Convert from Preallocated to Sparse doesn't change the actual disks' size**
 - [BZ 2018412](https://bugzilla.redhat.com/show_bug.cgi?id=2018412) **Deleting a Quota shows an UNKNOWN value in the Events log**
 - [BZ 2093954](https://bugzilla.redhat.com/show_bug.cgi?id=2093954) **Engine certificate alert, no option to update offered by engine-setup**
 - [BZ 1565183](https://bugzilla.redhat.com/show_bug.cgi?id=1565183) **Snapshot creation with memory fails on permission validation**
 - [BZ 2076053](https://bugzilla.redhat.com/show_bug.cgi?id=2076053) **Console disconnect action delay field in the database is set to the type smallint while from UI and REST the field type is integer**
 - [BZ 1915029](https://bugzilla.redhat.com/show_bug.cgi?id=1915029) **[VEEAM] Check incremental backup by default when creating a new disk**
 - [BZ 1904962](https://bugzilla.redhat.com/show_bug.cgi?id=1904962) **Can't import guest from VMware on rhv4.4 GUI if guest disk has special character**

### No Doc Update

#### VDSM

 - [BZ 2102678](https://bugzilla.redhat.com/show_bug.cgi?id=2102678) **vdsmd uses ~ 100% cpu on HostedEngine VM start and stop**

#### oVirt Engine

 - [BZ 2084530](https://bugzilla.redhat.com/show_bug.cgi?id=2084530) **Vm vnic with port-mirroring hot-plug succeeds but is not reported in oVirt DB for over 60 sec**
 - [BZ 1939284](https://bugzilla.redhat.com/show_bug.cgi?id=1939284) **clusterPolicyWeightFunctionInfo tooltip needs improvement in relation to Rank Selector policy unit.**
 - [BZ 2100417](https://bugzilla.redhat.com/show_bug.cgi?id=2100417) **Improve error message for timeout deploy error.**



## Also includes

### Release Note

#### ovirt-ansible-collection

 - [BZ 2049286](https://bugzilla.redhat.com/show_bug.cgi?id=2049286) **when upgrading all hosts in cluster, all pinned VMs are stopped, even on hosts that are skipped.**

   cluster_upgrade role in ovirt-ansible-collection 2.0.0 contains a fix, that only VMs pinned to hosts, which are selected to be upgraded during cluster upgrade, are stopped during the cluster upgrade. VMs pinned to other hosts (not selected for upgrade) are left untouched
 - [BZ 2100420](https://bugzilla.redhat.com/show_bug.cgi?id=2100420) **[RFE] Support Satellite registration in ovirt.repositories role with username/password**

   We have added new parameters for Satellite support in the ansible repositories role. Main parameters which were added:
   ovirt_repositories_org - The org ID which should be used from Satellite
   ovirt_repositories_activationkey - Activation key which will be used with the org.
   ovirt_repositories_ca_rpm_url - The URL to install Satellite CA.   
   ovirt_repositories_rhsm_environment - To set up the host with Satellite using username/password and choose which environment to use.
 - [BZ 2101481](https://bugzilla.redhat.com/show_bug.cgi?id=2101481) **abrt was removed in RHEL 8.6 and causes HE deployments to fail it upgraded from RHEL 8.5 and earlier.**

   Upgrade from previous oVirt versions, which used abrt to handle core dumps, to oVirt 4.5 batch 1, which uses systemd core dump, was fixed.

#### oVirt Engine

 - [BZ 2101474](https://bugzilla.redhat.com/show_bug.cgi?id=2101474) **Keycloak Administration Console URL should be displayed at the end of engine-setup along with webadmin URL when bundled Keycloak integration is enabled**

   There are now displayed Keycloak related information at the end of engine-setup summary, such as administrator username and Keycloak administration console URL.

### Rebase: Bug Fixeses and Enhancementss

#### ovirt-distribution

 - [BZ 2068740](https://bugzilla.redhat.com/show_bug.cgi?id=2068740) **[RFE] Rebase on UnboundID LDAP SDK for Java 6.0.4**

   UnboundID LDAP SDK has been rebased on upstream version 6.0.4. Please review https://github.com/pingidentity/ldapsdk/releases for changes since version 4.0.14

### Bug Fixes

#### ovirt-log-collector

 - [BZ 2081676](https://bugzilla.redhat.com/show_bug.cgi?id=2081676) **--log-size option does not limit the size of the logs from the hypervisor**

#### oVirt Engine

 - [BZ 2109923](https://bugzilla.redhat.com/show_bug.cgi?id=2109923) **Error when importing templates in Admin portal**

### Other

#### oVirt Engine

 - [BZ 1677500](https://bugzilla.redhat.com/show_bug.cgi?id=1677500) **[RFE] Concurrent read of template VM disks fails due to disk lock**
 - [BZ 2021123](https://bugzilla.redhat.com/show_bug.cgi?id=2021123) **ovirt-engine-ui-extensions fails to build on c9s**
 - [BZ 2077649](https://bugzilla.redhat.com/show_bug.cgi?id=2077649) **Block image transfer to/from Managed Block Storage domain**
 - [BZ 2079351](https://bugzilla.redhat.com/show_bug.cgi?id=2079351) **VDSErrorException while migrating a dedicated VM which is part of positive enforcing affinity rule**
 - [BZ 2107985](https://bugzilla.redhat.com/show_bug.cgi?id=2107985) **Live migration of disk cause a database error (engine won't start anymore)**

#### ovirt-ansible-collection

 - [BZ 2036613](https://bugzilla.redhat.com/show_bug.cgi?id=2036613) **Cluster upgrade not sequential and marked as completed to early**
 - [BZ 2084235](https://bugzilla.redhat.com/show_bug.cgi?id=2084235) **Misleading error when using the name of existing storage domain in ansible ovirt_storage_domain module**
 - [BZ 2097332](https://bugzilla.redhat.com/show_bug.cgi?id=2097332) **Fix ansible-lint 6.0.0 for disaster_recovery and remove_stale_lun**

### No Doc Update

#### oVirt Engine

 - [BZ 1974974](https://bugzilla.redhat.com/show_bug.cgi?id=1974974) **Not possible to determine migration policy from the API, even though documentation reports that it can be done.**
 - [BZ 2088446](https://bugzilla.redhat.com/show_bug.cgi?id=2088446) **pki enroll request failure**

#### ovirt-ansible-collection

 - [BZ 2016638](https://bugzilla.redhat.com/show_bug.cgi?id=2016638) **Document that "vm_name" parameter should be specified for Ansible "ovirt_disk" extend attached disk flow**
 - [BZ 2097333](https://bugzilla.redhat.com/show_bug.cgi?id=2097333) **Fix ansible-lint 6.0.0 for hosted_engine_setup and shutdown_env**
 - [BZ 2102616](https://bugzilla.redhat.com/show_bug.cgi?id=2102616) **Cluster upgrade not sequential and marked as completed too early**

#### VDSM

 - [BZ 2084171](https://bugzilla.redhat.com/show_bug.cgi?id=2084171) **[c9s] failing to setup network**
 - [BZ 2108974](https://bugzilla.redhat.com/show_bug.cgi?id=2108974) **Regression with bridge_opts while setting priority parameter via oVirt - 'priority is not a valid nmstate bridge option'**

#### redhat-release-virtualization-host

 - [BZ 2109393](https://bugzilla.redhat.com/show_bug.cgi?id=2109393) **Upgrade redhat-release-virtualization-host to 4.5.2**

### Contributors

36 people contributed to this release:

	Albert Esteve (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	ArtiomDivak (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-keycloak, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: cockpit-ovirt, ovirt-hosted-engine-setup)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dax Kelson (Contributed to: cockpit-ovirt)
	Eitan Raviv (Contributed to: ovirt-engine, vdsm)
	Harel Braha (Contributed to: vdsm)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Karthikeyan Singaravelan (Contributed to: mom)
	Lev Veyde (Contributed to: ovirt-hosted-engine-setup)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine, ovirt-engine-ui-extensions)
	Marcin Sobczyk (Contributed to: ovirt-engine, vdsm)
	Mark Kemel (Contributed to: ovirt-engine)
	Martin Nečas (Contributed to: ovirt-engine)
	Martin Perina (Contributed to: vdsm-jsonrpc-java)
	Michal Skrivanek (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Pavel Bar (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-web-ui)
	Ritesh Chikatwar (Contributed to: cockpit-ovirt)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, mom, ovirt-engine, vdsm-jsonrpc-java)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Leib Melamud (Contributed to: ovirt-engine)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: mom, ovirt-engine, vdsm)
	Vojtěch Juránek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-engine, vdsm)
	rokkbert (Contributed to: vdsm)
