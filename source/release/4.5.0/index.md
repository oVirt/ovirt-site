---
title: oVirt 4.5.0 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.0 release planning

The oVirt 4.5.0 code freeze is planned for April 06, 2022.

If no critical issues are discovered while testing this compose it will be released on April 20, 2022.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.5.0](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.5.0%22%20-target_milestone%3A%22ovirt-4.5.0-%22)


# oVirt 4.5.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.0 First Beta release as of April 06, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for CentOS Stream 8 and Red Hat Enterprise Linux 8.6 Beta (or similar).

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

To learn about features introduced before 4.5.0, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## BETA RELEASE

In order to install this Beta Release you will need to enable pre-release repository.


> IMPORTANT
> If you are going to install on RHEL 8.6 Beta please follow [Installing on RHEL](/download/install_on_rhel.html) first.

```bash
dnf install -y centos-release-ovirt45
```

```bash
dnf install -y python3-dnf-plugins-core
dnf config-manager --set-enabled centos-ovirt45-testing
dnf config-manager --set-enabled ovirt-45-upstream-testing
```


## What's New in 4.5.0?

### Release Note

#### oVirt Engine

 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in oVirt to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.

   The upgrade is transparent to the user as long as few conditions are met:

   1. Upgrade the engine first.

   2. Before you upgrade the hosts, disable the ovirt-provider-ovn security groups for all OVN networks that are expected to work between hosts with OVN/OvS version 2.11.

   3. Upgrade the hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done with the web console, in order to reconfigure OVN and to refresh the certificates.

   4. Reboot the host after upgrade.

   5. Verify that the provider and OVN were configured successfully by launching the web console and checking the "OVN configured" field on the "General" tab for each host. (You can also obtain the value using the REST API.) Note that the value might be "No" if the host configuration has not been refreshed.

   If the host's OVN is not configured after refresh and you are using engine 4.5 or later, reinstalling the host will fix this issue.
 - [BZ 2056126](https://bugzilla.redhat.com/show_bug.cgi?id=2056126) **[RFE] Extend time to warn of upcoming certificate expiration**

   oVirt Engine 4.5 certificate expiration check will warn of upcoming certificate expiration earlier:

   1. If a certificate is going to expire in the upcoming 120 days, then WARNING event is raised in the audit log
   2. If a certificate is going to expired in the upcoming 30 days, then ALERT event is raised in the audit log

   This checks for internal oVirt certificates (for example certificate for oVirt Engine &lt;-&gt; hypervisor communication), but it doesn't check for custom certificates configured for HTTPS access to oVirt Engine as configured according to https://ovirt.org/documentation/administration_guide/index#Replacing_the_Manager_CA_Certificate
 - [BZ 2021545](https://bugzilla.redhat.com/show_bug.cgi?id=2021545) **[RFE] Add cluster-level 4.7**

   In this release we have added DataCenter/Cluster compatibility level 4.7, which is available only on hosts with RHEL 8.6+, latest CentOS Stream 8 and CentOS Stream/RHEL 9 with libvirt &gt;= 8.0.0 installed.
 - [BZ 2015093](https://bugzilla.redhat.com/show_bug.cgi?id=2015093) **[RFE] Implement hypervisors core dump related configuration to work on EL8 and EL9**

   oVirt 4.5 has moved from abrt to systemd-coredump to gather crash dumps on the hypervisors
 - [BZ 2023250](https://bugzilla.redhat.com/show_bug.cgi?id=2023250) **[RFE] Use virt:rhel module instead of virt:av in RHEL 8.6+ to get advanced virtualization packages**

   Advanced Virtualization module (virt:av) has been merged into standard RHEL virtualization module (virt:rhel) as a part of RHEL 8.6 release. Due to this change the host deploy and host upgrade flows has been updated to properly enable virt:rhel module during new installation of RHEL 8.6 host and during upgrade of existing RHEL &lt;= 8.5 to RHEL 8.6 host.
 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in oVirt with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.

#### oVirt Engine Metrics

 - [BZ 2059521](https://bugzilla.redhat.com/show_bug.cgi?id=2059521) **[RFE] Upgrade to ansible-core-2.12 in ovirt-engine-metrics**

   oVirt Engine 4.5 requires ansible-core-2.12 from RHEL 8.6 and doesn't work anymore with previous ansible-2.9.z versions.

#### oVirt Open vSwitch

 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in oVirt with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.
 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in oVirt to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.

   The upgrade is transparent to the user as long as few conditions are met:

   1. Upgrade the engine first.

   2. Before you upgrade the hosts, disable the ovirt-provider-ovn security groups for all OVN networks that are expected to work between hosts with OVN/OvS version 2.11.

   3. Upgrade the hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done with the web console, in order to reconfigure OVN and to refresh the certificates.

   4. Reboot the host after upgrade.

   5. Verify that the provider and OVN were configured successfully by launching the web console and checking the "OVN configured" field on the "General" tab for each host. (You can also obtain the value using the REST API.) Note that the value might be "No" if the host configuration has not been refreshed.

   If the host's OVN is not configured after refresh and you are using engine 4.5 or later, reinstalling the host will fix this issue.

#### oVirt Provider OVN

 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in oVirt with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.
 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in oVirt to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.

   The upgrade is transparent to the user as long as few conditions are met:

   1. Upgrade the engine first.

   2. Before you upgrade the hosts, disable the ovirt-provider-ovn security groups for all OVN networks that are expected to work between hosts with OVN/OvS version 2.11.

   3. Upgrade the hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done with the web console, in order to reconfigure OVN and to refresh the certificates.

   4. Reboot the host after upgrade.

   5. Verify that the provider and OVN were configured successfully by launching the web console and checking the "OVN configured" field on the "General" tab for each host. (You can also obtain the value using the REST API.) Note that the value might be "No" if the host configuration has not been refreshed.

   If the host's OVN is not configured after refresh and you are using engine 4.5 or later, reinstalling the host will fix this issue.

#### VDSM

 - [BZ 2021545](https://bugzilla.redhat.com/show_bug.cgi?id=2021545) **[RFE] Add cluster-level 4.7**

   In this release we have added DataCenter/Cluster compatibility level 4.7, which is available only on hosts with RHEL 8.6+, latest CentOS Stream 8 and CentOS Stream/RHEL 9 with libvirt &gt;= 8.0.0 installed.
 - [BZ 2015093](https://bugzilla.redhat.com/show_bug.cgi?id=2015093) **[RFE] Implement hypervisors core dump related configuration to work on EL8 and EL9**

   oVirt 4.5 has moved from abrt to systemd-coredump to gather crash dumps on the hypervisors
 - [BZ 2010205](https://bugzilla.redhat.com/show_bug.cgi?id=2010205) **vm_kill_paused_time value should be determined from io_timeout**

   Vdsm configuration option vars.vm_kill_paused_time was removed. The corresponding value is directly dependent on the value of recently introduced sanlock.io_timeout option and needn't be configured separately.
 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in oVirt to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.

   The upgrade is transparent to the user as long as few conditions are met:

   1. Upgrade the engine first.

   2. Before you upgrade the hosts, disable the ovirt-provider-ovn security groups for all OVN networks that are expected to work between hosts with OVN/OvS version 2.11.

   3. Upgrade the hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done with the web console, in order to reconfigure OVN and to refresh the certificates.

   4. Reboot the host after upgrade.

   5. Verify that the provider and OVN were configured successfully by launching the web console and checking the "OVN configured" field on the "General" tab for each host. (You can also obtain the value using the REST API.) Note that the value might be "No" if the host configuration has not been refreshed.

   If the host's OVN is not configured after refresh and you are using engine 4.5 or later, reinstalling the host will fix this issue.

### Enhancements

#### cockpit-ovirt

 - [BZ 2066042](https://bugzilla.redhat.com/show_bug.cgi?id=2066042) **Require ansible-core instead of ansible in cockpit-ovirt**

   Feature: Require ansible-core in cockpit-ovirt

   Reason: oVirt 4.5 is upgraded to use ansible-core

   Result: Ansible-core is used in oVirt 4.5

#### oVirt Ansible collection

 - [BZ 2040474](https://bugzilla.redhat.com/show_bug.cgi?id=2040474) **[RFE] Add progress tracking for Cluster Upgrade**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 2020620](https://bugzilla.redhat.com/show_bug.cgi?id=2020620) **Hosted engine setup fails on host with DISA STIG profile**

   Feature: Support Hosted Engine deployment on a host with DISA STIG profile

   Reason: Support DISA STIG profile in oVirt

   Result: Hosted Engine deployment works on a host with DISA STIG is profile
 - [BZ 2029830](https://bugzilla.redhat.com/show_bug.cgi?id=2029830) **[RFE] Hosted engine should accept OpenSCAP profile name instead of bool**

   Hosted Engine installation now supports selecting either DISA STIG or PCI-DSS security profiles for the Hosted Engine VM

#### oVirt Engine

 - [BZ 2040474](https://bugzilla.redhat.com/show_bug.cgi?id=2040474) **[RFE] Add progress tracking for Cluster Upgrade**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 1922977](https://bugzilla.redhat.com/show_bug.cgi?id=1922977) **[RFE] VM shared disks are not part of the OVF_STORE**

   Feature:
   Make Virtual Machines' shared disks to be part of the "OVF_STORE" configuration.

   Reason:
   Until now the VM shared disks were not part of the "OVF_STORE" configuration (only non-shared disks were part of it).
   Thus, when moving Storage Domain to another environment (Detach &amp; Attach), and after importing VMs, those shared disks' configuration was "lost along the way".

   Result:
   After the fix, the shared disks are part of the 'OVF_STORE' configuration.
   That allows VMs to share disks, move Storage Domain to another environment, and after importing VMs, the VMs correctly share the same disks without any additional manual configuration.
 - [BZ 2055666](https://bugzilla.redhat.com/show_bug.cgi?id=2055666) **[RFE] Timer for Console Disconnect Action - Shutdown VM after N minutes of being disconnected**
 - [BZ 1782077](https://bugzilla.redhat.com/show_bug.cgi?id=1782077) **[RFE] More Flexible oVirt CPU Allocation Policy with HyperThreading**

   Added a CPU pinning policy named DEDICATED that exclusively pin virtual CPUs to physical CPUs. With this policy, a complete physical core can be used as a virtual core of a single virtual machine.
 - [BZ 1987121](https://bugzilla.redhat.com/show_bug.cgi?id=1987121) **[RFE] Support enabling nVidia Unified Memory on mdev vGPU**

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "enable_uvm=1". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2054681](https://bugzilla.redhat.com/show_bug.cgi?id=2054681) **[RFE] Make VM sealing configurable**
 - [BZ 1999698](https://bugzilla.redhat.com/show_bug.cgi?id=1999698) **ssl.conf modifications of engine-setup do not conform to best practices (according to red hat insights)**

   In previous versions, engine-setup configured apache httpd's SSLProtocol configuration option to be '-all +TLSv1.2'.

   In RHEL 8, this isn't needed, because this option is managed by crypto-policies.

   With this version, engine-setup does not set this option, and removes it if it's already set, letting it be managed by crypto-policies.
 - [BZ 977778](https://bugzilla.redhat.com/show_bug.cgi?id=977778) **[RFE] - Mechanism for converting disks for non-running VMS**

   Feature: 
   Support the conversion of a disk's format and allocation policy

   Reason: Users may want to change allocation policy or format to make reduce space usage or improve performance. As well as enable incremental backup on existing raw disks.

   Result:
 - [BZ 1878930](https://bugzilla.redhat.com/show_bug.cgi?id=1878930) **[RFE] Provide warning event if MAC Address Pool free and available addresses are below threshold**

   Feature: Provide warning event if number of available MAC addresses in pool are below threshold. The threshold is configurable via engine-config. An event will be created per pool on engine start, and if the threshold is reached when consuming addresses from the pool.

   Reason: Make it easier for the admin user to plan ahead.

   Result: Admin will not be faced with an empty pool when creating VNICs on VMs.
 - [BZ 2027087](https://bugzilla.redhat.com/show_bug.cgi?id=2027087) **[RFE] Warn the user on too many hosted-engine hosts**

   We are supporting only 7 hosts with hosted engine configuration in the hosted engine cluster. There might be raised issues when there are more than 7 active hosts with hosted engine configuration, but up until now we haven't been showing any warning about it.

   From oVirt Engine 4.5 if administrators will try to install more than 7 hosts with active hosted engine configuration, there will be raised a warning in the audit log about it.

   If administrators have a strong reason to change that 7 hosts limit, they could create `/etc/ovirt-engine/engine.conf.d/99-max-he-hosts.conf` file with following content:

     MAX_RECOMMENDED_HE_HOSTS=NNN

   where `NNN` represents the maximum number of hosts with active hosted engine configuration before above warning is raised.

   Be aware that 7 is the maximum number of officially supported active hosts with hosted engine configuration, so administrators should decrease number of such hosts below 7 to eliminate issues around hosted engine .
 - [BZ 1624015](https://bugzilla.redhat.com/show_bug.cgi?id=1624015) **[RFE] Expose Console Options and Console invocation via API**

   Feature: 
   Setting the default console type (for both new and existing VMs) can be done engine widely by using CLI for setting the following engine-config parameters:
   `engine-config -s ClientModeVncDefault=NoVnc` to prefer NoVnc instead of remote-viewer
   and 
   `engine-config -s ClientModeConsoleDefault=vnc` to prefer VNC over SPICE in case the VM has both available. 


   If the actual console type for existed VMs was chosen manually via 'console options' dialog, cleaning the browser local storage is needed.
   So in case  it's required to set console type globally for
   all existing VMs, please clear the browser local storage after running the engine.


   Reason: 
   An option for setting default console type for all provisioned VMs globally at once was not supported up till now. Needed to go one VM by one and set the console type via the 'console options' dialog.

   Result: 
   Support setting console type globally for all VMs, existed and new ones, by using the engine-config parameters.
 - [BZ 2023786](https://bugzilla.redhat.com/show_bug.cgi?id=2023786) **oVirt VM with SAP monitoring configuration does not fail to start if the Host is missing vdsm-hook-vhostmd**

   Feature: When a VM is set with a custom property sap_agent=true, it requires vhostmd hooks to be installed on the host to work correctly. However, if the hooks were missing, up until now there was no warning to the user. Now, when the required hooks are not installed and reported by the host, the host is filtered out by the scheduler when starting the VM.
 - [BZ 1975720](https://bugzilla.redhat.com/show_bug.cgi?id=1975720) **[RFE] Huge VMs require an additional migration parameter**

   Support for parallel migration connections was added.

   See https://www.ovirt.org/develop/release-management/features/virt/parallel-migration-connections.html for all the important information about the feature.
 - [BZ 2011768](https://bugzilla.redhat.com/show_bug.cgi?id=2011768) **Add an option to show only direct permissions (filter inherited permissions)**

   Feature: 

   Enable to filter indirect permissions on an object 

   Reason: 

   List of inherited permissions may be large and it is not easy to get only direct permissions 

   Result: 

   Adding "ALL" and "Direct" buttons that controls the permission list
 - [BZ 1821018](https://bugzilla.redhat.com/show_bug.cgi?id=1821018) **[RFE] Use only "engine-backup --mode=restore" for restoration of every possible databases by default instead of "--provision-all-databases"**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 2024157](https://bugzilla.redhat.com/show_bug.cgi?id=2024157) **engine-setup should prevent upgrade to an engine that does not match its own version**

   engine-setup now requires the version of the setup package to be the same as the version of the engine package.
 - [BZ 1964208](https://bugzilla.redhat.com/show_bug.cgi?id=1964208) **[RFE] add new feature for VM's screenshot on RestAPI**

   Feature: Introduce capture VM screenshot API call

   Add screenshot API that captures the current screen of a VM, and then returns PPM file screenshot

   the user can then download the screenshot and view it content
 - [BZ 1998255](https://bugzilla.redhat.com/show_bug.cgi?id=1998255) **[RFE] [UI] Add search box for vNIC Profiles in oVirt Engine WebUI on the main vNIC profiles tab**

   Feature: Search box in VNIC profiles main page

   Reason: Requested by customer

   Result: It is now possible to search and filter the VNIC profiles by values of their attributes in the main VNIC profiles page.
 - [BZ 2002283](https://bugzilla.redhat.com/show_bug.cgi?id=2002283) **Make NumOfPciExpressPorts configurable via engine-config**

   It is now possible to set the number of PCI Express ports virtual machines are configured with by setting the NumOfPciExpressPorts configuration using engine-config
 - [BZ 1927985](https://bugzilla.redhat.com/show_bug.cgi?id=1927985) **[RFE] Speed up export-to-OVA on NFS by aligning loopback device offset**

   Padding between files is now added when exporting a VM to OVA. The goal is to align disks in the OVA to the edge of a block of the underlying filesystem. In this case disks are written faster during the export, especially to an NFS partition.
 - [BZ 1849169](https://bugzilla.redhat.com/show_bug.cgi?id=1849169) **[RFE] add virtualCPUs/physicalCPUs ratio property to evenly_distributed policy**

   Feature: 
   A new parameter was added to the evenly_distributed scheduling policy that takes into account the ratio between virtual and physical CPUs on the host.
   Reason: 
   To prevent the host from over utilization of all physical CPUs.
   Result: 
   When the ratio is set to 0, the evenly distributed policy works as before. If the value is greater than 0, the vCPU to physical CPU is considered as follows:
   a. when scheduling a VM, hosts with lower CPU utilization are preferred. However, if adding of the VM would cause the vCPU to physical ratio to be exceeded, the hosts vCPU to physical ratio AND cpu utilization are considered. 
   b. in a running environment, if the host's vCPU to physical ratio is above the limit, some of the VMs might be load balanced to the hosts with lower vCPU to physical CPU ratio.
 - [BZ 2003862](https://bugzilla.redhat.com/show_bug.cgi?id=2003862) **Missing default hv_stimer_direct, hv_ipi, hv_evmcs flags**

   hv_stimer_direct and hv_ipi Hyper-V flags are newly added to VMs when the cluster level is higher than 4.6.
 - [BZ 1944834](https://bugzilla.redhat.com/show_bug.cgi?id=1944834) **[RFE] Timer for Console Disconnect Action - Shutdown VM after N minutes of being disconnected (Webadmin-only)**

   The feature adds a user-specified delay to the 'Shutdown' Console Disconnect Action of a VM. The shutdown won't be immediate anymore, but will occur after the delay, unless the user reconnects to the VM console, when it will be canceled. 
   This prevents a user's session loss after an accidental disconnect.
 - [BZ 1973251](https://bugzilla.redhat.com/show_bug.cgi?id=1973251) **[RFE] Making the number of virtio-scsi multi-queue configurable**

   Feature: Make the number of virtio-scsi multi-queue configurable

   The virtio-scsi multi-queue scsi is currently boolean - either disabled or enabled, and when it's enabled the number of queues is determined automatically.

   This RFE enables the user to specify the desired number of multi-queues
 - [BZ 1616436](https://bugzilla.redhat.com/show_bug.cgi?id=1616436) **[RFE] Sparsify uploads**

   Feature: 
   Detect zero areas in uploaded images and use optimized zero write method to write the zeroes to the underlying storage. 

   Reason: 
   Not all clients support sparse files when uploading images, resulting in fully allocated images even when the disk is using thin allocation policy.

   Result:
   Images uploaded to disks with thin allocation policy remain sparse, minimizing the storage allocation. Uploading 
   images containing large zeroed areas is usually faster now.
 - [BZ 1979797](https://bugzilla.redhat.com/show_bug.cgi?id=1979797) **Ask user for confirmation when the deleted storage domain has leases of VMs that has disk in other SDs**

   Adds a new warning message in the removing storage domain window in case that the selected domain has leases for entities that raised on a different storage domain.
 - [BZ 1838089](https://bugzilla.redhat.com/show_bug.cgi?id=1838089) **[RFE] Please allow placing domain in maintenance mode with suspended VM**

   Storage domain can now be deactivated and set to maintenance even if there are suspended VMs.

   Note, a suspended VM will be able to run only when all the storage domains disks (including memory disks) are active.
 - [BZ 655153](https://bugzilla.redhat.com/show_bug.cgi?id=655153) **[RFE] confirmation prompt when suspending a virtual machine - webadmin**

   Previously, no confirmation dialog was shown for the suspend VM operation. A virtual machine was suspending right after clicking the suspend-VM button.

   Now, a confirmation dialog is presented by default when pressing the suspend-VM button. The user can choose not to show this confirmation dialog again. That setting can be reverted in the user preferences dialog.

#### oVirt Engine Data Warehouse

 - [BZ 1925878](https://bugzilla.redhat.com/show_bug.cgi?id=1925878) **[RFE] Create links from Grafana to oVirt Engine**

   With this release, a link has been added to all Grafana dashboards that allows you to quickly access the Red Hat Virtualization Administration Portal.
 - [BZ 1931939](https://bugzilla.redhat.com/show_bug.cgi?id=1931939) **[RFE] Add the engine FQDN to dwh**

   Feature: 
   add engine fqdn column to dwh

   Reason: 
   to be able to link to the admin portal when dwh is on separate machine 

   Result:
   the engine fqdn is available in dwh, in the history_configuration table.

#### oVirt Engine Metrics

 - [BZ 1990462](https://bugzilla.redhat.com/show_bug.cgi?id=1990462) **[RFE] Add user name and password to ELK integration**

   Feature: Add Elasticsearch username and password for authentication from rsyslog.

   Reason: Some deployments require username and password authentication from rsyslog.

   Result: rsyslog can authenticate to Elasticsearch using username and password.

#### oVirt Engine UI Extensions

 - [BZ 1987121](https://bugzilla.redhat.com/show_bug.cgi?id=1987121) **[RFE] Support enabling nVidia Unified Memory on mdev vGPU**

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "enable_uvm=1". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2040474](https://bugzilla.redhat.com/show_bug.cgi?id=2040474) **[RFE] Add progress tracking for Cluster Upgrade**

   If this bug requires documentation, please select an appropriate Doc Type value.

#### oVirt Host Dependencies

 - [BZ 2058177](https://bugzilla.redhat.com/show_bug.cgi?id=2058177) **[RFE] Include the package nvme-cli on virtualization hosts**

   Feature: Include the package nvme-cli on virtualization hosts

   Reason: The package is requested in RHEL 8 Managing Storage devices, Chapter 15. NVMe over fabrics using FC for accessing that hardware

   Result: the needed package is available on the host.

#### oVirt Hosted Engine HA

 - [BZ 2020620](https://bugzilla.redhat.com/show_bug.cgi?id=2020620) **Hosted engine setup fails on host with DISA STIG profile**

   Feature: Support Hosted Engine deployment on a host with DISA STIG profile

   Reason: Support DISA STIG profile in oVirt

   Result: Hosted Engine deployment works on a host with DISA STIG is profile

#### oVirt Hosted Engine Setup

 - [BZ 2052686](https://bugzilla.redhat.com/show_bug.cgi?id=2052686) **[RFE] Upgrade to ansible-core-2.12 in hosted-engine-setup**

   Feature: Use ansible-core-2.12 in hosted-engine-setup

   Reason: Upgrade to the latest ansible (ansible-core) version in oVirt

   Result: Using the latest ansible-core
 - [BZ 2029830](https://bugzilla.redhat.com/show_bug.cgi?id=2029830) **[RFE] Hosted engine should accept OpenSCAP profile name instead of bool**

   Hosted Engine installation now supports selecting either DISA STIG or PCI-DSS security profiles for the Hosted Engine VM

#### oVirt Release Host Node

 - [BZ 1986775](https://bugzilla.redhat.com/show_bug.cgi?id=1986775) **[RFE] introduce support for CentOS Stream 9 on oVirt releases**

   oVirt release package now provides YUM repositories configuration also for CentOS Stream 9.

#### VDSM

 - [BZ 1987121](https://bugzilla.redhat.com/show_bug.cgi?id=1987121) **[RFE] Support enabling nVidia Unified Memory on mdev vGPU**

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "enable_uvm=1". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2051997](https://bugzilla.redhat.com/show_bug.cgi?id=2051997) **[RFE] Default thin provisioning extension thresholds should match modern hardware**

   Feature: 
   Adapt thin provisioning defaults to match modern hardware with faster write and larger capacity. The minimum allocation size was increased from 1 GiB to 2.5G, and the minimum free space threshold was increased from 512 MiB to 2 GiB.

   Reason: 
   With modern hardware virtual machines sometimes paused temporarily when writing to thin disks on block based storage.

   Result:
   The system allocates more data earlier, minimizing virtual machines pauses.
 - [BZ 2012830](https://bugzilla.redhat.com/show_bug.cgi?id=2012830) **[RFE] Use lvmdevices instead of lvm filter on RHEL 8.6/Centos Steam 9**

   Feature: 
   Use LVM devices instead lvm filter to manage storage devices.

   Reason: 
   LVM filter is hard to manage and also in some case hard to set up in a correct way. LVM devices provides more easy way how to manage devices. Morover, starting CentOS Stream 9/RHEL 9, this will be the default used by LVM.

   Result:
   With this feature, vdsm use LVM devices file for managing storage devices and LVM filter is not needed any more.
 - [BZ 1975720](https://bugzilla.redhat.com/show_bug.cgi?id=1975720) **[RFE] Huge VMs require an additional migration parameter**

   Support for parallel migration connections was added.

   See https://www.ovirt.org/develop/release-management/features/virt/parallel-migration-connections.html for all the important information about the feature.
 - [BZ 977778](https://bugzilla.redhat.com/show_bug.cgi?id=977778) **[RFE] - Mechanism for converting disks for non-running VMS**

   Feature: 
   Support the conversion of a disk's format and allocation policy

   Reason: Users may want to change allocation policy or format to make reduce space usage or improve performance. As well as enable incremental backup on existing raw disks.

   Result:
 - [BZ 1944834](https://bugzilla.redhat.com/show_bug.cgi?id=1944834) **[RFE] Timer for Console Disconnect Action - Shutdown VM after N minutes of being disconnected (Webadmin-only)**

   The feature adds a user-specified delay to the 'Shutdown' Console Disconnect Action of a VM. The shutdown won't be immediate anymore, but will occur after the delay, unless the user reconnects to the VM console, when it will be canceled. 
   This prevents a user's session loss after an accidental disconnect.
 - [BZ 1964208](https://bugzilla.redhat.com/show_bug.cgi?id=1964208) **[RFE] add new feature for VM's screenshot on RestAPI**

   Feature: Introduce capture VM screenshot API call

   Add screenshot API that captures the current screen of a VM, and then returns PPM file screenshot

   the user can then download the screenshot and view it content
 - [BZ 1782077](https://bugzilla.redhat.com/show_bug.cgi?id=1782077) **[RFE] More Flexible oVirt CPU Allocation Policy with HyperThreading**

   Added a CPU pinning policy named DEDICATED that exclusively pin virtual CPUs to physical CPUs. With this policy, a complete physical core can be used as a virtual core of a single virtual machine.
 - [BZ 1616436](https://bugzilla.redhat.com/show_bug.cgi?id=1616436) **[RFE] Sparsify uploads**

   Feature: 
   Detect zero areas in uploaded images and use optimized zero write method to write the zeroes to the underlying storage. 

   Reason: 
   Not all clients support sparse files when uploading images, resulting in fully allocated images even when the disk is using thin allocation policy.

   Result:
   Images uploaded to disks with thin allocation policy remain sparse, minimizing the storage allocation. Uploading 
   images containing large zeroed areas is usually faster now.

#### oVirt Engine Appliance

 - [BZ 2070582](https://bugzilla.redhat.com/show_bug.cgi?id=2070582) **Include packages needed by DISA STIG**

   rng-tools, rsyslog-gnutls, usbguard packages have been added to ovirt-appliance to satisfy DISA-STIG profile requirements
 - [BZ 2000066](https://bugzilla.redhat.com/show_bug.cgi?id=2000066) **[RFE] Include a manifest in the rpm**

   A manifest of the packages included in the ova has been added to the ovirt-appliance rpm.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Release Host Node

 - [BZ 2012747](https://bugzilla.redhat.com/show_bug.cgi?id=2012747) **Add Gluster 10 repos**

   oVirt release package now enables by default GlusterFS 10 repositories. Please follow the Gluster 10 upgrade guide at https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-10/

### Removed functionality

#### oVirt Engine

 - [BZ 2028359](https://bugzilla.redhat.com/show_bug.cgi?id=2028359) **Remove "moVirt for Android" link from the welcome page of oVirt Engine**

   moVirt - Android mobile application for managing oVirt - development has been discontinued.
 - [BZ 1950730](https://bugzilla.redhat.com/show_bug.cgi?id=1950730) **Remove old Cinder integration from the REST-API**

   This patch removes the ability to create/use old cinder integration using the REST API.

### Bug Fixes

#### OTOPI

 - [BZ 1986485](https://bugzilla.redhat.com/show_bug.cgi?id=1986485) **otopi uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**

#### oVirt Ansible collection

 - [BZ 2026770](https://bugzilla.redhat.com/show_bug.cgi?id=2026770) **host deployment fails on fips-enabled host**
 - [BZ 1768969](https://bugzilla.redhat.com/show_bug.cgi?id=1768969) **Duplicate iSCSI sessions in the hosted-engine deployment host when the tpgt is not 1**

#### oVirt Engine

 - [BZ 2007384](https://bugzilla.redhat.com/show_bug.cgi?id=2007384) **Failed to parse 'writeRate' value xxxx to integer: For input string: xxxx**
 - [BZ 2041544](https://bugzilla.redhat.com/show_bug.cgi?id=2041544) **Admin GUI: Making selection of host while uploading disk it will immediately replace it with the first active host in the list.**
 - [BZ 2052557](https://bugzilla.redhat.com/show_bug.cgi?id=2052557) **oVirt fails to release mdev vGPU device after VM shutdown**
 - [BZ 2051462](https://bugzilla.redhat.com/show_bug.cgi?id=2051462) **Unable to correctly search for User field in Advanced view of Events pane**
 - [BZ 1994144](https://bugzilla.redhat.com/show_bug.cgi?id=1994144) **[oVirt 4.4.6] Mail recipient is not updated while configuring Event Notifications**
 - [BZ 2010903](https://bugzilla.redhat.com/show_bug.cgi?id=2010903) **I/O operations/sec reporting wrong values**
 - [BZ 1982083](https://bugzilla.redhat.com/show_bug.cgi?id=1982083) **[Cinderlib][MBS] Cloning VM with managed block storage raise a NPE**
 - [BZ 1944290](https://bugzilla.redhat.com/show_bug.cgi?id=1944290) **URL to change the password is not shown properly**
 - [BZ 1648985](https://bugzilla.redhat.com/show_bug.cgi?id=1648985) **VM from VM-pool which is already in use by a SuperUser is presented to another User with UserRole permission who can shutdown the VM.**
 - [BZ 1999028](https://bugzilla.redhat.com/show_bug.cgi?id=1999028) **TPM device can't be marked in added status when VM is running**
 - [BZ 2000031](https://bugzilla.redhat.com/show_bug.cgi?id=2000031) **SPM host is rebooted multiple times when engine recovers the host**
 - [BZ 1931812](https://bugzilla.redhat.com/show_bug.cgi?id=1931812) **VMs in a pool are created with different memory values than those provided in the update-pool request**
 - [BZ 1986726](https://bugzilla.redhat.com/show_bug.cgi?id=1986726) **VM imported from OVA gets thin provisioned disk despite of allocation policy set as 'preallocated'**
 - [BZ 2006745](https://bugzilla.redhat.com/show_bug.cgi?id=2006745) **[MBS] Template disk Copy from data storage domain to Managed Block Storage domain is failing**
 - [BZ 2023313](https://bugzilla.redhat.com/show_bug.cgi?id=2023313) **VM with a PCI host device and max vCPUs &gt;= 256 fails to start**
 - [BZ 1956107](https://bugzilla.redhat.com/show_bug.cgi?id=1956107) **Reject RHEL &lt; 6.9 on PPC**
 - [BZ 1687845](https://bugzilla.redhat.com/show_bug.cgi?id=1687845) **Multiple notification for one time host activation**
 - [BZ 2003996](https://bugzilla.redhat.com/show_bug.cgi?id=2003996) **ovirt_snapshot module fails to delete snapshot when there is a "Next Run configuration snapshot"**
 - [BZ 1959186](https://bugzilla.redhat.com/show_bug.cgi?id=1959186) **Enable assignment of user quota when provisioning from a non-blank template via rest-api**
 - [BZ 1971622](https://bugzilla.redhat.com/show_bug.cgi?id=1971622) **Incorrect warning displayed: "The VM CPU does not match the Cluster CPU Type"**
 - [BZ 1979441](https://bugzilla.redhat.com/show_bug.cgi?id=1979441) **High Performance VMs always have "VM CPU does not match the cluster CPU Type" warning**
 - [BZ 1959141](https://bugzilla.redhat.com/show_bug.cgi?id=1959141) **Export to data domain of a VM that isn't running creates a snapshot that isn't removed**
 - [BZ 1988496](https://bugzilla.redhat.com/show_bug.cgi?id=1988496) **vmconsole-proxy-helper.cer is not renewed when running engine-setup**

#### oVirt Engine Data Warehouse

 - [BZ 2010903](https://bugzilla.redhat.com/show_bug.cgi?id=2010903) **I/O operations/sec reporting wrong values**

#### oVirt Engine UI Extensions

 - [BZ 2024202](https://bugzilla.redhat.com/show_bug.cgi?id=2024202) **oVirt Dashboard does not show memory and storage details properly when using Spanish language.**

#### oVirt Hosted Engine HA

 - [BZ 1986732](https://bugzilla.redhat.com/show_bug.cgi?id=1986732) **ovirt-ha services cannot set the LocalMaintenance mode in the storage metadata and are in a restart loop**
 - [BZ 2024161](https://bugzilla.redhat.com/show_bug.cgi?id=2024161) **Penalizing score by 1000 due to cpu load is not canceled after load decreasing to 0**

#### oVirt Hosted Engine Setup

 - [BZ 2026770](https://bugzilla.redhat.com/show_bug.cgi?id=2026770) **host deployment fails on fips-enabled host**
 - [BZ 1768969](https://bugzilla.redhat.com/show_bug.cgi?id=1768969) **Duplicate iSCSI sessions in the hosted-engine deployment host when the tpgt is not 1**

#### oVirt Setup Lib

 - [BZ 1971863](https://bugzilla.redhat.com/show_bug.cgi?id=1971863) **Queries of type 'ANY' are deprecated - RFC8482**

#### VDSM

 - [BZ 2028481](https://bugzilla.redhat.com/show_bug.cgi?id=2028481) **SCSI reservation is not working for hot plugged VM disks**
 - [BZ 2010478](https://bugzilla.redhat.com/show_bug.cgi?id=2010478) **After storage error HA VMs failed to auto resume.**
 - [BZ 1787192](https://bugzilla.redhat.com/show_bug.cgi?id=1787192) **Host fails to activate in oVirt and goes to non-operational status when some of the iSCSI targets are down**
 - [BZ 1926589](https://bugzilla.redhat.com/show_bug.cgi?id=1926589) **"Too many open files" in vdsm.log after 380 migrations**

### Other

#### imgbased

 - [BZ 2055829](https://bugzilla.redhat.com/show_bug.cgi?id=2055829) **[RFE] /var/tmp should be on its own partition**

#### MOM

 - [BZ 2001759](https://bugzilla.redhat.com/show_bug.cgi?id=2001759) **mom requires python-nose**

#### OTOPI

 - [BZ 2060006](https://bugzilla.redhat.com/show_bug.cgi?id=2060006) **dnf packager on AlmaLinux**
 - [BZ 1916144](https://bugzilla.redhat.com/show_bug.cgi?id=1916144) **[RFE] Check otopi's dnf package with signatures during CI automation/check-patch.sh**

#### oVirt Ansible collection

 - [BZ 2022620](https://bugzilla.redhat.com/show_bug.cgi?id=2022620) **[RFE] adapt the current hosted_engine_setup role to work within ansible-core 2.12**

#### oVirt Engine

 - [BZ 1989121](https://bugzilla.redhat.com/show_bug.cgi?id=1989121) **[CBT][Veeam] Block backup of hosted-engine vm**
 - [BZ 2069670](https://bugzilla.redhat.com/show_bug.cgi?id=2069670) **NPE when converting ISCSI disk during the copy_data action**
 - [BZ 2070536](https://bugzilla.redhat.com/show_bug.cgi?id=2070536) **The same host CPUs are assigned twice when we run dedicated&amp;none&amp;resize VMs on the same host**
 - [BZ 2070184](https://bugzilla.redhat.com/show_bug.cgi?id=2070184) **Hybrid Backup - Specifying disks for backup doesn't work, backup is created for all disks**
 - [BZ 2068104](https://bugzilla.redhat.com/show_bug.cgi?id=2068104) **hybrid backup VM after a snapshot fails - start_nbd_server error=Bitmap does not exist**
 - [BZ 1979277](https://bugzilla.redhat.com/show_bug.cgi?id=1979277) **[RFE] Migration - Apply automatic CPU and NUMA pinning based on the migrated host**
 - [BZ 2065152](https://bugzilla.redhat.com/show_bug.cgi?id=2065152) **Implicit CPU pinning for NUMA VMs destroyed because of invalid CPU policy**
 - [BZ 2043984](https://bugzilla.redhat.com/show_bug.cgi?id=2043984) **Cannot move any host to maintenance mode**
 - [BZ 2037779](https://bugzilla.redhat.com/show_bug.cgi?id=2037779) **VM name is displayed as &lt;UNKNOWN&gt; in disk properties update notification**
 - [BZ 1991482](https://bugzilla.redhat.com/show_bug.cgi?id=1991482) **[RFE] add a link to Grafana in the Admin portal UI**
 - [BZ 1913389](https://bugzilla.redhat.com/show_bug.cgi?id=1913389) **[CBT] [RFE] Provide VDSM with more information on scratch disks**
 - [BZ 1988959](https://bugzilla.redhat.com/show_bug.cgi?id=1988959) **[Cinderlib] - The attached disk isn't attached to the cloned VM from template**
 - [BZ 2001904](https://bugzilla.redhat.com/show_bug.cgi?id=2001904) **[RFE] Admin portal: add ability to choose a tab item by arrow keys**
 - [BZ 1846340](https://bugzilla.redhat.com/show_bug.cgi?id=1846340) **Extra white space and over-stretched components in WebAdmin dialogues - create VM dialog**
 - [BZ 1661875](https://bugzilla.redhat.com/show_bug.cgi?id=1661875) **[UI] - UI exception when trying to import an external network while exists on all DCs in the system**
 - [BZ 2014035](https://bugzilla.redhat.com/show_bug.cgi?id=2014035) **engine-backup failed  in case of  "/tmp"  doesn't have enough space , no warning  is provided to the user regarding out-of-space**
 - [BZ 2043124](https://bugzilla.redhat.com/show_bug.cgi?id=2043124) **Import a template that has multiple copied fails after it's removed from the system**
 - [BZ 2034531](https://bugzilla.redhat.com/show_bug.cgi?id=2034531) **Cloning a VM from a QCOW based template on a block-based storage domain, results with a VM that has a disk with the same actual and virtual size**
 - [BZ 2043283](https://bugzilla.redhat.com/show_bug.cgi?id=2043283) **Use the transfer id as the nbd server id**
 - [BZ 1912967](https://bugzilla.redhat.com/show_bug.cgi?id=1912967) **Unexpected Threads per core on guest for VM when setting NUMA pinning**
 - [BZ 2040361](https://bugzilla.redhat.com/show_bug.cgi?id=2040361) **Hotplug VirtIO-SCSI disk fails with error "Domain already contains a disk with that address" when IO threads &gt; 1**

   Previously, when hot plugging multiple disks with VIRTIO SCSI interface to virtual machine that are defined with more than one IO thread, this would have failed due to allocation of a duplicate PCI address.

   Now, each disk is assigned with a unique PCI address in this process, which enabled to plug multiple disks with VIRTIO SCSI to virtual machines also when they are set with more than one IO thread.
 - [BZ 2021217](https://bugzilla.redhat.com/show_bug.cgi?id=2021217) **[RFE] Windows 2022 support**

   Add Windows 2022 as a guest operating system
 - [BZ 2024529](https://bugzilla.redhat.com/show_bug.cgi?id=2024529) **Creating a template from a VM with TPM in the REST API without specifying the TPM property results in a template without TPM**
 - [BZ 1998866](https://bugzilla.redhat.com/show_bug.cgi?id=1998866) **[RFE] Windows 11 support**
 - [BZ 2033185](https://bugzilla.redhat.com/show_bug.cgi?id=2033185) **[RFE] Add e1000e driver on cluster level &gt;=4.7**

   Add e1000e VM Nic type for cluster level 4.7. The e1000 is depracated from RHEL8.0 and users should switch to e1000e when possible.
 - [BZ 1936430](https://bugzilla.redhat.com/show_bug.cgi?id=1936430) **Auto_pinning Next Run configuration changes are cancelled after VM re-start.**
 - [BZ 1929260](https://bugzilla.redhat.com/show_bug.cgi?id=1929260) **Fails validation of action 'UpdateVm' when changing VM (set with auto pinning policy) type to High Performance**
 - [BZ 2038887](https://bugzilla.redhat.com/show_bug.cgi?id=2038887) **Make Chipset/Firmware Type setting more visible**
 - [BZ 1944637](https://bugzilla.redhat.com/show_bug.cgi?id=1944637) **Power off and removing VM during reboot with VM next run configuration causes error**
 - [BZ 1979041](https://bugzilla.redhat.com/show_bug.cgi?id=1979041) **[RFE] Apply automatic CPU and NUMA pinning based on the scheduled host**
 - [BZ 2024086](https://bugzilla.redhat.com/show_bug.cgi?id=2024086) **[RFE] Add a host to affinity group by its name**
 - [BZ 1848579](https://bugzilla.redhat.com/show_bug.cgi?id=1848579) **[RFE] Show total huge pages**
 - [BZ 1997893](https://bugzilla.redhat.com/show_bug.cgi?id=1997893) **[RFE] Prefer UEFI for new VMs**
 - [BZ 2027410](https://bugzilla.redhat.com/show_bug.cgi?id=2027410) **Clarify that cold-reboot is required when failing to "steal" a console**
 - [BZ 1862893](https://bugzilla.redhat.com/show_bug.cgi?id=1862893) **oVirt shows ip info even if guest's ip doesn't exist**
 - [BZ 1964241](https://bugzilla.redhat.com/show_bug.cgi?id=1964241) **[RFE][CBT][Veeam]Allow providing the created backup ID when starting a VM backup**
 - [BZ 1952502](https://bugzilla.redhat.com/show_bug.cgi?id=1952502) **Inconsistent validation of pool creation by Rest API**
 - [BZ 1887174](https://bugzilla.redhat.com/show_bug.cgi?id=1887174) **Host deactivation failure after "Migration not in progress, code = 47" error**
 - [BZ 1952321](https://bugzilla.redhat.com/show_bug.cgi?id=1952321) **There is failed cloning message when cloning VM with shareable direct lun attached**
 - [BZ 2019869](https://bugzilla.redhat.com/show_bug.cgi?id=2019869) **Local disk is not bootable when the VM is imported from OVA**
 - [BZ 1940494](https://bugzilla.redhat.com/show_bug.cgi?id=1940494) **provide better information for windows guest-agent mark**
 - [BZ 1950321](https://bugzilla.redhat.com/show_bug.cgi?id=1950321) **SSH public key Ok button is not enabled automatically**
 - [BZ 1679935](https://bugzilla.redhat.com/show_bug.cgi?id=1679935) **Administration Configure user role does not shows scrollbar**
 - [BZ 1913764](https://bugzilla.redhat.com/show_bug.cgi?id=1913764) **GlusterFS - Failing to assign new Master SD within the same storage type leads to infinite (or long) reconstruction**
 - [BZ 1913843](https://bugzilla.redhat.com/show_bug.cgi?id=1913843) **Disable NUMA Tuning for non-pinned vNUMA nodes**
 - [BZ 1683098](https://bugzilla.redhat.com/show_bug.cgi?id=1683098) **ovirt-provider-ovn service is not stopped/disabled by engine-cleanup**
 - [BZ 2001565](https://bugzilla.redhat.com/show_bug.cgi?id=2001565) **VM OVA import fails if loop device doesn't exist in the host during the import**
 - [BZ 1991804](https://bugzilla.redhat.com/show_bug.cgi?id=1991804) **Engine using old 2400 maximum score on HA scheduling weight policy**
 - [BZ 1847514](https://bugzilla.redhat.com/show_bug.cgi?id=1847514) **Can't create a VM with memory higher than the max-allowed (hard validation)**
 - [BZ 1956295](https://bugzilla.redhat.com/show_bug.cgi?id=1956295) **Template import from storage domain fails when quota is enabled.**
 - [BZ 1868249](https://bugzilla.redhat.com/show_bug.cgi?id=1868249) **The OVF disk size on file storage reported by engine does not match the actual size of the OVF**
 - [BZ 1959385](https://bugzilla.redhat.com/show_bug.cgi?id=1959385) **[Cinderlib] Not possible to set MBS domain on maintenance even though all its disks have been deleted.**

#### oVirt Engine UI Extensions

 - [BZ 1979052](https://bugzilla.redhat.com/show_bug.cgi?id=1979052) **Move and rename the 'Export' button**
 - [BZ 1991482](https://bugzilla.redhat.com/show_bug.cgi?id=1991482) **[RFE] add a link to Grafana in the Admin portal UI**
 - [BZ 1992568](https://bugzilla.redhat.com/show_bug.cgi?id=1992568) **Dashboard - pop-up messages are not localized**
 - [BZ 1771925](https://bugzilla.redhat.com/show_bug.cgi?id=1771925) **Improve error handling when calling REST API**
 - [BZ 1980331](https://bugzilla.redhat.com/show_bug.cgi?id=1980331) **manage vGPU dialog: maximum value of available mdev instances to attach is incorrect.**

#### oVirt Host Dependencies

 - [BZ 2001537](https://bugzilla.redhat.com/show_bug.cgi?id=2001537) **mailx -&gt; s-nail replacement in CentOS Stream 9**

#### oVirt Hosted Engine Setup

 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**
 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**

#### oVirt Provider OVN

 - [BZ 2012850](https://bugzilla.redhat.com/show_bug.cgi?id=2012850) **Cannot add router port with IPv6**

#### oVirt Setup Lib

 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**
 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**

#### VDSM

 - [BZ 2066285](https://bugzilla.redhat.com/show_bug.cgi?id=2066285) **Copying from an Image domain to a Managed Block Storage domain fails**
 - [BZ 1881832](https://bugzilla.redhat.com/show_bug.cgi?id=1881832) **[CinderLib] - remove managed block disks from storage domain which have a VM snapshot fails - EVENT_ID: USER_FINISHED_FAILED_REMOVE_DISK(2,015)**
 - [BZ 1755801](https://bugzilla.redhat.com/show_bug.cgi?id=1755801) **[Cinderlib] Managed Block Storage: Live Migration Problems with ceph**
 - [BZ 1913389](https://bugzilla.redhat.com/show_bug.cgi?id=1913389) **[CBT] [RFE] Provide VDSM with more information on scratch disks**
 - [BZ 2033697](https://bugzilla.redhat.com/show_bug.cgi?id=2033697) **Secret information may be leaked in Vdsm logs**
 - [BZ 1536880](https://bugzilla.redhat.com/show_bug.cgi?id=1536880) **Include text from lvm command stdout and stderr in all lvm related exceptions**
 - [BZ 2026263](https://bugzilla.redhat.com/show_bug.cgi?id=2026263) **getStats should report if the data is real or initial**
 - [BZ 1919857](https://bugzilla.redhat.com/show_bug.cgi?id=1919857) **Consume disk logical names from Libvirt (RHEL 8.5)**
 - [BZ 2025527](https://bugzilla.redhat.com/show_bug.cgi?id=2025527) **Refreshing LVs fail:  "locking_type (4) is deprecated, using --sysinit --readonly.\', \'  Operation prohibited while --readonly is set.\', "  Can\'t get lock for ...."**
 - [BZ 1949475](https://bugzilla.redhat.com/show_bug.cgi?id=1949475) **If pivot failed during live merge, top volume is left illegal, requires manual fix if vm is stopped**
 - [BZ 2018947](https://bugzilla.redhat.com/show_bug.cgi?id=2018947) **vm: do not ignore errors when syncing volume chain**
 - [BZ 1913764](https://bugzilla.redhat.com/show_bug.cgi?id=1913764) **GlusterFS - Failing to assign new Master SD within the same storage type leads to infinite (or long) reconstruction**

### No Doc Update

#### MOM

 - [BZ 2001789](https://bugzilla.redhat.com/show_bug.cgi?id=2001789) **mom uses deprecated API SafeConfigParser**

#### OTOPI

 - [BZ 2047260](https://bugzilla.redhat.com/show_bug.cgi?id=2047260) **DNF on otopi is logging UNKNOWN for packages on some actions**

#### oVirt Ansible collection

 - [BZ 1932147](https://bugzilla.redhat.com/show_bug.cgi?id=1932147) **[RFE] Support specifying storage domain format (V3, V4, V5...) in ansible ovirt_storage_domain module**

#### oVirt Engine

 - [BZ 2070053](https://bugzilla.redhat.com/show_bug.cgi?id=2070053) **Removal of a labeled long network(more than 15 characters)  is incomplete**
 - [BZ 2032917](https://bugzilla.redhat.com/show_bug.cgi?id=2032917) **Restapi: after migrating Jackson to com.fasterxml.jackson, REST API's JSON default serializing mode is not ignoring properties with null values anymore**
 - [BZ 1700460](https://bugzilla.redhat.com/show_bug.cgi?id=1700460) **Let the user eventually skip HE global maintenance mode check on upgrades**
 - [BZ 2061904](https://bugzilla.redhat.com/show_bug.cgi?id=2061904) **Unable to attach a oVirt Host back into cluster after removing due to networking**
 - [BZ 2056052](https://bugzilla.redhat.com/show_bug.cgi?id=2056052) **oVirt Node w/ PCI-DSS profile causes OVA export to fail**
 - [BZ 1765339](https://bugzilla.redhat.com/show_bug.cgi?id=1765339) **Kdump Status in Hosts' section is wrong (Disabled)**
 - [BZ 1993016](https://bugzilla.redhat.com/show_bug.cgi?id=1993016) **Make network with 0.0.0.0 gateway in sync**
 - [BZ 2052503](https://bugzilla.redhat.com/show_bug.cgi?id=2052503) **DWH admin portal dashboard queries use 4_4 views**
 - [BZ 2031027](https://bugzilla.redhat.com/show_bug.cgi?id=2031027) **The /usr/share/ovirt-engine/ansible-runner-service-project/inventory/hosts fails rpm verification**
 - [BZ 1990446](https://bugzilla.redhat.com/show_bug.cgi?id=1990446) **Concurrent deploy of 2 host fails during certificate creation**
 - [BZ 1980192](https://bugzilla.redhat.com/show_bug.cgi?id=1980192) **Network statistics copy a U64 into DECIMAL(18,4)**
 - [BZ 2026473](https://bugzilla.redhat.com/show_bug.cgi?id=2026473) **Cannot upgrade the Engine database schema due to wrong ownership of some database entities**
 - [BZ 1900597](https://bugzilla.redhat.com/show_bug.cgi?id=1900597) **[RFE] Add 'include_template' flag to disk snapshots listing**
 - [BZ 2006602](https://bugzilla.redhat.com/show_bug.cgi?id=2006602) **vm_statistics table has wrong type for guest_mem_* columns.**
 - [BZ 2008798](https://bugzilla.redhat.com/show_bug.cgi?id=2008798) **Older name rhv-openvswitch is not checked in ansible playbook**
 - [BZ 1986731](https://bugzilla.redhat.com/show_bug.cgi?id=1986731) **ovirt-engine uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**
 - [BZ 1907798](https://bugzilla.redhat.com/show_bug.cgi?id=1907798) **migrate org.codehaus.jackson to newer com.fasterxml.jackson**
 - [BZ 1996123](https://bugzilla.redhat.com/show_bug.cgi?id=1996123) **ovf stores capacity/truesize on the storage does not match values in engine database**

#### oVirt Engine Data Warehouse

 - [BZ 2041220](https://bugzilla.redhat.com/show_bug.cgi?id=2041220) **Update queries to use v4_5 views in all dashboards**
 - [BZ 2026358](https://bugzilla.redhat.com/show_bug.cgi?id=2026358) **ovirt_engine_history_grafana user is not granted permissions to query new tables**
 - [BZ 2030663](https://bugzilla.redhat.com/show_bug.cgi?id=2030663) **Update Network statistics types in DWH**

#### oVirt Engine Metrics

 - [BZ 1804268](https://bugzilla.redhat.com/show_bug.cgi?id=1804268) **ovirt-engine-metrics role fails on ansible-linter**
 - [BZ 2012569](https://bugzilla.redhat.com/show_bug.cgi?id=2012569) **Update the LSR version**
 - [BZ 2025936](https://bugzilla.redhat.com/show_bug.cgi?id=2025936) **metrics configuration playbooks failing due to rhel-system-role last refactor**

#### oVirt Hosted Engine HA

 - [BZ 2003155](https://bugzilla.redhat.com/show_bug.cgi?id=2003155) **ovirt-hosted-engine-ha uses python-mock**
 - [BZ 2003157](https://bugzilla.redhat.com/show_bug.cgi?id=2003157) **ovirt-hosted-engine-ha uses python-nose**

#### ovirt-imageio

 - [BZ 2066113](https://bugzilla.redhat.com/show_bug.cgi?id=2066113) **When downloading 4 disks concurrently using SDK, it sometimes fails with: 'Resource temporarily unavailable'**

#### oVirt Log Collector

 - [BZ 2000121](https://bugzilla.redhat.com/show_bug.cgi?id=2000121) **docs/comments/etc misguide about postgresql credentials defaults**
 - [BZ 1986728](https://bugzilla.redhat.com/show_bug.cgi?id=1986728) **ovirt-log-collector uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**

#### oVirt Release Host Node

 - [BZ 2010049](https://bugzilla.redhat.com/show_bug.cgi?id=2010049) **ovirt-release-master installs non-existing repos**

#### oVirt Engine SDK 4 Python

 - [BZ 1900597](https://bugzilla.redhat.com/show_bug.cgi?id=1900597) **[RFE] Add 'include_template' flag to disk snapshots listing**

#### VDSM

 - [BZ 2054745](https://bugzilla.redhat.com/show_bug.cgi?id=2054745) **Setting SD to maintenance fails and turns the SD to inactive mode as a result**
 - [BZ 2004412](https://bugzilla.redhat.com/show_bug.cgi?id=2004412) **Minimize skipped checks in vdsm flake8 configuration**
 - [BZ 2026370](https://bugzilla.redhat.com/show_bug.cgi?id=2026370) **oVirt node fail to boot if lvm filter uses /dev/disk/by-id/lvm-pv-uuid-***
 - [BZ 2014865](https://bugzilla.redhat.com/show_bug.cgi?id=2014865) **Errors hidden in %posttrans scriptlet**
 - [BZ 2005213](https://bugzilla.redhat.com/show_bug.cgi?id=2005213) **c9s - setupNetworks fails**

#### VDSM JSON-RPC Java

 - [BZ 2013209](https://bugzilla.redhat.com/show_bug.cgi?id=2013209) **vdsm-jsonrpc-java requires slf4j-log4j12 and log4j12 which have been removed in el9**

#### oVirt Node NG Image

 - [BZ 2056596](https://bugzilla.redhat.com/show_bug.cgi?id=2056596) **CVE-2021-4083 kernel: fget: check that the fd still exists after getting a ref to it [ovirt-4.5]**
 - [BZ 2061694](https://bugzilla.redhat.com/show_bug.cgi?id=2061694) **CVE-2022-0847 - kernel: improper initialization of the "flags" member of the new pipe_buffer [ovirt-4.5]**
 - [BZ 2005045](https://bugzilla.redhat.com/show_bug.cgi?id=2005045) **ovirt-node-ng iso build relies on genisoimage**

#### oVirt Engine Appliance

 - [BZ 2067982](https://bugzilla.redhat.com/show_bug.cgi?id=2067982) **CVE-2022-24302 python-paramiko: Race condition in the write_private_key_file function [ovirt-4.5]**
 - [BZ 2050071](https://bugzilla.redhat.com/show_bug.cgi?id=2050071) **Use authselect in oVirt Node and appliance images**

#### Contributors

65 people contributed to this release:

	Aleš Musil (Contributed to: ovirt-appliance, ovirt-engine, ovirt-host, ovirt-openvswitch, ovirt-provider-ovn, ovirt-release, vdsm)
	Andrej Krejcir (Contributed to: mom)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-keycloak, ovirt-engine-wildfly, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: cockpit-ovirt, ovirt-ansible-collection, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-setup-lib)
	Avital Pinnick (Contributed to: ovirt-site)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine, ovirt-engine-metrics)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-release)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-host, ovirt-release, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Denis Volkov (Contributed to: ovirt-engine-keycloak)
	Dominik Holler (Contributed to: ovirt-openvswitch, ovirt-release)
	Donna DaCosta (Contributed to: ovirt-site)
	Dusan Fodor (Contributed to: ovirt-openvswitch)
	Edward Haas (Contributed to: ovirt-release)
	Ehud Yonasi (Contributed to: ovirt-appliance)
	Eitan Raviv (Contributed to: ovirt-engine, ovirt-provider-ovn)
	Eli Marcus (Contributed to: ovirt-site)
	Eli Mesika (Contributed to: ovirt-dwh, ovirt-engine)
	Evgheni Dereveanchin (Contributed to: ovirt-engine, ovirt-release)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Filip Januska (Contributed to: ovirt-engine, python-ovirt-engine-sdk4, vdsm)
	Gal Zaidman (Contributed to: ovirt-release)
	Harel Braha (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, vdsm)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Jake Reynolds (Contributed to: ovirt-hosted-engine-ha)
	Janos Bonic (Contributed to: ovirt-release)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-engine, ovirt-log-collector, ovirt-node-ng-image, ovirt-release, vdsm)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Loïc Albertin (Contributed to: ovirt-node-ng)
	Lucia Jelinkova (Contributed to: ovirt-engine, ovirt-engine-ui-extensions)
	Marcin Sobczyk (Contributed to: ovirt-release, vdsm)
	Mark Kemel (Contributed to: ovirt-engine, ovirt-engine-ui-extensions, python-ovirt-engine-sdk4, vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-release, python-ovirt-engine-sdk4)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-keycloak, ovirt-engine-metrics, ovirt-engine-wildfly, ovirt-imageio, ovirt-jboss-modules-maven-plugin, ovirt-release, python-ovirt-engine-sdk4, vdsm, vdsm-jsonrpc-java)
	Martin Tzvetanov Grigorov (Contributed to: ovirt-engine)
	Michal Skrivanek (Contributed to: imgbased, ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-engine-metrics, ovirt-engine-ui-extensions, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-web-ui)
	Miguel Duarte Barroso (Contributed to: ovirt-release)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nick Sonneveld (Contributed to: ovirt-ansible-collection)
	Nijin Ashok (Contributed to: ovirt-ansible-collection, ovirt-log-collector)
	Nir Levy (Contributed to: ovirt-node-ng-image)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-imageio, ovirt-release, ovirt-site, python-ovirt-engine-sdk4, vdsm)
	Oli (Contributed to: ovirt-ansible-collection)
	Ondra Machacek (Contributed to: ovirt-release)
	Ori Liel (Contributed to: ovirt-engine)
	Pavel Bar (Contributed to: ovirt-engine, vdsm)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Ravi (Contributed to: vdsm)
	Roman Bednar (Contributed to: vdsm)
	Saif Abu Saleh (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-web-ui, vdsm)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, engine-db-query, imgbased, mom, otopi, ovirt-appliance, ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-metrics, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-engine-wildfly, ovirt-host, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-imageio, ovirt-jboss-modules-maven-plugin, ovirt-log-collector, ovirt-node-ng, ovirt-node-ng-image, ovirt-provider-ovn, ovirt-release, ovirt-setup-lib, ovirt-site, ovirt-web-ui, python-ovirt-engine-sdk4, vdsm, vdsm-jsonrpc-java)
	Sanja Bonic (Contributed to: ovirt-node-ng-image, ovirt-release, ovirt-site)
	Scott J Dickerson (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine, vdsm)
	Sharon Gratch (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Simone Tiraboschi (Contributed to: ovirt-ansible-collection)
	Tomáš Golembiovský (Contributed to: mom, ovirt-ansible-collection, ovirt-release, vdsm)
	Vojtěch Juránek (Contributed to: ovirt-imageio, vdsm)
	Yedidyah Bar David (Contributed to: cockpit-ovirt, imgbased, otopi, ovirt-ansible-collection, ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-node-ng, ovirt-node-ng-image, ovirt-release, ovirt-setup-lib, ovirt-site)
	Yuval Turgeman (Contributed to: ovirt-release)
	drokath (Contributed to: ovirt-ansible-collection)
