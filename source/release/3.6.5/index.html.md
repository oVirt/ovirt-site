---
title: OVirt 3.6.5 Release Notes
category: documentation
authors: didi, sandrobonazzola, rafaelmartins
---

# oVirt 3.6.5 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.5 first release candidate as of March 30th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## CANDIDATE RELEASE

In order to install oVirt 3.6.5 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.5 on a clean host, you should read our
[Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/)

## What's New in 3.6.5?

**RFE: Do not recycle MAC addresses immediately**

Reason: In environment, where VMs are created and removed quickly, acquiring MAC addresses in smallest MAC available order may lead to situation, where there's MAC still used on network, but device using it is different than expected — other devices expects, that this MAC address belongs to some device which was here just moment ago.

Result: MAC addresses are acquired in cycle. When getting MAC address from pool, pool marks position of last returned MAC, and next time will search for available MAC from this position. This will cause all other available MAC address are 'used' before reusing MAC address returned back to pool.

**[RFE] Edit the settings of the hosted engine VM in the GUI**

Feature: Switching from per-host editing of the hosted engine vm to the regular engine flow of updating a vm via REST api or UI.

Reason: Instead of cumbersome, error-prone, local editing the vm.conf on each and every HA host we use the engine itself to edit it. The change should be made in one place, once.

Result: A change via ovirt-engine is kept in the engine DB and propagated into the OVF_STORE disk on the storage donmain. So it is both shared, and backed-up and highly available.

**[RFE] Disable power management (display and computer)**

**[RFE][3.6 clone] engine-backup should not depend on the engine**

## Bugs fixed

### oVirt Engine

 - [BZ 1260962](https://bugzilla.redhat.com/1260962) - [help] Run Once help icon points to useless doc
 - [BZ 1269301](https://bugzilla.redhat.com/1269301) - RFE: Do not recycle MAC addresses immediately
 - [BZ 1275778](https://bugzilla.redhat.com/1275778) - Unable to set VM highly available in Instance type
 - [BZ 1281732](https://bugzilla.redhat.com/1281732) - Updating a template in a vm pool causes removal of soundcard and memory ballon device
 - [BZ 1281871](https://bugzilla.redhat.com/1281871) - [admin portal] Actual timezone in the guest differs tooltip / Rename 'Time Zone' in VM -> System -> General dialog to 'RTC time'
 - [BZ 1291080](https://bugzilla.redhat.com/1291080) - [engine-backend] Actual size of disk, that was previously imported from Glance, is reported wrongly in 'attach' disk view
 - [BZ 1291146](https://bugzilla.redhat.com/1291146) - [de_DE][Admin Portal] - Icon overlapping in New Network Interface form
 - [BZ 1293154](https://bugzilla.redhat.com/1293154) - New VM dialog offers each VM template twice
 - [BZ 1293574](https://bugzilla.redhat.com/1293574) - [WebAdmin] - "Error message appears in the UI "Uncaught exception occurred." when pressing on a rhev-h server that have a new version available
 - [BZ 1294511](https://bugzilla.redhat.com/1294511) - Pool's template version doesn't update when set to latest and a new version is created
 - [BZ 1297454](https://bugzilla.redhat.com/1297454) - [SR-IOV] - REST API - No validation for 'passthrough' profile in DCs less than 3.6
 - [BZ 1302372](https://bugzilla.redhat.com/1302372) - The Sub Version Name is present on the new pool dialog
 - [BZ 1302582](https://bugzilla.redhat.com/1302582) - The relation between memory and memory guaranteed is not consistent
 - [BZ 1303640](https://bugzilla.redhat.com/1303640) - [SR-IOV] - PF is no longer considered as a PF after the VM shuts down, if it was attached/added directly to VM via Host Devices sub tab
 - [BZ 1304674](https://bugzilla.redhat.com/1304674) - RHEVM UI raise exceptions when remove any items from long list (SDa/VMs/etc)
 - [BZ 1304676](https://bugzilla.redhat.com/1304676) - Watchdog doesn't allow starting a virtual machine from template
 - [BZ 1304729](https://bugzilla.redhat.com/1304729) - Hovering above an exclamation mark next to vm icon does not produce the expected message
 - [BZ 1304755](https://bugzilla.redhat.com/1304755) - admin should have permission to see 'change CD' in admin portal
 - [BZ 1304776](https://bugzilla.redhat.com/1304776) - Edit VM dialog, host side-tab: change label "specific" to "specific host(s)"
 - [BZ 1305837](https://bugzilla.redhat.com/1305837) - sign websocket proxy ticket via RESTapi when VM have VNC graphics protocol
 - [BZ 1305904](https://bugzilla.redhat.com/1305904) - Cloud-Init payload not passed into VM via python SDK
 - [BZ 1306178](https://bugzilla.redhat.com/1306178) - ovirt-engine-setup-plugin-ovirt-engine does not require ovirt-engine-setup-plugin-vmconsole-proxy-helper
 - [BZ 1306585](https://bugzilla.redhat.com/1306585) - Network Import dialogue will not close on Cancel
 - [BZ 1307030](https://bugzilla.redhat.com/1307030) - uncaught exception while searching using a tag
 - [BZ 1308478](https://bugzilla.redhat.com/1308478) - [SCALE] Create new VM in webadmin portal shows only spinning ring.
 - [BZ 1308642](https://bugzilla.redhat.com/1308642) - Glance image import: wrong target storage domain is mentioned in the running task
 - [BZ 1308778](https://bugzilla.redhat.com/1308778) - Windows VM name validation is limited to 15 chars, no indication that sysinit VM hostname should be used
 - [BZ 1308868](https://bugzilla.redhat.com/1308868) - NPE when importing image from glance
 - [BZ 1308885](https://bugzilla.redhat.com/1308885) - virtio-serial duplicates after engine upgrade to 3.6
 - [BZ 1309221](https://bugzilla.redhat.com/1309221) - UI- Add VM from template list - wrong "Optimized For" value
 - [BZ 1309294](https://bugzilla.redhat.com/1309294) - Failed to syncDbRecords after successful live merge because host is down
 - [BZ 1310615](https://bugzilla.redhat.com/1310615) - "Volume does not exist" alert is displayed when snapshot successfully deleted
 - [BZ 1311899](https://bugzilla.redhat.com/1311899) - Minimum guaranteed memory is higher than VM memory when hotplug fails
 - [BZ 1312879](https://bugzilla.redhat.com/1312879) - cannot refresh host devices of a host when device is assigned to multiple VMs
 - [BZ 1312880](https://bugzilla.redhat.com/1312880) - Alert box regarding supported browsers has broken link
 - [BZ 1313744](https://bugzilla.redhat.com/1313744) - VM is inoperative after power off during Live storage migration
 - [BZ 1314430](https://bugzilla.redhat.com/1314430) - On rhevm webadmin login page the word "Documentation" is not clearly seen
 - [BZ 1314826](https://bugzilla.redhat.com/1314826) - No debug log entry for user executing an action or query
 - [BZ 1314847](https://bugzilla.redhat.com/1314847) - Restore fails with ovirt-engine-dwh conf, though that was not on backup
 - [BZ 1315657](https://bugzilla.redhat.com/1315657) - No auto-completion option for scheduling policy name in update cluster
 - [BZ 1315744](https://bugzilla.redhat.com/1315744) - upgrade from 3.5.1 fails
 - [BZ 1316849](https://bugzilla.redhat.com/1316849) - New role 'CpuProfileOperator' in Everyone group caused that user with 'UserRole' can see extended tab in Userportal
 - [BZ 1318936](https://bugzilla.redhat.com/1318936) - The label Sessions was changed to 'Guest Information' in the left tree view
 - [BZ 1320092](https://bugzilla.redhat.com/1320092) - [RFE][3.6 clone] engine-backup should not depend on the engine

## oVirt Engine Reports

 - [BZ 1296585](https://bugzilla.redhat.com/1296585) - Heatmap report show additional line for clusters with multiple hosts
 - [BZ 1303132](https://bugzilla.redhat.com/1303132) - engine-setup js-ant failed to execute with java 1.8
 - [BZ 1304656](https://bugzilla.redhat.com/1304656) - VM uptime is wrong on BR44 report

### VDSM

 - [BZ 1303977](https://bugzilla.redhat.com/1303977) - KeyError when primary server used to mount gluster volume is down
 - [BZ 1318657](https://bugzilla.redhat.com/1318657) - VDSM keeps sending api-version messages to the guest agent when the guest agent is supporting a higher API Version than VDSM
 - [BZ 1321823](https://bugzilla.redhat.com/1321823) - vdsm: build with hooks - broken flag

### oVirt Hosted Engine Setup

 - [BZ 1303977](https://bugzilla.redhat.com/1303977) - KeyError when primary server used to mount gluster volume is down
 - [BZ 1318657](https://bugzilla.redhat.com/1318657) - VDSM keeps sending api-version messages to the guest agent when the guest agent is supporting a higher API Version than VDSM
 - [BZ 1321823](https://bugzilla.redhat.com/1321823) - vdsm: build with hooks - broken flag
