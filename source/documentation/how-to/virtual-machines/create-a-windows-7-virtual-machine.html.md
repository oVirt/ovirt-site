---
title: How to create a Windows 7 Virtual Machine
category: howto
authors: jonar, nkesick
---

# How to create a Windows 7 Virtual Machine

## Introduction

In your current configuration, you should have at least one host available for running virtual machines, and uploaded the required installation images to your ISO domain. This section guides you through the creation of a Windows 7 virtual machine. You will perform a normal attended installation using a virtual DVD.

### VirtIO interfaces

**Please read this section** before jumping to the installation part. If you are familiar with Linux VMs on oVirt you know that the default options work fairly well. This is not the case with Windows.

*   For Disks there are three interface options - VirtIO, VirtIO-SCSI, and IDE. **VirtIO** (default) is the recommended interface but it requires additional drivers to be present at install and after the installation, much like servers or desktops with RAID and SCSI interfaces. **IDE** is an optional alternative that does not require the additional drivers but may show some performance issues.
*   For Networking there are three interface options - VirtIO, e1000, and rtl8139. **VirtIO** (default) is the recommended interface but it requires additional drivers to be present after the installation which is a common issue for Windows desktops and servers after reinstalling the OS. **e1000** and **rtl8139** are optional alternatives that do not require the additional drivers (depending on the Windows OS) but may show some performance issues. The network interface can be changed after installing.

Loading the VirtIO drivers and using the alternatives is covered in the install directions below. If you would like to use the VirtIO interfaces you only need to add the VirtIO disk to your ISO domain. [Please see this section to download the VirtIO ISO from Fedora](/documentation/internal/guest-agent/understanding-guest-agents-and-other-tools#VirtIO_Drivers) which contains signed drivers for Windows.

## Creating a Windows 7 VM

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

    ![](/images/wiki/Navigation_Tabs.png "Navigation_Tabs.png")<br>
    Figure 1.1: The navigation tabs

2. The “New Virtual Machine” popup appears.

    ![](/images/wiki/New_VM_Win7.png "New_VM_Win7.png")<br>
    Figure 1.2: Create new Windows virtual machine

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Windows 7 (for 32-bit Windows) or Windows7 x64 (for 64-bit Windows).

5. Under Optimized For, choose Desktop.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK.

      Note: By clicking “Additional Options” you can configure other details such as memory and CPU resources. You can change these after creating a VM as well, 

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

    ![](/images/wiki/Guide_Me.png "Guide_Me.png")<br>
    Figure 1.3. New Virtual Machine – Guide Me

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Click OK.

      The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary. 

      ![](/images/wiki/Add_Virtual_Disk_Win7.png "Add_Virtual_Disk_Win7.png")<br>
      Figure 1.4. Add Virtual Disk configurations

      Note: [As mentioned above](/documentation/how-to/virtual-machines/create-a-windows-7-virtual-machine#VirtIO_interfaces), when using the VirtIO interface (recommended) additional drivers are required at install time. You can use the IDE interface instead which does not require the additional drivers. The OS install guide covers both VirtIO and IDE interfaces below.

13. Close the Guide Me window by clicking Configure Later. Your new Windows 7 virtual machine will display in the Virtual Machines tab.

You have now created your Windows 7 virtual machine. Before you can use your virtual machine you need to install an operating system on it.

## Installing an Operating System

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

      Note: If you do not have any in the list, you need to upload one.

3. Click OK.

    ![](/images/wiki/Run_Once_Win7.png "Run_Once_Win7.png")<br>
    Figure 2.1. Run once menu

    Retain the default settings for the other options and click OK to start the virtual machine. 

4. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system.

5. Continue with the Windows 7 install as normal until you reach "Where do you want to install Windows?"

### Installing with a VirtIO interface

You need to load the VirtIO driver.

1. On the Navigation Tabs, click Change CD

    ![Change CD](/images/wiki/Navigation_Tabs_Change_CD.png "fig:Change CD")

2. From the drop down list select the virtio CD and click OK.

3. On the console, click "Load Drivers"

4. On the "Load Driver" popup, click Browse

5. Browse to the CD, Win7 folder. Choose the appropriate architecture (AMD64 for 64-bit, x86 for 32-bit) and click OK.

6. The VirtIO Drivers should appear. Choose "Red Hat VirtIO SCSI Controller", and then click Next

    ![Drivers Available](/images/wiki/Install_Windows7_VirtIO_Drivers.png "fig:Drivers Available")

7. The driver should install and return to the "Where do you want to install Windows?" screen now showing a disk to install to. Note that a message has appeared that "Windows cannot be installed to this disk"

8. On the Navigation Tabs, click Change CD.

9. From the drop down list select the Windows 7 install media and click OK.

10. On the console, click "Refresh". The "Windows cannot be installed to this disk" message should disappear as the system can see the Windows install media again.

11. Continue with the install as normal.

### Installing with a IDE interface

"Where do you want to install Windows?" shows a disk to install to. Continue as normal.

## Post Install Additions

### Drivers

If you choose to use the VirtIO disk interface, the VirtIO network interface, or wish to use the oVirt Guest Tools through the VirtIO-Serial interface, you need to install additional drivers.

![Device Manager](/images/wiki/Device_Manager_Win7_Missing_Drivers_VirtIO.png "fig:Device Manager")

1. On the console, open the Device Manager

2. On the Navigation Tabs, click Change CD.

3. From the drop down list select the virtio CD and click OK.

4. On the console, right click the first device that is missing drivers

5. Select "Update Driver Software", and then "Browse my computer for driver software"

6. Browse to the CD, Win7 folder. Choose the appropriate architecture (AMD64 for 64-bit, x86 for 32-bit) and click OK.

7. When prompted to install the driver, check "Always trust software from Red Hat, Inc" and click Install.

8. Repeat the above for the remaining missing drivers.

#### Graphics

To install the graphics driver (aka "Video Controller (VGA compatible)") if you are using the Spice console, download and install the [Spice Guest Tools](http://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-0.74.exe). When prompted, click "Continue Anyway".

### Guest Tools

Adding a few guest tools may improve your experience.

*   oVirt Guest Agent allows oVirt to show the Memory and Network utilization of the VM, the IP address of the VM, the installed Applications, Enable Single Sign On (SSO) and more.
*   Spice-vdagent allows for copy and paste support (text & image), better mouse functionality, and automatic adjustment of the screen resolution based on the size of your window.
