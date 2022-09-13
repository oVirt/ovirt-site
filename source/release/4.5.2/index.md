---
title: oVirt 4.5.2 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.2 release as of August 10, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for CentOS Stream 8 and Red Hat Enterprise Linux 8.6 (or similar).

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).



If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.


For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.5.2, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL 8.6 or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.



## What's New in 4.5.2?

### Release Note

#### oVirt Engine

 - [BZ 2107250](https://bugzilla.redhat.com/show_bug.cgi?id=2107250) **Upgrade of the host failed as the oVirt 4.3 hypervisor is based on RHEL 7 with openssl 1.0.z, but oVirt Engine 4.4 uses the openssl 1.1.z syntax**

   Process to check certificate validity has been changed to be compatible with both RHEL 8 and RHEL 7 based hypervisors
 - [BZ 2097560](https://bugzilla.redhat.com/show_bug.cgi?id=2097560) **Warning when ovsdb-server certificates are about to expire(engine certificate)**

   Expiration of ovirt-provider-ovn certificate is now checked regularly along with other oVirt certificates (such as engine CA, engine or hypervisors) and if ovirt-provider-ovn is going to expire or already expired, the warning or alert is being raised into audit log. To renew ovirt-provider-ovn certificate administators need to run engine-setup.

   If your ovirt-provider-ovn certificate expires on previous oVirt version, please upgrade to oVirt 4.5 batch 2 or newer, and ovirt-provider-ovn certificate will be renewed automatically as a part of engine-setup
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

 - [BZ 2097558](https://bugzilla.redhat.com/show_bug.cgi?id=2097558) **Renew ovirt-provider-ovn.cer certificates during engine-setup**
 - [BZ 1853924](https://bugzilla.redhat.com/show_bug.cgi?id=1853924) **Fails to import template as OVA from the given configuration if the VM is not removed**
 - [BZ 1955388](https://bugzilla.redhat.com/show_bug.cgi?id=1955388) **Auto Pinning Policy only pins some of the vCPUs on a single NUMA host**
 - [BZ 1257644](https://bugzilla.redhat.com/show_bug.cgi?id=1257644) **Starting VM with snapshot with memory conflicts with later VM properties changes**
 - [BZ 2104115](https://bugzilla.redhat.com/show_bug.cgi?id=2104115) **oVirt 4.5 cannot import VMs with cpu pinning**
 - [BZ 2096862](https://bugzilla.redhat.com/show_bug.cgi?id=2096862) **Certificate Warn period and automatic renewal via engine-setup do not match**
 - [BZ 2097725](https://bugzilla.redhat.com/show_bug.cgi?id=2097725) **Certificate Warn period and automatic renewal via engine-setup do not match**

#### oVirt Engine Data Warehouse

 - [BZ 2113980](https://bugzilla.redhat.com/show_bug.cgi?id=2113980) **engine-setup on a separate machine fails with: 'Plugin' object has no attribute '_remote_engine'**

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

 - [BZ 2018796](https://bugzilla.redhat.com/show_bug.cgi?id=2018796) **I/O operations/sec reporting wrong values**
 - [BZ 2077666](https://bugzilla.redhat.com/show_bug.cgi?id=2077666) **Block copy image from local storage domain to Lightbits Labs MBS**
 - [BZ 2104806](https://bugzilla.redhat.com/show_bug.cgi?id=2104806) **Moving a compressed qcow to a block storage domain fails**
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
 - [BZ 2076053](https://bugzilla.redhat.com/show_bug.cgi?id=2076053) **Console disconnect action delay field in the database is set to the type smallint while from UI and REST the field type is integer**
 - [BZ 1915029](https://bugzilla.redhat.com/show_bug.cgi?id=1915029) **[VEEAM] Check incremental backup by default when creating a new disk**
 - [BZ 1904962](https://bugzilla.redhat.com/show_bug.cgi?id=1904962) **Can't import guest from VMware on rhv4.4 GUI if guest disk has special character**

#### oVirt Engine API Model

 - [BZ 2106349](https://bugzilla.redhat.com/show_bug.cgi?id=2106349) **VM pool creation with SPICE display type from a template with VNC display type sets the pool's display type to VNC**

### No Doc Update

#### VDSM

 - [BZ 2102678](https://bugzilla.redhat.com/show_bug.cgi?id=2102678) **vdsmd uses ~ 100% cpu on HostedEngine VM start and stop**

#### oVirt Engine

 - [BZ 2016341](https://bugzilla.redhat.com/show_bug.cgi?id=2016341) **Allocating VM from a Pool shows popup with UNKNOWN values**
 - [BZ 2084530](https://bugzilla.redhat.com/show_bug.cgi?id=2084530) **Vm vnic with port-mirroring hot-plug succeeds but is not reported in oVirt DB for over 60 sec**
 - [BZ 1939284](https://bugzilla.redhat.com/show_bug.cgi?id=1939284) **clusterPolicyWeightFunctionInfo tooltip needs improvement in relation to Rank Selector policy unit.**
 - [BZ 2100417](https://bugzilla.redhat.com/show_bug.cgi?id=2100417) **Improve error message for timeout deploy error.**

#### oVirt Engine API Model

 - [BZ 1974974](https://bugzilla.redhat.com/show_bug.cgi?id=1974974) **Not possible to determine migration policy from the API, even though documentation reports that it can be done.**



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

#### ovirt-engine-extension-aaa-ldap

 - [BZ 2068741](https://bugzilla.redhat.com/show_bug.cgi?id=2068741) **[RFE] Update dependency on UnboundID LDAP SDK for Java to 6.0.4**

   unboundid-ldapsdk &gt;= 6.0.4 is now required for ovirt-engine-extension-aaa-ldap

#### oVirt Engine

 - [BZ 2101474](https://bugzilla.redhat.com/show_bug.cgi?id=2101474) **Keycloak Administration Console URL should be displayed at the end of engine-setup along with webadmin URL when bundled Keycloak integration is enabled**

   There are now displayed Keycloak related information at the end of engine-setup summary, such as administrator username and Keycloak administration console URL.

#### openvswitch

 - [BZ 2113068](https://bugzilla.redhat.com/show_bug.cgi?id=2113068) **oVirt 4.5+  logrotate fails for ovn due to incorrect permissions of /var/log/ovn**

   During upgrade of OVS/OVN 2.11 to OVS 2.15/OVN 2021 we are now updating permissions correctly for /var/log/ovn directory

### Enhancements

#### otopi

 - [BZ 2095135](https://bugzilla.redhat.com/show_bug.cgi?id=2095135) **[RFE] Wrap notes with long lines more nicely**

   otopi based tools will display long lines in a nicer way when executed in smaller console windows.

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

#### ovirt-release

 - [BZ 2100002](https://bugzilla.redhat.com/show_bug.cgi?id=2100002) **Updating ovirt-node installs old ovirt-node-ng-image-update-placeholder**

### No Doc Update

#### ovirt-ansible-collection

 - [BZ 2016638](https://bugzilla.redhat.com/show_bug.cgi?id=2016638) **Document that "vm_name" parameter should be specified for Ansible "ovirt_disk" extend attached disk flow**
 - [BZ 2097333](https://bugzilla.redhat.com/show_bug.cgi?id=2097333) **Fix ansible-lint 6.0.0 for hosted_engine_setup and shutdown_env**
 - [BZ 2102616](https://bugzilla.redhat.com/show_bug.cgi?id=2102616) **Cluster upgrade not sequential and marked as completed too early**
 - [BZ 2107063](https://bugzilla.redhat.com/show_bug.cgi?id=2107063) **[HE] ansible-role is calling ovn-config without specifying the host FQDN**

#### VDSM

 - [BZ 2084171](https://bugzilla.redhat.com/show_bug.cgi?id=2084171) **[c9s] failing to setup network**
 - [BZ 2108974](https://bugzilla.redhat.com/show_bug.cgi?id=2108974) **Regression with bridge_opts while setting priority parameter via oVirt - 'priority is not a valid nmstate bridge option'(code revert)**

#### oVirt Engine

 - [BZ 2088446](https://bugzilla.redhat.com/show_bug.cgi?id=2088446) **pki enroll request failure**

#### otopi

 - [BZ 2114928](https://bugzilla.redhat.com/show_bug.cgi?id=2114928) **Upgrade otopi to 1.10.2**

#### redhat-release-virtualization-host

 - [BZ 2109393](https://bugzilla.redhat.com/show_bug.cgi?id=2109393) **Upgrade redhat-release-virtualization-host to 4.5.2**

### Contributors

113 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine-api-model)
	Ala Hino (Contributed to: ovirt-engine-api-model)
	Albert Esteve (Contributed to: ovirt-imageio, vdsm)
	Aleksei Slaikovskii (Contributed to: ovirt-engine-api-model)
	Alexey Slaykovsky (Contributed to: ovirt-engine-api-model)
	Aleš Musil (Contributed to: ovirt-engine-api-model)
	Allon Mureinik (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Alona Kaplan (Contributed to: ovirt-engine-api-model)
	Amit Aviram (Contributed to: ovirt-engine-api-model)
	Andrej Cernek (Contributed to: ovirt-engine-api-model)
	Andrej Krejcir (Contributed to: ovirt-engine-api-model)
	Arik Hadas (Contributed to: ovirt-engine, ovirt-engine-api-model)
	ArtiomDivak (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-api-model, ovirt-engine-keycloak, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: cockpit-ovirt, ovirt-hosted-engine-setup)
	Avital Pinnick (Contributed to: ovirt-engine-api-model)
	Aviv Litman (Contributed to: ovirt-dwh)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Bohdan Iakymets (Contributed to: ovirt-engine-api-model)
	Byron Gravenorst (Contributed to: ovirt-engine-api-model)
	Dana Elfassy (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Daniel Erez (Contributed to: ovirt-engine-api-model)
	David Caro (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Dax Kelson (Contributed to: cockpit-ovirt)
	Denis Chaplygin (Contributed to: ovirt-engine-api-model)
	Dominik Holler (Contributed to: ovirt-engine-api-model)
	Donna DaCosta (Contributed to: ovirt-engine-api-model)
	Eitan Raviv (Contributed to: ovirt-engine, ovirt-engine-api-model, vdsm)
	Eli Marcus (Contributed to: ovirt-engine-api-model)
	Eli Mesika (Contributed to: ovirt-engine-api-model)
	Eyal Shenitzky (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Fedor Gavrilov (Contributed to: ovirt-engine-api-model)
	Fred Rolland (Contributed to: ovirt-engine-api-model)
	Harel Braha (Contributed to: vdsm)
	Idan Shaby (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Irit Goihman (Contributed to: ovirt-engine-api-model)
	Jakub Niedermertl (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Jean-Louis Dupond (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Jenny Tokar (Contributed to: ovirt-engine-api-model)
	Joey Ma (Contributed to: ovirt-engine-api-model)
	Juan Hernandez (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Julien Wang (Contributed to: ovirt-engine-api-model)
	Karthikeyan Singaravelan (Contributed to: mom)
	Leon Goldberg (Contributed to: ovirt-engine-api-model)
	Lev Veyde (Contributed to: ovirt-hosted-engine-setup)
	Liran Rotenberg (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Liron Aravot (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Lucia Jelinkova (Contributed to: ovirt-engine, ovirt-engine-api-model, ovirt-engine-ui-extensions)
	Lucy Bopf (Contributed to: ovirt-engine-api-model)
	Lukas Svaty (Contributed to: ovirt-engine-api-model)
	Lukianov Artyom (Contributed to: ovirt-engine-api-model)
	Maor Lipchuk (Contributed to: ovirt-engine-api-model)
	Marcin Mirecki (Contributed to: ovirt-engine-api-model)
	Marcin Sobczyk (Contributed to: ovirt-engine, vdsm)
	Marek Libra (Contributed to: ovirt-engine-api-model)
	Mark Kemel (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Martin Betak (Contributed to: ovirt-engine-api-model)
	Martin Mucha (Contributed to: ovirt-engine-api-model)
	Martin Nečas (Contributed to: ovirt-engine, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-api-metamodel, ovirt-engine-api-model, python-ovirt-engine-sdk4, vdsm-jsonrpc-java)
	Martin Sivak (Contributed to: ovirt-engine-api-model)
	Megan Lewis (Contributed to: ovirt-engine-api-model)
	Michal Skrivanek (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Miguel Duarte Barroso (Contributed to: ovirt-engine-api-model)
	Milan Zamazal (Contributed to: ovirt-engine, ovirt-engine-api-model, vdsm)
	Miroslava Voglova (Contributed to: ovirt-engine-api-model)
	Mor Kalfon (Contributed to: ovirt-engine-api-model)
	Moshe Sheena (Contributed to: ovirt-engine-api-model)
	Moti Asayag (Contributed to: ovirt-engine-api-model)
	Nir Soffer (Contributed to: ovirt-engine-api-model, ovirt-imageio, python-ovirt-engine-sdk4, vdsm)
	Ondra Machacek (Contributed to: ovirt-engine-api-metamodel, ovirt-engine-api-model)
	Ori Ben Sasson (Contributed to: ovirt-engine-api-model)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-api-metamodel, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Oved Ourfali (Contributed to: ovirt-engine-api-model)
	Pavel Bar (Contributed to: ovirt-engine, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Petr Horáček (Contributed to: ovirt-engine-api-model)
	Phillip Bailey (Contributed to: ovirt-engine-api-model)
	Piotr Kliczewski (Contributed to: ovirt-engine-api-model)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-engine-api-model, ovirt-web-ui)
	Ramesh Nachimuthu (Contributed to: ovirt-engine-api-model)
	Ravi Nori (Contributed to: ovirt-engine-api-model)
	Ritesh Chikatwar (Contributed to: cockpit-ovirt, ovirt-engine-api-model)
	Roman Mohr (Contributed to: ovirt-engine-api-model)
	Roy Golan (Contributed to: ovirt-engine-api-model)
	Sahina Bose (Contributed to: ovirt-engine-api-model)
	Saif Abu Saleh (Contributed to: ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, mom, ovirt-engine, ovirt-engine-api-model, python-ovirt-engine-sdk4, vdsm-jsonrpc-java)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-api-model, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shahar Havivi (Contributed to: ovirt-engine-api-model)
	Shani Leviim (Contributed to: ovirt-engine, ovirt-engine-api-metamodel, ovirt-engine-api-model, python-ovirt-engine-sdk4)
	Sharon Gratch (Contributed to: cockpit-ovirt, ovirt-engine-api-model, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Leib Melamud (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Shmuel Melamud (Contributed to: ovirt-engine, ovirt-engine-api-model)
	Shubham Dubey (Contributed to: ovirt-engine-api-model)
	Slitmano (Contributed to: ovirt-engine-api-model)
	StLuke (Contributed to: ovirt-engine-api-model)
	Steve Goodman (Contributed to: ovirt-engine-api-model)
	Steven Rosenberg (Contributed to: ovirt-engine-api-model)
	Tahlia Richardson (Contributed to: ovirt-engine-api-model)
	Tal Nisan (Contributed to: ovirt-engine-api-model)
	Tomas Jelinek (Contributed to: ovirt-engine-api-model)
	Tomáš Golembiovský (Contributed to: mom, ovirt-engine, ovirt-engine-api-model, vdsm)
	Vered Volansky (Contributed to: ovirt-engine-api-model)
	Viktor Mihajlovski (Contributed to: ovirt-engine-api-model)
	Vinzenz Feenstra (Contributed to: ovirt-engine-api-model)
	Vojtěch Juránek (Contributed to: vdsm)
	Yanir Quinn (Contributed to: ovirt-engine-api-model)
	Yaniv Bronhaim (Contributed to: ovirt-engine-api-model)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine, vdsm)
	Yevgeny Zaspitsky (Contributed to: ovirt-engine-api-model)
	borod108 (Contributed to: ovirt-engine-api-model)
	rob (Contributed to: python-ovirt-engine-sdk4)
	rokkbert (Contributed to: vdsm)
