---
title: Understanding Guest Agents and Other Tools
authors:
  - bobdrad
  - gianluca
  - nkesick
  - sven
  - vfeenstr
  - sandrobonazzola
---


# Understanding Guest Agents and Other Tools

## Introduction

There are three tools which together can provide the best experience when using a virtual machine with oVirt.

*   QEMU Guest Agent - Recommended
*   VirtIO Drivers - Recommended
*   Spice Drivers - Recommended if you use the Spice console

There used to be also:

*   oVirt Guest Agent - Deprecated and not available on recent OSs

Please refer to [Virtual Machine Management Guide](/documentation/virtual_machine_management_guide) for agents and drivers installation instructions.


## Agents

### QEMU Guest Agent

The QEMU Guest Agent helps management applications with executing functions which need assistance of the guest OS. For example, freezing and thawing filesystems, entering suspend.
It provides information, notifications, and actions between the oVirt web interface and the guest. A more detailed description can be found at [QEMU Guest Agent](https://wiki.libvirt.org/page/Qemu_guest_agent).

### oVirt Guest Agent

**The oVirt Guest Agent has been deprecated** in favor of QEMU Guest Agent and is not available anymore for recent OS. It can still be found for less recent OS in their own distribution repositories.
The oVirt Guest Agent provides information, notifications, and actions between the oVirt web interface and the guest.
A more detailed description can be found at [oVirt Guest Agent](guest-agent.html).
The agent provides the Machine Name, Operating System, IP Addresses, Installed Applications, Network and RAM usage and others details to the web interface.
The agent also provides Single Sign On so an authenticated user to the web interface does not need to authenticate again when connected to a VM.

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



