# Creating a Virtual Machine Pool

You can create a virtual machine pool that contains multiple virtual machines that have been created based on a common template.

**Creating a Virtual Machine Pool**

1. Click the **Pools** tab.

2. Click the **New** button to open the **New Pool** window.

3. Use the drop down-list to select the **Cluster** or use the selected default.

4. Use the **Template** drop-down menu to select the required template and version or use the selected default. A template provides standard settings for all the virtual machines in the pool.

5. Use the **Operating System** drop-down list to select an **Operating System** or use the default provided by the template.

6. Use the **Optimized for** drop-down list to optimize virtual machines for either **Desktop** use or **Server** use.

7. Enter a **Name** and **Description**, any **Comments**, and the **Number of VMs** for the pool.

8. Enter the number of virtual machines to be prestarted in the **Prestarted VMs** field.

9. Select the **Maximum number of VMs per user** that a single user is allowed to run in a session. The minimum is one.

10. Select the **Delete Protection** check box to enable delete protection. 

11. Optionally, click the **Show Advanced Options** button and perform the following steps:

    1. Click the **Type** tab and select a **Pool Type**:

        * **Manual** - The administrator is responsible for explicitly returning the virtual machine to the pool. The virtual machine reverts to the original base image after the administrator returns it to the pool.

        * **Automatic** - When the virtual machine is shut down, it automatically reverts to its base image and is returned to the virtual machine pool.

    2. Select the **Console** tab. At the bottom of the tab window, select the **Override SPICE Proxy** check box to enable the **Overridden SPICE proxy address** text field. Specify the address of a SPICE proxy to override the global SPICE proxy.

12. Click **OK**.

You have created and configured a virtual machine pool with the specified number of identical virtual machines. You can view these virtual machines in the **Virtual Machines** resource tab, or in the details pane of the **Pools** resource tab; a virtual machine in a pool is distinguished from independent virtual machines by its icon.
