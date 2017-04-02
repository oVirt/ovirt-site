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

1. Click the **Data Centers** tab in the Navigation Pane.

2. From the list of data centers displayed in the Navigation Pane, choose the data center whose quota policy you plan to edit.

3. Click **Edit** in the top left of the Navigation Pane.

    An **Edit Data Center** window opens.

4. In the **Quota Mode** drop-down, change the quota mode to **Enforced**.

5. Click **OK**.

You have now enabled a quota mode at the Data Center level. If you set the quota mode to **Audit** during testing, then you must change it to **Enforced** in order for the quota settings to take effect.

## Creating a New Quota Policy

You have enabled quota mode, either in Audit or Enforcing mode. You want to define a quota policy to manage resource usage in your data center.

**Creating a New Quota Policy**

1. In tree mode, select the data center. The **Quota** tab appears in the Navigation Pane.

2. Click the **Quota** tab in the Navigation Pane.

3. Click **Add** in the Navigation Pane. The **New Quota** window opens.

4. Fill in the **Name** field with a meaningful name.

    Fill in the **Description** field with a meaningful name.

5. In the **Memory & CPU** section of the **New Quota** window, use the green slider to set **Cluster Threshold**.

6. In the **Memory & CPU** section of the **New Quota** window, use the blue slider to set **Cluster Grace**.

7. Select the **All Clusters** or the **Specific Clusters** radio button. If you select **Specific Clusters**, select the check box of the clusters that you want to add a quota policy to.

8. Click **Edit** to open the **Edit Quota** window.

9. Under the **Memory** field, select either the **Unlimited** radio button (to allow limitless use of Memory resources in the cluster), or select the **limit to** radio button to set the amount of memory set by this quota. If you select the **limit to** radio button, input a memory quota in megabytes (MB) in the **MB** field.

10. Under the **CPU** field, select either the **Unlimited** radio button or the **limit to** radio button to set the amount of CPU set by this quota. If you select the **limit to** radio button, input a number of vCPUs in the **vCpus** field.

11. Click **OK** in the **Edit Quota** window.

12. In the **Storage** section of the **New Quota** window, use the green slider to set **Storage Threshold**.

13. In the **Storage** section of the **New Quota** window, use the blue slider to set **Storage Grace**.

14. Select the **All Storage Domains** or the **Specific Storage Domains** radio button. If you select **Specific Storage Domains**, select the check box of the storage domains that you want to add a quota policy to.

15. Click **Edit** to open the **Edit Quota** window.

16. Under the **Storage Quota** field, select either the **Unlimited** radio button (to allow limitless use of Storage) or the **limit to** radio button to set the amount of storage to which quota will limit users. If you select the **limit to** radio button, input a storage quota size in gigabytes (GB) in the **GB** field.

17. Click **OK** in the **Edit Quota** window. You are returned to the **New Quota** window.

18. Click **OK** in the **New Quota** window.

**Result**

You have created a new quota policy.

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

**Summary**

This procedure explains how to associate a virtual machine with a quota.

**Assigning a Quota to a Virtual Machine**

1. In the navigation pane, select the Virtual Machine to which you plan to add a quota.

2. Click **Edit**. The **Edit Virtual Machine** window appears.

3. Select the quota you want the virtual machine to consume. Use the **Quota** drop-down to do this.

4. Click **OK**.

**Result**

You have designated a quota for the virtual machine you selected.

**Summary**

This procedure explains how to associate a virtual machine disk with a quota.

**Assigning a Quota to a Virtual Disk**

1. In the navigation pane, select the Virtual Machine whose disk(s) you plan to add a quota.

2. In the details pane, select the disk you plan to associate with a quota.

3. Click **Edit**. The **Edit Virtual Disk** window appears.

4. Select the quota you want the virtual disk to consume.

5. Click **OK**.

**Result**

You have designated a quota for the virtual disk you selected.

**Important:** Quota must be selected for all objects associated with a virtual machine, in order for that virtual machine to work. If you fail to select a quota for the objects associated with a virtual machine, the virtual machine will not work. The error that the Engine throws in this situation is generic, which makes it difficult to know if the error was thrown because you did not associate a quota with all of the objects associated with the virtual machine. It is not possible to take snapshots of virtual machines that do not have an assigned quota. It is not possible to create templates of virtual machines whose virtual disks do not have assigned quotas.

## Using Quota to Limit Resources by User

**Summary**

This procedure describes how to use quotas to limit the resources a user has access to.

**Assigning a User to a Quota**

1. In the tree, click the Data Center with the quota you want to associate with a User.

2. Click the **Quota** tab in the navigation pane.

3. Select the target quota in the list in the navigation pane.

4. Click the **Consumers** tab in the details pane.

5. Click **Add** at the top of the details pane.

6. In the **Search** field, type the name of the user you want to associate with the quota.

7. Click **GO**.

8. Select the check box at the left side of the row containing the name of the target user.

9. Click **OK** in the bottom right of the **Assign Users and Groups to Quota** window.

**Result**

After a short time, the user will appear in the **Consumers** tab of the details pane.

## Editing Quotas

**Summary**

This procedure describes how to change existing quotas.

**Editing Quotas**

1. On the tree pane, click on the data center whose quota you want to edit.

2. Click on the **Quota** tab in the Navigation Pane.

3. Click the name of the quota you want to edit.

4. Click **Edit** in the Navigation pane.

5. An **Edit Quota** window opens. If required, enter a meaningful name in the **Name** field.

6. If required, you can enter a meaningful description in the **Description** field.

7. Select either the **All Clusters** radio button or the **Specific Clusters** radio button. Move the **Cluster Threshold** and **Cluster Grace** sliders to the desired positions on the **Memory & CPU** slider.

8. Select either the **All Storage Domains** radio button or the **Specific Storage Domains** radio button. Move the **Storage Threshold** and **Storage Grace** sliders to the desired positions on the **Storage** slider.

9. Click **OK** in the **Edit Quota** window to confirm the new quota settings.

**Result**

You have changed an existing quota.

## Removing Quotas

**Summary**

This procedure describes how to remove quotas.

**Removing Quotas**

1. On the tree pane, click on the data center whose quota you want to edit.

2. Click on the **Quota** tab in the Navigation Pane.

3. Click the name of the quota you want to remove.

4. Click **Remove** at the top of the Navigation pane, under the row of tabs.

5. Click **OK** in the **Remove Quota(s)** window to confirm the removal of this quota.

**Result**

You have removed a quota.

## Service Level Agreement Policy Enforcement

**Summary**

This procedure describes how to set service level agreement CPU features.

**Setting a Service Level Agreement CPU Policy**

1. Select **New VM** in the Navigation Pane.

2. Select **Show Advanced Options**.

3. Select the **Resource Allocation** tab.

    **Service Level Agreement Policy Enforcement - CPU Allocation Menu**

    ![Description](/images/admin-guide/6591.png)

4. Specify **CPU Shares**. Possible options are **Low**, **Medium**, **High**, **Custom**, and **Disabled**. Virtual machines set to **High** receive twice as many shares as **Medium**, and virtual machines set to **Medium** receive twice as many shares as virtual machines set to **Low**. **Disabled** instructs VDSM to use an older algorithm for determining share dispensation; usually the number of shares dispensed under these conditions is 1020.

**Result**

You have set a service level agreement CPU policy. The CPU consumption of users is now governed by the policy you have set.

**Prev:** [Chapter 15: Users and Roles](../chap-Users_and_Roles)<br>
**Next:** [Chapter 17: Event Notifications](../chap-Event_Notifications)
