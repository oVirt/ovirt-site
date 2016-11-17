# Enabling Gluster Processes on Red Hat Gluster Storage Nodes

1. In the Navigation Pane, select the **Clusters** tab.

2. Select **New**.

3. Select the "Enable Gluster Service" radio button. Provide the address, SSH fingerprint, and password as necessary. The address and password fields can be filled in only when the **Import existing Gluster configuration** check box is selected.

    **Selecting the "Enable Gluster Service" Radio Button**

    ![Description](images/6560.png)

4. Click **OK**.

It is now possible to add Red Hat Gluster Storage nodes to the Gluster cluster, and to mount Gluster volumes as storage domains. iptables rules no longer block storage domains from being added to the cluster.
