---
title: oVirt 4.2.4 Release Notes
category: documentation
toc: true
---

# oVirt 4.2.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.4 Release as of June 26, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.4, see the [release notes for previous versions](/documentation/#previous-release-notes).


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
[Upgrade Guide](/documentation/upgrade_guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.4?

### Release Note

#### oVirt Engine

 - [BZ 1582527](https://bugzilla.redhat.com/1582527) <b>Enable only strong ciphers from engine to VDSM communication for hosts in cluster level >= 4.2</b><br>This change enables only string ciphers for communication between engine and hosts for clusters with cluster level >= 4.2.<br><br>Following steps need to performed to apply the change:<br><br>1. Newly added hosts<br>    - The change is applied automatically when host is added to engine to clusters with cluster level >= 4.2<br>    - When adding new host to cluster with cluster level 3.6, 4.0 or 4.1 the change is not applied and hosts support all ciphers enabled by underlying libraries<br><br>2. Existing hosts<br>    - to apply the change to existing hosts in cluster level 4.2 please follow steps described in [How to apply change] section<br><br>3. Moving hosts between clusters<br>    - when host is moved to 4.2 cluster the change is not applied automatically. To apply please follow steps described in [How to apply change] section<br><br><br>How to apply change<br>To enable only strong ciphers for a host in cluster with cluster levels >= 4.2 following steps need to be applied:<br><br>1. Move host to Maintenance using option Maintenance in Management menu inside Hosts view<br>2. Reinstall the host using option Reinstall in Installation menu inside Hosts view<br>3. Activate the host after successful reinstallation using Activate option in Management menu inside Hosts view
 - [BZ 1577593](https://bugzilla.redhat.com/1577593) <b>Disable TLS versions < 1.2 for hosts with cluster level >= 4.1</b><br>This change disables TLSv1 and TLSv11 for communication between engine and hosts for clusters with cluster level >= 4.1.<br><br>Following steps need to be performed to apply the change:<br><br>1. Newly added hosts<br>    - The change is applied automatically when host is added to engine to clusters with cluster level >= 4.1<br>    - When adding new host to cluster with cluster level 3.6 or 4.0 the change is not applied and the host supports TLSv1, TLSv11 and TLSv12 protocols<br><br>2. Existing hosts<br>    - to apply the change to existing host in cluster level 4.1 or 4.2 please follow steps described in [How to apply change] section<br><br>3. Moving hosts between clusters<br>    - when host is moved to 4.1 or 4.2 cluster the change is not applied automatically. To apply please follow steps described in [How to apply change] section<br><br><br>How to apply change<br>To disable older TLS versions for a host in cluster with cluster levels >= 4.1 following steps need to be applied:<br><br>1. Move host to Maintenance using option Maintenance in Management menu inside Hosts view<br>2. Reinstall the host using option Reinstall in Installation menu inside Hosts view<br>3. Activate the host after successful reinstallation using Activate option in Management menu inside Hosts view

### Enhancements

#### oVirt Engine

 - [BZ 1549030](https://bugzilla.redhat.com/1549030) <b>Update neutron binding after VM migration with info from caps</b><br>When a port is created/updated, it's "binding:host_id" attribute should be updated with the id of the provider driver id (for example OVN chassis id) reported during get_caps. <br>The port for which the binding has been reported, requires the binding to be set on every consecutive host it moves to. This could be a problem when migrating from a 4.2.2 level host to an earlier one. <br>Hosts before that do not report the host_id. When no provider driver id is reported, the "binding:host_id" is not set, and the value from the previous host will be kept. To fix this, the older hosts need to be updated with a newer version of the provider driver.
 - [BZ 1539765](https://bugzilla.redhat.com/1539765) <b>Auto-Sync - network rename on provider does not trigger rename in engine</b><br>Feature:  External network rename on provider is reflected in engine<br><br>Reason: The name of an external network in engine should be consistent with the name of the same network on the provider.<br><br>Result: Renaming an external network on the provider is reflected in engine.
 - [BZ 1098612](https://bugzilla.redhat.com/1098612) <b>[donstream clone 4.2.4] [RFE] filter for "Allocation Policy" in Disks search</b><br>
 - [BZ 1242822](https://bugzilla.redhat.com/1242822) <b>[RFE] filter for "Allocation Policy" in Disks search</b><br>
 - [BZ 1251468](https://bugzilla.redhat.com/1251468) <b>[RFE] Additional warning when removing required networks</b><br>
 - [BZ 1593653](https://bugzilla.redhat.com/1593653) <b>[downstream clone - 4.2.4] [RFE] virtio nics are reported as '1gbit' nics, and should be '10gbit'</b><br>
 - [BZ 1587884](https://bugzilla.redhat.com/1587884) <b>[downstream clone - 4.2.4] [RFE] Include storage domain UUID in Storage Domain 'General' tab</b><br>
 - [BZ 1579302](https://bugzilla.redhat.com/1579302) <b>support more granularity in cluster cpu types</b><br>Feature: <br>Support distinguishing cpus also by features they support, not just by model.<br><br>Reason: <br>If a new CPU feature is important, it is important to be able to distinguish if the CPU with some model also supports this feature and than require this feature also for VMs.<br><br>Result: <br>Now, it is possible to distinguish CPUs also by features and require them for the VMs. CPU types take additional flags in addition to their libvirt name. Like e.g. SandyBridge, you can specify custom CPU as “SandyBridge,+xyz” or “SandyBridge,-xyz” to add or remove arbitrary individual CPU flags in addition to what the named model contains.
 - [BZ 1577901](https://bugzilla.redhat.com/1577901) <b>[RFE] add content type column to disk table</b><br>

#### oVirt Engine Appliance

 - [BZ 1582507](https://bugzilla.redhat.com/1582507) <b>[downstream clone - 4.2.4] [RFE] Add  ovirt-engine-extension-aaa-ldap-setup and  ovirt-engine-extension-aaa-ldap to RHV-M Image</b><br>

#### oVirt Host Dependencies

 - [BZ 1579210](https://bugzilla.redhat.com/1579210) <b>[downstream clone - 4.2.4] add cockpit-machines-ovirt to RHVH hosts</b><br>The cockpit-machines-ovirt plugin (https://cockpit-project.org/guide/latest/feature-ovirtvirtualmachines) has been added to Red Hat Enterprise Linux hosts and Red Hat Virtualization Hosts.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine

 - [BZ 1585157](https://bugzilla.redhat.com/1585157) <b>[downstream clone - 4.2.4] [UI] - VM's network interface name and icon too large and wrap</b><br>

### Bug Fixes

#### oVirt Engine

 - [BZ 1583619](https://bugzilla.redhat.com/1583619) <b>[downstream clone - 4.2.4] [SCALE] Listing users in Users tab overloads the postgresql DB (CPU)</b><br>
 - [BZ 1579719](https://bugzilla.redhat.com/1579719) <b>Geo-Replication failing to kick off geo-rep session daily, when the same volume is used for two different sessions and one gets destroyed.</b><br>
 - [BZ 1578257](https://bugzilla.redhat.com/1578257) <b>Unable to schedule a Snapshot of a Gluster volume</b><br>
 - [BZ 1574191](https://bugzilla.redhat.com/1574191) <b>SyncNetworkProviderCommand fails on NPE if Provider is DNP of a Cluster with no DC</b><br>
 - [BZ 1574451](https://bugzilla.redhat.com/1574451) <b>UI exception seen in ovirt-engine</b><br>

#### VDSM

 - [BZ 1584523](https://bugzilla.redhat.com/1584523) <b>[downstream clone - 4.2.4] [HE] Failed to deploy RHV-H on Hosted engine</b><br>
 - [BZ 1576442](https://bugzilla.redhat.com/1576442) <b>KeyError: 'sizeTotal' in gluster volume status monitoring</b><br>
 - [BZ 1576675](https://bugzilla.redhat.com/1576675) <b>RHV import fails if VM has an unreachable floppy defined</b><br>

#### oVirt Engine Metrics

 - [BZ 1572508](https://bugzilla.redhat.com/1572508) <b>fluentd unable to connect keeps retrying every 3 minutes</b><br>

#### ovirt-engine-dwh

 - [BZ 1576937](https://bugzilla.redhat.com/1576937) <b>Value too long for type character varying(50) for host_interface_configuration and vm_interface_configuration</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1583712](https://bugzilla.redhat.com/1583712) <b>hosted-engine metadata are not correctly read and write on hosts set into maintenance mode from the engine</b><br>
 - [BZ 1557793](https://bugzilla.redhat.com/1557793) <b>ovirt-hosted-engine-cleanup takes too much time</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1576310](https://bugzilla.redhat.com/1576310) <b>[OVN] - [HE] - ovn tunnel is not created if central hostname resolved as 127.0.0.1 in hosts file</b><br>
 - [BZ 1557793](https://bugzilla.redhat.com/1557793) <b>ovirt-hosted-engine-cleanup takes too much time</b><br>
 - [BZ 1557775](https://bugzilla.redhat.com/1557775) <b>[RFE] During deployment, verification is missing for wrong NFS path.</b><br>

#### imgbased

 - [BZ 1568414](https://bugzilla.redhat.com/1568414) <b>missing lvm filter causing "nodectl check" to fail to verify thinprovisioned local lv metadata</b><br>

### Other

#### oVirt Engine

 - [BZ 1585990](https://bugzilla.redhat.com/1585990) <b>Empty cluster from upgraded 4.1 engine does not have Cluster CPU Type set</b><br>
 - [BZ 1585950](https://bugzilla.redhat.com/1585950) <b>[downstream clone - 4.2.4] Live Merge failed on engine with "still in volume chain", but merge on host was successful</b><br>
 - [BZ 1585455](https://bugzilla.redhat.com/1585455) <b>[downstream clone - 4.2.4] Move disk failed but delete was called on source sd, losing all the data</b><br>
 - [BZ 1576377](https://bugzilla.redhat.com/1576377) <b>engine-setup rewrites SSL*File options</b><br>engine-setup now checks if apache httpd's ssl.conf file needs updates also on upgrades, prompts accordingly, and applies the updates as needed. Now, only parameters that actually require a change are changed - specifically, manual user changes to SSL certificates are not overridden.<br><br>doc team: Please see bug 1558500 and comment 0 of current.<br><br>Copied doc text from that bug and added a statement. Feel free to rewrite however you find best.<br><br>Also, "parameters that actually require a change" are currently only a single one, "SSLProtocol". So if you want to be more specific than we tried to be in the past (and in the code), it's enough to:<br><br>engine-setup now only updates SSLProtocol in apache httpd's ssl.conf file, if needed, and not other parameters.
 - [BZ 1553112](https://bugzilla.redhat.com/1553112) <b>NumberFormatException importing VMWARE ova</b><br>
 - [BZ 1581701](https://bugzilla.redhat.com/1581701) <b>The custom serial number policy does not work in 4.2</b><br>
 - [BZ 1515877](https://bugzilla.redhat.com/1515877) <b>Unable to define QoS for the 10Gbit interface</b><br>
 - [BZ 1582822](https://bugzilla.redhat.com/1582822) <b>[UI] - Interface name is gone in the Network Interfaces sub tab</b><br>
 - [BZ 1574508](https://bugzilla.redhat.com/1574508) <b>Space used icon in RHV-M not showing the actual space</b><br>
 - [BZ 1578763](https://bugzilla.redhat.com/1578763) <b>[downstream clone - 4.2.4] Unreachable ISO/Export SD prevents hosts from activating</b><br>
 - [BZ 1584885](https://bugzilla.redhat.com/1584885) <b>VM remains migrating forever with no Host (actually doesn't exist) after StopVmCommand fails to DestroyVDS</b><br>
 - [BZ 1583579](https://bugzilla.redhat.com/1583579) <b>[downstream clone - 4.2.4] Very slow UI if Host has many (~64) elements (VFs or dummies or networks)</b><br>
 - [BZ 1573216](https://bugzilla.redhat.com/1573216) <b>non-VM network appears in the new vNIC profile drop down</b><br>
 - [BZ 1573462](https://bugzilla.redhat.com/1573462) <b>wrong SinglePciQxl initialization during import from OVF</b><br>
 - [BZ 1561865](https://bugzilla.redhat.com/1561865) <b>[Code Change] - Validate duplicate MACs on unset 'Allow Duplicates' and  transaction rollback fix</b><br>
 - [BZ 1585013](https://bugzilla.redhat.com/1585013) <b>[downstream clone - 4.2.4] ovirt-engine loses track of a cancelled disk</b><br>
 - [BZ 1571849](https://bugzilla.redhat.com/1571849) <b>USB controllers not written to snapshots</b><br>
 - [BZ 1573145](https://bugzilla.redhat.com/1573145) <b>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision</b><br>Cause: <br>The precision of the rx_rate, tx_rate of virtual and host network interfaces has been increased on the engine db.<br><br>Consequence: <br>This requires updating the dwh precision for better reporting.<br><br>Fix:<br>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision<br><br>Result: <br>Hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision was increased on DWH.
 - [BZ 1590185](https://bugzilla.redhat.com/1590185) <b>MAC pool ranges off by one</b><br>
 - [BZ 1583491](https://bugzilla.redhat.com/1583491) <b>[UI] - Align the (mbps)/(bytes) in network's statistics</b><br>
 - [BZ 1550099](https://bugzilla.redhat.com/1550099) <b>[RFE] - [SR-IOV] Network Interfaces sub tab - Add button 'Show VFs/Hide Vfs'</b><br>
 - [BZ 1585039](https://bugzilla.redhat.com/1585039) <b>[downstream clone - 4.2.4] Live Storage Migration continued on after snapshot creation hung and timed out</b><br>
 - [BZ 1576382](https://bugzilla.redhat.com/1576382) <b>no VM name validation on import from OVF</b><br>
 - [BZ 1574480](https://bugzilla.redhat.com/1574480) <b>vGPU: Webadmin should reject VM snapshot creation when using mdev_type hook.</b><br>
 - [BZ 1578276](https://bugzilla.redhat.com/1578276) <b>[engine-setup] PostgreSQL conf verification text is broken</b><br>
 - [BZ 1558614](https://bugzilla.redhat.com/1558614) <b>OVA import does not set CPU topology correctly.</b><br>
 - [BZ 1568305](https://bugzilla.redhat.com/1568305) <b>empty vNIC profiles tab in edit Network dialog</b><br>
 - [BZ 1539589](https://bugzilla.redhat.com/1539589) <b>ovn localnet - On OVS cluster don't allow to attach VM networks to VM</b><br>
 - [BZ 1551910](https://bugzilla.redhat.com/1551910) <b>[ja_JP] Text truncation observed on compute -> hosts -> network interfaces -> setup host networks page.</b><br>
 - [BZ 1543062](https://bugzilla.redhat.com/1543062) <b>Auto-sync - additional OVN cluster on DC does not consume OVN network as expected</b><br>
 - [BZ 1583486](https://bugzilla.redhat.com/1583486) <b>Block renaming/modifying name of external provider</b><br>
 - [BZ 1552449](https://bugzilla.redhat.com/1552449) <b>[UI] - Adjust VM's vNIC panel to the exact size of the host's NIC panel and align vNIC's icons to the center</b><br>
 - [BZ 1491155](https://bugzilla.redhat.com/1491155) <b>[Text] Report owner(s) of colliding MAC address if already in use</b><br>
 - [BZ 1565523](https://bugzilla.redhat.com/1565523) <b>engine-backup(8) man page is not up-to-date with engine-backup features</b><br>
 - [BZ 1570383](https://bugzilla.redhat.com/1570383) <b>[PPC] Webadmin doesn't expose sPAPR VSCSI disk interface in disk creation prompt that is initiated from within VM creation prompt</b><br>
 - [BZ 1565534](https://bugzilla.redhat.com/1565534) <b>[UI] - Reverse the title and the entity on the NIC panel - MAC, Statistics and for the new vNIC design</b><br>
 - [BZ 1483846](https://bugzilla.redhat.com/1483846) <b>[UI] - Adjust the VM's vNIC panel to be similar to the new host NIC panel information design</b><br>
 - [BZ 1572157](https://bugzilla.redhat.com/1572157) <b>bad checkbox spacing in Logical Networks > New > Cluster</b><br>
 - [BZ 1570919](https://bugzilla.redhat.com/1570919) <b>[CodeChange][i18n] oVirt 4.2.4 translation pull</b><br>
 - [BZ 1541917](https://bugzilla.redhat.com/1541917) <b>[ja_JP] Text alignment correction needed on compute -> hosts -> new -> network provider window</b><br>
 - [BZ 1551994](https://bugzilla.redhat.com/1551994) <b>[All_LANG except zh,ko] Text truncation observed on networks -> networks -> import page.</b><br>
 - [BZ 1586023](https://bugzilla.redhat.com/1586023) <b>Guarenteed space differing under storage domains in the RHV-M</b><br>
 - [BZ 1587885](https://bugzilla.redhat.com/1587885) <b>[downstream clone - 4.2.4] [RFE] Need a way to track how many logical volumes consumed in a storage domain and alert when it gets full</b><br>The storage domain's General sub-tab in the Administration Portal now shows the number of images on the storage domain under the rubric "Images", this corresponds to the number of LVs on a block domain.
 - [BZ 1582160](https://bugzilla.redhat.com/1582160) <b>Unable to obtain a template list of a storage domain</b><br>
 - [BZ 1583562](https://bugzilla.redhat.com/1583562) <b>Failed to active host after upgrade (host was in PreparingForMaintenance before upgrade)</b><br>
 - [BZ 1583664](https://bugzilla.redhat.com/1583664) <b>After update "provider_binding_host_id" table doesn't exist, hosts are stuck in Activating state</b><br>
 - [BZ 1579102](https://bugzilla.redhat.com/1579102) <b>VM can be started while ISO is still uploading</b><br>
 - [BZ 1506473](https://bugzilla.redhat.com/1506473) <b>[disk content type] the default filtering is 'All' and the button of 'All' should also be selected after reloading RHV</b><br>
 - [BZ 1506468](https://bugzilla.redhat.com/1506468) <b>[disk content type] The disk default content type is 'All' and the button should be set to 'All' as well</b><br>
 - [BZ 1572071](https://bugzilla.redhat.com/1572071) <b>API SDK doesn't provide search method in external providers</b><br>
 - [BZ 1585456](https://bugzilla.redhat.com/1585456) <b>[downstream clone - 4.2.4] ovirt-engine fails to start when having a large number of stateless snapshots</b><br>
 - [BZ 1582826](https://bugzilla.redhat.com/1582826) <b>[UI] -  When opening the setup networks dialogue it is taking few seconds to load the host interfaces</b><br>
 - [BZ 1572148](https://bugzilla.redhat.com/1572148) <b>Fencing takes too long when first agent is unreachable</b><br>
 - [BZ 1574862](https://bugzilla.redhat.com/1574862) <b>Vague message on failure in upgrade of compatibility level on cluster</b><br>
 - [BZ 1581158](https://bugzilla.redhat.com/1581158) <b>Live Storage Migration releases lock twice</b><br>
 - [BZ 1560553](https://bugzilla.redhat.com/1560553) <b>VMs imported from OVAs miss properties compared to ones imported from an export domain</b><br>
 - [BZ 1575596](https://bugzilla.redhat.com/1575596) <b>/vm/affinitylabels should return the same as /affinitylabels</b><br>
 - [BZ 1568669](https://bugzilla.redhat.com/1568669) <b>404 response when query for VM's sessions if a session already opened with a user account</b><br>The bug happens when getting user information to set within the session object. This is wrong to begin with, because the convention in the API is to return the data of the entity which is being retrieved, and only links to referenced entities, not their contents. So the fix to this bug will result in only the link to the user set within the session, and this should obviously work for both admin and non-admin users.
 - [BZ 1514374](https://bugzilla.redhat.com/1514374) <b>oVirt webadmin  StorageQoS input letters still could click confirm.</b><br>
 - [BZ 1579909](https://bugzilla.redhat.com/1579909) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>Vdsm uses the domain metadata section to store extra data which is required to configure a VM but not properly represented on the standard libvirt domain.<br>This always happens when a VM starts.<br>Vdsm tried to store the drive IO tune settings in the metadata, which was redundant because the IO tune has already a proper representation.<br>Furthermore the implementation of the store operation of the IO tune settings had an implementation bug, which made it not possible to succesfully start the VM.<br>This bug appears only if IO tune settings are enabled.
 - [BZ 1563567](https://bugzilla.redhat.com/1563567) <b>Change CD dialog lists isos in non-ordered way, dialog list too small</b><br>
 - [BZ 1578756](https://bugzilla.redhat.com/1578756) <b>Importing an OVA made in ovirt failed on extract disks (ExtractOvaCommand)</b><br>
 - [BZ 1578416](https://bugzilla.redhat.com/1578416) <b>Register a partial Template with allow_partial flag throws an exception</b><br>
 - [BZ 1573091](https://bugzilla.redhat.com/1573091) <b>Do no force DB patch version and settings in setup for remote databases.</b><br>engine-setup now allows using a remote PostgreSQL database with a different Z version - e.g. 9.5.9 client (the engine machine) can use a 9.5.8 remote database server.<br><br>engine-setup also allows forcing it to ignore all PostgreSQL sanity/configuration checks.<br><br>Doc team: See also comment 6 for latter. I'd rather not include the details in the doc text.<br><br>For oVirt I added text to [1].<br><br>For RHV we might want a KB article.<br><br>[1] https://ovirt.org/develop/developer-guide/engine/engine-setup/
 - [BZ 1557770](https://bugzilla.redhat.com/1557770) <b>Webadmin-imageIO - 'Cancel' option should be removed from download disk</b><br>
 - [BZ 1573865](https://bugzilla.redhat.com/1573865) <b>[WebAdmin] Move disk dialog displays orange container for warning message even when it is empty</b><br>
 - [BZ 1585454](https://bugzilla.redhat.com/1585454) <b>[downstream clone - 4.2.4] Uploaded image: Virtual Size of qcow2 image is not reflected at guest OS level</b><br>
 - [BZ 1573913](https://bugzilla.redhat.com/1573913) <b>upload image dialog - test connection button should be displayed for any DC</b><br>
 - [BZ 1571154](https://bugzilla.redhat.com/1571154) <b>vdsm reports to engine  the local host network address IPv4 and IPv6 during the VM launch</b><br>
 - [BZ 1571323](https://bugzilla.redhat.com/1571323) <b>Create template fail sometimes</b><br>
 - [BZ 1566393](https://bugzilla.redhat.com/1566393) <b>When registering a VM that has disks on detached SD, error appears in engine.log, showing null as the SD name</b><br>
 - [BZ 1572067](https://bugzilla.redhat.com/1572067) <b>can't search in external providers</b><br>

#### VDSM

 - [BZ 1583045](https://bugzilla.redhat.com/1583045) <b>Failed to add a second host after a successful deployment due to a name clash on vdsm python module</b><br>
 - [BZ 1570349](https://bugzilla.redhat.com/1570349) <b>After upgrade from 4.1 to 4.2.3 vm disk is inactive and vm nic is un-plugged</b><br>
 - [BZ 1591667](https://bugzilla.redhat.com/1591667) <b>[downstream clone - 4.2.4] Live storage migration completes but leaves volume un-opened.</b><br>
 - [BZ 1534197](https://bugzilla.redhat.com/1534197) <b>After updating to current RHV-H, vdsmd consistently fails to start on startup.</b><br>
 - [BZ 1585030](https://bugzilla.redhat.com/1585030) <b>[downstream clone - 4.2.4] RAW-Preallocated disk is converted to RAW-sparse while cloning a VM in file based storage domain</b><br>
 - [BZ 1568696](https://bugzilla.redhat.com/1568696) <b>Failed to convert app: [[Ljava.lang.Object;] warning appear in engine.log</b><br>
 - [BZ 1567603](https://bugzilla.redhat.com/1567603) <b>[CodeChange] Cleanup create snapshot code after requiring qemu > 2.10</b><br>
 - [BZ 1579909](https://bugzilla.redhat.com/1579909) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>Vdsm uses the domain metadata section to store extra data which is required to configure a VM but not properly represented on the standard libvirt domain.<br>This always happens when a VM starts.<br>Vdsm tried to store the drive IO tune settings in the metadata, which was redundant because the IO tune has already a proper representation.<br>Furthermore the implementation of the store operation of the IO tune settings had an implementation bug, which made it not possible to succesfully start the VM.<br>This bug appears only if IO tune settings are enabled.
 - [BZ 1580478](https://bugzilla.redhat.com/1580478) <b>Vdsm should support hotunplug by Alias</b><br>
 - [BZ 1565002](https://bugzilla.redhat.com/1565002) <b>Check vdsmd status before starting rpm upgrade</b><br>

#### oVirt Engine Metrics

 - [BZ 1585963](https://bugzilla.redhat.com/1585963) <b>Error in collectd 05-global-configuration.conf file - missing end of line</b><br>
 - [BZ 1573784](https://bugzilla.redhat.com/1573784) <b>Deprecation warning in fluentd forward plugin</b><br>

#### ovirt-engine-dwh

 - [BZ 1586011](https://bugzilla.redhat.com/1586011) <b>ovirt-engine-provisiondb should not try to connect to databases</b><br>
 - [BZ 1573145](https://bugzilla.redhat.com/1573145) <b>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision</b><br>Cause: <br>The precision of the rx_rate, tx_rate of virtual and host network interfaces has been increased on the engine db.<br><br>Consequence: <br>This requires updating the dwh precision for better reporting.<br><br>Fix:<br>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision<br><br>Result: <br>Hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision was increased on DWH.

#### oVirt Hosted Engine HA

 - [BZ 1585028](https://bugzilla.redhat.com/1585028) <b>[downstream clone - 4.2.4] RHV-H 4.2.3: hosted-engine agent fails to start after upgrade due to Permission denied: '/var/log/ovirt-hosted-engine-ha/broker.log' '/var/log/ovirt-hosted-engine-ha/agent.log'</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1578418](https://bugzilla.redhat.com/1578418) <b>Checks on bond mode are not effective</b><br>
 - [BZ 1594024](https://bugzilla.redhat.com/1594024) <b>[HE] Failed to deploy hosted engine over NFS on updated rhel7.5 with ansible 2.6</b><br>
 - [BZ 1578404](https://bugzilla.redhat.com/1578404) <b>Fetch engine logs from the engine VM</b><br>
 - [BZ 1573074](https://bugzilla.redhat.com/1573074) <b>The deployment fails on create_storage_domain stage when using generated answers</b><br>
 - [BZ 1576451](https://bugzilla.redhat.com/1576451) <b>ovirt-hosted-engine-cleanup must undefine the HostedEngine VM</b><br>

#### cockpit-ovirt

 - [BZ 1582579](https://bugzilla.redhat.com/1582579) <b>Using  a new device for creating non vdo volume is being blocked</b><br>
 - [BZ 1583637](https://bugzilla.redhat.com/1583637) <b>HE Wizard - General error message displayed with no field-specific errors</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1434834](https://bugzilla.redhat.com/1434834) <b>Implement automatic SSO token renew</b><br>
 - [BZ 1571648](https://bugzilla.redhat.com/1571648) <b>Detailed message in Error SDK</b><br>

#### oVirt Log Collector

 - [BZ 1573143](https://bugzilla.redhat.com/1573143) <b>Collect ovirt-provider-ovn logs.</b><br>

#### OTOPI

 - [BZ 1574433](https://bugzilla.redhat.com/1574433) <b>"Invalid data received during bootstrap" errors do not log the invalid data</b><br>

#### oVirt Provider OVN

 - [BZ 1580254](https://bugzilla.redhat.com/1580254) <b>removing routers external_gateway by port leaks static_routes</b><br>
 - [BZ 1559056](https://bugzilla.redhat.com/1559056) <b>Provider does not check if generated port MAC address is already assigned</b><br>

#### imgbased

 - [BZ 1585028](https://bugzilla.redhat.com/1585028) <b>[downstream clone - 4.2.4] RHV-H 4.2.3: hosted-engine agent fails to start after upgrade due to Permission denied: '/var/log/ovirt-hosted-engine-ha/broker.log' '/var/log/ovirt-hosted-engine-ha/agent.log'</b><br>
 - [BZ 1589544](https://bugzilla.redhat.com/1589544) <b>[HE] host-deploy fails to start vdsmd on node/rhel-h</b><br>
 - [BZ 1534197](https://bugzilla.redhat.com/1534197) <b>After updating to current RHV-H, vdsmd consistently fails to start on startup.</b><br>

#### oVirt Node

 - [BZ 1534197](https://bugzilla.redhat.com/1534197) <b>After updating to current RHV-H, vdsmd consistently fails to start on startup.</b><br>

### No Doc Update

#### VDSM JSON-RPC Java

 - [BZ 1571768](https://bugzilla.redhat.com/1571768) <b>Connections shouldn't be closed after the connection to the host was recovered</b><br>

#### oVirt Engine

 - [BZ 1422428](https://bugzilla.redhat.com/1422428) <b>[fr-FR] Admin portal->Quota: measurements units are mixed up (GB in English and Go in French all mixed up).</b><br>
 - [BZ 1542341](https://bugzilla.redhat.com/1542341) <b>[fr, de, es] A button label on administration ->quota -> add page is getting truncated.</b><br>
 - [BZ 1542880](https://bugzilla.redhat.com/1542880) <b>[fr, es, pt_BR, ja] Text alignment correction needed on compute -> virtual machines -> affinity groups -> new page</b><br>
 - [BZ 1541309](https://bugzilla.redhat.com/1541309) <b>[ja_JP] Text Positioning needs to be adjusted on Administration -> Quota -> add screen.</b><br>
 - [BZ 1541348](https://bugzilla.redhat.com/1541348) <b>[ja, zh_CN, ko] Text positioning needs to be adjusted on Administration - Configure -> scheduling policy -> new page</b><br>
 - [BZ 1576752](https://bugzilla.redhat.com/1576752) <b>Number of "Prestarted VMs" is ignored and all VMs of Pool starts after editing existing Pool.</b><br>
 - [BZ 1582356](https://bugzilla.redhat.com/1582356) <b>UI hangs with NPE while trying to migrate VM in Powering Up status</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1571119](https://bugzilla.redhat.com/1571119) <b>[HE] - Engine complaining that the 'VM HostedEngine is down with error. Exit message: resource busy: Failed to acquire lock: Lease is held by another host.'</b><br>
 - [BZ 1582489](https://bugzilla.redhat.com/1582489) <b>Memory leak, at least 7.31 KB per minute</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1572542](https://bugzilla.redhat.com/1572542) <b>argument vlan_tag is of type <type 'str'> and we were unable to convert to int: invalid literal for int() with base 10: '8000\\\\n1'\"}"</b><br>

