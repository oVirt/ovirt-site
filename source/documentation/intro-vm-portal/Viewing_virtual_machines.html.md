---
title: Managing Virtual Machines
---

# Chapter 2: Managing Virtual Machines

You can perform common virtual machine management tasks in the virtual machines pane:

* Start up a virtual machine by clicking the **Run** icon (![](/images/intro-vm-portal/Run.png)). It is available when the virtual machine is paused, stopped, or powered off.

* Temporarily stop a virtual machine by clicking the **Suspend** icon (![](/images/intro-vm-portal/Suspend.png)). It is available when the virtual machine is running.

* Stop a virtual machine by clicking the **Shutdown** icon (![](/images/intro-vm-portal/Shutdown.png)). It is available when the virtual machine is running.

* Restart a virtual machine by clicking the **Reboot** icon (![](/images/intro-vm-portal/Reboot.png)).  It is available when the virtual machine is running.

* Access the console of a virtual machine by clicking the **Console** icon (![](/images/intro-vm-portal/Console.png)). It is available when the virtual machine is running.

* Edit a virtual machine by clicking the **Edit** icon (![](/images/intro-vm-portal/Edit_VM.png)).

## Viewing virtual machine details

**Viewing a virtual machine's details**

Click the virtual machine's name in the virtual machines pane to go to the details view. The following details display:

* **State** - For example, `Up`, `Down`, `Paused`, `Suspended`

* **Description** (optional)

* **Cluster**

* **Template**

* **Operating System**

* **Optimized for** - `Desktop`/`Server`/`High Performance`

* **Defined Memory**

* **CPUs**

* **Address** - Virtual machine's FQDN. The guest agent must be installed on the virtual machine to retrieve this value.

* **CD**

* **Console** - See the "Changing console settings" section for more information about console options.

* **Disks** - Clicking the **Edit** icon displays the **Delete** and **New** buttons, for deleting the current disk and creating a new disk.

* **Network interfaces** - Clicking the **Edit** icon displays the **Delete** and **New** buttons, for deleting the current network interface and creating a new network interface.

* **Boot Menu** status - `On`/`Off`

* **Cloud-Init** status - `On`/`Off`. To change the **Boot Menu** or **Cloud-Init** status, see the "Editing virtual machines".

To go directly to the details view of other virtual machines, click the collapsible arrow on the left side of the details pane to open a list of available virtual machines. You can click each machine name to view its details.

## Editing virtual machines

    **Note:** Your user role must have permission to edit a virtual machine.

You can edit a virtual machine's disk, network interfaces, and console settings in the virtual machine's details view. See the "Viewing virtual machine details" section.

**Editing a virtual machine**

1. In the virtual machines pane, click the **Edit** icon (![](/images/intro-vm-portal/Edit_VM.png)) of the virtual machine that you want to edit. The following fields appear:

   * **Name** of the virtual machine. The virtual machine name may contain only upper- or lower-case letters, numbers, underscores, hyphens, or periods. Special characters and spaces are not permitted.

   * **Description** (optional)

   * **Cluster**

   * **Template**

   * **Operating System**

   * **Defined Memory**

   * **CPUs**

   * **CD**

   * **Boot menu** - When this is set to `ON`, the **Boot** menu appears in the console, enabling you to select a bootable device.

   * **Cloud-Init** - The `cloud-init` tool allows you to automate the deployment of virtual machines. When this is set to `ON`, the **Hostname** and **SSH Authorized Keys** fields display.

2. Click **Update VM**.

**Changing a virtual machine's icon**

1. Click the **Edit** icon under the virtual machine's icon.

2. Browse to your image and click **Open**. The maximum permitted size is 150 x 120 pixels.

To restore the default icon, click the circular arrow.

## Creating virtual machines

**Creating a virtual machine**

1. Click the **Add New VM** button in the toolbar.

2. Set the following fields:

   * **Name** of the virtual machine. The virtual machine name may contain only upper- or lower-case letters, numbers, underscores (`_`), hyphens (`-`), or periods (`.`). Special characters and spaces are not permitted.

   * **Description** (optional)

   * **Cluster**

   * **Template**

   * **Operating System**

   * **Defined Memory**

   * **CPUs**

   * **CD**

3. Click **Create VM**.

## Connecting to virtual machines

**Connecting to a virtual machine**

1. In the virtual machines pane, click the **Run** icon to start a virtual machine.

2. Click the **Console** icon to connect to the virtual machine.

3. You will be asked to download a **.vv** file.

4. Open the file with **remote-viewer**. A console window displays.

   You can now use the virtual machine in the same way that you would use a physical desktop.

   # Changing console settings

   **Note:** The `Console` settings may be changed by any user who has permission to view the virtual machine. The changes are stored locally in the browser, not on the server.

   **Changing console settings**

   1. In the virtual machines pane, click the virtual machine name to go to the details view.

   2. Click the **Console** settings icon (![](/images/intro-vm-portal/Edit_blue.png)) to access the following options:

      * **Connect automatically**: Enables you to connect automatically if only one virtual machine is running.

      * **Fullscreen**: Opens the virtual machine console in full screen automatically when you connect to the virtual machine. Press `SHIFT + F11` to toggle full screen mode on or off.

      * **Use Ctrl+Alt+Del**: Maps the `Ctrl+Alt+End` key combination to `Ctrl+Alt+Del` inside the virtual machine.

      * **Smartcard enabled**: Allows you to pass the smartcard from your client machine to the virtual machine.

**Prev:** [Chapter 1: Accessing the VM Portal](../What_is_the_VM_Portal)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/introduction_to_the_vm_portal/chap-managing_virtual_machines)
