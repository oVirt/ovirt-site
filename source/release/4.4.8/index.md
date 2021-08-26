---
title: oVirt 4.4.8.1 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.8.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.8.1 release as of August 26, 2021.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.4 (or similar) and CentOS Stream.

> **NOTE**
>
> Starting from oVirt 4.4.6 both oVirt Node and oVirt Engine Appliance are
> based on CentOS Stream.

{:.alert.alert-warning}
Please note that if you are upgrading oVirt Node from previous version you should remove CentOS Linux related yum configuration.
See Bug [1955617 - CentOS Repositories should be removed from yum.repo.d when upgrading to CentOS Stream](https://bugzilla.redhat.com/show_bug.cgi?id=1955617)
For more details.


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

To learn about features introduced before 4.4.8, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.8 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.8 (redeploy in case of already being on 4.4.8).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.8?

### Enhancements

#### oVirt Release Package

 - [BZ 1955375](https://bugzilla.redhat.com/show_bug.cgi?id=1955375) **[cinderlib] Provide cinderlib prerequisites in host and engine installation**

   Feature: 

Automatically install dependencies required for using cinderlib with ceph



Reason:

Currently users are required to manually install cinderlib and ceph dependencies like python3-cinderlib, python3-os-brick (on each host) and ceph-common. To make installation simpler, the dependencies will be installed automatically.



Result: 

Now cinderlib+ceph dependencies are pulled automatically on the ovirt-engine host and vdsm hosts. ceph-common and python3-cinderlib will be installed on the ovirt-engine host, ceph-common and python3-os-brick will be installed on the vdsm hosts.


#### oVirt Engine

 - [BZ 1939286](https://bugzilla.redhat.com/show_bug.cgi?id=1939286) **[RFE] Expose broken Affinity Groups via API too**

   Feature: Expose broken field in affinity groups in rest api



Reason: When using affinity groups, the broken field of affinity group is exposed in the web-admin but is not exposed in rest api

Affinity group is considered broken when any of its rules are not satisfied.



Result: Exposed broken field to be shown as part of affinity group in rest api

 - [BZ 1971317](https://bugzilla.redhat.com/show_bug.cgi?id=1971317) **[RFE][API] Import OVA template as a clone**

   

 - [BZ 1691696](https://bugzilla.redhat.com/show_bug.cgi?id=1691696) **[RFE] multipath events notifications**

   Feature: 

Subscription for Multipath events

Reason: 

Multipath events were introduced in RHV4.2, but there is no way to configure email notifications for these events (neither in UI nor in REST)

Result: 

Added ability to configure email notifications for multipath events - both in UI and in REST

 - [BZ 1963083](https://bugzilla.redhat.com/show_bug.cgi?id=1963083) **[RFE] Support storing user data in VM checkpoint entity**

   This RFE will add the ability to add a 'description' to a backup/checkpoint entity.



So you will be able to send the following request - 



POST /ovirt-engine/api/vms/123/backups



&lt;backup&gt;

    &lt;disks&gt;

       &lt;disk id="456" /&gt;

       …​

    &lt;/disks&gt;

    &lt;description&gt;Eyal's backup&lt;/description&gt;

&lt;/backup&gt;



And when you fetched the created backup from the API (or in the response for the request) you should see - 



&lt;backup id="789"&gt;

    &lt;disks&gt;

       &lt;disk id="456" /&gt;

       …​

       …​

    &lt;/disks&gt;

    &lt;status&gt;initializing&lt;/status&gt;

    &lt;creation_date&gt;

    &lt;description&gt;Eyal's backup&lt;/description&gt;

&lt;/backup&gt;



Same for the checkpoint that was created for that backup - 



&lt;checkpoint id="456"&gt;

     &lt;link href="/ovirt-engine/api/vms/vm-uuid/checkpoints/456/disks" rel="disks"/&gt;

     &lt;parent_id&gt;parent-checkpoint-uuid&lt;/parent_id&gt;

     &lt;creation_date&gt;xxx&lt;/creation_date&gt;

     &lt;description&gt;Eyal's backup&lt;/description&gt;

     &lt;vm href="/ovirt-engine/api/vms/123" id="123"/&gt;

&lt;/checkpoint&gt;

 - [BZ 1946231](https://bugzilla.redhat.com/show_bug.cgi?id=1946231) **[RFE] Support virtual machines with 710 VCPUs**

   The maximum number of vCPUs has been increased to 710 on x86_64 architecture and 4.6 cluster level. Additionally, the limit on the number of CPU sockets has been effectively removed for 4.6 cluster levels.

 - [BZ 1955375](https://bugzilla.redhat.com/show_bug.cgi?id=1955375) **[cinderlib] Provide cinderlib prerequisites in host and engine installation**

   Feature: 

Automatically install dependencies required for using cinderlib with ceph



Reason:

Currently users are required to manually install cinderlib and ceph dependencies like python3-cinderlib, python3-os-brick (on each host) and ceph-common. To make installation simpler, the dependencies will be installed automatically.



Result: 

Now cinderlib+ceph dependencies are pulled automatically on the ovirt-engine host and vdsm hosts. ceph-common and python3-cinderlib will be installed on the ovirt-engine host, ceph-common and python3-os-brick will be installed on the vdsm hosts.

 - [BZ 1941507](https://bugzilla.redhat.com/show_bug.cgi?id=1941507) **[RFE] Implement rotation mechanism for /var/log/ovirt-engine/host-deploy**

   Feature: Implement logrotate for check for updates



Reason: The operation is executed frequently, causing the directory to grow extensively



Result: 

Logs are rotated as follows:

- host deploy, enroll certificates, host upgrade, ova, brick setup and db-manual logs are rotated monthly, and one archived file is kept.

- check for updates is rotated daily, and one archived file is kept.



Compressed files are removed as follows:

- host deploy, enroll certificates, host upgrade and ova logs are removed 30 days from when their metadata was changed.

- check for updates is removed one day from its creation time. 

- brick setup log is removed 30 days from its creation time


#### oVirt Host Dependencies

 - [BZ 1955375](https://bugzilla.redhat.com/show_bug.cgi?id=1955375) **[cinderlib] Provide cinderlib prerequisites in host and engine installation**

   Feature: 

Automatically install dependencies required for using cinderlib with ceph



Reason:

Currently users are required to manually install cinderlib and ceph dependencies like python3-cinderlib, python3-os-brick (on each host) and ceph-common. To make installation simpler, the dependencies will be installed automatically.



Result: 

Now cinderlib+ceph dependencies are pulled automatically on the ovirt-engine host and vdsm hosts. ceph-common and python3-cinderlib will be installed on the ovirt-engine host, ceph-common and python3-os-brick will be installed on the vdsm hosts.


#### oVirt Ansible collection

 - [BZ 1991171](https://bugzilla.redhat.com/show_bug.cgi?id=1991171) **Backup was created by version '4.4.7.7' and can not be restored using the installed version 4.4.7.6**

   Since Red Hat Virtualization 4.4.7, the engine-backup refuses to restore to a version older than the one used for backup. This causes 'hosted-engine --restore-from-file' to fail if the latest appliance is older than the latest Manager. 

In this release, such a scenario does not fail, but prompts the user to connect via SSH to the Manager virtual machine and fix the restore issue.

 - [BZ 1967530](https://bugzilla.redhat.com/show_bug.cgi?id=1967530) **[RFE] Support enabling FIPS on the engine VM**

   Support enabling FIPS on the Self Hosted Engine VM via ansible



Previously the ansible code enabled FIPS on the Self Hosted 

Engine VM only if the user asked to apply an OpenSCAP profile. 



Starting with ovirt-ansible-collection 1.5.4 is now possible to enable FIPS without requiring an OpenSCAP profile.


#### oVirt Hosted Engine Setup

 - [BZ 1967533](https://bugzilla.redhat.com/show_bug.cgi?id=1967533) **[RFE] allow enabling fips on the engine VM**

   Support enabling FIPS on the Self Hosted Engine VM via command line



`hosted-engine --deploy` now also asks `'Do you want to enable FIPS?`

The answer to this question is passed to the ansible code which now supports enabling FIPS without requiring an OpenSCAP profile (bug #1967530)


#### oVirt Engine Data Warehouse

 - [BZ 1980315](https://bugzilla.redhat.com/show_bug.cgi?id=1980315) **Configure Grafana in hosted-engine setup by default**

   With previous versions, hosted-engine deployment didn't configure grafana, and so users had to manually configure it later, which was inconvenient.



With this version, hosted-engine deployment does configure grafana automatically by default.



doc team: Some more details and background:



1. I am writing doc text only for this bug, because that's enough IMO, although the actual needed changes are tracked also in other bugs - 1985927 and 1986393.



2. The current behavior (before fixing this bug) was introduced in 4.4.2, for bug 1866780. That one was about upgrade from 4.3 with dwh on a separate machine. To make the fix for current but not introduce that one, the change is slightly more complex: For new deployments, grafana is always configured (by default), but when restoring from backup (and also as part of upgrade from 4.3, which involves backup/restore), we configure grafana only if dwh was local to the engine machine.



So you might want to mention this in the doc text, if you want - something like "When using hosted-engine with --restore-from-file, grafana is configured only if dwh was configured locally, on the engine machine".



3. I now also filed a doc bug 1987193, for removing this from the documentation.


### Removed functionality

#### OTOPI

 - [BZ 1983047](https://bugzilla.redhat.com/show_bug.cgi?id=1983047) **Remove Java bindings from otopi**

   OTOPI Java bindings have been dropped as not used anymore within the project.


### Bug Fixes

#### VDSM

 - [BZ 1984209](https://bugzilla.redhat.com/show_bug.cgi?id=1984209) **VDSM reports failed snapshot to engine, but it succeeded. Then engine deletes the volume and causes data corruption.**

 - [BZ 1948177](https://bugzilla.redhat.com/show_bug.cgi?id=1948177) **Unknown drive for vm - ignored block threshold event**


#### oVirt Engine

 - [BZ 1993017](https://bugzilla.redhat.com/show_bug.cgi?id=1993017) **Automatic setting of guaranteed memory ignores memory overcommit**

 - [BZ 1987295](https://bugzilla.redhat.com/show_bug.cgi?id=1987295) **Setting host to 'maintenance' will be blocked when there are image transfers with status different then 'paused'**

 - [BZ 1770027](https://bugzilla.redhat.com/show_bug.cgi?id=1770027) **Live Merge completed on the host, but not on the engine, which just waited for it to complete until the operation was terminated.**

 - [BZ 1982296](https://bugzilla.redhat.com/show_bug.cgi?id=1982296) **vCPU maximum CPU calculation is off causing VM's not to boot due to exceeding maximum vcpu of machine type**

 - [BZ 1950767](https://bugzilla.redhat.com/show_bug.cgi?id=1950767) **updating an affinity groups in parallel causes 400 erros and SQL errors**

 - [BZ 1982065](https://bugzilla.redhat.com/show_bug.cgi?id=1982065) **Invalid amount of memory is allowed to be hot plugged**


#### oVirt Hosted Engine HA

 - [BZ 1984356](https://bugzilla.redhat.com/show_bug.cgi?id=1984356) **dns/dig network monitor is too sensitive to network load**


### Other

#### VDSM

 - [BZ 1967413](https://bugzilla.redhat.com/show_bug.cgi?id=1967413) **Logical name doesn't appear in diskattachments and UI immediately after a disk is hot plugged into vm**

   

 - [BZ 1892681](https://bugzilla.redhat.com/show_bug.cgi?id=1892681) **[CBT] VM will be corrupted during full backup if the user performs reboot inside guest OS of the VM**

   

 - [BZ 1757689](https://bugzilla.redhat.com/show_bug.cgi?id=1757689) **Remove memAvailable and memCommitted**

   

 - [BZ 1981307](https://bugzilla.redhat.com/show_bug.cgi?id=1981307) **Skip setting disk thresholds on the destination host during migration**

   


#### oVirt Engine

 - [BZ 1674742](https://bugzilla.redhat.com/show_bug.cgi?id=1674742) **Custom Properties silently removed when changing VM cluster**

   

 - [BZ 1983636](https://bugzilla.redhat.com/show_bug.cgi?id=1983636) **Add "last_updated" column to the "vm_backups" DB table**

   

 - [BZ 1989794](https://bugzilla.redhat.com/show_bug.cgi?id=1989794) **engine still generates duplicate address for hotplug disks**

   

 - [BZ 1966535](https://bugzilla.redhat.com/show_bug.cgi?id=1966535) **NullPointerException when trying to delete uploaded disks with using transfer_url**

   

 - [BZ 1990350](https://bugzilla.redhat.com/show_bug.cgi?id=1990350) **Can't set default time zone via engine-config**

   

 - [BZ 1901572](https://bugzilla.redhat.com/show_bug.cgi?id=1901572) **RHV-M doesn't display guest information of HostedEngine VM**

   Fix a race that lead to having the hosted engine VM with no IP address in the virtual machines list that is presented in the webadmin

 - [BZ 1964496](https://bugzilla.redhat.com/show_bug.cgi?id=1964496) **Host-specific fields of a VM are not updated when dedicated host(s) changes**

   

 - [BZ 1983414](https://bugzilla.redhat.com/show_bug.cgi?id=1983414) **Disks are locked forever when copying VMs' disks after snapshot**

   

 - [BZ 1931982](https://bugzilla.redhat.com/show_bug.cgi?id=1931982) **[RFE] Make timezones configurable**

   

 - [BZ 1757689](https://bugzilla.redhat.com/show_bug.cgi?id=1757689) **Remove memAvailable and memCommitted**

   

 - [BZ 1984424](https://bugzilla.redhat.com/show_bug.cgi?id=1984424) **Incorrect CPUs in the NUMA node for the second hosts's socket**

   

 - [BZ 1983610](https://bugzilla.redhat.com/show_bug.cgi?id=1983610) **Chipset should be set to Q35 if converting from XEN to RHV by v2v rhv-upload**

   

 - [BZ 1973270](https://bugzilla.redhat.com/show_bug.cgi?id=1973270) **[RFE] Make VM sealing configurable**

   

 - [BZ 1983661](https://bugzilla.redhat.com/show_bug.cgi?id=1983661) **[CBT] committing a snapshot after backup tries to clear bitmaps on RAW volumes**

   

 - [BZ 1981158](https://bugzilla.redhat.com/show_bug.cgi?id=1981158) **Trying to assign i915-GVTg_V5_4 vgpu appears to fail due to bad regex matching**

   

 - [BZ 1963715](https://bugzilla.redhat.com/show_bug.cgi?id=1963715) **[RFE] Export/import VMs/templates with NVRAM**

   

 - [BZ 1853501](https://bugzilla.redhat.com/show_bug.cgi?id=1853501) **[RFE] Add column with storage domain in the "Storage -&gt; Disks" page**

   

 - [BZ 1978253](https://bugzilla.redhat.com/show_bug.cgi?id=1978253) **OGA memory report isn't shown in the VM general tab**

   


#### cockpit-ovirt

 - [BZ 1959904](https://bugzilla.redhat.com/show_bug.cgi?id=1959904) **Cockpit UI need to be proper  alignment  while deployment**

   


### No Doc Update

#### VDSM

 - [BZ 1962563](https://bugzilla.redhat.com/show_bug.cgi?id=1962563) **[RFE] Use nmstate for source routing**

   


#### oVirt Engine

 - [BZ 1958398](https://bugzilla.redhat.com/show_bug.cgi?id=1958398) **"This VM has no graphic display device" error after upgrade from RHV 4.3 to RHV 4.4 for some VMs**

   

 - [BZ 1979539](https://bugzilla.redhat.com/show_bug.cgi?id=1979539) **[RHHI] Upgrading RHVH hyperconverged host from Admin portal fails for first host**

   

 - [BZ 1975225](https://bugzilla.redhat.com/show_bug.cgi?id=1975225) **Occasional failures to export VM to OVA**

   

 - [BZ 1974656](https://bugzilla.redhat.com/show_bug.cgi?id=1974656) **[Rest API] Event search template filter throws SQL error**

   


#### oVirt Ansible collection

 - [BZ 1977486](https://bugzilla.redhat.com/show_bug.cgi?id=1977486) **Duplicate tasks execution when using hosted-engine --deploy**

   


#### oVirt Engine Appliance

 - [BZ 1985927](https://bugzilla.redhat.com/show_bug.cgi?id=1985927) **Configure Grafana in hosted-engine setup by default**

   


#### Contributors

39 people contributed to this release:

	Ales Musil (Contributed to: ovirt-provider-ovn, ovirt-release, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-ansible-collection, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine-metrics)
	Aviv Turgeman (Contributed to: cockpit-ovirt)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-host, ovirt-release)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dominik Holler (Contributed to: ovirt-provider-ovn)
	Ehud Yonasi (Contributed to: python-ovirt-engine-sdk4)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, ovirt-engine-sdk, vdsm)
	Filip Januska (Contributed to: ovirt-engine)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-engine, ovirt-node-ng-image, ovirt-release, vdsm)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Mark Kemel (Contributed to: ovirt-engine)
	Martin Nečas (Contributed to: ovirt-ansible-collection, python-ovirt-engine-sdk4)
	Martin Perina (Contributed to: ovirt-engine)
	Michal Skrivanek (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nijin Ashok (Contributed to: ovirt-ansible-collection)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Pavel Bar (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Radoslaw Szwajkowski (Contributed to: ovirt-web-ui)
	Ritesh Chikatwar (Contributed to: cockpit-ovirt, ovirt-engine)
	Roman Bednar (Contributed to: vdsm)
	Saif Abu Saleh (Contributed to: ovirt-engine, vdsm)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, otopi, ovirt-appliance, ovirt-engine, ovirt-host, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-release)
	Scott J Dickerson (Contributed to: ovirt-engine-nodejs-modules, ovirt-web-ui)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-web-ui)
	Shirly Radco (Contributed to: ovirt-engine-metrics)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtěch Juránek (Contributed to: ovirt-ansible-collection, vdsm)
	Yedidyah Bar David (Contributed to: otopi, ovirt-ansible-collection, ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-hosted-engine-ha)
