---
title: oVirt 3.2 release notes
authors: cheryntan, shireesh, theron, vered
---

# oVirt 3.2 release notes

The oVirt Project is pleased to announce the availability of its third formal release, oVirt 3.2.

## What's New in 3.2.1?

New RPMS are now uploaded for oVirt 3.2.1. The updates included:

      ovirt-engine-cli 3.2.0.11-1
      ovirt-engine-sdk 3.2.0.10-1
      ovirt-engine 3.2.1-1

<big>**oVirt Engine changes:**</big>

*   Fixed bug blocking firewalld configuration when selinux was in enforcing mode
*   Small change in All-In-One
*   Minor patches at rest-api

Also included in the oVirt Engine update are patches to enable EL6 builds.

*To upgrade, please run engine-upgrade.*

## What's New in 3.2?

The oVirt 3.2 release includes these notable changes.

### Installer

*   The Application Mode option has been added to the engine-setup script, which prompts users to configure the engine for virtualization management only, Gluster management only, or both.
*   oVirt nodes and Fedora hosts can be registered to the oVirt engine from the administration portal without using the HTTP(s) protocol.
*   The CA certificate for the web administration portal is now acquired from the TLS/SSL handshake during the VDSM registration process, replacing the previous method of downloading a self-signed certificate from the oVirt Engine. This separates between the CA certificates issued for VDSM and the web administration portal.
*   VDSM now uses tuned profiles for virtual hosts. Upon host installation, the installation script changes the host profile to 'virtual-host', which improves host performance.
*   Users can now remove virtual machines while leaving the virtual machine disks as floating disks. This is only applicable when the virtual disks have no snapshots, and when the virtual machine is not based on a template.
*   The oVirt Engine now performs a DNS lookup and automatically finds a suitable Java Virtual Machine (JVM) during setup, replacing the previous behaviour of hardcoding the JVM location to the data center configuration file.

### Storage

*   engine-log-collector can now collect Gluster logs from hosts belonging to a Gluster-enabled clusters, under the /var/log/gluster/\* directory.
*   Previously, it was not possible to remove a host from a Gluster-enabled cluster if the host had any volume bricks on it, or if the host was non-responsive. Now, hosts can be forcefully removed from a Gluster cluster, and when all hosts are removed, the engine removes the host entries and Gluster volumes from the database.
*   Cluster configuration changes made in the Gluster command line shell are now automatically synced with the oVirt Engine database, and reported in the oVirt web administration portal ([Features/Gluster_Sync_Configuration_With_CLI](/develop/release-management/features/gluster/gluster-sync-configuration-with-cli.html)).
*   Support has been added for importing existing Gluster supported clusters to the oVirt Engine. All hosts in the cluster are imported, and the bootstrap script installs all necessary VDSM packages on the hosts ([Features/Gluster_Import_Existing_Cluster](/develop/release-management/features/gluster/gluster-import-existing-cluster.html)).
*   Support has been added for storage live migration. This allows migration of virtual machine disks to different storage devices without first shutting down the virtual machine ([Features/Design/StorageLiveMigration](/develop/release-management/features/storage/storagelivemigration.html)).
*   Support has been added for storage domain live upgrade. This allows upgrades from old data center types to the new V3 domain while virtual machines are running ([Features/StorageDomainLiveUpgrade](/develop/release-management/features/storage/storagedomainliveupgrade.html)).
*   Gluster volumes can now be optimized for virtualization. This can be done using the "Optimize for Virt Store" button on the "Volumes" tab of the engine administration portal.

**Note:** Gluster management features in oVirt 3.2 require glusterfs version 3.4.0. At the time of oVirt 3.2 release, glusterfs 3.4.0 is still under testing. The latest QA release of glusterfs 3.4.0 can be obtained from the yum repository <http://bits.gluster.org/pub/gluster/glusterfs/stage.repo>

### Infrastructure

*   Support has been added for the Windows 8, Windows 8 x64, and Windows 2012 virtual machine operating systems, including sysprep images and product keys.
*   Support has been added for virtualization hosts with Intel Haswell and Opteron G5 based CPUs.
*   Host logs can now be collected from the /var/log/ovirt-engine/host-deploy directory on the engine, and also from the /tmp/ovirt-host-deploy directory on the host.
*   Previously, a virtual machine could not pass a payload using a CD if it already had a CD attached from the ISO domain. Now, the virtual machine can run with a CD from the ISO domain and with a payload CD at the same time.
*   Support has been added for live snapshots. Snapshots of a virtual machine can now be created without first having to stop it.
*   Smartcard support has been added for virtual machines. Users can pass smartcards to virtual machines using the administration portal, user portal, or REST API ([Features/Smartcard_support](/develop/release-management/features/virt/smartcard-support.html)).
*   Support has been added for deploying custom user interface (UI) plugins for the administration portal. The administration portal supports plugins written in JavaScript, and directly invokes the plugins on the web browser.
*   Support has been added for a certified cloud provider inventory report. This report displays a list of virtual machines organised by operating system, data center, or cluster; and each virtual machine's respective uptime and existence time.
*   Support has been added for a user SPICE session activity report. This report displays time spent and resources used during each SPICE session in a selected data center and cluster and within a selected period.
*   The history database now reports the inventory of storage domains, including name, type, vendor, operating system, version, IP address, status, and capacity.
*   Scripts are now able to communicate with multiple oVirt Engine servers by creating and manipulating separate instances of the ovirtsdk.API Python class.
*   A new feature is available that supports enabling and disabling of ovirt-engine-cli paging of a returned response. Page disabling is done using 'no_paging = True'.

### Performance

*   The performance of the SSL communication between the oVirt Engine and VDSM has been improved with the implementation of SSL session caching, as the engine does not have to perform a new SSL handshake for each request.
*   oVirt Engine now uses the PKCS#12 format to store keys, replacing the previous Java Key Store format. The PKCS#12 format separates the engine as client key usage and engine as server key usage to support third party certificates for the web administration and user portals ([Features/PKI_Improvements](/develop/release-management/features/infra/pki-improvements.html)).
*   Memory Overcommit Manager (MOM) is enabled by default for hosts. It provides the ability to manage memory ballooning and Kernel Same-page Merging (KSM) of the Linux kernel ([SLA-mom](/develop/release-management/features/sla/sla-mom.html)).

### Virtualization

*   Improvements have been made to the quota implementation, including its logic, calculation, and monitoring. Details can be found at [Features/Quota-3.2](/develop/release-management/features/sla/quota-3.2.html).
*   Clusters can now be configured to treat host CPU threads as cores for the purposes of virtual machine resource allocation and migration. This replaces the previous behaviour where VDSM only reported physical cores by default, and users could manually force VDSM to report host threads instead of physical cores.
*   VDSM hooks have been added for hot plugging and unplugging network interface cards.
*   Virtual machines can now utilize the host's CPU flags, which enables better performance in virtual machines. However, as this option provides the host's CPU capabilities to the virtual machine's CPU, virtual machines with this option enabled cannot be migrated to hosts of a different CPU model ([Features/Cpu-host_Support](/develop/release-management/features/sla/cpu-host-support.html)).
*   This release introduces OvfAutoUpdater, which performs periodic updates for multiple OVFs in a data center using a single VDSM call, resulting in faster execution of virtual machine operations.

### User Interface

*   The "Disks" tab has been added under the "Storage" tab, allowing users to easily view, add or remove disks from each storage domain.
*   Support has been added for UTF8 characters including names and descriptions of virtual machines, templates, snapshots, and disk aliases.
*   Users can now change the auto-generated name of a virtual machine that was created as part of a pool. This can be done by using the 'Edit Virtual Machine' window.
*   A new "Network" tab has been added to the main resource tabs, and a "Networks" entry has been added to the Tree pane. Users can now search for networks using the web administration portal or the REST API ([Feature/NetworkMainTab](/develop/release-management/features/network/networkmaintab.html)).
*   New administrative and user permissions have been added for networks, which can be granted from the web administration portal or the REST API ([Feature/NetworkPermissions](/develop/release-management/features/network/networkpermissions.html)).
*   A delete protection entity has been added for virtual machines and templates. When it is enabled in the web administration portal or REST API, the virtual machine or template cannot be deleted.
*   Users can now view advanced details on Gluster volumes, including the services running in the hosts of the cluster and volume brick details ([Features/GlusterVolumeAdvancedDetails](/develop/release-management/features/gluster/glustervolumeadvanceddetails.html)).
*   Quota information has been added to the Resources pane in the user portal, so users can monitor vCPU, memory, and storage consumption ([Features/Quota-3.2](/develop/release-management/features/sla/quota-3.2.html)).
*   oVirt Engine now retrieves and displays host BIOS information when a host is added to the engine ([Features/Design/HostBiosInfo](/develop/release-management/features/infra/hostbiosinfo.html)).
*   The web reports portal now displays the number of storage domains in each data center and throughout the system.

### Networking

*   Users can now dynamically change the network of a running virtual machine without unplugging the virtual network interface card (vNIC), and maintain the device address of the vNIC ([Feature/NetworkLinking](/develop/release-management/features/network/networklinking.html)).
*   The Guest Agent now reports the IP addresses and internal name of the vNIC to the oVirt Engine ([Feature/ReportingVnicImplementation](/develop/release-management/features/network/reportingvnicinformation.html)).

### Power Management

*   Previously, when hosts could not connect to the storage pool, oVirt Engine triggered the reconstruct master to increase the version number of the master domain, so the master domain can be used to synchronize between hosts and storage. However, the master domain version increase was not reflected on the host side, so the domain mismatch prevented hosts from connecting to the storage pool. Now, when the reconstruct is performed, the master domain version is increased on both the host and storage sides. When the reconstruct is successful, the hosts will connect to storage and return to an 'Up' state.
*   Host power management policies have been improved. Users can define each host's priority to act as a proxy for fencing operations, by default a non-operational host will search for a proxy within its own cluster, and then within its data center ([Features/Design/DetailedHostPMProxyPreferences](/develop/release-management/features/infra/detailedhostpmproxypreferences.html)).
*   Dual-power hosts can now support two power management agents connected to the same power switch. The agents can be used concurrently (either agent can fence a host) or sequentially (if one agent fails, the other is used). See [Features/Design/DetailedHostPMMultipleAgents](/develop/release-management/features/infra/detailedhostpmmultipleagents.html) for implementation details.
*   Support has been added for iLo2 and iLo4 power management devices.
