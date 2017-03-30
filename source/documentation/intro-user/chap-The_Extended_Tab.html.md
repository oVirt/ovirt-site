---
title: The Extended Tab
---

# Chapter 3: The Extended Tab

# Extended Tab Graphical Interface

The **Extended** tab graphical interface enables you to access and monitor all the virtual resources that are available to you.

**The Extended Tab**

![](/images/intro-user/6144.png)

**The Extended Tab**

<table>
 <thead>
  <tr>
   <td>Number</td>
   <td>Element Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>1</td>
   <td>Title Bar</td>
   <td>Includes the name of the <b>User</b> logged in to the portal and links to the <b>Guide</b> and <b>About</b> pages.</td>
  </tr>
  <tr>
   <td>2</td>
   <td>User Portal View Option Tabs</td>
   <td>Power Users have access to the <b>Extended</b> tab of the User Portal and the <b>Basic</b> tab of the User Portal. The <b>Basic</b> view is the default view for users with basic permissions.</td>
  </tr>
  <tr>
   <td>3</td>
   <td>Navigation Pane</td>
   <td>The Navigation Pane allows you to toggle between the Virtual Machines, Templates, and Resources tabs.</td>
  </tr>
  <tr>
   <td>4</td>
   <td>Management Bar</td>
   <td>The management bar is used to create and make changes to virtual machines.</td>
  </tr>
  <tr>
   <td>5</td>
   <td>Virtual Machine List</td>
   <td>The list of virtual machines, with the operating systems installed on them and their statuses (running, paused, or stopped).</td>
  </tr>
  <tr>
   <td>6</td>
   <td>Virtual Machine Control Buttons</td>
   <td>
    <p>Virtual Machine Control Buttons allow you to start, stop, pause, or power off virtual machines.</p>
    <ul>
     <li>The green <b>Run VM</b> button starts up the virtual machine. It is available when the virtual machine is paused, stopped or powered off.</li>
     <li>The red <b>Shutdown VM</b> button stops the virtual machine. It is available when the virtual machine is running.</li>
     <li>The blue <b>Suspend VM</b> button temporarily halts the virtual machine. To restart it, press the green <b>Run VM</b> button.</li>
     <li>The green <b>Reboot VM</b> button reboots the virtual machine. It is available when the virtual machine is running.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>7</td>
   <td>Console Button</td>
   <td>The console button launches a SPICE window and connects to machines that have been powered-up.</td>
  </tr>
  <tr>
   <td>8</td>
   <td>Details Pane</td>
   <td>The Details Pane displays the statistics of the virtual machine selected in the Navigation Pane.</td>
  </tr>
 </tbody>
</table>

**Details Pane Tab Functions:**

* The **General** tab displays basic software and hardware information of the virtual machine, including its name, operating system, display protocol and defined memory.

* The **Network Interfaces** tab displays the name, type and speed of the network connected to the virtual machine. You can add, edit and remove network interfaces using this tab.

* The **Disks** tab displays the name, size and format of the disk attached to the virtual machine. You can add, edit and remove virtual disks using this tab.

* The **Snapshots** tab displays a view of the virtual machine's operating system and applications. You can create and use snapshots using this tab.

* The **Permissions** tab displays the users and roles assigned to each virtual machine. You can assign and remove user permissions using this tab.

* The **Events** tab displays the description and time of events which affect the virtual machine.

* The **Applications** tab displays the applications which have been installed on the virtual machine.

* The **Monitor** tab displays the CPU Usage, Memory Usage, and Network Usage statistics for the machine selected in the Navigation Pane.

* The **Sessions** tab displays the Logged-In User, Console User, and Console Client IP for the machine selected in the Navigation Pane.

## Running Virtual machines

In the User Portal, virtual machines are represented by icons that indicate both type and status. The icons indicate whether a virtual machine is part of a virtual machine pool or is a standalone Windows or Linux virtual machine. The icons also show whether the virtual machine is running or stopped.

The User Portal displays a list of the virtual machines assigned to you. You can turn on one or more virtual machines, connect, and log in. You can access virtual machines that are running different operating systems, and you can use multiple virtual machines simultaneously.

If you have only one running virtual machine and have enabled automatic connection, you can bypass the User Portal and log in directly to the virtual machine, similar to how you log in to a physical machine.

### Connecting to Virtual Machines

After you have logged into the portal, you can start, stop, or connect to the virtual machines that are displayed.

**Connecting to Virtual Machines**

1. Select the required virtual machine, then click the Run ![](/images/intro-user/4646.png) button. The virtual machine powers up.

    **Virtual machine turned off**

    ![](/images/intro-user/5039.png)

    The Stop symbol next to the virtual machine's name changes to a Powering Up symbol.

    When the virtual machine is turned on, the Run symbol displays next to the virtual machine's name.

    **Virtual machine turned on**

    ![](/images/intro-user/5040.png)

2. Click the **Console** button to connect to the virtual machine.

    **Connect to virtual machine**

    ![](/images/intro-user/5041.png)

3. If it is the first time connecting with SPICE, you will be prompted to install `virt-viewer`.

A console window of the virtual machine displays. You can now use the virtual machine in the same way that you would use a physical desktop.

**Warning:** By default, a virtual machine running Windows 7 will be suspended after an hour of inactivity. This prevents users from connecting to the virtual machine from the User Portal. To avoid this, disable the power-saving feature on the guest's power manager.

### Turning Off a Virtual Machine from the User Portal

If you attempt to turn off a virtual machine from the User Portal, it may freeze with a status of **Powering Down**, indicating that it has not completely shut down.

**Important:** To minimize the risk of data loss, log off from a virtual machine before turning it off.

**Turning Off a Virtual Machine from the User Portal**

1. Log out of the guest operating system.

2. If you were using your virtual machine in full screen mode, press **Shift** + **F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.

    To turn off the virtual machine, click the ![](/images/intro-user/4647.png) button. The Stop symbol appears next to the name of the virtual machine when it has been turned off.

**Note:** You can also turn off virtual machines gracefully using the native method from within the virtual machine itself. For example, in Windows virtual machines you can click **Start** > **Shut Down**, and in Enterprise Linux virtual machines you can click **System** > **Shut Down**.

### Rebooting a Virtual Machine from the User Portal<

**Important:** To minimize the risk of data loss, log off from a virtual machine before rebooting.

**Rebooting a Virtual Machine from the User Portal**

1. Log out of the guest operating system.

2. If you were using your virtual machine in full screen mode, press **Shift** + **F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.

3. To reboot the virtual machine, click the ![](/images/intro-user/5038.png) button. The Reboot symbol appears next to the name of the virtual machine while it is rebooting, then changes back to a Run symbol when reboot completes.

## Resources

### Monitoring Resources

Before making configuration changes to virtual machines in the User Portal, it is recommended that you take an inventory of the resources available. This is to ensure the resources are sufficient for peak performance and to avoid overloading the hosts running the virtual machines.

The **Resources** tab in the navigation pane shows a cumulative view of all the resources available in the User Portal, and the performance and statistics of each virtual machine.

**Resources tab**

![](/images/intro-user/6561.png)

* **Virtual CPUs**: This box displays the number of your machines' virtual CPUs in use, and the consumption of CPU quota used by you and others.

* **Memory**: This box displays the consumption of memory quota used by you and others, and available memory as defined by the quota.

* **Storage**: This box displays the consumption of storage quota by you and others, the total size of all your virtual disks, and the number and total size of your virtual machines' snapshots. It also displays a breakdown of storage details for each virtual machine. Click the **+** button next to the virtual machine name to display all the virtual disks attached to the virtual machine.

### Quota - A User's Introduction

When you create a virtual machine, the virtual machine consumes CPU and storage resources from its data center. Quota compares the amount of virtual resources consumed by the creation of the virtual machine to the storage allowance and the runtime allowance set by the system administrator.

If you do not have enough of either kind of allowance, you are not allowed to create the virtual machine. Avoid exceeding your quota limit by using the Resources tab to monitor your CPU and storage consumption.

**Resources tab**

![](/images/intro-user/6561.png)

# What to Do When You Exceed Your Quota

oVirt provides a resource limitation tool called *quota*, which allows system administrators to limit the amount of CPU and storage each user can consume. Quota compares the amount of virtual resources consumed when you use the virtual machine to the storage allowance and the runtime allowance set by the system administrator.

When you exceed your quota, a pop-up window informs you that you have exceeded your quota, and you will no longer have access to virtual resources. For example, this can happen if you have too many concurrently running virtual machines in your environment.

**Quota exceeded error message**

![](/images/intro-user/1165.png)

To regain access to your virtual machines, do one of the following:

* Shut down the virtual machines that you do not need to bring your resource consumption down to a level that does not exceed the quota. Once the resource consumption level is below the quota you will be able to run virtual machines again.

* If you cannot shut down any existing virtual machines, contact your system administrator to extend your quota allowance or remove any unused virtual machines.

**Prev:** [Chapter 2: The Basic Tab](../chap-The_Basic_Tab)
