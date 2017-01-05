# Configuring iSCSI Multipathing

The **iSCSI Multipathing** enables you to create and manage groups of logical networks and iSCSI storage connections. To prevent host downtime due to network path failure, configure multiple network paths between hosts and iSCSI storage. Once configured, the Manager connects each host in the data center to each bonded target via NICs/VLANs related to logical networks of the same iSCSI Bond. You can also specify which networks to use for storage traffic, instead of allowing hosts to route traffic through a default network. This option is only available in the Administration Portal after at least one iSCSI storage domain has been attached to a data center.  

**Prerequisites**

* Ensure you have created an iSCSI storage domain and discovered and logged into all the paths to the iSCSI target(s).

* Ensure you have created **Non-Required** logical networks to bond with the iSCSI storage connections. You can configure multiple logical networks or bond networks to allow network failover.

**Configuring iSCSI Multipathing**

1. Click the **Data Centers** tab and select a data center from the results list.

2. In the details pane, click the **iSCSI Multipathing** tab.

3. Click **Add**.

4. In the **Add iSCSI Bond** window, enter a **Name** and a **Description** for the bond.

5. Select the networks to be used for the bond from the **Logical Networks** list. The networks must be **Non-Required** networks.

    **Note:** To change a network's **Required** designation, from the Administration Portal, select a network, click the **Cluster** tab, and click the **Manage Networks** button.

6. Select the storage domain to be accessed via the chosen networks from the **Storage Targets** list. Ensure to select all paths to the same target.

7. Click **OK**.

All hosts in the data center are connected to the selected iSCSI target through the selected logical networks.
