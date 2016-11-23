# Creating a Snapshot of a Virtual Machine

A snapshot is a view of a virtual machine's operating system and applications on any or all available disks at a given point in time. Take a snapshot of a virtual machine before you make a change to it that may have unintended consequences. You can use a snapshot to return a virtual machine to a previous state.

**Important:** Before taking a live snapshot of a virtual machine using OpenStack Volume (Cinder) disks, you must freeze and thaw the guest filesystem manually. This cannot be done with the Manager, and must be executed using the REST API. See [Freeze Virtual Machine Filesystems Action](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/rest-api-guide/index.html#Freeze_Virtual_Machine_Filesystems_Action) in the *Red Hat Virtualization REST API Guide* for more information.

**Creating a Snapshot of a Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane and click **Create**.

    **Create snapshot**

    ![](images/5030.png)

3. Enter a description for the snapshot.

4. Select **Disks to include** using the check boxes.

5. Use the **Save Memory** check box to denote whether to include the virtual machine's memory in the snapshot.

6. Click **OK**.

**Note:** If you are taking a snapshot of a virtual machine with an OpenStack Volume (Cinder) disk, you must thaw the guest filesystem when the snapshot is complete using the REST API. See [Thaw Virtual Machine Filesystems Action](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/rest-api-guide/index.html#Thaw_Virtual_Machine_Filesystems_Action) in the *REST API Guide for instructions.

The virtual machine's operating system and applications on the selected disk(s) are stored in a snapshot that can be previewed or restored. The snapshot is created with a status of `Locked`, which changes to `Ok`. When you click on the snapshot, its details are shown on the **General**, **Disks**, **Network Interfaces**, and **Installed Applications** tabs in the right side-pane of the details pane.





