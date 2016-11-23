# Creating a Cloned Virtual Machine Based on a Template

Cloned virtual machines are similar to virtual machines based on templates. However, while a cloned virtual machine inherits settings in the same way as a virtual machine based on a template, a cloned virtual machine does not depend on the template on which it was based after it has been created.

**Note:** If you clone a virtual machine from a template, the name of the template on which that virtual machine was based is displayed in the **General** tab of the **Edit Virtual Machine** window for that virtual machine. If you change the name of that template, the name of the template in the **General** tab will also be updated. However, if you delete the template from the Manager, the original name of that template will be displayed instead.

**Cloning a Virtual Machine Based on a Template**

1. Click the **Virtual Machines** tab.

2. Click **New VM**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Based on Template** drop-down menu.

5. Enter a **Name**, **Description** and any **Comments**. You can accept the default values inherited from the template in the rest of the fields, or change them if required.

6. Click the **Resource Allocation** tab.

7. Select the **Clone** radio button in the **Storage Allocation** area.

8. Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.

    * Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.

    * Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

9. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.

10. Click **OK**.

**Note:** Cloning a virtual machine may take some time. A new copy of the template's disk must be created. During this time, the virtual machine's status is first **Image Locked**, then **Down**.

The virtual machine is created and displayed in the **Virtual Machines** tab. You can now assign users to it, and can begin using it when the clone operation is complete.
