# Browser and Client Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the User Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested and fully supported. Red Hat Engineering is committed to fixing issues with browsers on this tier.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work. Limited support is provided for this tier. Red Hat Engineering will attempt to fix issues with browsers on this tier.

* Tier 3: Browser and operating system combinations that are not tested, but may work. Minimal support is provided for this tier. Red Hat Engineering will attempt to fix only minor issues with browsers on this tier.

**Browser Requirements**

| Support Tier | Operating System Family | Browser | Portal Access |
|-
| Tier 1 | Red Hat Enterprise Linux | Mozilla Firefox Extended Support Release (ESR) version | Administration Portal and User Portal |
| Tier 2 | Windows | Internet Explorer 10 or later | Administration Portal and User Portal |
|        | Any | Most recent version of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
| Tier 3 | Any | Earlier versions of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
|        | Any | Other browsers | Administration Portal and User Portal |

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Red Hat Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supported Components](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide#sect-Installing_Supporting_Components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

SPICE console access is only available on other operating systems, such as OS X, through the unsupported SPICE HTML5 browser client.

Supported QXL drivers are available on Red Hat Enterprise Linux machines, Windows XP and Windows 7 machines.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which remote-viewer has been fully tested and is supported. 

* Tier 2: Operating systems on which remote-viewer is partially tested and is likely to work. Limited support is provided for this tier. Red Hat Engineering will attempt to fix issues with remote-viewer on this tier.

**Client Operating System SPICE Support**

| Support Tier | Operating System | SPICE Support |
|-
| Tier 1 | Red Hat Enterprise Linux 7 | Fully supported on Red Hat Enterprise Linux 7.2 and above |
|        | Microsoft Windows 7 | Fully supported on Microsoft Windows 7 |
| Tier 2 | Microsoft Windows 8 | Supported when spice-vdagent is running on these guest operating systems |
|        | Microsoft Windows 10 | Supported when spice-vdagent is running on these guest operating systems |
