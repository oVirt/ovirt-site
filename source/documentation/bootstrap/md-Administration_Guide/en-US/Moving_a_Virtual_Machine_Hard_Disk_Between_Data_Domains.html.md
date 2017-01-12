# Moving a Virtual Disk

Move a virtual disk that is attached to a virtual machine or acts as a floating virtual disk from one storage domain to another. You can move a virtual disk that is attached to a running virtual machine; this is referred to as live storage migration. Alternatively, shut down the virtual machine before continuing. 

Consider the following when moving a disk:

* You can move multiple disks at the same time.

* You can move disks between any two storage domains in the same data center.

* If the virtual disk is attached to a virtual machine that was created based on a template and used the thin provisioning storage allocation option, you must copy the disks for the template on which the virtual machine was based to the same storage domain as the virtual disk.

**Moving a Virtual Disk**

1. Select the **Disks** tab.

2. Select one or more virtual disks to move.

3. Click **Move** to open the **Move Disk(s)** window.

4. From the **Target** list, select the storage domain to which the virtual disk(s) will be moved.

5. From the **Disk Profile** list, select a profile for the disk(s), if applicable.

6. Click **OK**.

The virtual disks are moved to the target storage domain, and have a status of `Locked` while being moved.



