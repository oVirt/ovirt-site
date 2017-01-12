# Creating a New Logical Network in a Data Center or Cluster

Create a logical network and define its use in a data center, or in clusters in a data center.

**Creating a New Logical Network in a Data Center or Cluster**

1. Click the **Data Centers** or **Clusters** resource tabs, and select a data center or cluster in the results list.

2. Click the **Logical Networks** tab of the details pane to list the existing logical networks.

    * From the **Data Centers** details pane, click **New** to open the **New Logical Network** window.

    * From the **Clusters** details pane, click **Add Network** to open the **New Logical Network** window.

3. Enter a **Name**, **Description**, and **Comment** for the logical network.

4. Optionally select the **Create on external provider** check box. Select the **External Provider** from the drop-down list and provide the IP address of the **Physical Network**. The **External Provider** drop-down list will not list any external providers in read-only mode.

    If **Create on external provider** is selected, the **Network Label**, **VM Network**, and **MTU** options are disabled.

5. Enter a new label or select an existing label for the logical network in the **Network Label** text field.

6. Optionally enable **Enable VLAN tagging**.

7. Optionally disable **VM Network**.

8. Set the **MTU** value to **Default (1500)** or **Custom**.

9. From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.

10. If **Create on external provider** is selected, the **Subnet** tab will be visible. From the **Subnet** tab, select the **Create subnet** and enter a **Name**, **CIDR**, and **Gateway** address, and select an **IP Version** for the subnet that the logical network will provide. You can also add DNS servers as required.

11. From the **vNIC Profiles** tab, add vNIC profiles to the logical network as required.

12. Click **OK**.

You have defined a logical network as a resource required by a cluster or clusters in the data center. If you entered a label for the logical network, it will be automatically added to all host network interfaces with that label.

**Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.
