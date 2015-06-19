---
title: Understanding Guest Agents and Other Tools
authors: bobdrad, gianluca, nkesick, sven, vfeenstr
wiki_title: Understanding Guest Agents and Other Tools
wiki_revision_count: 41
wiki_last_updated: 2015-01-18
---

# Understanding Guest Agents and Other Tools

## Introduction

There are three tools which together can provide the best experience when using a virtual machine with oVirt.

*   oVirt Guest Agent - Recommended
*   VirtIO Drivers - Recommended
*   Spice Drivers - Recommended if you use the Spice console

## Agents

### oVirt Guest Agent

The oVirt Guest Agent provides information, notifications, and actions between the oVirt web interface and the guest. A more detailed description can be found at [Guest Agent](Guest_Agent). The agent provides the Machine Name, Operating System, IP Addresses, Installed Applications, Network and RAM usage and others details to the web interface. The agent also provides Single Sign On so a authenticated user to the web interface does not need to authenticate again when connected to a VM.

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

VirtIO is built into the Linux kernel so no additional installation is required for Linux VMs with recent kernels (2.6.35 and newer). For Windows VMs the drivers must be installed. The VirtIO drivers are available on an [ISO from Fedora](http://alt.fedoraproject.org/pub/alt/virtio-win/latest/) for easy installation to guests at run time and install time. Without the VirtIO drivers a Windows based VM can still function but it requires a IDE based virtual hard drive and e1000 or rtl8139 network devices which may not be optimal.

## Availability & Install Instructions

### Windows Guests

|-------------------|------------------------------------------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|
|                   | [Win XP](How_to_create_a_Windows_XP_Virtual_Machine)        | [Win 7](How_to_create_a_Windows_7_Virtual_Machine)        | [Win8](How_to_create_a_Windows_8_Virtual_Machine)        | [Server 2003/R2](How_to_create_a_Windows_2003_Virtual_Machine) | [Server 2008/R2](How_to_create_a_Windows_2008_Virtual_Machine) | [Server 2012/R2](How_to_create_a_Windows_2012_Virtual_Machine) |
| oVirt Guest Agent | -                                                                      | -                                                                    | -                                                                   | -                                                                         | -                                                                         | -                                                                         |
| VirtIO Drivers    | [Yes(1)](How_to_create_a_Windows_XP_Virtual_Machine#VirtIO) | [Yes](How_to_create_a_Windows_7_Virtual_Machine#Drivers)  | [Yes](How_to_create_a_Windows_8_Virtual_Machine#Drivers) | [Yes(1)](How_to_create_a_Windows_2003_Virtual_Machine#VirtIO)  | [Yes](How_to_create_a_Windows_2008_Virtual_Machine#VirtIO)     | [Yes](How_to_create_a_Windows_2012_Virtual_Machine#VirtIO)     |
| Spice Drivers     | [Yes](How_to_create_a_Windows_XP_Virtual_Machine#Graphics)  | [Yes](How_to_create_a_Windows_7_Virtual_Machine#Graphics) | No(2)                                                               | [Yes](How_to_create_a_Windows_2003_Virtual_Machine#Graphics)   | [Yes](How_to_create_a_Windows_2008_Virtual_Machine#Graphics)   | No(2)                                                                     |

*(1) XP Does not support VirtIO-SCSI[1](https://bugzilla.redhat.com/show_bug.cgi?id=1043198)*

''(2) The spice drivers currently work with Windows 7 and below. ''

### Linux Guests

|-------------------|-------------------------------------------------------------|--------------------------------------------------------|--------------------------------------------------------|-------------------------------------------------------------|------------------------------------------------------------|----------------------------------------------|------------------------------------------|
|                   | [Fedora](How_to_create_a_Fedora_Virtual_Machine) | RHEL                                                   | CentOS                                                 | [Ubuntu](How_to_create_a_Ubuntu_Virtual_Machine) | Debian                                                     | openSuSE                                     | SuSE Linux Enterprise                    |
| oVirt Guest Agent | [Yes](How_to_install_the_guest_agent_in_Fedora)  | Yes                                                    | Yes                                                    | [Yes](Feature/GuestAgentUbuntu)                  | [Yes](How_to_install_the_guest_agent_in_Debian) | [Yes](Feature/GuestAgentOpenSUSE) | [Yes](Feature/GuestAgentSLES) |
| VirtIO Drivers    | Built-in                                                    | Built-in                                               | Built-in                                               | Built-in                                                    | Built-in                                                   | Built-in                                     | Built-in                                 |
| Spice Agent       | [Yes](How_to_install_the_spice_guest_agent)      | [Yes](How_to_install_the_spice_guest_agent) | [Yes](How_to_install_the_spice_guest_agent) | [Yes](How_to_install_the_spice_guest_agent)      | [Yes](How_to_install_the_spice_guest_agent)     | -                                            | -                                        |
