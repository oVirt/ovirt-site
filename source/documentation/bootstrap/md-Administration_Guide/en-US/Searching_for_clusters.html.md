# Searching for Clusters

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
