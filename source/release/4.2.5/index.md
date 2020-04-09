---
title: oVirt 4.2.5 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.2.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.5 release as of July 30, 2018.

Release has been updated on August 10, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.5, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.5?

### Release Note

#### oVirt Engine

 - [BZ 1605076](https://bugzilla.redhat.com/1605076) <b>[downstream clone - 4.2.5] Config values inconsistency between RHV versions</b><br>There were inconsistencies in the following internal configuration options:<br><br>* HotPlugCpuSupported<br>* HotUnplugCpuSupported<br>* HotPlugMemorySupported<br>* HotUnplugMemorySupported<br>* IsMigrationSupported<br>* IsMemorySnapshotSupported<br>* IsSuspendSupported<br>* ClusterRequiredRngSourcesDefault<br><br>If you are having issues with these features, upgrade to Red Hat Virtualization 4.2.5+ to resolve the problem.

### Enhancements

#### oVirt Engine

 - [BZ 1568893](https://bugzilla.redhat.com/1568893) <b>Alert when guaranteed capacity reaches a threshold value</b><br>Feature: Notification on running our of physical space.<br><br>Reason: With VDO and Thin pool support, users may see more space, that it is available physically. This is totally fine and with VDO it is an expected behavior. At the same time, we can't predict, how much data user will be able to actually write. Because of that, to keep user informed, we would like to notify him, when he is running out of physical space and, at the same time, show him how much confirmed space he have.<br><br>Result: When actually used space of the thin device goes above configured threshold, event will be issued.
 - [BZ 1608362](https://bugzilla.redhat.com/1608362) <b>[downstream clone - 4.2.5] [RFE] Disable Event notification popup in admin portal</b><br>This update adds a feature to control pop up notifications. Once 3 or more notifications are showing, "Dismiss" and "Do not disturb" buttons will appear that allow the user to silence notifications.
 - [BZ 1572158](https://bugzilla.redhat.com/1572158) <b>[RFE] add disk sizes in Disk general tab</b><br>
 - [BZ 1574771](https://bugzilla.redhat.com/1574771) <b>[RFE] Provide a friendly interface (UI + REST) for virtio multiqueue network interfaces</b><br>Feature: Multi Queue<br><br>Reason: Better performance.<br><br>Result: This feature is adding new property to the VM, 'Multi Queues Enabled'.<br>'Multi Queues' will be enabled by default.<br><br>Each vnic of a VM with 'Multi Queue' enabled will get min(num_of_vCpus, 4) queues.<br><br>Note: Queues configured via the vnic profile's custom properties will override the 'Mutli Queues'.
 - [BZ 1591730](https://bugzilla.redhat.com/1591730) <b>[RFE] allow a ui-plugin to set an icon on its left nav</b><br>This feature allows ui plugins to set an icon on their main menu navigation item.
 - [BZ 1601514](https://bugzilla.redhat.com/1601514) <b>[downstream clone - 4.2.5] [RFE] Changes that require Virtual Machine restart: name</b><br>
 - [BZ 1580386](https://bugzilla.redhat.com/1580386) <b>'Enable IO threads' should be checked by default (or at least for Server VM type)</b><br>
 - [BZ 1443963](https://bugzilla.redhat.com/1443963) <b>[RFE] Expose API to reduce a volume</b><br>Feature:<br><br>Added 'reduce' action on disk in the API:<br><br>POST /ovirt-engine/api/disks/cc9ce0d3-f651-4d86-94e6-0e4e5cfde3ce/reduce<br><br>Reduces the size of the specified disk image. The action invokes 'lvreduce' on the logical volume (i.e. this is only applicable for block storage domains). This is applicable for floating disks and disks attached to non-running virtual machines. There is no need to specify the size as the optimal size is calculated automatically.
 - [BZ 1451342](https://bugzilla.redhat.com/1451342) <b>configure guest MTU based on underlying network</b><br>Feature:<br>The feature adds the ability to manage the MTU of VM networks in a centralized way. This extends the ability of oVirt to manage the MTU of host networks.<br><br>Reason: <br>This feature enables the usage of big MTUs ("Jumbo Frames") for OVN networks. This improves the network throughput for OVN networks.<br><br>Result:<br>The MTU of the network is propagated the whole way down to the guest in the VM.
 - [BZ 1136916](https://bugzilla.redhat.com/1136916) <b>[RFE] Add visual element to LUNs already in use by Storage domain in add External (Direct Lun) screen</b><br>Feature: <br>Add a visual element to LUNs already in use by storage domain in add External (Direct Lun) screen.<br><br>Reason: <br>Having the visual element will allow the user to skip such LUNs more efficiently.<br><br>Result:<br>LUNs which are already used by an external storage domain won't be able to be selected and appear as grayed out with an N/A button on the 'Actions' column.
 - [BZ 1197685](https://bugzilla.redhat.com/1197685) <b>[RFE] SR-IOV > Add tooltip on the PF with info about --> 'Number of enabled VFs' and ' How many and which VFs are free/in use) in the Setup Networks dialog (GUI)</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1193961](https://bugzilla.redhat.com/1193961) <b>[RFE] [hosted-engine] [iSCSI multipath] Support hosted engine deployment based on multiple iSCSI initiators</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1193961](https://bugzilla.redhat.com/1193961) <b>[RFE] [hosted-engine] [iSCSI multipath] Support hosted engine deployment based on multiple iSCSI initiators</b><br>

#### oVirt Provider OVN

 - [BZ 1593676](https://bugzilla.redhat.com/1593676) <b>[RFE] Provide static routes support for routers</b><br>This feature adds static routes support to ovirt-provider-ovn, as specified in<br>https://developer.openstack.org/api-ref/network/v2/#routers-routers<br><br>The appropriate REST request for this is as follows:<br>{<br>"router": {<br>  "routes": [<br>   {<br>      "destination": "179.24.1.0/24",<br>       "nexthop": "172.24.3.99"<br>   },<br>  ...

#### oVirt Engine Dashboard

 - [BZ 1591730](https://bugzilla.redhat.com/1591730) <b>[RFE] allow a ui-plugin to set an icon on its left nav</b><br>This feature allows ui plugins to set an icon on their main menu navigation item.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1596234](https://bugzilla.redhat.com/1596234) <b>[downstream clone - 4.2.5] Virtual machine lost its cdrom device</b><br>Previously, when a virtual machine's cluster level was updated (for example, from 4.1 to 4.2), ejected CD-ROM devices could be lost, and the virtual machine was sometimes unable to use CDs anymore. This has now been fixed so that CD-ROM devices remain intact during upgrades regardless of whether they are in use or ejected.

#### VDSM

 - [BZ 1600595](https://bugzilla.redhat.com/1600595) <b>[downstream clone - 4.2.5] add AMD EPYC SSBD CPU</b><br>

### Bug Fixes

#### oVirt Engine

 - [BZ 1607149](https://bugzilla.redhat.com/1607149) <b>[downstream clone - 4.2.5] OVN network synchronization not working after replacing the RHV-M tls certificate with a commercial one</b><br>
 - [BZ 1590943](https://bugzilla.redhat.com/1590943) <b>hosted-engine VM created with node zero misses the console device</b><br>
 - [BZ 1596523](https://bugzilla.redhat.com/1596523) <b>Guaranteed free space implementation differs between replica and arbiter volumes</b><br>
 - [BZ 1584325](https://bugzilla.redhat.com/1584325) <b>Search bar is case sensitive</b><br>
 - [BZ 1605198](https://bugzilla.redhat.com/1605198) <b>[downstream clone - 4.2.5] Hit Xorg Segmentation fault while installing rhel7.4 release guest in RHV 4.2 with QXL</b><br>
 - [BZ 1593564](https://bugzilla.redhat.com/1593564) <b>Snapshot creation failed due duplicate uuid for new image</b><br>

#### oVirt Engine Metrics

 - [BZ 1585666](https://bugzilla.redhat.com/1585666) <b>Some hosts stop reporting data to elasticsearch after a few minutes</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1590943](https://bugzilla.redhat.com/1590943) <b>hosted-engine VM created with node zero misses the console device</b><br>
 - [BZ 1588720](https://bugzilla.redhat.com/1588720) <b>A system wide proxy with no exception for the engine FQDN will cause a "Failed connect to <ManagerFQDN>:443; No route to host"</b><br>

#### cockpit-ovirt

 - [BZ 1584152](https://bugzilla.redhat.com/1584152) <b>[day2] Updated hosts are not persisted both the gdeploy config files</b><br>

#### VDSM

 - [BZ 1481022](https://bugzilla.redhat.com/1481022) <b>When blocking connection between host and NFS storage, a running VM doesn't switch to paused mode</b><br>

### Other

#### oVirt Release Package

 - [BZ 1597289](https://bugzilla.redhat.com/1597289) <b>ovirt-epel repository is enabled in oVirt node</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1591534](https://bugzilla.redhat.com/1591534) <b>[RFE] [v2v] imageio performance  - support keep alive connections</b><br>

#### oVirt Engine

 - [BZ 1613249](https://bugzilla.redhat.com/1613249) <b>[downstream clone - 4.2.5] Foreign key constraint violation on upgrade to 4.2.5</b><br>
 - [BZ 1602804](https://bugzilla.redhat.com/1602804) <b>NPE in Add/RemoveFenceAgentCommand</b><br>
 - [BZ 1600819](https://bugzilla.redhat.com/1600819) <b>Gluster volume cannot be created with arbiter brick</b><br>
 - [BZ 1578842](https://bugzilla.redhat.com/1578842) <b>out-of-sync error message should tell what exactly is out of sync</b><br>
 - [BZ 1576729](https://bugzilla.redhat.com/1576729) <b>XML based hot-(un)plug of disks and nics</b><br>
 - [BZ 1572250](https://bugzilla.redhat.com/1572250) <b>Disk total size is reported as 0 in disk collection if the disk does not have any snapshots</b><br>
 - [BZ 1613168](https://bugzilla.redhat.com/1613168) <b>[downstream clone - 4.2.5-1] On rollback of failed upgrade from 4.2.1+, engine-setup outputs errors about the uuid-ossp extension</b><br>
 - [BZ 1583516](https://bugzilla.redhat.com/1583516) <b>[AutoDefine] - The external sync of the AutoSyncCommand attaching all external_networks to all clusters type</b><br>
 - [BZ 1550120](https://bugzilla.redhat.com/1550120) <b>Upgrade ovirt-engine-wildfly to 13.0.0 Final</b><br>
 - [BZ 1586019](https://bugzilla.redhat.com/1586019) <b>[SR-IOV] - VF leakage when shutting down a VM from powering UP state</b><br>
 - [BZ 1535001](https://bugzilla.redhat.com/1535001) <b>ovn localnet: read custom bridge/vlan from external provider to populate UI (and possibly REST too)</b><br>
 - [BZ 1447637](https://bugzilla.redhat.com/1447637) <b>[RFE] engine should report openvswitch package versions on each host</b><br>
 - [BZ 1526799](https://bugzilla.redhat.com/1526799) <b>[UI] - Add/Edit VM's vNIC dropdown: add external provider indication if relevant</b><br>
 - [BZ 1595857](https://bugzilla.redhat.com/1595857) <b>Add input validation for FenceProxyDefaultPreferences in engine-config</b><br>
 - [BZ 1610439](https://bugzilla.redhat.com/1610439) <b>After upgrade to RHV 4.2.3, hosts can no longer be set into maintenance mode.</b><br>
 - [BZ 1601227](https://bugzilla.redhat.com/1601227) <b>image upload - command failure on resume</b><br>
 - [BZ 1608348](https://bugzilla.redhat.com/1608348) <b>[downstream clone - 4.2.5] Live merge fails on the RHV-M Engine with "Invalid UUID string: payload" followed by exception.</b><br>
 - [BZ 1599054](https://bugzilla.redhat.com/1599054) <b>Fix APIv3 deprecated/removed message</b><br>
 - [BZ 1563122](https://bugzilla.redhat.com/1563122) <b>Useless error message: 'Engine server is not responding' (NOT on hosted-engine, regular engine)</b><br>
 - [BZ 1585641](https://bugzilla.redhat.com/1585641) <b>REST API doesn't return display -> type element for VM in VMpool with All-content header</b><br>
 - [BZ 1590300](https://bugzilla.redhat.com/1590300) <b>Creating DB without the UUID extension messes scripts in the data director and causing an error.</b><br>
 - [BZ 1594775](https://bugzilla.redhat.com/1594775) <b>download raw image - wrong total value in progress</b><br>
 - [BZ 1605133](https://bugzilla.redhat.com/1605133) <b>[downstream clone - 4.2.5] Skipped power management operation has misleading logs</b><br>
 - [BZ 1577177](https://bugzilla.redhat.com/1577177) <b>Make engine compatible with both WildFly 11 and WildFly 13</b><br>
 - [BZ 1588698](https://bugzilla.redhat.com/1588698) <b>Commit snapshot-preview fails with Error while executing action Revert to snapshot: Internal engine error</b><br>
 - [BZ 1605206](https://bugzilla.redhat.com/1605206) <b>[downstream clone - 4.2.5] JsonMappingException in businessentities.storage.DiskImage prevents access to Engine</b><br>
 - [BZ 1595641](https://bugzilla.redhat.com/1595641) <b>Host install fail due to missing dependcy on python-netaddr</b><br>
 - [BZ 1592114](https://bugzilla.redhat.com/1592114) <b>StreamingAPI-  Download disk image & try to resume via SDK - operation should fail but succeeds</b><br>
 - [BZ 1583698](https://bugzilla.redhat.com/1583698) <b>Uninformative error message "Operation Failed" when trying to pause an image download via the API</b><br>

#### oVirt Engine Metrics

 - [BZ 1593646](https://bugzilla.redhat.com/1593646) <b>[RFE] Add ansible-inventory file required for OCP/Origin 3.10 to metrics store machine</b><br>
 - [BZ 1576391](https://bugzilla.redhat.com/1576391) <b>Paths in config should not include trailing /</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1574336](https://bugzilla.redhat.com/1574336) <b>Ansible logging improvements</b><br>
 - [BZ 1578144](https://bugzilla.redhat.com/1578144) <b>hosted-engine deploy asks for VM size using wrong units</b><br>
 - [BZ 1601790](https://bugzilla.redhat.com/1601790) <b>Automatic creation of storage domain uses front-end IP to mount the gluster volume</b><br>

#### cockpit-ovirt

 - [BZ 1590588](https://bugzilla.redhat.com/1590588) <b>[branding] 'Getting Started' and 'More Information' points to incorrect url on the Cockpit guided Self-Hosted Engine Deployment.</b><br>
 - [BZ 1540096](https://bugzilla.redhat.com/1540096) <b>Suggest to give the selection or hint of the glusterFS volume replica(at least 3) while deploying HE via cockpit with gluster based otopi</b><br>
 - [BZ 1558072](https://bugzilla.redhat.com/1558072) <b>Wizard exits when hitting ESC key when entering values on the wizard</b><br>
 - [BZ 1572051](https://bugzilla.redhat.com/1572051) <b>Cockpit is missing the "Getting Started" and "More Information" while using chrome</b><br>
 - [BZ 1550890](https://bugzilla.redhat.com/1550890) <b>[RFE][Text] Suggest to give a hint about the format of the "mount options" while deploying HE like the "Storage connection"</b><br>
 - [BZ 1558082](https://bugzilla.redhat.com/1558082) <b>"Are you sure?" dialog should pop when one close the wizard in the middle of the installation</b><br>
 - [BZ 1602263](https://bugzilla.redhat.com/1602263) <b>Disabling Thinpool when compression and deduplication is enabled on a device</b><br>
 - [BZ 1584143](https://bugzilla.redhat.com/1584143) <b>[day2] Peer status is not consistent in cockpit UI unless user will refresh the cockpit UI.</b><br>
 - [BZ 1583470](https://bugzilla.redhat.com/1583470) <b>[day2] The volume section in gluster management tab under hosted engine is not providing correct brick configuration</b><br>
 - [BZ 1597266](https://bugzilla.redhat.com/1597266) <b>[day2] last volume listed in gluster management shows lot of bricks than actually available</b><br>
 - [BZ 1592642](https://bugzilla.redhat.com/1592642) <b>Unable to uncheck arbiter brick with dedupe and compression enabled</b><br>
 - [BZ 1583498](https://bugzilla.redhat.com/1583498) <b>[day2] The configue ' Lv size ' text box under bricks tab in ' expand cluster ' operation is vanishing on a backspace.</b><br>
 - [BZ 1578687](https://bugzilla.redhat.com/1578687) <b>Re editing the tabs after the failure is not reflected in the congif file.(Day 2 operations)</b><br>
 - [BZ 1590891](https://bugzilla.redhat.com/1590891) <b>Accessing hosted engine page without gdeploy installed generates error</b><br>

#### imgbased

 - [BZ 1583145](https://bugzilla.redhat.com/1583145) <b>"nodectl check" failed after mount nfs storge via cockpit UI.</b><br>

#### VDSM

 - [BZ 1605172](https://bugzilla.redhat.com/1605172) <b>[downstream clone - 4.2.5] VM was destroyed on destination after successful migration due to missing the 'device' key on the lease device</b><br>
 - [BZ 1607860](https://bugzilla.redhat.com/1607860) <b>[downstream clone - 4.2.5] vdsm-tool upgrade-networks fails with KeyError: 'defaultRoute'</b><br>
 - [BZ 1570562](https://bugzilla.redhat.com/1570562) <b>vdsm is dead after upgrade to vdsm-4.20.26-1.el7ev.x86_64</b><br>
 - [BZ 1597113](https://bugzilla.redhat.com/1597113) <b>Run VM fails on 'Bad volume specification' when NFS data storage domain path specified using ipv6 address</b><br>
 - [BZ 1565040](https://bugzilla.redhat.com/1565040) <b>Engine stuck on CopyData despite task completion in vdsm</b><br>
 - [BZ 1553985](https://bugzilla.redhat.com/1553985) <b>In offline disk migration task stuck in lock state when migrating from one iSCSI storage domain to another.</b><br>
 - [BZ 1574631](https://bugzilla.redhat.com/1574631) <b>Problem to create snapshot</b><br>

#### oVirt Ansible ManageIQ role

 - [BZ 1590336](https://bugzilla.redhat.com/1590336) <b>Can't set password via miq_app_password variable</b><br>

#### oVirt Ansible disaster recovery role

 - [BZ 1588557](https://bugzilla.redhat.com/1588557) <b>[DR]Validator failed to validate when using encrypted password file</b><br>
 - [BZ 1588465](https://bugzilla.redhat.com/1588465) <b>[DR] Log file not created for disaster validation</b><br>

#### oVirt Engine WildFly

 - [BZ 1550120](https://bugzilla.redhat.com/1550120) <b>Upgrade ovirt-engine-wildfly to 13.0.0 Final</b><br>

#### oVirt Engine WildFly Overlay

 - [BZ 1550120](https://bugzilla.redhat.com/1550120) <b>Upgrade ovirt-engine-wildfly to 13.0.0 Final</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1551926](https://bugzilla.redhat.com/1551926) <b>[ja_JP] Text alignment correction needed on compute -> clusters -> new ->scheduling policy</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1393839](https://bugzilla.redhat.com/1393839) <b>Hosted engine vm status remains paused on 1st host and starts on 2nd Host during hosted-storage disconnect and reconnect</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1573461](https://bugzilla.redhat.com/1573461) <b>[RFE] Sort Hosted-Engine answerfile's lines</b><br>

#### cockpit-ovirt

 - [BZ 1594736](https://bugzilla.redhat.com/1594736) <b>The 'Writeback' option in LVM cache mode dropdown is not accessible.</b><br>

#### oVirt Provider OVN

 - [BZ 1549033](https://bugzilla.redhat.com/1549033) <b>[requires ovs-2.9.0-45] allow modifying host binding of port (for live migration)</b><br>
 - [BZ 1588455](https://bugzilla.redhat.com/1588455) <b>RHV Hosts are continuosly logging error :- database connection failed (No such file or directory)</b><br>
