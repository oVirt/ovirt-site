# Updating the MoM Policy on Hosts in a Cluster

The Memory Overcommit Manager handles memory balloon and KSM functions on a host. Changes to these functions at the cluster level are only passed to hosts the next time a host moves to a status of **Up** after being rebooted or in maintenance mode. However, if necessary you can apply important changes to a host immediately by synchronizing the MoM policy while the host is **Up**. The following procedure must be performed on each host individually.

**Synchronizing MoM Policy on a Host**

1. Click the **Clusters** tab and select the cluster to which the host belongs.

2. Click the **Hosts** tab in the details pane and select the host that requires an updated MoM policy.

3. Click **Sync MoM Policy**.

The MoM policy on the host is updated without having to move the host to maintenance mode and back **Up**.
