# Creating a Template

Create a template from an existing virtual machine to use as a blueprint for creating additional virtual machines.

**Important:** Before you create a template, you must seal the source virtual machine to ensure all system-specific details are removed from the virtual machine. This is necessary to prevent the same details from appearing on multiple virtual machines created based on the same template. See [Sealing a Linux Virtual Machine for Deployment as a Template](sect-Sealing_a_Linux_Virtual_Machine_for_Deployment_as_a_Template).

**Creating a Template**

1. Click the **Virtual Machines** tab and select the source virtual machine.

2. Ensure the virtual machine is powered down and has a status of `Down`.

3. Click **Make Template**.

    **The New Template window**

    ![The New Template window](images/6325.png)

4. Enter a **Name**, **Description**, and **Comment** for the template.

5. Select the cluster with which to associate the template from the **Cluster** drop-down list. By default, this is the same as that of the source virtual machine.

6. Optionally, select a CPU profile for the template from the **CPU Profile** drop-down list.

7. Optionally, select the **Create as a Sub Template version** check box, select a **Root Template**, and enter a **Sub Version Name** to create the new template as a sub template of an existing template.

8. In the **Disks Allocation** section, enter an alias for the disk in the **Alias** text field, and select the storage domain on which to store the disk from the **Target** list. By default, these are the same as those of the source virtual machine.

9. Select the **Allow all users to access this Template** check box to make the template public.

10. Select the **Copy VM permissions** check box to copy the permissions of the source virtual machine to the template.

11. Click **OK**.

The virtual machine displays a status of `Image Locked` while the template is being created. The process of creating a template may take up to an hour depending on the size of the virtual machine disk and the capabilities of your storage hardware. When complete, the template is added to the **Templates** tab. You can now create new virtual machines based on the template.

**Note:** When a template is made, the virtual machine is copied so that both the existing virtual machine and its template are usable after template creation.
