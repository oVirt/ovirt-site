# Introduction to Quota

Quota is a resource limitation tool provided with Red Hat Virtualization. Quota may be thought of as a layer of limitations on top of the layer of limitations set by User Permissions.

Quota is a data center object.

Quota allows administrators of Red Hat Virtualization environments to limit user access to memory, CPU, and storage. Quota defines the memory resources and storage resources an administrator can assign users. As a result users may draw on only the resources assigned to them. When the quota resources are exhausted, Red Hat Virtualization does not permit further user actions.

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

If starting a virtual machine causes the aggregated resources of all running virtual machines covered by a quota to exceed the allowance defined in the quota, then the Manager refuses to run the virtual machine.

When a user creates a new disk, the requested disk size is added to the aggregated disk usage of all the other disks covered by the applicable quota. If the new disk takes the total aggregated disk usage above the amount allowed by the quota, disk creation fails.

Quota allows for resource sharing of the same hardware. It supports hard and soft thresholds. Administrators can use a quota to set thresholds on resources. These thresholds appear, from the user's point of view, as 100% usage of that resource. To prevent failures when the customer unexpectedly exceeds this threshold, the interface supports a "grace" amount by which the threshold can be briefly exceeded. Exceeding the threshold results in a warning sent to the customer.

**Important:** Quota imposes limitations upon the running of virtual machines. Ignoring these limitations is likely to result in a situation in which you cannot use your virtual machines and virtual disks.

When quota is running in enforced mode, virtual machines and disks that do not have quotas assigned cannot be used.

To power on a virtual machine, a quota must be assigned to that virtual machine.

To create a snapshot of a virtual machine, the disk associated with the virtual machine must have a quota assigned.

When creating a template from a virtual machine, you are prompted to select the quota that you want the template to consume. This allows you to set the template (and all future machines created from the template) to consume a different quota than the virtual machine and disk from which the template is generated.
