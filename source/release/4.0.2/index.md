---
title: oVirt 4.0.2 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.0.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.2 Release as of August 12th, 2016.
The release has been updated on August 19th with a new build of oVirt Engine fixing [BZ 1367483](https://bugzilla.redhat.com/show_bug.cgi?id=1367483)

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm)

If you're upgrading from a previous release on Enterprise Linux 7 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should follow our [Migration Guide](https://web.archive.org/web/20170723145830/http://www.ovirt.org/documentation/migration-engine-36-to-40/) in order to migrate to Enterprise Linux 7 or Fedora 23.



## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/show_bug.cgi?id=1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.

## What's New in 4.0.2?

### Enhancement

#### oVirt Engine

##### Team: Infra

 - [BZ 1346782](https://bugzilla.redhat.com/show_bug.cgi?id=1346782) <b>Display also pretty name along with name, version and release in Host Detail tab in Hosts view</b><br>With this release, the Administration Portal displays the operating system pretty name for all hosts that have an /etc/os-release file with the PRETTY_NAME entry. When you select a host, you can see an "OS Description" field in the "Software" section of the "General" sub-tab. This field can be used to tell the difference between Red Hat Virtualization Hosts (RHVH) and RHEL hosts. Note: this enhancement is not accessible to the REST API.

##### Team: Integration

 - [BZ 1290073](https://bugzilla.redhat.com/show_bug.cgi?id=1290073) <b>engine-setup should warn users running within hosted engine to set to maintenance</b><br>Feature: <br>Warn users to set system into global maintenance mode before running engine-setup. <br><br>Reason: <br>Data corruption may occur if the engine-setup is run without setting the system into global maintenance.<br><br>Result: <br>The user is warned and the setup will be aborted if the system is not in the global maintenance mode, if the engine is running in the hosted engine configuration.

##### Team: Network

 - [BZ 1209795](https://bugzilla.redhat.com/show_bug.cgi?id=1209795) <b>[RFE] alert after a VM is imported while using MAC outside its MAC Pool</b><br>Feature: <br>The system will alert upon importing a VM with a MAC, which is out of the range of the target MAC-pool range.<br><br>Reason: <br>Having such MAC could indicate the problem of MAC collision in the user's LAN. Such problem could appear immediately or later, when 2 active NICs with the same problematic MAC would appear in the user's LAN: one on the imported VM and another one on any other network appliance that isn't managed by the this oVirt instance.<br><br>Result:

##### Team: UX

 - [BZ 1358136](https://bugzilla.redhat.com/show_bug.cgi?id=1358136) <b>[LOGGING] /var/log/ovirt-engine/ui.log is growing at a rate of 16mb/second</b><br>This update prevents UI exceptions from repeatedly spamming the remote /var/log/ovirt-engine/ui.log after subsequent occurrences of the same error. Each remote operation is an HTTP request and consumes network resources.<br><br>Any uncaught exception in the Administration Portal or User Portal is compared to the last one, and only logged remotely if it's not the same. All occurrences are still logged on the web browser.
 - [BZ 1361255](https://bugzilla.redhat.com/show_bug.cgi?id=1361255) <b>UI plugin API: allow executing certain actions while the plugin is loading</b><br>Background:<br><br>UI plugin API performs requested actions only if the given plugin is either initializing (within UiInit callback) or in use (within other callbacks).<br><br>This means all API actions are no-op while the plugin is loading, e.g. before the plugin calls the ready() function that triggers the UiInit callback. <br><br>Feature:<br><br>Allow following API functions to be executed also while the plugin is loading:<br><br>- loginUserName<br>- loginUserId<br>- ssoToken<br>- engineBaseUrl<br>- currentLocale<br><br>Above functions are considered "safe to call while loading" as they have no visual or other side effects on WebAdmin UI.<br><br>Reason:<br><br>Let UI plugins call above functions within their init code, e.g. before the plugin calls ready() to signal that it's ready for use.<br><br>Result:<br><br>Plugins able to call above functions within their init code.

##### Team: Virt

 - [BZ 1285883](https://bugzilla.redhat.com/show_bug.cgi?id=1285883) <b>Align virt-viewer to engine SSO and remove proprietary HTTP session access</b><br>The Virt Viewers .vv file's 'versions=' row requires a remote-viewer that supports the 'sso-token=' row. The minimum versions are:<br>- Windows (64-bit and 32-bit): 2.0-160<br>- Red Hat Enterprise Linux 7: 2.0-8<br>- Red Hat Enterprise Linux 6: No supporting sso-token planned.
 - [BZ 1348907](https://bugzilla.redhat.com/show_bug.cgi?id=1348907) <b>During cluster level upgrade - warn and mark VMs as pending a configuration change when they are running</b><br>Previously, cluster compatibility version upgrades were blocked if there was a running virtual machine in the cluster. Now, the user is informed about running/suspended virtual machines in a cluster when changing the cluster version. All such virtual machines are marked with a Next Run Configuration symbol to denote the requirement for rebooting them as soon as possible after the cluster version upgrade.
 - [BZ 1356488](https://bugzilla.redhat.com/show_bug.cgi?id=1356488) <b>Edit VM Pool show wrong storage domain</b><br>With this update, a new option been added to the options for a virtual machine pool for disk storage. This option allows the user to select Auto Select Disk Target, instead of a specific domain. This means that every new virtual machine in the pool will use the storage domain with the most available space.
 - [BZ 1310804](https://bugzilla.redhat.com/show_bug.cgi?id=1310804) <b>[RFE] Override instance type on VmPools in Python-SDK</b><br>The instance type field was missing in the REST API virtual machine pool resource. This update adds the ability to pick one when creating the virtual machine pool, and to report the currently configured one.

#### VDSM

##### Team: Gluster

 - [BZ 1225728](https://bugzilla.redhat.com/show_bug.cgi?id=1225728) <b>[RFE][HC] vdsm-gluster to be build as part of RHEV vdsm build</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1313917](https://bugzilla.redhat.com/show_bug.cgi?id=1313917) <b>[RFE] allow NFS hosted-engine system started on 3.4 to upgrade its filebase metadata and lockspace area to a VDSM volume as for fresh deployments</b><br>This update supports the self-hosted engine upgrade path from Red Hat Enterprise Virtualization 3.4 to Red Hat Virtualization 4.0 by migrating filebase metadata and lockspace.

#### oVirt Engine DWH

##### Team: DWH

 - [BZ 1349309](https://bugzilla.redhat.com/show_bug.cgi?id=1349309) <b>Lower interval collection rate (to improve monitoring for System Dashboard)</b><br>The sampling interval default time has been decreased from 1 minute to 20 seconds to provide more accurate calculations for the new dashboards.

#### oVirt Cockpit Plugin

##### Team: Virt

 - [BZ 1358783](https://bugzilla.redhat.com/show_bug.cgi?id=1358783) <b>webadmin-cockpit-ui-plugin: Show instructions how to accept Cockpit's SSL certificate</b><br>This update improves the error message received when Cockpit cannot be displayed in the Administration portal's Host's sub-tab. The error now includes SSL certificate information and a link to the Cockpit ping page.

### Unclassified

#### oVirt Engine

##### Team: DWH

 - [BZ 1344935](https://bugzilla.redhat.com/show_bug.cgi?id=1344935) <b>"Can not sample data, oVirt Engine is not updating the statistics" shown when dwh_sampling and engine DwhHeartBeatInterval  do not match</b><br>

##### Team: Infra

 - [BZ 1357296](https://bugzilla.redhat.com/show_bug.cgi?id=1357296) <b>v3 API | Failed to delete a specified storage domain in the system</b><br>
 - [BZ 1357452](https://bugzilla.redhat.com/show_bug.cgi?id=1357452) <b>User is not logged out from userportal on session timeout</b><br>
 - [BZ 1356675](https://bugzilla.redhat.com/show_bug.cgi?id=1356675) <b>[AAA] Can't add IPA directory users to VM permissions</b><br>
 - [BZ 1337240](https://bugzilla.redhat.com/show_bug.cgi?id=1337240) <b>When using v4 rest api with request, which is valid for v3 compatibility requests, incorrect suggestion how request should look like is offered by system</b><br>
 - [BZ 1353460](https://bugzilla.redhat.com/show_bug.cgi?id=1353460) <b>API: exception on engine while trying add an event via API (due to the use of cluster name. Workaround: use cluster ID)</b><br>
 - [BZ 1361619](https://bugzilla.redhat.com/show_bug.cgi?id=1361619) <b>v3 API | The link to activate a vm's disk is broken</b><br>
 - [BZ 1354452](https://bugzilla.redhat.com/show_bug.cgi?id=1354452) <b>[notifier] drop mentioning AES192 and AES256 in notifier.conf</b><br>
 - [BZ 1352953](https://bugzilla.redhat.com/show_bug.cgi?id=1352953) <b>show descriptive error  message when sending a negative number like: {url}/events;max=-3</b><br>
 - [BZ 1355647](https://bugzilla.redhat.com/show_bug.cgi?id=1355647) <b>Capabilities entry point missing</b><br>
 - [BZ 1352721](https://bugzilla.redhat.com/show_bug.cgi?id=1352721) <b>Users with '%' in their password, cannot log in.</b><br>
 - [BZ 1350353](https://bugzilla.redhat.com/show_bug.cgi?id=1350353) <b>[UI] - New cluster - Authorization provider: <UNKNOWN> was granted permission for Role CpuProfileOperator on Cpu Profile <UNKNOWN>, by admin@internal-authz when creating new cluster</b><br>
 - [BZ 1352575](https://bugzilla.redhat.com/show_bug.cgi?id=1352575) <b>v3 REST API | job object status description should be in upper case letters and inside a <state> entry</b><br>
 - [BZ 1350399](https://bugzilla.redhat.com/show_bug.cgi?id=1350399) <b>NPE during compensation on startup</b><br>

##### Team: Integration

 - [BZ 1354465](https://bugzilla.redhat.com/show_bug.cgi?id=1354465) <b>engine-setup suggests to install DWH and Reports</b><br>
 - [BZ 1343155](https://bugzilla.redhat.com/show_bug.cgi?id=1343155) <b>ovirt-engine fails to start with python-daemon-2.1.0 installed</b><br>

##### Team: Network

 - [BZ 1359668](https://bugzilla.redhat.com/show_bug.cgi?id=1359668) <b>Failed to import VM from any source</b><br>
 - [BZ 1367483](https://bugzilla.redhat.com/show_bug.cgi?id=1367483) <b>Installing a 3.6 host to rhev-m 4.0 results in 'ovirtmgmt' network as out of sync</b><br>
 - [BZ 1364787](https://bugzilla.redhat.com/show_bug.cgi?id=1364787) <b>Installing a 3.6 host on a 3.6 cluster cause host to stuck on activating state</b><br>
 - [BZ 1364145](https://bugzilla.redhat.com/show_bug.cgi?id=1364145) <b>Forbid mixing QoS and non-QoS on the same NIC</b><br>
 - [BZ 1351145](https://bugzilla.redhat.com/show_bug.cgi?id=1351145) <b>Register unregistered templates (import storage domain) failed via REST</b><br>

##### Team: SLA

 - [BZ 1364048](https://bugzilla.redhat.com/show_bug.cgi?id=1364048) <b>[API] Not possible to access /clusters collection in user level api in version 3 of the API</b><br>
 - [BZ 1340626](https://bugzilla.redhat.com/show_bug.cgi?id=1340626) <b>Support update of the HE OVF ad-hoc</b><br>
 - [BZ 1350861](https://bugzilla.redhat.com/show_bug.cgi?id=1350861) <b>After configuring custom VM numa topologies updating the VM in the UI is impossible</b><br>
 - [BZ 1348640](https://bugzilla.redhat.com/show_bug.cgi?id=1348640) <b>HE can't get started if a new vNIC was added with an empty profile.</b><br>
 - [BZ 1350423](https://bugzilla.redhat.com/show_bug.cgi?id=1350423) <b>Hosted-Engine tab not hidden in UI for host in maintenance.</b><br>
 - [BZ 1343934](https://bugzilla.redhat.com/show_bug.cgi?id=1343934) <b>CPU Profile is not assigned when changing it on a running VM</b><br>

##### Team: Storage

 - [BZ 1364783](https://bugzilla.redhat.com/show_bug.cgi?id=1364783) <b>V3 API | Attach disk to vm with active=true isn't working</b><br>
 - [BZ 1356649](https://bugzilla.redhat.com/show_bug.cgi?id=1356649) <b>Template's & VMs disks link is wrongly calculated in rest API V3</b><br>
 - [BZ 1357987](https://bugzilla.redhat.com/show_bug.cgi?id=1357987) <b>In v4, GET to /disks/{disk:id} returns property <active></b><br>
 - [BZ 1358729](https://bugzilla.redhat.com/show_bug.cgi?id=1358729) <b>image upload dialog - Image Source panel should be removed</b><br>
 - [BZ 1349498](https://bugzilla.redhat.com/show_bug.cgi?id=1349498) <b>When a VM is started, attached disks can't be edited anymore</b><br>
 - [BZ 1359632](https://bugzilla.redhat.com/show_bug.cgi?id=1359632) <b>[engine-webadmin-portal] Tool-tip is not displayed when hot-plug disk is not supported</b><br>
 - [BZ 1357431](https://bugzilla.redhat.com/show_bug.cgi?id=1357431) <b>"Scan Disks" option should be disabled for Export and ISO storage domains</b><br>
 - [BZ 1361845](https://bugzilla.redhat.com/show_bug.cgi?id=1361845) <b>Require ovirt-imageio-proxy</b><br>
 - [BZ 1360776](https://bugzilla.redhat.com/show_bug.cgi?id=1360776) <b>image upload - UI styling modifications</b><br>
 - [BZ 1359736](https://bugzilla.redhat.com/show_bug.cgi?id=1359736) <b>Image upload - volume format COW is not available</b><br>
 - [BZ 1358432](https://bugzilla.redhat.com/show_bug.cgi?id=1358432) <b>Storage allocation table in New VM dialog has shifted columns</b><br>
 - [BZ 1353430](https://bugzilla.redhat.com/show_bug.cgi?id=1353430) <b>RHEV-M should rescan the scsi bus when creating and attaching a new FC storage domain</b><br>
 - [BZ 1358860](https://bugzilla.redhat.com/show_bug.cgi?id=1358860) <b>Api v3 error return null in disk search</b><br>
 - [BZ 1359489](https://bugzilla.redhat.com/show_bug.cgi?id=1359489) <b>missing diskVmElement.diskInterface error when extending a Cinder disk</b><br>
 - [BZ 1358727](https://bugzilla.redhat.com/show_bug.cgi?id=1358727) <b>image upload - no validation for file selection</b><br>
 - [BZ 1354547](https://bugzilla.redhat.com/show_bug.cgi?id=1354547) <b>UI exception thrown when creating new profile and moving to another sub tab</b><br>
 - [BZ 1353229](https://bugzilla.redhat.com/show_bug.cgi?id=1353229) <b>Upload image: default values for Image Type and  Allocation Policy don't integrate</b><br>
 - [BZ 1352855](https://bugzilla.redhat.com/show_bug.cgi?id=1352855) <b>Storage domain is not selectable when uploading a disk from "disks" tab</b><br>
 - [BZ 1352825](https://bugzilla.redhat.com/show_bug.cgi?id=1352825) <b>CommandEntity record isn't cleared for commands with callback that fails on validate() till the next engine restart.</b><br>
 - [BZ 1353604](https://bugzilla.redhat.com/show_bug.cgi?id=1353604) <b>endAction() is wrongly executed for commands with callback that fails on validate() on the next engine restart.</b><br>
 - [BZ 1353196](https://bugzilla.redhat.com/show_bug.cgi?id=1353196) <b>QCOW image upload to block storage is limited to 1GB</b><br>
 - [BZ 1352676](https://bugzilla.redhat.com/show_bug.cgi?id=1352676) <b>When a disk finished uploading to a storage domain, it's status turns to Illegal</b><br>
 - [BZ 1351636](https://bugzilla.redhat.com/show_bug.cgi?id=1351636) <b>Wrong warning when hotpluging a disk is not supported</b><br>
 - [BZ 1352657](https://bugzilla.redhat.com/show_bug.cgi?id=1352657) <b>GET of diskattachment returns a list of objects without the href property</b><br>

##### Team: UX

 - [BZ 1359504](https://bugzilla.redhat.com/show_bug.cgi?id=1359504) <b>UX: exception when clicking on a host's 'Software' subtab</b><br>
 - [BZ 1360920](https://bugzilla.redhat.com/show_bug.cgi?id=1360920) <b>some messages reference RHEV when they should reference RHV</b><br>
 - [BZ 1347109](https://bugzilla.redhat.com/show_bug.cgi?id=1347109) <b>fix login and welcome pages to conform to PatternFly standards more closely</b><br>
 - [BZ 1360403](https://bugzilla.redhat.com/show_bug.cgi?id=1360403) <b>dashboard: '-1' is show in CPU utilization (initially, then it goes to 0)</b><br>
 - [BZ 1347807](https://bugzilla.redhat.com/show_bug.cgi?id=1347807) <b>Welcome page: background is truncated when scrolling</b><br>
 - [BZ 1358160](https://bugzilla.redhat.com/show_bug.cgi?id=1358160) <b>Dashboard show zeros. reports-interface-proxy doesn't trust externally-issued web certificate in spite of issuer being in system (and java) trust store</b><br>
 - [BZ 1357070](https://bugzilla.redhat.com/show_bug.cgi?id=1357070) <b>oVirt 4.0 translation update post intl-QA</b><br>

##### Team: Virt

 - [BZ 1360265](https://bugzilla.redhat.com/show_bug.cgi?id=1360265) <b>Engine doesn't start because of outdated entry of RunVm in command_entities</b><br>
 - [BZ 1357630](https://bugzilla.redhat.com/show_bug.cgi?id=1357630) <b>VMs > 'Guest Info' subtab throws FE exception while switching VMs</b><br>
 - [BZ 1357440](https://bugzilla.redhat.com/show_bug.cgi?id=1357440) <b>Cannot create an instance type via UI - gwt error</b><br>
 - [BZ 1354494](https://bugzilla.redhat.com/show_bug.cgi?id=1354494) <b>VMs in unknown status and no run_on_vds</b><br>
 - [BZ 1351200](https://bugzilla.redhat.com/show_bug.cgi?id=1351200) <b>Remove warning of unsupported migration with Native USB on clusters < 3.2</b><br>
 - [BZ 1351283](https://bugzilla.redhat.com/show_bug.cgi?id=1351283) <b>Host kernel configuration: mention reinstall and reboot host is needed as part of webadmin kernel modification procedure.</b><br>
 - [BZ 1354495](https://bugzilla.redhat.com/show_bug.cgi?id=1354495) <b>v2v: import dialog - "external provider" field is not refreshed when changing DC field value</b><br>
 - [BZ 1351477](https://bugzilla.redhat.com/show_bug.cgi?id=1351477) <b>Missing property for Origin KVM</b><br>
 - [BZ 1350501](https://bugzilla.redhat.com/show_bug.cgi?id=1350501) <b>v2v: '?' tooltip in import dialog is located incorrectly.</b><br>
 - [BZ 1359885](https://bugzilla.redhat.com/show_bug.cgi?id=1359885) <b>[API v3] Adding a vm with payload fails with internal server error</b><br>
 - [BZ 1354463](https://bugzilla.redhat.com/show_bug.cgi?id=1354463) <b>Cannot add a permission for a vmPool to a user via API v4</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1359648](https://bugzilla.redhat.com/show_bug.cgi?id=1359648) <b>add deprecation warning to vdscli module</b><br>

##### Team: Network

 - [BZ 1356635](https://bugzilla.redhat.com/show_bug.cgi?id=1356635) <b>RHVH can't obtain ip over bond+vlan network after anaconda interactive installation.</b><br>
 - [BZ 1350883](https://bugzilla.redhat.com/show_bug.cgi?id=1350883) <b>vdscli.connect's heuristic ends up reading the local server address from vdsm config, where it finds the default ipv6-local address of "::".</b><br>

##### Team: Storage

 - [BZ 1339780](https://bugzilla.redhat.com/show_bug.cgi?id=1339780) <b>Require fix for bug 1339777 - ioprocess keep open file on shared storage after touching or truncating a file</b><br>
 - [BZ 1349529](https://bugzilla.redhat.com/show_bug.cgi?id=1349529) <b>VDSM to require qemu-kvm-ev delivered by bug 1349525</b><br>
 - [BZ 1342397](https://bugzilla.redhat.com/show_bug.cgi?id=1342397) <b>Vdsm cannot parse the output of dd from coreutils 8.25.5</b><br>

##### Team: Virt

 - [BZ 1364149](https://bugzilla.redhat.com/show_bug.cgi?id=1364149) <b>VDSM memory leak in logging warnings</b><br>
 - [BZ 1354344](https://bugzilla.redhat.com/show_bug.cgi?id=1354344) <b>wait properly for migration to begin</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1358255](https://bugzilla.redhat.com/show_bug.cgi?id=1358255) <b>unlogical appearance of ' Hosted Engine upgrade failed: this system is not reliable.'</b><br>Making the exit message context aware: using softer exit messages if the error occured before<br>the tool really touched the system.
 - [BZ 1356221](https://bugzilla.redhat.com/show_bug.cgi?id=1356221) <b>hosted-engine --ugprade-appliance fails with glusterfs based SHE</b><br>

#### oVirt Hosted Engine HA

##### Team: Integration

 - [BZ 1364034](https://bugzilla.redhat.com/show_bug.cgi?id=1364034) <b>Hosted Engine always show "Not running" status in cockpit after deploy it.</b><br>

#### oVirt Engine SDK 4 Java

##### Team: Infra

 - [BZ 1349857](https://bugzilla.redhat.com/show_bug.cgi?id=1349857) <b><link> element is not parsed</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1351585](https://bugzilla.redhat.com/show_bug.cgi?id=1351585) <b>Dashboard does not load on IE11</b><br>
 - [BZ 1347117](https://bugzilla.redhat.com/show_bug.cgi?id=1347117) <b>Spacing should be changed to fit the dashboard in 1920x1080 resolution</b><br>
 - [BZ 1360459](https://bugzilla.redhat.com/show_bug.cgi?id=1360459) <b>oVirt 4.0 translation cycle 3</b><br>
 - [BZ 1360403](https://bugzilla.redhat.com/show_bug.cgi?id=1360403) <b>dashboard: '-1' is show in CPU utilization (initially, then it goes to 0)</b><br>
 - [BZ 1347009](https://bugzilla.redhat.com/show_bug.cgi?id=1347009) <b>Inventory Warning icon is not vertically aligned with the other icons</b><br>
 - [BZ 1357104](https://bugzilla.redhat.com/show_bug.cgi?id=1357104) <b>oVirt 4.0 translation update post intl-QA</b><br>

#### oVirt Engine DWH

##### Team: DWH

 - [BZ 1354150](https://bugzilla.redhat.com/show_bug.cgi?id=1354150) <b>Missing "disks_vm_map" table in oVirt 4 DWH</b><br>

#### oVirt Cockpit Plugin

##### Team: Node

 - [BZ 1355617](https://bugzilla.redhat.com/show_bug.cgi?id=1355617) <b>Node info spill out of the box on cockpit UI via Internet Explorer 11</b><br>
 - [BZ 1356847](https://bugzilla.redhat.com/show_bug.cgi?id=1356847) <b>The info window does not prompt when selecting the buttons (Information/Health/Layers/Show) in virtualization dashboard for the second times.</b><br>

## Bug fixes

### oVirt Engine

#### Team: Gluster

 - [BZ 1303878](https://bugzilla.redhat.com/show_bug.cgi?id=1303878) <b>Gluster: Exceptions are flooded in the RHEVM UI, when there is no activity in  Volume's tab  Activities column</b><br>
 - [BZ 1255590](https://bugzilla.redhat.com/show_bug.cgi?id=1255590) <b>Gluster: Variables in an error message are not replaced when it is shown on screen</b><br>

#### Team: Infra

 - [BZ 1226561](https://bugzilla.redhat.com/show_bug.cgi?id=1226561) <b>Command-coordination: re-acquire engine lock after engine restart</b><br>
 - [BZ 1219147](https://bugzilla.redhat.com/show_bug.cgi?id=1219147) <b>oVirt's message mechanism should permit space allocation warnings to be thrown</b><br>

#### Team: Integration

 - [BZ 1350397](https://bugzilla.redhat.com/show_bug.cgi?id=1350397) <b>OpenJDK-1.8 missing in required packages</b><br>
 - [BZ 1331168](https://bugzilla.redhat.com/show_bug.cgi?id=1331168) <b>engine-setup should check postgresql version compatibility for remote DBs</b><br>

#### Team: Network

 - [BZ 1324479](https://bugzilla.redhat.com/show_bug.cgi?id=1324479) <b>race between SetupNetwork and event-triggered getVdsCaps</b><br>
 - [BZ 1324125](https://bugzilla.redhat.com/show_bug.cgi?id=1324125) <b>macpool addresses are not forced to lowercase</b><br>
 - [BZ 1333728](https://bugzilla.redhat.com/show_bug.cgi?id=1333728) <b>Rest API allows creating network providers without required fields.</b><br>

#### Team: SLA

 - [BZ 1351533](https://bugzilla.redhat.com/show_bug.cgi?id=1351533) <b>Cant upgrade to new cluster version when HE VM is running in it</b><br>
 - [BZ 1324830](https://bugzilla.redhat.com/show_bug.cgi?id=1324830) <b>Update VM NUMA pinning via host menu, when VM run will result to VM failed to start on next run</b><br>
 - [BZ 1260381](https://bugzilla.redhat.com/show_bug.cgi?id=1260381) <b>Incorrect behavior of power saving weight module</b><br>
 - [BZ 1339640](https://bugzilla.redhat.com/show_bug.cgi?id=1339640) <b>scheduling policy overcommitminduration is not editable</b><br>
 - [BZ 1351556](https://bugzilla.redhat.com/show_bug.cgi?id=1351556) <b>LowUtiliztion parameter does not exist under power_saving policy</b><br>

#### Team: UX

 - [BZ 1230159](https://bugzilla.redhat.com/show_bug.cgi?id=1230159) <b>remove underline for tool-tipped column headers</b><br>
 - [BZ 1320559](https://bugzilla.redhat.com/show_bug.cgi?id=1320559) <b>[Webadmin] uncaught exception notification repeats endlessly</b><br>

#### Team: Virt

 - [BZ 1351886](https://bugzilla.redhat.com/show_bug.cgi?id=1351886) <b>Unable to create VM when changing template</b><br>
 - [BZ 1128453](https://bugzilla.redhat.com/show_bug.cgi?id=1128453) <b>[REST API]: VM next_run do not have all fields updated.</b><br>
 - [BZ 1296127](https://bugzilla.redhat.com/show_bug.cgi?id=1296127) <b>string showing number of cores of VM in basictab in 3.6 is harder to read than in 3.5</b><br>
 - [BZ 1349526](https://bugzilla.redhat.com/show_bug.cgi?id=1349526) <b>Incorrect error message while VM migration is running</b><br>
 - [BZ 1346848](https://bugzilla.redhat.com/show_bug.cgi?id=1346848) <b>VmPoolMonitor does not log reason for VM prestart failure</b><br>
 - [BZ 1315100](https://bugzilla.redhat.com/show_bug.cgi?id=1315100) <b>Command 'org.ovirt.engine.core.bll.hostdev.RefreshHostDevicesCommand' failed: Failed managing transaction</b><br>

### VDSM

#### Team: Storage

 - [BZ 1260428](https://bugzilla.redhat.com/show_bug.cgi?id=1260428) <b>[vdsm] Cannot upgrade storage pool when there was/is an unavailable domain</b><br>
 - [BZ 1344289](https://bugzilla.redhat.com/show_bug.cgi?id=1344289) <b>Add compat level verification for uploaded QCOW</b><br>

### oVirt Hosted Engine Setup

#### Team: Network

 - [BZ 1364615](https://bugzilla.redhat.com/show_bug.cgi?id=1364615) <b>3.4->3.5->3.6->4.0 SHE migration fails /  The following existing interfaces are not suitable for vdsm: vnet0,eth0.</b><br>

### oVirt Release RPM

#### Team: Node

 - [BZ 1333091](https://bugzilla.redhat.com/show_bug.cgi?id=1333091) <b>Web UI theme doesn't fit 16:9 screens / background is not scaled/streched correctly</b><br>

