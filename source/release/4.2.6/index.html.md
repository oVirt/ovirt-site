---
title: oVirt 4.2.6 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.6 Third Release Candidate as of August 28, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



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

## What's New in 4.2.6?

### Enhancements

#### oVirt Engine

 - [BZ 1457250](https://bugzilla.redhat.com/1457250) <b>[RFE] Provide Live Migration for VMs based on "High Performance VM" Profile - manual migrations</b><br>Feature: <br>This feature provides the ability to enable the live migration for those HP VMs (and in general to all VM types with pinning settings).<br><br>Reason: <br>n oVirt 4.2 we added a new “High Performance” VM profile type. This required configuration settings includes pinning the VM to a host based on the host specific configuration. Due to that pinning settings, the migration option for the HP VM type was automatically forced to be disabled.<br><br>Result: <br>in oVirt 4.2.x we will provide the ability to manual migrate the HP VM. This is the first phase solution as mentioned in the feature page.<br>In next oVirt release 4.2 we will provide a full automatic solution.<br><br>This solution for 4.2.x includes:<br>1. Only manual migration can be done for HP VMs via the UI. In addition the user will have to choose the destination host to migrate to.<br>2. Manual migration is also supported for Server/Desktop VM types with pinned configuration, but only via REST api.<br><br>For more details on this first phase/manual solution, please refer to the feature page: https://www.ovirt.org/develop/release-management/features/virt/high-performance-vm-migration/
 - [BZ 1558847](https://bugzilla.redhat.com/1558847) <b>[RFE] Sync all networks across all hosts in cluster</b><br>Feature: Enable all-network sync at the cluster level<br><br>Reason: When changing a data-center network, multiple hosts can end up out of sync.<br><br>Result: User can sync all networks belonging to all hosts of a cluster<br><br>Suggestd addition to RHEV Admin guide (under 'Editing Host Network Interfaces and Assigning Logical Networks to Hosts' or 'Editing a Logical Network'):<br><br>Note:<br><br>Modifying the properties of a network interface card on the host will cause these properties to be out of sync with the engine's corresponding logical network properties.<br>This fact will be acknowledged by a symbol on the relevant interface in the Network Interfaces list of the host. If the symbol does not show use Refresh Capabilities. When<br>engine is aware that the network is out of sync, a 'Sync All Networks' button will become enabled in two location in the webadmin:<br>- Network Interfaces list of the host<br>- Logical Networks list of the cluster<br>Pressing the button at the host level will trigger a sync of all the properties of all network interface cards of the host to engine's corresponding logical networks.<br>Pressing the button at the cluster level will trigger a sync of all the properties of all network interface cards of all the hosts of the cluster to engine's corresponding logical networks.<br>Once the sync operation terminates (or a short while thereafter) the button will become disabled again.
 - [BZ 1565541](https://bugzilla.redhat.com/1565541) <b>packaging: Ansible playbook to set ovn cluster tunnel should accept long network names</b><br>This fature adds support for long network names<br>when modifying the tunneling network for ovn<br>controllers. <br><br>The usage of the script: <br><br>'ansible-playbook --key-file <pubkey> -i <inventory> --extra-vars " cluster_name=<cluster name> ovn_central=<ovn central ip> ovirt_network=<ovirt network name> ovn_tunneling_interface=<vdsm_network_name>"' <br><br>Paramters:<br>  cluster_name - name of cluster on which to do the change<br>  ovirt_network - the ovirt network name (can be long name)<br>  ovn_tunneling_interface - specifies the vdsm network name (same as bridge name on vdsm)<br><br>Either 'ovirt_network' or 'ovn_tunneling_interface'<br>can be defined. The playbook will fail if both are<br>defined.<br><br>The 'inventory' paramter is the vm inventory for ovirt.<br>The following script can be used to retrieve this:<br>  /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory<br><br>The user has to provider a key to long into the hosts.<br>The default key used by ovirt-engine is usually located in:<br>  /etc/pki/ovirt-engine/keys/engine_id_rsa<br><br><br><br>Example of usage:<br><br>using ovirt_network parameter for ovirt network "Long Network Name with ascii char ☺":<br><br>ansible-playbook --key-file /etc/pki/ovirt-engine/keys/engine_id_rsa -i /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory --extra-vars " cluster_name=test-cluster ovn_central=192.168.200.2 ovirt_network=\"Long\ Network\ Name\ with\ \ascii\ char\ \☺\"" ovirt-provider-ovn-driver.yml<br><br>using ovn_tunneling_interface parameter for vdsm network "on703ea21ddbc34":<br><br>ansible-playbook --key-file /etc/pki/ovirt-engine/keys/engine_id_rsa -i /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory --extra-vars " cluster_name=test-cluster ovn_central=192.168.200.2 ovn_tunneling_interface=on703ea21ddbc34" ovirt-provider-ovn-driver.yml
 - [BZ 1596151](https://bugzilla.redhat.com/1596151) <b>enable migration for cpu pinned VMs</b><br>Remove the config parameter called "CpuPinMigrationEnabled" (appears on DB in vdc_options table) in downstream and upstream installations. <br>This change was done to support High Performance VM live migration (BZ 1457250)

#### VDSM

 - [BZ 1622700](https://bugzilla.redhat.com/1622700) <b>[downstream clone - 4.2.6] [RFE][Dalton] - Blacklist all local disk in multipath on RHEL / RHEV Host (RHEL 7.5)</b><br>Feature:<br>Blacklist local devices in multipath. <br><br>Reason: <br>multipath repeatedly logs irrelevant errors for local devices.<br><br>Result: <br>Local devices are blacklisted, and no irrelevant errors are logged anymore.

#### oVirt Setup Lib

 - [BZ 1295041](https://bugzilla.redhat.com/1295041) <b>[RFE] add IPv6 support to ovirt-setup-lib</b><br>Feature: add IPv6 support to engine-setup<br><br>Reason: <br><br>Result:

#### oVirt Hosted Engine Setup

 - [BZ 1608467](https://bugzilla.redhat.com/1608467) <b>[TEXT] - the deployment will fail late if firewalld is disabled or masked on the host</b><br>The deployment is going to fail if firewalld is masked on the host, checking this earlier.

#### oVirt Engine Metrics

 - [BZ 1607127](https://bugzilla.redhat.com/1607127) <b>[RFE] Update ansible-inventory file to use latest instead of version</b><br>Feature: <br>Add symlink that uses latest instead of the specific version for the ansible-inventory files.<br><br>Reason: <br>So that documentation is always up to date and user does not need to specify the version to install.<br><br>Result: <br>Add symlink that uses latest instead of the specific version for the ansible-inventory files.<br><br>Also, the version to install is a parameter openshift_version that is set to 310 but can also be updated to 39.<br><br>Also, for upstream we set openshift_distribution to origin and in downstream ocp. This allows installing only the relevant ansible-inventory file to the metrics store machine.

### Bug Fixes

#### oVirt Engine

 - [BZ 1619474](https://bugzilla.redhat.com/1619474) <b>Pending change IO thread disable is not applied on shutdown</b><br>
 - [BZ 1622994](https://bugzilla.redhat.com/1622994) <b>[downstream clone - 4.2.6] IO-Threads is enabled inadvertently by editing unrelated configuration</b><br>
 - [BZ 1609147](https://bugzilla.redhat.com/1609147) <b>[REST API] all VMs in VM Pool are returned to a pool user regardless of actual VM ownership</b><br>
 - [BZ 1581709](https://bugzilla.redhat.com/1581709) <b>Move the vfio-mdev vGPU hook to a VDSM code base</b><br>
 - [BZ 1608828](https://bugzilla.redhat.com/1608828) <b>[downstream clone - 4.2.6] Unable to perform upgrade from 4.1 to 4.2 due to selinux related errors.</b><br>
 - [BZ 1589045](https://bugzilla.redhat.com/1589045) <b>[RHHI] Brick profile feature in RHV-M doesn't seems to be working</b><br>
 - [BZ 1613875](https://bugzilla.redhat.com/1613875) <b>[downstream clone - 4.2.6] Indicate that RHV-H hosts have to be rebooted always after upgrade</b><br>

#### VDSM

 - [BZ 1581709](https://bugzilla.redhat.com/1581709) <b>Move the vfio-mdev vGPU hook to a VDSM code base</b><br>

#### oVirt Windows Guest Tools

 - [BZ 1609779](https://bugzilla.redhat.com/1609779) <b>Unquoted Service Paths Windows guest tools</b><br>

#### imgbased

 - [BZ 1601633](https://bugzilla.redhat.com/1601633) <b>If upgrading fails, the new LV should be removed in the RPM %post script</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1590359](https://bugzilla.redhat.com/1590359) <b>[ovn-provider] wrong message when posting a Subnet with no default gateway</b><br>
 - [BZ 1503577](https://bugzilla.redhat.com/1503577) <b>Duplicate OVN network name (with subnet) on different DCs pops unfriendly UI message</b><br>
 - [BZ 1608408](https://bugzilla.redhat.com/1608408) <b>Listing ports fails when stray subnet is present in db</b><br>

#### oVirt Engine

 - [BZ 1615124](https://bugzilla.redhat.com/1615124) <b>[RFE] upload image - add sparse flag to ticket</b><br>
 - [BZ 1613282](https://bugzilla.redhat.com/1613282) <b>Failed to hot-Unplug disk from VM with Code 46 (Timeout detaching)</b><br>
 - [BZ 1610758](https://bugzilla.redhat.com/1610758) <b>When specifying folder of OVAs in import dialog, the task hangs forever</b><br>
 - [BZ 1601469](https://bugzilla.redhat.com/1601469) <b>[OVN] - Create external network's vNIC profile without network filter</b><br>
 - [BZ 1595140](https://bugzilla.redhat.com/1595140) <b>Exceptions seen with refreshing geo-rep session on the gluster volume</b><br>
 - [BZ 1610248](https://bugzilla.redhat.com/1610248) <b>Create new Georep session popup does not open</b><br>
 - [BZ 1590109](https://bugzilla.redhat.com/1590109) <b>refresh caps events are not sent on network dhcp attachment or update</b><br>
 - [BZ 1607704](https://bugzilla.redhat.com/1607704) <b>[Engine] Cannot modify vNic profile of running vm with MTU set in its XML</b><br>
 - [BZ 1584734](https://bugzilla.redhat.com/1584734) <b>A UI exception while creating a new network on external provider</b><br>
 - [BZ 1571563](https://bugzilla.redhat.com/1571563) <b>The VM could not be edited from HighPerformance or Server to Desktop in PPC arch (even if the new create of Desktop is allowed)</b><br>
 - [BZ 1589790](https://bugzilla.redhat.com/1589790) <b>[UI] - Remove subnet sub tab from edit external network flow</b><br>
 - [BZ 1603878](https://bugzilla.redhat.com/1603878) <b>[UI] Cannot copy-paste Network Interface MAC address</b><br>
 - [BZ 1619730](https://bugzilla.redhat.com/1619730) <b>increase execution rate of ExtendImageTicket</b><br>
 - [BZ 1608291](https://bugzilla.redhat.com/1608291) <b>[RFE] Should be able to change the Port number of NoVnc</b><br>
 - [BZ 1620178](https://bugzilla.redhat.com/1620178) <b>Auto enable multiple network queues for high Performance VMS</b><br>
 - [BZ 1613104](https://bugzilla.redhat.com/1613104) <b>The engine is generating domain XML for HE VM also if the cluster compatibility level doesn't allow it</b><br>
 - [BZ 1613341](https://bugzilla.redhat.com/1613341) <b>API doesn't return stored ssh public key for non admin user properly</b><br>
 - [BZ 1552098](https://bugzilla.redhat.com/1552098) <b>Rephrase: "command GetStatsAsyncVDS failed: Heartbeat exceeded" error message</b><br>
 - [BZ 1570988](https://bugzilla.redhat.com/1570988) <b>Don't try to remove functions, views or tables in public schema installed by PostgreSQL extensions</b><br>
 - [BZ 1608392](https://bugzilla.redhat.com/1608392) <b>Status code from the API for unsupported reduce volume actions (for disk that resides on file based domain for example) is 400 (bad request) instead 409 (conflict)</b><br>
 - [BZ 1573184](https://bugzilla.redhat.com/1573184) <b>StreamingAPI - Transfer disk Lock is freed before transfer is complete - after Finalizing phase but before Finished Success</b><br>
 - [BZ 1608716](https://bugzilla.redhat.com/1608716) <b>upload image - rounded up size value for the created disk</b><br>
 - [BZ 1609011](https://bugzilla.redhat.com/1609011) <b>Creating transient disk during backup operation is failing with error "No such file or directory"</b><br>
 - [BZ 1579303](https://bugzilla.redhat.com/1579303) <b>External VMs prevent placing host in maintenance mode</b><br>
 - [BZ 1600325](https://bugzilla.redhat.com/1600325) <b>Link to change password is broken</b><br>
 - [BZ 1591271](https://bugzilla.redhat.com/1591271) <b>Get Internal Server Error while trying to get graphic console, while VM suspending</b><br>
 - [BZ 1608265](https://bugzilla.redhat.com/1608265) <b>change GB labels to GiB</b><br>
 - [BZ 1607131](https://bugzilla.redhat.com/1607131) <b>UI exception is thrown when trying to create a VM from template with CD-ROM from ISO attached to the template</b><br>
 - [BZ 1602339](https://bugzilla.redhat.com/1602339) <b>VM with preallocated/RO disks only can run even if the storage domain that holds the disks is in maintenance</b><br>
 - [BZ 1600534](https://bugzilla.redhat.com/1600534) <b>Status code from the API for incompatible disk configuration for disk creation is 400 (bad request) instead of 409 (conflict)</b><br>

#### VDSM

 - [BZ 1600140](https://bugzilla.redhat.com/1600140) <b>[VDSM] Cannot modify vNic profile of  running vm with MTU set in its XML</b><br>
 - [BZ 1595636](https://bugzilla.redhat.com/1595636) <b>vdsm-hook-vfio-mdev failed to run VM with Intel GVT-g device.</b><br>
 - [BZ 1612904](https://bugzilla.redhat.com/1612904) <b>[downstream clone - 4.2.6] getFileStats fails on NFS domain in case or recursive symbolic link (e.g., using NetApp snapshots)</b><br>
 - [BZ 1614657](https://bugzilla.redhat.com/1614657) <b>[downstream clone - 4.2.6] Kdump Status is disabled after successful fencing of host.</b><br>
 - [BZ 1613838](https://bugzilla.redhat.com/1613838) <b>"TemporaryFailure: Cannot inquire Lease" during storage pool removal</b><br>
 - [BZ 1612958](https://bugzilla.redhat.com/1612958) <b>Ctor parameters not passed correctly to API.ISCSIConnection.__init__</b><br>
 - [BZ 1562369](https://bugzilla.redhat.com/1562369) <b>Hosts show sanlock renewal errors in /var/log/messages</b><br>

#### cockpit-ovirt

 - [BZ 1614426](https://bugzilla.redhat.com/1614426) <b>Gluster deployment wizard throws Null Pointer Exception after finished deployment</b><br>
 - [BZ 1540936](https://bugzilla.redhat.com/1540936) <b>cockpit accepts (and propose by default) localhost as the host address and this fails for sure since the engine VM will try to deploy itself as the host</b><br>
 - [BZ 1600883](https://bugzilla.redhat.com/1600883) <b>Remove Packages tab from gluster deployment  in cockpit ovirt</b><br>
 - [BZ 1597255](https://bugzilla.redhat.com/1597255) <b>The mount point of the additional volume created during gluster deployment is not correct .</b><br>
 - [BZ 1608660](https://bugzilla.redhat.com/1608660) <b>Support single node deployment from cockpit</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1552098](https://bugzilla.redhat.com/1552098) <b>Rephrase: "command GetStatsAsyncVDS failed: Heartbeat exceeded" error message</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1580268](https://bugzilla.redhat.com/1580268) <b>Add example how to clearing virtual numa nodes of VM via API</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1615122](https://bugzilla.redhat.com/1615122) <b>[v2v] fast-zero - support sparse uploads on file storage</b><br>
 - [BZ 1619019](https://bugzilla.redhat.com/1619019) <b>[v2v] Broken pipe (Errno 32) occurs during multiple VMs conversion</b><br>
 - [BZ 1615144](https://bugzilla.redhat.com/1615144) <b>[v2v] fast-zero - to improve performance</b><br>
 - [BZ 1614195](https://bugzilla.redhat.com/1614195) <b>[v2v] Keep more logs with ovirt-imageio-daemon</b><br>
 - [BZ 1614202](https://bugzilla.redhat.com/1614202) <b>[v2v] Reduce logging details per upload</b><br>
 - [BZ 1592847](https://bugzilla.redhat.com/1592847) <b>[v2v] ovirt-Imageio-daemon Memory growth unreasonable during disk transfer</b><br>

#### oVirt Ansible virtual machine infrastructure role

 - [BZ 1601445](https://bugzilla.redhat.com/1601445) <b>Role fails when vms list is empty</b><br>

#### imgbased

 - [BZ 1598781](https://bugzilla.redhat.com/1598781) <b>Upgrading RHV-H is bringing back libvirt network file which causes issues in starting of VM</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1608961](https://bugzilla.redhat.com/1608961) <b>tear down ovirt-provider-ovn when an host is removed from ovirt-engine</b><br>
 - [BZ 1566112](https://bugzilla.redhat.com/1566112) <b>Exception when trying to run multiple VMs (VMs failed to run)</b><br>
