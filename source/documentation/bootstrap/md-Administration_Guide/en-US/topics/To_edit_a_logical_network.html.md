# Editing a Logical Network

Edit the settings of a logical network.

**Editing a Logical Network**

**Important:** A logical network cannot be edited or moved to another interface if it is not synchronized with the network configuration on the host. See [Editing host network interfaces](Editing_host_network_interfaces) on how to synchronize your networks.

1. Click the **Data Centers** resource tab, and select the data center of the logical network in the results list.

2. Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.

3. Select a logical network and click **Edit** to open the **Edit Logical Network** window.

4. Edit the necessary settings.

5. Click **OK** to save the changes.

**Note:** Multi-host network configuration automatically applies updated network settings to all of the hosts within the data center to which the network is assigned. Changes can only be applied when virtual machines using the network are down. You cannot rename a logical network that is already configured on a host. You cannot disable the **VM Network** option while virtual machines or templates using that network are running.
