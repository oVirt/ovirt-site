---
title: Enabling Gluster Processes on Gluster Storage Nodes
---

# Appendix C: Enabling Gluster Processes on Gluster Storage Nodes

1. Click **Compute** &rarr; **Clusters**.

2. Click **New**.

3. Click the **General** tab and select the **Enable Gluster Service** check box. Enter the address, SSH fingerprint, and password as necessary. The address and password fields can be filled in only when the **Import existing Gluster configuration** check box is selected.

4. Click **OK**.

It is now possible to add Gluster Storage nodes to the Gluster cluster, and to mount Gluster volumes as storage domains. `iptables` rules no longer block storage domains from being added to the cluster.

**Prev:** [Appendix B: Attaching the Local ISO Domain to a Data Center](../appe-Attaching_the_Local_ISO_Domain_to_a_Data_Center) <br>
**Next:** [Appendix D: Preparing a Remote PostgreSQL Database](../appe-Preparing_a_Remote_PostgreSQL_Database)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-enabling_gluster_processes_on_red_hat_gluster_storage_nodes)
