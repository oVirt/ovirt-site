# Searching for Templates

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
