---
title: The Basic Tab
---

# Chapter 2: The Basic Tab

## Basic Tab Graphical Interface

The **Basic** tab enables you to view and use all the virtual machines that are available to you. The screen consists of three areas: the title bar, a virtual machines area, and a details pane. A number of control buttons allow you to work with the virtual machines.

**The User Portal**

![](/images/intro-user/6142.png)

The title bar (1) includes the name of the **User** logged in to the portal and links to the **Guide** and **About** pages.

The virtual machines area displays the name of the virtual machines or virtual machine pools assigned (2). The logo of the virtual machine's operating system or a custom icon also displays (3). When a virtual machine is powered up, you can connect to it by double-clicking on the virtual machine's logo.

On each virtual machine's icon, buttons allow you to start, stop, pause, or reboot a virtual machine (4).

* ![](/images/intro-user/4646.png) The green **Run VM** button starts up the virtual machine. It is available when the virtual machine is paused, stopped or powered off.

* ![](/images/intro-user/4647.png) The red **Shutdown VM** button stops the virtual machine. It is available when the virtual machine is running.

* ![](/images/intro-user/4648.png) The blue **Suspend VM** button temporarily halts the virtual machine. To restart it, press the green **Run VM** button.

* ![](/images/intro-user/5038.png) The green **Reboot VM** button reboots the virtual machine. It is available when the virtual machine is running.

The status of the virtual machine is indicated by the text below the virtual machine's icon - **Machine is Ready** or **Machine is Down**.

Clicking on a virtual machine displays the statistics of the selected virtual machine on the details pane to the right (5), including the operating system, defined memory, number of cores and size of virtual drives. You can also configure connection protocol options (6) such as enabling the use of USB devices or local drives.

## Running Virtual Machines

In the User Portal, virtual machines are represented by icons that indicate both type and status. The icons indicate whether a virtual machine is part of a virtual machine pool or is a standalone Windows or Linux virtual machine. The icons also show whether the virtual machine is running or stopped.

The User Portal displays a list of the virtual machines assigned to you. You can turn on one or more virtual machines, connect, and log in. You can access virtual machines that are running different operating systems, and you can use multiple virtual machines simultaneously.

If you have only one running virtual machine and have enabled automatic connection, you can bypass the User Portal and log in directly to the virtual machine, similar to how you log in to a physical machine.

### Turning on a Virtual Machine

To use a virtual machine in the User Portal, you must turn it on and then connect to it. If a virtual machine is turned off, it is grayed out and displays **Machine is Down**.

You can be assigned an individual virtual machine or assigned to one or more virtual machines that are part of a virtual machine pool. Virtual machines in a pool are all clones of a base template, and have the same operating system and installed applications.

**Note:** When you take a virtual machine from a virtual machine pool, you are not guaranteed to receive the same virtual machine each time. However, if you configure console options for a VM taken from a virtual machine pool, those options are saved as the default for all virtual machines taken from that virtual machine pool.

**Turning on a Virtual Machine**

1. Turn on the standalone virtual machine or take a virtual machine from a pool as follows:

    * To turn on a standalone virtual machine, select the virtual machine icon and click the ![](/images/intro-user/4646.png) button.

        **Turn on virtual machine**

        ![](/images/intro-user/5126.png)

    * To take a virtual machine from a pool, select the virtual machine pool icon and click the ![](/images/intro-user/4646.png) button.

        **Take virtual machine from a pool**

        ![](/images/intro-user/5132.png)

        If there is an available virtual machine in the pool, an icon for that virtual machine will appear in your list. The rest of this procedure then applies to that virtual machine. If you can take multiple virtual machines from a pool, the icon for the virtual machine pool will change into an icon for the last virtual machine you have taken when you take the maximum number of virtual machines possible for that pool.

2. The virtual machine powers up.

    **Virtual machine powering up**

    ![](/images/intro-user/5129.png)

3. When the virtual machine is powered up, the icon is no longer grayed out. The text displays as **Machine is Ready**. You are now ready to connect.

    **Virtual machine turned on**

    ![](/images/intro-user/5127.png)

**Note:** You can only connect to a virtual machine after it has powered up.

### Connecting to a Powered-On Virtual Machine<

After a virtual machine has been turned on, you can connect to it, log in, and start work the same way that you would with a physical machine. The text "Machine is Ready" displays on virtual machines that are powered up.

**Connecting to a Powered on Virtual Machine**

1. Double-click on the selected virtual machine to connect.

    **Connect to Virtual Machine**

    ![](/images/intro-user/5128.png)

2. A console window of the virtual machine displays. You can now use the virtual machine in the same way that you would use a physical desktop.

**Note:** The first time you connect with SPICE, you are prompted to install `virt-viewer`.

### Logging out of a Virtual Machine

To minimize the risk of data loss log out from a virtual machine before shutting it down. Additionally, if you attempt to forcefully shut down a virtual machine from the User Portal, it might freeze with a status of **Powering Down**.

**Shutting down a virtual machine**

1. Log out of the guest operating system.

2. If you were using your virtual machine in full screen mode, press **Shift** + **F11** to exit full screen mode, and close the virtual machine's console window. You are now returned to the User Portal.

3. To shut down the virtual machine, click the ![](/images/intro-user/4647.png) button. The virtual machine is grayed out and displays as "Machine is Down" when it has been turned off.

**Prev:** [Chapter 1: Accessing the User Portal](../chap-Accessing_the_User_Portal) <br>
**Next:** [Chapter 3: The Extended Tab](../chap-The_Extended_Tab)
