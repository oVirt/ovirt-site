# Editing Host Network Interfaces and Assigning Logical Networks to Hosts

You can change the settings of physical host network interfaces, move the management network from one physical host network interface to another, and assign logical networks to physical host network interfaces. Bridge and ethtool custom properties are also supported.

**Important:** You cannot assign logical networks offered by external providers to physical host network interfaces; such networks are dynamically assigned to hosts as they are required by virtual machines.

**Editing Host Network Interfaces and Assigning Logical Networks to Hosts**

1. Click the **Hosts** resource tab, and select the desired host.

2. Click the **Network Interfaces** tab in the details pane.

3. Click the **Setup Host Networks** button to open the **Setup Host Networks** window.

4. Attach a logical network to a physical host network interface by selecting and dragging the logical network into the **Assigned Logical Networks** area next to the physical host network interface.

    Alternatively, right-click the logical network and select a network interface from the drop-down menu.

5. Configure the logical network:

    1. Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.

    2. Select a **Boot Protocol** from **None**, **DHCP**, or **Static**. If you selected **Static**, enter the **IP**, **Netmask / Routing Prefix**, and the **Gateway**.

        **Note:** Each logical network can have a separate gateway defined from the management network gateway. This ensures traffic that arrives on the logical network will be forwarded using the logical network's gateway instead of the default gateway used by the management network.

    3. To override the default host network quality of service, select **Override QoS** and enter the desired values in the following fields:

        * **Weighted Share**: Signifies how much of the logical link's capacity a specific network should be allocated, relative to the other networks attached to the same logical link. The exact share depends on the sum of shares of all networks on that link. By default this is a number in the range 1-100.
        * **Rate Limit [Mbps]**: The maximum bandwidth to be used by a network.
        * **Committed Rate [Mbps]**: The minimum bandwidth required by a network. The Committed Rate requested is not guaranteed and will vary depending on the network infrastructure and the Committed Rate requested by other networks on the same logical link.

        For more information on configuring host network quality of service see [Host Network Quality of Service](sect-Host_Network_Quality_of_Service)

    4. To configure a network bridge, click the **Custom Properties** tab and select **bridge_opts** from the drop-down list. Enter a valid key and value with the following syntax: `key=value`. Separate multiple entries with a whitespace character. The following keys are valid, with the values provided as examples. For more information on these parameters, see [Explanation of bridge opts Parameters](Explanation_of_bridge_opts_Parameters).

            forward_delay=1500
            gc_timer=3765
            group_addr=1:80:c2:0:0:0
            group_fwd_mask=0x0
            hash_elasticity=4
            hash_max=512
            hello_time=200
            hello_timer=70
            max_age=2000
            multicast_last_member_count=2
            multicast_last_member_interval=100
            multicast_membership_interval=26000
            multicast_querier=0
            multicast_querier_interval=25500
            multicast_query_interval=13000
            multicast_query_response_interval=1000
            multicast_query_use_ifaddr=0
            multicast_router=1
            multicast_snooping=1
            multicast_startup_query_count=2
            multicast_startup_query_interval=3125

    5. To configure ethtool properties, click the **Custom Properties** tab and select **ethtool_opts** from the drop-down list. Enter a valid key and value with the following syntax: `key=value`. Separate multiple entries with a whitespace character. The **ethtool_opts** option is not available by default; you need to add it using the engine configuration tool. See [How to Set Up Red Hat Enterprise Virtualization Manager to Use Ethtool](How_to_Set_Up_Red_Hat_Enterprise_Virtualization_Manager_to_Use_Ethtool) for more information. See the manual page for more information on ethtool properties.

    6. To configure Fibre Channel over Ethernet (FCoE), click the **Custom Properties** tab and select **fcoe** from the drop-down list. Enter a valid key and value with the following syntax: `key=value`. At least `enable=yes` is required. You can also add `dcb=[yes|no]` and `auto_vlan=[yes|no]`. Separate multiple entries with a whitespace character. The **fcoe** option is not available by default; you need to add it using the engine configuration tool. See [How to Set Up RHVM to Use FCoE](How_to_Set_Up_RHVM_to_Use_FCoE) for more information.

        **Note:** A separate, dedicated logical network is recommended for use with FCoE.

    7. If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box. A logical network cannot be edited or moved to another interface until it is synchronized.

        **Note:** Networks are not considered synchronized if they have one of the following conditions:

        * The **VM Network** is different from the physical host network.

        * The VLAN identifier is different from the physical host network.

        * A **Custom** **MTU** is set on the logical network, and is different from the physical host network.

6. Select the **Verify connectivity between Host and Engine** check box to check network connectivity; this action will only work if the host is in maintenance mode.

7. Select the **Save network configuration** check box to make the changes persistent when the environment is rebooted.

8. Click **OK**.

**Note:** If not all network interface cards for the host are displayed, click the **Refresh Capabilities** button to update the list of network interface cards available for that host.
