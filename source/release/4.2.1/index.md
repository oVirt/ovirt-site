---
title: oVirt 4.2.1 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.2.1 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.1
release as of February 12, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).



For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.1, see the [release notes for previous versions](/documentation/#previous-release-notes).


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
follow [Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow the [Upgrade Guide](/documentation/upgrade_guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.1?

### Release Note

#### oVirt Engine

 - [BZ 1515635](https://bugzilla.redhat.com/1515635) <b>[RFE] Drop uuid_generate_v1() internal implementation and use the implementation from standard PostgreSQL uuid-ossp extension</b><br>We have added a requirement for uuid-ossp PostgreSQL extension to be present in engine database. For databases managed by engine-setup this is performed automatically, but non-managed databases (usually remote databases) this needs to be done manually by administrators.<br><br>Here are required additional steps:<br><br>New installation:<br>  1. Requirement to install rh-postgresql95-postgresql-contrib package<br>     on remote database host<br>  2. Once database is created administrators need to add uuid-ossp extension<br>     to it using: <br>       su - postgres -c "scl enable rh-postgresql95 \-- psql -d engine"<br>       postgres=# CREATE EXTENSION "uuid-ossp";<br><br>Upgrade:<br>  1. Requirement to install rh-postgresql95-postgresql-contrib package<br>     on remote database host<br>  2. Once database is upgraded to 9.5 administrators need to remove our custom implementation and add uuid-ossp extension<br>     to it using: <br>       su - postgres -c "scl enable rh-postgresql95 \-- psql -d engine"<br>       postgres=# DROP FUNCTION IF EXISTS uuid_generate_v1();<br>       postgres=# CREATE EXTENSION "uuid-ossp";<br><br>In both above example "engine" specified using "-d" option is the name of engine database

### Enhancements

#### oVirt Engine Metrics

 - [BZ 1523068](https://bugzilla.redhat.com/1523068) <b>[RFE] Add fluentd file output plugin support for quick and easy debugging</b><br>Feature:<br>Add fluentd file output plugin support for quick and easy debugging <br><br>Reason: <br>Sometimes we want to debug the metrics without setting a remote metrics store.<br><br>Result: <br>Added a "file" output plugin support to the ovirt-engine-metrics setup.<br>Metrics will be sent to a local file.

#### oVirt Host Dependencies

 - [BZ 1425032](https://bugzilla.redhat.com/1425032) <b>[RFE] Include katello agent in RHV-H NG</b><br>Feature: Katello Agent is now installed on RHV hosts during deployment and is included in RHV-H image<br><br>Reason: to better integrate with Satellite. Katello Agent provides the list of the installed rpms.<br><br>Result: katello-agent is installed and working on RHV / RHV-H Hosts

#### oVirt Hosted Engine Setup

 - [BZ 1353713](https://bugzilla.redhat.com/1353713) <b>[RFE] - Hosted Engine: iSCSI Setup Should use different User/Password For Discovery and Portal</b><br>hosted-engine-setup was assuming that the user set the same CHAP username and password for iSCSI discovery and iSCSI login.<br>Let the user pass different username and password couples for iSCSI discover and iSCSI login at setup time.

#### OTOPI

 - [BZ 1396925](https://bugzilla.redhat.com/1396925) <b>[RFE] restructure answer-file behavior</b><br>otopi can now optionally write its own answer files, which are simpler to understand, compared to tool-specific files written by existing tools that use otopi. Also functionality is different, imitating more closely the behavior without an answer file and answers provided interactively.

#### oVirt Engine

 - [BZ 1510578](https://bugzilla.redhat.com/1510578) <b>[RFE][hc][dalton] - Set up cgroup for gluster processes in HC mode from the engine</b><br>Feature: Restrict the CPU resources consumed by gluster processes <br><br>Reason: When running in hyperconverged mode, gluster processes should co-exist with virt processes and not consume all available resources<br><br>Result: Hyperconverged mode works as expected
 - [BZ 1511823](https://bugzilla.redhat.com/1511823) <b>[RFE] Automatically synchronize networks of cluster with default network provider</b><br>Feature:<br>Add a new boolean property to external network providers is added.<br>If true, the networks of this provider are automatically and cyclically synchronized to oVirt in the background. This means that all new networks of this provider are imported, and all discarded networks are removed from all clusters that have this external provider as the default provider.<br><br>The automatically initiated import triggers the following steps:<br><br> - The networks of the external provider will be imported to every data center in the data centers of the clusters that have that external provider as the default provider.<br><br> - A vNIC profile will be created for each involved data center and network.<br><br> - The networks will be assigned to each cluster that has that external provider as the default provider.<br><br>All users are allowed to use the new vNIC Profile.<br><br>Reason:<br> - Support the user to use only external networks for VMs, which are still available<br>   on the external provider.<br> - Make new networks of the external network provider available more comfortable.<br><br>Result:<br>After the user has enabled the new boolean property, e.g. during creating the external provider, the networks of the external provider are available to be used for VMs without manually importing them.
 - [BZ 1530730](https://bugzilla.redhat.com/1530730) <b>[downstream clone - 4.2.1] [RFE] Allow uploading ISO images to data domains and using them in VMs</b><br>It is now possible to upload an ISO file to a data domain and attach it to a VM as a CDROM device.<br>In order to do so the user has to upload an ISO file via the UI (which will recognize the ISO by it's header and will upload it as ISO) or via the APIs in which case the request should define the disk container "content_type" property as "iso" before the upload.<br>Once the ISO exists on an active storage domain in the data center it will be possible to attach it to a VM as a CDROM device either through the "Edit VM" dialog or through the APIs (see example in comment #27
 - [BZ 1330217](https://bugzilla.redhat.com/1330217) <b>[RFE] Enable configuring IPv6 in VM cloud-init</b><br>Cloud-Init supports IPv6 properties for initializing a virtual machine's network interfaces.
 - [BZ 1517832](https://bugzilla.redhat.com/1517832) <b>[RFE] make VM names in host details clickable</b><br>Feature: Clicking on the VM name in the VM detail view of the hosts, will take you directly to the VM detail view. This allows you to see more details of that VM and make changes easier.<br><br>Reason: Navigating between hosts and their associated VMs was difficult. This change allows the user to quickly switch selected entities.<br><br>Result: The names of the VMs in the VM grid of the host detail view now contains a link to the VM detail view.
 - [BZ 1049604](https://bugzilla.redhat.com/1049604) <b>[RFE] Allow uploading a pre-existing VM image (OVA) into the environment</b><br>Feature: <br>Enable uploading an OVA into an oVirt data center.<br><br>Reason: <br>Simplify the process of importing a virtual machine that was created out of the data center.<br><br>Result: <br>It is now possible to import an OVA that is accessible to at least of the hosts in the data center into a virtual machine in oVirt.
 - [BZ 1528960](https://bugzilla.redhat.com/1528960) <b>Add ability to change maximum timeout for Ansible process executed from engine to finish</b><br>The default timeout for Ansible process executed from engine has been enlarged to 30 minutes, because especially upgrading hosts can take significant amount of time. If Ansible process doesn't finish until this timeout, engine will kill the Ansible process and fail the action.<br><br>If even default 30 minutes timeout is not enough, administrators can further enlarge it by creating a new configuration file in /etc/ovirt-engine/engine.conf.d (for example 99-ansible-playbook-timeout.conf) with following content:<br><br>  ANSIBLE_PLAYBOOK_EXEC_DEFAULT_TIMEOUT=NNN<br><br>where NNN is number minutes which engine should wait for Ansible process to finish.

#### VDSM

 - [BZ 1334982](https://bugzilla.redhat.com/1334982) <b>[RFE] Gracefully shutdown Virtual Machines on Host reboot/shutdown.</b><br>Previously, in cases of emergency,  users were required to shut down the hosts to preserve the data center. This caused running virtual machines to be killed by the systemd process without performing a graceful shutdown. As a result, the virtual machine's state became undefined which led to problematic scenarios for virtual machines running databases such as Oracle and SAP.<br>In this release, virtual machines can be gracefully shut down by delaying the systemd process. Only after the virtual machines are shut down, does the systemd process take control and continue the shut down. The VDSM is only shut down after the virtual machines have been gracefully shut down, after passing information to the Manager and waiting 5 seconds for the Manager to acknowledge the virtual machines have been shut down.
 - [BZ 1530730](https://bugzilla.redhat.com/1530730) <b>[downstream clone - 4.2.1] [RFE] Allow uploading ISO images to data domains and using them in VMs</b><br>It is now possible to upload an ISO file to a data domain and attach it to a VM as a CDROM device.<br>In order to do so the user has to upload an ISO file via the UI (which will recognize the ISO by it's header and will upload it as ISO) or via the APIs in which case the request should define the disk container "content_type" property as "iso" before the upload.<br>Once the ISO exists on an active storage domain in the data center it will be possible to attach it to a VM as a CDROM device either through the "Edit VM" dialog or through the APIs (see example in comment #27
 - [BZ 1429536](https://bugzilla.redhat.com/1429536) <b>[RFE] Rebase on gluster-3.12</b><br>Feature: oVirt to use the latest released version of glusterfs - 3.12<br><br>Reason: GlusterFS 3.12 has many fixes and enhancements that improve experience for oVirt users
 - [BZ 1511234](https://bugzilla.redhat.com/1511234) <b>[RFE] Hook for booting from Passthrough Devices</b><br>New vdsm hook boot_hostdev has been added. It allows Virtual Machines to boot from passed through host devices such as NIC VFs, PCI-E SAS/RAID Cards, SCSI devices etc. without requiring a normal bootable disk from RHV SD/Direct LUN

#### oVirt Engine SDK 4 Python

 - [BZ 1049604](https://bugzilla.redhat.com/1049604) <b>[RFE] Allow uploading a pre-existing VM image (OVA) into the environment</b><br>Feature: <br>Enable uploading an OVA into an oVirt data center.<br><br>Reason: <br>Simplify the process of importing a virtual machine that was created out of the data center.<br><br>Result: <br>It is now possible to import an OVA that is accessible to at least of the hosts in the data center into a virtual machine in oVirt.

### Known Issue

#### oVirt Engine

 - [BZ 1523614](https://bugzilla.redhat.com/1523614) <b>Copy image to a block storage destination does not work after disk extension in a snapshot in DC pre-4.0</b><br>Cause: <br>qemu-img convert with compat=0.10 and a backing file writes <br>the space after the backing file as zeroes which may cause the output disk be larger than the LV created for it<br><br>Consequence: <br>Moving a disk that has snapshot created prior to its extension will fail in storage domains with a version older than V4 (i.e., domains in DC 4.0 or older)<br><br>Fix: <br>The move operation of a disk with snapshots created prior to its extension will be blocked with an error message stating the deletion of the disk's snapshot is required before attempting to move it, instead of attempting to execute the copying and waiting for it to fail.<br><br>Result:

#### oVirt Hosted Engine Setup

 - [BZ 1543988](https://bugzilla.redhat.com/1543988) <b>hosted-engine --get-shared-config rewrites all the hosted-engine configuration files loosing spm id</b><br>Cause: <br>'hosted-engine --get-shared-config' and 'hosted-engine --set-shared-config' always rewrite all the HE configuration files with the copy on the shared storage.<br>/etc/ovirt-hosted-engine/hosted-engine.conf contains host_id field with the SPM ID to be used on the host while the shared copy on the shared storage that contains only host_id=1<br><br>Consequence:<br>This can cause an SPM collision in the future.<br>
<br>Workaround:<br>Manually restore host_id in /etc/ovirt-hosted-engine/hosted-engine.conf after 'hosted-engine --get-shared-config' or 'hosted-engine --set-shared-config'<br><br>

### Bug Fixes

#### oVirt Hosted Engine Setup

 - [BZ 1536941](https://bugzilla.redhat.com/1536941) <b>HE-VM cloudinit root password saved in the setup log file as clear text.</b><br>

#### oVirt Release Package

 - [BZ 1516123](https://bugzilla.redhat.com/1516123) <b>tuned-adm timeout while adding the host in manager and the deployment will fail/take time to complete</b><br>

#### oVirt Engine

 - [BZ 1525353](https://bugzilla.redhat.com/1525353) <b>vNIC mapping is broken on import from data domain - vNICs mapped as 'Empty' in the destination cluster</b><br>
 - [BZ 1528906](https://bugzilla.redhat.com/1528906) <b>Engine requires to set a gateway in order to sync a network</b><br>
 - [BZ 1517492](https://bugzilla.redhat.com/1517492) <b>Create VM with new created quota fails.</b><br>
 - [BZ 1529255](https://bugzilla.redhat.com/1529255) <b>Can't import VMware OVA folder with EngineException: Failed to query OVA info</b><br>
 - [BZ 1519811](https://bugzilla.redhat.com/1519811) <b>On upgrade from RHEV-3.6 to RHV-4, max_memory_size_mb seems hardly set to 1TB</b><br>
 - [BZ 1529262](https://bugzilla.redhat.com/1529262) <b>OVN provider password added by engine-setup must be encrypted</b><br>
 - [BZ 1492838](https://bugzilla.redhat.com/1492838) <b>Engine database upgrade: take care of zero 'vm_snapshot_id' fields</b><br>
 - [BZ 1529965](https://bugzilla.redhat.com/1529965) <b>OVA import: querying OVA file from import dialog failed with NullPointerException</b><br>
 - [BZ 1530261](https://bugzilla.redhat.com/1530261) <b>unable to boot vm with libgfapi in 4.2</b><br>
 - [BZ 1529607](https://bugzilla.redhat.com/1529607) <b>NPE when exporting disk with no description to OVA</b><br>
 - [BZ 1529292](https://bugzilla.redhat.com/1529292) <b>uploaded image alignment should be validated</b><br>

#### VDSM

 - [BZ 1532151](https://bugzilla.redhat.com/1532151) <b>cannot run vm after  upgrade to 4.2-beta - AttributeError: 'Element' object has no attribute '_elem'</b><br>
 - [BZ 1533762](https://bugzilla.redhat.com/1533762) <b>Failed to hotplug a vNIC with Empty network</b><br>
 - [BZ 1432039](https://bugzilla.redhat.com/1432039) <b>lvchange --refresh generates unneeded load on lvm</b><br>
 - [BZ 1527416](https://bugzilla.redhat.com/1527416) <b>Wrong state returned in VM getStats when actual state changes in the middle</b><br>
 - [BZ 1518676](https://bugzilla.redhat.com/1518676) <b>Entire vdsm process hang during when formatting xlease volume on NFS storage domain</b><br>
 - [BZ 1526133](https://bugzilla.redhat.com/1526133) <b>[SR-IOV] hot-plug of vNIC on running VM fails with VDSErrorException</b><br>
 - [BZ 1449968](https://bugzilla.redhat.com/1449968) <b>Guest LVs created on raw volumes are auto activated on the hypervisor with FC storage (lvm filter?)</b><br>
 - [BZ 1532133](https://bugzilla.redhat.com/1532133) <b>Preallocated volume convert to sparse volume after live storage migration to file based storage domain</b><br>
 - [BZ 1530072](https://bugzilla.redhat.com/1530072) <b>Vdsm can get into D state when checking disk type on non-responsive NFS server</b><br>

#### oVirt Host Deploy

 - [BZ 1539040](https://bugzilla.redhat.com/1539040) <b>host-deploy stops libvirt-guests triggering a shutdown of all the running VMs (including HE one)</b><br>

#### imgbased

 - [BZ 1493176](https://bugzilla.redhat.com/1493176) <b>RHVH stuck on startup after 'probing EDD... ok' step</b><br>
 - [BZ 1535791](https://bugzilla.redhat.com/1535791) <b>Upgrading node brings back previous hosted-engine configuration</b><br>
 - [BZ 1533871](https://bugzilla.redhat.com/1533871) <b>the /boot partition grows after each update until it's at 100% causing boot loop.</b><br>

### Other

#### oVirt Engine Metrics

 - [BZ 1529295](https://bugzilla.redhat.com/1529295) <b>[RFE] - Add root file system disk space statistics for the engine</b><br>
 - [BZ 1506178](https://bugzilla.redhat.com/1506178) <b>Multiple minor issues with help of configure_metrics script</b><br>
 - [BZ 1534240](https://bugzilla.redhat.com/1534240) <b>Old VDSM still send hosts statistics and fluentd should filter them out</b><br>
 - [BZ 1532196](https://bugzilla.redhat.com/1532196) <b>[RFE] Add ovirt.engine_fqdn to hosts logs</b><br>

#### oVirt Engine Dashboard

 - [BZ 1358604](https://bugzilla.redhat.com/1358604) <b>CPU/Memory/Storage tooltip text should be improved</b><br>
 - [BZ 1402007](https://bugzilla.redhat.com/1402007) <b>Dashboard: Over commit: XX% (allocated XX%) parameters are not clear</b><br>
 - [BZ 1489433](https://bugzilla.redhat.com/1489433) <b>Dashboard utilization circle doesn't show up when 0 out of 0 is used</b><br>
 - [BZ 1526258](https://bugzilla.redhat.com/1526258) <b>[CodeChange][i18n] oVirt 4.2 translation cycle 1, part 2</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1527394](https://bugzilla.redhat.com/1527394) <b>[HE] - SHE ha-host's score is unstable and hosted-engine.conf is not equal on both ha-hosts.</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1527394](https://bugzilla.redhat.com/1527394) <b>[HE] - SHE ha-host's score is unstable and hosted-engine.conf is not equal on both ha-hosts.</b><br>
 - [BZ 1540850](https://bugzilla.redhat.com/1540850) <b>ansible flow needs better logging</b><br>
 - [BZ 1537630](https://bugzilla.redhat.com/1537630) <b>Hosted engine VM cannot be edited using the UI, because it has priority 0</b><br>
 - [BZ 1537153](https://bugzilla.redhat.com/1537153) <b>iSCSI deployment of node zero fails with "'ansible.errors.AnsibleUndefinedVariable'>\nexception: 'int object' has no attribute 'split'"}".</b><br>
 - [BZ 1532213](https://bugzilla.redhat.com/1532213) <b>[HE] in deploy of Hosted Engine with ansible we should remove the otopi question "generate on-fly a cloud-init ISO image..." since its not supported.</b><br>
 - [BZ 1529941](https://bugzilla.redhat.com/1529941) <b>missing '--config-append' option in help and man</b><br>
 - [BZ 1530125](https://bugzilla.redhat.com/1530125) <b>AnsibleHelper is consuming too much cpu time</b><br>
 - [BZ 1526752](https://bugzilla.redhat.com/1526752) <b>HE setup: Don't use /var/tmp/localvm but a temp dir.</b><br>

#### OTOPI

 - [BZ 1529474](https://bugzilla.redhat.com/1529474) <b>config-append failed to resolve path that start with ~/</b><br>

#### oVirt Release Package

 - [BZ 1526850](https://bugzilla.redhat.com/1526850) <b>brand is missing on cockpit login screen.</b><br>

#### oVirt Engine

 - [BZ 1541233](https://bugzilla.redhat.com/1541233) <b>bad "before" or "after" parameters in _misc_configure_ovn_pki</b><br>
 - [BZ 1535393](https://bugzilla.redhat.com/1535393) <b>[PPC] Failed to run VM, unsupported configuration: setting ACPI S3 not supported.</b><br>
 - [BZ 1539656](https://bugzilla.redhat.com/1539656) <b>Deploying a node in HC cluster fails due to cgroups role</b><br>
 - [BZ 1528292](https://bugzilla.redhat.com/1528292) <b>Recursion in HostDeviceManager and other services prevents engine to startup successfully</b><br>
 - [BZ 1531995](https://bugzilla.redhat.com/1531995) <b>[UI] Unable to set a vNIC profile on network interface window</b><br>
 - [BZ 1532013](https://bugzilla.redhat.com/1532013) <b>New/Edit network - Labels drop down list is gone</b><br>
 - [BZ 1532046](https://bugzilla.redhat.com/1532046) <b>ovn localnet: attachment of ovn network to data center network is not saved</b><br>
 - [BZ 1526815](https://bugzilla.redhat.com/1526815) <b>Backup restore API: Transient volume is not created on compatibility version-4.2  after backup VM start with snapshot disk from source VM attached</b><br>
 - [BZ 1525374](https://bugzilla.redhat.com/1525374) <b>EngineException: Failed to GetLldpVDS, error = The method does not exist / is not available when running a 3.6 host in rhv 4.2 engine</b><br>
 - [BZ 1526260](https://bugzilla.redhat.com/1526260) <b>Previewing snapshot for VM A actually snapshots disks of VM B, both get broken.</b><br>
 - [BZ 1493914](https://bugzilla.redhat.com/1493914) <b>ISCSI targets results in duplicate connections with incorrect node.tpgt values.</b><br>
 - [BZ 1518509](https://bugzilla.redhat.com/1518509) <b>Numa aware ksm state in file /sys/kernel/mm/ksm/merge_across_nodes  always remains  1</b><br>
 - [BZ 1529119](https://bugzilla.redhat.com/1529119) <b>Upgrade from RHV 4.1 to 4.2 with OVN provider name: ovirt-provider-ovn fails</b><br>
 - [BZ 1484199](https://bugzilla.redhat.com/1484199) <b>Device.map can't be updated to vda if import rhel7.4 guest from kvm source at rhv4.1</b><br>
 - [BZ 1522799](https://bugzilla.redhat.com/1522799) <b>[RFE] - DR: On template\vm registration, vnic_profile_mappings should be under registration_configuration</b><br>
 - [BZ 1530723](https://bugzilla.redhat.com/1530723) <b>[RFE] Add posibility to specify verbose mode of ansible-playbook execution by engine configuration value</b><br>User can specify the ansible-playbook command verbose level, which is used by engine.<br>To change the value permanentaly create a configuration file 99-ansible-playbook-verbose-level.conf in /etc/ovirt-engine/engine.conf.d/ with following content:<br>ANSIBLE_PLAYBOOK_VERBOSE_LEVEL=4
 - [BZ 1534227](https://bugzilla.redhat.com/1534227) <b>Confusing logging when cold-moving a disk - the term CreateSnapshot is referenced</b><br>
 - [BZ 1532040](https://bugzilla.redhat.com/1532040) <b>Webadmin: Available LUNs are grayed out in block domain creation prompt</b><br>
 - [BZ 1528297](https://bugzilla.redhat.com/1528297) <b>Reinstalling host on 'ovirt-provider-ovn' cluster doesn't deploy OVN</b><br>
 - [BZ 1525912](https://bugzilla.redhat.com/1525912) <b>allow to create cluster without specifying cpu type</b><br>
 - [BZ 1510384](https://bugzilla.redhat.com/1510384) <b>iSCSI Storage domain's size after executing 'reduceluns' via REST API or 'Remove LUNs' via UI doesn't seem to be updated</b><br>
 - [BZ 1528724](https://bugzilla.redhat.com/1528724) <b>Import ova playbooks assume that ovf comes first in OVA</b><br>
 - [BZ 1527318](https://bugzilla.redhat.com/1527318) <b>The engine fails to deploy hosted-engine host: Exception: java.lang.IllegalArgumentException: No enum constant org.ovirt.engine.core.common.businessentities.network.VmInterfaceType.virtio</b><br>
 - [BZ 1511369](https://bugzilla.redhat.com/1511369) <b>REST: add external network provider by name</b><br>
 - [BZ 1486761](https://bugzilla.redhat.com/1486761) <b>[UI] cloud-init: improve networking text</b><br>
 - [BZ 1495535](https://bugzilla.redhat.com/1495535) <b>Add validation to disallow hotplug memory if vm uses huge pages</b><br>
 - [BZ 1522708](https://bugzilla.redhat.com/1522708) <b>[ja_JP] Text truncation observed on network->vNIC profile->new page.</b><br>
 - [BZ 1524419](https://bugzilla.redhat.com/1524419) <b>resume behavior is marked as needs restart even if not needed</b><br>
 - [BZ 1506135](https://bugzilla.redhat.com/1506135) <b>Default setting for 'Default Network Provider' is empty string</b><br>
 - [BZ 1526906](https://bugzilla.redhat.com/1526906) <b>[UI] - Align the 'Remove networks from external provider' checkbox in the remove network dialog</b><br>
 - [BZ 1520123](https://bugzilla.redhat.com/1520123) <b>[UI] - UI exception on add vNIC to template flow</b><br>
 - [BZ 1512794](https://bugzilla.redhat.com/1512794) <b>[UI] - Add tooltip to the disabled default route role for clusters <=4.1</b><br>
 - [BZ 1522784](https://bugzilla.redhat.com/1522784) <b>[UI] - Network role icons are overlapping the network's name in case of long name or vlan tagged</b><br>
 - [BZ 1538998](https://bugzilla.redhat.com/1538998) <b>Ansible playbooks of host deployed getting stuck</b><br>
 - [BZ 1536966](https://bugzilla.redhat.com/1536966) <b>Can't import template from data domain</b><br>
 - [BZ 1535904](https://bugzilla.redhat.com/1535904) <b>engine-setup creates bad 10-setup-database.conf if it has to provision engine_TIMESTAMP</b><br>
 - [BZ 1534626](https://bugzilla.redhat.com/1534626) <b>Webadmin-removing a boot iso CD while VM is booting is allowed</b><br>
 - [BZ 1511037](https://bugzilla.redhat.com/1511037) <b>GetUnregisteredDiskQuery fails with NullPointerException after domain import between 4.1 and 4.2 envs</b><br>
 - [BZ 1534207](https://bugzilla.redhat.com/1534207) <b>The engine needs newer ovirt-engine-metrics</b><br>
 - [BZ 1534231](https://bugzilla.redhat.com/1534231) <b>'stateless snapshot' disk snapshot is removable</b><br>
 - [BZ 1531137](https://bugzilla.redhat.com/1531137) <b>Webadmin -right vertical scroller in "attach virtual disks" window hides the "shared" disk column</b><br>
 - [BZ 1530603](https://bugzilla.redhat.com/1530603) <b>snapshots.list following delete sometimes fails (using the API)</b><br>
 - [BZ 1532844](https://bugzilla.redhat.com/1532844) <b>Webadmin: Available LUNs are grayed out in new direct LUN prompt</b><br>
 - [BZ 1478001](https://bugzilla.redhat.com/1478001) <b>Cannot edit new cluster memory optimization in Guide Me dialog</b><br>
 - [BZ 1532873](https://bugzilla.redhat.com/1532873) <b>Meaningless validation message for live storage migration attempt for disk attached to VM in restoring state</b><br>
 - [BZ 1522669](https://bugzilla.redhat.com/1522669) <b>Log uncleared async tasks when failing to stop the SPM</b><br>
 - [BZ 1532870](https://bugzilla.redhat.com/1532870) <b>Meaningless validation message for suspended VM hibernation disks remove attempt</b><br>
 - [BZ 1518459](https://bugzilla.redhat.com/1518459) <b>Add missing validations for affinity group, label, users and roles when registering a VM or a Template</b><br>
 - [BZ 1532630](https://bugzilla.redhat.com/1532630) <b>Prevent deactivation of a data domain with ISO disks that are attached to running VMs</b><br>
 - [BZ 1532613](https://bugzilla.redhat.com/1532613) <b>Unexpected character error when running check for update on a host</b><br>
 - [BZ 1528763](https://bugzilla.redhat.com/1528763) <b>WebAdmin changes the selected host</b><br>
 - [BZ 1507426](https://bugzilla.redhat.com/1507426) <b>All non data disks should be filtered out from the attach disk to VM dialog box</b><br>
 - [BZ 1494525](https://bugzilla.redhat.com/1494525) <b>Can attach OVF-STORE as disk while creating a new VM</b><br>
 - [BZ 1528284](https://bugzilla.redhat.com/1528284) <b>Fail host deploy process if any firewalld service isn't found, by default open all predefined firewalld services for specific cluster</b><br>
 - [BZ 1532308](https://bugzilla.redhat.com/1532308) <b>Cannot add Openstack glance and block storage provider in the UI</b><br>
 - [BZ 1532011](https://bugzilla.redhat.com/1532011) <b>StreamingApi - Can not cancel via UI a disk that paused download by SDK</b><br>
 - [BZ 1527067](https://bugzilla.redhat.com/1527067) <b>Null pointer exception after removing disk from VM</b><br>
 - [BZ 1532231](https://bugzilla.redhat.com/1532231) <b>Importing a VM with the collapse snapshots checkbox unchecked still results in snapshot collapse</b><br>
 - [BZ 1530043](https://bugzilla.redhat.com/1530043) <b>Extending a block(ISCSI) raw disk attached to a VM with a 'virtio' interface does not change lv size in SPM</b><br>
 - [BZ 1527372](https://bugzilla.redhat.com/1527372) <b>AuditLogMessages - ERROR</b><br>
 - [BZ 1527362](https://bugzilla.redhat.com/1527362) <b>SQL Deadlock ERROR on DisplayAllAuditLogEventsCommand -under scaled topology</b><br>
 - [BZ 1525569](https://bugzilla.redhat.com/1525569) <b>PostConstruct of Backend is recursively invoked</b><br>
 - [BZ 1528294](https://bugzilla.redhat.com/1528294) <b>Webadmin's disk search throws an exception when trying to filter by the "bootable" property</b><br>
 - [BZ 1529507](https://bugzilla.redhat.com/1529507) <b>UX: no auto-completion for search in Administration->Users search bar</b><br>
 - [BZ 1511420](https://bugzilla.redhat.com/1511420) <b>[RFE] API for running VM with an ISO from the DATA domain</b><br>
 - [BZ 1528804](https://bugzilla.redhat.com/1528804) <b>'Remove' button should be disabled for OVF_STORE disks with status other than ILLEGAL</b><br>
 - [BZ 1523225](https://bugzilla.redhat.com/1523225) <b>OVF update failure ignored</b><br>
 - [BZ 1465548](https://bugzilla.redhat.com/1465548) <b>webadmin: Missing fields in 'Edit Provider' dialog for KVM, XEN and VMware provider types</b><br>
 - [BZ 1516412](https://bugzilla.redhat.com/1516412) <b>While managing a block storage domain, moving too fast to Targets > LUNs table resets lun's isInclude() check-mark</b><br>
 - [BZ 1342753](https://bugzilla.redhat.com/1342753) <b>Image Transfer - authorizing once to reduce overhead in UI and proxy</b><br>
 - [BZ 1527866](https://bugzilla.redhat.com/1527866) <b>Initial hosted-engine VM not deleted properly after ansible SHE deployment.</b><br>
 - [BZ 1528283](https://bugzilla.redhat.com/1528283) <b>Add the ability to search storage domains by their Discard After Delete value in the webadmin</b><br>
 - [BZ 1511013](https://bugzilla.redhat.com/1511013) <b>3.6 host install fails because of firewall type set to firewalld in 3.6 cluster</b><br>
 - [BZ 1502696](https://bugzilla.redhat.com/1502696) <b>Advanced parameters section doesn't get border on error Discard after delete</b><br>
 - [BZ 1526263](https://bugzilla.redhat.com/1526263) <b>[CodeChange][i18n] oVirt 4.2 translation cycle 1, part 2</b><br>
 - [BZ 1502559](https://bugzilla.redhat.com/1502559) <b>Prevent a storage domain to be updated to backup SD while it contain disks which are attached to running VMs or running VMs with leases</b><br>
 - [BZ 1525968](https://bugzilla.redhat.com/1525968) <b>[GUI] - each event in host Events list appears 10 times.</b><br>
 - [BZ 1516907](https://bugzilla.redhat.com/1516907) <b>Editing VM properties task hangs forever. The only way out is remove job_id from postgres and engine restart</b><br>
 - [BZ 1527134](https://bugzilla.redhat.com/1527134) <b>Removing a disk with a non-existent snapshot fails</b><br>
 - [BZ 1525989](https://bugzilla.redhat.com/1525989) <b>Cannot register VM with FC LUN</b><br>
 - [BZ 1526782](https://bugzilla.redhat.com/1526782) <b>Querying for users throws Exception: java.lang.ClassCastException: java.util.Collections$EmptyMap cannot be cast to java.u til.HashMap</b><br>
 - [BZ 1524222](https://bugzilla.redhat.com/1524222) <b>No heartbeat message arrived from host messages on all hosts</b><br>
 - [BZ 1457087](https://bugzilla.redhat.com/1457087) <b>Insufficient logging for failed VM live migration with missing direct pass-though LUN</b><br>
 - [BZ 1519695](https://bugzilla.redhat.com/1519695) <b>Remove no longer available HTTPS protocols from ENGINE_HTTPS_PROTOCOLS option</b><br>
 - [BZ 1524126](https://bugzilla.redhat.com/1524126) <b>Webadmin: LUNs list in block domain creation prompt has multiple side to side scrolling tools which hide the LUNs</b><br>

#### VDSM

 - [BZ 1509675](https://bugzilla.redhat.com/1509675) <b>Live merge with continuous I/O to the VM failed to deactivate logical volume (depends on platform bug 1516717)</b><br>
 - [BZ 1530839](https://bugzilla.redhat.com/1530839) <b>Deployment fails configuring ovirtmgmt interface if a VLAN exists on the management interface</b><br>
 - [BZ 1530230](https://bugzilla.redhat.com/1530230) <b>[OVS] - Supervdsm log is spammed with: ovirtmgmt is not a Linux bridge errors</b><br>
 - [BZ 1526815](https://bugzilla.redhat.com/1526815) <b>Backup restore API: Transient volume is not created on compatibility version-4.2  after backup VM start with snapshot disk from source VM attached</b><br>
 - [BZ 1526192](https://bugzilla.redhat.com/1526192) <b>Failed to start supervdsm on PPC host</b><br>
 - [BZ 1523661](https://bugzilla.redhat.com/1523661) <b>When adding the host over an existing bond-vlan, it looses network connection after reboot.</b><br>
 - [BZ 1522971](https://bugzilla.redhat.com/1522971) <b>move defaultRoute=True to a new network even if persisted on a former network</b><br>
 - [BZ 1527318](https://bugzilla.redhat.com/1527318) <b>The engine fails to deploy hosted-engine host: Exception: java.lang.IllegalArgumentException: No enum constant org.ovirt.engine.core.common.businessentities.network.VmInterfaceType.virtio</b><br>
 - [BZ 1488892](https://bugzilla.redhat.com/1488892) <b>iscsi re-scan is executed multiple times at connectStorageServer</b><br>
 - [BZ 1518587](https://bugzilla.redhat.com/1518587) <b>Supervdsm log - ERROR - 'Failed source route addition:' on every dhclient lease renew</b><br>
 - [BZ 1478890](https://bugzilla.redhat.com/1478890) <b>Static ip remain on the bond interface when removing non-vm network from it in case it has another vlan network attached</b><br>
 - [BZ 1534950](https://bugzilla.redhat.com/1534950) <b>[Backup restore API] Start VM, with attached snapshot disk on block based storage, fails on libvirtError</b><br>
 - [BZ 1532483](https://bugzilla.redhat.com/1532483) <b>Improve osinfo kdump_status() logging level.</b><br>
 - [BZ 1523292](https://bugzilla.redhat.com/1523292) <b>sos plugin is generating Exception during plugin-setup</b><br>
 - [BZ 1528816](https://bugzilla.redhat.com/1528816) <b>vdsm-tool remove-config does not revert changes</b><br>
 - [BZ 1527155](https://bugzilla.redhat.com/1527155) <b>Describe jsonrpc client reconnection parameters</b><br>
 - [BZ 1525955](https://bugzilla.redhat.com/1525955) <b>VDSM fails to start HE VM due to VM.getStats error right after VM.create (seen on OST)</b><br>
 - [BZ 1525453](https://bugzilla.redhat.com/1525453) <b>jsonrpc reconnect logic contains busy loop and floods logs</b><br>
 - [BZ 1526010](https://bugzilla.redhat.com/1526010) <b>Storage: Incorrect valid_paths in multipath events in some cases when several paths change states at the same time</b><br>

#### oVirt Provider OVN

 - [BZ 1530533](https://bugzilla.redhat.com/1530533) <b>admin_state_up property of a router is a list instead of single value</b><br>
 - [BZ 1527894](https://bugzilla.redhat.com/1527894) <b>Log source IP and port on requests to the provider</b><br>
 - [BZ 1524123](https://bugzilla.redhat.com/1524123) <b>Improper error message in vdsm-tool ovn-config</b><br>

#### ovirt-engine-dwh

 - [BZ 1490941](https://bugzilla.redhat.com/1490941) <b>add notice to dwh-vacuum help about full vacuum</b><br>
 - [BZ 1535935](https://bugzilla.redhat.com/1535935) <b>engine-setup creates bad 10-setup-database.conf if it has to provision ovirt_engine_history_TIMESTAMP</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1525912](https://bugzilla.redhat.com/1525912) <b>allow to create cluster without specifying cpu type</b><br>
 - [BZ 1511369](https://bugzilla.redhat.com/1511369) <b>REST: add external network provider by name</b><br>
 - [BZ 1522799](https://bugzilla.redhat.com/1522799) <b>[RFE] - DR: On template\vm registration, vnic_profile_mappings should be under registration_configuration</b><br>
 - [BZ 1511420](https://bugzilla.redhat.com/1511420) <b>[RFE] API for running VM with an ISO from the DATA domain</b><br>

#### oVirt Host Deploy

 - [BZ 1533390](https://bugzilla.redhat.com/1533390) <b>Start glustereventsd while deploying host</b><br>

#### imgbased

 - [BZ 1528468](https://bugzilla.redhat.com/1528468) <b>oVirt NGN kickstart-based install fails during imgbased layout initialization after installing an rpm package in %post</b><br>
 - [BZ 1519784](https://bugzilla.redhat.com/1519784) <b>oVirt Node upgrade fails if SELINUX is disabled</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1541029](https://bugzilla.redhat.com/1541029) <b>[cockpit][vintage otopi][iscsi] iSCSI discovery systematically fails</b><br>
 - [BZ 1539497](https://bugzilla.redhat.com/1539497) <b>Generating answer file with the incorrect domainType ('nfs' instead of 'nfs3') while deploying HE via cockpit based vintage deployment</b><br>
 - [BZ 1415179](https://bugzilla.redhat.com/1415179) <b>[RFE] provide a way for the user to setup-cache</b><br>
 - [BZ 1523573](https://bugzilla.redhat.com/1523573) <b>[RFE] Change 'Standard' term in cockpit deployment to 'Hosted Engine Only Deployment'</b><br>
 - [BZ 1538930](https://bugzilla.redhat.com/1538930) <b>The vintage (based-otopi) deployment didn't use deprecated python flow while deploying HE via cockpit.</b><br>
 - [BZ 1519743](https://bugzilla.redhat.com/1519743) <b>In cockpit installation of self hosted engine inputs invisible on high resolution screens</b><br>
 - [BZ 1535793](https://bugzilla.redhat.com/1535793) <b>Cockpit is missing the options for user configure about HE-VM engine</b><br>
 - [BZ 1529223](https://bugzilla.redhat.com/1529223) <b>Hide the iscsi portal password while deploying SHE with iscsi via cockpit.</b><br>
 - [BZ 1529222](https://bugzilla.redhat.com/1529222) <b>There is the excess step about iscsi portal password while deploying SHE with iscsi via cockpit</b><br>
 - [BZ 1526448](https://bugzilla.redhat.com/1526448) <b>insufficient memory message should state how much memory is needed</b><br>

### No Doc Update

#### oVirt Hosted Engine HA

 - [BZ 1519289](https://bugzilla.redhat.com/1519289) <b>If migration of HE VM failed because of timeout, source host will have hanged state "EngineMigratingAway"</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1529131](https://bugzilla.redhat.com/1529131) <b>iscsi target password visible when having authentication error on deployment</b><br>
 - [BZ 1529490](https://bugzilla.redhat.com/1529490) <b>hosted-engine failed to deploy because of permission error for the cloud-init iso file</b><br>
 - [BZ 1530209](https://bugzilla.redhat.com/1530209) <b>[RFE] when choosing ISCSI - display lun's number to help the user identify the luns</b><br>

#### oVirt Engine

 - [BZ 1523297](https://bugzilla.redhat.com/1523297) <b>Engine fails to create OVN subnet</b><br>
 - [BZ 1517108](https://bugzilla.redhat.com/1517108) <b>[ALL_LANG except zh_CN, ko_KR] Table headers getting truncated on compute->virtual machines-> disks -> new -> direct LUN page.</b><br>
 - [BZ 1418197](https://bugzilla.redhat.com/1418197) <b>[fr_FR] [Admin Portal] The UI alignment needs to be corrected on cluster->new->optimization page.</b><br>
 - [BZ 1497665](https://bugzilla.redhat.com/1497665) <b>NPE in ovirt-engine/docs/manual</b><br>
 - [BZ 1483844](https://bugzilla.redhat.com/1483844) <b>[UI] - Adjust the font size and icons size on the new UI design for the 'Network Interfaces' sub tab</b><br>
 - [BZ 1469538](https://bugzilla.redhat.com/1469538) <b>Network changes to HE VM OVF take longer than other changes</b><br>
 - [BZ 1532018](https://bugzilla.redhat.com/1532018) <b>engine requires tenant name for External Network Provider in RHV 4.2.1</b><br>
 - [BZ 1530526](https://bugzilla.redhat.com/1530526) <b>configure ovirt-provider-ovn dialog appear in PACKAGES section instead of PRODUCT OPTIONS section</b><br>
 - [BZ 1494519](https://bugzilla.redhat.com/1494519) <b>Dashboard in left menu stays highlighted when using any link from it</b><br>

#### oVirt Provider OVN

 - [BZ 1528166](https://bugzilla.redhat.com/1528166) <b>Log source IP and port on requests to the authorization module</b><br>

#### imgbased

 - [BZ 1538925](https://bugzilla.redhat.com/1538925) <b>Failed to upgrade to rhvh-4.1-0.20180125.0</b><br>
