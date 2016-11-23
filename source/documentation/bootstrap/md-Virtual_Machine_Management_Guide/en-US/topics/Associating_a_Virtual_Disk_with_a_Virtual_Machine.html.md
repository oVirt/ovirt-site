# Attaching an Existing Disk to a Virtual Machine

Floating disks are disks that are not associated with any virtual machine.

Floating disks can minimize the amount of time required to set up virtual machines. Designating a floating disk as storage for a virtual machine makes it unnecessary to wait for disk preallocation at the time of a virtual machine's creation.

Floating disks can be attached to a single virtual machine, or to multiple virtual machines if the disk is shareable.

Once a floating disk is attached to a virtual machine, the virtual machine can access it.

**Attaching Virtual Disks to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane.

3. Click **Attach**.

    **The Attach Virtual Disks Window**

    ![](images/7318.png)

4. Select one or more virtual disks from the list of available disks.

5. Click **OK**.

**Note:** No Quota resources are consumed by attaching virtual disks to, or detaching virtual disks from, virtual machines.
