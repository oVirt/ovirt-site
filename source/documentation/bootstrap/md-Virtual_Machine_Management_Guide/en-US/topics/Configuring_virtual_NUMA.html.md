# Configuring Virtual NUMA

In the Administration Portal, you can configure virtual NUMA nodes on a virtual machine and pin them to physical NUMA nodes on a host. The host’s default policy is to schedule and run virtual machines on any available resources on the host. As a result, the resources backing a large virtual machine that cannot fit within a single host socket could be spread out across multiple NUMA nodes, and over time may be moved around, leading to poor and unpredictable performance. Configure and pin virtual NUMA nodes to avoid this outcome and improve performance.

Configuring virtual NUMA requires a NUMA-enabled host. To confirm whether NUMA is enabled on a host, log in to the host and run `numactl --hardware`. The output of this command should show at least two NUMA nodes. You can also view the host's NUMA topology in the Administration Portal by selecting the host from the **Hosts** tab and clicking **NUMA Support**. This button is only available when the selected host has at least two NUMA nodes.

**Configuring Virtual NUMA**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific** radio button and select a host from the list. The selected host must have at least two NUMA nodes.

5. Select **Do not allow migration** from the **Migration Options** drop-down list.

6. Enter a number into the **NUMA Node Count** field to assign virtual NUMA nodes to the virtual machine.

7. Select **Strict**, **Preferred**, or **Interleave** from the **Tune Mode** drop-down list. If the selected mode is **Preferred**, the **NUMA Node Count** must be set to `1`.

8. Click **NUMA Pinning**. 

    **The NUMA Topology Window**

    ![](images/numa.png)

9. In the **NUMA Topology** window, click and drag virtual NUMA nodes from the box on the right to host NUMA nodes on the left as required, and click **OK**.

10. Click **OK**.

**Note:** Automatic NUMA balancing is available in Red Hat Enterprise Linux 7, but is not currently configurable through the Red Hat Virtualization Manager.
