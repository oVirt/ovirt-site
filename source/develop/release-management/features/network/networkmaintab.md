---
title: NetworkMainTab
category: feature
authors:
  - alkaplan
  - danken
  - lpeer
  - moti
  - msalem
  - ykaul
---

# Network Main Tab

## Summary

*   Adding main tab for Networks.
*   Adding Networks to the tree.
*   Adding search strings and queries for Networks.

## Owner

*   Name: Alona Kaplan (alkaplan)
*   Email: <alkaplan@redhat.com>

## Current status

*   Merged to upsream
*   Last update date: 20/10/2012

## Detailed Description

### User Experience

### Tree

#### New items:

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

#### Selected items in the tree that show Networks tab:

*   Networks
*   Network
*   Dc
*   Cluster
*   Host

![](/images/wiki/NetworkTree.png)

### Main-Tab

*   **Display order** - between Host and Storage Tab.
*   **Sort** - first- dc name, second- network name.
*   **Columns**- Name, Data Center, Description (if longer then X chars display "(X-3)..." and the complete description in the tooltip), Role (list of icon + tooltip represent vm network and mgmt network), VLAN tagging (if empty- "-")
*   **Actions**

    * Add, Edit

        * Add - Same as Add network from Data Centers->Logical Networks sub tab. Only change- first field will be "Data Center" combo box. All the dialog under the "Data Center" combo will be refreshed according to the dc change.

        * Edit- Same as Edit network from Data Centers->Logical Networks sub tab. Only change- first field will be disabled "Data Center" combo box.

        * If VM Network or MTU are disabled, a tool tip on each of them sholud explain why.

        * Swap the locations of Vlan tag and VM Network.

    * Remove- (The networks in the remove dialog list will be in format -"network name" in Data Center "dc name" ("description"))

### Sub-Tabs

**General**

*   **Fields**- Name, Id, Description, Role (all dc level roles- comma separated), VLAN tagging (if empty - "none"), MTU (if empty- "host's default")

![](/images/wiki/NetworkTab.png)
**Clusters**- show all the clusters in the dc (first sort- is attahced, second sort- name)

*   **Columns**- Name, Compatibility Version, Network Attached (read only check box), Network Status (icon), Network Required (read only check box), Network Role (icon + tooltip), description.
*   **Actions**

:\*Assign/Unassign Network - Same as Cluster-> Logical Networks-> Assign/Unassign, just instead of networks list, clusters list.
**Hosts**
Have a radio button that will show either

1.  All the hosts in the dc
    -   **Columns**- Status (icon), Name, Cluster, Data Center
    -   **Actions**- SetupNetworks (enabled if cluster compatabily version is 3.1 or more)

2.  All the hosts that this network is attached to (default)
    -   **Columns**- Status (icon), Name, Cluster, Data Center, Nic Status, Nic (nic name, if bond- bond name), Nic Rx, Nic Tx.
    -   **Actions**-SetupNetworks (enabled if cluster compatabily version is 3.1 or more)

3.  All the hosts where this network attached to the cluster but not to the host (Very important for non-required where the host status does not indicate something is missing)
    -   **Columns**- Status (icon), Name, Cluster, Data Center
    -   **Actions**- SetupNetworks (enabled if cluster compatabily version is 3.1 or more)

**Virtual Machines** - All the vms that this network is attached to (if a vm has more then one vnic on the network, there should bee a seperate line in the table for each vnic) (first sort- cluster second sort- name)
\* **Columns**- Status (icon), Name, Cluster, IP Address (list of all host's ip addresses), Vnic status(icon), Vnic, Vnic Rx, Vnic Tx, description (if there is enough place to display it).

*   **Actions**- remove (multipule selection) - enabled if vm is down or vnic not active or cluster's version supports hotplug nic. Opens a confirmation window with a message- "Please note this operation will remove from the vm Vnic 'vnic_name'" (this is a stretch goal and we are not sure we'll add it in 3.2)

**Templates** - All the templates that this network is attached to (if a template has more then one vnic on the network, there should bee a seperate line in the table for each vnic) (first sort- cluster, second sort- name)

*   **Columns**- Name, Status (text), Cluster, Vnic.
*   **Actions**- same as vm (this is a stretch goal and we are not sure we'll add it in 3.2)

**Permissions**

*   **Columns**- User, Role, Inherited Permission
*   **Actions**- Add, Remove

## Search

**Main Tab Search**
SearchType.Network - add relevant search command

**Tree**
Networks:

*   "Network: datacenter.name ='dcName'"

Network:

*   "Network: name = 'treeSelectedNetName' datacenter = 'dcName'"
*   "Cluster: Cluster_network.network_name = 'treeSelectedNetName' Datacenter.name = 'dcName'"
*   "Host : Nic.network_name = 'treeSelectedNetName' datacenter ='dcName'"
*   "Vm : Vnic.network_name = 'treeSelectedNetName' datacenter = 'dcName'"
*   "Template : Vnic.network_name = 'treeSelectedNetName' datacenter = 'dcName'"

DataCenter:

*   "Network: datacenter ='treeSelectedDcName'"

Cluster:

*   "Network: cluster ='treeSelectedClusterName'"

Host:

*   "Network: host ='treeSelectedHostName'"

**Search text area**
Network: (search by network properties)

## Queries

**Queries for the sub tabs**

1.  Clusters
    -   GetVdsGroupsAndNetworksByNetworkIdQuery - returns all the clusters in the dc, if the network is not attached to the cluster cluster_network will be null (VDSGroup + cluster_network)

2.  Hosts
    -   GetVdsByStoragePoolId - returns all the hosts belong to the same dc as the network. (VDS)
    -   GetVdsAndNetworkInterfacesByNetworkIdQuery - returns all the hosts the network is attached to one of their nics. (VdsNetworkInterface + VDS, similar to GetVdsInterfacesByVdsId)
    -   GetVdsWithoutNetworkQuery - All the hosts where this network attached to the cluster but not to the host (VDS)

3.  Virtual Machines
    -   GetVmsAndNetworkInterfacesByNetworkIdQuery - returns all the vms that have at least one vnic on the network. (VmNetworkInterface + VM)

4.  Templates
    -   GetVmTemplatesAndNetworkInterfacesByNetworkIdQuery - returns all the templates that have at least one vnic on the network. (VmNetworkInterface + VmTemplate)

## Documentation / External references

Bugzilla - [(networks_main_tab) Networks Main Tab](https://bugzilla.redhat.com/show_bug.cgi?id=858742)

