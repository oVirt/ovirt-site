---
title: oVirt 4.1.5 Release Notes
category: documentation
toc: true
---

# oVirt 4.1.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.5
release as of August 22, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.5, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL



In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade_guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.5?

### Enhancements

#### oVirt Release Package

 - [BZ 1364083](https://bugzilla.redhat.com/1364083) <b>[RFE] Provide ppc64le arch packages</b><br>With this update, oVirt Host related packages are now also available for ppc64le architecture.

#### oVirt Engine

 - [BZ 1022961](https://bugzilla.redhat.com/1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>This release adds libgfapi support to the Manager and VDSM. libgfapi provides virtual machines with faster access to their images, stored on a Gluster volume, compared to a fuse interface. With the 'LibgfApi' data center feature enabled, or 'lubgfapi_supported' cluster-level feature enabled, virtual machines will access their images, stored on Gluster volumes, directly via libgfapi.

#### VDSM

 - [BZ 1022961](https://bugzilla.redhat.com/1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>This release adds libgfapi support to the Manager and VDSM. libgfapi provides virtual machines with faster access to their images, stored on a Gluster volume, compared to a fuse interface. With the 'LibgfApi' data center feature enabled, or 'lubgfapi_supported' cluster-level feature enabled, virtual machines will access their images, stored on Gluster volumes, directly via libgfapi.

#### oVirt Engine Metrics

 - [BZ 1462500](https://bugzilla.redhat.com/1462500) <b>Add a check that ovirt_env_name is a valid OpenShift namespace identifier</b><br>This release adds checks to the ovirt_env_name, to make sure it is a valid OpenShift namespace identifier. If it is not, the metrics script will now fail. The name must be valid in order for the records to be kept by the Elasticsearch running in OpenShift.

#### oVirt Hosted Engine Setup

 - [BZ 1457357](https://bugzilla.redhat.com/1457357) <b>Allow editing all the shared storage configuration values</b><br>You can now change more self-hosted engine configuration in the hosted-engine.conf file.<br>For example, to set the value: <br>hosted-engine --set-shared-config gateway 10.35.1.254<br><br>To get the value: <br>hosted-engine --get-shared-config gateway<br><br>The commands can be used with the additional parameter "type", if there is concern for duplicate keys in different files: <br>hosted-engine --set-shared-config gateway 10.35.1.254 --type=he_conf<br>hosted-engine --get-shared-config gateway --type=he_conf

#### oVirt Hosted Engine HA

 - [BZ 1457357](https://bugzilla.redhat.com/1457357) <b>Allow editing all the shared storage configuration values</b><br>You can now change more self-hosted engine configuration in the hosted-engine.conf file.<br>For example, to set the value: <br>hosted-engine --set-shared-config gateway 10.35.1.254<br><br>To get the value: <br>hosted-engine --get-shared-config gateway<br><br>The commands can be used with the additional parameter "type", if there is concern for duplicate keys in different files: <br>hosted-engine --set-shared-config gateway 10.35.1.254 --type=he_conf<br>hosted-engine --get-shared-config gateway --type=he_conf

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1473179](https://bugzilla.redhat.com/1473179) <b>ovirt-engine-setup-plugin-dockerc is now deprecated</b><br>The ovirt-engine-setup-plugin-dockerc package is now deprecated, and will be removed in version 4.2.

### Bug Fixes

#### oVirt Release Package

 - [BZ 1476650](https://bugzilla.redhat.com/1476650) <b>RHV-H Upgrade Breaks System Clock Sync</b><br>

#### oVirt Engine

 - [BZ 1414499](https://bugzilla.redhat.com/1414499) <b>[RFE] ability to download images that are attached to vms</b><br>
 - [BZ 1476979](https://bugzilla.redhat.com/1476979) <b>Cannot set ImageProxyAddress with engine-config</b><br>
 - [BZ 1464819](https://bugzilla.redhat.com/1464819) <b>[API] Setting Custom Compatibility Version for a VM via REST api to a none/empty value  is not working</b><br>

#### VDSM

 - [BZ 1461029](https://bugzilla.redhat.com/1461029) <b>Live merge fails when file based domain includes "images" in its path</b><br>

#### imgbased

 - [BZ 1476071](https://bugzilla.redhat.com/1476071) <b>ovirt-imageio-daemon fails to run after upgrading from 4.0 NGN (as  directory "/var/log/ovirt-imageio-daemon/" is owned by user root)</b><br>
 - [BZ 1478339](https://bugzilla.redhat.com/1478339) <b>capabilities of /usr/bin/ping got corrupted after upgrade from 4.1.2 async to 4.1.3</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1479768](https://bugzilla.redhat.com/1479768) <b>[downstream clone - 4.1.5] Hosted engine issues too many lvm operations</b><br>

### Other

#### oVirt Engine

 - [BZ 1437152](https://bugzilla.redhat.com/1437152) <b>v2v import from VmWare via REST API doesn't override the original mac address</b><br>
 - [BZ 1454811](https://bugzilla.redhat.com/1454811) <b>[downstream clone - 4.1.5] No error pops when logging with a locked ovirt user account</b><br>
 - [BZ 1475272](https://bugzilla.redhat.com/1475272) <b>MAC addresses are not freed when a storage domain is destroyed from a data-center</b><br>
 - [BZ 1336708](https://bugzilla.redhat.com/1336708) <b>disk enumeration order in API don't match disk order in the qemu command line</b><br>
 - [BZ 1481098](https://bugzilla.redhat.com/1481098) <b>[downstream clone - 4.1.5] engine does not start due to trying to call non-existent callback.</b><br>
 - [BZ 1465859](https://bugzilla.redhat.com/1465859) <b>OVESETUP_ENGINE_CONFIG/fqdn value not getting logged in answerfile when installing remote dwh</b><br>
 - [BZ 1476744](https://bugzilla.redhat.com/1476744) <b>No validation on the storage_domain parameter when creating VM disks attachments</b><br>Cause: There was no validation on the storage_domain parameter on SDK / REST API. Therefore, it was "possible" to create a vm's disk_attachment without a storage_domain.<br><br>Consequence: Disk attachment has been created, and the storage_domain's parameter was set as the other VM's disk storage domain.<br><br>Fix: Add validation for the storage_domain parameter which supplied by the user (as a part of SDK / REST API command parameters).  <br><br>Result: Error message which indicates that storage_domain wasn't supplied + operation stops.
 - [BZ 1477375](https://bugzilla.redhat.com/1477375) <b>v2v: In audit log IMPORTEXPORT_STARTING_IMPORT_VM is accompanied by ID of the source VM instead of the destination one</b><br>
 - [BZ 1468301](https://bugzilla.redhat.com/1468301) <b>Creating a new Pool fails if 'Auto select target' check box is enabled and the created Pool is based on a Template with at least one disk</b><br>
 - [BZ 1448650](https://bugzilla.redhat.com/1448650) <b>UX: uncaught exception when trying to access the tab "Virtual Machine > Guest Info" of a offline instance.</b><br>
 - [BZ 1471759](https://bugzilla.redhat.com/1471759) <b>Synchronizing a direct lun that is also a part of a storage domain causes its virtual group ID to be removed from the DB</b><br>
 - [BZ 1465539](https://bugzilla.redhat.com/1465539) <b>Auto Generated snapshots failed to remove when live migrating disks concurrently</b><br>

#### VDSM

 - [BZ 1422508](https://bugzilla.redhat.com/1422508) <b>acquire lease Operations which depends on acquire lease, fails with error 'Sanlock resource not acquired', since the acquire has not been completed before the operation took place.</b><br>
 - [BZ 1479829](https://bugzilla.redhat.com/1479829) <b>Can't set DHCP bootproto for non-VM network that is attached to a bond interface</b><br>
 - [BZ 1474638](https://bugzilla.redhat.com/1474638) <b>[SR-IOV] - Vdsm doesn't report VFs with zero MAC addresses 00:00:00:00:00:00 - bnx2x driver</b><br>
 - [BZ 1473344](https://bugzilla.redhat.com/1473344) <b>vdsm's ssl_excludes not working, can't connect to engine</b><br>
 - [BZ 1408304](https://bugzilla.redhat.com/1408304) <b>Confusing errors when a volume does not exists in Volume.getInfo</b><br>
 - [BZ 1473295](https://bugzilla.redhat.com/1473295) <b>vdsm with python/ssl ssl_implementation cannot connect to engine</b><br>
 - [BZ 1469175](https://bugzilla.redhat.com/1469175) <b>vdsm path checking stops</b><br>
 - [BZ 1449944](https://bugzilla.redhat.com/1449944) <b>remove & format iscsi storage domain fails sometimes -  FormatStorageDomainVDS failed</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1469436](https://bugzilla.redhat.com/1469436) <b>set the shard-block-size to recommended value</b><br>
 - [BZ 1477452](https://bugzilla.redhat.com/1477452) <b>Remove the parameter OVEHOSTED_STORAGE/imgSizeGB from file  /usr/share/cockpit/ovirt-dashboard/gdeploy-templates/he-common.conf</b><br>
 - [BZ 1474267](https://bugzilla.redhat.com/1474267) <b>thinpoolsize should include poolmetatadatasize plus lv size.</b><br>
 - [BZ 1441523](https://bugzilla.redhat.com/1441523) <b>Conditionally show packages tab in cockpit UI for RHEL</b><br>
 - [BZ 1459894](https://bugzilla.redhat.com/1459894) <b>Newly created LV for brick entry should be of type thinlv</b><br>
 - [BZ 1459886](https://bugzilla.redhat.com/1459886) <b>Additional volume creation,shows up the volume entry with default volume type as arbiter</b><br>
 - [BZ 1455010](https://bugzilla.redhat.com/1455010) <b>Trim whitespaces in the user provided text in the cockpit UI</b><br>
 - [BZ 1476292](https://bugzilla.redhat.com/1476292) <b>gdeploy config file doesn't load on the 'Review' Step of hosted-engine setup wizard</b><br>
 - [BZ 1460614](https://bugzilla.redhat.com/1460614) <b>The page "Virtual Machines" has no response on Cockpit</b><br>

#### imgbased

 - [BZ 1477942](https://bugzilla.redhat.com/1477942) <b>Missing new layer boot entry sometimes when upgrade to rhvh-4.1-20170802</b><br>
 - [BZ 1477001](https://bugzilla.redhat.com/1477001) <b>Rpm is not persistent after upgrade to rhvh-4.1-20170728.0</b><br>
 - [BZ 1472193](https://bugzilla.redhat.com/1472193) <b>The NIST LVs generated by auto partitioning are not consistent with the ones generated by manual partitioning</b><br>
 - [BZ 1476094](https://bugzilla.redhat.com/1476094) <b>Upgrade failed when upgrade to rhvh-4.1-20170727.1</b><br>
 - [BZ 1475111](https://bugzilla.redhat.com/1475111) <b>Missing discard for /</b><br>
 - [BZ 1472189](https://bugzilla.redhat.com/1472189) <b>Missing discard for the NIST partitions when choosing auto partitioning</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1459818](https://bugzilla.redhat.com/1459818) <b>Build instructions fails</b><br>
 - [BZ 1461060](https://bugzilla.redhat.com/1461060) <b>SDK4 fails when handling data with accents using Python2</b><br>
 - [BZ 1459625](https://bugzilla.redhat.com/1459625) <b>Strange choices in spec file for rpm build.</b><br>

### No Doc Update

#### oVirt Hosted Engine Setup

 - [BZ 1460982](https://bugzilla.redhat.com/1460982) <b>[downstream clone - 4.1.5] [TEXT] Error message is confusing when hosted-engine Storage Domain can't be mounted</b><br>

