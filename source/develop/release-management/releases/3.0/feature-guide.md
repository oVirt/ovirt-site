---
title: oVirt 3.0 Feature Guide
category: documentation
toc: true
authors: jbrooks
---

# oVirt 3.0 Feature Guide

(adapted from RHEV 3.0 feature guide)

oVirt is a complete virtualization management platform, licensed and developed as open source software. oVirt builds on the powerful Kernel-based Virtual Machine (KVM) hypervisor, and on the RHEV-M management server released by Red Hat to the open source community.

## oVirt Node:

*   Image-based, small-footprint (<200MB) hypervisor with minimized security footprint
*   Text-based GUI for enhanced manageability and easy installation

### Scalability

*   Host scalability: Supported limit of up to 160 Logical CPUs and 2TB per host (platform capable of up to 4,096 logical CPUs/64TB per host)
*   Guest scalability: Supports up to 64 vCPU and 2TB vRAM per guest

### Performance

*   vhost-net: The KVM networking stack resides within the Linux kernel, which greatly improves performance and reduces latency compared to userspace networking.
*   Transparent huge pages (THP): The Linux kernel dynamically creates large memory pages (2MB vs. 4KB) for virtual machines, improving performance by reducing the number of times that memory is accessed, typically improving performance for most workloads.
*   x2paic: Paravirtualized interrupt controller in the VM, which reduces guest overhead and can improve guest performance in interrupt-heavy workloads.
*   Async-IO: For block I/O operations, in many cases yielding notable improvement in block I/O.
*   KSM memory overcommitment: allows administrators to define more RAM in their VMs than is present in a physical host.

### SELinux and sVirt security

Security model supports SELinux and new sVirt capabilities, including Mandatory Access Control (MAC) for enhanced virtual machine and hypervisor security.

### Troubleshooting

Supports remote logging (rsyslog) and remote crash analysis (remote kdump)

## oVirt Engine

Centralized enterprise-grade virtualization management engine with graphical administration console and programming interfaces.

### Platform

The engine is now running on Jboss AS7 as the application server.

### oVirt API

oVirt API all platform commands via an open source, community-driven RESTful API

### Software Development Kit

The oVirt Engine Software Development Kit provides an enhanced Python environment to support the development of custom software utilizing the APIs exposed by the engine.

### Admin Portal

The oVirt administrator portal provides a graphical management system for administrators to manage virtual machines, templates, desktops, storage, clusters, and datacenters.

User interface features include:

*   Tree-view for hierarchical management of the oVirt environment
*   Tag and bookmark capabilities
*   Query engine for searching for oVirt objects
*   Extensive event monitoring
*   Rich dialog boxes, including a network bonding dialog box to ease configuration of multiple virtual networks

### User Portal

The oVirt user portal provides standard and power user access to the oVirt environment

### Live migration

*   Allows for running virtual machines to be moved seamlessly from one host to another within an oVirt cluster.
*   Now supports VM-level “Do Not Migrate” option and VM-host pinning.

### High availability

Allows critical VMs to be restarted on another host in the event of hardware failure with three levels of priority, taking into account resiliency policy.

*   Resiliency policy to control high availability VMs at the cluster level.
*   Supports application-level high availability with supported fencing agents.

### Maintenance mode

Allows for one-click VM migration to put an oVirt hypervisor host in maintenance mode for upgrade or hardware updates.

### System scheduler

System Scheduler policies for load balancing (automatically balances the VM load among hosts in a cluster) and Power Saver mode (consolidates VM loads onto fewer hosts during non-peak hours).

## Desktop Management Features

*   User Portal for connecting oVirt users to their virtual machines.
*   SPICE open source remote rendering protocol for presentation of desktop environment to supported thin clients and PCs.
*   Enhanced network performance for desktop virtualization, including new dynamic and variable compression algorithms for higher latency, lower bandwidth WAN environments.
*   Enhanced Linux desktop support for auto-resizing, guest agent reporting, and single sign-on (on supported guests)
*   Enhancements to user experience, including higher supported screen resolutions and dynamic copy-and-paste
*   Desktop pooling for deployment of multiple desktop VMs from templates

## Storage management

*   Supports iSCSI, FC, and NFS shared storage infrastructures
*   Support for transparent block alignment for better performance of virtual disk files on shared and local storage
*   Supports local physical disks and locally attached SAN or other storage supported by standard mpio drivers
*   Supports preallocated (thick-provisioned) disks for optimal performance and thin-provisioned disks for optimal storage usage

## User and group-based security

*   Supports Red Hat Directory Server, FreeIPA or Microsoft Active Directory for user and administrator authentication to oVirt Engine
*   Granular, inheritable, multi-level administration security roles to all actions and objects in the platform

## Migration tools

Use [virt-v2v](http://libguestfs.org/virt-v2v/) tools for automating the conversion of physical servers or unsupported virtual machine formats for use with oVirt.

## Extensibility

Hooks allow for advanced KVM technology to be supported from the oVirt interface. Sample hooks available in this [git repository](http://gerrit.ovirt.org/gitweb?p=vdsm.git;a=tree;f=vdsm_hooks).

## System Requirements

TK

<category:collateral>
