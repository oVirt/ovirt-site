# Additional Configuration

## Configuring Single Sign-On for Virtual Machines

Configuring single sign-on, also known as password delegation, allows you to automatically log in to a virtual machine using the credentials you use to log in to the User Portal. Single sign-on can be used on both Red Hat Enterprise Linux and Windows virtual machines.

**Important:** If single sign-on to the User Portal is enabled, single sign-on to virtual machines will not be possible. With single sign-on to the User Portal enabled, the User Portal does not need to accept a password, thus the password cannot be delegated to sign in to virtual machines.

* [Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines](Configuring_Single_Sign-On_for_Red_Hat_Enterprise_Linux_Virtual_Machines)
* [Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines Using Active Directory](Configuring_Single_Sign-On_for_Red_Hat_Enterprise_Linux_Virtual_Machines_Using_Active_Directory)
* [Configuring Single Sign On for Windows Virtual Machines](Configuring_Single_Sign_On_for_Windows_Virtual_Machines)
* [Disabling Single Sign-on for Virtual Machines](Disabling_Single_Sign-on_for_Virtual_Machines)

## Configuring USB Devices

A virtual machine connected with the SPICE protocol can be configured to connect directly to USB devices.

The USB device will only be redirected if the virtual machine is active and in focus. USB redirection can be manually enabled each time a device is plugged in or set to automatically redirect to active virtual machines in the SPICE client menu.

**Important:** Note the distinction between the client machine and guest machine. The client is the hardware from which you access a guest. The guest is the virtual desktop or virtual server which is accessed through the User Portal or Administration Portal.

* [Using USB Devices on Virtual Machines - Native Mode](Using_USB_Devices_on_Virtual_Machines_-_Native_Mode)
* [Using USB Devices on a Windows Client](Using_USB_Devices_on_a_Windows_Client)
* [Using USB Devices on a Red Hat Enterprise Linux Client](Using_USB_Devices_on_a_Red_Hat_Enterprise_Linux_Client)

## Configuring Multiple Monitors

* [Configuring Multiple Displays for Red Hat Enterprise Linux Guest Virtual Machines](Configuring_Multiple_Displays_for_Red_Hat_Enterprise_Linux_Guest_Virtual_Machines)
* [Configuring Multiple Displays for Windows Guest Virtual Machines](Configuring_Multiple_Displays_for_Windows_Guest_Virtual_Machines)

## Configuring Console Options

### Console Options

Connection protocols are the underlying technology used to provide graphical consoles for virtual machines and allow users to work with virtual machines in a similar way as they would with physical machines. Red Hat Virtualization currently supports the following connection protocols:

**SPICE**

Simple Protocol for Independent Computing Environments (SPICE) is the recommended connection protocol for both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using SPICE, use Remote Viewer.

**VNC**

Virtual Network Computing (VNC) can be used to open consoles to both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using VNC, use Remote Viewer or a VNC client.

**RDP**

Remote Desktop Protocol (RDP) can only be used to open consoles to Windows virtual machines, and is only available when you access a virtual machines from a Windows machine on which Remote Desktop has been installed. Before you can connect to a Windows virtual machine using RDP, you must set up remote sharing on the virtual machine and configure the firewall to allow remote desktop connections.

**Note:** SPICE is not currently supported on virtual machines running Windows 8. If a Windows 8 virtual machine is configured to use the SPICE protocol, it will detect the absence of the required SPICE drivers and automatically fall back to using RDP.

 * [Configuring SPICE console options](Configuring_SPICE_console_options1)
 * [SPICE Console Options](SPICE_Console_Options)
 * [VNC Console Options](VNC_Console_Options)
 * [RDP Console Options](RDP_Console_Options)

### Remote Viewer Options

 * [Using SPICE connection options](Using_SPICE_connection_options1)
 * [SPICE hotkeys](SPICE_hotkeys1)
 * [Manually Associating console.vv Files with Remote Viewer](Manually_Associating_console.vv_Files_with_Remote_Viewer)

## Configuring a Watchdog

* [Adding a Watchdog Card to a Virtual machine](Adding_a_Watchdog_Card_to_a_Virtual_machine)
* [Configuring a Watchdog](Configuring_a_Watchdog)
* [Confirming Watchdog Functionality](Confirming_Watchdog_Functionality)
* [Parameters for Watchdogs in watchdog.conf](Parameters_for_Watchdogs_in_watchdog.conf)

<!-- end section -->

* [Configuring virtual NUMA](Configuring_virtual_NUMA)
* [Configuring Satellite Errata](Configuring_Satellite_Errata)
