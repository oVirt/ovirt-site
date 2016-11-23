# Importing a Virtual Machine into the Destination Data Center

You have a virtual machine on an export domain. Before the virtual machine can be imported to a new data center, the export domain must be attached to the destination data center.

**Importing a Virtual Machine into the Destination Data Center**

1. Click the **Storage** tab, and select the export domain in the results list. The export domain must have a status of `Active`.

2. Select the **VM Import** tab in the details pane to list the available virtual machines to import.

3. Select one or more virtual machines to import and click **Import**.

    **Import Virtual Machine**

    ![](images/6582.png)

4. Select the **Default Storage Domain** and **Cluster**.

5. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

6. Click the virtual machine to be imported and click on the **Disks** sub-tab. From this tab, you can use the **Allocation Policy** and **Storage Domain** drop-down lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and can also select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

7. Click **OK** to import the virtual machines.

8. The **Import Virtual Machine Conflict** window opens if the virtual machine exists in the virtualized environment.

    **Import Virtual Machine Conflict Window**

    ![](images/6583.png)

9. Choose one of the following radio buttons: 

    * **Don't import**

    * **Import as cloned** and enter a unique name for the virtual machine in the **New Name** field.

10. Optionally select the **Apply to all** check box to import all duplicated virtual machines with the same suffix, and then enter a suffix in the **Suffix to add to the cloned VMs** field.

11. Click **OK**.

**Important:** During a single import operation, you can only import virtual machines that share the same architecture. If any of the virtual machines to be imported have a different architecture to that of the other virtual machines to be imported, a warning will display and you will be prompted to change your selection so that only virtual machines with the same architecture will be imported.
