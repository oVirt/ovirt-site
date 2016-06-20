---
title: oVirt Administration Guide
category: documentation
authors: bproffitt, omachace, vered, wdennis
wiki_title: OVirt Administration Guide
wiki_revision_count: 7
wiki_last_updated: 2015-11-16
---

# OVirt Administration Guide

## Introduction

### oVirt Architecture

An oVirt environment consists of:

*   Virtual machine **hosts** using the Kernel-based Virtual Machine (KVM).
*   **Agents and tools** running on hosts including VDSM, QEMU, and libvirt. These tools provide local management for virtual machines, networks and storage.
*   **oVirt**; a centralized management platform for the oVirt environment. It provides a graphical interface where you can view, provision and manage resources.
*   **Storage domains** to hold virtual resources like virtual machines, templates, ISOs.
*   A **database** to track the state of and changes to the environment.
*   Access to an external **Directory Server** to provide users and authentication.
*   **Networking** to link the environment together. This includes physical network links, and logical networks.

![](Ovirt-1024x698.png "Ovirt-1024x698.png")

**Figure 1.1. oVirt Platform Overview**

### oVirt System Components

The oVirt version 3.4 environment consists of one or more hosts (either Red Hat Enterprise Linux 6.5 or later hosts (or similar), Fedora 19, or oVirt Node 6.5 or later hosts) and at least one instance of oVirt.

Hosts run virtual machines using KVM (Kernel-based Virtual Machine) virtualization technology.

oVirt runs on a Red Hat Enterprise Linux (or similar) server, as well as Fedora 19, and provides interfaces for controlling the oVirt environment. It manages virtual machine and storage provisioning, connection protocols, user sessions, virtual machine images, and high-availability virtual machines.

oVirt is accessed through the Administration Portal using a web browser.

### oVirt Resources

The components of the oVirt environment fall into two categories: physical resources, and logical resources. Physical resources are physical objects, such as host and storage servers. Logical resources are nonphysical groupings and processes, such as logical networks and virtual machine templates.

*   **Data Center** - A data center is the highest-level container for all physical and logical resources within a managed virtual environment. It is a collection of clusters, virtual machines, storage, and networks.
*   **Clusters** - A cluster is a set of physical hosts that are treated as a resource pool for virtual machines. Hosts in a cluster share the same network infrastructure and storage. They form a migration domain within which virtual machines can be moved from host to host.
*   **Logical Networks** - A logical network is a logical representation of a physical network. Logical networks group network traffic and communication between oVirt, hosts, storage, and virtual machines.
*   **Hosts** - A host is a physical server that runs one or more virtual machines. Hosts are grouped into clusters. Virtual machines can be migrated from one host to another within a cluster.
*   **Storage Pool** - The storage pool is a logical entity that contains a standalone image repository of a certain type, either iSCSI, Fibre Channel, NFS, or POSIX. Each storage pool can contain several domains, for storing virtual machine disk images, ISO images, and for the import and export of virtual machine images.
*   **Virtual Machines** - A virtual machine is a virtual desktop or virtual server containing an operating system and a set of applications. Multiple identical virtual machines can be created in a **Pool**. Virtual machines are created, managed, or deleted by power users and accessed by users.
*   **Template** - A template is a model virtual machine with predefined settings. A virtual machine that is based on a particular template acquires the settings of the template. Using templates is the quickest way of creating a large number of virtual machines in a single step.
*   **Virtual Machine Pool** - A virtual machine pool is a group of identical virtual machines that are available on demand by each group member. Virtual machine pools can be set up for different purposes. For example, one pool can be for the Marketing department, another for Research and Development, and so on.
*   **Snapshot** - A snapshot is a view of a virtual machine's operating system and all its applications at a point in time. It can be used to save the settings of a virtual machine before an upgrade or installing new applications. In case of problems, a snapshot can be used to restore the virtual machine to its original state.
*   **User Types** - oVirt supports multiple levels of administrators and users with distinct levels of permissions. System administrators can manage objects of the physical infrastructure, such as data centers, hosts, and storage. Users access virtual machines available from a virtual machine pool or standalone virtual machines made accessible by an administrator.
*   **Events and Monitors** - Alerts, warnings, and other notices about activities help the administrator to monitor the performance and status of resources.
*   **Reports** - A range of reports either from the reports module based on JasperReports, or from the data warehouse. Preconfigured or ad hoc reports can be generated from the reports module. Users can also generate reports using any query tool that supports SQL from a data warehouse that collects monitoring data for hosts, virtual machines, and storage.

### oVirt API Support Statement

oVirt exposes a number of interfaces for interacting with the components of the virtualization environment. These interfaces are in addition to the user interfaces provided by oVirt Administration, User, and Reports Portals. Many of these interfaces are fully supported. Some, however, are supported only for read access.

**Supported Interfaces for Read and Write Access**

Direct interaction with these interfaces is supported and encouraged for both read and write access:

Representational State Transfer (REST) API  
The REST API exposed by oVirt is a fully supported interface for interacting with oVirt.

Software Development Kit (SDK)  
The SDK provided by the python-sdk and java-sdk packages is a fully supported interface for interacting with oVirt.

Command Line Shell  
The command line shell provided by the ovirt-shell package is a fully supported interface for interacting with oVirt.

VDSM Hooks  
The creation and use of VDSM hooks to trigger modification of virtual machines based on custom properties specified in the Administration Portal is supported on oVirt hosts. The use of VDSM Hooks on virtualization hosts running oVirt Node is not currently supported.

**Supported Interfaces for Read Access**

Direct interaction with these interfaces is supported and encouraged only for read access. Use of these interfaces for write access is not supported:

oVirt History Database  
Read access to oVirt history database using the database views specified in the Administration Guide is supported. Write access is *not* supported.

Libvirt on Virtualization Hosts  
Read access to `libvirt` using the `virsh -r` command is a supported method of interacting with virtualization hosts. Write access is *not* supported.

**Unsupported Interfaces**

Direct interaction with these interfaces is *not* supported:

The vdsClient Command  
Use of the `vdsClient` command to interact with virtualization hosts is *not* supported.

oVirt Node Console  
Console access to oVirt Node outside of the provided text user interface for configuration is *not* supported.

oVirt Database  
Direct access to and manipulation of oVirt database is *not* supported.

### Administering and Maintaining the oVirt Environment

The oVirt environment requires an administrator to keep it running. As an administrator, your tasks include:

*   Managing physical and virtual resources such as hosts and virtual machines. This includes upgrading and adding hosts, importing domains, converting virtual machines created on foreign hypervisors, and managing virtual machine pools.
*   Monitoring the overall system resources for potential problems such as extreme load on one of the hosts, insufficient memory or disk space, and taking any necessary actions (such as migrating virtual machines to other hosts to lessen the load or freeing resources by shutting down machines).
*   Responding to the new requirements of virtual machines (for example, upgrading the operating system or allocating more memory).
*   Managing customized object properties using tags.
*   Managing searches saved as public bookmarks.
*   Managing user setup and setting permission levels.
*   Troubleshooting for specific users or virtual machines for overall system functionality.
*   Generating general and specific reports.

## Using the Administration Portal

### Graphical User Interface Elements

The oVirt Administration Portal consists of contextual panes and menus and can be used in two modes - tree mode, and flat mode. Tree mode allows you to browse the object hierarchy of a data center while flat mode allows you to view all resources across data centers in a single list. The elements of the graphical user interface are shown in the diagram below.

⁠

![Key Graphical User Interface Elements](Admin-portal-label.png "Key Graphical User Interface Elements")

**Figure 2.1. Key Graphical User Interface Elements**

**Key Graphical User Interface Elements**

*   ![](Bullet1.png "fig:Bullet1.png")
    **Header**
    The header bar contains the name of the currently logged in user, the **Sign Out** button, the **About** button, the **Configure** button, and the **Guide** button. The **About** shows information on the version of oVirt, the **Configure** button allows you to configure user roles, and the **Guide** button provides a shortcut to the book you are reading now.
    **Search Bar**
    The search bar allows you to build queries for finding resources such as hosts and clusters in the oVirt environment. Queries can be as simple as a list of all the hosts in the system, or more complex, such as a list of resources that match certain conditions. As you type each part of the search query, you are offered choices to assist you in building the search. The star icon can be used to save the search as a bookmark.
*   ![](Bullet2.png "fig:Bullet2.png")
    **System/Bookmarks/Tags Pane**
    The system pane displays a navigable hierarchy of the resources in the virtualized environment. Bookmarks are used to save frequently used or complicated searches for repeated use. Bookmarks can be added, edited, or removed. Tags are applied to groups of resources and are used to search for all resources associated with that tag. The System/Bookmarks/Tags Pane can be minimized using the arrow in the upper right corner of the panel.
*   ![](Bullet3.png "fig:Bullet3.png")
    **Resource Tabs**
    All resources can be managed using their associated tab. Moreover, the **Events** tab allows you to view events for each resource. The Administration Portal provides the following tabs: **Data Centers**, **Clusters**, **Hosts**, **Networks**, **Storage**, **Disks**, **Virtual Machines**, **Pools**, **Templates**, **Volumes**, **Users**, and **Events**, and a **Dashboard** tab if you have installed the data warehouse and reports.
*   ![](Bullet4.png "fig:Bullet4.png")
    **Results List**
    You can perform a task on an individual item, multiple items, or all the items in the results list by selecting the items and clicking the relevant action button. Information on a selected item is displayed in the details pane.
     **Refresh Rate**
    The refresh rate drop-down menu at the top of the Results List allows you to set the time, in seconds, between Administration Portal refreshes. To avoid the delay between a user performing an action and the result appearing the portal, the portal will automatically refresh upon an action or event regardless of the chosen refresh interval. You can set this interval by clicking the refresh symbol in top right of the portal.
*   ![](Bullet5.png "fig:Bullet5.png")
    **Details Pane**
    The details pane shows detailed information about a selected item in the results list. If no items are selected, this pane is hidden. If multiple items are selected, the details pane displays information on the first selected item only.
     **Alerts/Events Pane**
    Below the Details pane, the **Alerts** tab lists all high severity events such as errors or warnings. The **Events** tab shows a list of events for all resources. The **Tasks** tab lists the currently running tasks. You can view this panel by clicking the maximize/minimize button.

<div class="alert alert-info">
**Important:** The minimum supported resolution viewing the Administration Portal in a web browser is 1024x768. The Administration Portal will not render correctly when viewed at a lower resolution.

</div>
<div class="alert alert-info">
**Note:** In oVirt 3.4, the web user interface display has been improved to allow the Administration Portal to render correctly at low resolutions or on non-maximized windows. When resolution is too low or window space insufficient to hold all menu tabs, you are able to scroll the tabs left or right, and access a drop down menu that lists all tabs. The **System/Bookmarks/Tags Pane** can also be minimized to allow additional space.

</div>

### Tree Mode and Flat Mode

The Administration Portal provides two different modes for managing your resources: tree mode and flat mode. Tree mode displays resources in a hierarchical view per data center, from the highest level of the data center down to the individual virtual machine. Working in tree mode is highly recommended for most operations.

⁠

![Tree Mode|250px](Tree_mode.png "Tree Mode|250px")

**Figure 2.2. Tree Mode**

Flat mode allows you to search across data centers, or storage domains. It does not limit you to viewing the resources of a single hierarchy. For example, you may need to find all virtual machines that are using more than 80% CPU across clusters and data centers, or locate all hosts that have the highest utilization. Flat mode makes this possible. In addition, certain objects, such as **Pools** and **Users** are not in the data center hierarchy and can be accessed only in flat mode.

To access flat mode, click on the **System** item in the **Tree** pane on the left side of the screen. You are in flat mode if the **Pools** and **Users** resource tabs appear.

⁠

![Flat Mode|250px](Flat_mode.png "Flat Mode|250px")

**Figure 2.3. Flat Mode**

### Using the Guide Me Facility

When setting up resources such as data centers and clusters, a number of tasks must be completed in sequence. The context-sensitive **Guide Me** window prompts for actions that are appropriate to the resource being configured. The **Guide Me** window can be accessed at any time by clicking the **Guide Me** button on the resource toolbar.

⁠

![New Data Center Guide Me Window|300px](Guide_me.png "New Data Center Guide Me Window|300px")

**Figure 2.4. New Data Center Guide Me Window**

### Performing Searches in oVirt

The Administration Portal enables the management of thousands of resources, such as virtual machines, hosts, users, and more. To perform a search, enter the search query (free-text or syntax-based) in the search bar. Search queries can be saved as bookmarks for future reuse, so you do not have to reenter a search query each time the specific search results are needed.

<div class="alert alert-info">
**Note:** In versions prior to oVirt 3.4, searches in the Administration Portal were case sensitive. Now, the search bar supports case insensitive searches.

</div>

### Saving a Query String as a Bookmark

**Summary**

A bookmark can be used to remember a search query, and shared with other users.

⁠

**Procedure 2.1. Saving a Query String as a Bookmark**

1.  Enter the desired search query in the search bar and perform the search.
2.  Click the star-shaped **Bookmark** button to the right of the search bar to open the **New Bookmark** window.
    ⁠

    ![Bookmark Icon](Bookmark.png "Bookmark Icon")

    **Figure 2.5. Bookmark Icon**

3.  Enter the **Name** of the bookmark.
4.  Edit the **Search string** field (if applicable).
5.  Click **OK** to save the query as a bookmark and close the window.
6.  The search query is saved and displays in the **Bookmarks** pane.

**Result**

You have saved a search query as a bookmark for future reuse. Use the **Bookmark** pane to find and select the bookmark.

## ⁠Data Centers

### Introduction to Data Centers

A data center is a logical entity that defines the set of resources used in a specific environment. A data center is considered a container resource, in that it is comprised of logical resources, in the form of clusters and hosts; network resources, in the form of logical networks and physical NICs; and storage resources, in the form of storage domains.

A data center can contain multiple clusters, which can contain multiple hosts; it can have multiple storage domains associated to it; and it can support multiple virtual machines on each of its hosts. An oVirt environment can contain multiple data centers; the data center infrastructure allows you to keep these centers separate.

All data centers are managed from the single Administration Portal.

oVirt creates a default data center during installation. It is recommended that you do not remove the default data center; instead, set up new appropriately named data centers.

### The Storage Pool Manager

The Storage Pool Manager (SPM) is a role given to one of the hosts in the data center enabling it to manage the storage domains of the data center. The SPM entity can be run on any host in the data center; oVirt grants the role to one of the hosts. The SPM does not preclude the host from its standard operation; a host running as SPM can still host virtual resources.

The SPM entity controls access to storage by coordinating the metadata across the storage domains. This includes creating, deleting, and manipulating virtual disks (images), snapshots, and templates, and allocating storage for sparse block devices (on SAN). This is an exclusive responsibility: only one host can be the SPM in the data center at one time to ensure metadata integrity.

oVirt ensures that the SPM is always available. oVirt moves the SPM role to a different host if the SPM host encounters problems accessing the storage. When the SPM starts, it ensures that it is the only host granted the role; therefore it will acquire a storage-centric lease. This process can take some time.

### SPM Priority

The SPM role uses some of a host's available resources. The SPM priority setting of a host alters the likelihood of the host being assigned the SPM role: a host with high SPM priority will be assigned the SPM role before a host with low SPM priority. Critical virtual machines on hosts with low SPM priority will not have to contend with SPM operations for host resources.

You can change a host's SPM priority by editing the host.

### Using the Events Tab to Identify Problem Objects in Data Centers

The **Events** tab for a data center displays all events associated with that data center; events include audits, warnings, and errors. The information displayed in the results list will enable you to identify problem objects in your oVirt environment.

The **Events** results list has two views: Basic and Advanced. Basic view displays the event icon, the time of the event, and the description of the events. Advanced view displays these also and includes, where applicable, the event ID; the associated user, host, virtual machine, template, data center, storage, and cluster; the Gluster volume, and the correlation ID.

### Data Center Tasks

#### Creating a New Data Center

**Summary**

This procedure creates a data center in your virtualization environment. The data center requires a functioning cluster, host, and storage domain to operate.

<div class="alert alert-info">
**Note:** The storage **Type** can be edited until the first storage domain is added to the data center. Once a storage domain has been added, the storage **Type** cannot be changed.

If you set the **Compatibility Version** as **3.1**, it cannot be changed to **3.0** at a later time; version regression is not allowed.

</div>
⁠

**Procedure 3.1. Creating a New Data Center**

1.  Select the **Data Centers** resource tab to list all data centers in the results list.
2.  Click **New** to open the **New Data Center** window.
3.  Enter the **Name** and **Description** of the data center.
4.  Select the storage **Type**, **Compatibility Version**, and **Quota Mode** of the data center from the drop-down menus.
5.  Click **OK** to create the data center and open the **New Data Center - Guide Me** window.
6.  The **Guide Me** window lists the entities that need to be configured for the data center. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the data center and clicking the **Guide Me** button.

**Result**

The new data center is added to the virtualization environment. It will remain **Uninitialized** until a cluster, host, and storage domain are configured for it; use **Guide Me** to configure these entities.

#### Explanation of Settings in the New Data Center and Edit Data Center Windows

The table below describes the settings of a data center as displayed in the **New Data Center** and **Edit Data Center** windows. Invalid entries are outlined in orange when you click **OK**, prohibiting the changes being accepted. In addition, field prompts indicate the expected values or range of values.

⁠

**Table 3.1. Data Center Properties**

<table>
<colgroup>
<col width="15%" />
<col width="85%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the data center. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>The description of the data center. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Type</strong></p></td>
<td align="left"><p>The storage type. Choose one of the following:</p>
<ul>
<li><strong>Shared</strong></li>
<li><strong>Local</strong></li>
</ul>
<p>The type of data domain dictates the type of the data center and cannot be changed after creation without significant disruption. Multiple types of storage domains (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, though local and shared domains cannot be mixed.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Compatibility Version</strong></p></td>
<td align="left"><p>The version of oVirt. Choose one of the following:</p>
<ul>
<li><strong>3.0</strong></li>
<li><strong>3.1</strong></li>
<li><strong>3.2</strong></li>
<li><strong>3.3</strong></li>
<li><strong>3.4</strong></li>
</ul>
<p>After upgrading oVirt, the hosts, clusters and data centers may still be in the earlier version. Ensure that you have upgraded all the hosts, then the clusters, before you upgrade the Compatibility Level of the data center.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Quota Mode</strong></p></td>
<td align="left"><p>Quota is a resource limitation tool provided with oVirt. Choose one of:</p>
<ul>
<li><strong>Disabled</strong>: Select if you do not want to implement Quota</li>
<li><strong>Audit</strong>: Select if you want to edit the Quota settings</li>
<li><strong>Enforced</strong>: Select to implement Quota</li>
</ul></td>
</tr>
</tbody>
</table>

#### Editing a Resource

**Summary**

Edit the properties of a resource.

**Procedure 3.2. Editing a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click **Edit** to open the **Edit** window.
3.  Change the necessary properties and click **OK**.

**Result**

The new properties are saved to the resource. The **Edit** window will not close if a property field is invalid.

#### Creating a New Logical Network in a Data Center or Cluster

**Summary**

Create a logical network and define its use in a data center, or in clusters in a data center.

**Procedure 3.3. Creating a New Logical Network in a Data Center or Cluster**

1.  Use the **Data Centers** or **Clusters** resource tabs, tree mode, or the search function to find and select a data center or cluster in the results list.
2.  Click the **Logical Networks** tab of the details pane to list the existing logical networks.
3.  From the **Data Centers** details pane, click **New** to open the **New Logical Network** window. From the **Clusters** details pane, click **Add Network** to open the **New Logical Network** window.
4.  Enter a **Name**, **Description** and **Comment** for the logical network.
5.  In the **Export** section, select the **Create on external provider** check box to create the logical network on an external provider. Select the external provider from the **External Provider** drop-down menu.
6.  In the **Network Parameters** section, select the **Enable VLAN tagging**, **VM network** and **Override MTU** to enable these options.
7.  Enter a new label or select an existing label for the logical network in the **Network Label** text field.
8.  From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.
9.  If the **Create on external provider** check box is selected, the **Subnet** tab will be visible. From the **Subnet** tab enter a **Name**, **CIDR** and select an **IP Version** for the subnet that the logical network will provide.
10. From the **Profiles** tab, add vNIC profiles to the logical network as required.
11. Click **OK**.

**Result**

You have defined a logical network as a resource required by a cluster or clusters in the data center. If you entered a label for the logical network, it will be automatically added to all host network interfaces with that label.

<div class="alert alert-info">
**Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.

</div>

#### Removing a Logical Network

**Summary**

Remove a logical network from oVirt.

⁠**Procedure 3.4. Removing Logical Networks**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to find and select the data center of the logical network in the results list.
2.  Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.
3.  Select a logical network and click **Remove** to open the **Remove Logical Network(s)** window.
4.  Optionally, select the **Remove external network(s) from the provider(s) as well** check box to remove the logical network both from oVirt and from the external provider if the network is provided by an external provider.
5.  Click **OK**.

**Result**

The logical network is removed from oVirt and is no longer available. If the logical network was provided by an external provider and you elected to remove the logical network from that external provider, it is removed from the external provider and is no longer available on that external provider as well.

#### Re-Initializing a Data Center: Recovery Procedure

**Summary**

This recovery procedure replaces the master data domain of your data center with a new master data domain; necessary in the event of data corruption of your master data domain. Re-initializing a data center allows you to restore all other resources associated with the data center, including clusters, hosts, and non-problematic storage domains.

You can import any backup or exported virtual machines or templates into your new master data domain.

⁠

**Procedure 3.5. Re-Initializing a Data Center**

1.  Click the **Data Centers** resource tab and select the data center to re-initialize.
2.  Ensure that any storage domains attached to the data center are in maintenance mode.
3.  Right-click the data center and select **Re-Initialize Data Center** from the drop-down menu to open the **Data Center Re-Initialize** window.
4.  The **Data Center Re-Initialize** window lists all available (detached; in maintenance mode) storage domains. Click the radio button for the storage domain you are adding to the data center.
5.  Select the **Approve operation** check box.
6.  Click **OK** to close the window and re-initialize the data center.

**Result**

The storage domain is attached to the data center as the master data domain and activated. You can now import any backup or exported virtual machines or templates into your new master data domain.

#### Removing a Data Center

**Summary**

An active host is required to remove a data center. Removing a data center will not remove the associated resources.

⁠

**Procedure 3.6. Removing a Data Center**

1.  Ensure the storage domains attached to the data center is in maintenance mode.
2.  Click the **Data Centers** resource tab and select the data center to remove.
3.  Click **Remove** to open the **Remove Data Center(s)** confirmation window.
4.  Click **OK**.

**Result**

The data center has been removed.

#### Force Removing a Data Center

**Summary**

A data center becomes `Non Responsive` if the attached storage domain is corrupt or if the host becomes `Non Responsive`. You cannot **Remove** the data center under either circumstance.

**Force Remove** does not require an active host. It also permanently removes the attached storage domain.

It may be necessary to **Destroy** a corrupted storage domain before you can **Force Remove** the data center.

⁠

**Procedure 3.7. Force Removing a Data Center**

1.  Click the **Data Centers** resource tab and select the data center to remove.
2.  Click **Force Remove** to open the **Force Remove Data Center** confirmation window.
3.  Select the **Approve operation** check box.
4.  Click **OK**

**Result**

The data center and attached storage domain are permanently removed from the oVirt environment.

#### Changing the Data Center Compatibility Version

**Summary**

oVirt data centers have a compatibility version. The compatibility version indicates the version of oVirt that the data center is intended to be compatible with. All clusters in the data center must support the desired compatibility level.

<div class="alert alert-info">
**Note:** To change the data center compatibility version, you must have first updated all the clusters in your data center to a level that supports your desired compatibility level.

</div>
⁠

**Procedure 3.8. Changing the Data Center Compatibility Version**

1.  Click the **Data Centers** resource tab and select the data center to remove.
2.  Select the data center to change from the list displayed. If the list of data centers is too long to filter visually, then perform a search to locate the desired data center.
3.  Click the **Edit** button.
4.  Change the **Compatibility Version** to the desired value.
5.  Click **OK**.

**Result**

You have updated the compatibility version of the data center.

<div class="alert alert-info">
**Warning:** Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center. If you are upgrading the compatibility version from below 3.1 to a higher version, these storage domains will become unusable with versions older than 3.1.

</div>

### Data Centers and Storage Domains

#### Attaching an Existing Data Domain to a Data Center

**Summary**

Data domains that are **Unattached** can be attached to a data center. The data domain must be of the same **Storage Type** as the data center.

⁠

**Procedure 3.9. Attaching an Existing Data Domain to a Data Center**

1.  Click the **Data Centers** resource tab and select the appropriate data center.
2.  Select the **Storage** tab in the details pane to list the storage domains already attached to the data center.
3.  Click **Attach Data** to open the **Attach Storage** window.
4.  Select the check box for the data domain to attach to the data center. You can select multiple check boxes to attach multiple data domains.
5.  Click **OK**.

**Result**

The data domain is attached to the data center and is automatically activated.

<div class="alert alert-info">
**Note:** In oVirt 3.4, shared storage domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center.

</div>

#### Attaching an Existing ISO domain to a Data Center

**Summary**

An ISO domain that is **Unattached** can be attached to a data center. The ISO domain must be of the same **Storage Type** as the data center. Only one ISO domain can be attached to a data center.

**Procedure 3.10. Attaching an Existing ISO Domain to a Data Center**

1.  Click the **Data Centers** resource tab and select the appropriate data center.
2.  Select the **Storage** tab in the details pane to list the storage domains already attached to the data center.
3.  Click **Attach ISO** to open the **Attach ISO Library** window.
4.  Click the radio button for the appropriate ISO domain.
5.  Click **OK**.

**Result**

The ISO domain is attached to the data center and is automatically activated.

#### Attaching an Existing Export Domain to a Data Center

**Summary**

An export domain that is **Unattached** can be attached to a data center.

Only one export domain can be attached to a data center.

⁠

**Procedure 3.11. Attaching an Existing Export Domain to a Data Center**

1.  Click the **Data Centers** resource tab and select the appropriate data center.
2.  Select the **Storage** tab in the details pane to list the storage domains already attached to the data center.
3.  Click **Attach Export** to open the **Attach Export Domain** window.
4.  Click the radio button for the appropriate Export domain.
5.  Click **OK**.

**Result**

The Export domain is attached to the data center and is automatically activated.

#### Detaching a Storage Domain from a Data Center

**Summary**

Detaching a storage domain from a data center will stop the data center from associating with that storage domain. The storage domain is not removed from the oVirt environment; it can be attached to another data center.

Data, such as virtual machines and templates, remains attached to the storage domain.

<div class="alert alert-info">
**Note:** The master storage, if it is the last available storage domain, cannot be removed.

</div>
⁠

**Procedure 3.12. Detaching a Storage Domain from a Data Center**

1.  Click the **Data Centers** resource tab and select the appropriate data center.
2.  Select the **Storage** tab in the details pane to list the storage domains attached to the data center.
3.  Select the storage domain to detach. If the storage domain is `Active`, click **Maintenance** to open the **Maintenance Storage Domain(s)** confirmation window.
4.  Click **OK** to initiate maintenance mode.
5.  Click **Detach** to open the **Detach Storage** confirmation window.
6.  Click **OK**.

**Result**

You have detached the storage domain from the data center. It can take up to several minutes for the storage domain to disappear from the details pane.

#### Activating a Storage Domain from Maintenance Mode

**Summary**

Storage domains in maintenance mode must be activated to be used.

⁠

**Procedure 3.13. Activating a Data Domain from Maintenance Mode**

1.  Click the **Data Centers** resource tab and select the appropriate data center.
2.  Select the **Storage** tab in the details pane to list the storage domains attached to the data center.
3.  Select the appropriate storage domain and click **Activate**.

**Result**

The storage domain is activated and can be used in the data center.

## ⁠Clusters

### Introduction to Clusters

A cluster is a logical grouping of hosts that share the same storage domains and have the same type of CPU (either Intel or AMD). If the hosts have different generations of CPU models, they use only the features present in all models.

Each cluster in the system must belong to a data center, and each host in the system must belong to a cluster. Virtual machines are dynamically allocated to any host in a cluster and can be migrated between them, according to policies defined on the **Clusters** tab and in the Configuration tool during runtime. The cluster is the highest level at which power and load-sharing policies can be defined.

Clusters run virtual machines or Red Hat Storage Servers. These two purposes are mutually exclusive: A single cluster cannot support virtualization and storage hosts together.

The oVirt platform installs a default cluster in the default data center by default during the installation process.

### Cluster Tasks

#### Creating a New Cluster

**Summary**

A data center can contain multiple clusters, and a cluster can contain multiple hosts. All hosts in a cluster must be of the same CPU type (Intel or AMD). It is recommended that you create your hosts before you create your cluster to ensure CPU type optimization. However, you can configure the hosts at a later time using the **Guide Me** button.

⁠

**Procedure 4.1. Creating a New Cluster**

1.  Select the **Clusters** resource tab.
2.  Click **New** to open the **New Cluster** window.
3.  Select the **Data Center** the cluster will belong to from the drop-down list.
4.  Enter the **Name** and **Description** of the cluster.
5.  Select the **CPU Name** and **Compatibility Version** from the drop-down lists. It is important to match the CPU processor family with the minimum CPU processor type of the hosts you intend to attach to the cluster, otherwise the host will be non-operational.
6.  Click the **Optimization** tab to select the memory page sharing threshold for the cluster, and optionally enable CPU thread handling, memory ballooning, and KSM control on the hosts in the cluster.
7.  Click the **Cluster Policy** tab to optionally configure a cluster policy, scheduler optimization settings, enable trusted service for hosts in the cluster, and enable HA Reservation.
8.  Click the **Resilience Policy** tab to select the virtual machine migration policy.
9.  Click the **Console** tab to optionally override the global SPICE proxy, if any, and specify the address of a SPICE proxy for hosts in the cluster.
10. Click **OK** to create the cluster and open the **New Cluster - Guide Me** window.
11. The **Guide Me** window lists the entities that need to be configured for the cluster. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the cluster and clicking the **Guide Me** button.

**Result**

The new cluster is added to the virtualization environment.

#### Explanation of Settings and Controls in the New Cluster and Edit Cluster Windows

##### General Cluster Settings Explained

![New Cluster window|400px](New_Cluster_Window.png "New Cluster window|400px")

**Figure 4.1. New Cluster window**

The table below describes the settings for the **General** tab in the **New Cluster** and **Edit Cluster** windows. Invalid entries are outlined in orange when you click **OK**, prohibiting the changes being accepted. In addition, field prompts indicate the expected values or range of values.

⁠

**Table 4.1. General Cluster Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center that will contain the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>The description of the cluster. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>CPU Name</strong></p></td>
<td align="left"><p>The CPU type of the cluster. Choose one of:</p>
<ul>
<li>Intel Conroe Family</li>
<li>Intel Penryn Family</li>
<li>Intel Nehalem Family</li>
<li>Intel Westmere Family</li>
<li>Intel SandyBridge Family</li>
<li>Intel Haswell Family</li>
<li>AMD Opteron G1</li>
<li>AMD Opteron G2</li>
<li>AMD Opteron G3</li>
<li>AMD Opteron G4</li>
<li>AMD Opteron G5</li>
<li>IBM POWER 7 v2.0</li>
<li>IBM POWER 7 v2.1</li>
<li>IBM POWER 7 v2.3</li>
<li>IBM POWER 7+ v2.1</li>
<li>IBM POWER 8 v1.0</li>
</ul>
<p>All hosts in a cluster must run the same CPU type (Intel or AMD); this cannot be changed after creation without significant disruption. The CPU type should be set for the least powerful host. For example: an <strong>Intel SandyBridge</strong> host can attach to an <strong>Intel Penryn</strong> cluster; an <strong>Intel Conroe</strong> host cannot. Hosts with different CPU models will only use features present in all models.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Compatibility Version</strong></p></td>
<td align="left"><p>The version of oVirt. Choose one of:</p>
<ul>
<li>3.0</li>
<li>3.1</li>
<li>3.2</li>
<li>3.3</li>
<li>3.4</li>
</ul>
<p>You will not be able to select a version older than the version specified for the data center.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>CPU Architecture</strong></p></td>
<td align="left"><p>The architecture of the cluster. Choose either:</p>
<ul>
<li>x86_64</li>
<li>ppc64</li>
</ul></td>
</tr>
</tbody>
</table>

##### Optimization Settings Explained

Memory page sharing allows virtual machines to use up to 200% of their allocated memory by utilizing unused memory in other virtual machines. This process is based on the assumption that the virtual machines in your oVirt environment will not all be running at full capacity at the same time, allowing unused memory to be temporarily allocated to a particular virtual machine.

CPU Thread Handling allows hosts to run virtual machines with a total number of processor cores greater than number of cores in the host. This is useful for non-CPU-intensive workloads, where allowing a greater number of virtual machines to run can reduce hardware requirements. It also allows virtual machines to run with CPU topologies that would otherwise not be possible, specifically if the number of guest cores is between the number of host cores and number of host threads.

The table below describes the settings for the **Optimization** tab in the **New Cluster** and **Edit Cluster** windows.

⁠

**Table 4.2. Optimization Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Memory Optimization</strong></p></td>
<td align="left"><ul>
<li><strong>None - Disable memory page sharing</strong>: Disables memory page sharing.</li>
<li><strong>For Server Load - Enable memory page sharing to 150%</strong>: Sets the memory page sharing threshold to 150% of the system memory on each host.</li>
<li><strong>For Desktop Load - Enable memory page sharing to 200%</strong>: Sets the memory page sharing threshold to 200% of the system memory on each host.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>CPU Threads</strong></p></td>
<td align="left"><p>Selecting the <strong>Count Threads As Cores</strong> check box allows hosts to run virtual machines with a total number of processor cores greater than the number of cores in the host. The exposed host threads would be treated as cores which can be utilized by virtual machines. For example, a 24-core system with 2 threads per core (48 threads total) can run virtual machines with up to 48 cores each, and the algorithms to calculate host CPU load would compare load against twice as many potential utilized cores.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Memory Balloon</strong></p></td>
<td align="left"><p>Selecting the <strong>Enable Memory Balloon Optimization</strong> check box enables memory overcommitment on virtual machines running on the hosts in this cluster. When this option is set, the Memory Overcommit Manager (MoM) will start ballooning where and when possible, with a limitation of the guaranteed memory size of every virtual machine. To have a balloon running, the virtual machine needs to have a balloon device with relevant drivers. Each virtual machine in cluster level 3.2 and higher includes a balloon device, unless specifically removed. Each host in this cluster receives a balloon policy update when its status changes to <code>Up</code>. It is important to understand that in some scenarios ballooning may collide with KSM. In such cases MoM will try to adjust the balloon size to minimize collisions. Additionally, in some scenarios ballooning may cause sub-optimal performance for a virtual machine. Administrators are advised to use ballooning optimization with caution.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>KSM control</strong></p></td>
<td align="left"><p>Selecting the <strong>Enable KSM</strong> check box enables MoM to run Kernel Same-page Merging (KSM) when necessary and when it can yield a memory saving benefit that outweighs its CPU cost.</p></td>
</tr>
</tbody>
</table>

##### Resilience Policy Settings Explained

The resilience policy sets the virtual machine migration policy in the event of host failure. Virtual machines running on a host that unexpectedly shuts down or is put into maintenance mode are migrated to other hosts in the cluster; this migration is dependent upon your cluster policy.

<div class="alert alert-info">
**Note:** Virtual machine migration is a network-intensive operation. For instance, on a setup where a host is running ten or more virtual machines, migrating all of them can be a long and resource-consuming process. Therefore, select the policy action to best suit your setup. If you prefer a conservative approach, disable all migration of virtual machines. Alternatively, if you have many virtual machines, but only several which are running critical workloads, select the option to migrate only highly available virtual machines.

</div>
The table below describes the settings for the **Resilience Policy** tab in the **New Cluster** and **Edit Cluster** windows.

⁠ **Table 4.3. Resilience Policy Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Migrate Virtual Machines</strong></p></td>
<td align="left"><p>Migrates all virtual machines in order of their defined priority.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Migrate only Highly Available Virtual Machines</strong></p></td>
<td align="left"><p>Migrates only highly available virtual machines to prevent overloading other hosts.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Do Not Migrate Virtual Machines</strong></p></td>
<td align="left"><p>Prevents virtual machines from being migrated.</p></td>
</tr>
</tbody>
</table>

##### Cluster Policy Settings Explained

Cluster policies allow you to specify the usage and distribution of virtual machines between available hosts. Define the cluster policy to enable automatic load balancing across the hosts in a cluster.

⁠

![Editing a cluster's load balancing policy.](Cluster_Window_Policy.png "Editing a cluster's load balancing policy.")

**Figure 4.2. Cluster Policy Settings: Power_Saving**

⁠

![Editing a cluster's load balancing policy.](Cluster_Window_Policy_VM_evenly.png "Editing a cluster's load balancing policy.")

**Figure 4.3. Cluster Policy Settings: VM_Evenly_Distributed**

The table below describes the settings for the **Edit Policy** window.

⁠

**Table 4.4. Cluster Policy Tab Properties**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field/Tab</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>None</strong></p></td>
<td align="left"><p>Set the policy value to <strong>None</strong> to have no load or power sharing between hosts. This is the default mode.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Evenly_Distributed</strong></p></td>
<td align="left"><p>Distributes the CPU processing load evenly across all hosts in the cluster. Additional virtual machines attached to a host will not start if that host has reached the defined Maximum Service Level.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Power_Saving</strong></p></td>
<td align="left"><p>Distributes the CPU processing load across a subset of available hosts to reduce power consumption on underutilized hosts. Hosts with a CPU load below the low utilization value for longer than the defined time interval will migrate all virtual machines to other hosts so that it can be powered down. Additional virtual machines attached to a host will not start if that host has reached the defined high utilization value.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VM_Evenly_Distributed</strong></p></td>
<td align="left"><p>Distributes virtual machines evenly between hosts based on a count of the virtual machines.</p>
<ul>
<li><strong>HighVmCount</strong>: Sets the maximum number of virtual machines that can run on each host. Exceeding this limit qualifies the host as overloaded.</li>
<li><strong>MigrationThreshold</strong>: Defines a buffer before virtual machines are migrated from the host. It is the maximum inclusive difference in virtual machine count between the most highly-utilized host and the least-utilized host. The cluster is balanced when every host in the cluster has a virtual machine count that falls inside the migration threshold.</li>
<li><strong>SpmVmGrace</strong>: Defines the number of slots for virtual machines to be reserved on SPM hosts. The SPM host will have a lower load than other hosts, so this variable defines how many fewer virtual machines than other hosts it can run.</li>
</ul>
<p>The cluster is considered unbalanced if any host is running more virtual machines than the <strong>HighVmCount</strong> and there is at least one host with a virtual machine count that falls outside of the <strong>MigrationThreshold</strong>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>CpuOverCommitDurationMinutes</strong></p></td>
<td align="left"><p>Sets the time (in minutes) that a host can run a CPU load outside of the defined utilization values before the cluster policy takes action. The defined time interval protects against temporary spikes in CPU load activating cluster policies and instigating unnecessary virtual machine migration. Maximum two characters.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>HighUtilization</strong></p></td>
<td align="left"><p>Expressed as a percentage. If the host runs with CPU usage at or above the high utilization value for the defined time interval, oVirt migrates virtual machines to other hosts in the cluster until the host's CPU load is below the maximum service threshold.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>LowUtilization</strong></p></td>
<td align="left"><p>Expressed as a percentage. If the host runs below the low utilization value for the defined time interval, oVirt will migrate virtual machines to other hosts in the cluster. oVirt will power down the original host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Scheduler Optimization</strong></p></td>
<td align="left"><p>Optimize scheduling for host weighing/ordering.</p>
<ul>
<li><strong>Optimize for Utilization</strong>: Includes weight modules in scheduling to allow best selection.</li>
<li><strong>Optimize for Speed</strong>: Skips host weighting in cases where there are more than ten pending requests.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Enable Trusted Service</strong></p></td>
<td align="left"><p>Enable integration with an OpenAttestation server. Before this can be enabled, use the <code>engine-config</code> tool to enter the OpenAttestation server's details.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Enable HA Reservation</strong></p></td>
<td align="left"><p>Enable oVirt to monitor cluster capacity for highly available virtual machines. oVirt ensures that appropriate capacity exists within a cluster for virtual machines designated as highly available to migrate in the event that their existing host fails unexpectedly.</p></td>
</tr>
</tbody>
</table>

When a host's free memory drops below 20%, ballooning commands like `mom.Controllers.Balloon - INFO Ballooning guest:half1 from 1096400 to 1991580` are logged to `/var/log/vdsm/mom.log`. `/var/log/vdsm/mom.log` is the Memory Overcommit Manager log file.

##### Cluster Console Settings Explained

The following table details the information required on the **Console** tab of the **New Cluster** or **Edit Cluster** window.

⁠

**Table 4.5. Console settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Define SPICE Proxy for Cluster</strong></p></td>
<td align="left"><p>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hypervisors reside.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Overridden SPICE proxy address</strong></p></td>
<td align="left"><p>The proxy by which the SPICE client will connect to virtual machines. The address must be in the following format:</p>
<pre><code>protocol://[host]:[port]</code></pre></td>
</tr>
</tbody>
</table>

#### Editing a Resource

**Summary**

Edit the properties of a resource.

⁠

**Procedure 4.2. Editing a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click **Edit** to open the **Edit** window.
3.  Change the necessary properties and click **OK**.

**Result**

The new properties are saved to the resource. The **Edit** window will not close if a property field is invalid.

#### Setting Load and Power Management Policies for Hosts in a Cluster

**Summary**

Cluster policies allow you to specify acceptable CPU usage values, both high and low, and what happens when those levels are reached. Define the cluster policy to enable automatic load balancing across the hosts in a cluster.

A host with CPU usage that exceeds the **HighUtilization** value will reduce its CPU processor load by migrating virtual machines to other hosts.

A host with CPU usage below its **LowUtilization** value will migrate all of its virtual machines to other hosts so it can be powered down until such time as it is required again.

⁠

**Procedure 4.3. Setting Load and Power Management Policies for Hosts**

1.  Use the resource tabs, tree mode, or the search function to find and select the cluster in the results list.
2.  Click the **Edit** button to open the **Edit Cluster** window.
    ⁠

    ![Edit Cluster Policy](Edit_Cluster_Window_Policy.png "Edit Cluster Policy")

    **Figure 4.4. Edit Cluster Policy**

3.  Select one of the following policies:
    -   **None**
    -   **VM_Evenly_Distributed** - Enter the maximum number of virtual machines that can run on each host in **HighVmCount** field.
    -   **Evenly_Distributed** - Enter CPU utilization percentage at which virtual machines start migrating to other hosts in the **HighUtilization** text field.
    -   **Power Saving** - Enter the CPU utilization percentage below which the host will be considered under-utilized in the **LowUtilization** text field. Enter the CPU utilization percentage at which virtual machines start migrating to other hosts in the **HighUtilization** text field

4.  Specify the time interval in minutes at which the selected policy will be triggered in the **CpuOverCommitDurationMinutes** text field.
5.  If you are using an OpenAttestation server to verify your hosts, and have set up the server's details using the `engine-config` tool, select the **Enable Trusted Service** check box.
6.  Click **OK**.

**Result**

You have updated the cluster policy for the cluster.

#### Creating a New Logical Network in a Data Center or Cluster

**Summary**

Create a logical network and define its use in a data center, or in clusters in a data center.

⁠

**Procedure 4.4. Creating a New Logical Network in a Data Center or Cluster**

1.  Use the **Data Centers** or **Clusters** resource tabs, tree mode, or the search function to find and select a data center or cluster in the results list.
2.  Click the **Logical Networks** tab of the details pane to list the existing logical networks.
3.  From the **Data Centers** details pane, click **New** to open the **New Logical Network** window. From the **Clusters** details pane, click **Add Network** to open the **New Logical Network** window.
4.  Enter a **Name**, **Description** and **Comment** for the logical network.
5.  In the **Export** section, select the **Create on external provider** check box to create the logical network on an external provider. Select the external provider from the **External Provider** drop-down menu.
6.  In the **Network Parameters** section, select the **Enable VLAN tagging**, **VM network** and **Override MTU** to enable these options.
7.  Enter a new label or select an existing label for the logical network in the **Network Label** text field.
8.  From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.
9.  If the **Create on external provider** check box is selected, the **Subnet** tab will be visible. From the **Subnet** tab enter a **Name**, **CIDR** and select an **IP Version** for the subnet that the logical network will provide.
10. From the **Profiles** tab, add vNIC profiles to the logical network as required.
11. Click **OK**.

**Result**

You have defined a logical network as a resource required by a cluster or clusters in the data center. If you entered a label for the logical network, it will be automatically added to all host network interfaces with that label.

<div class="alert alert-info">
**Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.

</div>

#### Removing a Cluster

**Summary**

Move all hosts out of a cluster before removing it.

<div class="alert alert-info">
**Note:** You cannot remove the **Default** cluster, as it holds the **Blank** template. You can however rename the **Default** cluster and add it to a new data center.

</div>
⁠

**Procedure 4.5. Removing a Cluster**

1.  Use the resource tabs, tree mode, or the search function to find and select the cluster to be removed in the results list.
2.  Ensure there are no hosts in the cluster.
3.  Click **Remove** to open the **Remove Cluster(s)** confirmation window.
4.  Click **OK**

**Result**

The cluster is removed.


#### Designate a Specific Traffic Type for a Logical Network with the Manage Networks Window


**Summary**

Specify the traffic type for the logical network to optimize the network traffic flow.

⁠

**Procedure 4.6. Assigning or Unassigning a Logical Network to a Cluster**

1.  Use the **Clusters** resource tab, tree mode, or the search function to find and select the cluster in the results list.
2.  Select the **Logical Networks** tab in the details pane to list the logical networks assigned to the cluster.
3.  Click **Manage Networks** to open the **Manage Networks** window.
    ⁠

    ![The Manage Networks window](Manage_Networks.png "The Manage Networks window")

    **Figure 4.5. Manage Networks**

4.  Select appropriate check boxes.
5.  Click **OK** to save the changes and close the window.

**Result**

You have optimized the network traffic flow by assigning a specific type of traffic to be carried on a specific logical network.

<div class="alert alert-info">
**Note:** Networks offered by external providers cannot be used as display networks.

</div>

#### Explanation of Settings in the Manage Networks Window

The table below describes the settings for the **Manage Networks** window.

⁠

**Table 4.6. Manage Networks Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Assign</strong></p></td>
<td align="left"><p>Assigns the logical network to all hosts in the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Required</strong></p></td>
<td align="left"><p>A Network marked "required" must remain operational in order for the hosts associated with it to function properly. If a required network ceases to function, any hosts associated with it become non-operational.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>VM Network</strong></p></td>
<td align="left"><p>A logical network marked "VM Network" carries network traffic relevant to the virtual machine network.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Display Network</strong></p></td>
<td align="left"><p>A logical network marked "Display Network" carries network traffic relevant to SPICE and to the virtual network controller.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Migration Network</strong></p></td>
<td align="left"><p>A logical network marked "Migration Network" carries virtual machine and storage migration traffic.</p></td>
</tr>
</tbody>
</table>

#### Changing the Cluster Compatibility Version

**Summary**

oVirt clusters have a compatibility version. The cluster compatibility version indicates the features of oVirt supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

<div class="alert alert-info">
**Note:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

</div>
⁠

**Procedure 4.7. Changing the Cluster Compatibility Version**

1.  Use the **Clusters** resource tab, tree mode, or the search function to find and select the cluster in the results list.
2.  Click the **Edit** link. The Edit Cluster window will open.
3.  Change the **Compatibility Version** to the desired value.
4.  Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.
5.  Click **OK** to confirm.

**Result**

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, then you are also able to change the compatibility version of the data center itself.

<div class="alert alert-info">
**Warning:** Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center. If you are upgrading the compatibility version from below 3.1 to a higher version, these storage domains will become unusable with versions older than 3.1.

</div>

## Logical Networks

### Introduction to Logical Networks

A logical network is a named set of global network connectivity properties in your data center. When a logical network is added to a host, it may be further configured with host-specific network parameters. Logical networks optimize network flow by grouping network traffic by usage, type, and requirements.

Logical networks allow both connectivity and segregation. You can create a logical network for storage communication to optimize network traffic between hosts and storage domains, a logical network specifically for all virtual machine traffic, or multiple logical networks to carry the traffic of groups of virtual machines.

The default logical network in all data centers is the management network called `ovirtmgmt`. The `ovirtmgmt` network carries all traffic, until another logical network is created. It is meant especially for management communication between oVirt and hosts.

A logical network is a data center level resource; creating one in a data center makes it available to the clusters in a data center. A logical network that has been designated a **Required** must be configured in all of a cluster's hosts before it is operational. **Optional networks** can be used by any host they have been added to.

<div class="alert alert-info">
**Warning:** Do not change networking in a data center or a cluster if any hosts are running as this risks making the host unreachable.

</div>
<div class="alert alert-info">
**Important:** If you plan to use oVirt nodes to provide any services, remember that the services will stop if the oVirt environment stops operating.

This applies to all services, but you should be especially aware of the hazards of running the following on oVirt:

*   Directory Services
*   DNS
*   Storage

</div>

### Port Mirroring

Port mirroring copies layer 3 network traffic on a given logical network and host to a virtual interface on a virtual machine. This virtual machine can be used for network debugging and tuning, intrusion detection, and monitoring the behavior of other virtual machines on the same host and logical network.

The only traffic copied is internal to one logical network on one host. There is no increase on traffic on the network external to the host; however a virtual machine with port mirroring enabled uses more host CPU and RAM than other virtual machines.

Enable and disable port mirroring by editing network interfaces on virtual machines.

Port mirroring requires an IPv4 IP address.

Hotplugging profiles with port mirroring is not supported.

As of oVirt 3.4, port mirroring has been included in vNIC profiles. Port mirroring cannot be altered when the vNIC profile associated with port mirroring is attached to a virtual machine. To use port mirroring, create a dedicated vNIC profile that has port mirroring enabled.

<div class="alert alert-info">
**Important:** Enabling port mirroring reduces the privacy of other network users.

</div>

### Required Networks, Optional Networks, and Virtual Machine Networks

oVirt 3.1 and higher distinguishes between required networks and optional networks.

**Required** networks must be applied to all hosts in a cluster for the cluster and network to be **Operational**. Logical networks are added to clusters as **Required** networks by default.

When a required network becomes non-operational, the virtual machines running on the network are fenced and migrated to another host. This is beneficial if you have machines running mission critical workloads.

When a non-required network becomes non-operational, the virtual machines running on the network are not migrated to another host. This prevents unnecessary I/O overload caused by mass migrations.

Optional networks are those logical networks that have not been explicitly declared **Required** networks. Optional networks can be implemented on only the hosts that use them. The presence or absence of these networks does not affect the **Operational** status of a host.

Use the **Manage Networks** button to change a network's **Required** designation.

Virtual machine networks (called a **VM network** in the user interface) are logical networks designated to carry only virtual machine network traffic. Virtual machine networks can be required or optional.

<div class="alert alert-info">
**Note:** A virtual machine with a network interface on an optional virtual machine network will not start on a host without the network.

</div>

### vNIC Profiles and QoS

#### vNIC Profile Overview

A Virtual Network Interface Card (vNIC) profile is a collection of settings that can be applied to individual virtual network interface cards in oVirt. vNIC profiles allow you to apply Network QoS profiles to a vNIC, enable or disable port mirroring, and add or remove custom properties. vNIC profiles offer an added layer of administrative flexibility in that permission to use (consume) these profiles can be granted to specific users. In this way, you can control the quality of service that different users receive from a given network.

<div class="alert alert-info">
**Note:** Starting with oVirt 3.3, virtual machines now access logical networks only through vNIC profiles and cannot access a logical network if no vNIC profiles exist for that logical network. When you create a new logical network in oVirt, a vNIC profile of the same name as the logical network is automatically created under that logical network.

</div>

#### Creating a vNIC Profile

**Summary**

Create a Virtual Network Interface Controller (vNIC) profile to regulate network bandwidth for users and groups.

**Procedure 5.1. Creating a vNIC Profile**

1.  Use the **Networks** resource tab, tree mode, or the search function to select a logical network in the results pane.
2.  Select the **Profiles** tab in the details pane to display available vNIC profiles. If you selected the logical network in tree mode, you can select the **vNIC Profiles** tab in the results list.
3.  Click **New** to open the **VM Interface Profile** window.
    ⁠

    ![The VM Interface Profile window|350px](VM_Interface_Profile.png "The VM Interface Profile window|350px")

    **Figure 5.1. The VM Interface Profile window**

4.  Enter the **Name** and **Description** of the profile.
5.  Use the **QoS** drop-down menu to select the relevant Quality of Service policy to apply to the vNIC profile.
6.  Use the **Port Mirroring** and **Allow all users to use this Profile** check boxes to toggle these options.
7.  Use the custom properties drop-down menu, which displays **Please select a key...** by default, to select a custom property and use the **+** and **-** buttons to add additional custom properties or remove existing custom properties.
8.  Click **OK** to save the profile and close the window.

**Result**

You have created a vNIC profile. Apply this profile to users and groups to regulate their network bandwidth.

#### Assigning Security Groups to vNIC Profiles

**Summary**

You can assign security groups to the vNIC profile of networks that have been imported from an OpenStack Networking instance and that use the Linux Bridge or Open vSwitch plug-ins. A security group is a collection of strictly enforced rules that allow you to filter inbound and outbound traffic over a network interface. The following procedure outlines how to attach a security group to a vNIC profile.

⁠

**Procedure 5.2. Assigning Security Groups to vNIC Profiles**

1.  Click the **Networks** tab and select a logical network in the results list.
2.  Click the **vNIC Profiles** tab in the details pane.
3.  Click **New** or select an existing vNIC profile and click **Edit** to open the **VM Interface Profile** window.
4.  From the custom properties drop-down menu, select **SecurityGroups**.
5.  In the text field to the right of the custom properties drop-down menu, enter the ID of the security group to attach to the vNIC profile.
6.  Click **OK**.

<div class="alert alert-info">
**Note:** A security group is identified using the ID of that security group as registered in the OpenStack Networking instance. You can find the IDs of security groups for a given tenant by running the following command on the system on which OpenStack Networking is installed:

    # neutron security-group-list

</div>
**Result**

You have attached a security group to the vNIC profile and all traffic through the logical network to which that profile is attached will be filtered in accordance with the rules defined for that security group.

#### Explanation of Settings in the VM Interface Profile Window

**Table 5.1. VM Interface Profile Window**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Network</strong></p></td>
<td align="left"><p>A drop-down menu of the available networks to apply the vNIC profile.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the vNIC profile. This must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores between 1 and 50 characters.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>The description of the vNIC profile. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>QoS</strong></p></td>
<td align="left"><p>A drop-down menu of the available Network Quality of Service policies to apply to the vNIC profile. QoS policies regulate inbound and outbound network traffic of the vNIC.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Port Mirroring</strong></p></td>
<td align="left"><p>A check box to toggle port mirroring. Port mirroring copies layer 3 network traffic on the logical network to a virtual interface on a virtual machine. It it not selected by default.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Device Custom Properties</strong></p></td>
<td align="left"><p>A drop-down menu to select available custom properties to apply to the VNIC profile. Use the <strong>+</strong> and <strong>-</strong> buttons to add and remove properties respectively.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Allow all users to use this Profile</strong></p></td>
<td align="left"><p>A check box to toggle the availability of the profile to all users in the environment. It is selected by default.</p></td>
</tr>
</tbody>
</table>

#### Removing a vNIC Profile

**Summary**

Remove a vNIC profile to delete it from your virtualized environment.

**Procedure 5.3. Removing a vNIC Profile**

1.  Use the **Networks** resource tab, tree mode, or the search function to select a logical network in the results pane.
2.  Select the **Profiles** tab in the details pane to display available vNIC profiles. If you selected the logical network in tree mode, you can select the **vNIC Profiles** tab in the results list.
3.  Select one or more profiles and click **Remove** to open the **Remove VM Interface Profile(s)** window.
4.  Click **OK** to remove the profile and close the window.

**Result**

You have removed the vNIC profile.

#### User Permissions for vNIC Profiles

**Summary**

Configure user permissions to assign users to certain vNIC profiles. Assign the **VnicProfileUser** role to a user to enable them to use the profile. Restrict users from certain profiles by removing their permission for that profile.

**Procedure 5.4. User Permissions for vNIC Profiles**

1.  Use tree mode to select a logical network.
2.  Select the **vNIC Profiles** resource tab to display the VNIC profiles.
3.  Select the **Permissions** tab in the details pane to show the current user permissions for the profile.
4.  Use the **Add** button to open the **Add Permission to User** window, and the **Remove** button to open the **Remove Permission** window, to affect user permissions for the vNIC profile.

**Result**

You have configured user permissions for a VNIC profile.

#### QoS Overview

Network QoS is a feature that allows you to create profiles for limiting both the inbound and outbound traffic of individual virtual NIC. With this feature, you can limit bandwidth in a number of layers, controlling the consumption of network resources.

<div class="alert alert-info">
**Important:** Network QoS is only supported on cluster compatibility version 3.3 and higher.

</div>

#### Adding QoS

**Summary**

Create a QoS profile to regulate network traffic when applied to a vNIC profile, also known as VM Interface profile.

**Procedure 5.5. Creating a QoS profile**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to display and select a data center in the results list.
2.  Select the **Network QoS** tab in the details pane to display the available QoS profiles.
3.  Click **New** to open the **New Network QoS** window.
4.  Enter the **Name** of the profile.
5.  Enter the limits for the **Inbound** and **Outbound** network traffic.
6.  Click **OK** to save the changes and close the window.

**Summary**

You have created a QoS Profile that can be used in a vNIC profile, also known as VM Interface profile.

#### Settings in the New Network QoS and Edit Network QoS Windows Explained

Network QoS settings allow you to configure bandwidth limits for both inbound and outbound traffic on three distinct levels.

**Table 5.2. Network QoS Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center to which the Network QoS policy is to be added. This field is configured automatically according to the selected data center.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>A name to represent the network QoS policy within oVirt.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Inbound</strong></p></td>
<td align="left"><p>The settings to be applied to inbound traffic. Select or clear the <strong>Inbound</strong> check box to enable or disable these settings.</p>
<ul>
<li><strong>Average</strong>: The average speed of inbound traffic.</li>
<li><strong>Peak</strong>: The speed of inbound traffic during peak times.</li>
<li><strong>Burst</strong>: The speed of inbound traffic during bursts.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Outbound</strong></p></td>
<td align="left"><p>The settings to be applied to outbound traffic. Select or clear the <strong>Outbound</strong> check box to enable or disable these settings.</p>
<ul>
<li><strong>Average</strong>: The average speed of outbound traffic.</li>
<li><strong>Peak</strong>: The speed of outbound traffic during peak times.</li>
<li><strong>Burst</strong>: The speed of outbound traffic during bursts.</li>
</ul></td>
</tr>
</tbody>
</table>

####  Removing QoS

**Summary**

Remove a QoS profile from your virtualized environment.

**Procedure 5.6. Removing a QoS profile**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to display and select a data center in the results list.
2.  Select the **Network QoS** tab in the details pane to display the available QoS profiles.
3.  Select the QoS profile to remove and click **Remove** to open the **Remove Network QoS** window. This window will list what, if any, vNIC profiles are using the selected QoS profile.
4.  Click **OK** to save the changes and close the window.

**Result**

You have removed the QoS profile.

### Logical Network Tasks

#### Creating a New Logical Network in a Data Center or Cluster

**Summary**

Create a logical network and define its use in a data center, or in clusters in a data center.

⁠

**Procedure 5.7. Creating a New Logical Network in a Data Center or Cluster**

1.  Use the **Data Centers** or **Clusters** resource tabs, tree mode, or the search function to find and select a data center or cluster in the results list.
2.  Click the **Logical Networks** tab of the details pane to list the existing logical networks.
3.  From the **Data Centers** details pane, click **New** to open the **New Logical Network** window. From the **Clusters** details pane, click **Add Network** to open the **New Logical Network** window.
4.  Enter a **Name**, **Description** and **Comment** for the logical network.
5.  In the **Export** section, select the **Create on external provider** check box to create the logical network on an external provider. Select the external provider from the **External Provider** drop-down menu.
6.  In the **Network Parameters** section, select the **Enable VLAN tagging**, **VM network** and **Override MTU** to enable these options.
7.  Enter a new label or select an existing label for the logical network in the **Network Label** text field.
8.  From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.
9.  If the **Create on external provider** check box is selected, the **Subnet** tab will be visible. From the **Subnet** tab enter a **Name**, **CIDR** and select an **IP Version** for the subnet that the logical network will provide.
10. From the **Profiles** tab, add vNIC profiles to the logical network as required.
11. Click **OK**.

**Result**

You have defined a logical network as a resource required by a cluster or clusters in the data center. If you entered a label for the logical network, it will be automatically added to all host network interfaces with that label.

<div class="alert alert-info">
**Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.

</div>

#### Explanation of Settings and Controls in the New Cluster and Edit Cluster Windows

##### Logical Network General Settings Explained

The table below describes the settings for the **General** tab of the **New Logical Network** and **Edit Logical Network** window.

⁠

**Table 5.3. New Logical Network and Edit Logical Network Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the logical network. This text field has a 15-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>The description of the logical network. This text field has a 40-character limit.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text, human-readable comments regarding the logical network.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Create on external provider</strong></p></td>
<td align="left"><p>Allows you to create the logical network to an OpenStack Networking instance that has been added to oVirt as an external provider. <strong>External Provider</strong> - Allows you to select the external provider on which the logical network will be created.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Enable VLAN tagging</strong></p></td>
<td align="left"><p>VLAN tagging is a security feature that gives all network traffic carried on the logical network a special characteristic. VLAN-tagged traffic cannot be read by interfaces that do not also have that characteristic. Use of VLANs on logical networks also allows a single network interface to be associated with multiple, differently VLAN-tagged logical networks. Enter a numeric value in the text entry field if VLAN tagging is enabled.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VM Network</strong></p></td>
<td align="left"><p>Select this option if only virtual machines use this network. If the network is used for traffic that does not involve virtual machines, such as storage communications, do not select this check box.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Override MTU</strong></p></td>
<td align="left"><p>Set a custom maximum transmission unit for the logical network. You can use this to match the maximum transmission unit supported by your new logical network to the maximum transmission unit supported by the hardware it interfaces with. Enter a numeric value in the text entry field if <strong>Override MTU</strong> is selected.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Network Label</strong></p></td>
<td align="left"><p>Allows you to specify a new label for the network or select from a existing labels already attached to host network interfaces. If you select an existing label, the logical network will be automatically assigned to all host network interfaces with that label.</p></td>
</tr>
</tbody>
</table>

##### Logical Network Cluster Settings Explained

The table below describes the settings for the **Cluster** tab of the **New Logical Network** and **Edit Logical Network** window.

**Table 5.4. New Logical Network and Edit Logical Network Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Attach/Detach Network to/from Cluster(s)</strong></p></td>
<td align="left"><p>Allows you to attach or detach the logical network from clusters in the data center and specify whether the logical network will be a required network for individual clusters.</p>
<p><strong>Name</strong> - the name of the cluster to which the settings will apply. This value cannot be edited.</p>
<p><strong>Attach All</strong> - Allows you to attach or detach the logical network to or from all clusters in the data center. Alternatively, select or clear the <strong>Attach</strong> check box next to the name of each cluster to attach or detach the logical network to or from a given cluster.</p>
<p><strong>Required All</strong> - Allows you to specify whether the logical network is a required network on all clusters. Alternatively, select or clear the <strong>Required</strong> check box next to the name of each cluster to specify whether the logical network is a required network for a given cluster.</p></td>
</tr>
</tbody>
</table>

##### Logical Network vNIC Profiles Settings Explained

The table below describes the settings for the **vNIC Profiles** tab of the **New Logical Network** and **Edit Logical Network** window.

**Table 5.5. New Logical Network and Edit Logical Network Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>vNIC Profiles</strong></p></td>
<td align="left"><p>Allows you to specify one or more vNIC profiles for the logical network. You can add or remove a vNIC profile to or from the logical network by clicking the plus or minus button next to the vNIC profile. The first field is for entering a name for the vNIC profile.</p>
<p><strong>Public</strong> - Allows you to specify whether the profile is available to all users.</p>
<p><strong>QoS</strong> - Allows you to specify a network quality of service (QoS) profile to the vNIC profile.</p></td>
</tr>
</tbody>
</table>

#### Editing a Logical Network

**Summary**

Edit the settings of a logical network.

⁠

**Procedure 5.8. Editing a Logical Network**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to find and select the data center of the logical network in the results list.
2.  Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.
3.  Select a logical network and click **Edit** to open the **Edit Logical Network** window.
4.  Edit the necessary settings.
5.  Click **OK** to save the changes.

**Result**

You have updated the settings of your logical network.

<div class="alert alert-info">
**Note:** Multi-host network configuration is available on data centers with 3.1-or-higher compatibility, and automatically applies updated network settings to all of the hosts within the data center to which the network is assigned. Changes can only be applied when virtual machines using the network are down. You cannot rename a logical network that is already configured on a host. You cannot disable the **VM Network** option while virtual machines or templates using that network are running.

</div>

#### Designate a Specific Traffic Type for a Logical Network with the Manage Networks Window

**Summary**

Specify the traffic type for the logical network to optimize the network traffic flow.

**Procedure 5.9. Assigning or Unassigning a Logical Network to a Cluster**

1.  Use the **Clusters** resource tab, tree mode, or the search function to find and select the cluster in the results list.
2.  Select the **Logical Networks** tab in the details pane to list the logical networks assigned to the cluster.
3.  Click **Manage Networks** to open the **Manage Networks** window.
    ⁠

    ![The Manage Networks window|300px](Manage_Networks.png "The Manage Networks window|300px")

    **Figure 5.2. Manage Networks**

4.  Select appropriate check boxes.
5.  Click **OK** to save the changes and close the window.

**Result**

You have optimized the network traffic flow by assigning a specific type of traffic to be carried on a specific logical network.

<div class="alert alert-info">
**Note:** Networks offered by external providers cannot be used as display networks.

</div>

#### Explanation of Settings in the Manage Networks Window

The table below describes the settings for the **Manage Networks** window.

**Table 5.6. Manage Networks Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Assign</strong></p></td>
<td align="left"><p>Assigns the logical network to all hosts in the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Required</strong></p></td>
<td align="left"><p>A Network marked "required" must remain operational in order for the hosts associated with it to function properly. If a required network ceases to function, any hosts associated with it become non-operational.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>VM Network</strong></p></td>
<td align="left"><p>A logical network marked "VM Network" carries network traffic relevant to the virtual machine network.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Display Network</strong></p></td>
<td align="left"><p>A logical network marked "Display Network" carries network traffic relevant to SPICE and to the virtual network controller.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Migration Network</strong></p></td>
<td align="left"><p>A logical network marked "Migration Network" carries virtual machine and storage migration traffic.</p></td>
</tr>
</tbody>
</table>

#### Adding Multiple VLANs to a Single Network Interface Using Logical Networks

**Summary**

Multiple VLANs can be added to a single network interface to separate traffic on the one host.

<div class="alert alert-info">
**Important:** You must have created more than one logical network, all with the **Enable VLAN tagging** check box selected in the **New Logical Network** or **Edit Logical Network** windows.

</div>
**Procedure 5.10. Adding Multiple VLANs to a Network Interface using Logical Networks**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select in the results list a host associated with the cluster to which your VLAN-tagged logical networks are assigned.
2.  Click the **Network Interfaces** tab in the details pane to list the physical network interfaces attached to the data center.
3.  Click **Setup Host Networks** to open the **Setup Host Networks** window.
4.  Drag your VLAN-tagged logical networks into the **Assigned Logical Networks** area next to the physical network interface. The physical network interface can have multiple logical networks assigned due to the VLAN tagging.
    ⁠

    ![Setup Host Networks|400px](Setup_Host_Networks.png "Setup Host Networks|400px")

    **Figure 5.3. Setup Host Networks**

5.  Edit the logical networks by hovering your cursor over an assigned logical network and clicking the pencil icon to open the **Edit Network** window. If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box. Select a **Boot Protocol** from:
    -   **None**,
    -   **DHCP**, or
    -   **Static**, Provide the **IP** and **Subnet Mask**.

    Click **OK**.

6.  Select the **Verify connectivity between Host and Engine** check box to run a network check; this will only work if the host is in maintenance mode.
7.  Select the **Save network configuration** check box
8.  Click **OK**.

Add the logical network to each host in the cluster by editing a NIC on each host in the cluster. After this is done, the network will become operational

**Result**

You have added multiple VLAN-tagged logical networks to a single interface. This process can be repeated multiple times, selecting and editing the same network interface each time on each host to add logical networks with different VLAN tags to a single network interface.

#### Network Labels

Network labels can be used to greatly simplify several administrative tasks associated with creating and administering logical networks and associating those logical networks with physical host network interfaces and bonds.

A network label is a plain text, human readable label that can be attached to a logical network or a physical host network interface. There is no strict limit on the length of label, but you must use a combination of lowercase and uppercase letters, underscores and hyphens; no spaces or special characters are allowed.

Attaching a label to a logical network or physical host network interface creates an association with other logical networks or physical host network interfaces to which the same label has been attached, as follows:

**Network Label Associations**

*   When you attach a label to a logical network, that logical network will be automatically associated with any physical host network interfaces with the given label.
*   When you attach a label to a physical host network interface, any logical networks with the given label will be automatically associated with that physical host network interface.
*   Changing the label attached to a logical network or physical host network interface acts in the same way as removing a label and adding a new label. The association between related logical networks or physical host network interfaces is updated.

**Network Labels and Clusters**

*   When a labeled logical network is added to a cluster and there is a physical host network interface in that cluster with the same label, the logical network is automatically added to that physical host network interface.
*   When a labeled logical network is detached from a cluster and there is a physical host network interface in that cluster with the same label, the logical network is automatically detached from that physical host network interface.

**Network Labels and Logical Networks With Roles**

*   When a labeled logical network is assigned to act as a display network or migration network, that logical network is then configured on the physical host network interface using DHCP so that the logical network can be assigned an IP address.

##### Adding Network Labels to Host Network Interfaces

**Summary**

Using network labels allows you to greatly simplify the administrative workload associated with assigning logical networks to host network interfaces.

**Procedure 5.11. Adding Network Labels to Host Network Interfaces**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select in the results list a host associated with the cluster to which your VLAN-tagged logical networks are assigned.
2.  Click the **Network Interfaces** tab in the details pane to list the physical network interfaces attached to the data center.
3.  Click **Setup Host Networks** to open the **Setup Host Networks** window.
4.  Edit a physical network interface by hovering your cursor over a physical network interface and clicking the pencil icon to open the **Edit Interface** window.
    ⁠

    ![The Edit Interface Window|200px](Edit_Management_Network.png "The Edit Interface Window|200px")

    **Figure 5.4. The Edit Interface Window**

5.  Enter a name for the network label in the **Label** text field and use the **+** and **-** buttons to add or remove additional network labels.
6.  Click **OK**.

**Result**

You have added a network label to a host network interface. Any newly created logical networks with the same label will be automatically assigned to all host network interfaces with that label. Also, removing a label from a logical network will automatically remove that logical network from all host network interfaces with that label.

#### Using the Networks Tab

The **Networks** resource tab provides a central location for users to perform network-related operations and search for networks based on each network's property or association with other resources.

All networks in the oVirt environment display in the results list of the **Networks** tab. The **New**, **Edit** and **Remove** buttons allow you to create, change the properties of, and delete logical networks within data centers.

Click on each network name and use the **Clusters**, **Hosts**, **Virtual Machines**, **Templates**, and **Permissions** tabs in the details pane to perform functions including:

*   Attaching or detaching the networks to clusters and hosts
*   Removing network interfaces from virtual machines and templates
*   Adding and removing permissions for users to access and manage networks

These functions are also accessible through each individual resource tab.

### External Provider Networks

#### Importing Networks From External Providers

**Summary**

If an external provider offering networking services has been registered in oVirt, the networks provided by that provider can be imported into oVirt and used by virtual machines.

**Procedure 5.12. Importing a Network From an External Provider**

1.  Click the **Networks** tab.
2.  Click the **Import** button to open the **Import Networks** window.
    ⁠

    ![The Import Networks Window|300px](Import_Networks.png "The Import Networks Window|300px")

    **Figure 5.5. The Import Networks Window**

3.  From the **Network Provider** drop-down list, select an external provider. The networks offered by that provider are automatically discovered and listed in the **Provider Networks** list.
4.  Using the check boxes, select the networks to import in the **Provider Networks** list and click the down arrow to move those networks into the **Networks to Import** list.
5.  From the **Data Center** drop-down list, select the data center into which the networks will be imported.
6.  Optionally, clear the **Allow All** check box for a network in the **Networks to Import** list to prevent that network from being available to all users.
7.  Click the **Import** button.

**Result**

The selected networks are imported into the target data center and can now be used in oVirt.

#### Limitations to Using External Provider Networks

The following limitations apply to using logical networks imported from an external provider in an oVirt environment.

*   Logical networks offered by external providers must be used as virtual machine networks, and cannot be used as display networks.
*   The same logical network can be imported more than once, but only to different data centers.
*   You cannot edit logical networks offered by external providers in oVirt. To edit the details of a logical network offered by an external provider, you must edit the logical network directly from the OpenStack Networking instance that provides that logical network.
*   Port mirroring is not available for virtual network interface cards connected to logical networks offered by external providers.
*   If a virtual machine uses a logical network offered by an external provider, that provider cannot be deleted from oVirt while the logical network is still in use by the virtual machine.
*   Networks offered by external providers are non-required. As such, scheduling for clusters in which such logical networks have been imported will not take those logical networks into account during host selection. Moreover, it is the responsibility of the user to ensure the availability of the logical network on hosts in clusters in which such logical networks have been imported.

<div class="alert alert-info">
**Important:** Logical networks imported from external providers are only compatible with Red Hat Enterprise Linux hosts and cannot be assigned to virtual machines running on oVirt Node hosts.

</div>
<div class="alert alert-info">
**Important:** External provider discovery and importing are Technology Preview features. Technology Preview features are not fully supported under Red Hat Subscription Service Level Agreements (SLAs), may not be functionally complete, and are not intended for production use. However, these features provide early access to upcoming product innovations, enabling customers to test functionality and provide feedback during the development process.

</div>

#### Subnets on External Provider Logical Networks

##### Configuring Subnets on External Provider Logical Networks

A logical network provided by an external provider can only assign IP addresses to virtual machines if one or more subnets have been defined on that logical network. If no subnets are defined, virtual machines will not be assigned IP addresses. If there is one subnet, virtual machines will be assigned an IP address from that subnet, and if there are multiple subnets, virtual machines will be assigned an IP address from any of the available subnets. The DHCP service provided by the Neutron instance on which the logical network is hosted is responsible for assigning these IP addresses.

While oVirt automatically discovers predefined subnets on imported logical networks, you can also add or remove subnets to or from logical networks from within oVirt.

##### Adding Subnets to External Provider Logical Networks

**Summary**

Create a subnet on a logical network provided by an external provider

⁠

**Procedure 5.13. Adding Subnets to External Provider Logical Networks**

1.  Click the **Networks** tab.
2.  Click the logical network provided by an external provider to which the subnet will be added.
3.  Click the **Subnets** tab in the details pane.
4.  Click the **New** button to open the **New External Subnet** window.
5.  Enter a **Name** and **CIDR** for the new subnet.
6.  From the **IP Version** drop-down menu, select either **IPv4** or **IPv6**.
7.  Click **OK**.

**Result**

A new subnet is created on the logical network.

##### Removing Subnets from External Provider Logical Networks

**Summary**

Remove a subnet from a logical network provided by an external provider

⁠

**Procedure 5.14. Removing Subnets from External Provider Logical Networks**

1.  Click the **Networks** tab.
2.  Click the logical network provided by an external provider from which the subnet will be removed.
3.  Click the **Subnets** tab in the details pane.
4.  Click the subnet to remove.
5.  Click the **Remove** button and click **OK** when prompted.

**Result**

The subnet is removed from the logical network.

## ⁠Hosts

### Introduction to oVirt Hosts

Hosts, also known as hypervisors, are the physical servers on which virtual machines run. Full virtualization is provided by using a loadable Linux kernel module called Kernel-based Virtual Machine (KVM).

KVM can concurrently host multiple virtual machines running either Windows or Linux operating systems. Virtual machines run as individual Linux processes and threads on the host machine and are managed remotely by oVirt. An oVirt environment has one or more hosts attached to it.

oVirt supports two methods of installing hosts. You can use the oVirt Node installation media, or install hypervisor packages on a standard Red Hat Enterprise Linux, CentOS, or Fedora installation.

oVirt hosts take advantage of **tuned** profiles, which provide virtualization optimizations. For more information on **tuned** for Red Hat Enterprise Linux, please refer to the *[Red Hat Enterprise Linux 6.0 Performance Tuning Guide](//access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Performance_Tuning_Guide/index.html)*.

The oVirt Node has security features enabled. Security Enhanced Linux (SELinux) and the iptables firewall are fully configured and on by default. oVirt can open required ports on Red Hat Enterprise Linux, CentOS, and Fedora hosts when it adds them to the environment. For a full list of ports, see [Section A.2, “Virtualization Host Firewall Requirements”](#Virtualization_Host_Firewall_Requirements1).

A host is a physical 64-bit server with the Intel VT or AMD-V extensions running Red Hat Enterprise Linux 6.1 or later, as well as CentOS 6.1 or later, in either the AMD64/Intel 64 version.

<div class="alert alert-info">
**Important:** Red Hat Enterprise Linux 5.4 and Red Hat Enterprise Linux 5.5 machines that belong to existing clusters are supported. oVirt Guest Agent is now included in the `virtio serial` channel. Any Guest Agents installed on Windows guests on Red Hat Enterprise Linux hosts will lose their connection to oVirt when the Red Hat Enterprise Linux hosts are upgraded from version 5 to version 6.

</div>
A physical host on the oVirt platform:

*   Must belong to only one cluster in the system.
*   Must have CPUs that support the AMD-V or Intel VT hardware virtualization extensions.
*   Must have CPUs that support all functionality exposed by the virtual CPU type selected upon cluster creation.
*   Has a minimum of 2 GB RAM.
*   Can have an assigned system administrator with system permissions.

### oVirt Node Hosts

oVirt Node hosts are installed using a special build of Fedora, with only the packages required to host virtual machines. They run stateless, not writing any changes to disk unless explicitly required to.

oVirt Node hosts can be added directly to, and configured by, oVirt. Alternatively a host can be configured locally to connect to oVirt; oVirt then is only used to approve the host to be used in the environment.

Unlike Red Hat Enterprise Linux, Fedora, or CentOS hosts, oVirt Node hosts cannot be added to clusters that have been enabled for Gluster service for use as Red Hat Storage nodes.

<div class="alert alert-info">
**Important:** The oVirt Node is a closed system. Use a Red Hat Enterprise Linux, CentOS, or Fedora host if additional rpm packages are required for your environment.

</div>

### Foreman Host Provider Hosts

Hosts provided by a Foreman host provider can also be used as virtualization hosts by oVirt. After a Foreman host provider has been added to oVirt as an external provider, any hosts that it provides can be added to and used in oVirt in the same way as oVirt Node hosts and Red Hat Enterprise Linux/CentOS hosts.

<div class="alert alert-info">
**Important:** Foreman host provider hosts are a Technology Preview feature. Technology Preview features are not fully supported, may not be functionally complete, and are not intended for production use. However, these features provide early access to upcoming product innovations, enabling customers to test functionality and provide feedback during the development process.

</div>

### Enterprise Linux Hosts

You can use a standard Red Hat Enterprise Linux 6 or CentOS 6 installation on capable hardware as a host. oVirt supports hosts running Red Hat Enterprise Linux 6 or CentOS server AMD64/Intel 64 version.

Adding a host can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge and a reboot of the host. Use the Details pane to monitor the hand-shake process as the host and management system establish a connection.

### Host Tasks

#### Adding an Enterprise Linux Host

**Summary**

An Enterprise Linux host is based on a standard "basic" installation of Red Hat Enterprise Linux or CentOS. The physical host must be set up before you can add it to the oVirt environment.

oVirt logs into the host to perform virtualization capability checks, install packages, create a network bridge, and reboot the host. The process of adding a new host can take up to 10 minutes.

**Procedure 6.1. Adding an Enterprise Linux Host**

1.  Click the **Hosts** resource tab to list the hosts in the results list.
2.  Click **New** to open the **New Host** window.
3.  Use the drop-down menus to select the **Data Center** and **Host Cluster** for the new host.
4.  Enter the **Name**, **Address**, and **SSH Port** of the new host.
5.  Select an authentication method to use with the host.
    -   Enter the root user's password to use password authentication.
    -   Copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the host to use public key authentication.

6.  You have now completed the mandatory steps to add a Red Hat Enterprise Linux or CentOS host. Click the **Advanced Parameters** button to expand the advanced host settings.
    1.  Optionally disable automatic firewall configuration.
    2.  Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

7.  You can configure the **Power Management** and **SPM** using the applicable tabs now; however, as these are not fundamental to adding a Red Hat Enterprise Linux host, they are not covered in this procedure.
8.  Click **OK** to add the host and close the window.

**Result**

The new host displays in the list of hosts with a status of `Installing`. When installation is complete, the status updates to `Reboot`. The host must be activated for the status to change to `Up`.

<div class="alert alert-info">
**Note:** You can view the progress of the installation in the details pane.

</div>

#### Approving a Hypervisor

**Summary**

It is not possible to run virtual machines on a Hypervisor until the addition of it to the environment has been approved in oVirt.

**Procedure 6.2. Approving a Hypervisor**

1.  Log in to oVirt Administration Portal.
2.  From the **Hosts** tab, click on the host to be approved. The host should currently be listed with the status of **Pending Approval**.
3.  Click the **Approve** button. The **Edit and Approve Hosts** dialog displays. You can use the dialog to set a name for the host, fetch its SSH fingerprint before approving it, and configure power management, where the host has a supported power management card. For information on power management configuration, refer to [“Host Power Management Settings Explained”](#Host_Power_Management_Settings_Explained).
4.  Click **OK**. If you have not configured power management you will be prompted to confirm that you wish to proceed without doing so, click **OK**.

**Result**

The status in the **Hosts** tab changes to **Installing**, after a brief delay the host status changes to **Up**.

#### Explanation of Settings and Controls in the New Host and Edit Host Windows

##### Host General Settings Explained

These settings apply when editing the details of a host or adding new Red Hat Enterprise Linux hosts and Foreman host provider hosts.

The **General** settings table contains the information required on the **General** tab of the **New Host** or **Edit Host** window.

⁠

**Table 6.1. General Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center to which the host belongs. oVirt Node hosts cannot be added to Gluster-enabled clusters.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Host Cluster</strong></p></td>
<td align="left"><p>The cluster to which the host belongs.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Use External Providers</strong></p></td>
<td align="left"><p>Select or clear this check box to view or hide options for adding hosts provided by external providers. Upon selection, a drop-down list of external providers that have been added to oVirt displays. The following options are also available:</p>
<ul>
<li><strong>Provider search filter</strong> - A text field that allows you to search for hosts provided by the selected external provider. This option is provider-specific; see provider documentation for details on forming search queries for specific providers. Leave this field blank to view all available hosts.</li>
<li><strong>External Hosts</strong> - A drop-down list that is populated with the name of hosts provided by the selected external provider. The entries in this list are filtered in accordance with any search queries that have been input in the <strong>Provider search filter</strong>.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text, human-readable comments regarding the host.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Address</strong></p></td>
<td align="left"><p>The IP address, or resolvable hostname of the host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Password</strong></p></td>
<td align="left"><p>The password of the host's root user. This can only be given when you add the host; it cannot be edited afterwards.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>SSH PublicKey</strong></p></td>
<td align="left"><p>Copy the contents in the text box to the <code>/root/.known_hosts</code> file on the host to use oVirt's ssh key instead of using a password to authenticate with the host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Automatically configure host firewall</strong></p></td>
<td align="left"><p>When adding a new host, oVirt can open the required ports on the host's firewall. This is enabled by default. This is an <strong>Advanced Parameter</strong>.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>SSH Fingerprint</strong></p></td>
<td align="left"><p>You can <strong>fetch</strong> the host's SSH fingerprint, and compare it with the fingerprint you expect the host to return, ensuring that they match. This is an <strong>Advanced Parameter</strong>.</p></td>
</tr>
</tbody>
</table>

##### Host Power Management Settings Explained

The **Power Management** settings table contains the information required on the **Power Management** tab of the **New Host** or **Edit Host** windows.

⁠

**Table 6.2. Power Management Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
</tr>
<tr class="even">
<td align="left"><p><strong>Primary/ Secondary</strong></p></td>
<td align="left"><p>Prior to oVirt 3.2, a host with power management configured only recognized one fencing agent. Fencing agents configured on version 3.1 and earlier, and single agents, are treated as primary agents. The secondary option is valid when a second agent is defined.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Concurrent</strong></p></td>
<td align="left"><p>Valid when there are two fencing agents, for example for dual power hosts in which each power switch has two agents connected to the same power switch.</p>
<ul>
<li>If this check box is selected, both fencing agents are used concurrently when a host is fenced. This means that both fencing agents have to respond to the Stop command for the host to be stopped; if one agent responds to the Start command, the host will go up.</li>
<li>If this check box is not selected, the fencing agents are used sequentially. This means that to stop or start a host, the primary agent is used first, and if it fails, the secondary agent is used.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Address</strong></p></td>
<td align="left"><p>The address to access your host's power management device. Either a resolvable hostname or an IP address.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>User Name</strong></p></td>
<td align="left"><p>User account with which to access the power management device. You can set up a user on the device, or use the default user.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Password</strong></p></td>
<td align="left"><p>Password for the user accessing the power management device.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Type</strong></p></td>
<td align="left"><p>The type of power management device in your host. Choose one of the following:</p>
<ul>
<li><strong>apc</strong> - APC MasterSwitch network power switch. Not for use with APC 5.x power switch devices.</li>
<li><strong>apc_snmp</strong> - Use with APC 5.x power switch devices.</li>
<li><strong>bladecenter</strong> - IBM Bladecentre Remote Supervisor Adapter.</li>
<li><strong>cisco_ucs</strong> - Cisco Unified Computing System.</li>
<li><strong>drac5</strong> - Dell Remote Access Controller for Dell computers.</li>
<li><strong>drac7</strong> - Dell Remote Access Controller for Dell computers.</li>
<li><strong>eps</strong> - ePowerSwitch 8M+ network power switch.</li>
<li><strong>hpblade</strong> - HP BladeSystem.</li>
<li><strong>ilo</strong>, <strong>ilo2</strong>, <strong>ilo3</strong>, <strong>ilo4</strong> - HP Integrated Lights-Out.</li>
<li><strong>ipmilan</strong> - Intelligent Platform Management Interface and Sun Integrated Lights Out Management devices.</li>
<li><strong>rsa</strong> - IBM Remote Supervisor Adaptor.</li>
<li><strong>rsb</strong> - Fujitsu-Siemens RSB management interface.</li>
<li><strong>wti</strong> - WTI Network PowerSwitch.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Port</strong></p></td>
<td align="left"><p>The port number used by the power management device to communicate with the host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Options</strong></p></td>
<td align="left"><p>Power management device specific options. Enter these as 'key=value' or 'key'. See the documentation of your host's power management device for the options available.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Secure</strong></p></td>
<td align="left"><p>Tick this check box to allow the power management device to connect securely to the host. This can be done via ssh, ssl, or other authentication protocols depending on and supported by the power management agent.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Source</strong></p></td>
<td align="left"><p>Specifies whether the host will search within its <strong>cluster</strong> or <strong>data center</strong> for a fencing proxy. Use the <strong>Up</strong> and <strong>Down</strong> buttons to change the sequence in which the resources are used.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Disable policy control of power management</strong></p></td>
<td align="left"><p>Power management is controlled by the <strong>Cluster Policy</strong> of the host's <strong>cluster</strong>. If power management is enabled and the defined low utilization value is reached, oVirt will power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Tick this check box to disable policy control.</p></td>
</tr>
</tbody>
</table>

##### SPM Priority Settings Explained

The **SPM** settings table details the information required on the **SPM** tab of the **New Host** or **Edit Host** window.

⁠

**Table 6.3. SPM settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
</tr>
<tr class="even">
<td align="left"><p><strong>SPM Priority</strong></p></td>
<td align="left"><p>Defines the likelihood that the host will be given the role of Storage Pool Manager(SPM). The options are <strong>Low</strong>, <strong>Normal</strong>, and <strong>High</strong> priority. Low priority means that there is a reduced likelihood of the host being assigned the role of SPM, and High priority means there is an increased likelihood. The default setting is Normal.</p></td>
</tr>
</tbody>
</table>

##### Host Console Settings Explained

The **Console** settings table details the information required on the **Console** tab of the **New Host** or **Edit Host** window.

⁠

**Table 6.4. Console settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
</tr>
<tr class="even">
<td align="left"><p><strong>Override display address</strong></p></td>
<td align="left"><p>Select this check box to override the display addresses of the host. This feature is useful in a case where the hosts are defined by internal IP and are behind a NAT firewall. When a user connects to a virtual machine from outside of the internal network, instead of returning the private address of the host on which the virtual machine is running, the machine returns a public IP or FQDN (which is resolved in the external network to the public IP).</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Display address</strong></p></td>
<td align="left"><p>The display address specified here will be used for all virtual machines running on this host. The address must be in the format of a fully qualified domain name or IP.</p></td>
</tr>
</tbody>
</table>

#### Configuring Host Power Management Settings

**Summary**

Configure your host power management device settings to perform host life-cycle operations (stop, start, restart) from the Administration Portal.

It is necessary to configure host power management in order to utilize host high availability and virtual machine high availability.

<div class="alert alert-info">
**Important:** Ensure that your host is in `maintenance mode` before configuring power management settings. Otherwise, all running virtual machines on that host will be stopped ungracefully upon restarting the host, which can cause disruptions in production environments. A warning dialog will appear if you have not correctly set your host to `maintenance mode.`

</div>
⁠

**Procedure 6.3. Configuring Power Management Settings**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Edit** to open the **Edit Host** window.
3.  Click the **Power Management** tab to display the Power Management settings.
4.  Select the **Enable Power Management** check box to enable the fields.
5.  The **Primary** option is selected by default if you are configuring a new power management device. If you are adding a new device, set it to **Secondary**.
6.  Select the **Concurrent** check box to enable multiple fence agents to be used concurrently.
7.  Enter the **Address**, **User Name**, and **Password** of the power management device into the appropriate fields.
8.  Use the drop-down menu to select the **Type** of power management device.
9.  Enter the **Port** number used by the power management device to communicate with the host.
10. Enter the **Options** for the power management device. Use a comma-separated list of **key=value** or **key**.
11. Select the **Secure** check box to enable the power management device to connect securely to the host.
12. Click **Test** to ensure the settings are correct.
13. Click **OK** to save your settings and close the window.

**Result**

You have configured the power management settings for the host. The **Power Management** drop-down menu is now enabled in the Administration Portal.

<div class="alert alert-info">
**Note:** Power management is controlled by the **Cluster Policy** of the host's **cluster**. If power management is enabled and the defined low utilization value is reached, oVirt will power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Tick the **Disable policy control of power management** check box if you do not wish for your host to automatically perform these functions.

</div>

#### Configuring Host Storage Pool Manager Settings

**Summary**

The Storage Pool Manager (SPM) is a management role given to one of the hosts in a data center to maintain access control over the storage domains. The SPM must always be available, and the SPM role will be assigned to another host if the SPM host becomes unavailable. As the SPM role uses some of the host's available resources, it is important to prioritize hosts that can afford the resources.

The Storage Pool Manager (SPM) priority setting of a host alters the likelihood of the host being assigned the SPM role: a host with high SPM priority will be assigned the SPM role before a host with low SPM priority.

⁠

**Procedure 6.4. Configuring SPM settings**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Edit** to open the **Edit Host** window.
3.  Click the **SPM** tab to display the **SPM Priority** settings.
4.  Use the radio buttons to select the appropriate SPM priority for the host.
5.  Click **OK** to save the settings and close the window.

**Result**

You have configured the SPM priority of the host.

#### Editing a Resource

**Summary**

Edit the properties of a resource.

⁠

**Procedure 6.5. Editing a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click **Edit** to open the **Edit** window.
3.  Change the necessary properties and click **OK**.

**Result**

The new properties are saved to the resource. The **Edit** window will not close if a property field is invalid.

#### Approving Newly Added oVirt Node Hosts

**Summary**

You have to install your oVirt Node hosts before you can approve them in oVirt. Read about installing oVirt Nodes in the *oVirt Installation Guide*.

Once installed, the oVirt Node host is visible in the Administration Portal but not active. Approve it so that it can host virtual machines.

**Procedure 6.6. Approving newly added oVirt Node hosts**

1.  In the **Hosts** tab, select the host you recently installed using the oVirt Node host installation media. This host shows a status of `Pending Approval`.
2.  Click the **Approve** button.

**Result**

The host's status changes to `Up` and it can be used to run virtual machines.

<div class="alert alert-info">
**Note:** You can also add this host using the procedure in [“Adding an Enterprise Linux Host”](#Adding_an_Enterprise_Linux_Host), which utilizes the oVirt Node host's IP address and the password that was set on the **oVirt Engine** screen.

</div>

#### Moving a Host to Maintenance Mode

**Summary**

Many common maintenance tasks, including network configuration and deployment of software updates, require that hosts be placed into maintenance mode. When a host is placed into maintenance mode oVirt attempts to migrate all running virtual machines to alternative hosts.

The normal prerequisites for live migration apply, in particular there must be at least one active host in the cluster with capacity to run the migrated virtual machines.

⁠

**Procedure 6.7. Moving a Host to Maintenance Mode**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.
3.  Click **OK** to initiate maintenance mode.

Result:

All running virtual machines are migrated to alternative hosts. The **Status** field of the host changes to `Preparing for Maintenance`, and finally `Maintenance` when the operation completes successfully.

#### Activating a Host from Maintenance Mode

**Summary**

A host that has been placed into maintenance mode, or recently added to the environment, must be activated before it can be used.

⁠

**Procedure 6.8. Activating a Host from Maintenance Mode**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Activate**.

**Result**

The host status changes to `Unassigned`, and finally `Up` when the operation is complete. Virtual machines can now run on the host.

#### Removing a Host

**Summary**

Remove a host from your virtualized environment.

**Procedure 6.9. Removing a host**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Place the host into maintenance mode.
3.  Click **Remove** to open the **Remove Host(s)** confirmation window.
4.  Select the **Force Remove** check box if the host is part of a Red Hat Storage cluster and has volume bricks on it, or if the host is non-responsive.
5.  Click **OK**.

**Result**

Your host has been removed from the environment and is no longer visible in the **Hosts** tab.

#### Customizing Hosts with Tags

**Summary**

You can use tags to store information about your hosts. You can then search for hosts based on tags.

⁠

**Procedure 6.10. Customizing hosts with tags**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Assign Tags** to open the **Assign Tags** window.
    ⁠

    ![Assign Tags Window](Assign Tags.png "Assign Tags Window")

    **Figure 6.1. Assign Tags Window**

3.  The **Assign Tags** window lists all available tags. Select the check boxes of applicable tags.
4.  Click **OK** to assign the tags and close the window.

**Result**

You have added extra, searchable information about your host as tags.

### Hosts and Networking

#### Refreshing Host Capabilities

**Summary**

When a network interface card is added to a host, the capabilities of the host must be refreshed to display that network interface card in oVirt.

⁠

**Procedure 6.11. To Refresh Host Capabilities**

1.  Use the resource tabs, tree mode, or the search function to find and select a host in the results list.
2.  Click the **Refresh Capabilities** button.

**Result**

The list of network interface cards in the **Network Interfaces** tab of the details pane for the selected host is updated. Any new network interface cards can now be used in oVirt.

#### Editing Host Network Interfaces and Assigning Logical Networks to Hosts

**Summary**

You can change the settings of physical host network interfaces, move the management network from one physical host network interface to another, and assign logical networks to physical host network interfaces.

<div class="alert alert-info">
**Important:** You cannot assign logical networks offered by external providers to physical host network interfaces; such networks are dynamically assigned to hosts as they are required by virtual machines.

</div>
⁠

**Procedure 6.12. Editing Host Network Interfaces and Assigning Logical Networks to Hosts**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results.
2.  Click the **Network Interfaces** tab in the details pane.
3.  Click the **Setup Host Networks** button to open the **Setup Host Networks** window.
    ⁠

    ![The Setup Host Networks window](Setup_Host_Networks.png "The Setup Host Networks window")

    **Figure 6.2. The Setup Host Networks window**

4.  Attach a logical network to a physical host network interface by selecting and dragging the logical network into the **Assigned Logical Networks** area next to the physical host network interface. Alternatively, right-click the logical network and select a network interface from the drop-down menu.
5.  Configure the logical network:
    1.  Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.
    2.  Select a **Boot Protocol** from:
        -   **None**,
        -   **DHCP**, or
        -   **Static**. If you selected **Static**, enter the **IP**, **Subnet Mask**, and the **Gateway**.

    3.  Click **OK**.
    4.  If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box.

6.  Select the **Verify connectivity between Host and Engine** check box to check network connectivity; this action will only work if the host is in maintenance mode.
7.  Select the **Save network configuration** check box to make the changes persistent when the environment is rebooted.
8.  Click **OK**.

**Result**

You have assigned logical networks to and configured a physical host network interface.

<div class="alert alert-info">
**Note:** If not all network interface cards for the host are displayed, click the **Refresh Capabilities** button to update the list of network interface cards available for that host.

</div>

#### Bonds

##### Bonding Logic in oVirt

oVirt Administration Portal allows you to create bond devices using a graphical interface. There are several distinct bond creation scenarios, each with its own logic.

Two factors that affect bonding logic are:

*   Are either of the devices already carrying logical networks?
*   Are the devices carrying compatible logical networks? A single device cannot carry both VLAN tagged and non-VLAN tagged logical networks.

⁠

**Table 6.5. Bonding Scenarios and Their Results**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Bonding Scenario</p></th>
<th align="left"><p><strong>Result</strong></p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>NIC + NIC</p></td>
<td align="left"><p>The <strong>Create New Bond</strong> window is displayed, and you can configure a new bond device. If the network interfaces carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NIC + Bond</p></td>
<td align="left"><p>The NIC is added to the bond device. Logical networks carried by the NIC and the bond are all added to the resultant bond device if they are compatible. If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Bond + Bond</p></td>
<td align="left"><p>If the bond devices are not attached to logical networks, or are attached to compatible logical networks, a new bond device is created. It contains all of the network interfaces, and carries all logical networks, of the component bond devices. The <strong>Create New Bond</strong> window is displayed, allowing you to configure your new bond. If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p></td>
</tr>
</tbody>
</table>

##### Bonding Modes

oVirt supports the following common bonding modes:

*   Mode 1 (active-backup policy) sets all interfaces to the backup state while one remains active. Upon failure on the active interface, a backup interface replaces it as the only active interface in the bond. The MAC address of the bond in mode 1 is visible on only one port (the network adapter), to prevent confusion for the switch. Mode 1 provides fault tolerance and is supported in oVirt.
*   Mode 2 (XOR policy) selects an interface to transmit packages to based on the result of an XOR operation on the source and destination MAC addresses modulo NIC slave count. This calculation ensures that the same interface is selected for each destination MAC address used. Mode 2 provides fault tolerance and load balancing and is supported in oVirt.
*   Mode 4 (IEEE 802.3ad policy) creates aggregation groups for which included interfaces share the speed and duplex settings. Mode 4 uses all interfaces in the active aggregation group in accordance with the IEEE 802.3ad specification and is supported in oVirt.
*   Mode 5 (adaptive transmit load balancing policy) ensures the outgoing traffic distribution is according to the load on each interface and that the current interface receives all incoming traffic. If the interface assigned to receive traffic fails, another interface is assigned the receiving role instead. Mode 5 is supported in oVirt.

##### Creating a Bond Device Using the Administration Portal

**Summary**

You can bond compatible network devices together. This type of configuration can increase available bandwidth and reliability. You can bond multiple network interfaces, pre-existing bond devices, and combinations of the two.

A bond cannot carry both vlan tagged and non-vlan traffic.

⁠

**Procedure 6.13. Creating a Bond Device using the Administration Portal**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click the **Network Interfaces** tab in the details pane to list the physical network interfaces attached to the host.
3.  Click **Setup Host Networks** to open the **Setup Host Networks** window.
4.  Select and drag one of the devices over the top of another device and drop it to open the **Create New Bond** window. Alternatively, right-click the device and select another device from the drop-down menu.
    If the devices are incompatible, for example one is vlan tagged and the other is not, the bond operation fails with a suggestion on how to correct the compatibility issue.

    ⁠

    ![Bond Devices Window](Create_New_Bond.png "Bond Devices Window")

    **Figure 6.3. Bond Devices Window**

5.  Select the **Bond Name** and **Bonding Mode** from the drop-down menus. Bonding modes 1, 2, 4, and 5 can be selected. Any other mode can be configured using the **Custom** option.
6.  Click **OK** to create the bond and close the **Create New Bond** window.
7.  Assign a logical network to the newly created bond device.
8.  Optionally choose to **Verify connectivity between Host and Engine** and **Save network configuration**.
9.  Click **OK** accept the changes and close the **Setup Host Networks** window.

**Result**

Your network devices are linked into a bond device and can be edited as a single interface. The bond device is listed in the **Network Interfaces** tab of the details pane for the selected host.

Bonding must be enabled for the ports of the switch used by the host. The process by which bonding is enabled is slightly different for each switch; consult the manual provided by your switch vendor for detailed information on how to enable bonding.

##### Example Uses of Custom Bonding Options with Host Interfaces

You can create customized bond devices by selecting **Custom** from the **Bonding Mode** of the **Create New Bond** window. The following examples should be adapted for your needs. For a comprehensive list of bonding options and their descriptions, see the [*Linux Ethernet Bonding Driver HOWTO*](https://www.kernel.org/doc/Documentation/networking/bonding.txt) on Kernel.org.

⁠

**Example 6.1. xmit_hash_policy**

This option defines the transmit load balancing policy for bonding modes 2 and 4. For example, if the majority of your traffic is between many different IP addresses, you may want to set a policy to balance by IP address. You can set this load-balancing policy by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=4 xmit_hash_policy=layer2+3

⁠

**Example 6.2. ARP Monitoring**

ARP monitor is useful for systems which can't or don't report link-state properly via ethtool. Set an *`arp_interval`* on the bond device of the host by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 arp_interval=1 arp_ip_target=192.168.0.2

⁠

**Example 6.3. Primary**

You may want to designate a NIC with higher throughput as the primary interface in a bond device. Designate which NIC is primary by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 primary=eth0

#### Saving a Host Network Configuration

**Summary**

One of the options when configuring a host network is to save the configuration as you apply it, making the changes persistent.

Any changes made to the host network configuration will be temporary if you did not select the **Save network configuration** check box in the **Setup Host Networks** window.

Save the host network configuration to make it persistent.

⁠

**Procedure 6.14. Saving a host network configuration**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click the **Network Interfaces** tab on the Details pane to list the NICs on the host, their address, and other specifications.
3.  Click the **Save Network Configuration** button.
4.  The host network configuration is saved and the following message is displayed on the task bar: "Network changes were saved on host *[Hostname]*."

**Result**

The host's network configuration is saved persistently and will survive reboots.

<div class="alert alert-info">
**Note:** Saving the host network configuration also updates the list of available network interfaces for the host. This behavior is similar to that of the **Refresh Capabilities** button.

</div>

### Host Resilience

#### Host High Availability

oVirt uses fencing to keep the hosts in a cluster responsive. A **Non Responsive** host is different from a **Non Operational** host. **Non Operational** hosts can be communicated with by oVirt, but have an incorrect configuration, for example a missing logical network. **Non Responsive** hosts cannot be communicated with by oVirt.

If a host with a power management device loses communication with oVirt, it can be fenced (rebooted) from the Administration Portal. All the virtual machines running on that host are stopped, and highly available virtual machines are started on a different host.

All power management operations are done using a proxy host, as opposed to directly by oVirt. At least two hosts are required for power management operations.

Fencing allows a cluster to react to unexpected host failures as well as enforce power saving, load balancing, and virtual machine availability policies. You should configure the fencing parameters for your host's power management device and test their correctness from time to time.

Hosts can be fenced automatically using the power management parameters, or manually by right-clicking on a host and using the options on the menu. In a fencing operation, an unresponsive host is rebooted, and if the host does not return to an active status within a prescribed time, it remains unresponsive pending manual intervention and troubleshooting.

If the host is required to run virtual machines that are highly available, power management must be enabled and configured.

#### Power Management by Proxy in oVirt

oVirt does not communicate directly with fence agents. Instead, oVirt uses a proxy to send power management commands to a host power management device. oVirt uses VDSM to execute power management device actions, so another host in the environment is used as a fencing proxy.

You can select between:

*   Any host in the same cluster as the host requiring fencing.
*   Any host in the same data center as the host requiring fencing.

A viable fencing proxy host has a status of either *UP* or *Maintenance*.

#### Setting Fencing Parameters on a Host

The parameters for host fencing are set using the **Power Management** fields on the **New Host** or **Edit Host** windows. Power management enables the system to fence a troublesome host using an additional interface such as a Remote Access Card (RAC).

All power management operations are done using a proxy host, as opposed to directly by oVirt. At least two hosts are required for power management operations.

⁠

**Procedure 6.15. Setting fencing parameters on a host**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Edit** to open the **Edit Host** window.
3.  Click the **Power Management** tab.
    ⁠

    ![Power Management Settings](Edit Host Power Management.png "Power Management Settings")

    **Figure 6.4. Power Management Settings**

4.  Select the **Enable Power Management** check box to enable the fields.
5.  The **Primary** option is selected by default if you are configuring a new power management device. If you are adding a new device, set it to **Secondary**.
6.  Select the **Concurrent** check box to enable multiple fence agents to be used concurrently.
7.  Enter the **Address**, **User Name**, and **Password** of the power management device.
8.  Select the power management device **Type** from the drop-down menu.
9.  Enter the **Port** number used by the power management device to communicate with the host.
10. Enter the specific **Options** of the power management device. Use a comma-separated list of 'key=value' or 'key' entries.
11. Click the **Test** button to test the power management device. *Test Succeeded, Host Status is: on* will display upon successful verification.
    <div class="alert alert-info">
    **Warning:** Power management parameters (userid, password, options, etc) are tested by oVirt only during setup and manually after that. If you choose to ignore alerts about incorrect parameters, or if the parameters are changed on the power management hardware without the corresponding change in oVirt, fencing is likely to fail when most needed.

    </div>
12. Click **OK** to save the changes and close the window.

**Result**

You are returned to the list of hosts. Note that the exclamation mark next to the host's name has now disappeared, signifying that power management has been successfully configured.

#### Soft-Fencing Hosts

Sometimes a host becomes non-responsive due to an unexpected problem, and though VDSM is unable to respond to requests, the virtual machines that depend upon VDSM remain alive and accessible. In these situations, restarting VDSM returns VDSM to a responsive state and resolves this issue.

oVirt 3.3 introduces "soft-fencing over SSH". Prior to oVirt 3.3, non-responsive hosts were fenced only by external fencing devices. In oVirt 3.3, the fencing process has been expanded to include "SSH Soft Fencing", a process whereby oVirt attempts to restart VDSM via SSH on non-responsive hosts. If oVirt fails to restart VDSM via SSH, the responsibility for fencing falls to the external fencing agent if an external fencing agent has been configured.

Soft-fencing over SSH works as follows. Fencing must be configured and enabled on the host, and a valid proxy host (a second host, in an UP state, in the data center) must exist. When the connection between oVirt and the host times out, the following happens:

1.  On the first network failure, the status of the host changes to "connecting".
2.  oVirt then makes three attempts to ask VDSM for its status, or it waits for an interval determined by the load on the host. The formula for determining the length of the interval is configured by the configuration values TimeoutToResetVdsInSeconds (the default is 60 seconds) + [DelayResetPerVmInSeconds (the default is 0.5 seconds)]\*(the count of running vms on host) + [DelayResetForSpmInSeconds (the default is 20 seconds)] \* 1 (if host runs as SPM) or 0 (if the host does not run as SPM). To give VDSM the maximum amount of time to respond, oVirt chooses the longer of the two options mentioned above (three attempts to retrieve the status of VDSM or the interval determined by the above formula).
3.  If the host does not respond when that interval has elapsed, `vdsm restart` is executed via SSH.
4.  If `vdsm restart` does not succeed in re-establishing the connection between the host and oVirt, the status of the host changes to `Non Responsive` and, if power management is configured, fencing is handed off to the external fencing agent.

<div class="alert alert-info">
**Note:** Soft-fencing over SSH can be executed on hosts that have no power management configured. This is distinct from "fencing": fencing can be executed only on hosts that have power management configured.

</div>

#### Using Host Power Management Functions

**Summary**

When power management has been configured for a host, you can access a number of options from the Administration Portal interface. While each power management device has its own customizable options, they all support the basic options to start, stop, and restart a host.

⁠

**Procedure 6.16. Using Host Power Management Functions**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click the **Power Management** drop-down menu.
3.  Select one of the following options:

    *   **Restart**: This option stops the host and waits until the host's status changes to `Down`. When the agent has verified that the host is down, the highly available virtual machines are restarted on another host in the cluster. The agent then restarts this host. When the host is ready for use its status displays as `Up`.
    *   **Start**: This option starts the host and lets it join a cluster. When it is ready for use its status displays as `Up`.
    *   **Stop**: This option powers off the host. Before using this option, ensure that the virtual machines running on the host have been migrated to other hosts in the cluster. Otherwise the virtual machines will crash and only the highly available virtual machines will be restarted on another host. When the host has been stopped its status displays as `Non-Operational`.

    <div class="alert alert-info">
    **Important:** When two fencing agents are defined on a host, they can be used concurrently or sequentially. For concurrent agents, both agents have to respond to the Stop command for the host to be stopped; and when one agent responds to the Start command, the host will go up. For sequential agents, to start or stop a host, the primary agent is used first; if it fails, the secondary agent is used.

    </div>

4.  Selecting one of the above options opens a confirmation window. Click **OK** to confirm and proceed.

**Result**

The selected action is performed.

#### Manually Fencing or Isolating a Non Responsive Host

**Summary**

If a host unpredictably goes into a non-responsive state, for example, due to a hardware failure; it can significantly affect the performance of the environment. If you do not have a power management device, or it is incorrectly configured, you can reboot the host manually.

<div class="alert alert-info">
**Warning:** Do not use the **Confirm host has been rebooted** option unless you have manually rebooted the host. Using this option while the host is still running can lead to a virtual machine image corruption.

</div>
⁠

**Procedure 6.17. Manually fencing or isolating a non-responsive host**

1.  On the **Hosts** tab, select the host. The status must display as `non-responsive`.
2.  Manually reboot the host. This could mean physically entering the lab and rebooting the host.
3.  On the Administration Portal, right-click the host entry and select the **Confirm Host has been rebooted** button.
4.  A message displays prompting you to ensure that the host has been shut down or rebooted. Select the **Approve Operation** check box and click **OK**.

**Result**

You have manually rebooted your host, allowing highly available virtual machines to be started on active hosts. You confirmed your manual fencing action in the Administrator Portal, and the host is back online.

## ⁠Storage

oVirt uses a centralized storage system for virtual machine disk images, ISO files and snapshots. Storage networking can be implemented using:

*   Network File System (NFS)
*   GlusterFS exports
*   Other POSIX compliant file systems
*   Internet Small Computer System Interface (iSCSI)
*   Local storage attached directly to the virtualization hosts
*   Fibre Channel Protocol (FCP)
*   Parallel NFS (pNFS)

Setting up storage is a prerequisite for a new data center because a data center cannot be initialized unless storage domains are attached and activated.

As an oVirt system administrator, you need to create, configure, attach and maintain storage for the virtualized enterprise. You should be familiar with the storage types and their use. Read your storage array vendor's guides, and refer to the *Red Hat Enterprise Linux Storage Administration Guide* for more information on the concepts, protocols, requirements or general usage of storage.

The oVirt platform enables you to assign and manage storage using the Administration Portal's **Storage** tab. The **Storage** results list displays all the storage domains, and the details pane shows general information about the domain.

oVirt platform has three types of storage domains:

*   **Data Domain:** A data domain holds the virtual hard disks and OVF files of all the virtual machines and templates in a data center. In addition, snapshots of the virtual machines are also stored in the data domain. The data domain cannot be shared across data centers. Storage domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, provided they are all shared, rather than local, domains. You must attach a data domain to a data center before you can attach domains of other types to it.
*   **ISO Domain:** ISO domains store ISO files (or logical CDs) used to install and boot operating systems and applications for the virtual machines. An ISO domain removes the data center's need for physical media. An ISO domain can be shared across different data centers.
*   **Export Domain:** Export domains are temporary storage repositories that are used to copy and move images between data centers and oVirt environments. Export domains can be used to backup virtual machines. An export domain can be moved between data centers, however, it can only be active in one data center at a time.
    **Important**

    Support for export storage domains backed by storage on anything other than NFS is being deprecated. While existing export storage domains imported from oVirt 2.2 environments remain supported new export storage domains must be created on NFS storage.

Only commence configuring and attaching storage for your oVirt environment once you have determined the storage needs of your data center(s).

<div class="alert alert-info">
**Important:** To add storage domains you must be able to successfully access the Administration Portal, and there must be at least one host connected with a status of **Up**.

</div>

### Understanding Storage Domains

A storage domain is a collection of images that have a common storage interface. A storage domain contains complete images of templates and virtual machines (including snapshots), or ISO files. A storage domain can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems).

On NFS, all virtual disks, templates, and snapshots are files.

On SAN (iSCSI/FCP), each virtual disk, template or snapshot is a logical volume. Block devices are aggregated into a logical entity called a volume group, and then divided by LVM (Logical Volume Manager) into logical volumes for use as virtual hard disks.

Virtual disks can have one of two formats, either Qcow2 or RAW. The type of storage can be either Sparse or Preallocated. Snapshots are always sparse but can be taken for disks created either as RAW or sparse.

Virtual machines that share the same storage domain can be migrated between hosts that belong to the same cluster.

### Storage Metadata Versions in oVirt

oVirt stores information about storage domains as metadata on the storage domains themselves. Each major release of oVirt has seen improved implementations of storage metadata.

*   *V1 metadata (oVirt 2.x series)* Each storage domain contains metadata describing its own structure, and all of the names of physical volumes that are used to back virtual machine disk images. Master domains additionally contain metadata for all the domains and physical volume names in the storage pool. The total size of this metadata is limited to 2 kb, limiting the number of storage domains that can be in a pool. Template and virtual machine base images are read only. V1 metadata is applicable to NFS, iSCSI, and FC storage domains.
*   *V2 metadata (oVirt 3.0)* All storage domain and pool metadata is stored as logical volume tags rather than written to a logical volume. Metadata about virtual machine disk volumes is still stored in a logical volume on the domains. Physical volume names are no longer included in the metadata. Template and virtual machine base images are read only. V2 metadata is applicable to iSCSI, and FC storage domains.
*   *V3 metadata (oVirt 3.1+)* All storage domain and pool metadata is stored as logical volume tags rather than written to a logical volume. Metadata about virtual machine disk volumes is still stored in a logical volume on the domains. Virtual machine and template base images are no longer read only. This change enables live snapshots, live storage migration, and clone from snapshot. Support for unicode metadata is added, for non-English volume names. V3 metadata is applicable to NFS, GlusterFS, POSIX, iSCSI, and FC storage domains.

### Preparing and Adding File-Based Storage

#### Preparing NFS Storage

**Summary**

These steps must be taken to prepare an NFS file share on a server running Red Hat Enterprise Linux 6 for use with oVirt.

⁠

**Procedure 7.1. Preparing NFS Storage**

1.  **Install nfs-utils**
    NFS functionality is provided by the nfs-utils package. Before file shares can be created, check that the package is installed by querying the RPM database for the system:

        $ rpm -qi nfs-utils

    If the nfs-utils package is installed then the package information will be displayed. If no output is displayed then the package is not currently installed. Install it using `yum` while logged in as the `root` user:

        # yum install nfs-utils

2.  **Configure Boot Scripts**
    To ensure that NFS shares are always available when the system is operational both the `nfs` and `rpcbind` services must start at boot time. Use the `chkconfig` command while logged in as `root` to modify the boot scripts.

        # chkconfig --add rpcbind
        # chkconfig --add nfs
        # chkconfig rpcbind on
        # chkconfig nfs on

    Once the boot script configuration has been done, start the services for the first time.

        # service rpcbind start
        # service nfs start

3.  **Create Directory**
    Create the directory you wish to share using NFS.

        # mkdir /exports/iso

    Replace */exports/iso* with the name, and path of the directory you wish to use.

4.  **Export Directory**
    To be accessible over the network using NFS the directory must be exported. NFS exports are controlled using the `/etc/exports` configuration file. Each export path appears on a separate line followed by a tab character and any additional NFS options. Exports to be attached to oVirt must have the read, and write, options set.

    To grant read, and write access to `/exports/iso` using NFS for example you add the following line to the `/etc/exports` file.

        /exports/iso       *(rw)

    Again, replace */exports/iso* with the name, and path of the directory you wish to use.

5.  **Reload NFS Configuration**
    For the changes to the `/etc/exports` file to take effect the service must be told to reload the configuration. To force the service to reload the configuration run the following command as `root`:

        # service nfs reload

6.  **Set Permissions**
    The NFS export directory must be configured for read write access and must be owned by vdsm:kvm. If these users do not exist on your external NFS server use the following command, assuming that `/exports/iso` is the directory to be used as an NFS share.

        # chown -R 36:36 /exports/iso

    The permissions on the directory must be set to allow read and write access to the owner, and read and execute access to the group and other users. The owner will also have execute access to the directory. The permissions are set using the `chmod` command. The following command arguments set the required permissions on the `/exports/iso` directory.

        # chmod 0755 /exports/iso

**Result**

The NFS file share has been created, and is ready to be attached by oVirt.

#### Attaching NFS Storage

**Summary**

An NFS type **Storage Domain** is a mounted NFS share that is attached to a data center. It is used to provide storage for virtualized guest images and ISO boot media. Once NFS storage has been exported it must be attached to oVirt using the Administration Portal.

NFS data domains can be added to NFS data centers. You can add NFS, ISO, and export storage domains to data centers of any type.

**Procedure 7.2. Attaching NFS Storage**

1.  Click the **Storage** resource tab to list the existing storage domains.
2.  Click **New Domain** to open the **New Domain** window.
    ⁠

    ![NFS Storage](New Domain.png "NFS Storage")

    **Figure 7.1. NFS Storage**

3.  Enter the **Name** of the storage domain.
4.  Select the **Data Center**, **Domain Function / Storage Type**, and **Use Host** from the drop-down menus. If applicable, select the **Format** from the drop-down menu.
5.  Enter the **Export Path** to be used for the storage domain. The export path should be in the format of `192.168.0.10:/data or domain.example.com:/data`
6.  Click **Advanced Parameters** to enable further configurable settings. It is recommended that the values of these parameters not be modified.
    <div class="alert alert-info">
    **Important:** All communication to the storage domain is from the selected host and not directly from oVirt. At least one active host must be attached to the chosen Data Center before the storage is configured.

    </div>
7.  Click **OK** to create the storage domain and close the window.

**Result**

The new NFS data domain is displayed on the **Storage** tab with a status of `Locked` while the disk prepares. It is automatically attached to the data center upon completion.

#### Preparing Local Storage

**Summary**

A local storage domain can be set up on a host. When you set up host to use local storage, the host automatically gets added to a new data center and cluster that no other hosts can be added to. Multiple host clusters require that all hosts have access to all storage domains, which is not possible with local storage. Virtual machines created in a single host cluster cannot be migrated, fenced or scheduled.

<div class="alert alert-info">
**Important:** On the "oVirt Node" system the only path permitted for use as local storage is `/data/images`. This directory already exists with the correct permissions on Hypervisor installations. The steps in this procedure are only required when preparing local storage on an oVirt hypervisor installed on a stock OS, such as Fedora or Centos.
</div>
⁠

**Procedure 7.3. Preparing Local Storage**

1.  On the virtualization host, create the directory to be used for the local storage.
        # mkdir -p /data/images

2.  Ensure that the directory has permissions allowing read/write access to the `vdsm` user (UID 36) and `kvm` group (GID 36).
        # chown 36:36 /data /data/images

        # chmod 0755 /data /data/images

**Result**

Your local storage is ready to be added to the oVirt environment.

#### Adding Local Storage

**Summary**

Storage local to your host has been prepared. Now use oVirt to add it to the host.

Adding local storage to a host in this manner causes the host to be put in a new data center and cluster. The local storage configuration window combines the creation of a data center, a cluster, and storage into a single process.

⁠

**Procedure 7.4. Adding Local Storage**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.
3.  Click **OK** to initiate maintenance mode.
4.  Click **Configure Local Storage** to open the **Configure Local Storage** window.
    ⁠

    ![Configure Local Storage Window](Configure Local Storage.png "Configure Local Storage Window")

    **Figure 7.2. Configure Local Storage Window**

5.  Click the **Edit** buttons next to the **Data Center**, **Cluster**, and **Storage** fields to configure and name the local storage domain.
6.  Set the path to your local storage in the text entry field.
7.  If applicable, select the **Optimization** tab to configure the memory optimization policy for the new local storage cluster.
8.  Click **OK** to save the settings and close the window.

**Result**

Your host comes online in a data center of its own.

### Adding POSIX Compliant File System Storage

oVirt 3.1 and higher supports the use of POSIX (native) file systems for storage. POSIX file system support allows you to mount file systems using the same mount options that you would normally use when mounting them manually from the command line. This functionality is intended to allow access to storage not exposed using NFS, iSCSI, or FCP.

Any POSIX compliant filesystem used as a storage domain in oVirt **MUST** support sparse files and direct I/O. The Common Internet File System (CIFS), for example, does not support direct I/O, making it incompatible with oVirt.

<div class="alert alert-info">
**Important:** Do *not* mount NFS storage by creating a POSIX compliant file system Storage Domain. Always create an NFS Storage Domain instead.

</div>

#### Attaching POSIX Compliant File System Storage

**Summary**

You want to use a POSIX compliant file system that is not exposed using NFS, iSCSI, or FCP as a storage domain.

⁠

**Procedure 7.5. Attaching POSIX Compliant File System Storage**

1.  Click the **Storage** resource tab to list the existing storage domains in the results list.
2.  Click **New Domain** to open the **New Domain** window.
    ⁠

    ![POSIX Storage](New Domain Posix.png "POSIX Storage")

    **Figure 7.3. POSIX Storage**

3.  Enter the **Name** for the storage domain.
4.  Select the **Data Center** to be associated with the storage domain. The Data Center selected must be of type **POSIX (POSIX compliant FS)**. Alternatively, select `(none)`.
5.  Select `Data / POSIX compliant FS` from the **Domain Function / Storage Type** drop-down menu. If applicable, select the **Format** from the drop-down menu.
6.  Select a host from the **Use Host** drop-down menu. Only hosts within the selected data center will be listed. The host that you select will be used to connect the storage domain.
7.  Enter the **Path** to the POSIX file system, as you would normally provide it to the `mount` command.
8.  Enter the **VFS Type**, as you would normally provide it to the `mount` command using the *`-t`* argument. See `man mount` for a list of valid VFS types.
9.  Enter additional **Mount Options**, as you would normally provide them to the `mount` command using the *`-o`* argument. The mount options should be provided in a comma-separated list. See `man mount` for a list of valid mount options.
10. Click **OK** to attach the new Storage Domain and close the window.

**Result**

You have used a supported mechanism to attach an unsupported file system as a storage domain.

### Preparing and Adding Block Storage

#### Preparing iSCSI Storage

**Summary**

These steps must be taken to export iSCSI storage device from a server running Red Hat Enterprise Linux 6 to use as a storage domain with oVirt.

⁠

**Procedure 7.6. Preparing iSCSI Storage**

1.  Install the **scsi-target-utils** package using the `yum` command as root on your storage server.
        # yum install -y scsi-target-utils

2.  Add the devices or files you want to export to the `/etc/tgt/targets.conf` file. Here is a generic example of a basic addition to the `targets.conf` file:
        <target iqn.YEAR-MONTH.com.EXAMPLE:SERVER.targetX>
                  backing-store /PATH/TO/DEVICE1 # Becomes LUN 1
                  backing-store /PATH/TO/DEVICE2 # Becomes LUN 2
                  backing-store /PATH/TO/DEVICE3 # Becomes LUN 3
        </target>

    Targets are conventionally defined using the year and month they are created, the reversed fully qualified domain that the server is in, the server name, and a target number.

3.  Start the **tgtd** service.
        # service tgtd start

4.  Make the **tgtd** start persistently across reboots.
        # chkconfig tgtd on

5.  Open an iptables firewall port to allow clients to access your iSCSI export. By default, iSCSI uses port 3260. This example inserts a firewall rule at position 6 in the INPUT table.
        # iptables -I INPUT 6 -p tcp --dport 3260 -j ACCEPT

6.  Save the iptables rule you just created.
        # service iptables save

**Result**

You have created a basic iSCSI export. You can use it as an iSCSI data domain.

#### Adding iSCSI Storage

**Summary**

oVirt platform supports iSCSI storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

For information regarding the setup and configuration of iSCSI on Red Hat Enterprise Linux, see the *Red Hat Enterprise Linux Storage Administration Guide*.

<div class="alert alert-info">
**Note:** You can only add an iSCSI storage domain to a data center that is set up for iSCSI storage type.

</div>
⁠

**Procedure 7.7. Adding iSCSI Storage**

1.  Click the **Storage** resource tab to list the existing storage domains in the results list.
2.  Click the **New Domain** button to open the **New Domain** window.
3.  Enter the **Name** of the new storage domain.
    ⁠

    ![New iSCSI Domain](New Domain iscsi.png "New iSCSI Domain")

    **Figure 7.4. New iSCSI Domain**

4.  Use the **Data Center** drop-down menu to select an iSCSI data center. If you do not yet have an appropriate iSCSI data center, select `(none)`.
5.  Use the drop-down menus to select the **Domain Function / Storage Type** and the **Format**. The storage domain types that are not compatible with the chosen data center are not available.
6.  Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.
    <div class="alert alert-info">
    **Important:** All communication to the storage domain is via the selected host and not directly from oVirt. At least one active host must exist in the system, and be attached to the chosen data center, before the storage is configured.

    </div>
7.  oVirt is able to map either iSCSI targets to LUNs, or LUNs to iSCSI targets. The **New Domain** window automatically displays known targets with unused LUNs when iSCSI is selected as the storage type. If the target that you are adding storage from is not listed then you can use target discovery to find it, otherwise proceed to the next step.
    **iSCSI Target Discovery**

    1.  Click **Discover Targets** to enable target discovery options. When targets have been discovered and logged in to, the **New Domain** window automatically displays targets with LUNs unused by the environment.
        <div class="alert alert-info">
        **Note:** LUNs used externally to the environment are also displayed.

        </div>
        You can use the **Discover Targets** options to add LUNs on many targets, or multiple paths to the same LUNs.

    2.  Enter the fully qualified domain name or IP address of the iSCSI host in the **Address** field.
    3.  Enter the port to connect to the host on when browsing for targets in the **Port** field. The default is `3260`.
    4.  If the Challenge Handshake Authentication Protocol (CHAP) is being used to secure the storage, select the **User Authentication** check box. Enter the **CHAP user name** and **CHAP password**.
    5.  Click the **Discover** button.
    6.  Select the target to use from the discovery results and click the **Login** button. Alternatively, click the **Login All** to log in to all of the discovered targets.

8.  Click the **+** button next to the desired target. This will expand the entry and display all unused LUNs attached to the target.
9.  Select the check box for each LUN that you are using to create the storage domain.
10. Click **OK** to create the storage domain and close the window.

**Result**

The new iSCSI storage domain displays on the storage tab. This can take up to 5 minutes.

#### Adding FCP Storage

**Summary**

oVirt platform supports SAN storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

oVirt system administrators need a working knowledge of Storage Area Networks (SAN) concepts. SAN usually uses Fibre Channel Protocol (FCP) for traffic between hosts and shared external storage. For this reason, SAN may occasionally be referred to as FCP storage.

For information regarding the setup and configuration of FCP or multipathing on Red Hat Enterprise Linux, please refer to the *Storage Administration Guide* and *DM Multipath Guide*.

<div class="alert alert-info">
**Note:** You can only add an FCP storage domain to a data center that is set up for FCP storage type.

</div>
**Procedure 7.8. Adding FCP Storage**

1.  Click the **Storage** resource tab to list all storage domains in the virtualized environment.
2.  Click **New Domain** to open the **New Domain** window.
3.  Enter the **Name** of the storage domain
    ⁠

    ![Adding FCP Storage](New Domain FCP.png "Adding FCP Storage")

    **Figure 7.5. Adding FCP Storage**

4.  Use the **Data Center** drop-down menu to select an FCP data center. If you do not yet have an appropriate FCP data center, select `(none)`.
5.  Use the drop-down menus to select the **Domain Function / Storage Type** and the **Format**. The storage domain types that are not compatible with the chosen data center are not available.
6.  Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.
    **Important**

    All communication to the storage domain is via the selected host and not directly from oVirt. At least one active host must exist in the system, and be attached to the chosen data center, before the storage is configured.

7.  The **New Domain** window automatically displays known targets with unused LUNs when **Data / Fibre Channel** is selected as the storage type. Select the **LUN ID** check box to select all of the available LUNs.
8.  Click **OK** to create the storage domain and close the window.

**Result**

The new FCP data domain displays on the **Storage** tab. It will remain with a `Locked` status while it is being prepared for use. When ready, it is automatically attached to the data center.

#### Unusable LUNs in oVirt

In certain circumstances, oVirt will not allow you to use a LUN to create a storage domain or virtual machine hard disk.

*   LUNs that are already part of the current oVirt environment are automatically prevented from being used.
*   LUNs that are already being used by the SPM host will also display as in use. You can choose to forcefully over ride the contents of these LUNs, but the operation is not guaranteed to succeed.

### Storage Tasks

#### Importing Existing ISO or Export Storage Domains

**Summary**

You have an ISO or export domain that you have been using with a different data center. You want to attach it to the data center you are using, and import virtual machines or use ISOs.

⁠

**Procedure 7.9. Importing an Existing ISO or Export Storage Domain**

1.  Click the **Storage** resource tab to list all the available storage domains in the results list.
2.  Click **Import Domain** to open the **Import Pre-Configured Domain** window.
    ⁠

    ![Import Domain](Import Domain.png "Import Domain")

    **Figure 7.6. Import Pre-Configured Domain**

3.  Select the appropriate **Domain Function / Storage Type** from the following:
    -   ISO
    -   Export

    The **Domain Function / Storage Type** determines the availability of the **Format** field.

4.  Select the SPM host from the **Use host** drop-down menu.
    <div class="alert alert-info">
    **Important:**All communication to the storage domain is via the selected host and not from oVirt. At least one host must be active and have access to the storage before the storage can be configured.

    </div>
5.  Enter the **Export path** of the storage. The export path can be either a static **IP address** or a resolvable hostname. For example, `192.168.0.10:/Images/ISO` or `storage.demo.redhat.com:/exports/iso`.
6.  Click **OK** to import the domain and close the window.
7.  The storage domain is imported and displays on the **Storage** tab. The next step is to attach it to a data center. This is described later in this chapter, .

**Result**

You have imported your export or ISO domain to you data center. Attach it to a data center to use it.

#### Populating the ISO Storage Domain

**Summary**

An ISO storage domain is attached to a data center, ISO images must be uploaded to it. oVirt provides an ISO uploader tool that ensures that the images are uploaded into the correct directory path, with the correct user permissions.

The creation of ISO images from physical media is not described in this document. It is assumed that you have access to the images required for your environment.

⁠

**Procedure 7.10. Populating the ISO Storage Domain**

1.  Copy the required ISO image to a temporary directory on the system running oVirt.
2.  Log in to the system running oVirt as the `root` user.
3.  Use the `engine-iso-uploader` command to upload the ISO image. This action will take some time, the amount of time varies depending on the size of the image being uploaded and available network bandwidth.
    ⁠

    **Example 7.1. ISO Uploader Usage**

    In this example the ISO image `RHEL6.iso` is uploaded to the ISO domain called `ISODomain` using NFS. The command will prompt for an administrative user name and password. The user name must be provided in the form *user name*@*domain*.

        # engine-iso-uploader --iso-domain=ISODomain upload RHEL6.iso

**Result**

The ISO image is uploaded and appears in the ISO storage domain specified. It is also available in the list of available boot media when creating virtual machines in the data center which the storage domain is attached to.

#### Moving Storage Domains to Maintenance Mode

**Summary**

Detaching and removing storage domains requires that they be in maintenance mode. This is required to redesignate another data domain as the master data domain.

Editing domains and expanding iSCSI domains by adding more LUNs can only be done when the domain is active.

<div class="alert alert-info">
**Important:** Put any active ISO and export domains in maintenance mode using this procedure.

</div>
⁠

**Procedure 7.11. Moving storage domains to maintenance mode**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the storage domain in the results list.
2.  Shut down and move all the virtual machines running on the storage domain.
3.  Click the **Data Centers** tab in the details pane.
4.  Click **Maintenance** to open the **Maintenance Storage Domain(s)** confirmation window.
5.  Click **OK** to initiate maintenance mode. The storage domain is deactivated and has an `Inactive` status in the results list.

**Result**

You can now edit, detach, remove, or reactivate the inactive storage domains from the data center.

<div class="alert alert-info">
**Note:** You can also activate, detach and place domains into maintenance mode using the Storage tab on the details pane of the data center it is associated with.

</div>

#### Editing a Resource

**Summary**

Edit the properties of a resource.

⁠

**Procedure 7.12. Editing a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click **Edit** to open the **Edit** window.
3.  Change the necessary properties and click **OK**.

**Result**

The new properties are saved to the resource. The **Edit** window will not close if a property field is invalid.

#### Activating Storage Domains

**Summary**

If you have been making changes to a data center's storage, you have to put storage domains into maintenance mode. Activate a storage domain to resume using it.

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the inactive storage domain in the results list.
2.  Click the **Data Centers** tab in the details pane.
3.  Select the appropriate data center and click **Activate**.
    <div class="alert alert-info">
    **Important:** If you attempt to activate the ISO domain before activating the data domain, an error message displays and the domain is not activated.

    </div>

**Result**

Your storage domain is active and ready for use.

#### Removing a Storage Domain

**Summary**

You have a storage domain in your data center that you want to remove from the virtualized environment.

⁠

**Procedure 7.13. Removing a Storage Domain**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the appropriate storage domain in the results list.
2.  Move the domain into maintenance mode to deactivate it.
3.  Detach the domain from the data center.
4.  Click **Remove** to open the **Remove Storage** confirmation window.
5.  Select a host from the list.
6.  Click **OK** to remove the storage domain and close the window.

**Summary**

The storage domain is permanently removed from the environment.

#### Destroying a Storage Domain

**Summary**

A storage domain encountering errors may not be able to be removed through the normal procedure. Destroying a storage domain will forcibly remove the storage domain from the virtualized environment without reference to the export directory.

When the storage domain is destroyed, you are required to manually fix the export directory of the storage domain before it can be used again.

⁠

**Procedure 7.14. Destroying a Storage Domain**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the appropriate storage domain in the results list.
2.  Right-click the storage domain and select **Destroy** to open the **Destroy Storage Domain** confirmation window.
3.  Select the **Approve operation** check box and click **OK** to destroy the storage domain and close the window.

**Result**

The storage domain has been destroyed. Manually clean the export directory for the storage domain to recycle it.

#### Detaching the Export Domain

**Summary**

Detach the export domain from the data center to import the templates to another data center.

⁠

**Procedure 7.15. Detaching an Export Domain from the Data Center**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the export domain in the results list.
2.  Click the **Data Centers** tab in the details pane and select the export domain.
3.  Click **Maintenance** to open the **Maintenance Storage Domain(s)** confirmation window.
4.  Click **OK** to initiate maintenance mode.
5.  Click **Detach** to open the **Detach Storage** confirmation window.
6.  Click **OK** to detach the export domain.

**Result**

The export domain has been detached from the data center, ready to be attached to another data center.

#### Attaching an Export Domain to a Data Center

**Summary**

Attach the export domain to a data center.

⁠

**Procedure 7.16. Attaching an Export Domain to a Data Center**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the export domain in the results list.
2.  Click the **Data Centers** tab in the details pane.
3.  Click **Attach** to open the **Attach to Data Center** window.
4.  Select the radio button of the appropriate data center.
5.  Click **OK** to attach the export domain.

**Result**

The export domain is attached to the data center and is automatically activated.

## Virtual Machines

### Introduction to Virtual Machines

A virtual machine is a software implementation of a computer. The oVirt environment enables you to create virtual desktops and virtual servers.

Virtual machines consolidate computing tasks and workloads. In traditional computing environments, workloads usually run on individually administered and upgraded servers. Virtual machines reduce the amount of hardware and administration required to run the same computing tasks and workloads.

### Supported Virtual Machine Operating Systems

The operating systems that can be virtualized as guest operating systems in oVirt are as follows:

⁠

**Table 8.1. Operating systems that can be used as guest operating systems**

<table>
<colgroup>
<col width="60%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Operating System</p></th>
<th align="left"><p>Architecture</p></th>
<th align="left"><p>SPICE support</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Red Hat Enterprise Linux 3</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Red Hat Enterprise Linux 4</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Red Hat Enterprise Linux 5</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Red Hat Enterprise Linux 6</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Red Hat Enterprise Linux 7</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>SUSE Linux Enterprise Server 10 (select <strong>Other Linux</strong> for the guest type in the user interface)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SUSE Linux Enterprise Server 11 (SPICE drivers (QXL) are not supplied by Red Hat. However, the distribution's vendor may provide SPICE drivers as part of their distribution.)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
<tr class="even">
<td align="left"><p>Ubuntu 12.04 (Precise Pangolin LTS)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Ubuntu 12.10 (Quantal Quetzal)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Ubuntu 13.04 (Raring Ringtail)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Ubuntu 13.10 (Saucy Salamander)</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Windows XP Service Pack 3 and newer</p></td>
<td align="left"><p>32-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Windows 7</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Windows 8</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Windows Server 2003 Service Pack 2 and newer</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Windows Server 2003 R2</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Windows Server 2008</p></td>
<td align="left"><p>32-bit, 64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="even">
<td align="left"><p>Windows Server 2008 R2</p></td>
<td align="left"><p>64-bit</p></td>
<td align="left"><p>Yes</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Windows Server 2012</p></td>
<td align="left"><p>64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
<tr class="even">
<td align="left"><p>Windows Server 2012 R2</p></td>
<td align="left"><p>64-bit</p></td>
<td align="left"><p>No</p></td>
</tr>
</tbody>
</table>

Remote Desktop Protocol (RDP) is the default connection protocol for accessing Windows 8 and Windows 2012 guests from the user portal as Microsoft introduced changes to the Windows Display Driver Model that prevent SPICE from performing optimally.

<div class="alert alert-info">
**Note:** While Red Hat Enterprise Linux 3 and Red Hat Enterprise Linux 4 are supported, virtual machines running the 32-bit version of these operating systems cannot be shut down gracefully from the administration portal because there is no ACPI support in the 32-bit x86 kernel. To terminate virtual machines running the 32-bit version of Red Hat Enterprise Linux 3 or Red Hat Enterprise Linux 4, right-click the virtual machine and select the **Power Off** option.

</div>

### Virtual Machine Performance Parameters

oVirt virtual machines can support the following parameters:

**Table 8.2. Supported virtual machine parameters**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Parameter</p></th>
<th align="left"><p>Number</p></th>
<th align="left"><p>Note</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Virtualized CPUs</p></td>
<td align="left"><p>160</p></td>
<td align="left"><p>per virtual machine</p></td>
</tr>
<tr class="even">
<td align="left"><p>Virtualized RAM</p></td>
<td align="left"><p>2TB</p></td>
<td align="left"><p>For a 64 bit virtual machine</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Virtualized RAM</p></td>
<td align="left"><p>4GB</p></td>
<td align="left"><p>per 32 bit virtual machine. Note, the virtual machine may not register the entire 4GB. The amount of RAM that the virtual machine recognizes is limited by its operating system.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Virtualized storage devices</p></td>
<td align="left"><p>8</p></td>
<td align="left"><p>per virtual machine</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Virtualized network interface controllers</p></td>
<td align="left"><p>8</p></td>
<td align="left"><p>per virtual machine</p></td>
</tr>
<tr class="even">
<td align="left"><p>Virtualized PCI devices</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>per virtual machine</p></td>
</tr>
</tbody>
</table>

### Creating Virtual Machines

#### Creating a Virtual Machine

**Summary**

You can create a virtual machine using a blank template and configure all of its settings.

**Procedure 8.1. Creating a Virtual Machine**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
    ⁠

    ![The New Virtual Machine Window](New Virtual Machine.png "The New Virtual Machine Window")

    **Figure 8.1. The New Virtual Machine Window**

3.  On the **General** tab, fill in the **Name** and **Operating System** fields. You can accept the default settings for other fields, or change them if required.
4.  Alternatively, click the **Initial Run**, **Console**, **Host**, **Resource Allocation**, **Boot Options**, and **Custom Properties** tabs in turn to define options for your virtual machine.
5.  Click **OK** to create the virtual machine and close the window. The **New Virtual Machine - Guide Me** window opens.
6.  Use the Guide Me buttons to complete configuration or click **Configure Later** to close the window.

**Result**

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`. Before you can use this virtual machine, add at least one network interface and one virtual disk, and install an operating system.

#### Creating a Virtual Machine Based on a Template

**Summary**

You can create virtual machines based on templates. This allows you to create virtual machines that are pre-configured with an operating system, network interfaces, applications and other resources.

<div class="alert alert-info">
**Note:** Virtual machines created based on a template depend on that template. This means that you cannot remove that template from oVirt if there is a virtual machine that was created based on that template. However, you can clone a virtual machine from a template to remove the dependency on that template.

</div>
⁠

**Procedure 8.2. Creating a Virtual Machine Based on a Template**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
3.  Select the **Cluster** on which the virtual machine will run.
4.  Select a template from the **Based on Template** drop-down menu.
5.  Select a template sub version from the **Template Sub Version** drop-down menu.
6.  Enter a **Name**, **Description** and any **Comments**, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.
7.  Click the **Show Advanced Options** button.
8.  Click the **Resource Allocation** tab.
    ![Provisioning - Thin](New Virtual Machine Resource Allocation.png "Provisioning - Thin")

    **Figure 8.2. Provisioning - Thin**

9.  Select the **Thin** radio button in the **Storage Allocation** area.
10. Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.
    -   Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.
    -   Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

11. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.
12. Click **OK**.

**Result**

The virtual machine is created and displayed in the list in the **Virtual Machines** tab. You can now log on to the virtual machine and begin using it, or assign users to it.

#### Creating a Cloned Virtual Machine Based on a Template

**Summary**

Cloned virtual machines are similar to virtual machines based on templates. However, while a cloned virtual machine inherits settings in the same way as a virtual machine based on a template, a cloned virtual machine does not depend on the template on which it was based after it has been created.

<div class="alert alert-info">
**Note:** If you clone a virtual machine from a template, the name of the template on which that virtual machine was based is displayed in the **General** tab of the **Edit Virtual Machine** window for that virtual machine. If you change the name of that template, the name of the template in the **General** tab will also be updated. However, if you delete the template from oVirt, the original name of that template will be displayed instead.

</div>
⁠

**Procedure 8.3. Cloning a Virtual Machine Based on a Template**

1.  Click the **Virtual Machines** tab.
2.  Click the **New VM** button to open the **New Virtual Machine** window.
3.  Select the **Cluster** on which the virtual machine will run.
4.  Select a template from the **Based on Template** drop-down menu.
5.  Select a template sub version from the **Template Sub Version** drop-down menu.
6.  Enter a **Name**, **Description** and any **Comments**. You can accept the default values inherited from the template in the rest of the fields, or change them if required.
7.  Click the **Show Advanced Options** button.
8.  Click the **Resource Allocation** tab.
    ![Provisioning - Clone](New Virtual Machine Clone Allocation.png "Provisioning - Clone")

    **Figure 8.3. Provisioning - Clone**

9.  Select the **Clone** radio button in the **Storage Allocation** area.
10. Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.
    -   Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.
    -   Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

11. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.
12. Click **OK**.

<div class="alert alert-info">
**Note:** Cloning a virtual machine may take some time. A new copy of the template's disk must be created. During this time, the virtual machine's status is first **Image Locked**, then **Down**.

</div>
**Result**

The virtual machine is created and displayed in the list in the **Virtual Machines** tab. You can now assign users to it, and can begin using it when the clone operation is complete.

### Explanation of Settings and Controls in the New Virtual Machine and Edit Virtual Machine Windows

#### Virtual Machine General Settings Explained

The following table details the options available on the **General** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.3. Virtual Machine: General Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Cluster</strong></p></td>
<td align="left"><p>The name of the host cluster to which the virtual machine is attached. Virtual machines are hosted on any physical machine in that cluster in accordance with policy rules.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Based on Template</strong></p></td>
<td align="left"><p>The template on which the virtual machine can be based. This field is set to <code>Blank</code> by default, which allows you to create a virtual machine on which an operating system has not yet been installed.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Template Sub Version</strong></p></td>
<td align="left"><p>The version of the template on which the virtual machine can be based. This field is set to the most recent version for the given template by default. If no versions other than the base template are available, this field is set to <code>base template</code> by default. Each version is marked by a number in brackets that indicates the relative order of the versions, with higher numbers indicating more recent versions.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Operating System</strong></p></td>
<td align="left"><p>The operating system. Valid values include a range of Red Hat Enterprise Linux and Windows variants.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Optimized for</strong></p></td>
<td align="left"><p>The type of system for which the virtual machine is to be optimized. There are two options: <strong>Server</strong>, and <strong>Desktop</strong>; by default, the field is set to <strong>Server</strong>. Virtual machines optimized to act as servers have no sound card, use a cloned disk image, and are not stateless. In contrast, virtual machines optimized to act as desktop machines do have a sound card, use an image (thin allocation), and are stateless.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the virtual machine. Names must not contain any spaces, and must contain at least one character from A-Z or 0-9. The maximum length of a virtual machine name is 64 characters.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>A meaningful description of the new virtual machine.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text human-readable comments regarding the virtual machine.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Stateless</strong></p></td>
<td align="left"><p>Select this check box to run the virtual machine in stateless mode. This mode is used primarily for desktop VMs. Running a stateless desktop or server creates a new COW layer on the VM hard disk image where new and changed data is stored. Shutting down the stateless VM deletes the new COW layer, which returns the VM to its original state. Stateless VMs are useful when creating machines that need to be used for a short time, or by temporary staff.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Start in Pause Mode</strong></p></td>
<td align="left"><p>Select this check box to always start the virtual machine in pause mode. This option is suitable for VMs which require a long time to establish a SPICE connection; for example, VMs in remote locations.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Delete Protection</strong></p></td>
<td align="left"><p>Select this check box to make it impossible to delete the virtual machine. It is only possible to delete the virtual machine if this check box is not selected.</p></td>
</tr>
</tbody>
</table>

At the bottom of the **General** tab is a drop-down box that allows you to assign network interfaces to the new virtual machine. Use the plus and minus buttons to add or remove additional network interfaces.

#### Virtual Machine System Settings Explained

The following table details the options available on the **System** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.4. Virtual Machine: System Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Memory Size</strong></p></td>
<td align="left"><p>The amount of memory assigned to the virtual machine. When allocating memory, consider the processing and storage needs of the applications that are intended to run on the virtual machine. Maximum guest memory is constrained by the selected guest architecture and the cluster compatibility level.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Total Virtual CPUs</strong></p></td>
<td align="left"><p>The processing power allocated to the virtual machine as CPU Cores. Do not assign more cores to a virtual machine than are present on the physical host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Cores per Virtual Socket</strong></p></td>
<td align="left"><p>The number of cores assigned to each virtual socket.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Virtual Sockets</strong></p></td>
<td align="left"><p>The number of CPU sockets for the virtual machine. Do not assign more sockets to a virtual machine than are present on the physical host.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine Initial Run Settings Explained

The following table details the options available on the **Initial Run** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows. The settings in this table are only visible if the **Use Cloud-Init/Sysprep** check box is selected.

⁠

**Table 8.5. Virtual Machine: Initial Run Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Use Cloud-Init/Sysprep</strong></p></td>
<td align="left"><p>This check box toggles whether Cloud-Init or Sysprep will be used to initialize the virtual machine.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VM Hostname</strong></p></td>
<td align="left"><p>Allows you to specify a host name for the virtual machine.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Configure Time Zone</strong></p></td>
<td align="left"><p>Allows you to apply a specific time zone for the virtual machine. Select this check box and select a time zone from the <strong>Time Zone</strong> drop-down menu.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Authentication</strong></p></td>
<td align="left"><p>Allows you to configure authentication details for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
<ul>
<li><strong>Use already configured password</strong>: Allows you to specify that any passwords that have been configured for the virtual machine will be used.</li>
<li><strong>Root Password</strong>: Allows you to specify a root password for the virtual machine. Enter the password in this text field and the <strong>Verify Root Password</strong> text field to verify the password.</li>
<li><strong>SSH Authorized Keys</strong>: Allows you to specify SSH keys to be added to the authorized keys file of the virtual machine.</li>
<li><strong>Regenerate SSH Keys</strong>: Allows you to regenerate SSH keys for the virtual machine.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Networks</strong></p></td>
<td align="left"><p>Allows you to specify network-related settings for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
<ul>
<li><strong>DNS Servers</strong>: Allows you to specify the DNS servers to be used by the virtual machine.</li>
<li><strong>DNS Search Domains</strong>: Allows you to specify the DNS search domains to be used by the virtual machine.</li>
<li><strong>Network</strong>: Allows you to configure network interfaces for the virtual machine. Select this check box and use the <strong>+</strong> and <strong>-</strong> buttons to add or remove network interfaces to or from the virtual machine. When you click the <strong>+</strong> button, a set of fields becomes visible that allow you to specify whether to use DHCP, and configure an IP address, netmask, and gateway, and also specify whether the network interface will start on boot.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Custom Script</strong></p></td>
<td align="left"><p>Allows you to enter custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by oVirt, and allow you to automate tasks such as creating users and files, configuring <strong>yum</strong> repositories and running commands. For more information on the format of scripts that can be entered in this field, see the <a href="http://www.ovirt.org/Features/vm-init-persistent#Custom_Script">Custom Script</a> documentation.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine Console Settings Explained

The following table details the options available on the **Console** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.6. Virtual Machine: Console Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Protocol</strong></p></td>
<td align="left"><p>Defines which display protocol to use. <strong>SPICE</strong> is the recommended protocol for Linux and Windows virtual machines, excepting Windows 8 and Windows Server 2012. Optionally, select <strong>VNC</strong> for Linux virtual machines. A VNC client is required to connect to a virtual machine using the VNC protocol.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VNC Keyboard Layout</strong></p></td>
<td align="left"><p>Defines the keyboard layout for the virtual machine. This option is only available when using the VNC protocol.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>USB Support</strong></p></td>
<td align="left"><p>Defines whether USB devices can be used on the virtual machine. This option is only available for virtual machines using the SPICE protocol. Select either:</p>
<ul>
<li><strong>Disabled</strong> - Does not allow USB redirection from the client machine to the virtual machine.</li>
<li><strong>Legacy</strong> - Enables the SPICE USB redirection policy used in oVirt 3.0. This option can only be used on Windows virtual machines, and will not be supported in future versions of oVirt.</li>
<li><strong>Native</strong> - Enables native KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual machines do not require any in-guest agents or drivers for native USB. This option can only be used if the virtual machine's cluster compatibility version is set to 3.1 or higher.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Monitors</strong></p></td>
<td align="left"><p>The number of monitors for the virtual machine. This option is only available for virtual desktops using the SPICE display protocol. You can choose <strong>1</strong>, <strong>2</strong> or <strong>4</strong>. Since Windows 8 and Windows Server 2012 virtual machines do not support the SPICE protocol, they do not support multiple monitors.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Smartcard Enabled</strong></p></td>
<td align="left"><p>Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines. Tick or untick the check box to activate and deactivate Smart card authentication for individual virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Disable strict user checking</strong></p></td>
<td align="left"><p>Click the <strong>Advanced Parameters</strong> arrow and select the check box to use this option. With this option selected, the virtual machine does not need to be rebooted when a different user connects to it. By default, strict checking is enabled so that only one user can connect to the console of a virtual machine. No other user is able to open a console to the same virtual machine until it has been rebooted. The exception is that a <code>SuperUser</code> can connect at any time and replace a existing connection. When a <code>SuperUser</code> has connected, no normal user can connect again until the virtual machine is rebooted. Disable strict checking with caution, because you can expose the previous user's session to the new user.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Soundcard Enabled</strong></p></td>
<td align="left"><p>A sound card device is not necessary for all virtual machine use cases. If it is for yours, enable a sound card here.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VirtIO Console Device Enabled</strong></p></td>
<td align="left"><p>The VirtIO console device is a console over VirtIO transport for communication between the host user space and guest user space. It has two parts: device emulation in QEMU that presents a virtio-pci device to the guest, and a guest driver that presents a character device interface to user space applications. Tick the check box to attach a VirtIO console device to your virtual machine.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine Host Settings Explained

The following table details the options available on the **Host** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.7. Virtual Machine: Host Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Start Running On</strong></p></td>
<td align="left"><p>Defines the preferred host on which the virtual machine is to run. Select either:</p>
<ul>
<li><strong>Any Host in Cluster</strong> - The virtual machine can start and run on any available host in the cluster.</li>
<li><strong>Specific</strong> - The virtual machine will start running on a particular host in the cluster. However, oVirt or an administrator can migrate the virtual machine to a different host in the cluster depending on the migration and high-availability settings of the virtual machine. Select the specific host from the drop-down list of available hosts.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Migration Options</strong></p></td>
<td align="left"><p>Defines options to run and migrate the virtual machine. If the options here are not used, the virtual machine will run or migrate according to its cluster's policy.</p>
<ul>
<li><strong>Allow manual and automatic migration</strong> - The virtual machine can be automatically migrated from one host to another in accordance with the status of the environment, or manually by an administrator.</li>
<li><strong>Allow manual migration only</strong> - The virtual machine can only be migrated from one host to another manually by an administrator.</li>
<li><strong>Do not allow migration</strong> - The virtual machine cannot be migrated, either automatically or manually.</li>
</ul>
<p>The <strong>Use Host CPU</strong> check box allows virtual machines to take advantage of the features of the physical CPU of the host on which they are situated. This option can only be enabled when <strong>Allow manual migration only</strong> or <strong>Do not allow migration</strong> are selected. The <strong>Use custom migration downtime</strong> check box allows you to specify the maximum number of milliseconds the virtual machine can be down during live migration. Configure different maximum downtimes for each virtual machine according to its workload and SLA requirements. The VDSM default value is 0.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine High Availability Settings Explained

The following table details the options available on the **High Availability** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.8. Virtual Machine: High Availability Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Highly Available</strong></p></td>
<td align="left"><p>Select this check box if the virtual machine is to be highly available. For example, in cases of host maintenance or failure, the virtual machine is automatically moved to or re-launched on another host. If the host is manually shut down by the system administrator, the virtual machine is not automatically moved to another host. Note that this option is unavailable if the <strong>Migration Options</strong> setting in the <strong>Hosts</strong> tab is set to either <strong>Allow manual migration only</strong> or <strong>No migration</strong>. For a virtual machine to be highly available, it must be possible for oVirt to migrate the virtual machine to other available hosts as necessary.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Priority for Run/Migration queue</strong></p></td>
<td align="left"><p>Sets the priority level for the virtual machine to be migrated or restarted on another host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Watchdog</strong></p></td>
<td align="left"><p>Allows users to attach a watchdog card to a virtual machine. A watchdog is a timer that is used to automatically detect and recover from failures. Once set, a watchdog timer continually counts down to zero while the system is in operation, and is periodically restarted by the system to prevent it from reaching zero. If the timer reaches zero, it signifies that the system has been unable to reset the timer and is therefore experiencing a failure. Corrective actions are then taken to address the failure. This functionality is especially useful for servers that demand high availability. <strong>Watchdog Model</strong>: The model of watchdog card to assign to the virtual machine. At current, the only supported model is <strong>i6300esb</strong>. <strong>Watchdog Action</strong>: The action to take if the watchdog timer reaches zero. The following actions are available:</p>
<ul>
<li><strong>none</strong> - No action is taken. However, the watchdog event is recorded in the audit log.</li>
<li><strong>reset</strong> - The virtual machine is reset and oVirt is notified of the reset action.</li>
<li><strong>poweroff</strong> - The virtual machine is immediately shut down.</li>
<li><strong>dump</strong> - A dump is performed and the virtual machine is paused.</li>
<li><strong>pause</strong> - The virtual machine is paused, and can be resumed by users.</li>
</ul></td>
</tr>
</tbody>
</table>

#### Virtual Machine Resource Allocation Settings Explained

The following table details the options available on the **Resource Allocation** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.9. Virtual Machine: Resource Allocation Settings**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Sub-element</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>CPU Allocation</strong></p></td>
<td align="left"><p><strong>CPU Shares</strong></p></td>
<td align="left"><p>Allows users the set the level of CPU resources a virtual machine can demand relative to other virtual machines.</p>
<ul>
<li><strong>Low</strong> - 512</li>
<li><strong>Medium</strong> - 1024</li>
<li><strong>High</strong> - 2048</li>
<li><strong>Custom</strong> - A custom level of CPU shares defined by the user.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left"><p><strong>CPU Pinning topology</strong></p></td>
<td align="left"><p>Enables the virtual machine's virtual CPU (vCPU) to run on a specific physical CPU (pCPU) in a specific host. This option is not supported if the virtual machine's cluster compatibility version is set to 3.0. The syntax of CPU pinning is <code>v#p[_v#p]</code>, for example:</p>
<ul>
<li><code>0#0</code> - Pins vCPU 0 to pCPU 0.</li>
<li><code>0#0_1#3</code> - Pins vCPU 0 to pCPU 0, and pins vCPU 1 to pCPU 3.</li>
<li><code>1#1-4,^2</code> - Pins vCPU 1 to one of the pCPUs in the range of 1 to 4, excluding pCPU 2.</li>
</ul>
<p>In order to pin a virtual machine to a host, you must select <strong>Do not allow migration</strong> under <strong>Migration Options</strong>, and select the <code>Use Host CPU</code> check box.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Memory Allocation</strong></p></td>
<td align="left"></td>
<td align="left"><p>The amount of physical memory guaranteed for this virtual machine.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Storage Allocation</strong></p></td>
<td align="left"></td>
<td align="left"><p>The <strong>Template Provisioning</strong> option is only available when the virtual machine is created from a template.</p></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left"><p><strong>Thin</strong></p></td>
<td align="left"><p>Provides optimized usage of storage capacity. Disk space is allocated only as it is required.</p></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left"><p><strong>Clone</strong></p></td>
<td align="left"><p>Optimized for the speed of guest read and write operations. All disk space requested in the template is allocated at the time of the clone operation.</p></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left"><p><strong>VirtIO-SCSI Enabled</strong></p></td>
<td align="left"><p>Allows users to enable or disable the use of VirtIO-SCSI on the virtual machines.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine Boot Options Settings Explained

The following table details the options available on the **Boot Options** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows

⁠

**Table 8.10. Virtual Machine: Boot Options Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>First Device</strong></p></td>
<td align="left"><p>After installing a new virtual machine, the new virtual machine must go into Boot mode before powering up. Select the first device that the virtual machine must try to boot:</p>
<ul>
<li><strong>Hard Disk</strong></li>
<li><strong>CD-ROM</strong></li>
<li><strong>Network (PXE)</strong></li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Second Device</strong></p></td>
<td align="left"><p>Select the second device for the virtual machine to use to boot if the first device is not available. The first device selected in the previous option does not appear in the options.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Attach CD</strong></p></td>
<td align="left"><p>If you have selected <strong>CD-ROM</strong> as a boot device, tick this check box and select a CD-ROM image from the drop-down menu. The images must be available in the ISO domain.</p></td>
</tr>
</tbody>
</table>

#### Virtual Machine Custom Properties Settings Explained

The following table details the options available on the **Custom Properties** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

⁠

**Table 8.11. Virtual Machine: Custom Properties Settings**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
<th align="left"><p>Recommendations and Limitations</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>sap_agent</strong></p></td>
<td align="left"><p>Enables SAP monitoring on the virtual machine. Set to <strong>true</strong> or <strong>false</strong>.</p></td>
</tr>
<tr class="even">
</tr>
<tr class="odd">
<td align="left"><p><strong>sndbuf</strong></p></td>
<td align="left"><p>Enter the size of the buffer for sending the virtual machine's outgoing data over the socket. Default value is 0.</p></td>
</tr>
<tr class="even">
</tr>
<tr class="odd">
<td align="left"><p><strong>vhost</strong></p></td>
<td align="left"><p>Disables vhost-net, which is the kernel-based virtio network driver on virtual network interface cards attached to the virtual machine. To disable vhost, the format for this property is:</p>
<pre><code>LogicalNetworkName: false</code></pre>
<p>This will explicitly start the virtual machine without the vhost-net setting on the virtual NIC attached to <em>LogicalNetworkName</em>.</p></td>
<td align="left"><p>vhost-net provides better performance than virtio-net, and if it is present, it is enabled on all virtual machine NICs by default. Disabling this property makes it easier to isolate and diagnose performance issues, or to debug vhost-net errors; for example, if migration fails for virtual machines on which vhost does not exist.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>viodiskcache</strong></p></td>
<td align="left"><p>Caching mode for the virtio disk. <strong>writethrough</strong> writes data to the cache and the disk in parallel, <strong>writeback</strong> does not copy modifications from the cache to the disk, and <strong>none</strong> disables caching.</p></td>
<td align="left"><p>For oVirt 3.1, if viodiskcache is enabled, the virtual machine cannot be live migrated.</p></td>
</tr>
</tbody>
</table>

<div class="alert alert-info">
**Warning:** Increasing the value of the sndbuf custom property results in increased occurrences of communication failure between hosts and unresponsive virtual machines.

</div>

### Configuring Virtual Machines

#### Completing the Configuration of a Virtual Machine by Defining Network Interfaces and Hard Disks

**Summary**

Before you can use your newly created virtual machine, the **Guide Me** window prompts you to configure at least one network interface and one virtual disk for the virtual machine.

**Procedure 8.4. Completing the Configuration of a Virtual Machine by Defining Network Interfaces and Hard Disks**

1.  On the **New Virtual Machine - Guide Me** window, click the **Configure Network Interfaces** button to open the **New Network Interface** window. You can accept the default values or change them as necessary.
2.  Enter the **Name** of the network interface.
3.  Use the drop-down menus to select the **Network** and the **Type** of network interface for the new virtual machine. The **Link State** is set to **Up** by default when the NIC is defined on the virtual machine and connected to the network.
    <div class="alert alert-info">
    **Note:** The options on the **Network** and **Type** fields are populated by the networks available to the cluster, and the NICs available to the virtual machine.

    </div>
4.  If applicable, select the **Specify custom MAC address** check box and enter the network interface's MAC address.
5.  Click the arrow next to **Advanced Parameters** to configure the **Port Mirroring** and **Card Status** fields, if necessary.
6.  Click **OK** to close the **New Network Interface** window and open the **New Virtual Machine - Guide Me** window.
7.  Click the **Configure Virtual Disk** button to open the **New Virtual Disk** window.
8.  Add either an **Internal** virtual disk or an **External** LUN to the virtual machine.
    ⁠

    ![Add Virtual Disk Window](Add Virtual Disk.png "Add Virtual Disk Window")

    **Figure 8.4. Add Virtual Disk Window**

9.  Click **OK** to close the **New Virtual Disk** window. The **New Virtual Machine - Guide Me** window opens with changed context. There is no further mandatory configuration.
10. Click **Configure Later** to close the window.

**Result**

You have added a network interface and a virtual disk to your virtual machine.

#### Installing Windows on VirtIO-Optimized Hardware

**Summary**

The `virtio-win.vfd` diskette image contains Windows drivers for VirtIO-optimized disk and network devices. These drivers provide a performance improvement over emulated device drivers.

The `virtio-win.vfd` is placed automatically on ISO storage domains that are hosted on oVirt server. It must be manually uploaded using the **engine-iso-uploader** tool to other ISO storage domains.

You can install the VirtIO-optimized device drivers during your Windows installation by attaching a diskette to your virtual machine.

This procedure presumes that you added a `Red Hat VirtIO` network interface and a disk that uses the `VirtIO` interface to your virtual machine.

⁠

**Procedure 8.5. Installing VirtIO Drivers during Windows Installation**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Run Once** button, and the **Run Once** window displays.
3.  Click **Boot Options** to expand the **Boot Options** configuration options.
4.  Click the **Attach Floppy** check box, and select `virtio-win.vfd` from the drop down selection box.
5.  Click the **Attach CD** check box, and select from the drop down selection box the ISO containing the version of Windows you want to install.
6.  Move **CD-ROM** **UP** in the **Boot Sequence** field.
7.  Configure the rest of your **Run Once** options as required, and click **OK** to start your virtual machine, and then click the **Console** button to open a graphical console to your virtual machine.

**Result**

Windows installations include an option to load additional drivers early in the installation process. Use this option to load drivers from the `virtio-win.vfd` diskette that was attached to your virtual machine as `A:`.

For each supported virtual machine architecture and Windows version, there is a folder on the disk containing optimized hardware device drivers.

#### Virtual Machine Run Once Settings Explained

The **Run Once** window defines one-off boot options for a virtual machine. For persistent boot options, use the **Boot Options** tab in the **New Virtual Machine** window. The following table details the information required for the **Run Once** window.

**Table 8.12. Virtual Machine: Run Once Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Boot Options</strong></p></td>
<td align="left"><p>Defines the virtual machine's boot sequence, running options, and source images for installing the operating system and required drivers.</p>
<ul>
<li><strong>Attach Floppy</strong> - Attaches a diskette image to the virtual machine. Use this option to install Windows drivers. The diskette image must reside in the ISO domain.</li>
<li><strong>Attach CD</strong> - Attaches an ISO image to the virtual machine. Use this option to install the virtual machine's operating system and applications. The CD image must reside in the ISO domain.</li>
<li><strong>Boot Sequence</strong> - Determines the order in which the boot devices are used to boot the virtual machine. Select either <strong>Hard Disk</strong>, <strong>CD-ROM</strong> or <strong>Network</strong>, and use the arrow keys to move the option up or down.</li>
<li><strong>Run Stateless</strong> - Deletes all changes to the virtual machine upon shutdown. This option is only available if a virtual disk is attached to the virtual machine.</li>
<li><strong>Start in Pause Mode</strong> - Starts then pauses the virtual machine to enable connection to the console, suitable for virtual machines in remote locations.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Linux Boot Options</strong></p></td>
<td align="left"><p>The following options boot a Linux kernel directly instead of through the BIOS bootloader.</p>
<ul>
<li><strong>kernel path</strong> - A fully qualified path to a kernel image to boot the virtual machine. The kernel image must be stored on either the ISO domain (path name in the format of <code>iso://path-to-image</code>) or on the host's local storage domain (path name in the format of <code>/data/images</code>).</li>
<li><strong>initrd path</strong> - A fully qualified path to a ramdisk image to be used with the previously specified kernel. The ramdisk image must be stored on the ISO domain (path name in the format of <code>iso://path-to-image</code>) or on the host's local storage domain (path name in the format of <code>/data/images</code>).</li>
<li><strong>kernel params</strong> - Kernel command line parameter strings to be used with the defined kernel on boot.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Initial Run</strong></p></td>
<td align="left"><p>Specifies whether Cloud-Init is used to initialize the virtual machine. If selected, the following settings become available to configure this feature:</p>
<ul>
<li><strong>VM Hostname</strong> - Specify a host name for the virtual machine.</li>
<li><strong>Configure Time Zone</strong> - Apply a specific time zone for the virtual machine. Select this check box and select a time zone from the <strong>Time Zone</strong> drop-down menu to specify the time zone.</li>
</ul>
<p><strong>Authentication</strong></p>
<ul>
<li><strong>Use already configured password</strong> - Specifies that any passwords that have been configured for the virtual machine will be used.</li>
<li><strong>Root Password</strong> - Specify a root password for the virtual machine. Enter the password in this text field and the <strong>Verify Root Password</strong> text field to verify the password.</li>
<li><strong>SSH Authorized Keys</strong> - Specify SSH keys to be added to the authorized keys file of the virtual machine.</li>
<li><strong>Regenerate SSH Keys</strong> - Regenerates SSH keys for the virtual machine.</li>
</ul>
<p><strong>Networks</strong></p>
<ul>
<li><strong>DNS Servers</strong>: Specify the DNS servers to be used by the virtual machine.</li>
<li><strong>DNS Search Domains</strong>: Specify the DNS search domains to be used by the virtual machine.</li>
<li><strong>Network</strong>: Configures network interfaces for the virtual machine. Select this check box and use the <strong>+</strong> and <strong>-</strong> buttons to add or remove network interfaces to or from the virtual machine. When you click the <strong>+</strong> button, a set of fields becomes visible that can specify whether to use DHCP, and configure an IP address, netmask, and gateway, and specify whether the network interface will start on boot.</li>
</ul>
<p><strong>Custom Script</strong></p>
<ul>
<li>Enter custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by oVirt. They automate tasks such as creating users and files, configuring <strong>yum</strong> repositories and running commands. For more information on the format of scripts that can be entered in this field, see the <a href="http://www.ovirt.org/Features/vm-init-persistent#Custom_Script">Custom Script</a> documentation.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Host</strong></p></td>
<td align="left"><p>Defines the virtual machine's host.</p>
<ul>
<li><strong>Any host in cluster:</strong> - Allocates the virtual machine to any available host.</li>
<li><strong>Specific</strong> - Specifies a user-defined host for the virtual machine.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Display Protocol</strong></p></td>
<td align="left"><p>Defines the protocol to connect to virtual machines.</p>
<ul>
<li><strong>VNC</strong> - Can be used for Linux virtual machines. Requires a VNC client to connect to a virtual machine using VNC. Optionally, specify <strong>VNC Keyboard Layout</strong> from the drop-down menu.</li>
<li><strong>SPICE</strong> - Recommended protocol for Linux and Windows virtual machines, excepting Windows 8 and Server 2012 virtual machines.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Custom Properties</strong></p></td>
<td align="left"><p>Additional VDSM options for running virtual machines.</p>
<ul>
<li><strong>sap_agent</strong> - Enables SAP monitoring on the virtual machine. Set to <strong>true</strong> or <strong>false</strong>.</li>
<li><strong>sndbuf</strong> - Enter the size of the buffer for sending the virtual machine's outgoing data over the socket.</li>
<li><strong>vhost</strong> - Enter the name of the virtual host on which this virtual machine should run. The name can contain any combination of letters and numbers.</li>
<li><strong>viodiskcache</strong> - Caching mode for the virtio disk. <strong>writethrough</strong> writes data to the cache and the disk in parallel, <strong>writeback</strong> does not copy modifications from the cache to the disk, and <strong>none</strong> disables caching.</li>
</ul></td>
</tr>
</tbody>
</table>

#### Configuring a Watchdog

##### Adding a Watchdog Card to a Virtual Machine

**Summary**

Add a watchdog card to a virtual machine.

⁠

**Procedure 8.6. Adding a Watchdog Card to a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** to open the **Edit Virtual Machine** window.
3.  Click **Show Advanced Options** to display all tabs and click the **High Availability** tab.
4.  Select the watchdog model to use from the **Watchdog Model** drop-down menu.
5.  Select an action from the **Watchdog Action** drop-down menu. This is the action that the virtual machine takes when the watchdog is triggered.
6.  Click **OK**.

**Result**

You have added a watchdog card to the virtual machine.

##### Installing a Watchdog

**Summary**

To activate a watchdog card attached to a virtual machine, you must install the watchdog package on that virtual machine and start the `watchdog` service.

⁠

**Procedure 8.7. Installing a Watchdog**

1.  Log on to the virtual machine on which the watchdog card is attached.
2.  Run the following command to install the watchdog package and dependencies:
        # yum install watchdog

3.  Edit the `/etc/watchdog.conf` file and uncomment the following line:
        watchdog-device = /dev/watchdog

4.  Save the changes.
5.  Run the following commands to start the `watchdog` service and ensure this service starts on boot:
        # service watchdog start
        # chkconfig watchdog on

**Result**

You have installed and started the `watchdog` service on a virtual machine.

##### Confirming Watchdog Functionality

**Summary**

Confirm that a watchdog card has been attached to a virtual machine and that the `watchdog` service is active.

<div class="alert alert-info">
**Warning:** This procedure is provided for testing the functionality of watchdogs only and must not be run on production machines.

</div>
⁠

**Procedure 8.8. Confirming Watchdog Functionality**

1.  Log on to the virtual machine on which the watchdog card is attached.
2.  Run the following command to confirm that the watchdog card has been identified by the virtual machine:
        # lspci | grep watchdog -i

3.  Run one of the following commands to confirm that the watchdog is active:
    -   Run the following command to trigger a kernel panic:
            # echo c > /proc/sysrq-trigger

    -   Run the following command to terminate the `watchdog` service:
            # kill -9 `pgrep watchdog`

**Result**

The watchdog timer can no longer be reset, so the watchdog counter reaches zero after a short period of time. When the watchdog counter reaches zero, the action specified in the **Watchdog Action** drop-down menu for that virtual machine is performed.

##### Parameters for Watchdogs in watchdog.conf

The following is a list of options for configuring the `watchdog` service available in the `/etc/watchdog.conf` file. To configure an option, you must ensure that option is uncommented and restart the `watchdog` service after saving the changes.

<div class="alert alert-info">
**Note:** For a more detailed explanation of options for configuring the `watchdog` service and using the `watchdog` command, see the `watchdog` man page.

</div>
**Table 8.13. watchdog.conf variables**

<table>
<colgroup>
<col width="40%" />
<col width="20%" />
<col width="40%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Variable name</p></th>
<th align="left"><p>Default Value</p></th>
<th align="left"><p>Remarks</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>ping</code></p></td>
<td align="left"><p>N/A</p></td>
<td align="left"><p>An IP address that the watchdog attempts to ping to verify whether that address is reachable. You can specify multiple IP addresses by adding additional <code>ping</code> lines.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>interface</code></p></td>
<td align="left"><p>N/A</p></td>
<td align="left"><p>A network interface that the watchdog will monitor to verify the presence of network traffic. You can specify multiple network interfaces by adding additional <code>interface</code> lines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>file</code></p></td>
<td align="left"><p><code>/var/log/messages</code></p></td>
<td align="left"><p>A file on the local system that the watchdog will monitor for changes. You can specify multiple files by adding additional <code>file</code> lines.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>change</code></p></td>
<td align="left"><p><code>1407</code></p></td>
<td align="left"><p>The number of watchdog intervals after which the watchdog checks for changes to files. A <code>change</code> line must be specified on the line directly after each <code>file</code> line, and applies to the <code>file</code> line directly above that <code>change</code> line.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>max-load-1</code></p></td>
<td align="left"><p><code>24</code></p></td>
<td align="left"><p>The maximum average load that the virtual machine can sustain over a one-minute period. If this average is exceeded, then the watchdog is triggered. A value of <code>0</code> disables this feature.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>max-load-5</code></p></td>
<td align="left"><p><code>18</code></p></td>
<td align="left"><p>The maximum average load that the virtual machine can sustain over a five-minute period. If this average is exceeded, then the watchdog is triggered. A value of <code>0</code> disables this feature. By default, the value of this variable is set to a value approximately three quarters that of <code>max-load-1</code>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>max-load-15</code></p></td>
<td align="left"><p><code>12</code></p></td>
<td align="left"><p>The maximum average load that the virtual machine can sustain over a fifteen-minute period. If this average is exceeded, then the watchdog is triggered. A value of <code>0</code> disables this feature. By default, the value of this variable is set to a value approximately one half that of <code>max-load-1</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>min-memory</code></p></td>
<td align="left"><p><code>1</code></p></td>
<td align="left"><p>The minimum amount of virtual memory that must remain free on the virtual machine. This value is measured in pages. A value of <code>0</code> disables this feature.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>repair-binary</code></p></td>
<td align="left"><p><code>/usr/sbin/repair</code></p></td>
<td align="left"><p>The path and file name of a binary file on the local system that will be run when the watchdog is triggered. If the specified file resolves the issues preventing the watchdog from resetting the watchdog counter, then the watchdog action is not triggered.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>test-binary</code></p></td>
<td align="left"><p>N/A</p></td>
<td align="left"><p>The path and file name of a binary file on the local system that the watchdog will attempt to run during each interval. A test binary allows you to specify a file for running user-defined tests.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>test-timeout</code></p></td>
<td align="left"><p>N/A</p></td>
<td align="left"><p>The time limit, in seconds, for which user-defined tests can run. A value of <code>0</code> allows user-defined tests to continue for an unlimited duration.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>temperature-device</code></p></td>
<td align="left"><p>N/A</p></td>
<td align="left"><p>The path to and name of a device for checking the temperature of the machine on which the <code>watchdog</code> service is running.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>max-temperature</code></p></td>
<td align="left"><p><code>120</code></p></td>
<td align="left"><p>The maximum allowed temperature for the machine on which the <code>watchdog</code> service is running. The machine will be halted if this temperature is reached. Unit conversion is not taken into account, so you must specify a value that matches the watchdog card being used.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>admin</code></p></td>
<td align="left"><p><code>root</code></p></td>
<td align="left"><p>The email address to which email notifications are sent.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>interval</code></p></td>
<td align="left"><p><code>10</code></p></td>
<td align="left"><p>The interval, in seconds, between updates to the watchdog device. The watchdog device expects an update at least once every minute, and if there are no updates over a one-minute period, then the watchdog is triggered. This one-minute period is hard-coded into the drivers for the watchdog device, and cannot be configured.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>logtick</code></p></td>
<td align="left"><p><code>1</code></p></td>
<td align="left"><p>When verbose logging is enabled for the <code>watchdog</code> service, the <code>watchdog</code> service periodically writes log messages to the local system. The <code>logtick</code> value represents the number of watchdog intervals after which a message is written.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>realtime</code></p></td>
<td align="left"><p><code>yes</code></p></td>
<td align="left"><p>Specifies whether the watchdog is locked in memory. A value of <code>yes</code> locks the watchdog in memory so that it is not swapped out of memory, while a value of <code>no</code> allows the watchdog to be swapped out of memory. If the watchdog is swapped out of memory and is not swapped back in before the watchdog counter reaches zero, then the watchdog is triggered.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>priority</code></p></td>
<td align="left"><p><code>1</code></p></td>
<td align="left"><p>The schedule priority when the value of <code>realtime</code> is set to <code>yes</code>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>pidfile</code></p></td>
<td align="left"><p><code>/var/run/syslogd.pid</code></p></td>
<td align="left"><p>The path and file name of a PID file that the watchdog monitors to see if the corresponding process is still active. If the corresponding process is not active, then the watchdog is triggered.</p></td>
</tr>
</tbody>
</table>

### Editing Virtual Machines

#### Editing Virtual Machine Properties

**Summary**

Changes to storage, operating system or networking parameters can adversely affect the virtual machine. Ensure that you have the correct details before attempting to make any changes. Virtual machines must be powered off before some changes can be made to them. This procedure explains how to edit a virtual machine. It is necessary to edit a virtual machines in order to change its settings.

The following fields can be edited while a virtual machine is running:

*   **Name**
*   **Description**
*   **Comment**
*   **Delete Protection**
*   **Network Interfaces**
*   **Use Cloud-Init/Sysprep** (and its properties)
*   **Use custom migration downtime**
*   **Highly Available**
*   **Priority for Run/Migration queue**
*   **Watchdog Model**
*   **Watchdog Action**
*   **Physical Memory Guaranteed**
*   **Memory Balloon Device Enabled**
*   **VirtIO-SCSI Enabled**
*   **First Device**
*   **Second Device**
*   **Attach CD**
*   **kernel path**
*   **initrd path**
*   **kernel parameters**

To change all other settings, the virtual machine must be powered off.

⁠

**Procedure 8.9. Editing a virtual machine:**

1.  Select the virtual machine to be edited.
2.  Click the **Edit** button to open the **Edit Virtual Machine** window.
3.  Change the **General**, **System**, **Initial Run**, **Console**, **Host**, **High Availability**, **Resource Allocation**, **Boot Options**, and **Custom Options** fields as required.
4.  Click **OK** to save your changes. Your changes will be applied once you restart your virtual machine.

**Result**

You have changed the settings of a virtual machine by editing it.

#### Network Interfaces

##### Adding and Editing Virtual Machine Network Interfaces

**Summary**

You can add network interfaces to virtual machines. Doing so allows you to put your virtual machine on multiple logical networks. You can also edit a virtual machine's network interface card to change the details of that network interface card. This procedure can be performed on virtual machines that are running, but some actions can be performed only on virtual machines that are not running.

**Procedure 8.10. Adding Network Interfaces to Virtual Machines**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Network Interfaces** tab in the details pane to display a list of network interfaces that are currently associated with the virtual machine.
3.  Click **New** to open the **New Network Interface** window.
    ⁠

    ![New Network Interface window](New Network Interface.png "New Network Interface window")

    **Figure 8.5. New Network Interface window**

4.  Enter the **Name** of the network interface.
5.  Use the drop-down menus to select the **Profile** and the **Type** of network interface for the new network interface.The **Link State** is set to **Up** by default when the network interface card is defined on the virtual machine and connected to the network.
    <div class="alert alert-info">
    **Note:** The **Profile** and **Type** fields are populated in accordance with the profiles and network types available to the cluster and the network interface cards available to the virtual machine.

    </div>
6.  Select the **Custom MAC address** check box and enter a MAC address for the network interface card as required.
7.  Click **OK** to close the **New Network Interface** window.

**Result**

Your new network interface is listed in the **Network Interfaces** tab in the details pane of the virtual machine.

##### Editing a Network Interface

**Summary**

This procedure describes editing a network interface. In order to change any network settings, you must edit the network interface.

⁠

**Procedure 8.11. Editing a Network Interface**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Network Interfaces** tab of the details pane and select the network interface to edit.
3.  Click **Edit** to open the **Edit Network Interface** window. This dialog contains the same fields as the **New Network Interface** dialog.
4.  Click **OK** to save your changes once you are finished.

**Result**

You have now changed the network interface by editing it.

##### Removing a Network Interface

**Summary**

This procedure describes how to remove a network interface.

⁠

**Procedure 8.12. Removing a Network Interface**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Network Interfaces** tab of the details pane and select the network interface to remove.
3.  Click **Remove** and click **OK** when prompted.

**Result**

You have removed a network interface from a virtual machine.

##### Explanation of Settings in the Virtual Machine Network Interface Window

These settings apply when you are adding or editing a virtual machine network interface. If you have more than one network interface attached to a virtual machine, you can put the virtual machine on more than one logical network.

**Table 8.14. Add a network interface to a virtual machine entries**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the network interface. This text field has a 21-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Network</strong></p></td>
<td align="left"><p>Logical network that the network interface is placed on. By default, all network interfaces are put on the <strong>rhevm</strong> management network.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Link State</strong></p></td>
<td align="left"><p>Whether or not the network interface is connected to the logical network.</p>
<ul>
<li><strong>Up</strong>: The network interface is located on its slot.
<ul>
<li>When the <strong>Card Status</strong> is <strong>Plugged</strong>, it means the network interface is connected to a network cable, and is active.</li>
<li>When the <strong>Card Status</strong> is <strong>Unplugged</strong>, the network interface will be automatically connected to the network and become active.</li>
</ul></li>
<li><strong>Down</strong>: The network interface is located on its slot, but it is not connected to any network. Virtual machines will not be able to run in this state.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Type</strong></p></td>
<td align="left"><p>The virtual interface the network interface presents to virtual machines. VirtIO is faster but requires VirtIO drivers. Red Hat Enterprise Linux 5 and higher includes VirtIO drivers. Windows does not include VirtIO drivers, but they can be installed from the guest tools ISO or virtual floppy disk. rtl8139 and e1000 device drivers are included in most operating systems.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Specify custom MAC address</strong></p></td>
<td align="left"><p>Choose this option to set a custom MAC address. oVirt automatically generates a MAC address that is unique to the environment to identify the network interface. Having two devices with the same MAC address online in the same network causes networking conflicts.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Port Mirroring</strong></p></td>
<td align="left"><p>A security feature that allows all network traffic going to or leaving from virtual machines on a given logical network and host to be copied (mirrored) to the network interface. If the host also uses the network, then traffic going to or leaving from the host is also copied. Port mirroring only works on network interfaces with IPv4 IP addresses.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Card Status</strong></p></td>
<td align="left"><p>Whether or not the network interface is defined on the virtual machine.</p>
<ul>
<li><code>Plugged</code>: The network interface has been defined on the virtual machine.
<ul>
<li>If its <strong>Link State</strong> is <code>Up</code>, it means the network interface is connected to a network cable, and is active.</li>
<li>If its <strong>Link State</strong> is <code>Down</code>, the network interface is not connected to a network cable.</li>
</ul></li>
<li><code>Unplugged</code>: The network interface is only defined on oVirt, and is not associated with a virtual machine.
<ul>
<li>If its <strong>Link State</strong> is <code>Up</code>, when the network interface is plugged it will automatically be connected to a network and become active.</li>
<li>If its <strong>Link State</strong> is <code>Down</code>, the network interface is not connected to any network until it is defined on a virtual machine.</li>
</ul></li>
</ul></td>
</tr>
</tbody>
</table>

##### Hot Plugging Network Interfaces

**Summary**

You can hot plug network interfaces. Hot plugging means enabling and disabling network interfaces while a virtual machine is running.

⁠

**Procedure 8.13. Hot plugging network interfaces**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Network Interfaces** tab from the details pane of the virtual machine.
3.  Select the network interface you would like to hot plug and click **Edit** to open the **Edit Network Interface** window.
4.  Click the **Advanced Parameters** arrow to access the **Card Status** option. Set the **Card Status** to **Plugged** to enable the network interface, or set it to **Unplugged** to disable the network interface.

**Result**

You have enabled or disabled a virtual network interface.

##### Removing Network Interfaces From Virtual Machines

**Summary**

You can remove network interfaces from virtual machines.

⁠

**Procedure 8.14. Removing Network Interfaces From Virtual Machines**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Network Interfaces** tab in the virtual machine details pane.
3.  Select the network interface to remove.
4.  Click the **Remove** button and click **OK** when prompted.

**Result**

The network interface is no longer attached to the virtual machine.

#### Virtual Disks

##### Adding and Editing Virtual Machine Disks

**Summary**

It is possible to add disks to virtual machines. You can add new disks, or previously created floating disks to a virtual machine. This allows you to provide additional space to and share disks between virtual machines. You can also edit disks to change some of their details.

An **Internal** disk is the default type of disk. You can also add an **External(Direct Lun)** disk. Internal disk creation is managed entirely by oVirt; external disks require externally prepared targets that already exist. Existing disks are either floating disks or shareable disks attached to virtual machines.

⁠

**Procedure 8.15. Adding Disks to Virtual Machines**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Disks** tab in the details pane to display a list of virtual disks currently associated with the virtual machine.
3.  Click **Add** to open the **Add Virtual Disk** window.
    ⁠

    ![Add Virtual Disk Window](Add_Virtual_Disk.png "Add Virtual Disk Window")

    **Figure 8.6. Add Virtual Disk Window**

4.  Use the appropriate radio buttons to switch between **Internal** and the **External (Direct Lun)** disks.
5.  Select the **Attach Disk** check box to choose an existing disk from the list and select the **Activate** check box. Alternatively, enter the **Size**, **Alias**, and **Description** of a new disk and use the drop-down menus and check boxes to configure the disk.
6.  Click **OK** to add the disk and close the window.

**Result**

Your new disk is listed in the **Virtual Disks** tab in the details pane of the virtual machine.

##### Hot Plugging Virtual Machine Disks

**Summary**

You can hot plug virtual machine disks. Hot plugging means enabling or disabling devices while a virtual machine is running.

⁠

**Procedure 8.16. Hot Plugging Virtual Machine Disks**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Disks** tab from the details pane of the virtual machine.
3.  Select the virtual machine disk you would like to hot plug.
4.  Click the **Activate** button, or click the **Deactivate** button and click **OK** when prompted.

**Result**

You have enabled or disabled a virtual machine disk.

##### Removing Virtual Disks From Virtual Machines

**Summary**

You can remove virtual disks from virtual machines.

⁠

**Procedure 8.17. Removing Virtual Disks From Virtual Machines**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Disks** tab in the virtual machine details pane.
3.  Select the virtual disk to remove.
4.  Click the **Deactivate** button and click **OK** when prompted.
5.  Click the **Remove** button and click **OK** when prompted. Optionally, select the **Remove Permanently** option to completely remove the virtual disk from the environment. If you do not select this option - for example, because the disk is a shared disk - the virtual disk will remain in the **Disks** resource tab.

**Result**

The disk is no longer attached to the virtual machine.

#### Extending the Size of an Online Virtual Disk

**Summary**

This procedure explains how to extend the size of a virtual drive while the virtual drive is attached to a virtual machine.

⁠

**Procedure 8.18. Extending the Size of an Online Virtual Disk**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Select the **Disks** tab in the details pane.
3.  Select a target disk from the list in the details pane.
4.  Click **Edit** in the details pane.
5.  Enter a value in the `Extend size by(GB)` field.
6.  Click **OK**.

**Result**

The target disk's status becomes `locked` for a short time, during which the drive is resized. When the resizing of the drive is complete, the status of the drive becomes `OK`.

#### Floating Disks

Floating disks are disks that are not associated with any virtual machine.

Floating disks can minimize the amount of time required to set up virtual machines. Designating a floating disk as storage for a VM makes it unnecessary to wait for disk preallocation at the time of a VM's creation.

Floating disks can be attached to virtual machines or designated as shareable disks, which can be used with one or more VMs.

#### Associating a Virtual Disk with a Virtual Machine

**Summary**

This procedure explains how to associate a virtual disk with a virtual machine. Once the virtual disk is associated with the virtual machine, the VM is able to access it.

⁠

**Procedure 8.19. Associating a Virtual Disk with a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  In the details pane, select the **Disks** tab.
3.  Click **Add** in the menu at the top of the Details Pane.
4.  Type the size in GB of the disk into the **Size(GB)** field.
5.  Type the disk alias into the **Alias** field.
6.  Click **OK** in the bottom right corner of the **Add Virtual Disk** window. The disk you have associated with the virtual machine appears in the details pane after a short time.

**Result**

The virtual disk is associated with the virtual machine.

<div class="alert alert-info">
**Note:** No Quota resources are consumed by attaching virtual disks to, or detaching virtual disks from, virtual machines.

</div>
<div class="alert alert-info">
**Note:** Using the above procedure, it is now possible to attach a virtual disk to more than one virtual machine.

</div>

#### Changing the CD for a Virtual Machine

**Summary**

You can change the CD accessible to a virtual machine while that virtual machine is running.

<div class="alert alert-info">
**Note:** You can only use ISO files that have been added to the ISO domain of the cluster in which the virtual machine is a member. Therefore, you must upload ISO files to that domain before you can make those ISO files accessible to virtual machines.

</div>
⁠

**Procedure 8.20. Changing the CD for a Virtual Machine**

1.  From the **Virtual Machines** tab, select a virtual machine that is currently running.
2.  Click **Change CD** to open the **Change CD** window.
    ⁠

    ![The Change CD Window](Change_CD.png "The Change CD Window")

    **Figure 8.7. The Change CD Window**

3.  From the drop-down menu:
    -   Select `[Eject]` to eject the CD currently accessible to the virtual machine. Or,
    -   Select an ISO file from the list to eject the CD currently accessible to the virtual machine and mount that ISO file as a CD.

4.  Click **OK**.

**Result**

You have ejected the CD previously accessible to the virtual machine, or ejected the CD previously accessible to the virtual machine and made a new CD accessible to that virtual machine

#### Smart Card Authentication

Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines.

#### Enabling and Disabling Smart cards

**Summary**

The following procedures explain how to enable and disable the Smart card feature for virtual machines.

⁠

**Procedure 8.21. Enabling Smart cards**

1.  Ensure that the Smart card hardware is plugged into the client machine and is installed according to manufacturer's directions.
2.  Select the desired virtual machine.
3.  Click the **Edit** button. The **Edit Virtual Machine** window appears.
4.  Select the **Console** tab, and select the check box labeled **Smartcard enabled**, then click **OK**.
5.  Run the virtual machine by clicking the **Console** icon or through the User Portal. Smart card authentication is now passed from the client hardware to the virtual machine.

**Result**

You have enabled Smart card authentication for the virtual machine.

<div class="alert alert-info">
**Important:** If the Smart card hardware is not correctly installed, enabling the Smart card feature will result in the virtual machine failing to load properly.

</div>
⁠

**Procedure 8.22. Disabling Smart cards**

1.  Select the desired virtual machine.
2.  Click the **Edit** button. The **Edit Virtual Machine** window appears.
3.  Select the **Console** tab, and clear the check box labeled **Smartcard enabled**, then click **OK**.

**Result**

You have disabled Smart card authentication for the virtual machine.

### Running Virtual Machines

#### Installing Console Components

##### Console Components

A console is a graphical window that allows you to view the start up screen, shut down screen and desktop of a virtual machine, and to interact with that virtual machine in a similar way to a physical machine. In oVirt, the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on the client machine prior to use.

##### Installing Remote Viewer on Linux

Remote Viewer is an application for opening a graphical console to virtual machines. Remote Viewer is a SPICE client that is included the virt-viewer package provided by the `Red Hat Enterprise Linux Workstation (v. 6 for x86_64)` channel.

⁠

**Procedure 8.23. Installing Remote Viewer on Linux**

1.  Run the following command to install the spice-xpi package and dependencies:
        # yum install spice-xpi

2.  Run the following command to check whether the **virt-viewer** package has already been installed on your system:
        # rpm -q virt-viewer
        virt-viewer-0.5.2-18.el6_4.2.x86_64

    If the virt-viewer package has not been installed, run the following command to install the package and its dependencies:

        # yum install virt-viewer

3.  Restart Firefox for your changes to take effect.

The SPICE plug-in is now installed. You can now connect to your virtual machines using the SPICE protocol.

##### Installing Remote Viewer for Internet Explorer on Windows

**Summary**

The SPICE ActiveX component is required to run Remote Viewer, which opens a graphical console to virtual machines. Remote Viewer is a SPICE client installed together with the SPICE ActiveX component; both are provided in the `SpiceX.cab` file.

⁠

**Procedure 8.24. Installing Remote Viewer for Internet Explorer on Windows**

1.  Open Internet Explorer and log in to the User Portal.
2.  Start a virtual machine and attempt to connect to the virtual machine using the **Browser plugin** console option.
3.  Click the warning banner and click **Install This Add-on** when prompted.
4.  Click **Install** when prompted.
5.  Restart Internet Explorer for your changes to take effect.

**Result**

You have installed the SPICE plug-in and Remote Viewer, and can now connect to virtual machines using the SPICE protocol from within Internet Explorer.

##### Installing Remote Viewer on Windows

The **Remote Viewer** application provides users with a graphical console for connecting to virtual machines. Once installed, it is called automatically when attempting to open a SPICE session with a virtual machine. Alternatively, it can also be used as a standalone application.

⁠

**Procedure 8.25. Installing Remote Viewer on Windows**

1.  Open a web browser and download one of the following installers according to the architecture of your system.
    -   Virt Viewer for 32-bit Windows:
            https://[your manager's address]/ovirt-engine/services/files/spice/virt-viewer-x86.msi

    -   Virt Viewer for 64-bit Windows:
            https://[your manager's address]/ovirt-engine/services/files/spice/virt-viewer-x64.msi

2.  Open the folder where the file was saved.
3.  Double-click the file.
4.  Click **Run** if prompted by a security warning.
5.  Click **Yes** if prompted by User Account Control.

**Result**

**Remote Viewer** is installed and can be accessed via **Remote Viewer** in the **VirtViewer** folder of **All Programs** in the start menu.

#### Guest Drivers and Agents

##### Installing Guest Agents and Drivers

Installing oVirt guest agents and drivers on virtual machines provides optimized performance and extra features.

<dl>
<dt>
Installing the agents and drivers on Red Hat Enterprise Linux guests
</dt>
<dd>
All of the drivers are included in the base channel for RHN-registered Red Hat Enterprise Linux virtual machines. They can be installed using the `yum install rhevm-guest-agent` command. Your RHEL guest must be subscribed to the `Red Hat Enterprise Virt Agent` channel to install the agents. In Red Hat Enterprise Linux 5, this channel is labeled `rhel-x86_64-rhev-agent-5-server`. In Red Hat Enterprise Linux 6, the channel is labeled `rhel-x86_64-rhev-agent-6-server`.
</dd>
<dt>
Installing the agents and drivers on Windows guests
</dt>
<dd>
The guest tools ISO is `ovirt-guest-tools-iso.rpm`, an RPM file installed on oVirt. After installing oVirt, the guest tools ISO can be found at `/usr/share/rhev-guest-tools-iso/ovirt-tools-setup.iso`. When setting up oVirt, if you have created a local storage share for an ISO storage domain, the ISO file is automatically copied to the ISO storage domain. In this case the ISO image is automatically attached to Windows guests when they are created. Otherwise, the ISO must be manually attached to Windows guests for the tools and agents to be installed. Updated versions of the ISO file must be manually attached to running Windows virtual machines to install updated versions of the tools and drivers. If the APT service is enabled on virtual machines, the updated ISO files will be automatically attached.
</dd>
</dl>

##### Automating Guest Additions on Windows Guests with oVirt Application Provisioning Tool(APT)

oVirt Application Provisioning Tool (APT) is a Windows service that can be installed in Windows virtual machines and templates. Attach the guest tools ISO file to your Windows virtual machine and **ovirt-Application Provisioning.exe** automatically runs to install the APT service.

When the APT service is installed on a virtual machine, attached ISO files are automatically scanned. When the service recognizes a valid oVirt guest tools ISO, and no other guest tools are installed, the APT service installs the guest tools. If guest tools are installed, and the ISO image contains newer versions of the tools, an upgrade is automatically performed.

When the APT service has successfully installed or upgraded guest tools on a virtual machine, the virtual machine is automatically rebooted.

##### oVirt Guest Drivers and Guest Agents

oVirt provides customized drivers and guest tools to use with Windows and Red Hat Enterprise Linux guests. The drivers allow guests to use enhanced virtual devices that perform better than emulated devices; the guest agents facilitate communication between the guest and oVirt.

⁠

**Table 8.15. oVirt Guest Drivers**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Driver</p></th>
<th align="left"><p>Description</p></th>
<th align="left"><p>Works on</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>virtio-net</code></p></td>
<td align="left"><p>Paravirtualized network driver provides enhanced performance over emulated devices like rtl.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>virtio-block</code></p></td>
<td align="left"><p>Paravirtualized HDD driver offers increased I/O performance over emulated devices like IDE by optimizing the coordination and communication between the guest and the hypervisor. The driver complements the software implementation of the virtio-device used by the host to play the role of a hardware device.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>virtio-scsi</code></p></td>
<td align="left"><p>Paravirtualized iSCSI HDD driver offers similar functionality to the virtio-block device, with some additional enhancements. In particular, this driver supports adding hundreds of devices, and names devices using the standard SCSI device naming scheme.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>virtio-serial</code></p></td>
<td align="left"><p>Virtio-serial provides support for multiple serial ports. The improved performance is used for fast communication between the guest and the host that avoids network complications. This fast communication is required for the guest agents and for other features such as clipboard copy-paste between the guest and the host and logging.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>virtio-balloon</code></p></td>
<td align="left"><p>Virtio-balloon is used to control the amount of memory a guest actually accesses. It offers improved memory over-commitment. The balloon drivers are installed for future compatibility but not used by default in oVirt 3.1 or higher.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>qxl</code></p></td>
<td align="left"><p>A paravirtualized display driver reduces CPU usage on the host and provides better performance through reduced network bandwidth on most workloads.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
</tbody>
</table>

⁠

**Table 8.16. oVirt Guest Agents and Tools**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Guest agent/tool</p></th>
<th align="left"><p>Description</p></th>
<th align="left"><p>Works on</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>ovirt-guest-agent</code></p></td>
<td align="left"><p>Allows oVirt to receive guest internal events and information such as IP address and installed applications. Also allows oVirt to execute specific commands, such as shut down or reboot, on a guest. On Red Hat Enterprise Linux 6 and higher guests, the ovirt-guest-agent installs <strong>tuned</strong> on your virtual machine and configures it to use an optimized, virtualized-guest profile.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>spice-agent</code></p></td>
<td align="left"><p>The SPICE agent supports multiple monitors and is responsible for client-mouse-mode support to provide a better user experience and improved responsiveness than the QEMU emulation. Cursor capture is not needed in client-mouse-mode. The SPICE agent reduces bandwidth usage when used over a wide area network by reducing the display level, including color depth, disabling wallpaper, font smoothing, and animation. The SPICE agent enables clipboard support allowing cut and paste operations for both text and images between client and guest, and automatic guest display setting according to client-side settings. On Windows guests, the SPICE agent consists of vdservice and vdagent.</p></td>
<td align="left"><p>Server and Desktop.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>ovirt-sso</code></p></td>
<td align="left"><p>An agent that enables users to automatically log in to their virtual machines based on the credentials used to access oVirt.</p></td>
<td align="left"><p>Desktop.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>ovirt-usb</code></p></td>
<td align="left"><p>A component that contains drivers and services for Legacy USB support (version 3.0 and earlier) on guests. It is needed for accessing a USB device that is plugged into the client machine. <code>ovirt-USB Client</code> is needed on the client side.</p></td>
<td align="left"><p>Desktop.</p></td>
</tr>
</tbody>
</table>

#### Accessing Virtual machines

##### Starting a Virtual Machine

**Summary**

You can start a virtual machine from the Administration Portal.

**Procedure 8.26. Starting a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine with a status of `Down`.
2.  Click the run ![](up.png "fig:up.png") button. Alternatively, right-click the virtual machine and select **Run**.

**Result**

The **Status** of the virtual machine changes to `Up`, and the console protocol of the selected virtual machine is displayed. If the guest agent is installed on the virtual machine, the IP address of that virtual machine is also displayed.

##### Opening a Console to a Virtual Machine

**Summary**

Open a console to a virtual machine.

**Procedure 8.27. Logging in to a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the console button or right-click the virtual machine and select **Console**.
    ⁠

    ![Connection Icon on the Virtual Machine Menu](Console.png "Connection Icon on the Virtual Machine Menu")

    **Figure 8.8. Connection Icon on the Virtual Machine Menu**

3.  -   If Remote Viewer is installed, a console window will automatically open for the virtual machine.

**Result**

You have opened a console to a virtual machine from the Administration Portal.

<div class="alert alert-info">
**Note:** If Remote Viewer is not installed, you will be prompted to download a file called `console.vv`. You can then install Remove Viewer and manually open this file, or you can use a text editor to open the file and retrieve the connection information that file contains. This information can then be used to open a console to the virtual machine using a VNC client.

</div>

##### Shutting Down a Virtual Machine

**Summary**

If the guest agent is installed on a virtual machine or that virtual machine supports Advanced Configuration and Power Interface (ACPI), you can shut that virtual machine down from within the Administration Portal.

**Procedure 8.28. Shutting Down a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a running virtual machine.
2.  Click the shut down ( ![](Down.png "fig:Down.png") ) button. Alternatively, right-click the virtual machine and select **Shutdown**.

**Result**

The virtual machine shuts down gracefully and the **Status** of the virtual machine changes to `Down`.

##### Pausing a Virtual Machine

**Summary**

If the guest agent is installed on a virtual machine or that virtual machine supports Advanced Configuration and Power Interface (ACPI), you can pause that virtual machine from within the Administration Portal. This is equal to placing that virtual machine into *Hibernate* mode.

⁠

**Procedure 8.29. Pausing a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a running virtual machine.
2.  Click the Suspend ( ![](Suspend.png "fig:Suspend.png") ) button. Alternatively, right-click the virtual machine and select **Suspend**.

**Result**

The **Status** of the virtual machine changes to `Paused`.

##### Rebooting a Virtual Machine

**Summary**

If the guest agent is installed on a virtual machine, you can reboot that virtual machine from within the Administration Portal.

**Procedure 8.30. Rebooting a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a running virtual machine.
2.  Click the Reboot ( ![](Reboot.png "fig:Reboot.png") ) button. Alternatively, right-click the virtual machine and select **Reboot**.
3.  Click **OK** in the **Reboot Virtual Machine(s)** confirmation window.

**Result**

The **Status** of the virtual machine changes to `Reboot In Progress` before returning to `Up`.

#### Console Options

##### Introduction to Connection Protocols

Connection protocols are the underlying technology used to provide graphical consoles for virtual machines and allow users to work with virtual machines in a similar way as they would with physical machines. oVirt currently supports the following connection protocols:

SPICE

Simple Protocol for Independent Computing Environments (SPICE) is the recommended connection protocol for both Linux virtual machines and Windows virtual machines. SPICE is installed and executed on the client that connects to the virtual machine.

VNC

Virtual Network Computing (VNC) can be used to open consoles to both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using VNC, you must use Remote Viewer or a VNC client.

RDP

Remote Desktop Protocol (RDP) can only be used to open consoles to Windows virtual machines, and is only available when you access a virtual machines from a Windows machine on which Remote Desktop has been installed. Moreover, before you can connect to a Windows virtual machine using RDP, you must set up remote sharing on the virtual machine and configure the firewall to allow remote desktop connections.

<div class="alert alert-info">
**Note:** SPICE is not currently supported on virtual machines running Windows 8. If a Windows 8 virtual machine is configured to use the SPICE protocol, it will detect the absence of the required SPICE drivers and automatically fall back to using RDP.

</div>

##### Accessing Console Options

In the Administration Portal, you can configure several options for opening graphical consoles for virtual machines, such as the method of invocation and whether to enable or disable USB redirection.

⁠

**Procedure 8.31. Accessing Console Options**

1.  Select a running virtual machine.
2.  Right-click the virtual machine and click the **Edit Console Options** button to open the **Console Options** window.

<div class="alert alert-info">
**Note:** Further options specific to each of the connection protocols, such as the keyboard layout when using the VNC connection protocol, can be configured in the **Console** tab of the **Edit Virtual Machine** window.

</div>

##### SPICE Console Options

When the SPICE connection protocol is selected, the following options are available in the **Console Options** window.

![The Console Options window](Console Options.png "The Console Options window")

**Figure 8.9. The Console Options window**

**Console Invocation**

*   **Auto**: oVirt automatically selects the method for invoking the console.
*   **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.
*   **Browser plugin**: When you connect to the console of the virtual machine, you are connected directly via Remote Viewer.
*   **SPICE HTML5 browser client (Tech preview)**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**SPICE Options**

*   **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl**+**Alt**+**Del** key combination to **Ctrl**+**Alt**+**End** inside the virtual machine.
*   **Enable USB Auto-Share**: Select this check box to automatically redirect USB devices to the virtual machine. If this option is not selected, USB devices will connect to the client machine instead of the guest virtual machine. To use the USB device on the guest machine, manually enable it in the SPICE client menu.
*   **Open in Full Screen**: Select this check box for the virtual machine console to automatically open in full screen when you connect to the virtual machine. Press **SHIFT**+**F11** to toggle full screen mode on or off.
*   **Enable SPICE Proxy**: Select this check box to enable the SPICE proxy.
*   **Enable WAN options**: Select this check box to enable WAN color depth and effects for the virtual machine console. Select this check box for only Windows virtual machines. Selecting this check box sets the parameters *WAN-DisableEffects* and *WAN-ColorDepth*. Selecting **Enable WAN options** sets *Wan-DisableEffects* to *animation* and sets the color depth to 16 bits.

<div class="alert alert-info">
**Important:** The **Browser plugin** console option is only available when accessing the Administration and User Portals through Internet Explorer. This console options uses the version of Remote Viewer provided by the `SpiceX.cab` installation program. For all other browsers, the **Native client** console option is the default. This console option uses the version of Remote Viewer provided by the `virt-viewer-x86.msi` and `virt-viewer-x64.msi` installation files.

</div>

##### VNC Console Options

When the VNC connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

*   **Native Client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.
*   **NoVNC**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**VNC Options**

*   **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl**+**Alt**+**Del** key combination to **Ctrl**+**Alt**+**End** inside the virtual machine.

##### RDP Console Options

When the RDP connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

*   **Auto**: oVirt automatically selects the method for invoking the console.
*   **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Desktop.

**RDP Options**

*   **Use Local Drives**: Select this check box to make the drives on the client machine to be accessible on the guest virtual machine.

#### Remote Viewer Options

##### Remote Viewer Options

When you specify the **Native client** or **Browser plugin** console invocation options, you will connect to virtual machines using Remote Viewer. The Remote Viewer window provides a number of options for interacting with the virtual machine to which it is connected.⁠

**Table 8.17. Remote Viewer Options**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Option</p></th>
<th align="left"><p>Hotkey</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>File</p></td>
<td align="left"><ul>
<li><strong>Screenshot</strong>: Takes a screen capture of the active window and saves it in a location of your specification.</li>
<li><strong>USB device selection</strong>: If USB redirection has been enabled on your virtual machine, the USB device plugged into your client machine can be accessed from this menu.</li>
<li><strong>Quit</strong>: Closes the console. The hot key for this option is <strong>Shift</strong>+<strong>Ctrl</strong>+<strong>Q</strong>.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p>View</p></td>
<td align="left"><ul>
<li><strong>Full screen</strong>: Toggles full screen mode on or off. When enabled, full screen mode expands the virtual machine to fill the entire screen. When disabled, the virtual machine is displayed as a window. The hot key for enabling or disabling full screen is <strong>SHIFT</strong>+<strong>F11</strong>.</li>
<li><strong>Zoom</strong>: Zooms in and out of the console window. <strong>Ctrl</strong>+<strong>+</strong> zooms in, <strong>Ctrl</strong>+<strong>-</strong> zooms out, and <strong>Ctrl</strong>+<strong>0</strong> returns the screen to its original size.</li>
<li><strong>Automatically resize</strong>: Tick to enable the guest resolution to automatically scale according to the size of the console window.</li>
<li><strong>Displays</strong>: Allows users to enable and disable displays for the guest virtual machine.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p>Send key</p></td>
<td align="left"><ul>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>Del</strong>: On a Red Hat Enterprise Linux virtual machine, it displays a dialog with options to suspend, shut down or restart the virtual machine. On a Windows virtual machine, it displays the task manager or Windows Security dialog.</li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>Backspace</strong>: On a Red Hat Enterprise Linux virtual machine, it restarts the X sever. On a Windows virtual machine, it does nothing.</li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F1</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F2</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F3</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F4</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F5</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F6</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F7</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F8</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F9</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F10</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F11</strong></li>
<li><strong>Ctrl</strong>+<strong>Alt</strong>+<strong>F12</strong></li>
<li><strong>Printscreen</strong>: Passes the <strong>Printscreen</strong> keyboard option to the virtual machine.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p>Help</p></td>
<td align="left"><p>The <strong>About</strong> entry displays the version details of Virtual Machine Viewer that you are using.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Release Cursor from Virtual Machine</p></td>
<td align="left"><p><strong>SHIFT</strong>+<strong>F12</strong></p></td>
</tr>
</tbody>
</table>

##### Remote Viewer Hotkeys

You can access the hotkeys for a virtual machine in both full screen mode and windowed mode. If you are using full screen mode, you can display the menu containing the button for hotkeys by moving the mouse pointer to the middle of the top of the screen. If you are using windowed mode, you can access the hotkeys via the **Send key** menu on the virtual machine window title bar.

<div class="alert alert-info">
**Note:** If **vdagent** is not running on the client machine, the mouse can become captured in a virtual machine window if it is used inside a virtual machine and the virtual machine is not in full screen. To unlock the mouse, press **Shift**+**F12**.

</div>

### Removing Virtual Machines

#### Removing a Virtual Machine

**Summary**

Remove a virtual machine from the oVirt environment.

<div class="alert alert-info">
**Important:** The **Remove** button is disabled while virtual machines are running; you must shut down a virtual machine before you can remove it.

</div>
⁠

**Procedure 8.32. Removing a Virtual Machine**

1.  Click the **Virtual Machines** tab and select the virtual machine to remove.
2.  Click **Remove** to open the **Remove Virtual Machine(s)** window.
3.  Optionally, select the **Remove Disk(s)** check box to remove the virtual disks attached to the virtual machine together with the virtual machine. If the **Remove Disk(s)** check box is cleared, then the virtual disks remain in the environment as floating disks.
4.  Click **OK**.

**Result**

The virtual machine is removed from the environment and is no longer listed in the **Virtual Machines** resource tab. If you selected the **Remove Disk(s)** check box, then the virtual disks attached to the virtual machine are also removed.

### ⁠Snapshots

#### Creating a Snapshot of a Virtual Machine

**Summary**

A snapshot is a view of a virtual machine's operating system and applications on any or all available disks at a given point in time. Take a snapshot of a virtual machine before you make a change to it that may have unintended consequences. You can use a snapshot to return a virtual machine to a previous state.

<div class="alert alert-info">
**Note:** Live snapshots can only be created for virtual machines running on 3.1-or-higher-compatible data centers. Virtual machines in 3.0-or-lower-compatible data centers must be shut down before a snapshot can be created.

</div>
**Procedure 8.33. Creating a Snapshot of a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Create Snapshot** to open the **Create Snapshot** window.
    ⁠

    ![Create snapshot](Create Snapshot.png "Create snapshot")

    **Figure 8.10. Create snapshot**

3.  Enter a description for the snapshot.
4.  Select **Disks to include** using the check boxes.
5.  Use the **Save Memory** check box to denote whether you wish to include the virtual machine's memory in the snapshot.
6.  Click **OK** to create the snapshot and close the window.

**Result**

The virtual machine's operating system and applications on the selected disk(s) are stored in a snapshot that can be previewed or restored. The snapshot is created with a status of `Locked`, which changes to `Ok`. When you click on the snapshot, its details are shown on the **General**, **Disks**, **Network Interfaces**, and **Installed Applications** tabs in the right side-pane of the details pane.

#### Using a Snapshot to Restore a Virtual Machine

**Summary**

A snapshot can be used to restore a virtual machine to its previous state.

⁠

**Procedure 8.34. Using a snapshot to restore a virtual machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Snapshots** tab in the details pane to list the available snapshots.
3.  Select a snapshot to restore in the left side-pane. The snapshot details display in the right side-pane.
4.  Click the drop-down list beside **Preview** to open the **Custom Preview Snapshot** window.
5.  Use the check boxes to select the **VM Configuration**, **Memory**, and disk(s) you want to restore, then click **OK**. This allows you to create and restore from a customized snapshot using the configuration and disk(s) from multiple snapshots. The status of the snapshot changes to `Preview Mode`. The status of the virtual machine briefly changes to `Image Locked` before returning to `Down`.
6.  Start the virtual machine; it runs using the disk image of the snapshot.
7.  Click **Commit** to permanently restore the virtual machine to the condition of the snapshot. Any subsequent snapshots are erased. Alternatively, click the **Undo** button to deactivate the snapshot and return the virtual machine to its previous state.

**Result**

The virtual machine is restored to its state at the time of the snapshot, or returned to its state before the preview of the snapshot.

#### Creating a Virtual Machine from a Snapshot

**Summary**

You have created a snapshot from a virtual machine. Now you can use that snapshot to create another virtual machine.

⁠

**Procedure 8.35. Creating a virtual machine from a snapshot**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Snapshots** tab in the details pane to list the available snapshots for the virtual machines.
3.  Select a snapshot in the list displayed and click **Clone** to open the **Clone VM from Snapshot** window.
4.  Enter the **Name** and **Description** of the virtual machine to be created.
    ⁠

    ![Clone a Virtual Machine from a Snapshot](Clone VM Snapshot.png "Clone a Virtual Machine from a Snapshot")

    **Figure 8.11. Clone a Virtual Machine from a Snapshot**

5.  Click **OK** to create the virtual machine and close the window.

**Result**

After a short time, the cloned virtual machine appears in the **Virtual Machines** tab in the navigation pane. It appears in the navigation pane with a status of `Image Locked`. The virtual machine will remain in this state until oVirt completes the creation of the virtual machine. A virtual machine with a preallocated 20GB hard drive takes about fifteen minutes to create. Sparsely-allocated virtual disks take less time to create than do preallocated virtual disks.

When the virtual machine is ready to use, its status changes from `Image Locked` to `Down` in the **Virtual Machines** tab in the navigation pane.

#### Deleting a Snapshot

**Summary**

Delete a snapshot and permanently remove it from the virtualized environment.

⁠

**Procedure 8.36. Deleting a Snapshot**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Snapshots** tab in the details pane to list available snapshots for the virtual machine.
    ⁠

    ![Snapshot List](Snapshot List.png "Snapshot List")

    **Figure 8.12. Snapshot List**

3.  Select the snapshot to delete.
4.  In the Navigation pane, shut down the running virtual machine associated with the snapshot to be deleted.
5.  Click **Delete** to open the **Delete Snapshot** confirmation window.
6.  Click **OK** to delete the snapshot and close the window.

**Result**

You have removed a virtual machine snapshot. Removing a snapshot does not affect the virtual machine.

### ⁠Affinity Groups

#### Introduction to Virtual Machine Affinity

Virtual machine affinity allows you to define sets of rules that specify whether certain virtual machines run together on the same host or run separately on different hosts. This allows you to create advanced workload scenarios for addressing challenges such as strict licensing requirements and workloads demanding high availability.

Virtual machine affinity is applied to virtual machines by adding virtual machines to one or more affinity groups. An affinity group is a group of two or more virtual machines for which a set of identical parameters and conditions apply. These parameters include positive (run together) affinity that ensures the virtual machines in an affinity group run on the same host, and negative (run independently) affinity that ensures the virtual machines in an affinity group run on different hosts.

A further set of conditions can then be applied to these parameters. For example, you can apply hard enforcement, which is a condition that ensures the virtual machines in the affinity group run on the same host or different hosts regardless of external conditions, or soft enforcement, which is a condition that indicates a preference for virtual machines in an affinity group to run on the same host or different hosts when possible.

The combination of an affinity group, its parameters and conditions are collectively known as an affinity policy.

<div class="alert alert-info">
**Note:** Affinity groups are applied to virtual machines on the cluster level. When a virtual machine is moved from one cluster to another, that virtual machine is removed from all affinity groups in the source cluster.

</div>
<div class="alert alert-info">
**Important:** Affinity groups will only take effect when the `VmAffinityGroups` filter module or weights module is enabled in the cluster policy applied to clusters in which affinity groups are defined. The `VmAffinityGroups` filter module is used to implement hard enforcement, and the `VmAffinityGroups` weights module is used to implement soft enforcement.

</div>

#### Creating an Affinity Group

**Summary**

You can create new affinity groups for applying affinity policies to virtual machines.

⁠

**Procedure 8.37. Creating an Affinity Group**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Affinity Groups** tab in the details pane.
3.  Click the **New** button to open the **New Affinity Group** window.
4.  Enter a name and description for the affinity group in the **Name** text field and **Description** text field.
5.  Select the **Positive** check box to apply positive affinity, or ensure this check box is cleared to apply negative affinity.
6.  Select the **Enforcing** check box to apply hard enforcement, or ensure this check box is cleared to apply soft enforcement.
7.  Use the drop-down menu to select the virtual machines to be added to the affinity group. Use the **+** and **-** buttons to add or remove additional virtual machines.
8.  Click **OK**.

**Result**

You have created a virtual machine affinity group and specified the parameters and conditions to be applied to the virtual machines that are members of that group.

#### Editing an Affinity Group

**Summary**

You can edit the settings of existing affinity groups.

⁠

**Procedure 8.38. Editing an Affinity Group**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Affinity Groups** tab in the details pane.
3.  Click the **Edit** button to open the **Edit Affinity Group** window.
4.  Change the **Positive** and **Enforcing** check boxes to the preferred values and use the **+** and **-** buttons to add or remove virtual machines to or from the affinity group.
5.  Click **OK**.

**Result**

You have edited an affinity group.

#### Removing an Affinity Group

**Summary**

You can remove an existing affinity group.

⁠

**Procedure 8.39. Removing an Affinity Group**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click the **Affinity Groups** tab in the details pane.
3.  Click the **Remove** button and click **OK** when prompted to remove the affinity group.

**Result**

You have removed an affinity group, and the affinity policy that applied to the virtual machines that were members of that affinity group no longer applies.

### ⁠Importing and Exporting Virtual Machines

#### Exporting and Importing Virtual Machines and Templates

Virtual machines and templates can be exported from and imported to data centers in the same oVirt environment, or a different oVirt environment. oVirt allows you to import and export virtual machines (and templates) stored in Open Virtual Machine Format (OVF).

There are three stages to exporting and importing virtual machines and templates:

1.  Export the virtual machine or template to an export domain.
2.  Detach the export domain from one data center, and attach it to another. You can attach it to a different data center in the same oVirt environment, or attach it to a data center in a separate oVirt environment that is managed by another installation of oVirt.
3.  Import the virtual machine or template into the data center to which the export domain is attached.

A virtual machine must be stopped before it can be moved across data centers. If the virtual machine was created using a template, the template must exist in the destination data center for the virtual machine to work, or the virtual machine must be exported with the **Collapse Snapshots** option selected.

<div class="alert alert-info">
**Note:** When you export or import a virtual machine or template, the properties of that virtual machine or template are preserved, including basic details such as the name and description, resource allocation, and high availability settings.

</div>

#### Overview of the Export and Import Process

The export domain allows you to move virtual machines and templates between oVirt environments.

To export or import virtual machines and templates, an active export domain must be attached to the data center containing the virtual machine or template to be exported or imported. An export domain acts as a temporary storage area containing two directories for each exported virtual machine or template. One directory contains the OVF (Open Virtualization Format) files for the virtual machine or template. The other directory holds the disk image or images for the virtual machine or template.

You can also import virtual machines from other virtualization providers such as Xen, VMware or Windows virtual machines using the V2V feature. V2V converts virtual machines and places them in the export domain.

For more information on V2V, see the *Red Hat Enterprise Linux V2V Guide*.

<div class="alert alert-info">
**Note:** An export domain can only be active in one data center at a given time. This means that the export domain must be attached to either the source data center or the destination data center.

</div>
Exporting virtual machines and templates from one data center to another requires some preparation. Ensure that:

*   An export domain exists, and is attached to the source data center.
*   The virtual machine is shut down.
*   If the virtual machine was created based on a template, that template must reside on the destination data center or be exported with the virtual machine.

When the virtual machine or template has been exported to the export domain, you can import that virtual machine or template into the destination data center. If the destination data center is in the same oVirt environment as the source data center, delete the original virtual machine or template from the source data center after the export has completed.

#### Graphical Overview for Exporting and Importing Virtual Machines and Templates

**Summary**

This procedure provides a graphical overview of the steps required to export a virtual machine or template from one data center and import that virtual machine or template into another data center.

⁠

**Procedure 8.40. Exporting and Importing Virtual Machines and Templates**

1.  Attach the export domain to the source data center.
    ⁠

    ![Attach Export Domain](Export1.png "Attach Export Domain")

    **Figure 8.13. Attach Export Domain**

2.  Export the virtual machine or template to the export domain.
    ⁠

    ![Export the Virtual Resource](Export2.png "Export the Virtual Resource")

    **Figure 8.14. Export the Virtual Resource**

3.  Detach the export domain from the source data center.
    ⁠

    ![Detach Export Domain](Export3.png "Detach Export Domain")

    **Figure 8.15. Detach Export Domain**

4.  Attach the export domain to the destination data center.
    ⁠

    ![Attach the Export Domain](Export4.png "Attach the Export Domain")

    **Figure 8.16. Attach the Export Domain**

5.  Import the virtual machine or template into the destination data center.
    ⁠

    ![Import the virtual resource](Export5.png "Import the virtual resource")

    **Figure 8.17. Import the virtual resource**

**Result**

The virtual machine or template is imported to the destination data center.

#### Exporting a Virtual Machine to the Export Domain

**Summary**

Export a virtual machine to the export domain so that it can be imported into a different data center. Before you begin, the export domain must be attached to the data center that contains the virtual machine to be exported.

⁠

**Procedure 8.41. Exporting a Virtual Machine to the Export Domain**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Export** to open the **Export Virtual Machine** window.
3.  Select the **Force Override** check box to override existing images of the virtual machine on the export domain. Select the **Collapse Snapshots** check box to create a single export volume per disk. Selecting this option will remove snapshot restore points and include the template in a template-based virtual machine. This removes any dependencies a virtual machine has on a template.
4.  Click **OK** to export the virtual machine and close the window.

**Result**

The export of the virtual machine begins. The virtual machine displays in the Virtual Machines list with an `Image Locked` status as it is exported. Depending on the size of your virtual machine hard disk images, and your storage hardware, this can take up to an hour. Use the **Events** tab to view the progress.

When complete, the virtual machine has been exported to the export domain and displays on the **VM Import** tab of the export domain's details pane.

#### Importing a Virtual Machine into the Destination Data Center

**Summary**

You have a virtual machine on an export domain. Before the virtual machine can be imported to a new data center, the export domain must be attached to the destination data center.

⁠

**Procedure 8.42. Importing a Virtual Machine into the Destination Data Center**

1.  Use the **Storage** resource tab, tree mode, or the search function to find and select the export domain in the results list. The export domain must have a status of `Active`
2.  Select the **VM Import** tab in the details pane to list the available virtual machines to import.
3.  Select one or more virtual machines to import and click **Import** to open the **Import Virtual Machine(s)** window.
4.  Use the drop-down menus to select the **Default Storage Domain** and **Cluster**.
5.  Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.
6.  Click the virtual machine to be imported and click on the **Disks** sub-tab. From this tab, you can use the **Allocation Policy** and **Storage Domain** drop-down lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and can also select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.
7.  Click **OK** to import the virtual machines The **Import Conflict** window opens if the virtual machine exists in the virtualized environment.
8.  Choose one of the following radio buttons:
    -   **Don't import**
    -   **Clone** and enter a unique name for the virtual machine in the **New Name** field.

    Or select the **Apply to all** check box to import all duplicated virtual machines with the same suffix.

9.  Click **OK** to import the virtual machines and close the window.

<div class="alert alert-info">
**Important:** During a single import operation, you can only import virtual machines that share the same architecture. If any of the virtual machines to be imported have a different architecture to that of the other virtual machines to be imported, a warning will display and you will be prompted to change your selection so that only virtual machines with the same architecture will be imported.

</div>
**Result**

You have imported the virtual machine to the destination data center. This may take some time to complete.

### ⁠Migrating Virtual Machines Between Hosts

#### What is Live Migration?

Live migration provides the ability to move a running virtual machine between physical hosts with no interruption to service.

Live migration is transparent to the end user: the virtual machine remains powered on and user applications continue to run while the virtual machine is relocated to a new physical host.

#### Live Migration Prerequisites

Live migration is used to seamlessly move virtual machines to support a number of common maintenance tasks. Ensure that your oVirt environment is correctly configured to support live migration well in advance of using it.

At a minimum, for successful live migration of virtual machines to be possible:

*   The source and destination host must both be members of the same cluster, ensuring CPU compatibility between them.
*   The source and destination host must have a status of `Up`.
*   The source and destination host must have access to the same virtual networks and VLANs.
*   The source and destination host must have access to the data storage domain on which the virtual machine resides.
*   There must be enough CPU capacity on the destination host to support the virtual machine's requirements.
*   There must be enough RAM on the destination host that is not in use to support the virtual machine's requirements.
*   The migrating virtual machine must not have the `cache!=none` custom property set.

In addition, for best performance, the storage and management networks should be split to avoid network saturation. Virtual machine migration involves transferring large amounts of data between hosts.

Live migration is performed using the management network. Each live migration event is limited to a maximum transfer speed of 30 MBps, and the number of concurrent migrations supported is also limited by default. Despite these measures, concurrent migrations have the potential to saturate the management network. It is recommended that separate logical networks are created for storage, display, and virtual machine data to minimize the risk of network saturation.

#### Automatic Virtual Machine Migration

oVirt automatically initiates live migration of all virtual machines running on a host when the host is moved into maintenance mode. The destination host for each virtual machine is assessed as the virtual machine is migrated, in order to spread the load across the cluster.

oVirt automatically initiates live migration of virtual machines in order to maintain load balancing or power saving levels in line with cluster policy. While no cluster policy is defined by default, it is recommended that you specify the cluster policy which best suits the needs of your environment. You can also disable automatic, or even manual, live migration of specific virtual machines where required.

#### Preventing Automatic Migration of a Virtual Machine

**Summary**

oVirt allows you to disable automatic migration of virtual machines. You can also disable manual migration of virtual machines by setting the virtual machine to run only on a specific host.

The ability to disable automatic migration and require a virtual machine to run on a particular host is useful when using application high availability products, such as Red Hat High Availability or Cluster Suite.

**Procedure 8.43. Preventing automatic migration of a virtual machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** to open the **Edit Virtual Machine** window.
3.  Click the **Hide Advanced Options** button.
    ![Edit Virtual Machine Window](Edit Virtual Machine.png "fig:Edit Virtual Machine Window")
    **Figure 8.18. Edit Virtual Machine Window**
4.  Click the **Host** tab.
5.  Use the **Run On** radio buttons to designate the virtual machine to run on **Any Host in Cluster** or a **Specific** host. If applicable, select a specific host from the drop-down menu.
    <div class="alert alert-info">
    **Warning:** Explicitly assigning a virtual machine to a specific host and disabling migration is mutually exclusive with oVirt high availability. Virtual machines that are assigned to a specific host can only be made highly available using third party high availability products like Red Hat High Availability.

    </div>
6.  Use the drop-down menu to affect the **Migration Options**. Select **Do not allow migration** to enable the **Use Host CPU** check box.
7.  If applicable, enter relevant **CPU Pinning topology** commands in the text field.
8.  Click **OK** to save the changes and close the window.

**Result**

You have changed the migration settings for the virtual machine.

#### Manually Migrating Virtual Machines

**Summary**

A running virtual machine can be migrated to any host within its designated host cluster. This is especially useful if the load on a particular host is too high. When bringing a server down for maintenance, migration is triggered automatically, so manual migration is not required. Migration of virtual machines does not cause any service interruption.

The migrating virtual machine must not have the `cache!=none` custom property set.

**Procedure 8.44. Manually Migrating Virtual Machines**

1.  Click the **Virtual Machines** tab and select a running virtual machine.
2.  Click **Migrate** to open the **Migrate Virtual Machine(s)** window.
3.  Use the radio buttons to select whether to **Select Host Automatically** or to **Select Destination Host**, specifying the host using the drop-down menu.
    <div class="alert alert-info">
    **Note:** Virtual Machines migrate within their designated host cluster. When the **Select Host Automatically** option is selected, the system determines the host to which the virtual is migrated according to the load balancing and power management rules set up in the cluster policy.

    </div>
4.  Click **OK** to commence migration and close the window.

**Result**

The virtual machine is migrated. Once migration is complete the **Host** column will update to display the host the virtual machine has been migrated to.

#### Setting Migration Priority

**Summary**

oVirt queues concurrent requests for migration of virtual machines off of a given host. Every minute the load balancing process runs. Hosts already involved in a migration event are not included in the migration cycle until their migration event has completed. When there is a migration request in the queue and available hosts in the cluster to action it, a migration event is triggered in line with the load balancing policy for the cluster.

It is possible to influence the ordering of the migration queue, for example setting mission critical virtual machines to migrate before others. oVirt allows you to set the priority of each virtual machine to facilitate this. Virtual machines migrations will be ordered by priority, those virtual machines with the highest priority will be migrated first.

⁠

**Procedure 8.45. Setting Migration Priority**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** to open the **Edit Virtual Machine** window.
3.  Select the **High Availability** tab.
4.  Use the radio buttons to set the **Priority for Run/Migrate Queue** of the virtual machine to one of **Low**, **Medium**, or **High**.
5.  Click **OK** to save changes and close the window.

**Result**

The virtual machine's migration priority has been modified.

#### Canceling Ongoing Virtual Machine Migrations

**Summary**

A virtual machine migration is taking longer than you expected. You'd like to be sure where all virtual machines are running before you make any changes to your environment.

⁠

**Procedure 8.46. Canceling Ongoing Virtual Machine Migrations**

1.  Select the migrating virtual machine. It is displayed in the **Virtual Machines** resource tab with a status of **Migrating from**.
2.  Click the **Cancel Migration** button at the top of the results list. Alternatively, right-click on the virtual machine and select **Cancel Migration** from the context menu.

**Result**

The virtual machine status returns from **Migrating from** status to **Up** status.

#### Event and Log Notification upon Automatic Migration of Highly Available Virtual Servers

When a virtual server is automatically migrated because of the high availability function, the details of an automatic migration are documented in the **Events** tab and in the engine log to aid in troubleshooting, as illustrated in the following examples:

⁠

**Example 8.1. Notification in the Events Tab of the Web Admin Portal**

Highly Available *Virtual_Machine_Name* failed. It will be restarted automatically.

*Virtual_Machine_Name* was restarted on Host *Host_Name*

⁠

**Example 8.2. Notification in oVirt engine.log**

This log can be found on oVirt at `/var/log/ovirt-engine/engine.log`:

Failed to start Highly Available VM. Attempting to restart. VM Name: *Virtual_Machine_Name*, VM Id:*Virtual_Machine_ID_Number*

### ⁠Improving Uptime with Virtual Machine High Availability

#### Why Use High Availability?

High availability is recommended for virtual machines running critical workloads.

High availability can ensure that virtual machines are restarted in the following scenarios:

*   When a host becomes non-operational due to hardware failure.
*   When a host is put into maintenance mode for scheduled downtime.
*   When a host becomes unavailable because it has lost communication with an external storage resource.

A high availability virtual machine is automatically restarted, either on its original host or another host in the cluster.

#### What is High Availability?

High availability means that a virtual machine will be automatically restarted if its process is interrupted. This happens if the virtual machine is terminated by methods other than powering off from within the guest or sending the shutdown command from oVirt. When these events occur, the highly available virtual machine is automatically restarted, either on its original host or another host in the cluster.

High availability is possible because oVirt constantly monitors the hosts and storage, and automatically detects hardware failure. If host failure is detected, any virtual machine configured to be highly available is automatically restarted on another host in the cluster.

With high availability, interruption to service is minimal because virtual machines are restarted within seconds with no user intervention required. High availability keeps your resources balanced by restarting guests on a host with low current resource utilization, or based on any workload balancing or power saving policies that you configure. This ensures that there is sufficient capacity to restart virtual machines at all times.

#### High Availability Considerations

A highly available host requires a power management device and its fencing parameters configured. In addition, for a virtual machine to be highly available when its host becomes non-operational, it needs to be started on another available host in the cluster. To enable the migration of highly available virtual machines:

*   Power management must be configured for the hosts running the highly available virtual machines.
*   The host running the highly available virtual machine must be part of a cluster which has other available hosts.
*   The destination host must be running.
*   The source and destination host must have access to the data domain on which the virtual machine resides.
*   The source and destination host must have access to the same virtual networks and VLANs.
*   There must be enough CPUs on the destination host that are not in use to support the virtual machine's requirements.
*   There must be enough RAM on the destination host that is not in use to support the virtual machine's requirements.

#### Configuring a Highly Available Virtual Machine

**Summary**

High availability must be configured individually for each virtual machine.

**Procedure 8.47. Configuring a Highly Available Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** to open the **Edit Virtual Machine** window.
3.  Click the **Show Advanced Options** button.
4.  Click the **High Availability** tab.
5.  Select the **Highly Available** check box to enable high availability for the virtual machine.
6.  Use the radio buttons to set the **Priority for Run/Migrate Queue** of the virtual machine to one of **Low**, **Medium**, or **High**. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.
7.  Click **OK**.

**Result**

You have configured high availability for a virtual machine. You can check if a virtual machine is highly available by selecting the virtual machine and clicking on the **General** tab in the details pane.

### ⁠Other Virtual Machine Tasks

#### Enabling SAP monitoring for a virtual machine from the Administration Portal

**Summary**

Enable SAP monitoring on a virtual machine to be recognized by SAP monitoring systems.

**Procedure 8.48. Enabling SAP monitoring for a Virtual Machine from the Administration Portal**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** button to open the **Edit Virtual Machine** window.
3.  Click the **Show Advanced Properties** button.
4.  Select the **Custom Properties** tab.
    ![Custom Properties tab](Edit Virtual Machine CustomProperties.png "fig:Custom Properties tab")
    **Figure 8.19. Enable SAP**
5.  Use the drop-down menu to select `sap_agent`. Ensure the secondary drop-down menu is set to **True**. If previous properties have been set, select the plus sign to add a new property rule and select `sap_agent`.
6.  Click **OK** to save changes and close the window.

**Result**

You have enabled SAP monitoring for your virtual machine.

#### Configuring Red Hat Enterprise Linux 5.4 or Higher Virtual Machines to use SPICE

##### Using SPICE on virtual machines running versions of Red Hat Enterprise Linux released prior to 5.4

SPICE is a remote display protocol designed for virtual environments, which enables you to view a virtualized desktop or server. SPICE delivers a high quality user experience, keeps CPU consumption low, and supports high quality video streaming.

Using SPICE on a Linux machine significantly improves the movement of the mouse cursor on the console of the virtual machine. To use SPICE, the X-Windows system requires additional qxl drivers. The qxl drivers are provided with Red Hat Enterprise Linux 5.4 and newer. Older versions are not supported. Installing SPICE on a virtual machine running Red Hat Enterprise Linux significantly improves the performance of the graphical user interface.

<div class="alert alert-info">
**Note:** Typically, this is most useful for virtual machines where the user requires the use of the graphical user interface. System administrators who are creating virtual servers may prefer not to configure SPICE if their use of the graphical user interface is minimal.

</div>

##### Installing qxl drivers on virtual machines

**Summary**

This procedure installs qxl drivers on virtual machines running Red Hat Enterprise Linux 5.4 or higher.

**Procedure 8.49. Installing qxl Drivers on a Virtual Machine**

1.  Log in to a Red Hat Enterprise Linux virtual machine.
2.  Open a terminal.
3.  Run the following command as root:
        # yum install xorg-x11-drv-qxl

**Result**

The qxl drivers have been installed and must now be configured.

##### Configuring qxl drivers on virtual machines

**Summary**

You can configure qxl drivers using either a graphical interface or the command line. Perform only one of the following procedures.

**Procedure 8.50. Configuring qxl drivers in GNOME**

1.  Click **System**.
2.  Click **Administration**.
3.  Click **Display**.
4.  Click the **Hardware** tab.
5.  Click **Video Cards Configure**.
6.  Select **qxl** and click **OK**.
7.  Restart X Window by logging out of the virtual machine and logging back in.

**Procedure 8.51. Configuring qxl drivers on the command line:**

1.  Back up `/etc/X11/xorg.conf`:
        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

2.  Make the following change to the Device section of `/etc/X11/xorg.conf`:
        Section     "Device"
        Identifier  "Videocard0"
        Driver      "qxl"
        Endsection

**Result**

You have configured qxl drivers to enable your virtual machine to use SPICE.

##### Configuring a Virtual Machine's Tablet and Mouse to use SPICE

**Summary**

Edit the `/etc/X11/xorg.conf` file to enable SPICE for your virtual machine's tablet devices.

**Procedure 8.52. Configuring a virtual machine's tablet and mouse to use SPICE**

1.  Verify that the tablet device is available on your guest:
        # /sbin/lsusb -v | grep 'QEMU USB Tablet'

    If there is no output from the command, do not continue configuring the tablet.

2.  Back up `/etc/X11/xorg.conf` by running this command:
        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

3.  Make the following changes to /etc/X11/xorg.conf:
        Section "ServerLayout"
        Identifier     "single head configuration"
        Screen      0  "Screen0" 0 0
        InputDevice    "Keyboard0" "CoreKeyboard"
        InputDevice    "Tablet" "SendCoreEvents"
        InputDevice    "Mouse" "CorePointer"
        EndSection

        Section "InputDevice"
        Identifier  "Mouse"
        Driver      "void"
        #Option      "Device" "/dev/input/mice"
        #Option      "Emulate3Buttons" "yes"
        EndSection

        Section "InputDevice"
        Identifier  "Tablet"
        Driver      "evdev"
        Option      "Device" "/dev/input/event2"
        Option "CorePointer" "true"
        EndSection

4.  Log out and log back into the virtual machine to restart X-Windows.

**Result**

You have enabled a tablet and a mouse device on your virtual machine to use SPICE.

#### KVM Virtual Machine Timing Management

Virtualization poses various challenges for virtual machine time keeping. Virtual machines which use the Time Stamp Counter (TSC) as a clock source may suffer timing issues as some CPUs do not have a constant Time Stamp Counter. Virtual machines running without accurate timekeeping can have serious affects on some networked applications as your virtual machine will run faster or slower than the actual time.

KVM works around this issue by providing virtual machines with a paravirtualized clock. The KVM `pvclock` provides a stable source of timing for KVM guests that support it.

Presently, only Red Hat Enterprise Linux/CentOS 5.4 and higher virtual machines fully support the paravirtualized clock.

Virtual machines can have several problems caused by inaccurate clocks and counters:

*   Clocks can fall out of synchronization with the actual time which invalidates sessions and affects networks.
*   Virtual machines with slower clocks may have issues migrating.

These problems exist on other virtualization platforms and timing should always be tested.

<div class="alert alert-info">
**Important:** The Network Time Protocol (NTP) daemon should be running on the host and the virtual machines. Enable the `ntpd` service:

    # service ntpd start

Add the ntpd service to the default startup sequence:

    # chkconfig ntpd on

Using the `ntpd` service should minimize the affects of clock skew in all cases.

</div>
The NTP servers you are trying to use must be operational and accessible to your hosts and virtual machines.

Determining if your CPU has the constant Time Stamp Counter

Your CPU has a constant Time Stamp Counter if the `constant_tsc` flag is present. To determine if your CPU has the `constant_tsc` flag run the following command:

    $ cat /proc/cpuinfo | grep constant_tsc

If any output is given your CPU has the `constant_tsc` bit. If no output is given follow the instructions below.

Configuring Hosts Without a Constant Time Stamp Counter

Systems without constant time stamp counters require additional configuration. Power management features interfere with accurate time keeping and must be disabled for virtual machines to accurately keep time with KVM.

<div class="alert alert-info">
**Important:** These instructions are for AMD revision F CPUs only.

</div>
If the CPU lacks the `constant_tsc` bit, disable all power management features ([BZ#513138](https://bugzilla.redhat.com/show_bug.cgi?id=513138)). Each system has several timers it uses to keep time. The TSC is not stable on the host, which is sometimes caused by `cpufreq` changes, deep C state, or migration to a host with a faster TSC. Deep C sleep states can stop the TSC. To prevent the kernel using deep C states append "`processor.max_cstate=1`" to the kernel boot options in the `grub.conf` file on the host:

    term Red Hat Enterprise Linux Server (2.6.18-159.el5)
            root (hd0,0)
        kernel /vmlinuz-2.6.18-159.el5 ro root=/dev/VolGroup00/LogVol00 rhgb quiet processor.max_cstate=1

Disable `cpufreq` (only necessary on hosts without the `constant_tsc`) by editing the `/etc/sysconfig/cpuspeed` configuration file and change the `MIN_SPEED` and `MAX_SPEED` variables to the highest frequency available. Valid limits can be found in the `/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_frequencies` files.

Using the `engine-config` tool to receive alerts when hosts drift out of sync.

You can use the `engine-config` tool to configure alerts when your hosts drift out of sync.

There are two relevant parameters for time drift on hosts: `EnableHostTimeDrift` and `HostTimeDriftInSec`. `EnableHostTimeDrift`, with a default value of false, can be enabled to receive alert notifications of host time drift. The `HostTimeDriftInSec` parameter is used to set the maximum allowable drift before alerts start being sent.

Alerts are sent once per hour per host.

Using the Paravirtualized Clock with Red Hat Enterprise Linux or CentOS virtual machines

For certain Red Hat Enterprise Linux or CentOS virtual machines, additional kernel parameters are required. These parameters can be set by appending them to the end of the /kernel line in the /boot/grub/grub.conf file of the virtual machine.

<div class="alert alert-info">
**Note:** The process of configuring kernel parameters can be automated using the `ktune` package

</div>
The `ktune` package provides an interactive Bourne shell script, `fix_clock_drift.sh`. When run as the superuser, this script inspects various system parameters to determine if the virtual machine on which it is run is susceptible to clock drift under load. If so, it then creates a new `grub.conf.kvm` file in the `/boot/grub/` directory. This file contains a kernel boot line with additional kernel parameters that allow the kernel to account for and prevent significant clock drift on the KVM virtual machine. After running `fix_clock_drift.sh` as the superuser, and once the script has created the `grub.conf.kvm` file, then the virtual machine's current `grub.conf` file should be backed up manually by the system administrator, the new `grub.conf.kvm` file should be manually inspected to ensure that it is identical to `grub.conf` with the exception of the additional boot line parameters, the `grub.conf.kvm` file should finally be renamed `grub.conf`, and the virtual machine should be rebooted.

The table below lists versions of Red Hat Enterprise Linux and the parameters required for virtual machines on systems without a constant Time Stamp Counter.

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p><strong>Red Hat Enterprise Linux</strong></p></th>
<th align="left"><p><strong>Additional virtual machine kernel parameters</strong></p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>5.4 AMD64/Intel 64 with the paravirtualized clock</p></td>
<td align="left"><p>Additional parameters are not required</p></td>
</tr>
<tr class="even">
<td align="left"><p>5.4 AMD64/Intel 64 without the paravirtualized clock</p></td>
<td align="left"><p>notsc lpj=n</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5.4 x86 with the paravirtualized clock</p></td>
<td align="left"><p>Additional parameters are not required</p></td>
</tr>
<tr class="even">
<td align="left"><p>5.4 x86 without the paravirtualized clock</p></td>
<td align="left"><p>clocksource=acpi_pm lpj=n</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5.3 AMD64/Intel 64</p></td>
<td align="left"><p>notsc</p></td>
</tr>
<tr class="even">
<td align="left"><p>5.3 x86</p></td>
<td align="left"><p>clocksource=acpi_pm</p></td>
</tr>
<tr class="odd">
<td align="left"><p>4.8 AMD64/Intel 64</p></td>
<td align="left"><p>notsc</p></td>
</tr>
<tr class="even">
<td align="left"><p>4.8 x86</p></td>
<td align="left"><p>clock=pmtmr</p></td>
</tr>
<tr class="odd">
<td align="left"><p>3.9 AMD64/Intel 64</p></td>
<td align="left"><p>Additional parameters are not required</p></td>
</tr>
<tr class="even">
<td align="left"><p>3.9 x86</p></td>
<td align="left"><p>Additional parameters are not required</p></td>
</tr>
</tbody>
</table>

Using the Real-Time Clock with Windows Virtual Machines

Windows uses the both the Real-Time Clock (RTC) and the Time Stamp Counter (TSC). For Windows virtual machines the Real-Time Clock can be used instead of the TSC for all time sources which resolves virtual machine timing issues.

To enable the Real-Time Clock for the PMTIMER clocksource (the PMTIMER usually uses the TSC) add the following line to the Windows boot settings. Windows boot settings are stored in the boot.ini file. Add the following line to the `boot.ini` file:

    /use pmtimer

For more information on Windows boot settings and the pmtimer option, refer to [Available switch options for the Windows XP and the Windows Server 2003 Boot.ini files](http://support.microsoft.com/kb/833721).

#### Monitoring Virtual Machine Login Activity Using the Sessions Tab

Client virtual machines connecting to oVirt will require maintenance and/or updates on occasion. The information contained in the **Sessions** tab allows you to monitor virtual machine login activity to avoid performing maintenance tasks on machines in active use.

Use the **Virtual Machines** resource tab, tree mode, or the search function to find and select a virtual machine in the results list. Select the **Sessions** tab in the details pane to display **Logged-in User**, **Console User**, and **Console Client IP**.

## ⁠Templates

### Introduction to Templates

A template is a copy of a preconfigured virtual machine, used to simplify the subsequent, repeated creation of similar virtual machines. Templates capture installed software and software configurations, as well as the hardware configuration, of the original virtual machine.

When you create a template from a virtual machine, a read-only copy of the virtual machine's disk is taken. The read-only disk becomes the base disk image of the new template, and of any virtual machines created from the template. As such, the template cannot be deleted whilst virtual machines created from the template exist in the environment.

Virtual machines created from a template use the same NIC type and driver as the original virtual machine, but utilize separate and unique MAC addresses.

<div class="alert alert-info">
**Note:** A virtual machine may require to be sealed before being used to create a template.

</div>

### Template Tasks

#### Creating a Template

**Summary**

Create a template from an existing virtual machine to use as a blueprint for creating additional virtual machines.

**Procedure 9.1. Creating a Template from an Existing Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Ensure the virtual machine is powered down and has a status of `Down`.
3.  Click **Make Template** to open the **New Template** window.
    ![The New Template window](New Template.png "fig:The New Template window")
    **Figure 9.1. The New Template window**
4.  Enter a **Name**, **Description**, and **Comment** for the template.
5.  From the **Cluster** drop-down menu, select the cluster with which the template will be associated. By default, this will be the same as that of the source virtual machine.
6.  Optionally, select the **Create as a Sub Template version** check box, select a **Root Template** and enter a **Sub Version Name** to create the new template as a sub template of an existing template.
7.  In the **Disks Allocation** section, enter an alias for the disk in the **Alias** text field and select the storage domain on which the disk will be stored from the **Target** drop-down list. By default, these will be the same as those of the source virtual machine.
8.  The **Allow all users to access this Template** check box is selected by default. This makes the template public.
9.  The **Copy VM permissions** check box is not selected by default. Select this check box to copy the permissions of the source virtual machine to the template.
10. Click **OK**.

**Result**

The virtual machine displays a status of `Image Locked` while the template is being created. The process of creating a template may take up to an hour depending on the size of the virtual machine disk and your storage hardware. When complete, the template is added to the **Templates** tab. You can now create new virtual machines based on the template.

<div class="alert alert-info">
**Note:** When a template is made, the virtual machine is copied so that both the existing virtual machine and its template are usable after template creation.

</div>

#### Explanation of Settings and Controls in the New Template Window

The following table details the settings for the **New Template** window.⁠

**Table 9.1. New Template and Edit Template Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the template. This is the name by which the template is listed in the <strong>Templates</strong> tab in the Administration Portal and is accessed via the REST API. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>A description of the template. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text, human-readable comments regarding the template.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Cluster</strong></p></td>
<td align="left"><p>The cluster with which the template will be associated. This is the same as the original virtual machines by default. You can select any cluster in the data center.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Create as a Sub Template version</strong></p></td>
<td align="left"><p>Allows you to specify whether the template will be created as a new version of an existing template. Select this check box to access the settings for configuring this option.</p>
<ul>
<li><strong>Root Template</strong>: The template under which the sub template will be added.</li>
<li><strong>Sub Version Name</strong>: The name of the template. This is the name by which the template is accessed when creating a new virtual machine based on the template.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Disks Allocation</strong></p></td>
<td align="left"><p><strong>Alias</strong> - An alias for the virtual machine disk used by the template. By default, the alias is set to the same value as that of the source virtual machine. <strong>Virtual Size</strong> - The current actual size of the virtual disk used by the template. This value cannot be edited, and is provided for reference only. <strong>Target</strong> - The storage domain on which the virtual disk used by the template will be stored. By default, the storage domain is set to the same value as that of the source virtual machine. You can select any storage domain in the cluster.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Allow all users to access this Template</strong></p></td>
<td align="left"><p>Allows you to specify whether a template is public or private. A public template can be accessed by all users, whereas a private template can only be accessed by users with the <strong>TemplateAdmin</strong> or <strong>SuperUser</strong> roles.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Copy VM permissions</strong></p></td>
<td align="left"><p>Allows you to copy explicit permissions that have been set on the source virtual machine to the template.</p></td>
</tr>
</tbody>
</table>

#### Editing a Template

**Summary**

Once a template has been created, its properties can be edited. Because a template is a copy of a virtual machine, the options available when editing a template are identical to those in the **Edit Virtual Machine** window.

⁠

**Procedure 9.2. Editing a Template**

1.  Use the **Templates** resource tab, tree mode, or the search function to find and select the template in the results list.
2.  Click **Edit** to open the **Edit Template** window.
3.  Change the necessary properties and click **OK**.

**Result**

The properties of the template are updated. The **Edit Template** window will not close if a property field is invalid.

#### Deleting a Template

**Summary**

Delete a template from your oVirt environment.

<div class="alert alert-info">
**Warning:** If you have used a template to create a virtual machine, make sure that you do not delete the template as the virtual machine needs it to continue running.

</div>
⁠

**Procedure 9.3. Deleting a Template**

1.  Use the resource tabs, tree mode, or the search function to find and select the template in the results list.
2.  Click **Remove** to open the **Remove Template(s)** window.
3.  Click **OK** to remove the template.

**Result**

You have removed the template.

#### Exporting Templates

##### Migrating Templates to the Export Domain

**Summary**

Export templates into the export domain to move them to another data domain, either in the same oVirt environment, or another one.

⁠

**Procedure 9.4. Exporting Individual Templates to the Export Domain**

1.  Use the **Templates** resource tab, tree mode, or the search function to find and select the template in the results list.
2.  Click **Export** to open the **Export Template** window.
    <div class="alert alert-info">
    **Note:** Select the **Force Override** check box to replace any earlier version of the template on the export domain.

    </div>
3.  Click **OK** to begin exporting the template; this may take up to an hour, depending on the virtual machine disk image size and your storage hardware.
4.  Repeat these steps until the export domain contains all the templates to migrate before you start the import process. Use the **Storage** resource tab, tree mode, or the search function to find and select the export domain in the results list and click the **Template Import** tab in the details pane to view all exported templates in the export domain.

**Result**

The templates have been exported to the export domain.

##### Copying a Template's Virtual Hard Disk

**Summary**

If you are moving a virtual machine that was created from a template with the thin provisioning storage allocation option selected, the template's disks must be copied to the same storage domain as that of the virtual machine disk.

⁠

**Procedure 9.5. Copying a Virtual Hard Disk**

1.  Select the **Disks** tab.
2.  Select the template disk or disks to copy.
3.  Click the **Copy** button to display the **Copy Disk** window.
4.  Use the drop-down menu or menus to select the **Target** data domain.

**Result**

A copy of the template's virtual hard disk has been created, either on the same, or a different, storage domain. If you were copying a template disk in preparation for moving a virtual hard disk, you can now move the virtual hard disk.

#### Importing Templates

##### Importing a Template into a Data Center

**Summary**

Import templates from a newly attached export domain.

⁠

**Procedure 9.6. Importing a Template into a Data Center**

1.  Use the resource tabs, tree mode, or the search function to find and select the newly attached export domain in the results list.
2.  Select the **Template Import** tab of the details pane to display the templates that migrated across with the export domain.
3.  Select a template and click **Import** to open the **Import Template(s)** window.
4.  Select the templates to import.
5.  Use the drop-down menus to select the **Destination Cluster** and **Storage** domain. Alter the **Suffix** if applicable. Alternatively, clear the **Clone All Templates** check box.
6.  Click **OK** to import templates and open a notification window. Click **Close** to close the notification window.

**Result**

The template is imported into the destination data center. This can take up to an hour, depending on your storage hardware. You can view the import progress in the **Events** tab.

Once the importing process is complete, the templates will be visible in the **Templates** resource tab. The templates can create new virtual machines, or run existing imported virtual machines based on that template.

##### Importing a Virtual Disk Image from an OpenStack Image Service as a Template

**Summary**

Virtual disk images managed by an OpenStack Image Service can be imported into oVirt if that OpenStack Image Service has been added to oVirt as an external provider.

1.  Click the **Storage** resource tab and select the OpenStack Image Service domain from the results list.
2.  Select the image to import in the **Images** tab of the details pane.
3.  Click **Import** to open the **Import Image(s)** window.
    ⁠

    ![The Import Image(s) Window](images/5008.png "The Import Image(s) Window")

    **Figure 9.2. The Import Image(s) Window**

4.  From the **Data Center** drop-down menu, select the data center into which the virtual disk image will be imported.
5.  From the **Domain Name** drop-down menu, select the storage domain in which the virtual disk image will be stored.
6.  Optionally, select a quota from the **Quota** drop-down menu to apply a quota to the virtual disk image.
7.  Select the **Import as Template** check box.
8.  From the **Cluster** drop-down menu, select the cluster in which the virtual disk image will be made available as a template.
9.  Click **OK** to import the virtual disk image.

**Result**

The image is imported as a template and is displayed in the results list of the **Templates** resource tab. You can now create virtual machines based on the template.

### Sealing Virtual Machines in Preparation for Deployment as Templates

#### Sealing a Linux Virtual Machine for Deployment as a Template

##### Sealing a Linux Virtual Machine for Deployment as a Template

There are two main methods for sealing a Linux virtual machine in preparation for using that virtual machine to create a template: manually, or using the `sys-unconfig` command. Sealing a Linux virtual machine manually requires you to create a file on the virtual machine that acts as a flag for initiating various configuration tasks the next time you start that virtual machine. The `sys-unconfig` command allows you to automate this process. However, both of these methods also require you to manually delete files on the virtual machine that are specific to that virtual machine or might cause conflicts amongst virtual machines created based on the template you will create based on that virtual machine. As such, both are valid methods for sealing a Linux virtual machine and will achieve the same result.

##### Sealing a Linux Virtual Machine Manually for Deployment as a Template

**Summary**

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

⁠**Procedure 9.7. Sealing a Linux Virtual Machine**

1.  Log in to the virtual machine.
2.  Flag the system for re-configuration by running the following command as root:
        # touch /.unconfigured

3.  Run the following command to remove ssh host keys:
        # rm -rf /etc/ssh/ssh_host_*

4.  Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network`
5.  Run the following command to remove `/etc/udev/rules.d/70-*`:
        # rm -rf /etc/udev/rules.d/70-*

6.  Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.
7.  Optionally, delete all the logs from `/var/log` and build logs from `/root`.
8.  Run the following command to shut down the virtual machine:
        # poweroff

**Result**

The virtual machine is sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.

##### Sealing a Linux Virtual Machine for Deployment as a Template using sys-unconfig

**Summary**

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

**Procedure 9.8. Sealing a Linux Virtual Machine using sys-unconfig**

1.  Log in to the virtual machine.
2.  Run the following command to remove ssh host keys:
        # rm -rf /etc/ssh/ssh_host_*

3.  Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network`.
4.  Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.
5.  Optionally, delete all the logs from `/var/log` and build logs from `/root`.
6.  Run the following command:
        # sys-unconfig

**Result**

The virtual machine shuts down; it is now sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.

#### Sealing a Windows Virtual Machine for Deployment as a Template

##### Considerations when Sealing a Windows Template with Sysprep

A template created for Windows virtual machines must be generalized (sealed) before being used to deploy virtual machines. This ensures that machine-specific settings are not reproduced in the template.

The **Sysprep** tool is used to seal Windows templates before use.

<div class="alert alert-info">
**Important:** Do not reboot the virtual machine during this process.

</div>
Before starting the `Sysprep` process, verify the following settings are configured:

*   The Windows **Sysprep** parameters have been correctly defined. If not, click **Edit** and enter the required information in the **Operating System** and **Domain** fields.
*   The correct product key has been entered in the `engine-config` configuration tool. If not, run the configuration tool on oVirt as the root user, and enter the required information. The configuration keys that you need to set are `ProductKey` and `SysPrepPath`. For example, the Windows 7 configuration value is `ProductKeyWindow7` and `SysPrepWindows7Path`. Set these values with this command:
        # engine-config --set ProductKeyWindow7=<validproductkey> --cver=general

##### Sealing a Windows XP Template

**Summary**

Seal a Windows XP template using the **Sysprep** tool before using the template to deploy virtual machines.

<div class="alert alert-info">
**Note:** You can also use the procedure above to seal a Windows 2003 template. The Windows 2003 **Sysprep** tool is available at [<http://www.microsoft.com/download/en/details.aspx?id=14830>](http://www.microsoft.com/download/en/details.aspx?id=14830).

</div>
⁠

**Procedure 9.9. Sealing a Windows XP Template**

1.  Download `sysprep` to the virtual machine to be used as a template. The Windows XP **Sysprep** tool is available at [<http://www.microsoft.com/download/en/details.aspx?id=11282>](http://www.microsoft.com/download/en/details.aspx?id=11282)
2.  Create a new directory: `c:\sysprep`.
3.  Open the `deploy.cab` file and add its contents to `c:\sysprep`.
4.  Execute `sysprep.exe` from within the folder and click **OK** on the welcome message to display the Sysprep tool.
5.  Select the following check boxes:
    -   **Don't reset grace period for activation**
    -   **Use Mini-Setup**

6.  Ensure that the shutdown mode is set to `Shut down` and click **Reseal**.
7.  Acknowledge the pop-up window to complete the sealing process; the virtual machine shuts down automatically upon completion.

**Result**

The Windows XP template is sealed and ready for deploying virtual machines.

##### Sealing a Windows 7 or Windows 2008 Template

**Summary**

Seal a Windows 7 or Windows 2008 template before using the template to deploy virtual machines.

⁠

**Procedure 9.10. Sealing a Windows 7 or Windows 2008 Template**

1.  In the virtual machine to be used as a template, open a command line terminal and type `regedit`.
2.  The **Registry Editor** window opens. On the left pane, expand **HKEY_LOCAL_MACHINE** → **SYSTEM** → **SETUP**.
3.  On the main window, right-click to add a new string value using **New** → **String Value**.
4.  Right-click on the file and select **Modify** to open the **Edit String** window.
5.  Enter the following information in the provided fields:
    -   Value name: `UnattendFile`
    -   Value data: `a:\sysprep.inf`

6.  Launch **Sysprep** from `C:\Windows\System32\sysprep\sysprep.exe`.
7.  Enter the following information into the **Sysprep** tool:
    -   Under **System Cleanup Action**, select **Enter System Out-of-Box-Experience (OOBE)**.
    -   Select the **Generalize** check box if you need to change the computer's system identification number (SID).
    -   Under **Shutdown Options**, select **Shutdown**.

    Click **OK** to complete the sealing process; the virtual machine shuts down automatically upon completion.

**Result**

The Windows 7 or Windows 2008 template is sealed and ready for deploying virtual machines.

#### Using Cloud-Init to Automate the Configuration of Virtual Machines

##### Cloud-Init Overview

Cloud-Init is a tool for automating the initial setup of virtual machines such as configuring the host name, network interfaces, and authorized keys. It can be used when provisioning virtual machines that have been deployed based on a template to avoid conflicts on the network.

To use this tool, the cloud-init package must first be installed on the virtual machine. Once installed, the Cloud-Init service starts during the boot process to search for instructions on what to configure. You can then use options in the **Run Once** window to provide these instructions one time only, or options in the **New Virtual Machine**, **Edit Virtual Machine** and **Edit Template** windows to provide these instructions every time the virtual machine starts.

##### Cloud-Init Use Case Scenarios

Cloud-Init can be used to automate the configuration of virtual machines in a variety of scenarios. Several common scenarios are as follows:

Virtual Machines Created Based on Templates  
You can use the Cloud-Init options in the **Initial Run** section of the **Run Once** window to initialize a virtual machine that was created based on a template. This allows you to customize the virtual machine the first time that virtual machine is started.

Virtual Machine Templates  
You can use the **Use Cloud-Init/Sysprep** options in the **Initial Run** tab of the **New Template** and **Edit Template** windows to specify options for customizing virtual machines created based on that template.

Virtual Machine Pools  
You can use the **Use Cloud-Init/Sysprep** options in the **Initial Run** tab of the **New Pool** window to specify options for customizing virtual machines taken from that virtual machine pool. This allows you to specify a set of standard settings that will be applied every time a virtual machine is taken from that virtual machine pool. You can inherit or override the options specified for the template on which the virtual machine is based, or specify options for the virtual machine pool itself.

##### Installing Cloud-Init

**Summary**

Install Cloud-Init on a Red Hat or CentOS virtual machine.

**Procedure 9.11. Installing Cloud-Init**

1.  Log on to the virtual machine.
2.  Install the cloud-init package and dependencies:
        # yum install cloud-init

**Result**

You have installed the cloud-init package and dependencies.

##### Using Cloud-Init to Initialize a Virtual Machine

**Summary**

Use Cloud-Init to automate the initial configuration of a Linux virtual machine that has been provisioned based on a template.

⁠

**Procedure 9.12. Using Cloud-Init to Initialize a Virtual Machine**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Run Once** to open the **Run Virtual Machine(s)** window.
3.  Expand the **Initial Run** section and select the **Cloud-Init** check box.
4.  Enter a host name in the **VM Hostname** text field.
5.  Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down menu.
6.  Select the **Use already configured password** check box to use the existing credentials, or clear that check box and enter a root password in the **Root Password** and **Verify Root Password** text fields to specify a new root password.
7.  Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.
8.  Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.
9.  Enter any DNS servers in the **DNS Servers** text field.
10. Enter any DNS search domains in the **DNS Search Domains** text field.
11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.
12. Enter any custom scripts in the **Custom Script** text area.
13. Click **OK**.

<div class="alert alert-info">
**Important:** Cloud-Init is only supported on cluster compatibility version 3.3 and higher.

</div>
**Result**

The virtual machine boots and the specified settings are applied.

##### Using Cloud-Init to Prepare a Template

**Summary**

Use Cloud-Init to specify a set of standard settings to be included in a template.

<div class="alert alert-info">
**Note:** While the following procedure outlines how to use Cloud-Init when preparing a template, the same settings are also available in the **New Virtual Machine** and **Edit Template** windows.

</div>
⁠

**Procedure 9.13. Using Cloud-Init to Prepare a Template**

1.  Click the **Virtual Machines** tab and select a virtual machine.
2.  Click **Edit** to open the **Edit Virtual Machine** window.
3.  Click the **Initial Run** tab and select the **Use Cloud-Init/Sysprep** check box.
4.  Enter a host name in the **VM Hostname** text field.
5.  Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down menu.
6.  Expand the **Authentication** section and select the **Use already configured password** check box to user the existing credentials, or clear that check box and enter a root password in the **Root Password** and **Verify Root Password** text fields to specify a new root password.
7.  Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.
8.  Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.
9.  Expand the **Networks** section and enter any DNS servers in the **DNS Servers** text field.
10. Enter any DNS search domains in the **DNS Search Domains** text field.
11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.
12. Expand the **Custom Script** section and enter any custom scripts in the **Custom Script** text area.
13. Click **Ok**.

<div class="alert alert-info">
**Important:** Cloud-Init is only supported on cluster compatibility version 3.3 and higher.

</div>
**Result**

The virtual machine boots and the specified settings are applied.

## ⁠Pools

### Introduction to Virtual Machine Pools

A virtual machine pool is a group of virtual machines that are all clones of the same template and that can be used on demand by any user in a given group. Virtual machine pools allow administrators to rapidly configure a set of generalized virtual machines for users.

Users access a virtual machine pool by taking a virtual machine from the pool. When a user takes a virtual machine from a pool, they are provided with any one of the virtual machines in the pool if any are available. That virtual machine will have the same operating system and configuration as that of the template on which the pool was based, but users may not receive the same member of the pool each time they take a virtual machine. Users can also take multiple virtual machines from the same virtual machine pool depending on the configuration of that pool.

Virtual machines in a virtual machine pool are stateless, meaning that data is not persistent across reboots. However, if a user configures console options for a virtual machine taken from a virtual machine pool, those options will be set as the default for that user for that virtual machine pool.

In principle, virtual machines in a pool are started when taken by a user, and shut down when the user is finished. However, virtual machine pools can also contain pre-started virtual machines. Pre-started virtual machines are kept in an up state, and remain idle until they are taken by a user. This allows users to start using such virtual machines immediately, but these virtual machines will consume system resources even while not in use due to being idle.

<div class="alert alert-info">
**Note:** Virtual machines taken from a pool are not stateless when accessed from the Administration Portal. This is because administrators need to be able to write changes to the disk if necessary.

</div>

### Virtual Machine Pool Tasks

#### Creating a Virtual Machine Pool

**Summary**

You can create a virtual machine pool that contains multiple virtual machines that have been created based on a common template.

**Procedure 10.1. Creating a Virtual Machine Pool**

1.  Click the **Pools** tab.
2.  Click the **New** button to open the **New Pool** window.
    -   Use the drop down-list to select the **Cluster** or use the selected default.
    -   Use the **Based on Template** drop-down menu to select a template or use the selected default. If you have selected a template, optionally use the **Template Sub Version** drop-down menu to select a version of that template. A template provides standard settings for all the virtual machines in the pool.
    -   Use the **Operating System** drop-down list to select an **Operating System** or use the default provided by the template.
    -   Use the **Optimized for** drop-down list to optimize virtual machines for either **Desktop** use or **Server** use.

3.  Enter a **Name** and **Description**, any **Comments** and the **Number of VMs** for the pool.
4.  Select the **Maximum number of VMs per user** that a single user is allowed to run in a session. The minimum is one.
5.  Optionally, click the **Show Advanced Options** button and perform the following steps:
    1.  Select the **Console** tab. At the bottom of the tab window, select the **Override SPICE Proxy** check box to enable the **Overridden SPICE proxy address** text field and specify the address of a SPICE proxy to override the global SPICE proxy, if any.
    2.  Click the **Pool** tab and select a **Pool Type**:
        -   **Manual** - The administrator is responsible for explicitly returning the virtual machine to the pool. The virtual machine reverts to the original base image after the administrator returns it to the pool.
        -   **Automatic** - When the virtual machine is shut down, it automatically reverts to its base image and is returned to the virtual machine pool.

6.  Click **OK**.

**Result**

You have created and configured a virtual machine pool with the specified number of identical virtual machines. You can view these virtual machines in the **Virtual Machines** resource tab, or in the details pane of the **Pools** resource tab; a virtual machine in a pool is distinguished from independent virtual machines by its icon.

#### Explanation of Settings and Controls in the New Pool Window

##### New Pool General Settings Explained

The following table details the information required on the **General** tab of the **New Pool** window that is specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** window.

**Table 10.1. General settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Number of VMs</strong></p></td>
<td align="left"><p>Allows you to specify the number of virtual machines in the virtual machine pool that will be created and made available to the virtual machine pool when that virtual machine pools is created. By default, the maximum number of virtual machines you can create in a pool is 1000. This value can be configured using the <code>MaxVmsInPool</code> key of the <code>engine-config</code> command.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Maximum number of VMs per user</strong></p></td>
<td align="left"><p>Allows you to specify the maximum number of virtual machines a single user can take from the virtual machine pool at any one time. The value of this field must be between <code>1</code> and <code>32,767</code>.</p></td>
</tr>
</tbody>
</table>

##### New Pool Pool Settings Explained

The following table details the information required on the **Pool** tab of the **New Pool** window.

⁠**Table 10.2. Console settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Pool Type</strong></p></td>
<td align="left"><p>This drop-down menu allows you to specify the type of the virtual machine pool. The following options are available:</p>
<ul>
<li><strong>Automatic</strong>: After a user finishes using a virtual machine taken from a virtual machine pool, that virtual machine is automatically returned to the virtual machine pool.</li>
<li><strong>Manual</strong>: After a user finishes using a virtual machine taken from a virtual machine pool, that virtual machine is only returned to the virtual machine pool when an administrator manually returns the virtual machine.</li>
</ul></td>
</tr>
</tbody>
</table>

##### New Pool and Edit Pool Console Settings Explained

The following table details the information required on the **Console** tab of the **New Pool** or **Edit Pool** window that is specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Table 10.3. Console settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Override SPICE proxy</strong></p></td>
<td align="left"><p>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hypervisors reside.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Overridden SPICE proxy address</strong></p></td>
<td align="left"><p>The proxy by which the SPICE client will connect to virtual machines. This proxy overrides both the global SPICE proxy defined for the oVirt environment and the SPICE proxy defined for the cluster to which the virtual machine pool belongs, if any. The address must be in the following format:</p>
<pre><code>protocol://[host]:[port]</code></pre></td>
</tr>
</tbody>
</table>

#### Editing a Virtual Machine Pool

**Summary**

After a virtual machine pool has been created, its properties can be edited. The properties available when editing a virtual machine pool are identical to those available when creating a new virtual machine pool except that the **Number of VMs** property is replaced by **Increase number of VMs in pool by**.

⁠

**Procedure 10.2. Editing a Virtual Machine Pool**

1.  Use the **Pools** resource tab, tree mode, or the search function to find and select the virtual machine pool in the results list.
2.  Click **Edit** to open the **Edit Pool** window.
3.  Edit the properties of the virtual machine pool.
4.  Click **Ok**.

**Result**

The properties of an existing virtual machine pool have been edited.

#### Explanation of Settings and Controls in the Edit Pool Window

##### Edit Pool General Settings Explained

The following table details the information required on the **General** tab of the **Edit Pool** window that is specific to virtual machine pools. All other settings are identical to those in the **Edit Virtual Machine** window.

**Table 10.4. General settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Prestarted VMs</strong></p></td>
<td align="left"><p>Allows you to specify the number of virtual machines in the virtual machine pool that will be started before they are taken and kept in that state to be taken by users. The value of this field must be between <code>0</code> and the total number of virtual machines in the virtual machine pool.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Increase number of VMs in pool by</strong></p></td>
<td align="left"><p>Allows you to increase the number of virtual machines in the virtual machine pool by the specified number.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Maximum number of VMs per user</strong></p></td>
<td align="left"><p>Allows you to specify the maximum number of virtual machines a single user can take from the virtual machine at any one time. The value of this field must be between <code>1</code> and <code>32,767</code>.</p></td>
</tr>
</tbody>
</table>

#### Prestarting Virtual Machines in a Pool

The virtual machines in a virtual machine pool are powered down by default. When a user requests a virtual machine from a pool, a machine is powered up and assigned to the user. In contrast, a prestarted virtual machine is already running and waiting to be assigned to a user, decreasing the amount of time a user has to wait before being able to access a machine. When a prestarted virtual machine is shut down it is returned to the pool and restored to its original state. The maximum number of prestarted virtual machines is the number of virtual machines in the pool.

**Summary**

Prestarted virtual machines are suitable for environments in which users require immediate access to virtual machines which are not specifically assigned to them. Only automatic pools can have prestarted virtual machines.

⁠

**Procedure 10.3. Prestarting Virtual Machines in a Pool**

1.  Use the **Pools** resource tab, tree mode, or the search function to find and select the virtual machine pool in the results list.
2.  Click **Edit** to open the **Edit Pool** window.
3.  Enter the number of virtual machines to be prestarted in the **Prestarted VMs** field.
4.  Select the **Pool** tab. Ensure **Pool Type** is set to **Automatic**.
5.  Click **OK**.

**Result**

You have set a number of prestarted virtual machines in a pool. The prestarted machines are running and available for use.

#### Adding Virtual Machines to a Virtual Machine Pool

**Summary**

If you require more virtual machines than originally provisioned in a virtual machine pool, add more machines to the pool.

⁠

**Procedure 10.4. Adding Virtual Machines to a Virtual Machine Pool**

1.  Use the **Pools** resource tab, tree mode, or the search function to find and select the virtual machine pool in the results list.
2.  Click **Edit** to open the **Edit Pool** window.
3.  Enter the number of additional virtual machines to add in the **Increase number of VMs in pool by** field.
4.  Click **OK**.

**Result**

You have added more virtual machines to the virtual machine pool.

#### Detaching Virtual Machines from a Virtual Machine Pool

**Summary**

You can detach virtual machines from a virtual machine pool. Detaching a virtual machine removes it from the pool to become an independent virtual machine.

⁠

**Procedure 10.5. Detaching Virtual Machines from a Virtual Machine Pool**

1.  Use the **Pools** resource tab, tree mode, or the search function to find and select the virtual machine pool in the results list.
2.  Ensure the virtual machine has a status of `Down` because you cannot detach a running virtual machine. Click the **Virtual Machines** tab in the details pane to list the virtual machines in the pool.
3.  Select one or more virtual machines and click **Detach** to open the **Detach Virtual Machine(s)** confirmation window.
4.  Click **OK** to detach the virtual machine from the pool.

<div class="alert alert-info">
**Note:** The virtual machine still exists in the environment and can be viewed and accessed from the **Virtual Machines** resource tab. Note that the icon changes to denote that the detached virtual machine is an independent virtual machine.

</div>
**Result**

You have detached a virtual machine from the virtual machine pool.

#### Removing a Virtual Machine Pool

**Summary**

You can remove a virtual machine pool from a data center. You must first either delete or detach all of the virtual machines in the pool. Detaching virtual machines from the pool will preserve them as independent virtual machines.

⁠

**Procedure 10.6. Removing a Virtual Machine Pool**

1.  Use the **Pools** resource tab, tree mode, or the search function to find and select the virtual machine pool in the results list.
2.  Click **Remove** to open the **Remove Pool(s)** confirmation window.
3.  Click **OK** to remove the pool.

**Result**

You have removed the pool from the data center.

### Trusted Compute Pools

#### Creating a Trusted Cluster

<div class="alert alert-info">
**Note:** If no OpenAttestation server is properly configured, this procedure will fail.

</div>
**Summary**

This procedure explains how to set up a trusted computing pool. Trusted computing pools permit the deployment of virtual machines on trusted hosts. With the addition of attestation, administrators can ensure that verified measurement of software is running in the hosts. This provides the foundation of the secure enterprise stack.

⁠

**Procedure 10.7. Creating a Trusted Cluster**

1.  In the navigation pane, select the **Clusters** tab.
2.  Click the **New** button.
3.  In the **General** tab, set the cluster name.
4.  In the **General** tab, select the **Enable Virt Service** radio button.
5.  In the **Cluster Policy** tab, select **Enable Trusted Service** check box.
6.  Click **OK**.

**Result**

You have built a trusted computing pool.

#### Adding a Trusted Host

**Summary**

This procedure explains how to add a trusted host to your oVirt environment.

⁠

**Procedure 10.8. **

1.  Select the **Hosts** tab.
2.  Click the **New** button.
3.  In the **General** tab, set the host's name.
4.  In the **General** tab, set the host's address.
    **Note**

    The host designated here must be trusted by the attestation server.

5.  In the **General** tab, in the **Host Cluster** drop-down menu, select a trusted cluster.
6.  Click **OK**.

**Result**

You have added a trusted host to your oVirt environment.

## ⁠Virtual Machine Disks

### Understanding Virtual Machine Storage

oVirt supports three storage types: NFS, iSCSI and FCP.

In each type, a host known as the Storage Pool Manager (SPM) manages access between hosts and storage. The SPM host is the only node that has full access within the storage pool; the SPM can modify the storage domain metadata, and the pool's metadata. All other hosts can only access virtual machine hard disk image data.

By default in an NFS, local, or POSIX compliant data center, the SPM creates the virtual disk using a thin provisioned format as a file in a file system.

In iSCSI and other block-based data centers, the SPM creates a volume group on top of the Logical Unit Numbers (LUNs) provided, and makes logical volumes to use as virtual machine disks. Virtual machine disks on block-based storage are preallocated by default.

If the virtual disk is preallocated, a logical volume of the specified size in GB is created. The virtual machine can be mounted on a Red Hat Enterprise Linux server using `kpartx`, `vgscan`, `vgchange` and `mount` to investigate the virtual machine's processes or problems.

If the virtual disk is a thin provisioned, a 1 GB logical volume is created. The logical volume is continuously monitored by the host on which the virtual machine is running. As soon as the usage nears a threshold the host notifies the SPM, and the SPM extends the logical volume by 1 GB. The host is responsible for resuming the virtual machine after the logical volume has been extended. If the virtual machine goes into a paused state it means that the SPM could not extend the disk in time. This occurs if the SPM is too busy or if there is not enough storage space.

A virtual disk with a preallocated (RAW) format has significantly faster write speeds than a virtual disk with a thin provisioning (Qcow2) format. Thin provisioning takes significantly less time to create a virtual disk. The thin provision format is suitable for non-IO intensive virtual machines.

oVirt 3.3 and above introduced online virtual drive resizing.

### Understanding Virtual Disks

Virtual disks are of two types, **Thin Provisioned** or **Preallocated**. Preallocated disks are RAW formatted. Thin provisioned disks are QCOW2 formatted.

*   Preallocated A preallocated virtual disk has reserved storage of the same size as the virtual disk itself. The backing storage device (file/block device) is presented as is to the virtual machine with no additional layering in between. This results in better performance because no storage allocation is required during runtime. On SAN (iSCSI, FCP) this is achieved by creating a block device with the same size as the virtual disk. On NFS this is achieved by filling the backing hard disk image file with zeros. Preallocating storage on an NFS storage domain presumes that the backing storage is not QCOW2 formatted and zeros will not be deduplicated in the hard disk image file. (If these assumptions are incorrect, do not select Preallocated for NFS virtual disks).
*   Thin Provisioned For sparse virtual disks backing storage is not reserved and is allocated as needed during runtime. This allows for storage overcommitment under the assumption that most disks are not fully utilized and that storage capacity can be utilized better. This requires the backing storage to monitor write requests and can cause some performance issues. On NFS backing storage is achieved by using files. On SAN this is achieved by creating a block device smaller than the virtual disk's defined size and communicating with the hypervisor to monitor necessary allocations. This does not require support from the underlying storage devices.

The possible combinations of storage types and formats are described in the following table.

**Table 11.1. Permitted Storage Combinations**

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Storage</p></th>
<th align="left"><p>Format</p></th>
<th align="left"><p>Type</p></th>
<th align="left"><p>Note</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>NFS or iSCSI/FCP</p></td>
<td align="left"><p>RAW or Qcow2</p></td>
<td align="left"><p>Sparse or Preallocated</p></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>NFS</p></td>
<td align="left"><p>RAW</p></td>
<td align="left"><p>Preallocated</p></td>
<td align="left"><p>A file with an initial size which equals the amount of storage defined for the virtual disk, and has no formatting.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>NFS</p></td>
<td align="left"><p>RAW</p></td>
<td align="left"><p>Sparse</p></td>
<td align="left"><p>A file with an initial size which is close to zero, and has no formatting.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NFS</p></td>
<td align="left"><p>Qcow2</p></td>
<td align="left"><p>Sparse</p></td>
<td align="left"><p>A file with an initial size which is close to zero, and has RAW formatting. Subsequent layers will be Qcow2 formatted.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SAN</p></td>
<td align="left"><p>RAW</p></td>
<td align="left"><p>Preallocated</p></td>
<td align="left"><p>A block device with an initial size which equals the amount of storage defined for the virtual disk, and has no formatting.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SAN</p></td>
<td align="left"><p>Qcow2</p></td>
<td align="left"><p>Preallocated</p></td>
<td align="left"><p>A block device with an initial size which equals the amount of storage defined for the virtual disk, and has Qcow2 formatting.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SAN</p></td>
<td align="left"><p>Qcow2</p></td>
<td align="left"><p>Sparse</p></td>
<td align="left"><p>A block device with an initial size which is much smaller than the size defined for the VDisk (currently 1GB), and has Qcow2 formatting for which space is allocated as needed (currently in 1GB increments).</p></td>
</tr>
</tbody>
</table>

### Shareable Disks in oVirt

Some applications require storage to be shared between servers. oVirt allows you to mark virtual machine hard disks as **shareable** and attach those disks to virtual machines. That way a single virtual disk can be used by multiple cluster-aware guests.

Shared disks are not to be used in every situation. For applications like clustered database servers, and other highly available services, shared disks are appropriate. Attaching a shared disk to multiple guests that are not cluster-aware is likely to cause data corruption because their reads and writes to the disk are not coordinated.

You cannot take a snapshot of a shared disk. Virtual disks that have snapshots taken of them cannot later be marked shareable.

You can mark a disk shareable either when you create it, or by editing the disk later.

### Read Only Disks in oVirt

Some applications require administrators to share data with read-only rights. oVirt allows you to mark virtual machine hard disks as **Read Only** and attach those disks to virtual machines. If a disk is marked **shareable**, you can add it to some virtual machines as read-only and to others as rewritable. That way, a single disk can be read by multiple cluster-aware guests, while an administrator maintains writing privileges.

Floating disks are always rewritable and cannot be marked read-only.

A disk cannot be switched from or to read-only while active.

You can mark a disk read-only either when you create it, or by editing the disk later.

### Virtual Disk Tasks

#### Creating Floating Virtual Disks

**Summary**

You can create a virtual disk that does not belong to any virtual machines. You can then attach this disk to a single virtual machine, or to multiple virtual machines if the disk is shareable.

**Procedure 11.1. Creating Floating Virtual Disks**

1.  Select the **Disks** resource tab.
2.  Click **Add** to open the **Add Virtual Disk** window.
    ![Add Virtual Disk Window](Add_Virtual_Disk.png "fig:Add Virtual Disk Window")
    **Figure 11.1. Add Virtual Disk Window**
3.  Use the radio buttons to specify whether the virtual disk will be an **Internal** or **External (Direct Lun)** disk.
4.  Enter the **Size(GB)**, **Alias**, and **Description** of the virtual disk.
5.  Use the drop-down menus to select the **Interface**, **Allocation Policy**, **Data Center**, and **Storage Domain** of the virtual disk.
6.  Select the **Wipe After Delete**, **Is Bootable** and **Is Shareable** check boxes to enable each of these options.
7.  Click **OK**.

**Result**

You have created a virtual disk that can be attached to one or more virtual machines depending on its settings.

#### Explanation of Settings in the New Virtual Disk Window

**Table 11.2. Add Virtual Disk Settings: Internal**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Size(GB)</strong></p></td>
<td align="left"><p>The size of the new virtual disk in GB.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Alias</strong></p></td>
<td align="left"><p>The name of the virtual disk, limited to 40 characters.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>A description of the virtual disk. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Interface</strong></p></td>
<td align="left"><p>The virtual interface the disk presents to virtual machines. <strong>VirtIO</strong> is faster, but requires drivers. Red Hat Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. IDE devices do not require special drivers.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Allocation Policy</strong></p></td>
<td align="left"><p>The provisioning policy for the new virtual disk. <strong>Preallocated</strong> allocates the entire size of the disk on the storage domain at the time the virtual disk is created. <strong>Thin Provision</strong> allocates 1 GB at the time the virtual disk is created and sets a maximum limit on the size to which the disk can grow. Preallocated virtual disks take more time to create than thinly provisioned virtual disks, but have better read and write performance. Preallocated virtual disks are recommended for servers. Thinly provisioned disks are faster to create than preallocated disks and allow for storage over-commitment. Thinly provisioned virtual disks are recommended for desktops.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center in which the virtual disk will be available.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Storage Domain</strong></p></td>
<td align="left"><p>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given cluster, and also shows the total space and currently available space in the storage domain.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Wipe after delete</strong></p></td>
<td align="left"><p>Allows you to enable enhanced security for deletion of sensitive material when the virtual disk is deleted.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Is bootable</strong></p></td>
<td align="left"><p>Allows you to enable the bootable flag on the virtual disk.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Is Shareable</strong></p></td>
<td align="left"><p>Allows you to attach the virtual disk to more than one virtual machine at a time.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Read Only</strong></p></td>
<td align="left"><p>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another.</p></td>
</tr>
</tbody>
</table>

The **External (Direct Lun)** settings can be displayed in either **Targets > LUNs** or **LUNs > Targets**. **Targets > LUNs** sorts available LUNs according to the host on which they are discovered, whereas **LUNs > Targets** displays a single list of LUNs.

**Table 11.3. Add Virtual Disk Settings: External (Direct Lun)**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Alias</strong></p></td>
<td align="left"><p>The name of the virtual disk, limited to 40 characters.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>A description of the virtual disk. This field is recommended but not mandatory.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Interface</strong></p></td>
<td align="left"><p>The virtual interface the disk presents to virtual machines. <strong>VirtIO</strong> is faster, but requires drivers. Red Hat Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. IDE devices do not require special drivers.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center in which the virtual disk will be available.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Use Host</strong></p></td>
<td align="left"><p>The host on which the LUN will be mounted. You can select any host in the data center.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Storage Type</strong></p></td>
<td align="left"><p>The type of external LUN to add. You can select from either <strong>iSCSI</strong> or <strong>Fibre Channel</strong>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Discover Targets</strong></p></td>
<td align="left"><p>This section can be expanded when you are using iSCSI external LUNs and <strong>Targets > LUNs</strong> is selected. <strong>Address</strong> - The host name or IP address of the target server. <strong>Port</strong> - The port by which to attempt a connection to the target server. The default port is 3260. <strong>User Authentication</strong> - The iSCSI server requires User Authentication. The <strong>User Authentication</strong> field is visible when you are using iSCSI external LUNs. <strong>CHAP user name</strong> - The user name of a user with permission to log in to LUNs. This field is accessible when the <strong>User Authentication</strong> check box is selected. <strong>CHAP password</strong> - The password of a user with permission to log in to LUNs. This field is accessible when the <strong>User Authentication</strong> check box is selected.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Is bootable</strong></p></td>
<td align="left"><p>Allows you to enable the bootable flag on the virtual disk.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Is Shareable</strong></p></td>
<td align="left"><p>Allows you to attach the virtual disk to more than one virtual machine at a time.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Read Only</strong></p></td>
<td align="left"><p>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another.</p></td>
</tr>
</tbody>
</table>

Fill in the fields in the **Discover Targets** section and click the **Discover** button to discover the target server. You can then click the **Login All** button to list the available LUNs on the target server and, using the radio buttons next to each LUN, select the LUN to add.

Using LUNs directly as virtual machine hard disk images removes a layer of abstraction between your virtual machines and their data.

The following considerations must be made when using a direct LUN as a virtual machine hard disk image:

*   Live storage migration of direct LUN hard disk images is not supported.
*   Direct LUN disks are not included in virtual machine exports.
*   Direct LUN disks are not included in virtual machine snapshots.

#### Moving a Virtual Disk

**Summary**

You can move a virtual disk that is attached to a virtual machine or acts as a floating virtual disk from one storage domain to another

<div class="alert alert-info">
**Note:** If the virtual disk is attached to a virtual machine that was created based on a template and used the thin provisioning storage allocation option, the disks for the template on which the virtual machine was based must be copied to the same storage domain as the virtual disk.

</div>
⁠

**Procedure 11.2. Moving a Virtual Disk**

1.  Select the **Disks** tab.
2.  Select the virtual disks to move.
3.  Click the **Move** button to open the **Move Disk(s)** window.
4.  Use the **Target** drop-down menus to select the storage domain to which the virtual disk will be moved.
5.  Click **OK**.

**Result**

The virtual disks are moved to the target storage domain, and have a status of `Locked` while being moved.

#### Copying a Virtual Disk

**Summary**

You can copy a virtual disk attached to a template from one storage domain to another.

⁠

**Procedure 11.3. Copying a Virtual Disk**

1.  Select the **Disks** tab.
2.  Select the virtual disks to copy.
3.  Click the **Copy** button to open the **Copy Disk(s)** window.
4.  Use the **Target** drop-down menus to select the storage domain to which the virtual disk will be copied.
5.  Click **OK**.

**Result**

The virtual disks are copied to the target storage domain, and have a status of `Locked` while being copied.

## ⁠Backups

### Backing Up and Restoring oVirt

#### Backing up oVirt - Overview

While taking complete backups of the machine on which oVirt is installed is recommended whenever changing the configuration of that machine, a utility is provided for backing up only the key files related to oVirt. This utility - the `engine-backup` command - can be used to rapidly back up the engine database and configuration files into a single file that can be easily stored.

#### Syntax for the engine-backup Command

The `engine-backup` command works in one of two basic modes:

    # engine-backup --mode=backup

    # engine-backup --mode=restore

These two modes are further extended by a set of parameters that allow you to specify the scope of the backup and different credentials for the engine database. A full list of parameters and their function is as follows:

**Basic Options**

*`--mode`*  
Specifies whether the command will perform a backup operation or a restore operation. Two options are available - `backup`, and `restore`. This is a required parameter.

*`--file`*  
Specifies the path and name of a file into which backups are to be taken in backup mode, and the path and name of a file from which to read backup data in restore mode. This is a required parameter in both backup mode and restore mode.

*`--log`*  
Specifies the path and name of a file into which logs of the backup or restore operation are to be written. This parameter is required in both backup mode and restore mode.

*`--scope`*  
Specifies the scope of the backup or restore operation. There are two options - `all`, which backs up both the engine database and configuration data, and `db`, which backs up only the engine database.

**Database Options**

The following options are only available when using the `engine-backup` command in `restore` mode.

*`--change-db-credentials`*  
Allows you to specify alternate credentials for restoring the engine database using credentials other than those stored in the backup itself. Specifying this parameter allows you to add the following parameters.

*`--db-host`*  
Specifies the IP address or fully qualified domain name of the host on which the database resides. This is a required parameter.

*`--db-port`*  
Specifies the port by which a connection to the database will be made.

*`--db-user`*  
Specifies the name of the user by which a connection to the database will be made. This is a required parameter.

*`--db-passfile`*  
Specifies a file containing the password by which a connection to the database will be made. Either this parameter or the *`--db-password`* parameter must be specified.

*`--db-password`*  
Specifies the plain text password by which a connection to the database will be made. Either this parameter or the *`--db-passfile`* parameter must be specified.

*`--db-name`*  
Specifies the name of the database to which the database will be restored. This is a required parameter.

*`--db-secured`*  
Specifies that the connection with the database is to be secured.

*`--db-secured-validation`*  
Specifies that the connection with the host is to be validated.

**Help**

*`--help`*  
Provides an overview of the available modes, parameters, sample usage, how to create a new database and configure the firewall in conjunction with backing up and restoring oVirt.

#### Creating a Backup with the engine-backup Command

**Summary**

The process for creating a backup of the engine database and the configuration data for oVirt using the `engine-backup` command is straightforward and can be performed while oVirt is active.

**Procedure 12.1. Backing up oVirt**

1.  Log on to the machine running oVirt.
2.  Run the following command to create a full backup:
    **Example 12.1. Creating a Full Backup**
        # engine-backup --scope=all --mode=backup --log=[file name] --file=[file name]

    Alternatively, run the following command to back up only the engine database:
    **Example 12.2. Creating an engine database Backup**

        # engine-backup --scope=db --mode=backup --log=[file name] --file=[file name]

**Result**

A `tar` file containing a backup of the engine database, or the engine database and the configuration data for oVirt, is created using the path and file name provided.

#### Restoring a Backup with the engine-backup Command

While the process for restoring a backup using the `engine-backup` command is straightforward, it involves several additional steps in comparison to that for creating a backup depending on the destination to which the backup is to be restored. For example, the `engine-backup` command can be used to restore backups to fresh installations of oVirt, on top of existing installations of oVirt, and using local or remote databases.

<div class="alert alert-info">
**Important:** Backups can only be restored to environments of the same major release as that of the backup. For example, a backup of an oVirt version 3.3 environment can only be restored to another oVirt version 3.3 environment. To view the version of oVirt contained in a backup file, unpack the backup file and read the value in the `version` file located in the root directory of the unpacked files.

</div>

#### Restoring a Backup to a Fresh Installation

**Summary**

The `engine-backup` command can be used to restore a backup to a fresh installation of oVirt. The following procedure must be performed on a machine on which the base operating system has been installed and the required packages for oVirt have been installed, but the `engine-setup` command has not yet been run. This procedure assumes that the backup file can be accessed from the machine on which the backup is to be restored.

<div class="alert alert-info">
**Note:** The `engine-backup` command does not handle the actual creation of the engine database or the initial configuration of the `postgresql` service. Therefore, these tasks must be performed manually as outlined below when restoring a backup to a fresh installation.

</div>
**Procedure 12.2. Restoring a Backup to a Fresh Installation**

1.  Log on to the machine on which oVirt is installed.
2.  Manually create an empty database to which the database in the backup can be restored and configure the `postgresql` service:
    1.  Run the following commands to initialize the `postgresql` database, start the `postgresql` service and ensure this service starts on boot:
            # service postgresql initdb
            # service postgresql start
            # chkconfig postgresql on

    2.  Run the following commands to enter the postgresql command line:
            # su postgres
            $ psql

    3.  Run the following command to create a new user:
            postgres=# create role [user name] with login encrypted password '[password]';

    4.  Run the following command to create the new database:
            postgres=# create database [database name] owner [user name] template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

    5.  Edit the `/var/lib/pgsql/data/pg_hba.conf` file as follows:
        -   For local databases, replace the existing directives in the section starting with `Local` at the bottom of the file with the following directives:
                host    [database name]    [user name]    0.0.0.0/0  md5
                host    [database name]    [user name]    ::0/0      md5

        -   For remote databases, add the following line immediately underneath the line starting with `Local` at the bottom of the file, replacing *X.X.X.X* with the IP address of oVirt:
                host    [database name]    [user name]    X.X.X.X/32   md5

    6.  Run the following command to restart the `postgresql` service:
            # service postgresql restart

3.  Restore the backup using the `engine-backup` command with the *`--change-db-credentials`* parameter to pass the credentials of the new database:
        # engine-backup --mode=restore --file=[file name] --log=[file name] --change-db-credentials --db-host=[database location] --db-name=[database name] --db-user=[user name] --db-password=[password]

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4.  Run the following command and follow the prompts to configure oVirt:
        # engine-setup

**Result**

The engine database and configuration files for oVirt have been restored to the version in the backup.

#### Restoring a Backup to Overwrite an Existing Installation

**Summary**

The `engine-backup` command can restore a backup to a machine on which oVirt has already been installed and set up. This is useful when you have taken a backup up of an installation, performed changes on that installation and then want to restore the installation from the backup.

<div class="alert alert-info">
**Note:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-backup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist.

</div>
**Procedure 12.3. Restoring a Backup to Overwrite an Existing Installation**

1.  Log on to the machine on which oVirt is installed.
2.  Run the following command and follow the prompts to remove the configuration files for and clean the database associated with oVirt:
        # engine-cleanup

3.  Restore the backup using the `engine-backup` command:
        # engine-backup --mode=restore --file=[file name] --log=[file name]

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4.  Run the following command and follow the prompts to re-configure the firewall and ensure the `ovirt-engine` service is correctly configured:
        # engine-setup

**Result**

The engine database and configuration files for oVirt have been restored to the version in the backup.

#### Restoring a Backup with Different Credentials

**Summary**

The `engine-backup` command can restore a backup to a machine on which oVirt has already been installed and set up, but the credentials of the database in the backup are different to those of the database on the machine on which the backup is to be restored. This is useful when you have taken a backup of an installation and want to restore the installation from the backup to a different system.

<div class="alert alert-info">
**Important:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-backup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist. However, if the credentials for the owner of the engine database are not known, you must change them before you can restore the backup.

</div>
**Procedure 12.4. Restoring a Backup with Different Credentials**

1.  Log on to the machine on which oVirt is installed.
2.  Run the following command and follow the prompts to remove the configuration files for and clean the database associated with oVirt:
        # engine-cleanup

3.  Change the password for the owner of the engine database if the credentials of that user are not known:
    1.  Run the following commands to enter the postgresql command line:
            # su postgres
            $ psql

    2.  Run the following command to change the password of the user that owns the engine database:
            postgres=# alter role [user name] encrypted password '[new password]';

4.  Restore the backup using the `engine-backup` command with the *`--change-db-credentials`* parameter:
        # engine-backup --mode=restore --file=[file name] --log=[file name] --change-db-credentials --db-host=[database location] --db-name=[database name] --db-user=[user name] --db-password=[password]

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

5.  Run the following command and follow the prompts to re-configure the firewall and ensure the `ovirt-engine` service is correctly configured:
        # engine-setup

**Result**

The engine database and configuration files for oVirt have been restored to the version in the backup using the supplied credentials, and oVirt has been configured to use the new database.

### Manually Backing Up and Restoring oVirt

#### Backing Up the Engine Database Using the backup.sh Script

**Summary**

oVirt includes a script to automate database backups. Using this script on your Manager server, you can protect yourself against potential data loss.

**Procedure 12.5. Backing up the engine database using the backup.sh script**

1.  Change into the `/usr/share/ovirt-engine/dbscripts/` directory.
2.  Invoke `backup.sh` with the *`-h`* parameter to see the available options.
        Usage: backup.sh [-h] [-s SERVERNAME] [-p PORT] [-d DATABASE] [-l DIR] -u USERNAME [-v] 

            -s SERVERNAME - The database servername for the database (def. localhost)
            -p PORT       - The database port for the database       (def. 5432)
            -d DATABASE   - The database name                        (def. engine)
            -u USERNAME   - The username for the database.
            -v            - Turn on verbosity (WARNING: lots of output)
            -l DIR        - Backup file directory. 
            -h            - This help text.

        for more options please run pg_dump --help

3.  Invoke the `backup.sh` command again with parameters appropriate for your environment. If you are backing up the local `engine` database, the *`-s, -p,`* and *`-d`* parameters are not necessary. Use the *`-l`* to specify the backup directory. This will cause a `.sql` file to be created in the directory you give.
4.  Copy the `.sql` you just created from the directory you specified to a safe remote location.

**Result**

You have used the backup.sh script to backup your `engine` database.

#### Backing Up Manager Configuration Files

oVirt stores customized configurations as configuration files. These configuration files contain specific configuration details regarding a given environment, and must be backed up.

**Table 12.1. Files and directories that must be backed up**

<table>
<colgroup>
<col width="67%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Location</p></th>
<th align="left"><p>Overview</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>/etc/ovirt-engine/</p></td>
<td align="left"><p>A directory containing oVirt configuration files such as <code>engine-config.conf</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>/etc/yum/pluginconf.d/versionlock.list</p></td>
<td align="left"><p>A file containing version information about currently installed oVirt components.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>/etc/pki/ovirt-engine/</p></td>
<td align="left"><p>Security certificates provided by oVirt to clients.</p></td>
</tr>
<tr class="even">
<td align="left"><p>/usr/share/jasperreports-server-pro/buildomatic/</p></td>
<td align="left"><p>A directory containing files required to build the oVirt reports server.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>/var/lib/ovirt-engine/backups/</p></td>
<td align="left"><p>A directory containing backup files.</p></td>
</tr>
<tr class="even">
<td align="left"><p>/var/tmp/ovirt-engine/deployments/</p></td>
<td align="left"><p>A directory containing information on deployments.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>/usr/share/ovirt-engine-reports/</p></td>
<td align="left"><p>A directory containing configuration files related to reports. In particular, this directory contains sub-directories in which the credentials of the reports user are stored in a plain text, human-readable format.</p></td>
</tr>
<tr class="even">
<td align="left"><p>/root/.rnd</p></td>
<td align="left"><p>A random seed file used to generate secure certificates.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>/var/log/ovirt-engine/setup/</p></td>
<td align="left"><p>A directory containing logs that contain the answers you gave to the setup configuration questions. You must use these files when restoring oVirt because they supply the same information that was used to initially configure oVirt.</p></td>
</tr>
</tbody>
</table>

When you have backed up all the above files and directories, you can recover oVirt to a working state after an unforeseen event.

#### Restoring the Engine Database Using the restore.sh Script

**Summary**

oVirt includes a script to automate database restoration. Using this script on your Manager server, you can recover from database corruption.

**Procedure 12.6. Restoring the Engine Database Using the restore.sh Script**

1.  Change into the `/usr/share/ovirt-engine/dbscripts/` directory.
2.  Invoke `restore.sh` with the *`-h`* parameter to see the available options.
        Usage: restore.sh [-h] [-s SERVERNAME] [-p PORT] -u USERNAME -d DATABASE -f FILE [-r] 

            -s SERVERNAME - The database servername for the database (def. localhost)
            -p PORT       - The database port for the database       (def. 5432)
            -u USERNAME   - The username for the database.
            -d DATABASE   - The database name
            -f File       - Backup file name to restore from. 
            -r            - Remove existing database with same name
            -h            - This help text.

        for more options please run pg_restore --help

3.  Invoke the `restore.sh` command again with parameters appropriate for your environment. If you are restoring the local `engine` database, the *`-s`* and *`-p`* parameters are not necessary. Use the *`-d`* to specify name of the database you are creating. oVirt expects a primary database named `engine`. Use the *`-f`* to specify the `.sql` file you are restoring from.

**Result**

You have used the restore.sh script to restore your `engine` database.

#### Restoring oVirt Configuration Files

**Summary**

Restore a backed up copy of configuration files to oVirt.

**Procedure 12.7. Restoring oVirt Configuration Files**

1.  Stop the engine service:
        # service ovirt-engine stop

2.  Completely remove all previous installations of oVirt:
        # yum remove ovirt-engine

3.  Remove `/etc/pki/ovirt-engine`:
        # rm -rf /etc/pki/ovirt-engine

4.  Remove the main `ovirt-engine` directory:
        # rm -rf /etc/ovirt-engine

5.  Install oVirt:
        # yum install -y ovirt-engine

6.  Run `engine-setup`, giving the same answers as when you originally installed `ovirt-engine`:
        # engine-setup

    Your answers can be found in `/var/log/engine-setup-SETUP-DATE.log`, which you backed up.

7.  Stop the engine service, which was restarted as a part of the previous command:
        # service ovirt-engine stop

8.  Restore the backed up configuration files to their original locations.
9.  Make sure the ownership of the `.truststore` file is correct:
        # chown ovirt:ovirt /etc/pki/ovirt-engine/.truststore

10. Make sure the permissions of the `ovirt-engine-notifier.conf` file is correct:
        # chmod 640 /usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf

11. Start the engine service:
        # service ovirt-engine start

**Result**

You have restored a backed up copy of configuration files to oVirt.

## ⁠Users and Roles

### Introduction to Users

oVirt uses external directory services for user authentication and information. All user accounts must be created in external directory servers; these users are called *directory users*. The exception is the `admin` user which resides in the `internal` domain created during installation.

After a directory server is attached to oVirt, the users in the directory can be added to the Administration Portal, making them *oVirt users*. oVirt users can be assigned different roles and permissions according to the tasks they have to perform.

There are two types of oVirt users - end users who use and manage virtual resources from the User Portal, and administrators who maintain the system infrastructure using the Administration Portal. `User` roles and `admin` roles can be assigned to oVirt users for individual resources like virtual machines and hosts, or on a hierarchy of objects like clusters and data centers.

### Directory Users

#### Directory Services Support in oVirt

During installation oVirt creates its own internal administration user, `admin`. This account is intended for use when initially configuring the environment, and for troubleshooting. To add other users to oVirt you must attach a directory server to oVirt using the Domain Management Tool, `engine-manage-domains`.

Once at least one directory server has been attached to oVirt, you can add users that exist in the directory server and assign roles to them using the Administration Portal. Users can be identified by their User Principal Name (UPN) of the form `user@domain`. Attachment of more than one directory server to oVirt is also supported.

The directory servers supported for use with oVirt 3.4 are:

*   Active Directory
*   Identity Management (IdM)
*   Red Hat Directory Server 9 (RHDS 9)
*   OpenLDAP

You must ensure that the correct DNS records exist for your directory server. In particular you must ensure that the DNS records for the directory server include:

*   A valid pointer record (PTR) for the directory server's reverse look-up address.
*   A valid service record (SRV) for LDAP over TCP port `389`.
*   A valid service record (SRV) for Kerberos over TCP port `88`.
*   A valid service record (SRV) for Kerberos over UDP port `88`.

If these records do not exist in DNS then you cannot add the domain to oVirt configuration using `engine-manage-domains`.

For more detailed information on installing and configuring a supported directory server, see the vendor's documentation:

*   Active Directory - [<http://technet.microsoft.com/en-us/windowsserver/dd448614>](http://technet.microsoft.com/en-us/windowsserver/dd448614).
*   Identity Management (IdM) - [<http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/index.html>](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/index.html)
*   Red Hat Directory Server (RHDS) - [<http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/index.html>](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/index.html)
*   OpenLDAP - [<http://www.openldap.org/doc/>](http://www.openldap.org/doc/)

<div class="alert alert-info">
**Important:** A user must be created in the directory server specifically for use as the oVirt administrative user. Do *not* use the administrative user for the directory server as the oVirt administrative user.

</div>
<div class="alert alert-info">
**Important:** It is not possible to install oVirt (rhevm) and IdM (ipa-server) on the same system. IdM is incompatible with the mod_ssl package, which is required by oVirt.

</div>
<div class="alert alert-info">
**Important:** If you are using Active Directory as your directory server, and you want to use `sysprep` in the creation of Templates and Virtual Machines, then the oVirt administrative user must be delegated control over the Domain to:

*   **Join a computer to the domain**
*   **Modify the membership of a group**

For information on creation of user accounts in Active Directory, see [<http://technet.microsoft.com/en-us/library/cc732336.aspx>](http://technet.microsoft.com/en-us/library/cc732336.aspx).

For information on delegation of control in Active Directory, see [<http://technet.microsoft.com/en-us/library/cc732524.aspx>](http://technet.microsoft.com/en-us/library/cc732524.aspx).

</div>
<div class="alert alert-info">
**Note:** oVirt uses Kerberos to authenticate with directory servers. RHDS does not provide native support for Kerberos. If you are using RHDS as your directory server then you must ensure that the directory server is made a service within a valid Kerberos domain. To do this you must perform these steps while referring to the relevant directory server documentation:

*   Configure the `memberOf` plug-in for RHDS to allow group membership. In particular ensure that the value of the *`memberofgroupattr`* attribute of the `memberOf` plug-in is set to `uniqueMember`. In **OpenLDAP**, the `memberOf` functionality is not called a "plugin". It is called an "overlay" and requires no configuration after installation. Consult the Red Hat Directory Server 9.0 *Plug-in Guide* for more information on configuring the `memberOf` plug-in.
*   Define the directory server as a service of the form `ldap/hostname@REALMNAME` in the Kerberos realm. Replace *hostname* with the fully qualified domain name associated with the directory server and *REALMNAME* with the fully qualified Kerberos realm name. The Kerberos realm name must be specified in capital letters.
*   Generate a `keytab` file for the directory server in the Kerberos realm. The `keytab` file contains pairs of Kerberos principals and their associated encrypted keys. These keys allow the directory server to authenticate itself with the Kerberos realm. Consult the documentation for your Kerberos principle for more information on generating a `keytab` file.
*   Install the `keytab` file on the directory server. Then configure RHDS to recognize the `keytab` file and accept Kerberos authentication using GSSAPI. Consult the Red Hat Directory Server 9.0 *Administration Guide* for more information on configuring RHDS to use an external `keytab` file.
*   Test the configuration on the directory server by using the `kinit` command to authenticate as a user defined in the Kerberos realm. Once authenticated run the `ldapsearch` command against the directory server. Use the *`-Y GSSAPI`* parameters to ensure the use of Kerberos for authentication.

</div>

### User Authorization

#### User Authorization Model

oVirt applies authorization controls based on the combination of the three components:

*   The user performing the action
*   The type of action being performed
*   The object on which the action is being performed

#### User Actions

For an action to be successfully performed, the `user` must have the appropriate `permission` for the `object` being acted upon. Each type of action corresponds to a `permission`. There are many different permissions in the system, so for simplicity:

![Actions](Actions.png "Actions")

**Figure 13.1. Actions**

<div class="alert alert-info">
**Important:** Some actions are performed on more than one object. For example, copying a template to another storage domain will impact both the template and the destination storage domain. The user performing an action must have appropriate permissions for all objects the action impacts.

</div>

#### User Permissions

Permissions enable users to perform actions on objects, where objects are either individual objects or container objects.

![Permissions & Roles](Permissions roles.png "Permissions & Roles")

**Figure 13.2. Permissions & Roles**

Any permissions that apply to a container object also apply to all members of that container. The following diagram depicts the hierarchy of objects in the system.

![oVirt Object Hierarchy](Object heirarchy.png "oVirt Object Hierarchy")

**Figure 13.3. oVirt Object Hierarchy**

### oVirt User Properties and Roles

#### User Properties

Roles and permissions are the properties of the user. Roles are predefined sets of privileges that permit access to different levels of physical and virtual resources. Multilevel administration provides a finely grained hierarchy of permissions. For example, a data center administrator has permissions to manage all objects in the data center, while a host administrator has system administrator permissions to a single physical host. A user can have permissions to use a single virtual machine but not make any changes to the virtual machine configurations, while another user can be assigned system permissions to a virtual machine.

#### User and Administrator Roles

oVirt provides a range of pre-configured roles, from an administrator with system-wide permissions to an end user with access to a single virtual machine. While you cannot change or remove the default roles, you can clone and customize them, or create new roles according to your requirements. There are two types of roles:

*   Administrator Role: Allows access to the *Administration Portal* for managing physical and virtual resources. An administrator role does not confer any permissions for the User Portal.
*   User Role: Allows access to the *User Portal* for managing and accessing virtual machines and templates. A user role does not confer any permissions for the Administration Portal.

For example, if you have an `administrator` role on a cluster, you can manage all virtual machines in the cluster using the *Administration Portal*. However, you cannot access any of these virtual machines in the *User Portal*; this requires a `user` role.

#### User Roles Explained

The table below describes basic user roles which confer permissions to access and configure virtual machines in the User Portal.

⁠

**Table 13.1. oVirt User Roles - Basic**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Role</p></th>
<th align="left"><p>Privileges</p></th>
<th align="left"><p>Notes</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>UserRole</p></td>
<td align="left"><p>Can access and use virtual machines and pools.</p></td>
<td align="left"><p>Can log in to the User Portal, use assigned virtual machines and pools, view virtual machine state and details.</p></td>
</tr>
<tr class="even">
<td align="left"><p>PowerUserRole</p></td>
<td align="left"><p>Can create and manage virtual machines and templates.</p></td>
<td align="left"><p>Apply this role to a user for the whole environment with the <strong>Configure</strong> window, or for specific data centers or clusters. For example, if a PowerUserRole is applied on a data center level, the PowerUser can create virtual machines and templates in the data center.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>UserVmManager</p></td>
<td align="left"><p>System administrator of a virtual machine.</p></td>
<td align="left"><p>Can manage virtual machines, create and use snapshots, and migrate virtual machines. A user who creates a virtual machine in the User Portal is automatically assigned the UserVmManager role on the machine.</p></td>
</tr>
</tbody>
</table>

<div class="alert alert-info">
**Note:** In oVirt 3.0, the **PowerUserRole** only granted permissions for virtual machines which are directly assigned to the PowerUser, or virtual machines created by the PowerUser. Now, the **VmCreator** role provides privileges previously conferred by the **PowerUserRole**. The **PowerUserRole** can now be applied on a system-wide level, or on specific data centers or clusters, and grants permissions to all virtual machines and templates within the system or specific resource. Having a **PowerUserRole** is equivalent to having the **VmCreator**, **DiskCreator**, and **TemplateCreator** roles.

</div>
The table below describes advanced user roles which allow you to do more fine tuning of permissions for resources in the User Portal.

**Table 13.2. oVirt User Roles - Advanced**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Role</p></th>
<th align="left"><p>Privileges</p></th>
<th align="left"><p>Notes</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>UserTemplateBasedVm</p></td>
<td align="left"><p>Limited privileges to only use Templates.</p></td>
<td align="left"><p>Can use templates to create virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p>DiskOperator</p></td>
<td align="left"><p>Virtual disk user.</p></td>
<td align="left"><p>Can use, view and edit virtual disks. Inherits permissions to use the virtual machine to which the virtual disk is attached.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VmCreator</p></td>
<td align="left"><p>Can create virtual machines in the User Portal.</p></td>
<td align="left"><p>This role is not applied to a specific virtual machine; apply this role to a user for the whole environment with the <strong>Configure</strong> window. Alternatively apply this role for specific data centers or clusters. When applying this role to a cluster, you must also apply the DiskCreator role on an entire data center, or on specific storage domains.</p></td>
</tr>
<tr class="even">
<td align="left"><p>TemplateCreator</p></td>
<td align="left"><p>Can create, edit, manage and remove virtual machine templates within assigned resources.</p></td>
<td align="left"><p>This role is not applied to a specific template; apply this role to a user for the whole environment with the <strong>Configure</strong> window. Alternatively apply this role for specific data centers, clusters, or storage domains.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DiskCreator</p></td>
<td align="left"><p>Can create, edit, manage and remove virtual machine disks within assigned clusters or data centers.</p></td>
<td align="left"><p>This role is not applied to a specific virtual disk; apply this role to a user for the whole environment with the <strong>Configure</strong> window. Alternatively apply this role for specific data centers or storage domains.</p></td>
</tr>
<tr class="even">
<td align="left"><p>TemplateOwner</p></td>
<td align="left"><p>Can edit and delete the template, assign and manage user permissions for the template.</p></td>
<td align="left"><p>This role is automatically assigned to the user who creates a template. Other users who do not have <strong>TemplateOwner</strong> permissions on a template cannot view or use the template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>NetworkUser</p></td>
<td align="left"><p>Logical network and network interface user for virtual machine and template.</p></td>
<td align="left"><p>Can attach or detach network interfaces from specific logical networks.</p></td>
</tr>
</tbody>
</table>

#### Administrator Roles Explained

The table below describes basic administrator roles which confer permissions to access and configure resources in the Administration Portal.

**Table 13.3. oVirt System Administrator Roles - Basic**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Role</p></th>
<th align="left"><p>Privileges</p></th>
<th align="left"><p>Notes</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>SuperUser</p></td>
<td align="left"><p>System Administrator of the oVirt environment.</p></td>
<td align="left"><p>Has full permissions across all objects and levels, can manage all objects across all data centers.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ClusterAdmin</p></td>
<td align="left"><p>Cluster Administrator.</p></td>
<td align="left"><p>Possesses administrative permissions for all objects underneath a specific cluster.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DataCenterAdmin</p></td>
<td align="left"><p>Data Center Administrator.</p></td>
<td align="left"><p>Possesses administrative permissions for all objects underneath a specific data center except for storage.</p></td>
</tr>
</tbody>
</table>

<div class="alert alert-info">
**Important:** Do not use the administrative user for the directory server as the oVirt administrative user. Create a user in the directory server specifically for use as the oVirt administrative user.

</div>
The table below describes advanced administrator roles which allow you to do more fine tuning of permissions for resources in the Administration Portal.

**Table 13.4. oVirt System Administrator Roles - Advanced**

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Role</p></th>
<th align="left"><p>Privileges</p></th>
<th align="left"><p>Notes</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>TemplateAdmin</p></td>
<td align="left"><p>Administrator of a virtual machine template.</p></td>
<td align="left"><p>Can create, delete, and configure the storage domains and network details of templates, and move templates between domains.</p></td>
</tr>
<tr class="even">
<td align="left"><p>StorageAdmin</p></td>
<td align="left"><p>Storage Administrator.</p></td>
<td align="left"><p>Can create, delete, configure, and manage an assigned storage domain.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>HostAdmin</p></td>
<td align="left"><p>Host Administrator.</p></td>
<td align="left"><p>Can attach, remove, configure, and manage a specific host.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NetworkAdmin</p></td>
<td align="left"><p>Network Administrator.</p></td>
<td align="left"><p>Can configure and manage the network of a particular data center or cluster. A network administrator of a data center or cluster inherits network permissions for virtual pools within the cluster.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VmPoolAdmin</p></td>
<td align="left"><p>System Administrator of a virtual pool.</p></td>
<td align="left"><p>Can create, delete, and configure a virtual pool; assign and remove virtual pool users; and perform basic operations on a virtual machine in the pool.</p></td>
</tr>
<tr class="even">
<td align="left"><p>GlusterAdmin</p></td>
<td align="left"><p>Gluster Storage Administrator.</p></td>
<td align="left"><p>Can create, delete, configure, and manage Gluster storage volumes.</p></td>
</tr>
</tbody>
</table>

### oVirt User Tasks

#### Adding Users

**Summary**

Users in oVirt must be added from an external directory service before they can be assigned roles and permissions.

**Procedure 13.1. Adding Users to oVirt**

1.  Click the **Users** tab to display the list of authorized users.
2.  Click **Add**. The **Add Users and Groups** window opens.
    ![Add Users and Groups Window](Add Users.png "fig:Add Users and Groups Window")
    **Figure 13.4. Add Users and Groups Window**
3.  In the **Search** drop down menu, select the appropriate domain. Enter a name or part of a name in the search text field, and click **GO**. Alternatively, click **GO** to view a list of all users and groups.
4.  Select the check boxes for the appropriate users or groups.
5.  Click **OK**.

**Result**

The added user displays on the **Users** tab.

#### Viewing User Information

**Summary**

You can view detailed information on each user in the **Users** tab.

**Procedure 13.2. Viewing User Information**

1.  Click the **Users** tab to display the list of authorized users.
2.  Select the user, or perform a search if the user is not visible on the results list.
3.  The details pane displays for the selected user, usually with the **General** tab displaying general information, such as the domain name, email and status of the user.
4.  The other tabs allow you to view groups, permissions, quotas, and events for the user. For example, to view the groups to which the user belongs, click the **Directory Groups** tab.

**Result**

You have viewed domain, permissions, quota, group and event information for a user.

#### Viewing User Permissions on Resources

**Summary**

Users can be assigned permissions on specific resources or a hierarchy of resources. You can view the assigned users and their permissions on each resource.

**Procedure 13.3. Viewing User Permissions on Resources**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click the **Permissions** tab of the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

**Result**

You have viewed the assigned users and their roles for a selected resource.

#### Removing Users

**Summary**

When a user account is no longer required, remove it from oVirt.

**Procedure 13.4. Removing Users**

1.  Click the **Users** tab to display the list of authorized users.
2.  Select the user to be removed. Ensure the user is not running any virtual machines.
3.  Click the **Remove** button. A message displays prompting you to confirm the removal. Click **OK**.

**Result**

The user is removed from oVirt, but not from the external directory.

#### Configuring Roles

Roles are predefined sets of privileges that can be configured from oVirt. Roles provide access and management permissions to different levels of resources in the data center, and to specific physical and virtual resources.

With multilevel administration, any permissions which apply to a container object also apply to all individual objects within that container. For example, when a host administrator role is assigned to a user on a specific host, the user gains permissions to perform any of the available host operations, but only on the assigned host. However, if the host administrator role is assigned to a user on a data center, the user gains permissions to perform host operations on all hosts within the cluster of the data center.

#### Creating a New Role

**Summary**

If the role you require is not on oVirt's default list of roles, you can create a new role and customize it to suit your purposes.

**Procedure 13.5. Creating a New Role**

1.  On the header bar, click the **Configure** button to open the **Configure** window. The window shows a list of default User and Administrator roles, and any custom roles.
2.  Click **New**. The **New Role** dialog box displays.
    ![The New Role Dialog](New Role.png "fig:The New Role Dialog")
    **Figure 13.5. The New Role Dialog**
3.  Enter the **Name** and **Description** of the new role.
4.  Select either **Admin** or **User** as the **Account Type**.
5.  Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects in the **Check Boxes to Allow Action** list. You can also expand or collapse the options for each object.
6.  For each of the objects, select or clear the actions you wish to permit or deny for the role you are setting up.
7.  Click **OK** to apply the changes you have made. The new role displays on the list of roles.

**Result**

You have created a new role with permissions to specific resources. You can assign the new role to users.

#### Editing or Copying a Role

**Summary**

You can change the settings for roles you have created, but you cannot change default roles. To change default roles, clone and modify them to suit your requirements.

**Procedure 13.6. Editing or Copying a Role**

1.  On the header bar, click the **Configure** button to open the **Configure** window. The window shows a list of default User and Administrator roles, and any custom roles.
2.  Select the role you wish to change. Click **Edit** to open the **Edit Role** window, or click **Copy** to open the **Copy Role** window.
3.  If necessary, edit the **Name** and **Description** of the role.
4.  Use the **Expand All** or **Collapse All** buttons to view more or fewer of the permissions for the listed objects. You can also expand or collapse the options for each object.
5.  For each of the objects, select or clear the actions you wish to permit or deny for the role you are editing.
6.  Click **OK** to apply the changes you have made.

**Result**

You have edited the properties of a role, or cloned a role.

### Assigning an Administrator or User Role to a Resource

**Summary**

Assign administrator or user roles to resources to allow users to access or manage that resource.

**Procedure 13.7. Assigning a Role to a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click the **Permissions** tab of the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.
3.  Click **Add** to open the **Add Permission to User** window.
4.  Enter the name or user name of an existing user into the **Search** text box and click **Go**. Select a user from the resulting list of possible matches.
5.  Select a role from the **Role to Assign:** drop-down menu.
6.  Click **OK** to assign the role and close the window.

**Result**

You have assigned a role to a user; the user now has the inherited permissions of that role enabled for that resource.

### Removing an Administrator or User Role from a Resource

**Summary**

Remove an administrator or user role from a resource; the user loses the inherited permissions associated with the role for that resource.

**Procedure 13.8. Removing a Role from a Resource**

1.  Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.
2.  Click the **Permissions** tab of the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.
3.  Select the user to remove from the resource.
4.  Click **Remove**. The **Remove Permission** window opens to confirm permissions removal.
5.  Click **OK** to remove the user role.

**Result**

You have removed the user's role, and the associated permissions, from the resource.

### User Role and Authorization Examples

The following examples illustrate how to apply authorization controls for various scenarios, using the different features of the authorization system described in this chapter.

**Example 13.1. Cluster Permissions**

Sarah is the system administrator for the accounts department of a company. All the virtual resources for her department are organized under an oVirt `cluster` called `Accounts`. She is assigned the `ClusterAdmin` role on the accounts cluster. This enables her to manage all virtual machines in the cluster, since the virtual machines are child objects of the cluster. Managing the virtual machines includes editing, adding, or removing virtual resources such as disks, and taking snapshots. It does not allow her to manage any resources outside this cluster. Because `ClusterAdmin` is an administrator role, it allows her to use the Administration Portal to manage these resources, but does not give her any access via the User Portal.

**Example 13.2. VM PowerUser Permissions**

John is a software developer in the accounts department. He uses virtual machines to build and test his software. Sarah has created a virtual desktop called `johndesktop` for him. John is assigned the `UserVmManager` role on the `johndesktop` virtual machine. This allows him to access this single virtual machine using the User Portal. Because he has `UserVmManager` permissions, he can modify the virtual machine and add resources to it, such as new virtual disks. Because `UserVmManager` is a user role, it does not allow him to use the Administration Portal.

⁠**Example 13.3. Data Center Power User Role Permissions**

Penelope is an office manager. In addition to her own responsibilities, she occasionally helps the HR manager with recruitment tasks, such as scheduling interviews and following up on reference checks. As per corporate policy, Penelope needs to use a particular application for recruitment tasks.

While Penelope has her own machine for office management tasks, she wants to create a separate virtual machine to run the recruitment application. She is assigned `PowerUserRole` permissions for the data center in which her new virtual machine will reside. This is because to create a new virtual machine, she needs to make changes to several components within the data center, including creating the virtual machine disk image in the storage domain.

Note that this is not the same as assigning `DataCenterAdmin` privileges to Penelope. As a PowerUser for a data center, Penelope can log in to the User Portal and perform virtual machine-specific actions on virtual machines within the data center. She cannot perform data center-level operations such as attaching hosts or storage to a data center.

**Example 13.4. Network Administrator Permissions**

Chris works as the network administrator in the IT department. Her day-to-day responsibilities include creating, manipulating, and removing networks in the department's oVirt environment. For her role, she requires administrative privileges on the resources and on the networks of each resource. For example, if Chris has `NetworkAdmin` privileges on the IT department's data center, she can add and remove networks in the data center, and attach and detach networks for all virtual machines belonging to the data center.

In addition to managing the networks of the company's virtualized infrastructure, Chris also has a junior network administrator reporting to her. The junior network administrator, Pat, is managing a smaller virtualized environment for the company's internal training department. Chris has assigned Pat `NetworkUser` permissions and `UserVmManager` permissions for the virtual machines used by the internal training department. With these permissions, Pat can perform simple administrative tasks such as adding network interfaces onto virtual machines in the Power User Portal. However, he does not have permissions to alter the networks for the hosts on which the virtual machines run, or the networks on the data center to which the virtual machines belong.

**Example 13.5. Custom Role Permissions**

Rachel works in the IT department, and is responsible for managing user accounts in oVirt. She needs permission to add user accounts and assign them the appropriate roles and permissions. She does not use any virtual machines herself, and should not have access to administration of hosts, virtual machines, clusters or data centers. There is no built-in role which provides her with this specific set of permissions. A custom role must be created to define the set of permissions appropriate to Rachel's positi

![UserManager Custom Role](UserManager.png "UserManager Custom Role")

**Figure 13.6. UserManager Custom Role**

The **UserManager** custom role shown above allows manipulation of users, permissions and roles. These actions are organized under `System` - the top level object of the hierarchy shown in Figure 13.6. This means they apply to all other objects in the system. The role is set to have an **Account Type** of **Admin**. This means that when she is assigned this role, Rachel can only use the Administration Portal, not the User Portal.

## ⁠Quotas and Service Level Agreement Policy

### Introduction to Quota

Quota is a resource limitation tool provided with oVirt. Quota may be thought of as a layer of limitations on top of the layer of limitations set by User Permissions.

Quota is a data center object.

Quota allows administrators of oVirt environments to limit user access to memory, CPU, and storage. Quota defines the memory resources and storage resources an administrator can assign users. As a result users may draw on only the resources assigned to them. When the quota resources are exhausted, oVirt does not permit further user actions.

There are two different kinds of Quota:

**Table 14.1. The Two Different Kinds of Quota**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Quota type</p></th>
<th align="left"><p>Definition</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Run-time Quota</p></td>
<td align="left"><p>This quota limits the consumption of runtime resources, like CPU and memory.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Storage Quota</p></td>
<td align="left"><p>This quota limits the amount of storage available.</p></td>
</tr>
</tbody>
</table>

Quota, like SELinux, has three modes:

**Table 14.2. Quota Modes**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Quota Mode</p></th>
<th align="left"><p>Function</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Enforced</p></td>
<td align="left"><p>This mode puts into effect the Quota that you have set in audit mode, limiting resources to the group or user affected by the quota.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Audit</p></td>
<td align="left"><p>This mode allows you to change Quota settings. Choose this mode to increase or decrease the amount of runtime quota and the amount of storage quota available to users affected by it.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Disabled</p></td>
<td align="left"><p>This mode turns off the runtime and storage limitations defined by the quota.</p></td>
</tr>
</tbody>
</table>

When a user attempts to run a virtual machine, the specifications of the virtual machine are compared to the storage allowance and the runtime allowance set in the applicable quota.

If starting a virtual machine causes the aggregated resources of all running virtual machines covered by a quota to exceed the allowance defined in the quota, then oVirt refuses to run the virtual machine.

When a user creates a new disk, the requested disk size is added to the aggregated disk usage of all the other disks covered by the applicable quota. If the new disk takes the total aggregated disk usage above the amount allowed by the quota, disk creation fails.

Quota allows for resource sharing of the same hardware. It supports hard and soft thresholds. Administrators can use a quota to set thresholds on resources. These thresholds appear, from the user's point of view, as 100% usage of that resource. To prevent failures when the customer unexpectedly exceeds this threshold, the interface supports a "grace" amount by which the threshold can be briefly exceeded. Exceeding the threshold results in a warning sent to the customer.

<div class="alert alert-info">
**Important:** Quota imposes limitations upon the running of virtual machines. Ignoring these limitations is likely to result in a situation in which you cannot use your virtual machines and virtual disks.

</div>
When quota is running in enforced mode, virtual machines and disks that do not have quotas assigned cannot be used.

To power on a virtual machine, a quota must be assigned to that virtual machine.

To create a snapshot of a virtual machine, the disk associated with the virtual machine must have a quota assigned.

When creating a template from a virtual machine, you are prompted to select the quota that you want the template to consume. This allows you to set the template (and all future machines created from the template) to consume a different quota than the virtual machine and disk from which the template is generated.

### Shared Quota and Individually Defined Quota

Users with SuperUser permissions can create quotas for individual users or quotas for groups.

Group quotas can be set for Active Directory users. If a group of ten users are given a quota of 1TB of storage and one of the ten users fills the entire terabyte, then the entire group will be in excess of the quota and none of the ten users will be able to use any of the storage associated with their group.

An individual user's quota is set for only the individual. Once the individual user has used up all of his or her storage or runtime quota, the user will be in excess of the quota and the user will no longer be able to use the storage associated with his or her quota.

### Quota Accounting

When a quota is assigned to a consumer or a resource, each action by that consumer or on the resource involving storage, vCPU, or memory results in quota consumption or quota release.

Since the quota acts as an upper bound that limits the user's access to resources, the quota calculations may differ from the actual current use of the user. The quota is calculated for the max growth potential and not the current usage.

**Example 14.1. Accounting example**

A user runs a virtual machine with 1 vCPU and 1024 MB memory. The action consumes 1 vCPU and 1024 MB of the quota assigned to that user. When the virtual machine is stopped 1 vCPU and 1024 MB of RAM are released back to the quota assigned to that user. Run-time quota consumption is accounted for only during the actual run-time of the consumer.

A user creates a virtual thin provision disk of 10GB. The actual disk usage may indicate only 3GB of that disk are actually in use. The quota consumption, however, would be 10GB, the max growth potential of that disk.

### Enabling and Changing a Quota Mode in a Data Center

**Summary**

This procedure enables or changes the quota mode in a data center. You must select a quota mode before you can define quotas. You must be logged in to the Web Administration Portal to follow the steps of this procedure.

Use **Audit** mode to test your quota to make sure it works as you expect it to. You do not need to have your quota in **Audit** mode to create or change a quota.

**Procedure 14.1. Enabling and Changing Quota in a Data Center**

1.  Click the **Data Centers** tab in the Navigation Pane.
2.  From the list of data centers displayed in the Navigation Pane, choose the data center whose quota policy you plan to edit.
3.  Click **Edit** in the top left of the Navigation Pane. An **Edit Data Center** window opens.
4.  In the **Quota Mode** drop-down, change the quota mode to **Enforced**.
5.  Click **OK**.

**Result**

You have now enabled a quota mode at the Data Center level. If you set the quota mode to **Audit** during testing, then you must change it to **Enforced** in order for the quota settings to take effect.

### Creating a New Quota Policy

**Summary**

You have enabled quota mode, either in Audit or Enforcing mode. You want to define a quota policy to manage resource usage in your data center

**Procedure 14.2. Creating a New Quota Policy**

1.  In tree mode, select the data center. The **Quota** tab appears in the Navigation Pane.
2.  Click the **Quota** tab in the Navigation Pane.
3.  Click **Add** in the Navigation Pane. The **New Quota** window opens.
4.  Fill in the **Name** field with a meaningful name. Fill in the **Description** field with a meaningful name.
5.  In the **Memory & CPU** section of the **New Quota** window, use the green slider to set **Cluster Threshold**.
6.  In the **Memory & CPU** section of the **New Quota** window, use the blue slider to set **Cluster Grace**.
7.  Click **Edit** on the bottom-right of the **Memory & CPU** field. An **Edit Quota** window opens.
8.  Under the **Memory** field, select either the **Unlimited** radio button (to allow limitless use of Memory resources in the cluster), or select the **limit to** radio button to set the amount of memory set by this quota. If you select the **limit to** radio button, input a memory quota in megabytes (MB) in the **MB** field.
9.  Under the **CPU** field, select either the **Unlimited** radio button or the **limit to** radio button to set the amount of CPU set by this quota. If you select the **limit to** radio button, input a number of vCPUs in the **vCpus** field.
10. Click **OK** in the **Edit Quota** window.
11. In the **Storage** section of the **New Quota** window, use the green slider to set **Storage Threshold**.
12. In the **Storage** section of the **New Quota** window, use the blue slider to set **Storage Grace**.
13. Click **Edit** in the **Storage** field. The **Edit Quota** window opens.
14. Under the **Storage Quota** field, select either the **Unlimited** radio button (to allow limitless use of Storage) or the **limit to** radio button to set the amount of storage to which quota will limit users. If you select the **limit to** radio button, input a storage quota size in gigabytes (GB) in the **GB** field.
15. Click **OK** in the **Edit Quota** window. You are returned to the **New Quota** window.
16. Click **OK** in the **New Quota** window.

**Result**

You have created a new quota policy.

### Explanation of Quota Threshold Settings

**Table 14.3. Quota thresholds and grace**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Setting</p></th>
<th align="left"><p>Definition</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>Cluster Threshold</p></td>
<td align="left"><p>The amount of cluster resources available per data center.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Cluster Grace</p></td>
<td align="left"><p>The amount of the cluster available for the data center after exhausting the data center's Cluster Threshold.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Storage Threshold</p></td>
<td align="left"><p>The amount of storage resources available per data center.</p></td>
</tr>
<tr class="even">
<td align="left"><p>Storage Grace</p></td>
<td align="left"><p>The amount of storage available for the data center after exhausting the data center's Storage Threshold.</p></td>
</tr>
</tbody>
</table>

If a quota is set to 100GB with 20% Grace, then consumers are blocked from using storage after they use 120GB of storage. If the same quota has a Threshold set at 70%, then consumers receive a warning when they exceed 70GB of storage consumption (but they remain able to consume storage until they reach 120GB of storage consumption.) Both "Threshold" and "Grace" are set relative to the quota. "Threshold" may be thought of as the "soft limit", and exceeding it generates a warning. "Grace" may be thought of as the "hard limit", and exceeding it makes it impossible to consume any more storage resources.

### Assigning a Quota to an Object

**Summary**

This procedure explains how to associate a virtual machine with a quota.

**Procedure 14.3. Assigning a Quota to a Virtual Machine**

1.  In the navigation pane, select the Virtual Machine to which you plan to add a quota.
2.  Click **Edit**. The **Edit Virtual Machine** window appears.
3.  Select the quota you want the virtual machine to consume. Use the **Quota** drop-down to do this.
4.  Click **OK**.

**Result**

You have designated a quota for the virtual machine you selected.

**Summary**

This procedure explains how to associate a virtual machine disk with a quota.

**Procedure 14.4. Assigning a Quota to a Virtual Disk**

1.  In the navigation pane, select the Virtual Machine whose disk(s) you plan to add a quota.
2.  In the details pane, select the disk you plan to associate with a quota.
3.  Click **Edit**. The **Edit Virtual Disk** window appears.
4.  Select the quota you want the virtual disk to consume.
5.  Click **OK**.

**Result**

You have designated a quota for the virtual disk you selected.

<div class="alert alert-info">
**Important:** Quota must be selected for all objects associated with a virtual machine, in order for that virtual machine to work. If you fail to select a quota for the objects associated with a virtual machine, the virtual machine will not work. The error that oVirt throws in this situation is generic, which makes it difficult to know if the error was thrown because you did not associate a quota with all of the objects associated with the virtual machine. It is not possible to take snapshots of virtual machines that do not have an assigned quota. It is not possible to create templates of virtual machines whose virtual disks do not have assigned quotas.

</div>

### Using Quota to Limit Resources by User

**Summary**

This procedure describes how to use quotas to limit the resources a user has access to.

**Procedure 14.5. Assigning a User to a Quota**

1.  In the tree, click the Data Center with the quota you want to associate with a User.
2.  Click the **Quota** tab in the navigation pane.
3.  Select the target quota in the list in the navigation pane.
4.  Click the **Consumers** tab in the details pane.
5.  Click **Add** at the top of the details pane.
6.  In the **Search** field, type the name of the user you want to associate with the quota.
7.  Click **GO**.
8.  Select the check box at the left side of the row containing the name of the target user.
9.  Click **OK** in the bottom right of the **Assign Users and Groups to Quota** window.

**Result**

After a short time, the user will appear in the **Consumers** tab of the details pane.

### Editing Quotas

**Summary**

This procedure describes how to change existing quotas.

**Procedure 14.6. Editing Quotas**

1.  On the tree pane, click on the data center whose quota you want to edit.
2.  Click on the **Quota** tab in the Navigation Pane.
3.  Click the name of the quota you want to edit.
4.  Click **Edit** in the Navigation pane.
5.  An **Edit Quota** window opens. If required, enter a meaningful name in the **Name** field.
6.  If required, you can enter a meaningful description in the **Description** field.
7.  Select either the **All Clusters** radio button or the **Specific Clusters** radio button. Move the **Cluster Threshold** and **Cluster Grace** sliders to the desired positions on the **Memory & CPU** slider.
8.  Select either the **All Storage Domains** radio button or the **Specific Storage Domains** radio button. Move the **Storage Threshold** and **Storage Grace** sliders to the desired positions on the **Storage** slider.
9.  Click **OK** in the **Edit Quota** window to confirm the new quota settings.

**Result**

You have changed an existing quota.

### ⁠Removing Quotas

**Summary**

This procedure describes how to remove quotas.

**Procedure 14.7. Removing Quotas**

1.  On the tree pane, click on the data center whose quota you want to edit.
2.  Click on the **Quota** tab in the Navigation Pane.
3.  Click the name of the quota you want to remove.
4.  Click **Remove** at the top of the Navigation pane, under the row of tabs.
5.  Click **OK** in the **Remove Quota(s)** window to confirm the removal of this quota.

**Result**

You have removed a quota.

### ⁠Service-level Agreement Policy Enforcement

oVirt 3.3 supports service-level agreement CPU features. These features can be accessed through the Administrator Portal.

**Summary**

This procedure describes how to set service-level agreement CPU features.

1.  Select **New VM** in the Navigation Pane.
2.  Select **Show Advanced Options**.
3.  Select the **Resource Allocation** tab.
4.  Specify **CPU Shares**. Possible options are **Low**, **Medium**, **High**, **Custom**, and **Disabled**. Virtual machines set to **High** receive twice as many shares as **Medium**, and virtual machines set to **Medium** receive twice as many shares as virtual machines set to **Low**. **Disabled** instructs VDSM to use an older algorithm for determining share dispensation; usually the number of shares dispensed under these conditions is 1020.

**Result**

You have set a service-level agreement CPU policy. Users' CPU consumption is now governed by the policy you have set.

![Description](SLA.png "Description")

**Figure 14.1. Service-level Agreement Policy Enforcement - CPU Allocation Menu**

## ⁠Event Notifications

### Configuring Event Notifications

**Summary**

oVirt can notify designated users when specific events occur in the environment that oVirt manages. To use this functionality, you must set up a mail transfer agent to deliver messages.

**Procedure 15.1. Configuring Event Notifications**

1.  Ensure you have set up the mail transfer agent with the appropriate variables.
2.  Use the **Users** resource tab, tree mode, or the search function to find and select the user to which event notifications will be sent.
3.  Click the **Event Notifier** tab in the details pane to list the events for which the user will be notified. This list will be blank if you have not configured any event notifications for that user.
4.  Click **Manage Events** to open the **Add Event Notification** window.
    ![The Add Events Notification Window](Add Event Notification.png "fig:The Add Events Notification Window")
    **Figure 15.1. The Add Events Notification Window**
5.  Use the **Expand All** button or the subject-specific expansion buttons to view the events.
6.  Select the appropriate check boxes.
7.  Enter an email address in the **Mail Recipient** field.
8.  Click **OK** to save changes and close the window.
9.  Add and start the **ovirt-engine-notifier** service on oVirt. This activates the changes you have made:
        # chkconfig --add ovirt-engine-notifier
        # chkconfig ovirt-engine-notifier on
        # service ovirt-engine-notifier restart

**Result**

The specified user now receives emails based on events in the oVirt environment. The selected events display on the **Event Notifier** tab for that user.

### Parameters for Event Notifications in ovirt-engine-notifier.conf

The event notifier configuration file can be found in `/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf`

**Table 15.1. ovirt-engine-notifier.conf variables**

<table>
<colgroup>
<col width="40%" />
<col width="20%" />
<col width="40%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Variable Name</p></th>
<th align="left"><p>Default</p></th>
<th align="left"><p>Remarks</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>SENSITIVE_KEYS</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>A comma-separated list of keys that will not be logged.</p></td>
</tr>
<tr class="even">
<td align="left"><p>JBOSS_HOME</p></td>
<td align="left"><p>/usr/share/jbossas</p></td>
<td align="left"><p>The location of the JBoss application server used by oVirt.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ENGINE_ETC</p></td>
<td align="left"><p>/etc/ovirt-engine</p></td>
<td align="left"><p>The location of the <code>etc</code> directory used by oVirt.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ENGINE_LOG</p></td>
<td align="left"><p>/var/log/ovirt-engine</p></td>
<td align="left"><p>The location of the <code>logs</code> directory used by oVirt.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ENGINE_USR</p></td>
<td align="left"><p>/usr/share/ovirt-engine</p></td>
<td align="left"><p>The location of the <code>usr</code> directory used by oVirt.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ENGINE_JAVA_MODULEPATH</p></td>
<td align="left"><p>${ENGINE_USR}/modules</p></td>
<td align="left"><p>The file path to which the JBoss modules are appended.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>NOTIFIER_DEBUG_ADDRESS</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>The address of a machine that can be used to perform remote debugging of the Java virtual machine that the notifier uses.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NOTIFIER_STOP_TIME</p></td>
<td align="left"></td>
<td align="left"><p>The time, in seconds, after which the service will time out.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>NOTIFIER_STOP_INTERVAL</p></td>
<td align="left"></td>
<td align="left"><p>The time, in seconds, by which the timeout counter will be incremented.</p></td>
</tr>
<tr class="even">
<td align="left"><p>INTERVAL_IN_SECONDS</p></td>
<td align="left"></td>
<td align="left"><p>The interval in seconds between instances of dispatching messages to subscribers.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>IDLE_INTERVAL</p></td>
<td align="left"></td>
<td align="left"><p>The interval, in seconds, between which low-priority tasks will be performed.</p></td>
</tr>
<tr class="even">
<td align="left"><p>DAYS_TO_KEEP_HISTORY</p></td>
<td align="left"></td>
<td align="left"><p>This variable sets the number of days dispatched events will be preserved in the history table. If this variable is not set, events remain on the history table indefinitely.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>FAILED_QUERIES_NOTIFICATION_THRESHOLD</p></td>
<td align="left"></td>
<td align="left"><p>The number of failed queries after which a notification email is sent. A notification email is sent after the first failure to fetch notifications, and then once every time the number of failures specified by this variable is reached. If you specify a value of <code>0</code> or <code>1</code>, an email will be sent with each failure.</p></td>
</tr>
<tr class="even">
<td align="left"><p>FAILED_QUERIES_NOTIFICATION_RECIPIENTS</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>The email addresses of the recipients to which notification emails will be sent. Email addresses must be separated by a comma. This entry has been deprecated by the <code>FILTER</code> variable.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DAYS_TO_SEND_ON_STARTUP</p></td>
<td align="left"></td>
<td align="left"><p>The number of days of old events that will be processed and sent when the notifier starts.</p></td>
</tr>
<tr class="even">
<td align="left"><p>FILTER</p></td>
<td align="left"><p>exclude:*</p></td>
<td align="left"><p>The algorithm used to determine the triggers for and recipients of email notifications. The value for this variable comprises a combination of <code>include</code> or <code>exclude</code>, the event, and the recipient. For example, <code>include:VDC_START(smtp:mail@example.com) ${FILTER}</code></p></td>
</tr>
<tr class="odd">
<td align="left"><p>MAIL_SERVER</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>The SMTP mail server address. Required.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MAIL_PORT</p></td>
<td align="left"></td>
<td align="left"><p>The port used for communication. Possible values include <code>25</code> for plain SMTP, <code>465</code> for SMTP with SSL, and <code>587</code> for SMTP with TLS.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MAIL_USER</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>If SSL is enabled to authenticate the user, then this variable must be set. This variable is also used to specify the "from" user address when the MAIL_FROM variable is not set. Some mail servers do not support this functionality. The address is in RFC822 format.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SENSITIVE_KEYS</p></td>
<td align="left"><p>${SENSITIVE_KEYS},MAIL_PASSWORD</p></td>
<td align="left"><p>Required to authenticate the user if the mail server requires authentication or if SSL or TLS is enabled.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MAIL_PASSWORD</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>Required to authenticate the user if the mail server requires authentication or if SSL or TLS is enabled.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MAIL_SMTP_ENCRYPTION</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>The type of encryption to be used in communication. Possible values are <code>none</code>, <code>ssl</code>, <code>tls</code>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>HTML_MESSAGE_FORMAT</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>The mail server sends messages in HTML format if this variable is set to <code>true</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MAIL_FROM</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>This variable specifies a sender address in RFC822 format, if supported by the mail server.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MAIL_REPLY_TO</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>This variable specifies reply-to addresses in RFC822 format on sent mail, if supported by the mail server.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MAIL_SEND_INTERVAL</p></td>
<td align="left"></td>
<td align="left"><p>The number of SMTP messages to be sent for each IDLE_INTERVAL</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MAIL_RETRIES</p></td>
<td align="left"></td>
<td align="left"><p>The number of times to attempt to send an email before failing.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SNMP_MANAGER</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>The IP addresses or fully qualified domain names of machines that will act as the SNMP managers. Entries must be separated by a space and can contain a port number. For example, <code>manager1.example.com manager2.example.com:164</code></p></td>
</tr>
<tr class="odd">
<td align="left"><p>SNMP_COMMUNITY</p></td>
<td align="left"><p>public</p></td>
<td align="left"><p>The default SNMP community.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SNMP_OID</p></td>
<td align="left"></td>
<td align="left"><p>The default TRAP object identifiers for alerts.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ENGINE_INTERVAL_IN_SECONDS</p></td>
<td align="left"></td>
<td align="left"><p>The interval, in seconds, between monitoring the machine on which oVirt is installed. The interval is measured from the time the monitoring is complete.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ENGINE_MONITOR_RETRIES</p></td>
<td align="left"></td>
<td align="left"><p>The number of times the notifier attempts to monitor the status of the machine on which oVirt is installed in a given interval after a failure.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ENGINE_TIMEOUT_IN_SECONDS</p></td>
<td align="left"></td>
<td align="left"><p>The time, in seconds, to wait before the notifier attempts to monitor the status of the machine on which oVirt is installed in a given interval after a failure.</p></td>
</tr>
<tr class="even">
<td align="left"><p>IS_HTTPS_PROTOCOL</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>This entry must be set to <code>true</code> if JBoss is being run in secured mode.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SSL_PROTOCOL</p></td>
<td align="left"><p>TLS</p></td>
<td align="left"><p>The protocol used by JBoss configuration connector when SSL is enabled.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SSL_IGNORE_CERTIFICATE_ERRORS</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>This value must be set to <code>true</code> if JBoss is running in secure mode and SSL errors is to be ignored.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SSL_IGNORE_HOST_VERIFICATION</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>This value must be set to <code>true</code> if JBoss is running in secure mode and host name verification is to be ignored.</p></td>
</tr>
<tr class="even">
<td align="left"><p>REPEAT_NON_RESPONSIVE_NOTIFICATION</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>This variable specifies whether repeated failure messages will be sent to subscribers if the machine on which oVirt is installed is non-responsive.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ENGINE_PID</p></td>
<td align="left"><p>/var/lib/ovirt-engine/ovirt-engine.pid</p></td>
<td align="left"><p>The path and file name of the PID of oVirt.</p></td>
</tr>
</tbody>
</table>

### Canceling Event Notifications

**Summary**

A user has configured some unnecessary event notifications and wants them canceled.

**Procedure 15.2. Canceling Event Notifications**

1.  In the **Users** tab, select the user or the user group.
2.  Select the **Event Notifier** tab in the details pane to list events for which the user receives notifications.
3.  Click **Manage Events** to open the **Add Event Notification** window.
4.  Use the **Expand All** button, or the subject-specific expansion buttons, to view the events.
5.  Clear the appropriate check boxes to remove notification for that event.
6.  Click **OK** to save changes and close the window.

**Result**

You have canceled unnecessary event notifications for the user.

## ⁠Utilities

### The Ovirt Engine Rename Tool

#### The Ovirt Engine Rename Tool

When the `engine-setup` command is run in a clean environment, the command generates a number of certificates and keys that use the fully qualified domain name of oVirt supplied during the setup process. If the fully qualified domain name of oVirt must be changed later on (for example, due to migration of the machine hosting oVirt to a different domain), the records of the fully qualified domain name must be updated to reflect the new name. The `ovirt-engine-rename` command automates this task.

The `ovirt-engine-rename` command updates records of the fully qualified domain name of oVirt in the following locations:

*   /etc/ovirt-engine/engine.conf.d/10-setup-protocols.conf
*   /etc/ovirt-engine/imageuploader.conf.d/10-engine-setup.conf
*   /etc/ovirt-engine/isouploader.conf.d/10-engine-setup.conf
*   /etc/ovirt-engine/logcollector.conf.d/10-engine-setup.conf
*   /etc/pki/ovirt-engine/cert.conf
*   /etc/pki/ovirt-engine/cert.template
*   /etc/pki/ovirt-engine/certs/apache.cer
*   /etc/pki/ovirt-engine/keys/apache.key.nopass
*   /etc/pki/ovirt-engine/keys/apache.p12

<div class="alert alert-info">
**Warning:** While the `ovirt-engine-rename` command creates a new certificate for the web server on which oVirt runs, it does not affect the certificate for the engine or the certificate authority. Due to this, there is some risk involved in using the `ovirt-engine-rename` command, particularly in environments that have been upgraded from oVirt version 3.2 and earlier. Therefore, changing the fully qualified domain name of oVirt by running `engine-cleanup` and `engine-setup` is recommended where possible.

</div>

#### Syntax for the Ovirt Engine Rename Command

The basic syntax for the `ovirt-engine-rename` command is:

    # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

The command also accepts the following options:

*`--newname=[new name]`*  
Allows you to specify the new fully qualified domain name for oVirt without user interaction.

*`--log=[file]`*  
Allows you to specify the path and name of a file into which logs of the rename operation are to be written.

*`--config=[file]`*  
Allows you to specify the path and file name of a configuration file to load into the rename operation.

*`--config-append=[file]`*  
Allows you to specify the path and file name of a configuration file to append to the rename operation. This option can be used to specify the path and file name of an answer file.

*`--generate-answer=[file]`*  
Allows you to specify the path and file name of a file into which your answers to and the values changed by the `ovirt-engine-rename` command are recorded.

#### Using the Ovirt Engine Rename Tool

**Summary**

You can use the `ovirt-engine-rename` command to update records of the fully qualified domain name of oVirt.

**Procedure 16.1. Renaming oVirt**

1.  Prepare all DNS and other relevant records for the new fully qualified domain name.
2.  Update the DHCP server configuration if DHCP is used.
3.  Update the host name on oVirt.
4.  Run the following command:
        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

5.  When prompted, press **Enter** to stop the engine service:
        During execution engine service will be stopped (OK, Cancel) [OK]:

6.  When prompted, enter the new fully qualified domain name for oVirt:
        New fully qualified server name:[new name]

**Result**

The `ovirt-engine-rename` command updates records of the fully qualified domain name of oVirt.

### The Domain Management Tool

#### The Domain Management Tool

oVirt authenticates users using directory services. To add users to oVirt you must first use the internal `admin` user to add the directory service that the users must be authenticated against. You add and remove directory services domains using the included domain management tool, `engine-manage-domains`.

The `engine-manage-domains` command is only accessible on the machine on which oVirt is installed. The `engine-manage-domains` command must be run as the `root` user.

#### Syntax for the Domain Management Tool

The usage syntax is:

    engine-manage-domains -action=ACTION [options]

Available actions are:

*`add`*  
Add a domain to oVirt's directory services configuration.

*`edit`*  
Edit a domain in oVirt's directory services configuration.

*`delete`*  
Delete a domain from oVirt's directory services configuration.

*`validate`*  
Validate oVirt's directory services configuration. This command attempts to authenticate each domain in the configuration using the configured user name and password.

*`list`*  
List oVirt's current directory services configuration.

These options can be combined with the actions on the command line:

*`--add-permissions`*  
Specifies that the domain user will be given the **SuperUser** role in oVirt. By default, if the *`--add-permissions`* parameter is not specified, the **SuperUser** role is not assigned to the domain user. The *`--add-permissions`* option is optional. It is only valid when used in combination with the *`add`* and *`edit`* actions.

*`--change-password-msg=[MSG]`*  
Specifies the message that is returned to the user at login when their password has expired. This allows you to direct users to a specific URL (must begin with http or https) where their password can be changed. The *`--change-password-msg`* option is optional, and is only valid when used in combination with the *`add`* and *`edit`* actions.

*`--config-file=[FILE]`*  
Specifies an alternate configuration file that the command must use. The *`--config-file`* parameter is always optional.

*`--domain=[DOMAIN]`*  
The domain on which the action will be performed. The *`--domain`* parameter is mandatory for the *`add`*, *`edit`*, and *`delete`* actions.

*`--force`*  
Forces the command to skip confirmation of delete operations.

*`--ldap-servers=[servers]`*  
A comma delimited list of LDAP servers to be set to the domain.

*`--provider=`*[PROVIDER]  
The LDAP provider type of the directory server for the domain. Valid values are:

*   *`ad`* - Microsoft Active Directory.
*   *`ipa`* - Identity Management (IdM).
*   *`rhds`* - Red Hat Directory Server. Red Hat Directory Server does not come with Kerberos. oVirt requires Kerberos authentication. Red Hat Directory Server must be running as a service inside a Kerberos domain to provide directory services to oVirt.
    <div class="alert alert-info">
    **Note:** To use Red Hat Directory Server as your directory server, you must have the `memberof` plug-in installed in Red Hat Directory Server. To use the `memberof` plug-in, your users must be `inetuser`.

    </div>
*   `itds` - IBM Tivoli Directory Server.
*   `oldap` - OpenLDAP.

*`--report`*  
When used in conjunction with the *`validate`* action, this command outputs a report of all validation errors encountered.

*`--user=[USER]`*  
Specifies the domain user to use. The *`--user`* parameter is mandatory for *`add`*, and optional for *`edit`*.

*`--password-file=[FILE]`*  
Specifies that the domain user's password is on the first line of the provided file. This option, or the *`--interactive`* option, must be used to provide the password for use with the *`add`* action.

For further details on usage, see the `engine-manage-domains` command's help output:

    # engine-manage-domains --help

### The Configuration Tool

#### The Configuration Tool

Installing oVirt modifies only a subset of configuration settings from their defaults. Further modifications are made using the configuration tool: `engine-config`.

The configuration tool does not require Red Hat JBoss Enterprise Application Platform or oVirt to be running to update the configuration. Configuration key values are stored in the database; configuration changes will not be saved unless the database is operational. Changes are applied when Red Hat JBoss Enterprise Application Platform is restarted.

oVirt stores configuration settings as a series of key-to-value pair mappings. The configuration tool allows you to:

*   List all available configuration keys.
*   List all available configuration values.
*   Retrieve the value of a specific configuration key.
*   Set the value of a specific configuration key.

You are also able to maintain multiple versions of oVirt's configuration with the configuration tool. Use the *`--cver`* parameter to specify the configuration version to be used when retrieving or setting a value for a configuration key. The default configuration version is `general`.

#### Syntax for engine-config Command

The configuration tool is accessible on the client machine on which oVirt is installed. For full usage information consult the help output of the `engine-config` command:

    # engine-config --help

**Common tasks**

List available configuration keys  
Use the *`--list`* parameter to list available configuration keys.

<!-- -->

    # engine-config --list

Each available configuration key is listed by name and description.

List available configuration values  
Use the *`--all`* parameter to list available configuration values.

<!-- -->

    # engine-config --all

Each available configuration key is listed by name, current value of the key, and the configuration version.

Retrieve value of configuration key  
Use the *`--get`* parameter to retrieve the value of a specific key.

<!-- -->

    # engine-config --get KEY_NAME

Replace *KEY_NAME* with the name of the specific key to retrieve the key name, value, and the configuration version. Use the *`--cver`* parameter to specify the configuration version of the value to be retrieved.

Set value of configuration key  
Use the *`--set`* parameter to set the value of a specific key. You must also set the configuration version to which the change is to apply using the *`--cver`* parameter.

<!-- -->

    # engine-config --set KEY_NAME=KEY_VALUE --cver=VERSION

Replace *KEY_NAME* with the name of the specific key to set; replace *KEY_VALUE* with the value to be set. Environments with more than one configuration version require the *VERSION* to be specified.

#### The admin@internal User

The `admin@internal` user account is automatically created upon installation of oVirt. This account is stored locally in oVirt's PostgreSQL database, separate from external directory services such as IdM or Active Directory. Unlike external directory domains, users cannot be added or deleted from the `internal` domain. The `admin@internal` user is the SuperUser of oVirt and has administrative privileges over the environment via the Administration Portal.

The password for the `admin@internal` user is set during the installation of oVirt. Use the **engine-config** utility if you need to reset the password.

#### Changing the Password for admin@internal

1.  Log in to oVirt server as the `root` user.
2.  -   For oVirt 3.6 or newer (for more info see [this](Features/AAA_JDBC#Password_management) link):
            # ovirt-aaa-jdbc-tool user password-reset admin

    -   For oVirt 3.5 or later:
        Use the `engine-config` utility to set a new password for the `admin@internal` user.
            # engine-config -s AdminPassword=interactive

        Use escape characters if your password includes any special characters.

3.  Restart the ovirt-engine service for the changes to take effect.

<!-- -->

    # service ovirt-engine restart


#### oVirt Configuration Options

**Table 16.1. oVirt Configuration Options**

<table>
<colgroup>
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Name</p></th>
<th align="left"><p>Description</p></th>
<th align="left"><p>Type</p></th>
<th align="left"><p>Default Value</p></th>
<th align="left"><p>Comments</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>AbortMigrationOnError</p></td>
<td align="left"><p>Abort ongoing migration on error</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>v3.0: false v3.1: false v3.2: false v3.3: false</p></td>
<td align="left"><p>Specify whether it is possible to optionally abort ongoing migration when an error occurs.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AsyncTaskPollingRate</p></td>
<td align="left"><p>Async Task Polling Rate (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>How often (in seconds) oVirt queries the status of an asynchronous task in progress.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>AsyncTaskZombieTaskLifeInMinutes</p></td>
<td align="left"><p>Zombie tasks lifetime in minutes</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>How long (in minutes) a task is allowed to run before assuming it has become a zombie and should be killed. The value affects large storage manipulations especially. When using slow storage and large virtual images, or when a task is known to take longer than 3000 minutes (50 hours), the value should be increased.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AttestationPort</p></td>
<td align="left"><p>Definition of service port for attestation service</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Which port is your attestation server listening for connections on?</p></td>
</tr>
<tr class="odd">
<td align="left"><p>AttestationServer</p></td>
<td align="left"><p>Definition of FQDN of attestation server</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Fully qualified domain name or IP address of your attestation server.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AttestationTruststore</p></td>
<td align="left"><p>Trust store used for securing communication with attestation service</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>TrustStore.jks</p></td>
<td align="left"><p>Copy the TrustStore.jks keystore file from <code>/var/lib/oat-appraiser/Certificate/</code> on your attestation server to <code>/usr/share</code> on your engine server.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>AttestationTruststorePass</p></td>
<td align="left"><p>The password used to access trust store</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>password</p></td>
<td align="left"><p>The default password is password.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AttestationFirstStageSize</p></td>
<td align="left"><p>Attestation size for first stage</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Used for quick initialization. Do not change unless you know why.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>AuditLogAgingThreshold</p></td>
<td align="left"><p>Audit Log Aging Threshold (in days)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>How long an audit log is kept before being rotated.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AuditLogCleanupTime</p></td>
<td align="left"><p>Time to check for Audit Log cleanup</p></td>
<td align="left"><p>Time</p></td>
<td align="left"><p>At what time the Audit Log is checked for Aging and cleaned up.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>AuthenticationMethod</p></td>
<td align="left"><p>The authentication method used by oVirt</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>LDAP</p></td>
<td align="left"><p>The API used for querying users. Currently LDAP is the only supported value.</p></td>
</tr>
<tr class="even">
<td align="left"><p>BlockMigrationOnSwapUsagePercentage</p></td>
<td align="left"><p>Host swap percentage threshold (for scheduling)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum percentage of swap space on the host that a VM run or migration is allowed to consume on the host. If the host is swapping beyond this percentage, a VM will not migrate over and will not be started.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>BootstrapMinimalVdsmVersion</p></td>
<td align="left"><p>Minimum VDSM version</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>The minimum version of VDSM that is acceptable when adding hosts to the Engine. Newer versions have more features.</p></td>
</tr>
<tr class="even">
<td align="left"><p>CABaseDirectory</p></td>
<td align="left"><p>CA Base Directory</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>/etc/pki/ovirt-engine</p></td>
<td align="left"><p>Where oVirt Certificate Authority is located on oVirt host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>CertificateFileName</p></td>
<td align="left"><p>Certificate File Name</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>/etc/pki/ovirt-engine/certs/engine.cer</p></td>
<td align="left"><p>Points to the certificate file used by oVirt for SSL/TLS communication with VDSM.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ClientModeSpiceDefault</p></td>
<td align="left"><p>The default SPICE console protocol mode</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Auto</p></td>
<td align="left"><p>The default mode to use when connecting to a virtual machine using the SPICE console protocol.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ClientModeVncDefault</p></td>
<td align="left"><p>The default VNC console protocol mode</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Native</p></td>
<td align="left"><p>The default mode to use when connecting to a virtual machine using the VNC console protocol.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ClientModeRdpDefault</p></td>
<td align="left"><p>The default RDP console protocol mode</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Auto</p></td>
<td align="left"><p>The default mode to use when connecting to a virtual machine using the RDP console protocol.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ClusterEmulatedMachines</p></td>
<td align="left"><p>Supported machine types</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>v3.0: rhel6.2.0 v3.1: rhel6.3.0 v3.2: rhel6.4.0 v3.3: rhel6.5.0 v3.4: rhel6.5.0</p></td>
<td align="left"><p>The machine types supported by clusters.</p></td>
</tr>
<tr class="even">
<td align="left"><p>CpuOverCommitDurationMinutes</p></td>
<td align="left"><p>The duration in minutes of CPU consumption to activate selection algorithm</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When the cluster policy is set to Even Distribution, wait for this amount of minutes after detecting CPU overcommit before triggering virtual machine migrations to rebalance the host load. This configuration value applies only for the default.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>CustomDeviceProperties</p></td>
<td align="left"><p>Custom device properties</p></td>
<td align="left"><p>DeviceCustomProperties</p></td>
<td align="left"><p>v3.4 only: {type=interface;prop={SecurityGroups=^(?:(?:[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}, *)*[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}|)$}}</p></td>
<td align="left"><p>Definition of custom properties for each device type.</p></td>
</tr>
<tr class="even">
<td align="left"><p>DefaultWindowsTimeZone</p></td>
<td align="left"><p>The default time zone for Windows virtual machines</p></td>
<td align="left"><p>WindowsTimeZone</p></td>
<td align="left"><p>GMT Standard Time</p></td>
<td align="left"><p>The default time zone used when creating new Windows virtual machines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DefaultGeneralTimeZone</p></td>
<td align="left"><p>The default time zone for virtual machines other than Windows virtual machines</p></td>
<td align="left"><p>GeneralTimeZone</p></td>
<td align="left"><p>Etc/GMT</p></td>
<td align="left"><p>The default time zone used when creating virtual machines other than Windows virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p>DelayResetForSpmInSeconds</p></td>
<td align="left"><p>Delay before Storage Pool Manager reset</p></td>
<td align="left"><p>Double</p></td>
<td align="left"></td>
<td align="left"><p>The additional delay, in seconds, before reset due to a communication issue when the host is the Storage Pool Manager.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DelayResetPerVmInSeconds</p></td>
<td align="left"><p>Delay before virtual machine reset</p></td>
<td align="left"><p>Double</p></td>
<td align="left"></td>
<td align="left"><p>The additional delay, in seconds, before reset due to a communication issue for each virtual machine running on a host.</p></td>
</tr>
<tr class="even">
<td align="left"><p>DisableFenceAtStartupInSec</p></td>
<td align="left"><p>Disable Fence Operations at oVirt Startup in seconds</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Allow this amount of seconds after oVirt starts to detect hosts, before assuming the hosts are unresponsive and proceed to fence hosts. This value should be increased when oVirt is on a machine that has slow network startup (a VMware guest, for example).</p></td>
</tr>
<tr class="odd">
<td align="left"><p>DwhHeartBeatInterval</p></td>
<td align="left"><p>The interval, in seconds at which the data warehouse is informed that the engine is running</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>WANDisableEffects</p></td>
<td align="left"><p>Disabled WAN Effects value to send to the SPICE console</p></td>
<td align="left"><p>StringMultiple</p></td>
<td align="left"><p>animation</p></td>
<td align="left"><p>The list of effects which will be disabled for SPICE. Possible values: <code>animation</code>, <code>wallpaper</code>, <code>font-smooth</code>, and <code>all</code>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>WANColorDepth</p></td>
<td align="left"><p>WAN Color Depth value to send to the SPICE console</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"><p>The color depth used by the SPICE. Possible values are <code>16</code> and <code>32</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>EnableMACAntiSpoofingFilterRules</p></td>
<td align="left"><p>Enable anti-spoofing filter rules for MAC addresses</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>Specifies whether network filtering is enabled.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>EnableSpiceRootCertificateValidation</p></td>
<td align="left"><p>Enable Spice Root Certification Validation</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>If <code>true</code>, the certificate of the host on which the virtual machine is running and oVirt setup CA certificate are sent to the SPICE client when attempting to connect to the virtual machine with SPICE, as an extra security mechanism.</p></td>
</tr>
<tr class="even">
<td align="left"><p>EnableUSBAsDefault</p></td>
<td align="left"><p>Enable USB devices attachment to the virtual machine by default</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>EnableVdsLoadBalancing</p></td>
<td align="left"><p>Enables Host Load Balancing system</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>This config value allows the user to turn on or off (true and false, respectively) the virtual machine load balancing according to the policy configured for the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p>EncryptHostCommunication</p></td>
<td align="left"><p>Encryption of host communication</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>Specify whether communication between hosts and oVirt will be encrypted.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ExternalSchedulerServiceURL</p></td>
<td align="left"><p>The location of an external scheduler</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p><a href="http://localhost:18781" class="uri">http://localhost:18781</a></p></td>
<td align="left"><p>The location of an external scheduler.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ExternalSchedulerConnectionTimeout</p></td>
<td align="left"><p>The time for which a connection to an external scheduler will be attempted before timing out</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>This value can be set to <code>0</code> to disable this feature.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ExternalSchedulerEnabled</p></td>
<td align="left"><p>Specifies whether the virtual machine scheduler will consider the external filters and load balancers</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>false</p></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>ExternalSchedulerResponseTimeout</p></td>
<td align="left"><p>The time for which a response from an external scheduler will be waited on before timing out</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>FreeSpaceCriticalLowInGB</p></td>
<td align="left"><p>Critical low disk space alert threshold (in GB)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Produces an alert when a Storage Domain has this amount of space left. This setting is also used in various preliminary tests for action sanity when users try to use storage domains, to prevent reaching this critical amount. Adding and importing disks will fail if the amount of space is less than the value specified here.</p></td>
</tr>
<tr class="even">
<td align="left"><p>FreeSpaceLow</p></td>
<td align="left"><p>Limit of percentage of free disk space below which it is considered low</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When a storage domain has this percentage of space left, it is considered low on disk space.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>GlusterRefreshRateHooks</p></td>
<td align="left"><p>The refresh rate for Gluster hooks</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The refresh rate, in seconds, for Gluster hooks from Gluster servers.</p></td>
</tr>
<tr class="even">
<td align="left"><p>HighUtilizationForEvenlyDistribute</p></td>
<td align="left"><p>High Utilization Limit For Evenly Distribute selection algorithm</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum number of virtual machines per host in the Evenly Distribute algorithm.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>HighUtilizationForPowerSave</p></td>
<td align="left"><p>High Utilization Limit For Power Save selection algorithm</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>A default for newly created clusters, in use with PowerSave load balancing algorithm, marks the higher limit of host utilization for populating hosts.</p></td>
</tr>
<tr class="even">
<td align="left"><p>HostPreparingForMaintenanceIdleTime</p></td>
<td align="left"><p>The time to wait, in seconds, to determine if a host is idling in status <code>PreparingForMaintenance</code></p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When the interval is met, another attempt is made to move the host into maintenance.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>KeystoneAuthUrl</p></td>
<td align="left"><p>The location of a Keystone server</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>The location of an OpenStack Keystone server for authenticating OpenStack providers.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LDAPQueryTimeout</p></td>
<td align="left"><p>Read Timeout in seconds for LDAP queries</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of time an LDAP query will read before the query is stopped.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LDAPOperationTimeout</p></td>
<td align="left"><p>Search timeout at LDAP server side</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of time an LDAP search will operate before it is stopped.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LDAPConnectTimeout</p></td>
<td align="left"><p>Connect timeout in seconds for LDAP queries</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of time an LDAP query will connect before it is stopped.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LocalAdminPassword</p></td>
<td align="left"><p>Local Administrator Password</p></td>
<td align="left"><p>Password</p></td>
<td align="left"><p>Populated during initial setup</p></td>
<td align="left"><p>The password for <code>admin@local</code> default user.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LogMaxPhysicalMemoryUsedThresholdInPercentage</p></td>
<td align="left"><p>Memory usage threshold for triggering a log event</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum threshold of physical memory usage on a host, in percentage, that will trigger an audit log event.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LogMaxCpuUsedThresholdInPercentage</p></td>
<td align="left"><p>CPU usage threshold for triggering a log event</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum threshold of CPU usage on a host, in percentage, that will trigger an audit log event.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LogMaxNetworkUsedThresholdInPercentage</p></td>
<td align="left"><p>Network usage threshold for triggering a log event</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum threshold of network usage on a host, in percentage, that will trigger an audit log event.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LogMinFreeSwapThresholdInMB</p></td>
<td align="left"><p>Free swap threshold for triggering a log event</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The minimum threshold of free swap memory on a host, in MB, that will trigger an audit log event.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LogMaxSwapUsedThresholdInPercentage</p></td>
<td align="left"><p>Swap usage threshold for triggering a log event</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum threshold for swap memory usage on a host, in percentage, that will trigger an audit log event.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LogPhysicalMemoryThresholdInMB</p></td>
<td align="left"><p>Threshold for logging low host memory in MB</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The minimum amount of RAM left before a host is considered low on memory. If a host's RAM is lower than this setting, it is recorded on the audit log and no action is taken.</p></td>
</tr>
<tr class="even">
<td align="left"><p>LowUtilizationForEvenlyDistribute</p></td>
<td align="left"><p>Low Utilization Limit for Evenly Distribute selection algorithm</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Minimum number of virtual machines per host in the Evenly Distribute algorithm.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>LowUtilizationForPowerSave</p></td>
<td align="left"><p>Low Utilization Limit for Power Save selection algorithm</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>A default for newly created clusters, in use with PowerSave load balancing algorithm, marks the lower limit of host utilization for populating hosts.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MacPoolRanges</p></td>
<td align="left"><p>MAC Addresses Pool Ranges</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>The MAC address pool range to be automatically assigned to virtual machines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxAverageNetworkQoSValue</p></td>
<td align="left"><p>Maximum value for Average Networks Quality of Service (Mbps)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>MaxPeakNetworkQoSValue</p></td>
<td align="left"><p>Maximum value for Peak Networks Quality of Service (Mbps)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxBurstNetworkQoSValue</p></td>
<td align="left"><p>Maximum value for Burst Networks Quality of Service (Mb)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>MaxMacsCountInPool</p></td>
<td align="left"><p>Maximum MAC Addresses count in Pool</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum number of MAC addresses allowed in the MAC pool.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxNumberOfHostsInStoragePool</p></td>
<td align="left"><p>Maximum number of hosts in Storage Pool</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Limits the maximum number of hosts assigned to the clusters of a single Data Center. This can be increased after testing more hosts, if necessary.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxNumOfCpuPerSocket</p></td>
<td align="left"><p>Maximum Number of CPU per socket</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum number of virtual CPU cores that can be assigned to a single virtual CPU socket.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxNumOfVmCpus</p></td>
<td align="left"><p>Total Numbers of Virtual Machine CPUs</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"><p>3.1: 160 3.2: 160 3.3: 160 3.4: 160</p></td>
<td align="left"><p>The maximum total amount of CPU cores assigned to a virtual machine (determined by number of cores multiplied by number of sockets).</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxNumofVmSockets</p></td>
<td align="left"><p>Maximum number of sockets per virtual machine</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum number of virtual CPU sockets assigned to a virtual machine.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxRerunVmOnVdsCount</p></td>
<td align="left"><p>Maximum virtual machine rerun attempts on a host</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum number of attempts to start a virtual machine on a host before an error ("unable to start VM") is reported.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxSchedulerWeight</p></td>
<td align="left"><p>Maximum schedule weighting</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum weight score for a single scheduler weight module.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxStorageVdsDelayCheckSec</p></td>
<td align="left"><p>Max delay for check of domain in seconds</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum amount of seconds to wait for storage domain status to be returned before reporting an error.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxStorageVdsTimeoutCheckSec</p></td>
<td align="left"><p>Maximum timeout for last check of domain in seconds</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When monitoring storage, vdsmd on the hosts reports a "lastCheck" value for each domain. This setting is used to decide whether the last check happened too long ago and domain is considered in error.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxVdsMemOverCommit</p></td>
<td align="left"><p>Max Host Memory Over-Commit (%) for virtual desktops load</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The percentage of memory overcommit permitted to occur when using virtual desktop loads.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxVdsMemOverCommitForServers</p></td>
<td align="left"><p>Maximum Host Memory Over-Commit (%) for Virtual Servers load</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The percentage of memory overcommit permitted to occur when using virtual server loads.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxVdsNameLength</p></td>
<td align="left"><p>Max VDS name length</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum name length for a Hypervisor host.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxVmNameLengthNonWindows</p></td>
<td align="left"><p>Maximum virtual machine name length for non-Windows operating system</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum name length for a non-Windows virtual machine.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>MaxVmNameLengthWindows</p></td>
<td align="left"><p>Maximum name length in Windows</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum name length for Windows virtual machine (limitation imposed by Windows hostnames).</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxVmsInPool</p></td>
<td align="left"><p>Max virtual machines in pool</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Maximum number of virtual machines in a single data center.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VmPoolMaxSubsequentFailures</p></td>
<td align="left"><p>Maximum number of subsequent VM creation failures before giving up</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum number of subsequent failed virtual machine creations that can occur in a virtual machine pool before the operation is stopped.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NumberofFailedRunsOnVds</p></td>
<td align="left"><p>Number of Failed Runs on Host</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Number of attempts to run virtual machines on hosts before setting host status to "Error".</p></td>
</tr>
<tr class="odd">
<td align="left"><p>NumberOfVmsForTopSizeVms</p></td>
<td align="left"><p>Number of virtual machines with highest disk size to display</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Number of virtual machines to display in the storage domain's virtual machine tab. Will display this amount of virtual machines, sorted by the most storage space per used virtual machine.</p></td>
</tr>
<tr class="even">
<td align="left"><p>NumberVmRefreshesBeforeSave</p></td>
<td align="left"><p>Number of Virtual Machine Data Refreshes Before Saving to Database</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The number of host monitor iterations between refreshing virtual machines from VDSM (determines if virtual machines should be refreshed one upon each iteration)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>OnlyRequiredNetworksMandatoryForVdsSelection</p></td>
<td align="left"><p>Specifies whether only required networks will be considered for determining if a virtual machine can be run on a host</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>If set to <code>true</code>, only networks marked as <code>Required</code> will be considered when determining if a virtual machine can be run on a given host. Otherwise, all networks that the virtual machine uses must be set up on a host for that host to be able to run the virtual machine.</p></td>
</tr>
<tr class="even">
<td align="left"><p>OverUtilizationForHaReservation</p></td>
<td align="left"><p>A percentage representing the threshold for over-utilization compared to the optimal use case</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Example - if the optimal number of highly available virtual machines for a given host is two, and this key is set to <code>200</code>, a highly available virtual machine will not be migrated using the balance method until there are at least five highly available virtual machines on that the given host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ScaleDownForHaReservation</p></td>
<td align="left"><p>A number by which the high-availability reservation weight score is divided to produce the final weight score</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Example - if the weight score for a host is 90 and this key is set to <code>2</code>, the final score for that host is 45. This allows you to reduce the effect of the high-availability reservation weight function has on the total scoring for a host.</p></td>
</tr>
<tr class="even">
<td align="left"><p>oVirtISOsRepositoryPath</p></td>
<td align="left"><p>The oVirt Node installation files path</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>/usr/share/ovirt-hypervisor</p></td>
<td align="left"><p>The location of oVirt Node ISO images used for upgrading Hypervisor hosts.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>EnableVdsHaReservation</p></td>
<td align="left"><p>Specifies whether high-availability virtual machine reservation is enabled for a cluster</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>true</p></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>VdsHaReservationIntervalInMinutes</p></td>
<td align="left"><p>The period of time, in minutes, after which a cluster will be checked for high-availability reservation</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>DefaultMaximumMigrationDowntime</p></td>
<td align="left"><p>The maximum time a virtual machine can be down during live migration</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>If this key is set to <code>0</code>, the default value for VDSM will be used.</p></td>
</tr>
<tr class="even">
<td align="left"><p>PollUri</p></td>
<td align="left"><p>The URI used for accessing the attestation service</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>AttestationService/resources/PollHosts</p></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>ProductKey2003</p></td>
<td align="left"><p>Product Key (for Windows 2003)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ProductKey2003x64</p></td>
<td align="left"><p>Product Key (for Windows 2003 x64)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ProductKey2008</p></td>
<td align="left"><p>Product Key (for Windows 2008)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ProductKey2008R2</p></td>
<td align="left"><p>Product Key (for Windows 2008 R2)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ProductKey2008x64</p></td>
<td align="left"><p>Product Key (for Windows 2008 x64)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ProductKey</p></td>
<td align="left"><p>Product Key (for Windows XP)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ProductKeyWindow7</p></td>
<td align="left"><p>Product Key (for Windows 7)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>ProductKeyWindow7x64</p></td>
<td align="left"><p>Product Key (for Windows 7 x64)</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Windows serial key to be used with sysprepped virtual machines created from a template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ProductRPMVersion</p></td>
<td align="left"><p>oVirt RPM Version</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Automatically populated</p></td>
<td align="left"><p>The RPM version of the currently used rhevm package.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SANWipeAfterDelete</p></td>
<td align="left"><p>Initializing disk image is more secure but it can be time consuming and I/O intensive depending on the size of the image</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>Determines the default value (checked/unchecked) of the <strong>Wipe After Delete</strong> check box in the <strong>New Virtual Disk</strong> window. This is relevant for disks being created on SAN-based storage domains (FC/iSCSI).</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SASL_QOP</p></td>
<td align="left"><p>SASL quality of protection</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>auth-conf</p></td>
<td align="left"><p>Determines the quality of protection in authentication and LDAP queries (auth, auth-int, auth-conf).</p></td>
</tr>
<tr class="even">
<td align="left"><p>SearchResultsLimit</p></td>
<td align="left"><p>Max Quantity of Search Results</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The number of results to return for search queries if no specific figure is given in the web administration portal or REST.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SecureConnectionWithOATServers</p></td>
<td align="left"><p>Determine whether use secure communication or not to access attestation service</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>true</p></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>ServerRebootTimeout</p></td>
<td align="left"><p>Host Reboot Timeout (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Wait this amount of seconds when a host is rebooted or fenced, before determining that the host is <code>Non Responsive</code>. Can be increased for hosts that take longer to reboot.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SpiceProxyDefault</p></td>
<td align="left"><p>The address of the SPICE Proxy.</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>none</p></td>
<td align="left"><p>When this key is set to a value, the SPICE proxy is activated (turned on). When this key is not set to a value, the SPICE proxy is not activated (turned off).</p></td>
</tr>
<tr class="even">
<td align="left"><p>SpiceReleaseCursorKeys</p></td>
<td align="left"><p>Keyboard keys combination that causes the mouse cursor to be released from its grab on SPICE</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Shift+F12</p></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>SpiceSecureChannels</p></td>
<td align="left"><p>SPICE Secure Channels</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>smain, sinputs, scursor, splayback, srecord, sdisplay, susbredir, ssmartcard</p></td>
<td align="left"><p>Which SPICE channels should be secured with SSL.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SpiceToggleFullScreenKeys</p></td>
<td align="left"><p>Keyboard keys combination that toggles the full-screen state of SPICE client window</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Shift+F11</p></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>SpiceUsbAutoShare</p></td>
<td align="left"><p>Enable USB devices sharing by default in SPICE</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>Represents the default value (checked/unchecked) of the <strong>Enable USB Auto-Share</strong> check box in the <strong>Console Options</strong> dialog in the User Portal.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SpmCommandFailOverRetries</p></td>
<td align="left"><p>Number of retries to failover the Storage Pool Manager on failed commands</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Number of SPM selection failover retries. In case an SPM command fails, back end performs a failover - it selects a new SPM and re-runs the command.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SPMFailOverAttempts</p></td>
<td align="left"><p>Number of attempts to connect to the Storage Pool Manager before Failover</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When monitoring a Storage Pool, if the current SPM fails, failover does not happen immediately (see description of SpmCommandFailOverRetries). This setting defines the number of retries before deciding that the current SPM is down and a failover is required.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SpmVCpuConsumption</p></td>
<td align="left"><p>The CPU consumption of SPM embodied as number of VCPUs on the Host</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When a host is the SPM, it is considered to be using this amount of extra virtual CPUs, to make up for the overhead that SPM operations generate.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SSHInactivityTimoutSeconds</p></td>
<td align="left"><p>SSH Inactivity Timeout (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum amount of time back end allows for an SSH session to remote hosts. After this timeout the session is killed.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SSHInactivityHardTimoutSeconds</p></td>
<td align="left"><p>SSH Inactivity Hard Timeout (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>NumberOfUSBSlots</p></td>
<td align="left"><p>Number of USB slots in virtual machines with native USB support</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>SchedulerAllowOverBooking</p></td>
<td align="left"><p>Specify whether scheduler resource synchronization will be skipped</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>If scheduler resource synchronization is skipped, it may lead to more requests being scheduled than can be fulfilled.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SchedulerOverBookingThreshold</p></td>
<td align="left"><p>Determines the threshold for pending Scheduling requests before Scheduling resource synchronization is skipped</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>This option is used when <code>SchedulerAllowOverBooking</code> is set to <code>true</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SSLEnabled</p></td>
<td align="left"><p>SPICE SSL Enabled</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>Whether SPICE Secure channels should be encrypted using SSL.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>StorageDomainFailureTimeoutInMinutes</p></td>
<td align="left"><p>Storage Domain failure timeout</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Defines the amount of time taken before deciding domain is problematic, starting at the first failure reported by VDSM (in minutes).</p></td>
</tr>
<tr class="even">
<td align="left"><p>StoragePoolRefreshTimeInSeconds</p></td>
<td align="left"><p>Storage Pool Manager Polling Rate (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Storage Pool monitoring frequency.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrep2K3Path</p></td>
<td align="left"><p>Path to a Windows 2003 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrep2K8Path</p></td>
<td align="left"><p>Path to a Windows 2008 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrep2K8R2Path</p></td>
<td align="left"><p>Path to a Windows 2008 R2 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrep2K8x64Path</p></td>
<td align="left"><p>Path to a Windows 2008 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrepWindows7Path</p></td>
<td align="left"><p>Path to a Windows 7 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrepWindows7x64Path</p></td>
<td align="left"><p>Path to a Windows 7 x64 machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrepWindows8Path</p></td>
<td align="left"><p>Path to a Windows 8 machine Sys-Prep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrepWindows8x64Path</p></td>
<td align="left"><p>Path to a Windows 8 x64 machine Sys-Prep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrepWindows2012x64Path</p></td>
<td align="left"><p>Path to a Windows 2012 x64 machine Sys-Prep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrepXPPath</p></td>
<td align="left"><p>Path to a Windows XP machine sysprep file</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Path to the operating system specific sysprep file template.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>TimeoutToResetVdsInSeconds</p></td>
<td align="left"><p>Communication timeout in seconds before attempting reset</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of time a host is unresponsive before a fence command is issued. This is used in conjunction with <em><code>VDSAttemptsToResetCount</code></em>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>TimeToReduceFailedRunOnVdsInMinutes</p></td>
<td align="left"><p>Time to Reduce Failed Run on Host (in minutes)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of time that the host will be in Error status after failing to run virtual machines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>UserDefinedVMProperties</p></td>
<td align="left"><p>User-defined virtual machine properties</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Mostly used with VDSM hooks.</p></td>
</tr>
<tr class="even">
<td align="left"><p>UseFqdnForRdpIfAvailable</p></td>
<td align="left"><p>Specify whether the fully qualified domain name will be used in connections using the RDP console protocol</p></td>
<td align="left"><p>Boolean</p></td>
<td align="left"><p>true</p></td>
<td align="left"><p>If this option is enabled, the RDP console will use the fully qualified domain name of the virtual machine, if available, as reported by the guest agent. This fully qualified domain name is then used to establish the connection.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>UserRefreshRate</p></td>
<td align="left"><p>Refresh Rate of Users' Data from Active Directory (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>How often the directory server is polled for user account updates.</p></td>
</tr>
<tr class="even">
<td align="left"><p>UtilizationThresholdInPercent</p></td>
<td align="left"><p>The Utilization Threshold (in percent)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>In load balancing, this is a default value used to calculate the maximum CPU limit to determine if the host is over-utilized. This is the percent of the value that the user set in high-utilization in the cluster.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ValidNumOfMonitors</p></td>
<td align="left"><p>Valid Numbers of Monitors</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Number of monitors available for SPICE-enabled virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p>VdcVersion</p></td>
<td align="left"><p>oVirt Version</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>Automatically set to the current version of oVirt</p></td>
</tr>
<tr class="odd">
</tr>
<tr class="even">
<td align="left"><p>VDSAttemptsToResetCount</p></td>
<td align="left"><p>Number of attempts to communicate with Host before trying to reset</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The amount of times to retry communications with a host before a fence command is issued. Used in conjunction with <em><code>TimeoutToResetVdsInSeconds</code></em>.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VdsLoadBalancingeIntervalInMinutes</p></td>
<td align="left"><p>Host Load Balancing Interval (in minutes)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The interval between running the virtual machines' load balancer in minutes (also defines the first invocation of the load balancer).</p></td>
</tr>
<tr class="even">
<td align="left"><p>VdsRecoveryTimeoutInMintues</p></td>
<td align="left"><p>Host Timeout when Recovering (in minutes)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>When VDSM fails/restarts, it can sometimes be in recovering mode (VDSM reports "initializing" or "recovering from reports").</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VdsRefreshRate</p></td>
<td align="left"><p>Time interval in seconds to poll a Host's status</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>How often a Hypervisor host's status is checked.</p></td>
</tr>
<tr class="even">
<td align="left"><p>vdsTimeout</p></td>
<td align="left"><p>Host Control Communication Timeout (in seconds)</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Timeout for a VDSM call - the time engine will wait for sync call to VDSM.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>vdsConnectionTimeout</p></td>
<td align="left"><p>VDS connection timeout value</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The time to wait, in seconds, for establishment of a connection with a host.</p></td>
</tr>
<tr class="even">
<td align="left"><p>vdsRetries</p></td>
<td align="left"><p>Number of times to retry VDS-related host operations</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The number of times to retry host operations in the event of communication errors.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VM32BitMaxMemorySizeInMB</p></td>
<td align="left"><p>Maximum memory for 32-bit virtual machines</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The maximum memory size, in MB, for 32-bit virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p>VM64BitMaxMemorySizeInMB</p></td>
<td align="left"><p>Maximum memory for 64-bit virtual machines</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"><p>v3.0: 524288 v3.1: 2097152 v3.2: 2097152 v3.3: 2097152 v3.4: 2097152</p></td>
<td align="left"><p> </p></td>
</tr>
<tr class="odd">
<td align="left"><p>VmGracefulShutdownMessage</p></td>
<td align="left"><p>Message displayed in Virtual Machine when Virtual Machine is being shut down from oVirt</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>System Administrator has initiated shutdown of this Virtual Machine. Virtual Machine is shutting down.</p></td>
</tr>
<tr class="even">
</tr>
<tr class="odd">
<td align="left"><p>VMMinMemorySizeInMB</p></td>
<td align="left"><p>Minimal memory size of virtual machine in MB</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>VncKeyboardLayout</p></td>
<td align="left"><p>Keyboard Layout configuration for VNC</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>en-us</p></td>
<td align="left"><p>Possible values: ar, da, de-ch, en-us, et, fo, fr-be, fr-ch, hu, it, li, mk, nl, no, pt, ru, sv, tr, de en-gb, es, fi, fr, fr-ca, hr, is, ja, lv, nl-be, pl, pt-br, sl, th.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>WaitForVdsInitInSec</p></td>
<td align="left"><p>Wait for a host to complete init in SPM selection</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>This is a timeout for initializing host as in <em><code>VdsRecoveryTimeoutInMinutes</code></em>, but this timeout is shorter and is used during the SPM selection algorithm. If the selected host is initialized, wait for it to recover.</p></td>
</tr>
<tr class="even">
<td align="left"><p>FenceQuietTimeBetweenOperationsInSec</p></td>
<td align="left"><p>Quiet time between Power Management operations in seconds</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The minimum time in seconds between two power management operations activated manually by a user.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>FenceProxyDefaultPreferences</p></td>
<td align="left"><p>The default preferences for fencing proxies</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>cluster,dc</p></td>
<td align="left"><p>The default fencing proxy preferences used to define how to search for a proxy host in fencing operations.</p></td>
</tr>
<tr class="even">
<td align="left"><p>MaxAuditLogMessageLength</p></td>
<td align="left"><p>Maximum length of an Audit Log message</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>SysPrepDefaultUser</p></td>
<td align="left"><p>Default sysprep user name</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>This user is used if the domain for sysprep is unknown or no domain is specified.</p></td>
</tr>
<tr class="even">
<td align="left"><p>SysPrepDefaultPassword</p></td>
<td align="left"><p>Default SysPrep user password</p></td>
<td align="left"><p>Password</p></td>
<td align="left"><p>Empty</p></td>
<td align="left"><p>This password is used if the domain for sysprep is unknown or no domain is specified.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>QoSInboundAverageDefaultValue</p></td>
<td align="left"><p>The average quality of service for inbound network traffic</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The average quality of service for inbound network traffic, in Mbps.</p></td>
</tr>
<tr class="even">
<td align="left"><p>QoSInboundPeakDefaultValue</p></td>
<td align="left"><p>The quality of service for inbound network traffic during peak times</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The quality of service for inbound network traffic during peak times, in Mbps.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>QoSInboundBurstDefaultValue</p></td>
<td align="left"><p>The quality of service for inbound network traffic during bursts</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The quality of service for inbound network traffic during bursts, in Mbps.</p></td>
</tr>
<tr class="even">
<td align="left"><p>QoSOutboundAverageDefaultValue</p></td>
<td align="left"><p>The average quality of service for outbound network traffic</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The average quality of service for outbound network traffic, in Mbps.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>QoSOutboundPeakDefaultValue</p></td>
<td align="left"><p>The quality of service for outbound network traffic during peak times</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The quality of service for outbound network traffic during peak times, in Mbps.</p></td>
</tr>
<tr class="even">
<td align="left"><p>QoSOutboundBurstDefaultValue</p></td>
<td align="left"><p>The quality of service for outbound network traffic during bursts</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The quality of service for outbound network traffic during bursts, in Mbps.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>UserSessionTimeOutInterval</p></td>
<td align="left"><p>Session timeout interval in minutes</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>User session timeout. Global for all types of access - User Portal/Admin Portal/Web Admin/API.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AdminPassword</p></td>
<td align="left"><p>admin user password</p></td>
<td align="left"><p>Password</p></td>
<td align="left"></td>
<td align="left"><p>Password of admin user (used if no directory service is used for authentication).</p></td>
</tr>
<tr class="odd">
<td align="left"><p>IPTablesConfig</p></td>
<td align="left"><p>Iptables configuration used to auto-configure oVirt</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>The complete set of iptables rules that are used when automatic firewall configuration is selected when running the <code>engine-setup</code> command</p></td>
</tr>
<tr class="even">
<td align="left"><p>OvirtIsoPrefix</p></td>
<td align="left"><p>oVirt ISOs files prefix</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>ovirt-node-iso, rhevh</p></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>OvirtInitialSupportedIsoVersion</p></td>
<td align="left"><p>oVirt node initial Supported ISO Version</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>VdsLocalDisksLowFreeSpace</p></td>
<td align="left"><p>Amount of free disk space on a host local storage domain that should be considered low, in MB</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Setting this value lower than the default of 1000 MB reduces the time available to add additional space to your data domains before virtual machine performance is affected. If you have many virtual machines, generating or receiving data, it may make sense to set this value higher.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>VdsLocalDisksCriticallyLowFreeSpace</p></td>
<td align="left"><p>Amount of free disk space on a host local storage domain that should be considered critically low, in MB</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>Setting this value lower than the default of 500 MB reduces the time between when critical disk shortage messages begin being displayed and when virtual machine performance is affected. If you have many virtual machines, generating or receiving data quickly, you might find that the default value is too low, and does not provide enough time to add more storage.</p></td>
</tr>
<tr class="even">
<td align="left"><p>AllowDuplicateMacAddresses</p></td>
<td align="left"><p>Enable duplicate MAC address for VM network interface</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>If enabled, allows that the same MAC address be set explicitly on several virtual NICs. Otherwise, setting a MAC address that is already in use on another virtual NIC is prohibited.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>JobCleanupRateInMinutes</p></td>
<td align="left"><p>Frequency of jobs cleanup process</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>SucceededJobCleanupTimeInMinutes</p></td>
<td align="left"><p>Time to keep successfully ended jobs</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>FailedJobCleanupTimeInMinutes</p></td>
<td align="left"><p>Time to keep failed jobs</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>VmPoolMonitorIntervalInMinutes</p></td>
<td align="left"><p>Interval in minutes for monitoring number of prestarted virtual machines in virtual machine pools</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>UserMessageOfTheDay</p></td>
<td align="left"><p>A message to be displayed in the User Portal login page</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>VmPoolMonitorBatchSize</p></td>
<td align="left"><p>Maximum number of virtual machines that the virtual machine pool monitor will attempt to prestart in a single cycle</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>NetworkConnectivityCheckTimeoutInSeconds</p></td>
<td align="left"><p>The time to wait before rolling back network changes in case the engine losses connectivity with the host in seconds</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>AllowClusterWithVirtGlusterEnabled</p></td>
<td align="left"><p>Allows to create a Cluster with both Virt and Gluster services enabled</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>If enabled, the user can create a cluster with both Virt and Gluster support or one of them, otherwise the user cannot create a cluster that supports both.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>EnableMACAntiSpoofingFilterRules</p></td>
<td align="left"><p>Indicates if Network Filtering should be enabled or not</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>v3.0: false v3.1: false v3.2: true</p></td>
<td align="left"><p>If enabled, MAC anti-spoofing rules are set on each virtual network interface card, ensuring that the Ethernet frames this network interface card sends have the source MAC that is assigned to it in the engine.</p></td>
</tr>
<tr class="even">
<td align="left"><p>EnableHostTimeDrift</p></td>
<td align="left"><p>Indicates if host time-drift validation is enabled</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>false</p></td>
<td align="left"><p>If time drift validation is enabled, oVirt will require that host system time be within a given variation of oVirt system time. The allowed difference is set by HostTimeDriftInSec</p></td>
</tr>
<tr class="odd">
<td align="left"><p>EngineMode</p></td>
<td align="left"><p>Engine working mode</p></td>
<td align="left"><p>String</p></td>
<td align="left"><p>Active</p></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><p>HostTimeDriftInSec</p></td>
<td align="left"><p>Allowed time drift between any Host and Engine</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><p>WebSocketProxy</p></td>
<td align="left"><p>The location of a websocket proxy</p></td>
<td align="left"><p>String</p></td>
<td align="left"></td>
<td align="left"><p>The location of a websocket proxy. Possible values include <code>Off</code>, <code>Host:[port]</code>, <code>Engine:[port]</code>, <em>[host name]</em>, or <em>[ip address]</em>:<em>[port]</em></p></td>
</tr>
<tr class="even">
<td align="left"><p>WebSocketProxyTicketValiditySeconds</p></td>
<td align="left"><p>The time for which websocket proxy tickets are valid</p></td>
<td align="left"><p>Integer</p></td>
<td align="left"></td>
<td align="left"><p>The time, in seconds, for validity of tickets issued for a websocket proxy.</p></td>
</tr>
</tbody>
</table>

### The Image Uploader Tool

#### The Image Uploader Tool

The `engine-image-uploader` command allows you to list export storage domains and upload virtual machine images in OVF format to an export storage domain and have them automatically recognized in oVirt.

<div class="alert alert-info">
**Note:** The image uploader only supports gzip-compressed OVF files created by oVirt.

</div>
The archive contains images and master directories in the following format:

    |-- images
    |   |-- [Image Group UUID]
    |        |--- [Image UUID (this is the disk image)]
    |        |--- [Image UUID (this is the disk image)].meta
    |-- master
    |   |---vms
    |       |--- [UUID]
    |             |--- [UUID].ovf

#### Syntax for the engine-image-uploader Command

The basic syntax for the image uploader command is:

    engine-image-uploader [options] list
    engine-image-uploader [options] upload [file].[file]...[file]

The image uploader command supports two actions - *`list`*, and *`upload`*.

*   The *`list`* action lists the export storage domains to which images can be uploaded.
*   The *`upload`* action uploads images to the specified export storage domain.

You must specify one of the above actions when you use the image uploader command. Moreover, you must specify at least one local file to use the *`upload`* action.

There are several parameters to further refine the `engine-image-uploader` command. You can set defaults for any of these parameters in the `/etc/ovirt-engine/imageuploader.conf` file.

**General Options**

*`-h`*, *`--help`*  
Displays information on how to use the image uploader command.

*`--conf-file=[PATH]`*  
Sets *[PATH]* as the configuration file the command will to use. The default is `etc/ovirt-engine/imageuploader.conf`.

*`--log-file=[PATH]`*  
Sets *[PATH]* as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-image-uploader/ovirt-image-uploader-[date].log`.

*`--cert-file=[PATH]`*  
Sets *[PATH]* as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

*`--insecure`*  
Specifies that no attempt will be made to verify the engine.

*`--quiet`*  
Sets quiet mode, reducing console output to a minimum.

*`-v`*, *`--verbose`*  
Sets verbose mode, providing more console output.

*`-f`*, *`--force`*  
Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination export domain. This option forces the existing file to be overwritten.

**oVirt Options**

*`-u [USER]`*, *`--user=[USER]`*  
Specifies the user whose credentials will be used to execute the command. The *[USER]* is specified in the format *[username]*@*[domain]*. The user must exist in the specified domain and be known to oVirt.

*`-r [FQDN]`*, *`--engine=[FQDN]`*  
Specifies the IP address or fully qualified domain name of oVirt from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which oVirt is installed. The default value is `localhost:443`.

**Export Storage Domain Options**

The following options specify the export domain to which the images will be uploaded. These options cannot be used together; you must used either the *`-e`* option or the *`-n`* option.

*`-e`* *[EXPORT_DOMAIN]*, *`--export-domain=[EXPORT_DOMAIN]`*  
Sets the storage domain *EXPORT_DOMAIN* as the destination for uploads.

*`-n`* *[NFSSERVER]*, *`--nfs-server=[NFSSERVER]`*  
Sets the NFS path *[NFSSERVER]* as the destination for uploads.

**Import Options**

The following options allow you to customize which attributes of the images being uploaded are included when the image is uploaded to the export domain.

*`-i`*, *`--ovf-id`*  
Specifies that the UUID of the image will not be updated. By default, the command generates a new UUID for images that are uploaded. This ensures there is no conflict between the id of the image being uploaded and the images already in the environment.

*`-d`*, *`--disk-instance-id`*  
Specifies that the instance ID for each disk in the image will not be renamed. By default, the command generates new UUIDs for disks in images that are uploaded. This ensures there are no conflicts between the disks on the image being uploaded and the disks already in the environment.

*`-m`*, *`--mac-address`*  
Specifies that network components in the image will not be removed from the image. By default, the command removes network interface cards from image being uploaded to prevent conflicts with network cards on other virtual machines already in the environment. If you do not use this option, you can use the Administration Portal to add network interface cards to newly imported images and oVirt will ensure there are no MAC address conflicts.

*`-N [NEW_IMAGE_NAME]`*, *`--name=[NEW_IMAGE_NAME]`*  
Specifies a new name for the image being uploaded.

#### Creating an OVF Archive That is Compatible With the Image Uploader

**Summary**

You can create files that can be uploaded using the `engine-image-uploader` tool.

**Procedure 16.2. Creating an OVF Archive That is Compatible With the Image Uploader**

1.  Use oVirt to create an empty export domain. An empty export domain makes it easy to see which directory contains your virtual machine.
2.  Export your virtual machine to the empty export domain you just created.
3.  Log in to the storage server that serves as the export domain, find the root of the NFS share and change to the subdirectory under that mount point. You started with a new export domain, there is only one directory under the exported directory. It contains the `images/` and `master/` directories.
4.  Run the `tar -zcvf my.ovf images/ master/` command to create the tar/gzip ovf archive.
5.  Anyone you give the resulting ovf file to (in this example, called `my.ovf`) can import it to oVirt using the `engine-image-uploader` command.

**Result**

You have created a compressed OVF image file that can be distributed. Anyone you give it to can use the `engine-image-uploader` command to upload your image into their oVirt environment.

#### Basic engine-image-uploader Usage Examples

The following is an example of how to use the engine uploader command to list export storage domains:

**Example 16.1. Listing export storage domains using the image uploader**

    # engine-image-uploader list
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    Export Storage Domain Name | Datacenter  | Export Domain Status
    myexportdom               | Myowndc 　  | active

The following is an example of how to upload an Open Virtualization Format (ovf) file:

**Example 16.2. Uploading a file using the image uploader**

    # engine-image-uploader -e myexportdom upload myrhel6.ovf
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):

### The Log Collector Tool

#### Log Collector

A log collection tool is included in oVirt. This allows you to easily collect relevant logs from across the oVirt environment when requesting support.

The log collection command is `engine-log-collector`. You are required to log in as the `root` user and provide the administration credentials for the oVirt environment. The `engine-log-collector -h` command displays usage information, including a list of all valid options for the `engine-log-collector` command.

#### Syntax for engine-log-collector Command

The basic syntax for the log collector command is:

    engine-log-collector [options] list [all, clusters, datacenters]
    engine-log-collector [options] collect

The two supported modes of operation are *`list`* and *`collect`*.

*   The *`list`* parameter lists either the hosts, clusters, or data centers attached to oVirt. You are able to filter the log collection based on the listed objects.
*   The *`collect`* parameter performs log collection from oVirt. The collected logs are placed in an archive file under the `/tmp/logcollector` directory. The `engine-log-collector` command assigns each log a specific file name.

Unless another parameter is specified, the default action is to list the available hosts together with the data center and cluster to which they belong. You will be prompted to enter user names and passwords to retrieve certain logs.

There are numerous parameters to further refine the `engine-log-collector` command.

**General options**

*`--version`*  
Displays the version number of the command in use and returns to prompt.

*`-h`*, *`--help`*  
Displays command usage information and returns to prompt.

*`--conf-file=PATH`*  
Sets *PATH* as the configuration file the tool is to use.

*`--local-tmp=PATH`*  
Sets *PATH* as the directory in which logs are saved. The default directory is `/tmp/logcollector`.

*`--ticket-number=TICKET`*  
Sets *TICKET* as the ticket, or case number, to associate with the SOS report.

*`--upload=FTP_SERVER`*  
Sets *FTP_SERVER* as the destination for retrieved logs to be sent using FTP. Do not use this option unless advised to by a Red Hat support representative.

*`--log-file=PATH`*  
Sets *PATH* as the specific file name the command should use for the log output.

*`--quiet`*  
Sets quiet mode, reducing console output to a minimum. Quiet mode is off by default.

*`-v`*, *`--verbose`*  
Sets verbose mode, providing more console output. Verbose mode is off by default.

**oVirt Options**

These options filter the log collection and specify authentication details for oVirt.

These parameters can be combined for specific commands. For example, `engine-log-collector --user=admin@internal --cluster ClusterA,ClusterB --hosts "SalesHost"*` specifies the user as `admin@internal` and limits the log collection to only `SalesHost` hosts in clusters `A` and `B`.

*`--no-hypervisors`*  
Omits virtualization hosts from the log collection.

*`-u USER`*, *`--user=USER`*  
Sets the user name for login. The *USER* is specified in the format *user*@*domain*, where *user* is the user name and *domain* is the directory services domain in use. The user must exist in directory services and be known to oVirt.

*`-r FQDN`*, *`--rhevm=FQDN`*  
Sets the fully qualified domain name of oVirt server from which to collect logs, where *FQDN* is replaced by the fully qualified domain name of oVirt. It is assumed that the log collector is being run on the same local host as oVirt; the default value is `localhost`.

*`-c CLUSTER`*, *`--cluster=CLUSTER`*  
Collects logs from the virtualization hosts in the nominated *CLUSTER* in addition to logs from oVirt. The cluster(s) for inclusion must be specified in a comma-separated list of cluster names or match patterns.

*`-d DATACENTER`*, *`--data-center=DATACENTER`*  
Collects logs from the virtualization hosts in the nominated *DATACENTER* in addition to logs from oVirt. The data center(s) for inclusion must be specified in a comma-separated list of data center names or match patterns.

*`-H HOSTS_LIST`*, *`--hosts=HOSTS_LIST`*  
Collects logs from the virtualization hosts in the nominated *HOSTS_LIST* in addition to logs from oVirt. The hosts for inclusion must be specified in a comma-separated list of host names, fully qualified domain names, or IP addresses. Match patterns are also valid.

**SOS Report Options**

The log collector uses the JBoss SOS plugin. Use the following options to activate data collection from the JMX console.

*`--jboss-home=JBOSS_HOME`*  
JBoss installation directory path. The default is `/var/lib/jbossas`.

*`--java-home=JAVA_HOME`*  
Java installation directory path. The default is `/usr/lib/jvm/java`.

*`--jboss-profile=JBOSS_PROFILE`*  
Displays a quoted and space-separated list of server profiles; limits log collection to specified profiles. The default is *`'rhevm-slimmed'`*.

*`--enable-jmx`*  
Enables the collection of run-time metrics from oVirt's JBoss JMX interface.

*`--jboss-user=JBOSS_USER`*  
User with permissions to invoke JBoss JMX. The default is *`admin`*.

*`--jboss-logsize=LOG_SIZE`*  
Maximum size in MB for the retrieved log files.

*`--jboss-stdjar=STATE`*  
Sets collection of JAR statistics for JBoss standard JARs. Replace *STATE* with `on` or `off`. The default is `on`.

*`--jboss-servjar=STATE`*  
Sets collection of JAR statistics from any server configuration directories. Replace *STATE* with `on` or `off`. The default is `on`.

*`--jboss-twiddle=STATE`*  
Sets collection of twiddle data on or off. Twiddle is the JBoss tool used to collect data from the JMX invoker. Replace *STATE* with `on` or `off`. The default is `on`.

*`--jboss-appxml=XML_LIST`*  
Displays a quoted and space-separated list of applications with XML descriptions to be retrieved. Default is `all`.

**SSH Configuration**

*`--ssh-port=PORT`*  
Sets *PORT* as the port to use for SSH connections with virtualization hosts.

*`-k KEYFILE`*, *`--key-file=KEYFILE`*  
Sets *KEYFILE* as the public SSH key to be used for accessing the virtualization hosts.

*`--max-connections=MAX_CONNECTIONS`*  
Sets *MAX_CONNECTIONS* as the maximum concurrent SSH connections for logs from virtualization hosts. The default is `10`.

**PostgreSQL Database Options**

The database user name and database name must be specified, using the *`pg-user`* and *`dbname`* parameters, if they have been changed from the default values.

Use the *`pg-dbhost`* parameter if the database is not on the local host. Use the optional *`pg-host-key`* parameter to collect remote logs. The PostgreSQL SOS plugin must be installed on the database server for remote log collection to be successful.

*`--no-postgresql`*  
Disables collection of database. The log collector will connect to oVirt PostgreSQL database and include the data in the log report unless the *`--no-postgresql`* parameter is specified.

*`--pg-user=USER`*  
Sets *USER* as the user name to use for connections with the database server. The default is `postgres`.

*`--pg-dbname=DBNAME`*  
Sets *DBNAME* as the database name to use for connections with the database server. The default is `rhevm`.

*`--pg-dbhost=DBHOST`*  
Sets *DBHOST* as the host name for the database server. The default is `localhost`.

*`--pg-host-key=KEYFILE`*  
Sets *KEYFILE* as the public identity file (private key) for the database server. This value is not set by default; it is required only where the database does not exist on the local host.

#### Basic Log Collector Usage

When the `engine-log-collector` command is run without specifying any additional parameters, its default behavior is to collect all logs from oVirt and its attached hosts. It will also collect database logs unless the *`--no-postgresql`* parameter is added. In the following example, log collector is run to collect all logs from oVirt and three attached hosts.

**Example 16.3. Log Collector Usage**

    # engine-log-collector
    INFO: Gathering oVirt Engine information...
    INFO: Gathering PostgreSQL the oVirt Engine database and log files from localhost...
    Please provide REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    About to collect information from 3 hypervisors. Continue? (Y/n):
    INFO: Gathering information from selected hypervisors...
    INFO: collecting information from 192.168.122.250
    INFO: collecting information from 192.168.122.251
    INFO: collecting information from 192.168.122.252
    INFO: finished collecting information from 192.168.122.250
    INFO: finished collecting information from 192.168.122.251
    INFO: finished collecting information from 192.168.122.252
    Creating compressed archive...
    INFO Log files have been collected and placed in /tmp/logcollector/sosreport-rhn-account-20110804121320-ce2a.tar.xz.
    The MD5 for this file is 6d741b78925998caff29020df2b2ce2a and its size is 26.7M

### The ISO Uploader Tool

#### The ISO Uploader Tool

The ISO uploader is a tool for uploading ISO images to the ISO storage domain. It is installed as part of oVirt.

The ISO uploader command is `engine-iso-uploader`. You must log in as the `root` user and provide the administration credentials for the oVirt environment to use this command. The `engine-iso-uploader -h` command displays usage information, including a list of all valid options for the `engine-iso-uploader` command.

#### Syntax for the engine-iso-uploader Command

The basic syntax for the ISO uploader command is:

    engine-iso-uploader [options] list
    engine-iso-uploader [options] upload [file].[file]...[file]

The ISO uploader command supports two actions - *`list`*, and *`upload`*.

*   The *`list`* action lists the ISO storage domains to which ISO files can be uploaded. oVirt creates this list on the machine on which oVirt is installed during the installation process.
*   The *`upload`* action uploads a single ISO file or multiple ISO files separated by spaces to the specified ISO storage domain. NFS is used by default, but SSH is also available.

You must specify one of the above actions when you use the ISO uploader command. Moreover, you must specify at least one local file to use the *`upload`* action.

There are several parameters to further refine the `engine-iso-uploader` command.

**General Options**

*`--version`*  
Displays the version of the ISO uploader command.

*`-h`*, *`--help`*  
Displays information on how to use the ISO uploader command.

*`--conf-file=[PATH]`*  
Sets *[PATH]* as the configuration file the command will to use. The default is `/etc/ovirt-engine/isouploader.conf`.

*`--log-file=[PATH]`*  
Sets *[PATH]* as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-iso-uploader/ovirt-iso-uploader[date].log`.

*`--cert-file=[PATH]`*  
Sets *[PATH]* as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

*`--insecure`*  
Specifies that no attempt will be made to verify the engine.

*`--nossl`*  
Specifies that SSL will not be used to connect to the engine.

*`--quiet`*  
Sets quiet mode, reducing console output to a minimum.

*`-v`*, *`--verbose`*  
Sets verbose mode, providing more console output.

*`-f`*, *`--force`*  
Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination ISO domain. This option forces the existing file to be overwritten.

**oVirt Options**

*`-u [USER]`*, *`--user=[USER]`*  
Specifies the user whose credentials will be used to execute the command. The *[USER]* is specified in the format *[username]*@*[domain]*. The user must exist in the specified domain and be known to oVirt.

*`-r [FQDN]`*, *`--engine=[FQDN]`*  
Specifies the IP address or fully qualified domain name of oVirt from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which oVirt is installed. The default value is `localhost:443`.

**ISO Storage Domain Options**

The following options specify the ISO domain to which the images will be uploaded. These options cannot be used together; you must used either the *`-i`* option or the *`-n`* option.

*`-i`*, *`--iso-domain=[ISODOMAIN]`*  
Sets the storage domain *[ISODOMAIN]* as the destination for uploads.

*`-n`*, *`--nfs-server=[NFSSERVER]`*  
Sets the NFS path *[NFSSERVER]* as the destination for uploads.

**Connection Options**

The ISO uploader uses NFS as default to upload files. These options specify SSH file transfer instead.

*`--ssh-user=[USER]`*  
Sets *[USER]* as the SSH user name to use for the upload. The default is `root`.

*`--ssh-port=[PORT]`*  
Sets *[PORT]* as the port to use when connecting to SSH.

*`-k [KEYFILE]`*, *`--key-file=[KEYFILE]`*  
Sets *[KEYFILE]* as the public key to use for SSH authentication. You will be prompted to enter the password of the user specified with *`--ssh-user=[USER]`* if no key is set.

## Log Files

### oVirt Installation Log Files

⁠

**Table 17.1. Installation**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Log File</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>/var/log/ovirt-engine/engine-cleanup_yyyy_mm_dd_hh_mm_ss.log</code></p></td>
<td align="left"><p>Log from the <code>engine-cleanup</code> command. This is the command used to reset an oVirt installation. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>/var/log/ovirt-engine/engine-db-install-yyyy_mm_dd_hh_mm_ss.log</code></p></td>
<td align="left"><p>Log from the <code>engine-setup</code> command detailing the creation and configuration of the <code>rhevm</code> database.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>/var/log/ovirt-engine/rhevm-dwh-setup-yyyy_mm_dd_hh_mm_ss.log</code></p></td>
<td align="left"><p>Log from the <code>rhevm-dwh-setup</code> command. This is the command used to create the <code>ovirt_engine_history</code> database for reporting. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>/var/log/ovirt-engine/ovirt-engine-reports-setup-yyyy_mm_dd_hh_mm_ss.log</code></p></td>
<td align="left"><p>Log from the <code>rhevm-reports-setup</code> command. This is the command used to install oVirt Reports modules. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>/var/log/ovirt-engine/setup/ovirt-engine-setup-yyyymmddhhmmss.log</code></p></td>
<td align="left"><p>Log from the <code>engine-setup</code> command. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently.</p></td>
</tr>
</tbody>
</table>

### oVirt Log Files

**Table 17.2. Service Activity**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Log File</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>/var/log/ovirt-engine/engine.log</code></p></td>
<td align="left"><p>Reflects all oVirt GUI crashes, Active Directory look-ups, Database issues, and other events.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>/var/log/ovirt-engine/host-deploy</code></p></td>
<td align="left"><p>Log files from hosts deployed from oVirt.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>/var/lib/ovirt-engine/setup-history.txt</code></p></td>
<td align="left"><p>Tracks the installation and upgrade of packages associated with oVirt.</p></td>
</tr>
</tbody>
</table>

### oVirt Host Log Files

**Table 17.3.  Host Log Files**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Log File</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><code>/var/log/vdsm/libvirt.log</code></p></td>
<td align="left"><p>Log file for <code>libvirt</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>/var/log/vdsm/spm-lock.log</code></p></td>
<td align="left"><p>Log file detailing the host's ability to obtain a lease on the Storage Pool Manager role. The log details when the host has acquired, released, renewed, or failed to renew the lease.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><code>/var/log/vdsm/vdsm.log</code></p></td>
<td align="left"><p>Log file for VDSM, oVirt's agent on the virtualization host(s).</p></td>
</tr>
<tr class="even">
<td align="left"><p><code>/tmp/ovirt-host-deploy-@DATE@.log</code></p></td>
<td align="left"><p>Host deployment log, copied to engine as /var/log/ovirt-engine/host-deploy/ovirt-<em>@DATE@-@HOST@-@CORRELATION_ID@</em>.log after the host has been successfully deployed.</p></td>
</tr>
</tbody>
</table>

### Remotely Logging Host Activities

#### Setting Up a Virtualization Host Logging Server

**Summary**

oVirt hosts generate and update log files, recording their actions and problems. Collecting these log files centrally simplifies debugging.

This procedure should be used on your centralized log server. You could use a separate logging server, or use this procedure to enable host logging on oVirt.

**Procedure 17.1. Setting up a Virtualization Host Logging Server**

1.  Configure SELinux to allow **rsyslog** traffic.
        # semanage port -a -t syslogd_port_t -p udp 514

2.  Edit `/etc/rsyslog.conf` and add below lines:
        $template TmplAuth, "/var/log/%fromhost%/secure" 
        $template TmplMsg, "/var/log/%fromhost%/messages" 

        $RuleSet remote
        authpriv.*   ?TmplAuth
        *.info,mail.none;authpriv.none,cron.none   ?TmplMsg
        $RuleSet RSYSLOG_DefaultRuleset
        $InputUDPServerBindRuleset remote

    Uncomment the following:

        #$ModLoad imudp
        #$UDPServerRun 514

3.  Restart the rsyslog service:
        # service rsyslog restart

**Result**

Your centralized log server is now configured to receive and store the `messages` and `secure` logs from your virtualization hosts.

#### Configuring oVirt Node Hosts to Use a Logging Server

**Summary**

oVirt hosts generate and update log files, recording their actions and problems. Collecting these log files centrally simplifies debugging.

Use this procedure on an oVirt Node host to begin sending log files to your centralized log server.

⁠

**Procedure 17.2. Configuring oVirt Node Hosts to Use a Logging Server**

1.  Log in to your oVirt Node host as `admin` to access the Hypervisors text user interface (TUI) setup screen.
2.  Select **Logging** from the list of options on the left of the screen.
3.  Press the **Tab** key to reach the text entry fields. Enter the IP address or FQDN of your centralized log server and the port it uses.
4.  Press the **Tab** key to reach the **Apply**, and press the **Enter** Key.

**Result**

Your oVirt Node host has been configured to send messages to a centralized log server.

## ⁠Proxies

### SPICE Proxy

#### SPICE Proxy Overview

The SPICE Proxy is a tool used to connect SPICE Clients to guests when the SPICE Clients are outside the network that connects the hypervisors.

Setting up a SPICE Proxy consists of installing **Squid** on a machine and configuring **iptables** to allow proxy traffic through the firewall.

Turning a SPICE Proxy on consists of using **engine-config** on oVirt to set the key `SpiceProxyDefault` to a value consisting of the name and port of the proxy.

Turning a SPICE Proxy off consists of using **engine-config** on oVirt to remove the value that the key `SpiceProxyDefault` has been set to.

#### SPICE Proxy Machine Setup

**Summary**

This procedure explains how to set up a machine as a SPICE Proxy. A SPICE Proxy makes it possible to connect to the oVirt network from outside the network. We use **Squid** in this procedure to provide proxy services.

**Procedure 18.1. Installing Squid on a RHEL Machine**

1.  Install **Squid** on the Proxy machine:
        # yum install squid

2.  Open `/etc/squid/squid.conf`. Change
        http_access deny CONNECT !SSL_ports

    to

        http_access deny CONNECT !Safe_ports

3.  Restart the proxy:
        # service squid restart

4.  Open the default squid port:
        # iptables -A INPUT -p tcp --dport 3128 -j ACCEPT

5.  Make this iptables rule persistent:
        # iptables-save

**Result**

You have now set up a machine as a SPICE proxy. Before connecting to the oVirt network from outside the network, activate the SPICE proxy.

#### Turning on SPICE Proxy

**Summary**

This procedure explains how to activate (or turn on) the SPICE proxy.

**Procedure 18.2. Activating SPICE Proxy**

1.  On oVirt, use the engine-config tool to set a proxy:
        # engine-config -s SpiceProxyDefault=someProxy

2.  Restart the **ovirt-engine** service:
        # service ovirt-engine restart

    The proxy must have this form:

        protocol://[host]:[port]

    <div class="alert alert-info">
    **Note:** Only the http protocol is supported by SPICE clients. If https is specified, the client will ignore the proxy setting and attempt a direct connection to the hypervisor

    </div>

**Result**

SPICE Proxy is now activated (turned on). It is now possible to connect to the oVirt network through the SPICE proxy.

#### Turning Off a SPICE Proxy

**Summary**

This procedure explains how to turn off (deactivate) a SPICE proxy.

**Procedure 18.3. Turning Off a SPICE Proxy**

1.  Log in to oVirt:
        $ ssh root@[IP of Manager]

2.  Run the following command to clear the SPICE proxy:
        # engine-config -s SpiceProxyDefault=""

3.  Restart oVirt:
        # service ovirt-engine restart

**Result**

SPICE proxy is now deactivated (turned off). It is no longer possible to connect to the oVirt network through the SPICE proxy.

### Squid Proxy

#### Installing and Configuring a Squid Proxy

**Summary**

This section explains how to install and configure a Squid Proxy to the User Portal.

**Procedure 18.4. Configuring a Squid Proxy**

1.  **Obtaining a Keypair**
    Obtain a keypair and certificate for the HTTPS port of the Squid proxy server.
    You can obtain this keypair the same way that you would obtain a keypair for another SSL/TLS service. The keypair is in the form of two PEM files which contain the private key and the signed certificate. In this document we assume that they are named `proxy.key` and `proxy.cer`.
    The keypair and certificate can also be generated using the certificate authority of the oVirt engine. If you already have the private key and certificate for the proxy and do not want to generate it with the oVirt engine certificate authority, skip to the next step.
2.  **Generating a Keypair**
    Decide on a host name for the proxy. In this procedure, the proxy is called `proxy.example.com`.
    Decide on the rest of the distinguished name of the certificate for the proxy. The important part here is the "common name", which contains the host name of the proxy. Users' browsers use the common name to validate the connection. It is good practice to use the same country and same organization name used by the oVirt engine itself. Find this information by logging in to the oVirt engine machine and running the following command:
        [root@engine ~]# openssl x509 -in /etc/pki/ovirt-engine/ca.pem -noout -subject

    This command will output something like this:

        subject= /C=US/O=Example Inc./CN=engine.example.com.81108

    The relevant part here is `/C=us/O=Example Inc.`. Use this to build the complete distinguished name for the certificate for the proxy:

        /C=US/O=Example Inc./CN=proxy.example.com

    Log in to the proxy machine and generate a certificate signing request:

        [root@proxy ~]# openssl req -newkey rsa:2048 -subj '/C=US/O=Example Inc./CN=proxy.example.com' -nodes -keyout proxy.key -out proxy.req

    <div class="alert alert-info">
    **Note:** The quotes around the distinguished name for the certificate are very important. Do not leave them out.

    </div>
    The command will generate the key pair. It is very important that the private key is not encrypted (that is the effect of the -nodes option) because otherwise you would need to type the password to start the proxy server.
    The output of the command looks like this:

        Generating a 2048 bit RSA private key
        ......................................................+++
        .................................................................................+++
        writing new private key to 'proxy.key'
        -----

    The command will generate two files: `proxy.key` and `proxy.req`. `proxy.key` is the private key. Keep this file safe. `proxy.req` is the certificate signing request. `proxy.req` does not require any special protection.
    To generate the signed certificate, copy the `private.csr` file to the oVirt engine machine, using the **scp** command:

        [root@proxy ~]# scp proxy.req engine.example.com:/etc/pki/ovirt-engine/requests/.

    Log in to the oVirt engine machine and run the following command to sign the certificate:

        [root@engine ~]# /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=proxy --days=3650 --subject='/C=US/O=Example Inc./CN=proxy.example.com'

    This will sign the certificate and make it valid for 10 years (3650 days). Set the certificate to expire earlier, if you prefer.
    The output of the command looks like this:

        Using configuration from openssl.conf
        Check that the request matches the signature
        Signature ok
        The Subject's Distinguished Name is as follows
        countryName           :PRINTABLE:'US'
        organizationName      :PRINTABLE:'Example Inc.'
        commonName            :PRINTABLE:'proxy.example.com'
        Certificate is to be certified until Jul 10 10:05:24 2023 GMT (3650
        days)

        Write out database with 1 new entries
        Data Base Updated

    The generated certificate file is available in the directory `/etc/pki/ovirt-engine/certs` and should be named `proxy.cer`. Copy this file to the proxy machine:

        [root@proxy ~]# scp engine.example.com:/etc/pki/ovirt-engine/certs/proxy.cer .

    Make sure that both the `proxy.key` and `proxy.cer` files are present on the proxy machine:

        [root@proxy ~]# ls -l proxy.key proxy.cer

    The output of this command will look like this:

        -rw-r--r--. 1 root root 4902 Jul 12 12:11 proxy.cer
        -rw-r--r--. 1 root root 1834 Jul 12 11:58 proxy.key

    You are now ready to install and configure the proxy server.

3.  **Install the Squid proxy server package**
    Install this system as follows:
        [root@proxy ~]# yum -y install squid

4.  **Configure the Squid proxy server**
    Move the private key and signed certificate to a place where the proxy can access them, for example to the `/etc/squid` directory:
        [root@proxy ~]# cp proxy.key proxy.cer /etc/squid/.

    Set permissions so that the "squid" user can read these files:

        [root@proxy ~]# chgrp squid /etc/squid/proxy.*
        [root@proxy ~]# chmod 640 /etc/squid/proxy.*

    The Squid proxy will connect to the oVirt engine web server using the SSL protocol, and must verify the certificate used by the engine. Copy the certificate of the CA that signed the certificate of the oVirt engine web server to a place where the proxy can access it, for example `/etc/squid`. The default CA certificate is located in the `/etc/pki/ovirt-engine/ca.pem` file in the oVirt engine machine. Copy it with the following command:

        [root@proxy ~]# scp engine.example.com:/etc/pki/ovirt-engine/ca.pem /etc/squid/.

    Ensure the `squid` user can read that file:

        [root@proxy ~]# chgrp squid /etc/squid/ca.pem
        [root@proxy ~]# chmod 640 /etc/squid/ca.pem

    If SELinux is in enforcing mode, change the context of port 443 using the **semanage** tool. This permits Squid to use port 443.

        [root@proxy ~]# yum install -y policycoreutils-python
        [root@proxy ~]# semanage port -m -p tcp -t http_cache_port_t 443

    Replace the existing squid configuration file with the following:

        https_port 443 key=/etc/squid/proxy.key cert=/etc/squid/proxy.cer ssl-bump defaultsite=engine.example.com
        cache_peer engine.example.com parent 443 0 no-query originserver ssl sslcafile=/etc/squid/ca.pem name=engine
        cache_peer_access engine allow all
        ssl_bump allow all
        http_access allow all

5.  **Restart the Squid Proxy Server**
    Run the following command in the proxy machine:
        [root@proxy ~]# service squid restart

6.  **Configure the websockets proxy**
    <div class="alert alert-info">
    **Note:** This step is optional. Do this step only to use the noVNC console or the SPICE HTML 5 console.

    </div>
    To use the noVNC or SPICE HTML 5 consoles to connect to the console of virtual machines, the websocket proxy server must be configured on the machine on which the engine is installed. If you selected to configure the websocket proxy server when prompted during installing or upgrading the engine with the `engine-setup` command, the websocket proxy server will already be configured. If you did not select to configure the websocket proxy server at this time, you can configure it later by running the `engine-setup` command with the following option:

        engine-setup --otopi-environment="OVESETUP_CONFIG/websocketProxyConfig=bool:True"

    You must also ensure the **ovirt-websocket-proxy** service is started and will start automatically on boot:

        [root@engine ~]# service ovirt-websocket-proxy status
        [root@engine ~]# chkconfig ovirt-websocket-proxy on

    Both the noVNC and the SPICE HTML 5 consoles use the websocket protocol to connect to the virtual machines, but squid proxy server does not support the websockets protocol, so this communication cannot be proxied with Squid. Tell the system to connect directly to the websockets proxy running in the machine where the engine is running. To do this, update the `WebSocketProxy` configuration parameter using the "engine-config" tool:

        [root@engine ~]# engine-config \
        -s WebSocketProxy=engine.example.com:6100
        [root@engine ~]# service ovirt-engine restart

    <div class="alert alert-info">
    **Important:** If you skip this step the clients will assume that the websockets proxy is running in the proxy machine, and thus will fail to connect.

    </div>
7.  **Connect to the User Portal using the complete URL**
    Connect to the User Portal using the complete URL, for instance:
        https://proxy.example.com/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html

    <div class="alert alert-info">
    **Note:** Shorter URLs, for example `https://proxy.example.com/UserPortal`, will not work. These shorter URLs are redirected to the long URL by the application server, using the 302 response code and the Location header. The version of **Squid** in Red Hat Enterprise Linux and Fedora (**Squid** version 3.1) does not support rewriting these headers.

    </div>

**Summary**

You have installed and configured a Squid proxy to the User Portal.

## Firewalls

### ⁠oVirt Firewall Requirements

oVirt requires that a number of ports be opened to allow network traffic through the system's firewall. The `engine-setup` script is able to configure the firewall automatically, but this overwrites any pre-existing firewall configuration.

Where an existing firewall configuration exists, you must manually insert the firewall rules required by oVirt instead. The `engine-setup` command saves a list of the `iptables` rules required in the `/usr/share/ovirt-engine/conf/iptables.example` file.

The firewall configuration documented here assumes a default configuration. Where non-default HTTP and HTTPS ports are chosen during installation adjust the firewall rules to allow network traffic on the ports that were selected - not the default ports (`80` and `443`) listed here.

**Table A.1. oVirt Firewall Requirements**

<table>
<colgroup>
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Port(s)</p></th>
<th align="left"><p>Protocol</p></th>
<th align="left"><p>Source</p></th>
<th align="left"><p>Destination</p></th>
<th align="left"><p>Purpose</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>-</p></td>
<td align="left"><p>ICMP</p></td>
<td align="left"><ul>
<li>oVirt Node(s)<br /></li>
<li>Red Hat Enterprise Linux host(s)</li>
</ul></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><p>When registering to oVirt, virtualization hosts send an ICMP ping request to oVirt to confirm that it is online.</p></td>
</tr>
<tr class="even">
<td align="left"><p>22</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>System(s) used for maintenance of oVirt including backend configuration, and software upgrades.</li>
</ul></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><p>SSH (optional)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>80, 443</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>Administration Portal clients<br /></li>
<li>User Portal clients<br /></li>
<li>oVirt Node(s)<br /></li>
<li>Red Hat Enterprise Linux host(s)<br /></li>
<li>REST API clients<br /></li>
</ul></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><p>Provides HTTP and HTTPS access to oVirt.</p></td>
</tr>
</tbody>
</table>

<div class="alert alert-info">
**Important:** In environments where oVirt is also required to export NFS storage, such as an ISO Storage Domain, additional ports must be allowed through the firewall. Grant firewall exceptions for the ports applicable to the version of NFS in use:

**NFSv4**  
TCP port `2049` for NFS.

**NFSv3**  
TCP and UDP port `2049` for NFS.

TCP and UDP port `111` (`rpcbind`/`sunrpc`).

TCP and UDP port specified with `MOUNTD_PORT="port"`

TCP and UDP port specified with `STATD_PORT="port"`

TCP port specified with `LOCKD_TCPPORT="port"`

UDP port specified with `LOCKD_UDPPORT="port"`

</div>

The `MOUNTD_PORT`, `STATD_PORT`, `LOCKD_TCPPORT`, and `LOCKD_UDPPORT` ports are configured in the `/etc/sysconfig/nfs` file.

### ⁠Virtualization Host Firewall Requirements

Red Hat Enterprise Linux hosts and oVirt Nodes require a number of ports to be opened to allow network traffic through the system's firewall. In the case of the oVirt Node these firewall rules are configured automatically. For Red Hat Enterprise Linux hosts however it is necessary to manually configure the firewa

**Table A.2. Virtualization Host Firewall Requirements**

<table>
<colgroup>
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Port(s)</p></th>
<th align="left"><p>Protocol</p></th>
<th align="left"><p>Source</p></th>
<th align="left"><p>Destination</p></th>
<th align="left"><p>Purpose</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>22</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>Secure Shell (SSH) access.</p></td>
</tr>
<tr class="even">
<td align="left"><p>161</p></td>
<td align="left"><p>UDP</p></td>
<td align="left"><ul>
<li>Red Hat Enterprise Linux Hypervisors</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><p>Simple network management protocol (SNMP).</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5900-6923</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>Administration Portal clients</li>
<li>User Portal clients</li>
</ul></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>Remote guest console access via VNC and SPICE. These ports must be open to facilitate client access to virtual machines.</p></td>
</tr>
<tr class="even">
<td align="left"><p>5989</p></td>
<td align="left"><p>TCP, UDP</p></td>
<td align="left"><ul>
<li>Common Information Model Object Manager (CIMOM)</li>
</ul></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>Used by Common Information Model Object Managers (CIMOM) to monitor virtual machines running on the virtualization host. To use a CIMOM to monitor the virtual machines in your virtualization environment then you must ensure that this port is open.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>16514</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>Virtual machine migration using <code>libvirt</code>.</p></td>
</tr>
<tr class="even">
<td align="left"><p>49152-49216</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>Red Hat Enterprise Linux Hypervisors</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><ul>
<li>Red Hat Enterprise Linux Hypervisors</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>Virtual machine migration and fencing using VDSM. These ports must be open facilitate both automated and manually initiated migration of virtual machines.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>54321</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>oVirt</li>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><ul>
<li>oVirt Nodes</li>
<li>Red Hat Enterprise Linux hosts</li>
</ul></td>
<td align="left"><p>VDSM communications with oVirt and other virtualization hosts.</p></td>
</tr>
</tbody>
</table>

**Example A.1. Option Name: IPTablesConfig**

Recommended (default) values: Automatically generated by vdsm bootstrap script

    *filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A INPUT -p icmp -j ACCEPT
    -A INPUT -i lo -j ACCEPT
    # vdsm
    -A INPUT -p tcp --dport 54321 -j ACCEPT
    # libvirt tls
    -A INPUT -p tcp --dport 16514 -j ACCEPT
    # SSH
    -A INPUT -p tcp --dport 22 -j ACCEPT
    # guest consoles
    -A INPUT -p tcp -m multiport --dports 5900:6923 -j ACCEPT
    # migration
    -A INPUT -p tcp -m multiport --dports 49152:49216 -j ACCEPT
    # snmp
    -A INPUT -p udp --dport 161 -j ACCEPT
    # Reject any other input traffic
    -A INPUT -j REJECT --reject-with icmp-host-prohibited
    -A FORWARD -m physdev ! --physdev-is-bridged -j REJECT --reject-with icmp-host-prohibited
    COMMIT

### ⁠Directory Server Firewall Requirements

oVirt requires a directory server to support user authentication. A number of ports must be opened in the directory server's firewall to support GSS-API authentication as used by oVirt.

**Table A.3. Host Firewall Requirements**

<table>
<colgroup>
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Port(s)</p></th>
<th align="left"><p>Protocol</p></th>
<th align="left"><p>Source</p></th>
<th align="left"><p>Destination</p></th>
<th align="left"><p>Purpose</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>88, 464</p></td>
<td align="left"><p>TCP, UDP</p></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><ul>
<li>Directory server</li>
</ul></td>
<td align="left"><p>Kerberos authentication.</p></td>
</tr>
<tr class="even">
<td align="left"><p>389, 636</p></td>
<td align="left"><p>TCP</p></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><ul>
<li>Directory server</li>
</ul></td>
<td align="left"><p>Lightweight Directory Access Protocol (LDAP) and LDAP over SSL.</p></td>
</tr>
</tbody>
</table>

### ⁠Database Server Firewall Requirements

oVirt supports the use of a remote database server. If you plan to use a remote database server with oVirt then you must ensure that the remote database server allows connections from oVirt.

**Table A.4. Host Firewall Requirements**

<table>
<colgroup>
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Port(s)</p></th>
<th align="left"><p>Protocol</p></th>
<th align="left"><p>Source</p></th>
<th align="left"><p>Destination</p></th>
<th align="left"><p>Purpose</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>5432</p></td>
<td align="left"><p>TCP, UDP</p></td>
<td align="left"><ul>
<li>oVirt</li>
</ul></td>
<td align="left"><ul>
<li>PostgreSQL database server</li>
</ul></td>
<td align="left"><p>Default port for PostgreSQL database connections.</p></td>
</tr>
</tbody>
</table>

If you plan to use a local database server on oVirt itself, which is the default option provided during installation, then no additional firewall rules are required.

## oVirt and SSL

### ⁠Replacing oVirt SSL Certificate

**Summary**

You want to use your organization's commercially signed certificate to identify your oVirt to users connecting over https.

<div class="alert alert-info">
**Note:** Using a commercially issued certificate for https connections does not affect the certificate used for authentication between your oVirt and hosts, they will continue to use the self-signed certificate generated by oVirt.

</div>
Prerequisites

This procedure requires a *PEM* formatted certificate from your commercial certificate issuing authority, a *.nokey* file, and a *.cer* file. The *.nokey* and *.cer* files are sometimes distributed as a certificate-key bundle in the *P12* format.

This procedure assumes that you have a certificate-key bundle in the *P12* format.

**Procedure B.1. Replacing oVirt Apache SSL Certificate**

1.  oVirt has been configured to use `/etc/pki/ovirt-engine/apache-ca.pem`, which is symbolically linked to `/etc/pki/ovirt-engine/ca.pem`. Remove the symbolic link.
        # rm /etc/pki/ovirt-engine/apache-ca.pem

2.  Save your commercially issued certificate as `/etc/pki/ovirt-engine/apache-ca.pem`.
        mv YOUR-3RD-PARTY-CERT.pem /etc/pki/ovirt-engine/apache-ca.pem

3.  Move your *P12* bundle to `/etc/pki/ovirt-engine/keys/apache.p12`.
4.  Extract the key from the bundle.
        # openssl pkcs12 -in  /etc/pki/ovirt-engine/keys/apache.p12 -nocerts -nodes > /etc/pki/ovirt-engine/keys/apache.key.nopass

5.  Extract the certificate from the bundle.
        # openssl pkcs12 -in /etc/pki/ovirt-engine/keys/apache.p12 -nokeys > /etc/pki/ovirt-engine/certs/apache.cer

6.  Restart the Apache server.
        # service httpd restart

**Result**

Your users can now connect to the portals without being warned about the authenticity of the certificate used to encrypt https traffic.

## Authors and Revision History

**Jodi Biddle**

Red Hat Engineering Content Services

      jbiddle@redhat.com

**Andrew Burden**

Red Hat Engineering Content Services

      aburden@redhat.com

**Lucy Bopf**

Red Hat Engineering Content Services

      lbopf@redhat.com

**Andrew Dahms**

Red Hat Engineering Content Services

      adahms@redhat.com

**Zac Dover**

Red Hat Engineering Content Services

      zdover@redhat.com

Revision 1.0-1

Wed 25 Jun 2014

**Lucy Bopf**

|------------------------------------------------------------------|
| Initial creation for oVirt Engine test build for Brian Proffitt. |

## Legal Notice

Copyright © 2014 Red Hat, Inc.

This document is licensed by Red Hat under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/). If you distribute this document, or a modified version of it, you must provide attribution to Red Hat, Inc. and provide a link to the original. If the document is modified, all Red Hat trademarks must be removed.

Red Hat, as the licensor of this document, waives the right to enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law.

Red Hat, Red Hat Enterprise Linux, the Shadowman logo, JBoss, MetaMatrix, Fedora, the Infinity Logo, and RHCE are trademarks of Red Hat, Inc., registered in the United States and other countries.

Linux® is the registered trademark of Linus Torvalds in the United States and other countries.

Java® is a registered trademark of Oracle and/or its affiliates.

XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries.

MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries.

Node.js® is an official trademark of Joyent. Red Hat Software Collections is not formally related to or endorsed by the official Joyent Node.js open source or commercial project.

The OpenStack® Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.

All other trademarks are the property of their respective owners.
