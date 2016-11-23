# Removing a Virtual Disk from a Virtual Machine

**Removing Virtual Disks From Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane and select the virtual disk to remove.

3. Click **Deactivate**.

4. Click **OK**.

5. Click **Remove**.

6. Optionally, select the **Remove Permanently** check box to completely remove the virtual disk from the environment. If you do not select this option - for example, because the disk is a shared disk - the virtual disk will remain in the **Disks** resource tab.

7. Click **OK**.

If the disk was created as block storage, for example iSCSI, and the **Wipe After Delete** check box was selected when creating the disk, you can view the log file on the host to confirm that the data has been wiped after permanently removing the disk. See [Settings to Wipe Virtual Disks After Deletion](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#Settings_to_Wipe_Virtual_Disks_After_Deletion) in the *Administration Guide*.
