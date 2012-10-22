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
*   Last update date: 20/10/2010

### Detailed Description

#### User Experience

#### Tree

##### New items:

1.  **Networks** (a tree item under dc)
    -   Displayed Tabs (the tabs that are displayed when the item is selected in the tree)-
        -   Networks (search criteria- "Network: datacenter = 'dcName'")
    -   Children- all dc networks

2.  **Network** (a tree item under Networks, specific network name)
    -   Displayed Tabs-
        -   Networks (search criteria- *"Network : name = networkName and datacenter = dcName"*)
        -   Clusters (search criteria- *"Clusters : Cluster_network.network_name = treeSelectedNetName and Datacenter.name = dcName"*)
        -   Hosts (search criteria- *"Host: Nic.network_name = 'treeSelectedNetName' and datacenter.name = 'dcName'"*)
        -   Virtual Machines (search criteria- *"VMS : Vnic.network_name = treeSelectedNetName and datacenter = dcName"*)
        -   Templates (search criteria- *"Template: : Vnic.network_name = treeSelectedNetName and datacenter = dcName"*)
    -   Children - none

##### Selected items in the tree that show Networks tab:

*   Networks
*   Network
*   Dc
*   Cluster
*   Host

![](NetworkTree.png "NetworkTree.png")

#### Main-Tab

*   **Display order** - between Host and Storage Tab.
*   **Sort** - first- dc name, second- network name.
*   **Columns**- Name, Data Center, Description (if longer then X chars display "(X-3)..." and the complete description in the tooltip), Role (icon + tooltip), VLAN tagging (if empty- "-")
*   **Actions**

    * Add, Edit

        * Add - Same as Add network from Data Centers->Logical Networks sub tab. Only change- first field will be "Data Center" combo box. All the dialog under the "Data Center" combo will be refreshed according to the dc change.

        * Edit- Same as Edit network from Data Centers->Logical Networks sub tab

        * If VM Network or MTU are disabled, a tool tip on each of them sholud explain why.

        * Swap the locations of Vlan tag and VM Network.

    * Remove- (The networks in the remove dialog list will be in format -"network name" in Data Center "dc name" ("description"))

#### Sub-Tabs

**General**

*   **Fields**- Name, Id, Description, Role (?), VLAN tagging (if empty - "None"), MTU (if empty- "host's default")

![](NetworkTab.png "fig:NetworkTab.png")
**Clusters**- show all the clusters in the dc (first sort- is attahced, second sort- name)

*   **Columns**- Attached (read only check box), Name, Compatibility Version, Network Status (icon ?), Network Required (V icon if yes, empty if no), Network Role (icon)
*   **Actions**

:\*Assign/Unassign Network - Same as Cluster-> Logical Networks-> Assign/Unassign, just instead of networks list, clusters list.
**Hosts**
Have a radio button that will show either

1.  All the hosts in the dc
    -   **Columns**- Status (icon), Name, Cluster, Data Center
    -   **Actions**- SetupNetworks

2.  All the hosts that this network is attached to (default)
    -   **Columns**- Status (icon), Name, Cluster, Data Center, Nic (nic name, if bond- bond name), Nic Rx, Nic Tx.
    -   **Actions**-SetupNetworks

3.  All the hosts where this network attached to the cluster but not to the host (Very important for non-required where the host status does not indicate something is missing)
    -   **Columns**- Status (icon), Name, Cluster, Data Center
    -   **Actions**- SetupNetworks

**Virtual Machines** (default sub tab)- All the vms that this network is attached to
\* **Columns**- Status (icon), Name, Cluster, IP Address (list of all host's ip addresses), Vnic status(icon, if more then one vnic- display the first one status), Vnic (if more than one 'Vnic1...', the Vnic's list will be displayed in the tooltip coma seperated), Vnic Rx(?), Vnic Tx(?), description (? if there is enough place to display it).

*   **Actions**- remove (multipule selection) - enabled if vm is down or cluster's version supports hotplug nic. Opens a confirmation window with a message- "Please note this operation will remove from the vm the Vnics that are using the selected network" (this is a stretch goal and we are not sure we'll add it in 3.2)

**Templates** - All the templates that this network is attached to

*   **Columns**- same as vm except IP Address, Vnic Rx, Vnic Tx
*   **Actions**- same as vm (this is a stretch goal and we are not sure we'll add it in 3.2)

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

1.  Clusters - returns all the clusters the networks is attached to (VDSGroup + cluster_network)
2.  Hosts
    -   returns all the hosts the network is attached to one of their nics. (VDS + vds_interface_view similar to GetVdsInterfacesByVdsId)
    -   All the hosts where this network attached to the cluster but not to the host (VDS)

3.  Virtual Machines
    -   returns all the vms that have at least one vnic on the network. (VM + List<vm_interfaces>)

4.  Templates
    -   returns all the templates that have at least one vnic on the network. (VM + List<vm_interfaces>)

### Documentation / External references

Bugzilla - [(networks_main_tab) Networks Main Tab](https://bugzilla.redhat.com/858742)

<Category:Feature> <Category:Template>
