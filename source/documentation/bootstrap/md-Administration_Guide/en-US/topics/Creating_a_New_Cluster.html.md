# Creating a New Cluster

A data center can contain multiple clusters, and a cluster can contain multiple hosts. All hosts in a cluster must be of the same CPU type (Intel or AMD). It is recommended that you create your hosts before you create your cluster to ensure CPU type optimization. However, you can configure the hosts at a later time using the **Guide Me** button.

**Creating a New Cluster**

1. Select the **Clusters** resource tab.

2. Click **New**.

3. Select the **Data Center** the cluster will belong to from the drop-down list.

4. Enter the **Name** and **Description** of the cluster.

5. Select a network from the **Management Network** drop-down list to assign the management network role.

6. Select the **CPU Architecture** and **CPU Type** from the drop-down lists. It is important to match the CPU processor family with the minimum CPU processor type of the hosts you intend to attach to the cluster, otherwise the host will be non-operational.

    **Note:** For both Intel and AMD CPU types, the listed CPU models are in logical order from the oldest to the newest. If your cluster includes hosts with different CPU models, select the oldest CPU model. For more information on each CPU model, see [https://access.redhat.com/solutions/634853](https://access.redhat.com/solutions/634853).

7. Select the **Compatibility Version** of the cluster from the drop-down list.

8. Select either the **Enable Virt Service** or **Enable Gluster Service** radio button to define whether the cluster will be populated with virtual machine hosts or with Gluster-enabled nodes. Note that you cannot add Red Hat Virtualization Host (RHVH) to a Gluster-enabled cluster.

9. Optionally select the **Enable to set VM maintenance reason** check box to enable an optional reason field when a virtual machine is shut down from the Manager, allowing the administrator to provide an explanation for the maintenance.

10. Optionally select the **Enable to set Host maintenance reason** check box to enable an optional reason field when a host is placed into maintenance mode from the Manager, allowing the administrator to provide an explanation for the maintenance.

11. Select either the **/dev/random source** (Linux-provided device) or **/dev/hwrng source** (external hardware device) check box to specify the random number generator device that all hosts in the cluster will use.

12. Click the **Optimization** tab to select the memory page sharing threshold for the cluster, and optionally enable CPU thread handling and memory ballooning on the hosts in the cluster.

13. Click the **Migration Policy** tab to define the virtual machine migration policy for the cluster.

14. Click the **Scheduling Policy** tab to optionally configure a scheduling policy, configure scheduler optimization settings, enable trusted service for hosts in the cluster, enable HA Reservation, and add a custom serial number policy.

15. Click the **Console** tab to optionally override the global SPICE proxy, if any, and specify the address of a SPICE proxy for hosts in the cluster.

16. Click the **Fencing policy** tab to enable or disable fencing in the cluster, and select fencing options.

17. Click **OK** to create the cluster and open the **New Cluster - Guide Me** window.

18. The **Guide Me** window lists the entities that need to be configured for the cluster. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the cluster and clicking the **Guide Me** button.

The new cluster is added to the virtualization environment.
