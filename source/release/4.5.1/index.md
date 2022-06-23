---
title: oVirt 4.5.1 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.1 release as of June 22, 2022.

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

To learn about features introduced before 4.5.1, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL 8.6 or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.



## What's New in 4.5.1?

### Release Note

#### VDSM

 - [BZ 2081359](https://bugzilla.redhat.com/show_bug.cgi?id=2081359) **IPoIB interfaces not reported by supervdsm network_caps**

   Infiniband interface are now being reported in vdsm capabilities.

#### oVirt Engine

 - [BZ 2090670](https://bugzilla.redhat.com/show_bug.cgi?id=2090670) **Host upgrade 4.4.[23] to 4.5 failed on network-scripts-openvswitch2.1x conflict**

   network-scripts-openvswitch2.11 was a weak dependency in some older verssionn of OVS 2.11, but it's no longer needed in recent OVS 2.11 version, so host upgrade is going to uninstall that package prior to upgrade to OVS 2.15 to prevent conflicts
 - [BZ 2087738](https://bugzilla.redhat.com/show_bug.cgi?id=2087738) **ovirt-engine is not able to kill hanged ansible-runner process after execution timeout passed**

   ansible-runner stop command is executed to kill ansibe-runner process after execution timeout. If there is an error during the operation, then we just log the error.
 - [BZ 2087886](https://bugzilla.redhat.com/show_bug.cgi?id=2087886) **ipmilan fencing agent configuration panel misses port option and passing it as option ends up with losing the parameter**

   port option will be always visible for ipmilan fence agent, so admin can override the default port directy (and not using options field) if needed
 - [BZ 2072626](https://bugzilla.redhat.com/show_bug.cgi?id=2072626) **oVirt Engine generates SNMPv3 trap with msgAuthoritativeEngineBoots: 0 despite multiple engine restarts**

   ovirt-engine-notifier is now correctly storing SNMP EngineBoots value during service restarts, so it's possible to use SNMPv3 security level AuthPriv with ovirt-engine-notifier
 - [BZ 2077387](https://bugzilla.redhat.com/show_bug.cgi?id=2077387) **Update to 4.5 failed due to failed database schema refresh**

   If vdc_options table contains records with NULL default value (most probably as a remains from ancient versions), the upgrade to ovirt-engine-4.5.0 fails. This bug fixes the issue, so upgrade to ovirt-engine-4.5.1 is successful.

### Enhancements

#### Keycloak SSO setup for oVirt Engine

 - [BZ 2021497](https://bugzilla.redhat.com/show_bug.cgi?id=2021497) **[RFE] Install and configure Keycloak as a default SSO provider for ovirt-engine**

   Feature: 
   Replace oVirt default (internal) Single-Sign-On implementation (SSO)[1] with bundled Keycloak[2] (OpenID protocol).  

   Reason: 
   Our existing (internal) SSO supports only a limited number of authentication providers. It is an in-house implementation of OAuth protocol that required significant amount of effort on maintenance.
   The Keycloak solution enables oVirt user to use additional authentication providers in addition to JDBC or LDAP. These includes integration with 3rd party SSO providers ie. GitHub, Google, Facebook as well as with custom ones. 
   Another benefit is ability to easily configure multi step authentication to increase overall security level of the oVirt installation.

   Result: 
   oVirt administrators will be able to fully use Keycloak capabilities in terms of setting up authentication/SSO mechanism and multiple user bases. 
   Please note that default ovirt administrator user name has been changed  from 'admin' to 'admin@ovirt'  (Administrator Panel, VM Portal) and from 'admin@internal' to 'admin@ovirt@internalsso' (REST API). 
   Covered deployment scenarios are documented here[3].
   With this RFE implementation it is now possible to login to Monitoring Portal(Grafana) using 'oVirt Single Sing On'. Grafana initial admin user ('admin') is matched by email to default oVirt Administrator ('admin@ovirt')

   [1]https://ovirt.org/documentation/administration_guide/index.html#chap-Users_and_Roles
   [2]https://www.keycloak.org
   [3]https://github.com/oVirt/ovirt-engine-keycloak/blob/master/keycloak_usage.md

#### oVirt Engine

 - [BZ 1782077](https://bugzilla.redhat.com/show_bug.cgi?id=1782077) **[RFE] More Flexible oVirt CPU Allocation Policy with HyperThreading**

   Added a CPU pinning policy named "Isolate Threads" that exclusively pin a physical core to a virtual CPU. With this policy, a complete physical core can be used as a virtual core of a single virtual machine.

#### oVirt Hosted Engine Setup

 - [BZ 1881280](https://bugzilla.redhat.com/show_bug.cgi?id=1881280) **[RFE] Validate HE cluster if --restore-from-file**

   Feature: 

   Now, in 'hosted-engine --deploy --restore-from-file', the prompts asking for the data center and cluster, do not provide a default, and have better text.

   Reason: 

   On restore, it's important to provide correct input. Providing a default risked pressing 'Enter' without reading the question.

   Result: 

   Restore/Migrate/Upgrade deployments are more likely to succeed.

   It's important to clarify that what is "correct" is dependent on the specific scenario/condition and can't be guessed by the tool.

### Bug Fixes

#### VDSM

 - [BZ 2090169](https://bugzilla.redhat.com/show_bug.cgi?id=2090169) **Invalid entry in /etc/multipath/wwids causes unbootable ovirt-node**
 - [BZ 2048545](https://bugzilla.redhat.com/show_bug.cgi?id=2048545) **Bogus errors and warning when looking up NFS storage domain using LVM**
 - [BZ 2090156](https://bugzilla.redhat.com/show_bug.cgi?id=2090156) **Migration fails of VM's with VNC password &gt; 8 chars**
 - [BZ 2055905](https://bugzilla.redhat.com/show_bug.cgi?id=2055905) **Virtual Machine with large number of Direct LUNs failed to migrate without adjusting vars/migration_listener_timeout**
 - [BZ 1853897](https://bugzilla.redhat.com/show_bug.cgi?id=1853897) **Preserve guest agent info during live migration**
 - [BZ 2081493](https://bugzilla.redhat.com/show_bug.cgi?id=2081493) **Preallocated COW volume is reduced by cold merge**
 - [BZ 2077008](https://bugzilla.redhat.com/show_bug.cgi?id=2077008) **guest cpu count not working for RHEL8 guests**

#### oVirt Engine

 - [BZ 2081556](https://bugzilla.redhat.com/show_bug.cgi?id=2081556) **[admin portal] Unable to clone vm from snapshot if VM has preallocated COW disk (incremental)**
 - [BZ 2079760](https://bugzilla.redhat.com/show_bug.cgi?id=2079760) **vGPU: VM failed to run with more than one vGPU instance**
 - [BZ 2006625](https://bugzilla.redhat.com/show_bug.cgi?id=2006625) **Engine generates VDS_HIGH_MEM_USE events for empty hosts that have most memory reserved by huge pages**
 - [BZ 2089803](https://bugzilla.redhat.com/show_bug.cgi?id=2089803) **Rename tool fails on missing key shortLife**
 - [BZ 2081241](https://bugzilla.redhat.com/show_bug.cgi?id=2081241) **VFIO_MAP_DMA failed: Cannot allocate memory -12 (VM with GPU passthrough, Q35 machine and 16 vcpus)**
 - [BZ 2001574](https://bugzilla.redhat.com/show_bug.cgi?id=2001574) **Memory usage on Windows client browser while using move or copy disk operations on Admin web**

### Other

#### VDSM

 - [BZ 2083302](https://bugzilla.redhat.com/show_bug.cgi?id=2083302) **CPU pinning not replaced when resuming hibernated VM with CPU policy 'Dedicated'**
 - [BZ 2078569](https://bugzilla.redhat.com/show_bug.cgi?id=2078569) **Gluster status is disconnected for this host.**
 - [BZ 2083271](https://bugzilla.redhat.com/show_bug.cgi?id=2083271) **iscsi: Keep existing session on "session exists"**

#### oVirt Engine

 - [BZ 1958032](https://bugzilla.redhat.com/show_bug.cgi?id=1958032) **Live Storage Migration fails because replication filled the destination volume before extension.**

   Previously, live storage migration could have failed if the destination volume filled up before being extended. Now, the initial size of the destination volume is larger, rendering the initial extension redundant and prevent the aforementioned race.
 - [BZ 2070045](https://bugzilla.redhat.com/show_bug.cgi?id=2070045) **UploadStreamVDSCommand  fails with java.net.SocketTimeoutException after 20 seconds**

   Failures to update the OVF store within 20 sec don't lead to the host switching to non-responsive state anymore.
 - [BZ 2095259](https://bugzilla.redhat.com/show_bug.cgi?id=2095259) **VM with resize_and_pin could not migrate between identical hosts.**
 - [BZ 2079605](https://bugzilla.redhat.com/show_bug.cgi?id=2079605) **Not pinned numa nodes configuration is cleared after export/import from OVA**
 - [BZ 2080718](https://bugzilla.redhat.com/show_bug.cgi?id=2080718) **NPE while trying to remove a VM during ongoing backup**
 - [BZ 2078500](https://bugzilla.redhat.com/show_bug.cgi?id=2078500) **[RFE] Add support for parallel migration connections to the REST API**
 - [BZ 2094415](https://bugzilla.redhat.com/show_bug.cgi?id=2094415) **When running Isolate Thread VM , the CPU that must be reserved for VDSM is taken**
 - [BZ 2081294](https://bugzilla.redhat.com/show_bug.cgi?id=2081294) **Snapshot failure causes inconsistency**
 - [BZ 2079267](https://bugzilla.redhat.com/show_bug.cgi?id=2079267) **Secure Intel Nehalem/Westmere Family require md_clear flag**
 - [BZ 1949004](https://bugzilla.redhat.com/show_bug.cgi?id=1949004) **Bochs display is not set by default when creating new server VM with UEFI**
 - [BZ 2074522](https://bugzilla.redhat.com/show_bug.cgi?id=2074522) **Resize_and_pin policy can't be configured in one transaction if user sets vCPUS, Host pinning and policy.**
 - [BZ 2090682](https://bugzilla.redhat.com/show_bug.cgi?id=2090682) **[VEEAM] VM can't be backed up again if user power offs it during hybrid backup**
 - [BZ 2081410](https://bugzilla.redhat.com/show_bug.cgi?id=2081410) **Allow setting numa count without host pinning**
 - [BZ 2023368](https://bugzilla.redhat.com/show_bug.cgi?id=2023368) **Importing VM OVA fails with ERROR: insert or update on table "vm_static" violates foreign key constraint "fk_vm_static_lease_sd_i d_storage_domain_static_id"**
 - [BZ 2072423](https://bugzilla.redhat.com/show_bug.cgi?id=2072423) **Disk is being copied with wrong allocation policy**
 - [BZ 1900552](https://bugzilla.redhat.com/show_bug.cgi?id=1900552) **[CBT][incremental backup] VmBackup.finalize synchronous instead of asynchronous**
 - [BZ 2076072](https://bugzilla.redhat.com/show_bug.cgi?id=2076072) **Improve error message for screenshot on headless VM**
 - [BZ 2080752](https://bugzilla.redhat.com/show_bug.cgi?id=2080752) **VMs and VM pools that are created from a template are not set with the number of virtio-scsi multi-queue queues from the template**
 - [BZ 2039746](https://bugzilla.redhat.com/show_bug.cgi?id=2039746) **'Cannt remove Virtual Disk ${DiskName} is being moved or copied' message appear when trying to delete disk in rhv**
 - [BZ 2066078](https://bugzilla.redhat.com/show_bug.cgi?id=2066078) **Remove VM fails - [Cannot remove VM: VM is locked] but the VM is not locked.**
 - [BZ 2065068](https://bugzilla.redhat.com/show_bug.cgi?id=2065068) **Too large subtable console errors in engine admin portal**
 - [BZ 2048429](https://bugzilla.redhat.com/show_bug.cgi?id=2048429) **VFIO_MAP_DMA failed: Cannot allocate memory -12 (VM with GPU passthrough, Q35 machine and 16 vcpus)**
 - [BZ 2078193](https://bugzilla.redhat.com/show_bug.cgi?id=2078193) **Switching Chipset/Firmware Type will automatically modify the console Graphics protocol**
 - [BZ 2080758](https://bugzilla.redhat.com/show_bug.cgi?id=2080758) **Cloning a VM with a different number of virtio-scsi multi-queue queues from the original VM doesn't reflect on the cloned VM**
 - [BZ 2080766](https://bugzilla.redhat.com/show_bug.cgi?id=2080766) **Hybrid Backup - Creating a snapshot during backup finalization causes the backup to fail.**
 - [BZ 2080728](https://bugzilla.redhat.com/show_bug.cgi?id=2080728) **[CBT] [REST-API] Actions and backup disks link for hybrid backups are sometimes missing in /api/vms/&lt;vm-id&gt;/backups**
 - [BZ 2076047](https://bugzilla.redhat.com/show_bug.cgi?id=2076047) **Disk convert on block type might raise "No space left on device" and fail to convert**
 - [BZ 2070451](https://bugzilla.redhat.com/show_bug.cgi?id=2070451) **Deletion of  multiple snapshot  from the UI ( count= 10 ) ,by name :  "Forklift Operator warm migration precopy"  failed exit on error " Failed Removing Disks from Snapshot(s) "**
 - [BZ 2013696](https://bugzilla.redhat.com/show_bug.cgi?id=2013696) **[REST API] Incorrect disk snapshot returned for GET api/disks/xxx/disksnapshots/xxx request**
 - [BZ 2076054](https://bugzilla.redhat.com/show_bug.cgi?id=2076054) **Disconnect action delay property isn't copied from template on VMPool creation via RestAPI**
 - [BZ 2076042](https://bugzilla.redhat.com/show_bug.cgi?id=2076042) **Error in engine.log when converting disk format/allocation policy**
 - [BZ 2065543](https://bugzilla.redhat.com/show_bug.cgi?id=2065543) **First host report turns host non-operational with FIPS_INCOMPATIBLE_WITH_CLUSTER**

### No Doc Update

#### VDSM

 - [BZ 2075795](https://bugzilla.redhat.com/show_bug.cgi?id=2075795) **"Too many open files" error causes vdsm not being able to work properly**

#### oVirt Engine

 - [BZ 1852308](https://bugzilla.redhat.com/show_bug.cgi?id=1852308) **Snapshot fails to create with 'Invalid parameter: 'capacity=1073741824'' Exception**

#### oVirt Engine UI Extensions

 - [BZ 2095346](https://bugzilla.redhat.com/show_bug.cgi?id=2095346) **cluster upgrade wizard does not handle host name selection correctly**



## Also includes

### Release Note

#### ovirt-ansible-collection

 - [BZ 1930643](https://bugzilla.redhat.com/show_bug.cgi?id=1930643) **Adding HA lease for VM, next actions on VMs will fail**

   wait_after_lease option has been added to ovirt_vm Ansible module to provide delay to finish creating VM lease.
 - [BZ 1996098](https://bugzilla.redhat.com/show_bug.cgi?id=1996098) **[RFE] Provide options for 'Disable Spice file transfer', 'Disable spice clipboard copy and paste'**

   Options copy_paste_enabled and file_transfer_enabled have been added to ovirt_vm Ansibe moudle
 - [BZ 2079896](https://bugzilla.redhat.com/show_bug.cgi?id=2079896) **'Update storage parameters' changes iscsi connection list in engine DB**

   infra role in oVirt Ansible Collection supports storage domains using a single storage connection only. If you need to create storage domain with multiple storage connections, then you need to do that either with ovirt_storage_domain Ansible module directly or using SDK, RESTAPI or webadmin UI.
 - [BZ 2090331](https://bugzilla.redhat.com/show_bug.cgi?id=2090331) **Ansible ovirt_vm module should fail if snapshot_name doesn't exist**

   ovirt_vm Ansibe module will throw an error if a snapshort with specified name doesn't exist.

#### oVirt Engine

 - [BZ 2099650](https://bugzilla.redhat.com/show_bug.cgi?id=2099650) **Update to 4.5 failed due to failed database schema refresh**

   If vdc_options table contains records with NULL default value (most probably as a remains from ancient versions), the upgrade to ovirt-engine-4.5.0 fails. This bug fixes the issue, so upgrade to ovirt-engine-4.5.1 is successful.

### Enhancements

#### oVirt Engine

 - [BZ 1663217](https://bugzilla.redhat.com/show_bug.cgi?id=1663217) **[RFE] Add oVirt VM name to the matching between Satellite's content host to oVirt (currently only VM FQDN is used)**

   The hostname and/or FQDN of the VM or VDSM host can change after a virtual machine (VM) is created. Previously, this change could prevent the VM from fetching errata from Red Hat Satellite/Foreman. With this enhancement, they can fetch the errata even after the VM hostname or FQDN changes.

   To match content hosts in Red Hat Satellite/Foreman with virtual machines in the oVirt Engine/oVirt engine, the matching algorithm queries Satellite/Foreman using the following criteria in the order shown:

   The host and virtual machine ID (facts.dmi::system::uuid)
   The virtual machine's FQDN (facts.network::fqdn)
   The host and virtual machine name (facts.network::hostname). (This criterion preserves the hostname fact for backward compatibility.)

   If the criterion value is present, not null, the algorithm matches the host to the virtual machine. Otherwise, it uses the next criterion. If no match is found, it returns the content host.

   One motivation for using these multi-step checks is that potential changes in VM / host, like a change in FQDN, are reflected in Satellite/Foreman with a delay. The only non-changing property is the ID. For the Manager/Engine host, only the engine host is used, as before.
 - [BZ 2027087](https://bugzilla.redhat.com/show_bug.cgi?id=2027087) **[RFE] Warn the user on too many hosted-engine hosts**

   We are supporting only 7 hosts with hosted engine configuration in the hosted engine cluster. There might be raised issues when there are more than 7 active hosts with hosted engine configuration, but up until now we haven't been showing any warning about it.

   From oVirt Engine 4.5 if administrators will try to install more than 7 hosts with active hosted engine configuration, there will be raised a warning in the audit log about it.

   If administrators have a strong reason to change that 7 hosts limit, they could create `/etc/ovirt-engine/engine.conf.d/99-max-he-hosts.conf` file with following content:

     `MAX_RECOMMENDED_HE_HOSTS=NNN`

   where `NNN` represents the maximum number of hosts with active hosted engine configuration before above warning is raised.

   Be aware that 7 is the maximum number of officially supported active hosts with hosted engine configuration, so administrators should decrease number of such hosts below 7 to eliminate issues around hosted engine .

#### ovirt-ansible-collection

 - [BZ 1937408](https://bugzilla.redhat.com/show_bug.cgi?id=1937408) **[RFE] Add ability to import template from OVA in image_template role**

   Following options has been added to ovirt_template module:

    kvm:
      - Dictionary of values to be used to connect to kvm and import a template to oVirt.
      - Following keys can be specified within the dictionary

        url:
          - The URL to be passed to the I(virt-v2v) tool for conversion.
          - For example I(qemu:///system). This is required parameter.

        storage_domain:
          - Specifies the target storage domain for converted disks. This is required parameter.

        host:
          - The host name from which the template will be imported.
 
        clone:
          - Indicates if the identifiers of the imported template should be regenerated.

#### virt-viewer

 - [BZ 1999167](https://bugzilla.redhat.com/show_bug.cgi?id=1999167) **[SPICE] RFE: Cannot change CD with ISO in oVirt Data domain**

   Feature: 
   Change CD from a Data Storage Domain

   Reason:
   oVirt now allows keeping ISO images on Data Storage Domains.

   Result:
   If a oVirt ISO Storage Domain does not exist, remote-viewer now allows to Change CD from a Data Storage Domain.
   If a oVirt ISO Storage Domain does exist, it is used.
   If no oVirt ISO Storage Domain exists and multiple Data Storage Domain exist, only one of them is used (the first one on the list that remote-viewer gets from oVirt).

### Bug Fixes

#### oVirt Engine

 - [BZ 1994144](https://bugzilla.redhat.com/show_bug.cgi?id=1994144) **[oVirt 4.4.6] Mail recipient is not updated while configuring Event Notifications**
 - [BZ 2001923](https://bugzilla.redhat.com/show_bug.cgi?id=2001923) **NPE during RemoveSnapshotSingleDisk command**
 - [BZ 2068270](https://bugzilla.redhat.com/show_bug.cgi?id=2068270) **oVirt Engine Admin Portal gives '500 - Internal Server Error" with command_entities in EXECUTION_FAILED status**

#### ovirt-ansible-collection

 - [BZ 2076200](https://bugzilla.redhat.com/show_bug.cgi?id=2076200) **Use 128MiB instead of 1GiB for he_metadata**

#### oVirt Log Collector

 - [BZ 2081684](https://bugzilla.redhat.com/show_bug.cgi?id=2081684) **Could not collect PostgreSQL information: 'PostgresData' object has no attribute 'sos_version'**

### Other

#### oVirt Engine

 - [BZ 1858935](https://bugzilla.redhat.com/show_bug.cgi?id=1858935) **Upgrade Timeout doesn't work**
 - [BZ 1913429](https://bugzilla.redhat.com/show_bug.cgi?id=1913429) **Engine allows exceeding critical_space_action_blocker**
 - [BZ 1954427](https://bugzilla.redhat.com/show_bug.cgi?id=1954427) **[CBT] Image transfer cannot be stopped after failed to download missing backup disk**
 - [BZ 1975596](https://bugzilla.redhat.com/show_bug.cgi?id=1975596) **[RFE] Enhancement of oVirt monitoring by SNMP to merge each alert message into a single line**
 - [BZ 1976607](https://bugzilla.redhat.com/show_bug.cgi?id=1976607) **Deprecate QXL**

   VGA is now used for new virtual machines instead of QXL. This also introduces a way to switch from QXL to VGA using the API:
   1. Remove the graphic and video devices (make the vm headless)
   2. Add VNC graphic device
 - [BZ 2004350](https://bugzilla.redhat.com/show_bug.cgi?id=2004350) **[MBS] Block creation of a template from vm snapshot using MBS disk**
 - [BZ 2046689](https://bugzilla.redhat.com/show_bug.cgi?id=2046689) **Creating a VM from Template (clone) does not copy/unable to set backup property**
 - [BZ 2075188](https://bugzilla.redhat.com/show_bug.cgi?id=2075188) **Add support for Georgian language as a community translation**
 - [BZ 2076100](https://bugzilla.redhat.com/show_bug.cgi?id=2076100) **Two VMs with summary CPU more then host CPU are allowed to run on the same host.**
 - [BZ 2090264](https://bugzilla.redhat.com/show_bug.cgi?id=2090264) **[DR] Failed to generate mapping files due to import ansible module that was not found**

#### ovirt-ansible-collection

 - [BZ 2020624](https://bugzilla.redhat.com/show_bug.cgi?id=2020624) **[RFE] support satellite registration with repositories role**

#### VDSM

 - [BZ 2064907](https://bugzilla.redhat.com/show_bug.cgi?id=2064907) **[RFE] Support measuring sub chain**

#### oVirt Log Collector

 - [BZ 2081676](https://bugzilla.redhat.com/show_bug.cgi?id=2081676) **--log-size option does not limit the size of the logs from the hypervisor**

### No Doc Update

#### oVirt Engine

 - [BZ 1849045](https://bugzilla.redhat.com/show_bug.cgi?id=1849045) **Differences between apidoc and REST API documentation about exporting VMs and templates to OVA**
 - [BZ 2073074](https://bugzilla.redhat.com/show_bug.cgi?id=2073074) **failing to set tuned profile on oVirt Node with Gluster Mode**
 - [BZ 2089332](https://bugzilla.redhat.com/show_bug.cgi?id=2089332) **DISA-STIG profile sets default umask that fails HE install**
 - [BZ 2089856](https://bugzilla.redhat.com/show_bug.cgi?id=2089856) **[TestOnly] Bug 2015796 - [RFE] oVirt Engine should support running on a host with DISA STIG security profile applied**

#### collectd

 - [BZ 1868372](https://bugzilla.redhat.com/show_bug.cgi?id=1868372) **collectd-virt plugin doesn't work with latest libvirt**

#### ovirt-ansible-collection

 - [BZ 1932147](https://bugzilla.redhat.com/show_bug.cgi?id=1932147) **[RFE] Support specifying storage domain format (V3, V4, V5...) in ansible ovirt_storage_domain module**

#### ovirt-distribution

 - [BZ 1978582](https://bugzilla.redhat.com/show_bug.cgi?id=1978582) **[RFE] Create follow parameter documentation**

#### ovirt-node

 - [BZ 2005257](https://bugzilla.redhat.com/show_bug.cgi?id=2005257) **oVirt-node 4.5 based on CentOS Stream 9: Missing help info during anaconda interactive installation**

#### VDSM

 - [BZ 2014865](https://bugzilla.redhat.com/show_bug.cgi?id=2014865) **Errors hidden in %posttrans scriptlet**

### Contributors

37 people contributed to this release:

	Albert Esteve (Contributed to: ovirt-engine, vdsm)
	Aleš Musil (Contributed to: vdsm)
	Anton Fadeev (Contributed to: ovirt-engine)
	Arik Hadas (Contributed to: ovirt-engine, vdsm)
	ArtiomDivak (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-dwh, ovirt-engine, ovirt-engine-keycloak)
	Asaf Rachmani (Contributed to: ovirt-dwh, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Denis Volkov (Contributed to: ovirt-engine-keycloak)
	Eitan Raviv (Contributed to: vdsm)
	Eli Mesika (Contributed to: ovirt-engine)
	Harel Braha (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-log-collector)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: ovirt-engine, ovirt-web-ui, vdsm)
	Mark Kemel (Contributed to: ovirt-engine)
	Martin Nečas (Contributed to: ovirt-engine)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-keycloak)
	Michal Skrivanek (Contributed to: ovirt-dwh, ovirt-engine, vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: ovirt-imageio, vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Pavel Bar (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-web-ui)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-hosted-engine-setup, ovirt-release, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-engine, ovirt-hosted-engine-setup)
	fadeev (Contributed to: ovirt-engine)
	kurokobo (Contributed to: ovirt-web-ui)
	rchikatw (Contributed to: vdsm)
