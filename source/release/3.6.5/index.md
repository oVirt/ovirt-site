---
title: oVirt 3.6.5 Release Notes
category: documentation
toc: true
authors:
  - didi
  - sandrobonazzola
  - rafaelmartins
page_classes: releases
---

# oVirt 3.6.5 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.5 release as of April 21st, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

### oVirt Node

oVirt Node is now released continously. Please refer to the [Node Project](/download/node.html) page for release notes, download and install instructions.

## What's New in 3.6.5?

### Enhancement

#### oVirt Engine

 - [BZ 1160094](https://bugzilla.redhat.com/1160094) <b>[RFE] Edit the settings of the hosted engine VM in the GUI</b><br>Feature: Switching from per-host editing of the hosted engine vm to the regular engine flow of updating a vm via REST api or UI.<br><br>Reason: Instead of cumbersome, error-prone, local editing the vm.conf on each and every HA host we use the engine itself to edit it. The change should be made in one place, once.<br><br>Result: A change via ovirt-engine is kept in the engine DB and propagated into the OVF_STORE disk on the storage donmain. So it is both shared, and backed-up and highly available.
 - [BZ 1269301](https://bugzilla.redhat.com/1269301) <b>RFE: Do not recycle MAC addresses immediately</b><br>Feature: <br><br>Reason: <br>In environment, where VMs are created and removed quickly, acquiring MAC addresses in smallest MAC available order may lead to situation, where there's MAC still used on network, but device using it is different than expected — other devices expects, that this MAC address belongs to some device which was here just moment ago.<br><br>Result: MAC addresses are acquired in cycle. When getting MAC address from pool, pool marks position of last returned MAC, and next time will search for available MAC from this position. This will cause all other available MAC address are 'used' before reusing MAC address returned back to pool.
 - [BZ 1316583](https://bugzilla.redhat.com/1316583) <b>[RFE][z-stream clone - 3.6.5] Add Fencing of Ilo3/4 via ssh fencing to RHEV-M</b><br>
 - [BZ 1320092](https://bugzilla.redhat.com/1320092) <b>[RFE][3.6 clone] engine-backup should not depend on the engine</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1058384](https://bugzilla.redhat.com/1058384) <b>Changing a VM's migration profile now requires the VM to be down</b><br>
 - [BZ 1154391](https://bugzilla.redhat.com/1154391) <b>oVirt Change CD incorrectly rejecting isos with uppercase extensions (ISO vs iso)</b><br>
 - [BZ 1238742](https://bugzilla.redhat.com/1238742) <b>Wrong changed items list, when changing in edit running VM dialog, the console parameter</b><br>
 - [BZ 1260962](https://bugzilla.redhat.com/1260962) <b>[help] Run Once help icon points to useless doc</b><br>
 - [BZ 1275778](https://bugzilla.redhat.com/1275778) <b>Unable to set VM highly available in Instance type</b><br>
 - [BZ 1281732](https://bugzilla.redhat.com/1281732) <b>Updating a template in a vm pool causes removal of soundcard and memory ballon device</b><br>
 - [BZ 1281871](https://bugzilla.redhat.com/1281871) <b>[admin portal] Actual timezone in the guest differs tooltip / Rename 'Time Zone' in VM -> System -> General dialog to 'RTC time'</b><br>
 - [BZ 1290478](https://bugzilla.redhat.com/1290478) <b>Prevent unsupported or risky provisioning actions on hosted engine VM</b><br>
 - [BZ 1291080](https://bugzilla.redhat.com/1291080) <b>[engine-backend] Actual size of disk, that was previously imported from Glance, is reported wrongly in 'attach' disk view</b><br>
 - [BZ 1291146](https://bugzilla.redhat.com/1291146) <b>[de_DE][Admin Portal] - Icon overlapping in New Network Interface form</b><br>
 - [BZ 1293154](https://bugzilla.redhat.com/1293154) <b>New VM dialog offers each VM template twice</b><br>
 - [BZ 1293574](https://bugzilla.redhat.com/1293574) <b>[WebAdmin] - "Error message appears in the UI "Uncaught exception occurred." when pressing on a rhev-h server that have a new version available</b><br>
 - [BZ 1294511](https://bugzilla.redhat.com/1294511) <b>Pool's template version doesn't update when set to latest and a new version is created</b><br>
 - [BZ 1294678](https://bugzilla.redhat.com/1294678) <b>[scale] - High Memory and CPU Usage in Chrome and Firefox</b><br>
 - [BZ 1297018](https://bugzilla.redhat.com/1297018) <b>[security] disable strict user checking does not work - users can steal already opened console by other user</b><br>
 - [BZ 1297454](https://bugzilla.redhat.com/1297454) <b>[SR-IOV] - REST API - No validation for 'passthrough' profile in DCs less than 3.6</b><br>
 - [BZ 1302372](https://bugzilla.redhat.com/1302372) <b>The Sub Version Name is present on the new pool dialog</b><br>
 - [BZ 1302582](https://bugzilla.redhat.com/1302582) <b>The relation between memory and memory guaranteed is not consistent</b><br>
 - [BZ 1303132](https://bugzilla.redhat.com/1303132) <b>engine-setup js-ant failed to execute with java 1.8</b><br>
 - [BZ 1303640](https://bugzilla.redhat.com/1303640) <b>[SR-IOV] - PF is no longer considered as a PF after the VM shuts down, if it was attached/added directly to VM via Host Devices sub tab</b><br>
 - [BZ 1304674](https://bugzilla.redhat.com/1304674) <b>RHEVM UI raise exceptions when remove any items from long list (SDa/VMs/etc)</b><br>
 - [BZ 1304676](https://bugzilla.redhat.com/1304676) <b>Watchdog doesn't allow starting a virtual machine from template</b><br>
 - [BZ 1304729](https://bugzilla.redhat.com/1304729) <b>Hovering above an exclamation mark next to vm icon does not produce the expected message</b><br>
 - [BZ 1304776](https://bugzilla.redhat.com/1304776) <b>Edit VM dialog, host side-tab: change label "specific" to "specific host(s)"</b><br>
 - [BZ 1305837](https://bugzilla.redhat.com/1305837) <b>sign websocket proxy ticket via RESTapi when VM have VNC graphics protocol</b><br>
 - [BZ 1305904](https://bugzilla.redhat.com/1305904) <b>Cloud-Init payload not passed into VM via python SDK</b><br>
 - [BZ 1306178](https://bugzilla.redhat.com/1306178) <b>ovirt-engine-setup-plugin-ovirt-engine does not require ovirt-engine-setup-plugin-vmconsole-proxy-helper</b><br>
 - [BZ 1306585](https://bugzilla.redhat.com/1306585) <b>Network Import dialogue will not close on Cancel</b><br>
 - [BZ 1307030](https://bugzilla.redhat.com/1307030) <b>uncaught exception while searching using a tag</b><br>
 - [BZ 1308642](https://bugzilla.redhat.com/1308642) <b>Glance image import: wrong target storage domain is mentioned in the running task</b><br>
 - [BZ 1308778](https://bugzilla.redhat.com/1308778) <b>Windows VM name validation is limited to 15 chars, no indication that sysinit VM hostname should be used</b><br>
 - [BZ 1308868](https://bugzilla.redhat.com/1308868) <b>NPE when importing image from glance</b><br>
 - [BZ 1308885](https://bugzilla.redhat.com/1308885) <b>virtio-serial duplicates after engine upgrade to 3.6</b><br>
 - [BZ 1308914](https://bugzilla.redhat.com/1308914) <b>v2v: webadmin does not indicate bootable/OS disk on an imported VM.</b><br>
 - [BZ 1309221](https://bugzilla.redhat.com/1309221) <b>UI- Add VM from template list - wrong "Optimized For" value</b><br>
 - [BZ 1309294](https://bugzilla.redhat.com/1309294) <b>Failed to syncDbRecords after successful live merge because host is down</b><br>
 - [BZ 1310615](https://bugzilla.redhat.com/1310615) <b>"Volume does not exist" alert is displayed when snapshot successfully deleted</b><br>
 - [BZ 1311052](https://bugzilla.redhat.com/1311052) <b>cannot add VM from a template as a PowerUser</b><br>
 - [BZ 1311408](https://bugzilla.redhat.com/1311408) <b>spice html5 missing from engine-config's ClientModeSpiceDefault.validValues</b><br>
 - [BZ 1311899](https://bugzilla.redhat.com/1311899) <b>Minimum guaranteed memory is higher than VM memory when hotplug fails</b><br>
 - [BZ 1311908](https://bugzilla.redhat.com/1311908) <b>Edit VM dialog save action calls UpdateVmDiskCommand even though no disk change happened</b><br>
 - [BZ 1312879](https://bugzilla.redhat.com/1312879) <b>cannot refresh host devices of a host when device is assigned to multiple VMs</b><br>
 - [BZ 1312880](https://bugzilla.redhat.com/1312880) <b>Alert box regarding supported browsers has broken link</b><br>
 - [BZ 1313744](https://bugzilla.redhat.com/1313744) <b>VM is inoperative after power off during Live storage migration</b><br>
 - [BZ 1314430](https://bugzilla.redhat.com/1314430) <b>On rhevm webadmin login page the word "Documentation" is not clearly seen</b><br>
 - [BZ 1314826](https://bugzilla.redhat.com/1314826) <b>No debug log entry for user executing an action or query</b><br>
 - [BZ 1314847](https://bugzilla.redhat.com/1314847) <b>Restore fails with ovirt-engine-dwh conf, though that was not on backup</b><br>
 - [BZ 1315744](https://bugzilla.redhat.com/1315744) <b>upgrade from 3.5.1 fails</b><br>
 - [BZ 1315886](https://bugzilla.redhat.com/1315886) <b>Template Edit dialog loads SPICE as Graphics protocol even if using VNC</b><br>
 - [BZ 1316849](https://bugzilla.redhat.com/1316849) <b>New role 'CpuProfileOperator' in Everyone group caused that user with 'UserRole' can see extended tab in Userportal</b><br>
 - [BZ 1317248](https://bugzilla.redhat.com/1317248) <b>Add host name as header to JsonRpcUtils</b><br>
 - [BZ 1318936](https://bugzilla.redhat.com/1318936) <b>The label Sessions was changed to 'Guest Information' in the left tree view</b><br>
 - [BZ 1319635](https://bugzilla.redhat.com/1319635) <b>Add warning to engine-manage-domains is not supported</b><br>
 - [BZ 1319769](https://bugzilla.redhat.com/1319769) <b>Allow editing of hosted engine vNICs</b><br>
 - [BZ 1321583](https://bugzilla.redhat.com/1321583) <b>Service name in notify events is not correct</b><br>
 - [BZ 1323450](https://bugzilla.redhat.com/1323450) <b>[z-stream clone - 3.6.5] java.lang.IllegalArgumentException: No type specified for option: 'encrypt_options' in /api/capabilities</b><br>

### VDSM

 - [BZ 1292096](https://bugzilla.redhat.com/1292096) <b>v2v: Implement bypass for dcpath (cluster name) issue</b><br>

### oVirt Hosted Engine HA

 - [BZ 1292652](https://bugzilla.redhat.com/1292652) <b>[upgrade] the upgrade from 3.5 to 3.6 can fail if interrupted in the middle and restarted after a reboot</b><br>
 - [BZ 1319785](https://bugzilla.redhat.com/1319785) <b>vNICs without link from OVF must be marked as such in the vm.conf too</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1228141](https://bugzilla.redhat.com/1228141) <b>[hosted-engine][text] generate cloud-init image in HE setup is not clear</b><br>
 - [BZ 1309572](https://bugzilla.redhat.com/1309572) <b>[RFE] Provide flag to run Hosted Engine VM from local conf file instead of the one in the shared storage.</b><br>
 - [BZ 1318612](https://bugzilla.redhat.com/1318612) <b>[z-stream clone - 3.6.5] hosted engine appliance deployment fails with insufficient information.</b><br>
 - [BZ 1319881](https://bugzilla.redhat.com/1319881) <b>Hosted-engine CPU type list should match the list on the engine</b><br>

### oVirt Reports

 - [BZ 1296585](https://bugzilla.redhat.com/1296585) <b>Heatmap report show additional line for clusters with multiple hosts</b><br>
 - [BZ 1303132](https://bugzilla.redhat.com/1303132) <b>engine-setup js-ant failed to execute with java 1.8</b><br>
 - [BZ 1304656](https://bugzilla.redhat.com/1304656) <b>VM uptime is wrong on BR44 report</b><br>

### oVirt Engine SDK

 - [BZ 1311495](https://bugzilla.redhat.com/1311495) <b>Add support for URL parameters in actions</b><br>

### oVirt Engine Extension AAA LDAP

 - [BZ 1313516](https://bugzilla.redhat.com/1313516) <b>failover serverset don't work - getting null objects as addreses</b><br>
 - [BZ 1313583](https://bugzilla.redhat.com/1313583) <b>aaa-ldap setup tool shouldn't offer advanced option to specify custom DNS servers as it cannot be verified</b><br>

