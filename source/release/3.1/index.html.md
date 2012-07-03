---
title: OVirt 3.1 release notes
authors: abonas, amureini, danken, dneary, jbrooks, nkesick, roy, sgordon, val0x00ff
wiki_title: OVirt 3.1 release notes
wiki_revision_count: 70
wiki_last_updated: 2013-10-17
---

# OVirt 3.1 release notes

The oVirt Project is pleased to announce the availability of its second formal release, oVirt 3.2.

## What's New?

The oVirt 3.2 release includes these notable changes.

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

* import vm more than once (need to see if made ovirt 3.1)[BR](BR) - stable device addresses[BR](BR) - pre-started vms in pool[BR](BR) - vm payload[BR](BR) - native spice usb support (need to see if made ovirt 3.1)[BR](BR) - spice wan options (need to see if made ovirt 3.1)[BR](BR) - new custom hook in vdsm: set vm ticket[BR](BR) - cancel live migration[BR](BR) - clone vm from snapshot[BR](BR) - new cpu models: sandy bridge and opteron G4 (need to see if made ovirt 3.1)[BR](BR) - vnc details screen (need to see if made ovirt 3.1)[BR](BR)

### SLA

*   Added support for the definition quotas restricting user resource usage ([Features/Quota](Features/Quota)).
*   Added support for pinning Virtual Machines to specific physical CPUs ([Features/Design/cpu-pinning](Features/Design/cpu-pinning)).

### Network

* setup multiple networks and new ui[BR](BR) - mtu ("jumbo frames")[BR](BR) - vm networks ("bridgeless networks")[BR](BR) - optional/required networks[BR](BR) - hotplug nic[BR](BR) - port mirroring ("promiscuous mode")[BR](BR)

### Interfaces

*   New Python SDK, packaged as *ovirtsdk* ([SDK](SDK)).
*   New Python CLI, packaged as *???* ([CLI](CLI)).
*   Added JSON support for REST API.
*   Added session support to the REST API, allowing one login to process multiple requests.

## Installation Instructions

### oVirt Engine

### oVirt Node
