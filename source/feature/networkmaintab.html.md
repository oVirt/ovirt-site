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
*   Last update date: 20/9/2010

### Detailed Description

#### User Experience

#### Tree

##### New items:

1.  **Networks** (a tree item under dc)
    -   Displayed Tabs (the tabs that are displayed when the item is selected in the tree)-
        -   Networks (search criteria- "Network: datacenter.name = 'dcName'")
    -   Children- all dc networks

2.  **Network** (a tree item under Networks, specific network name)
    -   Displayed Tabs-
        -   Networks (search criteria- "Network: name = 'treeSelectedNetName' datacenter.name = 'dcName'")
        -   Clusters (search criteria- "Cluster: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'")
        -   Hosts (search criteria- "Host: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'")
        -   Virtual Machines (search criteria- "Vms: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'")
        -   Templates (search criteria- "Template: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'")
    -   Children - none

##### Selected items in the tree that show Networks tab:

*   Networks
*   Network
*   Dc
*   Cluster
*   Host

![](NetworkTree.png "NetworkTree.png")

#### Main-Tab

*   **Columns**- Name, Data Center, VM Network, VLAN tagging, Description
*   **Actions**

    * Add - Same as Add network from Data Centers->Logical Networks sub tab. Only change- first field will be "Data Center" combo box. All the dialog under the "Data Center" combo will be refreshed according to the dc change.

    * Edit- Same as Edit network from Data Centers->Logical Networks sub tab.

    * Remove

#### Sub-Tabs

**General**

*   **Fields**- Name, Description, VM Network, VLAN tagging, MTU

![](NetworkTab.png "fig:NetworkTab.png")
**Clusters**

*   **Columns**- Name, Compatibility Version, Network Status, Network Assigned, Network Required, Network Role
*   **Actions**

:\*Assign/Unassign Network ![](assignNet.png "fig:assignNet.png")
**Hosts** (list of hosts the network is attached to one of its NICs)
Have a radio button that will show either

1.  All the hosts that this network is attached to
    -   **Columns**- "Status image", Name, Cluster, Data Center, Status
    -   **Actions**- Remove (detaches the network from the nic/bonds on the host)

2.  All the hosts where this network attached to the cluster but not to the host (Very important for non-required where the host status does not indicate something is missing)
    -   **Columns**- "Status image", Name, Cluster, Data Center, Status
    -   **Actions**- SetupNetworks (link to SetupNetworks window)

**Virtual Machines** (tree of VMs that have at least one vNIC attached to the network; under each VM - a list of the vNICs attached to the network) Have a radio button that will show either

1.  All the vms that this network is attached to
    -   **Columns**- Name, ,nic (if more than one 'multiple'), Cluster, IP Address, Network, Status, Uptime
    -   **Actions**- remove (multipule selection), remove from all

2.  All the vms where this network is not attached to
    -   **Columns**- Name, Cluster, IP Address, Network, Status, Uptime
    -   **Actions**- add (multiple selection)

![](NetworkVmTreeTab.png "fig:NetworkVmTreeTab.png")
**Templates** (same as vm)

*   **Columns**- same as vm except IP Address and Uptime
*   **Actions**- same as vm

**Permissions**

*   **Columns**- User, Role, Inherited Permission
*   **Actions**- Add, Remove

### Search

**Main Tab Search**
SearchType.Network - add relevant search command

**Tree**
Networks: 1.2 Have a remove button for 1.1.1, ManageNetworks button for 1.1.2. Simple add will not do since you don't know where to add.

*   "Network: datacenter.name ='dcName'"

Network:

*   "Network: name = 'treeSelectedNetName' datacenter.name = 'dcName'"
*   "Cluster: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'"
*   "Host: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'"
*   "Vms: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'"
*   "Template: network.name = 'treeSelectedNetName' datacenter.name = 'dcName'"

**Search text area**
Network: (search by network properties)

### Queries

**Queries for the sub tabs**

1.  Clusters - returns all the clusters the networks is attached to.
2.  Hosts- returns all the hosts the network is attached to one of their nics.
3.  Virtual Machines- returns all the vms that have at least one vnic on the network.
4.  Templates- returns all the templates that have at least one vnic on the network.

### Documentation / External references

Bugzilla - [(networks_main_tab) Networks Main Tab](https://bugzilla.redhat.com/858742)

<Category:Feature> <Category:Template>
