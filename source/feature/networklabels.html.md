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

Network labels allow to tag networks with a label and to use that label on the host's interface, so the label abstracts the networks from the physical interface:
The host network configuration can be done by manipulating the network label:

*   Tagging a network with label will attach that network to all hosts nics which are tagged with that label.
*   Removing a tag from the network will trigger its removal from all hosts nics which are tagged with that label.
*   Modifying a network will update all hosts nics which are tagged with that label.

### Owner

*   Name: Moti Asayag
*   Email: <masayag@redhat.com>

### Current status

*   On Design
*   Planned for ovirt-engine-3.4
*   Last updated: ,

### Detailed Description

*   A new property 'labels' will be added to the network.
*   A new property 'labels' will be added to the host interface.

The property 'labels' represents the list of labels that the network/nic are marked with.
Both network/nics can be marked with few labels.
 The labels represent a varied list of networks, according to the cluster network assignment:
\* The network is defined on the data-center level.

*   Network can be attached to a host only if it is assigned to a cluster.

For example:

       label 'users' is tagged on 'red' and 'blue'
       network 'red' is assigned to cluster A and B. 
       network 'blue' is assigned to cluster B.
       

Therefore label 'users' represents only network 'red' in the context of cluster A and represents 'red' and 'blue' in the context of cluster B.
Once network 'blue' is assigned to cluster A, label 'users' will stand for it as well as for network 'red'. Therefore it should trigger adding the network 'red' to all of the hosts in the cluster which their interfaces are labelled 'users'.
If network 'blue' will be unassigned from cluster B, label 'users' will represents only network 'red'. Therefore it should trigger the removal of network 'blue' from all of the hosts in the cluster which their interfaces are labelled 'users'.
 When a change is made to the network labels field, it will trigger an action for all of the hosts which one of their interfaces is labelled with the same label:

       Network 'red' - label A
       Network 'blue' - labels A,B
       
       Host X - eth0 - label A
       Host Y - bond0 - label A,B
       
       * Removing 'label A' from Network A will trigger the removal of 'red' from eth0 (Host X) and from bond0 (Host Y)
       * Adding network 'green' with label A will trigger the addition of 'green' to eth0 (Host X) and to bond0 (Host Y)

### Benefit to oVirt

The main advantages of the feature is to ease and simplify the maintenance of a data-center with multiple hosts.
The amount of request actions by the administrator are significantly reduced and in a relative simple manner the host network configuration is kept in-sync with the logical network definition.

#### User Experience

*   In 'Add/Edit VM' dialog a new property *labels* will be added.
*   In 'network main tab' a *labels* column will present the labels.
*   In Network main tab ---> the 'Hosts sub-tab' will contain a 'labels' column.
*   In 'Setup Networks' dialog a new property *labels* will be added.
*   In host interfaces sub-tab a column *labels* will present the labels.

#### REST

TBD

#### Search Engine

For phase 2:

*   A query for all hosts which are labelled with specific label will be supported.
*   A query for all networks which are labelled with specific label will be supported.

### Dependencies / Related Features

The feature will use the [Edit Provisioned Network](Features/EditProvisionedNetwork) feature to achieve its goals.

### Documentation / External references

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

<Category:Feature>
