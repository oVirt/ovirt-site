# Optimizing Live Migration

Live virtual machine migration can be a resource-intensive operation. The following two options can be set globally for every virtual machine in the environment, at the cluster level, or at the individual virtual machine level to optimize live migration.

The **Auto Converge migrations** option allows you to set whether auto-convergence is used during live migration of virtual machines. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine.

The **Enable migration compression** option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern.

Both options are disabled globally by default.

**Configuring Auto-convergence and Migration Compression for Virtual Machine Migration**

1. Configure the optimization settings at the global level:

    1. Enable auto-convergence at the global level:

            # engine-config -s DefaultAutoConvergence=True

    2. Enable migration compression at the global level:

            # engine-config -s DefaultMigrationCompression=True

    3. Restart the `ovirt-engine` service to apply the changes:

            # systemctl restart ovirt-engine.service

2. Configure the optimization settings at the cluster level:

    1. Select a cluster.

    2. Click **Edit**.

    3. Click the **Scheduling Policy** tab.

    4. From the **Auto Converge migrations** list, select **Inherit from global setting**, **Auto Converge**, or **Don't Auto Converge**.

    5. From the **Enable migration compression** list, select **Inherit from global setting**, **Compress**, or **Don't Compress**.

3. Configure the optimization settings at the virtual machine level:

    1. Select a virtual machine.

    2. Click **Edit**.

    3. Click the **Host** tab.

    4. From the **Auto Converge migrations** list, select **Inherit from cluster setting**, **Auto Converge**, or **Don't Auto Converge**.

    5. From the **Enable migration compression** list, select **Inherit from cluster setting**, **Compress**, or **Don't Compress**.
