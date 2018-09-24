---
title: Quotas and Service Level Agreement Policy
---

# Chapter 16: Quotas and Service Level Agreement Policy

## Introduction to Quota

Quota is a resource limitation tool provided with oVirt. Quota may be thought of as a layer of limitations on top of the layer of limitations set by User Permissions.

Quota is a data center object.

Quota allows administrators of oVirt environments to limit user access to memory, CPU, and storage. Quota defines the memory resources and storage resources an administrator can assign users. As a result users may draw on only the resources assigned to them. When the quota resources are exhausted, oVirt does not permit further user actions.

There are two different kinds of Quota:

**The Two Different Kinds of Quota**

| Quota type | Definition |
|-
| Run-time Quota | This quota limits the consumption of runtime resources, like CPU and memory. |
| Storage Quota | This quota limits the amount of storage available. |

Quota, like SELinux, has three modes:

**Quota Modes**

| Quota Mode | Function |
|-
| Enforced | This mode puts into effect the Quota that you have set in audit mode, limiting resources to the group or user affected by the quota. |
| Audit | This mode allows you to change Quota settings. Choose this mode to increase or decrease the amount of runtime quota and the amount of storage quota available to users affected by it. |
| Disabled | This mode turns off the runtime and storage limitations defined by the quota. |

When a user attempts to run a virtual machine, the specifications of the virtual machine are compared to the storage allowance and the runtime allowance set in the applicable quota.

If starting a virtual machine causes the aggregated resources of all running virtual machines covered by a quota to exceed the allowance defined in the quota, then the Engine refuses to run the virtual machine.

When a user creates a new disk, the requested disk size is added to the aggregated disk usage of all the other disks covered by the applicable quota. If the new disk takes the total aggregated disk usage above the amount allowed by the quota, disk creation fails.

Quota allows for resource sharing of the same hardware. It supports hard and soft thresholds. Administrators can use a quota to set thresholds on resources. These thresholds appear, from the user's point of view, as 100% usage of that resource. To prevent failures when the customer unexpectedly exceeds this threshold, the interface supports a "grace" amount by which the threshold can be briefly exceeded. Exceeding the threshold results in a warning sent to the customer.

    **Important:** Quota imposes limitations upon the running of virtual machines. Ignoring these limitations is likely to result in a situation in which you cannot use your virtual machines and virtual disks.

    When quota is running in enforced mode, virtual machines and disks that do not have quotas assigned cannot be used.

    To power on a virtual machine, a quota must be assigned to that virtual machine.

    To create a snapshot of a virtual machine, the disk associated with the virtual machine must have a quota assigned.

    When creating a template from a virtual machine, you are prompted to select the quota that you want the template to consume. This allows you to set the template (and all future machines created from the template) to consume a different quota than the virtual machine and disk from which the template is generated.

## Shared Quota and Individually Defined Quota

Users with SuperUser permissions can create quotas for individual users or quotas for groups.

Group quotas can be set for Active Directory users. If a group of ten users are given a quota of 1 TB of storage and one of the ten users fills the entire terabyte, then the entire group will be in excess of the quota and none of the ten users will be able to use any of the storage associated with their group.

An individual user's quota is set for only the individual. Once the individual user has used up all of his or her storage or runtime quota, the user will be in excess of the quota and the user will no longer be able to use the storage associated with his or her quota.

## Quota Accounting

When a quota is assigned to a consumer or a resource, each action by that consumer or on the resource involving storage, vCPU, or memory results in quota consumption or quota release.

Since the quota acts as an upper bound that limits the user's access to resources, the quota calculations may differ from the actual current use of the user. The quota is calculated for the max growth potential and not the current usage.

**Accounting example**

A user runs a virtual machine with 1 vCPU and 1024 MB memory. The action consumes 1 vCPU and 1024 MB of the quota assigned to that user. When the virtual machine is stopped 1 vCPU and 1024 MB of RAM are released back to the quota assigned to that user. Run-time quota consumption is accounted for only during the actual run-time of the consumer.

A user creates a virtual thin provision disk of 10 GB. The actual disk usage may indicate only 3 GB of that disk are actually in use. The quota consumption, however, would be 10 GB, the max growth potential of that disk.

## Enabling and Changing a Quota Mode in a Data Center

This procedure enables or changes the quota mode in a data center. You must select a quota mode before you can define quotas. You must be logged in to the Administration Portal to follow the steps of this procedure.

Use **Audit** mode to test your quota to make sure it works as you expect it to. You do not need to have your quota in **Audit** mode to create or change a quota.

**Enabling and Changing Quota in a Data Center**

1. Click **Compute** &rarr; **Data Centers** and select a data center.

2. Click **Edit**.

3. In the **Quota Mode** drop-down list, change the quota mode to **Enforced**.

4. Click **OK**.

If you set the quota mode to **Audit** during testing, then you must change it to **Enforced** in order for the quota settings to take effect.

## Creating a New Quota Policy

You have enabled quota mode, either in Audit or Enforcing mode. You want to define a quota policy to manage resource usage in your data center.

**Creating a New Quota Policy**

1. Click **Administration** &rarr; **Quota**.

2. Click **Add**.

3. Fill in the **Name** and **Description** fields.

4. Select a **Data Center**.

5. In the **Memory & CPU** section, use the green slider to set **Cluster Threshold**.

6. In the **Memory & CPU** section, use the blue slider to set **Cluster Grace**.

7. Click the **All Clusters** or the **Specific Clusters** radio button. If you select **Specific Clusters**, select the check box of the clusters that you want to add a quota policy to.

8. Click **Edit** to open the **Edit Quota** window.

    i. Under the **Memory** field, select either the **Unlimited** radio button (to allow limitless use of Memory resources in the cluster), or select the **limit to** radio button to set the amount of memory set by this quota. If you select the **limit to** radio button, input a memory quota in megabytes (MB) in the **MB** field.

    ii. Under the **CPU** field, select either the **Unlimited** radio button or the **limit to** radio button to set the amount of CPU set by this quota. If you select the **limit to** radio button, input a number of vCPUs in the **vCpus** field.

    iii. Click **OK** in the **Edit Quota** window.

9. In the **Storage** section, use the green slider to set **Storage Threshold**.

10. In the **Storage** section, use the blue slider to set **Storage Grace**.

11. Click the **All Storage Domains** or the **Specific Storage Domains** radio button. If you select **Specific Storage Domains**, select the check box of the storage domains that you want to add a quota policy to.

12. Click **Edit** to open the **Edit Quota** window.

    i. Under the **Storage Quota** field, select either the **Unlimited** radio button (to allow limitless use of Storage) or the **limit to** radio button to set the amount of storage to which quota will limit users. If you select the **limit to** radio button, input a storage quota size in gigabytes (GB) in the **GB** field.

    ii. Click **OK** in the **Edit Quota** window.

13. Click **OK** in the **New Quota** window.

## Explanation of Quota Threshold Settings

**Quota thresholds and grace**

| Setting | Definition |
|-
| Cluster Threshold | The amount of cluster resources available per data center. |
| Cluster Grace | The amount of the cluster available for the data center after exhausting the data center's Cluster Threshold. |
| Storage Threshold | The amount of storage resources available per data center. |
| Storage Grace | The amount of storage available for the data center after exhausting the data center's Storage Threshold. |

If a quota is set to 100 GB with 20% Grace, then consumers are blocked from using storage after they use 120 GB of storage. If the same quota has a Threshold set at 70%, then consumers receive a warning when they exceed 70 GB of storage consumption (but they remain able to consume storage until they reach 120 GB of storage consumption.) Both "Threshold" and "Grace" are set relative to the quota. "Threshold" may be thought of as the "soft limit", and exceeding it generates a warning. "Grace" may be thought of as the "hard limit", and exceeding it makes it impossible to consume any more storage resources.

## Assigning a Quota to an Object

**Assigning a Quota to a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Select the quota you want the virtual machine to consume from the **Quota** drop-down list.

4. Click **OK**.

**Assigning a Quota to a Virtual Disk**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine’s name to open the details view.

3. Click the **Disks** tab and select the disk you plan to associate with a quota.

4. Click **Edit**.

5. Select the quota you want the virtual disk to consume from the **Quota** drop-down list.

6. Click **OK**.

    **Important:** Quota must be selected for all objects associated with a virtual machine, in order for that virtual machine to work. If you fail to select a quota for the objects associated with a virtual machine, the virtual machine will not work. The error that the Engine throws in this situation is generic, which makes it difficult to know if the error was thrown because you did not associate a quota with all of the objects associated with the virtual machine. It is not possible to take snapshots of virtual machines that do not have an assigned quota. It is not possible to create templates of virtual machines whose virtual disks do not have assigned quotas.

## Using Quota to Limit Resources by User

This procedure describes how to use quotas to limit the resources a user has access to.

**Assigning a User to a Quota**

1. Click **Administration** &rarr; **Quota**.

2. Click the name of the target quota to open the details view.

3. Click the **Consumers** tab.

4. Click **Add**.

5. In the **Search** field, type the name of the user you want to associate with the quota.

6. Click **GO**.

7. Select the check box next to the user’s name.

8. Click **OK**.

After a short time, the user will appear in the **Consumers** tab in the details view.

## Editing Quotas

This procedure describes how to change existing quotas.

**Editing Quotas**

1. Click **Administration** &rarr; **Quota** and select a quota.

2. Click **Edit**.

3. Edit the fields as required.

4. Click **OK**.

## Removing Quotas

This procedure describes how to remove quotas.

**Removing Quotas**

1. Click **Administration** &rarr; **Quota** and select a quota.

2. Click **Remove**.

3. Click **OK**.

## Service Level Agreement Policy Enforcement

This procedure describes how to set service level agreement CPU features.

**Setting a Service Level Agreement CPU Policy**

1. Click **Compute** &rarr; **Virtual Machines**

2. Click **New**, or select a virtual machine and click **Edit**.

3. Click the **Resource Allocation** tab.

4. Specify **CPU Shares**. Possible options are **Low**, **Medium**, **High**, **Custom**, and **Disabled**. Virtual machines set to **High** receive twice as many shares as **Medium**, and virtual machines set to **Medium** receive twice as many shares as virtual machines set to **Low**. **Disabled** instructs VDSM to use an older algorithm for determining share dispensation; usually the number of shares dispensed under these conditions is 1020.

The CPU consumption of users is now governed by the policy you have set.

**Prev:** [Chapter 15: Users and Roles](../chap-Users_and_Roles)<br>
**Next:** [Chapter 17: Event Notifications](../chap-Event_Notifications)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-quotas_and_service_level_agreement_policy)
