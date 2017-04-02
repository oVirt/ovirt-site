---
title: Global Configuration
---

# Chapter 1: Global Configuration

Accessed from the header bar in the Administration Portal, the **Configure** window allows you to configure a number of global resources for your oVirt environment, such as users, roles, system permissions, scheduling policies, instance types, and MAC address pools. This window allows you to customize the way in which users interact with resources in the environment, and provides a central location for configuring options that can be applied to multiple clusters.

**Accessing the Configure window**

![Accessing the Configure window](/images/admin-guide/6219.png)

## Roles

Roles are predefined sets of privileges that can be configured from oVirt Engine. Roles provide access and management permissions to different levels of resources in the data center, and to specific physical and virtual resources.

With multilevel administration, any permissions which apply to a container object also apply to all individual objects within that container. For example, when a host administrator role is assigned to a user on a specific host, the user gains permissions to perform any of the available host operations, but only on the assigned host. However, if the host administrator role is assigned to a user on a data center, the user gains permissions to perform host operations on all hosts within the cluster of the data center.

### Creating a New Role

If the role you require is not on oVirt's default list of roles, you can create a new role and customize it to suit your purposes.

**Creating a New Role**

1. On the header bar, click the **Configure** button to open the **Configure** window. The window shows a list of default User and Administrator roles, and any custom roles.

2. Click **New**. The **New Role** dialog box displays.

    **The New Role Dialog**

    ![](/images/admin-guide/7331.png)

3. Enter the **Name** and **Description** of the new role.

4. Select either **Admin** or **User** as the **Account Type**.

5. Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects in the **Check Boxes to Allow Action** list. You can also expand or collapse the options for each object.

6. For each of the objects, select or clear the actions you wish to permit or deny for the role you are setting up.

7. Click **OK** to apply the changes you have made. The new role displays on the list of roles.

### Editing or Copying a Role

You can change the settings for roles you have created, but you cannot change default roles. To change default roles, clone and modify them to suit your requirements.

**Editing or Copying a Role**

1. On the header bar, click the **Configure** button to open the **Configure** window. The window shows a list of default User and Administrator roles, and any custom roles.

2. Select the role you wish to change. Click **Edit** to open the **Edit Role** window, or click **Copy** to open the **Copy Role** window.

3. If necessary, edit the **Name** and **Description** of the role.

4. Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects. You can also expand or collapse the options for each object.

5. For each of the objects, select or clear the actions you wish to permit or deny for the role you are editing.

6. Click **OK** to apply the changes you have made.

### User Role and Authorization Examples

The following examples illustrate how to apply authorization controls for various scenarios, using the different features of the authorization system described in this chapter.

**Cluster Permissions**

Sarah is the system administrator for the accounts department of a company. All the virtual resources for her department are organized under an oVirt `cluster` called `Accounts`. She is assigned the `ClusterAdmin` role on the accounts cluster. This enables her to manage all virtual machines in the cluster, since the virtual machines are child objects of the cluster. Managing the virtual machines includes editing, adding, or removing virtual resources such as disks, and taking snapshots. It does not allow her to manage any resources outside this cluster. Because `ClusterAdmin` is an administrator role, it allows her to use the Administration Portal to manage these resources, but does not give her any access via the User Portal.

**VM PowerUser Permissions**

John is a software developer in the accounts department. He uses virtual machines to build and test his software. Sarah has created a virtual desktop called `johndesktop` for him. John is assigned the `UserVmManager` role on the `johndesktop` virtual machine. This allows him to access this single virtual machine using the User Portal. Because he has `UserVmManager` permissions, he can modify the virtual machine and add resources to it, such as new virtual disks. Because `UserVmManager` is a user role, it does not allow him to use the Administration Portal.

**Data Center Power User Role Permissions**

Penelope is an office manager. In addition to her own responsibilities, she occasionally helps the HR manager with recruitment tasks, such as scheduling interviews and following up on reference checks. As per corporate policy, Penelope needs to use a particular application for recruitment tasks.

While Penelope has her own machine for office management tasks, she wants to create a separate virtual machine to run the recruitment application. She is assigned `PowerUserRole` permissions for the data center in which her new virtual machine will reside. This is because to create a new virtual machine, she needs to make changes to several components within the data center, including creating the virtual machine disk image in the storage domain.

Note that this is not the same as assigning `DataCenterAdmin` privileges to Penelope. As a PowerUser for a data center, Penelope can log in to the User Portal and perform virtual machine-specific actions on virtual machines within the data center. She cannot perform data center-level operations such as attaching hosts or storage to a data center.

**Network Administrator Permissions**

Chris works as the network administrator in the IT department. Her day-to-day responsibilities include creating, manipulating, and removing networks in the department's oVirt environment. For her role, she requires administrative privileges on the resources and on the networks of each resource. For example, if Chris has `NetworkAdmin` privileges on the IT department's data center, she can add and remove networks in the data center, and attach and detach networks for all virtual machines belonging to the data center.

In addition to managing the networks of the company's virtualized infrastructure, Chris also has a junior network administrator reporting to her. The junior network administrator, Pat, is managing a smaller virtualized environment for the company's internal training department. Chris has assigned Pat `VnicProfileUser` permissions and `UserVmManager` permissions for the virtual machines used by the internal training department. With these permissions, Pat can perform simple administrative tasks such as adding network interfaces onto virtual machines in the **Extended** tab of the User Portal. However, he does not have permissions to alter the networks for the hosts on which the virtual machines run, or the networks on the data center to which the virtual machines belong.

**Custom Role Permissions**

Rachel works in the IT department, and is responsible for managing user accounts in oVirt. She needs permission to add user accounts and assign them the appropriate roles and permissions. She does not use any virtual machines herself, and should not have access to administration of hosts, virtual machines, clusters or data centers. There is no built-in role which provides her with this specific set of permissions. A custom role must be created to define the set of permissions appropriate to Rachel's position.

**UserManager Custom Role**

![](/images/admin-guide/6568.png)

The **UserManager** custom role shown above allows manipulation of users, permissions and roles. These actions are organized under `System` - the top level object of the hierarchy shown in [rhev-object-hierarchy](rhev-object-hierarchy). This means they apply to all other objects in the system. The role is set to have an **Account Type** of **Admin**. This means that when she is assigned this role, Rachel can only use the Administration Portal, not the User Portal.

## System Permissions

Permissions enable users to perform actions on objects, where objects are either individual objects or container objects.

**Permissions & Roles**

![](/images/admin-guide/496.png)

Any permissions that apply to a container object also apply to all members of that container. The following diagram depicts the hierarchy of objects in the system.

**oVirt Object Hierarchy**

![](/images/admin-guide/492.png)

### User Properties

Roles and permissions are the properties of the user. Roles are predefined sets of privileges that permit access to different levels of physical and virtual resources. Multilevel administration provides a finely grained hierarchy of permissions. For example, a data center administrator has permissions to manage all objects in the data center, while a host administrator has system administrator permissions to a single physical host. A user can have permissions to use a single virtual machine but not make any changes to the virtual machine configurations, while another user can be assigned system permissions to a virtual machine.

### User and Administrator Roles

oVirt provides a range of pre-configured roles, from an administrator with system-wide permissions to an end user with access to a single virtual machine. While you cannot change or remove the default roles, you can clone and customize them, or create new roles according to your requirements. There are two types of roles:

* Administrator Role: Allows access to the *Administration Portal* for managing physical and virtual resources. An administrator role confers permissions for actions to be performed in the User Portal; however, it has no bearing on what a user can see in the User Portal.

* User Role: Allows access to the *User Portal* for managing and accessing virtual machines and templates. A user role determines what a user can see in the User Portal. Permissions granted to a user with an administrator role are reflected in the actions available to that user in the User Portal.

For example, if you have an `administrator` role on a cluster, you can manage all virtual machines in the cluster using the *Administration Portal*. However, you cannot access any of these virtual machines in the *User Portal*; this requires a `user` role.

### User Roles Explained

The table below describes basic user roles which confer permissions to access and configure virtual machines in the User Portal.

**oVirt User Roles - Basic**

| Role | Privileges | Notes |
|-
| UserRole | Can access and use virtual machines and pools. | Can log in to the User Portal, use assigned virtual machines and pools, view virtual machine state and details. |
| PowerUserRole | Can create and manage virtual machines and templates. | Apply this role to a user for the whole environment with the **Configure** window, or for specific data centers or clusters. For example, if a PowerUserRole is applied on a data center level, the PowerUser can create virtual machines and templates in the data center. |
| UserVmManager | System administrator of a virtual machine. | Can manage virtual machines and create and use snapshots. A user who creates a virtual machine in the User Portal is automatically assigned the UserVmManager role on the machine. |

The table below describes advanced user roles which allow you to do more fine tuning of permissions for resources in the User Portal.

**oVirt User Roles - Advanced**
| Role | Privileges | Notes |
|-
| UserTemplateBasedVm | Limited privileges to only use Templates. | Can use templates to create virtual machines. |
| DiskOperator | Virtual disk user. | Can use, view and edit virtual disks. Inherits permissions to use the virtual machine to which the virtual disk is attached. |
| VmCreator | Can create virtual machines in the User Portal. | This role is not applied to a specific virtual machine; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers or clusters. When applying this role to a cluster, you must also apply the DiskCreator role on an entire data center, or on specific storage domains. |
| TemplateCreator | Can create, edit, manage and remove virtual machine templates within assigned resources. | This role is not applied to a specific template; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers, clusters, or storage domains. |
| DiskCreator | Can create, edit, manage and remove virtual machine disks within assigned clusters or data centers. | This role is not applied to a specific virtual disk; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers or storage domains. |
| TemplateOwner | Can edit and delete the template, assign and manage user permissions for the template. | This role is automatically assigned to the user who creates a template. Other users who do not have **TemplateOwner** permissions on a template cannot view or use the template. |
| VnicProfileUser | Logical network and network interface user for virtual machine and template. | Can attach or detach network interfaces from specific logical networks. |

### Administrator Roles Explained

The table below describes basic administrator roles which confer permissions to access and configure resources in the Administration Portal.

**oVirt System Administrator Roles - Basic**

| Role | Privileges | Notes |
|-
| SuperUser | System Administrator of the oVirt environment. | Has full permissions across all objects and levels, can manage all objects across all data centers. |
| ClusterAdmin | Cluster Administrator. | Possesses administrative permissions for all objects underneath a specific cluster. |
| DataCenterAdmin | Data Center Administrator. | Possesses administrative permissions for all objects underneath a specific data center except for storage. |

**Important:** Do not use the administrative user for the directory server as the oVirt administrative user. Create a user in the directory server specifically for use as the oVirt administrative user.

The table below describes advanced administrator roles which allow you to do more fine tuning of permissions for resources in the Administration Portal.

**oVirt System Administrator Roles - Advanced**

| Role | Privileges | Notes |
|-
| TemplateAdmin | Administrator of a virtual machine template. | Can create, delete, and configure the storage domains and network details of templates, and move templates between domains. |
| StorageAdmin | Storage Administrator. | Can create, delete, configure, and manage an assigned storage domain. |
| HostAdmin | Host Administrator. | Can attach, remove, configure, and manage a specific host. |
| NetworkAdmin | Network Administrator. | Can configure and manage the network of a particular data center or cluster. A network administrator of a data center or cluster inherits network permissions for virtual pools within the cluster. |
| VmPoolAdmin | System Administrator of a virtual pool. | Can create, delete, and configure a virtual pool; assign and remove virtual pool users; and perform basic operations on a virtual machine in the pool. |
| GlusterAdmin | Gluster Storage Administrator. | Can create, delete, configure, and manage Gluster storage volumes. |
| VmImporterExporter |                                           Import and export Administrator of a virtual machine. | Can import and export virtual machines. Able to view all virtual machines and templates exported by other users. |

## Scheduling Policies

A scheduling policy is a set of rules that defines the logic by which virtual machines are distributed amongst hosts in the cluster that scheduling policy is applied to. Scheduling policies determine this logic via a combination of filters, weightings, and a load balancing policy. The oVirt Engine provides five default scheduling policies: **Evenly_Distributed**, **InClusterUpgrade**, **None**, **Power_Saving**, and **VM_Evenly_Distributed**. You can also define new scheduling policies that provide fine-grained control over the distribution of virtual machines.

### Creating a Scheduling Policy

You can create new scheduling policies to control the logic by which virtual machines are distributed amongst a given cluster in your oVirt environment.

**Creating a Scheduling Policy**

1. Click the **Configure** button in the header bar of the Administration Portal to open the **Configure** window.

2. Click **Scheduling Policies** to view the scheduling policies tab.

3. Click **New** to open the **New Scheduling Policy** window.

    **The New Scheduling Policy Window**

    ![The New Scheduling Policy Window](/images/admin-guide/7332.png)

4. Enter a **Name** and **Description** for the scheduling policy.

5. Configure filter modules:

    1. In the **Filter Modules** section, drag and drop the preferred filter modules to apply to the scheduling policy from the **Disabled Filters** section into the **Enabled Filters** section.

    2. Specific filter modules can also be set as the **First**, to be given highest priority, or **Last**, to be given lowest priority, for basic optimization.

        To set the priority, right-click any filter module, hover the cursor over **Position** and select **First** or **Last**.

6. Configure weight modules:

    1. In the **Weights Modules** section, drag and drop the preferred weights modules to apply to the scheduling policy from the **Disabled Weights** section into the **Enabled Weights & Factors** section.

    2. Use the **+** and **-** buttons to the left of the enabled weight modules to increase or decrease the weight of those modules.

7. Specify a load balancing policy:

    1. From the drop-down menu in the **Load Balancer** section, select the load balancing policy to apply to the scheduling policy.

    2. From the drop-down menu in the **Properties** section, select a load balancing property to apply to the scheduling policy and use the text field to the right of that property to specify a value.

    3. Use the **+** and **-** buttons to add or remove additional properties.

8. Click **OK**.

### Explanation of Settings in the New Scheduling Policy and Edit Scheduling Policy Window

The following table details the options available in the **New Scheduling Policy** and **Edit Scheduling Policy** windows.

**New Scheduling Policy and Edit Scheduling Policy Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the scheduling policy. This is the name used to refer to the scheduling policy in the oVirt Engine.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the scheduling policy. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Filter Modules</b></td>
   <td>
    <p>A set of filters for controlling the hosts on which a virtual machine in a cluster can run. Enabling a filter will filter out hosts that do not meet the conditions specified by that filter, as outlined below:</p>
    <ul>
     <li><tt>CpuPinning</tt>: Hosts which do not satisfy the CPU pinning definition.</li>
     <li><tt>Migration</tt>: Prevent migration to the same host.</li>
     <li><tt>PinToHost</tt>: Hosts other than the host to which the virtual machine is pinned.</li>
     <li><tt>CPU-Level</tt>: Hosts that do not meet the CPU topology of the virtual machine.</li>
     <li><tt>CPU</tt>: Hosts with fewer CPUs than the number assigned to the virtual machine.</li>
     <li><tt>Memory</tt>: Hosts that do not have sufficient memory to run the virtual machine.</li>
     <li><tt>VmAffinityGroups</tt>: Hosts that do not meet the conditions specified for a virtual machine that is a member of an affinity group. For example, that virtual machines in an affinity group must run on the same host or on separate hosts.</li>
     <li><tt>InClusterUpgrade</tt>: Hosts which run an older operating system than the virtual machine currently runs on.</li>
     <li><tt>HostDevice</tt>: Hosts that do not support host devices required by the virtual machine.</li>
     <li><tt>HA</tt>: Forces the hosted engine virtual machine to only run on hosts with a positive high availability score.</li>
     <li><tt>Emulated-Machine</tt>: Hosts which do not have proper emulated machine support.</li>
     <li><tt>Network</tt>: Hosts on which networks required by the network interface controller of a virtual machine are not installed, or on which the cluster's display network is not installed.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Weights Modules</b></td>
   <td>
    <p>A set of weightings for controlling the relative priority of factors considered when determining the hosts in a cluster on which a virtual machine can run.</p>
    <ul>
     <li><tt>InClusterUpgrade</tt>: Weight hosts in accordance with their operating system version. The weight penalizes hosts with older operating systems more than hosts with the same operating system, giving priority to hosts with newer operating systems. </li>
     <li><tt>OptimalForHaReservation</tt>: Weights hosts in accordance with their high availability score.</li>
     <li><tt>None</tt>: Weights hosts in accordance with the even distribution module.</li>
     <li><tt>OptimalForEvenGuestDistribution</tt>: Weights hosts in accordance with the number of virtual machines running on those hosts.</li>
     <li><tt>VmAffinityGroups</tt>: Weights hosts in accordance with the affinity groups defined for virtual machines. This weight module determines how likely virtual machines in an affinity group are to run on the same host or on separate hosts in accordance with the parameters of that affinity group.</li>
     <li><tt>OptimalForPowerSaving</tt>: Weights hosts in accordance with their CPU usage, giving priority to hosts with higher CPU usage.</li>
     <li><tt>OptimalForEvenDistribution</tt>: Weights hosts in accordance with their CPU usage, giving priority to hosts with lower CPU usage.</li>
     <li><tt>HA</tt>: Weights hosts in accordance with their high availability score.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Load Balancer</b></td>
   <td>This drop-down menu allows you to select a load balancing module to apply. Load balancing modules determine the logic used to migrate virtual machines from hosts experiencing high usage to hosts experiencing lower usage.</td>
  </tr>
  <tr>
   <td><b>Properties</b></td>
   <td>This drop-down menu allows you to add or remove properties for load balancing modules, and is only available when you have selected a load balancing module for the scheduling policy. No properties are defined by default, and the properties that are available are specific to the load balancing module that is selected. Use the <b>+</b> and <b>-</b> buttons to add or remove additional properties to or from the load balancing module.</td>
  </tr>
 </tbody>
</table>

## Instance Types

Instance types can be used to define the hardware configuration of a virtual machine. Selecting an instance type when creating or editing a virtual machine will automatically fill in the hardware configuration fields. This allows users to create multiple virtual machines with the same hardware configuration without having to manually fill in every field.

A set of predefined instance types are available by default, as outlined in the following table:

**Predefined Instance Types**

| Name | Memory | vCPUs |
|-
| Tiny | 512 MB | 1 |
| Small | 2 GB | 1 |
| Medium | 4 GB | 2 |
| Large | 8 GB | 2 |
| XLarge | 16 GB | 4 |

Administrators can also create, edit, and remove instance types from the **Instance Types** tab of the **Configure** window.

**The Instance Types Tab**

![](/images/admin-guide/7330.png)

Fields in the **New Virtual Machine** and **Edit Virtual Machine** windows that are bound to an instance type will have a chain link image next to them (![](/images/admin-guide/6121.png)). If the value of one of these fields is changed, the virtual machine will be detached from the instance type, changing to **Custom**, and the chain will appear broken (![](/images/admin-guide/6122.png)). However, if the value is changed back, the chain will relink and the instance type will move back to the selected one.

### Creating Instance Types

Administrators can create new instance types, which can then be selected by users when creating or editing virtual machines.

**Creating an Instance Type**

1. On the header bar, click **Configure**.

2. Click the **Instance Types** tab.

3. Click **New** to open the **New Instance Type** window.

    **The New Instance Type Window**

    ![](/images/admin-guide/InstanceType.png)

4. Enter a **Name** and **Description** for the instance type.

5. Click **Show Advanced Options** and configure the instance type's settings as required. The settings that appear in the **New Instance Type** window are identical to those in the **New Virtual Machine** window, but with the relevant fields only. See "Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

6. Click **OK**.

The new instance type will appear in the **Instance Types** tab in the **Configure** window, and can be selected from the **Instance Type** drop-down list when creating or editing a virtual machine.

### Editing Instance Types

Administrators can edit existing instance types from the **Configure** window.

**Editing Instance Type Properties**

1. On the header bar, click **Configure**.

2. Click the **Instance Types** tab.

3. Select the instance type to be edited.

4. Click **Edit** to open the **Edit Instance Type** window.

5. Change the settings as required.

6. Click **OK**.

The configuration of the instance type is updated. New virtual machines and restarted existing virtual machines based on the instance type will use the new configuration.

### Removing Instance Types

**Removing an Instance Type**

1. On the header bar, click **Configure**.

2. Click the **Instance Types** tab.

3. Select the instance type to be removed.

4. Click **Remove** to open the **Remove Instance Type** window.

5. If any virtual machines are based on the instance type to be removed, a warning window listing the attached virtual machines will appear. To continue removing the instance type, select the **Approve Operation** checkbox. Otherwise click **Cancel**.

6. Click **OK**.

The instance type is removed from the **Instance Types** list and can no longer be used when creating a new virtual machine. Any virtual machines that were attached to the removed instance type will now be attached to **Custom** (no instance type).

## MAC Address Pools

MAC address pools define the range of MAC addresses from which MAC addresses are allocated for each data center. A MAC address pool is specified for each data center. By using MAC address pools oVirt can automatically generate and assign MAC addresses to new virtual network devices, which helps to prevent MAC address duplication. MAC address pools are more memory efficient when all MAC addresses related to a data center are within the range for the assigned MAC address pool.

The same MAC address pool can be shared by multiple data centers, but each data center has a single MAC address pool assigned. A default MAC address pool is created by oVirt and is used if another MAC address pool is not assigned. For more information about assigning MAC address pools to data centers see [Creating a New Data Center](Creating_a_New_Data_Center).

The MAC address pool assigns the next available MAC address following the last address that was returned to the pool. If there are no further addresses left in the range, the search starts again from the beginning of the range. If there are multiple MAC address ranges with available MAC addresses defined in a single MAC address pool, the ranges take turns in serving incoming requests in the same way available MAC addresses are selected.

### Creating MAC Address Pools

You can create new MAC address pools.

**Creating a MAC Address Pool**

1. On the header bar, click the **Configure** button to open the **Configure** window.

2. Click the **MAC Address Pools** tab.

3. Click the **Add** button to open the **New MAC Address Pool** window.

    **The New MAC Address Pool Window**

    ![](/images/admin-guide/New_MAC_Address_Pool.png)

4. Enter the **Name** and **Description** of the new MAC address pool.

5. Select the **Allow Duplicates** check box to allow a MAC address to be used multiple times in a pool. The MAC address pool will not automatically use a duplicate MAC address, but enabling the duplicates option means a user can manually use a duplicate MAC address.

    **Note:** If one MAC address pool has duplicates disabled, and another has duplicates enabled, each MAC address can be used once in the pool with duplicates disabled but can be used multiple times in the pool with duplicates enabled.

6. Enter the required **MAC Address Ranges**. To enter multiple ranges click the plus button next to the **From** and **To** fields.

7. Click **OK**.

### Editing MAC Address Pools

You can edit MAC address pools to change the details, including the range of MAC addresses available in the pool and whether duplicates are allowed.

**Editing MAC Address Pool Properties**

1. On the header bar, click the **Configure** button to open the **Configure** window.

2. Click the **MAC Address Pools** tab.

3. Select the MAC address pool to be edited.

4. Click the **Edit** button to open the **Edit MAC Address Pool** window.

5. Change the **Name**, **Description**, **Allow Duplicates**, and **MAC Address Ranges** fields as required.

    **Note:** When a MAC address range is updated, the MAC addresses of existing NICs are not reassigned. MAC addresses that were already assigned, but are outside of the new MAC address range, are added as user-specified MAC addresses and are still tracked by that MAC address pool.

6. Click **OK**.

### Editing MAC Address Pool Permissions

After a MAC address pool has been created, you can edit its user permissions. The user permissions control which data centers can use the MAC address pool. See [Roles](sect-Roles) for more information on adding new user permissions.

**Editing MAC Address Pool Permissions**

1. On the header bar, click the **Configure** button to open the **Configure** window.

2. Click the **MAC Address Pools** tab.

3. Select the required MAC address pool.

4. Edit the user permissions for the MAC address pool:

    * To add user permissions to a MAC address pool:

        1. Click **Add** in the user permissions pane at the bottom of the **Configure** window.

        2. Search for and select the required users.

        3. Select the required role from the **Role to Assign** drop-down list.

        4. Click **OK** to add the user permissions.

    * To remove user permissions from a MAC address pool:

        1. Select the user permission to be removed in the user permissions pane at the bottom of the **Configure** window.

        2. Click **Remove** to remove the user permissions.

### Removing MAC Address Pools

You can remove created MAC address pools, but the default MAC address pool cannot be removed.

**Removing a MAC Address Pool**

1. On the header bar, click the **Configure** button to open the **Configure** window.

2. Click the **MAC Address Pools** tab.

3. Select the MAC address pool to be removed.

4. Click the **Remove** button to open the **Remove MAC Address Pool** window.

5. Click **OK**.

**Next:** [Chapter 2: System Dashboard](../chap-System_Dashboard)
