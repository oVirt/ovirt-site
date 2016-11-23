# Creating a Virtual Machine Based on a Template

Create virtual machines based on templates. This allows you to create virtual machines that are pre-configured with an operating system, network interfaces, applications and other resources.

**Note:** Virtual machines created based on a template depend on that template. This means that you cannot remove that template from the Manager if there is a virtual machine that was created based on that template. However, you can clone a virtual machine from a template to remove the dependency on that template.

**Creating a Virtual Machine Based on a Template**

1. Click the **Virtual Machines** tab.

2. Click **New VM**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Based on Template** list.

5. Enter a **Name**, **Description**, and any **Comments**, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.

6. Click the **Resource Allocation** tab.

7. Select the **Thin** radio button in the **Storage Allocation** area.

8. Select the disk provisioning policy from the **Allocation Policy** list. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.

    * Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.

    * Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

9. Use the **Target** list to select the storage domain on which the virtual machine's virtual disk will be stored.

10. Click **OK**.

The virtual machine is displayed in the **Virtual Machines** tab.
