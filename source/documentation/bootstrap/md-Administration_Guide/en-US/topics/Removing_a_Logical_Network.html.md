# Removing a Logical Network

You can remove a logical network from the **Networks** resource tab or the **Data Centers** resource tab. The following procedure shows you how to remove logical networks associated to a data center. For a working Red Hat Virtualization environment, you must have at least one logical network used as the `ovirtmgmt` management network.

**Removing Logical Networks**

1. Click the **Data Centers** resource tab, and select the data center of the logical network in the results list.

2. Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.

3. Select a logical network and click **Remove** to open the **Remove Logical Network(s)** window.

4. Optionally, select the **Remove external network(s) from the provider(s) as well** check box to remove the logical network both from the Manager and from the external provider if the network is provided by an external provider. The check box is grayed out if the external provider is in read-only mode.

5. Click **OK**.

The logical network is removed from the Manager and is no longer available.

