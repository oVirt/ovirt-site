---
title: Introducing oVirt 4.2.0 Alpha
author: jmarks
tags: oVirt, 4.2.0, release notes
date: 2017-09-19 11:25:00 CET
comments: true
published: true
---

On September 24, the oVirt project released version 4.2.0 Alpha, available for Red Hat Enterprise Linux 7.3, CentOS Linux 7.3, or similar.

**This pre-release version should not be used in production, and is not feature complete.**

oVirt is the open source virtualization solution that provides an awesome KVM management interface for multi-node virtualization. This maintenance version is super stable and there are some nice new features.

READMORE

### what's new in oVirt 4.2.0?

Here's an overview of the new main features:

The **Administration Portal** has been redesigned from scratch using Patternfly, a widely adopted standard in web application design that promotes consistency and usability across IT applications, through UX patterns and widgets. The result is a cleaner, more intuitive and user-friendly user interface. The old horizontal menu has been replaced by a two-level vertical menu. The system tree is gone, and its functionality has been integrated into the vertical menus. Here are some screnshots:

**Dashboard**
![](/images/blog/2017-09-19/adminportal_dashboard.png)

**Virtual Machines View**
![](/images/blog/2017-09-19/adminportal_compute_VMs.png)

**Adding a New Virtual Machine**
![](/images/blog/2017-09-19/adminportal_compute_VM_New.png)

**Storage View**
![](/images/blog/2017-09-19/adminportal_storage.png)


An all new **VM Portal** for non-admin users - designed with React-based UI and Patternfly principles - replaces the existing User Portal. Built with performance and ease of use in mind, the VM Portal keeps the Extended view of the User Portal, and is more streamlined.

A new **High Performance virtual machine** (VM) type has been added to the New VM dialog box in the Administration Portal. By selecting the ‘High Performance’ option in the ‘Optimized for’ field, administrators can effortlessly optimize a VM for high performance workloads.

**Open Virtual Network** (OVN) adds support for Open vSwitch virtual networking. oVirt VMs can now use logical overlay networks defined by OVN, allowing the user to manage and define multiple logical networks via one physical network. OVN is managed either via the oVirt Administration Portal, or REST.  For more information, see the OVN feature page.

oVirt now supports **Nvidia vGPU**, a technology that enables users to shard a GRID capable physical GPU - such as Nvidia Tesla M60 - into a number of smaller instances. Each instance can be assigned to a VM, for GPU-accelerated workloads.

The **ovirt-ansible-roles** package helps users with common administration tasks. All roles can be executed from the command line using Ansible, and some are executed directly from oVirt engine. You can learn how to use oVirt Ansible roles on the oVirt blog.

**Virt-v2v** - the tool that converts VMs from a foreign hypervisor to run on KVM - now supports Debian/Ubuntu based VMs, in addition to the supported RPM and Windows-based VMs. It is available for VDSM hosts running on RHEL 7.4, and from oVirt hosts versions 4.0 and above.

oVirt 4.2 will now use **PostgresSQL 9.5** as its database, for improved performance.


Support is now restored for **Gluster ISO domains**, without the need for NFS which was previously disabled by Gluster.

**Affinity Labels** create a strong/positive affinity between the hosts and VMs to which they are applied. The new Affinity Labels sub tab for clusters, hosts, and VMs in the Administration Portal provides a table view of labels associated with the currently selected entity, as well as the option to add, edit, and delete them. Additionally, existing labels can be added and/or removed from VMs and hosts in their respective new/edit popup dialogs.


For the entire list of features, enhancements, bug fixes, and more, see the [4.2.0 release notes](/release/4.2.0/).
