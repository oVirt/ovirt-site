# Manually Migrating Virtual Machines

A running virtual machine can be live migrated to any host within its designated host cluster. Live migration of virtual machines does not cause any service interruption. Migrating virtual machines to a different host is especially useful if the load on a particular host is too high. For live migration prerequisites, see [Live migration prerequisites](Live_migration_prerequisites).

**Note:** When you place a host into maintenance mode, the virtual machines running on that host are automatically migrated to other hosts in the same cluster. You do not need to manually migrate these virtual machines.

**Note:** Live migrating virtual machines between different clusters is generally not recommended. The currently only supported use case is documented at [https://access.redhat.com/articles/1390733](https://access.redhat.com/articles/1390733).

**Manually Migrating Virtual Machines**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Migrate**.

3. Use the radio buttons to select whether to **Select Host Automatically** or to **Select Destination Host**, specifying the host using the drop-down list.

    **Note:** When the **Select Host Automatically** option is selected, the system determines the host to which the virtual machine is migrated according to the load balancing and power management rules set up in the scheduling policy.

4. Click **OK**.

During migration, progress is shown in the **Migration** progress bar. Once migration is complete the **Host** column will update to display the host the virtual machine has been migrated to.
