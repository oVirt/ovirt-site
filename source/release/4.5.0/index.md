---
title: oVirt 4.5.0 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.0 release as of April 20, 2022.

On April 26th, 2022 the oVirt Project released an [oVirt Node 4.5.0.1 Async update](https://blogs.ovirt.org/2022/04/ovirt-node-4-5-0-1-async-update/)

On May 13th, 2022 the oVirt Project released an [oVirt Node 4.5.0.2 Async update](https://blogs.ovirt.org/2022/05/ovirt-node-4-5-0-2-async-update/)

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

To learn about features introduced before 4.5.0, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL 8.6 or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.



## What's New in 4.5.0?

### Release Note

#### oVirt dependencies

 - [BZ 2077794](https://bugzilla.redhat.com/show_bug.cgi?id=2077794) **Upgrading postgresql-jdbc package to 42.2.14-1 breaks ovirt-engine functionality**

   oVirt Engine now requires postgresql-jdbc &gt;= 42.2.14 and spring-framework &gt;= 5.3.19

#### oVirt Engine

 - [BZ 2077794](https://bugzilla.redhat.com/show_bug.cgi?id=2077794) **Upgrading postgresql-jdbc package to 42.2.14-1 breaks ovirt-engine functionality**

   oVirt Engine now requires postgresql-jdbc &gt;= 42.2.14 and spring-framework &gt;= 5.3.19
 - [BZ 2077387](https://bugzilla.redhat.com/show_bug.cgi?id=2077387) **Update to 4.5 failed due to failed database schema refresh**

   If vdc_options table contains records with NULL default value (most probably as a remains from ancient versions), the upgrade to ovirt-engine-4.5.0 fails. This bug fixes the issue, so upgrade to ovirt-engine-4.5.0 is successfull.
 - [BZ 2071468](https://bugzilla.redhat.com/show_bug.cgi?id=2071468) **Engine fenced host that was already reconnected and set to Up status.**

   If SSH soft fencing needs to be executed on a problematic host, oVirt Engine now waits expected time interval before it continues with fencing, so VDSM has enough time to start and respond to oVirt Engine.
 - [BZ 2052690](https://bugzilla.redhat.com/show_bug.cgi?id=2052690) **[RFE] Upgrade to ansible-core-2.12 in ovirt-engine**

   oVirt Engine 4.5 requires ansible-core-2.12 from RHEL 8.6 and doesn't work anymore with previous ansible-2.9.z versions
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

   This checks for internal oVirt certificates (for example certificate for oVirt Engine &lt;-&gt; hypervisor communication), but it doesn't check for custom certificates configured for HTTPS access to oVirt Engine as configured according to [https://ovirt.org/documentation/administration_guide/index#Replacing_the_Manager_CA_Certificate](https://ovirt.org/documentation/administration_guide/index#Replacing_the_Manager_CA_Certificate)
 - [BZ 2015093](https://bugzilla.redhat.com/show_bug.cgi?id=2015093) **[RFE] Implement hypervisors core dump related configuration to work on EL8 and EL9**

   oVirt 4.5 has moved from abrt to systemd-coredump to gather crash dumps on the hypervisors
 - [BZ 2023250](https://bugzilla.redhat.com/show_bug.cgi?id=2023250) **[RFE] Use virt:rhel module instead of virt:av in RHEL 8.6+ to get advanced virtualization packages**

   Advanced Virtualization module (virt:av) has been merged into standard RHEL virtualization module (virt:rhel) as a part of RHEL 8.6 release. Due to this change the host deploy and host upgrade flows has been updated to properly enable virt:rhel module during new installation of RHEL 8.6 host and during upgrade of existing RHEL &lt;= 8.5 to RHEL 8.6 host.
 - [BZ 2015802](https://bugzilla.redhat.com/show_bug.cgi?id=2015802) **[RFE] oVirt hypervisors should support running on host with DISA STIG security profile applied**

   oVirt Hypervisor 4.5, with exception to oVirt Node, is able to run on a host with RHEL 8.6 DISA STIG openscap profile applied.
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

 - [BZ 2015093](https://bugzilla.redhat.com/show_bug.cgi?id=2015093) **[RFE] Implement hypervisors core dump related configuration to work on EL8 and EL9**

   oVirt 4.5 has moved from abrt to systemd-coredump to gather crash dumps on the hypervisors
 - [BZ 2010205](https://bugzilla.redhat.com/show_bug.cgi?id=2010205) **vm_kill_paused_time value should be determined from io_timeout**

   Vdsm configuration option vars.vm_kill_paused_time was removed. The corresponding value is directly dependent on the value of recently introduced sanlock.io_timeout option and needn't be configured separately.
 - [BZ 2015802](https://bugzilla.redhat.com/show_bug.cgi?id=2015802) **[RFE] oVirt hypervisors should support running on host with DISA STIG security profile applied**

   oVirt Hypervisor 4.5, with exception to oVirt Node, is able to run on a host with RHEL 8.6 DISA STIG openscap profile applied.
 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in oVirt to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.

   The upgrade is transparent to the user as long as few conditions are met:

   1. Upgrade the engine first.

   2. Before you upgrade the hosts, disable the ovirt-provider-ovn security groups for all OVN networks that are expected to work between hosts with OVN/OvS version 2.11.

   3. Upgrade the hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done with the web console, in order to reconfigure OVN and to refresh the certificates.

   4. Reboot the host after upgrade.

   5. Verify that the provider and OVN were configured successfully by launching the web console and checking the "OVN configured" field on the "General" tab for each host. (You can also obtain the value using the REST API.) Note that the value might be "No" if the host configuration has not been refreshed.

   If the host's OVN is not configured after refresh and you are using engine 4.5 or later, reinstalling the host will fix this issue.

#### oVirt Node NG Image

 - [BZ 2056596](https://bugzilla.redhat.com/show_bug.cgi?id=2056596) **CVE-2021-4083 kernel: fget: check that the fd still exists after getting a ref to it [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2021-4083](https://bugzilla.redhat.com/show_bug.cgi?id=2029923)
 - [BZ 2061694](https://bugzilla.redhat.com/show_bug.cgi?id=2061694) **CVE-2022-0847 - kernel: improper initialization of the "flags" member of the new pipe_buffer [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2022-0847](https://bugzilla.redhat.com/show_bug.cgi?id=2060795)

#### oVirt Engine Appliance

 - [BZ 2067982](https://bugzilla.redhat.com/show_bug.cgi?id=2067982) **CVE-2022-24302 python-paramiko: Race condition in the write_private_key_file function [ovirt-4.5]**

   CVE-2022-24302: Creation of new private key files using `~paramiko.pkey.PKey` subclasses was subject to a race condition between file creation and mode modification, which could be exploited by an attacker with knowledge of where the Paramiko-using code would write out such files; this has been patched by using `os.open` and `os.fdopen` to ensure new files are opened with the correct mode immediately (we've left the subsequent explicit `chmod` in place to minimize any possible disruption).

### Enhancements

#### oVirt Cockpit Plugin

 - [BZ 2066042](https://bugzilla.redhat.com/show_bug.cgi?id=2066042) **Require ansible-core instead of ansible in cockpit-ovirt**

   With this release, oVirt 4.5 has been upgraded to use ansible-core in cockpit-ovirt.

#### imgbased

 - [BZ 2055829](https://bugzilla.redhat.com/show_bug.cgi?id=2055829) **[RFE] /var/tmp should be on its own partition**

   `/var/tmp` is now on a separate lvm partition for DISA-STIG support.

#### OTOPI

 - [BZ 2060006](https://bugzilla.redhat.com/show_bug.cgi?id=2060006) **dnf packager on AlmaLinux**

   OTOPI packager detection has been extended to implicitly support all RHEL rebuilds, such as AlmaLinux.

#### oVirt Ansible collection

 - [BZ 2040474](https://bugzilla.redhat.com/show_bug.cgi?id=2040474) **[RFE] Add progress tracking for Cluster Upgrade**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 2020620](https://bugzilla.redhat.com/show_bug.cgi?id=2020620) **Hosted engine setup fails on host with DISA STIG profile**

   Feature: Support Hosted Engine deployment on a host with DISA STIG profile

   Reason: Support DISA STIG profile in oVirt

   Result: Hosted Engine deployment works on a host with DISA STIG is profile
 - [BZ 2022620](https://bugzilla.redhat.com/show_bug.cgi?id=2022620) **[RFE] adapt the current hosted_engine_setup role to work within ansible-core 2.12**

   Self Hosted Engine Setup role has been adapted to work with ansible-core 2.12
 - [BZ 2029830](https://bugzilla.redhat.com/show_bug.cgi?id=2029830) **[RFE] Hosted engine should accept OpenSCAP profile name instead of bool**

   Hosted Engine installation now supports selecting either DISA STIG or PCI-DSS security profiles for the Hosted Engine VM

#### oVirt Engine

 - [BZ 2072881](https://bugzilla.redhat.com/show_bug.cgi?id=2072881) **Allow upgrade via backup and restore from 4.4 to 4.5**

   Usually oVirt Engine can restore backups taken only from the same version. For oVirt 4.5 it has been made possible to restore a backup taken from oVirt 4.4 into an oVirt 4.5 Engine.
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
 - [BZ 1987121](https://bugzilla.redhat.com/show_bug.cgi?id=1987121) **[RFE] Support enabling nVidia Unified Memory on mdev vGPU**

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "`enable_uvm=1`". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2054681](https://bugzilla.redhat.com/show_bug.cgi?id=2054681) **[RFE] Make VM sealing configurable**
 - [BZ 1991482](https://bugzilla.redhat.com/show_bug.cgi?id=1991482) **[RFE] add a link to Grafana in the Admin portal UI**

   A link to Monitoring Portal has been added within the Administration Portal
 - [BZ 1999698](https://bugzilla.redhat.com/show_bug.cgi?id=1999698) **ssl.conf modifications of engine-setup do not conform to best practices (according to red hat insights)**

   In previous versions, engine-setup configured apache httpd's SSLProtocol configuration option to be `-all +TLSv1.2`.

   In RHEL 8, this isn't needed, because this option is managed by crypto-policies.

   With this version, engine-setup does not set this option, and removes it if it's already set, letting it be managed by crypto-policies.
 - [BZ 977778](https://bugzilla.redhat.com/show_bug.cgi?id=977778) **[RFE] - Mechanism for converting disks for non-running VMS**

   Feature: 
   Support the conversion of a disk's format and allocation policy

   Reason: Users may want to change allocation policy or format to make reduce space usage or improve performance. As well as enable incremental backup on existing raw disks.

   Result:
 - [BZ 2021545](https://bugzilla.redhat.com/show_bug.cgi?id=2021545) **[RFE] Add cluster-level 4.7**

   With this release, DataCenter/Cluster compatibility level 4.7 has been added, which is available only on hosts with RHEL 8.6 or later, on the latest CentOS Stream 8 and CentOS Stream/RHEL 9 with libvirt 8.0.0 or later installed.
 - [BZ 1878930](https://bugzilla.redhat.com/show_bug.cgi?id=1878930) **[RFE] Provide warning event if MAC Address Pool free and available addresses are below threshold**

   Feature: Provide warning event if number of available MAC addresses in pool are below threshold. The threshold is configurable via engine-config. An event will be created per pool on engine start, and if the threshold is reached when consuming addresses from the pool.

   Reason: Make it easier for the admin user to plan ahead.

   Result: Admin will not be faced with an empty pool when creating VNICs on VMs.
 - [BZ 2027087](https://bugzilla.redhat.com/show_bug.cgi?id=2027087) **[RFE] Warn the user on too many hosted-engine hosts**

   We are supporting only 7 hosts with hosted engine configuration in the hosted engine cluster. There might be raised issues when there are more than 7 active hosts with hosted engine configuration, but up until now we haven't been showing any warning about it.

   From oVirt Engine 4.5 if administrators will try to install more than 7 hosts with active hosted engine configuration, there will be raised a warning in the audit log about it.

   If administrators have a strong reason to change that 7 hosts limit, they could create `/etc/ovirt-engine/engine.conf.d/99-max-he-hosts.conf` file with following content:

     `MAX_RECOMMENDED_HE_HOSTS=NNN`

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

   See [Parallel migration connections](https://www.ovirt.org/develop/release-management/features/virt/parallel-migration-connections.html) for all the important information about the feature.
 - [BZ 2011768](https://bugzilla.redhat.com/show_bug.cgi?id=2011768) **Add an option to show only direct permissions (filter inherited permissions)**

   Feature: 

   Enable to filter indirect permissions on an object 

   Reason: 

   List of inherited permissions may be large and it is not easy to get only direct permissions 

   Result: 

   Adding "ALL" and "Direct" buttons that controls the permission list
 - [BZ 2021217](https://bugzilla.redhat.com/show_bug.cgi?id=2021217) **[RFE] Windows 2022 support**

   Add Windows 2022 as a guest operating system
 - [BZ 1998866](https://bugzilla.redhat.com/show_bug.cgi?id=1998866) **[RFE] Windows 11 support**

   Add Windows 11 as a guest operating system
 - [BZ 1821018](https://bugzilla.redhat.com/show_bug.cgi?id=1821018) **[RFE] Use only "engine-backup --mode=restore" for restoration of every possible databases by default instead of "--provision-all-databases"**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 2033185](https://bugzilla.redhat.com/show_bug.cgi?id=2033185) **[RFE] Add e1000e driver on cluster level &gt;=4.7**

   Add e1000e VM Nic type for cluster level 4.7. The e1000 is depracated from RHEL8.0 and users should switch to e1000e when possible.
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

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "`enable_uvm=1`". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2040474](https://bugzilla.redhat.com/show_bug.cgi?id=2040474) **[RFE] Add progress tracking for Cluster Upgrade**

   If this bug requires documentation, please select an appropriate Doc Type value.
 - [BZ 1991482](https://bugzilla.redhat.com/show_bug.cgi?id=1991482) **[RFE] add a link to Grafana in the Admin portal UI**

   A link to Monitoring Portal has been added within the Administration Portal

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
 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**

   A check has been added to Self Hosted Engine Setup to ensure that the IP address resolved from oVirt Engine FQDN belongs to the same Subnet of the host which will run the Self Hosted Engine Agent.

#### oVirt Setup Lib

 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**

   A check has been added to Self Hosted Engine Setup to ensure that the IP address resolved from oVirt Engine FQDN belongs to the same Subnet of the host which will run the Self Hosted Engine Agent.

#### VDSM

 - [BZ 1987121](https://bugzilla.redhat.com/show_bug.cgi?id=1987121) **[RFE] Support enabling nVidia Unified Memory on mdev vGPU**

   The vGPU editing dialog was enhanced with an option to set driver parameters. The driver parameters are are specified as an arbitrary text, which is passed to NVidia drivers as it is, e.g. "`enable_uvm=1`". The given text will be used for all the vGPUs of a given VM.

   The vGPU editing dialog was moved from the host devices tab to the VM devices tab.

   vGPU properties are no longer specified using mdev_type VM custom property. They are specified as VM devices now. This change is transparent when using the vGPU editing dialog. In the REST API, the vGPU properties can be manipulated using a newly introduced `.../vms/.../mediateddevices` endpoint. The new API permits setting "nodisplay" and driver parameters for each of the vGPUs individually, but note that this is not supported in the vGPU editing dialog where they can be set only to a single value common for all the vGPUs of a given VM.
 - [BZ 2051997](https://bugzilla.redhat.com/show_bug.cgi?id=2051997) **[RFE] Default thin provisioning extension thresholds should match modern hardware**

   Feature: 
   Adapt thin provisioning defaults to match modern hardware with faster write and larger capacity. The minimum allocation size was increased from 1 GiB to 2.5G, and the minimum free space threshold was increased from 512 MiB to 2 GiB.

   Reason: 
   With modern hardware virtual machines sometimes paused temporarily when writing to thin disks on block based storage.

   Result:
   The system allocates more data earlier, minimizing virtual machines pauses.
 - [BZ 2012830](https://bugzilla.redhat.com/show_bug.cgi?id=2012830) **[RFE] Use lvm devices instead of lvm filter on RHEL 8.6 / CentOS Stream 9**

   Feature: 
   Use LVM devices instead lvm filter to manage storage devices.

   Reason: 
   LVM filter is hard to manage and also in some case hard to set up in a correct way. LVM devices provides more easy way how to manage devices. Morover, starting CentOS Stream 9/RHEL 9, this will be the default used by LVM.

   Result:
   With this feature, vdsm use LVM devices file for managing storage devices and LVM filter is not needed any more.
 - [BZ 2021545](https://bugzilla.redhat.com/show_bug.cgi?id=2021545) **[RFE] Add cluster-level 4.7**

   With this release, DataCenter/Cluster compatibility level 4.7 has been added, which is available only on hosts with RHEL 8.6 or later, on the latest CentOS Stream 8 and CentOS Stream/RHEL 9 with libvirt 8.0.0 or later installed.
 - [BZ 1975720](https://bugzilla.redhat.com/show_bug.cgi?id=1975720) **[RFE] Huge VMs require an additional migration parameter**

   Support for parallel migration connections was added.

   See [Parallel migration connections](https://www.ovirt.org/develop/release-management/features/virt/parallel-migration-connections.html) for all the important information about the feature.
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

 - [BZ 2012747](https://bugzilla.redhat.com/show_bug.cgi?id=2012747) **Add Gluster 10 repositories**

   oVirt release package now enables by default GlusterFS 10 repositories. Please follow the [Gluster 10 upgrade guide](https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-10/)

### Technology Preview

#### oVirt Release Host Node

 - [BZ 1986775](https://bugzilla.redhat.com/show_bug.cgi?id=1986775) **[RFE] introduce support for CentOS Stream 9 on oVirt releases**

   oVirt release package now provides YUM repositories configuration also for CentOS Stream 9.

### Removed functionality

#### oVirt Engine

 - [BZ 2028359](https://bugzilla.redhat.com/show_bug.cgi?id=2028359) **Remove "moVirt for Android" link from the welcome page of oVirt Engine**

   moVirt - Android mobile application for managing oVirt - development has been discontinued.
 - [BZ 1950730](https://bugzilla.redhat.com/show_bug.cgi?id=1950730) **Remove old Cinder integration from the REST-API**

   This patch removes the ability to create/use old cinder integration using the REST API.

#### oVirt Web Site

 - [BZ 2077545](https://bugzilla.redhat.com/show_bug.cgi?id=2077545) **[DOCS] Remove references to ovirt-iso-uploader / engine-iso-uploader**

   ovirt-iso-uploader package was deprecated in 4.3 and removed in 4.4.

### Bug Fixes

#### OTOPI

 - [BZ 1986485](https://bugzilla.redhat.com/show_bug.cgi?id=1986485) **otopi uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**

#### oVirt Ansible collection

 - [BZ 2026770](https://bugzilla.redhat.com/show_bug.cgi?id=2026770) **host deployment fails on fips-enabled host**
 - [BZ 1768969](https://bugzilla.redhat.com/show_bug.cgi?id=1768969) **Duplicate iSCSI sessions in the hosted-engine deployment host when the tpgt is not 1**

#### oVirt Engine

 - [BZ 2066084](https://bugzilla.redhat.com/show_bug.cgi?id=2066084) **vmconsole-proxy-user certificate expired - cannot access serial console**
 - [BZ 1988496](https://bugzilla.redhat.com/show_bug.cgi?id=1988496) **vmconsole-proxy-helper.cer is not renewed when running engine-setup**
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
 - [BZ 2040361](https://bugzilla.redhat.com/show_bug.cgi?id=2040361) **Hotplug VirtIO-SCSI disk fails with error "Domain already contains a disk with that address" when IO threads &gt; 1**
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

#### oVirt Engine Data Warehouse

 - [BZ 2010903](https://bugzilla.redhat.com/show_bug.cgi?id=2010903) **I/O operations/sec reporting wrong values**

#### oVirt Engine UI Extensions

 - [BZ 2024202](https://bugzilla.redhat.com/show_bug.cgi?id=2024202) **oVirt Dashboard does not show memory and storage details properly when using Spanish language.**

#### oVirt Hosted Engine HA

 - [BZ 1986732](https://bugzilla.redhat.com/show_bug.cgi?id=1986732) **ovirt-ha services cannot set the LocalMaintenance mode in the storage metadata and are in a restart loop**
 - [BZ 2024161](https://bugzilla.redhat.com/show_bug.cgi?id=2024161) **Penalizing score by 1000 due to cpu load is not canceled after load decreasing to 0**

#### oVirt Hosted Engine Setup

 - [BZ 2026770](https://bugzilla.redhat.com/show_bug.cgi?id=2026770) **host deployment fails on fips-enabled host**
 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**
 - [BZ 1768969](https://bugzilla.redhat.com/show_bug.cgi?id=1768969) **Duplicate iSCSI sessions in the hosted-engine deployment host when the tpgt is not 1**

#### oVirt Setup Lib

 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**
 - [BZ 1971863](https://bugzilla.redhat.com/show_bug.cgi?id=1971863) **Queries of type 'ANY' are deprecated - RFC8482**

#### VDSM

 - [BZ 2028481](https://bugzilla.redhat.com/show_bug.cgi?id=2028481) **SCSI reservation is not working for hot plugged VM disks**
 - [BZ 2010478](https://bugzilla.redhat.com/show_bug.cgi?id=2010478) **After storage error HA VMs failed to auto resume.**
 - [BZ 1787192](https://bugzilla.redhat.com/show_bug.cgi?id=1787192) **Host fails to activate in oVirt and goes to non-operational status when some of the iSCSI targets are down**
 - [BZ 1926589](https://bugzilla.redhat.com/show_bug.cgi?id=1926589) **"Too many open files" in vdsm.log after 380 migrations**

### Other

#### oVirt Engine

 - [BZ 2079835](https://bugzilla.redhat.com/show_bug.cgi?id=2079835) **Separate validity length of Apache and internal certificates**
 - [BZ 2079890](https://bugzilla.redhat.com/show_bug.cgi?id=2079890) **renew certificates sooner before they expire**
 - [BZ 2079901](https://bugzilla.redhat.com/show_bug.cgi?id=2079901) **allow Enroll Certificate action when host is Non Responsive**
 - [BZ 2079799](https://bugzilla.redhat.com/show_bug.cgi?id=2079799) **issue the internal Certificate Authority for 20 years**
 - [BZ 2074112](https://bugzilla.redhat.com/show_bug.cgi?id=2074112) **[Veeam] VM does not have a disk after restored from backup**
 - [BZ 2074916](https://bugzilla.redhat.com/show_bug.cgi?id=2074916) **Failed to upload OVA as template via upload_ova_as_vm_or_template.py**
 - [BZ 2075435](https://bugzilla.redhat.com/show_bug.cgi?id=2075435) **Hybrid Backup - backup href has changed and causing backups to get stuck in finalizing stage**
 - [BZ 2074582](https://bugzilla.redhat.com/show_bug.cgi?id=2074582) **VDSM expects from engine to translate resize_and_pin_numa policy to resize_and_pin**
 - [BZ 2075037](https://bugzilla.redhat.com/show_bug.cgi?id=2075037) **Wrong pinning in the dedicated virsh dumpxml after migration**
 - [BZ 1989121](https://bugzilla.redhat.com/show_bug.cgi?id=1989121) **[CBT][Veeam] Block backup of hosted-engine vm**
 - [BZ 2069670](https://bugzilla.redhat.com/show_bug.cgi?id=2069670) **NPE when converting ISCSI disk during the copy_data action**
 - [BZ 2070536](https://bugzilla.redhat.com/show_bug.cgi?id=2070536) **The same host CPUs are assigned twice when we run dedicated&amp;none&amp;resize VMs on the same host**
 - [BZ 2070184](https://bugzilla.redhat.com/show_bug.cgi?id=2070184) **Hybrid Backup - Specifying disks for backup doesn't work, backup is created for all disks**
 - [BZ 2068104](https://bugzilla.redhat.com/show_bug.cgi?id=2068104) **hybrid backup VM after a snapshot fails - start_nbd_server error=Bitmap does not exist**
 - [BZ 1979277](https://bugzilla.redhat.com/show_bug.cgi?id=1979277) **[RFE] Migration - Apply automatic CPU and NUMA pinning based on the migrated host**
 - [BZ 2065152](https://bugzilla.redhat.com/show_bug.cgi?id=2065152) **Implicit CPU pinning for NUMA VMs destroyed because of invalid CPU policy**
 - [BZ 2043984](https://bugzilla.redhat.com/show_bug.cgi?id=2043984) **Cannot move any host to maintenance mode**
 - [BZ 2037779](https://bugzilla.redhat.com/show_bug.cgi?id=2037779) **VM name is displayed as &lt;UNKNOWN&gt; in disk properties update notification**
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
 - [BZ 2024529](https://bugzilla.redhat.com/show_bug.cgi?id=2024529) **Creating a template from a VM with TPM in the REST API without specifying the TPM property results in a template without TPM**
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
 - [BZ 1992568](https://bugzilla.redhat.com/show_bug.cgi?id=1992568) **Dashboard - pop-up messages are not localized**
 - [BZ 1771925](https://bugzilla.redhat.com/show_bug.cgi?id=1771925) **Improve error handling when calling REST API**
 - [BZ 1980331](https://bugzilla.redhat.com/show_bug.cgi?id=1980331) **manage vGPU dialog: maximum value of available mdev instances to attach is incorrect.**

#### oVirt Provider OVN

 - [BZ 2012850](https://bugzilla.redhat.com/show_bug.cgi?id=2012850) **Cannot add router port with IPv6**

#### VDSM

 - [BZ 2076545](https://bugzilla.redhat.com/show_bug.cgi?id=2076545) **Mailbox logs are too noisy, no way to silence them**
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

### No Doc Update

#### MOM

 - [BZ 2001789](https://bugzilla.redhat.com/show_bug.cgi?id=2001789) **mom uses deprecated API SafeConfigParser**
 - [BZ 2001759](https://bugzilla.redhat.com/show_bug.cgi?id=2001759) **mom requires python-nose**

#### OTOPI

 - [BZ 2047260](https://bugzilla.redhat.com/show_bug.cgi?id=2047260) **DNF on otopi is logging UNKNOWN for packages on some actions**
 - [BZ 1916144](https://bugzilla.redhat.com/show_bug.cgi?id=1916144) **[RFE] Check otopi's dnf package with signatures during CI automation/check-patch.sh**

#### oVirt Ansible collection

 - [BZ 1932147](https://bugzilla.redhat.com/show_bug.cgi?id=1932147) **[RFE] Support specifying storage domain format (V3, V4, V5...) in ansible ovirt_storage_domain module**

#### oVirt Engine

 - [BZ 2083230](https://bugzilla.redhat.com/show_bug.cgi?id=2083230) **engine-setup on a separate machine fails with: Command '/usr/bin/rpm' failed to execute**
 - [BZ 2075486](https://bugzilla.redhat.com/show_bug.cgi?id=2075486) **VM with Q35 UEFI and 64 CPUs is running but without boot screen, console and network.**
 - [BZ 2076474](https://bugzilla.redhat.com/show_bug.cgi?id=2076474) **OVA import: importing VM OVA  failed with "async task did not complete within the requested time - 120s"**
 - [BZ 1868372](https://bugzilla.redhat.com/show_bug.cgi?id=1868372) **collectd-virt plugin doesn't work with latest libvirt**
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

#### oVirt Host Dependencies

 - [BZ 1868372](https://bugzilla.redhat.com/show_bug.cgi?id=1868372) **collectd-virt plugin doesn't work with latest libvirt**
 - [BZ 2001537](https://bugzilla.redhat.com/show_bug.cgi?id=2001537) **mailx -&gt; s-nail replacement in CentOS Stream 9**

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

 - [BZ 2005045](https://bugzilla.redhat.com/show_bug.cgi?id=2005045) **ovirt-node-ng iso build relies on genisoimage**

#### oVirt Engine Appliance

 - [BZ 2050071](https://bugzilla.redhat.com/show_bug.cgi?id=2050071) **Use authselect in oVirt Node and appliance images**



## Also includes

### Release Note

#### oVirt Engine SDK 4 Python

 - [BZ 1933555](https://bugzilla.redhat.com/show_bug.cgi?id=1933555) **[RFE] Release python-ovirt-engine-sdk4 package on RHEL 9**

   Python SDK for oVirt is going to be released also for RHEL 9

#### oVirt Ansible collection

 - [BZ 2004018](https://bugzilla.redhat.com/show_bug.cgi?id=2004018) **Modify ovirt_disk Ansible module to allow setting the bootable flag only if disk is attached to a virtual machine**

   Error message has been added to ovirt_disk module, that parameters 'interface', 'activate', 'bootable', 'uses_scsi_reservation' and 'pass_discard' cannot be used without specifying a VM.
 - [BZ 2004852](https://bugzilla.redhat.com/show_bug.cgi?id=2004852) **[RFE] include option to enable/disable virtio scsi support in ovirt_vm module**

   Following parameters has been added to ovirt_vm module:

     * virtio_scsi_enabled:
         - If true, it enable Virtio SCSI support

     * multi_queues_enabled:
          - If true, each virtual interface will get the optimal number of queues, depending on the available virtual CPUs.
 - [BZ 2006721](https://bugzilla.redhat.com/show_bug.cgi?id=2006721) **uploading image using ovirt_disk always fails for the first time and works in second attempt**

   ovirt_disk module released as a part of ovirt-ansible-collection 2.0.0 uses imageio python client to upload images into oVirt Engine.
 - [BZ 2017070](https://bugzilla.redhat.com/show_bug.cgi?id=2017070) **Remove manageiq role from oVirt Ansible Collection**

   manageiq role has been removed from oVirt Ansible Collection 2.0.0
 - [BZ 2071365](https://bugzilla.redhat.com/show_bug.cgi?id=2071365) **[RFE] Require ansible-core-2.12 in ovirt-ansible-collection**

   oVirt Ansible Collection 2.0.0 requires ansible-core-2.12 from RHEL 8.6 and doesn't work anymore with previous ansible-2.9.z versions

#### oVirt Engine

 - [BZ 2015796](https://bugzilla.redhat.com/show_bug.cgi?id=2015796) **[RFE] oVirt Engine should support running on a host with DISA STIG security profile applied**

   oVirt Engine 4.5 is able to run on a host with RHEL 8.6 DISA STIG openscap profile applied
 - [BZ 2022323](https://bugzilla.redhat.com/show_bug.cgi?id=2022323) **[RFE] Upgrade emulated machine**

   oVirt 4.5 will use following machine types for cluster level 4.7:

   * x86_64
     - pc-q35-rhel8.6.0 
     - pc-q35-4.1
     - pc-i440fx-rhel7.6.0
     - pc-i440fx-2.12

   * ppc64le
     - pseries-rhel8.4.0
 - [BZ 2022326](https://bugzilla.redhat.com/show_bug.cgi?id=2022326) **[RFE] Upgrade emulated machine**

   oVirt 4.5 will use following machine types for cluster level 4.7:

   * x86_64
     - pc-q35-rhel8.6.0 
     - pc-i440fx-rhel7.6.0

   * ppc64le
     - pseries-rhel8.4.0
 - [BZ 2030596](https://bugzilla.redhat.com/show_bug.cgi?id=2030596) **[RFE] oVirt Engine should support running on a host with the PCI-DSS security profile applied**

   The oVirt Engine is now capable of running on machine with PCI-DSS security profile.
 - [BZ 2043146](https://bugzilla.redhat.com/show_bug.cgi?id=2043146) **Expired /etc/pki/vdsm/libvirt-vnc/server-cert.pem certificate is skipped during Enroll Certificate**

   Renewing of libvirt-vnc certificate has been omitted during Enroll Certificate flow. This has been fixed in oVirt 4.5 and also libvirt-vnc certificates are renewed during Enroll Certificate
 - [BZ 2056021](https://bugzilla.redhat.com/show_bug.cgi?id=2056021) **[BUG]: "Enroll Certificate" operation not updating libvirt-vnc cert and key**

   Renewing of libvirt-vnc certificate has been omitted during Enroll Certificate flow. This has been fixed in oVirt 4.5 and also libvirt-vnc certificates are renewed during Enroll Certificate
 - [BZ 2055136](https://bugzilla.redhat.com/show_bug.cgi?id=2055136) **virt module is not changed to the correct stream during host upgrade**

   Version of virt DNF module is now correctly set according to the RHEL version the host is upgraded to during host upgrade flow.

#### VDSM

 - [BZ 2030226](https://bugzilla.redhat.com/show_bug.cgi?id=2030226) **[RFE] oVirt hypervisors should support running on hosts with the PCI-DSS security profile applied**

   The oVirt Hypervisor is now capable of running on machine with PCI-DSS security profile.

#### ovirt-node

 - [BZ 2065579](https://bugzilla.redhat.com/show_bug.cgi?id=2065579) **CVE-2022-25235 CVE-2022-25236 CVE-2022-25315 expat: various flaws [ovirt-4.5]**

   oVirt Node includes updated expat package providing fixes for multiple CVEs:
   [CVE-2022-25315](https://bugzilla.redhat.com/show_bug.cgi?id=2056363)
   [CVE-2022-25235](https://bugzilla.redhat.com/show_bug.cgi?id=2056366)
   [CVE-2022-25236](https://bugzilla.redhat.com/show_bug.cgi?id=2056370)
 - [BZ 2068507](https://bugzilla.redhat.com/show_bug.cgi?id=2068507) **CVE-2022-0778 openssl: Infinite loop in BN_mod_sqrt() reachable when parsing certificates [ovirt-4.5]**

   oVirt Node includes updated openssl packages providing fixes for [CVE-2022-0778](https://bugzilla.redhat.com/show_bug.cgi?id=2062202)
 - [BZ 2056588](https://bugzilla.redhat.com/show_bug.cgi?id=2056588) **CVE-2021-4028 kernel: use-after-free in RDMA listen() [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2021-4028](https://bugzilla.redhat.com/show_bug.cgi?id=2027201)
 - [BZ 2056597](https://bugzilla.redhat.com/show_bug.cgi?id=2056597) **CVE-2022-0435 kernel: remote stack overflow via kernel panic on systems using TIPC may lead to DoS [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2022-0435](https://bugzilla.redhat.com/show_bug.cgi?id=2048738)
 - [BZ 2065576](https://bugzilla.redhat.com/show_bug.cgi?id=2065576) **CVE-2022-25636 kernel: heap out of bounds write in nf_dup_netdev.c [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2022-25636](https://bugzilla.redhat.com/show_bug.cgi?id=2056830)
 - [BZ 2070051](https://bugzilla.redhat.com/show_bug.cgi?id=2070051) **CVE-2022-1015 kernel: arbitrary code execution in linux/net/netfilter/nf_tables_api.c [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2022-1015](https://bugzilla.redhat.com/show_bug.cgi?id=2065323)
 - [BZ 2070067](https://bugzilla.redhat.com/show_bug.cgi?id=2070067) **CVE-2022-1016 - kernel: uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM [ovirt-4.5]**

   oVirt Node has been updated with newer kernel release including fixes for [CVE-2022-1016](https://bugzilla.redhat.com/show_bug.cgi?id=2066614)

#### ovirt-distribution

 - [BZ 2084027](https://bugzilla.redhat.com/show_bug.cgi?id=2084027) **CVE-2022-22950 - ovirt-dependencies: spring-expression: Denial of service via specially crafted SpEL expression [ovirt-4.5]**

   ovirt-dependencies has been updated including Spring Framework 5.3.19 which fixes [CVE-2022-22950](https://bugzilla.redhat.com/show_bug.cgi?id=2069414)

### Enhancements

#### oVirt Engine

 - [BZ 1563552](https://bugzilla.redhat.com/show_bug.cgi?id=1563552) **[RFE] Add Virtio-1.1 support in oVirt (depends in CentOS/RHEL 8.5)**
 - [BZ 1995455](https://bugzilla.redhat.com/show_bug.cgi?id=1995455) **Increase the maximum number of CPU sockets**

   The limit of maximum 16 CPU sockets has been removed in cluster versions &gt;= 4.6. It's possible to use any number of CPU sockets now, up to the number of maximum vCPUs. Before using a high number of CPU sockets, it's advisable to check whether the guest OS is fine with such a configuration.
 - [BZ 2049782](https://bugzilla.redhat.com/show_bug.cgi?id=2049782) **[RFE] Admin portal user preferences/settings with server-side storage**
 - [BZ 2053669](https://bugzilla.redhat.com/show_bug.cgi?id=2053669) **[RFE] Allow changing vm powerstate during backup operation without interrupting the backup**

   Feature: 
   Use a temporary snapshot during a backup to decouple the backup
   operation from the VM.

   Reason: 
   Backup can take lot of time. Preventing changes in VM power
   state or migration during a backup is a problem for users.

   Result:
   A VM can be started, stopped, or migrated during backup.

#### oVirt Web UI

 - [BZ 1667517](https://bugzilla.redhat.com/show_bug.cgi?id=1667517) **[RFE] add VM Portal setting for set screen mode**

   Feature: 
   console options including set screen mode is added to VM Portal

   Reason: 
   There was no option to set screen mode in VM Portal

   Result: 
   The following console options can now be set in VM Portal:
   default console type to use (Spice, VNC, noVNC, RDP for Windows), 
   full screen mode (on/off) per console type, 
   smartcard enabled/disabled
   Ctrl+Alt+Del mapping 
   SSH key

   A new dialog was added: VM portal -&gt; Account Settings -&gt; Console options dialog. 

   Those console options settings are now persisted on engine server, so deleting cookies and website data won't reset those settings.

   Few limitations with current implementation:
   1. The console settings via VM Portal are global for all VMs and can't be set per VM (as opposed to Admin Portal where console options are set per VM). 

   2. There is no sync between Admin Portal console options and VM portal console options. I.e. the console options configuration done by Create/Edit VM/Pool dialog (supported console types and smartcard enabled) are synced, but the 'console options' run time settings done for running VMs via Console -&gt; Console options are not synced with Admin Portal. 

   3. The console settings are part of Account settings and therefore are set per user. Each user logged in to the VM Portal can have it's own console settings, defaults are taken from the vdc_options config parameters.
 - [BZ 1781241](https://bugzilla.redhat.com/show_bug.cgi?id=1781241) **missing “connect automatically” option in vm portal**

   Feature: 
   Adding back the support for automatically connecting to a Virtual Machine option. This is now enabled as part of the Account Setting console options dialog. 

   Reason: 
   This feature enables to connect automatically to a running Virtual Machine every time the user logs into the VM Portal. 
   This functionality was supported by old VM Portal and also by the User Portal and was requested to be supported by current VM Portal as well. 

   Result: 
   The current feature is now supported while usage is a bit different than how it was on previous User and VM portals:
   - Each user can choose a VM to auto connect to from a list on a global level, as part of Account Setting's console dialog. 
   - Only if the chosen VM exists and on a running state then the auto connect will be enforced next time the user logs in. 
   - The Console type for connecting will be chosen based on Account Setting's console options.
   - This auto connect VM setting is persisted per user on the engine.

#### oVirt Ansible collection

 - [BZ 1883949](https://bugzilla.redhat.com/show_bug.cgi?id=1883949) **ovirt_disk Ansible module uses the physical size of a qcow2 file instead of the virtual size**

   Feature:
   1. Add 2 new backup phases:
   - SUCCEEDED
   - FAILED
   2. Disable 'vm_backups' &amp; 'image_transfers' DB tables cleanup after backup / image transfer operation is over.
   3. Add DB cleanup scheduled thread to automatically clean backups and image transfers once in a while.

   Reason:
   After backup / image transfer operation finishes, all the execution data disappeared.
   That means, that the user didn't know the final execution state of the operation that was visible via DB and API while the backup / image transfer execution was still in progress.
   In case of backup operation, the situation was even worse - there was no indication for success/failure, the last thing the user might be able to see is the 'FINALIZING' status.
   We want the user to be able to see the operation result, but also not over-polute the database with too old data.

   Result:
   1. Added 2 new backup phases to show possible execution statuses (success/failure) for backup operations.
   2. Cancel DB cleanup of the 'vm_backups' &amp; 'image_transfers' DB tables when the backup / image transfer finishes to allow DB &amp; API status retrieval by user.
   3. Scheduled execution of the cleanup - 15 minutes for success entries, 30 minutes for the failure. Separate values for backup &amp; for image transfer operations, an additional value for the cleanup thread rate (all 5 values are configurable).
   4. Some minor user experience improvements.

#### ovirt-engine-sdk-python

 - [BZ 1973278](https://bugzilla.redhat.com/show_bug.cgi?id=1973278) **[RFE] Add an SDK example for importing templates from OVAs**

   Added an example that demonstrates importing of a template from an OVA file that is located on a host

### Bug Fixes

#### ovirt-distribution

 - [BZ 1810032](https://bugzilla.redhat.com/show_bug.cgi?id=1810032) **[Docs][API] Default value of network-filter for vnic-profile entity is not documented**

#### oVirt Engine

 - [BZ 1834542](https://bugzilla.redhat.com/show_bug.cgi?id=1834542) **"engine-setup" does not manage DNF configured proxy**
 - [BZ 1974741](https://bugzilla.redhat.com/show_bug.cgi?id=1974741) **Disk images remain in locked state if the HE VM is rebooted during a image transfer**
 - [BZ 1976333](https://bugzilla.redhat.com/show_bug.cgi?id=1976333) **Memory guaranteed size not live updated when changed alone**
 - [BZ 2064380](https://bugzilla.redhat.com/show_bug.cgi?id=2064380) **VNC Console: Operation Cancelled "Setting vm ticket failed" on engine 4.4.10.7**

#### oVirt Ansible collection

 - [BZ 1932149](https://bugzilla.redhat.com/show_bug.cgi?id=1932149) **Create hosted_storage with the correct storage_format based on the Data-Center level of the backup**
 - [BZ 2066811](https://bugzilla.redhat.com/show_bug.cgi?id=2066811) **Hosted engine deployment fails when DISA STIG profile is selected for the engine VM**
 - [BZ 2069658](https://bugzilla.redhat.com/show_bug.cgi?id=2069658) **Unable to deploy HE, couldn't resolve module/action 'firewalld'.**

#### oVirt Web UI

 - [BZ 1991240](https://bugzilla.redhat.com/show_bug.cgi?id=1991240) **Assign user quota when provisioning from a non-blank template via web-ui**

#### ovirt-imageio

 - [BZ 2010067](https://bugzilla.redhat.com/show_bug.cgi?id=2010067) **Downloading prellocated disk created preallocated image**

#### ovirt-engine-dwh

 - [BZ 2014888](https://bugzilla.redhat.com/show_bug.cgi?id=2014888) **oVirt executive dashboard/Virtual Machine dashboard does not actually show disk I/O operations per second, but it shows sum of I/o operations since the boot time of VM**

#### oVirt Log Collector

 - [BZ 2040402](https://bugzilla.redhat.com/show_bug.cgi?id=2040402) **unable to use --log-size=0 option**
 - [BZ 2048546](https://bugzilla.redhat.com/show_bug.cgi?id=2048546) **sosreport command should be replaced by sos report**

#### oVirt Hosted Engine HA

 - [BZ 2050108](https://bugzilla.redhat.com/show_bug.cgi?id=2050108) **hosted-engine-setup fails to start ovirt-ha-broker service on RHEL-H with DISA STIG**

### Other

#### oVirt Ansible collection

 - [BZ 2020624](https://bugzilla.redhat.com/show_bug.cgi?id=2020624) **[RFE] support satellite registration with repositories role**

#### oVirt Engine

 - [BZ 2073005](https://bugzilla.redhat.com/show_bug.cgi?id=2073005) **ui-extensions dialogs are flashing when they are rendered on a chrome browser**
 - [BZ 2076465](https://bugzilla.redhat.com/show_bug.cgi?id=2076465) **OVA import: importing OVA of Q35/UEFI VM failed with 'Duplicate key nvram'**

### No Doc Update

#### ovirt-distribution

 - [BZ 1713633](https://bugzilla.redhat.com/show_bug.cgi?id=1713633) **Kdump file is captured in local filesystem when setting "Location" to "Remote over NFS"**
 - [BZ 1978582](https://bugzilla.redhat.com/show_bug.cgi?id=1978582) **[RFE] Create follow parameter documentation**
 - [BZ 2000520](https://bugzilla.redhat.com/show_bug.cgi?id=2000520) **Explicitly require ovirt-openvswitch instead of implicit Provides**
 - [BZ 2065294](https://bugzilla.redhat.com/show_bug.cgi?id=2065294) **ceph support via cinderlib is failing due to too old python-psycopg2**

#### oVirt Engine

 - [BZ 1809463](https://bugzilla.redhat.com/show_bug.cgi?id=1809463) **engine-setup should set the permissions of private key files more restrictive**
 - [BZ 1913269](https://bugzilla.redhat.com/show_bug.cgi?id=1913269) **The allocation of vCPUs to NUMA nodes is incorrect/sub-optimal**
 - [BZ 1954041](https://bugzilla.redhat.com/show_bug.cgi?id=1954041) **Remove support for SHA-1 in ticket modules**
 - [BZ 1981079](https://bugzilla.redhat.com/show_bug.cgi?id=1981079) **Expected condition after migration is logged as an error and try to set threshold to migrated VM's disk.**
 - [BZ 1990298](https://bugzilla.redhat.com/show_bug.cgi?id=1990298) **[CinderLib] Block cloning a vm from vm snapshot**
 - [BZ 2003883](https://bugzilla.redhat.com/show_bug.cgi?id=2003883) **Failed to update the VFs configuration of network interface card type 82599ES and X520**
 - [BZ 2041165](https://bugzilla.redhat.com/show_bug.cgi?id=2041165) **Finalization of a backup after the VM was powered off from guest fails with non-informative response**
 - [BZ 2062754](https://bugzilla.redhat.com/show_bug.cgi?id=2062754) **VM with resize and pin cpu policy fails to start on host CPUs:48,Threads:2,Cores:24, Sockets:1,NUMA:4**
 - [BZ 2063802](https://bugzilla.redhat.com/show_bug.cgi?id=2063802) **When converting disk allocation type the disk is being removed instead**
 - [BZ 2063875](https://bugzilla.redhat.com/show_bug.cgi?id=2063875) **Not possible to make disk convert to all disks possibilities**
 - [BZ 2066628](https://bugzilla.redhat.com/show_bug.cgi?id=2066628) **[UI] UI exception when updating or enabling number of VFs via the webadmin**
 - [BZ 2070008](https://bugzilla.redhat.com/show_bug.cgi?id=2070008) **The Console Disconnect Action Delay property isn't included in the OVF**
 - [BZ 2070119](https://bugzilla.redhat.com/show_bug.cgi?id=2070119) **Dedicated VM (topology: Threads:2 Cores:7 Sockets:2) starts without vCPU-pCPU mapping**
 - [BZ 2073120](https://bugzilla.redhat.com/show_bug.cgi?id=2073120) **The CPU resources are not properly freed upon dedicated VM hibernation .**

#### VDSM

 - [BZ 1835105](https://bugzilla.redhat.com/show_bug.cgi?id=1835105) **[4.3] Unable to add a host to oVirt over BOND management interfaces created by IBM cloud**
 - [BZ 1929099](https://bugzilla.redhat.com/show_bug.cgi?id=1929099) **Disks remain in locked status**

#### oVirt Hosted Engine Setup

 - [BZ 1857815](https://bugzilla.redhat.com/show_bug.cgi?id=1857815) **Copying HE-VM's disk to iSCSI storage volume, during deployment of 4.4 HE takes too long.**
 - [BZ 2044034](https://bugzilla.redhat.com/show_bug.cgi?id=2044034) **Failed to deploy HE due to deprecations in ansible.**
 - [BZ 2066623](https://bugzilla.redhat.com/show_bug.cgi?id=2066623) **Drop dependency on  python-dateutil**

#### oVirt Engine SDK 4 Java

 - [BZ 2024698](https://bugzilla.redhat.com/show_bug.cgi?id=2024698) **build failure in copr**

#### ovirt-engine-dwh

 - [BZ 2026362](https://bugzilla.redhat.com/show_bug.cgi?id=2026362) **moved major version to 4.5.0**
 - [BZ 2065195](https://bugzilla.redhat.com/show_bug.cgi?id=2065195) **ETL service sampling has encountered an error**

#### ovirt-node

 - [BZ 2027287](https://bugzilla.redhat.com/show_bug.cgi?id=2027287) **Explore building oVirt Node with GitHub Actions and self-hosted runners**
 - [BZ 2057958](https://bugzilla.redhat.com/show_bug.cgi?id=2057958) **oVirt Node 4.5 el9 iso doesn't boot anymore**
 - [BZ 2074469](https://bugzilla.redhat.com/show_bug.cgi?id=2074469) **CVE-2022-1271 - gzip: arbitrary-file-write vulnerability [ovirt-4.5]**

#### oVirt Engine Appliance

 - [BZ 2027289](https://bugzilla.redhat.com/show_bug.cgi?id=2027289) **Explore building oVirt Engine Appliance with GitHub Actions and self-hosted runners**

#### oVirt Release Host Node

 - [BZ 2032850](https://bugzilla.redhat.com/show_bug.cgi?id=2032850) **Make ovirt-release-host-node build working on CBS**

#### oVirt Provider OVN

 - [BZ 2049059](https://bugzilla.redhat.com/show_bug.cgi?id=2049059) **[4.5.0-3] Add PPC host failed in "Configure OVN for oVirt" task**

### Contributors

68 people contributed to this release:

	Albert Esteve (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Aleš Musil (Contributed to: ovirt-appliance, ovirt-engine, ovirt-host, ovirt-openvswitch, ovirt-provider-ovn, ovirt-release, vdsm)
	Andrej Krejcir (Contributed to: mom)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-wildfly, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: cockpit-ovirt, ovirt-ansible-collection, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-setup-lib)
	Avital Pinnick (Contributed to: ovirt-site)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine, ovirt-engine-metrics, ovirt-host)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-release)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-host, ovirt-release, vdsm)
	Brett Maton (Contributed to: ovirt-site)
	Dana Elfassy (Contributed to: ovirt-engine)
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
	Germano Veit Michel (Contributed to: vdsm)
	Harel Braha (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, vdsm)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Jake Reynolds (Contributed to: ovirt-hosted-engine-ha)
	Janos Bonic (Contributed to: ovirt-release)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-engine, ovirt-log-collector, ovirt-node-ng-image, ovirt-release, ovirt-site, vdsm)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Loïc Albertin (Contributed to: ovirt-node-ng)
	Lucia Jelinkova (Contributed to: ovirt-engine, ovirt-engine-ui-extensions)
	Marcin Sobczyk (Contributed to: ovirt-release, vdsm)
	Mark Kemel (Contributed to: ovirt-engine, ovirt-engine-ui-extensions, python-ovirt-engine-sdk4, vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-release, python-ovirt-engine-sdk4)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-dependencies, ovirt-dwh, ovirt-engine, ovirt-engine-metrics, ovirt-engine-wildfly, ovirt-imageio, ovirt-jboss-modules-maven-plugin, ovirt-release, python-ovirt-engine-sdk4, vdsm, vdsm-jsonrpc-java)
	Martin Tzvetanov Grigorov (Contributed to: ovirt-engine)
	Michal Skrivanek (Contributed to: imgbased, ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-engine-metrics, ovirt-engine-ui-extensions, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-release, ovirt-web-ui)
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
	kurokobo (Contributed to: ovirt-site)
