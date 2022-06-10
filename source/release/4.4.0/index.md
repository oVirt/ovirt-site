---
title: oVirt 4.4.0 Release Notes
category: documentation
toc: true
authors:
  - sandrobonazzola
  - lveyde
page_classes: releases
---

# oVirt 4.4.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.0 release as of May 20, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.1 and
CentOS Linux 8.1 (or similar).



If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.0, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.4.0?

### Release Note

#### oVirt Release Package

 - [BZ 1745302](https://bugzilla.redhat.com/show_bug.cgi?id=1745302) **ovirt-guest-tools has been obsoleted by virtio-win guest tools**

   oVirt 4.4 replaces the ovirt-guest-tools a with a new WiX-based installer, included in Virtio-Win. You can download the ISO file containing the Windows guest drivers, agents and installers from https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/


### Enhancements

#### oVirt Setup Lib

 - [BZ 1546838](https://bugzilla.redhat.com/show_bug.cgi?id=1546838) **[RFE] Refuse to deploy on localhost.localdomain**

   The current release displays a new warning when you use 'localhost' as an FQDN: "[WARNING] Using the name 'localhost' is not recommended, and may cause problems later on."


#### oVirt Host Dependencies

 - [BZ 1725775](https://bugzilla.redhat.com/show_bug.cgi?id=1725775) **Replace screen requirement with tmux**

   Before this update, `screen` was installed on hosts. With this update, `screen` is removed, and `tmux` is installed on hosts instead.



`screen` was deprecated in RHEL 7.6, and is not included with RHEL 8.


#### oVirt Ansible hosted-engine setup role

 - [BZ 1816619](https://bugzilla.redhat.com/show_bug.cgi?id=1816619) **[RFE] Enable update of appliance from channels after VM is deployed**

   Feature: Change the default value of Hosted Engine deployment to update engine VM packages.

Add the ability to run engine-setup offline deployment in order to avoid updates.



Reason: Get an updated engine VM. 



Result: Packages will be updated.

 - [BZ 1602816](https://bugzilla.redhat.com/show_bug.cgi?id=1602816) **[RFE] hosted-engine deployment playbook should reject bridging over a teaming device with a clear error**

   Feature: Filter Team devices in Hosted-Engine deployment



Reason: Teaming is not supported on RHV



Result: Rejecting the deployment with a clear error message in case that only Team devices are available


#### oVirt Hosted Engine Setup

 - [BZ 1641694](https://bugzilla.redhat.com/show_bug.cgi?id=1641694) **[RFE] hosted-engine --vm-start-paused should clean up any existing HE-VM.**

   Feature: After starting HE VM with qemu paused, there is an option to start HE VM using `hosted-engine --vm-start`.



Reason: Start HE VM with qemu paused, and then start it as running VM



Result: option `--vm-start` can be used after `--vm-start-paused`


#### VDSM

 - [BZ 1739557](https://bugzilla.redhat.com/show_bug.cgi?id=1739557) **RFE: add support for native TLS encryption on migration TCP transport**

   With this update, you can enable encryption for live migration of virtual machines between hosts in the same cluster, providing more protection to data transferred between hosts. 



Enable or disable encryption in the Administration Portal, in the Edit Cluster dialog box, under Migration Policy > Additional Properties. Encryption is disabled by default.

 - [BZ 1680398](https://bugzilla.redhat.com/show_bug.cgi?id=1680398) **QEMU-GA capabilities are reported as none for a few minutes after VM start. Therefore, VM details are not reported by engine**

   Mechanism for polling QEMU-GA in VDSM has been enhanced to query newly started VMs more often in order to get the stats as soon as the agent becomes available in guest.

 - [BZ 1780943](https://bugzilla.redhat.com/show_bug.cgi?id=1780943) **[RFE] Add timeout and abort command to async live snapshot**

   Feature: 

Now that in 4.4 we are using asynchronous job to run live snapshot. Timeout to abort this job will be possible. The engine will consume the value from engine-config and provide it to the job.



Reason: 

The asynchronous live snapshot job can be infinite, locking the specific VM. The user should have the option to provide a timeout, releasing that VM.



Result: 

A default value is set in engine-config and can be changed. In case the job will reach the timeout it will be aborted and the VM's lock will be released.

 - [BZ 1749284](https://bugzilla.redhat.com/show_bug.cgi?id=1749284) **Change the Snapshot operation to be asynchronous**

   Before this update, the live snapshot operation was synchronized, such that if VDSM required more than 180 seconds to create a snapshot, the operation failed, preventing snapshots of some virtual machines, such as those with large memory loads, or slow storage.



With this update, the live snapshot operation is asynchronous, so the operation runs until it ends successfully, regardless of how long it takes.

 - [BZ 1692709](https://bugzilla.redhat.com/show_bug.cgi?id=1692709) **[RFE] Investigate viability of automatically setting up boot partition for FIPS hosts**

   With this update, each host's boot partition is explicitly stated in the kernel boot parameters. For example: `boot=/dev/sda1` or `boot=UUID=<id>`

 - [BZ 1179273](https://bugzilla.redhat.com/show_bug.cgi?id=1179273) **[RFE] vdsm: Utilize system-wide crypto-policies**

   The VDSM's 'ssl_protocol', 'ssl_excludes' and 'ssl_ciphers' config options have been removed. 

To find our more about crypto policies, please visit:

https://www.redhat.com/en/blog/consistent-security-crypto-policies-red-hat-enterprise-linux-8



If you need to fine-tune your crypto settings you should do it by changing or creating your own crypto policy. As an example, if you need your hosts to communicate with some legacy systems that still use insecure TLSv1 or TLSv1.1, you can change your crypto policy to 'LEGACY' with: 

 update-crypto-policies --set LEGACY


#### oVirt Engine

 - [BZ 1306586](https://bugzilla.redhat.com/show_bug.cgi?id=1306586) **change Windows drivers and sysprep delivery method to a CDROM**

   The floppy device has been replaced by a CDROM device for sysprep installation of Compatibility Versions 4.4 and later.

 - [BZ 1821930](https://bugzilla.redhat.com/show_bug.cgi?id=1821930) **Enable only TLSv1.2+ protocol for SPICE on EL7 hosts**

   For RHEL 7 based hosts we configure SPICE encryption during host deployment:

  - Only TLSv1.2 and newer protocols are enabled

  - Available ciphers are limited as described in BZ1563271



For RHEL 8 based hosts we don't configure SPICE encryption at all, we completely reply on defined RHEL crypto policies (similar to VDSM BZ1179273)

 - [BZ 1679110](https://bugzilla.redhat.com/show_bug.cgi?id=1679110) **[RFE] change Admin Portal toast notifications location**

   Feature: 

Changing the location of the toast notifications area from upper right corner to lower right corner. 



Reason: 

The default top right location covers all the action buttons and is quite intrusive.



Result: 

Toast notifications are growing bottom-up from  bottom right corner up to 400px from top, while buttons of "Dismiss all" and "Do not disturb" are located below the notifications area (please see attachments for more details).

 - [BZ 1455465](https://bugzilla.redhat.com/show_bug.cgi?id=1455465) **Virt: blank template should be of 'server' type and not 'desktop' type.**

   In this release, the default "optimized for" value optimization type for bundled templates is now set to "Server".

 - [BZ 1780943](https://bugzilla.redhat.com/show_bug.cgi?id=1780943) **[RFE] Add timeout and abort command to async live snapshot**

   Feature: 

Now that in 4.4 we are using asynchronous job to run live snapshot. Timeout to abort this job will be possible. The engine will consume the value from engine-config and provide it to the job.



Reason: 

The asynchronous live snapshot job can be infinite, locking the specific VM. The user should have the option to provide a timeout, releasing that VM.



Result: 

A default value is set in engine-config and can be changed. In case the job will reach the timeout it will be aborted and the VM's lock will be released.

 - [BZ 1807400](https://bugzilla.redhat.com/show_bug.cgi?id=1807400) **Ensure o-direct options are enabled on volume used as storage domain**

   

 - [BZ 1512838](https://bugzilla.redhat.com/show_bug.cgi?id=1512838) **[RFE][UI] - Add indication that a template is a sealed template**

   Feature: 

It is now possible to see if the template has been sealed in the template list table. It is also possible to change that value in the Edit template dialog. 

Reason: 

During the template creation, it is possible to seal the template automatically (for Linux). However, it was not possible to view in the UI if the template has been sealed or not. The other OS had to be sealed manually, but it was not possible to mark the template as sealed manually. 

Result: 

The seal status is now visible and editable via UI.

 - [BZ 1798403](https://bugzilla.redhat.com/show_bug.cgi?id=1798403) **Windows drivers will auto-attach on installation of windows**

   Feature: 

Attach windows guest tools ISO when installing windows from CD-ROM.



Reason: 

Since the floppy device is removed, the user still need the windows guest tools to complete the windows installation.



Result: 

The user can run once a VM that set to windows operation system, attach the windows install CD-ROM and select auto-attaching the windows guest tools. The windows guest tools will be attached to the VM for this run.

 - [BZ 1749284](https://bugzilla.redhat.com/show_bug.cgi?id=1749284) **Change the Snapshot operation to be asynchronous**

   Before this update, the live snapshot operation was synchronized, such that if VDSM required more than 180 seconds to create a snapshot, the operation failed, preventing snapshots of some virtual machines, such as those with large memory loads, or slow storage.



With this update, the live snapshot operation is asynchronous, so the operation runs until it ends successfully, regardless of how long it takes.

 - [BZ 1692709](https://bugzilla.redhat.com/show_bug.cgi?id=1692709) **[RFE] Investigate viability of automatically setting up boot partition for FIPS hosts**

   With this update, each host's boot partition is explicitly stated in the kernel boot parameters. For example: `boot=/dev/sda1` or `boot=UUID=<id>`

 - [BZ 1726907](https://bugzilla.redhat.com/show_bug.cgi?id=1726907) **[RFE] Add RHCOS to the list of operating systems**

   With this update, you can select Red Hat CoreOS (RHCOS) as the operating system for a virtual machine. When you do so, the initialization type is set to `ignition`. RHCOS uses ignition to initialize the virtual machine, differentiating it from RHEL.

 - [BZ 1549486](https://bugzilla.redhat.com/show_bug.cgi?id=1549486) **[RFE] update landing and login pages to to be compatible with Patternfly 4**

   

 - [BZ 1739557](https://bugzilla.redhat.com/show_bug.cgi?id=1739557) **RFE: add support for native TLS encryption on migration TCP transport**

   With this update, you can enable encryption for live migration of virtual machines between hosts in the same cluster, providing more protection to data transferred between hosts. 



Enable or disable encryption in the Administration Portal, in the Edit Cluster dialog box, under Migration Policy > Additional Properties. Encryption is disabled by default.

 - [BZ 1767319](https://bugzilla.redhat.com/show_bug.cgi?id=1767319) **[RFE] forbid updating mac pool that contains ranges overlapping with any mac range in the system**

   In this release, modifying a MAC address pool or modifying the range of a MAC address pool that has any overlap with existing MAC address pool ranges, is strictly forbidden.

 - [BZ 1547937](https://bugzilla.redhat.com/show_bug.cgi?id=1547937) **[RFE] Live Storage Migration progress bar.**

   This release adds a progress bar for the disk synchronization stage of Live Storage Migration.

 - [BZ 1593800](https://bugzilla.redhat.com/show_bug.cgi?id=1593800) **[RFE] forbid new mac pools with overlapping ranges**

   When creating a new MAC address pool its ranges must not overlap with each other or with any ranges in existing MAC address pools.

 - [BZ 1696245](https://bugzilla.redhat.com/show_bug.cgi?id=1696245) **[RFE] Allow full customization while cloning a VM**

   Feature: 

When cloning VM, user is now able to customize all the fields available in the Edit VM dialog (including discs and network)

Reason: 

When cloning VM, it was not possible to clone the disks into a different storage domain as the original one. 

Result: 

The newly cloned VM is now fully customizable.

 - [BZ 1732738](https://bugzilla.redhat.com/show_bug.cgi?id=1732738) **[RFE] Update engine to use OpenJDK 11 - both build and runtime**

   Modernizing the software stack of ovirt-engine for build and runtime using java-11-openjdk.

Java 11 openjdk is the new LTS version from Red Hat.

 - [BZ 1700021](https://bugzilla.redhat.com/show_bug.cgi?id=1700021) **[RFE] engine-setup should warn and prompt if ca.pem is missing but other generated pki files exist**

   Previously, if ca.pem was not present, engine-setup automatically regenerated all PKI files, requiring you to reinstall or re-enroll certificates for all hosts. 



Now, if ca.pem is not present but other PKI files are, engine-setup prompts you to restore ca.pem from backup without regenerating all PKI files. If a backup is present and you select this option, then you no longer need to reinstall or re-enroll certificates for all hosts.

 - [BZ 1450351](https://bugzilla.redhat.com/show_bug.cgi?id=1450351) **[RFE] Allow specifying a shutdown reason on the .shutdown() call**

   With this update, you can set the reason for shutting down or powering off a virtual machine when using a REST API request to execute the shutdown or power-off.

 - [BZ 1572155](https://bugzilla.redhat.com/show_bug.cgi?id=1572155) **[RFE] provide VM status and uptime in VM general tab**

   The current release adds the VM's current state and uptime to the Compute > Virtual Machine: General tab.

 - [BZ 1325468](https://bugzilla.redhat.com/show_bug.cgi?id=1325468) **[RFE] Autostart of VMs that are down (with Engine assistance - Engine has to be up)**

   1. After a high-availability virtual machine (HA VM) crashes, the Manager tries to restart it indefinitely. At first, with a short delay between restarts. After a specified amount of failed retries, the delay is longer. The current release adds three new configuration options:

- RetryToRunAutoStartVmShortIntervalInSeconds - Is the short delay. (Default: 30 seconds)

- RetryToRunAutoStartVmLongIntervalInSeconds - Is the long delay. (Default: 30 minutes)

- NumOfTriesToRunFailedAutoStartVmInShortIntervals - Is the number of failed restarts with short delays. (Default: 10 retries)



2. The Manager starts crashed HA VMs in order of priority, delaying lower-priority VMs until higher-priority VMs are 'Up.' The current release adds a new configuration option, 'MaxTimeAutoStartBlockedOnPriority,' which sets the maximum time the Manager waits before starting a lower-priority VM. (Default: 10 minutes)

 - [BZ 1080097](https://bugzilla.redhat.com/show_bug.cgi?id=1080097) **[RFE] Allow editing disks details in the Disks tab**

   In this release, it is now possible to edit the properties of a Floating Disk in the Storage > Disks tab of Administration Portal. For example, the user can edit the Description, Alias, and Size of the disk.

 - [BZ 1652565](https://bugzilla.redhat.com/show_bug.cgi?id=1652565) **[RFE] Unable to edit floating disk**

   In this release, it is now possible to edit the properties of a Floating Disk in the Storage > Disks tab of Administration Portal. For example, the user can edit the Description, Alias, and Size of the disk.

 - [BZ 854932](https://bugzilla.redhat.com/show_bug.cgi?id=854932) **RESTAPI: missing update impl at /api/disks/xxx**

   The REST API in the current release adds the following updatable disk properties for floating disks:

- For Image disks: provisioned_size, alias, description, wipe_after_delete, shareable, backup, and disk_profile.

- For LUN disks: alias, description and shareable.

- For Cinder and Managed Block disks: provisioned_size, alias, and description. 

See http://ovirt.github.io/ovirt-engine-api-model/4.4/#services/disk/methods/update

 - [BZ 1574443](https://bugzilla.redhat.com/show_bug.cgi?id=1574443) **[RFE] Allow host to be forcefully flipped to maintenance using power management restart**

   Feature: 

Allows to put host straight into maintenance mode when doing power management restart (restapi, webadmin).



Reason: 

It is problematic to flip the host to the maintenance state if it is flipping between connecting and activating state. It may get to the non-operation state for short period of time, but one has to monitor the host and click the button as soon as it is in the non-operational state otherwise the host can flip to connecting again.



Result: 

The host, regardless of its initial state before restart, will be put into maintenance mode, skipping connecting & activating phases.

 - [BZ 1731395](https://bugzilla.redhat.com/show_bug.cgi?id=1731395) **[RFE] Introduce a "Secure" variant of CPUs following the CPU-related vulnerability mitigations**

   Previously, with every security update a new CPU type was created in the vdc_options table under the key ServerCPUList in the database for all affected architectures. For example, the Intel Skylake Client Family included the following CPU types:



Intel Skylake Client Family

Intel Skylake Client IBRS Family

Intel Skylake Client IBRS SSBD Family

Intel Skylake Client IBRS SSBD MDS Family

    

With this update, only two CPU Types are now supported for any CPU microarchitecture that has security updates, keeping the CPU list manageable. For example:



Intel Skylake Client Family

Secure Intel Skylake Client Family

    

The default CPU type will not change. The Secure CPU type will contain the latest updates.

 - [BZ 1733932](https://bugzilla.redhat.com/show_bug.cgi?id=1733932) **[RFE] add an option to remove unregistered entities from attached storage domain**

   With this update, you can remove an unregistered entity, such as a virtual machine, a template, or a disk, without importing it into the environment.

 - [BZ 1358501](https://bugzilla.redhat.com/show_bug.cgi?id=1358501) **[RFE] multihost network change - notify when done**

   Feature: Network operations that span multiple hosts will have a start and end event in the events tab and engine.log, and a popup notification for the end of the operation in the web-admin if triggered from the web-admin.



Reason: Network operations that span multiple hosts may take a long time and the user has no indication of when they have finished.



Result:

 - [BZ 1740644](https://bugzilla.redhat.com/show_bug.cgi?id=1740644) **[nmstate] Add config option for Host deployment with nmstate**

   The current release adds a configuration option, VdsmUseNmstate, which you can use to enable nmstate on every new host with cluster compatibility level >= 4.4.

 - [BZ 1427717](https://bugzilla.redhat.com/show_bug.cgi?id=1427717) **[RFE] Create and/or select affinity group upon VM creation.**

   The current release adds the ability for you to select affinity groups while creating or editing a virtual machine (VM) or host. Previously, you could only add a VM or host by editing an affinity group.

 - [BZ 1482465](https://bugzilla.redhat.com/show_bug.cgi?id=1482465) **[RFE] Add sorting for Cluster's columns**

   With this update, when viewing clusters, you can sort by the Cluster CPU Type and Compatibility Version columns.

 - [BZ 1600059](https://bugzilla.redhat.com/show_bug.cgi?id=1600059) **[RFE] Add by default a storage lease to HA VMs**

   Feature: When HA is selected for a New VM we now set the Lease Storage Domain to a bootable Storage Domain automatically if the user did not already choose one.



Reason: To protect new HA VMs with leases when it has a bootable Storage Domain.



Result: Now a bootable Storage Domain is set as the lease Storage Domain for new HA VMs.

 - [BZ 1651406](https://bugzilla.redhat.com/show_bug.cgi?id=1651406) **[RFE] Allow Maintenance of Host with Enforcing VM Affinity Rules (hard affinity)**

   The current release enables you to migrate a group of virtual machines (VMs) that are in positive enforcing affinity with each other.

- You can use the new check-box in the Migrate VM dialog to migrate this type of affinity group.

- You can use the following REST API to migrate this type of affinity group: http://ovirt.github.io/ovirt-engine-api-model/4.4/#services/vm/methods/migrate/parameters/migrate_vms_in_affinity_closure.

- Putting a host into maintenance also migrates this type of affinity group.

 - [BZ 1475774](https://bugzilla.redhat.com/show_bug.cgi?id=1475774) **RHV-M requesting four GetDeviceListVDSCommand when editing storage domain**

   Feature: 

Adding a message while loading a large number of LUNs.  



Reason:

While creating/managing an iSCSI storage domain, there's no indication that the operation may take some long time.  



Result:

Added a message to the spinner dialog:

Loading...

A large number of LUNs may slow down the operation.

 - [BZ 1688796](https://bugzilla.redhat.com/show_bug.cgi?id=1688796) **[RFE] Make it possible to enable Kerberos/GSSAPI debug on AAA**

   With this update a new configuration variable, AAA_JAAS_ENABLE_DEBUG, has been added to enable Kerberos/GSSAPI debug on AAA. The default value is `false`. 

To enable debugging, create a new configuration file named `/etc/ovirt-engine/engine.conf.d/99-kerberos-debug.conf` with the following content:



AAA_JAAS_ENABLE_DEBUG=true


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1734724](https://bugzilla.redhat.com/show_bug.cgi?id=1734724) **[RFE] Update aaa-ldap to use OpenJDK 11 - both build and runtime**

   We should update below RHV Administration Guide for 4.4 chapters:



16.3.3. Configuring an External LDAP Provider (Manual Method)

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/sect-configuring_an_external_ldap_provider#Configuring_an_External_LDAP_Provider_ManualMethod



16.4. Configuring LDAP and Kerberos for Single Sign-on

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/configuring_ldap_and_kerberos_for_single_sign-on



and replace below strings:



1. From "org.ovirt.engine-extensions.aaa" to "org.ovirt.engine.extension.aaa"



2. From "org.ovirt.engineextensions.aaa" to "org.ovirt.engine.extension.aaa"





Those replacement are only breaking changes contained in version 1.4.0 compared to 1.3.0, but for upgrades from 4.3 those changes will be performed automatically as a part of engine-setup. So we just need to fix documentation mentioning manual setup of new LDAP integration.


#### ovirt-engine-extension-aaa-misc

 - [BZ 1734725](https://bugzilla.redhat.com/show_bug.cgi?id=1734725) **[RFE] Update aaa-misc to use OpenJDK 11 - both build and runtime**

   We should update below RHV Administration Guide for 4.4 chapters:



16.3.3. Configuring an External LDAP Provider (Manual Method)

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/sect-configuring_an_external_ldap_provider#Configuring_an_External_LDAP_Provider_ManualMethod



16.4. Configuring LDAP and Kerberos for Single Sign-on

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/configuring_ldap_and_kerberos_for_single_sign-on



and replace below strings:



1. From "org.ovirt.engine-extensions.aaa" to "org.ovirt.engine.extension.aaa"



2. From "org.ovirt.engineextensions.aaa" to "org.ovirt.engine.extension.aaa"





Those replacement are only breaking changes contained in version 1.4.0 compared to 1.3.0, but for upgrades from 4.3 those changes will be performed automatically as a part of engine-setup. So we just need to fix documentation mentioning manual setup of new LDAP integration.


#### ovirt-engine-extension-logger-log4j

 - [BZ 1734727](https://bugzilla.redhat.com/show_bug.cgi?id=1734727) **[RFE] Update logger-log4j to use OpenJDK 11 - both build and runtime**

   We should update below RHV Administration Guide for 4.4 chapters:



21.6. Enabling the oVirt Engine Extension Logger log4j

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/enabling_the_ovirt_engine_extension_logger_log4j



and replace below strings:



1. From "org.ovirt.engine-extensions.logger" to "org.ovirt.engine.extension.logger"



2. From "org.ovirt.engineextensions.logger" to "org.ovirt.engine.extension.logger"





Those replacement are only breaking changes contained in version 1.1.0 compared to 1.0.3, but for upgrades from 4.3 those changes will be performed automatically as a part of engine-setup. So we just need to fix documentation mentioning manual setup of logger-log4j extension.


#### oVirt Engine Metrics

 - [BZ 1523289](https://bugzilla.redhat.com/show_bug.cgi?id=1523289) **[RFE] Create a role that will list to the admin which hosts are not configured for metrics**

   Feature: 

List hosts that are not configured for metrics.



Reason: 

So that the user can check the reason the Collectd, Rsyslog/Fluentd services are not working as expected and fix it.



Result: 

When running the manage services playbook the "/etc/ovirt-engine-metrics/hosts_not_configured_for_metrics" file is created and includes the list of hosts that the services are not running on.


### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine WildFly

 - [BZ 1766166](https://bugzilla.redhat.com/show_bug.cgi?id=1766166) **Rebase on Wildfly 18**

   


#### oVirt Engine Appliance

 - [BZ 1708579](https://bugzilla.redhat.com/show_bug.cgi?id=1708579) **Rebase ovirt-engine-appliance on Fedora 29**

   

 - [BZ 1672732](https://bugzilla.redhat.com/show_bug.cgi?id=1672732) **Replace ovirt-guest-agent with qemu-guest-agent**

   


#### oVirt Node NG Image

 - [BZ 1708582](https://bugzilla.redhat.com/show_bug.cgi?id=1708582) **Rebase oVirt Node on top of Fedora 30**

   


### Removed functionality

#### oVirt Host Dependencies

 - [BZ 1698016](https://bugzilla.redhat.com/show_bug.cgi?id=1698016) **remove cockpit-machines-ovirt dependency**

   cockpit-machines-ovirt has been deprecated in Red Hat Virtualization version 4.3 (reference bug #1698014), and has been removed from the ovirt-host dependencies and from the RHV-H image.


#### VDSM

 - [BZ 1703840](https://bugzilla.redhat.com/show_bug.cgi?id=1703840) **drop vdsm-hook-macspoof**

   The vdsm-hook-macspoof has been dropped from the VDSM code. If you still require the ifacemacspoof hook, you can find and fix the vnic profiles using a script similar to the one provided in the https://gerrit.ovirt.org/#/c/94613/ commit message.


#### oVirt Engine

 - [BZ 1753889](https://bugzilla.redhat.com/show_bug.cgi?id=1753889) **[v3 REST API] Remove v3 API support**

   oVirt Engine RESTAPIv3 has been removed from the projects, users need to adapt their custom scripts to use RESTAPIv4

 - [BZ 1795684](https://bugzilla.redhat.com/show_bug.cgi?id=1795684) **[RFE] Drop support for hystrix monitoring integration**

   Hystrix monitoring integration has been removed from ovirt-engine due to limited adoption and difficulty to maintain.

 - [BZ 1638675](https://bugzilla.redhat.com/show_bug.cgi?id=1638675) **Drop OpenStack Neutron deployment**

   The current release removes OpenStack Neutron deployment,

including the automatic deployment of the neutron agents through the Network Provider tab in the New Host window and the AgentConfiguration in the REST-API.

Use the following components instead:

- To deploy OpenStack hosts, use the OpenStack Platform Director/TripleO.

- The Open vSwitch interface mappings are already managed automatically by VDSM in Clusters with switch type OVS.

- To manage the deployment of ovirt-provider-ovn-driver on a cluster, update the cluster's "Default Network Provider" attribute.


#### oVirt Release Package

 - [BZ 1753894](https://bugzilla.redhat.com/show_bug.cgi?id=1753894) **Retire ovirt-engine-sdk-java-3***

   The oVirt Engine SDK 3 Java bindings are not shipped anymore with oVirt 4.4 release.

 - [BZ 1753899](https://bugzilla.redhat.com/show_bug.cgi?id=1753899) **Retire ovirt-engine-cli**

   

 - [BZ 1753896](https://bugzilla.redhat.com/show_bug.cgi?id=1753896) **Retire ovirt-engine-sdk-python-3***

   oVirt Python SDKv3 has been removed from the project, users needs to upgrade their scripts to use Python SDKv4


### Known Issue

#### oVirt Engine

 - [BZ 1809116](https://bugzilla.redhat.com/show_bug.cgi?id=1809116) **Block RHEL8 hosts in OVS cluster**

   Cause: OVS switch type for nmstate managed hosts is currently known to be not working



Consequence: OVS clusters cannot contain RHEL 8 hosts



Workaround (if any): Do not upgrade hosts in clusters with OVS switch type to RHEL 8.


### Bug Fixes

#### Safelease

 - [BZ 1696313](https://bugzilla.redhat.com/show_bug.cgi?id=1696313) **Drop unneeded dependencies from safelease**


#### oVirt Cockpit Plugin

 - [BZ 1808152](https://bugzilla.redhat.com/show_bug.cgi?id=1808152) **[ RHHI-V  1.8 ]  Failed to create VDO**


#### oVirt Ansible hosted-engine setup role

 - [BZ 1756244](https://bugzilla.redhat.com/show_bug.cgi?id=1756244) **On dual stack env hosted-engine deploy chooses IPv6 just due to a link-local IPv6 address**

 - [BZ 1807060](https://bugzilla.redhat.com/show_bug.cgi?id=1807060) **hosted-engine-setup deployment fails with ovirt-engine-4.4-el8 appliance -  nic `eth0`  hardcoded.**


#### oVirt Hosted Engine Setup

 - [BZ 1756244](https://bugzilla.redhat.com/show_bug.cgi?id=1756244) **On dual stack env hosted-engine deploy chooses IPv6 just due to a link-local IPv6 address**

 - [BZ 1664479](https://bugzilla.redhat.com/show_bug.cgi?id=1664479) **Third VM fails to get migrated when host is placed into maintenance mode**

 - [BZ 1686575](https://bugzilla.redhat.com/show_bug.cgi?id=1686575) **hosted-engine deploy (restore-from-file) fails if any non-management logical network is marked as required in backup file.**


#### OTOPI

 - [BZ 1746700](https://bugzilla.redhat.com/show_bug.cgi?id=1746700) **ssh plugin fails if authorized_keys has non-ascii utf-8 text**

 - [BZ 1751324](https://bugzilla.redhat.com/show_bug.cgi?id=1751324) **get_otopi_python always prefers Python3 even when site-packages are Python2 on CentOS 7**


#### oVirt Hosted Engine HA

 - [BZ 1664479](https://bugzilla.redhat.com/show_bug.cgi?id=1664479) **Third VM fails to get migrated when host is placed into maintenance mode**


#### VDSM

 - [BZ 1680368](https://bugzilla.redhat.com/show_bug.cgi?id=1680368) **Failed to create VM from template in CreateVolumeContainerCommand when stopping VDSM service in a single host environment**

 - [BZ 1798175](https://bugzilla.redhat.com/show_bug.cgi?id=1798175) **Regression: KVM Importing fails due to missing readinto function on the StreamAdapter**

 - [BZ 1788783](https://bugzilla.redhat.com/show_bug.cgi?id=1788783) **after_migration is not sent to the guest after migration**

 - [BZ 1660071](https://bugzilla.redhat.com/show_bug.cgi?id=1660071) **Regression in Migration of VM that starts in pause mode: took 11 hours**

 - [BZ 1770889](https://bugzilla.redhat.com/show_bug.cgi?id=1770889) **virt-v2v from VMware or Xen to RHEL 8.1 host: although import succeeds VM remains in "locked" status.**

 - [BZ 1598266](https://bugzilla.redhat.com/show_bug.cgi?id=1598266) **[scale] VMs unresponsive due to delayed getVolumeSize**

 - [BZ 1749630](https://bugzilla.redhat.com/show_bug.cgi?id=1749630) **Reporting incorrect high memory usage, preventing VMs from migrating, high slab dentry**

 - [BZ 1746699](https://bugzilla.redhat.com/show_bug.cgi?id=1746699) **Can't import guest from export domain to data domain on rhv4.3 due to error "Invalid parameter: 'DiskType=1'"**

 - [BZ 1722854](https://bugzilla.redhat.com/show_bug.cgi?id=1722854) **Remove nwfilter configuration from the vdsmd service start**

 - [BZ 1711902](https://bugzilla.redhat.com/show_bug.cgi?id=1711902) **ovirt-engine-4.1.11.2 fails to add disks with vdsm-4.30 hosts and 4.1 compatibility level: InvalidParameterException: Invalid parameter: 'DiskType=2'**

 - [BZ 1713724](https://bugzilla.redhat.com/show_bug.cgi?id=1713724) **When a storage domain is updated to V5 during a DC upgrade, if there are volumes with metadata that has been reset then the upgrade fails**

 - [BZ 1569593](https://bugzilla.redhat.com/show_bug.cgi?id=1569593) **ERROR failed to retrieve Hosted Engine HA score '[Errno 2] No such file or directory' Is the Hosted Engine setup finished?**

 - [BZ 1685034](https://bugzilla.redhat.com/show_bug.cgi?id=1685034) **"after_get_caps" ovirt-provider-ovn-driver hook query floods /var/log/messages when ovs-vswitchd is disabled**


#### oVirt Engine

 - [BZ 1816777](https://bugzilla.redhat.com/show_bug.cgi?id=1816777) **Missing key 'path' when connecting to browser console in VM portal**

 - [BZ 1733843](https://bugzilla.redhat.com/show_bug.cgi?id=1733843) **Export to OVA fails if VM is running on the Host doing the export**

 - [BZ 1785364](https://bugzilla.redhat.com/show_bug.cgi?id=1785364) **After engine restore, ovn networks are not restored and new OVN networks are not working properly on 4.4**

 - [BZ 1810893](https://bugzilla.redhat.com/show_bug.cgi?id=1810893) **mountOptions is ignored for "import storage domain" from GUI**

 - [BZ 1808788](https://bugzilla.redhat.com/show_bug.cgi?id=1808788) **VM configured with 16 CPUs fails on start with unsupported configuration error .**

 - [BZ 1806276](https://bugzilla.redhat.com/show_bug.cgi?id=1806276) **[HE] ovirt-provider-ovn is non-functional on 4.3.9 Hosted-Engine**

 - [BZ 1795886](https://bugzilla.redhat.com/show_bug.cgi?id=1795886) **Validation for disk incremental backup property should be done only for incremental backup operation**

 - [BZ 1793481](https://bugzilla.redhat.com/show_bug.cgi?id=1793481) **Able to set 'enable incremental backup' for raw disks**

 - [BZ 1751215](https://bugzilla.redhat.com/show_bug.cgi?id=1751215) **Unable to change Graphical Console of HE VM.**

 - [BZ 1801205](https://bugzilla.redhat.com/show_bug.cgi?id=1801205) **HA configuration for VMs in a pool must be disabled - causes confusing behavior**

 - [BZ 1678262](https://bugzilla.redhat.com/show_bug.cgi?id=1678262) **Q35: BIOS type changed to "Default" when creating new VM from template with Q35 chipset.**

 - [BZ 1707225](https://bugzilla.redhat.com/show_bug.cgi?id=1707225) **[cinderlib] Cinderlib DB is missing a backup and restore option**

 - [BZ 1798425](https://bugzilla.redhat.com/show_bug.cgi?id=1798425) **Regression: KVM Importing fails due to an old version**

 - [BZ 1777954](https://bugzilla.redhat.com/show_bug.cgi?id=1777954) **VM Templates greater then 101 quantity are not listed/reported in RHV-M Webadmin UI.**

 - [BZ 1437559](https://bugzilla.redhat.com/show_bug.cgi?id=1437559) **[RFE] Explicitly assign all CPUs to NUMA  nodes**

 - [BZ 1678007](https://bugzilla.redhat.com/show_bug.cgi?id=1678007) **When importing a VM override its cluster level to match the cluster it is imported to**

 - [BZ 1731590](https://bugzilla.redhat.com/show_bug.cgi?id=1731590) **Cannot preview snapshot, it fails and VM remains locked.**

 - [BZ 1583328](https://bugzilla.redhat.com/show_bug.cgi?id=1583328) **NPE while running VM with passthrough network vnic type**

 - [BZ 1781095](https://bugzilla.redhat.com/show_bug.cgi?id=1781095) **Hide partial engine-cleanup option**

 - [BZ 1750212](https://bugzilla.redhat.com/show_bug.cgi?id=1750212) **MERGE_STATUS fails with 'Invalid UUID string: mapper' when Direct LUN that already exists is hot-plugged**

 - [BZ 1754363](https://bugzilla.redhat.com/show_bug.cgi?id=1754363) **[Scale] Engine generates excessive amount of dns configuration related sql queries**

 - [BZ 1743296](https://bugzilla.redhat.com/show_bug.cgi?id=1743296) **When having many VMs with the same name - The same VM is selected each time**

 - [BZ 1731212](https://bugzilla.redhat.com/show_bug.cgi?id=1731212) **RHV 4.4 landing page does not show login or allow scrolling.**

 - [BZ 1590911](https://bugzilla.redhat.com/show_bug.cgi?id=1590911) **wrong template details shown when names are matching**

 - [BZ 1769339](https://bugzilla.redhat.com/show_bug.cgi?id=1769339) **webadmin - Extend floating disk size on image, ISCSI, thin-prov' disks does not work**

 - [BZ 1770237](https://bugzilla.redhat.com/show_bug.cgi?id=1770237) **Cannot assign a vNIC profile for VM instance profile.**

 - [BZ 1656621](https://bugzilla.redhat.com/show_bug.cgi?id=1656621) **Importing VM OVA always enables 'Cloud-Init/Sysprep'**

 - [BZ 1763084](https://bugzilla.redhat.com/show_bug.cgi?id=1763084) **Fix invalid host certificates by filling-in subject alternate name during host installation, host upgrade or certificate enrolment**

 - [BZ 1717390](https://bugzilla.redhat.com/show_bug.cgi?id=1717390) **[REST] VM interface hot-unplug right after VM boot up fails over missing vnic alias name**

 - [BZ 1745384](https://bugzilla.redhat.com/show_bug.cgi?id=1745384) **[IPv6 Static] Engine should allow updating network's static ipv6gateway**

 - [BZ 1547038](https://bugzilla.redhat.com/show_bug.cgi?id=1547038) **Upgrade from 4.3 to 4.4 will fail if there are versioned templates in database**

 - [BZ 1729511](https://bugzilla.redhat.com/show_bug.cgi?id=1729511) **engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject**

 - [BZ 1718141](https://bugzilla.redhat.com/show_bug.cgi?id=1718141) **Cannot retrieve Host NIC VF configuration via REST API**

 - [BZ 1715393](https://bugzilla.redhat.com/show_bug.cgi?id=1715393) **[Q35] Disabling and re-enabling SPICE USB creates a  USB2.0 controller instead of xhci**

 - [BZ 1659574](https://bugzilla.redhat.com/show_bug.cgi?id=1659574) **Highly Available (HA) VMs with a VM lease failed to start after a 4.1 to 4.3 upgrade.**

 - [BZ 1664479](https://bugzilla.redhat.com/show_bug.cgi?id=1664479) **Third VM fails to get migrated when host is placed into maintenance mode**

 - [BZ 1703112](https://bugzilla.redhat.com/show_bug.cgi?id=1703112) **PCI address of NICs are not stored in the database after a hotplug of passthrough NIC resulting in change of network device name in VM after a reboot**

 - [BZ 1658101](https://bugzilla.redhat.com/show_bug.cgi?id=1658101) **[RESTAPI] Adding ISO disables serial console**

 - [BZ 1693813](https://bugzilla.redhat.com/show_bug.cgi?id=1693813) **Do not change DC level if there are VMs running/paused with older CL.**


### Other

#### imgbased

 - [BZ 1809367](https://bugzilla.redhat.com/show_bug.cgi?id=1809367) **Host update fails with environment block too small**

   

 - [BZ 1803017](https://bugzilla.redhat.com/show_bug.cgi?id=1803017) **The discard mount option is not set properly**

   

 - [BZ 1777886](https://bugzilla.redhat.com/show_bug.cgi?id=1777886) **[RFE] Support minimal storage layout for RHVH**

   

 - [BZ 1770683](https://bugzilla.redhat.com/show_bug.cgi?id=1770683) **[RHVH-4.4.0] Upgrade RHVH from RHVH-4.4-20190926.3 to rhvh-4.4.0.8-0.20191107.0 failed**

   

 - [BZ 1766579](https://bugzilla.redhat.com/show_bug.cgi?id=1766579) **imgbased build is not disabling anymore repositories**

   

 - [BZ 1759938](https://bugzilla.redhat.com/show_bug.cgi?id=1759938) **unittest: TypeError: unicode argument expected, got 'str'**

   

 - [BZ 1760809](https://bugzilla.redhat.com/show_bug.cgi?id=1760809) **src/imgbased/bootloader.py fails unit testing with nosetests-3**

   

 - [BZ 1760812](https://bugzilla.redhat.com/show_bug.cgi?id=1760812) **imgbased/src/imgbased/local.py fails unit testing with nosetests-3**

   

 - [BZ 1760217](https://bugzilla.redhat.com/show_bug.cgi?id=1760217) **RHVH4.4 installation fails when security profile is selected**

   

 - [BZ 1724102](https://bugzilla.redhat.com/show_bug.cgi?id=1724102) **[RFE] Warn if SELinux is disabled when upgrading RHV-H**

   


#### oVirt Cockpit Plugin

 - [BZ 1825748](https://bugzilla.redhat.com/show_bug.cgi?id=1825748) **Unable to enter the host details in the cockpit with single node deployment**

   

 - [BZ 1822121](https://bugzilla.redhat.com/show_bug.cgi?id=1822121) **Filter /dev/mapper/x devices, when provided with blacklist_gluster_devices option enabled**

   

 - [BZ 1818566](https://bugzilla.redhat.com/show_bug.cgi?id=1818566) **Cockpit UI logout due to 15 min timeout**

   

 - [BZ 1817306](https://bugzilla.redhat.com/show_bug.cgi?id=1817306) **Blacklisting is not done for LVM cache fast devices**

   

 - [BZ 1816105](https://bugzilla.redhat.com/show_bug.cgi?id=1816105) **Make either the public network for all hosts or use same FQDN for both networks mandatory**

   

 - [BZ 1816090](https://bugzilla.redhat.com/show_bug.cgi?id=1816090) **Direct usage of IPv6 addresses shouldn't be allowed**

   

 - [BZ 1816051](https://bugzilla.redhat.com/show_bug.cgi?id=1816051) **Falling back to DNS,TCP doesn't help for liveliness check of the host**

   

 - [BZ 1754748](https://bugzilla.redhat.com/show_bug.cgi?id=1754748) **Enabling LV cache along with VDO volumes fails during Deployment**

   

 - [BZ 1603591](https://bugzilla.redhat.com/show_bug.cgi?id=1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1814125](https://bugzilla.redhat.com/show_bug.cgi?id=1814125) **Enable blacklisting devices by default and update default data disks for RAID 6 as 10**

   

 - [BZ 1814554](https://bugzilla.redhat.com/show_bug.cgi?id=1814554) **Refrain from showing up the read-only fields in HC cockpit deployment wizard**

   

 - [BZ 1807815](https://bugzilla.redhat.com/show_bug.cgi?id=1807815) **[RFE]Provide option to control blacklist or whitelist multipath devices from cockpit**

   

 - [BZ 1762800](https://bugzilla.redhat.com/show_bug.cgi?id=1762800) **Consolidate host and additional hosts tab**

   

 - [BZ 1789277](https://bugzilla.redhat.com/show_bug.cgi?id=1789277) **Unable to deploy gluster using the hyperconverged wizard**

   

 - [BZ 1715430](https://bugzilla.redhat.com/show_bug.cgi?id=1715430) **Storage Domains should be created irrespective of automatic host addition**

   

 - [BZ 1688794](https://bugzilla.redhat.com/show_bug.cgi?id=1688794) **Need an option to get IP version type used for FQDNs from user**

   

 - [BZ 1688245](https://bugzilla.redhat.com/show_bug.cgi?id=1688245) **Gluster IPV6 storage domain requires additional mount options**

   

 - [BZ 1688271](https://bugzilla.redhat.com/show_bug.cgi?id=1688271) **Additional hosts with IPV6 addresses doesn't qualify for valid addresses**

   

 - [BZ 1733416](https://bugzilla.redhat.com/show_bug.cgi?id=1733416) **Cockpit UI dropdown menu changes needed for single node**

   

 - [BZ 1758150](https://bugzilla.redhat.com/show_bug.cgi?id=1758150) **Expanded disk size field should be non-editable.**

   

 - [BZ 1752951](https://bugzilla.redhat.com/show_bug.cgi?id=1752951) **Cleanup should confirm before starting up the cleanup process**

   

 - [BZ 1690880](https://bugzilla.redhat.com/show_bug.cgi?id=1690880) **Brick size is incorrect after user modifies the volume from arbiter to pure replica.**

   

 - [BZ 1756709](https://bugzilla.redhat.com/show_bug.cgi?id=1756709) **Add ids to elements in cockpit-ovirt**

   

 - [BZ 1700742](https://bugzilla.redhat.com/show_bug.cgi?id=1700742) **python packaging changes needed due to deprecation of /usr/bin/python**

   


#### oVirt Host Dependencies

 - [BZ 1836645](https://bugzilla.redhat.com/show_bug.cgi?id=1836645) **Package ovirt-imageio-client is not included in latest 4.4 build - rhv-release-4.4.0-36**

   

 - [BZ 1782754](https://bugzilla.redhat.com/show_bug.cgi?id=1782754) **Disable goferd on RHV Host Images**

   

 - [BZ 1741792](https://bugzilla.redhat.com/show_bug.cgi?id=1741792) **Add clevis RPMs to RHV-H image / repo**

   


#### oVirt Ansible hosted-engine setup role

 - [BZ 1827135](https://bugzilla.redhat.com/show_bug.cgi?id=1827135) **failed to deploy hosted-engine 4.4 from 4.3 backup file due to versionlock**

   

 - [BZ 1787267](https://bugzilla.redhat.com/show_bug.cgi?id=1787267) **Misleading fail message: deprecation of 'ovirt_host_facts' to be renamed to 'ovirt_host_info'**

   

 - [BZ 1603591](https://bugzilla.redhat.com/show_bug.cgi?id=1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1782799](https://bugzilla.redhat.com/show_bug.cgi?id=1782799) **"rhel7" hard-coded in virt-install command**

   

 - [BZ 1806526](https://bugzilla.redhat.com/show_bug.cgi?id=1806526) **hosted-engine-setup deployment fails :  Software Collections are no longer used on EL8**

   

 - [BZ 1459229](https://bugzilla.redhat.com/show_bug.cgi?id=1459229) **Interface matching regular expression ignores interfaces with a '-' in the name**

   

 - [BZ 1770030](https://bugzilla.redhat.com/show_bug.cgi?id=1770030) **[4.4.0-5] after deploy of HE the defined fqdn on the host changed to localhost.localdomain**

   


#### oVirt Provider OVN

 - [BZ 1701121](https://bugzilla.redhat.com/show_bug.cgi?id=1701121) **/etc/ovirt-provider-ovn/ovirt-provider-ovn.conf is a config file, although it's not meant to be**

   


#### oVirt Hosted Engine Setup

 - [BZ 1603591](https://bugzilla.redhat.com/show_bug.cgi?id=1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1726290](https://bugzilla.redhat.com/show_bug.cgi?id=1726290) **hosted-engine command line help is incomplete and confusing**

   


#### OTOPI

 - [BZ 1750093](https://bugzilla.redhat.com/show_bug.cgi?id=1750093) **dnf plugin silently ignores updated packages with broken dependencies**

   

 - [BZ 1688659](https://bugzilla.redhat.com/show_bug.cgi?id=1688659) **Drop requirement on sonatype-oss-parent from otopi**

   


#### MOM

 - [BZ 1626003](https://bugzilla.redhat.com/show_bug.cgi?id=1626003) **Port mom to Python3**

   


#### oVirt Hosted Engine HA

 - [BZ 1830730](https://bugzilla.redhat.com/show_bug.cgi?id=1830730) **Add log messages for DNS query test**

   

 - [BZ 1768511](https://bugzilla.redhat.com/show_bug.cgi?id=1768511) **ovirt-ha-broker "sometimes" fails to load on RHEL8 due to a permission error on a systemd defined RuntimeDirectory**

   

 - [BZ 1757414](https://bugzilla.redhat.com/show_bug.cgi?id=1757414) **ovirt-hosted-engine-ha python3 unicode fails testing**

   

 - [BZ 1624790](https://bugzilla.redhat.com/show_bug.cgi?id=1624790) **Package hosted-engine-ha for python2/3**

   


#### VDSM

 - [BZ 1803484](https://bugzilla.redhat.com/show_bug.cgi?id=1803484) **[UI] - Add nmstate version under 'Hosts' > 'General' software information**

   

 - [BZ 1821309](https://bugzilla.redhat.com/show_bug.cgi?id=1821309) **Can't change gateway of a static IPv4 address**

   

 - [BZ 1820283](https://bugzilla.redhat.com/show_bug.cgi?id=1820283) **Error creating storage domain via vdsm**

   

 - [BZ 1819098](https://bugzilla.redhat.com/show_bug.cgi?id=1819098) **Broken rollback for BlockVolume createVolumeMetadata**

   

 - [BZ 1818554](https://bugzilla.redhat.com/show_bug.cgi?id=1818554) **Libvirt service fails to start**

   

 - [BZ 1817001](https://bugzilla.redhat.com/show_bug.cgi?id=1817001) **[SR-IOV] [I40E] Hotunplug doesn't release the VF on the host**

   

 - [BZ 1766193](https://bugzilla.redhat.com/show_bug.cgi?id=1766193) **[Scale] oVirt should support up to 200 networks per host**

   

 - [BZ 1812914](https://bugzilla.redhat.com/show_bug.cgi?id=1812914) **Support setting a static DNS to interface that has dynamic IP**

   

 - [BZ 1544370](https://bugzilla.redhat.com/show_bug.cgi?id=1544370) **vdsm does not deactivate all LVs if a LUN is removed from the Storage Domain**

   

 - [BZ 1553133](https://bugzilla.redhat.com/show_bug.cgi?id=1553133) **Creating many thin clones corrupts vg metadata**

   

 - [BZ 1790503](https://bugzilla.redhat.com/show_bug.cgi?id=1790503) **[nmstate] Support bridge_opts custom properties for nmstate usage**

   

 - [BZ 1673277](https://bugzilla.redhat.com/show_bug.cgi?id=1673277) **"Volume Option cluster.granular-entry-heal=enable could not be set" when using "Optimize for Virt store"**

   

 - [BZ 1779161](https://bugzilla.redhat.com/show_bug.cgi?id=1779161) **HP VM could not be started if TSC scaling is not supported by the host CPU.**

   

 - [BZ 1793867](https://bugzilla.redhat.com/show_bug.cgi?id=1793867) **Remove Stochastic Fairness Queueing for network QoS**

   

 - [BZ 1785061](https://bugzilla.redhat.com/show_bug.cgi?id=1785061) **vdsmd 4.4.0 throws an exception in asyncore.py while updating OVF data**

   

 - [BZ 1793550](https://bugzilla.redhat.com/show_bug.cgi?id=1793550) **SCSI Hostdev Passthrough: local host disk is passthrough to VM when using other than scsi_generic property.**

   

 - [BZ 1766595](https://bugzilla.redhat.com/show_bug.cgi?id=1766595) **Webadmin and RESTAPI - creating/managing/importing ISCSI storage domain not possible - error block device action: (), code = 600**

   

 - [BZ 1765018](https://bugzilla.redhat.com/show_bug.cgi?id=1765018) **[rhel8.1] VM fail to start if having vNIC profile with port mirroring enabled**

   

 - [BZ 1639360](https://bugzilla.redhat.com/show_bug.cgi?id=1639360) **Separate lvm activation from other lvm commands**

   

 - [BZ 1756944](https://bugzilla.redhat.com/show_bug.cgi?id=1756944) **RHVH-4.4.0 The NICs are turned off during installation, but all NICs were found to be open after installation**

   

 - [BZ 1771051](https://bugzilla.redhat.com/show_bug.cgi?id=1771051) **Missing imageio demon at RHEL8 host breaking upload/download/V2V**

   

 - [BZ 1765684](https://bugzilla.redhat.com/show_bug.cgi?id=1765684) **Log important state changes and time spent in slow critical operations**

   

 - [BZ 1759388](https://bugzilla.redhat.com/show_bug.cgi?id=1759388) **Chance of data corruption if SPM VDSM is restarted during LSM**

   

 - [BZ 1738861](https://bugzilla.redhat.com/show_bug.cgi?id=1738861) **can't start VM that was cloned from snapshot when FIPS enabled**

   

 - [BZ 1755829](https://bugzilla.redhat.com/show_bug.cgi?id=1755829) **One of the 'HSM.moveImage' exception handlers refers to non-existing members on the exception instance**

   

 - [BZ 1750340](https://bugzilla.redhat.com/show_bug.cgi?id=1750340) **New libvirtd uses systemd socket activation by default, which is incompatible with --listen flag usage in /etc/sysconfig/libvirtd**

   

 - [BZ 1721599](https://bugzilla.redhat.com/show_bug.cgi?id=1721599) **Cannot create volume with initial size on preallocated qcow volume**

   

 - [BZ 1751881](https://bugzilla.redhat.com/show_bug.cgi?id=1751881) **Possible faulty storage task state transition on task abort**

   

 - [BZ 1753235](https://bugzilla.redhat.com/show_bug.cgi?id=1753235) **Align volume size to 4k block size in hsm module for file based storage**

   

 - [BZ 1738429](https://bugzilla.redhat.com/show_bug.cgi?id=1738429) **[SR-IOV] [rhel8.1] Can't enable VFs on rhel8.1 host - driver=igb**

   

 - [BZ 1738423](https://bugzilla.redhat.com/show_bug.cgi?id=1738423) **[rhel8.1] vdsm override ovirtmgmt with static IPv4 instead of the origin dhcpv4 NIC during host deploy in RHV**

   

 - [BZ 1688052](https://bugzilla.redhat.com/show_bug.cgi?id=1688052) **Typo and exception due to non-iterable object on gluster fencing testing**

   

 - [BZ 1679122](https://bugzilla.redhat.com/show_bug.cgi?id=1679122) **Automatically set in engine the following flags for High Performance VMs types: invtsc cpu flag and also the tsc frequency flag for supporting migration**

   

 - [BZ 1723668](https://bugzilla.redhat.com/show_bug.cgi?id=1723668) **VDSM command Get Host Statistics failed: Internal JSON-RPC error: {'reason': '[Errno 19] vnet&lt;x&gt; is not present in the system'}**

   

 - [BZ 1709628](https://bugzilla.redhat.com/show_bug.cgi?id=1709628) **lshw can take more than 15 seconds to execute depending on the system**

   

 - [BZ 1700623](https://bugzilla.redhat.com/show_bug.cgi?id=1700623) **Moving disk results in wrong SIZE/CAP key in the volume metadata**

   

 - [BZ 1417545](https://bugzilla.redhat.com/show_bug.cgi?id=1417545) **Unable to set global volume options using 'all' as volume name**

   


#### oVirt Engine

 - [BZ 1758048](https://bugzilla.redhat.com/show_bug.cgi?id=1758048) **clone(as thin) VM from template or create snapshot fails with 'Requested capacity 1073741824 < parent capacity 3221225472 (volume:1211)'**

   

 - [BZ 1831620](https://bugzilla.redhat.com/show_bug.cgi?id=1831620) **[UI] Wrong header name for bond's slaves**

   

 - [BZ 1417545](https://bugzilla.redhat.com/show_bug.cgi?id=1417545) **Unable to set global volume options using 'all' as volume name**

   

 - [BZ 1803484](https://bugzilla.redhat.com/show_bug.cgi?id=1803484) **[UI] - Add nmstate version under 'Hosts' > 'General' software information**

   

 - [BZ 1793988](https://bugzilla.redhat.com/show_bug.cgi?id=1793988) **[REST API] copyhostnetwork operation failure detail message is not formatted with values**

   

 - [BZ 1679877](https://bugzilla.redhat.com/show_bug.cgi?id=1679877) **[ALL_LANG except zh_CN] Column names are truncated on network -> network -> clusters -> manage networks screen.**

   

 - [BZ 1820100](https://bugzilla.redhat.com/show_bug.cgi?id=1820100) **Webadmin - wrong warning message when attaching export domain to data center**

   

 - [BZ 1802223](https://bugzilla.redhat.com/show_bug.cgi?id=1802223) **"Storage consumption" - incorrect recalculate**

   

 - [BZ 1801710](https://bugzilla.redhat.com/show_bug.cgi?id=1801710) **ovirt-imageio service not available on engine host after clean reprovision meaning upload/download operations from UI do not work**

   

 - [BZ 1813305](https://bugzilla.redhat.com/show_bug.cgi?id=1813305) **Engine updating SLA policies of VMs continuously in  an environment which is not having any QOS configured**

   

 - [BZ 1824472](https://bugzilla.redhat.com/show_bug.cgi?id=1824472) **Default cluster has wrong bios type**

   

 - [BZ 1823388](https://bugzilla.redhat.com/show_bug.cgi?id=1823388) **Ensure that meaningful messages are logged, when gluster volumes doesn not have o-direct enabled**

   

 - [BZ 1784049](https://bugzilla.redhat.com/show_bug.cgi?id=1784049) **Rhel6 guest with cluster default q35 chipset causes kernel panic**

   

 - [BZ 1770697](https://bugzilla.redhat.com/show_bug.cgi?id=1770697) **VM can't start after was shut down with - XML error: Invalid PCI address 0000:03:01.0. slot must be <= 0**

   

 - [BZ 1755518](https://bugzilla.redhat.com/show_bug.cgi?id=1755518) **importing an image or a template from export domain results in a non indented fields yaml files**

   

 - [BZ 1786999](https://bugzilla.redhat.com/show_bug.cgi?id=1786999) **Multipath status changes are not displayed in Engine events**

   

 - [BZ 1784398](https://bugzilla.redhat.com/show_bug.cgi?id=1784398) **System permissions to user can not be added**

   

 - [BZ 1816519](https://bugzilla.redhat.com/show_bug.cgi?id=1816519) **Importing a registered template with already exists name shouldn't be allowed**

   

 - [BZ 1768844](https://bugzilla.redhat.com/show_bug.cgi?id=1768844) **RHEL Advanced virtualization module streams support**

   As a part of adding new host we are now enabling advanced virtualization channel on the host to use latest supported libvirt and qemu packages

 - [BZ 1797494](https://bugzilla.redhat.com/show_bug.cgi?id=1797494) **[RFE]Remove quartz dependency and use standard java scheduler**

   

 - [BZ 1807929](https://bugzilla.redhat.com/show_bug.cgi?id=1807929) **importing VM uses the old (original) name instead of the new one**

   

 - [BZ 1431535](https://bugzilla.redhat.com/show_bug.cgi?id=1431535) **[UI] - Add exclamation mark/tooltip warning 'VM Name already exist in the Data Center' on registering a VM from a DATA domain dialog and option to rename it**

   

 - [BZ 1743690](https://bugzilla.redhat.com/show_bug.cgi?id=1743690) **Commit and Undo buttons active when no snapshot selected**

   

 - [BZ 1712592](https://bugzilla.redhat.com/show_bug.cgi?id=1712592) **oVirt 4.3.5 RC3 - cannot attach disk as virtio-scsi during new VM wizzard**

   

 - [BZ 1801779](https://bugzilla.redhat.com/show_bug.cgi?id=1801779) **Disable Autoconf only option for rhel8 host and above**

   

 - [BZ 1646319](https://bugzilla.redhat.com/show_bug.cgi?id=1646319) **dashboard not working while storage domain has size less than 1GB**

   

 - [BZ 1812906](https://bugzilla.redhat.com/show_bug.cgi?id=1812906) **Upgrade via backup and restore from 4.3 to 4.4 is blocked**

   engine-backup in version 4.4 allows restoring also from backups taken by 4.3, to allow using that as a means to upgrade from 4.3 on EL7 to 4.4 on EL8 (which does not allow direct upgrade).

 - [BZ 1783750](https://bugzilla.redhat.com/show_bug.cgi?id=1783750) **Block upgrade if there's a risk of running out of space (say, any brick / volume is @ >90% full capacity)**

   

 - [BZ 1517696](https://bugzilla.redhat.com/show_bug.cgi?id=1517696) **[UI] - grids bottom scrollbar hides bottom row**

   

 - [BZ 1795232](https://bugzilla.redhat.com/show_bug.cgi?id=1795232) **Apply Patternfly 4 styles and layouts to error and non-webadmin pages**

   

 - [BZ 1721368](https://bugzilla.redhat.com/show_bug.cgi?id=1721368) **Support upgrade of HC cluster from engine UI**

   

 - [BZ 1565696](https://bugzilla.redhat.com/show_bug.cgi?id=1565696) **UI plugin API - action button callbacks invoked multiple times**

   

 - [BZ 1791826](https://bugzilla.redhat.com/show_bug.cgi?id=1791826) **SCSI passthrough: VM failed to start after changing custom property with hostdev attached.**

   

 - [BZ 1779161](https://bugzilla.redhat.com/show_bug.cgi?id=1779161) **HP VM could not be started if TSC scaling is not supported by the host CPU.**

   

 - [BZ 1793550](https://bugzilla.redhat.com/show_bug.cgi?id=1793550) **SCSI Hostdev Passthrough: local host disk is passthrough to VM when using other than scsi_generic property.**

   

 - [BZ 1680522](https://bugzilla.redhat.com/show_bug.cgi?id=1680522) **[ja_JP] Overlapping string on storage -> volumes ->snapshot -> new page.**

   

 - [BZ 1805142](https://bugzilla.redhat.com/show_bug.cgi?id=1805142) **Updating an OpenStack port creates invalid json**

   

 - [BZ 1782236](https://bugzilla.redhat.com/show_bug.cgi?id=1782236) **Windows Update (the drivers) enablement**

   

 - [BZ 1795246](https://bugzilla.redhat.com/show_bug.cgi?id=1795246) **WGT ISO on data domain is always attached to Win VMs**

   

 - [BZ 1779543](https://bugzilla.redhat.com/show_bug.cgi?id=1779543) **With Q35 BIOS the Cluster overview shows wrong Emulated Machine Type**

   

 - [BZ 1784767](https://bugzilla.redhat.com/show_bug.cgi?id=1784767) **webadmin - illegal char' in extend size text box while editing disk not marked as illegal**

   

 - [BZ 1691301](https://bugzilla.redhat.com/show_bug.cgi?id=1691301) **[CodeChange] Remove (or disable) yum/dnf groups handling code**

   

 - [BZ 1777215](https://bugzilla.redhat.com/show_bug.cgi?id=1777215) **Add deprecation message to "Export to Export Domain" dialog**

   

 - [BZ 1796047](https://bugzilla.redhat.com/show_bug.cgi?id=1796047) **Bad payload on ignition when the custom script is empty**

   

 - [BZ 1795238](https://bugzilla.redhat.com/show_bug.cgi?id=1795238) **ovirt_hosted_engine_ha exception: failed to start monitor via ovirt-ha-broker**

   

 - [BZ 1714528](https://bugzilla.redhat.com/show_bug.cgi?id=1714528) **Missing IDs on cluster upgrade buttons**

   

 - [BZ 1779580](https://bugzilla.redhat.com/show_bug.cgi?id=1779580) **drop rhvm-doc package**

   

 - [BZ 1679880](https://bugzilla.redhat.com/show_bug.cgi?id=1679880) **[fr_FR] Misalignment on Storage > Volumes >Geo-replication > New window.**

   

 - [BZ 1768393](https://bugzilla.redhat.com/show_bug.cgi?id=1768393) **Auto attached WGT ISO doesn't show in Change CD dialogue**

   

 - [BZ 1769306](https://bugzilla.redhat.com/show_bug.cgi?id=1769306) **A white space appears between upper masthead menu to vertical masthead menu**

   

 - [BZ 1752515](https://bugzilla.redhat.com/show_bug.cgi?id=1752515) **The Notification Drawer window title is overlapped by the "Alerts" title area and the close/widen buttons as well as the whole drawer area is shifted**

   

 - [BZ 1656329](https://bugzilla.redhat.com/show_bug.cgi?id=1656329) **Webadmin- providers - creating the same glance image provider with different name & same provider url & tenant is allowed**

   

 - [BZ 1789291](https://bugzilla.redhat.com/show_bug.cgi?id=1789291) **Missing ca.pem recreation question should be part of PKI section**

   

 - [BZ 1786450](https://bugzilla.redhat.com/show_bug.cgi?id=1786450) **webadmin - cluster tab under data center can't be shown properly - can't see any attached cluster to DC**

   

 - [BZ 1769463](https://bugzilla.redhat.com/show_bug.cgi?id=1769463) **[Scale] Slow performance for api/clusters when many networks devices are present**

   

 - [BZ 1635498](https://bugzilla.redhat.com/show_bug.cgi?id=1635498) **[UI] [Text] - Notification Drawer - On display all Alerts the text show 'All events were displayed'**

   

 - [BZ 1666032](https://bugzilla.redhat.com/show_bug.cgi?id=1666032) **RFE Able to create direct LUN from already used LUN (by storage domain) without selecting 'approve operation' flag**

   

 - [BZ 1734409](https://bugzilla.redhat.com/show_bug.cgi?id=1734409) **Duplicate image id when importing VM from export domain while the original VM still exists in the environment**

   

 - [BZ 1768784](https://bugzilla.redhat.com/show_bug.cgi?id=1768784) **[rhv-4.4.0-4] webadmin - destroy storage domain is not possible via UI**

   

 - [BZ 1771474](https://bugzilla.redhat.com/show_bug.cgi?id=1771474) **webadmin -few windows have unnecessary blank space**

   

 - [BZ 1743562](https://bugzilla.redhat.com/show_bug.cgi?id=1743562) **Custom property of vNIC profile does not allow multiple security group ids**

   

 - [BZ 1776317](https://bugzilla.redhat.com/show_bug.cgi?id=1776317) **Cannot hotplug more than 2 vNICs per VM**

   

 - [BZ 1771471](https://bugzilla.redhat.com/show_bug.cgi?id=1771471) **webadmin - New virtual disk > Direct LUN window is a mess**

   

 - [BZ 1771545](https://bugzilla.redhat.com/show_bug.cgi?id=1771545) **webadmin - The window of "attach virtual disk" was cut**

   

 - [BZ 1733031](https://bugzilla.redhat.com/show_bug.cgi?id=1733031) **[RFE] Add warning when importing data domains to newer DC that may trigger SD format upgrade**

   Feature: 





Reason: 



Result:

 - [BZ 1564509](https://bugzilla.redhat.com/show_bug.cgi?id=1564509) **Unable to grant user permissions to upload ISOs through the web interface**

   

 - [BZ 1768851](https://bugzilla.redhat.com/show_bug.cgi?id=1768851) **webadmin - block(ISCSI/FC) storage domain window is a mess - misaligned "Advance Parameters" makes it hard to choose other options**

   

 - [BZ 1768707](https://bugzilla.redhat.com/show_bug.cgi?id=1768707) **Cannot set or update iscsi portal group tag when editing storage connection via API**

   

 - [BZ 1701236](https://bugzilla.redhat.com/show_bug.cgi?id=1701236) **Hot plug disk resides on backup storage domain while VM is running is permitted**

   

 - [BZ 1753628](https://bugzilla.redhat.com/show_bug.cgi?id=1753628) **webadmin - Modify/Edit an existing DC compatibility level on a local storage domain is not possible**

   

 - [BZ 1728617](https://bugzilla.redhat.com/show_bug.cgi?id=1728617) **upgrade of host fails on timeout after 30 minutes**

   Default maximum timeout for an ansible-playbook executed from engine has been raised from 30 to 120 minutes. This timeout is defined using configuration option ANSIBLE_PLAYBOOK_EXEC_DEFAULT_TIMEOUT within /usr/share/ovirt-engine/services/ovirt-engine/ovirt-engine.conf. If administrators need to change that timeout they can create /etc/ovirt-engine/engine.conf.d/99-ansible-timeout.conf file with below content:



  ANSIBLE_PLAYBOOK_EXEC_DEFAULT_TIMEOUT=NNN



where NNN is number of minutes the timeout should be.

 - [BZ 1743543](https://bugzilla.redhat.com/show_bug.cgi?id=1743543) **extract_ova fails over nfs**

   

 - [BZ 1679122](https://bugzilla.redhat.com/show_bug.cgi?id=1679122) **Automatically set in engine the following flags for High Performance VMs types: invtsc cpu flag and also the tsc frequency flag for supporting migration**

   

 - [BZ 1680502](https://bugzilla.redhat.com/show_bug.cgi?id=1680502) **The cancel button is not working on storage > volumes > geo-replication > new screen.**

   

 - [BZ 1750905](https://bugzilla.redhat.com/show_bug.cgi?id=1750905) **Data Center -> Guide me -> Configure storage does not let user create iSCSI volumes**

   

 - [BZ 1758874](https://bugzilla.redhat.com/show_bug.cgi?id=1758874) **V5 format is missing storage domain (none)**

   

 - [BZ 1746390](https://bugzilla.redhat.com/show_bug.cgi?id=1746390) **Error while creating local storage: Internal Engine Error**

   

 - [BZ 1722519](https://bugzilla.redhat.com/show_bug.cgi?id=1722519) **Guest tools ISO in data domain not automatically attached to Windows VMs**

   

 - [BZ 1748736](https://bugzilla.redhat.com/show_bug.cgi?id=1748736) **[UI] Tooltips in the setup networks dialog are broken**

   

 - [BZ 1738861](https://bugzilla.redhat.com/show_bug.cgi?id=1738861) **can't start VM that was cloned from snapshot when FIPS enabled**

   

 - [BZ 1678003](https://bugzilla.redhat.com/show_bug.cgi?id=1678003) **Collapse snapshot flag is available even if VM has no snapshots at all**

   

 - [BZ 1590866](https://bugzilla.redhat.com/show_bug.cgi?id=1590866) **SDK allows to create template in one DC with disk in another DC**

   

 - [BZ 1741102](https://bugzilla.redhat.com/show_bug.cgi?id=1741102) **host activation causes RHHI nodes to lose the quorum**

   

 - [BZ 1652064](https://bugzilla.redhat.com/show_bug.cgi?id=1652064) **Missing REST API endpoint to access affinity group hosts: .../affinitygroups/ID/hosts**

   

 - [BZ 1727025](https://bugzilla.redhat.com/show_bug.cgi?id=1727025) **NPE in DestroyImage endAction during live merge leaving a task in DB for hours causing operations depending on host clean tasks to fail as Deactivate host/StopSPM/deactivate SD**

   

 - [BZ 1742924](https://bugzilla.redhat.com/show_bug.cgi?id=1742924) **"Field 'foo' can not be updated when status is 'Up'" in engine.log when listing 'NEXT_RUN' configuration snapshot VMs**

   

 - [BZ 1700338](https://bugzilla.redhat.com/show_bug.cgi?id=1700338) **[RFE] Alternate method to configure the email Event Notifier for a user in RHV through API (instead of  RHV GUI)**

   

 - [BZ 1730611](https://bugzilla.redhat.com/show_bug.cgi?id=1730611) **Inconsistent UX labels - Use Host vs Host to Use**

   

 - [BZ 1727094](https://bugzilla.redhat.com/show_bug.cgi?id=1727094) **ISOs in Change CD dialog not sorted**

   

 - [BZ 1718790](https://bugzilla.redhat.com/show_bug.cgi?id=1718790) **Drop oVirt Node Legacy support in ovirt-engine**

   

 - [BZ 1739257](https://bugzilla.redhat.com/show_bug.cgi?id=1739257) **[UI] Don't show 'out-of-sync' info tooltip for the out-of-sync column under main 'Hosts' tab if network in sync**

   

 - [BZ 1730264](https://bugzilla.redhat.com/show_bug.cgi?id=1730264) **VMs will fail to start if the vnic profile attached is having port mirroring enabled and have name greater than 15 characters**

   

 - [BZ 1690026](https://bugzilla.redhat.com/show_bug.cgi?id=1690026) **[RFE] - Creating an NFS storage domain the engine should let the user specify exact NFS version v4.0 and not just v4**

   

 - [BZ 1731049](https://bugzilla.redhat.com/show_bug.cgi?id=1731049) **exception while adding user or group to quota consumer**

   

 - [BZ 1651939](https://bugzilla.redhat.com/show_bug.cgi?id=1651939) **a new size of the direct LUN not updated in Admin Portal**

   

 - [BZ 1721449](https://bugzilla.redhat.com/show_bug.cgi?id=1721449) **ISOs in Run Once dialog grouped by domain**

   

 - [BZ 1721438](https://bugzilla.redhat.com/show_bug.cgi?id=1721438) **The list of ISOs not sorted in VM Import dialog**

   

 - [BZ 1700036](https://bugzilla.redhat.com/show_bug.cgi?id=1700036) **[RFE] Add RedFish API for host power management for RHEV**

   Support for RedFish power management agent has been added into RHV. To use that functionality administrators need to select redfish power management agent in Power Management tab in Edit Host dialog and fill-in additional details like login information and IP/FQDN of the agent

 - [BZ 1714834](https://bugzilla.redhat.com/show_bug.cgi?id=1714834) **Cannot disable SCSI passthrough using API**

   

 - [BZ 1530249](https://bugzilla.redhat.com/show_bug.cgi?id=1530249) **Default quota must be updated  - still contains 0% (invalid value)**

   

 - [BZ 1671397](https://bugzilla.redhat.com/show_bug.cgi?id=1671397) **[RFE] Add mousovers and brief help instructions to OVA import dialog**

   

 - [BZ 1721563](https://bugzilla.redhat.com/show_bug.cgi?id=1721563) **VM not started on the expected host since external weight policy units are ignored.**

   

 - [BZ 1712890](https://bugzilla.redhat.com/show_bug.cgi?id=1712890) **engine-setup should check for snapshots in unsupported CL**

   Now, on upgrade, engine-setup prompts about virtual machines that have snapshots that are incompatible with the version we are going to upgrade to. It's safe to let it proceed, but it's not safe to try using these snapshots after the upgrade, e.g. to preview them.

 - [BZ 1706822](https://bugzilla.redhat.com/show_bug.cgi?id=1706822) **[engine-setup] Confusing message in engine-setup about installing local DBs manually**

   

 - [BZ 1632808](https://bugzilla.redhat.com/show_bug.cgi?id=1632808) **OVF import wrong error message**

   

 - [BZ 1609686](https://bugzilla.redhat.com/show_bug.cgi?id=1609686) **Get VMs  response doesn't match virsh output after updating of the serial number policy**

   

 - [BZ 1633240](https://bugzilla.redhat.com/show_bug.cgi?id=1633240) **can't search in pools with comment**

   

 - [BZ 1684266](https://bugzilla.redhat.com/show_bug.cgi?id=1684266) **Exporting OVA timed out leaving orphan volume**

   

 - [BZ 1695026](https://bugzilla.redhat.com/show_bug.cgi?id=1695026) **Failure in creating snapshots during "Live Storage Migration" can result in a nonexistent snapshot**

   

 - [BZ 1666913](https://bugzilla.redhat.com/show_bug.cgi?id=1666913) **[UI] warn users about different "Vdsm Name" when creating network with a fancy char or long name**

   

 - [BZ 1679039](https://bugzilla.redhat.com/show_bug.cgi?id=1679039) **Unable to upload image through Storage->Domain->Disk because of wrong DC**

   

 - [BZ 1696748](https://bugzilla.redhat.com/show_bug.cgi?id=1696748) **UI exception seen when creating the new logical network and selecting that network**

   

 - [BZ 1693628](https://bugzilla.redhat.com/show_bug.cgi?id=1693628) **Engine generates too many updates to vm_dynamic table due to the session change**

   


#### oVirt Engine UI Extensions

 - [BZ 1714528](https://bugzilla.redhat.com/show_bug.cgi?id=1714528) **Missing IDs on cluster upgrade buttons**

   

 - [BZ 1786569](https://bugzilla.redhat.com/show_bug.cgi?id=1786569) **Export VM to data domain with the same name fails with no clear error in the UI**

   

 - [BZ 1786589](https://bugzilla.redhat.com/show_bug.cgi?id=1786589) **Export VM to data domain while snapshot is being created fails with no clear error in the UI**

   

 - [BZ 1786621](https://bugzilla.redhat.com/show_bug.cgi?id=1786621) **When exporting VM with snapshots to data domain without collapse - the VM is exported without the snapshots**

   


#### oVirt Engine Metrics

 - [BZ 1773313](https://bugzilla.redhat.com/show_bug.cgi?id=1773313) **RHV Metric store installation fails with error: "You need to install \"jmespath\" prior to running json_query filter"**

   

 - [BZ 1715511](https://bugzilla.redhat.com/show_bug.cgi?id=1715511) **Update README for Variable openshift_distribution to include RHV default**

   

 - [BZ 1687729](https://bugzilla.redhat.com/show_bug.cgi?id=1687729) **Code Change - Use dedicated Ansible module for manageing SELinux file context**

   

 - [BZ 1677679](https://bugzilla.redhat.com/show_bug.cgi?id=1677679) **Remove hacky things from ansible.cfg**

   


#### oVirt Release Package

 - [BZ 1756706](https://bugzilla.redhat.com/show_bug.cgi?id=1756706) **The sshd service of RHVH is inactive.**

   

 - [BZ 1757457](https://bugzilla.redhat.com/show_bug.cgi?id=1757457) **ovirt-release-host-node has python2 code in %post section of the spec file**

   


#### oVirt Engine Appliance

 - [BZ 1813291](https://bugzilla.redhat.com/show_bug.cgi?id=1813291) **Enable posgresql 12 module**

   

 - [BZ 1594548](https://bugzilla.redhat.com/show_bug.cgi?id=1594548) **[RFE] Ensure Cockpit is installed properly (on Engine): cockpit-bridge is not a deps, causing login failure to cockpit**

   


#### oVirt-Cockpit SSO

 - [BZ 1826248](https://bugzilla.redhat.com/show_bug.cgi?id=1826248) **[4.4][ovirt-cockpit-sso] Compatibility issues with python3**

   


### No Doc Update

#### oVirt Engine NodeJS Modules

 - [BZ 1824523](https://bugzilla.redhat.com/show_bug.cgi?id=1824523) **cockpit is affected by multiple CVEs**

   


#### oVirt Cockpit Plugin

 - [BZ 1824523](https://bugzilla.redhat.com/show_bug.cgi?id=1824523) **cockpit is affected by multiple CVEs**

   

 - [BZ 1811989](https://bugzilla.redhat.com/show_bug.cgi?id=1811989) **[vdo] VDO systemd unit file shouldn't be edited for modifying VDO max_discard_size**

   

 - [BZ 1752113](https://bugzilla.redhat.com/show_bug.cgi?id=1752113) **Hosted-Engine will not deploy if SSH access is not enabled for the root user.**

   


#### oVirt Hosted Engine Setup

 - [BZ 1752113](https://bugzilla.redhat.com/show_bug.cgi?id=1752113) **Hosted-Engine will not deploy if SSH access is not enabled for the root user.**

   

 - [BZ 1717991](https://bugzilla.redhat.com/show_bug.cgi?id=1717991) **ovirt-hosted-engine-setup requires pyliblzma which is available only for python2**

   


#### OTOPI

 - [BZ 1814940](https://bugzilla.redhat.com/show_bug.cgi?id=1814940) **otopi fails with: Python 2 is disabled in RHEL8**

   

 - [BZ 1525905](https://bugzilla.redhat.com/show_bug.cgi?id=1525905) **[RFE] otopi should notify about nonexistent before=/after= events**

   


#### oVirt Hosted Engine HA

 - [BZ 1794089](https://bugzilla.redhat.com/show_bug.cgi?id=1794089) **Ha-broker fails to recognize when HE VM's storage is already locked - QEMU error message has changed**

   

 - [BZ 1786458](https://bugzilla.redhat.com/show_bug.cgi?id=1786458) **Python3: broker fails to update engine health status**

   


#### VDSM

 - [BZ 1820068](https://bugzilla.redhat.com/show_bug.cgi?id=1820068) **Live snapshot fails and leave disks in locked state**

   

 - [BZ 1819125](https://bugzilla.redhat.com/show_bug.cgi?id=1819125) **Cold storage migration to iscsi domain fails**

   

 - [BZ 1816004](https://bugzilla.redhat.com/show_bug.cgi?id=1816004) **Failed to create a new disk or copy template disk on iscsi of FCP storage domain - qemu-img: Protocol driver \'host_device\' does not support image creation**

   

 - [BZ 1811425](https://bugzilla.redhat.com/show_bug.cgi?id=1811425) **VM CD-ROM payload device switch to an empty source file**

   

 - [BZ 1813961](https://bugzilla.redhat.com/show_bug.cgi?id=1813961) **vdsm-tool crashes on python3 change needed**

   

 - [BZ 1787222](https://bugzilla.redhat.com/show_bug.cgi?id=1787222) **Coredumps are broken since Fedora 26**

   

 - [BZ 1808850](https://bugzilla.redhat.com/show_bug.cgi?id=1808850) **Failed to create a new disk or copy template disk on iscsi domains due to OVF failure in ILLEGAL state**

   

 - [BZ 1807050](https://bugzilla.redhat.com/show_bug.cgi?id=1807050) **vgs are not seen immediately after iscsiadm login**

   

 - [BZ 1797477](https://bugzilla.redhat.com/show_bug.cgi?id=1797477) **Power Management configuration fails with JSON-RPC error**

   

 - [BZ 1692685](https://bugzilla.redhat.com/show_bug.cgi?id=1692685) **Bad/missing home directory for user vdsm causes a failure**

   

 - [BZ 1712832](https://bugzilla.redhat.com/show_bug.cgi?id=1712832) **Storage migration of a compressed image is failing with error "No space left on device" in block storage domain**

   

 - [BZ 1786451](https://bugzilla.redhat.com/show_bug.cgi?id=1786451) **hosted-engine --add-console-password fails with: expected string or bytes-like object**

   

 - [BZ 1529344](https://bugzilla.redhat.com/show_bug.cgi?id=1529344) **Printing vdsm configuration by running config.py fail with "AttributeError: 'module' object has no attribute 'glob'"**

   

 - [BZ 1778638](https://bugzilla.redhat.com/show_bug.cgi?id=1778638) **[4.4.0-6] failed to add secondary hosts(HA) with error "Unable to stop service supervdsmd"**

   

 - [BZ 1760262](https://bugzilla.redhat.com/show_bug.cgi?id=1760262) **Bridge linux profile is not activated and stuck in connecting state after reboot**

   

 - [BZ 1768735](https://bugzilla.redhat.com/show_bug.cgi?id=1768735) **[rhv-4.4.0-4] - Adding ISCSI storage domains Failes with error VolumeGroupCreateError and code 502 - TypeError: devicemapper_removeMapping() missing 1 required positional argument: 'deviceName'**

   

 - [BZ 1663661](https://bugzilla.redhat.com/show_bug.cgi?id=1663661) **vdsm uses obsolete python module 'imp'**

   

 - [BZ 1753898](https://bugzilla.redhat.com/show_bug.cgi?id=1753898) **Make block size detection compatible with Gluster storage**

   

 - [BZ 1720977](https://bugzilla.redhat.com/show_bug.cgi?id=1720977) **[logging] limit getStats**

   

 - [BZ 1655593](https://bugzilla.redhat.com/show_bug.cgi?id=1655593) **Download only forbidden by vdsmupgrade yum plugin**

   


#### oVirt vmconsole

 - [BZ 1507920](https://bugzilla.redhat.com/show_bug.cgi?id=1507920) **/usr/share/ovirt-vmconsole/ovirt-vmconsole-host/ovirt-vmconsole-host-sshd/sshd_config line 23: Deprecated option RSAAuthentication**

   


#### oVirt Engine

 - [BZ 1816648](https://bugzilla.redhat.com/show_bug.cgi?id=1816648) **upgrade from 4.3 to 4.4 fails on pg_restore**

   

 - [BZ 1820182](https://bugzilla.redhat.com/show_bug.cgi?id=1820182) **ISCSI/FC- LSM/Cloning a VM(deep copy) from template fails in 'MeasureVolumeVDS' method with Could not open image No such file or directory**

   

 - [BZ 1823348](https://bugzilla.redhat.com/show_bug.cgi?id=1823348) **Attaching CDROM to a VM from an ISO residing on a block domain fails**

   

 - [BZ 1819205](https://bugzilla.redhat.com/show_bug.cgi?id=1819205) **[CodeChange][i18n] oVirt 4.4 webadmin - translation update**

   

 - [BZ 1820995](https://bugzilla.redhat.com/show_bug.cgi?id=1820995) **[OVN] ovirt-provider-ovn.service is dead after deploy/upgrade to ovirt-engine-4.4.0-0.31.master.el8ev.noarch**

   

 - [BZ 1819514](https://bugzilla.redhat.com/show_bug.cgi?id=1819514) **Failed to register 4.4 host to the latest engine (4.4.0-0.29.master.el8ev)**

   

 - [BZ 1819248](https://bugzilla.redhat.com/show_bug.cgi?id=1819248) **Cannot upgrade host after engine setup**

   

 - [BZ 1808126](https://bugzilla.redhat.com/show_bug.cgi?id=1808126) **host_service.install() does not work with deploy_hosted_engine as True.**

   

 - [BZ 1797927](https://bugzilla.redhat.com/show_bug.cgi?id=1797927) **[REST-API] Attaching/adding a disk with SATA interface to a VM fails with Exception Caused by: java.lang.IllegalArgumentException: Unknown disk interface "SATA"**

   

 - [BZ 1814197](https://bugzilla.redhat.com/show_bug.cgi?id=1814197) **[CNV&RHV] when provider is remover DC is left behind and active**

   

 - [BZ 1712832](https://bugzilla.redhat.com/show_bug.cgi?id=1712832) **Storage migration of a compressed image is failing with error "No space left on device" in block storage domain**

   

 - [BZ 1732437](https://bugzilla.redhat.com/show_bug.cgi?id=1732437) **Remove direct kernel/initrd booting from oVirt Engine**

   

 - [BZ 1811869](https://bugzilla.redhat.com/show_bug.cgi?id=1811869) **[Scale] Webadmin\REST for host interface list response time is too long because of excessive amount of qos related sql queries**

   

 - [BZ 1811865](https://bugzilla.redhat.com/show_bug.cgi?id=1811865) **[Scale] Host Monitoring generates excessive amount of qos related sql queries**

   

 - [BZ 1584563](https://bugzilla.redhat.com/show_bug.cgi?id=1584563) **[RFE] Expand message in the main events view**

   

 - [BZ 1802270](https://bugzilla.redhat.com/show_bug.cgi?id=1802270) **Cluster Upgrade fails to run, AnsibleServlet fails to start the upgrade ansible playbook**

   

 - [BZ 1135786](https://bugzilla.redhat.com/show_bug.cgi?id=1135786) **[RFE] trim spaces in integer fields**

   

 - [BZ 1801194](https://bugzilla.redhat.com/show_bug.cgi?id=1801194) **User experience of ignition/Custom script textbox is low.**

   

 - [BZ 1809640](https://bugzilla.redhat.com/show_bug.cgi?id=1809640) **Engine should not explode if host reports duplicated nameservers**

   

 - [BZ 1788090](https://bugzilla.redhat.com/show_bug.cgi?id=1788090) **Failed to reinstall a host on upgraded 4.4: Task Copy vdsm and QEMU CSRs failed to execute**

   

 - [BZ 1807883](https://bugzilla.redhat.com/show_bug.cgi?id=1807883) **Can't create a VM on firefox due to an "invalid regexp group" error**

   

 - [BZ 1779588](https://bugzilla.redhat.com/show_bug.cgi?id=1779588) **[RHVH-4.4.0] Unable to detect upgrade package, when upgrading RHVH from RHVM UI**

   

 - [BZ 1795184](https://bugzilla.redhat.com/show_bug.cgi?id=1795184) **Check for upgrade on RHEL 8 host always reports no updates**

   

 - [BZ 1791749](https://bugzilla.redhat.com/show_bug.cgi?id=1791749) **The engine allows adding a new host using IP as hostname while the host already exists and appears with FQDN**

   

 - [BZ 1802543](https://bugzilla.redhat.com/show_bug.cgi?id=1802543) **Support back compatibility with 4.3 cluster creating live snapshots**

   

 - [BZ 1791255](https://bugzilla.redhat.com/show_bug.cgi?id=1791255) **[RFE] There are no available hosts capable of running the engine VM. Why?**

   

 - [BZ 1800947](https://bugzilla.redhat.com/show_bug.cgi?id=1800947) **Clone VM action fails  while the engine.log and events report success**

   

 - [BZ 1801129](https://bugzilla.redhat.com/show_bug.cgi?id=1801129) **separate dwh setup: No such file or directory: '/usr/share/ovirt-engine/selinux'**

   

 - [BZ 1798139](https://bugzilla.redhat.com/show_bug.cgi?id=1798139) **VirtIO-SCSI virtual disk cannot be added to VM.**

   

 - [BZ 1725003](https://bugzilla.redhat.com/show_bug.cgi?id=1725003) **[RFE] fail adding permissions when no user/group selected**

   

 - [BZ 1791007](https://bugzilla.redhat.com/show_bug.cgi?id=1791007) **[4.4] Connection to VM using vm-console failed**

   

 - [BZ 1691562](https://bugzilla.redhat.com/show_bug.cgi?id=1691562) **Cluster level changes are not increasing VMs generation numbers and so a new OVF_STORE content is not copied to the shared storage**

   

 - [BZ 1795281](https://bugzilla.redhat.com/show_bug.cgi?id=1795281) **[UI] Failed to create VM with a nasty NPE in the engine log (Query 'IsVmTemplateI440fxQuery' failed: null)**

   

 - [BZ 1786118](https://bugzilla.redhat.com/show_bug.cgi?id=1786118) **[4.4.0-17] failed to add secondary hosts(HA) with error "Unable to stop service vdsmd: Job for vdsmd.service canceled"**

   

 - [BZ 1752282](https://bugzilla.redhat.com/show_bug.cgi?id=1752282) **Cannot activate Host while RefreshHostCapabilitiesCommand is running**

   

 - [BZ 1780022](https://bugzilla.redhat.com/show_bug.cgi?id=1780022) **An internal retry to run VM is ignoring ignition payload, RHCOS goes into emergency**

   

 - [BZ 1787195](https://bugzilla.redhat.com/show_bug.cgi?id=1787195) **[4.4.0-13] 1 out of 3 hosts non-responsive after ansible install finished - ovn-controller[20628]: ovs|00040|stream_ssl|ERR|Private key does not match certificate public key: error:140A80BE:SSL routines:SSL_CTX_check_private_key:no private key assigned**

   

 - [BZ 1710724](https://bugzilla.redhat.com/show_bug.cgi?id=1710724) **Get wrong values while search VMs**

   

 - [BZ 1789262](https://bugzilla.redhat.com/show_bug.cgi?id=1789262) **Can not use clusters: datacenter.&lt;anything&gt; in search engine**

   

 - [BZ 1776306](https://bugzilla.redhat.com/show_bug.cgi?id=1776306) **[rhv-4.4.0-4] - Export VM(on a system upgraded from 4.3) as ova fails -  Command 'ExportVmToOva' failed when attempting to perform the next operation**

   

 - [BZ 1523835](https://bugzilla.redhat.com/show_bug.cgi?id=1523835) **Hosted-Engine: memory hotplug does not work for engine vm**

   

 - [BZ 1749674](https://bugzilla.redhat.com/show_bug.cgi?id=1749674) **[RFE] Use Ansible instead of ovirt-host-deploy for host deployment**

   

 - [BZ 1784010](https://bugzilla.redhat.com/show_bug.cgi?id=1784010) **[rhv-4.4.0-9] Right after adding host to engine - Failed to execute Ansible host-deploy role: null with host unreachable**

   

 - [BZ 1785272](https://bugzilla.redhat.com/show_bug.cgi?id=1785272) **Host register failed with yum-utils**

   

 - [BZ 1715763](https://bugzilla.redhat.com/show_bug.cgi?id=1715763) **[RFE] Upgrade of host failed - yum lockfile is held by another process**

   

 - [BZ 1779085](https://bugzilla.redhat.com/show_bug.cgi?id=1779085) **Storage domain can not be deactivated with error Failed executing step 'UPDATE_OVF_STORE'**

   

 - [BZ 1529042](https://bugzilla.redhat.com/show_bug.cgi?id=1529042) **[RFE] Changing of Cluster CPU Type does not trigger config update notification**

   

 - [BZ 1769212](https://bugzilla.redhat.com/show_bug.cgi?id=1769212) **Rest API for creating affinity group with labels is resulted with the group created with missing labels**

   

 - [BZ 1734729](https://bugzilla.redhat.com/show_bug.cgi?id=1734729) **[RFE] Update vdsm-jsonrpc-java to use OpenJDK 11 - both build and runtime**

   

 - [BZ 1759143](https://bugzilla.redhat.com/show_bug.cgi?id=1759143) **[RFE] Use ansible-runner-service instead of ansible-playbook to execute Ansible playbooks from engine**

   

 - [BZ 1718851](https://bugzilla.redhat.com/show_bug.cgi?id=1718851) **[RFE] Unmanaged disks should be kept after VM restart/poweroff**

   

 - [BZ 1705727](https://bugzilla.redhat.com/show_bug.cgi?id=1705727) **Cannot read property 'a' of undefined when approving host**

   

 - [BZ 1741625](https://bugzilla.redhat.com/show_bug.cgi?id=1741625) **VM fails to be re-started with error: Failed to acquire lock: No space left on device**

   

 - [BZ 1723804](https://bugzilla.redhat.com/show_bug.cgi?id=1723804) **Operation Failed: [Resource unavailable] - failed to sync networks on host**

   

 - [BZ 1751423](https://bugzilla.redhat.com/show_bug.cgi?id=1751423) **Improve description of shared memory statistics and remove unimplemented memory metrics from API**

   

 - [BZ 1758786](https://bugzilla.redhat.com/show_bug.cgi?id=1758786) **Removing of Affinity Label in Edit VM window  throws java.lang.UnsupportedOperationException**

   

 - [BZ 1724632](https://bugzilla.redhat.com/show_bug.cgi?id=1724632) **When setting high custom compatibility version with ovirt_vm, java exception is returned**

   

 - [BZ 1754490](https://bugzilla.redhat.com/show_bug.cgi?id=1754490) **RHV Manager cannot start on EAP 7.2.4**

   

 - [BZ 1749944](https://bugzilla.redhat.com/show_bug.cgi?id=1749944) **teardownImage attempts to deactivate in-use LV's rendering the VM disk image/volumes in locked state.**

   

 - [BZ 1734839](https://bugzilla.redhat.com/show_bug.cgi?id=1734839) **Unable to start guests in our Power9 cluster without running in headless mode.**

   

 - [BZ 1737684](https://bugzilla.redhat.com/show_bug.cgi?id=1737684) **Engine deletes the leaf volume when SnapshotVDSCommand timed out without checking if the  volume is still used by the VM**

   

 - [BZ 1686650](https://bugzilla.redhat.com/show_bug.cgi?id=1686650) **Memory snapshots' deletion logging unnecessary WARNINGS in engine.log**

   

 - [BZ 1741271](https://bugzilla.redhat.com/show_bug.cgi?id=1741271) **Move/Copy disk are blocked if there is less space in source SD than the size of the disk**

   

 - [BZ 1715725](https://bugzilla.redhat.com/show_bug.cgi?id=1715725) **Sending credentials in query string logs them in ovirt-request-logs**

   

 - [BZ 1730436](https://bugzilla.redhat.com/show_bug.cgi?id=1730436) **Snapshot creation was successful, but snapshot remains locked**

   

 - [BZ 1690155](https://bugzilla.redhat.com/show_bug.cgi?id=1690155) **Disk migration progress bar not clearly visible and unusable.**

   

 - [BZ 1530026](https://bugzilla.redhat.com/show_bug.cgi?id=1530026) **[RFE][UI] Remove external network selection on add host window**

   

 - [BZ 1654889](https://bugzilla.redhat.com/show_bug.cgi?id=1654889) **[RFE] Support console VNC for mediated devices**

   

 - [BZ 1700319](https://bugzilla.redhat.com/show_bug.cgi?id=1700319) **VM is going to pause state with "storage I/O  error".**

   

 - [BZ 1637172](https://bugzilla.redhat.com/show_bug.cgi?id=1637172) **Live Merge hung in the volume deletion phase,  leaving snapshot in a LOCKED state**

   

 - [BZ 1696111](https://bugzilla.redhat.com/show_bug.cgi?id=1696111) **RHV could not detect Guest Agent when create snapshot for the running guest which installed qemu-guest-agent**

   

 - [BZ 1658524](https://bugzilla.redhat.com/show_bug.cgi?id=1658524) **Replace error notification with patternfly element**

   

 - [BZ 1616451](https://bugzilla.redhat.com/show_bug.cgi?id=1616451) **[UI] add a tooltip to explain the supported matrix for the combination of disk allocation policies, formats and the combination result**

   

 - [BZ 1700725](https://bugzilla.redhat.com/show_bug.cgi?id=1700725) **[scale] RHV-M runs out of memory due to to much data reported by the guest agent**

   

 - [BZ 1690475](https://bugzilla.redhat.com/show_bug.cgi?id=1690475) **When a live storage migration fails, the auto generated snapshot does not get removed**

   

 - [BZ 1498654](https://bugzilla.redhat.com/show_bug.cgi?id=1498654) **[RFE] Add correlation ID to events details page**

   

 - [BZ 1660644](https://bugzilla.redhat.com/show_bug.cgi?id=1660644) **Concurrent LSMs of the same disk can be issued via the REST-API**

   


#### oVirt Engine Data Warehouse

 - [BZ 1734718](https://bugzilla.redhat.com/show_bug.cgi?id=1734718) **[RFE] Update DWH to use OpenJDK 11 - both build and runtime**

   


#### oVirt Engine UI Extensions

 - [BZ 1807777](https://bugzilla.redhat.com/show_bug.cgi?id=1807777) **Fix cluster-upgrade playbook location to align with other playbooks executed from ovirt-engine via ansible-runner-service**

   


#### oVirt Engine SDK 4 Java

 - [BZ 1734728](https://bugzilla.redhat.com/show_bug.cgi?id=1734728) **[RFE] Update Java SDK to use OpenJDK 11 - both build and runtime**

   


#### oVirt Engine Extension AAA-JDBC

 - [BZ 1734720](https://bugzilla.redhat.com/show_bug.cgi?id=1734720) **[RFE] Update aaa-jdbc to use OpenJDK 11 - both build and runtime**

   

 - [BZ 1714633](https://bugzilla.redhat.com/show_bug.cgi?id=1714633) **Using more than one asterisk in the search string is not working when searching for users.**

   


#### oVirt Engine Metrics

 - [BZ 1762263](https://bugzilla.redhat.com/show_bug.cgi?id=1762263) **[RFE] Require Ansible 2.9 in ovirt-engine-metrics**

   


#### VDSM JSON-RPC Java

 - [BZ 1734729](https://bugzilla.redhat.com/show_bug.cgi?id=1734729) **[RFE] Update vdsm-jsonrpc-java to use OpenJDK 11 - both build and runtime**

   


#### oVirt Release Package

 - [BZ 1598404](https://bugzilla.redhat.com/show_bug.cgi?id=1598404) **branding: oVirt Node cockpit and oVirt Engine have different coloring**

   


#### oVirt Engine Appliance

 - [BZ 1802478](https://bugzilla.redhat.com/show_bug.cgi?id=1802478) **hosted-engine deploy does not configure a serial console in the engine vm**

   


#### oVirt-Cockpit SSO

 - [BZ 1789733](https://bugzilla.redhat.com/show_bug.cgi?id=1789733) **Host console SSO not working at all!**

   


#### Contributors

134 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Allon Mureinik
	Amar Shah
	Amit Bawer
	Andrej Cernek
	Andrej Krejcir
	Arik Hadas
	Artur Socha
	Asaf Rachmani
	Aviv Turgeman
	Barak Korren
	Bartosz Rybacki
	Bell Levin
	Beni Pelled
	Benny Zlotnik
	Bernhard M. Wiedemann
	Bohdan Iakymets
	Brian Ward
	Camila Moura
	Charles Thao
	Dafna Ron
	Dan Kenigsberg
	Dana Elfassy
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Douglas Schilling Landgraf
	Dusan Fodor
	Edward Haas
	Ehud Yonasi
	Eitan Raviv
	Eli Mesika
	Evgeny Slutsky
	Evgheni Dereveanchin
	Eyal Edri
	Eyal Shenitzky
	Fedor Gavrilov
	Francesco Romani
	Fred Rolland
	Funkabell
	Gal Zaidman
	Germano Veit Michel
	Gobinda Das
	Greg Sheremeta
	Hilda Stastna
	Ido Rosenzwig
	Irit Goihman
	Jan Zmeskal
	Joey
	John Call
	Juan Hernandez
	Kaustav Majumder
	Kedar Kulkarni
	Klaas Demter
	Kobi Hakimi
	Lev Veyde
	Liran Rotenberg
	Lucia Jelinkova
	Lukas Svaty
	Marcin Sobczyk
	Marek Libra
	Martin Necas
	Martin Nečas
	Martin Perina
	Martin Peřina
	Martin Sivak
	Mateusz Kowalski
	Michal Skrivanek
	Miguel Duarte Barroso
	Miguel Martin
	Milan Zamazal
	Moti Asayag
	Nijin Ashok
	Nir Levy
	Nir Soffer
	NirLevyRH
	Ondra Machacek
	Ori Liel
	Ori_Liel
	Pavel Bar
	Petr Kubica
	Pierre Lecomte
	Piotr Kliczewski
	Prajith Kesava Prasad
	Radoslaw Szwajkowski
	Ravi Nori
	Ritesh
	Ritesh Chikatwar
	Roberto Ciatti
	Roman Hodain
	Roy Golan
	Ryan Barry
	Ryan Kraus
	Sahina Bose
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Shmuel Melamud
	Siddhant Rao
	Simone Tiraboschi
	Steven Rosenberg
	Tal Nisan
	Tomasz Baranski
	Tomáš Golembiovský
	Uri Lublin
	Vitor de Lima
	Vojtech Juranek
	Vojtech Szocs
	Yaniv Bronhaim
	Yedidyah Bar David
	Yoav Kleinberger
	Yotam Fromm
	Yuval Turgeman
	bamsalem
	benams1
	bond95
	dependabot[bot]
	emesika
	eslutsky
	godas
	gzaidman
	imjoey
	kobihk
	mathianasj
	michalskrivanek
	mnecas
	parthdhanjal
	rchikatw
	thaorell
	yodem
