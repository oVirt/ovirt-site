---
title: NetworkLabels
category: feature
authors: alkaplan, danken, lvernia, moti, mpavlik
feature_name: Network Labels
feature_modules: Networking
feature_status: Released
---

# Network Labels

## Summary

**Network labels** feature provides the ability to label networks and to use that label on the host's interfaces, so the label abstracts the networks from the physical interface/bond (which can be labelled with one or more labels).
The host network configuration can be done by manipulating the network label:
\* Labeling a network will attach that network to all hosts interfaces which are tagged with that label.

*   Removing a label from the network will trigger the network removal from all hosts interfaces/bonds which are tagged with that label.

## Owner

*   Name: Moti Asayag (masayag)
*   Email: masayag@redhat.com

## Benefit to oVirt

**Network labels** designed to ease and to simplify the maintenance of a data-center, in respect to hosts network configuration.
With the **Network labels** feature the amount of actions required by the administrator are significantly reduced. Also, in a relative simple manner the host network configuration is kept in-sync with the logical network definition.

## Detailed Description

For simplicity, we'd avoid introducing a 'label' entity. The label will be defined by:

*   A new property 'label' will be added to the network: We start with a single label, and if needed we can extend label on network label to represent few labels.
*   A new property 'labels' will be added to the host interface.
    -   The property 'labels' represents the list of labels that the NIC are marked with.
    -   On **host** labeling is allowed only for physical interfaces or bonds (VLANs/bridge labeling is not allowed).

The labels represent a varied list of networks, depending on the network assignment to the cluster:
\* The network is defined on the data-center level.

*   Network can be attached to a host only if it is assigned to its cluster.

**For example:**

       networks 'red' and 'blue' labelled 'lbl1'
       network 'red' is assigned to a cluster 'A' and 'B'. 
       network 'blue' is assigned to a cluster 'B'.
       

Therefore in the context of cluster 'A' label 'lbl1' represents only network 'red' and in the context of cluster 'B' it represents 'red' and 'blue'.
Once network 'blue' is assigned to cluster 'A', label 'lbl1' will stand for it as well as for network 'red'. Assigning 'blue' to cluster 'A' triggers adding the network 'red' to all of the hosts interfaces in the cluster which are labelled 'lbl1'.
If network 'blue' will be unassigned from cluster 'B', label 'lbl1' will represent only network 'red'. Therefore it should trigger the removal of network 'blue' from all of the hosts interfaces in the cluster which are labelled 'lbl1'.
 **More examples:** When a change is made to the network label, it will trigger an action for all of the hosts which one of their interfaces is labelled with the same label:

       Network 'red' - lbl1
       Network 'blue' - lbl1
       
       Host X - eth0 - lbl1
       Host Y - bond0 - lbl1
       
       * Removing 'lbl1' from network 'red' will trigger the removal of network 'red' from eth0 (Host X) and from bond0 (Host Y)
       * Adding network 'green' with label 'lbl1' will trigger the addition of network 'green' to eth0 (Host X) and to bond0 (Host Y)

The network label should contain only numbers, digits, dash or underscore (comply with the pattern [0-9a-zA-Z_-]+).

#### Labeling a network or an interface

When the host interface is the first to be labelled and later on a new network is labelled with the same label, the 'Assign Network to cluster' action will trigger the attachment of the network to all of the hosts carrying that label on one of their interfaces.
When the network is labelled prior to labeling the host interface, labeling the interface will be done as part of the 'Setup Networks' action. The 'Setup Networks' will be the responsible to translate the label into the appropriate list of networks it represents and to validate the correctness of the label.

Defining a network label on network indicates the administrator enhances the usage of the network labels feature to apply a network to all of the hosts carrying the same label on their interfaces.
Hence, no further indication is required add the network to all of the hosts (i.e. by property 'Apply to all hosts').

#### Unlabeling a network or an interface

A network label can be removed either by clearing the label on network update or by removing the label from the host interface via 'setup networks':
\* Removing the label from the host interface will remove all of the networks which are associated to that label.

*   Removing the label from the network will remove the network from all of the interfaces that have this label.

#### Changing a label of a network or an interface

This actions is considered as adding and removing of a network label.
Changing a label of a network will remove it the network from all of the hosts which had their interfaces labelled with the old name and will add that network to any other interface in that data-center tagged with the new label.

#### Pre-'Setup Networks' execution

At the first step of the 'Setup Networks' parameters validation, a translation of the labels to a list of networks will be done.
The translation will rely on the host interface's set of labels.
'Setup Networks' API will support both labeling and attaching the networks to the interface/bond.
 Removing a labelled network from a labelled interface will be blocked, as labelled networks should be managed according to the interface label. In order to remove a network, the administrator should remove the label from the interface and manage the interface individually.

#### Assigning Network to a Cluster

When attaching a labelled network to a cluster, which the label already specified on the cluster's host interfaces will result in adding that network to all of the hosts in that cluster carrying that label on their interfaces.

#### Detaching Network from a Cluster

When a labelled network is detached from a cluster, the network will be removed from any labelled interface within that cluster.

#### Moving host between clusters

Moving host between cluster that supports 'network labels' to a cluster which doesn't will be blocked if labels are used on that host.
\* Moving a host that uses labels from version greater than 3.0 to cluster 3.0 will be blocked.

## Networks with roles

If a labeled network is marked on a cluster to act as a display network or migration network, it will be configured on the host via the label with a DHCP boot protocol, so the host will be able to get an IP address automatically for that network. This is a limitation for role networks, and without IP address, the host will not be able to serve vms.

#### Network Label constraints

The network labels feature relies on the 'Setup Networks' API to configure the networks on the hosts.
There are certain configurations which aren't supported by the 'Setup Networks' API and defining the network label in that manner will fail the operation and will result in a useless label declaration. The following network configuration on a single interface are prohibited:

1.  Any combination of 2 non-vlan networks:
    1.  2 VM networks
    2.  2 non-VM networks
    3.  VM network and a non-VM network

2.  A VM network and vlan networks

#### User Experience

For managing labels on host level:

*   In Network main tab ---> the 'Hosts sub-tab', the 'Network Device' column will contain tag image if the network is attached to the host via label.
*   In 'Setup Networks' dialog an option to adding the *labels* will be added, represented as a tag icon on the interface (left side of the setup networks dialog). Clicking the tag icon opens a new dialog for type the labels, in a drop-down/combo-box which will auto-complete the label name based on other labels that are in use in the same data-center (by hosts or by networks).
*   In host interfaces sub-tab, 'name' or 'bond' column will contain tag image if the interface have label. The tooltip of the tag image will contain the list of the labels on this interface.

For managing labels on network level:

*   In 'Add/Edit Network' dialog a new property *label* will be added.
    -   Before submitting, an verification for the validity of the label is being examined: If two networks which are attached to a specific cluster cannot co-exit on the host nic by that label, a warning message will be appeared to the user.
*   In 'network main tab' a *label* icon is added next to the network name, when hovers it displays the label name.

|---------------------------------------|-----------------------------------|---------------------------------------------|------------------------------------------|
| ![ thumb](/images/wiki/LabelNetwork.png  " thumb") | ![ thumb](/images/wiki/LabelNic.png  " thumb") | ![ thumb](/images/wiki/LabelSetupNetworks.png  " thumb") | ![ thumb](/images/wiki/LabelInterfaces.png  " thumb") |

#### REST

##### Host level

The network label on host nic level are represented as a sub-collection of the nic resource:
 /api/hosts/{host:id}/nics/{nic:id}/labels Supported actions:

*   **GET** returns a list of nic's labels
*   **POST** adds a new label and will trigger setupNetworks which will be interpreted to attaching all of the matching labelled networks to the nic.
    -   The setup-networks designed to maintain consistency of the label on the host.

`/api/hosts/{host:id}/nics/{nic:id}/labels/{label:id}`

Supported actions:

*   **GET** returns a specific label
*   **DELETE** removes a label from a nic and removes the networks managed by it
    -   The setup-networks designed to maintain consistency of the label on the host.

A representation of **label** element:

```xml
 <label id="label_name" />
```

A representation of **labels** element:

```xml
 <labels>
   <label id="label_name_1" />
   <label id="label_name_2" />
 </labels>
```

###### Phase 2 (when UI will use the RESTAPI)

The user will be able to provide the list of labels per nic via as part of the setupnetworks API:

`/api/hosts/{host:id}/nics/setupnetworks`

**POST** request example:

```xml
<action>
  <host_nics>
    <host_nic>
      <labels>
              <label id="label_name_1" /> 
              <label id="label_name_2" /> 
      </labels>
            ...
    </host_nic>
          ...
 </host_nics>
</action>
```

##### Network level

The network level are represent as a sub-collection of network:

`/api/networks/{network:id}/labels`

Supported actions:

*   **GET** returns all of the labels for a specific network
*   **POST** add a label to network (starting with a single label per network)

`/api/networks/{network:id}/labels/{label:id}`

Supported actions:

*   **GET** returns a specific label
*   **DELETE** - removes a label from network

A representation of **label** element:

```xml
 <network>
         ...
   <labels>
     <label>lbl1</label>
   </labels>
         ...
 <network>
```

#### Search Engine

For phase 1:

*   A query for all networks which are labelled with specific label will be supported.

For phase 2:

*   A query for all hosts which are labelled with specific label will be supported.

## Dependencies / Related Features

The feature will use the [Multi-Host Network Configuration](/develop/release-management/features/network/multihostnetworkconfiguration.html) feature to achieve its goals.

## Documentation / External references

## Testing

Testing can be done on a host with 1 nic - it requires to define the management network on the data-center level as non-vm network. If there are more than a single nic, the management network can be a vm network. The constraint is due to the fact that no mix of vm network (non-tagged) can co-exist on the same nic with any other network type.

Via API:

1.  Set label 'lbl' to network 'red' and 'blue' (both vlan) and attach them to cluster X: **POST** `<label id="lbl"/>` to `/api/networks/{network:id}/labels` for each network.
2.  Send a **POST** label request to an unassigned host's nic in that cluster to `/api/hosts/{host:id}/nics/{nic:id}/labels`: `<label id="lbl"/>`
3.  Verify label is created
4.  Verify networks 'red' and 'blue' were attached to the labeled nic.
5.  Delete 'lbl' from that nic by sending a **DELETE** to `/api/hosts/{host:id}/nics/{nic:id}/labels/lbl`
6.  Verify both 'red' and 'blue' were removed from that host.

Via Webadmin:

1.  Label vlan network 'green' with label 'aaa', assign the network to a cluster where the host resides.
2.  Label nic on host cluster via 'setup networks' dialog
3.  Verify 'green' was automatically dragged on that nic.
4.  Confirm the action, and verify 'green' appears on top of that host in the host's interface sub-tab.
5.  Detach 'green' from that cluster
6.  Verify 'green' is no longer configured on that host
7.  Attach 'green' to that cluster
8.  Verify 'green' is no configured on that host.

The test can be expanded to several hosts, and to multiple actions (all networks should be tagged/vlan) such as:

1.  Label host nics with labels 'aaa' and 'bbb'
2.  Label networks X and Y with 'aaa' and A and B with 'bbb'.
3.  Via the cluster tab, select the target cluster and from the networks sub tab open click the 'manage networks' button
4.  Check X, Y, A and B to be assigned to that cluster and confirm.
5.  Open setup networks dialog of that host and verify the networks were properly attached to the nics by the label
6.  From the same 'manage networks' dialog detach networks X and A from the cluster
7.  Confirm networks X and A were removed from the host, and only networks Y and B are assigned.
8.  Edit X network and remove the label from it.
9.  Verify network X was removed from the host.
10. Edit X network and label it with 'bbb'.
11. Verify network X was configured on the host.

