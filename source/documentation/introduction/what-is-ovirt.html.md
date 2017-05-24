---
title: What is oVirt?
authors: laravot
wiki_title: What is oVirt
wiki_revision_count: 4
wiki_last_updated: 2012-12-20
---

<!-- TODO: Content review -->

# What is oVirt?

oVirt is a complete virtualization management platform, licensed and developed as open source software. oVirt builds on the powerful Kernel-based Virtual Machine (KVM) hypervisor, and on the RHEV-M management server released by Red Hat to the open source community.

![](OVirt VMs.png "OVirt VMs.png")

## oVirt compnents

### oVirt node

Highly scalable, Image-based, small-footprint (<200MB) hypervisor with minimized security footprint. more info : www.ovirt.org/OVirt_3.0_Feature_Guide#oVirt_Node

### oVirt engine

Centralized enterprise-grade virtualization management engine with graphical administration console and programming interfaces. more info: www.ovirt.org/OVirt_3.0_Feature_Guide#oVirt_Node

# oVirt architecture

![](Architecture3.jpg "Architecture3.jpg")

# Features (Partial list)

[More oVirt Features](OVirt_3.0_Feature_Guide)

*   VM live migration: Move virtual machines from one server to another without shutting them down! Allows you to easily optimise usage of your hardware.
*   Storage live migration : Move storage from one server to another on the fly.

#### oVirt Node

##### Scalabillity

*   Host scalability: Supported limit of up to 160 Logical CPUs and 2TB per host (platform capable of up to 4,096 logical CPUs/64TB per host)
*   Guest scalability: Supports up to 64 vCPU and 2TB vRAM per guest

##### Performance

*   vhost-net: The KVM networking stack resides within the Linux kernel, which greatly improves performance and reduces latency compared to userspace networking.
*   Async-IO: For block I/O operations, in many cases yielding notable improvement in block I/O.
*   KSM memory overcommitment: allows administrators to define more RAM in their VMs than is present in a physical host.

##### SELinux and Security

*   Security model supports SELinux and new sVirt capabilities, including Mandatory Access Control (MAC) for enhanced virtual machine and hypervisor security.

#### oVirt Engine

##### Software Development Kit

*   The oVirt Engine Software Development Kit provides an enhanced Python environment to support the development of custom software utilizing the APIs exposed by the engine.

##### oVirt API

*   oVirt API all platform commands via an open source, community-driven RESTful API

##### User Portal

*   The oVirt administrator portal provides a graphical management system for administrators to manage virtual machines, templates, desktops, storage, clusters, and datacenters.

##### User Portal

*   Allows for running virtual machines to be moved seamlessly from one host to another within an oVirt cluster.

##### High availability

*   Supports application-level high availability with supported fencing agents.
*   Resiliency policy to control high availability VMs at the cluster level.

##### System scheduler

*   System Scheduler policies for load balancing (automatically balances the VM load among hosts in a cluster) and Power Saver mode (consolidates VM loads onto fewer hosts during non-peak hours).

##### Storage management

*   Supports iSCSI, FC, and NFS shared storage infrastructures
*   Support for transparent block alignment for better performance of virtual disk files on shared and local storage
*   Supports local physical disks and locally attached SAN or other storage supported by standard mpio drivers
*   Supports preallocated (thick-provisioned) disks for optimal performance and thin-provisioned disks for optimal storage usage

##### Migration tools

*   Use virt-v2v tools for automating the conversion of physical servers or unsupported virtual machine formats for use with oVirt.

##### Extensibility

*   Hooks allow for advanced KVM technology to be supported from the oVirt interface.
