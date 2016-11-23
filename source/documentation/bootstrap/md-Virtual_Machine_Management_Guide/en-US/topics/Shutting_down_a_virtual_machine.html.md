# Shutting Down a Virtual Machine

**Shutting Down a Virtual Machine**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click the shut down (![](images/5035.png)) button.

    Alternatively, right-click the virtual machine and select **Shutdown**.

3. Optionally in the Administration Portal, enter a **Reason** for shutting down the virtual machine in the **Shut down Virtual Machine(s)** confirmation window. This allows you to provide an explanation for the shutdown, which will appear in the logs and when the virtual machine is powered on again.

    **Note:** The virtual machine shutdown **Reason** field will only appear if it has been enabled in the cluster settings. For more information, see [Explanation of Settings and Controls in the New Cluster and Edit Cluster Windows](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#sect-Cluster_Tasks) in the *Administration Guide*.

4. Click **OK** in the **Shut down Virtual Machine(s)** confirmation window.

The virtual machine shuts down gracefully and the **Status** of the virtual machine changes to `Down`.
