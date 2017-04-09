---
title: About oVirt
category: documentation
layout: toc
authors: bproffitt, dneary
wiki_category: Documentation
wiki_title: About oVirt
wiki_revision_count: 4
wiki_last_updated: 2014-03-17
---

<!-- TODO: Content review -->

# About oVirt

oVirt is a virtualization management application. That means that you can use the oVirt management interface ([ the oVirt engine](Engine)) to manage hardware nodes, storage and network resources, and to deploy and monitor virtual machines running in your data center.

If you are familiar with VMware products, it is conceptually similar to vSphere. oVirt serves as the bedrock for Red Hat's Enterprise Virtualization product, and is the "upstream" project where new features are developed in advance of their inclusion in that supported product offering.

To get started with oVirt, follow our [ quick start guide](Download) and check out our [ getting started](Quick Start Guide) documentation.

# oVirt Features

*   Manage multiple virtual machines
*   Sophisticated user interface allows management of all aspects of your datacenter
*   Choice of means of allocation of VMs to hosts: manual, "optimised", pinned
*   Live migration of VMs from one hypervisor to another
*   Add new hypervisor nodes easily and centrally
*   Monitor resource usage on VMs
*   Manage quotas for use of resources (storage, compute, network)
*   Self-service console for simple and advanced use cases
*   Built on KVM hypervisor
*   Open source, you are welcome to participate in the design and development of project

# oVirt Engine

![](admin-portal-label.png)

1.  **Header**: This bar contains the name of the logged in user, the sign out button, the option to configure user roles.
2.  **Navigation Pane**: This pane allows you to navigate between the Tree, Bookmarks and Tags tabs. In the Tree tab, tree mode allows you to see the entire system tree and provides a visual representation your virtualization environment's architecture.
3.  **Resources Tabs**: These tabs allow you to access the resources of oVirt. You should already have a Default Data Center, a Default Cluster, a Host waiting to be approved, and available Storage waiting to be attached to the data center.
4.  **Results List**: When you select a tab, this list displays the available resources. You can perform a task on an individual item or multiple items by selecting the item(s) and then clicking the relevant action button. If an action is not possible, the button is disabled.
5.  **Details Pane**: When you select a resource, this pane displays its details in several subtabs. These subtabs also contain action buttons which you can use to make changes to the selected resource.

