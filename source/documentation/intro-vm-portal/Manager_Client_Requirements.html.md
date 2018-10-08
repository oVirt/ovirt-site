# Client Requirements

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Red Hat Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supporting Components on Client Machines](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/sect-installing_supporting_components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

Virtual machine consoles are accessed through the SPICE protocol. The QXL graphical driver can be installed in the guest operating system for improved/enhanced SPICE functionalities. SPICE currently supports a maximum resolution of 2560x1600 pixels.

Supported QXL drivers are available on Red Hat Enterprise Linux, Windows XP, and Windows 7.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which Remote Viewer has been fully tested and is supported. 

* Tier 2: Operating systems on which Remote Viewer is partially tested and is likely to work. Limited support is provided for this tier. Red Hat Engineering will attempt to fix issues with remote-viewer on this tier.

**Client Operating System SPICE Support**

|Support Tier |Operating System |
|-
|Tier 1 |Red Hat Enterprise Linux 7.2 and later|
| |Microsoft Windows 7 |
|Tier 2 |Microsoft Windows 8 |
| |Microsoft Windows 10 |
