# Managing Gluster Sync

The Gluster Sync feature periodically fetches the latest cluster configuration from GlusterFS and syncs the same with the engine DB. This process can be performed through the Manager. When a cluster is selected, the user is provided with the option to import hosts or detach existing hosts from the selected cluster. You can perform Gluster Sync if there is a host in the cluster.

**Note:** The Manager continuously monitors if hosts are added to or removed from the storage cluster. If the addition or removal of a host is detected, an action item is shown in the **General** tab for the cluster, where you can either to choose to **Import** the host into or **Detach** the host from the cluster.
