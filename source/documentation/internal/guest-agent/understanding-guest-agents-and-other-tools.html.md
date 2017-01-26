---
title: Understanding Guest Agents and Other Tools
authors: bobdrad, gianluca, nkesick, sven, vfeenstr
wiki_title: Understanding Guest Agents and Other Tools
wiki_revision_count: 41
wiki_last_updated: 2015-01-18
---

<!-- TODO: Content review -->

# Understanding Guest Agents and Other Tools

## Introduction

There are three tools which together can provide the best experience when using a virtual machine with oVirt.

*   oVirt Guest Agent - Recommended
*   VirtIO Drivers - Recommended
*   Spice Drivers - Recommended if you use the Spice console

## Agents

### oVirt Guest Agent

The oVirt Guest Agent provides information, notifications, and actions between the oVirt web interface and the guest. A more detailed description can be found at [Guest Agent](/develop/developer-guide/vdsm/guest-agent/). The agent provides the Machine Name, Operating System, IP Addresses, Installed Applications, Network and RAM usage and others details to the web interface. The agent also provides Single Sign On so a authenticated user to the web interface does not need to authenticate again when connected to a VM.

### Spice Agent

The Spice agent works with the Spice protocol to offer a better guest console experience. The Spice console can still be used without the Spice Agent. With the Spice agent installed the following features are enabled:

*   Copy & Paste of text and images between the guest and client machine
*   Automatic adjustment of resolution when the client screen changes - e.g. if you make the Spice console full screen the guest resolution will adjust to match it rather than letterboxing.
*   Better mouse integration - The mouse can be captured and released without needing to click inside the console or press keys to release it. The performance of mouse movement is also improved.

## Drivers

### VirtIO Drivers

The VirtIO drivers provide a number of interfaces to guests. Further information can be found at [linux-kvm.org](http://www.linux-kvm.org/page/Virtio)

The drivers include support for

*   VirtIO Serial - Used for communication with oVirt Management
*   VirtIO SCSI - Used for communication with virtual SCSI disks
*   VirtIO Network - Used for communication with physical and virtual networks
*   Memory Ballooning - Used for freeing memory so that it can be made available to other VMs.

VirtIO is built into the Linux kernel so no additional installation is required for Linux VMs with recent kernels (2.6.35 and newer). For Windows VMs the drivers must be installed. The VirtIO drivers are available on an [Windows VirtIO Drivers Wiki](https://fedoraproject.org/wiki/Windows_Virtio_Drivers) for easy installation to guests at run time and install time. Without the VirtIO drivers a Windows based VM can still function but it requires a IDE based virtual hard drive and e1000 or rtl8139 network devices which may not be optimal.

## Availability & Install Instructions

### Windows Guests

|-------------------|------------------------------------------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|
|                   | [Win XP](/documentation/how-to/virtual-machines/create-a-windows-xp-virtual-machine/)        | [Win 7](/documentation/how-to/virtual-machines/create-a-windows-7-virtual-machine/)        | [Win8](/documentation/how-to/virtual-machines/create-a-windows-8-virtual-machine/)        | [Server 2003/R2](/documentation/how-to/virtual-machines/create-a-windows-2003-virtual-machine/) | [Server 2008/R2](/documentation/how-to/virtual-machines/create-a-windows-2008-virtual-machine/) | [Server 2012/R2](/documentation/how-to/virtual-machines/create-a-windows-2012-virtual-machine/) |
| oVirt Guest Agent | -                                                                      | -                                                                    | -                                                                   | -                                                                         | -                                                                         | -                                                                         |
| VirtIO Drivers    | [Yes(1)](/documentation/how-to/virtual-machines/create-a-windows-xp-virtual-machine/#virtio) | [Yes](/documentation/how-to/virtual-machines/create-a-windows-7-virtual-machine/#drivers)  | [Yes](/documentation/how-to/virtual-machines/create-a-windows-8-virtual-machine/#drivers) | [Yes(1)](/documentation/how-to/virtual-machines/create-a-windows-2003-virtual-machine/#virtio)  | [Yes](/documentation/how-to/virtual-machines/create-a-windows-2008-virtual-machine/#virtio)     | [Yes](/documentation/how-to/virtual-machines/create-a-windows-2012-virtual-machine/#virtio)     |
| Spice Drivers     | [Yes](/documentation/how-to/virtual-machines/create-a-windows-xp-virtual-machine/#graphics)  | [Yes](/documentation/how-to/virtual-machines/create-a-windows-7-virtual-machine/#graphics) | No(2)                                                               | [Yes](/documentation/how-to/virtual-machines/create-a-windows-2003-virtual-machine/#graphics)   | [Yes](/documentation/how-to/virtual-machines/create-a-windows-2008-virtual-machine/#graphics)   | No(2)                                                                     |

*(1) XP Does not support VirtIO-SCSI[1](https://bugzilla.redhat.com/show_bug.cgi?id=1043198)*

''(2) The spice drivers currently work with Windows 7 and below. ''

### Linux Guests

|-------------------|-------------------------------------------------------------|--------------------------------------------------------|--------------------------------------------------------|-------------------------------------------------------------|------------------------------------------------------------|----------------------------------------------|------------------------------------------|
|                   | [Fedora](/documentation/how-to/virtual-machines/create-a-fedora-virtual-machine/) | RHEL                                                   | CentOS                                                 | [Ubuntu](/documentation/how-to/virtual-machines/create-a-ubuntu-virtual-machine/) | Debian                                                     | openSuSE                                     | SuSE Linux Enterprise                    |
| oVirt Guest Agent | [Yes](/documentation/how-to/guest-agent/install-the-guest-agent-in-fedora/)  | Yes                                                    | Yes                                                    | [Yes](/develop/release-management/features/virt/guestagentubuntu/)                  | [Yes](/documentation/how-to/guest-agent/install-the-guest-agent-in-debian/) | [Yes](/develop/release-management/features/virt/guestagentopensuse/) | [Yes](/develop/release-management/features/virt/guestagentsles/) |
| VirtIO Drivers    | Built-in                                                    | Built-in                                               | Built-in                                               | Built-in                                                    | Built-in                                                   | Built-in                                     | Built-in                                 |
| Spice Agent       | [Yes](/documentation/how-to/guest-agent/install-the-spice-guest-agent/)      | [Yes](/documentation/how-to/guest-agent/install-the-spice-guest-agent/) | [Yes](/documentation/how-to/guest-agent/install-the-spice-guest-agent/) | [Yes](/documentation/how-to/guest-agent/install-the-spice-guest-agent/)      | [Yes](/documentation/how-to/guest-agent/install-the-spice-guest-agent/)     | -                                            | -                                        |
