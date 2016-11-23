# Editing Virtual Machine Properties

Changes to storage, operating system, or networking parameters can adversely affect the virtual machine. Ensure that you have the correct details before attempting to make any changes. Virtual machines can be edited while running, and some changes (listed in the procedure below) will be applied immediately. To apply all other changes, the virtual machine must be shut down and restarted.

**Editing Virtual Machines**

1. Select the virtual machine to be edited.

2. Click **Edit**.

3. Change settings as required.

    Changes to the following settings are applied immediately:

    * **Name**

    * **Description**

    * **Comment**

    * **Optimized for** (Desktop/Server)

    * **Delete Protection**

    * **Network Interfaces**

    * **Memory Size** (Edit this field to hot plug virtual memory. See [Hot Plugging Virtual Memory](Hot_Plugging_Virtual_Memory).)

    * **Virtual Sockets** (Edit this field to hot plug CPUs. See [CPU hot plug](CPU_hot_plug).)

    * **Use custom migration downtime**

    * **Highly Available**

    * **Priority for Run/Migration queue**

    * **Disable strict user checking**

    * **Icon**

4. Click **OK**.

5. If the **Next Start Configuration** pop-up window appears, click **OK**.

Changes from the list in step 3 are applied immediately. All other changes are applied when you shut down and restart your virtual machine. Until then, an orange icon (![](images/7278.png)) appears as a reminder of the pending changes.
