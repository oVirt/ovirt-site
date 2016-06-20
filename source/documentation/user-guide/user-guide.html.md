---
title: oVirt User Guide
category: documentation
authors: bproffitt
wiki_title: OVirt User Guide
wiki_revision_count: 2
wiki_last_updated: 2014-10-03
---

# OVirt User Guide

## ⁠Accessing the User Portal

### Logging in to the User Portal

Log in to the oVirt User Portal directly from your web browser.

**Procedure 1.1. Logging in to the User Portal**

1.  Enter the provided **User Portal URL** in the address bar of your web browser. The address must be in the format of `https://server.example.com/UserPortal`. The login screen displays.
    Alternately, enter the provided **server address** into the web browser, to access the welcome screen. Click **User Portal** to be directed to the User Portal.

    ⁠

    ![The User Portal Login Selection Screen](Portal Selection.png "The User Portal Login Selection Screen")

    **Figure 1.1. The User Portal Login Selection Screen**

2.  Enter your **User Name** and **Password**. Use the **Domain** drop-down menu to select the correct domain.
    ⁠

    ![The User Portal Login Screen](User Portal Login.png "The User Portal Login Screen")

    **Figure 1.2. The User Portal Login Screen**

    -   If you have only one running virtual machine in use, select the **Connect Automatically** check box and connect directly to your virtual machine.
    -   If you have more than one running virtual machine or do not want to automatically connect to a virtual machine, do not select the **Connect Automatically** check box.
    -   Select the language in which the User Portal is presented by using the drop-down menu at the lower-right of the login window.

3.  Click **Login**. The list of virtual machines assigned to you displays.
    ⁠

    ![User Portal](User Portal.png "User Portal")

    **Figure 1.3. User Portal**

### Logging out of the User Portal

⁠

**Logging out of the User Portal:**

*   At the title bar of the User Portal, click **Sign out**. You are logged out and the User Portal login screen displays.

### Logging in for the First Time: Installing the Engine Certificate

#### Installing oVirt Certificate in Firefox

**Summary**

The first time you access the User Portal, you must install the certificate used by oVirt to avoid security warnings.

⁠

**Procedure 1.2. Installing oVirt Certificate in Firefox**

1.  Navigate to the URL for the User Portal in Firefox.
2.  Click **Add Exception** to open the **Add Security Exception** window.
3.  Ensure the **Permanently store this exception** check box is selected.
4.  Click the **Confirm Security Exception** button.

**Result**

You have installed the certificate used by the Red hat Enterprise Virtualization Manager and security warnings no longer appear when you access the User Portal.

## ⁠Installing Supporting Components

### Installing Console Components

#### Console Components

A console is a graphical window that allows you to view the start up screen, shut down screen and desktop of a virtual machine, and to interact with that virtual machine in a similar way to a physical machine. In oVirt, the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on the client machine prior to use.

#### Installing Remote Viewer on Linux

Remote Viewer is an application for opening a graphical console to virtual machines. Remote Viewer is a SPICE client that is included the virt-viewer package provided by the `Red Hat Enterprise Linux Workstation (v. 6 for x86_64)` channel.

**Procedure 2.1. Installing Remote Viewer on Linux**

1.  Run the following command to install the spice-xpi package and dependencies:
        # yum install spice-xpi

2.  Run the following command to check whether the **virt-viewer** package has already been installed on your system:
        # rpm -q virt-viewer
        virt-viewer-0.5.2-18.el6_4.2.x86_64

    If the virt-viewer package has not been installed, run the following command to install the package and its dependencies:

        # yum install virt-viewer

3.  Restart Firefox for your changes to take effect.

The SPICE plug-in is now installed. You can now connect to your virtual machines using the SPICE protocol.

## ⁠The Basic Tab

### Basic Tab Graphical Interface

The **Basic** tab enables you to view and use all the virtual machines that are available to you. The screen consists of three areas: the title bar, a virtual machines area, and a details pane. A number of control buttons allow you to work with the virtual machines.

![The User Portal](User Portal Callouts.png "The User Portal")

**Figure 3.1. The User Portal**

The title bar (1) includes the name of the **User** logged in to the portal and the **Sign Out** button.

In the virtual machines area, the name of the virtual machines or virtual machine pools assigned to you display (2). The logo of the virtual machine's operating system also displays (3). When a virtual machine is powered up, you can connect to it by double-clicking on the virtual machine's logo.

On each virtual machine's icon, buttons allow you to play, stop or pause a virtual machine. The buttons perform the same functions as buttons on a media player (4).

*   ![](Up.png "fig:Up.png") The green play button starts up the virtual machine. It is available when the virtual machine is paused, stopped or powered off.
*   ![](Down.png "fig:Down.png") The red stop button stops the virtual machine. It is available when the virtual machine is running.
*   ![](Suspend.png "fig:Suspend.png") The blue pause button temporarily halts the virtual machine. To restart it, press the green play button.
*   ![](Reboot.png "fig:Reboot.png") The green reboot button reboots the virtual machine. It is available when the virtual machine is running.

The status of the virtual machine is indicated by the text below the virtual machine's icon - **Machine is Ready** or **Machine is Down**.

Clicking on a virtual machine displays the statistics of the selected virtual machine on the details pane to the right (5), including the operating system, defined memory, number of cores and size of virtual drives. You can also configure connection protocol options (6) such as enabling the use of USB devices or local drives.

### Running Virtual Machines

#### Running Virtual Machines - Overview

In the User Portal, virtual machines are represented by icons that indicate both type and status. The icons indicate whether a virtual machine is part of a virtual machine pool or is a standalone Windows or Linux virtual machine. The icons also reflect whether the virtual machine is running or stopped.

The User Portal displays a list of the virtual machines assigned to you. You can turn on one or more virtual machines, connect, and log in. You can access virtual machines that are running different operating systems, and you can use multiple virtual machines simultaneously.

In contrast, if you have only one running virtual machine and have enabled automatic connection, you can bypass the User Portal and log in directly to the virtual machine, similar to how you log in to a physical machine.

#### Turning on a Virtual Machine

To use a virtual machine in the User Portal, you must turn it on and then connect to it. If a virtual machine is turned off, it is grayed out and displays **Machine is Down**.

You can be assigned an individual virtual machine or assigned to one or more virtual machines that are part of a virtual machine pool. Virtual machines in a pool are all clones of a base template, and have the same operating system and installed applications.

<div class="alert alert-info">
**Note:** When you take a virtual machine from a virtual machine pool, you are not guaranteed to receive the same VM each time. However, if you configure console options for a VM taken from a virtual machine pool, those options are saved as the default for all VMs taken from that virtual machine pool.

</div>
⁠

**Procedure 3.1. Turning on a Virtual Machine**

1.  Turn on the standalone virtual machine or take a virtual machine from a pool as follows:
    -   To turn on a standalone virtual machine, select the virtual machine icon and click the ![](Up.png "fig:Up.png") button.
        ⁠

        ![Turn on virtual machine](VM Powered Down.png "Turn on virtual machine")

        **Figure 3.2. Turn on virtual machine**

    -   To take a virtual machine from a pool, select the virtual machine pool icon and click the ![](Up.png "fig:Up.png") button.
        ⁠

        ![Take virtual machine from a pool](VM From Pool.png "Take virtual machine from a pool")

        **Figure 3.3. Take virtual machine from a pool**

        If there is an available virtual machine in the pool, an icon for that virtual machine will appear in your list. The rest of this procedure then applies to that virtual machine. If you can take multiple virtual machines from a pool, the icon for the virtual machine pool will change into an icon for the last virtual machine you have taken when you take the maximum number of virtual machines possible for that pool.

2.  The virtual machine powers up.
    ⁠

    ![Virtual machine powering up](VM Powering Up.png "Virtual machine powering up")

    **Figure 3.4. Virtual machine powering up**

3.  When the virtual machine is powered up, the icon is no longer grayed out. The text displays as **Machine is Ready**. You are now ready to connect.
    ⁠

    ![Virtual machine turned on](VM Powered Up.png "Virtual machine turned on")

    **Figure 3.5. Virtual machine turned on**

<div class="alert alert-info">
**Note:** You can only connect to a virtual machine after it has powered up.

</div>
#### Connecting to a Powered-On Virtual Machine

After a virtual machine has been turned on, you can connect to it, log in, and start work the same way that you would with a physical machine. The text "Machine is Ready" displays on virtual machines that are powered up.

**Procedure 3.2. Connecting to a Powered on Virtual Machine**

1.  Double-click on the selected virtual machine to connect.
    ⁠

    ![Connect to Virtual Machine](Connect to a VM.png "Connect to Virtual Machine")

    **Figure 3.6. Connect to Virtual Machine**

2.  A console window of the virtual machine displays. You can now use the virtual machine in the same way that you would use a physical desktop.

<div class="alert alert-info">
**Note:** The first time you connect with SPICE, you are prompted to install the appropriate SPICE component or plug-in. If it is the first time you are connecting from a Red Hat Enterprise Linux computer, install the SPICE plug-in for Mozilla Firefox. If you are connecting from a Windows computer, install the ActiveX plug-in.

</div>
#### Logging Out of a Virtual Machine

It is recommended that you log out from a virtual machine before shutting it down, to minimize the risk of data loss. Additionally, if you attempt to forcefully shut down a virtual machine from the User Portal, it might freeze with a status of **Powering Down**. To gracefully turn off a virtual machine, use the following steps.

**Procedure 3.3. Shutting Down a Virtual Machine**

1.  Log out of the guest operating system.
2.  If you were using your virtual machine in full screen mode, press **Shift**+**F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.
3.  To shut down the virtual machine, click the ![](Down.png "fig:Down.png") button. The virtual machine is grayed out and displays as "Machine is Down" when it has been turned off.

## ⁠Chapter 4. The Extended Tab

### The Extended Tab Graphical Interface

The **Extended** tab graphical interface enables you to access and monitor all the virtual resources that are available to you. Eight elements of the **Extended** tab are explained below.

![The Extended Tab](Extended Tab Callouts.png "The Extended Tab")

**Figure 4.1. The Extended Tab**

**Table 4.1. The Extended Tab**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Number</p></th>
<th align="left"><p>Element Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>1</p></td>
<td align="left"><p>Title Bar</p></td>
<td align="left"><p>Includes the name of the <strong>User</strong> logged in to the portal and the <strong>Sign Out</strong> button.</p></td>
</tr>
<tr class="even">
<td align="left"><p>2</p></td>
<td align="left"><p>User Portal View Option Tabs</p></td>
<td align="left"><p>Power Users have access to the <strong>Extended</strong> tab of the User Portal and the <strong>Basic</strong> tab of the User Portal. The <strong>Basic</strong> view is the default view for users with basic permissions.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>3</p></td>
<td align="left"><p>Navigation Pane</p></td>
<td align="left"><p>The Navigation Pane allows you to toggle between the Virtual Machines, Templates, and Resources tabs.</p></td>
</tr>
<tr class="even">
<td align="left"><p>4</p></td>
<td align="left"><p>Management Bar</p></td>
<td align="left"><p>The management bar is used to create and make changes to virtual machines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>Virtual Machine List</p></td>
<td align="left"><p>The list of virtual machines, with the operating systems installed on them and their statuses (running, paused, or stopped).</p></td>
</tr>
<tr class="even">
<td align="left"><p>6</p></td>
<td align="left"><p>Virtual Machine Control Buttons</p></td>
<td align="left"><p>Virtual Machine Control Buttons allow you to play, stop, pause, or power off virtual machines.</p>
<ul>
<li><img src="Up.png" title="fig:Up.png" alt="Up.png" /> The green play button starts the virtual machine. It is available when the virtual machine is paused, stopped or powered off.</li>
<li><img src="Down.png" title="fig:Down.png" alt="Down.png" /> The red stop button stops the virtual machine. It is available when the virtual machine is running.</li>
<li><img src="Suspend.png" title="fig:Suspend.png" alt="Suspend.png" /> The blue pause button temporarily halts the virtual machine. To restart it, press the green play button.</li>
<li><img src="Power.png" title="fig:Power.png" alt="Power.png" /> The power button turns off the virtual machine. It is available when the virtual machine is running.</li>
<li><img src="Reboot.png" title="fig:Reboot.png" alt="Reboot.png" /> The reboot button restarts the virtual machine. It is available when the virtual machine is running.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p>7</p></td>
<td align="left"><p>Console Button</p></td>
<td align="left"><p>The console button launches a SPICE window and connects to machines that have been powered-up.</p></td>
</tr>
<tr class="even">
<td align="left"><p>8</p></td>
<td align="left"><p>Details Pane</p></td>
<td align="left"><p>The Details Pane displays the statistics of the virtual machine selected in the Navigation Pane.</p></td>
</tr>
</tbody>
</table>

**Details Pane Tab Functions:**

*   The **General** tab displays basic software and hardware information of the virtual machine, including its name, operating system, display protocol and defined memory.
*   The **Network Interfaces** tab displays the name, type and speed of the network connected to the virtual machine. You can add, edit and remove network interfaces using this tab.
*   The **Disks** tab displays the name, size and format of the disk attached to the virtual machine. You can add, edit and remove virtual disks using this tab.
*   The **Snapshots** tab displays a view of the virtual machine's operating system and applications. You can create and use snapshots using this tab.
*   The **Permissions** tab displays the users and roles assigned to each virtual machine. You can assign and remove user permissions using this tab.
*   The **Events** tab displays the description and time of events which affect the virtual machine.
*   The **Applications** tab displays the applications which have been installed on the virtual machine.
*   The **Monitor** tab displays the CPU Usage, Memory Usage, and Network Usage statistics for the machine selected in the Navigation Pane.
*   The **Sessions** tab displays the Logged-In User, Console User, and Console Client IP for the machine selected in the Navigation Pane.

### Running Virtual machines

#### Running Virtual Machines Introduction

This chapter describes how to run, connect to and stop virtual machines on the Power User Portal. You can use multiple virtual machines simultaneously, or use machines running different operating systems.

#### Connecting to Virtual Machines

After you have logged into the portal, you can start, stop, or connect to the virtual machines that are displayed.

**Summary**

This procedure describes how to start a stopped virtual machine, and how to connect to the virtual machine.

**Procedure 4.1. Connecting to Virtual Machines**

1.  Select the virtual machine to which you want to connect, then click the Play ![](Up.png "fig:Up.png") button. The virtual machine powers up.
    ![Virtual machine turned off](Extended VM Powered Down.png "Virtual machine turned off")

    **Figure 4.2. Virtual machine turned off**

    The Stop symbol next to the virtual machine's name changes to a Powering Up symbol.When the virtual machine is turned on, the Play symbol displays next to the virtual machine's name.

    ⁠

    ![Virtual machine turned on](Extended VM Powering Up.png "Virtual machine turned on")

    **Figure 4.3. Virtual machine powering up**

2.  Click the **Console** button to connect to the virtual machine.
    ⁠

    ![Connect to virtual machine](Extended Connect to a VM.png "Connect to virtual machine")

    **Figure 4.4. Connect to virtual machine**

3.  If it is the first time connecting with SPICE, you will be prompted to install the appropriate SPICE component or plug-in. If you are connecting from a Windows computer, install the ActiveX component. If you are connecting from a Red Hat Enterprise Linux computer, install the Mozilla Firefox plug-in.

A console window of the virtual machine displays. You can now use the virtual machine in the same way that you would use a physical desktop.

**Result**

You have started a stopped virtual machine and connected to it.

<div class="alert alert-info">
**Warning:** By default, a virtual machine running Windows 7 will be suspended after an hour of inactivity. This prevents users from connecting to the virtual machine from the User Portal. To avoid this, disable the power-saving feature on the guest's power manager.

</div>
#### Turning Off a Virtual Machine from the User Portal

If you attempt to turn off a virtual machine from the User Portal, it might freeze with a status of **Powering Down**, indicating that it has not completely shut down. Use the following procedure to gracefully turn off a virtual machine from within the User Portal.

<div class="alert alert-info">
**Important:** To minimize the risk of data loss, log off from a virtual machine before turning it off.

</div>
**Summary**

This procedure explains how to turn off a virtual machine from the User Portal.

**Procedure 4.2. Turning Off a Virtual Machine from the User Portal**

1.  Log out of the guest operating system.
2.  If you were using your virtual machine in full screen mode, press **Shift**+**F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.
3.  To turn off the virtual machine, click the ![](Down.png "fig:Down.png") button. The Stop symbol appears next to the name of the virtual machine when it has been turned off.

**Result**

You have turned off a virtual machine.

<div class="alert alert-info">
**Note:** You can also turn off virtual machines gracefully using the native method from within the virtual machine itself. For example, in Windows virtual machines you can click **Start** → **Shut Down**, and in Red Hat Enterprise Linux virtual machines you can click **System** → **Shut Down**.

</div>
#### Rebooting a Virtual Machine from the User Portal

<div class="alert alert-info">
**Important:** To minimize the risk of data loss, log off from a virtual machine before rebooting.

</div>
**Summary**

This procedure explains how to reboot a virtual machine from the User Portal.

⁠

**Procedure 4.3. Rebooting a Virtual Machine from the User Portal**

1.  Log out of the guest operating system.
2.  If you were using your virtual machine in full screen mode, press **Shift**+**F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.
3.  To reboot the virtual machine, click the ![](Reboot.png "fig:Reboot.png") button. The Reboot symbol appears next to the name of the virtual machine while it is rebooting, then changes back to a Play symbol when reboot completes.

**Result**

You have rebooted a virtual machine.

### Creating Virtual Machines

#### Creating a Virtual Machine

**Summary**

You can create a virtual machine using a blank template and configure all of its settings.

**Procedure 4.4. Creating a Virtual Machine**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
    ⁠

    ![The New Virtual Machine Window](New_Virtual_Machine.png "The New Virtual Machine Window")

    **Figure 4.5. The New Virtual Machine Window**

3.  On the **General** tab, fill in the **Name** and **Operating System** fields. You can accept the default settings for other fields, or change them if required.
4.  Alternatively, click the **Initial Run**, **Console**, **Host**, **Resource Allocation**, **Boot Options**, and **Custom Properties** tabs in turn to define options for your virtual machine.
5.  Click **OK** to create the virtual machine and close the window. The **New Virtual Machine - Guide Me** window opens.
6.  Use the Guide Me buttons to complete configuration or click **Configure Later** to close the window.

**Result**

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`. Before you can use this virtual machine, add at least one network interface and one virtual disk, and install an operating system.

#### Creating a Virtual Machine Based on a Template

**Summary**

You can create virtual machines based on templates. This allows you to create virtual machines that are pre-configured with an operating system, network interfaces, applications and other resources.

<div class="alert alert-info">
**Note:** Virtual machines created based on a template depend on that template. This means that you cannot remove that template from the Manager if there is a virtual machine that was created based on that template. However, you can clone a virtual machine from a template to remove the dependency on that template.

</div>
**Procedure 4.5. Creating a Virtual Machine Based on a Template**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
3.  Select the **Cluster** on which the virtual machine will run.
4.  Select a template from the **Based on Template** drop-down menu.
5.  Select a template sub version from the **Template Sub Version** drop-down menu.
6.  Enter a **Name**, **Description** and any **Comments**, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.
7.  Click the **Resource Allocation** tab.
    ⁠

    ![Provisioning - Thin](New_Virtual_Machine_Resource_Allocation.png "Provisioning - Thin")

    **Figure 4.6. Provisioning - Thin**

8.  Select the **Thin** radio button in the **Storage Allocation** area.
9.  Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.
    -   Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.
    -   Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

10. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.
11. Click **OK**.

**Result**

The virtual machine is created and displayed in the list in the **Virtual Machines** tab. You can now log on to the virtual machine and begin using it, or assign users to it.

#### Creating a Cloned Virtual Machine Based on a Template

**Summary**

Cloned virtual machines are similar to virtual machines based on templates. However, while a cloned virtual machine inherits settings in the same way as a virtual machine based on a template, a cloned virtual machine does not depend on the template on which it was based after it has been created.

<div class="alert alert-info">
**Note:** If you clone a virtual machine from a template, the name of the template on which that virtual machine was based is displayed in the **General** tab of the **Edit Virtual Machine** window for that virtual machine. If you change the name of that template, the name of the template in the **General** tab will also be updated. However, if you delete the template from the Manager, the original name of that template will be displayed instead.

</div>
⁠

**Procedure 4.6. Cloning a Virtual Machine Based on a Template**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
3.  Select the **Cluster** on which the virtual machine will run.
4.  Select a template from the **Based on Template** drop-down menu.
5.  Select a template sub version from the **Template Sub Version** drop-down menu.
6.  Enter a **Name**, **Description** and any **Comments**. You can accept the default values inherited from the template in the rest of the fields, or change them if required.
7.  Click the **Resource Allocation** tab.
    ⁠

    ![Provisioning - Clone](New Virtual Machine Clone Allocation.png "Provisioning - Clone")

    **Figure 4.7. Provisioning - Clone**

8.  Select the **Clone** radio button in the **Storage Allocation** area.
9.  Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.
    -   Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.
    -   Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

10. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.
11. Click **OK**.

<div class="alert alert-info">
**Note:** Cloning a virtual machine may take some time. A new copy of the template's disk must be created. During this time, the virtual machine's status is first **Image Locked**, then **Down**.

</div>
**Result**

The virtual machine is created and displayed in the list in the **Virtual Machines** tab. You can now assign users to it, and can begin using it when the clone operation is complete.

### Configuring Virtual Machines

#### Completing the Configuration of a Virtual Machine by Defining Network Interfaces and Hard Disks

**Summary**

Before you can use your newly created virtual machine, the **Guide Me** window prompts you to configure at least one network interface and one virtual disk for the virtual machine.

**Procedure 4.7. Completing the Configuration of a Virtual Machine by Defining Network Interfaces and Hard Disks**

1.  On the **New Virtual Machine - Guide Me** window, click the **Configure Network Interfaces** button to open the **New Network Interface** window. You can accept the default values or change them as necessary.
2.  Enter the **Name** of the network interface.
3.  Use the drop-down menus to select the **Network** and the **Type** of network interface for the new virtual machine. The **Link State** is set to **Up** by default when the NIC is defined on the virtual machine and connected to the network.
    <div class="alert alert-info">
    **Note:** The options on the **Network** and **Type** fields are populated by the networks available to the cluster, and the NICs available to the virtual machine.

    </div>
4.  If applicable, select the **Specify custom MAC address** check box and enter the network interface's MAC address.
5.  Click the arrow next to **Advanced Parameters** to configure the **Port Mirroring** and **Card Status** fields, if necessary.
6.  Click **OK** to close the **New Network Interface** window and open the **New Virtual Machine - Guide Me** window.
7.  Click the **Configure Virtual Disk** button to open the **New Virtual Disk** window.
8.  Add either an **Internal** virtual disk or an **External** LUN to the virtual machine.
    ⁠

    ![Add Virtual Disk Window](Add Virtual Disk.png "Add Virtual Disk Window")

    **Figure 4.7. Add Virtual Disk Window**

9.  Click **OK** to close the **New Virtual Disk** window. The **New Virtual Machine - Guide Me** window opens with changed context. There is no further mandatory configuration.
10. Click **Configure Later** to close the window.

**Result**

You have added a network interface and a virtual disk to your virtual machine.

### Editing Virtual Machines

#### Editing Virtual Machine Properties

**Summary**

Changes to storage, operating system or networking parameters can adversely affect the virtual machine. Ensure that you have the correct details before attempting to make any changes. Virtual machines must be powered off before some changes can be made to them. This procedure explains how to edit a virtual machine. It is necessary to edit a virtual machines in order to change its settings.

The following fields can be edited while a virtual machine is running:

*   **Name**
*   **Description**
*   **Comment**
*   **Delete Protection**
*   **Network Interfaces**
*   **Use Cloud-Init/Sysprep** (and its properties)
*   **Use custom migration downtime**
*   **Highly Available**
*   **Priority for Run/Migration queue**
*   **Watchdog Model**
*   **Watchdog Action**
*   **Physical Memory Guaranteed**
*   **Memory Balloon Device Enabled**
*   **VirtIO-SCSI Enabled**
*   **First Device**
*   **Second Device**
*   **Attach CD**
*   **kernel path**
*   **initrd path**
*   **kernel parameters**

To change all other settings, the virtual machine must be powered off.

⁠

**Procedure 4.8. Editing a virtual machine:**

1.  Select the virtual machine to be edited.
2.  Click the **Edit** button to open the **Edit Virtual Machine** window.
3.  Change the **General**, **System**, **Initial Run**, **Console**, **Host**, **High Availability**, **Resource Allocation**, **Boot Options**, and **Custom Options** fields as required.
4.  Click **OK** to save your changes. Your changes will be applied once you restart your virtual machine.

**Result**

You have changed the settings of a virtual machine by editing it.

#### Editing a Network Interface

**Summary**

This procedure describes editing a network interface. In order to change any network settings, you must edit the network interface.

⁠

**Procedure 4.9. Editing a Network Interface**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Network Interfaces** tab of the details pane and select the network interface to edit.
3.  Click **Edit** to open the **Edit Network Interface** window. This dialog contains the same fields as the **New Network Interface** dialog.
4.  Click **OK** to save your changes once you are finished.

**Result**

You have now changed the network interface by editing it.

#### Extending the Size of an Online Virtual Disk

**Summary**

This procedure explains how to extend the size of a virtual drive while the virtual drive is attached to a virtual machine.

⁠

**Procedure 4.10. Extending the Size of an Online Virtual Disk**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Disks** tab in the details pane.
3.  Select a target disk from the list in the details pane.
4.  Click **Edit** in the details pane.
5.  Enter a value in the `Extend size by(GB)` field.
6.  Click **OK**.

**Result**

The target disk's status becomes `locked` for a short time, during which the drive is resized. When the resizing of the drive is complete, the status of the drive becomes `OK`.

#### Floating Disks

Floating disks are disks that are not associated with any virtual machine.

Floating disks can minimize the amount of time required to set up virtual machines. Designating a floating disk as storage for a VM makes it unnecessary to wait for disk preallocation at the time of a VM's creation.

Floating disks can be attached to virtual machines or designated as shareable disks, which can be used with one or more VMs.

#### Associating a Virtual Disk with a Virtual Machine

**Summary**

This procedure explains how to associate a virtual disk with a virtual machine. Once the virtual disk is associated with the virtual machine, the VM is able to access it.

⁠

**Procedure 4.11. Associating a Virtual Disk with a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  In the details pane, select the **Disks** tab.
3.  Click **Add** in the menu at the top of the Details Pane.
4.  Type the size in GB of the disk into the **Size(GB)** field.
5.  Type the disk alias into the **Alias** field.
6.  Click **OK** in the bottom right corner of the **Add Virtual Disk** window. The disk you have associated with the virtual machine appears in the details pane after a short time.

**Result**

The virtual disk is associated with the virtual machine.

<div class="alert alert-info">
**Note:** No Quota resources are consumed by attaching virtual disks to, or detaching virtual disks from, virtual machines.

</div>
<div class="alert alert-info">
**Note:** Using the above procedure, it is now possible to attach a virtual disk to more than one virtual machine.

</div>
#### Changing the CD for a Virtual Machine

**Summary**

You can change the CD accessible to a virtual machine while that virtual machine is running.

<div class="alert alert-info">
**Note:** You can only use ISO files that have been added to the ISO domain of the cluster in which the virtual machine is a member. Therefore, you must upload ISO files to that domain before you can make those ISO files accessible to virtual machines.

</div>
⁠

**Procedure 4.12. Changing the CD for a Virtual Machine**

1.  From the **Virtual Machines** tab, select a virtual machine that is currently running.
2.  Click **Change CD** to open the **Change CD** window.
    ⁠

    ![The Change CD Window](Change_CD.png "The Change CD Window")

    **Figure 4.9. The Change CD Window**

3.  From the drop-down menu:
    -   Select `[Eject]` to eject the CD currently accessible to the virtual machine. Or,
    -   Select an ISO file from the list to eject the CD currently accessible to the virtual machine and mount that ISO file as a CD.

4.  Click **OK**.

**Result**

You have ejected the CD previously accessible to the virtual machine, or ejected the CD previously accessible to the virtual machine and made a new CD accessible to that virtual machine

#### Smart card Authentication

Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines.

#### Enabling and Disabling Smart cards

**Summary**

The following procedures explain how to enable and disable the Smart card feature for virtual machines.

⁠

**Procedure 4.13. Enabling Smart cards**

1.  Ensure that the Smart card hardware is plugged into the client machine and is installed according to manufacturer's directions.
2.  Select the desired virtual machine.
3.  Click the **Edit** button. The **Edit Virtual Machine** window appears.
4.  Select the **Console** tab, and select the check box labeled **Smartcard enabled**, then click **OK**.
5.  Run the virtual machine by clicking the **Console** icon or through the User Portal. Smart card authentication is now passed from the client hardware to the virtual machine.

**Result**

You have enabled Smart card authentication for the virtual machine.

<div class="alert alert-info">
**Important:** If the Smart card hardware is not correctly installed, enabling the Smart card feature will result in the virtual machine failing to load properly.

</div>
⁠

**Procedure 4.14. Disabling Smart cards**

1.  Select the desired virtual machine.
2.  Click the **Edit** button. The **Edit Virtual Machine** window appears.
3.  Select the **Console** tab, and clear the check box labeled **Smartcard enabled**, then click **OK**.

**Result**

You have disabled Smart card authentication for the virtual machine.

### Removing Virtual Machines

#### Removing a Virtual Machine

**Summary**

Remove a virtual machine from the oVirt environment.

<div class="alert alert-info">
**Important:** The **Remove** button is disabled while virtual machines are running; you must shut down a virtual machine before you can remove it.

</div>
⁠

**Procedure 4.15. Removing a Virtual Machine**

1.  Click the **Virtual Machines** tab and select the virtual machine to remove.
2.  Click **Remove** to open the **Remove Virtual Machine(s)** window.
3.  Optionally, select the **Remove Disk(s)** check box to remove the virtual disks attached to the virtual machine together with the virtual machine. If the **Remove Disk(s)** check box is cleared, then the virtual disks remain in the environment as floating disks.
4.  Click **OK**.

**Result**

The virtual machine is removed from the environment and is no longer listed in the **Virtual Machines** resource tab. If you selected the **Remove Disk(s)** check box, then the virtual disks attached to the virtual machine are also removed.

### Snapshots

#### Managing Snapshots

Before you make changes to your virtual machine, it is recommended to use snapshots to back up all the virtual machine's existing data. A snapshot displays a view of the VM's operating system and all its applications at a given point in time, and can be used to restore a VM to a previous state.

<div class="alert alert-info">
**Important:** Live snapshots can only be taken on Data Centers running oVirt 3.1 or higher. Otherwise, the virtual machine must first be powered down.

</div>
#### Creating Snapshots

**Summary**

This procedure explains how to create a snapshot of a virtual machine.

⁠

**Procedure 4.16. Creating a snapshot of a virtual machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Snapshots** tab in the details pane.
3.  Click **Create**. The **Create Snapshot** dialog displays.
4.  Enter a description for the snapshot, select **Disks to include** using the check boxes. and click **OK**.
5.  A new snapshot of the virtual machine's operating system and applications is created. It displays in a list on the left side of the **Snapshots** tab.

**Result**

You have taken a snapshot of a virtual machine.

#### Cloning Snapshots

**Summary**

This procedure explains how to clone a virtual machine from a snapshot.

⁠

**Procedure 4.17. Cloning Snapshots**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Snapshots** tab in the details pane.
3.  Select the snapshot from which to create a clone in the list in the details pane.
4.  Click **Clone** at the top of the details pane. The **Clone VM from Snapshot** window opens. This window is similar to the **New VM** window.
5.  Fill in the parameters and click **OK** in the lower-right corner of the **Clone VM from Snapshot** window.

**Result**

You have cloned a virtual machine from a snapshot.

#### Using a Snapshot to Restore a Virtual Machine

**Summary**

A snapshot can be used to restore a virtual machine to its previous state.

⁠

**Procedure 4.18. Using a snapshot to restore a virtual machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Snapshots** tab in the details pane to list the available snapshots.
3.  Select a snapshot to restore in the left side-pane. The snapshot details display in the right side-pane.
4.  Click the drop-down list beside **Preview** to open the **Custom Preview Snapshot** window.
5.  Use the check boxes to select the **VM Configuration**, **Memory**, and disk(s) you want to restore, then click **OK**. This allows you to create and restore from a customized snapshot using the configuration and disk(s) from multiple snapshots. The status of the snapshot changes to `Preview Mode`. The status of the virtual machine briefly changes to `Image Locked` before returning to `Down`.
6.  Start the virtual machine; it runs using the disk image of the snapshot.
7.  Click **Commit** to permanently restore the virtual machine to the condition of the snapshot. Any subsequent snapshots are erased. Alternatively, click the **Undo** button to deactivate the snapshot and return the virtual machine to its previous state.

**Result**

The virtual machine is restored to its state at the time of the snapshot, or returned to its state before the preview of the snapshot.

#### Deleting Snapshots

**Summary**

This procedure describes how to delete a snapshot.

⁠

**Procedure 4.19. Deleting a Snapshot**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Snapshots** tab. A list of snapshots displays.
3.  Select the snapshot to delete, then click **Delete**n. A dialog prompts you to confirm the deletion. Click **OK** to continue.

**Result**

You have deleted a snapshot.

<div class="alert alert-info">
**Important:** Deleting a snapshot does not remove any information from the virtual machine - it simply removes a return-point. However, restoring a virtual machine from a snapshot deletes any content that was written to the virtual machine after the time the snapshot was taken.

</div>
### Templates

#### Introduction to Templates

A template is a copy of a preconfigured virtual machine, used to simplify the subsequent, repeated creation of similar virtual machines. Templates capture installed software and software configurations, as well as the hardware configuration, of the original virtual machine.

When you create a template from a virtual machine, a read-only copy of the virtual machine's disk is taken. The read-only disk becomes the base disk image of the new template, and of any virtual machines created from the template. As such, the template cannot be deleted whilst virtual machines created from the template exist in the environment.

Virtual machines created from a template use the same NIC type and driver as the original virtual machine, but utilize separate and unique MAC addresses.

<div class="alert alert-info">
**Note:** A virtual machine may require to be sealed before being used to create a template.

</div>
#### Template Tasks

##### Creating a Template

**Summary**

Create a template from an existing virtual machine to use as a blueprint for creating additional virtual machines.

⁠

**Procedure 4.20. Creating a Template from an Existing Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Ensure the virtual machine is powered down and has a status of `Down`.
3.  Click **Make Template** to open the **New Template** window.
    ![The New Template window](New Template.png "fig:The New Template window")
    **Figure 4.10. The New Template window**
4.  Enter a **Name**, **Description**, and **Comment** for the template.
5.  From the **Cluster** drop-down menu, select the cluster with which the template will be associated. By default, this will be the same as that of the source virtual machine.
6.  Optionally, select the **Create as a Sub Template version** check box, select a **Root Template** and enter a **Sub Version Name** to create the new template as a sub template of an existing template.
7.  In the **Disks Allocation** section, enter an alias for the disk in the **Alias** text field and select the storage domain on which the disk will be stored from the **Target** drop-down list. By default, these will be the same as those of the source virtual machine.
8.  The **Allow all users to access this Template** check box is selected by default. This makes the template public.
9.  The **Copy VM permissions** check box is not selected by default. Select this check box to copy the permissions of the source virtual machine to the template.
10. Click **OK**.

**Result**

The virtual machine displays a status of `Image Locked` while the template is being created. The process of creating a template may take up to an hour depending on the size of the virtual machine disk and your storage hardware. When complete, the template is added to the **Templates** tab. You can now create new virtual machines based on the template.

<div class="alert alert-info">
**Note:** When a template is made, the virtual machine is copied so that both the existing virtual machine and its template are usable after template creation.

</div>
##### Editing a Template

**Summary**

Once a template has been created, its properties can be edited. Because a template is a copy of a virtual machine, the options available when editing a template are identical to those in the **Edit Virtual Machine** window.

⁠

**Procedure 4.21. Editing a Template**

1.  Use the **Templates** resource tab, tree mode, or the search function to find and select the template in the results list.
2.  Click **Edit** to open the **Edit Template** window.
3.  Change the necessary properties and click **OK**.

**Result**

The properties of the template are updated. The **Edit Template** window will not close if a property field is invalid.

##### Deleting a Template

**Summary**

Delete a template from your oVirt environment.

**Warning**

If you have used a template to create a virtual machine, make sure that you do not delete the template as the virtual machine needs it to continue running.

⁠

**Procedure 4.22. Deleting a Template**

1.  Use the resource tabs, tree mode, or the search function to find and select the template in the results list.
2.  Click **Remove** to open the **Remove Template(s)** window.
3.  Click **OK** to remove the template.

**Result**

You have removed the template.

#### Templates and Permissions

##### Managing System Permissions for a Template

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A template administrator is a system administration role for templates in a data center. This role can be applied to specific virtual machines, to a data center, or to the whole virtualized environment; this is useful to allow different users to manage certain virtual resources.

The template administrator role permits the following actions:

*   Create, edit, export, and remove associated templates.
*   Import and export templates.

<div class="alert alert-info">
**Note:** You can only assign roles and permissions to existing users.

</div>
### Resources

#### Monitoring Power User Portal Resources

Before making configuration changes to virtual machines in the User Portal, it is recommended that you take an inventory of the resources available. This is to ensure the resources are sufficient for peak performance and to avoid overloading the hosts running the virtual machines.

The **Resources** tab in the navigation pane shows a cumulative view of all the resources available in the User Portal, and the performance and statistics of each virtual machine.

![Resources tab](Resource Tab.png "Resources tab")

**Figure 4.11. Resources tab**

*   **Virtual CPUs**: This box displays the number of your machines' virtual CPUs in use, and the consumption of CPU quota used by you and others.
*   **Memory**: This box displays the consumption of memory quota used by you and others, and available memory as defined by the quota.
*   **Storage**: This box displays the consumption of storage quota by you and others, the total size of all your virtual disks, and the number and total size of your virtual machines' snapshots. It also displays a breakdown of storage details for each virtual machine. Click the **+** button next to the virtual machine name to display all the virtual disks attached to the virtual machine.

#### Quota - A User's Introduction

When you create a virtual machine, the virtual machine consumes CPU and storage resources from its data center. Quota compares the amount of virtual resources consumed by the creation of the virtual machine to the storage allowance and the run-time allowance set by the system administrator.

If you do not have enough of either kind of allowance, you are not allowed to create the virtual machine. Avoid exceeding your quota limit by using the Resources tab to monitor your CPU and storage consumption.

#### What to Do When You Exceed Your Quota

oVirt provides a resource-limitation tool called *quota*, which allows system administrators to limit the amount of CPU and storage each user can consume. Quota compares the amount of virtual resources consumed when you use the virtual machine to the storage allowance and the run-time allowance set by the system administrator.

When you exceed your quota, a pop-up window informs you that you have exceeded your quota, and you will no longer have access to virtual resources. For example, this can happen if you have too many concurrently running virtual machines in your environment.

To regain access to your virtual machines, do one of the following:

*   Shut down the virtual machines that you do not need. This will bring your resource consumption down to a level at which it is not in excess of the quota, and you will be able to run virtual machines again.
*   If you cannot shut down any existing virtual machines, contact your system administrator to extend your quota allowance or remove any unused virtual machines.

### Virtual Machines and Permissions

#### Managing System Permissions for a Virtual Machine

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A **UserVmManager** is a system administration role for virtual machines in a data center. This role can be applied to specific virtual machines, to a data center, or to the whole virtualized environment; this is useful to allow different users to manage certain virtual resources.

The user virtual machine administrator role permits the following actions:

*   Create, edit, and remove virtual machines.
*   Run, suspend, shutdown, and stop virtual machines.

<div class="alert alert-info">
**Note:** You can only assign roles and permissions to existing users.

</div>
Many end users are concerned solely with the virtual machine resources of the virtualized environment. As a result, oVirt provides several user roles which enable the user to manage virtual machines specifically, but not other resources in the data center.

#### Assigning Virtual Machines to Users

If you are creating virtual machines for users other than yourself, you have to assign roles to the users before they can use the virtual machines. Note that permissions can only be assigned to existing users. See the *oVirt Installation Guide* for details on creating user accounts.

The oVirt User Portal supports three default roles: User, PowerUser and UserVmManager. However, customized roles can be configured via oVirt Administration Portal. The default roles are described below.

*   A **User** can connect to and use virtual machines. This role is suitable for desktop end users performing day-to-day tasks.
*   A **PowerUser** can create virtual machines and view virtual resources. This role is suitable if you are an administrator or manager who needs to provide virtual resources for your employees.
*   A **UserVmManager** can edit and remove virtual machines, assign user permissions, use snapshots and use templates. It is suitable if you need to make configuration changes to your virtual environment.

When you create a virtual machine, you automatically inherit **UserVmManager** privileges. This enables you to make changes to the virtual machine and assign permissions to the users you manage, or users who are in your Identity Management (IdM) or RHDS group.

See *oVirt Installation Guide* for more information on directory services support in oVirt.

**Summary**

This procedure explains how to add permissions to users.

⁠

**Procedure 4.23. Assigning Permissions to Users**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  On the details pane, select the **Permissions** tab.
3.  Click **New**. The **Add Permission to User** dialog displays. Enter a Name, or User Name, or part thereof in the **Search** text box, and click **Go**. A list of possible matches display in the results list.
4.  Select the check box of the user to be assigned the permissions. Scroll through the **Role to Assign** list and select **UserRole**. Click **OK**.
5.  The user's name and role display in the list of users permitted to access this virtual machine.

**Result**

You have added permissions to a user.

<div class="alert alert-info">
**Note:** If a user is assigned permissions to only one virtual machine, Single Sign On (SSO) can be configured for the virtual machine. SSO enables the user to bypass the User Portal and log in directly to the virtual machine. SSO can be enabled or disabled via the User Portal on a per virtual machine basis.

</div>
#### Removing Access to Virtual Machines from Users

**Summary**

This procedure explains how to remove user permissions.

⁠

**Procedure 4.24. Removing Access to Virtual Machines from Users**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  On the details pane, select the **Permissions** tab.
3.  Click **Remove**. A warning message displays, asking you to confirm removal of the selected permissions.
4.  To proceed, click **OK**. To abort, click **Cancel**.

**Result**

You have now removed permissions from a user.

## ⁠Configuring Console Options

### Console Options

#### Introduction to Connection Protocols

Connection protocols are the underlying technology used to provide graphical consoles for virtual machines and allow users to work with virtual machines in a similar way as they would with physical machines. oVirt currently supports the following connection protocols:

**SPICE**

Simple Protocol for Independent Computing Environments (SPICE) is the recommended connection protocol for both Linux virtual machines and Windows virtual machines. SPICE is installed and executed on the client that connects to the virtual machine.

**VNC**

Virtual Network Computing (VNC) can be used to open consoles to both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using VNC, you must use Remote Viewer or a VNC client.

**RDP**

Remote Desktop Protocol (RDP) can only be used to open consoles to Windows virtual machines, and is only available when you access a virtual machines from a Windows machine on which Remote Desktop has been installed. Moreover, before you can connect to a Windows virtual machine using RDP, you must set up remote sharing on the virtual machine and configure the firewall to allow remote desktop connections.

<div class="alert alert-info">
**Note:** SPICE is not currently supported on virtual machines running Windows 8. If a Windows 8 virtual machine is configured to use the SPICE protocol, it will detect the absence of the required SPICE drivers and automatically fall back to using RDP.

</div>
#### Accessing Console Options

In the User Portal, you can configure several options for opening graphical consoles for virtual machines, such as the method of invocation and whether to enable or disable USB redirection.

**Procedure 5.1. Accessing Console Options**

1.  Select a running virtual machine.
2.  Click the edit console options button to open the **Console Options** window.

<div class="alert alert-info">
**Note:** Further options specific to each of the connection protocols, such as the keyboard layout when using the VNC connection protocol, can be configured in the **Console** tab of the **Edit Virtual Machine** window.

</div>
#### SPICE Console Options

When the SPICE connection protocol is selected, the following options are available in the **Console Options** window.

![The Console Options window](Console Options.png "The Console Options window")

**Figure 5.1. The Console Options window**

**Console Invocation**

*   **Auto**: oVirt automatically selects the method for invoking the console.
*   **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.
*   **Browser plugin**: When you connect to the console of the virtual machine, you are connected directly via Remote Viewer.
*   **SPICE HTML5 browser client (Tech preview)**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**SPICE Options**

*   **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl**+**Alt**+**Del** key combination to **Ctrl**+**Alt**+**End** inside the virtual machine.
*   **Enable USB Auto-Share**: Select this check box to automatically redirect USB devices to the virtual machine. If this option is not selected, USB devices will connect to the client machine instead of the guest virtual machine. To use the USB device on the guest machine, manually enable it in the SPICE client menu.
*   **Open in Full Screen**: Select this check box for the virtual machine console to automatically open in full screen when you connect to the virtual machine. Press **SHIFT**+**F11** to toggle full screen mode on or off.
*   **Enable SPICE Proxy**: Select this check box to enable the SPICE proxy.
*   **Enable WAN options**: Select this check box to enable WAN color depth and effects for the virtual machine console. Select this check box for only Windows virtual machines. Selecting this check box sets the parameters *WAN-DisableEffects* and *WAN-ColorDepth*. Selecting **Enable WAN options** sets *Wan-DisableEffects* to *animation* and sets the color depth to 16 bits.

<div class="alert alert-info">
**Important:** The **Browser plugin** console option is only available when accessing the Administration and User Portals through Internet Explorer. This console options uses the version of Remote Viewer provided by the `SpiceX.cab` installation program. For all other browsers, the **Native client** console option is the default. This console option uses the version of Remote Viewer provided by the `virt-viewer-x86.msi` and `virt-viewer-x64.msi` installation files.

</div>
#### VNC Console Options

When the VNC connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

*   **Native Client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.
*   **NoVNC**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**VNC Options**

*   **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl**+**Alt**+**Del** key combination to **Ctrl**+**Alt**+**End** inside the virtual machine.

#### RDP Console Options

When the RDP connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

*   **Auto**: The Manager automatically selects the method for invoking the console.
*   **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Desktop.

**RDP Options**

*   **Use Local Drives**: Select this check box to make the drives on the client machine to be accessible on the guest virtual machine.

### Remote Viewer Options

#### Remote Viewer Options

When you specify the **Native client** or **Browser plugin** console invocation options, you will connect to virtual machines using Remote Viewer. The Remote Viewer window provides a number of options for interacting with the virtual machine to which it is connected.⁠

**Table 5.1. Remote Viewer Options**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Option</p></th>
<th align="left"><p>Hotkey</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>File</p></td>
<td align="left"><ul>
<li><strong>Screenshot</strong>: Takes a screen capture of the active window and saves it in a location of your specification.</li>
<li><strong>USB device selection</strong>: If USB redirection has been enabled on your virtual machine, the USB device plugged into your client machine can be accessed from this menu.</li>
<li><strong>Quit</strong>: Closes the console. The hot key for this option is <strong>Shift</strong>+<strong>Ctrl</strong>+<strong>Q</strong>.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p>View</p></td>
<td align="left"><ul>
<li><strong>Full screen</strong>: Toggles full screen mode on or off. When enabled, full screen mode expands the virtual machine to fill the entire screen. When disabled, the virtual machine is displayed as a window. The hot key for enabling or disabling full screen is <strong>SHIFT</strong>+<strong>F11</strong>.</li>
<li><strong>Zoom</strong>: Zooms in and out of the console window. <strong>Ctrl</strong>+<strong>+</strong> zooms in, <strong>Ctrl</strong>+<strong>-</strong> zooms out, and <strong>Ctrl</strong>+<strong>0</strong> returns the screen to its original size.</li>
<li><strong>Automatically resize</strong>: Tick to enable the guest resolution to automatically scale according to the size of the console window.</li>
<li><strong>Displays</strong>: Allows users to enable and disable displays for the guest virtual machine.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p>Send key</p></td>
<td align="left"><ul>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>Del</strong>: On a Red Hat Enterprise Linux virtual machine, it displays a dialog with options to suspend, shut down or restart the virtual machine. On a Windows virtual machine, it displays the task manager or Windows Security dialog.</li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>Backspace</strong>: On a Red Hat Enterprise Linux virtual machine, it restarts the X sever. On a Windows virtual machine, it does nothing.</li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F1</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F2</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F3</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F4</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F5</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F6</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F7</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F8</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F9</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F10</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F11</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F12</strong></li>
<li><strong>Printscreen</strong>: Passes the <strong>Printscreen</strong> keyboard option to the virtual machine.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p>Help</p></td>
<td align="left"><p>The <strong>About</strong> entry displays the version details of Virtual Machine Viewer that you are using.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Release Cursor from Virtual Machine</p></td>
<td align="left"><p><strong>SHIFT</strong>+<strong>F12</strong></p></td>
</tr>
</tbody>
</table>

#### Remote Viewer Hotkeys

You can access the hotkeys for a virtual machine in both full screen mode and windowed mode. If you are using full screen mode, you can display the menu containing the button for hotkeys by moving the mouse pointer to the middle of the top of the screen. If you are using windowed mode, you can access the hotkeys via the **Send key** menu on the virtual machine window title bar.

<div class="alert alert-info">
**Note:** If **vdagent** is not running on the client machine, the mouse can become captured in a virtual machine window if it is used inside a virtual machine and the virtual machine is not in full screen. To unlock the mouse, press **Shift**+**F12**.

</div>
## ⁠Configuring USB Devices

### Using USB Devices on Virtual Machines - Introduction

A virtual machine connected with the SPICE protocol can be configured to connect directly to USB devices.

The USB device will only be redirected if the virtual machine is active and in focus. USB redirection can be manually enabled each time a device is plugged in or set to automatically redirect to active virtual machines in the SPICE client menu.

<div class="alert alert-info">
**Important:** Note the distinction between the client machine and guest machine. The client is the hardware from which you access a guest. The guest is the virtual desktop or virtual server which is accessed through the User Portal.

</div>
### Using USB Devices on Virtual Machines - Native Mode

USB redirection Native mode allows KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual (guest) machines require no guest-installed agents or drivers for native USB. All packages required by the client are brought forward by the SPICE xpi Firefox plugin. The USBClerk package must be installed on the Windows client. Native USB mode is supported on the following clients and guests:

*   Client
    -   Red Hat Enterprise Linux 6.0 and higher
    -   Red Hat Enterprise Linux 5.5 and higher
    -   Windows XP
    -   Windows 7
    -   Windows 2008
    -   Windows 2008 Server R2
*   Guest
    -   Red Hat Enterprise Linux 6.0 and higher
    -   Red Hat Enterprise Linux 5.5 and higher
    -   Windows XP
    -   Windows 7
    -   Windows 2008

<div class="alert alert-info">
**Note:** If you have a 64-bit architecture PC, you must use the 64-bit version of Internet Explorer to install the 64-bit version of the USB driver. The USB redirection will not work if you install the 32-bit version on a 64-bit architecture. As long as you initially install the correct USB type, you then can access USB redirection from both 32 and 64-bit browsers.

</div>
### Using USB Devices on a Windows Client

The **usbclerk** service must be running on the Windows client for the USB device to be redirected to the guest. Ensure the version of **usbclerk** matches the architecture of the client machine. For example, the 64-bit version of **usbclerk** must be installed on 64-bit Windows machines.

**Procedure 7.1. Using USB Devices on a Windows Client**

1.  When the **usbclerk** service is installed and running, select a virtual machine that has been configured to use the SPICE protocol.
2.  Ensure USB support is set to **Native**:

<!-- -->

1.  Click the **Edit** button to open the **Edit Virtual Machine** window.
2.  Click the **Console** tab.
3.  From the **USB Support** drop-down menu, select **Native**.
4.  Click **OK**.

<li>
Right-click the virtual machine and click **Edit Console Options** to open the **Console Options**' window, and select the **Enable USB Auto-Share** check box.

</li>
<li>
Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

</li>
</ol>
### Using USB Devices on a Red Hat Enterprise Linux or CentOS Client

The usbredir package enables USB redirection from Red Hat Enterprise Linux, CentOS, or similar clients to virtual machines. usbredir is a dependency of the spice-xpi package, and is automatically installed together with that package.

**Procedure 7.2. Using USB devices on a Red Hat Enterprise Linux/CentOSclient**

1.  Click the **Virtual Machines** tab and select a virtual machine that has been configured to use the SPICE protocol.
2.  Ensure USB support is set to **Native**:

<!-- -->

1.  Click the **Edit** button to open the **Edit Virtual Machine** window.
2.  Click the **Console** tab.
3.  From the **USB Support** drop-down menu, select **Native**.
4.  Click **OK**.

<li>
Right-click the virtual machine and click **Edit Console Options** to open the **Console Options**' window, and select the **Enable USB Auto-Share** check box.

</li>
<li>
Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

</li>
</ol>
### Using USB Devices on Virtual Machines - Legacy Mode

Legacy mode for USB redirection enables the SPICE USB redirection policy used in oVirt 3.0. Legacy mode must be manually configured.

Legacy USB mode is supported on the following clients and guests:

*   Client
    -   Red Hat Enterprise Linux 6.0 and higher
    -   Red Hat Enterprise Linux 5.5 and higher
    -   Windows XP
    -   Windows 7
    -   Windows 2008
*   Guest
    -   Windows XP
    -   Windows 7

#### Configuring a Linux Client to Use USB Redirection in Legacy Mode

If you connect to a virtual guest from a Red Hat Enterprise Linux client machine, you have to install several SPICE packages before you can share USB devices between the client and the guest.

**Procedure 7.3. Using USB devices on Red Hat Enterprise Linux clients:**

1.  Install SPICE packages on client
     On your Linux client machine, install the following packages:
    -   spice-usb-share
    -   kmod-kspiceusb-rhel60 for Red Hat Enterprise Linux 6 or
    -   kmod-kspiceusb-rhel5u6 for Red Hat Enterprise Linux 5

     These packages are available on the Red Hat Network, from the Red Hat Enterprise Linux Supplementary Software channel for your version of Red Hat Enterprise Linux. To install the packages, run:
     # yum install spice-usb-share kmod-kspiceusb

2.  Run SPICE USB services
    Start the **spiceusbsrvd** service and load the **kspiceusb** module. Run:
     # service spiceusbsrvd start
    `   # modprobe kspiceusb`

3.  Install RHEV-Tools on guest
     Locate the CD drive to access the contents of the Guest Tools ISO, and launch `RHEV-ToolsSetup.exe`. If the Guest Tools ISO is not available in your CD drive, contact your system administrator. After the tools have been installed, you will be prompted to restart the machine for changes to be applied.
4.  Open firewall ports
     Allow connections on TCP port 32023 on any firewalls between the guest machine and the client machine.
5.  Enable USB Auto-Share
    On the User Portal, select your guest machine. Ensure that you have enabled SPICE USB Auto-Share on the guest machine.
6.  Attach USB device
     Connect to your guest machine. Place the SPICE console window of your guest desktop in focus, then attach a USB device to the client. The USB device displays in your guest desktop.
    ![List of Connected USB devices - Linux Client](List of Connected Devices.png "List of Connected USB devices - Linux Client")

    **Figure 7.1. List of Connected USB devices - Linux Client**

When you close the SPICE session the USB device will no longer be shared with the guest.

#### Configuring a Windows Client to Use USB Redirection in Legacy Mode

If you are connecting from a Windows client machine, and wish to use USB devices on your guest, you have to enable SPICE USB redirection.

**Procedure 7.4. Enabling USB redirection on Windows:**

1.  Install USB redirector package on client
    On a Windows client machine, install `oVirt-USB-Client.exe`.
2.  Install RHEV-Tools on guest
    Locate the CD drive to access the contents of the Guest Tools ISO, and launch `oVirt-ToolsSetup.exe`. If the Guest Tools ISO is not available in your CD drive, contact your system administrator. After the tools have been installed, you will be prompted to restart the machine for changes to be applied.
3.  Open firewall ports
    Allow connections on TCP port 32023 on any firewalls between the guest machine and the client machine.
4.  Enable USB sharing On the User Portal, select your guest machine. Ensure that you have enabled SPICE USB sharing on the guest machine.
5.  Attach USB device Connect to your guest machine and attach a USB device to the client. If the required USB device does not appear directly on the guest desktop, right-click on the SPICE frame and select USB Devices. Choose your device from the list displayed.
    ![List of Connected USB devices - Windows Client](List of Connected Devices-Windows.png "List of Connected USB devices - Windows Client")

    **Figure 7.2. List of Connected USB devices - Windows Client**

<div class="alert alert-info">
**Important:** When some USB devices are connected on Windows clients, the autoplay window will appear and the client will take control of the device, making it unavailable to the guest. To avoid this issue, disable USB autoplay on your Windows clients.

</div>
<div class="alert alert-info">
**Note:** You can also define additional USB policies for Windows clients, to allow or block access to certain USB devices. For details, see the sections on USB Filter Editor in the [oVirt Administration Guide](OVirt_Administration_Guide).

</div>
## Configuring Single Sign-On

### Configuring Single Sign-On for Virtual Machines

Configuring single sign-on allows you to automatically log in to a virtual machine using the credentials you use to log in to the User Portal. Single sign-on can be used on both Red Hat Enterprise Linux/CentOS and Windows virtual machines.

### Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines Using IPA (IdM)

To configure single sign-on for Red Hat Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and IPA (IdM) servers, you must install the ovirt-guest-agent package on the virtual machine and install the packages associated with your window manager.

<div class="alert alert-info">
**Important:** The following procedure assumes that you have a working IPA configuration and that the IPA domain is already joined to the Manager. You must also ensure that the clocks on the Manager, the virtual machine and the system on which IPA (IdM) is hosted are synchronized using NTP.

</div>
**Procedure 8.1. Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines**

1.  Log in to the Red Hat Enterprise Linux virtual machine.
2.  Run the following command to enable the required channel:
        # rhn-channel --add --channel=rhel-x86_64-rhev-agent-6-server

3.  Run the following command to download and install the guest agent packages:
        # yum install rhevm-guest-agent

4.  Run the following commands to install the single sign-on packages:
        # yum install rhev-agent-pam-rhev-cred
        # yum install rhev-agent-gdm-plugin-rhevcred

5.  Run the following command to install the IPA packages:
        # yum install ipa-client

6.  Run the following command and follow the prompts to configure **ipa-client** and join the virtual machine to the domain:
        # ipa-client-install --permit --mkhomedir

    <div class="alert alert-info">
    **Note:** In environments that use DNS obfuscation, this command should be:

        # ipa-client-install --domain=[FQDN] --server==[FQDN]

    </div>
7.  Fetch the details of an IPA user:
        # getent passwd [IPA user name]

8.  This will return something like this:
        [some-ipa-user]:*:936600010:936600001::/home/[some-ipa-user]:/bin/sh

    You will need this information in the next step to create a home directory for [some-ipa-user].

9.  Set up a home directory for the IPA user:
    1.  Create the new user's home directory:
            # mkdir /home/[some-ipa-user]

    2.  Give the new user ownership of the new user's home directory:
            # chown 935500010:936600001 /home/[some-ipa-user]

**Result**

You have enabled single sign-on for your Red Hat Enterprise Linux virtual machine. Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Red Hat Enterprise Linux/CentOS Virtual Machines Using Active Directory

To configure single sign-on for Red Hat Enterprise Linux or CentOS virtual machines using GNOME and KDE graphical desktop environments and Active Directory, you must install the ovirt-guest-agent package on the virtual machine, install the packages associated with your window manager and join the virtual machine to the domain.

<div class="alert alert-info">
**Important:** The following procedure assumes that you have a working Active Directory configuration and that the Active Directory domain is already joined to the Manager. You must also ensure that the clocks on the Manager, the virtual machine and the system on which Active Directory is hosted are synchronized using NTP.

</div>
⁠ **Procedure 8.2. Configuring Single Sign-On for Red Hat Enterprise Linux/CentOS Virtual Machines**

1.  Log in to the Red Hat Enterprise Linux or CentOS virtual machine.
2.  Run the following command to enable the required channel:
        # rhn-channel --add --channel=rhel-x86_64-rhev-agent-6-server

3.  Run the following command to download and install the guest agent packages:
        # yum install ovirt-guest-agent

4.  Run the following command to install the single sign-on packages:
        # yum install ovirt-agent-gdm-plugin-rhevcred

5.  Run the following command to install the Samba client packages:
        # yum install samba-client samba-winbind samba-winbind-clients

6.  On the virtual machine, modify the `/etc/samba/smb.conf` file to contain the following, replacing `DOMAIN` with the short domain name and `REALM.LOCAL` with the Active Directory realm:
        [global]
               workgroup = DOMAIN
               realm = REALM.LOCAL
               log level = 2
               syslog = 0
               server string = Linux File Server
               security = ads
               log file = /var/log/samba/%m
               max log size = 50
               printcap name = cups
               printing = cups
               winbind enum users = Yes
               winbind enum groups = Yes
               winbind use default domain = true
               winbind separator = +
               idmap uid = 1000000-2000000
               idmap gid = 1000000-2000000
               template shell = /bin/bash

7.  Run the following command to join the virtual machine to the domain:
        net ads join -U [user name]

8.  Run the following command to start the **winbind** service and ensure it starts on boot:
        # service winbind start
        # chkconfig winbind on

9.  Run the following commands to verify that the system can communicate with Active Directory:
    -   Verify that a trust relationship has been created:
            # wbinfo -t

    -   Verify that you can list users:
            # wbinfo -u

    -   Verify that you can list groups:
            # wbinfo -g

10. Run the following command to configure the NSS and PAM stack:
    1.  Run the following command to open the **Authentication Configuration** window:
            # authconfig-tui

    2.  Select the '''Use Winbind check box, select **Next** and press **Enter**.
    3.  Select the **OK** button and press **Enter**.

**Result**

You have enabled single sign-on for your Red Hat Enterprise Linux virtual machine. Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Windows Virtual Machines

To configure single sign-on for Windows virtual machines, the Windows guest agent must be installed on the guest virtual machine. The `oVirt Guest Tools ISO` file provides this agent. If the `oVirt-toolsSetup.iso` image is not available in your ISO domain, contact your system administrator. ⁠

**Procedure 8.3. Configuring Single Sign-On for Windows Virtual Machines**

1.  From the **Extended** tab of the User Portal, select the Windows virtual machine. Ensure the machine is powered up, then click the **Change CD** button.
2.  From the list of images, select `oVirt-toolsSetup.iso`. Click **OK**.
3.  Once you have attached the guest tools, click the **Console** icon and log in to the virtual machine.
4.  On the virtual machine, locate the CD drive to access the contents of the guest tools ISO file and launch **oVirt-ToolsSetup.exe**. After the tools have been installed, you will be prompted to restart the machine to apply the changes.

**Result**

You have enabled single sign-on for your Windows virtual machine. Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

## Legal Notice

Copyright © 2014 Red Hat, Inc.

This document is licensed by Red Hat under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/). If you distribute this document, or a modified version of it, you must provide attribution to Red Hat, Inc. and provide a link to the original. If the document is modified, all Red Hat trademarks must be removed.

Red Hat, as the licensor of this document, waives the right to enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law.

Red Hat, Red Hat Enterprise Linux, the Shadowman logo, JBoss, MetaMatrix, Fedora, the Infinity Logo, and RHCE are trademarks of Red Hat, Inc., registered in the United States and other countries.

Linux® is the registered trademark of Linus Torvalds in the United States and other countries.

Java® is a registered trademark of Oracle and/or its affiliates.

XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries.

MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries.

Node.js® is an official trademark of Joyent. Red Hat Software Collections is not formally related to or endorsed by the official Joyent Node.js open source or commercial project.

The OpenStack® Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.

All other trademarks are the property of their respective owners.

## Authors and Revision History

**Jodi Biddle**

      jbiddle@redhat.com

**Lucinda Bopf**

      lbopf@redhat.com

**Andrew Burden**

      aburden@redhat.com

*' Zac Dover*'

      zdover@redhat.com

**Tim Hildred**

      thildred@redhat.com

**Dayle Parker**

      dayparke@redhat.com

**Brian Proffitt**

      bkp@redhat.com

### Revision History

Revision 3.4-20

Fri 3 Oct 2014

Brian Proffitt

Converted to oVirt-oriented documentation.

Revision 3.4-19

Fri 27 Jun 2014

Andrew Dahms

|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1093492](https://bugzilla.redhat.com/show_bug.cgi?id=1093492) - Outlined the difference between the methods for sealing a Linux virtual machine. |

Revision 3.4-17

Wed 11 Jun 2014

Andrew Burden

|---------------------|
| Brewing for 3.4 GA. |

Revision 3.4-16

Fri 6 Jun 2014

Andrew Dahms

|----------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#996570](https://bugzilla.redhat.com/show_bug.cgi?id=996570) - Updated the list of console options for the SPICE and VNC connection protocols. |

Revision 3.4-14

Thurs 24 Apr 2014

Timothy Poitras

|----------------------------------------------------------------------------------------------------------------------|
| [BZ#1075477](https://bugzilla.redhat.com/show_bug.cgi?id=1075477) - Updated note re: enabling/disabling SSO on VMs. |

Revision 3.4-13

Tue 22 Apr 2014

Lucy Bopf

|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1088716](https://bugzilla.redhat.com/show_bug.cgi?id=1088716) - Updated screen shots for User Portal (Basic and Extended) to include new reboot button. |

Revision 3.4-10

Wed 16 Apr 2014

Timothy Poitras

|--------------------------------------------------------------------------------------------------------------------|
| [BZ#1085670](https://bugzilla.redhat.com/show_bug.cgi?id=1085670) - Tidied tagging and syntax in multiple topics. |

Revision 3.4-9

Tue 15 Apr 2014

Lucy Bopf

|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1075919](https://bugzilla.redhat.com/show_bug.cgi?id=1075919) - Added a list of parameters that can be changed while a Virtual Machine is running. |

Revision 3.4-8

Thu 03 Apr 2014

Andrew Dahms

|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1091596](https://bugzilla.redhat.com/show_bug.cgi?id=1091596) - Added a note that console settings for virtual machines taken from virtual machine pools are persistent.  |
| [BZ#1088648](https://bugzilla.redhat.com/show_bug.cgi?id=1088648) - Updated the description of selecting virtual machines in procedures involving virtual machine properties. |
| [BZ#1085786](https://bugzilla.redhat.com/show_bug.cgi?id=1085786) - Clarified that the Run Stateless option is only enabled on virtual machines with virtual disks.           |
| [BZ#1081744](https://bugzilla.redhat.com/show_bug.cgi?id=1080398) - Updated the description of the DataCenterAdmin role.                                                      |
| [BZ#1076282](https://bugzilla.redhat.com/show_bug.cgi?id=1076282) - Added a note outlining that the name of the base template is retained for cloned virtual machines.        |
| [BZ#1074421](https://bugzilla.redhat.com/show_bug.cgi?id=1074421) - Added an explanation of how to add and configure watchdogs.                                               |
| [BZ#1071044](https://bugzilla.redhat.com/show_bug.cgi?id=1071044) - Added a description of how to manually associate console.vv files with Remote Viewer.                     |
| [BZ#1039217](https://bugzilla.redhat.com/show_bug.cgi?id=1039217) - Updated the description of how to install and access console components.                                  |

Revision 3.4-7

Wed 02 Apr 2014

Lucy Bopf

|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1076892](https://bugzilla.redhat.com/show_bug.cgi?id=1076892) - Added the VNC Keyboard Layout option in the Run Once window.                         |
| [BZ#1076318](https://bugzilla.redhat.com/show_bug.cgi?id=1076318) - Updated and added procedures and screen shots to include new Reboot button.          |
| [BZ#1075526](https://bugzilla.redhat.com/show_bug.cgi?id=1075526) - Updated and added procedures and screen shots for creating and previewing snapshots. |

Revision 3.4-6

Tue 01 Apr 2014

Zac Dover

|-----------------------------------------------------------------|
| Beta build with Publican 3.99 for rhevm-doc - altered spec.tmpl |

Revision 3.4-3

Thu 27 Mar 2014

Andrew Dahms

|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1081268](https://bugzilla.redhat.com/show_bug.cgi?id=1081268) - Updated the procedure for changing the CD accessible to a virtual machine.                        |
| [BZ#1076283](https://bugzilla.redhat.com/show_bug.cgi?id=1076283) - Added an explanation of how to configure Cloud-Init settings for virtual machines and templates.  |
| [BZ#1075492](https://bugzilla.redhat.com/show_bug.cgi?id=1075492) - Updated sections on creating and using templates to outline the new template sub version feature. |
| [BZ#1075487](https://bugzilla.redhat.com/show_bug.cgi?id=1075487) - Added an explanation of how to configure persistent Cloud-Init settings.                          |

Revision 3.4-2

Thu 20 Mar 2014

Andrew Dahms

|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [BZ#1078606](https://bugzilla.redhat.com/show_bug.cgi?id=1078606) - Updated the location of the USB Clerk and Virt Viewer .msi files.                      |
| [BZ#1075878](https://bugzilla.redhat.com/show_bug.cgi?id=1075878) - Updated the procedure for removing virtual disks from virtual machines.                |
| [BZ#1043433](https://bugzilla.redhat.com/show_bug.cgi?id=1043433) - Added a description of how to ensure USB support is set to native for USB redirection. |

Revision 3.4-1

Mon 17 Mar 2014

Andrew Dahms

|-------------------------------------------------------------------------|
| Initial creation for the Red Hat Enterprise Virtualization 3.4 release. |
