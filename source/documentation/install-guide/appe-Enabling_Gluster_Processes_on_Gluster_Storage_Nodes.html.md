---
title: Enabling Gluster Processes on Gluster Storage Nodes
---

# Appendix C: Enabling Gluster Processes on Gluster Storage Nodes

1. In the Navigation Pane, select the **Clusters** tab.

2. Select **New**.

3. Select the "Enable Gluster Service" radio button. Provide the address, SSH fingerprint, and password as necessary. The address and password fields can be filled in only when the **Import existing Gluster configuration** check box is selected.

    **Selecting the "Enable Gluster Service" Radio Button**

    ![Description](/images/install-guide/6560.png)

4. Click **OK**.

It is now possible to add Gluster Storage nodes to the Gluster cluster, and to mount Gluster volumes as storage domains. iptables rules no longer block storage domains from being added to the cluster.

**Prev:** [Appendix B: Attaching the Local ISO Domain to a Data Center](../appe-Attaching_the_Local_ISO_Domain_to_a_Data_Center) <br>
**Next:** [Appendix D: Preparing a Remote PostgreSQL Database for Use with the oVirt Engine](../appe-Preparing_a_Remote_PostgreSQL_Database_for_Use_with_the_oVirt_Engine)
