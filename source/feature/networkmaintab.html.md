---
title: NetworkMainTab
category: feature
authors: alkaplan, danken, lpeer, moti, msalem, ykaul
wiki_category: Feature
wiki_title: Feature/NetworkMainTab
wiki_revision_count: 107
wiki_last_updated: 2013-03-07
wiki_warnings: list-item?
---

# Network Main Tab

### Summary

*   Adding main tab for Networks.
*   Adding Networks to the tree.
*   Adding search strings and queries for Networks.

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last updated date: 20/9/2010

### Detailed Description

#### User Experience

##### Tree

##### New items:

1.  **Networks** (a tree item under dc)
    -   Displayed Tabs-
        -   Network (search string- "Network: datacenter.name = 'dcName'")
    -   Children- all dc networks

2.  **Network** (a tree item under Networks, specific network name)-
    -   Displayed Tabs-
        -   Network (search string- "Network: name = 'networkName' datacenter.name = 'dcName'")
        -   Cluster (search string- "Cluster: network.name = 'network.name' datacenter.name = 'dcName'")
        -   Host (search string- "Host: network.name = 'networkName' datacenter.name = 'dcName'")
        -   Vm (search string- "Vms: network.name = 'networkName' datacenter.name = 'dcName'")
        -   Template (search string- "Template: network.name = 'networkName' datacenter.name = 'dcName'")
    -   Children - none

##### Selected items in the tree that show Networks tab:

*   Networks
*   Network
*   Dc
*   Cluster

#### Main-Tab

*   **Columns**- Name, Data Center, VM Network, VLAN tagging, Description
*   **Actions**-

    * Add - Same as Add network from Data Centers->Logical Networks sub tab. Only change- first field will be "Data Center" combo box. All the dialog under the "Data Center" combo will be refresh according to the dc change.

    * Edit- Same as Edit network from Data Centers->Logical Networks sub tab. Only change- first field will be "Data Center" combo box. All the dialog under the "Data Center" combo will be refresh according to the dc change.

    * Remove

#### Sub-Tabs

**General**

*   **Feilds**- Name, Data Center, Description, VM Network, VLAN tagging, MTU

![](NetworkTab.png "NetworkTab.png")

**Clusters**

*   **Columns**- Name, Compatiblity Version, Network Status, Network Assigned, Network Required, Role
*   **Actions**-

:\*Assign/Unassign Network ![](assignNet.png "fig:assignNet.png")

**Hosts** (list of hosts the network is attached to one of its nicks)

*   **Columns**- "Status image", Name, Cluster, Data Center, Status
*   **Actions**- none

**Virtual Machines** (tree of vms that has at least one vnic attached to the network, under each vm- a list of the vnics attached to the network)

*   **Columns**- Name (Can be expanded to show a list of the vnics the network is attached to) , Cluster, IP Address, Network, Status, Uptime
*   **Actions**- none

![](NetworkVmTreeTab.png "NetworkVmTreeTab.png")

**Templates** (tree of templates that has at least one vnic attached to the network, under each template- a list of the vnics attached to the network)

*   **Columns**- Name (Can be expanded to show a list of the vnics the network is attached to), Status, Cluster, Data Center
*   **Actions**- none

**Permissions**

*   **Columns**- User, Role, Inherited Permission
*   **Actions**- Add, Remove

### Search

### Queries

### Documentation / External references

[Main Tab RFE](https://bugzilla.redhat.com/858742)

<Category:Feature> <Category:Template>
