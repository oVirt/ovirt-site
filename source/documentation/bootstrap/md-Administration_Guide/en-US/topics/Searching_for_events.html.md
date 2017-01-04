# Searching for Events

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
