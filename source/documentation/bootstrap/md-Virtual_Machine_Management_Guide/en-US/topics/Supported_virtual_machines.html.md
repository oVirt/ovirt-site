# Supported Virtual Machine Operating Systems

The operating systems that can be virtualized as guest operating systems in Red Hat Virtualization are as follows:

**Operating systems that can be used as guest operating systems**

| Operating System | Architecture |
|-
| Red Hat Enterprise Linux 3 | 32-bit, 64-bit |
| Red Hat Enterprise Linux 4 | 32-bit, 64-bit |
| Red Hat Enterprise Linux 5 | 32-bit, 64-bit |
| Red Hat Enterprise Linux 6 | 32-bit, 64-bit |
| Red Hat Enterprise Linux 7 | 64-bit |
| Red Hat Enterprise Linux Atomic Host 7 | | 64-bit |
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

Of the operating systems that can be virtualized as guest operating systems in Red Hat Virtualization, the operating systems that are supported by Global Support Services are as follows:

**Guest operating systems that are supported by Global Support Services**

| Operating System | Architecture | SPICE Support |
|-
| Red Hat Enterprise Linux 3 | 32-bit, 64-bit | No |
| Red Hat Enterprise Linux 4 | 32-bit, 64-bit | No |
| Red Hat Enterprise Linux 5 | 32-bit, 64-bit | No |
| Red Hat Enterprise Linux 6 | 32-bit, 64-bit | Yes (on Red Hat Enterprise Linux 6.8 and above)  |
| Red Hat Enterprise Linux 7 | 64-bit | Yes (on Red Hat Enterprise Linux 7.2 and above) |
| Red Hat Enterprise Linux Atomic Host 7 | 64-bit | Yes |
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

**Note:** While Red Hat Enterprise Linux 3 and Red Hat Enterprise Linux 4 are supported, virtual machines running the 32-bit version of these operating systems cannot be shut down gracefully from the administration portal because there is no ACPI support in the 32-bit x86 kernel. To terminate virtual machines running the 32-bit version of Red Hat Enterprise Linux 3 or Red Hat Enterprise Linux 4, right-click the virtual machine and select the **Power Off** option.

**Note:** See [http://www.redhat.com/resourcelibrary/articles/enterprise-linux-virtualization-support](http://www.redhat.com/resourcelibrary/articles/enterprise-linux-virtualization-support) for information about up-to-date guest support.
