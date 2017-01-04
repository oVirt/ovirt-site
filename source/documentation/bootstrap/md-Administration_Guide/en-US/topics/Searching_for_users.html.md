# Searching for Users

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
