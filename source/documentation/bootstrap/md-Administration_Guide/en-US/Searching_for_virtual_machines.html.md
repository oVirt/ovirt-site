# Searching for Virtual Machines

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
