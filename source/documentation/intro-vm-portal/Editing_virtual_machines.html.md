# Editing virtual machines

**Note:** Your user role must have permission to edit a virtual machine.

You can edit a virtual machine's disk, network interfaces, and console settings in the virtual machine's details view. See [Viewing virtual machine details](../Viewing_virtual_machine_details).

**Editing a virtual machine**

1. In the virtual machines pane, click the **Edit** icon (![](images/Edit_VM.png)) of the virtual machine that you want to edit. The following fields appear:

   * **Name** of the virtual machine. The virtual machine name may contain only upper- or lower-case letters, numbers, underscores, hyphens, or periods. Special characters and spaces are not permitted.
   * **Description** (optional)
   * **Cluster**
   * **Template**
   * **Operating System**
   * **Defined Memory**
   * **CPUs**
   * **CD**
   * **Boot menu** - When this is set to `ON`, the **Boot** menu appears in the console, enabling you to select a bootable device.
   * **Cloud-Init** - The `cloud-init` tool allows you to automate the deployment of virtual machines. When this is set to `ON`, the **Hostname** and **SSH Authorized Keys** fields display. See [Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/virtual_machine_management_guide/#Virtual_Machine_General_settings_explained) in the *Virtual Machine Management Guide* for details.

2. Click **Update VM**.

**Changing a virtual machine's icon**

1. Click the **Edit** icon under the virtual machine's icon.
2. Browse to your image and click **Open**. The maximum permitted size is 150 x 120 pixels.

To restore the default icon, click the circular arrow.
