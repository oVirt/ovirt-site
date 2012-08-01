---
title: OVirt 3.1 release notes
authors: abonas, amureini, danken, dneary, jbrooks, nkesick, roy, sgordon, val0x00ff
wiki_title: OVirt 3.1 release notes
wiki_revision_count: 70
wiki_last_updated: 2013-10-17
---

# OVirt 3.1 release notes

The oVirt Project is pleased to announce the availability of its second formal release, oVirt 3.1.

## What's New?

The oVirt 3.1 release includes these notable changes.

### Installer

*   The installation script now supports the configuration of a HTTP/HTTPS proxy, allowing the oVirt Engine to be accessed via port 80 for HTTP, and port 443 for HTTPS ([Features/OvirtEnginePort80](Features/OvirtEnginePort80)).
*   The oVirt Engine now supports the use of a remote PostgreSQL database server, specified during installation ([Features/RemoteDB](Features/RemoteDB)).
*   An 'all-in-one' proof of concept mode is now available. This allows a single machine to both run the management engine and act as a virtualization host ([Feature/AllInOne](Feature/AllInOne)).

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

*   Support has been added for presenting any block device as a local disk attached to a virtual machine simply by specifying the device's GUID. This provides **directlun** support, which previously had to be implemented using a VDSM hook ([Features/Direct_Lun](Features/Direct_Lun)).
*   Support has been added to VDSM, and by extension oVirt Engine, for the attachment and use of NFSv4 storage ([Features/NFSv4](Features/NFSv4).
*   It is now possible to override some of VDSM's default NFS settings from the oVirt Engine when attaching storage ([Features/AdvancedNfsOptions](Features/AdvancedNfsOptions)).
*   Support has been added for the attachment and use of POSIX filesystem compliant storage, allowing users to attach any type of storage supported by **mount** ([Features/PosixFSConnection](Features/PosixFSConnection)).
*   Support for defining the priority of hosts in the storage pool manager (SPM) selection process has been added. Hosts can also be assigned a priority of **-1**m which means that they must not be selected as the SPM ([Features/SPMPriority](Features/SPMPriority)).
*   Support has been added for sharing of disks between virtual machines. Previously each disk could only be attached to a single virtual machine, it is now possible to share a disk between multiple virtual machines concurrently ([Features/SharedRawDisk](Features/SharedRawDisk)).
*   Support has been added for hot plugging and unplugging of **virtio-blk** disks to and from virtual machines If the "Add" menu command in the virtual disks pane of a running VM is disabled, a disk may be added from the VM "Guide Me" dialog) ([Features/HotPlug](Features/HotPlug)).
*   Support has been added for floating disks, disks which are not necessarily attached to a virtual machine at any one point in time but can be attached to virtual machines as and when needed. Floating disks can be found in the web administration portal under the **Disks** tab ([Features/FloatingDisk](Features/FloatingDisk)).
*   It is now possible for virtual machines to have their disks spread across multiple storage domains within the same data center. Previously all disks attached to a virtual machine had to reside on the same storage domain ([Features/MultipleStorageDomains](Features/MultipleStorageDomains)).

If the "Add" menu command in the virtual disks pane of a running VM is greyed out, a disk may be added from the VM "Guide Me" dialog)

TODO:

*   live snapshot (Requires qemu 1.1 on the vdsm host)
*   auto re-activate storage domains from error mode
*   **use sanlock for pool locks (need to see if made ovirt 3.1)**

### Virtualization

*   Previously it was not possible to import a Virtual Machine or Template that had already been imported, even if it was to a different data center. This is no longer the case ([Features/ImportMoreThanOnce](Features/ImportMoreThanOnce)).
*   Devices attached to guest virtual machines now retain the same address allocations as other devices are added and/or removed from the guest's configuration ([Features/Design/DetailedStableDeviceAddresses](Features/Design/DetailedStableDeviceAddresses)).
*   Support for "pre-started" virtual machine pools has been added. Instead of having to wait for a virtual machine allocated from the pool to boot user's will instead, where possible, be allocated a virtual machine which has already been started ([Features/PrestartedVm](Features/PrestartedVm)).
*   Support for virtual machine payloads has been added, in the form of a Floppy or CD/DVD image that will be passed to the virtual machine. Virtual machine payloads may be either temporary or permenant.([Features/VMPayload](Features/VMPayload)).
*   **native spice usb support (need to see if made ovirt 3.1)**
*   **spice wan options (need to see if made ovirt 3.1)**
*   new custom hook in vdsm: set vm ticket
*   cancel live migration
*   Added support for cloning a Virtual Machine from a specific Snapshot ([Features/CloneVmFromSnapshot](Features/CloneVmFromSnapshot)).
*   **new cpu models: sandy bridge and opteron G4 (need to see if made ovirt 3.1)**
*   **vnc details screen (need to see if made ovirt 3.1)**

### SLA

*   Added support for the definition quotas restricting user resource usage ([Features/Quota](Features/Quota)).
*   Added support for pinning Virtual Machines to specific physical CPUs ([Features/Design/cpu-pinning](Features/Design/cpu-pinning)).

### Network

*   A new network setup API to support complex network provisioning tasks has been added to the backend, as a result the user interface for host network setup has also been redesigned ([Features/Design/Network/SetupNetworks](Features/Design/Network/SetupNetworks)).
*   It is now possible to adjust the MTU of a logical network, when it is not attached to a cluster ([Features/Design/Network/Jumbo_frames](Features/Design/Network/Jumbo_frames)).
*   It is now possible to create bridgeless logical networks, previously all logical network were represented using a bridge ([Features/Design/Network/Bridgeless_Networks](Features/Design/Network/Bridgeless_Networks)).
*   Hot plugging and unplugging of virtual Network Interface Cards from virtual machines is now supported ([Features/HotplugNic](Features/HotplugNic)).
*   Support for port mirroring, allowing all network traffic to be mirrored to a specific virtual machine, has been added ([Features/PortMirroring](Features/PortMirroring)).
*   Previously, all logical networks were considered mandatory for all hosts in a cluster. Hosts that were not attached to all logcal networks in the cluster were marked non-responsive. Administrators now have the option to mark specific logical networks as non-mandatory, bypassing this behavior ([Features/Design/Network/Required_Networks](Features/Design/Network/Required_Networks)).

### Interfaces

*   New Python SDK, packaged as *ovirt-engine-sdk* ([SDK](SDK)).
*   New Python CLI, packaged as *ovirt-engine-cli* ([CLI](CLI)).
*   Added JSON support for REST API.
*   Added session support to the REST API, allowing one login to process multiple requests.

## Installation Instructions

### oVirt Engine

The oVirt Engine provides the browser based management interface for managing your oVirt environment. It also provides command line tools for managing configuration options not exposed via the user interface as well as a series of APIs supporting automation of both common and advanced tasks.

#### Fedora

To install the oVirt Engine on a Fedora 17 system:

*   Log in to the system on which you wish to host oVirt Engine as the **root** user.
*   Install the *ovirt-release* package using **yum**, this package configures your system to receive updates from the oVirt project's software repository:

`   # yum localinstall `[`http://ovirt.org/releases/ovirt-release-fedora-4-2.noarch.rpm`](http://ovirt.org/releases/ovirt-release-fedora-4-2.noarch.rpm)

*   Install the *ovirt-engine* package, and all of the packages it depends on, using **yum**:

         # yum install ovirt-engine

*   Run the **engine-setup** script and follow the prompts to complete installation of oVirt Engine. Once the Engine has been installed successfully it will then provide instructions for accessing the web Administration Portal:

         # engine-setup

### oVirt Node

## Upgrade Instructions

Upgrading from oVirt 3.0 to oVirt 3.1 is **not** recommended. Upgrade instructions are however available, refer to [OVirt_3.0_to_3.1_upgrade](OVirt_3.0_to_3.1_upgrade) for more information. It is highly recommended that before upgrading you backup all of your virtual machines to an export storage domain.
