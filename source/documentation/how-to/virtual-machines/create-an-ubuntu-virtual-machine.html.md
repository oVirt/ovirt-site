---
title: How to create an Ubuntu Virtual Machine
category: howto
authors: nkesick
wiki_title: How to create a Ubuntu Virtual Machine
wiki_revision_count: 1
wiki_last_updated: 2013-12-14
---

<!-- TODO: Content review -->

# How to create a Ubuntu Virtual Machine

## Introduction

In your current configuration, you should have at least one host available for running virtual machines, and uploaded the required installation images to your ISO domain. This section guides you through the creation of a Ubuntu virtual server. You will perform a normal attended installation using a virtual DVD.

## Creating a Ubuntu VM

1.  From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.<br>
    ![](/images/wiki/Navigation_Tabs.png "fig:Navigation_Tabs.png")<br>
    Figure 1.1: The navigation tabs

2.  The “New Virtual Machine” popup appears.<br>
    ![](/images/wiki/New_VM_Ubuntu.png "fig:New_VM_Ubuntu.png")<br>
    Figure 1.2: Create new Linux virtual machine

3.  Under General, your default Cluster and Template will be fine.
4.  For Operating System, choose a relevant Operating System Name
5.  Under Optimized For, choose Desktop if you are creating a desktop VM, or Server if you are creating a server VM.
6.  Add a Name (required) and a comment or description (optional).
7.  Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.
8.  Click OK<br>
    Note: By clicking “Additional Options” you can configure other details such as memory and CPU resources. You can change these after creating a VM as well,

9.  A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.<br>
    ![](/images/wiki/Guide_Me.png "fig:Guide_Me.png")<br>
    Figure 1.3. New Virtual Machine – Guide Me

10. Click Configure Virtual Disks to add storage to the virtual machine.
11. Enter a Size for the disk.
12. Click OK.<br>
    The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary.<br>
    ![](/images/wiki/Add_Virtual_Disk_Ubuntu.png "fig:Add_Virtual_Disk_Ubuntu.png")<br>
    Figure 1.4. Add Virtual Disk configurations

13. Close the Guide Me window by clicking Configure Later. Your new Ubuntu virtual machine will display in the Virtual Machines tab.

You have now created your Ubuntu virtual machine. Before you can use your virtual machine, install an operating system on it.

## Installing an Operating System

1.  Right click the virtual machine and select Run Once.
2.  Check “Attach CD” and choose a disk from the list<br>
    Note: If you do not have any in the list, you need to upload one.

3.  Click OK.<br>
    ![](/images/wiki/Run_Once_Ubuntu.png "fig:Run_Once_Ubuntu.png")<br>
    Figure 2.1. Run once menu<br>
    Retain the default settings for the other options and click OK to start the virtual machine.

4.  Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system. For further instructions, see the [Official Ubuntu Documentation](https://help.ubuntu.com/). Select your version, and then Installing Ubuntu.
5.  After the installation has completed, shut down the virtual machine and reboot from the hard drive.

You can now connect to your Ubuntu virtual machine and start using it.

## Post Install Additions

Adding a few guest tools may improve your experience.

*   oVirt Guest Agent allows oVirt to show the Memory and Network utilization of the VM, the IP address of the VM, the installed Applications, Enable Single Sign On (SSO) and more.
*   Spice-vdagent allows for copy and paste support (text & image), better mouse functionality, and automatic adjustment of the screen resolution based on the size of your window.

1.  Add the oVirt Guest Agent by following the directions at [How to install the guest agent in Ubuntu](/documentation/how-to/guest-agent/install-the-guest-agent-in-ubuntu/)
2.  Add the Spice-vdagent by following the directions at <<UNWRITTEN>>
