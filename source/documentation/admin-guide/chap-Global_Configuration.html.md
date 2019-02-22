---
title: Global Configuration
---

# Chapter 1: Global Configuration

Accessed by clicking **Administration** &rarr; **Configure**, the **Configure** window allows you to configure a number of global resources for your oVirt environment, such as users, roles, system permissions, scheduling policies, instance types, and MAC address pools. This window allows you to customize the way in which users interact with resources in the environment, and provides a central location for configuring options that can be applied to multiple clusters.

## Roles

Roles are predefined sets of privileges that can be configured from oVirt Engine. Roles provide access and management permissions to different levels of resources in the data center, and to specific physical and virtual resources.

With multilevel administration, any permissions which apply to a container object also apply to all individual objects within that container. For example, when a host administrator role is assigned to a user on a specific host, the user gains permissions to perform any of the available host operations, but only on the assigned host. However, if the host administrator role is assigned to a user on a data center, the user gains permissions to perform host operations on all hosts within the cluster of the data center.

### Creating a New Role

If the role you require is not on oVirt's default list of roles, you can create a new role and customize it to suit your purposes.

**Creating a New Role**

1. Click the **Administration** &rarr; **Configure** to open the **Configure** window. The **Roles** tab is selected by default, showing a list of default User and Administrator roles, and any custom roles.

2. Click **New**.

3. Enter the **Name** and **Description** of the new role.

4. Select either **Admin** or **User** as the **Account Type**.

5. Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects in the **Check Boxes to Allow Action** list. You can also expand or collapse the options for each object.

6. For each of the objects, select or clear the actions you wish to permit or deny for the role you are setting up.

7. Click **OK** to apply the changes you have made. The new role displays on the list of roles.

### Editing or Copying a Role

You can change the settings for roles you have created, but you cannot change default roles. To change default roles, clone and modify them to suit your requirements.

**Editing or Copying a Role**

1. Click the **Administration** &rarr; **Configure** to open the **Configure** window. The window shows a list of default User and Administrator roles, and any custom roles.

2. Select the role you wish to change. Click **Edit** to open the **Edit Role** window, or click **Copy** to open the **Copy Role** window.

3. If necessary, edit the **Name** and **Description** of the role.

4. Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects. You can also expand or collapse the options for each object.

5. For each of the objects, select or clear the actions you wish to permit or deny for the role you are editing.

6. Click **OK** to apply the changes you have made.

### User Role and Authorization Examples

The following examples illustrate how to apply authorization controls for various scenarios, using the different features of the authorization system described in this chapter.

**Cluster Permissions**

Sarah is the system administrator for the accounts department of a company. All the virtual resources for her department are organized under an oVirt **cluster** called `Accounts`. She is assigned the **ClusterAdmin** role on the accounts cluster. This enables her to manage all virtual machines in the cluster, since the virtual machines are child objects of the cluster. Managing the virtual machines includes editing, adding, or removing virtual resources such as disks, and taking snapshots. It does not allow her to manage any resources outside this cluster. Because **ClusterAdmin** is an administrator role, it allows her to use the Administration Portal to manage these resources, but does not give her any access via the VM Portal.

**VM PowerUser Permissions**

John is a software developer in the accounts department. He uses virtual machines to build and test his software. Sarah has created a virtual desktop called `johndesktop` for him. John is assigned the **UserVmManager** role on the `johndesktop` virtual machine. This allows him to access this single virtual machine using the VM Portal. Because he has **UserVmManager** permissions, he can modify the virtual machine and add resources to it, such as new virtual disks. Because **UserVmManager** is a user role, it does not allow him to use the Administration Portal.

**Data Center Power User Role Permissions**

Penelope is an office manager. In addition to her own responsibilities, she occasionally helps the HR manager with recruitment tasks, such as scheduling interviews and following up on reference checks. As per corporate policy, Penelope needs to use a particular application for recruitment tasks.

While Penelope has her own machine for office management tasks, she wants to create a separate virtual machine to run the recruitment application. She is assigned **PowerUserRole** permissions for the data center in which her new virtual machine will reside. This is because to create a new virtual machine, she needs to make changes to several components within the data center, including creating the virtual disk in the storage domain.

Note that this is not the same as assigning **DataCenterAdmin** privileges to Penelope. As a PowerUser for a data center, Penelope can log in to the VM Portal and perform virtual machine-specific actions on virtual machines within the data center. She cannot perform data center-level operations such as attaching hosts or storage to a data center.

**Network Administrator Permissions**

Chris works as the network administrator in the IT department. Her day-to-day responsibilities include creating, manipulating, and removing networks in the department’s oVirt environment. For her role, she requires administrative privileges on the resources and on the networks of each resource. For example, if Chris has **NetworkAdmin** privileges on the IT department’s data center, she can add and remove networks in the data center, and attach and detach networks for all virtual machines belonging to the data center.

**Custom Role Permissions**

Rachel works in the IT department, and is responsible for managing user accounts in oVirt. She needs permission to add user accounts and assign them the appropriate roles and permissions. She does not use any virtual machines herself, and should not have access to administration of hosts, virtual machines, clusters or data centers. There is no built-in role which provides her with this specific set of permissions. A custom role must be created to define the set of permissions appropriate to Rachel's position.

**UserManager Custom Role**

![](/images/admin-guide/6568.png)

The **UserManager** custom role shown above allows manipulation of users, permissions and roles. These actions are organized under `System` - the top level object of the hierarchy shown in [rhev-object-hierarchy](rhev-object-hierarchy). This means they apply to all other objects in the system. The role is set to have an **Account Type** of **Admin**. This means that when she is assigned this role, Rachel can only use the Administration Portal, not the VM Portal.

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

* Administrator Role: Allows access to the **Administration Portal** for managing physical and virtual resources. An administrator role confers permissions for actions to be performed in the VM Portal; however, it has no bearing on what a user can see in the VM Portal.

* User Role: Allows access to the **VM Portal** for managing and accessing virtual machines and templates. A user role determines what a user can see in the VM Portal. Permissions granted to a user with an administrator role are reflected in the actions available to that user in the VM Portal.

### User Roles Explained

The table below describes basic user roles which confer permissions to access and configure virtual machines in the VM Portal.

**oVirt User Roles - Basic**

| Role | Privileges | Notes |
|-
| UserRole | Can access and use virtual machines and pools. | Can log in to the VM Portal, use assigned virtual machines and pools, view virtual machine state and details. |
| PowerUserRole | Can create and manage virtual machines and templates. | Apply this role to a user for the whole environment with the **Configure** window, or for specific data centers or clusters. For example, if a PowerUserRole is applied on a data center level, the PowerUser can create virtual machines and templates in the data center. |
| UserVmManager | System administrator of a virtual machine. | Can manage virtual machines and create and use snapshots. A user who creates a virtual machine in the VM Portal is automatically assigned the UserVmManager role on the machine. |

The table below describes advanced user roles which allow you to do more fine tuning of permissions for resources in the VM Portal.

**oVirt User Roles - Advanced**

| Role | Privileges | Notes |
|-
| UserTemplateBasedVm | Limited privileges to only use Templates. | Can use templates to create virtual machines. |
| DiskOperator | Virtual disk user. | Can use, view and edit virtual disks. Inherits permissions to use the virtual machine to which the virtual disk is attached. |
| VmCreator | Can create virtual machines in the VM Portal. | This role is not applied to a specific virtual machine; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers or clusters. When applying this role to a cluster, you must also apply the DiskCreator role on an entire data center, or on specific storage domains. |
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

### Assigning an Administrator or User Role to a Resource

Assign administrator or user roles to resources to allow users to access or manage that resource.

**Assigning a Role to a Resource**

1. Find and click the resource’s name to open the details view.

2. Click the **Permissions** tab to list the assigned users, the user’s role, and the inherited permissions for the selected resource.

3. Click **Add**.

4. Enter the name or user name of an existing user into the **Search** text box and click **Go**. Select a user from the resulting list of possible matches.

5. Select a role from the **Role to Assign** drop-down list.

6. Click **OK**.

The user now has the inherited permissions of that role enabled for that resource.

### Removing an Administrator or User Role from a Resource

Remove an administrator or user role from a resource; the user loses the inherited permissions associated with the role for that resource.

**Removing a Role from a Resource**

1. Find and click the resource’s name to open the details view.

2. Click the **Permissions** tab to list the assigned users, the user’s role, and the inherited permissions for the selected resource.

3. Select the user to remove from the resource.

4. Click **Remove**.

5. Click **OK**.

### Managing System Permissions for a Data Center

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A data center administrator is a system administration role for a specific data center only. This is useful in virtualization environments with multiple data centers where each data center requires an administrator. The **DataCenterAdmin** role is a hierarchical model; a user assigned the data center administrator role for a data center can manage all objects in the data center with the exception of storage for that data center. Use the **Configure** button in the header bar to assign a data center administrator for all data centers in the environment.

The data center administrator role permits the following actions:

* Create and remove clusters associated with the data center.

* Add and remove hosts, virtual machines, and pools associated with the data center.

* Edit user permissions for virtual machines associated with the data center.

    **Note:** You can only assign roles and permissions to existing users.

You can change the system administrator of a data center by removing the existing system administrator and adding the new system administrator.

### Data Center Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to data center administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| DataCenterAdmin | Data Center Administrator | Can use, create, delete, manage all physical and virtual resources within a specific data center except for storage, including clusters, hosts, templates, and virtual machines. |
| NetworkAdmin | Network Administrator | Can configure and manage the network of a particular data center. A network administrator of a data center inherits network permissions for virtual machines within the data center as well. |

### Managing System Permissions for a Cluster

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A cluster administrator is a system administration role for a specific cluster only. This is useful in data centers with multiple clusters, where each cluster requires a system administrator. The **ClusterAdmin** role is a hierarchical model: a user assigned the cluster administrator role for a cluster can manage all objects in the cluster. Use the **Configure** button in the header bar to assign a cluster administrator for all clusters in the environment.

The cluster administrator role permits the following actions:

* Create and remove associated clusters.

* Add and remove hosts, virtual machines, and pools associated with the cluster.

* Edit user permissions for virtual machines associated with the cluster.

    **Note:** You can only assign roles and permissions to existing users.

You can also change the system administrator of a cluster by removing the existing system administrator and adding the new system administrator.

### Cluster Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to cluster administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| ClusterAdmin | Cluster Administrator | Can use, create, delete, manage all physical and virtual resources in a specific cluster, including hosts, templates and virtual machines. Can configure network properties within the cluster such as designating display networks, or marking a network as required or non-required. However, a **ClusterAdmin** does not have permissions to attach or detach networks from a cluster, to do so **NetworkAdmin** permissions are required. |
| NetworkAdmin | Network Administrator | Can configure and manage the network of a particular cluster. A network administrator of a cluster inherits network permissions for virtual machines within the cluster as well. |

### Managing System Permissions for a Network

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A network administrator is a system administration role that can be applied for a specific network, or for all networks on a data center, cluster, host, virtual machine, or template. A network user can perform limited administration roles, such as viewing and attaching networks on a specific virtual machine or template. You can use the **Configure** button in the header bar to assign a network administrator for all networks in the environment.

The network administrator role permits the following actions:

* Create, edit and remove networks.

* Edit the configuration of the network, including configuring port mirroring.

* Attach and detach networks from resources including clusters and virtual machines.

The user who creates a network is automatically assigned **NetworkAdmin** permissions on the created network. You can also change the administrator of a network by removing the existing administrator and adding the new administrator.

### Network Administrator and User Roles Explained

The table below describes the administrator and user roles and privileges applicable to network administration.

**oVirt Network Administrator and User Roles**

| Role | Privileges | Notes |
|-
| NetworkAdmin | Network Administrator for data center, cluster, host, virtual machine, or template. The user who creates a network is automatically assigned **NetworkAdmin** permissions on the created network. | Can configure and manage the network of a particular data center, cluster, host, virtual machine, or template. A network administrator of a data center or cluster inherits network permissions for virtual pools within the cluster. To configure port mirroring on a virtual machine network, apply the **NetworkAdmin** role on the network and the **UserVmManager** role on the virtual machine. |
| VnicProfileUser | Logical network and network interface user for virtual machine and template. | Can attach or detach network interfaces from specific logical networks. |

### Managing System Permissions for a Host

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A host administrator is a system administration role for a specific host only. This is useful in clusters with multiple hosts, where each host requires a system administrator. You can use the **Configure** button in the header bar to assign a host administrator for all hosts in the environment.

The host administrator role permits the following actions:

* Edit the configuration of the host.

* Set up the logical networks.

* Remove the host.

You can also change the system administrator of a host by removing the existing system administrator and adding the new system administrator.

### Host Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to host administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| HostAdmin | Host Administrator | Can configure, manage, and remove a specific host. Can also perform network-related operations on a specific host. |

### Managing System Permissions for a Storage Domain

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A storage administrator is a system administration role for a specific storage domain only. This is useful in data centers with multiple storage domains, where each storage domain requires a system administrator. Use the Configure button in the header bar to assign a storage administrator for all storage domains in the environment.

The storage domain administrator role permits the following actions:

* Edit the configuration of the storage domain.

* Move the storage domain into maintenance mode.

* Remove the storage domain.

    **Note:** You can only assign roles and permissions to existing users.

You can also change the system administrator of a storage domain by removing the existing system administrator and adding the new system administrator.

### Storage Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to storage domain administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| StorageAdmin | Storage Administrator | Can create, delete, configure and manage a specific storage domain. |
| GlusterAdmin | Gluster Storage Administrator | Can create, delete, configure and manage Gluster storage volumes. |

### Managing System Permissions for a Virtual Machine Pool

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A virtual machine pool administrator is a system administration role for virtual machine pools in a data center. This role can be applied to specific virtual machine pools, to a data center, or to the whole virtualized environment; this is useful to allow different users to manage certain virtual machine pool resources.

The virtual machine pool administrator role permits the following actions:

* Create, edit, and remove pools.

* Add and detach virtual machines from the pool.

    **Note:** You can only assign roles and permissions to existing users.

### Virtual Machine Pool Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to pool administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| VmPoolAdmin | System Administrator role of a virtual pool. | Can create, delete, and configure a virtual pool, assign and remove virtual pool users, and perform basic operations on a virtual machine. |
| ClusterAdmin | Cluster Administrator | Can use, create, delete, manage all virtual machine pools in a specific cluster. |

### Managing System Permissions for a Virtual Disk

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

oVirt Engine provides two default virtual disk user roles, but no default virtual disk administrator roles. One of these user roles, the **DiskCreator** role, enables the administration of virtual disks from the VM Portal. This role can be applied to specific virtual machines, to a data center, to a specific storage domain, or to the whole virtualized environment; this is useful to allow different users to manage different virtual resources.

The virtual disk creator role permits the following actions:

* Create, edit, and remove virtual disks associated with a virtual machine or other resources.

* Edit user permissions for virtual disks.

    **Note:** You can only assign roles and permissions to existing users.

### Virtual Disk User Roles Explained

The table below describes the user roles and privileges applicable to using and administrating virtual disks in the VM Portal.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| DiskOperator | Virtual disk user. | Can use, view and edit virtual disks. Inherits permissions to use the virtual machine to which the virtual disk is attached. |
| DiskCreator | Can create, edit, manage and remove virtual disks within assigned clusters or data centers. | This role is not applied to a specific virtual disk; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers, clusters, or storage domains. |

## Scheduling Policies

A scheduling policy is a set of rules that defines the logic by which virtual machines are distributed amongst hosts in the cluster that scheduling policy is applied to. Scheduling policies determine this logic via a combination of filters, weightings, and a load balancing policy. The filter modules apply hard enforcement and filter out hosts that do not meet the conditions specified by that filter. The weights modules apply soft enforcement, and are used to control the relative priority of factors considered when determining the hosts in a cluster on which a virtual machine can run.

The oVirt Engine provides five default scheduling policies: **Evenly_Distributed**, **Cluster_Maintenance**, **None**, **Power_Saving**, and **VM_Evenly_Distributed**. You can also define new scheduling policies that provide fine-grained control over the distribution of virtual machines. Regardless of the scheduling policy, a virtual machine will not start on a host with an overloaded CPU. By default, a host’s CPU is considered overloaded if it has a load of more than 80% for 5 minutes, but these values can be changed using scheduling policies. See the “Scheduling Policy Settings Explained” section for more information about the properties of each scheduling policy.

**Evenly Distributed Scheduling Policy**

![Evenly Distributed Scheduling Policy](/images/admin-guide/EvenlyDistributed.png)

The **Evenly_Distributed** scheduling policy distributes the memory and CPU processing load evenly across all hosts in the cluster. Additional virtual machines attached to a host will not start if that host has reached the defined **CpuOverCommitDurationMinutes**, **HighUtilization**, or **MaxFreeMemoryForOverUtilized**.

The **VM_Evenly_Distributed** scheduling policy virtual machines evenly between hosts based on a count of the virtual machines. The cluster is considered unbalanced if any host is running more virtual machines than the **HighVmCount** and there is at least one host with a virtual machine count that falls outside of the **MigrationThreshold**.

![Power Saving Scheduling Policy](/images/admin-guide/PowerSaving.png)

The **Power_Saving** scheduling policy distributes the memory and CPU processing load across a subset of available hosts to reduce power consumption on underutilized hosts. Hosts with a CPU load below the low utilization value for longer than the defined time interval will migrate all virtual machines to other hosts so that it can be powered down. Additional virtual machines attached to a host will not start if that host has reached the defined high utilization value.

Set the **None** policy to have no load or power sharing between hosts for running virtual machines. This is the default mode. When a virtual machine is started, the memory and CPU processing load is spread evenly across all hosts in the cluster. Additional virtual machines attached to a host will not start if that host has reached the defined **CpuOverCommitDurationMinutes**, **HighUtilization**, or **MaxFreeMemoryForOverUtilized**.

The **Cluster_Maintenance** scheduling policy limits activity in a cluster during maintenance tasks. When the **Cluster_Maintenance** policy is set, no new virtual machines may be started, except highly available virtual machines. If host failure occurs, highly available virtual machines will restart properly and any virtual machine can migrate.

### Creating a Scheduling Policy

You can create new scheduling policies to control the logic by which virtual machines are distributed amongst a given cluster in your oVirt environment.

**Creating a Scheduling Policy**

1. Click **Administration** &rarr; **Configure**.

2. Click the **Scheduling Policies** tab.

3. Click **New**.

4. Enter a **Name** and **Description** for the scheduling policy.

5. Configure filter modules:

    i. In the **Filter Modules** section, drag and drop the preferred filter modules to apply to the scheduling policy from the **Disabled Filters** section into the **Enabled Filters** section.

    ii. Specific filter modules can also be set as the **First**, to be given highest priority, or **Last**, to be given lowest priority, for basic optimization. To set the priority, right-click any filter module, hover the cursor over **Position** and select **First** or **Last**.

6. Configure weight modules:

    i. In the **Weights Modules** section, drag and drop the preferred weights modules to apply to the scheduling policy from the **Disabled Weights** section into the **Enabled Weights & Factors** section.

    ii. Use the **+** and **-** buttons to the left of the enabled weight modules to increase or decrease the weight of those modules.

7. Specify a load balancing policy:

    i. From the drop-down menu in the **Load Balancer** section, select the load balancing policy to apply to the scheduling policy.

    ii. From the drop-down menu in the **Properties** section, select a load balancing property to apply to the scheduling policy and use the text field to the right of that property to specify a value.

    ii. Use the **+** and **-** buttons to add or remove additional properties.

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

Fields in the **New Virtual Machine** and **Edit Virtual Machine** windows that are bound to an instance type will have a chain link image next to them (![](/images/admin-guide/6121.png)). If the value of one of these fields is changed, the virtual machine will be detached from the instance type, changing to **Custom**, and the chain will appear broken (![](/images/admin-guide/6122.png)). However, if the value is changed back, the chain will relink and the instance type will move back to the selected one.

### Creating Instance Types

Administrators can create new instance types, which can then be selected by users when creating or editing virtual machines.

**Creating an Instance Type**

1. Click **Administration** &rarr; **Configure**.

2. Click the **Instance Types** tab.

3. Click **New**.

4. Enter a **Name** and **Description** for the instance type.

5. Click **Show Advanced Options** and configure the instance type's settings as required. The settings that appear in the **New Instance Type** window are identical to those in the **New Virtual Machine** window, but with the relevant fields only. See "Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

6. Click **OK**.

The new instance type will appear in the **Instance Types** tab in the **Configure** window, and can be selected from the **Instance Type** drop-down list when creating or editing a virtual machine.

### Editing Instance Types

Administrators can edit existing instance types from the **Configure** window.

**Editing Instance Type Properties**

1. Click **Administration** &rarr; **Configure**.

2. Click the **Instance Types** tab.

3. Select the instance type to be edited.

4. Click **Edit**.

5. Change the settings as required.

6. Click **OK**.

The configuration of the instance type is updated. When a new virtual machine based on this instance type is created, or when an existing virtual machine based on this instance type is updated, the new configuration is applied.

Existing virtual machines based on this instance type will display fields, marked with a chain icon, that will be updated. If the existing virtual machines were running when the instance type was changed, the orange Pending Changes icon will appear beside them and the fields with the chain icon will be updated at the next restart.

### Removing Instance Types

**Removing an Instance Type**

1. Click **Administration** &rarr; **Configure**.

2. Click the **Instance Types** tab.

3. Select the instance type to be removed.

4. Click **Remove**.

5. If any virtual machines are based on the instance type to be removed, a warning window listing the attached virtual machines will appear. To continue removing the instance type, select the **Approve Operation** check box. Otherwise click **Cancel**.

6. Click **OK**.

The instance type is removed from the **Instance Types** list and can no longer be used when creating a new virtual machine. Any virtual machines that were attached to the removed instance type will now be attached to **Custom** (no instance type).

## MAC Address Pools

MAC address pools define the range(s) of MAC addresses allocated for each cluster. A MAC address pool is specified for each cluster. By using MAC address pools, oVirt can automatically generate and assign MAC addresses to new virtual network devices, which helps to prevent MAC address duplication. MAC address pools are more memory efficient when all MAC addresses related to a cluster are within the range for the assigned MAC address pool.

The same MAC address pool can be shared by multiple clusters, but each cluster has a single MAC address pool assigned. A default MAC address pool is created by oVirt and is used if another MAC address pool is not assigned. For more information about assigning MAC address pools to clusters see “Creating a New Cluster” section in Chapter 5.

**Note:** If more than one oVirt cluster shares a network, do not rely solely on the default MAC address pool because the virtual machines of each cluster will try to use the same range of MAC addresses, leading to conflicts. To avoid MAC address conflicts, check the MAC address pool ranges to ensure that each cluster is assigned a unique MAC address range.

The MAC address pool assigns the next available MAC address following the last address that was returned to the pool. If there are no further addresses left in the range, the search starts again from the beginning of the range. If there are multiple MAC address ranges with available MAC addresses defined in a single MAC address pool, the ranges take turns in serving incoming requests in the same way available MAC addresses are selected.

### Creating MAC Address Pools

You can create new MAC address pools.

**Creating a MAC Address Pool**

1. Click **Administration** &rarr; **Configure**.

2. Click the **MAC Address Pools** tab.

3. Click **Add**.

4. Enter the **Name** and **Description** of the new MAC address pool.

5. Select the **Allow Duplicates** check box to allow a MAC address to be used multiple times in a pool. The MAC address pool will not automatically use a duplicate MAC address, but enabling the duplicates option means a user can manually use a duplicate MAC address.

    **Note:** If one MAC address pool has duplicates disabled, and another has duplicates enabled, each MAC address can be used once in the pool with duplicates disabled but can be used multiple times in the pool with duplicates enabled.

6. Enter the required **MAC Address Ranges**. To enter multiple ranges click the plus button next to the **From** and **To** fields.

7. Click **OK**.

### Editing MAC Address Pools

You can edit MAC address pools to change the details, including the range of MAC addresses available in the pool and whether duplicates are allowed.

**Editing MAC Address Pool Properties**

1. Click **Administration** &rarr; **Configure**.

2. Click the **MAC Address Pools** tab.

3. Select the MAC address pool to be edited.

4. Click **Edit**.

5. Change the **Name**, **Description**, **Allow Duplicates**, and **MAC Address Ranges** fields as required.

    **Note:** When a MAC address range is updated, the MAC addresses of existing NICs are not reassigned. MAC addresses that were already assigned, but are outside of the new MAC address range, are added as user-specified MAC addresses and are still tracked by that MAC address pool.

6. Click **OK**.

### Editing MAC Address Pool Permissions

After a MAC address pool has been created, you can edit its user permissions. The user permissions control which data centers can use the MAC address pool. See the "[Roles](sect-Roles)" section for more information on adding new user permissions.

**Editing MAC Address Pool Permissions**

1. Click **Administration** &rarr; **Configure**.

2. Click the **MAC Address Pools** tab.

3. Select the required MAC address pool.

4. Edit the user permissions for the MAC address pool:

    * To add user permissions to a MAC address pool:

        i. Click **Add** in the user permissions pane at the bottom of the **Configure** window.

        ii. Search for and select the required users.

        iii. Select the required role from the **Role to Assign** drop-down list.

        iv. Click **OK** to add the user permissions.

    * To remove user permissions from a MAC address pool:

        i. Select the user permission to be removed in the user permissions pane at the bottom of the **Configure** window.

        ii. Click **Remove** to remove the user permissions.

### Removing MAC Address Pools

You can remove created MAC address pools, but the default MAC address pool cannot be removed.

**Removing a MAC Address Pool**

1. Click **Administration** &rarr; **Configure**.

2. Click the **MAC Address Pools** tab.

3. Select the MAC address pool to be removed.

4. Click **Remove**.

5. Click **OK**.

**Next:** [Chapter 2: Dashboard](chap-System_Dashboard)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-global_configuration)
