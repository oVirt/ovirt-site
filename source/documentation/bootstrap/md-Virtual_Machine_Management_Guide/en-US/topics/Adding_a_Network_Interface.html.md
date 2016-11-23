# Adding a New Network Interface

You can add multiple network interfaces to virtual machines. Doing so allows you to put your virtual machine on multiple logical networks.

**Adding Network Interfaces to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Network Interfaces** tab in the details pane.

3. Click **New**.

    **New Network Interface window**

    ![](images/7320.png)

4. Enter the **Name** of the network interface.

5. Use the drop-down lists to select the **Profile** and the **Type** of the network interface. The **Profile** and **Type** drop-down lists are populated in accordance with the profiles and network types available to the cluster and the network interface cards available to the virtual machine.

6. Select the **Custom MAC address** check box and enter a MAC address for the network interface card as required.

7. Click **OK**.

The new network interface is listed in the **Network Interfaces** tab in the details pane of the virtual machine. The **Link State** is set to **Up** by default when the network interface card is defined on the virtual machine and connected to the network.

For more details on the fields in the **New Network Interface** window, see [Virtual Machine Network Interface dialogue entries](Virtual_Machine_Network_Interface_dialogue_entries).
