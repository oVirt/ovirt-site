---
title: Architecture
category: architecture
authors: abonas, alonbl, amuller, dneary, geoffoc, lhornyak, ovedo, sven, vszocs
wiki_category: Architecture
wiki_title: Architecture
wiki_revision_count: 45
wiki_last_updated: 2014-12-07
---

# Architecture

## Overview

The diagrams and descriptions that follow represent the idealized long term architecture of the oVirt project. The actual releases may or may not exhibit all of the features / interactions shown on this page, since development is a moving target, and not yet complete.

## Managed node architecture

A managed node provides a host on which virtual machines will run. In fully managed node, all remote communication will take place over the AMQP protocol, via a QPid broker. In standalone mode, remote communication will take place over the native RPC mechanisms of each component. In both modes, further network services are used for NFS, iSCSI and SNMP.

![](Ovirt-node.png "Ovirt-node.png")

## Administration node architecture

The administration node is intended to have the flexibility to be deployed in a variety of configurations. In its simplest deployment everything on the diagram below can be deployed into a single physical node. For a redundant architecture, with scope for horizontal scalability & high availablity, it is possible to deploy nearly every piece on its own physical node.

![](Ovirt-admin.png "Ovirt-admin.png")

## Logical communication for backend services

This shows the logical communication for backend services between the oVirt admin node and managed nodes. This includes taskomatic job processing & domain monitoring / events.

![](Ovirt-arch-logical-backend.png "Ovirt-arch-logical-backend.png")

## Logical communication for identity / authentication services

This shows the logical communication for the identify / authentication services. At the center of everything is the IPA node providing Kerberos and LDAP services

![](Ovirt-arch-logical-ipa.png "Ovirt-arch-logical-ipa.png")

## Logical communication for network services

This shows the logical communication for core network services of DNS, NTP, etc

![](Ovirt-arch-logical-netserv.png "Ovirt-arch-logical-netserv.png")

## Logical communication for provisioning services

This shows the logical communication between backend components during provisioning of managed nodes and guest machines

![](Ovirt-arch-logical-provision.png "Ovirt-arch-logical-provision.png")

## Logical communication for frontend administrator UI

This shows the logical communication for the frontend web / console UI used by administrators

![](Ovirt-arch-logical-webui.png "Ovirt-arch-logical-webui.png")

## Physical network architecture

The idealized network architecture involves at least 3 seperate networks, one for guest VM traffic, one for host management traffic, and one for storage. In a small deployment all three may be consolidated into a single network, but it is highly recommended to keep storage traffic separate. In a very large scale deployment there may be multiple guest VM networks, both physical and VLAN backed

![](Ovirt-arch-physical.png "Ovirt-arch-physical.png")

<Category:Architecture> <Category:Node>
