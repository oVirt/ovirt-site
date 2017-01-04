# Moving a Host to Maintenance Mode

Many common maintenance tasks, including network configuration and deployment of software updates, require that hosts be placed into maintenance mode. Hosts should be placed into maintenance mode before any event that might cause VDSM to stop working properly, such as a reboot, or issues with networking or storage.

When a host is placed into maintenance mode the Red Hat Virtualization Manager attempts to migrate all running virtual machines to alternative hosts. The standard prerequisites for live migration apply, in particular there must be at least one active host in the cluster with capacity to run the migrated virtual machines.

**Placing a Host into Maintenance Mode**

1. Click the **Hosts** resource tab, and select the desired host.

2. Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.

3. Optionally, enter a **Reason** for moving the host into maintenance mode in the **Maintenance Host(s)** confirmation window. This allows you to provide an explanation for the maintenance, which will appear in the logs and when the host is activated again.

    **Note:** The host maintenance **Reason** field will only appear if it has been enabled in the cluster settings. See [Cluster properties](Cluster_properties) for more information.

4. Click **OK** to initiate maintenance mode.

All running virtual machines are migrated to alternative hosts. If the host is the Storage Pool Manager (SPM), the SPM role is migrated to another host. The **Status** field of the host changes to `Preparing for Maintenance`, and finally `Maintenance` when the operation completes successfully. VDSM does not stop while the host is in maintenance mode.

**Note:** If migration fails on any virtual machine, click **Activate** on the host to stop the operation placing it into maintenance mode, then click **Cancel Migration** on the virtual machine to stop the migration.

