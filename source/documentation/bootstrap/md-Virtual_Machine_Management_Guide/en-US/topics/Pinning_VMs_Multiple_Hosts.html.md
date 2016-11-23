# Pinning a Virtual Machine to Multiple Hosts

Virtual machines can be pinned to multiple hosts. Multi-host pinning allows a virtual machine to run on a specific subset of hosts within a cluster, instead of one specific host or all hosts in the cluster. The virtual machine cannot run on any other hosts in the cluster even if all of the specified hosts are unavailable. Multi-host pinning can be used to limit virtual machines to hosts with, for example, the same physical hardware configuration. 

A virtual machine that is pinned to multiple hosts cannot be live migrated, but in the event of a host failure, any virtual machine configured to be highly available is automatically restarted on one of the other hosts to which the virtual machine is pinned.

**Note:** High availability is not supported for virtual machines that are pinned to a single host.

**Pinning Virtual Machines to Multiple Hosts**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific** radio button under **Start Running On** and select two or more hosts from the list. 

5. Select **Do not allow migration** from the **Migration Options** drop-down list. 

6. Click the **High Availability** tab.

7. Select the **Highly Available** check box.

8. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

9. Click **OK**.
