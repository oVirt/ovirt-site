---
title: oVirt 3.4 Release Announcement
authors: bproffitt, gustavo.pedrosa
---

# oVirt 3.4 Release Announcement

The oVirt project, the open-source, openly governed KVM virtualization management project, today announced the general availability of oVirt 3.4, a community-driven open virtual datacenter management platform. This latest community release includes several new features, including hosted engine; improved storage and scheduling; and a preview of hot-plug CPU and PPC64 support features.

Developed by a global community, oVirt offers advanced virtualization capabilities, including high availability, live migration, live storage migration, the ability to schedule and control the deployment of virtual machines, and more. As the upstream development project for Red Hat Enterprise Virtualization, oVirt’s integrated virtualization enables cost savings for enterprises without the need to re-develop applications to conform to cloud platforms' APIs. oVirt also shares services with Red Hat’s cloud solutions including RDO, Red Hat's community OpenStack distribution, to improve key building blocks for private and public cloud deployments and allow upstream developments to make their way into Red Hat’s enterprise-hardened cloud and virtualization solutions.

**\1**

**Improved storage, scheduling and management:** oVirt 3.4 is designed to manage multiple storage domains, allowing users to mix different types of shared storage in the same datacenter. Virtual machine availability has also been enhanced, as the oVirt Engine can now provide high availability to VMs in the event of a host failure, and the oVirt Manager can flag individual VMs for high availability. Network processes and configuration have been simplified in oVirt 3.4, offering multi-host network configuration, reduced number of steps to reflect a definition change and new networking labels to differentiate host interfaces.

**Expanded developer features:** This newest release will allow developers to apply affinity and anti-affinity rules to VMs to manually dictate when VMs should simultaneously run on one hypervisor, or separately on different hypervisor hosts. They will also be able to manage a wider variety of storage options, including NFS, iSCI, POSIX, as well as GlusterFS and FibreChannel storage domains. Multi-host network configuration will enable administrators to modify networks already provisioned by hosts and apply those changes to all hosts within a datacenter, and power-saving rules can shut down and power up hosts as needed.

**Hosted engine and hot-plug CPUs:** New clustered solutions in oVirt 3.4 enable users to configure multiple hosts while running their oVirt engine inside a virtual machine. The ability to add and remove virtual resources to a virtual machine is critical in any virtualization environment, and oVirt 3.4 gives system administrators this freedom with an added preview of a hot-plug CPU feature. oVirt 3.4’s hot-plug CPU enables users to meet customer service-level agreements and dynamically scale virtual machine compute resources without restarting the virtual machine.

oVirt 3.4 also provides cross-architecture capabilities not found in most competing virtualization platforms, including a preview of PPC64 support, thanks to efforts from IBM and the Instituto de Pesquisas Eldorado (Eldorado Research Institute) in Brazil. Efforts continue to integrate oVirt with other projects and solutions that users want, such as oVirt guest agents for openSUSE and Ubuntu.

A complete list of oVirt 3.4 features is available on the oVirt Project’s community release announcement page: [OVirt 3.4 release announcement](/develop/release-management/releases/3.4/release-announcement.html) . oVirt 3.4 takes virtual datacenter management to new levels, with access to more developers, using open technologies. With easier-to-install features, more availability on different architectures and platforms, and better access to a variety of storage options, this newest release is a significant milestone for flexible, open source virtual datacenter management.

Itamar Heim, Director of Software Engineering, Red Hat adds, "oVirt 3.4 will provide admins with more flexibility than ever to better manage and synchronize and schedule their virtualization and cloud workloads. Managing virtual machines is now easier with many new scheduling and load balancing options and dynamic changes such as hot-plug CPU. Deployment is also more flexible with oVirt Engine able to run as a VM on the same hosts it manages, network configurations across multiple hosts and the capability to mix different types of storage in the same datacenter."

**Additional Resources**

*   Read more about the [oVirt 3.4 release highlights](/develop/release-management/releases/3.4/)
*   Get more [oVirt updates on Twitter](//twitter.com/ovirt)
*   Read more about [| Red Hat’s community projects and upcoming community events](//community.rehat.com)

**About the oVirt Project** The oVirt project is an open virtualization project providing a feature-rich server virtualization management system with advanced capabilities for hosts and guests, including high availability, live migration, storage management, system scheduler and more. Powered by KVM on Linux, oVirt offers developer choice of a stand-alone hypervisor or can be installed on top of an existing Linux platform on an easy-to-use web interface. Some technologies developed in the oVirt community may later be integrated into Red Hat virtualization products, and they are developed in oVirt under a free and open source license so other communities and projects are free to study, adopt and modify them.
