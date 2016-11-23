# Creating a Windows Virtual Machine

Create a new virtual machine and configure the required settings.

**Creating Windows Virtual Machines**

1. Click the **Virtual Machines** tab.

2. Click the **New VM** button to open the **New Virtual Machine** window.

    **The New Virtual Machine Window**

    ![](images/7316.png)

3. Select a Windows variant from the **Operating System** drop-down list.

4. Enter a **Name** for the virtual machine.

5. Add storage to the virtual machine. **Attach** or **Create** a virtual disk under **Instance Images**.

    * Click **Attach** and select an existing virtual disk. 

    * Click **Create** and enter a **Size(GB)** and **Alias** for a new virtual disk. You can accept the default settings for all other fields, or change them if required. See [Add Virtual Disk dialogue entries](Add_Virtual_Disk_dialogue_entries) for more details on the fields for all disk types.

6. Connect the virtual machine to the network. Add a network interface by selecting a vNIC profile from the **nic1** drop-down list at the bottom of the **General** tab.

7. Specify the virtual machine's **Memory Size** on the **System** tab.

8. Choose the **First Device** that the virtual machine will boot from on the **Boot Options** tab.

9. You can accept the default settings for all other fields, or change them if required. For more details on all fields in the **New Virtual Machine** window, see [Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows](sect-Explanation_of_Settings_in_the_New_Virtual_Machine_and_Edit_Virtual_Machine_Windows).

10. Click **OK**.

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`. Before you can use this virtual machine, you must install an operating system and VirtIO-optimized disk and network drivers.
