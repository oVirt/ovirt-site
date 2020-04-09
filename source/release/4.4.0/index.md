---
title: oVirt 4.4.0 Release Notes
category: documentation
toc: true
authors: sandrobonazzola lveyde
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.4.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.0 Third Beta release as of April 09, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.1 and
CentOS Linux 8.1 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.0, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## BETA RELEASE

In order to install this Beta Release you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)



## What's New in 4.4.0?

### Release Note

#### oVirt Engine

 - [BZ 1732738](https://bugzilla.redhat.com/1732738) **[RFE] Update engine to use OpenJDK 11 - both build and runtime**

   Modernizing the software stack of ovirt-engine to both compile and runtime using java-11-openjdk.

Java 11 openjdk is the new LTS version from Red Hat so this 

is only a natural step forward.


#### oVirt Release Package

 - [BZ 1745302](https://bugzilla.redhat.com/1745302) **ovirt-guest-tools has been obsoleted by virtio-win guest tools**

   oVirt 4.4 replaces the ovirt-guest-tools a with a new WiX-based installer, included in Virtio-Win. You can download the ISO file containing the Windows guest drivers, agents and installers from https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/


### Enhancements

#### oVirt Setup Lib

 - [BZ 1546838](https://bugzilla.redhat.com/1546838) **[RFE] Refuse to deploy on localhost.localdomain**

   The current release displays a new warning when you use 'localhost' as an FQDN: "[WARNING] Using the name 'localhost' is not recommended, and may cause problems later on."


#### oVirt Host Dependencies

 - [BZ 1725775](https://bugzilla.redhat.com/1725775) **Replace screen requirement with tmux**

   tmux is now installed on hosts instead of screen.

screen has been deprecated in RHEL 7.6 and is not available anymore in RHEL 8.


#### oVirt Ansible hosted-engine setup role

 - [BZ 1602816](https://bugzilla.redhat.com/1602816) **[RFE] hosted-engine deployment playbook should reject bridging over a teaming device with a clear error**

   Feature: Filter Team devices in Hosted-Engine deployment



Reason: Teaming is not supported on RHV



Result: Rejecting the deployment with a clear error message in case that only Team devices are available


#### oVirt Hosted Engine Setup

 - [BZ 1641694](https://bugzilla.redhat.com/1641694) **[RFE] hosted-engine --vm-start-paused should clean up any existing HE-VM.**

   Feature: After starting HE VM with qemu paused, there is an option to start HE VM using `hosted-engine --vm-start`.



Reason: Start HE VM with qemu paused, and then start it as running VM



Result: option `--vm-start` can be used after `--vm-start-paused`


#### VDSM

 - [BZ 1739557](https://bugzilla.redhat.com/1739557) **RFE: add support for native TLS encryption on migration TCP transport**

   See the feature page: https://www.ovirt.org/develop/release-management/features/virt/migration-encryption.html

 - [BZ 1780943](https://bugzilla.redhat.com/1780943) **[RFE] Add timeout and abort command to async live snapshot**

   Feature: 

Now that in 4.4 we are using asynchronous job to run live snapshot. Timeout to abort this job will be possible. The engine will consume the value from engine-config and provide it to the job.



Reason: 

The asynchronous live snapshot job can be infinite, locking the specific VM. The user should have the option to provide a timeout, releasing that VM.



Result: 

A default value is set in engine-config and can be changed. In case the job will reach the timeout it will be aborted and the VM's lock will be released.

 - [BZ 1749284](https://bugzilla.redhat.com/1749284) **Change the Snapshot operation to be asynchronous**

   Feature: 

Asynchronous live snapshot

Reason: 

Before this enhancement the live snapshot operation was synchronized. In that state the engine let VDSM to do the operation for 180 seconds by default. In case the time passed, the engine considered the operation as failure. This can happen due to big memory VM with memory load or/and having slow storage.



Result: 

With this enhancement the operation will be asynchronous. Letting the operation run until it ends without timeout.

The operation now will succeed to large memory load VMs or/and slow storage.

 - [BZ 1692709](https://bugzilla.redhat.com/1692709) **[RFE] Investigate viability of automatically setting up boot partition for FIPS hosts**

   In addition to setting `fips=1`, host's boot partition need to be explicitly stated in the kernel boot parameters (like: `boot=/dev/sda1`or `boot=UUID=<id>`), this bug will set the boot partition into the kernel boot parameters.

 - [BZ 1179273](https://bugzilla.redhat.com/1179273) **[RFE] vdsm: Utilize system-wide crypto-policies**

   Feature: Use crypto policies introduced in CentOS 8 in favour of VDSM's local crypto settings



Reason: Using crypto policies provides consistency across the whole OS in regard to crypto standards. Since oVirt solution is composed of multiple projects it is desirable to have a single, easily maintainable way of defining these standards. This is exactly what crypto policies do - they provide a set of configuration files that affect multiple libraries and programming languages to guarantee uniformity, at the same time keeping the used cipher strings, suites and protocols up to date with widely accepted security recommendations.



To find our more about crypto policies, please visit:



https://www.redhat.com/en/blog/consistent-security-crypto-policies-red-hat-enterprise-linux-8



Result: VDSM's 'ssl_protocol', 'ssl_excludes' and 'ssl_ciphers' config options have been removed. If you need to fine-tune your crypto settings you should do it by changing, or creating your own crypto policy. As an example, if you need your hosts to communicate with some legacy systems that still use insecure TLSv1 or TLSv1.1, you can change your crypto policy to 'LEGACY' with: 



 update-crypto-policies --set LEGACY


#### oVirt Engine

 - [BZ 1679110](https://bugzilla.redhat.com/1679110) **[RFE] change Admin Portal toast notifications location**

   Feature: 

Changing the location of the toast notifications area from upper right corner to lower right corner. 



Reason: 

The default top right location covers all the action buttons and is quite intrusive.



Result: 

Toast notifications are growing bottom-up from  bottom right corner up to 400px from top, while buttons of "Dismiss all" and "Do not disturb" are located below the notifications area (please see attachments for more details).

 - [BZ 1455465](https://bugzilla.redhat.com/1455465) **Virt: blank template should be of 'server' type and not 'desktop' type.**

   In this release, the default "optimized for" value optimization type for bundled templates is now set to "Server".

 - [BZ 1780943](https://bugzilla.redhat.com/1780943) **[RFE] Add timeout and abort command to async live snapshot**

   Feature: 

Now that in 4.4 we are using asynchronous job to run live snapshot. Timeout to abort this job will be possible. The engine will consume the value from engine-config and provide it to the job.



Reason: 

The asynchronous live snapshot job can be infinite, locking the specific VM. The user should have the option to provide a timeout, releasing that VM.



Result: 

A default value is set in engine-config and can be changed. In case the job will reach the timeout it will be aborted and the VM's lock will be released.

 - [BZ 1807400](https://bugzilla.redhat.com/1807400) **Ensure o-direct options are enabled on volume used as storage domain**

   

 - [BZ 1512838](https://bugzilla.redhat.com/1512838) **[RFE][UI] - Add indication that a template is a sealed template**

   Feature: 

It is now possible to see if the template has been sealed in the template list table. It is also possible to change that value in the Edit template dialog. 

Reason: 

During the template creation, it is possible to seal the template automatically (for Linux). However, it was not possible to view in the UI if the template has been sealed or not. The other OS had to be sealed manually, but it was not possible to mark the template as sealed manually. 

Result: 

The seal status is now visible and editable via UI.

 - [BZ 1798403](https://bugzilla.redhat.com/1798403) **Windows drivers will auto-attach on installation of windows**

   Feature: 

Attach windows guest tools ISO when installing windows from CD-ROM.



Reason: 

Since the floppy device is removed, the user still need the windows guest tools to complete the windows installation.



Result: 

The user can run once a VM that set to windows operation system, attach the windows install CD-ROM and select auto-attaching the windows guest tools. The windows guest tools will be attached to the VM for this run.

 - [BZ 1749284](https://bugzilla.redhat.com/1749284) **Change the Snapshot operation to be asynchronous**

   Feature: 

Asynchronous live snapshot

Reason: 

Before this enhancement the live snapshot operation was synchronized. In that state the engine let VDSM to do the operation for 180 seconds by default. In case the time passed, the engine considered the operation as failure. This can happen due to big memory VM with memory load or/and having slow storage.



Result: 

With this enhancement the operation will be asynchronous. Letting the operation run until it ends without timeout.

The operation now will succeed to large memory load VMs or/and slow storage.

 - [BZ 1692709](https://bugzilla.redhat.com/1692709) **[RFE] Investigate viability of automatically setting up boot partition for FIPS hosts**

   In addition to setting `fips=1`, host's boot partition need to be explicitly stated in the kernel boot parameters (like: `boot=/dev/sda1`or `boot=UUID=<id>`), this bug will set the boot partition into the kernel boot parameters.

 - [BZ 1726907](https://bugzilla.redhat.com/1726907) **[RFE] Add RHCOS to the list of operating systems**

   Feature: 

Add Red Hat CoreOS



Reason: 

RHCOS is an OS dedicated for containers solution. Users can now select this OS type for VM.

Result: 

When selecting this VM type, the main difference from other RHEL is the initialization step.

RHCOS uses ignition to initialize the VM. With this RFE, when selecting RHCOS in OS type, the initialize will be changed to ignition type.

 - [BZ 1549486](https://bugzilla.redhat.com/1549486) **[RFE] update landing and login pages to to be compatible with Patternfly 4**

   

 - [BZ 1739557](https://bugzilla.redhat.com/1739557) **RFE: add support for native TLS encryption on migration TCP transport**

   See the feature page: https://www.ovirt.org/develop/release-management/features/virt/migration-encryption.html

 - [BZ 1767319](https://bugzilla.redhat.com/1767319) **[RFE] forbid updating mac pool that contains ranges overlapping with any mac range in the system**

   In this release, modifying a MAC address pool or modifying the range of a MAC address pool that has any overlap with existing MAC address pool ranges, is strictly forbidden.

 - [BZ 1547937](https://bugzilla.redhat.com/1547937) **[RFE] Live Storage Migration progress bar.**

   This release adds a progress bar for the disk synchronization stage of Live Storage Migration.

 - [BZ 1593800](https://bugzilla.redhat.com/1593800) **[RFE] forbid new mac pools with overlapping ranges**

   When creating a new MAC address pool its ranges must not overlap with each other or with any ranges in existing MAC address pools.

 - [BZ 1696245](https://bugzilla.redhat.com/1696245) **[RFE] Allow full customization while cloning a VM**

   Feature: 

When cloning VM, user is now able to customize all the fields available in the Edit VM dialog (including discs and network)

Reason: 

When cloning VM, it was not possible to clone the disks into a different storage domain as the original one. 

Result: 

The newly cloned VM is now fully customizable.

 - [BZ 1700021](https://bugzilla.redhat.com/1700021) **[RFE] engine-setup should warn and prompt if ca.pem is missing but other generated pki files exist**

   Previously, if ca.pem was not present, engine-setup automatically regenerated all PKI files, requiring you to reinstall or re-enroll certificates for all hosts. 



Now, if ca.pem is not present but other PKI files are, engine-setup prompts you to restore ca.pem from backup without regenerating all PKI files. If a backup is present and you select this option, then you no longer need to reinstall or re-enroll certificates for all hosts.

 - [BZ 1450351](https://bugzilla.redhat.com/1450351) **[RFE] Allow specifying a shutdown reason on the .shutdown() call**

   This feature will allow users to set the reason for shutdown/power-off(stop) a VM using REST API request.

 - [BZ 1572155](https://bugzilla.redhat.com/1572155) **[RFE] provide VM status and uptime in VM general tab**

   The current release adds the VM's current state and uptime to the Compute > Virtual Machine: General tab.

 - [BZ 1325468](https://bugzilla.redhat.com/1325468) **[RFE] Autostart of VMs that are down (with Engine assistance - Engine has to be up)**

   1. After a high-availability virtual machine (HA VM) crashes, the Manager tries to restart it indefinitely. At first, with a short delay between restarts. After a specified amount of failed retries, the delay is longer. The current release adds three new configuration options:

- RetryToRunAutoStartVmShortIntervalInSeconds - Is the short delay. (Default: 30 seconds)

- RetryToRunAutoStartVmLongIntervalInSeconds - Is the long delay. (Default: 30 minutes)

- NumOfTriesToRunFailedAutoStartVmInShortIntervals - Is the number of failed restarts with short delays. (Default: 10 retries)



2. The Manager starts crashed HA VMs in order of priority, delaying lower-priority VMs until higher-priority VMs are 'Up.' The current release adds a new configuration option, 'MaxTimeAutoStartBlockedOnPriority,' which sets the maximum time the Manager waits before starting a lower-priority VM. (Default: 10 minutes)

 - [BZ 1080097](https://bugzilla.redhat.com/1080097) **[RFE] Allow editing disks details in the Disks tab**

   In this release, it is now possible to edit the properties of a Floating Disk in the Storage > Disks tab of Administration Portal. For example, the user can edit the Description, Alias, and Size of the disk.

 - [BZ 1652565](https://bugzilla.redhat.com/1652565) **[RFE] Unable to edit floating disk**

   Feature: 

Enable editing floating disks from the UI

 

Reason: 

Currently, it's possible editing only VM disks (from the VM they attached to).



Result: 

This patch adds a button for editing disks from the 'Disks' tab.

Once the popup shows up, the user will be able to edit a floating disk's parameters (such as description and alias) and also extends its size.

 - [BZ 854932](https://bugzilla.redhat.com/854932) **RESTAPI: missing update impl at /api/disks/xxx**

   The REST API in the current release adds the following updatable disk properties for floating disks:

- For Image disks: provisioned_size, alias, description, wipe_after_delete, shareable, backup, and disk_profile.

- For LUN disks: alias, description and shareable.

- For Cinder and Managed Block disks: provisioned_size, alias, and description. 

See http://ovirt.github.io/ovirt-engine-api-model/4.4/#services/disk/methods/update

 - [BZ 1574443](https://bugzilla.redhat.com/1574443) **[RFE] Allow host to be forcefully flipped to maintenance using power management restart**

   Feature: 

Allows to put host straight into maintenance mode when doing power management restart (restapi, webadmin).



Reason: 

It is problematic to flip the host to the maintenance state if it is flipping between connecting and activating state. It may get to the non-operation state for short period of time, but one has to monitor the host and click the button as soon as it is in the non-operational state otherwise the host can flip to connecting again.



Result: 

The host, regardless of its initial state before restart, will be put into maintenance mode, skipping connecting & activating phases.

 - [BZ 1731395](https://bugzilla.redhat.com/1731395) **[RFE] Introduce a "Secure" variant of CPUs following the CPU-related vulnerability mitigations**

   Described in feature page: https://www.ovirt.org/develop/release-management/features/virt/secure-cpus.html

 - [BZ 1306586](https://bugzilla.redhat.com/1306586) **change Windows drivers and sysprep delivery method to a CDROM**

   Feature: Replace the floppy device with an additional CDROM device for sysprep installation for Compatibility Versions 4.4 and later. 



Reason: To deprecate floppy support which has resulted in many issues.



Result: An additional CDROM device shall be used to replace the floppy drive for versions 4.4 and later.

 - [BZ 1358501](https://bugzilla.redhat.com/1358501) **[RFE] multihost network change - notify when done**

   Feature: Network operations that span multiple hosts will have a start and end event in the events tab and engine.log, and a popup notification for the end of the operation in the web-admin if triggered from the web-admin.



Reason: Network operations that span multiple hosts may take a long time and the user has no indication of when they have finished.



Result:

 - [BZ 1740644](https://bugzilla.redhat.com/1740644) **[nmstate] Add config option for Host deployment with nmstate**

   The current release adds a configuration option, VdsmUseNmstate, which you can use to enable nmstate on every new host with cluster compatibility level >= 4.4.

 - [BZ 1427717](https://bugzilla.redhat.com/1427717) **[RFE] Create and/or select affinity group upon VM creation.**

   The current release adds the ability for you to select affinity groups while creating or editing a virtual machine (VM) or host. Previously, you could only add a VM or host by editing an affinity group.

 - [BZ 1482465](https://bugzilla.redhat.com/1482465) **[RFE] Add sorting for Cluster's columns**

   Feature: Added sorting to more of the Cluster View's Columns. These columns include CPU Type and Compatibility Version.



Reason: Requested via this report.



Result: Now the user can sort by these columns.

 - [BZ 1600059](https://bugzilla.redhat.com/1600059) **[RFE] Add by default a storage lease to HA VMs**

   Feature: When HA is selected for a New VM we now set the Lease Storage Domain to a bootable Storage Domain automatically if the user did not already choose one.



Reason: To protect new HA VMs with leases when it has a bootable Storage Domain.



Result: Now a bootable Storage Domain is set as the lease Storage Domain for new HA VMs.

 - [BZ 1651406](https://bugzilla.redhat.com/1651406) **[RFE] Allow Maintenance of Host with Enforcing VM Affinity Rules (hard affinity)**

   The current release enables you to migrate a group of virtual machines (VMs) that are in positive enforcing affinity with each other.

- You can use the new check-box in the Migrate VM dialog to migrate this type of affinity group.

- You can use the following REST API to migrate this type of affinity group: http://ovirt.github.io/ovirt-engine-api-model/4.4/#services/vm/methods/migrate/parameters/migrate_vms_in_affinity_closure.

- Putting a host into maintenance also migrates this type of affinity group.

 - [BZ 1475774](https://bugzilla.redhat.com/1475774) **RHV-M requesting four GetDeviceListVDSCommand when editing storage domain**

   Feature: 

Adding a message while loading a large number of LUNs.  



Reason:

While creating/managing an iSCSI storage domain, there's no indication that the operation may take some long time.  



Result:

Added a message to the spinner dialog:

Loading...

A large number of LUNs may slow down the operation.

 - [BZ 1688796](https://bugzilla.redhat.com/1688796) **[RFE] Make it possible to enable Kerberos/GSSAPI debug on AAA**

   A new config variable AAA_JAAS_ENABLE_DEBUG has been added to enable Kerberos/GSSAPI debug on AAA. The default value is false and to enable debug the user should create a new config file /etc/ovirt-engine/engine.conf.d/99-kerberos-debug.conf with contents



AAA_JAAS_ENABLE_DEBUG=true


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1734724](https://bugzilla.redhat.com/1734724) **[RFE] Update aaa-ldap to use OpenJDK 11 - both build and runtime**

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

 - [BZ 1734725](https://bugzilla.redhat.com/1734725) **[RFE] Update aaa-misc to use OpenJDK 11 - both build and runtime**

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

 - [BZ 1734727](https://bugzilla.redhat.com/1734727) **[RFE] Update logger-log4j to use OpenJDK 11 - both build and runtime**

   We should update below RHV Administration Guide for 4.4 chapters:



21.6. Enabling the oVirt Engine Extension Logger log4j

https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html/administration_guide/enabling_the_ovirt_engine_extension_logger_log4j



and replace below strings:



1. From "org.ovirt.engine-extensions.logger" to "org.ovirt.engine.extension.logger"



2. From "org.ovirt.engineextensions.logger" to "org.ovirt.engine.extension.logger"





Those replacement are only breaking changes contained in version 1.1.0 compared to 1.0.3, but for upgrades from 4.3 those changes will be performed automatically as a part of engine-setup. So we just need to fix documentation mentioning manual setup of logger-log4j extension.


#### oVirt Engine Metrics

 - [BZ 1523289](https://bugzilla.redhat.com/1523289) **[RFE] Create a role that will list to the admin which hosts are not configured for metrics**

   Feature: 

List hosts that are not configured for metrics.



Reason: 

So that the user can check the reason the Collectd, Rsyslog/Fluentd services are not working as expected and fix it.



Result: 

When running the manage services playbook the "/etc/ovirt-engine-metrics/hosts_not_configured_for_metrics" file is created and includes the list of hosts that the services are not running on.


### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine WildFly

 - [BZ 1766166](https://bugzilla.redhat.com/1766166) **Rebase on Wildfly 18**

   


#### oVirt Engine Appliance

 - [BZ 1708579](https://bugzilla.redhat.com/1708579) **Rebase ovirt-engine-appliance on Fedora 29**

   

 - [BZ 1672732](https://bugzilla.redhat.com/1672732) **Replace ovirt-guest-agent with qemu-guest-agent**

   


#### oVirt Node NG Image

 - [BZ 1708582](https://bugzilla.redhat.com/1708582) **Rebase oVirt Node on top of Fedora 30**

   


### Removed functionality

#### oVirt Host Dependencies

 - [BZ 1698016](https://bugzilla.redhat.com/1698016) **remove cockpit-machines-ovirt dependency**

   cockpit-machines-ovirt has been deprecated in 4.3 with bug #1698014.

Dropping from ovirt-host dependencies and from RHV-H image.


#### VDSM

 - [BZ 1703840](https://bugzilla.redhat.com/1703840) **drop vdsm-hook-macspoof**

   MAC spoof hook has been dropped. If someone still depend of ifacemacspoof hook, they can find and fix the vnic

profiles using a script similar to the one provided in  https://gerrit.ovirt.org/#/c/94613/ commit message.


#### oVirt Engine

 - [BZ 1732437](https://bugzilla.redhat.com/1732437) **Remove direct kernel/initrd booting from oVirt Engine**

   The linux boot parameters, including direct kernel, initrd and custom kernel parameters are removed within this bug from the WEB-UI. It is deprecated from ansible and REST-API to support older versions.

 - [BZ 1753889](https://bugzilla.redhat.com/1753889) **[v3 REST API] Remove v3 API support**

   oVirt Engine RESTAPIv3 has been removed from the projects, users need to adapt their custom scripts to use RESTAPIv4

 - [BZ 1795684](https://bugzilla.redhat.com/1795684) **[RFE] Drop support for hystrix monitoring integration**

   Hystrix monitoring integration has been removed from ovirt-engine due to limited adoption and hard maintainability

 - [BZ 1638675](https://bugzilla.redhat.com/1638675) **Drop OpenStack Neutron deployment**

   The current release removes OpenStack Neutron deployment,

including the automatic deployment of the neutron agents through the Network Provider tab in the New Host window and the AgentConfiguration in the REST-API.

Use the following components instead:

- To deploy OpenStack hosts, use the OpenStack Platform Director/TripleO.

- The Open vSwitch interface mappings are already managed automatically by VDSM in Clusters with switch type OVS.

- To manage the deployment of ovirt-provider-ovn-driver on a cluster, update the cluster's "Default Network Provider" attribute.


#### oVirt Release Package

 - [BZ 1753894](https://bugzilla.redhat.com/1753894) **Retire ovirt-engine-sdk-java-3***

   The oVirt Engine SDK 3 Java bindings are not shipped anymore with oVirt 4.4 release.

 - [BZ 1753899](https://bugzilla.redhat.com/1753899) **Retire ovirt-engine-cli**

   

 - [BZ 1753896](https://bugzilla.redhat.com/1753896) **Retire ovirt-engine-sdk-python-3***

   oVirt Python SDKv3 has been removed from the project, users needs to upgrade their scripts to use Python SDKv4


### Known Issue

#### oVirt Engine

 - [BZ 1809116](https://bugzilla.redhat.com/1809116) **Block RHEL8 hosts in OVS cluster**

   Cause: OVS switch type for nmstate managed hosts is currently known to be not working



Consequence: OVS clusters cannot contain RHEL 8 hosts



Workaround (if any): Do not upgrade hosts in clusters with OVS switch type to RHEL 8.


### Bug Fixes

#### Safelease

 - [BZ 1696313](https://bugzilla.redhat.com/1696313) **Drop unneeded dependencies from safelease**


#### oVirt Ansible hosted-engine setup role

 - [BZ 1756244](https://bugzilla.redhat.com/1756244) **On dual stack env hosted-engine deploy chooses IPv6 just due to a link-local IPv6 address**

 - [BZ 1807060](https://bugzilla.redhat.com/1807060) **hosted-engine-setup deployment fails with ovirt-engine-4.4-el8 appliance -  nic `eth0`  hardcoded.**


#### oVirt Hosted Engine Setup

 - [BZ 1756244](https://bugzilla.redhat.com/1756244) **On dual stack env hosted-engine deploy chooses IPv6 just due to a link-local IPv6 address**

 - [BZ 1664479](https://bugzilla.redhat.com/1664479) **Third VM fails to get migrated when host is placed into maintenance mode**

 - [BZ 1686575](https://bugzilla.redhat.com/1686575) **hosted-engine deploy (restore-from-file) fails if any non-management logical network is marked as required in backup file.**


#### OTOPI

 - [BZ 1746700](https://bugzilla.redhat.com/1746700) **ssh plugin fails if authorized_keys has non-ascii utf-8 text**

 - [BZ 1751324](https://bugzilla.redhat.com/1751324) **get_otopi_python always prefers Python3 even when site-packages are Python2 on CentOS 7**


#### oVirt Hosted Engine HA

 - [BZ 1664479](https://bugzilla.redhat.com/1664479) **Third VM fails to get migrated when host is placed into maintenance mode**


#### VDSM

 - [BZ 1798175](https://bugzilla.redhat.com/1798175) **Regression: KVM Importing fails due to missing readinto function on the StreamAdapter**

 - [BZ 1788783](https://bugzilla.redhat.com/1788783) **after_migration is not sent to the guest after migration**

 - [BZ 1660071](https://bugzilla.redhat.com/1660071) **Regression in Migration of VM that starts in pause mode: took 11 hours**

 - [BZ 1770889](https://bugzilla.redhat.com/1770889) **virt-v2v from VMware or Xen to RHEL 8.1 host: although import succeeds VM remains in "locked" status.**

 - [BZ 1598266](https://bugzilla.redhat.com/1598266) **[scale] VMs unresponsive due to delayed getVolumeSize**

 - [BZ 1749630](https://bugzilla.redhat.com/1749630) **Reporting incorrect high memory usage, preventing VMs from migrating, high slab dentry**

 - [BZ 1746699](https://bugzilla.redhat.com/1746699) **Can't import guest from export domain to data domain on rhv4.3 due to error "Invalid parameter: 'DiskType=1'"**

 - [BZ 1722854](https://bugzilla.redhat.com/1722854) **Remove nwfilter configuration from the vdsmd service start**

 - [BZ 1711902](https://bugzilla.redhat.com/1711902) **ovirt-engine-4.1.11.2 fails to add disks with vdsm-4.30 hosts and 4.1 compatibility level: InvalidParameterException: Invalid parameter: 'DiskType=2'**

 - [BZ 1713724](https://bugzilla.redhat.com/1713724) **When a storage domain is updated to V5 during a DC upgrade, if there are volumes with metadata that has been reset then the upgrade fails**

 - [BZ 1569593](https://bugzilla.redhat.com/1569593) **ERROR failed to retrieve Hosted Engine HA score '[Errno 2] No such file or directory' Is the Hosted Engine setup finished?**

 - [BZ 1685034](https://bugzilla.redhat.com/1685034) **"after_get_caps" ovirt-provider-ovn-driver hook query floods /var/log/messages when ovs-vswitchd is disabled**


#### oVirt Engine

 - [BZ 1733843](https://bugzilla.redhat.com/1733843) **Export to OVA fails if VM is running on the Host doing the export**

 - [BZ 1808788](https://bugzilla.redhat.com/1808788) **VM configured with 16 CPUs fails on start with unsupported configuration error .**

 - [BZ 1795886](https://bugzilla.redhat.com/1795886) **Validation for disk incremental backup property should be done only for incremental backup operation**

 - [BZ 1793481](https://bugzilla.redhat.com/1793481) **Able to set 'enable incremental backup' for raw disks**

 - [BZ 1751215](https://bugzilla.redhat.com/1751215) **Unable to change Graphical Console of HE VM.**

 - [BZ 1801205](https://bugzilla.redhat.com/1801205) **HA configuration for VMs in a pool must be disabled - causes confusing behavior**

 - [BZ 1678262](https://bugzilla.redhat.com/1678262) **Q35: BIOS type changed to "Default" when creating new VM from template with Q35 chipset.**

 - [BZ 1707225](https://bugzilla.redhat.com/1707225) **[cinderlib] Cinderlib DB is missing a backup and restore option**

 - [BZ 1798425](https://bugzilla.redhat.com/1798425) **Regression: KVM Importing fails due to an old version**

 - [BZ 1777954](https://bugzilla.redhat.com/1777954) **VM Templates greater then 101 quantity are not listed/reported in RHV-M Webadmin UI.**

 - [BZ 1437559](https://bugzilla.redhat.com/1437559) **[RFE] Explicitly assign all CPUs to NUMA  nodes**

 - [BZ 1678007](https://bugzilla.redhat.com/1678007) **When importing a VM override its cluster level to match the cluster it is imported to**

 - [BZ 1731590](https://bugzilla.redhat.com/1731590) **Cannot preview snapshot, it fails and VM remains locked.**

 - [BZ 1583328](https://bugzilla.redhat.com/1583328) **NPE while running VM with passthrough network vnic type**

 - [BZ 1781095](https://bugzilla.redhat.com/1781095) **Hide partial engine-cleanup option**

 - [BZ 1750212](https://bugzilla.redhat.com/1750212) **MERGE_STATUS fails with 'Invalid UUID string: mapper' when Direct LUN that already exists is hot-plugged**

 - [BZ 1743296](https://bugzilla.redhat.com/1743296) **When having many VMs with the same name - The same VM is selected each time**

 - [BZ 1731212](https://bugzilla.redhat.com/1731212) **RHV 4.4 landing page does not show login or allow scrolling.**

 - [BZ 1590911](https://bugzilla.redhat.com/1590911) **wrong template details shown when names are matching**

 - [BZ 1769339](https://bugzilla.redhat.com/1769339) **webadmin - Extend floating disk size on image, ISCSI, thin-prov' disks does not work**

 - [BZ 1770237](https://bugzilla.redhat.com/1770237) **Cannot assign a vNIC profile for VM instance profile.**

 - [BZ 1656621](https://bugzilla.redhat.com/1656621) **Importing VM OVA always enables 'Cloud-Init/Sysprep'**

 - [BZ 1763084](https://bugzilla.redhat.com/1763084) **Fix invalid host certificates by filling-in subject alternate name during host installation, host upgrade or certificate enrolment**

 - [BZ 1717390](https://bugzilla.redhat.com/1717390) **[REST] VM interface hot-unplug right after VM boot up fails over missing vnic alias name**

 - [BZ 1745384](https://bugzilla.redhat.com/1745384) **[IPv6 Static] Engine should allow updating network's static ipv6gateway**

 - [BZ 1547038](https://bugzilla.redhat.com/1547038) **Upgrade from 4.3 to 4.4 will fail if there are versioned templates in database**

 - [BZ 1729511](https://bugzilla.redhat.com/1729511) **engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject**

 - [BZ 1718141](https://bugzilla.redhat.com/1718141) **Cannot retrieve Host NIC VF configuration via REST API**

 - [BZ 1715393](https://bugzilla.redhat.com/1715393) **[Q35] Disabling and re-enabling SPICE USB creates a  USB2.0 controller instead of xhci**

 - [BZ 1659574](https://bugzilla.redhat.com/1659574) **Highly Available (HA) VMs with a VM lease failed to start after a 4.1 to 4.3 upgrade.**

 - [BZ 1664479](https://bugzilla.redhat.com/1664479) **Third VM fails to get migrated when host is placed into maintenance mode**

 - [BZ 1703112](https://bugzilla.redhat.com/1703112) **PCI address of NICs are not stored in the database after a hotplug of passthrough NIC resulting in change of network device name in VM after a reboot**

 - [BZ 1658101](https://bugzilla.redhat.com/1658101) **[RESTAPI] Adding ISO disables serial console**

 - [BZ 1693813](https://bugzilla.redhat.com/1693813) **Do not change DC level if there are VMs running/paused with older CL.**


### Other

#### imgbased

 - [BZ 1803017](https://bugzilla.redhat.com/1803017) **The discard mount option is not set properly**

   

 - [BZ 1777886](https://bugzilla.redhat.com/1777886) **[RFE] Support minimal storage layout for RHVH**

   

 - [BZ 1770683](https://bugzilla.redhat.com/1770683) **[RHVH-4.4.0] Upgrade RHVH from RHVH-4.4-20190926.3 to rhvh-4.4.0.8-0.20191107.0 failed**

   

 - [BZ 1766579](https://bugzilla.redhat.com/1766579) **imgbased build is not disabling anymore repositories**

   

 - [BZ 1759938](https://bugzilla.redhat.com/1759938) **unittest: TypeError: unicode argument expected, got 'str'**

   

 - [BZ 1760809](https://bugzilla.redhat.com/1760809) **src/imgbased/bootloader.py fails unit testing with nosetests-3**

   

 - [BZ 1760812](https://bugzilla.redhat.com/1760812) **imgbased/src/imgbased/local.py fails unit testing with nosetests-3**

   

 - [BZ 1760217](https://bugzilla.redhat.com/1760217) **RHVH4.4 installation fails when security profile is selected**

   

 - [BZ 1724102](https://bugzilla.redhat.com/1724102) **[RFE] Warn if SELinux is disabled when upgrading RHV-H**

   


#### oVirt Cockpit Plugin

 - [BZ 1754748](https://bugzilla.redhat.com/1754748) **Enabling LV cache along with VDO volumes fails during Deployment**

   

 - [BZ 1811989](https://bugzilla.redhat.com/1811989) **[vdo] VDO systemd unit file shouldn't be edited for modifying VDO max_discard_size**

   

 - [BZ 1603591](https://bugzilla.redhat.com/1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1814125](https://bugzilla.redhat.com/1814125) **Enable blacklisting devices by default and update default data disks for RAID 6 as 10**

   

 - [BZ 1814554](https://bugzilla.redhat.com/1814554) **Refrain from showing up the read-only fields in HC cockpit deployment wizard**

   

 - [BZ 1807815](https://bugzilla.redhat.com/1807815) **[RFE]Provide option to control blacklist or whitelist multipath devices from cockpit**

   

 - [BZ 1808152](https://bugzilla.redhat.com/1808152) **[ RHHI-V  1.8 ]  Failed to create VDO**

   

 - [BZ 1762800](https://bugzilla.redhat.com/1762800) **Consolidate host and additional hosts tab**

   

 - [BZ 1789277](https://bugzilla.redhat.com/1789277) **Unable to deploy gluster using the hyperconverged wizard**

   

 - [BZ 1715430](https://bugzilla.redhat.com/1715430) **Storage Domains should be created irrespective of automatic host addition**

   

 - [BZ 1688794](https://bugzilla.redhat.com/1688794) **Need an option to get IP version type used for FQDNs from user**

   

 - [BZ 1688245](https://bugzilla.redhat.com/1688245) **Gluster IPV6 storage domain requires additional mount options**

   

 - [BZ 1688271](https://bugzilla.redhat.com/1688271) **Additional hosts with IPV6 addresses doesn't qualify for valid addresses**

   

 - [BZ 1733416](https://bugzilla.redhat.com/1733416) **Cockpit UI dropdown menu changes needed for single node**

   

 - [BZ 1758150](https://bugzilla.redhat.com/1758150) **Expanded disk size field should be non-editable.**

   

 - [BZ 1752951](https://bugzilla.redhat.com/1752951) **Cleanup should confirm before starting up the cleanup process**

   

 - [BZ 1690880](https://bugzilla.redhat.com/1690880) **Brick size is incorrect after user modifies the volume from arbiter to pure replica.**

   

 - [BZ 1756709](https://bugzilla.redhat.com/1756709) **Add ids to elements in cockpit-ovirt**

   

 - [BZ 1700742](https://bugzilla.redhat.com/1700742) **python packaging changes needed due to deprecation of /usr/bin/python**

   


#### oVirt Host Dependencies

 - [BZ 1782754](https://bugzilla.redhat.com/1782754) **Disable goferd on RHV Host Images**

   

 - [BZ 1741792](https://bugzilla.redhat.com/1741792) **Add clevis RPMs to RHV-H image / repo**

   


#### oVirt Ansible hosted-engine setup role

 - [BZ 1816619](https://bugzilla.redhat.com/1816619) **[RFE] Enable update of appliance from channels after VM is deployed**

   

 - [BZ 1787267](https://bugzilla.redhat.com/1787267) **Misleading fail message: deprecation of 'ovirt_host_facts' to be renamed to 'ovirt_host_info'**

   

 - [BZ 1603591](https://bugzilla.redhat.com/1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1782799](https://bugzilla.redhat.com/1782799) **"rhel7" hard-coded in virt-install command**

   

 - [BZ 1806526](https://bugzilla.redhat.com/1806526) **hosted-engine-setup deployment fails :  Software Collections are no longer used on EL8**

   

 - [BZ 1459229](https://bugzilla.redhat.com/1459229) **Interface matching regular expression ignores interfaces with a '-' in the name**

   

 - [BZ 1770030](https://bugzilla.redhat.com/1770030) **[4.4.0-5] after deploy of HE the defined fqdn on the host changed to localhost.localdomain**

   


#### oVirt Provider OVN

 - [BZ 1701121](https://bugzilla.redhat.com/1701121) **/etc/ovirt-provider-ovn/ovirt-provider-ovn.conf is a config file, although it's not meant to be**

   


#### oVirt Hosted Engine Setup

 - [BZ 1603591](https://bugzilla.redhat.com/1603591) **[RFE] - Hosted-engine deployment on NFS should have option to specify exact NFS version v4.0.**

   

 - [BZ 1726290](https://bugzilla.redhat.com/1726290) **hosted-engine command line help is incomplete and confusing**

   


#### OTOPI

 - [BZ 1750093](https://bugzilla.redhat.com/1750093) **dnf plugin silently ignores updated packages with broken dependencies**

   

 - [BZ 1688659](https://bugzilla.redhat.com/1688659) **Drop requirement on sonatype-oss-parent from otopi**

   


#### MOM

 - [BZ 1626003](https://bugzilla.redhat.com/1626003) **Port mom to Python3**

   


#### oVirt Hosted Engine HA

 - [BZ 1768511](https://bugzilla.redhat.com/1768511) **ovirt-ha-broker "sometimes" fails to load on RHEL8 due to a permission error on a systemd defined RuntimeDirectory**

   

 - [BZ 1757414](https://bugzilla.redhat.com/1757414) **ovirt-hosted-engine-ha python3 unicode fails testing**

   

 - [BZ 1624790](https://bugzilla.redhat.com/1624790) **Package hosted-engine-ha for python2/3**

   


#### VDSM

 - [BZ 1680368](https://bugzilla.redhat.com/1680368) **Failed to create VM from template in CreateVolumeContainerCommand when stopping VDSM service in a single host environment**

   

 - [BZ 1819098](https://bugzilla.redhat.com/1819098) **Broken rollback for BlockVolume createVolumeMetadata**

   

 - [BZ 1818554](https://bugzilla.redhat.com/1818554) **Libvirt service fails to start**

   

 - [BZ 1817001](https://bugzilla.redhat.com/1817001) **[SR-IOV] [I40E] Hotunplug doesn't release the VF on the host**

   

 - [BZ 1816004](https://bugzilla.redhat.com/1816004) **Failed to create a new disk or copy template disk on iscsi of FCP storage domain - qemu-img: Protocol driver \'host_device\' does not support image creation**

   

 - [BZ 1812914](https://bugzilla.redhat.com/1812914) **Support setting a static DNS to interface that has dynamic IP**

   

 - [BZ 1544370](https://bugzilla.redhat.com/1544370) **vdsm does not deactivate all LVs if a LUN is removed from the Storage Domain**

   

 - [BZ 1553133](https://bugzilla.redhat.com/1553133) **Creating many thin clones corrupts vg metadata**

   

 - [BZ 1790503](https://bugzilla.redhat.com/1790503) **[nmstate] Support bridge_opts custom properties for nmstate usage**

   

 - [BZ 1673277](https://bugzilla.redhat.com/1673277) **"Volume Option cluster.granular-entry-heal=enable could not be set" when using "Optimize for Virt store"**

   

 - [BZ 1779161](https://bugzilla.redhat.com/1779161) **HP VM could not be started if TSC scaling is not supported by the host CPU.**

   

 - [BZ 1793867](https://bugzilla.redhat.com/1793867) **Remove Stochastic Fairness Queueing for network QoS**

   

 - [BZ 1785061](https://bugzilla.redhat.com/1785061) **vdsmd 4.4.0 throws an exception in asyncore.py while updating OVF data**

   

 - [BZ 1793550](https://bugzilla.redhat.com/1793550) **SCSI Hostdev Passthrough: local host disk is passthrough to VM when using other than scsi_generic property.**

   

 - [BZ 1766595](https://bugzilla.redhat.com/1766595) **Webadmin and RESTAPI - creating/managing/importing ISCSI storage domain not possible - error block device action: (), code = 600**

   

 - [BZ 1765018](https://bugzilla.redhat.com/1765018) **[rhel8.1] VM fail to start if having vNIC profile with port mirroring enabled**

   

 - [BZ 1639360](https://bugzilla.redhat.com/1639360) **Separate lvm activation from other lvm commands**

   

 - [BZ 1756944](https://bugzilla.redhat.com/1756944) **RHVH-4.4.0 The NICs are turned off during installation, but all NICs were found to be open after installation**

   

 - [BZ 1771051](https://bugzilla.redhat.com/1771051) **Missing imageio demon at RHEL8 host breaking upload/download/V2V**

   

 - [BZ 1765684](https://bugzilla.redhat.com/1765684) **Log important state changes and time spent in slow critical operations**

   

 - [BZ 1759388](https://bugzilla.redhat.com/1759388) **Chance of data corruption if SPM VDSM is restarted during LSM**

   

 - [BZ 1738861](https://bugzilla.redhat.com/1738861) **can't start VM that was cloned from snapshot when FIPS enabled**

   

 - [BZ 1755829](https://bugzilla.redhat.com/1755829) **One of the 'HSM.moveImage' exception handlers refers to non-existing members on the exception instance**

   

 - [BZ 1750340](https://bugzilla.redhat.com/1750340) **New libvirtd uses systemd socket activation by default, which is incompatible with --listen flag usage in /etc/sysconfig/libvirtd**

   

 - [BZ 1721599](https://bugzilla.redhat.com/1721599) **Cannot create volume with initial size on preallocated qcow volume**

   

 - [BZ 1751881](https://bugzilla.redhat.com/1751881) **Possible faulty storage task state transition on task abort**

   

 - [BZ 1753235](https://bugzilla.redhat.com/1753235) **Align volume size to 4k block size in hsm module for file based storage**

   

 - [BZ 1738429](https://bugzilla.redhat.com/1738429) **[SR-IOV] [rhel8.1] Can't enable VFs on rhel8.1 host - driver=igb**

   

 - [BZ 1738423](https://bugzilla.redhat.com/1738423) **[rhel8.1] vdsm override ovirtmgmt with static IPv4 instead of the origin dhcpv4 NIC during host deploy in RHV**

   

 - [BZ 1688052](https://bugzilla.redhat.com/1688052) **Typo and exception due to non-iterable object on gluster fencing testing**

   

 - [BZ 1679122](https://bugzilla.redhat.com/1679122) **Automatically set in engine the following flags for High Performance VMs types: invtsc cpu flag and also the tsc frequency flag for supporting migration**

   

 - [BZ 1723668](https://bugzilla.redhat.com/1723668) **VDSM command Get Host Statistics failed: Internal JSON-RPC error: {'reason': '[Errno 19] vnet<x> is not present in the system'}**

   

 - [BZ 1709628](https://bugzilla.redhat.com/1709628) **lshw can take more than 15 seconds to execute depending on the system**

   

 - [BZ 1700623](https://bugzilla.redhat.com/1700623) **Moving disk results in wrong SIZE/CAP key in the volume metadata**

   


#### oVirt Engine

 - [BZ 1770697](https://bugzilla.redhat.com/1770697) **VM can't start after was shut down with - XML error: Invalid PCI address 0000:03:01.0. slot must be <= 0**

   

 - [BZ 1820995](https://bugzilla.redhat.com/1820995) **[OVN] ovirt-provider-ovn.service is dead after deploy/upgrade to ovirt-engine-4.4.0-0.31.master.el8ev.noarch**

   

 - [BZ 1786999](https://bugzilla.redhat.com/1786999) **Multipath status changes are not displayed in Engine events**

   

 - [BZ 1784398](https://bugzilla.redhat.com/1784398) **System permissions to user can not be added**

   

 - [BZ 1816519](https://bugzilla.redhat.com/1816519) **Importing a registered template with already exists name shouldn't be allowed**

   

 - [BZ 1785364](https://bugzilla.redhat.com/1785364) **After engine restore, ovn networks are not restored and new OVN networks are not working properly on 4.4**

   

 - [BZ 1768844](https://bugzilla.redhat.com/1768844) **RHEL Advanced virtualization module streams support**

   As a part of adding new host we are now enabling advanced virtualization channel on the host to use latest supported libvirt and qemu packages

 - [BZ 1797494](https://bugzilla.redhat.com/1797494) **[RFE]Remove quartz dependency and use standard java scheduler**

   

 - [BZ 1807929](https://bugzilla.redhat.com/1807929) **importing VM uses the old (original) name instead of the new one**

   

 - [BZ 1431535](https://bugzilla.redhat.com/1431535) **[UI] - Add exclamation mark/tooltip warning 'VM Name already exist in the Data Center' on registering a VM from a DATA domain dialog and option to rename it**

   

 - [BZ 1810893](https://bugzilla.redhat.com/1810893) **mountOptions is ignored for "import storage domain" from GUI**

   

 - [BZ 1743690](https://bugzilla.redhat.com/1743690) **Commit and Undo buttons active when no snapshot selected**

   

 - [BZ 1610212](https://bugzilla.redhat.com/1610212) **After updating to RHV 4.1 while trying to edit the disk, getting error "Cannot edit Virtual Disk. Cannot edit Virtual Disk. Disk extension combined with disk compat version update isn't supported. Please perform the updates separately."**

   

 - [BZ 1712592](https://bugzilla.redhat.com/1712592) **oVirt 4.3.5 RC3 - cannot attach disk as virtio-scsi during new VM wizzard**

   

 - [BZ 1801779](https://bugzilla.redhat.com/1801779) **Disable Autoconf only option for rhel8 host and above**

   

 - [BZ 1646319](https://bugzilla.redhat.com/1646319) **dashboard not working while storage domain has size less than 1GB**

   

 - [BZ 1812906](https://bugzilla.redhat.com/1812906) **Upgrade via backup and restore from 4.3 to 4.4 is blocked**

   engine-backup in version 4.4 allows restoring also from backups taken by 4.3, to allow using that as a means to upgrade from 4.3 on EL7 to 4.4 on EL8 (which does not allow direct upgrade).

 - [BZ 1811866](https://bugzilla.redhat.com/1811866) **[Scale] Webadmin clusters list view response time is too long because of excessive amount of qos related sql queries**

   

 - [BZ 1783750](https://bugzilla.redhat.com/1783750) **Block upgrade if there's a risk of running out of space (say, any brick / volume is @ >90% full capacity)**

   

 - [BZ 1517696](https://bugzilla.redhat.com/1517696) **[UI] - grids bottom scrollbar hides bottom row**

   

 - [BZ 1633126](https://bugzilla.redhat.com/1633126) **[RFE] Provide roles for node replacement**

   

 - [BZ 1795232](https://bugzilla.redhat.com/1795232) **Apply Patternfly 4 styles and layouts to error and non-webadmin pages**

   

 - [BZ 1721368](https://bugzilla.redhat.com/1721368) **Support upgrade of HC cluster from engine UI**

   

 - [BZ 1809052](https://bugzilla.redhat.com/1809052) **[CNV&RHV] ovirt-engine log file spammed by failed timers ( approx 3-5 messages/sec )**

   

 - [BZ 1565696](https://bugzilla.redhat.com/1565696) **UI plugin API - action button callbacks invoked multiple times**

   

 - [BZ 1806276](https://bugzilla.redhat.com/1806276) **[HE] ovirt-provider-ovn is non-functional on 4.3.9 Hosted-Engine**

   

 - [BZ 1809640](https://bugzilla.redhat.com/1809640) **Engine should not explode if host reports duplicated nameservers**

   

 - [BZ 1791826](https://bugzilla.redhat.com/1791826) **SCSI passthrough: VM failed to start after changing custom property with hostdev attached.**

   

 - [BZ 1779161](https://bugzilla.redhat.com/1779161) **HP VM could not be started if TSC scaling is not supported by the host CPU.**

   

 - [BZ 1793550](https://bugzilla.redhat.com/1793550) **SCSI Hostdev Passthrough: local host disk is passthrough to VM when using other than scsi_generic property.**

   

 - [BZ 1680522](https://bugzilla.redhat.com/1680522) **[ja_JP] Overlapping string on storage -> volumes ->snapshot -> new page.**

   

 - [BZ 1805142](https://bugzilla.redhat.com/1805142) **Updating an OpenStack port creates invalid json**

   

 - [BZ 1782236](https://bugzilla.redhat.com/1782236) **Windows Update (the drivers) enablement**

   

 - [BZ 1795246](https://bugzilla.redhat.com/1795246) **WGT ISO on data domain is always attached to Win VMs**

   

 - [BZ 1779543](https://bugzilla.redhat.com/1779543) **With Q35 BIOS the Cluster overview shows wrong Emulated Machine Type**

   

 - [BZ 1784767](https://bugzilla.redhat.com/1784767) **webadmin - illegal char' in extend size text box while editing disk not marked as illegal**

   

 - [BZ 1691301](https://bugzilla.redhat.com/1691301) **[CodeChange] Remove (or disable) yum/dnf groups handling code**

   

 - [BZ 1777215](https://bugzilla.redhat.com/1777215) **Add deprecation message to "Export to Export Domain" dialog**

   

 - [BZ 1796047](https://bugzilla.redhat.com/1796047) **Bad payload on ignition when the custom script is empty**

   

 - [BZ 1795238](https://bugzilla.redhat.com/1795238) **ovirt_hosted_engine_ha exception: failed to start monitor via ovirt-ha-broker**

   

 - [BZ 1714528](https://bugzilla.redhat.com/1714528) **Missing IDs on cluster upgrade buttons**

   

 - [BZ 1779580](https://bugzilla.redhat.com/1779580) **drop rhvm-doc package**

   

 - [BZ 1679880](https://bugzilla.redhat.com/1679880) **[fr_FR] Misalignment on Storage > Volumes >Geo-replication > New window.**

   

 - [BZ 1768393](https://bugzilla.redhat.com/1768393) **Auto attached WGT ISO doesn't show in Change CD dialogue**

   

 - [BZ 1769306](https://bugzilla.redhat.com/1769306) **A white space appears between upper masthead menu to vertical masthead menu**

   

 - [BZ 1752515](https://bugzilla.redhat.com/1752515) **The Notification Drawer window title is overlapped by the "Alerts" title area and the close/widen buttons as well as the whole drawer area is shifted**

   

 - [BZ 1656329](https://bugzilla.redhat.com/1656329) **Webadmin- providers - creating the same glance image provider with different name & same provider url & tenant is allowed**

   

 - [BZ 1789291](https://bugzilla.redhat.com/1789291) **Missing ca.pem recreation question should be part of PKI section**

   

 - [BZ 1786450](https://bugzilla.redhat.com/1786450) **webadmin - cluster tab under data center can't be shown properly - can't see any attached cluster to DC**

   

 - [BZ 1769463](https://bugzilla.redhat.com/1769463) **[Scale] Slow performance for api/clusters when many networks devices are present**

   

 - [BZ 1635498](https://bugzilla.redhat.com/1635498) **[UI] [Text] - Notification Drawer - On display all Alerts the text show 'All events were displayed'**

   

 - [BZ 1666032](https://bugzilla.redhat.com/1666032) **RFE Able to create direct LUN from already used LUN (by storage domain) without selecting 'approve operation' flag**

   

 - [BZ 1734409](https://bugzilla.redhat.com/1734409) **Duplicate image id when importing VM from export domain while the original VM still exists in the environment**

   

 - [BZ 1768784](https://bugzilla.redhat.com/1768784) **[rhv-4.4.0-4] webadmin - destroy storage domain is not possible via UI**

   

 - [BZ 1771474](https://bugzilla.redhat.com/1771474) **webadmin -few windows have unnecessary blank space**

   

 - [BZ 1743562](https://bugzilla.redhat.com/1743562) **Custom property of vNIC profile does not allow multiple security group ids**

   

 - [BZ 1776317](https://bugzilla.redhat.com/1776317) **Cannot hotplug more than 2 vNICs per VM**

   

 - [BZ 1754363](https://bugzilla.redhat.com/1754363) **[Scale] Engine generates excessive amount of dns configuration related sql queries**

   

 - [BZ 1771471](https://bugzilla.redhat.com/1771471) **webadmin - New virtual disk > Direct LUN window is a mess**

   

 - [BZ 1771545](https://bugzilla.redhat.com/1771545) **webadmin - The window of "attach virtual disk" was cut**

   

 - [BZ 1733031](https://bugzilla.redhat.com/1733031) **[RFE] Add warning when importing data domains to newer DC that may trigger SD format upgrade**

   Feature: 





Reason: 



Result:

 - [BZ 1564509](https://bugzilla.redhat.com/1564509) **Unable to grant user permissions to upload ISOs through the web interface**

   

 - [BZ 1768851](https://bugzilla.redhat.com/1768851) **webadmin - block(ISCSI/FC) storage domain window is a mess - misaligned "Advance Parameters" makes it hard to choose other options**

   

 - [BZ 1768707](https://bugzilla.redhat.com/1768707) **Cannot set or update iscsi portal group tag when editing storage connection via API**

   

 - [BZ 1701236](https://bugzilla.redhat.com/1701236) **Hot plug disk resides on backup storage domain while VM is running is permitted**

   

 - [BZ 1753628](https://bugzilla.redhat.com/1753628) **webadmin - Modify/Edit an existing DC compatibility level on a local storage domain is not possible**

   

 - [BZ 1728617](https://bugzilla.redhat.com/1728617) **upgrade of host fails on timeout after 30 minutes**

   Default maximum timeout for an ansible-playbook executed from engine has been raised from 30 to 120 minutes. This timeout is defined using configuration option ANSIBLE_PLAYBOOK_EXEC_DEFAULT_TIMEOUT within /usr/share/ovirt-engine/services/ovirt-engine/ovirt-engine.conf. If administrators need to change that timeout they can create /etc/ovirt-engine/engine.conf.d/99-ansible-timeout.conf file with below content:



  ANSIBLE_PLAYBOOK_EXEC_DEFAULT_TIMEOUT=NNN



where NNN is number of minutes the timeout should be.

 - [BZ 1743543](https://bugzilla.redhat.com/1743543) **extract_ova fails over nfs**

   

 - [BZ 1679122](https://bugzilla.redhat.com/1679122) **Automatically set in engine the following flags for High Performance VMs types: invtsc cpu flag and also the tsc frequency flag for supporting migration**

   

 - [BZ 1680502](https://bugzilla.redhat.com/1680502) **The cancel button is not working on storage > volumes > geo-replication > new screen.**

   

 - [BZ 1750905](https://bugzilla.redhat.com/1750905) **Data Center -> Guide me -> Configure storage does not let user create iSCSI volumes**

   

 - [BZ 1758874](https://bugzilla.redhat.com/1758874) **V5 format is missing storage domain (none)**

   

 - [BZ 1746390](https://bugzilla.redhat.com/1746390) **Error while creating local storage: Internal Engine Error**

   

 - [BZ 1722519](https://bugzilla.redhat.com/1722519) **Guest tools ISO in data domain not automatically attached to Windows VMs**

   

 - [BZ 1748736](https://bugzilla.redhat.com/1748736) **[UI] Tooltips in the setup networks dialog are broken**

   

 - [BZ 1738861](https://bugzilla.redhat.com/1738861) **can't start VM that was cloned from snapshot when FIPS enabled**

   

 - [BZ 1678003](https://bugzilla.redhat.com/1678003) **Collapse snapshot flag is available even if VM has no snapshots at all**

   

 - [BZ 1590866](https://bugzilla.redhat.com/1590866) **SDK allows to create template in one DC with disk in another DC**

   

 - [BZ 1741102](https://bugzilla.redhat.com/1741102) **host activation causes RHHI nodes to lose the quorum**

   

 - [BZ 1652064](https://bugzilla.redhat.com/1652064) **Missing REST API endpoint to access affinity group hosts: .../affinitygroups/ID/hosts**

   

 - [BZ 1727025](https://bugzilla.redhat.com/1727025) **NPE in DestroyImage endAction during live merge leaving a task in DB for hours causing operations depending on host clean tasks to fail as Deactivate host/StopSPM/deactivate SD**

   

 - [BZ 1742924](https://bugzilla.redhat.com/1742924) **"Field 'foo' can not be updated when status is 'Up'" in engine.log when listing 'NEXT_RUN' configuration snapshot VMs**

   

 - [BZ 1700338](https://bugzilla.redhat.com/1700338) **[RFE] Alternate method to configure the email Event Notifier for a user in RHV through API (instead of  RHV GUI)**

   

 - [BZ 1730611](https://bugzilla.redhat.com/1730611) **Inconsistent UX labels - Use Host vs Host to Use**

   

 - [BZ 1727094](https://bugzilla.redhat.com/1727094) **ISOs in Change CD dialog not sorted**

   

 - [BZ 1718790](https://bugzilla.redhat.com/1718790) **Drop oVirt Node Legacy support in ovirt-engine**

   

 - [BZ 1739257](https://bugzilla.redhat.com/1739257) **[UI] Don't show 'out-of-sync' info tooltip for the out-of-sync column under main 'Hosts' tab if network in sync**

   

 - [BZ 1730264](https://bugzilla.redhat.com/1730264) **VMs will fail to start if the vnic profile attached is having port mirroring enabled and have name greater than 15 characters**

   

 - [BZ 1690026](https://bugzilla.redhat.com/1690026) **[RFE] - Creating an NFS storage domain the engine should let the user specify exact NFS version v4.0 and not just v4**

   

 - [BZ 1731049](https://bugzilla.redhat.com/1731049) **exception while adding user or group to quota consumer**

   

 - [BZ 1651939](https://bugzilla.redhat.com/1651939) **a new size of the direct LUN not updated in Admin Portal**

   

 - [BZ 1721449](https://bugzilla.redhat.com/1721449) **ISOs in Run Once dialog grouped by domain**

   

 - [BZ 1721438](https://bugzilla.redhat.com/1721438) **The list of ISOs not sorted in VM Import dialog**

   

 - [BZ 1700036](https://bugzilla.redhat.com/1700036) **[RFE] Add RedFish API for host power management for RHEV**

   Support for RedFish power management agent has been added into RHV. To use that functionality administrators need to select redfish power management agent in Power Management tab in Edit Host dialog and fill-in additional details like login information and IP/FQDN of the agent

 - [BZ 1714834](https://bugzilla.redhat.com/1714834) **Cannot disable SCSI passthrough using API**

   

 - [BZ 1530249](https://bugzilla.redhat.com/1530249) **Default quota must be updated  - still contains 0% (invalid value)**

   

 - [BZ 1671397](https://bugzilla.redhat.com/1671397) **[RFE] Add mousovers and brief help instructions to OVA import dialog**

   

 - [BZ 1721563](https://bugzilla.redhat.com/1721563) **VM not started on the expected host since external weight policy units are ignored.**

   

 - [BZ 1712890](https://bugzilla.redhat.com/1712890) **engine-setup should check for snapshots in unsupported CL**

   Now, on upgrade, engine-setup prompts about virtual machines that have snapshots that are incompatible with the version we are going to upgrade to. It's safe to let it proceed, but it's not safe to try using these snapshots after the upgrade, e.g. to preview them.

 - [BZ 1706822](https://bugzilla.redhat.com/1706822) **[engine-setup] Confusing message in engine-setup about installing local DBs manually**

   

 - [BZ 1632808](https://bugzilla.redhat.com/1632808) **OVF import wrong error message**

   

 - [BZ 1609686](https://bugzilla.redhat.com/1609686) **Get VMs  response doesn't match virsh output after updating of the serial number policy**

   

 - [BZ 1633240](https://bugzilla.redhat.com/1633240) **can't search in pools with comment**

   

 - [BZ 1684266](https://bugzilla.redhat.com/1684266) **Exporting OVA timed out leaving orphan volume**

   

 - [BZ 1695026](https://bugzilla.redhat.com/1695026) **Failure in creating snapshots during "Live Storage Migration" can result in a nonexistent snapshot**

   

 - [BZ 1666913](https://bugzilla.redhat.com/1666913) **[UI] warn users about different "Vdsm Name" when creating network with a fancy char or long name**

   

 - [BZ 1679039](https://bugzilla.redhat.com/1679039) **Unable to upload image through Storage->Domain->Disk because of wrong DC**

   

 - [BZ 1696748](https://bugzilla.redhat.com/1696748) **UI exception seen when creating the new logical network and selecting that network**

   

 - [BZ 1693628](https://bugzilla.redhat.com/1693628) **Engine generates too many updates to vm_dynamic table due to the session change**

   


#### oVirt Engine UI Extensions

 - [BZ 1714528](https://bugzilla.redhat.com/1714528) **Missing IDs on cluster upgrade buttons**

   

 - [BZ 1786569](https://bugzilla.redhat.com/1786569) **Export VM to data domain with the same name fails with no clear error in the UI**

   

 - [BZ 1786589](https://bugzilla.redhat.com/1786589) **Export VM to data domain while snapshot is being created fails with no clear error in the UI**

   

 - [BZ 1786621](https://bugzilla.redhat.com/1786621) **When exporting VM with snapshots to data domain without collapse - the VM is exported without the snapshots**

   


#### oVirt Engine Metrics

 - [BZ 1773313](https://bugzilla.redhat.com/1773313) **RHV Metric store installation fails with error: "You need to install \"jmespath\" prior to running json_query filter"**

   

 - [BZ 1715511](https://bugzilla.redhat.com/1715511) **Update README for Variable openshift_distribution to include RHV default**

   

 - [BZ 1717339](https://bugzilla.redhat.com/1717339) **command 'SystemLogSocketName' is currently not permitted - did you already set it via a RainerScript command (v6+ config)?**

   

 - [BZ 1687729](https://bugzilla.redhat.com/1687729) **Code Change - Use dedicated Ansible module for manageing SELinux file context**

   

 - [BZ 1677679](https://bugzilla.redhat.com/1677679) **Remove hacky things from ansible.cfg**

   

 - [BZ 1755412](https://bugzilla.redhat.com/1755412) **Setting "oreg_url: registry.redhat.io" fails with error**

   

 - [BZ 1714994](https://bugzilla.redhat.com/1714994) **TODO comment in the check_logging_collectors.yml**

   


#### oVirt Release Package

 - [BZ 1756706](https://bugzilla.redhat.com/1756706) **The sshd service of RHVH is inactive.**

   

 - [BZ 1757457](https://bugzilla.redhat.com/1757457) **ovirt-release-host-node has python2 code in %post section of the spec file**

   


#### oVirt Engine Appliance

 - [BZ 1594548](https://bugzilla.redhat.com/1594548) **[RFE] Ensure Cockpit is installed properly (on Engine): cockpit-bridge is not a deps, causing login failure to cockpit**

   


### No Doc Update

#### oVirt Cockpit Plugin

 - [BZ 1752113](https://bugzilla.redhat.com/1752113) **Hosted-Engine will not deploy if SSH access is not enabled for the root user.**

   


#### oVirt Hosted Engine Setup

 - [BZ 1752113](https://bugzilla.redhat.com/1752113) **Hosted-Engine will not deploy if SSH access is not enabled for the root user.**

   

 - [BZ 1717991](https://bugzilla.redhat.com/1717991) **ovirt-hosted-engine-setup requires pyliblzma which is available only for python2**

   


#### OTOPI

 - [BZ 1814940](https://bugzilla.redhat.com/1814940) **otopi fails with: Python 2 is disabled in RHEL8**

   

 - [BZ 1525905](https://bugzilla.redhat.com/1525905) **[RFE] otopi should notify about nonexistent before=/after= events**

   


#### oVirt Hosted Engine HA

 - [BZ 1794089](https://bugzilla.redhat.com/1794089) **Ha-broker fails to recognize when HE VM's storage is already locked - QEMU error message has changed**

   

 - [BZ 1786458](https://bugzilla.redhat.com/1786458) **Python3: broker fails to update engine health status**

   


#### VDSM

 - [BZ 1819125](https://bugzilla.redhat.com/1819125) **Cold storage migration to iscsi domain fails**

   

 - [BZ 1811425](https://bugzilla.redhat.com/1811425) **VM CD-ROM payload device switch to an empty source file**

   

 - [BZ 1813961](https://bugzilla.redhat.com/1813961) **vdsm-tool crashes on python3 change needed**

   

 - [BZ 1787222](https://bugzilla.redhat.com/1787222) **Coredumps are broken since Fedora 26**

   

 - [BZ 1808850](https://bugzilla.redhat.com/1808850) **Failed to create a new disk or copy template disk on iscsi domains due to OVF failure in ILLEGAL state**

   

 - [BZ 1807050](https://bugzilla.redhat.com/1807050) **vgs are not seen immediately after iscsiadm login**

   

 - [BZ 1797477](https://bugzilla.redhat.com/1797477) **Power Management configuration fails with JSON-RPC error**

   

 - [BZ 1692685](https://bugzilla.redhat.com/1692685) **Bad/missing home directory for user vdsm causes a failure**

   

 - [BZ 1712832](https://bugzilla.redhat.com/1712832) **Storage migration of a compressed image is failing with error "No space left on device" in block storage domain**

   

 - [BZ 1786451](https://bugzilla.redhat.com/1786451) **hosted-engine --add-console-password fails with: expected string or bytes-like object**

   

 - [BZ 1529344](https://bugzilla.redhat.com/1529344) **Printing vdsm configuration by running config.py fail with "AttributeError: 'module' object has no attribute 'glob'"**

   

 - [BZ 1778638](https://bugzilla.redhat.com/1778638) **[4.4.0-6] failed to add secondary hosts(HA) with error "Unable to stop service supervdsmd"**

   

 - [BZ 1760262](https://bugzilla.redhat.com/1760262) **Bridge linux profile is not activated and stuck in connecting state after reboot**

   

 - [BZ 1768735](https://bugzilla.redhat.com/1768735) **[rhv-4.4.0-4] - Adding ISCSI storage domains Failes with error VolumeGroupCreateError and code 502 - TypeError: devicemapper_removeMapping() missing 1 required positional argument: 'deviceName'**

   

 - [BZ 1663661](https://bugzilla.redhat.com/1663661) **vdsm uses obsolete python module 'imp'**

   

 - [BZ 1753898](https://bugzilla.redhat.com/1753898) **Make block size detection compatible with Gluster storage**

   

 - [BZ 1720977](https://bugzilla.redhat.com/1720977) **[logging] limit getStats**

   

 - [BZ 1655593](https://bugzilla.redhat.com/1655593) **Download only forbidden by vdsmupgrade yum plugin**

   


#### oVirt vmconsole

 - [BZ 1507920](https://bugzilla.redhat.com/1507920) **/usr/share/ovirt-vmconsole/ovirt-vmconsole-host/ovirt-vmconsole-host-sshd/sshd_config line 23: Deprecated option RSAAuthentication**

   


#### oVirt Engine

 - [BZ 1819205](https://bugzilla.redhat.com/1819205) **[CodeChange][i18n] oVirt 4.4 webadmin - translation update**

   

 - [BZ 1820182](https://bugzilla.redhat.com/1820182) **ISCSI ONLY- Cloning a VM(deep copy) from template fails in 'MeasureVolumeVDS' method with Could not open image No such file or directory**

   

 - [BZ 1819514](https://bugzilla.redhat.com/1819514) **Failed to register 4.4 host to the latest engine (4.4.0-0.29.master.el8ev)**

   

 - [BZ 1819248](https://bugzilla.redhat.com/1819248) **Cannot upgrade host after engine setup**

   

 - [BZ 1816951](https://bugzilla.redhat.com/1816951) **[CNV&RHV] CNV VM migration failure is not handled correctly by the engine**

   

 - [BZ 1816739](https://bugzilla.redhat.com/1816739) **[CNV&RHV] CNV VM updated form CNV side doesn't update vm properties over on RHV side**

   

 - [BZ 1816691](https://bugzilla.redhat.com/1816691) **[CNV&RHV] Changes that require Virtual Machine restart: namespace**

   

 - [BZ 1808126](https://bugzilla.redhat.com/1808126) **host_service.install() does not work with deploy_hosted_engine as True.**

   

 - [BZ 1797927](https://bugzilla.redhat.com/1797927) **[REST-API] Attaching/adding a disk with SATA interface to a VM fails with Exception Caused by: java.lang.IllegalArgumentException: Unknown disk interface "SATA"**

   

 - [BZ 1814197](https://bugzilla.redhat.com/1814197) **[CNV&RHV] when provider is remover DC is left behind and active**

   

 - [BZ 1712832](https://bugzilla.redhat.com/1712832) **Storage migration of a compressed image is failing with error "No space left on device" in block storage domain**

   

 - [BZ 1811869](https://bugzilla.redhat.com/1811869) **[Scale] Webadmin\REST for host interface list response time is too long because of excessive amount of qos related sql queries**

   

 - [BZ 1811865](https://bugzilla.redhat.com/1811865) **[Scale] Host Monitoring generates excessive amount of qos related sql queries**

   

 - [BZ 1584563](https://bugzilla.redhat.com/1584563) **[RFE] Expand message in the main events view**

   

 - [BZ 1135786](https://bugzilla.redhat.com/1135786) **[RFE] trim spaces in integer fields**

   

 - [BZ 1809040](https://bugzilla.redhat.com/1809040) **[CNV&RHV] let the user know that token is not valid anymore**

   

 - [BZ 1801194](https://bugzilla.redhat.com/1801194) **User experience of ignition/Custom script textbox is low.**

   

 - [BZ 1788090](https://bugzilla.redhat.com/1788090) **Failed to reinstall a host on upgraded 4.4: Task Copy vdsm and QEMU CSRs failed to execute**

   

 - [BZ 1807883](https://bugzilla.redhat.com/1807883) **Can't create a VM on firefox due to an "invalid regexp group" error**

   

 - [BZ 1779588](https://bugzilla.redhat.com/1779588) **[RHVH-4.4.0] Unable to detect upgrade package, when upgrading RHVH from RHVM UI**

   

 - [BZ 1795184](https://bugzilla.redhat.com/1795184) **Check for upgrade on RHEL 8 host always reports no updates**

   

 - [BZ 1791749](https://bugzilla.redhat.com/1791749) **The engine allows adding a new host using IP as hostname while the host already exists and appears with FQDN**

   

 - [BZ 1802543](https://bugzilla.redhat.com/1802543) **Support back compatibility with 4.3 cluster creating live snapshots**

   

 - [BZ 1791255](https://bugzilla.redhat.com/1791255) **[RFE] There are no available hosts capable of running the engine VM. Why?**

   

 - [BZ 1800947](https://bugzilla.redhat.com/1800947) **Clone VM action fails  while the engine.log and events report success**

   

 - [BZ 1801129](https://bugzilla.redhat.com/1801129) **separate dwh setup: No such file or directory: '/usr/share/ovirt-engine/selinux'**

   

 - [BZ 1782279](https://bugzilla.redhat.com/1782279) **Warning message for low space is not received on Imported Storage domain**

   

 - [BZ 1798139](https://bugzilla.redhat.com/1798139) **VirtIO-SCSI virtual disk cannot be added to VM.**

   

 - [BZ 1725003](https://bugzilla.redhat.com/1725003) **[RFE] fail adding permissions when no user/group selected**

   

 - [BZ 1791007](https://bugzilla.redhat.com/1791007) **[4.4] Connection to VM using vm-console failed**

   

 - [BZ 1691562](https://bugzilla.redhat.com/1691562) **Cluster level changes are not increasing VMs generation numbers and so a new OVF_STORE content is not copied to the shared storage**

   

 - [BZ 1795281](https://bugzilla.redhat.com/1795281) **[UI] Failed to create VM with a nasty NPE in the engine log (Query 'IsVmTemplateI440fxQuery' failed: null)**

   

 - [BZ 1786118](https://bugzilla.redhat.com/1786118) **[4.4.0-17] failed to add secondary hosts(HA) with error "Unable to stop service vdsmd: Job for vdsmd.service canceled"**

   

 - [BZ 1752282](https://bugzilla.redhat.com/1752282) **Cannot activate Host while RefreshHostCapabilitiesCommand is running**

   

 - [BZ 1780022](https://bugzilla.redhat.com/1780022) **An internal retry to run VM is ignoring ignition payload, RHCOS goes into emergency**

   

 - [BZ 1787195](https://bugzilla.redhat.com/1787195) **[4.4.0-13] 1 out of 3 hosts non-responsive after ansible install finished - ovn-controller[20628]: ovs|00040|stream_ssl|ERR|Private key does not match certificate public key: error:140A80BE:SSL routines:SSL_CTX_check_private_key:no private key assigned**

   

 - [BZ 1710724](https://bugzilla.redhat.com/1710724) **Get wrong values while search VMs**

   

 - [BZ 1789262](https://bugzilla.redhat.com/1789262) **Can not use clusters: datacenter.<anything> in search engine**

   

 - [BZ 1776306](https://bugzilla.redhat.com/1776306) **[rhv-4.4.0-4] - Export VM(on a system upgraded from 4.3) as ova fails -  Command 'ExportVmToOva' failed when attempting to perform the next operation**

   

 - [BZ 1523835](https://bugzilla.redhat.com/1523835) **Hosted-Engine: memory hotplug does not work for engine vm**

   

 - [BZ 1749674](https://bugzilla.redhat.com/1749674) **[RFE] Use Ansible instead of ovirt-host-deploy for host deployment**

   

 - [BZ 1784010](https://bugzilla.redhat.com/1784010) **[rhv-4.4.0-9] Right after adding host to engine - Failed to execute Ansible host-deploy role: null with host unreachable**

   

 - [BZ 1785272](https://bugzilla.redhat.com/1785272) **Host register failed with yum-utils**

   

 - [BZ 1715763](https://bugzilla.redhat.com/1715763) **[RFE] Upgrade of host failed - yum lockfile is held by another process**

   

 - [BZ 1779085](https://bugzilla.redhat.com/1779085) **Storage domain can not be deactivated with error Failed executing step 'UPDATE_OVF_STORE'**

   

 - [BZ 1529042](https://bugzilla.redhat.com/1529042) **[RFE] Changing of Cluster CPU Type does not trigger config update notification**

   

 - [BZ 1769212](https://bugzilla.redhat.com/1769212) **Rest API for creating affinity group with labels is resulted with the group created with missing labels**

   

 - [BZ 1734729](https://bugzilla.redhat.com/1734729) **[RFE] Update vdsm-jsonrpc-java to use OpenJDK 11 - both build and runtime**

   

 - [BZ 1759143](https://bugzilla.redhat.com/1759143) **[RFE] Use ansible-runner-service instead of ansible-playbook to execute Ansible playbooks from engine**

   

 - [BZ 1718851](https://bugzilla.redhat.com/1718851) **[RFE] Unmanaged disks should be kept after VM restart/poweroff**

   

 - [BZ 1705727](https://bugzilla.redhat.com/1705727) **Cannot read property 'a' of undefined when approving host**

   

 - [BZ 1741625](https://bugzilla.redhat.com/1741625) **VM fails to be re-started with error: Failed to acquire lock: No space left on device**

   

 - [BZ 1723804](https://bugzilla.redhat.com/1723804) **Operation Failed: [Resource unavailable] - failed to sync networks on host**

   

 - [BZ 1751423](https://bugzilla.redhat.com/1751423) **Improve description of shared memory statistics and remove unimplemented memory metrics from API**

   

 - [BZ 1758786](https://bugzilla.redhat.com/1758786) **Removing of Affinity Label in Edit VM window  throws java.lang.UnsupportedOperationException**

   

 - [BZ 1724632](https://bugzilla.redhat.com/1724632) **When setting high custom compatibility version with ovirt_vm, java exception is returned**

   

 - [BZ 1754490](https://bugzilla.redhat.com/1754490) **RHV Manager cannot start on EAP 7.2.4**

   

 - [BZ 1749944](https://bugzilla.redhat.com/1749944) **teardownImage attempts to deactivate in-use LV's rendering the VM disk image/volumes in locked state.**

   

 - [BZ 1707451](https://bugzilla.redhat.com/1707451) **Don't execute removal of hosted engine configuration when host is turned off**

   

 - [BZ 1734839](https://bugzilla.redhat.com/1734839) **Unable to start guests in our Power9 cluster without running in headless mode.**

   

 - [BZ 1737684](https://bugzilla.redhat.com/1737684) **Engine deletes the leaf volume when SnapshotVDSCommand timed out without checking if the  volume is still used by the VM**

   

 - [BZ 1686650](https://bugzilla.redhat.com/1686650) **Memory snapshots' deletion logging unnecessary WARNINGS in engine.log**

   

 - [BZ 1741271](https://bugzilla.redhat.com/1741271) **Move/Copy disk are blocked if there is less space in source SD than the size of the disk**

   

 - [BZ 1715725](https://bugzilla.redhat.com/1715725) **Sending credentials in query string logs them in ovirt-request-logs**

   

 - [BZ 1730436](https://bugzilla.redhat.com/1730436) **Snapshot creation was successful, but snapshot remains locked**

   

 - [BZ 1726330](https://bugzilla.redhat.com/1726330) **[Cinderlib] - Start vm with 3PAR-ISCSI managed storage domain fails with the error : "Managed Volume is already attached"**

   

 - [BZ 1690155](https://bugzilla.redhat.com/1690155) **Disk migration progress bar not clearly visible and unusable.**

   

 - [BZ 1530026](https://bugzilla.redhat.com/1530026) **[RFE][UI] Remove external network selection on add host window**

   

 - [BZ 1654889](https://bugzilla.redhat.com/1654889) **[RFE] Support console VNC for mediated devices**

   

 - [BZ 1700319](https://bugzilla.redhat.com/1700319) **VM is going to pause state with "storage I/O  error".**

   

 - [BZ 1637172](https://bugzilla.redhat.com/1637172) **Live Merge hung in the volume deletion phase,  leaving snapshot in a LOCKED state**

   

 - [BZ 1696111](https://bugzilla.redhat.com/1696111) **RHV could not detect Guest Agent when create snapshot for the running guest which installed qemu-guest-agent**

   

 - [BZ 1658524](https://bugzilla.redhat.com/1658524) **Replace error notification with patternfly element**

   

 - [BZ 1616451](https://bugzilla.redhat.com/1616451) **[UI] add a tooltip to explain the supported matrix for the combination of disk allocation policies, formats and the combination result**

   

 - [BZ 1700725](https://bugzilla.redhat.com/1700725) **[scale] RHV-M runs out of memory due to to much data reported by the guest agent**

   

 - [BZ 1690475](https://bugzilla.redhat.com/1690475) **When a live storage migration fails, the auto generated snapshot does not get removed**

   

 - [BZ 1498654](https://bugzilla.redhat.com/1498654) **[RFE] Add correlation ID to events details page**

   

 - [BZ 1660644](https://bugzilla.redhat.com/1660644) **Concurrent LSMs of the same disk can be issued via the REST-API**

   


#### oVirt Engine Data Warehouse

 - [BZ 1734718](https://bugzilla.redhat.com/1734718) **[RFE] Update DWH to use OpenJDK 11 - both build and runtime**

   


#### oVirt Engine UI Extensions

 - [BZ 1807777](https://bugzilla.redhat.com/1807777) **Fix cluster-upgrade playbook location to align with other playbooks executed from ovirt-engine via ansible-runner-service**

   


#### oVirt Engine SDK 4 Java

 - [BZ 1734728](https://bugzilla.redhat.com/1734728) **[RFE] Update Java SDK to use OpenJDK 11 - both build and runtime**

   


#### oVirt Engine Extension AAA-JDBC

 - [BZ 1734720](https://bugzilla.redhat.com/1734720) **[RFE] Update aaa-jdbc to use OpenJDK 11 - both build and runtime**

   

 - [BZ 1714633](https://bugzilla.redhat.com/1714633) **Using more than one asterisk in the search string is not working when searching for users.**

   


#### oVirt Engine Metrics

 - [BZ 1807860](https://bugzilla.redhat.com/1807860) **[RFE] Allow resource allocation options to be customized**

   

 - [BZ 1762263](https://bugzilla.redhat.com/1762263) **[RFE] Require Ansible 2.9 in ovirt-engine-metrics**

   


#### VDSM JSON-RPC Java

 - [BZ 1734729](https://bugzilla.redhat.com/1734729) **[RFE] Update vdsm-jsonrpc-java to use OpenJDK 11 - both build and runtime**

   


#### oVirt Release Package

 - [BZ 1598404](https://bugzilla.redhat.com/1598404) **branding: oVirt Node cockpit and oVirt Engine have different coloring**

   


#### oVirt-Cockpit SSO

 - [BZ 1789733](https://bugzilla.redhat.com/1789733) **Host console SSO not working at all!**

   


#### Kubevirt java client

 - [BZ 1816643](https://bugzilla.redhat.com/1816643) **[CNV&RHV] VM created in CNV not visible in RHV**

   

 - [BZ 1816654](https://bugzilla.redhat.com/1816654) **[CNV&RHV] adding provider with already created vm failed**

   


#### Contributors

126 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Allon Mureinik
	Amit Bawer
	Andrej Cernek
	Andrej Krejcir
	Arik Hadas
	Artur Socha
	Asaf Rachmani
	Barak Korren
	Bartosz Rybacki
	Bell Levin
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
	Vitor de Lima
	Vojtech Juranek
	Vojtech Szocs
	Yaniv Bronhaim
	Yedidyah Bar David
	Yoav Kleinberger
	Yotam Fromm
	Yuval Turgeman
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
	thaorell
	yodem
	
