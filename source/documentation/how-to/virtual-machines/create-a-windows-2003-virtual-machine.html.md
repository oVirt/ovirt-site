---
title: How to create a Windows 2003 Virtual Machine
category: howto
authors: nkesick
---

<!-- TODO: Content review -->

# How to create a Windows 2003 Virtual Machine

## Introduction

In your current configuration, you should have at least one host available for running virtual machines, and uploaded the required installation images to your ISO domain. This section guides you through the creation of a Windows 2003 virtual machine. You will perform a normal attended installation using a virtual CD.

### VirtIO interfaces

**Please read this section** before jumping to the installation part. If you are familiar with Linux VMs on oVirt you know that the default options work fairly well. This is not the case with Windows.

*   For Disks there are three interface options - VirtIO, VirtIO-SCSI, and IDE. **VirtIO** (default) is the recommended interface but it requires additional drivers to be present at install and after the installation, much like servers or desktops with RAID and SCSI interfaces. **The VirtIO drivers cannot be installed at install time** in Windows 2003, therefore **IDE** is what must be used as it does not require the additional drivers but may show some performance issues.
*   For Networking there are four interface options - VirtIO, Dual Mode VirtIO/rlt8139, e1000, and rtl8139. **VirtIO** (default) is the recommended interface but it requires additional drivers to be present after the installation which is a common issue for Windows desktops and servers after reinstalling the OS. **rtl8139** is an optional alternative that does not require the additional drivers (depending on the Windows OS) but may show some performance issues. The network interface can be changed after installing.

Loading the VirtIO drivers and using the alternatives is covered in the install directions below. If you would like to use the VirtIO interfaces you only need to add the VirtIO disk to your ISO domain. [Please see this section to download the VirtIO ISO from Fedora](/documentation/internal/guest-agent/understanding-guest-agents-and-other-tools#VirtIO_Drivers), which contains signed drivers for Windows.

## Creating a Windows 2003 VM

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

    ![](/images/wiki/Navigation_Tabs.png "Navigation_Tabs.png")<br>
    Figure 1.1: The navigation tabs

2. The “New Virtual Machine” popup appears.

    ![](/images/wiki/New_VM_Win2003.png "New_VM_Win2003.png")<br>
    Figure 1.2: Create new Windows virtual machine

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Windows 2003 (for 32-bit Windows) or Windows 2003 x64 (for 64-bit Windows).

5. Under Optimized For, choose Server.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK.

      Note: By clicking “Additional Options” you can configure other details such as memory and CPU resources. You can change these after creating a VM as well, 

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

    ![](/images/wiki/Guide_Me.png "Guide_Me.png")<br>
    Figure 1.3. New Virtual Machine – Guide Me

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Change the Interface to IDE

13. Click OK

      The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary. 

      ![](/images/wiki/Add_Virtual_Disk_Win2003.png "Add_Virtual_Disk_Win2003.png")<br>
      Figure 1.4. Add Virtual Disk configurations

      Note: As mentioned above, Windows 2003 does not support using the VirtIO interface and the additional drivers cannot be installed. You must use the IDE interface instead which does not require the additional drivers. 

14. Close the Guide Me window by clicking Configure Later. Your new Windows 2003 virtual machine will display in the Virtual Machines tab.

You have now created your Windows 2003 virtual machine. Before you can use your virtual machine you need to install an operating system on it.

## Installing an Operating System

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

      Note: If you do not have any in the list, you need to upload one.

3. Change the boot order so that CDROM is first

4. Click OK.

    ![](/images/wiki/Run_Once_Win2003.png "Run_Once_Win2003.png")<br>
    Figure 2.1. Run once menu

    Retain the default settings for the other options and click OK to start the virtual machine. 

5. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system.

6. Continue with the Windows 2003 install as normal.

## Post-Install Additions

### Drivers

#### VirtIO

If you wish to use the oVirt Guest Tools through the VirtIO-Serial interface, the VirtIO network interface, or a SCSI disk you need to install additional drivers.

![Device Manager](/images/wiki/Device_Manager_Win2003_Missing_Drivers_VirtIO.png "fig:Device Manager")

1. On the console, open the Device Manger

2. On the Navigation Tabs, click Change CD.

  ![Change CD](/images/wiki/Navigation_Tabs_Change_CD.png "fig:Change CD")

3. From the drop down list select the virtio CD and click OK.

##### VirtIO Serial

1. On the console, right click the **PCI Simple Communications Controller** device that is missing drivers

2. Select "Update Driver", and then click Next

3. Choose "Install from a list or a specific location", and then click Next

4. **UNCHECK Search removable media or else it will install the Windows 8 drivers and error**

5. Check "Include this location in the search", Browse to "X:\\Wnet\\X86" (for 32-bit) or "X:\\Wnet\\AMD64" (for 64-bit) and then click Next

6. When prompted, choose "Continue Anyway"

##### VirtIO Networking

1. On the console, right click the **Ethernet Controller** device that is missing drivers

2. Select "Update Driver", and then click Next

3. Choose "Install from a list or a specific location", and then click Next

4. **UNCHECK Search removable media or else it will install the Windows 8 drivers and error**

5. Check "Include this location in the search", Browse to "X:\\XP\\X86" (for 32-bit and yes, this time X:\\XP\\X86) or "X:\\XP\\AMD64" (for 64-bit)and then click Next

6. When prompted, choose "Continue Anyway"

##### VirtIO SCSI

1. On the console, right click the **SCSI Controller** device that is missing drivers

2. Select "Update Driver", and then click Next

3. Choose "Install from a list or a specific location", and then click Next

4. **UNCHECK Search removable media or else it will install the Windows 8 drivers and error**

5. Check "Include this location in the search", Browse to "X:\\Wnet\\X86" (for 32-bit) or "X:\\Wnet\\AMD64" (for 64-bit) and then click Next

6. If prompted, choose "Continue Anyway"

      Note: There may be two "SCSI Controllers" which need drivers. There are drivers for one "Red Hat SCSI Controller", but there are no 2003 drivers for "Red Hat SCSI Pass-through"If the drivers do not install on one, try the other SCSI Controller if a second exists.

#### Graphics

To install the graphics driver (aka "Video Controller (VGA compatible)") if you are using the Spice console, download and install the [Spice Guest Tools](http://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-0.65.1.exe). When prompted, click "Continue Anyway".

### Guest Tools

Adding a few guest tools may improve your experience.

*   oVirt Guest Agent allows oVirt to show the Memory and Network utilization of the VM, the IP address of the VM, the installed Applications, Enable Single Sign On (SSO) and more.
*   Spice-vdagent allows for copy and paste support (text & image), better mouse functionality, and automatic adjustment of the screen resolution based on the size of your window.

Add the Spice-vdagent by following the directions above under graphics.
