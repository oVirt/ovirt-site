# Adding Multiple VLANs to a Single Network Interface Using Logical Networks

Multiple VLANs can be added to a single network interface to separate traffic on the one host.

**Important:** You must have created more than one logical network, all with the **Enable VLAN tagging** check box selected in the **New Logical Network** or **Edit Logical Network** windows.

**Adding Multiple VLANs to a Network Interface using Logical Networks**

1. Click the **Hosts** resource tab, and select in the results list a host associated with the cluster to which your VLAN-tagged logical networks are assigned.

2. Click the **Network Interfaces** tab in the details pane to list the physical network interfaces attached to the data center.

3. Click **Setup Host Networks** to open the **Setup Host Networks** window.

4. Drag your VLAN-tagged logical networks into the **Assigned Logical Networks** area next to the physical network interface. The physical network interface can have multiple logical networks assigned due to the VLAN tagging.

5. Edit the logical networks by hovering your cursor over an assigned logical network and clicking the pencil icon to open the **Edit Network** window.

    If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box.

    Select a **Boot Protocol** from: 

    * **None**,

    * **DHCP**, or

    * **Static**,

        Provide the **IP** and **Subnet Mask**.

    Click **OK**.

6. Select the **Verify connectivity between Host and Engine** check box to run a network check; this will only work if the host is in maintenance mode.

7. Select the **Save network configuration** check box

8. Click **OK**.

Add the logical network to each host in the cluster by editing a NIC on each host in the cluster. After this is done, the network will become operational.

You have added multiple VLAN-tagged logical networks to a single interface. This process can be repeated multiple times, selecting and editing the same network interface each time on each host to add logical networks with different VLAN tags to a single network interface.
