# Chapter 1: Introduction

A virtual machine is a software implementation of a computer. The oVirt environment enables you to create virtual desktops and virtual servers.

Virtual machines consolidate computing tasks and workloads. In traditional computing environments, workloads usually run on individually administered and upgraded servers. Virtual machines reduce the amount of hardware and administration required to run the same computing tasks and workloads.

## Audience

Most virtual machine tasks in oVirt can be performed in both the User Portal and Administration Portal. However, the user interface differs between each portal, and some administrative tasks require access to the Administration Portal. Tasks that can only be performed in the Administration Portal will be described as such in this book. Which portal you use, and which tasks you can perform in each portal, is determined by your level of permissions.

The User Portal's user interface is described in the [Introduction to the User Portal](/documentation/intro-user/Introduction_to_the_User_Portal/).

The Administration Portal's user interface is described in the[Introduction to the Administration Portal](/documentation/intro-admin/Introduction_to_the_Administration_Portal/).

## Supported Virtual Machine Operating Systems

The operating systems that can be virtualized as guest operating systems in oVirt are as follows:

**Operating systems that can be used as guest operating systems**

| Operating System | Architecture |
|-
| Enterprise Linux 3 | 32-bit, 64-bit |
| Enterprise Linux 4 | 32-bit, 64-bit |
| Enterprise Linux 5 | 32-bit, 64-bit |
| Enterprise Linux 6 | 32-bit, 64-bit |
| Enterprise Linux 7 | 64-bit |
| Enterprise Linux Atomic Host 7 | 64-bit |
| SUSE Linux Enterprise Server 10 (select **Other Linux** for the guest type in the user interface) | 32-bit, 64-bit |
| SUSE Linux Enterprise Server 11 (SPICE drivers (QXL) are not supplied by Red Hat. However, the distribution's vendor may provide SPICE drivers as part of their distribution.) | 32-bit, 64-bit |
| Ubuntu 12.04 (Precise Pangolin LTS) | 32-bit, 64-bit |
| Ubuntu 12.10 (Quantal Quetzal) | 32-bit, 64-bit |
| Ubuntu 13.04 (Raring Ringtail) | 32-bit, 64-bit |
| Ubuntu 13.10 (Saucy Salamander) | 32-bit, 64-bit |
| Windows 7 | 32-bit, 64-bit |
| Windows 8 | 32-bit, 64-bit |
| Windows 8.1 | 32-bit, 64-bit |
| Windows 10 | 32-bit, 64-bit |
| Windows Server 2008 | 32-bit, 64-bit |
| Windows Server 2008 R2 | 64-bit |
| Windows Server 2012 | 64-bit |
| Windows Server 2012 R2 | 64-bit |

Of the operating systems that can be virtualized as guest operating systems in oVirt, the operating systems that are supported by Global Support Services are as follows:

**Guest operating systems that are supported by Global Support Services**

| Operating System | Architecture | SPICE Support |
|-
| Enterprise Linux 3 | 32-bit, 64-bit | No |
| Enterprise Linux 4 | 32-bit, 64-bit | No |
| Enterprise Linux 5 | 32-bit, 64-bit | No |
| Enterprise Linux 6 | 32-bit, 64-bit | Yes (on Enterprise Linux 6.8 and above)  |
| Enterprise Linux 7 | 64-bit | Yes (on Enterprise Linux 7.2 and above) |
| Enterprise Linux Atomic Host 7 | 64-bit | Yes |
| SUSE Linux Enterprise Server 10 (select **Other Linux** for the guest type in the user interface) | 32-bit, 64-bit | No |
| SUSE Linux Enterprise Server 11 (SPICE drivers (QXL) are not supplied by Red Hat. However, the distribution's vendor may provide SPICE drivers as part of their distribution.) | 32-bit, 64-bit | No |
| Windows 7 | 32-bit, 64-bit | Yes |
| Windows 8 | 32-bit, 64-bit | No |
| Windows 8.1 | 32-bit, 64-bit | No |
| Windows 10 | 32-bit, 64-bit | No  |
| Windows Server 2008 | 32-bit, 64-bit | No |
| Windows Server 2008 R2 | 64-bit | No |
| Windows Server 2012 | 64-bit | No |
| Windows Server 2012 R2 | 64-bit | No |

Remote Desktop Protocol (RDP) is the default connection protocol for accessing Windows 8 and Windows 2012 guests from the user portal as Microsoft introduced changes to the Windows Display Driver Model that prevent SPICE from performing optimally.

**Note:** While Enterprise Linux 3 and Enterprise Linux 4 are supported, virtual machines running the 32-bit version of these operating systems cannot be shut down gracefully from the administration portal because there is no ACPI support in the 32-bit x86 kernel. To terminate virtual machines running the 32-bit version of Enterprise Linux 3 or Enterprise Linux 4, right-click the virtual machine and select the **Power Off** option.

**Note:** See [http://www.redhat.com/resourcelibrary/articles/enterprise-linux-virtualization-support](http://www.redhat.com/resourcelibrary/articles/enterprise-linux-virtualization-support) for information about up-to-date guest support.

## Virtual Machine Performance Parameters

oVirt virtual machines can support the following parameters:

**Supported virtual machine parameters**

| Parameter | Number | Note |
|-
| Virtualized CPUs | 240 | Per virtual machine running on a Enterprise Linux 6 host. |
| Virtualized CPUs | 240 | Per virtual machine running on a Enterprise Linux 7 host. |
| Virtualized RAM | 4000 GB | For a 64 bit virtual machine. |
| Virtualized RAM | 4 GB | Per 32 bit virtual machine. Note, the virtual machine may not register the entire 4 GB. The amount of RAM that the virtual machine recognizes is limited by its operating system. |
| Virtualized storage devices | 8 | Per virtual machine. |
| Virtualized network interface controllers | 8 | Per virtual machine. |
| Virtualized PCI devices | 32 | Per virtual machine. |


## Installing Supporting Components

### Installing Console Components

A console is a graphical window that allows you to view the start up screen, shut down screen, and desktop of a virtual machine, and to interact with that virtual machine in a similar way to a physical machine. In oVirt, the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on the client machine prior to use.

The details on installing/setting up consoles are described in the [Console Client Resources](/documentation/admin-guide/virt/console-client-resources/) page.

**Next:** [Chapter 2: Installing Linux Virtual Machines](../chap-Installing_Linux_Virtual_Machines)
