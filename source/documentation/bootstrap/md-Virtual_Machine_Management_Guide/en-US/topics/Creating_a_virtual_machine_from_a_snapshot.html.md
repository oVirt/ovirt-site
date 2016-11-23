# Creating a Virtual Machine from a Snapshot

You have created a snapshot from a virtual machine. Now you can use that snapshot to create another virtual machine.

**Creating a virtual machine from a snapshot**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the available snapshots.

3. Select a snapshot in the list displayed and click **Clone**.

4. Enter the **Name** and **Description** for the virtual machine.

    **Clone a Virtual Machine from a Snapshot**

    ![](images/6581.png)

5. Click **OK**.

After a short time, the cloned virtual machine appears in the **Virtual Machines** tab in the navigation pane with a status of `Image Locked`. The virtual machine will remain in this state until Red Hat Virtualization completes the creation of the virtual machine. A virtual machine with a preallocated 20 GB hard drive takes about fifteen minutes to create. Sparsely-allocated virtual disks take less time to create than do preallocated virtual disks.

When the virtual machine is ready to use, its status changes from `Image Locked` to `Down` in the **Virtual Machines** tab in the navigation pane.
