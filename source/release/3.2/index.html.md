---
title: OVirt 3.2 release notes
authors: cheryntan, shireesh, theron, vered
wiki_title: OVirt 3.2 release notes
wiki_revision_count: 11
wiki_last_updated: 2013-03-14
---

# OVirt 3.2 release notes

The oVirt Project is pleased to announce the availability of its second formal release, oVirt 3.2.

## What's New?

The oVirt 3.2 release includes these notable changes.

## Installer

*   The Application Mode option has been added to the engine-setup script, which prompts users to configure the engine for virtualization management only, Gluster management only, or both.
*   oVirt nodes and Fedora hosts can be registered to the oVirt engine from the administration portal without using the HTTP(s) protocol.
*   The CA certificate for the web administration portal is now acquired from the TLS/SSL handshake during the VDSM registration process, replacing the previous method of downloading a self-signed certificate from the oVirt Engine. This separates between the CA certificates issued for VDSM and the web administration portal.

## Storage

*   engine-log-collector can now collect Gluster logs from hosts belonging to a Gluster-enabled clusters, under the /var/log/gluster/\* directory.
*   Previously, it was not possible to remove a host from a Gluster-enabled cluster if the host had any volume bricks on it, or if the host was non-responsive. Now, hosts can be forcefully removed from a Gluster cluster, and when all hosts are removed, the engine removes the host entries and Gluster volumes from the database.
*   Cluster configuration changes made in the Gluster command line shell are now automatically synced with the oVirt Engine database, and reported in the oVirt web administration portal (http://www.ovirt.org/Features/Gluster_Sync_Configuration_With_CLI).
*   Support has been added for importing existing Gluster supported clusters to the oVirt Engine. All hosts in the cluster are imported, and the bootstrap script installs all necessary VDSM packages on the hosts (http://www.ovirt.org/Features/Gluster_Import_Existing_Cluster).
*   Support has been added for storage live migration. This allows migration of virtual machine disks to different storage devices without first shutting down the virtual machine (http://wiki.ovirt.org/wiki/Features/Design/StorageLiveMigration).
*   Support has been added for storage domain live upgrade. This allows upgrades from old data center types to the new V3 domain while virtual machines are running (http://www.ovirt.org/Features/StorageDomainLiveUpgrade).

## Performance

*   The performance of the SSL communication between the oVirt Engine and VDSM has been improved with the implementation of SSL session caching, as the engine does not have to perform a new SSL handshake for each request.
*   oVirt Engine now uses the PKCS#12 format to store keys, replacing the previous Java Key Store format. The PKCS#12 format separates the engine as client key usage and engine as server key usage to support third party certificates for the web administration and user portals (http://www.ovirt.org/Features/PKI_Improvements).
*   Improvements have been made to the quota implementation, including its logic, calculation, and monitoring. Details can be found at <http://www.ovirt.org/Features/Quota-3.2>.

## Infrastructure

*   Memory Overcommit Manager (MOM) is enabled by default for hosts. It provides the ability to manage memory ballooning and Kernel Same-page Merging (KSM) of the Linux kernel (http://www.ovirt.org/SLA-mom).
*   Support has been added for the Windows 8, Windows 8 x64, and Windows 2012 virtual machine operating systems, including sysprep images and product keys.
*   Support has been added for virtualization hosts with Intel Haswell and Opteron G5 based CPUs.
*   Host logs can now be collected from the /var/log/ovirt-engine/host-deploy directory on the engine, and also from the /tmp/ovirt-host-deploy directory on the host.
*   Previously, a virtual machine could not pass a payload using a CD if it already had a CD attached from the ISO domain. Now, the virtual machine can run with a CD from the ISO domain and with a payload CD at the same time.
*   Support has been added for live snapshots. Snapshots of a virtual machine can now be created without first having to stop it.
*   Smartcard support has been added for virtual machines. Users can pass smartcards to virtual machines using the administration portal, user portal, or REST API (http://www.ovirt.org/Features/Smartcard_support).
*   Support has been added for deploying custom user interface (UI) plugins for the administration portal. The administration portal supports plugins written in JavaScript, and directly invokes the plugins on the web browser (www.ovirt.org/Features/UIPlugins).

## User Interface

*   The "Disks" tab has been added under the "Storage" tab, allowing users to easily view, add or remove disks from each storage domain.
*   Support has been added for UTF8 characters including names and descriptions of virtual machines, templates, snapshots, and disk aliases.
*   Users can now change the auto-generated name of a virtual machine that was created as part of a pool. This can be done by using the 'Edit Virtual Machine' window.
*   A new "Network" tab has been added to the main resource tabs, and a "Networks" entry has been added to the Tree pane. Users can now search for networks using the web administration portal or the REST API (http://wiki.ovirt.org/Feature/NetworkMainTab).
*   New administrative and user permissions have been added for networks, which can be granted from the web administration portal or the REST API (http://wiki.ovirt.org/Feature/NetworkPermissions).
*   A delete protection entity has been added for virtual machines and templates. When it is enabled in the web administration portal or REST API, the virtual machine or template cannot be deleted.
*   Users can now view advanced details on Gluster volumes, including the services running in the hosts of the cluster and volume brick details (http://www.ovirt.org/Features/GlusterVolumeAdvancedDetails).

## Networking

*   Users can now dynamically change the network of a running virtual machine without unplugging the virtual network interface card (vNIC), and maintain the device address of the vNIC (http://wiki.ovirt.org/Feature/NetworkLinking).
*   The Guest Agent now reports the IP addresses and internal name of the vNIC to the oVirt Engine (http://wiki.ovirt.org/Feature/ReportingVnicImplementation).
