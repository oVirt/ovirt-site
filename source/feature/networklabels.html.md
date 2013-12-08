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
\* Labelling a network will attach that network to all hosts interfaces which are tagged with that label.

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

*   A new property 'labels' will be added to the network: We start with a single label, and if needed we can extend label on network label to represent few labels.
*   A new property 'labels' will be added to the host interface.
    -   Labelling are permitting only for interfaces or bonds (no vlans/bridge labelling allowed).

The property 'labels' represents the list of labels that the network/nic are marked with.
Both network/nics can be marked with multiple labels.
 The labels represent a varied list of networks, depending on the network assignment to the cluster:
\* The network is defined on the data-center level.

*   Network can be attached to a host only if it is assigned to a cluster.

**For example:**

       networks 'red' and 'blue' labelled 'lbl1'
       network 'red' is assigned to cluster 'A' and 'B'. 
       network 'blue' is assigned to cluster 'B'.
       

Therefore in the context of cluster 'A' label 'lbl1' represents only network 'red' and in the context of cluster 'B' it represents 'red' and 'blue'.
Once network 'blue' is assigned to cluster 'A', label 'lbl1' will stand for it as well as for network 'red'. Assigning 'blue' to cluster 'A' triggers adding the network 'red' to all of the hosts interfaces in the cluster which are labelled 'lbl1'.
If network 'blue' will be unassigned from cluster 'B', label 'lbl1' will represent only network 'red'. Therefore it should trigger the removal of network 'blue' from all of the hosts interfaces in the cluster which are labelled 'lbl1'.
 **More examples:** When a change is made to the network labels field, it will trigger an action for all of the hosts which one of their interfaces is labelled with the same label:

       Network 'red' - lbl1
       Network 'blue' - lbl1,lbl2
       
       Host X - eth0 - lbl1
       Host Y - bond0 - lbl1,lbl2
       
       * Removing 'lbl1' from network 'red' will trigger the removal of network 'red' from eth0 (Host X) and from bond0 (Host Y)
       * Adding network 'green' with label 'lbl1' will trigger the addition of network 'green' to eth0 (Host X) and to bond0 (Host Y)
       * Adding network 'yellow' with label 'lbl2' will trigger the addition of network 'yellow' only to bond0 (Host Y)

The network label should contain only numbers, digits, dash or underscore (comply with the pattern [0-9a-zA-Z_-]+).

#### Adding a network label

When the host interface is the first to be labelled and later on a new network is labelled with the same label, the 'Add Network' action will trigger the attachment of the network to all of the hosts.
When the network is labelled prior to labelling the the host interface, labelling the interface will be done as part of the 'Setup Networks' action. The 'Setup Networks' will be the responsible to translate the label into the appropriate list of networks it represents and to validate the correctness of the label.

If the network is labelled with 2 labels and on of these labels already tagged on the host, tagging the host with the second label will have no impact on the host.
Removing that label will also have no impact on the host.
 Defining a network label on network indicates the administrator enhances the usage of the network labels feature to apply a network to all of the hosts carrying the same label on their interfaces.
Hence, no need to specify explicitly the desire to add the network to all of the hosts (i.e. by property 'Apply to all hosts').

#### Deleting a network label

A network label can be removed either by updating the network and removing the label or by removing the label from the host interface.
The property 'Apply to all hosts' (introduced in [Edit Provisioned Network feature](Features/EditProvisionedNetwork#Phase_1)) will be reused in 'Update Network' operation to notate the network should be removed from all of the hosts.
Deleting the label from the host interface will not cause the removal of the networks which are already attached to that interface. However, it will cause the host interface not to be managed according to that label any more.

#### Renaming a network label

This actions is considered as adding and removing of a network label.
In order not to cause the removal of the network from all of the hosts, rename should be done on the hosts first, or not to mark the 'Apply to all hosts' checkbox when renaming the label on 'Edit Network'.

#### Pre-'Setup Networks' execution

At the first step of the 'Setup Networks' parameters validation, a translation of the labels to a list of networks will be done.
The translation will rely on the host interface's set of labels.
'Setup Networks' api will support both labelling and attaching the networks to the interface/bond.
 The administrator will be capable to remove a network which is attached to the interface, even if the network and the interface itself are labelled.
If the label remains on the host, next action on that network marked to be applied to all hosts will add that network to the host.

#### Assign Network to Cluster

When attaching a labelled network to a cluster, which the label already specified on the cluster's host interfaces will result in adding that network to all of the hosts.

#### Network Label constraints

The network labels feature relies on the 'Setup Networks' api to configure the networks on the hosts.
There are certain configurations which aren't supported by the 'Setup Networks' api and the defining the network label in that manner will fail the operation and will result in a useless label declaration. The following network configuration on a single interface are prohibited:

1.  Any combination of 2 non-vlan networks:
    1.  2 VM networks
    2.  2 non-VM networks
    3.  VM network and a non-VM network

2.  A VM network and vlan networks

#### User Experience

*   In Network main tab ---> the 'Hosts sub-tab' will contain a 'labels' column.
*   In 'Setup Networks' dialog a new property *labels* will be added.
*   In host interfaces sub-tab a column *labels* will present the labels.

For managing labels on network level: Alternative 1:

*   In 'Add/Edit VM' dialog a new property *labels* will be added.
*   In 'network main tab' a *labels* column will present the labels.

Alternative 2:

*   In 'Add/Edit VM' dialog a 'labels' left tab will be added, using the Add/Remove row widget to manage the labels.

#### REST

Defining network label on host level is done via POST */api/hosts/{host:id}/nics/setupnetworks* :

<action>
`  `<host_nics>
`    `<host_nic>
`      `<network_labels>
`        `<network_label>`lbl1`</network_label>
`        `<network_label>`lbl2`</network_label>
`        `<network_label>`lbl3`</network_label>
`      `</network_labels>
          ...
`    `</host_nic>
          ...
` `</host_nics>
</action>

The host interface will also contain the network labels when performing GET for an interface which is labelled in */api/hosts/{host:id}/nics/{nic:id}* :

` `<host_nic>
`   `<network_labels>
`     `<network_label>`lbl1`</network_label>
`     `<network_label>`lbl2`</network_label>
`     `<network_label>`lbl3`</network_label>
`   `</network_labels>
         ...
` `</host_nic>

On the network level either via POST to */api/networks/* or via PUT to */api/networks/{network:id}*:

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

The feature will use the [Edit Provisioned Network](Features/EditProvisionedNetwork) feature to achieve its goals.

### Documentation / External references

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

<Category:Feature>
