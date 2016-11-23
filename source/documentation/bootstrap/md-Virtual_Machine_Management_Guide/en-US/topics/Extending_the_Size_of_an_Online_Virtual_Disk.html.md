# Extending the Available Size of a Virtual Disk

You can extend the available size of a virtual disk while the virtual disk is attached to a virtual machine. Resizing a virtual disk does not resize the underlying partitions or file systems on that virtual disk. Use the `fdisk` utility to resize the partitions and file systems as required. See [How to Resize a Partition using fdisk](https://access.redhat.com/articles/1190213) for more information.

**Extending the Available Size of Virtual Disks**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane and select the disk to edit.

3. Click **Edit**.

4. Enter a value in the `Extend size by(GB)` field.

5. Click **OK**.

The target disk's status becomes `locked` for a short time, during which the drive is resized. When the resizing of the drive is complete, the status of the drive becomes `OK`.
