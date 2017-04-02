---
title: Using Search, Bookmarks, and Tags
---

# Appendix E: Using Search, Bookmarks, and Tags

## Searches

### Performing Searches in oVirt

The Administration Portal enables the management of thousands of resources, such as virtual machines, hosts, users, and more. To perform a search, enter the search query (free-text or syntax-based) into the search bar. Search queries can be saved as bookmarks for future reuse, so you do not have to reenter a search query each time the specific search results are required. Searches are not case sensitive.

### Search Syntax and Examples

The syntax of the search queries for oVirt resources is as follows:

`result type: {criteria} [sortby sort_spec]`

**Syntax Examples**

The following examples describe how the search query is used and help you to understand how oVirt assists with building search queries.

**Example Search Queries**

| Example | Result |
|-
| Hosts: Vms.status = up | Displays a list of all hosts running virtual machines that are up. |
| Vms: domain = qa.company.com | Displays a list of all virtual machines running on the specified domain. |
| Vms: users.name = Mary | Displays a list of all virtual machines belonging to users with the user name Mary. |
| Events: severity &gt; normal sortby time | Displays the list of all Events whose severity is higher than Normal, sorted by time. |

### Search Auto-Completion

The Administration Portal provides auto-completion to help you create valid and powerful search queries. As you type each part of a search query, a drop-down list of choices for the next part of the search opens below the Search Bar. You can either select from the list and then continue typing/selecting the next part of the search, or ignore the options and continue entering your query manually.

The following table specifies by example how the Administration Portal auto-completion assists in constructing a query:

` Hosts: Vms.status = down `

**Example Search Queries Using Auto-Completion**

<table>
 <thead>
  <tr>
   <td>Input</td>
   <td>List Items Displayed</td>
   <td>Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt> h </tt></td>
   <td><tt>Hosts</tt> (1 option only)</td>
   <td>
    <p>Select <tt>Hosts</tt> or;</p>
    <p>Type <tt> Hosts </tt></p>
   </td>
  </tr>
  <tr>
   <td><tt> Hosts: </tt></td>
   <td>All host properties</td>
   <td>Type <tt> v </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: v </tt></td>
   <td>host properties starting with a <tt>v</tt></td>
   <td>Select <tt>Vms</tt> or type <tt> Vms </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms </tt></td>
   <td>All virtual machine properties</td>
   <td>Type <tt> s </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.s </tt></td>
   <td>All virtual machine properties beginning with <tt>s</tt></td>
   <td>Select <tt>status</tt> or type <tt> status </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.status </tt></td>
   <td>
    <p><tt>=</tt></p>
    <p><tt>=!</tt></p>
   </td>
   <td>Select or type <tt> = </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.status = </tt></td>
   <td>All status values</td>
   <td>Select or type <tt> down </tt></td>
  </tr>
 </tbody>
</table>

### Search Result Type Options

The result type allows you to search for resources of any of the following types:

* **Vms** for a list of virtual machines

* **Host** for a list of hosts

* **Pools** for a list of pools

* **Template** for a list of templates

* **Event** for a list of events

* **Users** for a list of users

* **Cluster** for a list of clusters

* **Datacenter** for a list of data centers

* **Storage** for a list of storage domains

As each type of resource has a unique set of properties and a set of other resource types that it is associated with, each search type has a set of valid syntax combinations. You can also use the auto-complete feature to create valid queries easily.

### Search Criteria

You can specify the search criteria after the colon in the query. The syntax of `{criteria}` is as follows:

    <prop><operator><value>

or

    <obj-type><prop><operator><value>

**Examples**

The following table describes the parts of the syntax:

**Example Search Criteria**

<table>
 <thead>
  <tr>
   <td>Part</td>
   <td>Description</td>
   <td>Values</td>
   <td>Example</td>
   <td>Note</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>prop</td>
   <td>The property of the searched-for resource. Can also be the property of a resource type (see <tt>obj-type</tt>), or <i>tag</i> (custom tag).</td>
   <td>Limit your search to objects with a certain property. For example, search for objects with a <i>status</i> property.</td>
   <td>Status</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>obj-type</td>
   <td>A resource type that can be associated with the searched-for resource.</td>
   <td>These are system objects, like data centers and virtual machines.</td>
   <td>Users</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>operator</td>
   <td>Comparison operators.</td>
   <td>
    <p>=</p>
    <p>!= (not equal)</p>
    <p>&gt;</p>
    <p>&lt;</p>
    <p>&gt;=</p>
    <p>&lt;=</p>
   </td>
   <td>N/A</td>
   <td>Value options depend on obj-type.</td>
  </tr>
  <tr>
   <td>Value</td>
   <td>What the expression is being compared to.</td>
   <td>
    <p>String</p>
    <p>Integer</p>
    <p>Ranking</p>
    <p>Date (formatted according to Regional Settings)</p>
   </td>
   <td>
    <p>Jones</p>
    <p>256</p>
    <p>normal</p>
   </td>
   <td>
    <ul>
     <li>Wildcards can be used within strings.</li>
     <li>"" (two sets of quotation marks with no space between them) can be used to represent an un-initialized (empty) string.</li>
     <li>Double quotes should be used around a string or date containing spaces</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Search: Multiple Criteria and Wildcards

Wildcards can be used in the `<value>` part of the syntax for strings. For example, to find all users beginning with **m**, enter `m*`.

You can perform a search having two criteria by using the Boolean operators `AND` and `OR`. For example:

` Vms: users.name = m* AND status = Up `

This query returns all running virtual machines for users whose names begin with "m".

` Vms: users.name = m* AND tag = "paris-loc" `

This query returns all virtual machines tagged with "paris-loc" for users whose names begin with "m".

When two criteria are specified without `AND` or `OR`, `AND` is implied. `AND` precedes `OR`, and `OR` precedes implied `AND`.

### Search: Determining Search Order

You can determine the sort order of the returned information by using `sortby`. Sort direction (`asc` for ascending, `desc` for descending) can be included.

For example:

` events: severity > normal sortby time desc `

This query returns all Events whose severity is higher than Normal, sorted by time (descending order).

### Searching for Data Centers

The following table describes all search options for Data Centers.

**Searching for Data Centers**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Clusters.clusters-prop` | Depends on property type | The property of the clusters associated with the data center. |
| `name` | String | The name of the data center. |
| `description` | String | A description of the data center. |
| `type` | String | The type of data center. |
| `status` | List | The availability of the data center. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Datacenter: type = nfs and status != up `

This example returns a list of data centers with:

* A storage type of NFS and status other than up

### Searching for Clusters

The following table describes all search options for clusters.

**Searching Clusters**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Datacenter.datacenter-prop` | Depends on property type | The property of the data center associated with the cluster. |
| `Datacenter` | String | The data center to which the cluster belongs. |
| `name` | String | The unique name that identifies the clusters on the network. |
| `description` | String | The description of the cluster. |
| `initialized` | String | True or False indicating the status of the cluster. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

`Clusters: initialized = true or name = Default`

This example returns a list of clusters which are:

* initialized; or

* named Default

### Searching for Hosts

The following table describes all search options for hosts.

**Searching for Hosts**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Vms.Vms-prop` | Depends on property type | The property of the virtual machines associated with the host. |
| `Templates.templates-prop` | Depends on property type | The property of the templates associated with the host. |
| `Events.events-prop` | Depends on property type | The property of the events associated with the host. |
| `Users.users-prop` | Depends on property type | The property of the users associated with the host. |
| `name` | String | The name of the host. |
| `status` | List | The availability of the host. |
| `external_status` | String | The health status of the host as reported by external systems and plug-ins. |
| `cluster` | String | The cluster to which the host belongs. |
| `address` | String | The unique name that identifies the host on the network. |
| `cpu_usage` | Integer | The percent of processing power used. |
| `mem_usage` | Integer | The percentage of memory used. |
| `network_usage` | Integer | The percentage of network usage. |
| `load` | Integer | Jobs waiting to be executed in the *run-queue* per processor, in a given time slice. |
| `version` | Integer | The version number of the operating system. |
| `cpus` | Integer | The number of CPUs on the host. |
| `memory` | Integer | The amount of memory available. |
| `cpu_speed` | Integer | The processing speed of the CPU. |
| `cpu_model` | String | The type of CPU. |
| `active_vms` | Integer | The number of virtual machines currently running. |
| `migrating_vms` | Integer | The number of virtual machines currently being migrated. |
| `committed_mem` | Integer | The percentage of committed memory. |
| `tag` | String | The tag assigned to the host. |
| `type` | String | The type of host. |
| `datacenter` | String | The data center to which the host belongs. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Hosts: cluster = Default and Vms.os = rhel6 `

This example returns a list of hosts which:

* Are part of the Default cluster and host virtual machines running the Red Hat Enterprise Linux 6 operating system.

### Searching for Networks

The following table describes all search options for networks.

**Searching for Networks**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Cluster_network.clusternetwork-prop` | Depends on property type | The property of the cluster associated with the network. |
| `Host_Network.hostnetwork-prop` | Depends on property type | The property of the host associated with the network. |
| `name` | String | The human readable name that identifies the network. |
| `description` | String | Keywords or text describing the network, optionally used when creating the network. |
| `vlanid` | Integer | The VLAN ID of the network. |
| `stp` | String | Whether Spanning Tree Protocol (STP) is enabled or disabled for the network. |
| `mtu` | Integer | The maximum transmission unit for the logical network. |
| `vmnetwork` | String | Whether the network is only used for virtual machine traffic. |
| `datacenter` | String | The data center to which the network is attached. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Network: mtu > 1500 and vmnetwork = true `

This example returns a list of networks:

* with a maximum transmission unit greater than 1500 bytes

* which are set up for use by only virtual machines.

### Searching for Storage

The following table describes all search options for storage.

**Searching for Storage**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Hosts.hosts-prop` | Depends on property type | The property of the hosts associated with the storage. |
| `Clusters.clusters-prop` | Depends on property type | The property of the clusters associated with the storage. |
| `name` | String | The unique name that identifies the storage on the network. |
| `status` | String | The status of the storage domain. |
| `external_status` | String | The health status of the storage domain as reported by external systems and plug-ins. |
| `datacenter` | String | The data center to which the storage belongs. |
| `type` | String | The type of the storage. |
| `size` | Integer | The size of the storage. |
| `used` | Integer | The amount of the storage that is used. |
| `committed` | Integer | The amount of the storage that is committed. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Storage: size > 200 or used < 50 `

This example returns a list of storage with:

* total storage space greater than 200 GB; or

* used storage space less than 50 GB.

### Searching for Disks

The following table describes all search options for disks.

**Searching for Disks**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Datacenters.datacenters-prop` | Depends on property type | The property of the data centers associated with the disk. |
| `Storages.storages-prop` | Depends on property type | The property of the storage associated with the disk. |
| `alias` | String | The human readable name that identifies the storage on the network. |
| `description` | String | Keywords or text describing the disk, optionally used when creating the disk. |
| `provisioned_size` | Integer | The virtual size of the disk. |
| `size` | Integer | The size of the disk. |
| `actual_size` | Integer | The actual size allocated to the disk. |
| `creation_date` | Integer | The date the disk was created. |
| `bootable` | String | Whether the disk can or cannot be booted. Valid values are one of `0`, `1`, `yes`, or `no` |
| `shareable` | String | Whether the disk can or cannot be attached to more than one virtual machine at a time. Valid values are one of `0`, `1`, `yes`, or `no` |
| `format` | String | The format of the disk. Can be one of `unused`, `unassigned`, `cow`, or `raw`. |
| `status` | String | The status of the disk. Can be one of `unassigned`, `ok`, `locked`, `invalid`, or `illegal`. |
| `disk_type` | String | The type of the disk. Can be one of `image` or `lun`. |
| `number_of_vms` | Integer | The number of virtual machine(s) to which the disk is attached. |
| `vm_names` | String | The name(s) of the virtual machine(s) to which the disk is attached. |
| `quota` | String | The name of the quota enforced on the virtual disk. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Disks: format = cow and provisioned_size &gt; 8 `

This example returns a list of virtual disks with:

* QCOW, also known as thin provisioning, format; and

* an allocated disk size greater than 8 GB.

### Searching for Volumes

The following table describes all search options for volumes.

**Searching for Volumes**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Volume.cluster-prop` | Depends on property type | The property of the clusters associated with the volume. |
| `Cluster` | String | The name of the cluster associated with the volume. |
| `name` | String | The human readable name that identifies the volume. |
| `type` | String | Can be one of distribute, replicate, distributed_replicate, stripe, or distributed_stripe. |
| `transport_type` | Integer | Can be one of TCP or RDMA. |
| `replica_count` | Integer | Number of replica. |
| `stripe_count` | Integer | Number of stripes. |
| `status` | String | The status of the volume. Can be one of Up or Down. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Volume: transport_type = rdma and stripe_count >= 2 `

This example returns a list of volumes with:

* Transport type set to RDMA; and

* with 2 or more stripes.

### Searching for Virtual Machines

The following table describes all search options for virtual machines.

**Searching for Virtual Machines**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Hosts.hosts-prop` | Depends on property type | The property of the hosts associated with the virtual machine. |
| `Templates.templates-prop` | Depends on property type | The property of the templates associated with the virtual machine. |
| `Events.events-prop` | Depends on property type | The property of the events associated with the virtual machine. |
| `Users.users-prop` | Depends on property type | The property of the users associated with the virtual machine. |
| `Storage.storage-prop` | Depends on the property type | The property of storage devices associated with the virtual machine. |
| `Vnic.mac-prop` | Depends on the property type | The property of the MAC address associated with the virtual machine. |
| `name` | String | The name of the virtual machine. |
| `status` | List | The availability of the virtual machine. |
| `ip` | Integer | The IP address of the virtual machine. |
| `uptime` | Integer | The number of minutes that the virtual machine has been running. |
| `domain` | String | The domain (usually Active Directory domain) that groups these machines. |
| `os` | String | The operating system selected when the virtual machine was created. |
| `creationdate` | Date | The date on which the virtual machine was created. |
| `address` | String | The unique name that identifies the virtual machine on the network. |
| `cpu_usage` | Integer | The percent of processing power used. |
| `mem_usage` | Integer | The percentage of memory used. |
| `network_usage` | Integer | The percentage of network used. |
| `memory` | Integer | The maximum memory defined. |
| `apps` | String | The applications currently installed on the virtual machine. |
| `cluster` | List | The cluster to which the virtual machine belongs. |
| `pool` | List | The virtual machine pool to which the virtual machine belongs. |
| `loggedinuser` | String | The name of the user currently logged in to the virtual machine. |
| `tag` | List | The tags to which the virtual machine belongs. |
| `datacenter` | String | The data center to which the virtual machine belongs. |
| `type` | List | The virtual machine type (server or desktop). |
| `quota` | String | The name of the quota associated with the virtual machine. |
| `description` | String | Keywords or text describing the virtual machine, optionally used when creating the virtual machine. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Vms: template.name = Win* and user.name = "" `

This example returns a list of virtual machines, where:

* The template on which the virtual machine is based begins with Win and the virtual machine is assigned to any user.

**Example**

` Vms: cluster = Default and os = windows7 `

This example returns a list of virtual machines, where:

* The cluster to which the virtual machine belongs is named Default and the virtual machine is running the Windows 7 operating system.

### Searching for Pools

The following table describes all search options for Pools.

**Searching for Pools**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `name` | String | The name of the pool. |
| `description` | String | The description of the pool. |
| `type` | List | The type of pool. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

`Pools: type = automatic`

This example returns a list of pools with:

* Type of automatic

### Searching for Templates

The following table describes all search options for templates.

**Searching for Templates**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Vms.Vms-prop` | String | The property of the virtual machines associated with the template. |
| `Hosts.hosts-prop` | String | The property of the hosts associated with the template. |
| `Events.events-prop` | String | The property of the events associated with the template. |
| `Users.users-prop` | String | The property of the users associated with the template. |
| `name` | String | The name of the template. |
| `domain` | String | The domain of the template. |
| `os` | String | The type of operating system. |
| `creationdate` | Integer | The date on which the template was created. Date format is *mm/dd/yy*. |
| `childcount` | Integer | The number of virtual machines created from the template. |
| `mem` | Integer | Defined memory. |
| `description` | String | The description of the template. |
| `status` | String | The status of the template. |
| `cluster` | String | The cluster associated with the template. |
| `datacenter` | String | The data center associated with the template. |
| `quota` | String | The quota associated with the template. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Template: Events.severity >= normal and Vms.uptime > 0 `

This example returns a list of templates, where:

* Events of normal or greater severity have occurred on virtual machines derived from the template, and the virtual machines are still running.

### Searching for Users

The following table describes all search options for users.

**Searching for Users**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Vms.Vms-prop` | Depends on property type | The property of the virtual machines associated with the user. |
| `Hosts.hosts-prop` | Depends on property type | The property of the hosts associated with the user. |
| `Templates.templates-prop` | Depends on property type | The property of the templates associated with the user. |
| `Events.events-prop` | Depends on property type | The property of the events associated with the user. |
| `name` | String | The name of the user. |
| `lastname` | String | The last name of the user. |
| `usrname` | String | The unique name of the user. |
| `department` | String | The department to which the user belongs. |
| `group` | String | The group to which the user belongs. |
| `title` | String | The title of the user. |
| `status` | String | The status of the user. |
| `role` | String | The role of the user. |
| `tag` | String | The tag to which the user belongs. |
| `pool` | String | The pool to which the user belongs. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Users: Events.severity > normal and Vms.status = up or Vms.status = pause `

This example returns a list of users where:

* Events of greater than normal severity have occurred on their virtual machines AND the virtual machines are still running; or

* The users' virtual machines are paused.

### Searching for Events

The following table describes all search options you can use to search for events. Auto-completion is offered for many options as appropriate.

**Searching for Events**

| Property (of resource or resource-type) | Type | Description (Reference) |
|-
| `Vms.Vms-prop` | Depends on property type | The property of the virtual machines associated with the event. |
| `Hosts.hosts-prop` | Depends on property type | The property of the hosts associated with the event. |
| `Templates.templates-prop` | Depends on property type | The property of the templates associated with the event. |
| `Users.users-prop` | Depends on property type | The property of the users associated with the event. |
| `Clusters.clusters-prop` | Depends on property type | The property of the clusters associated with the event. |
| `Volumes.Volumes-prop` | Depends on property type | The property of the volumes associated with the event. |
| `type` | List | Type of the event. |
| `severity` | List | The severity of the event: Warning/Error/Normal. |
| `message` | String | Description of the event type. |
| `time` | List | Day the event occurred. |
| `usrname` | String | The user name associated with the event. |
| `event_host` | String | The host associated with the event. |
| `event_vm` | String | The virtual machine associated with the event. |
| `event_template` | String | The template associated with the event. |
| `event_storage` | String | The storage associated with the event. |
| `event_datacenter` | String | The data center associated with the event. |
| `event_volume` | String | The volume associated with the event. |
| `correlation_id` | Integer | The identification number of the event. |
| `sortby` | List | Sorts the returned results by one of the resource properties. |
| `page` | Integer | The page number of results to display. |

**Example**

` Events: Vms.name = testdesktop and Hosts.name = gonzo.example.com `

This example returns a list of events, where:

* The event occurred on the virtual machine named `testdesktop` while it was running on the host `gonzo.example.com`.

## Bookmarks

### Saving a Query String as a Bookmark

A bookmark can be used to remember a search query, and shared with other users.

**Saving a Query String as a Bookmark**

1. Enter the desired search query in the search bar and perform the search.

2. Click the star-shaped **Bookmark** button to the right of the search bar to open the **New Bookmark** window.

    **Bookmark Icon**

    ![](/images/admin-guide/6129.png)

3. Enter the **Name** of the bookmark.

4. Edit the **Search string** field (if applicable).

5. Click **OK** to save the query as a bookmark and close the window.

6. The search query is saved and displays in the **Bookmarks** pane.

You have saved a search query as a bookmark for future reuse. Use the **Bookmark** pane to find and select the bookmark.

### Editing a Bookmark

You can modify the name and search string of a bookmark.

**Editing a Bookmark**

1. Click the **Bookmarks** tab on the far left side of the screen.

2. Select the bookmark you wish to edit.

3. Click the **Edit** button to open the **Edit Bookmark** window.

4. Change the **Name** and **Search string** fields as necessary.

5. Click **OK** to save the edited bookmark.

You have edited a bookmarked search query.

### Deleting a Bookmark

When a bookmark is no longer needed, remove it.

**Deleting a Bookmark**

1. Click the **Bookmarks** tab on the far left side of the screen.

2. Select the bookmark you wish to remove.

3. Click the **Remove** button to open the **Remove Bookmark** window.

4. Click **OK** to remove the selected bookmark.

You have removed a bookmarked search query.

## Tags

### Using Tags to Customize Interactions with oVirt

After your oVirt platform is set up and configured to your requirements, you can customize the way you work with it using tags. Tags provide one key advantage to system administrators: they allow system resources to be arranged into groups or categories. This is useful when many objects exist in the virtualization environment and the administrator would like to concentrate on a specific set of them.

This section describes how to create and edit tags, assign them to hosts or virtual machines and search using the tags as criteria. Tags can be arranged in a hierarchy that matches a structure, to fit the needs of the enterprise.

Administration Portal Tags can be created, modified, and removed using the **Tags** pane.

### Creating a Tag

Create tags so you can filter search results using tags.

**Creating a Tag**

1. Click the **Tags** tab on the left side of the screen.

2. Select the node under which you wish to create the tag. For example, to create it at the highest level, click the **root** node.

3. Click the **New** button to open the **New Tag** window.

4. Enter the **Name** and **Description** of the new tag.

5. Click **OK** to create the tag.

The new tag is created and displays on the **Tags** tab.

### Modifying a Tag

You can edit the name and description of a tag.

**Modifying a Tag**

1. Click the **Tags** tab on the left side of the screen.

2. Select the tag you wish to modify.

3. Click **Edit** to open the **Edit Tag** window.

4. Change the **Name** and **Description** fields as necessary.

5. Click **OK** to save the edited tag.

You have modified the properties of a tag.

### Deleting a Tag

When a tag is no longer needed, remove it.

**Deleting a Tag**

1. Click the **Tags** tab on the left side of the screen.

2. Select the tag you wish to delete.

3. Click **Remove** to open the **Remove Tag(s)** window. The message warns you that removing the tag will also remove all descendants of the tag.

4. Click **OK** to delete the selected tag.

You have removed the tag and all its descendants. The tag is also removed from all the objects that it was attached to.

### Adding and Removing Tags to and from Objects

You can assign tags to and remove tags from hosts, virtual machines, and users.

**Adding and Removing Tags to and from Objects**

1. Click the resource tab, and select the object(s) you wish to tag or untag.

2. Click the **Assign Tags** button to open the **Assign Tags** window.

3. Select the check box to assign a tag to the object, or clear the check box to detach the tag from the object.

4. Click **OK**.

The specified tag is now added or removed as a custom property of the selected object(s).

### Searching for Objects Using Tags

1. Enter a search query using `tag` as the property and the desired value or set of values as criteria for the search.

The objects tagged with the specified criteria are listed in the results list.

**Prev:** [Appendix D: oVirt and SSL](../appe-oVirt_and_SSL)<br>
**Next:** [Appendix F: Branding](../appe-Branding)
