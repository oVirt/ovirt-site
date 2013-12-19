---
title: NetworkLabels
category: feature
authors: alkaplan, danken, lvernia, moti, mpavlik
wiki_category: Feature
wiki_title: Features/NetworkLabels
wiki_revision_count: 66
wiki_last_updated: 2014-09-15
---

# Network Labels

### Summary

**Network labels** feature provides the ability to label networks with a label to use that label on the host's interfaces, so the label abstracts the networks from the physical interface/bond which can be labelled with one or more labels.
The host network configuration can be done by manipulating the network label:
\* Labeling a network will attach that network to all hosts interfaces which are tagged with that label.

*   Removing a label from the network will trigger the network removal from all hosts interfaces/bonds which are tagged with that label.
*   Renaming a network label will update all hosts interfaces/bonds which are tagged with that label (either adding or removing that network).

### Owner

*   Name: Moti Asayag
*   Email: <masayag@redhat.com>

### Current status

*   On Design
*   Planned for ovirt-engine-3.4
*   Last updated: ,

### Benefit to oVirt

**Network labels** designed to ease and to simplify the maintenance of a data-center, in respect to hosts network configuration.
With the **Network labels** feature the amount of actions required by the administrator are significantly reduced. Also, in a relative simple manner the host network configuration is kept in-sync with the logical network definition.

### Detailed Description

For simplicity, we'd avoid introducing a 'label' entity. The label will be defined by:

*   A new property 'label' will be added to the network: We start with a single label, and if needed we can extend label on network label to represent few labels.
*   A new property 'labels' will be added to the host interface.
    -   The property 'labels' represents the list of labels that the nic are marked with.
    -   Labeling are permitting only for interfaces or bonds (no vlans/bridge labeling allowed).

The labels represent a varied list of networks, depending on the network assignment to the cluster:
\* The network is defined on the data-center level.

*   Network can be attached to a host only if it is assigned to its cluster.

**For example:**

       networks 'red' and 'blue' labelled 'lbl1'
       network 'red' is assigned to cluster 'A' and 'B'. 
       network 'blue' is assigned to cluster 'B'.
       

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
When the network is labelled prior to labeling the the host interface, labeling the interface will be done as part of the 'Setup Networks' action. The 'Setup Networks' will be the responsible to translate the label into the appropriate list of networks it represents and to validate the correctness of the label.

Defining a network label on network indicates the administrator enhances the usage of the network labels feature to apply a network to all of the hosts carrying the same label on their interfaces.
Hence, no further indication is required add the network to all of the hosts (i.e. by property 'Apply to all hosts').

#### Unlabeling a network or an interface

A network label can be removed either by clearing the label on network update or by removing the label from the host interface via 'setup networks':
\* Removing the label from the host interface will remove all of the networks which are associated to that label.

*   Removing the label from the network will remove the label from all of the interfaces that have this label.
*   In conjunction with the 'apply to all hosts', the network will be removed from all of the labelled interfaces, and the network will be updated on all of the other eligible hosts.

#### Changing a label of a network or an interface

This actions is considered as adding and removing of a network label.
Changing a label of a network will remove it the network from all of the hosts which had their interfaces labelled with the old name and will add that network to any other interface in that data-center tagged with the new label.

#### Pre-'Setup Networks' execution

At the first step of the 'Setup Networks' parameters validation, a translation of the labels to a list of networks will be done.
The translation will rely on the host interface's set of labels.
'Setup Networks' api will support both labeling and attaching the networks to the interface/bond.
 Removing a labelled network from a labelled interface will be blocked, as labelled networks should be managed according to the interface label. In order to remove a network, the administrator should remove the label from the interface and manage the interface individually.

#### Assigning Network to a Cluster

When attaching a labelled network to a cluster, which the label already specified on the cluster's host interfaces will result in adding that network to all of the hosts in that cluster carrying that label on their interfaces.

#### Moving host between clusters

Moving host between cluster that supports 'network labels' to a cluster which doesn't will be blocked if labels are used on that host.
\* Moving a host that uses labels from version greater than 3.0 to cluster 3.0 will be blocked.

#### Network Label constraints

The network labels feature relies on the 'Setup Networks' api to configure the networks on the hosts.
There are certain configurations which aren't supported by the 'Setup Networks' api and defining the network label in that manner will fail the operation and will result in a useless label declaration. The following network configuration on a single interface are prohibited:

1.  Any combination of 2 non-vlan networks:
    1.  2 VM networks
    2.  2 non-VM networks
    3.  VM network and a non-VM network

2.  A VM network and vlan networks

#### User Experience

For managing labels on host level:

*   In Network main tab ---> the 'Hosts sub-tab' will contain a 'labels' column.
*   In 'Setup Networks' dialog an option to adding the *labels* will be added, represented as a tag icon on the interface (left side of the setup networks dialog). Clicking the tag icon opens a new dialog for type the labels, in a drop-down/combo-box which will auto-complete the label name based on other labels that are in use in the same data-center (by hosts or by networks).
*   In host interfaces sub-tab a column *labels* will present the labels.

For managing labels on network level:

*   In 'Add/Edit Network' dialog a new property *label* will be added.
    -   Before submitting, an verification for the validity of the label is being examined: If two networks which are attached to a specific cluster cannot co-exit on the host nic by that label, a warning message will be appeared to the user.
*   In 'network main tab' a *label* icon is added next to the network name, when hovers it displays the label name.

#### REST

##### Host level

The network label on host nic level are represented as a sub-collection of the nic resource:
 /api/hosts/{host:id}/nics/{nic:id}/labels Supported actions:

*   **GET** returns a list of nic's labels
*   **POST** adds a new label and will trigger setupNetworks which will be interpreted to attaching all of the matching labelled networks to the nic.
    -   The setup-networks designed to maintain consistency of the label on the host.

       /api/hosts/{host:id}/nics/{nic:id}/labels/{label:id}

Supported actions:

*   **GET** returns a specific label
*   **DELETE** removes a label from a nic and removes the networks managed by it
    -   The setup-networks designed to maintain consistency of the label on the host.

A representation of **network_label** element:

` `<network_label id="label_name" />

A representation of **network_labels** element:

` `<network_labels>
`   `<network_label id="label_name_1" />
`   `<network_label id="label_name_2" />
` `</network_labels>
       

The user will be able to provide the list of labels per nic via as part of the setupnetworks api:

` `*`/api/hosts/{host:id}/nics/setupnetworks`*

**POST** request example:

<action>
`  `<host_nics>
`    `<host_nic>
`      `<network_labels>
              `<network_label id="label_name_1" />` 
              `<network_label id="label_name_2" />` 
`      `</network_labels>
            ...
`    `</host_nic>
          ...
` `</host_nics>
</action>

##### Network level

The network level are represent as a sub-collection of network:

       /api/networks/{network:id}/labels

Supported actions:

*   **GET** returns all of the labels for a specific network
*   **POST** add a label to network (starting with a single label per network)

       /api/networks/{network:id}/labels/{label:id}

Supported actions:

*   **GET** returns a specific label
*   **DELETE** - removes a label from network

A representation of **network_label** element:

` `<network>
         ...
`   `<network_labels>
`     `<network_label>`lbl1`</network_label>
`   `</network_labels>
         ...
` `<network>

#### Search Engine

For phase 1:

*   A query for all networks which are labelled with specific label will be supported.

For phase 2:

*   A query for all hosts which are labelled with specific label will be supported.

### Dependencies / Related Features

The feature will use the [Multi-Host Network Configuration](Features/MultiHostNetworkConfiguration) feature to achieve its goals.

### Documentation / External references

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

<Category:Feature> <Category:Networking>
