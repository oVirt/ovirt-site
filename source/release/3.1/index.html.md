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

*   Support has been added for Red Hat Directory Server and IBM Tivoli Directory Server.
*   An additional tab has been added to the oVirt Engine's management interface to support monitoring the status of tasks.
*   A correlation identifier to support debugging is now used to track events across the user interfaces, engine backend, and VDSM.
*   The oVirt Engine now automatically attempts to auto-activate hosts detected as non-operational.

### User Interface

*   Infrastructure supporting localization has been added, with translations to follow in a later release.
*   Infrastructure supporting integration of reports functionality has been added to the oVirt Engine management interface.

### Storage

* hot plug disk - multiple storage domains - shared disk - external disk (direct lun) - posix fs storage domains - nfs options - nfs v4 - live snapshot - disks main tab ("floating disks") - spm priority - auto re-activate storage domains from error mode - use sanlock for pool locks (need to see if made ovirt 3.1)

### Virtualization

*   ''Previously it was not possible to import a Virtual Machine or Template that had already been imported, even if it was to a different data center. This has now been fixed ([Features/ImportMoreThanOnce](Features/ImportMoreThanOnce)). ''
*   Devices in guest virtual machines now retain the same address allocations as other devices are added and/or removed from the guest's configuration ([Features/Design/DetailedStableDeviceAddresses](Features/Design/DetailedStableDeviceAddresses)).
*   Added support for "pre-started" virtual machine pools. Instead of having to wait for a virtual machine allocated from the pool to boot user's will instead, where possible, be allocated a virtual machine which has already been started ([Features/PrestartedVm](Features/PrestartedVm)).
*   Added support for a virtual machine payload, in the form of a Floppy or CD/DVD image, that will be passed to the virtual machine. Virtual machine payloads may be either temporary or permenant.([Features/VMPayload](Features/VMPayload)).
*   native spice usb support (need to see if made ovirt 3.1)
*   spice wan options (need to see if made ovirt 3.1)
*   new custom hook in vdsm: set vm ticket
*   cancel live migration
*   Added support for cloning a Virtual Machine from a specific Snapshot ([Features/CloneVmFromSnapshot](Features/CloneVmFromSnapshot)).
*   new cpu models: sandy bridge and opteron G4 (need to see if made ovirt 3.1)
*   vnc details screen (need to see if made ovirt 3.1)

### SLA

*   Added support for the definition quotas restricting user resource usage ([Features/Quota](Features/Quota)).
*   Added support for pinning Virtual Machines to specific physical CPUs ([Features/Design/cpu-pinning](Features/Design/cpu-pinning)).

### Network

*   A new network setup APIto handle complex network provisioning tasks has been added to the backend, as a result the user interface for host network setup has also been significantly improved ([Features/Design/Network/SetupNetworks](Features/Design/Network/SetupNetworks)).
*   mtu ("jumbo frames")
*   Support for adjusting the MTU of a logical network, when it is not attached to a cluster, has been added ([Features/Design/Network/Jumbo_frames](Features/Design/Network/Jumbo_frames)).
*   Support for bridgeless networks, has been added.([Features/Design/Network/Bridgeless_Networks](Features/Design/Network/Bridgeless_Networks)).
*   Support for hot plugging and unplugging of Virtual Network Interface Cards from virtual machines, has been added ([Features/HotplugNic](Features/HotplugNic)).
*   Support for port mirroring, allowing all network traffic to be mirrored to a specific virtual machine, has been added ([Features/PortMirroring](Features/PortMirroring)).
*   Previously, all logical networks were considered mandatroy for all hosts in a cluster. Hosts that were not attached to all logcal networks in the cluster were marked non-responsive. Administrators now have the option to mark specific logical networks as non-mandatory, bypassing this behavior ([Features/Design/Network/Required_Networks](Features/Design/Network/Required_Networks)).

### Interfaces

*   New Python SDK, packaged as *ovirtsdk* ([SDK](SDK)).
*   New Python CLI, packaged as *???* ([CLI](CLI)).
*   Added JSON support for REST API.
*   Added session support to the REST API, allowing one login to process multiple requests.

## Installation Instructions

### oVirt Engine

### oVirt Node
