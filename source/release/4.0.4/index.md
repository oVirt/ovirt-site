---
title: oVirt 4.0.4 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.0.4 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.4
Release as of September 26th, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

An updated documentation has been provided by our downstream 
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization?version=4.0/)


## Install / Upgrade from previous versions

Users upgrading from 3.6 should be aware of following 4.0 changes around
authentication and certificates handling:

1. Single Sign-On using OAUTH2 protocol has been implemented in engine to
   allow SSO between webadmin, userportal and RESTAPI. More information can
   be found at https://bugzilla.redhat.com/1092744

2. Due to SSO it's required to access engine only using the same FQDN which
   was specified during engine-setup invocation. If your engine FQDN is not
   accessible from all engine clients, you will not be able to login. Please
   use ovirt-engine-rename tool to fix your FQDN, more information can be
   found at https://www.ovirt.org/documentation/how-to/networking/changing-engine-hostname/ .
   If you try to access engine using IP or DNS alias, an error will be
   thrown. Please consult following bugs targeted to oVirt 4.0.4 which
   should fix this limitation:
     https://bugzilla.redhat.com/1325746
     https://bugzilla.redhat.com/1362196

3. If you have used Kerberos SSO to access engine, please consult
   https://bugzilla.redhat.com/1342192 how to update your Apache
   configuration after upgrade to 4.0

4. If you are using HTTPS certificate signed by custom certificate
   authority, please take a look at https://bugzilla.redhat.com/1336838
   for steps which need to be done after migration to 4.0. Also please
   consult https://bugzilla.redhat.com/1313379 how to setup this custom
   CA for use with virt-viewer clients.



### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm)

and then follow documentation from our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/)

If you're upgrading from a previous release on Enterprise Linux 7 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should follow our [Migration Guide](../../documentation/migration-engine-36-to-40/) in order to migrate to Enterprise Linux 7 or Fedora 23.

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow
[Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide or the
corresponding Red Hat Virtualization [Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide
or the corresponding Red Hat Virtualization [Upgrade Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/)

## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.


## What's New in 4.0.4?

### Enhancements

#### oVirt Engine

##### Team: Infra

 - [BZ 1344020](https://bugzilla.redhat.com/1344020) <b>host upgrade should upgrade all oVirt related packages, not just "vdsm"</b><br>Previously, the host upgrade manager in the Administration Portal only checked and applied updates for the vdsm and vdsm-cli packages. Other packages had to be updated manually using "yum update". With this release, the list of packages that the host upgrade manager checks and updates has been extended to include ioprocess, mom, libvirt-client, libvirt-daemon-config-nwfilter, libvirt-daemon-kvm, libvirt-lock-sanlock, libvirt-python, lvm2, ovirt-imageio-common, ovirt-imageio-daemon, ovirt-vmconsole, ovirt-vmconsole-host, python-ioprocess, qemu-kvm, qemu-img, sanlock, along with vdsm and vdsm-cli.

##### Team: Virt

 - [BZ 1302657](https://bugzilla.redhat.com/1302657) <b>[RFE] Switch from vnc/cirrus to vnc/vga</b><br>With this update, the default VNC graphics in Red Hat Virtualization 4.0 is VGA. Imported virtual machines with VNC/Cirrus, and originating in previous compatibility versions, are automatically upgraded to VNC/VGA. However, QXL is still the preferred default graphics, if the guest operating system supports it.

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1333449](https://bugzilla.redhat.com/1333449) <b>RFE: Remove virt-viewer dependency in favor of text only method</b><br>Change --console option to provide access to serial console instead of calling virt-viewer.
 - [BZ 1368604](https://bugzilla.redhat.com/1368604) <b>HE_APPLIANCE_ENGINE_SETUP_FAIL - Setup found legacy kerberos/ldap directory intergration</b><br>oVirt 4.0 doesn't support anymore the legacy directory integration. Adding a check for it in the upgrade procedure since the migration to the new aaa provider could to be performed only while on 3.6

#### MOM

##### Team: SLA

 - [BZ 1201482](https://bugzilla.redhat.com/1201482) <b>Storage QoS is not applying on a Live VM/disk</b><br>To properly support disk hot plug and disk QoS changes for a running virtual machine, MoM is updated and now reads the IO QoS settings from metadata and sets the respective ioTune limits to a running virtual machine's disk.

### Unclassified

#### oVirt Engine

##### Team: Gluster

 - [BZ 1353289](https://bugzilla.redhat.com/1353289) <b>Gluster: creating a brick display TiB instead GiB as size for block device</b><br>

##### Team: Infra

 - [BZ 1367557](https://bugzilla.redhat.com/1367557) <b>HA VMs are not restarted on different host if NonResponsive host is off and start action failed</b><br>
 - [BZ 1368552](https://bugzilla.redhat.com/1368552) <b>User unable to query disks of assigned VM</b><br>
 - [BZ 1366794](https://bugzilla.redhat.com/1366794) <b>API V3: can't force delete datacenter</b><br>
 - [BZ 1371515](https://bugzilla.redhat.com/1371515) <b>Exception on GetUserProfileQuery (unknown cause) : "The column name user_portal_vm_auto_login was not found in this ResultSet"</b><br>
 - [BZ 1362459](https://bugzilla.redhat.com/1362459) <b>Fix our own implementation uuid_generate_v1() to produce more random values</b><br>
 - [BZ 1368134](https://bugzilla.redhat.com/1368134) <b>The Host OS version parts are not reported</b><br>
 - [BZ 1367921](https://bugzilla.redhat.com/1367921) <b>[AAA] "Request state does not match session state" after successful login</b><br>
 - [BZ 1366927](https://bugzilla.redhat.com/1366927) <b>Wrong error message passed from SSO on password grant type failure</b><br>
 - [BZ 1364804](https://bugzilla.redhat.com/1364804) <b>[engine-backend] Compensation context data is cleared although the data wasn't reverted on parent-child command scenario</b><br>
 - [BZ 1367398](https://bugzilla.redhat.com/1367398) <b>remove org.ovirt.engine.api.json and org.ovirt.engine.api.xml packages</b><br>
 - [BZ 1367400](https://bugzilla.redhat.com/1367400) <b>cpu_profile permits are missing under /capabilities in v3</b><br>
 - [BZ 1360378](https://bugzilla.redhat.com/1360378) <b>engine startup fails if you have commands in command_entity table that refer to entities that have already been removed</b><br>
 - [BZ 1360373](https://bugzilla.redhat.com/1360373) <b>When failing on command execution after one task was created the command will reach endSuccesfully() instead of endWithFailure()</b><br>
 - [BZ 1362196](https://bugzilla.redhat.com/1362196) <b>aaa: Add support for dynamic porting</b><br>A new config variable has been added ENGINE_SSO_INSTALLED_ON_ENGINE_HOST.<br><br>This flag can be used to specify if the SSO service is installed on the same host as the engine or installed on a different host. If set to true the URL and port used to access engine is used to redirect to the login page. If set to false the value set in ENGINE_SSO_AUTH_URL is used to redirect user to login page.
 - [BZ 1359139](https://bugzilla.redhat.com/1359139) <b>The "creation_status" resources don't work with V3</b><br>
 - [BZ 1358434](https://bugzilla.redhat.com/1358434) <b>Restapi access should create sessions only if persistent_auth is requested</b><br>

##### Team: Integration

 - [BZ 1372230](https://bugzilla.redhat.com/1372230) <b>Cannot setup a separate host for DWH after upgrading to oVirt 4 (4.0.3)</b><br>

##### Team: Network

 - [BZ 1374475](https://bugzilla.redhat.com/1374475) <b>REST V3 and V4| ovirt-engine/api/events return Operation Failed</b><br>
 - [BZ 1372950](https://bugzilla.redhat.com/1372950) <b>Engine fail to start with NPE No default constructor for ManageNetworkClustersParameters["attachments"]</b><br>
 - [BZ 1371119](https://bugzilla.redhat.com/1371119) <b>Null ipv6 in IpConfiguration after 3.6->4.0 upgrade</b><br>
 - [BZ 1359643](https://bugzilla.redhat.com/1359643) <b>The page /api/v3/networkfilters does not exist, while the link to networkfilters under /api/v3 does exist</b><br>

##### Team: SLA

 - [BZ 1339660](https://bugzilla.redhat.com/1339660) <b>Hosted Engine's disk is in Unassigned Status in the RHEV UI</b><br>
 - [BZ 1350228](https://bugzilla.redhat.com/1350228) <b>Add affinity label to the VM or to the host does not return in response body entity</b><br>
 - [BZ 1361838](https://bugzilla.redhat.com/1361838) <b>[Disk profile] Cannot add VM. Disk Profile YYY with id XXX is not assigned to Storage Domain ZZZ</b><br>
 - [BZ 1359483](https://bugzilla.redhat.com/1359483) <b>[Admin Portal] Uncaught exception during deletion of disk profiles on storage domain</b><br>
 - [BZ 1346250](https://bugzilla.redhat.com/1346250) <b>Can not delete read_only affinity label</b><br>
 - [BZ 1351519](https://bugzilla.redhat.com/1351519) <b>Audit error connect to affinity labels under engine.log</b><br>
 - [BZ 1342928](https://bugzilla.redhat.com/1342928) <b>Pass through host CPU is not enabled with manual migration</b><br>
 - [BZ 1353059](https://bugzilla.redhat.com/1353059) <b>Slightly misleading log when using OptimalForPowerSaving Balancer.</b><br>

##### Team: Storage

 - [BZ 1369024](https://bugzilla.redhat.com/1369024) <b>[API] Can't attach disk to VM with UserVMManager role</b><br>
 - [BZ 1357548](https://bugzilla.redhat.com/1357548) <b>RFE: upload image - verify image format on client side</b><br>
 - [BZ 1372650](https://bugzilla.redhat.com/1372650) <b>Can not edit description and comment for a storage domain after activation.</b><br>
 - [BZ 1371304](https://bugzilla.redhat.com/1371304) <b>Uncaught exception occured when try to import Virtual Machine from Export domain</b><br>Previously, when trying to import a vm that is based on a template from an export domain via the webadmin, if the template did not exist then a UI error was shown and the new popup window got stuck.<br>Now the popup window is loaded and a red warning is shown - "Some imported VMs depend on one or more templates which are not available in the system. Therefore you must Import those VMs with 'collapse snapshots', another option is to Import missing templates first and then try import the VMs again".<br><br>This is a UI issue, so it does not occur in REST API and SDKs.
 - [BZ 1371164](https://bugzilla.redhat.com/1371164) <b>New VM created without disk</b><br>
 - [BZ 1370101](https://bugzilla.redhat.com/1370101) <b>RefreshLunsSizeCommand doesn't update the new LUNs' sizes in the DB</b><br>Previously, after resizing a lun, checking the storage domain's size gave us the new value, but checking the lun's size gave us the old one.<br>This bug was fixed and now the new size is immediately updated, so checking it right after the resize brings the updated value.
 - [BZ 1370912](https://bugzilla.redhat.com/1370912) <b>Compensation mechanism does not work for RefreshLunsSizeCommand</b><br>
 - [BZ 1368954](https://bugzilla.redhat.com/1368954) <b>CDA log of attaching second boot disk is wrong</b><br>
 - [BZ 1365087](https://bugzilla.redhat.com/1365087) <b>new VM disk is not marked as "bootable" by default</b><br>
 - [BZ 1367416](https://bugzilla.redhat.com/1367416) <b>Missing Scroll bar for VG selection in  "Import Pre-Configured Domain" window</b><br>
 - [BZ 1365393](https://bugzilla.redhat.com/1365393) <b>Delete disk snapshots (in the storage->disk snapshots subtab) fails to update engine database</b><br>
 - [BZ 1364780](https://bugzilla.redhat.com/1364780) <b>Failure when updating VM that is previewing a snapshot</b><br>
 - [BZ 1359788](https://bugzilla.redhat.com/1359788) <b>[engine-backend] Storage domain gets stuck in locked during storage pool initialization after a CreateStoragePool failure</b><br>
 - [BZ 1352857](https://bugzilla.redhat.com/1352857) <b>image upload: informative message is required when disk's entered values are not valid</b><br>
 - [BZ 1358271](https://bugzilla.redhat.com/1358271) <b>[v4 API only]: <logical_name> property (device name for disk) missing from disk attachments v4</b><br>

##### Team: UX

 - [BZ 1371195](https://bugzilla.redhat.com/1371195) <b>Calculation of average storage domains is wrong for dashboards</b><br>
 - [BZ 1364337](https://bugzilla.redhat.com/1364337) <b>iSCSI Initiator Name is not wrapped</b><br>
 - [BZ 1365980](https://bugzilla.redhat.com/1365980) <b>Hide the Reports-related "Dashboard" main tab</b><br>
 - [BZ 1369235](https://bugzilla.redhat.com/1369235) <b>main/sub tab action buttons added by UI plugins are not shown</b><br>
 - [BZ 1361656](https://bugzilla.redhat.com/1361656) <b>UI plugin API: loginUserName and loginUserId functions return null before WebAdmin UI is fully initialized</b><br>

##### Team: Virt

 - [BZ 1356172](https://bugzilla.redhat.com/1356172) <b>the message "snapshot created in different cluster version" is shown all the time</b><br>
 - [BZ 1362525](https://bugzilla.redhat.com/1362525) <b>Import KVM guest image: cannot convert VM with block device to block device.</b><br>User cannot import VM from KVM source to oVirt when the destination storage domain is block device due to incorrect disk allocation space.<br>Our current solution is allocating the virtual size of the disk.
 - [BZ 1361860](https://bugzilla.redhat.com/1361860) <b>VMs stuck in shutting down</b><br>
 - [BZ 1366138](https://bugzilla.redhat.com/1366138) <b>Reduce the frequency of logged number of running VMs</b><br>
 - [BZ 1364164](https://bugzilla.redhat.com/1364164) <b>Import KVM guest image: cannot import VM as clone</b><br>
 - [BZ 1340414](https://bugzilla.redhat.com/1340414) <b>shutting down VM produces extra message</b><br>
 - [BZ 1340025](https://bugzilla.redhat.com/1340025) <b>v2v: import dialog - invalid error message while opening dialog saying "no Export Domain is active"</b><br>
 - [BZ 1337619](https://bugzilla.redhat.com/1337619) <b>Redundant disk allocation label in VM dialogs if the template does not have disks</b><br>
 - [BZ 1373204](https://bugzilla.redhat.com/1373204) <b>[UI] Creating a vm/vmpool from a template with custom cluster compatibility via webadmin results in an infinite loop</b><br>
 - [BZ 1373103](https://bugzilla.redhat.com/1373103) <b>Import dialog: "OK" button stops to function in case of moving back from second dialog to first dialog.</b><br>
 - [BZ 1364171](https://bugzilla.redhat.com/1364171) <b>import dialog: Incorrect dialog behavior when trying to import VM with name duplication in RHEVM.</b><br>
 - [BZ 1351542](https://bugzilla.redhat.com/1351542) <b>Help message about URI: Import virtual machine from XEN should update and from KVM should add</b><br>
 - [BZ 1360914](https://bugzilla.redhat.com/1360914) <b>Create Snapshot UI Dialog missing scrollbar</b><br>
 - [BZ 1360397](https://bugzilla.redhat.com/1360397) <b>host installed with bad kernel cmdline for nested virtualization</b><br>
 - [BZ 1361193](https://bugzilla.redhat.com/1361193) <b>v2v: import dialog - SSL Verification field for VMware should be renamed to "verify server's SSL certificate"</b><br>
 - [BZ 1354511](https://bugzilla.redhat.com/1354511) <b>v2v: import dialog - tooltip for URI field of XEN source is truncated</b><br>

#### oVirt Engine SDK 4 Java

##### Team: Infra

 - [BZ 1376402](https://bugzilla.redhat.com/1376402) <b>Multiple threads should be able to reuse connection of the SDK</b><br>
 - [BZ 1372652](https://bugzilla.redhat.com/1372652) <b>The RPM for version 4 of the Java SDK doesn't include the Maven provides/requires</b><br>

#### oVirt Engine SDK 4 Python

##### Team: Infra

 - [BZ 1373431](https://bugzilla.redhat.com/1373431) <b>Reading empty list of elements doesn't work correctly</b><br>
 - [BZ 1367020](https://bugzilla.redhat.com/1367020) <b>Non descriptive error message while deactivating deactivated host</b><br>

#### oVirt Engine SDK 4 Ruby

##### Team: Infra

 - [BZ 1373436](https://bugzilla.redhat.com/1373436) <b>Reading empty list of elements doesn't work correctly</b><br>

#### oVirt image transfer daemon and proxy

##### Team: Storage

 - [BZ 1357942](https://bugzilla.redhat.com/1357942) <b>ovirt-imagio-daemon shouldn't be enabled by default</b><br>

#### oVirt ISO Uploader

##### Team: Integration

 - [BZ 1363681](https://bugzilla.redhat.com/1363681) <b>Add kerberos support to ovirt-iso-uploader</b><br>

#### oVirt Log collector

##### Team: Integration

 - [BZ 1355966](https://bugzilla.redhat.com/1355966) <b>log-collector: fails to run when param 'all' is set to True</b><br>
 - [BZ 1363684](https://bugzilla.redhat.com/1363684) <b>Add kerberos support to ovirt-log-collector</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1358530](https://bugzilla.redhat.com/1358530) <b>jsonrpcclient fails connecting with the default parameters if the hostname is not resolvable</b><br>If there is an issue with resolving the host name jsonrpc client was not able to connect to vdsm. Now we use 'localhost' by default.
 - [BZ 1368115](https://bugzilla.redhat.com/1368115) <b>vdsm config files from /etc/vdsm.conf.d don't override settings in /etc/vdsm.conf</b><br>
 - [BZ 1350350](https://bugzilla.redhat.com/1350350) <b>[RFE] Add metrics module to vdsm</b><br>

##### Team: Network

 - [BZ 1351095](https://bugzilla.redhat.com/1351095) <b>[RHV-H Cockpit] hosted-engine-setup fails when creating the ovirtmgmt bridge</b><br>
 - [BZ 1353456](https://bugzilla.redhat.com/1353456) <b>[vdsm] FCoE hook doesn't enable fcoe and lldpad services to start on boot</b><br>
 - [BZ 1364081](https://bugzilla.redhat.com/1364081) <b>[OVS] Add support to acquire ifaces with running IP config</b><br>

##### Team: Storage

 - [BZ 1358348](https://bugzilla.redhat.com/1358348) <b>VM qcow2 disk got corrupted after live migration</b><br>
 - [BZ 1366176](https://bugzilla.redhat.com/1366176) <b>Failed to import image from glance as template (as a result of RHEL 7.3 LVM issue - lvextend changed return code when called with current LV size)</b><br>
 - [BZ 1361182](https://bugzilla.redhat.com/1361182) <b>vdsm does not find nfs4 mount point with double slashes</b><br>Previously, we didn't support NFS4 mounts that contained a double slash, like in the case of trying to mount an NFS4 directory that is exported with the fsid=0 option.<br>Now it's possible to do that.

##### Team: Virt

 - [BZ 1367839](https://bugzilla.redhat.com/1367839) <b>Cannot import VMs from Xen and VMware when using RHEL7.3 host.</b><br>
 - [BZ 1360990](https://bugzilla.redhat.com/1360990) <b>[z-stream clone - 4.0.4] VMs are not reported as non-responding even though  qemu process does not responds.</b><br>This update fixes a error in the monitoring code that caused the VDSM to incorrectly report that a QEMU process has recovered and is responsive after being unavailable for a short amount of time, while it was actually unresponsive.
 - [BZ 1364924](https://bugzilla.redhat.com/1364924) <b>VMs flip to non-responsive state for ever.</b><br>This update fixes an issue in the monitoring code which caused the VDSM to fail to detect that a stuck QEMU process has become responsive.
 - [BZ 1365411](https://bugzilla.redhat.com/1365411) <b>[RFE] virt-v2v from RHEL Xen: Listing VMs failed if there are Xen VMs with block device.</b><br>Importing Xen on Rhel VMs that have block disk is failing. The imported VM shows no block domain disk in the import details dialog.

#### imgbased

##### Team: Node

 - [BZ 1346872](https://bugzilla.redhat.com/1346872) <b>Hide boot entry of original root filesystem created by anaconda</b><br>

## Bug fixes

### oVirt Engine

#### Team: Gluster

 - [BZ 1369357](https://bugzilla.redhat.com/1369357) <b>While replacing the brick, the destination brick chosen from host should be the sub-directory under the mount</b><br>
 - [BZ 1269132](https://bugzilla.redhat.com/1269132) <b>[ja_JP] Need to translate some warning messages on volume->geo replication->add pane.</b><br>

#### Team: Infra

 - [BZ 1325746](https://bugzilla.redhat.com/1325746) <b>[RFE] - Provide option to access engine not only by engine FQDN but also using alternate host names</b><br>

#### Team: Integration

 - [BZ 1369757](https://bugzilla.redhat.com/1369757) <b>engine-backup --mode=backup --restore-permissions should create the missing extra users if possible</b><br>

#### Team: SLA

 - [BZ 1304387](https://bugzilla.redhat.com/1304387) <b>HE VM hot plug is not working, it's missing the real max number of cpu definition</b><br>
 - [BZ 1284472](https://bugzilla.redhat.com/1284472) <b>User can't create a VM. No permission for EDIT_ADMIN_VM_PROPERTIES</b><br>
 - [BZ 1354281](https://bugzilla.redhat.com/1354281) <b>All hosts filtered out when memory underutilized parameter left out</b><br>
 - [BZ 1315657](https://bugzilla.redhat.com/1315657) <b>No auto-completion option for scheduling policy name in update cluster</b><br>
 - [BZ 1371888](https://bugzilla.redhat.com/1371888) <b>[z-stream clone - 4.0.4] User can't assign CPU profile after upgrade from 3.6 to 4.0</b><br>

#### Team: Storage

 - [BZ 1302752](https://bugzilla.redhat.com/1302752) <b>[scale] - getdisksvmguid inefficient query, hit the performance</b><br>
 - [BZ 1328877](https://bugzilla.redhat.com/1328877) <b>Image Upload: UI doesn't respond gracefully for a proxy failure when resuming an upload.</b><br>
 - [BZ 1368203](https://bugzilla.redhat.com/1368203) <b>Remove auto-generated snapshot job is stuck in status STARTED and the vm is "blocked" if a vm is stopped during a LSM</b><br>

#### Team: Virt

 - [BZ 1328725](https://bugzilla.redhat.com/1328725) <b>Re importing template version after the base template has changed fails</b><br>

### oVirt Host Deploy

#### Team: Integration

 - [BZ 1332586](https://bugzilla.redhat.com/1332586) <b>ovirt-host-deploy - README.environment is outdated</b><br>

### oVirt Hosted Engine HA

#### Team: Integration

 - [BZ 1365242](https://bugzilla.redhat.com/1365242) <b>3.4->3.5->3.6->4.0 SHE migration: ovirt-ha-agent not working correctly / state=AgentStopped</b><br>

### oVirt Image Uploader

#### Team: Integration

 - [BZ 1340963](https://bugzilla.redhat.com/1340963) <b>configuring SSO integration cause API failure in engine-image-uploader</b><br>
 - [BZ 1335169](https://bugzilla.redhat.com/1335169) <b>nfs-utils package is required by image-uploader but is not listed as dependency</b><br>

