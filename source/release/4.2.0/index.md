---
title: oVirt 4.2.0 Release Notes
category: documentation
toc: true
authors: sandrobonazzola,JohnMarksRH
page_classes: releases
---

# oVirt 4.2.0 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.0
Release as of December 19, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

## What's New in 4.2.0?

- The [Administration Portal](/blog/2017/09/introducing-ovirt-4.2.0/) has been redesigned using [Patternfly](http://www.patternfly.org). The new user interface is more intuitive and user-friendly, and features improved performance.

- A new **VM Portal** for non-admin users. Built with performance and ease of use in mind, the new VM portal delivers a more streamlined experience.

- A [High Performance VM type](/blog/2017/10/introducing-high-performance-vms/) has been added to the existing "Server" and "Desktop" types. The new type enables administrators to easily optimize a VM for high performance workloads.

- The **oVirt Metrics Store** is a real-time monitoring solution providing complete infrastructure visibility, for data-based decision making and faster issue resolution.

- oVirt now supports VM connectivity via **software defined networks** - implemented by **Open Virtual Network (OVN)**. OVN is automatically deployed to hypervisors, and made available for VM connectivity. Networks can be defined in the UI, over REST, or within the ManageIQ [Gaprindashvili](http://manageiq.org/blog/2017/12/Announcing-Gaprindashvili-RC/) release (now in RC).

- Support for [Nvidia vGPU](http://www.nvidia.com/object/grid-technology.html), a technology that enables users to shard a GRID-capable physical GPU into several smaller instances, for GPU-accelerated workloads.

- The [ovirt-ansible-roles](/blog/2017/07/ovirt-ansible-roles-an-introduction/) package helps users with [common administration tasks](/blog/2017/08/ovirt-ansible-roles-how-to-use/). All roles can be executed from the command line using Ansible, and some are executed directly from oVirt engine.

- oVirt will now use [PostgresSQL 9.5](https://www.postgresql.org/docs/9.5/static/release-9-5.html) as its database, for improved performance.

- Support for [LLDP](/blog/2017/11/webadmin-lldp/), enabling oVirt hosts to gather information from their networking interfaces, for improved network configuration. The information can be displayed both in the UI and via an API.

- **Snapshots** can be uploaded and downloaded via the REST API (and the SDKs).

- A new **self-hosted engine wizard UI**. Among other improvements it now enables users to review and edit their inputs before beginning the deployment process.

- **Hosted Engine Ansible-based deployment** (in Beta),using “ovirt-hosted-engine-setup  --ansible”, is a new method to deploy a hosted engine. It reduces deployment issues, and will enable users to benefit from future features such as single storage for the hosted engine and other VMs, live storage migration, and improved hosted engine VM editing capabilities. We expect it to become the default provisioning flow for Hosted Engine and would be glad to get feedback on its functionality!

- The **ipa-client package** is now installed on hosts and included in the oVirt Node. This identity management feature provides users with a seamless experience while moving between [Cockpit](http://cockpit-project.org/) and other products.

- **Virt-v2v** now supports Debian/Ubuntu based VMs, in addition to EL and Windows-based VMs.

- Restored support for **Gluster ISO domains**.

- Improved **Affinity Label management tools** were incorporated into the cluster, host, and VM’s edit dialogs.

- oVirt now features **Gluster 3.12.**

- oVirt's hyperconverged solution now enables a single **replica Gluster deployment.**

- Improved **self-hosted-engine iSCSI deployment**.

- A new **driver for Win10**, for seamless remote access to VMs, and improved performance.

- Administrators can now use the Administration Portal to **remove a LUN** from the storage domain.

- Instead of polling libvirt every 2 seconds to get the used disk for each thin disk, VDSM now uses **events**, for a noticeable increase in efficiency on a host with tens or hundreds of VMs.

- In addition, oVirt 4.2.0 features **host scalability** improvements, for high density setups.

To learn about features introduced before 4.2.0, see the [release notes for previous versions](/documentation/#previous-release-notes).

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


### Release Note

#### VDSM

 - [BZ 1438822](https://bugzilla.redhat.com/1438822) <b>The discard_enable flag should not be used anymore in oVirt 4.2</b><br>With this update, support for configuring "Discard After Delete" per host has been dropped. This also drops the value "discard_enable" from the VDSM configuration file. The "Discard After Delete" feature now needs to be configured per block storage domain. For more information see - http://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/

#### oVirt Web UI

 - [BZ 1507406](https://bugzilla.redhat.com/1507406) <b>Rebase ovirt-web-ui to 1.3.z</b><br>With this update, the Virtual Machine Portal has been updated to version 1.3.1 and adds the following functionality:<br>- Use of "AlwaysFilterResultsForWebUi" engine configuration parameter<br>- BnB (Brand new Branding) - aligned with ovirt-engine<br>- Smartcard Enabled option<br>- SSH public key<br>- Guest Operating System names as labels<br>- i18n improvements, first translations<br>- multiple fixes and minor UI enhancements

#### oVirt Engine

 - [BZ 1490784](https://bugzilla.redhat.com/1490784) <b>blacklist RHEL <6.9 from machine types pseries-rhel7.4.0+</b><br>With this update, Red Hat Enterprise Linux versions less than version 6.9 are not supported in clusters using the machine type pseries-rhel7.4.0 or newer (4.1+). It is now blacklisted and cannot be started due to there being no CPU architecture available. A new definition of guest operating system for Red Hat Enterprise Linux versions 6.9 and greater has been added and should be used for Red Hat Enterprise Linux 6 guests in Red Hat Virtualization 4.1 and greater clusters. Also note that the cluster compatibility version 4.2 requires the pseries-rhel7.5.0 machine type, which is introduced by Red Hat Enterprise Linux 7.5 hosts. Until they are available you need to keep using the 4.1 cluster compatibility level.
 - [BZ 1425935](https://bugzilla.redhat.com/1425935) <b>[RFE] Add SSO client command line registration tool</b><br>This update includes the new ovirt-register-sso-client-tool command-line tool to register SSO clients.<br><br>When running the tool, the user is prompted to enter the client ID, callback prefix, and the certificate location. A new entry is created in the sso_clients table if one does not exist, or the existing one with the same client ID is updated. The client_secret which is written to a temporary file should be noted and used by the client. <br><br>The client secret in the sso_clients table is encrypted and is for SSO internal use only.
 - [BZ 1463083](https://bugzilla.redhat.com/1463083) <b>RESTAPI - Attaching a storage domain to 4.0 DC fails due to discard after delete is now True by default but not supported</b><br>Previously, when adding a new data storage domain without stating the values of Discard After Delete (DAD) and storage format, their default values were previously calculated according to the data center version of the host that added the storage domain. Discard After Delete was set to true for a data center greater than or equal to Red Hat Virtualization 4.1, otherwise it was set to false. The storage format was set V4 for the a data center greater than or equal to Red Hat Virtualization 4.1, otherwise it was set to V3. This was a bad heuristic since the data center of the host that added the domain is a random data center and it is not necessarily the data center that the domain will be later attached to. Now, the logic has been changed so that the default storage format for new data domains will be the latest format, currently it is V4. For non-data domains, nothing has changed V1 was and will remain the default value. The default value of Discard After Delete will be calculated according to the storage format and is set to true for storage formats greater than or equal to V4, otherwise it is set to false.
 - [BZ 1420310](https://bugzilla.redhat.com/1420310) <b>User actions should succeed regardless of 'filter' parameter</b><br>With this update, an issue with the the way that the API supports the 'filter' parameter to indicate if results should be filtered according to the permissions of the user has been corrected. Previously, due to the way this was implemented, non-admin users needed to set this parameter for almost all operations, as the default value was 'false'. Now, to simplify the task for non-admin users, this patch changes the default value to 'true', but only for non-admin users. If the value is explicitly given in a request it will be honored.This is a backwards compatibility breaking change, as clients that used non-admin users and did *not* explicitly provide the 'filter' parameter will start to behave differently. However, this is unlikely, as calls from non-admin users without the 'filter=true' are almost useless. For those unlikely cases where this may be a problem, the patch also introduces a new 'ENGINE_API_FILTER_BY_DEFAULT' configuration parameter:<br>    <br>  #<br>  # This flags indicates if 'filtering' should be enabled by default for<br>  # users that aren't administrators.<br>  #<br>  ENGINE_API_FILTER_BY_DEFAULT="true"<br>    <br>If it is necessary to revert to the behavior of previous versions of the engine, it can be achieved by changing this parameter in a configuration file inside the '/etc/ovirt-engine/engine.conf.d' directory. For<br>example:<br>    <br>  # echo 'ENGINE_API_FILTER_BY_DEFAULT="false"' > \<br>  /etc/ovirt-engine/engine.conf.d/99-filter-by-default.conf<br>    <br>  # systemctl restart ovirt-engine

### Enhancements

#### oVirt Host Dependencies

 - [BZ 1490041](https://bugzilla.redhat.com/1490041) <b>[RFE] Provide IdM client software in RHVH</b><br>ipa-client package is now installed on hosts and is included in oVirt Node / RHV-H<br>This allows to integrate cockpit certificate signing and SSO with Red Hat IdM and adding the host to IdM realm.

#### OTOPI

 - [BZ 1411100](https://bugzilla.redhat.com/1411100) <b>[RFE] Change timestamp format to include timezone for logs</b><br>From now on, all timestamp records for otopi-based tools logs (including engine-setup, host-deploy, and hosted-engine --deploy) will contain a time zone to ease correlation between logs on the Manager and hosts. They will also now include the fraction of a second. Previously they contained a timestamp without a time zone and fraction of a second, for example:<br><br>2017-04-03 09:56:58 DEBUG otopi.context context.dumpEnvironment:760 ENVIRONMENT DUMP - BEGIN<br><br>From now on there will always be a comma and fraction of a second after the seconds part, and a timezone identifier at the end of the timestamp part, for example:<br><br>2017-04-05 10:41:08,500+0300 DEBUG otopi.context context.dumpEnvironment:760 ENVIRONMENT DUMP - BEGIN
 - [BZ 1518689](https://bugzilla.redhat.com/1518689) <b>[RFE] otopi should log on failure list of network connections</b><br>otopi now optionally logs the list of network connections on the machine after failures. Enable this by installing the optional package otopi-debug-plugins. This can help debug failures to start network services due to "Address already in use" errors.

#### oVirt Engine SDK 4 Ruby

 - [BZ 1317450](https://bugzilla.redhat.com/1317450) <b>[RFE] Have a policy for autoresume of VMs paused due to IO errors (stay paused, turn off, restart with defined time out time)</b><br>Feature: <br>Previously, if the VM has been paused due to IO Error, there was no way how to configure what should happen after the storage gets fixed. The only option was "auto resume", which resumed the VM. This feature adds two more options configurable per VM: "Kill" and "Leave Paused".<br><br>Reason: <br>There are ways how the "auto resume" together with HA VM using VM lease could lead to split brain. Other reason is that it can interfere with custom HA solutions.<br><br>Result: <br>Now the user can configure 3 resume policies for VMs:<br>- auto resume (the one which used to be the only one)<br>- leave paused<br>- kill

#### VDSM

 - [BZ 1317450](https://bugzilla.redhat.com/1317450) <b>[RFE] Have a policy for autoresume of VMs paused due to IO errors (stay paused, turn off, restart with defined time out time)</b><br>Feature: <br>Previously, if the VM has been paused due to IO Error, there was no way how to configure what should happen after the storage gets fixed. The only option was "auto resume", which resumed the VM. This feature adds two more options configurable per VM: "Kill" and "Leave Paused".<br><br>Reason: <br>There are ways how the "auto resume" together with HA VM using VM lease could lead to split brain. Other reason is that it can interfere with custom HA solutions.<br><br>Result: <br>Now the user can configure 3 resume policies for VMs:<br>- auto resume (the one which used to be the only one)<br>- leave paused<br>- kill
 - [BZ 1181665](https://bugzilla.redhat.com/1181665) <b>[RFE][scale] Use events and not polling to detect disk usage [using the improvement from platform bug 1181659]</b><br>Feature: <br>Vdsm can make use of the event added in libvirt 3.2.0 to learn about the allocation of block chunked drives and improve the efficiency of the thin provisioning implementation.<br><br>Reason: <br>To implement the thin provisioning of block chunked drives, Vdsm needs to periodically monitor the allocation of the backing volumes. This could be done either polling libvirt or registering events. The second option is available since libvirt 3.2.0 and it is way more efficient than the first.<br><br><br>Result: <br>When using events, Vdsm consumes much less system resources.
 - [BZ 1376843](https://bugzilla.redhat.com/1376843) <b>[RFE] Implement a keep-alive with reconnect if needed logic for the python jsonrpc client</b><br>jsonrpc python client is now able to reconnect in case jsonrpc server has restarted.
 - [BZ 1205739](https://bugzilla.redhat.com/1205739) <b>[RFE][DR] - Allow recovering an imported domain without an UP DC</b><br>Cause: <br>Can not attach storage domain with "dirty" SP_UUID.<br>This process fails since the host is not yet connected<br>to a storage pool and therefore there is no host id which we can use to take a lock on the storage domain.<br><br>Consequence: <br>When attempting to attach an imported storage domain to a Data Center. <br><br>Fix: <br>Enable the possibility to force detach a storage domain<br>even if the host is not yet connected to the storage pool.<br><br>Result:<br>Enable the option for force detach a storage<br>domain and clean its SP_UUID before we will want to connect it to the storage pool.
 - [BZ 1391859](https://bugzilla.redhat.com/1391859) <b>[RFE] When creating thick allocated disks on file-based storage, use '-o preallocation=falloc' instead of 'dd' with zeros.</b><br>New feature greatly reduces the time required to create thick allocated disks on file-based storage.
 - [BZ 1228543](https://bugzilla.redhat.com/1228543) <b>[RFE] hot-unplug memory</b><br>Previously, it was only possible to add memory to a running virtual machine (VM). To remove memory, the VM had to be shut down.<br>In this release, it is now possible to hot unplug memory from a running VM, provided that certain requirements are met and limitations are considered.
 - [BZ 1168327](https://bugzilla.redhat.com/1168327) <b>Live Merge: optimize internal volume size</b><br>After live merge, the base volume is reduced to its optimal size.
 - [BZ 1430799](https://bugzilla.redhat.com/1430799) <b>Create script to restore original network configuration of removed vdsm host</b><br>Feature:<br>Provide tools for simple removal of networks configured by oVirt on a host.<br><br>Reason: <br>One could add a host into Engine and one minute later decide to remove it. But the host would have ovirtmgmt bridge and various VDSM network hacks which are not clear how to remove.<br><br>Result:<br>vdsm-tool now provides commands for VDSM network cleanup, particularly `vdsm-tool clear-nets` and `vdsm-tool dummybr-remove`. One could remove networks configured by VDSM following the steps below. Note that vdsm service is not required to be running:<br><br>1. To prevent loss of connectivity it might be needed to exclude default route network from cleanup. Look for a network providing default route (ovirtmgmt by default):<br># vdsm-tool list-nets<br>...<br>ovirtmgmt (default route)<br>...<br><br>2. Remove all networks configured by VDSM except for the default network.<br># vdsm-tool clear-nets --exclude-net ovirtmgmt<br><br>3. Remove libvirt dummy bridge ;vdsmdummy;<br># vdsm-tool dummybr-remove<br><br>4. Host should be clean, you can remove vdsm now.
 - [BZ 1367806](https://bugzilla.redhat.com/1367806) <b>[RFE] - Add "blkdiscard" as a new method to zero volumes</b><br>A new VDSM parameter enables a host to remove a disk/snapshot on block storage, where "Wipe After Delete" is enabled, in much less time than the "dd" command, especially if the storage supports "Write same."
 - [BZ 1335642](https://bugzilla.redhat.com/1335642) <b>[RFE] Users should be able to seal VMs from RHEV-M</b><br>The feature is documented here: http://www.ovirt.org/develop/release-management/features/virt-sysprep/

#### oVirt Cockpit Plugin

 - [BZ 1493851](https://bugzilla.redhat.com/1493851) <b>[RFE] Suggest to give a hint when HE with one host don't permit to put itself into local maintenance.</b><br>Feature: The Hosted Engine management page in cockpit-ovirt now presents a warning message if only one host is available in the hosted engine cluster, preventing it from being moved to local maintenance. <br><br>Reason: Hosted Engine does not allow moving the last (or only) host running hosted engine to local maintenance, only global.<br><br>Result: cockpit-ovirt now reflects the options supported by hosted engine.

#### imgbased

 - [BZ 1503148](https://bugzilla.redhat.com/1503148) <b>[RFE] translate between basic ntp configurations and chrony configurations</b><br>
 - [BZ 1420068](https://bugzilla.redhat.com/1420068) <b>[RFE] RHV-H should meet NIST 800-53 partitioning requirements by default</b><br>In this release, Red Hat Virtualization Host supports NIST SP 800-53 partitioning requirements to improve the security. Environments upgrading to Red Hat Virtualization 4.2 will also be configured to match NIST SP 800-53 partitioning requirements.

#### oVirt Engine SDK 4 Python

 - [BZ 1405805](https://bugzilla.redhat.com/1405805) <b>[RFE] - Streaming API should support upload of disk snapshots</b><br>Support uploading of disk snapshots using ovirt-imageio. Full details in feature page: https://ovirt.org/develop/release-management/features/storage/backup-restore-disk-snapshots/
 - [BZ 1483305](https://bugzilla.redhat.com/1483305) <b>[RFE] - Streaming API should support download of disk snapshots</b><br>The REST API supports the download of disk snapshots.

#### oVirt Engine

 - [BZ 1317450](https://bugzilla.redhat.com/1317450) <b>[RFE] Have a policy for autoresume of VMs paused due to IO errors (stay paused, turn off, restart with defined time out time)</b><br>Feature: <br>Previously, if the VM has been paused due to IO Error, there was no way how to configure what should happen after the storage gets fixed. The only option was "auto resume", which resumed the VM. This feature adds two more options configurable per VM: "Kill" and "Leave Paused".<br><br>Reason: <br>There are ways how the "auto resume" together with HA VM using VM lease could lead to split brain. Other reason is that it can interfere with custom HA solutions.<br><br>Result: <br>Now the user can configure 3 resume policies for VMs:<br>- auto resume (the one which used to be the only one)<br>- leave paused<br>- kill
 - [BZ 1459134](https://bugzilla.redhat.com/1459134) <b>[RFE] Rebase engine-setup on PostgreSQL >= 9.5</b><br>With this release, the engine now requires PostgreSQL 9.5 or later, which provides new features and better performance. The engine-setup tool can help upgrade an existing database to Software Collections PostgreSQL 9.5, as well as use that version for new setups.
 - [BZ 1507277](https://bugzilla.redhat.com/1507277) <b>[RFE][DR] - Vnic Profiles mapping in VMs register from data storage domain should be supported also for templates</b><br>Feature: Allow selecting vnic profiles for templates when registering them to the engine from a storage domain.<br><br>Reason: This was possible for vm's but not for templates until now<br><br>Result: the user may configure the vnic profiles of a template upon register
 - [BZ 1319758](https://bugzilla.redhat.com/1319758) <b>[RFE] Allow uploading a pre-existing VM image (OVA) into the environment</b><br>Feature: <br>Enable uploading an OVA into an oVirt data center.<br><br>Reason: <br>Simplify the process of importing a virtual machine that was created out of the data center.<br><br>Result: <br>It is now possible to import an OVA that is accessible to at least of the hosts in the data center into a virtual machine in oVirt.
 - [BZ 1506697](https://bugzilla.redhat.com/1506697) <b>Don't freeze the VM when taking a live snapshot in LSM</b><br>Feature: <br>VM file system will not be frozen in case the snapshot is taken is the auto-generated snapshot that is created during live storage migration<br><br>Reason: <br>Speed up the process of live storage migration
 - [BZ 1514942](https://bugzilla.redhat.com/1514942) <b>Add option to specify the host when uploading an image via the API</b><br>Added the ability to specify a host in the ImageTransfer entity. This is useful if the user prefers to use a specific host for uploading.<br><br>An example for the python sdk:<br>transfer = transfers_service.add(<br>    types.ImageTransfer(<br>        image=types.Image(<br>            id=disk.id<br>        ),<br>        direction=types.ImageTransferDirection.DOWNLOAD,<br>        host=system_service.hosts_service().list(search='name=myhost')[0]<br>    )<br>)
 - [BZ 1480433](https://bugzilla.redhat.com/1480433) <b>[RFE] Indicate host needs to be reinstalled to push new configurations.</b><br>There are several cluster or host settings which will require host reinstallation if the settings are changed.<br><br>A host must be reinstalled if you any of its following settings are changed:<br>- Turn off/on Kdump integration.<br>- Change command line parameters.<br><br>All hosts in a cluster must be reinstalled if you change the firewall type of the cluster.<br><br>In addition to the existing documentation and Warning event, an exclamation mark icon will now be added to each host that needs to reinstalled. When exclamation mark icon is shown, you can find the details about it in Host detail view within Action Items section.
 - [BZ 1454287](https://bugzilla.redhat.com/1454287) <b>[RFE] Add UI support to remove a LUNs from a data domain</b><br>
 - [BZ 1496382](https://bugzilla.redhat.com/1496382) <b>[RFE][REST API] Support memory hot unplug via REST</b><br>please see <br>* https://www.ovirt.org/develop/release-management/features/virt/hot-unplug-memory/<br>* http://ovirt.github.io/ovirt-engine-api-model/master/#types/vm/attributes/memory<br>* http://ovirt.github.io/ovirt-engine-api-model/master/#types/memory_policy/attributes/guaranteed
 - [BZ 1405805](https://bugzilla.redhat.com/1405805) <b>[RFE] - Streaming API should support upload of disk snapshots</b><br>Support uploading of disk snapshots using ovirt-imageio. Full details in feature page: https://ovirt.org/develop/release-management/features/storage/backup-restore-disk-snapshots/
 - [BZ 1416141](https://bugzilla.redhat.com/1416141) <b>[RFE] Use JDK and EE builtins for scheduled tasks and threads</b><br>Use JBoss ManagedThreadFactory, ManagedExecutorService and ManagedScheduledExecutorService instead of Java EE ExecutorService and Quartz to schedule jobs.<br><br>There are two ManagedExecutorServices in engine commandCoordinator and hostUpdatesChecker. <br><br>The size of the commandCoordinator executor service is defined by config variable COMMAND_COORDINATOR_THREAD_POOL_SIZE. The default size if 10. To change the size create a new conf file 99-coco-thread-pool.conf in /etc/ovirt-engine/engine.conf.d/<br><br>The size of the hostUpdatesChecker executor service is defined by config variable HOST_CHECK_FOR_UPDATES_THREAD_POOL_SIZE. The default size if 5. To change the size create a new conf file 99-host-thread-pool.conf in /etc/ovirt-engine/engine.conf.d/<br> <br>Management clients, such as the WildFly CLI, can also be used to configure ManagedExecutorService instances commandCoordinator and hostUpdatesChecker with out having to restart engine. <br><br>The 'engine' executor service size is define by config variables ENGINE_THREAD_POOL_MIN_SIZE and ENGINE_THREAD_POOL_MAX_SIZE. The default value for ENGINE_THREAD_POOL_MIN_SIZE is 50 and default value for ENGINE_THREAD_POOL_MAX_SIZE is 500. To change the value permanentaly create a conf file 99-engine-thread-pool.conf in /etc/ovirt-engine/engine.conf.d/.<br><br>jconsole can be used to change the size of the 'engine' executor service with out having to restart engine.<br><br>'engineScheduled' ManagedScheduledExecutorService size is define by config variable ENGINE_SCHEDULED_THREAD_POOL_SIZE. The default value is 100. To change the value<br>permanentaly create a conf file 99-engine-scheduled-thread-pool.conf in /etc/ovirt-engine/engine.conf.d/<br><br>Management clients, such as the WildFly CLI, can also be used to configure ManagedScheduledExecutorService instance 'engineScheduled' with out having to restart engine. <br><br>Engine creates a log entry of the thread pool usage as define by the config variable THREAD_POOL_MONITORING_INTERVAL_IN_SECONDS. The default value is 600 seconds. So every 10 minutes a log entry is created for each pool showing the thread pool usage.<br><br>Thread pool 'engine' is using 7 threads out of 500, 1 threads waiting for tasks and 0 tasks in queue.<br>Thread pool 'engineScheduled' is using 0 threads out of 100 and 100 tasks are waiting in the queue.<br>Thread pool 'engineThreadMonitoring' is using 1 threads out of 1 and 0 tasks are waiting in the queue.
 - [BZ 1492067](https://bugzilla.redhat.com/1492067) <b>[RFE] add mdev_type to host devices tab</b><br>Feature: <br>Add the "mdev_type" column to host devices list.<br><br>Reason: <br>If a user wanted to pass through an mdev to a VM, he needed to find the mdev_type of the device by SSH-ing to the hypervisor and run a VDSM command to get this information.<br><br>Now, this information is exposed in the UI.<br><br>Result: <br>Now the user can find the mdev_type in the same UI which is used to set it to the VM.
 - [BZ 1490866](https://bugzilla.redhat.com/1490866) <b>[RFE] Deprecate iptables firewall type for hosts</b><br>Using an iptables firewall on virtualization hosts is deprecated in Red Hat Virtualization 4.2 and will be completely removed in Red Hat Virtualization 4.3. Administrators should switch to a firewalld firewall which is introduced in Red Hat Virtualization 4.2.<br><br>To make the switch to firewalld more visible, Red Hat Virtualization Manager will go all over existing clusters every 30 days and raise warning events to the audit log. Another warning message has been added to engine-config help for all iptables related settings.
 - [BZ 1457239](https://bugzilla.redhat.com/1457239) <b>[RFE] Provide "High Performance VM" Profile to ovirt</b><br>Previously, it was difficult to configure a virtual machine (VM) to run with high performance workloads via the Administration Portal as it involved understanding and configuring a large number of settings. In addition, several features that were essential for improving the VM's performance were not supported at all, for example, huge pages and IO thread pinning.<br><br>In this release, a new optimization type called High Performance is available when configuring VMs. It is capable of running a VM with the highest possible performance, with performance metrics as close to bare metal as possible. When the customer selects High Performance optimization, some of the the VMs settings are automatically configured while other settings are suggested for manual configuration.
 - [BZ 1185782](https://bugzilla.redhat.com/1185782) <b>REST-API is missing image total size attribute</b><br>
 - [BZ 1205739](https://bugzilla.redhat.com/1205739) <b>[RFE][DR] - Allow recovering an imported domain without an UP DC</b><br>Cause: <br>Can not attach storage domain with "dirty" SP_UUID.<br>This process fails since the host is not yet connected<br>to a storage pool and therefore there is no host id which we can use to take a lock on the storage domain.<br><br>Consequence: <br>When attempting to attach an imported storage domain to a Data Center. <br><br>Fix: <br>Enable the possibility to force detach a storage domain<br>even if the host is not yet connected to the storage pool.<br><br>Result:<br>Enable the option for force detach a storage<br>domain and clean its SP_UUID before we will want to connect it to the storage pool.
 - [BZ 1459908](https://bugzilla.redhat.com/1459908) <b>Rest API does not report network statistics host "data.current.tx, data.current.rx"</b><br>Feature: <br><br>The precision of the rx_rate, tx_rate, rx_drop and tx_drop of virtual and host network interfaces is increased.<br><br>Reason: <br><br>If traffic on the network interface is below the precision of the network interface statistics, it is not reflected in the statistics.<br><br>Result: <br><br>This enables to detect 100 times smaller traffic on network interface statistics.
 - [BZ 1483305](https://bugzilla.redhat.com/1483305) <b>[RFE] - Streaming API should support download of disk snapshots</b><br>The REST API supports the download of disk snapshots.
 - [BZ 1096497](https://bugzilla.redhat.com/1096497) <b>[restapi] Display image size and type for glance images missing in RESTAPI</b><br>Feature: <br>before that feature, Glance images returned by RESTAPI didn't list their size and type (iso/disk).<br><br>Reason: <br>That information should be listed regarding to Glance images.<br><br>Result:<br>Glance images do list their type and size on REST API.
 - [BZ 1372163](https://bugzilla.redhat.com/1372163) <b>[RFE] Warn user about VMs that have pending snapshot removal retries</b><br>When live or cold merge fails, snapshot disks may be left in an illegal state. If VMs with illegal snapshot disks are shut down, they will not re-start. VMs with illegal snapshot disks are now marked with an exclamation mark and a warning message not to shut them down.
 - [BZ 1475459](https://bugzilla.redhat.com/1475459) <b>[RFE] Use Wildfly 11 for oVirt engine 4.2</b><br>
 - [BZ 1463633](https://bugzilla.redhat.com/1463633) <b>[RFE] Provide support for data aggregation when fetching entities</b><br>This update enables Red Hat Virtualization API users to request that contents of some of the entity's links be returned inline, inside the requested entity.<br><br>Previously, to retrieve multiple related objects from the API, the only alternative was to retrieve the first one, then send additional requests to retrieve the related objects. For example, if you needed a virtual machine and also the disks and NICs, you would need to first send a request like this:<br><br>  GET /ovirt-engine/api/vms/123<br><br>And then send additional requests to get the disk attachments, the disks, and the NICs:<br><br>  GET /ovirt-engine/api/vms/123/diskattachments GET /ovirt-engine/api/disks/456 GET /ovirt-engine/api/disks/789 GET /ovirt-engine/api/vms/123/nics<br><br>In environments with high latency, this increases the time required to retrieve the data. In addition, it also means that multiple queries have to be sent to the database to retrieve the data. To improve this, a new follow parameter has been introduced. This parameter is a list of links that the server should follow and populate. For example, the previous scenario will be solved sending this request:<br><br>GET /ovirt-engine/api/vms/123?follow=diskattachments.disks,nics<br><br>This will return the virtual machine with the disks and the NICs embedded in the same response, thus avoiding the multiple network round-trips. The multiple database queries will be avoided only if the server is modified to retrieve that data with the more efficient queries, otherwise the server will use the approach of calling itself to retrieve it, which won’t improve the number of queries.
 - [BZ 1416491](https://bugzilla.redhat.com/1416491) <b>[RFE] Add support for OpenID Connect in engine SSO</b><br>This update adds SSO support for OpenID Connect clients. The following new OpenID Connect discovery endpoint has been added so that clients can discover the authorization endpoints and OpenID Connect capabilities of the Manager:<br><br>https://<Manager>/ovirt-engine/sso/openid/.well-known/openid-configuration<br><br>The following endpoint is used for client authorization and for obtaining the authentication code:<br><br>https://<Manager>/ovirt-engine/sso/openid/authorize<br><br>The following endpoint is used by clients to obtain the authentication token from the authentication code:<br><br>https://<Manager>/ovirt-engine/sso/openid/token<br><br>The following endpoint can used by clients to get details of the logged in user:<br><br>https://<Manager>/ovirt-engine/sso/openid/userinfo<br><br>The following endpoint can used by clients to get the keys used by SSO to sign the id_token returned from token and tokeninfo endpoints:<br><br>https://<Manager>/ovirt-engine/sso/openid/jwks
 - [BZ 1456414](https://bugzilla.redhat.com/1456414) <b>New domain should default to true on Discard After Delete</b><br>Up until now, the default value of the Discard After Delete field (DAD) was false.<br>That means that the UI checkbox was unchecked by default and creating a block storage domain via the REST-API without stating the value of DAD would have set it to false.<br><br>From now and on, the default value of DAD is true.<br>That means that the UI checkbox is checked by default and creating a block storage domain via the REST-API without stating the value of DAD will set it to true.
 - [BZ 1228543](https://bugzilla.redhat.com/1228543) <b>[RFE] hot-unplug memory</b><br>Previously, it was only possible to add memory to a running virtual machine (VM). To remove memory, the VM had to be shut down.<br>In this release, it is now possible to hot unplug memory from a running VM, provided that certain requirements are met and limitations are considered.
 - [BZ 1177628](https://bugzilla.redhat.com/1177628) <b>[RFE] pgsql logs are missing timestamps</b><br>engine-setup on new installations now configures postgresql to have a year worth of logs, and to include timestamps in the log records.
 - [BZ 1321585](https://bugzilla.redhat.com/1321585) <b>[RFE] Add option to deactivate storage domain only if ovf store was updated</b><br>Feature: Add ability to perform force maintenance to storage domain.<br><br>Reason:<br>Before this fix, storage domain could enter to maintenance even if OVF disks update failed.<br> <br>Now, storage domain deactivation will fail in case of OVF update failure.<br>Force maintenance flag will supply the ability to deactivate the storage domain even in case of failure in OVF update.
 - [BZ 1285456](https://bugzilla.redhat.com/1285456) <b>[RFE] Persist column visibility and position in browser's local storage</b><br>Feature: Persistent column widths, visibility, and order.<br><br>Reason: The user wants to be able to persist the width, visibility, and order of the columns in the grids on the webadmin UI.<br><br>Result: The width, visibility, and order is now stored in the browsers local storage so that reloads of the webadmin will not reset to the default width, visibility, and order.
 - [BZ 1433676](https://bugzilla.redhat.com/1433676) <b>[RFE] Add a link to CA certificate on the main landing page</b><br>A link to ovirt-engine's CA certificate has been added to the welcome page.
 - [BZ 1497612](https://bugzilla.redhat.com/1497612) <b>New package: ovirt-cockpit-sso</b><br>Feature: Single Sign On to Host Console from Administration Portal<br><br>Reason: The administrator does not need to enter credentials when accessing host's Cockpit session from Administration Portal.<br><br>Result: <br><br>The ovirt-cockpit-sso package provides Single Sign On (SSO) for Host COnsole (Cockpit) from Administration Portal.<br><br>To enable it on engine machine:<br>- install ovirt-cockpit-sso rpm (yum install ovirt-cockpit-sso)<br>- systemctl enable cockpit.socket<br>- systemctl enable ovirt-cockpit-sso<br>- systemctl start ovirt-cockpit-sso<br><br>The service listens on 9986/tcp port.<br><br>To try:<br>- have ovirt-cockpit-sso service running<br>- log into Administration Portal<br>- select Host<br>- click "Host Console" button<br>- optionally enable pop-up windows in you browser<br>- optionally confirm host's fingerprint, if prompted<br>- new browser tab will appear with root Cockpit session<br><br>Please note, there should be either cockpit-machines or preferably cockpit-ovirt package installed on the selected RHV-H for best experience.
 - [BZ 1399609](https://bugzilla.redhat.com/1399609) <b>[RFE] optimization in choice of target host for migration</b><br>Feature: <br><br>The host selection dropdown in Migrate dialog now shows only hosts that can actually be used as destination for the selected VMs.<br><br>Reason: <br><br>Nicer user experience, the user does not have to think about affinity, hosted engine and other limitations. The logic pre-filters the list for him.
 - [BZ 1420404](https://bugzilla.redhat.com/1420404) <b>[RFE] add ability to warm restart a VM so that VM starts on the same host when it is run by Run Once and rebooted</b><br>Feature: <br>Make a warm restart of VMs started as run once from webadmin possible<br><br>Reason: <br>Previously, when the VM was started as run once, the restart from webadmin/rest api always caused the VM to be cold restarted. This feature renames the "Trap guest reboots" option in run once to "Rollback this configuration during reboots" and broadens its meaning. Now it allows one to configure if the VM should be warm or cold restarted during reboots both from webadmin/api and from inside of the guest.<br><br>Result: <br>The user can now decide if the VM should be warm or cold rebooted .
 - [BZ 1168327](https://bugzilla.redhat.com/1168327) <b>Live Merge: optimize internal volume size</b><br>After live merge, the base volume is reduced to its optimal size.
 - [BZ 1428498](https://bugzilla.redhat.com/1428498) <b>[RFE] Allow to search VMs by specific host they are pinned to.</b><br>Feature: <br>List all VMs pinned to a specific host, event if the VMs are offline.<br><br>Reason: <br>When a host with pinned VMs is moved to the maintenance mode, the VMs are shut down. There was no simple way for the user to know which VMs have to be started again, when the host is no longer in the maintenance mode.<br><br>Result: <br>The pinned VMs are listed in the Virtual Machines details tab of the Host entity.<br>There are buttons on top of the table, allowing the user to show only running VMs, pinned VMs or both.
 - [BZ 1497619](https://bugzilla.redhat.com/1497619) <b>[RFE] present per-interface LLDP data in SetupHostNetwork dialog</b><br>
 - [BZ 1442687](https://bugzilla.redhat.com/1442687) <b>Hide expected network exceptions during host installation</b><br>
 - [BZ 1462811](https://bugzilla.redhat.com/1462811) <b>[RFE] Execute Ansible role ovirt-host-deploy as a part of host installation/reinstallation to allow customization of this flow</b><br>The Ansible role ovirt-host-deploy[1] is now executed as part of the host installation/reinstallation flow. This role is included in ovirt-ansible-roles package and is installed on the Red Hat Virtualization Manager by default.<br><br>[1] /usr/share/doc/ansible/rols/ovirt-host-deploy/README.md
 - [BZ 1441501](https://bugzilla.redhat.com/1441501) <b>[RFE] Exposing configuration options within RESTAPI</b><br>Previously the Manager configuration options with user or admin access levels were only available to GWT clients. To obtain option values for non-GWT clients they are now exposed in the following REST API:<br><br>  GET https://<ENGINE_FQDN>:/ovirt-engine/api/options/<OPTION_NAME><br>  <br>Where <OPTION_NAME> is an existing configuration option name. The output of that call is a list of values. To obtain a value for only a specific client version, you need to specify the requested version as follows:<br><br>  GET https://<ENGINE_FQDN>:/ovirt-engine/api/options/<OPTION_NAME>?version=<VERSION><br>  <br>The Manager configuration options are not backward compatible and may differ for each Manager version, and therefore existing options may not be available. Options are exposed as read-only in the REST APIs, but some of them can be updated by using the engine-config command-line tool.
 - [BZ 1231859](https://bugzilla.redhat.com/1231859) <b>[RFE] notify user that KSM will not be enable till next time hypervisor enters maintenance mode</b><br>
 - [BZ 1366905](https://bugzilla.redhat.com/1366905) <b>[RFE] Allow multiple IP's / text fields for network filters, specifically clean-traffic</b><br>The engine already supports filtering the network communication of VMs. Now it is possible to configure the filter parameters using the REST-API. <br><br>See http://www.ovirt.org/develop/release-management/features/network/networkfilterparameters/#current-implementation-status for details.
 - [BZ 1207992](https://bugzilla.redhat.com/1207992) <b>[RFE] Report IO errors to guests if the device is a CDROM</b><br>Virtual machines now stay operational when connectivity with CD-ROM images breaks. The error is reported to the guest operating system. Note that the configuration of the storage device may affect the time it takes to detect the error. In that period of time, the virtual machine is non-operational.
 - [BZ 1241410](https://bugzilla.redhat.com/1241410) <b>[RFE]- Add 'passthrough' column to the vNIC Profiles sub tab under Networks main tab</b><br>
 - [BZ 1169099](https://bugzilla.redhat.com/1169099) <b>[RFE] secrets should be marked so near their definition</b><br>
 - [BZ 1434306](https://bugzilla.redhat.com/1434306) <b>Can not remove Cinder provider even if the service is not available anymore.</b><br>Added 'Force Remove' button on Providers main view. Currently applicable only for volume providers (Cinder). Force removing a provider invokes the same operation as force remove of a storage domain. I.e. removing, from DB only, the provider along with all related entities (Storage Doamin, VMs, Templates, Disks).
 - [BZ 1445681](https://bugzilla.redhat.com/1445681) <b>No error pops when logging with a locked ovirt user account</b><br>For restapi clients the SSO authentication error is now added to the body of the response.<br><br>Example: Invalid password has been provided<br><br>curl -X GET -u admin@internal:123456 -H "Accept: application/xml" -H "Content-Type: application/xml" -H "Filter: true" http://127.0.0.1:8080/ovirt-engine/api/events<br><br>Response: The authentication error is now in the body of the response<br><br><html><head><title>Error</title></head><body>access_denied: Cannot authenticate user 'admin@internal': The username or password is incorrect..</body></html>
 - [BZ 1260480](https://bugzilla.redhat.com/1260480) <b>[RFE] For 'New' host function, change 'Address' to 'Hostname'</b><br>
 - [BZ 1160667](https://bugzilla.redhat.com/1160667) <b>[RFE] Allow explicit dns configuration</b><br>The engine now supports explicit DNS configuration.
 - [BZ 1439332](https://bugzilla.redhat.com/1439332) <b>[backup] Engine backup stages to /tmp, can fill disk to 100% and down rhv-m</b><br>Feature: <br><br>engine-backup now allows to control the location of the temporary directory it uses, using the command line option --tmpdir=DIR or the env variable $TMPDIR.<br><br>Reason: <br><br>Before this change, engine-backup always used /tmp. If /tmp is full or close to being full, it wasn't possible to tell engine-backup to use a different filesystem.<br><br>Result: <br><br>It's now possible to run engine-backup even if /tmp is full by telling it to use a different location.
 - [BZ 1433408](https://bugzilla.redhat.com/1433408) <b>[RFE] Upgrade to latest checkstyle</b><br>
 - [BZ 1335642](https://bugzilla.redhat.com/1335642) <b>[RFE] Users should be able to seal VMs from RHEV-M</b><br>The feature is documented here: http://www.ovirt.org/develop/release-management/features/virt-sysprep/
 - [BZ 1324532](https://bugzilla.redhat.com/1324532) <b>[TEXT] - engine-upgrade-check should prompt user that while RPMs are updated the engine might not be updated if he didn't run engine setup</b><br>Feature: <br>Provide a note to the user that the system may not be up to date after running engine-upgrade-check, if the user hasn't run engine-setup following e.g. yum update.<br><br>Reason: <br>To ensure the user is aware that the system may not be fully up to date in certain cases, even when the engine-upgrade-check says that there is no upgrade available.<br><br>Result: <br>The warning message is now displayed.
 - [BZ 1200963](https://bugzilla.redhat.com/1200963) <b>[RFE] - Set non-mgmt network as Default Route</b><br>Feature: <br>The engine now enables configuring a non-management network as the default network route, using the UI instead of custom properties.<br><br>Reason: <br><br>Result:
 - [BZ 1202311](https://bugzilla.redhat.com/1202311) <b>[RFE] Present Rx/TX counter with coma separator between thousands</b><br>
 - [BZ 1488466](https://bugzilla.redhat.com/1488466) <b>[RFE] Improve taskcleaner & unlock_entity execution</b><br>The taskcleaner and unlock_entity execution scripts have both had options for user, database, port and server names removed (-u, -d, -p, -s). Also there is no more need to export PGPASSWORD. All values are now obtained from the Manager configuration files.
 - [BZ 1404389](https://bugzilla.redhat.com/1404389) <b>[RFE] Need ability to refresh direct's LUN size if it was added without a HOST parameter (or if the underlying storage was extended)</b><br>The engine can update a direct LUN's missing or outdated information.
 - [BZ 1146558](https://bugzilla.redhat.com/1146558) <b>[RFE] Add the possibility to show iptables diff without interaction</b><br>
 - [BZ 1291177](https://bugzilla.redhat.com/1291177) <b>[RFE] Display disk content type in the GUI, and allow searching/filtering according to it</b><br>In the Administration Portal, on the "Disks" tab, disks can be filtered by content type.
 - [BZ 1514897](https://bugzilla.redhat.com/1514897) <b>'KILL' and 'LeavePaused' values could not be set for 'Resume Behaviour' of HA with no lease VMS</b><br>Feature: <br>Add resume behavior.<br><br>Reason: <br>Currently, if the VM gets paused due to storage error, if the storage gets back up again, it will always get un-paused. This is not always desirable (for example HA VMs restart is complicated, application level HA is complicated etc in this case).<br><br>Result: <br>Now there are 3 resume behaviors which can be configured per VM:<br>- kill (will kill the VM if it was paused for longer than 80s)<br>- LEAVE_PAUSED: do not touch it, leave it paused<br>- RESUME: the behavior which used to be the only one
 - [BZ 1484060](https://bugzilla.redhat.com/1484060) <b>[RFE] download monitoring in the WebAdmin</b><br>Added a progress bar to the status column of a disk on image download.<br>Also, the engine now finishes the download itself and doesn't need the user to click on Download -> Cancel when he's done to inform the engine about it.<br>Please see attached screencast to see the full process.
 - [BZ 1477505](https://bugzilla.redhat.com/1477505) <b>DR (site to site) - External LUN disks which are attached to VM should be part of the VM's OVF</b><br>Feature: <br>Adding the ability to register VMs with external LUN disks <br><br>Reason: <br>Until now we ignored external LUN disks in VM's OVF.<br>In oVirt 4.2 beta we added the support for those external LUN disks as part of the VM's OVF.<br>With the added external LUN disks, oVirt gains the ability to register those VMs to the engine and add the external LUN disks of those VMs as well.<br><br><br>Result: <br>External LUN disks are now part of the VM's OVF and can be added as part of the VM registration.<br>Keep in notice that once there is an existing external LUN disk in the ovirt-engine setup it must be removed before importing the VM, unless the partial_import flag is true.<br>In that case the VM will be registered without the external LUN disk
 - [BZ 1489332](https://bugzilla.redhat.com/1489332) <b>unlock_entity.sh does not report human readable output</b><br>Feature: <br><br>We have added command line parameter '-c', using which column names will be shown in the output, so administrators will know what entity is identified by showed UUID.<br><br>Reason: <br><br>Result:
 - [BZ 1491771](https://bugzilla.redhat.com/1491771) <b>[RFE] Enable storage domain creation on a non replicated gluster volumes</b><br>RHEV-M allows storage domain creation with a single Gluster brick.
 - [BZ 1489328](https://bugzilla.redhat.com/1489328) <b>unlock_entity.sh -q does not support type "all"</b><br>Administrators had to pass specific entity type ("vm", "disk" or "snapshot") using -q option for each unlock_entity.sh invocation, but there was no way how to process all entity types within single invocation.<br><br>We have introduced new value "all" which can be passed using -q option to process all entity types at once.
 - [BZ 1492706](https://bugzilla.redhat.com/1492706) <b>ovirt-engine-appliance misses python2-pyOpenSSL which is required for OVN setup</b><br>The engine now requires OVN.<br><br>Didn't check other OVN-related bugs, this can be mentioned in one of them instead of current.
 - [BZ 1468965](https://bugzilla.redhat.com/1468965) <b>Event log and engine spammed with 'User admin@internal-authz logged in/out' info messages</b><br>Feature: <br><br>All audit log messages around login or logout now contains not only username, but also IP address of the client which user is connecting from and ID of a session (if exists) to be able to distinguish between several connection from a single client.<br><br>Reason: <br><br>Result:
 - [BZ 1126277](https://bugzilla.redhat.com/1126277) <b>[Admin GUI] in 'Add Users and Groups' dialog the column title should be freeze.</b><br>
 - [BZ 1486006](https://bugzilla.redhat.com/1486006) <b>Guest OS type is missing for SLES12 in RHV4.x / RHEV3.x</b><br>Feature: <br>Change the "SUSE Linux Enterprise Server 11" to "SUSE Linux Enterprise Server 11+" in the OS list<br><br>Reason: <br>There was a missing "SUSE Linux Enterprise Server 12". Since there were no new values/settings for "SUSE Linux Enterprise Server 12", it was enough to change the 11 to 11+<br><br>Result: <br>Now the OS list contains the value: "SUSE Linux Enterprise Server 11+"
 - [BZ 1462629](https://bugzilla.redhat.com/1462629) <b>[New UI] - Improve and align the whole 'Network Interfaces' dialog</b><br>Feature: The Networks Interfaces screen was redesigned<br><br>Reason: The previous Network Interfaces screen represented the network data in a table. That design did not match our UI redesign look and feel.<br><br>Result: The Network Interfaces screen was redesigned to use PatternFly listviews. Important NIC information is always visible on each NIC's panel. More NIC details can be viewed by opening the expand/collapse sections on each list item.
 - [BZ 1360192](https://bugzilla.redhat.com/1360192) <b>[RFE] Image uploader: resume upload -  user is asked to supply source, path and image type - all over again</b><br>Resuming a paused image download is now done 'silently' on browser session level. I.e. resuming a download won't require selecting the file again *until restarting the browser* (after browser restart, we fallback to the previous behavior of selecting the file again).

#### oVirt Host Deploy

 - [BZ 1461081](https://bugzilla.redhat.com/1461081) <b>Deploy ovirt-host package only instead of single packages</b><br>
 - [BZ 1408942](https://bugzilla.redhat.com/1408942) <b>Host deploy should install cockpit-ovirt.</b><br>oVirt Host Deploy now install and maintain updated cockpit-ovirt package on hypervisor hosts.

#### oVirt Engine Dashboard

 - [BZ 1420039](https://bugzilla.redhat.com/1420039) <b>[RFE] Create a Refresh button on Dashboard in Manager UI</b><br>Feature: Add a manual refresh button to the dashboard UI to update the display with currently available system summary information.

#### ovirt-engine-dwh

 - [BZ 1459134](https://bugzilla.redhat.com/1459134) <b>[RFE] Rebase engine-setup on PostgreSQL >= 9.5</b><br>With this release, the engine now requires PostgreSQL 9.5 or later, which provides new features and better performance. The engine-setup tool can help upgrade an existing database to Software Collections PostgreSQL 9.5, as well as use that version for new setups.
 - [BZ 1409766](https://bugzilla.redhat.com/1409766) <b>[RFE]  Provide a tool to execute vacuum full on DWH database</b><br>This release adds a maintenance tool to run vacuum actions on the DWH database or specific tables. <br><br>The tool optimizes table stats and compacts the tables, resulting in less disk space usage. This allows for more efficient maintenance, and the updated table stats allow for better query planning.<br><br>Also provided is an engine-setup dialog that offers to perform vacuum during upgrades. This can be automated by the answer file.

#### oVirt Hosted Engine HA

 - [BZ 1498327](https://bugzilla.redhat.com/1498327) <b>HE host on EngineStarting -> EngineMaybeAway -> EngineDown cycle</b><br>Feature: Added caching of OVF storage location. <br><br>Reason: As OVF storage location raraely changes, we do not need to search for it on every monitoring loop iteration. Instead it can be saved and reused and expired only in case of error.<br><br>Result: Monitoring loop execution time decreased significantly
 - [BZ 1149579](https://bugzilla.redhat.com/1149579) <b>[RFE][hosted-engine-setup] [iSCSI support] allow selecting more than one iSCSI target</b><br>You can connect to more than one iSCSI target if you connect all the portals of an iSCSI portal group to enable multipathing before running the self-hosted engine deployment script. To be as backwards-compatible as possible and to avoid requiring changes in the deployment script, it saves the multiple IP and port values as a string composed of multiple comma-separated values with the same key used by the previous version. It assumes that the login is the same for all the portals.
 - [BZ 1457471](https://bugzilla.redhat.com/1457471) <b>Flood of getHardwareInfo (every 2 seconds or so) by ovirt-ha-agent</b><br>ovirt-ha-agent was renewing its json rpc connection to vdsm on each message using getHardwareInfo to verify it.<br>Now that the json rpc client internally supports a reconnect mechanism, there is not need to always create a fresh connection on ovirt-ha-agent side.
 - [BZ 1417708](https://bugzilla.redhat.com/1417708) <b>ovirt-ha-agent should reuse json-rpc connections</b><br>Feature: <br>In the past ovirt-ha-agent was opening a new connection each time it had to communicate with vdsm while now, for performance reasons, it can try to reuse an open connection if still valid.<br><br>Reason: <br>Performance reasons.<br><br>Result:<br>ovirt-ha-agent reuses an open json-rpc connection if available

#### oVirt Engine Metrics

 - [BZ 1508481](https://bugzilla.redhat.com/1508481) <b>[RFE] Add supervdsm to the collectd processes plugin</b><br>Feature: <br>Add supervdsm to the collectd processes plugin<br><br>Reason:<br>In order to monitor the supervdsm process.<br><br>Result: <br>An additional statistic under the processes plugin
 - [BZ 1508480](https://bugzilla.redhat.com/1508480) <b>[RFE] Add mom to the collectd processes plugin</b><br>Feature: <br>Add mom to the collectd processes plugin<br><br>Reason:<br>In order to monitor the mom process.<br><br>Result: <br>An additional statistic under the processes plugin
 - [BZ 1508484](https://bugzilla.redhat.com/1508484) <b>[RFE] Add ovirt-engine-dwhd to the collectd processes plugin</b><br>Feature: <br>Add ovirt-engine-dwhd to the collectd processes plugin<br><br>Reason:<br>In order to monitor the ovirt-engine-dwhd process.<br><br>Result: <br>An additional statistic under the processes plugin
 - [BZ 1471833](https://bugzilla.redhat.com/1471833) <b>[RFE]  Allow passing extra ansible opts to oVirt Metrics shell script</b><br>Feature: <br>Allow extra ansible opts that are optional when running ansible-playbook directly.<br><br>Reason: <br>This adds additional options when configuring oVirt metrics.<br> <br>Result: <br>Can now add ansible parameter when using configure_ovirt_machines_for_metrics.sh
 - [BZ 1446480](https://bugzilla.redhat.com/1446480) <b>[RFE]  add "Uptime" Column to oVirt Metrics Store</b><br>Feature: <br>This patch loads the uptime collectd plugin that reports the system uptime.<br><br>Reason: <br><br>Result:

#### oVirt Hosted Engine Setup

 - [BZ 1418579](https://bugzilla.redhat.com/1418579) <b>Use selinux when building ovirt-appliance</b><br>Feature: <br>Set SELinux to enforcing in ovirt-appliance<br><br>Reason: <br>Enhance security for the ovirt-appliance<br><br>Result: <br>SELinux is now being enforced
 - [BZ 1149579](https://bugzilla.redhat.com/1149579) <b>[RFE][hosted-engine-setup] [iSCSI support] allow selecting more than one iSCSI target</b><br>You can connect to more than one iSCSI target if you connect all the portals of an iSCSI portal group to enable multipathing before running the self-hosted engine deployment script. To be as backwards-compatible as possible and to avoid requiring changes in the deployment script, it saves the multiple IP and port values as a string composed of multiple comma-separated values with the same key used by the previous version. It assumes that the login is the same for all the portals.
 - [BZ 1461251](https://bugzilla.redhat.com/1461251) <b>[bug] hosted-engine yum repo required, but rpm-based install optional</b><br>Feature: <br>Provide path to Appliance OVF<br><br>Reason: <br>This feature is supported according to RedHat customer portal, but dropped in the past for some reason<br><br>Result: <br>User can provide path to appliance OVA instead of installing appliance RPM
 - [BZ 1429537](https://bugzilla.redhat.com/1429537) <b>[RFE] Rebase on gluster-3.12</b><br>Self-hosted engines now require GlusterFS 3.10 instead of 3.8.
 - [BZ 1304650](https://bugzilla.redhat.com/1304650) <b>[RFE] - he-setup should wait for all services and the Engine VM to come up successful at the end of the setup</b><br>With this release, the self-hosted engine deployment script waits for the Manager VM to power up before reporting that the deployment is complete. Now when the deployment is finished, you can connect to the Manager right away instead of waiting for the VM to power up.
 - [BZ 1233127](https://bugzilla.redhat.com/1233127) <b>[RFE] Warn when bad bond modes are used for the bond which is used for the initial VM network</b><br>

#### oVirt Log Collector

 - [BZ 1490447](https://bugzilla.redhat.com/1490447) <b>[RFE] option to collect logs from one host per cluster</b><br>Feature: <br>Introduce hypervisor-per-cluster option, to collect data from a single hypervisor per cluster. If the SPM found in the cluster, collect data from it.<br><br>Reason: <br>Simplifies collecting data.<br><br>Result: <br>Data is collected from a single host per cluster.
 - [BZ 1413316](https://bugzilla.redhat.com/1413316) <b>[RFE] enable collectd plugin for sos reports when it will be available</b><br>When sos >= 3.4 is used, log-collector now also enables collectd plugin which collects the CollectD configuration
 - [BZ 1020790](https://bugzilla.redhat.com/1020790) <b>[RFE] - add options to rhevm-log-collector to limit size of collected logs</b><br>The ovirt-log-collector can now limit the maximum size of logs collected in order to capture relevant logs only. The size of the logs may be extremely large in environments with large numbers of hosts or a large number of exceptions, so ovirt-log-collector can now arbitrarily limit the size of logs collected, defaulting to the last day only.
 - [BZ 1404509](https://bugzilla.redhat.com/1404509) <b>[RFE] Log collector should collect time diff for all hosts</b><br>When collecting SOS reports from hosts, chrony and systemd SOS plugins can now collect information about time synchronization. In addition, a new --time-only option has been added to ovirt-log-collector, allowing information about time differences to be gathered from the hosts without gathering full SOS reports, saving a considerable amount of time for the operation.
 - [BZ 1023455](https://bugzilla.redhat.com/1023455) <b>[CodeChange][RFE] log-collector should use the same code used by the engine for parsing configuration</b><br>

#### oVirt Provider OVN

 - [BZ 1505398](https://bugzilla.redhat.com/1505398) <b>OVS 2.6 obscures OVS 2.7 due to misuse of the epoch</b><br>This ensures that openvswitch version 1:2.6.1 (version: 2.6.1 epoch:1) is not consumed when the provider is installed. Ovs package 1:2.6.1 is a beta package which should not be used (but has accidentally been in the repos). <br><br>When ovs is not installed, the result will be that the correct version (if available) will be installed. <br><br>If 1:2.6.1 is already installed, the install operation will fail with the message: "... conflicts with openvswitch = 1:2.6.1 ...". <br>Manual action will be needed to replace the package. The user will have to manually change the openvswitch packages to the latest available.<br>The improper package version can be replaced by downloading and replacing the openvswitch packages with a specific version of openvswitch:<br><br>- download each of the openvswitch packages:<br>    - provider: openvswitch, openvswitch-ovn-common, openvswitch-ovn-central, python-openvswitch<br>    - driver: openvswitch, openvswitch-ovn-common, openvswitch-ovn-host, python-openvswitch<br>  yumdownloader <package>-<version><br>  for example: yumdownloader openvswitch-2.7.2<br><br>- install the new version using the downloaded rpm files<br>  yum downgrade <package><br>  for example:<br>  yum downgrade openvswitch-2.7.2-10.git20170914.el7fdp.x86_64.rpm
 - [BZ 1472747](https://bugzilla.redhat.com/1472747) <b>Error while trying to authenticate ovirt-provider-ovn against Active Directory</b><br>Feature: <br>to authenticate ovirt-provider-ovn against an ldap server via user/password set<br><br>ovirt-admin-user-name=<admin_username><br>in /etc/ovirt-provider-ovn/conf.d<br><br>and use <admin_username>@<ad_domain>@<auth_profile> when defining the external provider in ovirt-engine.<br><br>Similarly, to authenticate with an active directory group set in /etc/ovirt-provider-ovn/conf.d :<br><br>[AUTH]<br>auth-plugin=auth.plugins.ovirt:AuthorizationByGroup<br><br>[OVIRT]<br>ovirt-admin-role-id=def00005-0000-0000-0000-def000000005<br>ovirt-admin-group-attribute-name=AAA_AUTHZ_GROUP_NAME;java.lang.String;0eebe54f-b429-44f3-aa80-4704cbb16835<br><br>and use <admin_username>@<ad_domain>@<auth_profile> when defining the external provider in ovirt-engine.<br><br>Reason: <br><br>Result:

#### oVirt Engine Appliance

 - [BZ 1418579](https://bugzilla.redhat.com/1418579) <b>Use selinux when building ovirt-appliance</b><br>Feature: <br>Set SELinux to enforcing in ovirt-appliance<br><br>Reason: <br>Enhance security for the ovirt-appliance<br><br>Result: <br>SELinux is now being enforced
 - [BZ 1463853](https://bugzilla.redhat.com/1463853) <b>[RFE] RHV-M appliance should meet NIST 800-53 partitioning requirements</b><br>Previously, the partitioning scheme for the RHV-M Virtual Appliance included two primary partitions, "/" and swap.<br><br>In this release, the disk partitioning scheme has been modified to match the scheme specified by NIST. The updated disk partitions are as follows:<br><br>/boot 1G (primary)<br>/home 1G (lvm)<br>/tmp 2G (lvm)<br>/var 20G (lvm)<br>/var/log 10G (lvm)<br>/var/log/audit 1G (lvm)<br>swap 8G (lvm)<br>/ 6G (primary)
 - [BZ 1422982](https://bugzilla.redhat.com/1422982) <b>[RFE] add swap to rhevm-appliance</b><br>Previously, the default memory allotment for the RHV-M Virtual Appliance was always large enough to include support for user additions.<br><br>In this release, the RHV-M Virtual Appliance includes a swap partition that enables the memory to be increased when required.

#### oVirt Guest Agent

 - [BZ 1443143](https://bugzilla.redhat.com/1443143) <b>Do not set tuned profile - leave whatever the guest has</b><br>

### Rebase: Enhancementss Only

#### oVirt Release Package

 - [BZ 1429541](https://bugzilla.redhat.com/1429541) <b>Rebase on Gluster 3.12</b><br>oVirt release now enables CentOS Storage SIG Gluster 3.10 repository. See Gluster 3.10 release notes for more information  at https://gluster.readthedocs.io/en/latest/release-notes/3.10.0/

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1456558](https://bugzilla.redhat.com/1456558) <b>iptables support deprecation</b><br>With this update, iptables has been deprecated in favor of firewalld. In Red Hat Virtualization 4.2 it is still possible to use iptables but iptables will not be supported in future releases.
 - [BZ 1443989](https://bugzilla.redhat.com/1443989) <b>[RFE] Deprecate and remove spice-html5 support</b><br>The spice-html5 has been removed.
 - [BZ 1473182](https://bugzilla.redhat.com/1473182) <b>Drop ovirt-engine-setup-plugin-dockerc</b><br>With this update, the ovirt-engine-setup-plugin-dockerc package has been dropped. The ovirt-engine-setup-plugin-dockerc package was previously deprecated in version 4.1.5.

#### oVirt Host Deploy

 - [BZ 1426580](https://bugzilla.redhat.com/1426580) <b>Remove qemu-kvm-tools installation</b><br>With this update, the Host Deploy is no longer installing qemu-kvm-tools on deployed hosts.

### Known Issue

#### imgbased

 - [BZ 1454536](https://bugzilla.redhat.com/1454536) <b>HostedEngine setup fails if RHV-H timezone < UTC set during installation</b><br>Currently, the Red Hat Virtualization Host generates VDSM certificates at the time of the first boot. This means that if the system clock was not set correctly at install time then chrony or ntpd may resynchronize the clock after the VDSM certificate was generated, leading to a certificate that is not valid yet if the appropriate timezone is behind UTC. A workaround for this is to set the system clock appropriately at install time. Now, imgbased-configure-vdsm starts after chronyd or ntpd and waits two seconds for the clock to synchronize, but this is not a guarantee.

### Bug Fixes

#### OTOPI

 - [BZ 1490380](https://bugzilla.redhat.com/1490380) <b>otopi's path search is incompatible with common shells</b><br>
 - [BZ 1328764](https://bugzilla.redhat.com/1328764) <b>Setup does not dump keys that are initialized to None</b><br>

#### VDSM

 - [BZ 1446492](https://bugzilla.redhat.com/1446492) <b>Storage domain in 4.1 RHV will go offline if LVM metadata was restored manually</b><br>
 - [BZ 1470435](https://bugzilla.redhat.com/1470435) <b>Handle copy of compressed QCOWs image (like rhel guest images) from one to block storage domain.</b><br>
 - [BZ 1494921](https://bugzilla.redhat.com/1494921) <b>NPE when get LLDP info from host interface via REST</b><br>
 - [BZ 1474566](https://bugzilla.redhat.com/1474566) <b>[sos plugin] lvm commands need syntax change</b><br>
 - [BZ 1486543](https://bugzilla.redhat.com/1486543) <b>Migration leads to VM running on 2 Hosts</b><br>
 - [BZ 1260747](https://bugzilla.redhat.com/1260747) <b>Create the filesystem layout at install time in the places where needed</b><br>
 - [BZ 980363](https://bugzilla.redhat.com/980363) <b>Incorrect speed is displayed for the interface of the host</b><br>
 - [BZ 1358717](https://bugzilla.redhat.com/1358717) <b>Export of vm with thin provision disk from NFS Data domain and Import to Block Data domain makes virtual and Actual size of disk same.</b><br>
 - [BZ 1326799](https://bugzilla.redhat.com/1326799) <b>[CodeChange] Remove workaround for selinux.restorecon for disabled selinux</b><br>
 - [BZ 1506517](https://bugzilla.redhat.com/1506517) <b>Can't run VM with sysprep - could not create floppy file</b><br>
 - [BZ 1502488](https://bugzilla.redhat.com/1502488) <b>Cold merge will fail if the base qcow2 image reports leaked cluster</b><br>
 - [BZ 1502352](https://bugzilla.redhat.com/1502352) <b>Cleanup thread for live merge executed continously if a block job failed in libvirtd side</b><br>
 - [BZ 1422670](https://bugzilla.redhat.com/1422670) <b>During a Live Merge, VDSM still saw a block job, even though libvirt's block job had completed.</b><br>
 - [BZ 1428851](https://bugzilla.redhat.com/1428851) <b>RDMA Glusterfs does not recognized as mounted</b><br>
 - [BZ 1426144](https://bugzilla.redhat.com/1426144) <b>virt-v2v: trying to import a VM with unreachable cdrom device caused the import to fail with "disk storage error"</b><br>
 - [BZ 1412455](https://bugzilla.redhat.com/1412455) <b>[Bug] Gluster brick created with RHEV manager is overallocated</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1446094](https://bugzilla.redhat.com/1446094) <b>ovirt-imageio setup doesn't consume --reconfigure-optional-components on engine-setup</b><br>

#### imgbased

 - [BZ 1502920](https://bugzilla.redhat.com/1502920) <b>File missing after upgrade of RHVH node from version RHVH-4.1-20170925.0 to latest.</b><br>
 - [BZ 1324219](https://bugzilla.redhat.com/1324219) <b>Hide anaconda build logs and kickstart</b><br>
 - [BZ 1484629](https://bugzilla.redhat.com/1484629) <b>Miss new boot entry after upgrade to ovirt-node-ng 4.2</b><br>

#### oVirt Node

 - [BZ 1324219](https://bugzilla.redhat.com/1324219) <b>Hide anaconda build logs and kickstart</b><br>

#### oVirt Engine

 - [BZ 1441322](https://bugzilla.redhat.com/1441322) <b>HA VMs running in two hosts at a time after restoring backup of RHV-M</b><br>
 - [BZ 1518558](https://bugzilla.redhat.com/1518558) <b>Disable gfapi access for 4.2 cluster</b><br>
 - [BZ 1464396](https://bugzilla.redhat.com/1464396) <b>Pool VMs console disconnect action revert to "lock screen" instead of "shutdown virtual machine"</b><br>
 - [BZ 1376754](https://bugzilla.redhat.com/1376754) <b>Host is set to ERROR mode (cannot start VM) while being in Maintenance</b><br>
 - [BZ 1388336](https://bugzilla.redhat.com/1388336) <b>VMware import, username with '.' not accepted</b><br>
 - [BZ 1464055](https://bugzilla.redhat.com/1464055) <b>bond has no speed set in active_migration_network_interfaces</b><br>
 - [BZ 1362557](https://bugzilla.redhat.com/1362557) <b>[RFE] Use the improved VM overhead calculation in VM scheduling</b><br>
 - [BZ 1435485](https://bugzilla.redhat.com/1435485) <b>[Pool] VMs are still created with duplicate MAC addresses after 4.0.7 upgrade</b><br>
 - [BZ 1443292](https://bugzilla.redhat.com/1443292) <b>Failed to attach non-mgmt network to host if default route is set</b><br>
 - [BZ 1445171](https://bugzilla.redhat.com/1445171) <b>MultiHost command is not sent when updating network with default route role</b><br>
 - [BZ 1445266](https://bugzilla.redhat.com/1445266) <b>Engine not sending defaultRoute property on setup networks command</b><br>
 - [BZ 1491132](https://bugzilla.redhat.com/1491132) <b>Engine assigning MAC addresses which are in use by VMs when creating new VM from template</b><br>
 - [BZ 1247950](https://bugzilla.redhat.com/1247950) <b>When creating a template from glance we should mark the bootable disk as bootable</b><br>
 - [BZ 1448831](https://bugzilla.redhat.com/1448831) <b>Issues with automating the configuration of VMs (cloud-init)</b><br>
 - [BZ 1451221](https://bugzilla.redhat.com/1451221) <b>engine-setup should set admin@internal in the registered provider</b><br>
 - [BZ 1414970](https://bugzilla.redhat.com/1414970) <b>Block/limit/warn VM migration in UI if it has hostdev devices attached</b><br>
 - [BZ 1499126](https://bugzilla.redhat.com/1499126) <b>Not possible to change ValidNumOfMonitors as wrong data type set</b><br>
 - [BZ 1506449](https://bugzilla.redhat.com/1506449) <b>[API] Cannot clear vm initialization via api</b><br>
 - [BZ 1496704](https://bugzilla.redhat.com/1496704) <b>Python-SDK doesn't seem to handle quota information on disks</b><br>
 - [BZ 1270570](https://bugzilla.redhat.com/1270570) <b>HostSetupNetworks: Remove Bootproto and IP from NIC's tooltip when NIC is attached to network</b><br>
 - [BZ 1445199](https://bugzilla.redhat.com/1445199) <b>Put the HE host to the maintenance via the engine unmount the HE storage domain from the host</b><br>
 - [BZ 1130445](https://bugzilla.redhat.com/1130445) <b>[TEXT] - if engine-setup asks for updates and choice is no, suggest '--offline' on re-run.</b><br>
 - [BZ 1448100](https://bugzilla.redhat.com/1448100) <b>[OVN] - oVirt OVN provider password can't be empty</b><br>
 - [BZ 1447014](https://bugzilla.redhat.com/1447014) <b>Default route role should  fall back to management network</b><br>
 - [BZ 1413845](https://bugzilla.redhat.com/1413845) <b>Engine fails to start properly</b><br>
 - [BZ 1439970](https://bugzilla.redhat.com/1439970) <b>[v4 API] Specifying name and vm.disk_attachments returns error 500</b><br>
 - [BZ 1310715](https://bugzilla.redhat.com/1310715) <b>[UI][setupNetworks dialog] - NIC and network panel tooltips are not updated immediately</b><br>
 - [BZ 1252906](https://bugzilla.redhat.com/1252906) <b>Search based on negated fields with null values doesn't work properly</b><br>
 - [BZ 1304792](https://bugzilla.redhat.com/1304792) <b>Disks table - some columns are not sortable</b><br>
 - [BZ 1302351](https://bugzilla.redhat.com/1302351) <b>[UI] - [Hosts] -> 'Network Interfaces' -> 'Setup Host Networks', 'Save Network Configuration' and 'Sync All Networks' buttons shouldn't be part of the scrolling in case of multiple interfaces on the host</b><br>
 - [BZ 1149466](https://bugzilla.redhat.com/1149466) <b>New Template screen has some text, alignment, spacing and sizing issues</b><br>
 - [BZ 1442037](https://bugzilla.redhat.com/1442037) <b>No validation on the disk's type when taking a partial snapshot</b><br>
 - [BZ 1237132](https://bugzilla.redhat.com/1237132) <b>[TEXT] New package listing of engine-setup when upgrading packages is not user friendly</b><br>
 - [BZ 1263785](https://bugzilla.redhat.com/1263785) <b>Remove constants duplication in ovirt-engine-dwh and ovirt-engine-setup</b><br>
 - [BZ 1518693](https://bugzilla.redhat.com/1518693) <b>Quota is needed to copy template disk</b><br>
 - [BZ 1422922](https://bugzilla.redhat.com/1422922) <b>DataCenter Quota's threshold value</b><br>
 - [BZ 1508033](https://bugzilla.redhat.com/1508033) <b>[UI] - URL fragment is ignored when redirected from a login</b><br>
 - [BZ 1304931](https://bugzilla.redhat.com/1304931) <b>Rename "OpenStack Volume" to "OpenStack Block Storage"</b><br>
 - [BZ 1106552](https://bugzilla.redhat.com/1106552) <b>Restore the image_templates_images constraint [blocked on enhancement bug 1106547 - move to PG 9.5]</b><br>
 - [BZ 1415751](https://bugzilla.redhat.com/1415751) <b>Webadmin SearchBox: "Vms:hosts" doesn't work</b><br>
 - [BZ 1366960](https://bugzilla.redhat.com/1366960) <b>Disk element under storagedomains/{domain-id}/disks;unregistered should have 'register' Action</b><br>
 - [BZ 1475893](https://bugzilla.redhat.com/1475893) <b>DR (site to site) - Add the ability to support force remove of last master storage domain from data center</b><br>
 - [BZ 1484392](https://bugzilla.redhat.com/1484392) <b>Unable to Import a VM linked with its template to RHV 4.1 from export domain imported of RHEV 3.5</b><br>
 - [BZ 1425879](https://bugzilla.redhat.com/1425879) <b>NFS storage domain path with a trailing slash should be accepted</b><br>
 - [BZ 1333409](https://bugzilla.redhat.com/1333409) <b>Inconsistent behavior when creating VM from template that pinned to hosts via REST and via UI</b><br>
 - [BZ 1452139](https://bugzilla.redhat.com/1452139) <b>No validation on the VM disks attachments when taking a snapshot</b><br>
 - [BZ 1418020](https://bugzilla.redhat.com/1418020) <b>Engine should block detach of domain that isn't on maintenance status</b><br>
 - [BZ 1430865](https://bugzilla.redhat.com/1430865) <b>ERROR: duplicate key value violates unique constraint "pk_unregistered_disks_to_vms"</b><br>
 - [BZ 1406858](https://bugzilla.redhat.com/1406858) <b>Engine setup fails on F25 - m2crypto fails to load the ca.pem</b><br>
 - [BZ 1315771](https://bugzilla.redhat.com/1315771) <b>Virtual Machines' Disks & Snapshots in Resources in UserPortal is not expanded correctly</b><br>

#### oVirt Engine Dashboard

 - [BZ 1421104](https://bugzilla.redhat.com/1421104) <b>[fr_FR, es_ES] [Admin Portal] Some numbers are displayed as 'NaN' on Dashboard tab.</b><br>
 - [BZ 1508033](https://bugzilla.redhat.com/1508033) <b>[UI] - URL fragment is ignored when redirected from a login</b><br>

#### ovirt-engine-dwh

 - [BZ 1167903](https://bugzilla.redhat.com/1167903) <b>versionlock.list is not filtered if engine is not installed</b><br>
 - [BZ 1263785](https://bugzilla.redhat.com/1263785) <b>Remove constants duplication in ovirt-engine-dwh and ovirt-engine-setup</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1337914](https://bugzilla.redhat.com/1337914) <b>Hosted engine issues too many lvm operations</b><br>
 - [BZ 1413845](https://bugzilla.redhat.com/1413845) <b>Engine fails to start properly</b><br>
 - [BZ 1480039](https://bugzilla.redhat.com/1480039) <b>Additional HE host deploy fails due to 'received downloaded data size is wrong'</b><br>
 - [BZ 1286568](https://bugzilla.redhat.com/1286568) <b>HA Agent and Broker logs have incorrect permissions/ownership</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1464461](https://bugzilla.redhat.com/1464461) <b>hosted-engine --upgrade-appliance reports unsupported upgrade path</b><br>
 - [BZ 1466234](https://bugzilla.redhat.com/1466234) <b>Hosted Engine upgrade from 3.6 to 4.0 will fail if the NFS is exported with root_squash</b><br>
 - [BZ 1449557](https://bugzilla.redhat.com/1449557) <b>ovirt-hosted-engine-setup installs an older HE appliance and then upgrade to latest HE image (currently RHV-4.1)</b><br>
 - [BZ 1487560](https://bugzilla.redhat.com/1487560) <b>[iSCSI] ovirt-hosted-engine-setup fails if none of the discovered target is associated to the accessed portal</b><br>
 - [BZ 1449565](https://bugzilla.redhat.com/1449565) <b>ovirt-hosted-engine-setup has leftover mounts</b><br>
 - [BZ 1286568](https://bugzilla.redhat.com/1286568) <b>HA Agent and Broker logs have incorrect permissions/ownership</b><br>
 - [BZ 1517881](https://bugzilla.redhat.com/1517881) <b>Deployment of SHE stuck on the appliance.</b><br>
 - [BZ 1481680](https://bugzilla.redhat.com/1481680) <b>hosted-engine --upgrade-appliance fails with KeyError: 'stopped' if the metadata area contains references to 3.5 decommissioned hosts</b><br>

#### oVirt ISO Uploader

 - [BZ 1437799](https://bugzilla.redhat.com/1437799) <b>[RFE] - ovirt-iso-uploader should work with Gluster without NFS enabled</b><br>

#### oVirt Log Collector

 - [BZ 1445245](https://bugzilla.redhat.com/1445245) <b>ovirt-log-collector should use /etc/pki/ovirt-engine/apache-ca.pem instead of /etc/pki/ovirt-engine/ca.pem</b><br>

### Other

#### oVirt Host Dependencies

 - [BZ 1473164](https://bugzilla.redhat.com/1473164) <b>Do not install collectd-virt plugin</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1465328](https://bugzilla.redhat.com/1465328) <b>[RFE] Add a hierarchy of exceptions</b><br>
 - [BZ 1525302](https://bugzilla.redhat.com/1525302) <b>Need to explicitly control the number of requests sent to libcurl < 7.30.0</b><br>
 - [BZ 1525555](https://bugzilla.redhat.com/1525555) <b>The `all_content` parameter isn't translated into the `All-Content` header</b><br>
 - [BZ 1505427](https://bugzilla.redhat.com/1505427) <b>Ruby-SDK build requires redhat-rpm-config which is not listed in requirements</b><br>
 - [BZ 1492614](https://bugzilla.redhat.com/1492614) <b>Missing documentation for destination storage in template creation</b><br>
 - [BZ 1497641](https://bugzilla.redhat.com/1497641) <b>Not able to set user's public key.</b><br>
 - [BZ 1378113](https://bugzilla.redhat.com/1378113) <b>sdk should raise an exception when unknown parameter is used</b><br>
 - [BZ 1468461](https://bugzilla.redhat.com/1468461) <b>SDK-Ruby: Support 'error' field in JSON SSO response</b><br>

#### VDSM

 - [BZ 1524119](https://bugzilla.redhat.com/1524119) <b>Failed to migrate HE VM</b><br>
 - [BZ 1522901](https://bugzilla.redhat.com/1522901) <b>VM migration 4.2 -> 4.1 fails with virtio-rng device</b><br>
 - [BZ 1523399](https://bugzilla.redhat.com/1523399) <b>KeyError: 'vmName' after starting VM that was restored from snapshot with memory</b><br>
 - [BZ 1438506](https://bugzilla.redhat.com/1438506) <b>[downstream clone - 4.2.0] while deleting vms created from a template, vdsm command fails with error VDSM command failed: Could not remove all image's volumes</b><br>
 - [BZ 1522878](https://bugzilla.redhat.com/1522878) <b>GetCapabilitiesVDS failed: Not enough resources</b><br>
 - [BZ 1518688](https://bugzilla.redhat.com/1518688) <b>Unable to run a VM with a display network that is non-vm</b><br>
 - [BZ 1496719](https://bugzilla.redhat.com/1496719) <b>Port mirroring is not set after VM migration</b><br>
 - [BZ 1518315](https://bugzilla.redhat.com/1518315) <b>GetCapabilitiesVDS fails after upgrade to 4.2 due to missing openvswitch</b><br>
 - [BZ 1507278](https://bugzilla.redhat.com/1507278) <b>Can't create bond modes 5 and 6 when trying to create with non-VM vlan tagged network</b><br>
 - [BZ 1516660](https://bugzilla.redhat.com/1516660) <b>Persist device metadata also in the legacy flow (AttributeError: volumeID for storage Drives)</b><br>
 - [BZ 1516405](https://bugzilla.redhat.com/1516405) <b>Missing parameter 'memSize' after starting VM that was restored from snapshot with memory</b><br>
 - [BZ 1422430](https://bugzilla.redhat.com/1422430) <b>[RFE] Support MACADDR when acquiring interfaces from ifcfg and NM.</b><br>
 - [BZ 1507884](https://bugzilla.redhat.com/1507884) <b>VM fails to run after being suspended</b><br>
 - [BZ 1433380](https://bugzilla.redhat.com/1433380) <b>Execute fencing on hosts which RPC pool is exhausted</b><br>
 - [BZ 1408672](https://bugzilla.redhat.com/1408672) <b>Can't run VM with payload - permission denied trying to access payload</b><br>
 - [BZ 1430491](https://bugzilla.redhat.com/1430491) <b>Make guaranteed memory hot-settable when memory is hotplugged</b><br>
 - [BZ 1508397](https://bugzilla.redhat.com/1508397) <b>When BOOTPROTO=dhcp do NOT put DNS options explicitly into ifcfg-$network</b><br>
 - [BZ 1495905](https://bugzilla.redhat.com/1495905) <b>RHV-H reposts unknown bonding devices during the boot process.</b><br>
 - [BZ 1510443](https://bugzilla.redhat.com/1510443) <b>journal spammed with WARN cannot red eth0 speed (when using virtio NICs on the *host*)</b><br>
 - [BZ 1487064](https://bugzilla.redhat.com/1487064) <b>ERROR (Thread-1) [utils.Callback] qemuGuestAgentCallback failed on VM shutdown</b><br>
 - [BZ 1471727](https://bugzilla.redhat.com/1471727) <b>vdsm syslog print format is not compatible to other services' format</b><br>
 - [BZ 1469077](https://bugzilla.redhat.com/1469077) <b>[RFE] Import from kvm source when guest's disk type is volume</b><br>Previously, it was not possible to import virtual machines containing disks that were of type 'volume'. In this release, it is now possible to import this type of virtual machine.
 - [BZ 1468944](https://bugzilla.redhat.com/1468944) <b>Failed to import guest whose disk is not listed in storage pool from kvm/xen source at rhv4.1</b><br>
 - [BZ 1478712](https://bugzilla.redhat.com/1478712) <b>Power-off VM via the engine, raise Traceback in the vdsm log</b><br>
 - [BZ 1478965](https://bugzilla.redhat.com/1478965) <b>Vdsm shows traceback when HE VM powered-off</b><br>
 - [BZ 1458901](https://bugzilla.redhat.com/1458901) <b>Error: vdsm.virt.sampling.VMBulkstatsMonitor object at 0x3155490> operation failed (KeyError: 'balloon.current')</b><br>
 - [BZ 1452185](https://bugzilla.redhat.com/1452185) <b>After host reboot host doesn't have gateway</b><br>
 - [BZ 1426566](https://bugzilla.redhat.com/1426566) <b>kvm_amd nested virtualization not detected</b><br>
 - [BZ 1412451](https://bugzilla.redhat.com/1412451) <b>[RFE]virt-v2v new feature "--vdsm-compat" should be  implemented  in VDSM .</b><br>In this release, virt-v2v can convert QCOW2 images with compatibility level 1.1. Note that the Storage Domain must be version 4.
 - [BZ 1405378](https://bugzilla.redhat.com/1405378) <b>remove RHEV branding from guest agent area - oVirt 4.2 Channel name deprecation</b><br>
 - [BZ 1506193](https://bugzilla.redhat.com/1506193) <b>vdsm sos plugin does not collect hostdevListByCaps.</b><br>
 - [BZ 1425863](https://bugzilla.redhat.com/1425863) <b>[TEXT] null architecture type, replacing with x86_64, %s</b><br>
 - [BZ 1448913](https://bugzilla.redhat.com/1448913) <b>import kvm libvirt failure on buffer size mismatch (when working against an old libvirt)</b><br>
 - [BZ 1479872](https://bugzilla.redhat.com/1479872) <b>[vhost hook] vm failed to start if network name in custom property is invalid</b><br>
 - [BZ 1470696](https://bugzilla.redhat.com/1470696) <b>Bridge with two ports  kills getCaps - 'code=-32603, message=too many values to unpack'</b><br>
 - [BZ 1495213](https://bugzilla.redhat.com/1495213) <b>Code for dynamic allocation sums memory of VMs without hugepages</b><br>
 - [BZ 1516322](https://bugzilla.redhat.com/1516322) <b>HA VM is not restarted if was was Paused on SPM Host.</b><br>
 - [BZ 1488542](https://bugzilla.redhat.com/1488542) <b>"No such drive" error on live merge of one disk causes merge of other disk to fail on engine.</b><br>
 - [BZ 1514925](https://bugzilla.redhat.com/1514925) <b>vdsm-client Host getVMFullList returns "vmName": "nNone" and not the real VM name</b><br>
 - [BZ 1512572](https://bugzilla.redhat.com/1512572) <b>vdsm Failed to connect to guest agent channel</b><br>
 - [BZ 1508560](https://bugzilla.redhat.com/1508560) <b>Delete snapshot after live migration fails at reduce stage - BlockStorageDomainManifest' object has no attribute '_extendlock'</b><br>
 - [BZ 1501064](https://bugzilla.redhat.com/1501064) <b>'register' missing from usage and epilog parts of vdsm-tool register help message.</b><br>
 - [BZ 1505150](https://bugzilla.redhat.com/1505150) <b>Live Merge: Reduce volume fails on nfs storage</b><br>
 - [BZ 1481246](https://bugzilla.redhat.com/1481246) <b>VM does not consume any hugepages on a host</b><br>
 - [BZ 1455138](https://bugzilla.redhat.com/1455138) <b>virt: migration: do not refer to RHBZ#919201 if migration is stalling</b><br>
 - [BZ 1427184](https://bugzilla.redhat.com/1427184) <b>[downstream clone] LiveMerge fails with libvirtError: Block copy still active. Disk not ready for pivot</b><br>Cause:<br>Testing completion of a live merge operation was incorrect, checking live merge progress value available via libvirt api which does not provide the status of a live merge operation.<br><br>Consequence: <br>Live merge was detected as completed before the operation was actually completed. Trying to finalize the merge operation failed repeatedly until the operation was actually completed, logging multiple errors during the process.<br><br>Fix: <br>Detect live merge completion using the libvirt xml.<br><br>Result: <br>Live merge operation will complete successfully without logging errors.
 - [BZ 1414075](https://bugzilla.redhat.com/1414075) <b>Support for 0.25 m2crypto (on Fedora)</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1500739](https://bugzilla.redhat.com/1500739) <b>Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1505268](https://bugzilla.redhat.com/1505268) <b>proxy fails with a too-old -common package</b><br>
 - [BZ 1463722](https://bugzilla.redhat.com/1463722) <b>Failed to start service 'ovirt-imageio-proxy'</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1415984](https://bugzilla.redhat.com/1415984) <b>Save the generated gdeploy config files with timestamp under the persistent location</b><br>
 - [BZ 1367457](https://bugzilla.redhat.com/1367457) <b>[RFE] Refactor the hosted-engine wizard UI to use alt2</b><br>
 - [BZ 1522641](https://bugzilla.redhat.com/1522641) <b>Hosted Engine deployment looks like stuck, but become up with one more hours.</b><br>
 - [BZ 1516121](https://bugzilla.redhat.com/1516121) <b>There are some excess steps when deploying the HostedEngine.</b><br>
 - [BZ 1519743](https://bugzilla.redhat.com/1519743) <b>Inputs invisible on high resolution screens</b><br>
 - [BZ 1516113](https://bugzilla.redhat.com/1516113) <b>Deploy the HostedEngine failed with the default CPU type</b><br>
 - [BZ 1509775](https://bugzilla.redhat.com/1509775) <b>HostedEngine page cannot reach and keep status "Loading Wizard".</b><br>
 - [BZ 1426474](https://bugzilla.redhat.com/1426474) <b>There is 1 vm running after installing cockpit-ovirt with Fedora24</b><br>

#### imgbased

 - [BZ 1517116](https://bugzilla.redhat.com/1517116) <b>chronyd.service failed</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1467969](https://bugzilla.redhat.com/1467969) <b>[RFE] Add a hierarchy of exceptions</b><br>
 - [BZ 1468460](https://bugzilla.redhat.com/1468460) <b>Support 'error' field in JSON SSO response</b><br>

#### oVirt Engine

 - [BZ 1523415](https://bugzilla.redhat.com/1523415) <b>Error while executing action Edit VM properties: Internal Engine Error</b><br>
 - [BZ 1518134](https://bugzilla.redhat.com/1518134) <b>Cannot import VM from attached data storage domain</b><br>
 - [BZ 1518066](https://bugzilla.redhat.com/1518066) <b>ovirt-engine-backend contains jar files that shouldn't be there</b><br>
 - [BZ 1506092](https://bugzilla.redhat.com/1506092) <b>Disks and interfaces don't appear in VM's snapshots</b><br>
 - [BZ 1492673](https://bugzilla.redhat.com/1492673) <b>Adding iSCSI storage domain is impossible via the UI in the default dialog box "Targets -> LUNs"</b><br>
 - [BZ 1491598](https://bugzilla.redhat.com/1491598) <b>[UI] - 'Manage Networks' dialog is blank</b><br>
 - [BZ 1492386](https://bugzilla.redhat.com/1492386) <b>[UI] - Remove/Edit buttons are disabled for VM's vNICs</b><br>
 - [BZ 1523072](https://bugzilla.redhat.com/1523072) <b>Cannot export a VM to an export domain when specifying the storage domain by its name (Incomplete lookup for method signature)</b><br>
 - [BZ 1519124](https://bugzilla.redhat.com/1519124) <b>OVN add host (deploy) fails on RHV-H host and it becomes non-operational</b><br>
 - [BZ 1518724](https://bugzilla.redhat.com/1518724) <b>[UI] UI plugins can no longer add buttons / context menu items</b><br>
 - [BZ 1516842](https://bugzilla.redhat.com/1516842) <b>action bar kebab menu is cropped when the menu is long</b><br>
 - [BZ 1509667](https://bugzilla.redhat.com/1509667) <b>provider-host in ovirt-provider-ovn.conf should be FQDN</b><br>
 - [BZ 1500739](https://bugzilla.redhat.com/1500739) <b>Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>
 - [BZ 1463653](https://bugzilla.redhat.com/1463653) <b>[RFE] Provide a failure-is-ok command for decomisioning a host</b><br>
 - [BZ 1495261](https://bugzilla.redhat.com/1495261) <b>[RFE] Define default network provider on cluster level</b><br>
 - [BZ 1506887](https://bugzilla.redhat.com/1506887) <b>host_nic_vfs_config is not populated if parent pci device of nic is shared with another device</b><br>
 - [BZ 1503799](https://bugzilla.redhat.com/1503799) <b>Unable to create an iSCSI bond from webui</b><br>
 - [BZ 1500812](https://bugzilla.redhat.com/1500812) <b>Engine and audit logs don't indicate if a commit or undo was issued during a snapshot preview</b><br>
 - [BZ 1504558](https://bugzilla.redhat.com/1504558) <b>when removing network interface from VM it is still visible in VMs tab</b><br>
 - [BZ 1504265](https://bugzilla.redhat.com/1504265) <b>[UI] engine errata grid missing links to detail view</b><br>
 - [BZ 1380498](https://bugzilla.redhat.com/1380498) <b>[RFE] host upgrade should upgrade the whole host, not specific packages</b><br>Up until version 4.2 the upgrade process of the host upgraded just few packages on the host relevant for the virtualization. The packages was be specified by following variables: PackageNamesForCheckUpdate, UserPackageNamesForCheckUpdate and OvirtNodePackageNamesForCheckUpdate. <br><br>Since version 4.2 the upgrade process of the host will update all packages, not only relevant one. We also added an option to choose whether the host should be rebooted after the upgrade is done, where the default option is to do a reboot.<br><br>Users can't no longer choose relevant packages to check the upgrade, and so following config options don't exists anymore:<br> - PackageNamesForCheckUpdate<br> - UserPackageNamesForCheckUpdate<br> - OvirtNodePackageNamesForCheckUpdate
 - [BZ 1504005](https://bugzilla.redhat.com/1504005) <b>Cluster can be created with empty 'Default network provided', which is causing NPE during host deploy</b><br>
 - [BZ 1467928](https://bugzilla.redhat.com/1467928) <b>Shutdown of a vm during snapshot deletion renders the disk invalid</b><br>Cause: <br>Live merge failed during Merge Status command, Destroy Image command or Destroy Image Check command.<br><br>Consequence: <br>If this is an active image live merge, the top volume is left as illegal at the end of the failed live merge.<br><br>Fix: <br>The reason of the failure in those commands is, usually, network timeout when executing Vdsm verbs. In that case, we keep trying executing the verbs until succeeding.<br><br>Result: <br>Live merge process will not fail if there is an issue calling Vdsm and the top volume will not be illegal.
 - [BZ 1483329](https://bugzilla.redhat.com/1483329) <b>[UI] Incorrect 'Network Interfaces' IP values are displayed on a VM</b><br>
 - [BZ 1481007](https://bugzilla.redhat.com/1481007) <b>vGPU: VMs with mdev_type hook failed to run after RHV upgrade, even if the hook removed.</b><br>
 - [BZ 1495062](https://bugzilla.redhat.com/1495062) <b>[UI] - Pressing the 'QoS' sub tab under DC leave the webAdmin non-operational until browser refresh</b><br>
 - [BZ 1492702](https://bugzilla.redhat.com/1492702) <b>OVN setup plugins ignores --offline CLI option</b><br>
 - [BZ 1494920](https://bugzilla.redhat.com/1494920) <b>[UI] - Setup Networks dialog is completely broken and can't be used</b><br>
 - [BZ 1490383](https://bugzilla.redhat.com/1490383) <b>Auth plugin stopped working on Wildfly 11</b><br>
 - [BZ 1414207](https://bugzilla.redhat.com/1414207) <b>Too many ISO refreshing events</b><br>In order to maintain backwards compatibility in the REST-API which is used by virt-viewer the force refresh option is on by default unless the value of the configuration value ForceRefreshDomainFilesListByDefault is set to false.<br>So to solve this bug for the customer it's mandatory to change this configuration value accordingly
 - [BZ 1433380](https://bugzilla.redhat.com/1433380) <b>Execute fencing on hosts which RPC pool is exhausted</b><br>
 - [BZ 1506484](https://bugzilla.redhat.com/1506484) <b>[RFE] Allow attached disks registration using REST-API</b><br>
 - [BZ 1515661](https://bugzilla.redhat.com/1515661) <b>engine-setup keeps asking for configuration of ovirt-provider-ovn even if its already installed</b><br>
 - [BZ 1510432](https://bugzilla.redhat.com/1510432) <b>[RFE] Dashboard and history queries use lots of big temp file (increase pg work_mem)</b><br>
 - [BZ 1510508](https://bugzilla.redhat.com/1510508) <b>Add validation check for available macs in mac pool</b><br>
 - [BZ 1516982](https://bugzilla.redhat.com/1516982) <b>Engine creates DomaimXML with vNICs in unpredictable order</b><br>
 - [BZ 1511914](https://bugzilla.redhat.com/1511914) <b>on screen resolution 1368x768 is setup network dialog header not visible</b><br>
 - [BZ 1509896](https://bugzilla.redhat.com/1509896) <b>Tasks page should be closed when using vertical navigation</b><br>
 - [BZ 1510335](https://bugzilla.redhat.com/1510335) <b>[UI] - Network's tooltip is missing address, netmask and gateway if the bootproto is dhcp</b><br>
 - [BZ 1503196](https://bugzilla.redhat.com/1503196) <b>Upgrade to 4.2 from < 4.1.7 fails</b><br>
 - [BZ 1508023](https://bugzilla.redhat.com/1508023) <b>NPE when adding fence agent through REST API using nonexistent host UUID</b><br>
 - [BZ 1460701](https://bugzilla.redhat.com/1460701) <b>[RFE] Add support to search jobs by correlation_id</b><br>
 - [BZ 1478688](https://bugzilla.redhat.com/1478688) <b>[UI] - Adjust setup networks dialog to display long names networks</b><br>
 - [BZ 1472772](https://bugzilla.redhat.com/1472772) <b>[UI] - re-add context menus to grids</b><br>
 - [BZ 1509375](https://bugzilla.redhat.com/1509375) <b>Update VM from REST fails if next run spanshot exists</b><br>
 - [BZ 1508513](https://bugzilla.redhat.com/1508513) <b>Can't open setup networks dialog if there is an 'unmanaged' network on the host</b><br>
 - [BZ 1505328](https://bugzilla.redhat.com/1505328) <b>[Rest] - Rest should report current rx/tx data in bps</b><br>
 - [BZ 1422504](https://bugzilla.redhat.com/1422504) <b>[ALL_LANG] Need to localize some gluster related strings on users->event notifier->manage events screen.</b><br>
 - [BZ 1435402](https://bugzilla.redhat.com/1435402) <b>[CodeChange][i18n] oVirt 4.2 translation cycle 1</b><br>
 - [BZ 1430491](https://bugzilla.redhat.com/1430491) <b>Make guaranteed memory hot-settable when memory is hotplugged</b><br>
 - [BZ 1505674](https://bugzilla.redhat.com/1505674) <b>[UI] - NICs shown twice in the setup networks dialog</b><br>
 - [BZ 1485927](https://bugzilla.redhat.com/1485927) <b>Default vNIC profile not created if new network dialog is confirmed with keyboard Enter(works via Ok button click)</b><br>
 - [BZ 1497503](https://bugzilla.redhat.com/1497503) <b>[SR-IOV] [UI] - Networks are missing in the list when pressing the 'Specific Networks' radio button</b><br>
 - [BZ 1356510](https://bugzilla.redhat.com/1356510) <b>[ja_JP, fr_FR] [Admin Portal] Text truncation observed on virtual machines -> disks -> attach screen.</b><br>
 - [BZ 1356519](https://bugzilla.redhat.com/1356519) <b>[ja_JP] Text truncation observed on virtual machines -> create template screen.</b><br>
 - [BZ 1418154](https://bugzilla.redhat.com/1418154) <b>[ja_JP, es_ES] [Admin Portal] Text alignment needs to be adjusted on configure->instance type->new screen</b><br>
 - [BZ 1421974](https://bugzilla.redhat.com/1421974) <b>[ja_JP, fr_FR, es_ES] [Admin Portal] Text truncation observed on pools -> new -> Resource Allocation tab</b><br>
 - [BZ 1483400](https://bugzilla.redhat.com/1483400) <b>Highly populated export domain fails to attach.</b><br>
 - [BZ 1464746](https://bugzilla.redhat.com/1464746) <b>[New UI] - User is not authorized to perform action of create new 'QoS' entity</b><br>
 - [BZ 1482365](https://bugzilla.redhat.com/1482365) <b>User cannot use non Public vNIC Profiles</b><br>
 - [BZ 1495441](https://bugzilla.redhat.com/1495441) <b>add vm with cloud init config: IPv6 boot protocol initialized with user input of IPv4 boot protocol</b><br>
 - [BZ 1491230](https://bugzilla.redhat.com/1491230) <b>add indication to snapshot in preview</b><br>
 - [BZ 1479796](https://bugzilla.redhat.com/1479796) <b>vmfex hook not working properly</b><br>
 - [BZ 1431434](https://bugzilla.redhat.com/1431434) <b>[UI] - Gray out 'Sync All Networks' button when all networks are synced on host</b><br>
 - [BZ 1432412](https://bugzilla.redhat.com/1432412) <b>incorrect InfoIcon tooltip when importing VM through KVM</b><br>
 - [BZ 1437512](https://bugzilla.redhat.com/1437512) <b>when rng device is attached, suspend and hibernate fails</b><br>Previously, suspension and hibernation (S3 and S4) were enabled on the guest operating system although not supported in RHV. Now, they are disabled.
 - [BZ 1479779](https://bugzilla.redhat.com/1479779) <b>add template version in networks Template subtab to differentiate between subversions</b><br>
 - [BZ 1480238](https://bugzilla.redhat.com/1480238) <b>RESTAPI- PUT request to update DC from 4.0->4.1 fails with REST response 'Cannot migrate MACs to another MAC pool, because that action would create duplicates in target MAC pool, which are not allowed. Problematic MACs are  00:1a:4a:16:25:b2'</b><br>
 - [BZ 1443412](https://bugzilla.redhat.com/1443412) <b>[UI] -Gray out 'Default Route' checkbox on management network for Network>Clusters flow</b><br>
 - [BZ 1475788](https://bugzilla.redhat.com/1475788) <b>engine-cleanup renames conf files of postgres</b><br>
 - [BZ 1456778](https://bugzilla.redhat.com/1456778) <b>Physical Memory Guaranteed validation error highlight doesnt' work</b><br>
 - [BZ 1474352](https://bugzilla.redhat.com/1474352) <b>NPE While Increase size of vm pool with initial run configuration (cloud init)</b><br>
 - [BZ 1458724](https://bugzilla.redhat.com/1458724) <b>[DNS] [REST] - Add option to send an empty DNS configuration</b><br>
 - [BZ 1431555](https://bugzilla.redhat.com/1431555) <b>Some config files are writable by user ovirt</b><br>
 - [BZ 1445253](https://bugzilla.redhat.com/1445253) <b>Add and report out-of-sync to default route property</b><br>
 - [BZ 1436154](https://bugzilla.redhat.com/1436154) <b>Setup ovirt-provider-ovn during engine setup.</b><br>
 - [BZ 1434731](https://bugzilla.redhat.com/1434731) <b>[UI] - Add the new 'Default Route' icon to the network interface panel as well and not only on the network's tooltip</b><br>
 - [BZ 1417823](https://bugzilla.redhat.com/1417823) <b>[RFE]virt-v2v new feature "--vdsm-compat" should be added</b><br>with this new feature we are converting qcow images with the newer compat version '1.1'.<br>Note that the storage version needs to be 4 or more.
 - [BZ 1356562](https://bugzilla.redhat.com/1356562) <b>[ALL_LANGS] Untranslated strings in Disks->Upload: Browse button and related messages</b><br>
 - [BZ 1405378](https://bugzilla.redhat.com/1405378) <b>remove RHEV branding from guest agent area - oVirt 4.2 Channel name deprecation</b><br>
 - [BZ 1412074](https://bugzilla.redhat.com/1412074) <b>[SR-IOV] - same pci addr is stored for two vNICs - libvirtError: XML error: Attempted double use of PCI slot 0000:00:08.0 (may need "multifunction='on'" for device on function 0)</b><br>
 - [BZ 1419853](https://bugzilla.redhat.com/1419853) <b>[BLOCKED] Image upload fails when one of the ovirt-imageio-daemons was not running</b><br>
 - [BZ 1378045](https://bugzilla.redhat.com/1378045) <b>Importing VMs from VMware ova fails with error java.lang.reflect.UndeclaredThrowableException</b><br>
 - [BZ 1517974](https://bugzilla.redhat.com/1517974) <b>[AAA] Locale selector on welcome page doesn't work when using http</b><br>
 - [BZ 1514941](https://bugzilla.redhat.com/1514941) <b>Network: rephrase 'There is no important LLDAP information' message</b><br>
 - [BZ 1481586](https://bugzilla.redhat.com/1481586) <b>engine-setup ovn plugin outputs to the user a plaintext password on failure</b><br>
 - [BZ 1516917](https://bugzilla.redhat.com/1516917) <b>[UI] IE11: when a lot of notifications occur, they are scattered all over the screen</b><br>
 - [BZ 1506215](https://bugzilla.redhat.com/1506215) <b>[UI] Default Network Provider per cluster is not selected as default provider when creating a network</b><br>
 - [BZ 1508319](https://bugzilla.redhat.com/1508319) <b>[UI] - 'Required' checkbox should be grayed out if unchecking the 'Attached' to cluster checkbox on create new network flow</b><br>
 - [BZ 1472418](https://bugzilla.redhat.com/1472418) <b>[RFE] Allow user to get user ID in REST API</b><br>
 - [BZ 1481706](https://bugzilla.redhat.com/1481706) <b>disable default route role for clusters lower than 4.1 version</b><br>
 - [BZ 1488005](https://bugzilla.redhat.com/1488005) <b>[UI] - VM's vNIC - Align the '+' and '-' buttons for the new Network Filter Parameters ability</b><br>
 - [BZ 1492546](https://bugzilla.redhat.com/1492546) <b>[UI] - UI exception after setting default route property via Cluster>Logical Networks flow</b><br>
 - [BZ 1487907](https://bugzilla.redhat.com/1487907) <b>[RFE][UI] - Display network filter parameters under VM's network interfaces sub tab</b><br>
 - [BZ 1488013](https://bugzilla.redhat.com/1488013) <b>[UI] - Re-size VM's Network Interface(vNIC) dialog</b><br>
 - [BZ 1484255](https://bugzilla.redhat.com/1484255) <b>[UI] - VMs > Snapshots > 'Total TX' reported instead of 'Speed' and the Type is wrong</b><br>
 - [BZ 1496893](https://bugzilla.redhat.com/1496893) <b>Fail host deploy process if ovirt-host-deploy role is not found</b><br>
 - [BZ 1438329](https://bugzilla.redhat.com/1438329) <b>[UI] - Gap in the 'Network Role' icons under Networks>Clusters and Clusters>Networks</b><br>
 - [BZ 1425831](https://bugzilla.redhat.com/1425831) <b>Enlarge New VM dialog to make network immediately visible</b><br>
 - [BZ 1432008](https://bugzilla.redhat.com/1432008) <b>[UI] - The cursor jumps to the end of line when editing MAC Address Ranges in chrome</b><br>
 - [BZ 1490824](https://bugzilla.redhat.com/1490824) <b>Empty line is inserted at the beginning of versionlock.list after upgrade</b><br>
 - [BZ 1486547](https://bugzilla.redhat.com/1486547) <b>[UI] - 'Passthrough' should be disabled if the vNIC profile is attached and used by a VM</b><br>
 - [BZ 1434868](https://bugzilla.redhat.com/1434868) <b>Fence agents should be dropped from VDS view join</b><br>
 - [BZ 1477961](https://bugzilla.redhat.com/1477961) <b>[UI] - Failed to create bond from interfaces that has labeled networks attached</b><br>
 - [BZ 1390930](https://bugzilla.redhat.com/1390930) <b>[UI] - "Port Mirroring' property is editable although the 'passthrough' property is marked on edit vNIC profile dialog</b><br>
 - [BZ 1458668](https://bugzilla.redhat.com/1458668) <b>VM pool auto_storage_select flag doesn't return Validation error</b><br>
 - [BZ 1349382](https://bugzilla.redhat.com/1349382) <b>Configuring Ballooning device for VM pools from SDK does not work</b><br>
 - [BZ 1413364](https://bugzilla.redhat.com/1413364) <b>[UI] - 'Server with newer configuration for next run' tooltip is broken</b><br>
 - [BZ 1459003](https://bugzilla.redhat.com/1459003) <b>[UI] - Uncaught exception when trying to send an empty network name on edit network</b><br>
 - [BZ 1463568](https://bugzilla.redhat.com/1463568) <b>[UI] - no vNIC Profile is created during a new network is created</b><br>
 - [BZ 1451232](https://bugzilla.redhat.com/1451232) <b>long timeout when importing network with wrong provider credentials</b><br>
 - [BZ 1425149](https://bugzilla.redhat.com/1425149) <b>unexpected TAB key order in the New External Subnet window</b><br>
 - [BZ 1394555](https://bugzilla.redhat.com/1394555) <b>[UI] 'passthough' should be disabled in Create/edit vNIC profile dialog for external network</b><br>
 - [BZ 1434398](https://bugzilla.redhat.com/1434398) <b>Text in UI window "New External Subnet" does not look normal</b><br>
 - [BZ 1451245](https://bugzilla.redhat.com/1451245) <b>[DNS] - Validate empty DNS configuration and mark field in red</b><br>
 - [BZ 1382411](https://bugzilla.redhat.com/1382411) <b>[TEXT] PKI AIA Validation points to a non existent web page</b><br>
 - [BZ 1447635](https://bugzilla.redhat.com/1447635) <b>[UX] window title "undefined" in removing subnet</b><br>
 - [BZ 1341024](https://bugzilla.redhat.com/1341024) <b>[Text] - The text '...the host's certification' is wrong when trying to change the management's network ip</b><br>
 - [BZ 1523253](https://bugzilla.redhat.com/1523253) <b>When canceling a download, the engine finalizes the operation as if it was completed successfully</b><br>
 - [BZ 1518702](https://bugzilla.redhat.com/1518702) <b>Webadmin -  ImageIO- UI - canceling failed upload is not possible via 'upload' button  but only via 'download' button</b><br>
 - [BZ 1488853](https://bugzilla.redhat.com/1488853) <b>While downloading disk the cancel/pause upload button should be disabled</b><br>
 - [BZ 1513800](https://bugzilla.redhat.com/1513800) <b>Localdisk hook must prevent VM from being snapshot.</b><br>
 - [BZ 1512911](https://bugzilla.redhat.com/1512911) <b>Internal server Error on incorrect headers</b><br>
 - [BZ 1520387](https://bugzilla.redhat.com/1520387) <b>Re-initialize data center from unattached domain does not function. "Uncaught exception: com.google.gwt.event.shared.UmbrellaException:  Exception caught: (TypeError) : Cannot read property 'className' of undefined"</b><br>
 - [BZ 1517094](https://bugzilla.redhat.com/1517094) <b>after redesign, the detach vm from pool button disappeared</b><br>
 - [BZ 1519246](https://bugzilla.redhat.com/1519246) <b>WebAdmin: Import VM columns overlapping and too thin</b><br>
 - [BZ 1520119](https://bugzilla.redhat.com/1520119) <b>[UI] - Cluster's name is <UNKNOWN> on template import in the admin pop up messages(green)</b><br>
 - [BZ 1372302](https://bugzilla.redhat.com/1372302) <b>"Show available bricks from host" doesn't show any bricks</b><br>
 - [BZ 1419904](https://bugzilla.redhat.com/1419904) <b>Host state icon indicates down when being activated from maintenance</b><br>
 - [BZ 1518423](https://bugzilla.redhat.com/1518423) <b>inactive Data Center fail to delete a VM without images only with external LUN disks</b><br>
 - [BZ 1505724](https://bugzilla.redhat.com/1505724) <b>unattended cleanup fails</b><br>engine-cleanup now does not fail when using an answer file generated by an interactive invocation of it.
 - [BZ 1516817](https://bugzilla.redhat.com/1516817) <b>Don't allow hosts in Maintenance to be selected as fence proxies</b><br>
 - [BZ 1500163](https://bugzilla.redhat.com/1500163) <b>Error while executing action CloneVm: Internal Engine Error (when VM is configured with cloud-init)</b><br>
 - [BZ 1516322](https://bugzilla.redhat.com/1516322) <b>HA VM is not restarted if was was Paused on SPM Host.</b><br>
 - [BZ 1516792](https://bugzilla.redhat.com/1516792) <b>Can not remove fence agent via REST API</b><br>
 - [BZ 1484828](https://bugzilla.redhat.com/1484828) <b>[UI] - UI exception after snapshot create and preview</b><br>
 - [BZ 1511025](https://bugzilla.redhat.com/1511025) <b>Remove storage domain dialog box has a dropDownList-checkBox related issue</b><br>
 - [BZ 1510860](https://bugzilla.redhat.com/1510860) <b>Reports fullTargets on /hosts/123/iscsidiscover (iSCSI multipath)</b><br>Cause: <br>On a multipath iSCSI env, the same target that is exposed by multiple portals in the same target portal group<br><br>Consequence: <br>Only targets are listed w/o full details<br><br>Fix: <br>Add a new discoveredTargets that contains all details<br><br>Result: <br><discovered_targets><br>        <iscsi_details><br>            <address>10.35.146.129</address><br>            <port>3260</port><br>            <portal>10.35.146.129:3260,1</portal><br>            <target>iqn.2008-05.com.xtremio:xio00153500071-514f0c50023f6c00</target><br>        </iscsi_details><br>        <iscsi_details><br>            <address>10.35.146.161</address><br>            <port>3260</port><br>            <portal>10.35.146.161:3260,1</portal><br>            <target>iqn.2008-05.com.xtremio:xio00153500071-514f0c50023f6c01</target><br>        </iscsi_details><br>        <iscsi_details><br>            <address>10.35.146.193</address><br>            <port>3260</port><br>            <portal>10.35.146.193:3260,1</portal><br>            <target>iqn.2008-05.com.xtremio:xio00153500071-514f0c50023f6c04</target><br>        </iscsi_details><br>        <iscsi_details><br>            <address>10.35.146.225</address><br>            <port>3260</port><br>            <portal>10.35.146.225:3260,1</portal><br>            <target>iqn.2008-05.com.xtremio:xio00153500071-514f0c50023f6c05</target><br>        </iscsi_details><br>    </discovered_targets>
 - [BZ 1510755](https://bugzilla.redhat.com/1510755) <b>Possible exceptions in collection input validation</b><br>
 - [BZ 1510764](https://bugzilla.redhat.com/1510764) <b>Input validation - no signature found should throw ValidationException</b><br>
 - [BZ 1515852](https://bugzilla.redhat.com/1515852) <b>When resuming an upload that was auto-paused because of a browser refresh, the upload is paused again</b><br>
 - [BZ 1513969](https://bugzilla.redhat.com/1513969) <b>When resuming a paused image upload, the progress bar does not show the right progress</b><br>
 - [BZ 1514887](https://bugzilla.redhat.com/1514887) <b>ImageIO- Reboot proxy VDSM host during disk upload - upload can't be cancled/resumed - RemoveImageTicketVDS failed - The resource could not be found</b><br>
 - [BZ 1508813](https://bugzilla.redhat.com/1508813) <b>Cannot delete/update already uploaded users ssh key in web UI</b><br>
 - [BZ 1507849](https://bugzilla.redhat.com/1507849) <b>missing log file location when Ansible host-deploy role fails</b><br>
 - [BZ 1513996](https://bugzilla.redhat.com/1513996) <b>VM is restarted rather than resumed on dehibernation</b><br>
 - [BZ 1513933](https://bugzilla.redhat.com/1513933) <b>Cannot create iSCSI storage domain and LUN disks</b><br>
 - [BZ 1511944](https://bugzilla.redhat.com/1511944) <b>Failed logins log messages do not have IP</b><br>
 - [BZ 1503718](https://bugzilla.redhat.com/1503718) <b>by importing storage error confirmation checkbox is hidden</b><br>
 - [BZ 1507473](https://bugzilla.redhat.com/1507473) <b>Setting Hosts to Maintenance blocks UI</b><br>
 - [BZ 1506280](https://bugzilla.redhat.com/1506280) <b>engine-setup fails: Failed to execute stage 'Setup validation': 'list' object has no attribute 'splitlines'</b><br>
 - [BZ 1492471](https://bugzilla.redhat.com/1492471) <b>not clear mutual exclusive messages in pop up window</b><br>
 - [BZ 1477500](https://bugzilla.redhat.com/1477500) <b>DR (site to site) - Add cluster name to the VM's OVF</b><br>
 - [BZ 1505436](https://bugzilla.redhat.com/1505436) <b>DR (site to site) - Support mapping for entity's attributes on register</b><br>
 - [BZ 1505428](https://bugzilla.redhat.com/1505428) <b>Support users related to a VM as part of an entity's OVF</b><br>
 - [BZ 1510957](https://bugzilla.redhat.com/1510957) <b>Avoid preparing and tearing down images during create snapshot while the VM isn't down</b><br>
 - [BZ 1508844](https://bugzilla.redhat.com/1508844) <b>ExtendImageTicketVDSCommand might get stuck if host is restarted during image transfer</b><br>
 - [BZ 1415740](https://bugzilla.redhat.com/1415740) <b>Soft fencing causes a "host is rebooting" message that might be misleading</b><br>
 - [BZ 1352675](https://bugzilla.redhat.com/1352675) <b>Add Permissions dialog: 'My Groups' table has user-specific header/columns instead of group-specific</b><br>
 - [BZ 1506284](https://bugzilla.redhat.com/1506284) <b>Downloading disk for a running vm fails with: response content type 'text/html;charset=UTF-8' isn't the expected XML</b><br>
 - [BZ 1508403](https://bugzilla.redhat.com/1508403) <b>VM Portal logs out due to missing session refresh</b><br>
 - [BZ 1509962](https://bugzilla.redhat.com/1509962) <b>OVF update doesn't occur when create VM without disk and storage domain enter to maintenance</b><br>
 - [BZ 1509646](https://bugzilla.redhat.com/1509646) <b>[UI] - Mouse cursor icon is always 'wait' spinner</b><br>
 - [BZ 1509633](https://bugzilla.redhat.com/1509633) <b>Dashboard: clicking on the links doesn't do anything (for example, on 'hosts')</b><br>
 - [BZ 1508776](https://bugzilla.redhat.com/1508776) <b>UploadImageChunkSizeKB default value is too low, causing low ImageIO performance</b><br>The default value of UploadImageChunkSizeKB was increased to 100MB, in order to improve upload speed performance.
 - [BZ 1505452](https://bugzilla.redhat.com/1505452) <b>Start ovirt-engine and ovirt-engine-notifier services by default with MALLOC_ARENA_MAX=1</b><br>
 - [BZ 1507847](https://bugzilla.redhat.com/1507847) <b>Can't run High Performance VMs as non headless with the VNC graphics protocol</b><br>
 - [BZ 1508775](https://bugzilla.redhat.com/1508775) <b>Expose UploadImageChunkSizeKB in engine-config (used for ImageIO upload/download)</b><br>
 - [BZ 1508798](https://bugzilla.redhat.com/1508798) <b>The error message in case of failure in retrieving an image list doesn't well configured.</b><br>
 - [BZ 1483287](https://bugzilla.redhat.com/1483287) <b>[UI] - Can't choose multiple VM's vNICs at once using 'ctrl' or 'shift' buttons</b><br>
 - [BZ 1506611](https://bugzilla.redhat.com/1506611) <b>OVF update occur each time domain is deactivate even though there is nothing to update</b><br>
 - [BZ 1482413](https://bugzilla.redhat.com/1482413) <b>[UI] - Don't allow the use of up and down keyboard buttons in the background when dialog is open</b><br>
 - [BZ 1507098](https://bugzilla.redhat.com/1507098) <b>There is no version 4.2 in capabilities when using REST API v3</b><br>
 - [BZ 1500996](https://bugzilla.redhat.com/1500996) <b>Engine logs don't indicate the option chosen for a snapshot preview</b><br>
 - [BZ 1489334](https://bugzilla.redhat.com/1489334) <b>unlock_entity.sh -q reports duplicate records.</b><br>
 - [BZ 1489441](https://bugzilla.redhat.com/1489441) <b>Host: Add new PM proxy doesn't show name before reordering</b><br>
 - [BZ 1493158](https://bugzilla.redhat.com/1493158) <b>Host edit dialog does not show any labels</b><br>
 - [BZ 1501455](https://bugzilla.redhat.com/1501455) <b>Failed to verify power management agent</b><br>
 - [BZ 1502741](https://bugzilla.redhat.com/1502741) <b>Cannot fence host through REST API: PM is enabled for Host but no Agent type selected</b><br>
 - [BZ 1480213](https://bugzilla.redhat.com/1480213) <b>SSH public key field not shown when adding a host</b><br>
 - [BZ 1481583](https://bugzilla.redhat.com/1481583) <b>engine-setup with ovn fails to import cert after engine-cleanup</b><br>
 - [BZ 1428370](https://bugzilla.redhat.com/1428370) <b>The displayed cores are not sorted properly</b><br>
 - [BZ 1492684](https://bugzilla.redhat.com/1492684) <b>In edit host tab, authentication field should not be editable</b><br>
 - [BZ 1492614](https://bugzilla.redhat.com/1492614) <b>Missing documentation for destination storage in template creation</b><br>
 - [BZ 1497708](https://bugzilla.redhat.com/1497708) <b>Expose host hugepages to REST API</b><br>
 - [BZ 1504608](https://bugzilla.redhat.com/1504608) <b>Image from glance shows size 1024 MB instead of 1 GB when size is exactly 1073741824 B</b><br>
 - [BZ 1502596](https://bugzilla.redhat.com/1502596) <b>error appears when changing hosts cluster, but cluster is changed</b><br>
 - [BZ 1497641](https://bugzilla.redhat.com/1497641) <b>Not able to set user's public key.</b><br>
 - [BZ 1471082](https://bugzilla.redhat.com/1471082) <b>FinishedActivating notification is shown before host is actually activated</b><br>
 - [BZ 1502619](https://bugzilla.redhat.com/1502619) <b>Memory disks (memory and metadata) status is unassigned after VM registered from data storage domain</b><br>
 - [BZ 1490473](https://bugzilla.redhat.com/1490473) <b>URLs for classic user portal should redirect to VM Portal</b><br>
 - [BZ 1445320](https://bugzilla.redhat.com/1445320) <b>confirmation screen for host upgrade does not disappear when "ok" is clicked</b><br>
 - [BZ 1465795](https://bugzilla.redhat.com/1465795) <b>Top utilized Resources (Storage) - VMs should be sorted by actual use, not over-allocation percentage</b><br>
 - [BZ 1499716](https://bugzilla.redhat.com/1499716) <b>Event properties show empty fields</b><br>
 - [BZ 1449515](https://bugzilla.redhat.com/1449515) <b>When deleting a vm from an export domain the delete dialog is shown with a vm name as "null" (after performing some operations)</b><br>
 - [BZ 1404753](https://bugzilla.redhat.com/1404753) <b>/api/model requires external access to https://fonts.googleapis.com</b><br>
 - [BZ 1490870](https://bugzilla.redhat.com/1490870) <b>No help for ovirt-register-sso-client-tool</b><br>
 - [BZ 1499239](https://bugzilla.redhat.com/1499239) <b>Propagate errors to welcome page</b><br>
 - [BZ 1495723](https://bugzilla.redhat.com/1495723) <b>Several jobs are not finished</b><br>
 - [BZ 1488755](https://bugzilla.redhat.com/1488755) <b>Can't enable PM through REST API</b><br>
 - [BZ 1494955](https://bugzilla.redhat.com/1494955) <b>IllegalArgumentException is thrown when host with PM is edited</b><br>
 - [BZ 1496805](https://bugzilla.redhat.com/1496805) <b>GET to /api/disk return operation failed after importing VM with memory snapshot</b><br>
 - [BZ 1431441](https://bugzilla.redhat.com/1431441) <b>Difference between import vm and export vm 'collapse snapshot' default configuration</b><br>
 - [BZ 1454823](https://bugzilla.redhat.com/1454823) <b>Restore snapshots table constraints to base_disks</b><br>
 - [BZ 1468439](https://bugzilla.redhat.com/1468439) <b>VM startup takes 2m and 50 seconds with 1200 devices (use case: multiple direct LUNs)</b><br>
 - [BZ 1496329](https://bugzilla.redhat.com/1496329) <b>[UI] - CPU QoS is not reachable and has cut-off in the end of the page</b><br>
 - [BZ 1472143](https://bugzilla.redhat.com/1472143) <b>Wrong error message when setting one character, in linux boot parameters in Edit VM dialog</b><br>
 - [BZ 1487182](https://bugzilla.redhat.com/1487182) <b>When exporting a disk to Glance, the size shown is its "Virtual Size" but the title is "Actual Size".</b><br>
 - [BZ 1477963](https://bugzilla.redhat.com/1477963) <b>Export of VM without disks does not log the export success</b><br>
 - [BZ 1429499](https://bugzilla.redhat.com/1429499) <b>Import of VM without disks does not log the import success</b><br>
 - [BZ 1491567](https://bugzilla.redhat.com/1491567) <b>useless scrollbar in table view when only one row present</b><br>
 - [BZ 1481246](https://bugzilla.redhat.com/1481246) <b>VM does not consume any hugepages on a host</b><br>
 - [BZ 1491731](https://bugzilla.redhat.com/1491731) <b>attach disk dialog is empty</b><br>
 - [BZ 1491707](https://bugzilla.redhat.com/1491707) <b>dropdown menu is not all visible</b><br>
 - [BZ 1490936](https://bugzilla.redhat.com/1490936) <b>automatic postgres upgrade fails on remote db</b><br>
 - [BZ 1487312](https://bugzilla.redhat.com/1487312) <b>FE NPE when selecting a snapshot row</b><br>
 - [BZ 1466781](https://bugzilla.redhat.com/1466781) <b>Missing href attributes in some REST entry points</b><br>
 - [BZ 1456711](https://bugzilla.redhat.com/1456711) <b>[RFE] Add properties to events</b><br>
 - [BZ 1480134](https://bugzilla.redhat.com/1480134) <b>vertical navigation doesn't open the just-selected primary option on hover</b><br>
 - [BZ 1479301](https://bugzilla.redhat.com/1479301) <b>[RFE] Add elapsed times of operations to the engine.log</b><br>
 - [BZ 1466270](https://bugzilla.redhat.com/1466270) <b>Incorrect response format (not XML) for REST call on VM creation.</b><br>
 - [BZ 1487170](https://bugzilla.redhat.com/1487170) <b>by creating new bookmark Clear search doesn't work properly</b><br>
 - [BZ 1487193](https://bugzilla.redhat.com/1487193) <b>[UI] add right margin to action buttons in detail view</b><br>
 - [BZ 1479709](https://bugzilla.redhat.com/1479709) <b>templates quickswitch has the same name duplicated in the list</b><br>
 - [BZ 1452989](https://bugzilla.redhat.com/1452989) <b>Show disks containing memory dumps in the disks list in REST and the disks tab in the UI</b><br>Prior to this change the memory disks were filtered from the view in the webadmin and the disks results in the REST, now they are displayed in both.<br>Memory disks are disks containing memory dump or configuration created from either a snapshot that includes the guest's memory or from a machine that was suspended (hibernated).
 - [BZ 1428490](https://bugzilla.redhat.com/1428490) <b>Min/max memory values for RHEL 6 and RHEL 7 are incorrect</b><br>
 - [BZ 1480208](https://bugzilla.redhat.com/1480208) <b>Dismiss event in Notification Drawer causes Internal server error</b><br>
 - [BZ 1453159](https://bugzilla.redhat.com/1453159) <b>Allow filtering of disks according to their content type in webadmin</b><br>
 - [BZ 1428206](https://bugzilla.redhat.com/1428206) <b>Change Sub Version to Sub-version</b><br>
 - [BZ 1478020](https://bugzilla.redhat.com/1478020) <b>UI error on login the first time after engine is restarted</b><br>
 - [BZ 1478942](https://bugzilla.redhat.com/1478942) <b>add back searching with already created bookmarks</b><br>
 - [BZ 1477986](https://bugzilla.redhat.com/1477986) <b>[UI] - 'Clear All' doesn't working for 'Event's notifications tab</b><br>
 - [BZ 1474841](https://bugzilla.redhat.com/1474841) <b>can't click on Custom submenu by Preview snapshot</b><br>
 - [BZ 1457879](https://bugzilla.redhat.com/1457879) <b>Host reinstallation commands don't appear as tasks in Tasks tab in webadmin</b><br>
 - [BZ 1473171](https://bugzilla.redhat.com/1473171) <b>Do not check for updates for collectd-virt plugin</b><br>
 - [BZ 1468878](https://bugzilla.redhat.com/1468878) <b>multiple http.AuthnExtension fails</b><br>
 - [BZ 1467056](https://bugzilla.redhat.com/1467056) <b>Cluster creation via REST results in empty scheduling policy properties fields in the UI</b><br>
 - [BZ 1448798](https://bugzilla.redhat.com/1448798) <b>[TEXT] - Improve the error message when host-deploy reports an error</b><br>
 - [BZ 1442056](https://bugzilla.redhat.com/1442056) <b>Missing validation of option parameters for fence agents when using REST API</b><br>
 - [BZ 1464735](https://bugzilla.redhat.com/1464735) <b>Do not execute sql scripts as shell scripts</b><br>
 - [BZ 1460723](https://bugzilla.redhat.com/1460723) <b>Bump SpringFramework to 4.3.9</b><br>
 - [BZ 1452631](https://bugzilla.redhat.com/1452631) <b>specParams of memory devices 'size' and 'node' are of wrong type</b><br>
 - [BZ 1451230](https://bugzilla.redhat.com/1451230) <b>dialog for adding proxy in hosts Power management doesn't work properly</b><br>
 - [BZ 1438445](https://bugzilla.redhat.com/1438445) <b>Require boot protocol for a network that is set to be the Default Route network role</b><br>
 - [BZ 1451272](https://bugzilla.redhat.com/1451272) <b>enlarge default MAC pool of freshly-installed ovirt-engine</b><br>
 - [BZ 1434042](https://bugzilla.redhat.com/1434042) <b>[UI] - Highlight main tabs and sub tabs in the webadmin portal</b><br>
 - [BZ 1417201](https://bugzilla.redhat.com/1417201) <b>Updating a VM with 'next_run=true' returns the current memory instead of the next run memory</b><br>
 - [BZ 1416306](https://bugzilla.redhat.com/1416306) <b>Trying to import a Glance template with >40 chars long name should fail as an ERROR, not a WARNING</b><br>
 - [BZ 1395154](https://bugzilla.redhat.com/1395154) <b>Vm status via REST API does not reflect 'Copying disk' when a vm is imported with v2v</b><br>
 - [BZ 1434148](https://bugzilla.redhat.com/1434148) <b>Dropdown of Change CD dialog can't fit in</b><br>
 - [BZ 1418187](https://bugzilla.redhat.com/1418187) <b>Engine should stop sending the "display" legacy parameter to VDSM as part of the VM create api</b><br>
 - [BZ 1351215](https://bugzilla.redhat.com/1351215) <b>VM looses next run snapshot after second suspend</b><br>
 - [BZ 1378331](https://bugzilla.redhat.com/1378331) <b>Exception thrown immediately after logging in to user portal</b><br>
 - [BZ 1417940](https://bugzilla.redhat.com/1417940) <b>VM creation operations doesn't complete till the engine is restarted</b><br>

#### oVirt Host Deploy

 - [BZ 1494521](https://bugzilla.redhat.com/1494521) <b>cockpit is not started on deployed hosts</b><br>
 - [BZ 1471196](https://bugzilla.redhat.com/1471196) <b>Adding a new host in engine running on fedora 26 fails</b><br>
 - [BZ 1473163](https://bugzilla.redhat.com/1473163) <b>Do not install collectd-virt plugin</b><br>

#### oVirt Engine Dashboard

 - [BZ 1489467](https://bugzilla.redhat.com/1489467) <b>dashboard content from cards overflows with higher values</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1512534](https://bugzilla.redhat.com/1512534) <b>SHE deployment takes too much time and looks like stuck.</b><br>
 - [BZ 1485883](https://bugzilla.redhat.com/1485883) <b>hosted engine agent is not able to refresh hosted engine status when iso domain is not available after network outage</b><br>
 - [BZ 1378310](https://bugzilla.redhat.com/1378310) <b>Continuously restarting ha-agent breaks failover</b><br>
 - [BZ 1379250](https://bugzilla.redhat.com/1379250) <b>[TEXT] - A comment to vm.conf of the hosted engine</b><br>
 - [BZ 1525601](https://bugzilla.redhat.com/1525601) <b>Broker service fails to start after the straight upgrade of HE packages from 3.6 to 4.2</b><br>
 - [BZ 1524331](https://bugzilla.redhat.com/1524331) <b>HE VM can't start because incorrect value under vm.conf file</b><br>
 - [BZ 1518887](https://bugzilla.redhat.com/1518887) <b>ovirt-ha-agent fails parsing the OVF_STORE due to a change in OVF namespace URI</b><br>
 - [BZ 1488333](https://bugzilla.redhat.com/1488333) <b>ovirt-ha-agent fails connecting ovirt-ha-broker</b><br>

#### oVirt Engine Metrics

 - [BZ 1488014](https://bugzilla.redhat.com/1488014) <b>[RFE] Log the ansible metrics run to a log file</b><br>
 - [BZ 1475795](https://bugzilla.redhat.com/1475795) <b>[RFE] Parameterize fluentd Verbosity logs Level</b><br>
 - [BZ 1478695](https://bugzilla.redhat.com/1478695) <b>[RFE] Make collectd interval a parameter</b><br>
 - [BZ 1513418](https://bugzilla.redhat.com/1513418) <b>Cluster name is missing for host log records</b><br>
 - [BZ 1458700](https://bugzilla.redhat.com/1458700) <b>[RFE] Add postgres to the collectd processes plugin configuration</b><br>
 - [BZ 1477083](https://bugzilla.redhat.com/1477083) <b>[RFE] Add cluster name as a field to the hosts and vm records</b><br>
 - [BZ 1469104](https://bugzilla.redhat.com/1469104) <b>Remove host statistics collected from vdsm except for storage</b><br>
 - [BZ 1469119](https://bugzilla.redhat.com/1469119) <b>Disable collectd virt plugin</b><br>
 - [BZ 1468894](https://bugzilla.redhat.com/1468894) <b>warning message appears when running the metrics setup script regarding jinja2 templating</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1422535](https://bugzilla.redhat.com/1422535) <b>The default interface for management network configuration in the HE installation isn't the active interface</b><br>
 - [BZ 1467700](https://bugzilla.redhat.com/1467700) <b>The engine tries to auto-import the first SD named hosted_storage but this could fail due to leftovers on the host</b><br>
 - [BZ 1458739](https://bugzilla.redhat.com/1458739) <b>no-manual-page-for-binary ovirt-hosted-engine-cleanup</b><br>
 - [BZ 1356425](https://bugzilla.redhat.com/1356425) <b>[TEXT] 'hosted-engine --vm-start' said it destroyed the VM</b><br>
 - [BZ 1525854](https://bugzilla.redhat.com/1525854) <b>Upgrade appliance command fails after update of hosted-engine packages from 3.6 to 4.2</b><br>
 - [BZ 1522712](https://bugzilla.redhat.com/1522712) <b>OVEHOSTED_VM/cloudinitVMStaticCIDR will be set without CIDR</b><br>
 - [BZ 1467362](https://bugzilla.redhat.com/1467362) <b>Running HE CLI commands shows "Exception AttributeError"</b><br>

#### oVirt Log Collector

 - [BZ 1488630](https://bugzilla.redhat.com/1488630) <b>03_06_0620_create_fence_agents_table.sql:60: ERROR:  null value in column "agent_user" violates not-null constraint</b><br>
 - [BZ 1495267](https://bugzilla.redhat.com/1495267) <b>RFE: ovirt-log-collector-analyzer: hide fence passwords via switch</b><br>

#### oVirt Provider OVN

 - [BZ 1524520](https://bugzilla.redhat.com/1524520) <b>RHV network provider sync mechanism is not working</b><br>
 - [BZ 1510492](https://bugzilla.redhat.com/1510492) <b>OVN network status is constantly 'inactive' in CFME network provider UI</b><br>
 - [BZ 1399511](https://bugzilla.redhat.com/1399511) <b>Provider should support PUT method to allow update of subnet properties</b><br>
 - [BZ 1447875](https://bugzilla.redhat.com/1447875) <b>Create a conf.d for ovirt-provider-ovn configuration</b><br>
 - [BZ 1481985](https://bugzilla.redhat.com/1481985) <b>Token 'ServiceCatalog' returns incorrect URLs</b><br>
 - [BZ 1454694](https://bugzilla.redhat.com/1454694) <b>ovirt-provider-ovn-central firewalld service is no longer needed</b><br>

#### oVirt Release Package

 - [BZ 1464527](https://bugzilla.redhat.com/1464527) <b>[centos-qemu-ev-release] GPG key not found</b><br>
 - [BZ 1498745](https://bugzilla.redhat.com/1498745) <b>Add ovirt-cockpit-sso among dependencies</b><br>
 - [BZ 1495854](https://bugzilla.redhat.com/1495854) <b>Engine requires 'ovirt-host' package and failing to add ovirt-node-4.2</b><br>
 - [BZ 1488189](https://bugzilla.redhat.com/1488189) <b>Enable centos-release-scl-rh on el7 x86_64</b><br>
 - [BZ 1443965](https://bugzilla.redhat.com/1443965) <b>Libvirt is disabled on RHVH host</b><br>

#### oVirt Engine Appliance

 - [BZ 1406493](https://bugzilla.redhat.com/1406493) <b>Use livemedia-creator instead of image-tools</b><br>

#### oVirt Engine API Explorer

 - [BZ 1404753](https://bugzilla.redhat.com/1404753) <b>/api/model requires external access to https://fonts.googleapis.com</b><br>

### No Doc Update

#### oVirt Host Dependencies

 - [BZ 1518667](https://bugzilla.redhat.com/1518667) <b>ovirt-host causes repository closure error since glusterfs and ovirt-hosted-engine-setup are not available on ppc64le</b><br>
 - [BZ 1488064](https://bugzilla.redhat.com/1488064) <b>Package ovirt-provider-ovn-driver is not installed by default on hosts</b><br>

#### OTOPI

 - [BZ 1376008](https://bugzilla.redhat.com/1376008) <b>[RFE] otopi should be able to display a list of steps in the transaction at startup</b><br>
 - [BZ 1472325](https://bugzilla.redhat.com/1472325) <b>[RFE] clean up STAGE_BOOT priorities/schedule</b><br>

#### VDSM

 - [BZ 1448837](https://bugzilla.redhat.com/1448837) <b>Engine and vdsm complaining when trying to perform any SetupNetworks command on latest master vdsm</b><br>
 - [BZ 1454633](https://bugzilla.redhat.com/1454633) <b>mom continuously crashing on getVmInfo (mom/HypervisorInterfaces/vdsmjsonrpcInterface.py)     data['pid'] = vm['pid'] KeyError: 'pid'</b><br>
 - [BZ 1488416](https://bugzilla.redhat.com/1488416) <b>Command 'org.ovirt.engine.core.bll.AddUnmanagedVmsCommand' failed: null</b><br>
 - [BZ 1469109](https://bugzilla.redhat.com/1469109) <b>Stop sending hosts statistics to statsd except storage</b><br>
 - [BZ 1478054](https://bugzilla.redhat.com/1478054) <b>VM fails to run with all hooks</b><br>
 - [BZ 1472286](https://bugzilla.redhat.com/1472286) <b>RHEL7.4: libvirtError: internal error: unable to execute QEMU command 'device_del': Bus 'pci.0' does not support hotplugging</b><br>
 - [BZ 1457889](https://bugzilla.redhat.com/1457889) <b>Host is Non-Operational and missing networks after vdsm upgrade</b><br>
 - [BZ 1425596](https://bugzilla.redhat.com/1425596) <b>[RFE] Provide a way to correlate each 'run and protect' thread to its task</b><br>
 - [BZ 1425910](https://bugzilla.redhat.com/1425910) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1480949](https://bugzilla.redhat.com/1480949) <b>Regression with hotunplug vNIC</b><br>
 - [BZ 1477151](https://bugzilla.redhat.com/1477151) <b>Clean up old VM recovery information also by VM name</b><br>
 - [BZ 1454425](https://bugzilla.redhat.com/1454425) <b>No meaningful vdsm logging for 'wipe-after-delete' in RHV 4.1</b><br>
 - [BZ 1450132](https://bugzilla.redhat.com/1450132) <b>Add additional logging of LVM commands in VDSM</b><br>
 - [BZ 1437375](https://bugzilla.redhat.com/1437375) <b>getAllVmIoTunePolicies exceptions in VDSM</b><br>
 - [BZ 1422664](https://bugzilla.redhat.com/1422664) <b>Fix vdsm-tool register</b><br>
 - [BZ 1443347](https://bugzilla.redhat.com/1443347) <b>Adding rhvh-4.1-20170417.0 to engine failed with bond(active+backup) configured by cockpit</b><br>
 - [BZ 1497517](https://bugzilla.redhat.com/1497517) <b>host can't retrieve balloon info on vms</b><br>
 - [BZ 1483309](https://bugzilla.redhat.com/1483309) <b>startVM fails with OVN network</b><br>
 - [BZ 1437883](https://bugzilla.redhat.com/1437883) <b>RHV Manager sometimes shows a wrong value of CPU usage of host</b><br>
 - [BZ 1401281](https://bugzilla.redhat.com/1401281) <b>README.md refers to a non-existant 'INSTALL' file</b><br>
 - [BZ 1481217](https://bugzilla.redhat.com/1481217) <b>While adding NIC with port mirroring to VM and running the VM, port mirroring  doesn't configured on the  bridge</b><br>
 - [BZ 1481165](https://bugzilla.redhat.com/1481165) <b>Start VM with a disk resides on Gluster fails with 'UnsupportedType' error</b><br>
 - [BZ 1482034](https://bugzilla.redhat.com/1482034) <b>While updating the network vNIC profile to be with clean traffic ,and running the VM, IP parameters are not passed to the domxml</b><br>
 - [BZ 1472253](https://bugzilla.redhat.com/1472253) <b>Failed to clone VM from template because ImportError: No module named storage.volume</b><br>
 - [BZ 1458548](https://bugzilla.redhat.com/1458548) <b>[vdsm] Live storage migration fails on "libvirtError: Requested operation is not valid: domain is not transient" during diskReplicateStart</b><br>
 - [BZ 1442266](https://bugzilla.redhat.com/1442266) <b>VM paused with Improbable extension request messages during active layer block commit operation.</b><br>
 - [BZ 1444659](https://bugzilla.redhat.com/1444659) <b>AttributeError or OSError when trying to rename a directory if the destination directory exists and not empty</b><br>
 - [BZ 1428147](https://bugzilla.redhat.com/1428147) <b>"libvirt chain" message is not displayed in the vdsm logs by default during a live merge</b><br>
 - [BZ 1444657](https://bugzilla.redhat.com/1444657) <b>Error in top level error handler hiding real error</b><br>
 - [BZ 1443548](https://bugzilla.redhat.com/1443548) <b>Clone VM from snapshot fails with error = low level Image copy failed, code = 261</b><br>
 - [BZ 1426762](https://bugzilla.redhat.com/1426762) <b>Storage mailbox checksum failure when reading mail - no checksum on storage</b><br>
 - [BZ 1414862](https://bugzilla.redhat.com/1414862) <b>getVgInfo not returning updated information on allocated extents on a PV</b><br>
 - [BZ 1402880](https://bugzilla.redhat.com/1402880) <b>Hot-plugged memory devices are wrongly reported</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1425910](https://bugzilla.redhat.com/1425910) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>

#### imgbased

 - [BZ 1483871](https://bugzilla.redhat.com/1483871) <b>Raise RuntimeError("Failed to parse NVR: %s" % nvr) during install ovirt-node-ng 4.2</b><br>
 - [BZ 1429354](https://bugzilla.redhat.com/1429354) <b>[RFE] systemd-nspawn wrapper for imgbased</b><br>
 - [BZ 1368099](https://bugzilla.redhat.com/1368099) <b>Upgrade incorrect from build1 to other two new build2 and build3</b><br>
 - [BZ 1357247](https://bugzilla.redhat.com/1357247) <b>rhvh 4: reboot after install shows "4m[terminated]" and takes long to reboot</b><br>
 - [BZ 1433394](https://bugzilla.redhat.com/1433394) <b>kdump could fill up /var filesystem while writing to /var/crash</b><br>

#### oVirt Engine

 - [BZ 1517810](https://bugzilla.redhat.com/1517810) <b>Adding additional ha-host fails.</b><br>
 - [BZ 1479776](https://bugzilla.redhat.com/1479776) <b>After OVF generation HE VM can not start</b><br>
 - [BZ 1507834](https://bugzilla.redhat.com/1507834) <b>Engine duplicate template's nics on import template from export domain flow</b><br>
 - [BZ 1464044](https://bugzilla.redhat.com/1464044) <b>Missing task's substep names</b><br>
 - [BZ 1463971](https://bugzilla.redhat.com/1463971) <b>[UI] - Cannot create new Host QoS entity via the DC flow</b><br>
 - [BZ 1498465](https://bugzilla.redhat.com/1498465) <b>CPU Layer 3 cache needs to be enabled for high performance VMs</b><br>
 - [BZ 1502965](https://bugzilla.redhat.com/1502965) <b>Can't re-install host - engine complaining  that 'The provider type should be 'OpenStack Networking'.</b><br>
 - [BZ 1497916](https://bugzilla.redhat.com/1497916) <b>Host deploy failed - Failed to execute Ansible host-deploy role - TASK [ovirt-provider-ovn-driver : Configure OVN for oVirt]</b><br>
 - [BZ 1484961](https://bugzilla.redhat.com/1484961) <b>engine-setup fails in the setup of supplementary components without engine rpms</b><br>
 - [BZ 1491637](https://bugzilla.redhat.com/1491637) <b>Getting a java.lang.StackOverflowError exception while starting ovirt-engine</b><br>
 - [BZ 1493083](https://bugzilla.redhat.com/1493083) <b>UX: iSCSI import storage domains has missing grid</b><br>
 - [BZ 1464043](https://bugzilla.redhat.com/1464043) <b>Cloud-init network configuraton doesn't work</b><br>
 - [BZ 1435094](https://bugzilla.redhat.com/1435094) <b>[UI] - tooltips are missing on the new/edit vNIC profile dialog</b><br>
 - [BZ 1450460](https://bugzilla.redhat.com/1450460) <b>Unable to drag and drop vNuma to the Numa nodes when using Internet Explorer version 11</b><br>
 - [BZ 1480082](https://bugzilla.redhat.com/1480082) <b>[UI] - Port Mirroring indication is missing for the VM's vNIC info in the new UI</b><br>
 - [BZ 1479484](https://bugzilla.redhat.com/1479484) <b>VM with vNIC profile configured as passthrough fails to run on SR-IOV based host</b><br>
 - [BZ 1479794](https://bugzilla.redhat.com/1479794) <b>CPU pinning does not work</b><br>
 - [BZ 1464750](https://bugzilla.redhat.com/1464750) <b>[New UI] - New vNIC profile created on the wrong logical network</b><br>
 - [BZ 1439682](https://bugzilla.redhat.com/1439682) <b>'Pin VM to Host' dialog too short</b><br>
 - [BZ 1461476](https://bugzilla.redhat.com/1461476) <b>Extend sla architecture to consider hugepages-enabled VMs</b><br>
 - [BZ 1470554](https://bugzilla.redhat.com/1470554) <b>Adding fence agent through RESTApi fails with null pointer exception</b><br>
 - [BZ 1338799](https://bugzilla.redhat.com/1338799) <b>[RFE] Need UI element to view affinity labels in the VM and host dialog boxes</b><br>
 - [BZ 1468242](https://bugzilla.redhat.com/1468242) <b>Default DC & Cluster has fixed UUIDs</b><br>
 - [BZ 1414472](https://bugzilla.redhat.com/1414472) <b>RHV-M is not verifying the storage domain free space before running live merge</b><br>
 - [BZ 1438473](https://bugzilla.redhat.com/1438473) <b>choosing ovn-ovirt-provider in the engine-setup doesn't install any ovn packages</b><br>
 - [BZ 1438298](https://bugzilla.redhat.com/1438298) <b>[TEXT] - Clarify 'Experimental' Switch Type on Cluster Settings</b><br>
 - [BZ 1425910](https://bugzilla.redhat.com/1425910) <b>[RFE] JSON RPC broker should pass correlation id to VDSM</b><br>
 - [BZ 1438467](https://bugzilla.redhat.com/1438467) <b>engine-setup - choosing the ovn-ovirt-provider option as 'YES' cause the  url and provider type are switched in the database</b><br>
 - [BZ 1431228](https://bugzilla.redhat.com/1431228) <b>very slow update of host properties in RHEVM that has a cluster with 30 hosts and 40 networks</b><br>
 - [BZ 1394617](https://bugzilla.redhat.com/1394617) <b>ovirt-engine does not shut down cleanly</b><br>
 - [BZ 1400996](https://bugzilla.redhat.com/1400996) <b>Provide a mechanism to notify users that are using a deprecated version of the API</b><br>
 - [BZ 1517108](https://bugzilla.redhat.com/1517108) <b>[ALL_LANG except zh_CN, ko_KR] Table headers getting truncated on compute->virtual machines-> disks -> new -> direct LUN page.</b><br>
 - [BZ 1348139](https://bugzilla.redhat.com/1348139) <b>[ALL_LANGS except ko_KR, zh_CN] The UI alignment needs to be corrected on clusters->new->fencing policies page.</b><br>
 - [BZ 1511510](https://bugzilla.redhat.com/1511510) <b>WebAdmin: static content (under /webadmin/theme/00-ovirt.brand/ovirt-js-dependencies/...) does not seem to be cached</b><br>
 - [BZ 1510962](https://bugzilla.redhat.com/1510962) <b>Events are missing display all option</b><br>
 - [BZ 1356053](https://bugzilla.redhat.com/1356053) <b>[de_DE] The word "Deutsch" should not appear in welcome page's 'docs missing' message</b><br>
 - [BZ 1451413](https://bugzilla.redhat.com/1451413) <b>Introduce limit on repeating end method on command callbacks</b><br>
 - [BZ 1487728](https://bugzilla.redhat.com/1487728) <b>If VM is down and 'run_on_vds' is still set, errors are reported in engine and server logs</b><br>
 - [BZ 1479808](https://bugzilla.redhat.com/1479808) <b>vNIC profile custom properties: network 'queues' are not applied on the VM</b><br>
 - [BZ 1459765](https://bugzilla.redhat.com/1459765) <b>[hotplug memory] on hot plug failure the configured memory is updated right away</b><br>
 - [BZ 1439216](https://bugzilla.redhat.com/1439216) <b>Unable to allocate 32GB of RAM to Windows 10x64</b><br>
 - [BZ 1435140](https://bugzilla.redhat.com/1435140) <b>[ALL LANG] Need to localize a warning message on the welcome page 'unauthorized_client: Authentication required.'</b><br>
 - [BZ 1425323](https://bugzilla.redhat.com/1425323) <b>Don't display authorization provider name as a part of user name in users lists if it's displayed in specific authorization provider name column</b><br>
 - [BZ 1422428](https://bugzilla.redhat.com/1422428) <b>[fr-FR] Admin portal->Quota: measurements units are mixed up (GB in English and Go in French all mixed up).</b><br>
 - [BZ 1429021](https://bugzilla.redhat.com/1429021) <b>When trying to move a template's disk via Python SDK, error message placeholder is not resolved</b><br>
 - [BZ 1411572](https://bugzilla.redhat.com/1411572) <b>Snapshot deletion fails with error reported as "Drive image file could not be found"</b><br>
 - [BZ 1422455](https://bugzilla.redhat.com/1422455) <b>[ALL LANG] [User portal] User menu->Options dialog box tool tip messages are not localized</b><br>
 - [BZ 1356949](https://bugzilla.redhat.com/1356949) <b>[ALL_LANG] Check for upgrades related event is not translated properly</b><br>
 - [BZ 1314377](https://bugzilla.redhat.com/1314377) <b>Confusing message when the HE VM cannot be migrated to "failing" HE host</b><br>
 - [BZ 1492408](https://bugzilla.redhat.com/1492408) <b>[RFE] Admin Portal: About dialog should have a URL to www.ovirt.org</b><br>
 - [BZ 1512558](https://bugzilla.redhat.com/1512558) <b>"New VM" button naming inconsistent with the rest</b><br>
 - [BZ 1508819](https://bugzilla.redhat.com/1508819) <b>[UI] Setup Networks Multiple NICs - Keep the focus on the last NIC if attaching network to it</b><br>
 - [BZ 1462632](https://bugzilla.redhat.com/1462632) <b>[RFE][UI] - Add 'MTU' column to the 'Networks' main tab</b><br>
 - [BZ 1450161](https://bugzilla.redhat.com/1450161) <b>Engine can't be build if pip package isort is installed</b><br>
 - [BZ 1448867](https://bugzilla.redhat.com/1448867) <b>engine-setup: Re-enable SSL  for OVN north db connections</b><br>
 - [BZ 1433923](https://bugzilla.redhat.com/1433923) <b>[ALL LANG] [Admin Portal] The UI layout needs to be adjusted on data centers -> logical networks -> new page.</b><br>
 - [BZ 1408870](https://bugzilla.redhat.com/1408870) <b>Flood of endless exceptions in engine.log when host is non responsive (unknown cause)</b><br>
 - [BZ 1513005](https://bugzilla.redhat.com/1513005) <b>removing last vNIC by the VM selects the first one left, but selection is not visible</b><br>
 - [BZ 1506677](https://bugzilla.redhat.com/1506677) <b>Hotplug fail when attaching a disk with cow format on glusterfs</b><br>
 - [BZ 1497942](https://bugzilla.redhat.com/1497942) <b>[UI] - Events main view - Keep 'Refresh Interval' and 'Previous' 'Last' buttons static when scrolling events</b><br>
 - [BZ 1394160](https://bugzilla.redhat.com/1394160) <b>Creation of template from snapshot fails on CPU profile doesn't match cluster</b><br>
 - [BZ 1475845](https://bugzilla.redhat.com/1475845) <b>novnc doesn't work</b><br>
 - [BZ 1483863](https://bugzilla.redhat.com/1483863) <b>[UI] - Borders are missing for columns headers in Firefox 52 ESR</b><br>
 - [BZ 1510461](https://bugzilla.redhat.com/1510461) <b>[UI] - use PatternFly alert box for login errors on welcome page</b><br>
 - [BZ 1500424](https://bugzilla.redhat.com/1500424) <b>Breadcrumb in two lines in VM detail if capital letters are used for name</b><br>
 - [BZ 1505937](https://bugzilla.redhat.com/1505937) <b>press ESC in search form in breadcrumb causes ui error</b><br>
 - [BZ 1505710](https://bugzilla.redhat.com/1505710) <b>[UI] - Can't approve operation with 'enter' keyboard button in the setup networks dialog</b><br>
 - [BZ 1502244](https://bugzilla.redhat.com/1502244) <b>[UI] - DC > 'QoS' - Keep DC's action buttons and all DC's sub tabs static when scrolling</b><br>
 - [BZ 1501410](https://bugzilla.redhat.com/1501410) <b>Providers kebab menu is empty</b><br>
 - [BZ 1498187](https://bugzilla.redhat.com/1498187) <b>support automatic io threads+emulator threads pinning for  High Performance VMs</b><br>
 - [BZ 1496333](https://bugzilla.redhat.com/1496333) <b>[UI] - Edit/remove buttons are grayed out in the 'QoS' sub tab after creation and removal of a new QoS entity</b><br>
 - [BZ 1492740](https://bugzilla.redhat.com/1492740) <b>create snapshot disk dialog is empty</b><br>
 - [BZ 1492393](https://bugzilla.redhat.com/1492393) <b>request '/ovirt-engine/webadmin/theme/00-ovirt.brand/patternfly-functions-vertical-nav-custom-3.26.1.js produces 404</b><br>
 - [BZ 1491115](https://bugzilla.redhat.com/1491115) <b>Cast failure @ EventQueueMonitor: java.lang.Integer cannot be cast to java.lang.Long</b><br>
 - [BZ 1488929](https://bugzilla.redhat.com/1488929) <b>Add LUN storage domain via REST API is failing due to new required fields in the REST API</b><br>
 - [BZ 1479869](https://bugzilla.redhat.com/1479869) <b>Delete Cinder disk fails [due to jboss executor service change?]</b><br>
 - [BZ 1438513](https://bugzilla.redhat.com/1438513) <b>Preview of memory snapshot created in 4.1warns of reverting to cluster compatabilty ver 3.6</b><br>
 - [BZ 1488729](https://bugzilla.redhat.com/1488729) <b>Failed to create affinity group via REST API</b><br>
 - [BZ 1483971](https://bugzilla.redhat.com/1483971) <b>Allow removal of memory disks</b><br>
 - [BZ 1475892](https://bugzilla.redhat.com/1475892) <b>DR (site to site) - Add the ability to support detach of last master storage domain from data center</b><br>
 - [BZ 1483309](https://bugzilla.redhat.com/1483309) <b>startVM fails with OVN network</b><br>
 - [BZ 1486198](https://bugzilla.redhat.com/1486198) <b>[UI] - DC's QoS entities are followed to all other DCs when using the up/down keyboard buttons</b><br>
 - [BZ 1483433](https://bugzilla.redhat.com/1483433) <b>[UI] - Can't see the subnets of external network</b><br>
 - [BZ 1486555](https://bugzilla.redhat.com/1486555) <b>bad breadcrumb in storage domains</b><br>
 - [BZ 1483401](https://bugzilla.redhat.com/1483401) <b>Frequent traceback on MetadataDiskDescriptionHandler</b><br>
 - [BZ 1483584](https://bugzilla.redhat.com/1483584) <b>VM hibernation memory disks description is empty</b><br>
 - [BZ 1485951](https://bugzilla.redhat.com/1485951) <b>NullPointerException when viewing the images in ovirt-image-repository storage domain</b><br>
 - [BZ 1480086](https://bugzilla.redhat.com/1480086) <b>[UI] - oVirt logo is out of range in the new blue 'about' section</b><br>
 - [BZ 1482042](https://bugzilla.redhat.com/1482042) <b>[Memory hotplug] Mismatching values and units in memory hotplug</b><br>
 - [BZ 1483500](https://bugzilla.redhat.com/1483500) <b>Show the relevant VM info in memory disks description</b><br>
 - [BZ 1481217](https://bugzilla.redhat.com/1481217) <b>While adding NIC with port mirroring to VM and running the VM, port mirroring  doesn't configured on the  bridge</b><br>
 - [BZ 1484023](https://bugzilla.redhat.com/1484023) <b>Cpu Share doesn't work as expected</b><br>
 - [BZ 1478880](https://bugzilla.redhat.com/1478880) <b>creation date in templates disks subtab is in wrong format</b><br>
 - [BZ 1440101](https://bugzilla.redhat.com/1440101) <b>Host that lost network connectivity is not fenced</b><br>
 - [BZ 1482451](https://bugzilla.redhat.com/1482451) <b>[TEXT] Change message to match new UI (when importing an image)</b><br>
 - [BZ 1479752](https://bugzilla.redhat.com/1479752) <b>virtual/actual disks size in snapshot is not well formatted</b><br>
 - [BZ 1482033](https://bugzilla.redhat.com/1482033) <b>vGPU: custom properties mdev_type hook is not applied on VMs.</b><br>
 - [BZ 1479838](https://bugzilla.redhat.com/1479838) <b>Wrong matching for LUN disks</b><br>
 - [BZ 1481198](https://bugzilla.redhat.com/1481198) <b>While adding network QOS to NIC of the VM and running the VM, the values aren't configured on libvirt</b><br>
 - [BZ 1479764](https://bugzilla.redhat.com/1479764) <b>VM snapshots list-view highlighting not working</b><br>
 - [BZ 1477922](https://bugzilla.redhat.com/1477922) <b>When trying to download a disk that's attached to a running VM or a locked disk, using Python SDK, error message placeholder is not resolved</b><br>
 - [BZ 1464722](https://bugzilla.redhat.com/1464722) <b>[New UI] - Can't break bond after creation</b><br>
 - [BZ 1477042](https://bugzilla.redhat.com/1477042) <b>engine does not start due to trying to call non-existent callback.</b><br>
 - [BZ 1434348](https://bugzilla.redhat.com/1434348) <b>[UI] - Align 'Override display address' field in the new/edit Host dialog > 'Console' sub tab</b><br>
 - [BZ 1475966](https://bugzilla.redhat.com/1475966) <b>[webadmin automation] the IDs of all toolbar buttons are not static anymore</b><br>
 - [BZ 1475122](https://bugzilla.redhat.com/1475122) <b>RESTAPI- DELETE a storage connection from ISCSI SD in maintenance  - response 500 internal server error</b><br>
 - [BZ 1476191](https://bugzilla.redhat.com/1476191) <b>Export template to export domain failed with NPE</b><br>
 - [BZ 1475767](https://bugzilla.redhat.com/1475767) <b>Direct LUN should not have a PV ID</b><br>
 - [BZ 1475241](https://bugzilla.redhat.com/1475241) <b>Engine setup is failing on misc config</b><br>
 - [BZ 1388970](https://bugzilla.redhat.com/1388970) <b>webadmin: Move upload logic outside UploadImageModel</b><br>
 - [BZ 1468974](https://bugzilla.redhat.com/1468974) <b>[Scale] When the SPM changes the status of previously problematic domains to active, it queries vdsm once per each activated block domain instead of once per the whole process</b><br>
 - [BZ 1467794](https://bugzilla.redhat.com/1467794) <b>[Scale] When activating the first host in the data center, the engine queries vdsm once per each activated block domain instead of once per the whole process</b><br>
 - [BZ 1467781](https://bugzilla.redhat.com/1467781) <b>Can't import an existing block storage domain with Discard After Delete checked</b><br>
 - [BZ 1461932](https://bugzilla.redhat.com/1461932) <b>Upload image UI shows "C:\fakepath\disk_name" after selecting a disk to be uploaded in Chrome (55 and 59)</b><br>
 - [BZ 1400226](https://bugzilla.redhat.com/1400226) <b>Fix CommandsFactory logging to show original cause of the issue</b><br>
 - [BZ 1466070](https://bugzilla.redhat.com/1466070) <b>welcome page is now protected by login</b><br>
 - [BZ 1464296](https://bugzilla.redhat.com/1464296) <b>Command via API can cause host in Maintenance mode to be fenced</b><br>
 - [BZ 1458572](https://bugzilla.redhat.com/1458572) <b>engine-config can not set custom fencing parameters</b><br>
 - [BZ 1454821](https://bugzilla.redhat.com/1454821) <b>Search Query should not add the "IS NULL OR" part</b><br>
 - [BZ 1456268](https://bugzilla.redhat.com/1456268) <b>RESTAPI -  remove storage domain using a host in maintenance is allowed causing mount on SPM to not be removed</b><br>
 - [BZ 1463634](https://bugzilla.redhat.com/1463634) <b>Running the command logon on the VM via the REST failed</b><br>
 - [BZ 1464100](https://bugzilla.redhat.com/1464100) <b>Memory disks are not removed on snapshot deletion</b><br>
 - [BZ 1458659](https://bugzilla.redhat.com/1458659) <b>engine-setup doesn't stop engine service</b><br>
 - [BZ 1460694](https://bugzilla.redhat.com/1460694) <b>It's possible to issue multiple concurrent LSM commands on the same disk</b><br>
 - [BZ 1402048](https://bugzilla.redhat.com/1402048) <b>WARN org.ovirt.engine.core.bll.storage.disk.image.UploadDiskImageCommand Failed to stop image transfer session. Ticket does not exist for image ...</b><br>
 - [BZ 1460195](https://bugzilla.redhat.com/1460195) <b>[engine-backend] ExtendSANStorageDomain fails with NullPointerException in case the host is unreachable</b><br>
 - [BZ 1432127](https://bugzilla.redhat.com/1432127) <b>AuditLogDirector does not log messages if transactional command fails</b><br>
 - [BZ 1452988](https://bugzilla.redhat.com/1452988) <b>Block disk operations on disks containing memory dumps</b><br>
 - [BZ 1457810](https://bugzilla.redhat.com/1457810) <b>Fix logging issue in engine-config under EAP 7.0.6</b><br>
 - [BZ 1448399](https://bugzilla.redhat.com/1448399) <b>Listing storagedomains fails with 404</b><br>
 - [BZ 1455011](https://bugzilla.redhat.com/1455011) <b>RHV-M portal shows incorrect inherited permission for users</b><br>
 - [BZ 1443393](https://bugzilla.redhat.com/1443393) <b>Specify DC name on event notifying which host is the SPM</b><br>
 - [BZ 1452790](https://bugzilla.redhat.com/1452790) <b>Create snapshot window freezes</b><br>
 - [BZ 1450866](https://bugzilla.redhat.com/1450866) <b>Remove snapshot with multiple disks on the same SD fails with 'General command validation failure'</b><br>
 - [BZ 1451390](https://bugzilla.redhat.com/1451390) <b>Null pointer exception while updating cluster name</b><br>
 - [BZ 1450814](https://bugzilla.redhat.com/1450814) <b>Unable to edit the default OVN provider</b><br>
 - [BZ 1445263](https://bugzilla.redhat.com/1445263) <b>Snapshot remains in locked status after async delete using api (only when using async)</b><br>
 - [BZ 1445753](https://bugzilla.redhat.com/1445753) <b>The engine blocks deactivation of storage domain in Inactive (in problem) status</b><br>
 - [BZ 1443920](https://bugzilla.redhat.com/1443920) <b>Uninformative error message when attempting to reduce a lun from a file domain</b><br>
 - [BZ 1441858](https://bugzilla.redhat.com/1441858) <b>Previewing a snapshot creates a copy for each VM disk</b><br>
 - [BZ 1443645](https://bugzilla.redhat.com/1443645) <b>User can no longer use API having password with  special character "+".</b><br>
 - [BZ 1434696](https://bugzilla.redhat.com/1434696) <b>If group has assigned permission in engine and its name is updated on LDAP server, the group name is not updated within webadmin</b><br>
 - [BZ 1372516](https://bugzilla.redhat.com/1372516) <b>q35 cdrom sda and virtio-scsi sda duplicated error</b><br>
 - [BZ 1435115](https://bugzilla.redhat.com/1435115) <b>[UI] - Right click mouse menu is very small and out of proportions</b><br>
 - [BZ 1434056](https://bugzilla.redhat.com/1434056) <b>Placeholders for product name is not rendered in API documentation</b><br>
 - [BZ 1430243](https://bugzilla.redhat.com/1430243) <b>disk image upload fails (network error)</b><br>
 - [BZ 1408578](https://bugzilla.redhat.com/1408578) <b>Image upload using python sdk: Can't find relative path for class "org.ovirt.engine.api.resource.ImagesResource", will return null</b><br>

#### oVirt Host Deploy

 - [BZ 1464199](https://bugzilla.redhat.com/1464199) <b>drop m2crypto requirements on ovirt-host-deploy execution</b><br>
 - [BZ 1425447](https://bugzilla.redhat.com/1425447) <b>[RFE] allow installing realtime kernel and kvm</b><br>
 - [BZ 1512621](https://bugzilla.redhat.com/1512621) <b>Misleading error message as "Failed to install Host. HA client was not imported" while adding additional HE host</b><br>
 - [BZ 1460954](https://bugzilla.redhat.com/1460954) <b>vdsm-client package install fails on older (3.6 compat) nodes</b><br>

#### oVirt Engine Dashboard

 - [BZ 1510524](https://bugzilla.redhat.com/1510524) <b>dropdown menu for refresh interval in dashboard is not visible</b><br>
 - [BZ 1451485](https://bugzilla.redhat.com/1451485) <b>[RFE] [CodeChange] Consume PatternFly styling via official npm package</b><br>
 - [BZ 1353102](https://bugzilla.redhat.com/1353102) <b>[RFE][CodeChange] Translations should be verified automatically</b><br>

#### ovirt-engine-dwh

 - [BZ 1474570](https://bugzilla.redhat.com/1474570) <b>Cannot change dwh sampling scale with 'engine-setup --reconfigure-dwh-scale'</b><br>
 - [BZ 1431632](https://bugzilla.redhat.com/1431632) <b>[TEXT][RFE] Display Data Warehouse requirement during setup better</b><br>
 - [BZ 1492065](https://bugzilla.redhat.com/1492065) <b>error by upgrading dwh 4.1 on separate machine</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1479776](https://bugzilla.redhat.com/1479776) <b>After OVF generation HE VM can not start</b><br>
 - [BZ 1393922](https://bugzilla.redhat.com/1393922) <b>[CodeChange][RFE] ovirt-hosted-engine-ha: rebase on the new jsonrpc client</b><br>
 - [BZ 1457468](https://bugzilla.redhat.com/1457468) <b>Broker logs need a major improvement</b><br>
 - [BZ 1478848](https://bugzilla.redhat.com/1478848) <b>Use migration profile in HE maintenance migration</b><br>
 - [BZ 1487915](https://bugzilla.redhat.com/1487915) <b>Deployment of SHE fails with 'NoneType' object has no attribute 'values'.</b><br>

#### oVirt Engine Metrics

 - [BZ 1475707](https://bugzilla.redhat.com/1475707) <b>Ansible should configure the engine, even when all of the nodes failed to be configured</b><br>
 - [BZ 1471949](https://bugzilla.redhat.com/1471949) <b>[RFE] refactor the collectd configuration files 20-builtins-conf-for-ovirt-engine.conf and 20-builtins-conf-for-ovirt.conf so they will be more readable</b><br>
 - [BZ 1477866](https://bugzilla.redhat.com/1477866) <b>[RFE] Update swap collectd plugin configuration</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1517810](https://bugzilla.redhat.com/1517810) <b>Adding additional ha-host fails.</b><br>
 - [BZ 1434209](https://bugzilla.redhat.com/1434209) <b>[TEXT] Error message is confusing when hosted-engine Storage Domain can't be mounted</b><br>
 - [BZ 1461083](https://bugzilla.redhat.com/1461083) <b>Use ovirt-host package for pulling in needed dependencies</b><br>
 - [BZ 1512472](https://bugzilla.redhat.com/1512472) <b>"hosted-engine --deploy --ansible" deployment fails.</b><br>
 - [BZ 1487915](https://bugzilla.redhat.com/1487915) <b>Deployment of SHE fails with 'NoneType' object has no attribute 'values'.</b><br>
 - [BZ 1426581](https://bugzilla.redhat.com/1426581) <b>Remove qemu-kvm-tools dependency</b><br>

#### oVirt Log Collector

 - [BZ 1460734](https://bugzilla.redhat.com/1460734) <b>traceback on hosts sos report failure</b><br>
 - [BZ 1441258](https://bugzilla.redhat.com/1441258) <b>[RFE] remove dot from the ovirt-log-collector generated file</b><br>

#### oVirt Scheduler Proxy

 - [BZ 1494390](https://bugzilla.redhat.com/1494390) <b>On a clean CentOS 7.4 minimal, yum install ovirt-scheduler-proxy fails</b><br>

#### oVirt Provider OVN

 - [BZ 1489321](https://bugzilla.redhat.com/1489321) <b>ERROR [org.ovirt.engine.core.bll.provider.network.GetExternalSubnetsOnProviderByNetworkQuery]</b><br>
 - [BZ 1490104](https://bugzilla.redhat.com/1490104) <b>vdsm-tool does not start required services before configuring the host</b><br>
 - [BZ 1490092](https://bugzilla.redhat.com/1490092) <b>OVN network subnet without DNS or gateway unexpected behaviour</b><br>
 - [BZ 1466181](https://bugzilla.redhat.com/1466181) <b>ovn-controller is not configured to start at boot</b><br>
 - [BZ 1456236](https://bugzilla.redhat.com/1456236) <b>Typo in OVN configuration file</b><br>
 - [BZ 1448682](https://bugzilla.redhat.com/1448682) <b>Change file permissions on OVN configuration file</b><br>
 - [BZ 1509664](https://bugzilla.redhat.com/1509664) <b>Token creation results in HTTP code 201 where it should be 200 (for CFME)</b><br>
 - [BZ 1447885](https://bugzilla.redhat.com/1447885) <b>Change default authentication type in ovirt-provider-ovn.conf to authentication by username</b><br>

#### oVirt Release Package

 - [BZ 1427045](https://bugzilla.redhat.com/1427045) <b>Missing RPM for "tested" yum repo</b><br>
 - [BZ 1415705](https://bugzilla.redhat.com/1415705) <b>Repository virtio-win-stable is listed more than once in the configuration</b><br>
 - [BZ 1409743](https://bugzilla.redhat.com/1409743) <b>stop relaseing qemu-kvm-ev in ovirt repos</b><br>

#### oVirt Engine Appliance

 - [BZ 1467946](https://bugzilla.redhat.com/1467946) <b>rhvm-appliance only partitions 6gb for root partition</b><br>

#### MOM

 - [BZ 1454633](https://bugzilla.redhat.com/1454633) <b>mom continuously crashing on getVmInfo (mom/HypervisorInterfaces/vdsmjsonrpcInterface.py)     data['pid'] = vm['pid'] KeyError: 'pid'</b><br>

