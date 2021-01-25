---
title: oVirt 3.1 release notes
authors: abonas, amureini, danken, dneary, jbrooks, nkesick, roy, sgordon, val0x00ff
---

# oVirt 3.1 release notes

The oVirt Project is pleased to announce the availability of its second formal release, oVirt 3.1.

## What's New?

The oVirt 3.1 release includes these notable changes.

### Installer

*   The installation script now supports the configuration of a HTTP/HTTPS proxy, allowing the oVirt Engine to be accessed via port 80 for HTTP, and port 443 for HTTPS.
*   The oVirt Engine now supports the use of a remote PostgreSQL database server, specified during installation ([Features/RemoteDB](/develop/release-management/features/integration/remotedb.html)).
*   An 'all-in-one' proof of concept mode is now available. This allows a single machine to both run the management engine and act as a virtualization host ([Feature/AllInOne](/develop/release-management/features/integration/allinone.html)).

### Tools

*   The Log Collector (engine-log-collector), ISO Uploader (engine-iso-uploader), and Image Uploader (engine-image-uploader) have been rebased to access the oVirt Engine using the new Python SDK. Previously these tools, written in Python, accessed the REST API directly.

### Infrastructure

*   The oVirt Engine is now supports the use of Red Hat Directory Server and/or IBM Tivoli Directory Server for user authentication. This is addition to existing support for IPA and Active Directory.
*   An additional tab has been added to the oVirt Engine's management interface to support monitoring the status of tasks in the oVirt Environment.
*   A correlation identifier to support debugging is now used to track events across the user interfaces, engine backend, and VDSM.
*   The oVirt Engine now automatically attempts to auto-activate hosts detected as non-operational.

### User Interface

*   Infrastructure supporting localization has been added, with translations to follow in a later release.
*   Infrastructure supporting integration of reports functionality has been added to the oVirt Engine management interface.

### Storage

*   Support has been added for presenting any block device as a local disk attached to a virtual machine simply by specifying the device's GUID. This provides **directlun** support, which previously had to be implemented using a VDSM hook ([Features/Direct_Lun](/develop/release-management/features/storage/direct-lun.html)).
*   Support has been added to VDSM, and by extension oVirt Engine, for the attachment and use of NFSv4 storage ([Features/NFSv4)](/develop/release-management/features/storage/nfsv4.html)).
*   It is now possible to override some of VDSM's default NFS settings from the oVirt Engine when attaching storage ([Features/AdvancedNfsOptions](/develop/release-management/features/storage/advancednfsoptions.html)).
*   Support has been added for the attachment and use of POSIX filesystem compliant storage, allowing users to attach any type of storage supported by **mount** ([Features/PosixFSConnection](/develop/release-management/features/storage/posixfsconnection.html)).
*   Support for defining the priority of hosts in the storage pool manager (SPM) selection process has been added. Hosts can also be assigned a priority of **-1**m which means that they must not be selected as the SPM ([Features/SPMPriority](/develop/release-management/features/storage/spmpriority.html)).
*   Support has been added for sharing of disks between virtual machines. Previously each disk could only be attached to a single virtual machine, it is now possible to share a disk between multiple virtual machines concurrently ([Features/SharedRawDisk](/develop/release-management/features/storage/sharedrawdisk.html)).
*   Support has been added for hot plugging and unplugging of **virtio-blk** disks to and from virtual machines If the "Add" menu command in the virtual disks pane of a running VM is disabled, a disk may be added from the VM "Guide Me" dialog) ([Features/HotPlug](/develop/release-management/features/storage/hotplugdisk.html)).
*   Support has been added for floating disks, disks which are not necessarily attached to a virtual machine at any one point in time but can be attached to virtual machines as and when needed. Floating disks can be found in the web administration portal under the **Disks** tab ([Features/FloatingDisk](/develop/release-management/features/storage/floatingdisk.html)).
*   It is now possible for virtual machines to have their disks spread across multiple storage domains within the same data center. Previously all disks attached to a virtual machine had to reside on the same storage domain ([Features/MultipleStorageDomains](/develop/release-management/features/storage/multiplestoragedomains.html)).
*   Initial support has been added for provisioning and managing Gluster based storage clusters in oVirt. See [Features/Gluster_Support](/develop/release-management/features/gluster/gluster-support.html) for implementation details and known issues.

### Virtualization

*   Previously it was not possible to import a Virtual Machine or Template that had already been imported, even if it was to a different data center. This is no longer the case ([Features/ImportMoreThanOnce](/develop/release-management/features/storage/importmorethanonce.html)).
*   Devices attached to guest virtual machines now retain the same address allocations as other devices are added and/or removed from the guest's configuration ([Features/Design/DetailedStableDeviceAddresses](/develop/release-management/features/ux/detailedstabledeviceaddresses.html)).
*   Support for "pre-started" virtual machine pools has been added. Instead of having to wait for a virtual machine allocated from the pool to boot user's will instead, where possible, be allocated a virtual machine which has already been started ([Features/PrestartedVm](/develop/release-management/features/virt/prestartedvm.html)).
*   Support for virtual machine payloads has been added, in the form of a Floppy or CD/DVD image that will be passed to the virtual machine. Virtual machine payloads may be either temporary or permanent.([Features/VMPayload](/develop/release-management/features/virt/vmpayload.html)).
*   Added support for cloning a Virtual Machine from a specific Snapshot ([Features/CloneVmFromSnapshot](/develop/release-management/features/virt/clonevmfromsnapshot.html)).
*   Support has been added for virtualization hosts with Intel Sandybridge and Opteron G4 based CPUs.

<!-- -->

*   "windows" and "linux" OS Types are removed from the OS repository as they have no real use. This will break import of those OSs. To fix the import its enough to add to *$PREFIX/etc/ovirt-engine/osinfo.conf.d/20-import-export-linux-windows-fix.properties*

       20-import-export-linux-windows-fix.properties:
       backwardCompatibility.linux = 5
       backwardCompatibility.windows = 1

### SLA

*   Added support for the definition quotas restricting user resource usage ([Features/Quota](/develop/release-management/features/sla/quota.html)).
*   Added support for pinning Virtual Machines to specific physical CPUs ([Features/Design/cpu-pinning](/develop/sla/cpu-pinning.html)).

### Network

*   A new network setup API to support complex network provisioning tasks has been added to the backend, as a result the user interface for host network setup has also been redesigned ([Features/Design/Network/SetupNetworks](/develop/release-management/features/network/setupnetworks.html)).
*   It is now possible to adjust the MTU of a logical network, when it is not attached to a cluster ([Features/Network/Jumbo_frames](/develop/release-management/features/network/jumbo-frames.html)).
*   It is now possible to create bridgeless logical networks, previously all logical network were represented using a bridge ([Features/Design/Network/Bridgeless_Networks](/develop/release-management/features/network/bridgeless-networks.html)).
*   Hot plugging and unplugging of virtual Network Interface Cards from virtual machines is now supported ([Features/HotplugNic](/develop/release-management/features/network/hotplugnic.html)).
*   ~~Support for port mirroring, allowing all network traffic to be mirrored to a specific virtual machine, has been added ([Features/PortMirroring](/develop/release-management/features/network/portmirroring.html)).~~ (postponed to Ovirt-3.2)
*   Previously, all logical networks were considered mandatory for all hosts in a cluster. Hosts that were not attached to all logcal networks in the cluster were marked non-responsive. Administrators now have the option to mark specific logical networks as non-mandatory, bypassing this behavior ([Features/Design/Network/Required_Networks](/develop/release-management/features/network/required-networks.html)).

### Interfaces

*   New Python SDK, packaged as *ovirt-engine-sdk* ([SDK](/develop/release-management/features/infra/python-sdk.html)).
*   New Python CLI, packaged as *ovirt-engine-cli* ([CLI](/develop/release-management/features/infra/cli.html)).
*   Added JSON support for REST API.
*   Added session support to the REST API, allowing one login to process multiple requests.

## Installation Instructions

### oVirt Engine

The oVirt Engine provides the browser based management interface for managing your oVirt environment. It also provides command line tools for managing configuration options not exposed via the user interface as well as a series of APIs supporting automation of both common and advanced tasks.

#### Fedora

To install the oVirt Engine on a Fedora 17 system:

*   Log in to the system on which you wish to host oVirt Engine as the **root** user.
*   Add the yum repository to your system: https://resources.ovirt.org/releases/3.1/rpm/Fedora/17/
*   Install the *ovirt-engine* package, and all of the packages it depends on, using **yum**:

         # yum install ovirt-engine

*   Run the **engine-setup** script and follow the prompts to complete installation of oVirt Engine. Once the Engine has been installed successfully the script will provide instructions for accessing the web Administration Portal:

         # engine-setup

Suggested quick start path for new users:

*   Add a host to the *Default* cluster.
*   Add storage, refer to [Troubleshooting NFS Storage Issues](/develop/troubleshooting-nfs-storage-issues.html) for information on configuring NFS storage for use with oVirt. Support is also available for iSCSI, FCP, and POSIX compliant filesystem storage.
    -   Add a data storage domain to the *Default* data center.
    -   Add an ISO storage domain to the *Default* data center.
*   Upload operating system installation media, in ISO format, to the ISO storage domain using the **engine-iso-uploader** command line tool.

         # engine-iso-uploader -i MyISODomainName upload /root/Downloads/Fedora-17-x86_64-DVD.iso

*   Create a virtual machine!

### oVirt Node

oVirt Node is distributed as a compact image for use on a variety of installation media. It provides a minimal installation of Fedora and includes the packages necessary to support use of the system as a virtualization host in an environment controlled by oVirt Engine.

To install oVirt Node:

*   Download the latest oVirt Node ISO from </releases/3.1/tools/>
    -   Burn the ISO to a CD-ROM or DVD-ROM (**\1**); or
    -   Copy the ISO to a USB drive (**# dd if=./ovirt-node-iso-2.5.1-1.0.fc17.iso of=/dev/sdb**).
*   Boot the target virtualization host from the CD-ROM/DVD-ROM/USB device.
*   Follow the prompts to complete the installation, once the installation is complete and the system is rebooted the configuration screen will be displayed.
*   Use the terminal user interface to configure the Node, in particular ensure networking is configured and set the address to the oVirt Engine.
*   After applying your changes log in to your oVirt Engine installation, select the newly installed Node from the **Hosts** tab, and click **Approve**.

Your oVirt Node has been added to the environment, after adding your first oVirt Node you should:

*   Add Data and ISO storage domains.
*   Upload an ISO image for an operating system.
*   Create a virtual machine!

### Fedora Host

In addition to oVirt Node hosts, you can also reconfigure servers which are running Fedora 17 to be used as virtual machine hosts.

To install a Fedora 17 host:

*   On the machine designated as your Fedora host, install Fedora 17. A minimal installation is sufficient.
*   Log in to your Fedora host as the **root** user.
*   Add the yum repository to your system: https://resources.ovirt.org/releases/3.1/rpm/Fedora/17/

*   After installing this package, log in to your oVirt Engine installation, select "Add" from the **Hosts** tab, enter a name for the Fedora host, and provide the hostname or IP address and root password for the Fedora host, and click **OK**.

Your Fedora host has been added to the environment, after adding your first host (whether Fedora or oVirt Node-based) you should:

*   Add Data and ISO storage domains.
*   Upload an ISO image for an operating system.
*   Create a virtual machine!

## Upgrade Instructions

Upgrading from oVirt 3.0 to oVirt 3.1 is **not** recommended. Users are instead advised to use the migration process as documented on this page. Upgrade instructions are however available, refer to [OVirt 3.0 to 3.1 upgrade](/develop/release-management/releases/3.0/to-3.1-upgrade.html) for more information.

## Migration Instructions

Users of oVirt 3.0 who wish to migrate to oVirt 3.1 should:

*   Create an export storage domain.
*   Export all virtual machines to the export storage domain.
*   Detach the export storage domain.
*   Cleanup the engine installation:

         # engine-cleanup
         # yum remove ovirt\* 

*   Upgrade to Fedora 17: <https://fedoraproject.org/wiki/How_to_use_PreUpgrade>
*   Install oVirt Engine 3.1.
*   Attach the export storage domain.
*   Import all virtual machines.
