# Adding a New Virtual Disk

You can add multiple virtual disks to a virtual machine.

**Image** is the default type of disk. You can also add a **Direct LUN** disk or a **Cinder** (OpenStack Volume) disk. **Image** disk creation is managed entirely by the Manager. **Direct LUN** disks require externally prepared targets that already exist. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the Red Hat Virtualization environment using the **External Providers** window; see [Adding an OpenStack Volume (Cinder) Instance for Storage Management](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/administration-guide/112-adding-external-providers#Adding_an_OpenStack_Volume_Cinder_Instance_for_Storage_Management) for more information. Existing disks are either floating disks or shareable disks attached to virtual machines.

**Adding Disks to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane.

3. Click **New**.

    **The New Virtual Disk Window**

    ![](images/7319.png)

4. Use the appropriate radio buttons to switch between **Image**, **Direct LUN**, or **Cinder**. Virtual disks added in the User Portal can only be **Image** disks. **Direct LUN** and **Cinder** disks can be added in the Administration Portal.

5. Enter a **Size(GB)**, **Alias**, and **Description** for the new disk.

6. Use the drop-down lists and check boxes to configure the disk. See [Add Virtual Disk dialogue entries](Add_Virtual_Disk_dialogue_entries) for more details on the fields for all disk types.

7. Click **OK**.

The new disk appears in the details pane after a short time.
