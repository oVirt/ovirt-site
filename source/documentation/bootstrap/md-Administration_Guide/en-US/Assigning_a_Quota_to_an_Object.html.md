# Assigning a Quota to an Object

**Summary**

This procedure explains how to associate a virtual machine with a quota.

**Assigning a Quota to a Virtual Machine**

1. In the navigation pane, select the Virtual Machine to which you plan to add a quota.

2. Click **Edit**. The **Edit Virtual Machine** window appears.

3. Select the quota you want the virtual machine to consume. Use the **Quota** drop-down to do this.

4. Click **OK**.

**Result**

You have designated a quota for the virtual machine you selected.

**Summary**

This procedure explains how to associate a virtual machine disk with a quota.

**Assigning a Quota to a Virtual Disk**

1. In the navigation pane, select the Virtual Machine whose disk(s) you plan to add a quota.

2. In the details pane, select the disk you plan to associate with a quota.

3. Click **Edit**. The **Edit Virtual Disk** window appears.

4. Select the quota you want the virtual disk to consume.

5. Click **OK**.

**Result**

You have designated a quota for the virtual disk you selected.

**Important:** Quota must be selected for all objects associated with a virtual machine, in order for that virtual machine to work. If you fail to select a quota for the objects associated with a virtual machine, the virtual machine will not work. The error that the Manager throws in this situation is generic, which makes it difficult to know if the error was thrown because you did not associate a quota with all of the objects associated with the virtual machine. It is not possible to take snapshots of virtual machines that do not have an assigned quota. It is not possible to create templates of virtual machines whose virtual disks do not have assigned quotas.
