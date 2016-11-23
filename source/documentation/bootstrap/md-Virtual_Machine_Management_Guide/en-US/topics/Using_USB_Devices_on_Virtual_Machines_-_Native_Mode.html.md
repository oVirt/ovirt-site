# Using USB Devices on Virtual Machines

USB redirection Native mode allows KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual (guest) machines require no guest-installed agents or drivers for native USB. On Red Hat Enterprise Linux clients, all packages required for USB redirection are provided by the `virt-viewer` package. On Windows clients, you must also install the `usbdk` package. Native USB mode is supported on the following clients and guests:

* Client

    * Red Hat Enterprise Linux 7.1 and higher

    * Red Hat Enterprise Linux 6.0 and higher

    * Windows 10

    * Windows 8

    * Windows 7

    * Windows 2008

    * Windows 2008 Server R2

* Guest

    * Red Hat Enterprise Linux 7.1 and higher

    * Red Hat Enterprise Linux 6.0 and higher

    * Windows 7

    * Windows XP

    * Windows 2008

**Note:** If you have a 64-bit architecture PC, you must use the 64-bit version of Internet Explorer to install the 64-bit version of the USB driver. The USB redirection will not work if you install the 32-bit version on a 64-bit architecture. As long as you initially install the correct USB type, you then can access USB redirection from both 32 and 64-bit browsers.
