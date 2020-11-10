---
title: oVirt 4.4.3 Release Notes
category: documentation
authors: lveyde sandrobonazzola
toc: true
page_classes: releases
---

# oVirt 4.4.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.3 release as of November 10, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.2/8.3 (8.3 recommended) and
CentOS Linux 8.2 (or similar).

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

To learn about features introduced before 4.4.3, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**, 

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.3 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.3 (redeploy in case of already being on 4.4.3).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.3?

### Release Note

#### oVirt Engine

 - [BZ 1888626](https://bugzilla.redhat.com/1888626) **Require ansible-2.9.14 in ovirt-engine**

   Ansible-2.9.14 is required for proper setup and functioning of Red Hat Virtualization Manager 4.4.3.

 - [BZ 1824103](https://bugzilla.redhat.com/1824103) **Lifespan of certificates created by oVirt engine CA should not exceed 398 days**

   Up until 4.4.3 RHV used below validity lifetime for certificates:



1. CA certificate - 10 years

2. RHV Manager HTTPS certificate - 5 years

3. RHV hypervisors certificates 5 - years



But due recent efforts to reduce certificate lifetime [1][2] we have decided to shorten RHV certificate lifetime to align with those suggestions:



1. CA certificate - 10 years (no change)

2. RHV Manager HTTPS certificate - 398 days

3. RHV hypervisors certificates 398 days



This change doesn't affect existing certificates, it will be applied only on newly created certificates in RHV 4.4.3 and newer.



We have also discussed to shorten RHV CA certificate lifetime, but we have decided not to change the lifetime, because expiring CA certificate requires reenrolling certificates for all hosts, which means that all hosts needs to go to Maintenance status and this is very disruptive operation.



[1] https://cabforum.org/2019/09/10/ballot-sc22-reduce-certificate-lifetimes-v2/

[2] https://www.thesslstore.com/blog/ssl-certificate-validity-will-be-limited-to-one-year-by-apples-safari-browser/


### Enhancements

#### oVirt Engine

 - [BZ 1177156](https://bugzilla.redhat.com/1177156) **[RFE] Ability to clone a running VM directly from GUI**

   

 - [BZ 1752751](https://bugzilla.redhat.com/1752751) **[RFE] Show vCPUs and allocated memory in virtual machines summary**

   Features delivered under this issue (by their importance): 



1. Chosen grid settings (column visibility and order) are now by default persisted on the server. Existing settings will be migrated (uploaded) to the server. Functionality can be disabled by de-selecting checkbox 'Persist grid settings' in the Options pop-up (see screenshot).



2. It's now possible to reset grid settings - this option is now available via newly added action button (kebab button) in the top right corner of the grid (check animated gif for details)



3. Two new columns were added to Virtual Machine screen: number  of vCPUs and Memory in MB (see the screenshot for exact labels). Columns are hidden by default. User may show them by using column context menu (existing feature: pop-up triggered by right click on any column header) or by action "Change column visibility/order" (via kebab button added as part of this story - see screenshots).

 - [BZ 1862968](https://bugzilla.redhat.com/1862968) **[RFE] auto-set cpu and numa to a vm for best performance**

   This feature will introduce a way to automatically set the CPU and NUMA pinning of a VM.

Currently, it is optional to do so when adding a VM using REST-API only.

The new value is: auto_pinning_policy. It can be set to `existing`, using the current topology of the VM's CPU. Or, it can be set to `adjust`, using the dedicated host CPU topology, changing it accordingly to the VM.

The result will provide a better performance to that VM.

 - [BZ 1568461](https://bugzilla.redhat.com/1568461) **[RFE] Kernel address space layout randomization [KASLR] support**

   

 - [BZ 1881119](https://bugzilla.redhat.com/1881119) **[RFE] Make engine-backup refuse to restore a backup from a version earlier than 4.3.10**

   engine-backup now refuses to restore a backup taken with a version earlier than 4.3.10, to prevent a missing cinderlib database on restore - as cinderlib database backup was added on in 4.3.10.

 - [BZ 1797717](https://bugzilla.redhat.com/1797717) **Search backend cannot find VMs which name starts with a search keyword**

   Feature: 



Enable to use a keyword in a free text search in search engine.



Search engine enables to enter free text pattern in a search expression, this

kind of search looks for the pattern on all the entity fields.



In the case that the free text pattern starts with a keyword (column

name) that is related to the searched entity, search engine fails to

find the expected results and generates an error.



For example, if you have a cluster named "namedCluster" and you are

searching for "Cluster:name*" , you will get an empty result and an

error complaining on illegal search, also if you are doing that from UI ,

you will see that the character '*' is marked with red.



Reason: 



search engine should enable to search for entity column values that are prefixed with a keyword



Result: 



Support for search for entity column values that are prefixed with a keyword was added

 - [BZ 1657294](https://bugzilla.redhat.com/1657294) **[RFE] - enable renaming HostedEngine VM name**

   Feature: 

Let the user specify a custom name for the engine VM

 - [BZ 1828347](https://bugzilla.redhat.com/1828347) **[RFE] support virtio-win flows in 4.4**

   Previously, you used Windows Guest Tools to install the required drivers for virtual machines running Microsoft Windows. Now, RHV version 4.4 uses VirtIO-Win to provide these drivers. For clusters with a compatibility level of 4.4 and later, the engine sign of the guest-agent depends on the available VirtIO-Win. The auto-attaching of a driver ISO is dropped in favor of Microsoft Windows updates. However, the initial installation needs to be done manually.

 - [BZ 1854888](https://bugzilla.redhat.com/1854888) **RHV-M shows successful operation if OVA export/import failed during "qemu-img convert" phase**

   Feature: Added error handling for ova importing and exporting.



Reason: When the qemu-img process failed, the engine was reporting a successful completion of the process when the process actually failed.



Result: Now when the qemu-img process fails to compete, the failure is detected and reported to the engine which fails appropriately.


#### oVirt Engine Data Warehouse

 - [BZ 1851029](https://bugzilla.redhat.com/1851029) **[RFE] Add to time based queries the samples table**

   Previously, time-based Grafana reports did not include the most recent two to three hours of sample data. With this update, you can now view sample data from that time period.



For example, if you ran the report at 11:54, the report had data only until 9:00. Now the report has data until 11:54.


### Removed functionality

#### VDSM

 - [BZ 1853320](https://bugzilla.redhat.com/1853320) **[Code change] Remove setup networks based on network-scripts**

   


### Bug Fixes

#### VDSM

 - [BZ 1877632](https://bugzilla.redhat.com/1877632) **VM stuck in Migrating status after migration completed due to incorrect status reported by VDSM after restart**

 - [BZ 1883446](https://bugzilla.redhat.com/1883446) **[Upgrade] migration of VMs from a 4.3 host with rhel-7.9 to v4.4.3 host with rhel-8.3 fails**

 - [BZ 1883483](https://bugzilla.redhat.com/1883483) **Engine HotUnplugs the same memory device multiple times when it's requested to HotUnplug multiple memory devices in given size**

 - [BZ 1870500](https://bugzilla.redhat.com/1870500) **Some of the qemu-ga commands do not block anymore**

 - [BZ 1800966](https://bugzilla.redhat.com/1800966) **HA VMs are not restarted in case of host reboot**

 - [BZ 1870108](https://bugzilla.redhat.com/1870108) **VM devices may get temporarily unplugged on VM boot**


#### oVirt Engine database query tool

 - [BZ 1866981](https://bugzilla.redhat.com/1866981) **obj must be encoded before hashing**


#### oVirt Engine

 - [BZ 1894576](https://bugzilla.redhat.com/1894576) **Warning mentioning engine being at version 4.5 leads to a nightmare path upgrading the cluster ending with a dead datacenter**

 - [BZ 1890635](https://bugzilla.redhat.com/1890635) **Fail to deploy stand-alone Engine due to missing 'exportfs'**

 - [BZ 1702016](https://bugzilla.redhat.com/1702016) **Block moving HE hosts into different Data Centers and make HE host moved to different cluster NonOperational after activation**

 - [BZ 1871694](https://bugzilla.redhat.com/1871694) **HostedEngine VM is broken after Cluster changed to UEFI**

 - [BZ 1871819](https://bugzilla.redhat.com/1871819) **Prepare default OVN configuration for scaling scenarios**

 - [BZ 1879373](https://bugzilla.redhat.com/1879373) **grafana backup might fail**

 - [BZ 1760170](https://bugzilla.redhat.com/1760170) **If an in-use MAC is held by a VM on a different cluster, the engine does not attempt to get the next free MAC.**

 - [BZ 1881307](https://bugzilla.redhat.com/1881307) **Can't update cluster's MAC pool if the cluster contain template with vNIC**

 - [BZ 1855305](https://bugzilla.redhat.com/1855305) **Cannot hotplug disk reports libvirtError: Requested operation is not valid: Domain already contains a disk with that address**

 - [BZ 1869317](https://bugzilla.redhat.com/1869317) **SCSI Hostdev Passthrough: VM snapshot is dropping attached scsi_hostdev.**

 - [BZ 1855249](https://bugzilla.redhat.com/1855249) **noVNC console via websocket with separated host doesn't work in chrome**

 - [BZ 1873322](https://bugzilla.redhat.com/1873322) **Engine fails to properly import ppc64le VMs from storage domain classifying it as x86_64**

 - [BZ 1874519](https://bugzilla.redhat.com/1874519) **Block CPU hotplug on UEFI**

 - [BZ 1872383](https://bugzilla.redhat.com/1872383) **Uploading disks via the upload_disk script fails due to an engine regression.**

 - [BZ 1632068](https://bugzilla.redhat.com/1632068) **Cannot import VM from KVM without ISO Domain active**

 - [BZ 1808320](https://bugzilla.redhat.com/1808320) **[Permissions] DataCenterAdmin role defined on DC level does not allow Cluster creation**


#### oVirt Provider OVN

 - [BZ 1871819](https://bugzilla.redhat.com/1871819) **Prepare default OVN configuration for scaling scenarios**

 - [BZ 1835550](https://bugzilla.redhat.com/1835550) **ovirt-provider-ovn takes more than ExternalNetworkProviderTimeout to respond to engine requests**


#### oVirt Ansible collection

 - [BZ 1821425](https://bugzilla.redhat.com/1821425) **Hosted Engine deployment is using wrong size/space checks**

 - [BZ 1871694](https://bugzilla.redhat.com/1871694) **HostedEngine VM is broken after Cluster changed to UEFI**


#### oVirt Engine Data Warehouse

 - [BZ 1846365](https://bugzilla.redhat.com/1846365) **Handle grafana in ovirt-engine-rename**

 - [BZ 1861368](https://bugzilla.redhat.com/1861368) **grafana startup may take some time**


#### imgbased

 - [BZ 1883195](https://bugzilla.redhat.com/1883195) **/etc/multipath/conf.d is not copied correctly**


### Other

#### VDSM

 - [BZ 1891520](https://bugzilla.redhat.com/1891520) **Moving or copying raw preallocated disk to file storage make the disk sparse**

   

 - [BZ 1861674](https://bugzilla.redhat.com/1861674) **[CBT] Report backup mode (full or incremental) for disks that participates in the VM backup**

   A new field added to a disk, this field called 'backup_mode'.



The backup_mode is used only if the disk is part of a backup operation, otherwise, the backup_mode will be 'NULL'.



If the disk is part of a running backup, the backup_mode can have one of the two options - 



 - full - if the backup that was taken for the disk was a 

   full backup.



 - incremental - if the backup that was taken for the disk 

   was an incremental backup.



This will allow the engine to create a backup for a VM that contains both full for the disks that were not part of the previous backup and incremental backup for the disks that already backed up in the previous backup.



The user can check the disk's backup_mode and download the backup using the right method in imageio according to it.

 - [BZ 1809102](https://bugzilla.redhat.com/1809102) **Enable OVS switch type for nmstate managed hosts**

   

 - [BZ 1725166](https://bugzilla.redhat.com/1725166) **[RFE] Private VLAN / port isolation**

   

 - [BZ 1861671](https://bugzilla.redhat.com/1861671) **[CBT] Copy bitmaps to the new volume during storage migration when the VM contains incremental backups**

   When migrating a disk that belongs to a VM that contains the VM's full or incremental backups, all the backup bitmaps will be removed when the disk migration is done.



The fix for this bug will copy all the disk's bitmaps during the disk migration from one storage domain to another.

 - [BZ 1834233](https://bugzilla.redhat.com/1834233) **While Start or Reboot VM - It takes a long time till VM status is 'UP'**

   

 - [BZ 1858230](https://bugzilla.redhat.com/1858230) **Errors related to GlusterHook.read seen in engine.log**

   

 - [BZ 1863058](https://bugzilla.redhat.com/1863058) **LVs still active after putting host into maintenance**

   

 - [BZ 1861667](https://bugzilla.redhat.com/1861667) **[CBT] Copy all bitmaps from the previous top layer to the new layer when cold snapshot is taken for a VM that contains incremental backups**

   When creating a snapshot while the VM is not running, the host needs to copy the bitmaps chain from the base volume to the newly created top volume.



The copy of the bitmaps is done using the new 'qemu-img bitmaps' command.



This operation is transparent to the user.

 - [BZ 1870148](https://bugzilla.redhat.com/1870148) **Cannot bond a NIC with vlan tagged network attachment**

   

 - [BZ 1871348](https://bugzilla.redhat.com/1871348) **Cannot transfer images from admin portal or via using proxy_url in SDK with all-in-one setup**

   

 - [BZ 1871202](https://bugzilla.redhat.com/1871202) **List of users logged into guest OS is not reset on logout**

   


#### oVirt Engine

 - [BZ 1891306](https://bugzilla.redhat.com/1891306) **Live cloning is failing**

   

 - [BZ 1892242](https://bugzilla.redhat.com/1892242) **Wrong snapshot disk href**

   

 - [BZ 1890010](https://bugzilla.redhat.com/1890010) **Exception when listing disk snapshots under storage domain**

   

 - [BZ 1861674](https://bugzilla.redhat.com/1861674) **[CBT] Report backup mode (full or incremental) for disks that participates in the VM backup**

   A new field added to a disk, this field called 'backup_mode'.



The backup_mode is used only if the disk is part of a backup operation, otherwise, the backup_mode will be 'NULL'.



If the disk is part of a running backup, the backup_mode can have one of the two options - 



 - full - if the backup that was taken for the disk was a 

   full backup.



 - incremental - if the backup that was taken for the disk 

   was an incremental backup.



This will allow the engine to create a backup for a VM that contains both full for the disks that were not part of the previous backup and incremental backup for the disks that already backed up in the previous backup.



The user can check the disk's backup_mode and download the backup using the right method in imageio according to it.

 - [BZ 1825020](https://bugzilla.redhat.com/1825020) **[RFE] RHV-M Deployment/Install Needs it's own UUID**

   

 - [BZ 1358295](https://bugzilla.redhat.com/1358295) **[i18n][ALL_LANG] wrong translation of error message canceling operation**

   

 - [BZ 1804675](https://bugzilla.redhat.com/1804675) **[ja_JP] Text alignment correction needed on administration -> configure -> instance type -> add page**

   

 - [BZ 1829691](https://bugzilla.redhat.com/1829691) **Engine adding PCI-E elements on XML of i440FX SeaBIOS VM created from Q35 Template**

   

 - [BZ 1877668](https://bugzilla.redhat.com/1877668) **model_Cascadelake-Server-noTSX (cpu flag) is missing from vdc_options table**

   

 - [BZ 1854000](https://bugzilla.redhat.com/1854000) **Updating storage domain throws error dialog, but the path information gets updated**

   

 - [BZ 1881325](https://bugzilla.redhat.com/1881325) **CPU Type Bug With Coffee Lake CPU.**

   

 - [BZ 1879030](https://bugzilla.redhat.com/1879030) **The import_vm_from_ova.py example script fails when specifying the cluster name**

   

 - [BZ 1863051](https://bugzilla.redhat.com/1863051) **[RFE] Allow management of permissions of MAC Address Pools via REST-API**

   

 - [BZ 1887202](https://bugzilla.redhat.com/1887202) **Disk.reduce() allowed on active image, possibly corrupting disk**

   

 - [BZ 1809102](https://bugzilla.redhat.com/1809102) **Enable OVS switch type for nmstate managed hosts**

   

 - [BZ 1876234](https://bugzilla.redhat.com/1876234) **Expose OVA's OVF via the API**

   

 - [BZ 1861671](https://bugzilla.redhat.com/1861671) **[CBT] Copy bitmaps to the new volume during storage migration when the VM contains incremental backups**

   When migrating a disk that belongs to a VM that contains the VM's full or incremental backups, all the backup bitmaps will be removed when the disk migration is done.



The fix for this bug will copy all the disk's bitmaps during the disk migration from one storage domain to another.

 - [BZ 1881471](https://bugzilla.redhat.com/1881471) **Hosted Engine VM gets devices unplugged**

   

 - [BZ 1856671](https://bugzilla.redhat.com/1856671) **[RFE] Expose the "reinstallation required" flag of the hosts in the API**

   

 - [BZ 1884634](https://bugzilla.redhat.com/1884634) **[CNV&RHV] Disable creating new disks for Kubevirt VM**

   

 - [BZ 1861667](https://bugzilla.redhat.com/1861667) **[CBT] Copy all bitmaps from the previous top layer to the new layer when cold snapshot is taken for a VM that contains incremental backups**

   When creating a snapshot while the VM is not running, the host needs to copy the bitmaps chain from the base volume to the newly created top volume.



The copy of the bitmaps is done using the new 'qemu-img bitmaps' command.



This operation is transparent to the user.

 - [BZ 1883844](https://bugzilla.redhat.com/1883844) **[CNV&RHV] Remove warning about no active storage domain for Kubevirt VMs**

   

 - [BZ 1725166](https://bugzilla.redhat.com/1725166) **[RFE] Private VLAN / port isolation**

   

 - [BZ 1438386](https://bugzilla.redhat.com/1438386) **[RFE] - provide a way for the user to replace host which has both virt and gluster services enabled  from UI**

   

 - [BZ 1859586](https://bugzilla.redhat.com/1859586) **[HE] Re-deploying HE on host leaves host in state=LocalMaintenance with score=0 indefinitely**

   

 - [BZ 1855291](https://bugzilla.redhat.com/1855291) **'Enable KSM' is not set by default on new created clusters while for Default cluster it is set.**

   

 - [BZ 1659829](https://bugzilla.redhat.com/1659829) **[Backup restore API] Preview snapshot operation, while the VM has a snapshot disk attached, fails with NullPointerException and leaves the snapshot and a disk in status LOCKED. The VM cannot be started**

   

 - [BZ 1865923](https://bugzilla.redhat.com/1865923) **Cannot remove existing virtual disks in the clone modal (Admin portal)**

   

 - [BZ 1880972](https://bugzilla.redhat.com/1880972) **UI exception when viewing and sorting VMs via VMs > Network Interfaces > up and down with keyboard**

   

 - [BZ 1792870](https://bugzilla.redhat.com/1792870) **[RFE] Display cluster ID in cluster view**

   

 - [BZ 1873112](https://bugzilla.redhat.com/1873112) **Cannot update cluster chipset/firmware type if the cluster contains templates**

   

 - [BZ 1846350](https://bugzilla.redhat.com/1846350) **Extra white space and over-stretched components in WebAdmin dialogues - Storage dialogs**

   

 - [BZ 1862785](https://bugzilla.redhat.com/1862785) **Update "USB Policy" and "USB Support" to match each other**

   

 - [BZ 1871348](https://bugzilla.redhat.com/1871348) **Cannot transfer images from admin portal or via using proxy_url in SDK with all-in-one setup**

   

 - [BZ 1869359](https://bugzilla.redhat.com/1869359) **Q35 Fixups**

   

 - [BZ 1873136](https://bugzilla.redhat.com/1873136) **[CNV&RHV]Notification about VM creation contain <UNKNOWN> string**

   

 - [BZ 1854034](https://bugzilla.redhat.com/1854034) **Show bios type in VM/Template/Pool general information**

   

 - [BZ 1822372](https://bugzilla.redhat.com/1822372) **Adding quota to group doesn't propagate to users**

   

 - [BZ 1872602](https://bugzilla.redhat.com/1872602) **Incorrect storage consumption on Quota list page**

   

 - [BZ 1828333](https://bugzilla.redhat.com/1828333) **Can't resume an upload after it has been paused**

   

 - [BZ 1862722](https://bugzilla.redhat.com/1862722) **Remove unused ImageTransfer.signed_ticket**

   

 - [BZ 1836034](https://bugzilla.redhat.com/1836034) **Cannot switch Master to hosted_storage**

   

 - [BZ 1857148](https://bugzilla.redhat.com/1857148) **OVA import (exported from the same 4.4 cluster) is not using the correct BIOS Type.**

   


#### oVirt Ansible collection

 - [BZ 1850028](https://bugzilla.redhat.com/1850028) **[HE] Can't deploy HE with uppercase characters in the HE-VM MAC address**

   


#### oVirt Engine Data Warehouse

 - [BZ 1874880](https://bugzilla.redhat.com/1874880) **Update column settings to contain only relevant columns**

   

 - [BZ 1878496](https://bugzilla.redhat.com/1878496) **Add delete_date columns to uptime dashboard**

   

 - [BZ 1877706](https://bugzilla.redhat.com/1877706) **PostgreSQL 12 in oVirt 4.4 - engine-setup menu ref URL needs updating**

   

 - [BZ 1877280](https://bugzilla.redhat.com/1877280) **Remove time picker in hosts and vms inventory dashboard**

   

 - [BZ 1876802](https://bugzilla.redhat.com/1876802) **Adding a missing alias to a column settings**

   

 - [BZ 1874029](https://bugzilla.redhat.com/1874029) **Missing column in inventory dashboard**

   

 - [BZ 1873087](https://bugzilla.redhat.com/1873087) **Update reports that count to display the exact number**

   

 - [BZ 1866356](https://bugzilla.redhat.com/1866356) **Update the dashboards default time period**

   


#### IOProcess

 - [BZ 1777805](https://bugzilla.redhat.com/1777805) **Improve logging during block size detections**

   


#### oVirt Hosted Engine HA

 - [BZ 1860927](https://bugzilla.redhat.com/1860927) **Parsing the output from "hosted-engine --vm-start" is wrong**

   

 - [BZ 1857793](https://bugzilla.redhat.com/1857793) **Global Maintenance by cli causes penalizing score of the host with HE VM on it.**

   


#### oVirt Hosted Engine Setup

 - [BZ 1891521](https://bugzilla.redhat.com/1891521) **Failed to add block storage on RHEL 8.3 during HE deployment.**

   


#### oVirt Engine Metrics

 - [BZ 1870133](https://bugzilla.redhat.com/1870133) **Issue with dashboards creation when sending metrics to external Elasticsearch**

   


#### cockpit-ovirt

 - [BZ 1885119](https://bugzilla.redhat.com/1885119) **[RHHI] - different disk for different hosts (playbook for gluster deployment is generated wrong)**

   

 - [BZ 1850439](https://bugzilla.redhat.com/1850439) **cockpit ovirt(upstream) docs links point to downstream docs.**

   

 - [BZ 1816737](https://bugzilla.redhat.com/1816737) **when running installation of hosted engine again, /var/tmp is full**

   


#### ovirt-imageio

 - [BZ 1862719](https://bugzilla.redhat.com/1862719) **Remove python 2 leftovers**

   


#### oVirt Engine UI Extensions

 - [BZ 1870718](https://bugzilla.redhat.com/1870718) **Keep dialogs consistent with GWT by locating the primary action button to the left of the secondary action button**

   

 - [BZ 1851865](https://bugzilla.redhat.com/1851865) **[RFE] Destination Host in migrate VM dialog has to be searchable and sortable**

   

 - [BZ 1358295](https://bugzilla.redhat.com/1358295) **[i18n][ALL_LANG] wrong translation of error message canceling operation**

   


#### oVirt Web UI

 - [BZ 1358295](https://bugzilla.redhat.com/1358295) **[i18n][ALL_LANG] wrong translation of error message canceling operation**

   


#### oVirt Engine Appliance

 - [BZ 1868597](https://bugzilla.redhat.com/1868597) **mod_auth_openidc package missing on upgrade**

   


### No Doc Update

#### VDSM

 - [BZ 1861673](https://bugzilla.redhat.com/1861673) **[CBT] Copy bitmaps from deleted layer (top) to the base when cold merge operation is done on a  VM that contains incremental backups**

   

 - [BZ 1729222](https://bugzilla.redhat.com/1729222) **VDSM should depend on fence-agents-all which doesn't require telnet package**

   

 - [BZ 1835650](https://bugzilla.redhat.com/1835650) **[security] selecting STIG profile cause host to be unusable due to indirect dependency on telnet**

   

 - [BZ 1751520](https://bugzilla.redhat.com/1751520) **[logging] filter "RPC call" logs**

   

 - [BZ 1826365](https://bugzilla.redhat.com/1826365) **LSM for ISCSI disk size smaller than 1GB created with API fails**

   

 - [BZ 1876605](https://bugzilla.redhat.com/1876605) **VM with scsi hostdev (scsi_generic custom property) fails on start:'node-name too long for qemu'**

   

 - [BZ 1857347](https://bugzilla.redhat.com/1857347) **Live merge in endless loop trying to pivot after unrecoverable error from libvirt**

   

 - [BZ 1876230](https://bugzilla.redhat.com/1876230) **LSM fails on CreateLiveSnapshotForVmCommand - Unable to prepare the volume path for disk vdb**

   


#### oVirt Engine

 - [BZ 1887893](https://bugzilla.redhat.com/1887893) **[REST-API] all_content ignored when specified as query parameter**

   

 - [BZ 1887268](https://bugzilla.redhat.com/1887268) **Cannot perform yum update on my RHV manager (ansible conflict)**

   

 - [BZ 1861673](https://bugzilla.redhat.com/1861673) **[CBT] Copy bitmaps from deleted layer (top) to the base when cold merge operation is done on a  VM that contains incremental backups**

   

 - [BZ 1842344](https://bugzilla.redhat.com/1842344) **Status loop due to host initialization not checking network status, monitoring finding the network issue and auto-recovery.**

   

 - [BZ 1826365](https://bugzilla.redhat.com/1826365) **LSM for ISCSI disk size smaller than 1GB created with API fails**

   

 - [BZ 1881958](https://bugzilla.redhat.com/1881958) **Non admin users behave as admin users and have their permissions**

   

 - [BZ 1877679](https://bugzilla.redhat.com/1877679) **Synchronize advanced virtualization module with RHEL version during host upgrade**

   

 - [BZ 1857722](https://bugzilla.redhat.com/1857722) **[scale]  ovirt_root partition become full due to "artifacts" folder**

   

 - [BZ 1880962](https://bugzilla.redhat.com/1880962) **Upgrade of host is very slow after 4.4.2 upgrade**

   

 - [BZ 1871128](https://bugzilla.redhat.com/1871128) **CVE-2020-14333 ovirt-engine: Reflected cross site scripting vulnerability**

   

 - [BZ 1877279](https://bugzilla.redhat.com/1877279) **dwh status is overwritten by engine-setup**

   

 - [BZ 1876923](https://bugzilla.redhat.com/1876923) **PostgreSQL 12 in RHV 4.4 - engine-setup menu ref URL needs updating**

   

 - [BZ 1874631](https://bugzilla.redhat.com/1874631) **Tidy up and improve fix for bug 1755518**

   

 - [BZ 1872441](https://bugzilla.redhat.com/1872441) **inconsistent result set between views without tag information and views with tag information**

   

 - [BZ 1872911](https://bugzilla.redhat.com/1872911) **RHV Administration Portal fails with 404 error even after updating to RHV 4.3.9**

   

 - [BZ 1858638](https://bugzilla.redhat.com/1858638) **[Scale] Poor Performing VM search by cluster_name and partial host name**

   

 - [BZ 1686280](https://bugzilla.redhat.com/1686280) **[cinderLib] - Kaminario backend- CloneVM fails and non managed disk does not roll back and remains in "LOCKED' state**

   

 - [BZ 1828241](https://bugzilla.redhat.com/1828241) **Deleting snapshot do not display a lock for it's disks under "Disk Snapshots" tab.**

   

 - [BZ 1683573](https://bugzilla.redhat.com/1683573) **[CinderLib] - remove managed block disks from VM which have a template create from it fails - USER_REMOVE_VM_FINISHED_WITH_ILLEGAL_DISKS**

   


#### oVirt Ansible collection

 - [BZ 1844965](https://bugzilla.redhat.com/1844965) **engine logs are not copied**

   

 - [BZ 1887142](https://bugzilla.redhat.com/1887142) **[4.4.3-8] failed to update packages in deploy because of new ansible-2.9.14 is available when we have version lock on ansible-2.9.13**

   


#### oVirt Engine Data Warehouse

 - [BZ 1853252](https://bugzilla.redhat.com/1853252) **Modifying the variables to include all deleted entities**

   


#### ovirt-engine-extension-logger-log4j

 - [BZ 1877312](https://bugzilla.redhat.com/1877312) **package contains wrong symlink to log4j.jar**

   


#### oVirt Hosted Engine Setup

 - [BZ 1892378](https://bugzilla.redhat.com/1892378) **engine logs are not copied**

   

 - [BZ 1859922](https://bugzilla.redhat.com/1859922) **Local Maintenance by cli and restarting ovirt-ha-agent.service causes 0 score of the host with HE vm on it**

   


#### oVirt Engine Metrics

 - [BZ 1889522](https://bugzilla.redhat.com/1889522) **metrics playbooks are broken due to typo**

   

 - [BZ 1862134](https://bugzilla.redhat.com/1862134) **Update the metrics role based on the released linux-system-roles logging role**

   


#### oVirt Log Collector

 - [BZ 1877479](https://bugzilla.redhat.com/1877479) **ovirt-log-collector fails to gather hosts' info with latest sos**

   


#### cockpit-ovirt

 - [BZ 1885140](https://bugzilla.redhat.com/1885140) **Scroll bar disappears after clicking "No" in "Exit Wizard"**

   


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1879199](https://bugzilla.redhat.com/1879199) **ovirt-engine-extension-aaa-ldap-setup fails on cert import**

   

 - [BZ 1691253](https://bugzilla.redhat.com/1691253) **ovirt-engine-extension-aaa-ldap-setup does not escape special characters in password**

   


#### Contributors

71 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Alan Rominger (Contributed to: ovirt-ansible-collection)
	Ales Musil (Contributed to: ovirt-engine, ovirt-release, vdsm)
	Amit Bawer (Contributed to: ovirt-engine, vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-ansible-collection, ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: cockpit-ovirt, ovirt-ansible-collection, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine-metrics)
	Aviv Turgeman (Contributed to: cockpit-ovirt)
	Baptiste Mille-Mathias (Contributed to: ovirt-ansible-collection)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-web-ui)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Brian Ward (Contributed to: ovirt-ansible-collection)
	Christopher Brown (Contributed to: ovirt-ansible-collection)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Daniel Erez (Contributed to: ovirt-engine-sdk)
	Darin (Contributed to: ovirt-ansible-collection)
	Dominik Holler (Contributed to: ovirt-engine, ovirt-provider-ovn, vdsm)
	Douglas Schilling Landgraf (Contributed to: engine-db-query, ovirt-log-collector)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine, vdsm)
	Evgheni Dereveanchin (Contributed to: ovirt-release)
	Eyal Shenitzky (Contributed to: ioprocess, ovirt-engine, ovirt-engine-sdk, vdsm)
	Gal Zaidman (Contributed to: cockpit-ovirt)
	Germano Veit Michel (Contributed to: vdsm)
	Hilda Stastna (Contributed to: ovirt-engine-ui-extensions, ovirt-web-ui)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Kaustav Majumder (Contributed to: vdsm)
	Kedar Kulkarni (Contributed to: ovirt-ansible-collection)
	Klett IT (Contributed to: ovirt-ansible-collection)
	Kobi Hakimi (Contributed to: ovirt-ansible-collection)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-dwh, ovirt-engine, ovirt-hosted-engine-setup, ovirt-log-collector, ovirt-node-ng-image, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-engine-ui-extensions)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-engine-extension-aaa-ldap, ovirt-engine-extension-logger-log4j, ovirt-engine-sdk)
	Michal Skrivanek (Contributed to: ovirt-engine, ovirt-engine-metrics)
	Miguel Martín (Contributed to: ovirt-engine-extension-aaa-ldap)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nijin Ashok (Contributed to: ovirt-ansible-collection)
	Nir Levy (Contributed to: imgbased, ovirt-node-ng-image)
	Nir Soffer (Contributed to: ioprocess, ovirt-engine, ovirt-engine-sdk, ovirt-imageio, vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Pavel Bar (Contributed to: ioprocess, ovirt-ansible-collection)
	Pierre Lecomte (Contributed to: ovirt-engine)
	Prajith Kesava Prasad (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Reto Gantenbein (Contributed to: ovirt-ansible-collection)
	Sandro Bonazzola (Contributed to: engine-db-query, ovirt-appliance, ovirt-engine, ovirt-engine-metrics, ovirt-engine-sdk, ovirt-hosted-engine-setup, ovirt-log-collector, ovirt-node-ng-image, ovirt-release)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Sean Sackowitz (Contributed to: ovirt-ansible-collection)
	Shani Leviim (Contributed to: ovirt-engine, vdsm)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shirly Radco (Contributed to: ovirt-dwh, ovirt-engine-metrics)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Shubha Kulkarni (Contributed to: ovirt-engine)
	Simone Tiraboschi (Contributed to: ovirt-engine)
	Sloane Hertel (Contributed to: ovirt-ansible-collection)
	Steven Rosenberg (Contributed to: ovirt-engine, ovirt-engine-sdk, vdsm)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Yedidyah Bar David (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, ovirt-hosted-engine-setup)
	bverschueren (Contributed to: ovirt-ansible-collection)
	hiyokotaisa (Contributed to: ovirt-ansible-collection)
	jekader (Contributed to: ovirt-ansible-collection)
