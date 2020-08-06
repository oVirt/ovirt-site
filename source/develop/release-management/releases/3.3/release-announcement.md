---
title: oVirt 3.3 release announcement
category: release
authors: dneary, obasan
---

# oVirt 3.3 release announcement

## What is oVirt

oVirt is a KVM management application for datacenter management. It is the leading open source alternative to VMware vSphere. You can use oVirt to manage hundreds of KVM hypervisor nodes, running thousands of VMs.

oVirt provides a very sophisticated management application for systems administrators, while also providing a simpler self-service user console which exposes basic functiopnality related to creating and managing virtual machine instances. The management interface gives you a central location to manage all of your storage, network and compute resources, and to handle authentication and authorization for users of your virtualized infrastructure.

oVirt provides all of the features you expect from a datacenter management application, including:

*   Live migration of VMs
*   Live storage migration
*   Templates and snapshots of running VMs
*   Make your VMs highly available
*   A small footprint hypervizor operating system ready to deploy
*   RESTful APIs to allow easy automation of VM lifecycle
*   Integration of remote desktop access to VM instances
*   Support for iSCSI, FCoE, NFS, and Gluster for shared storage

oVirt builds on KVM, the only hypervisor technology integrated into the heart of the Linux kernel. QEMU and KVM give you get near-native performance for virtualized applications, by running guest code directly on the host hardware, while providing watertight security through SELinux for guest operating systems.

## What's hot in 3.3

### OpenStack and oVirt: A match made in heaven

[OpenStack](http://www.openstack.org) has made a huge impact in the industry since its launch 3 years ago. It is one of the fastest growing, fastest improving open source projects on the planet, and there is a huge amount of interest in it as an Infrastructure as a Service provider. The oVirt project has been working to ensure that oVirt and OpenStack work well together. Like OpenStack, oVirt needs to be able to store VM images and snapshots, we need to configure multiple virtual LANs for multiple tenants, and we need a reliable, scalable storage back-end for persistent storage.

In oVirt 3.3, we have added integration with the Glance image storage service, allowing oVirt users to import images from Glance as disks for templates in oVirt, and to export VM templates and disks from oVirt to Glance, where they can be used to launch new instances on OpenStack.

We also leverage the Neutron service for the definition of VLANs, virtual routing and virtual NICs. oVirt can discover networks configured in OpenStack, and also use the oVirt management UI, via the Neutron APIs, to define network configurations.

More is planned for the future, as we work to make it easier to use oVirt for your scale-out workloads while continuing to use oVirt for traditional virtualized workloads where quality of service and high availability are critical.

### Gluster: tight integration of software defined scale-out storage

GlusterFS is a clustered file-system capable of scaling to several peta-bytes, by grouping many storage bricks together into one continuous filesystem. The oVirt project has supported GlusterFS as a storage back-end for VMs managed by oVirt since version 3.1.

Over the past year, we have worked with the Gluster team to create an even tighter integration between the projects.

With oVirt 3.3 and Gluster 3.4:

*   Gluster users can use oVirt to manage their Gluster clusters
*   Changes made with the Gluster command line tool are reflected automatically in oVirt
*   oVirt users can optimise their GlusterFS storage for a virtualization use-case
*   Through the recently added glusterfs support in QEMU, oVirt now speaks natively to GlusterFS volumes

With the latest versions of oVirt and Gluster, oVirt users now have smooth integration of network-distributed storage, and Gluster users get easy management of their Gluster domains from a user friendly user interface.

### Extensibility and automation

oVirt provides a rich set of possibilities to integrate with and extend the oVirt engine.

*   Automate and script operations related to your VM lifecycle using the oVirt CLI and REST API, including starting and stop VMs, automation of back-ups, scheduling operations, creation of storage and network resources, and more
*   A rich collection of hooks which can be used to perform custom actions via scripts during a VM's lifecycle
*   APIs in a variety of programming languages, including Java and Python, to allow programmatic control of oVirt in your preferred language
*   A UI plug-in framework which allows you to add advanced functionality to the management interface. For example, integration of Nagios monitoring, Foreman for system configuration, or the management of NetApp storage.

The ability to extend and integrate your VM management application into your IT operations gives you the flexibility and power you need to get the most from your infrastructure.

## Further information

If you want to find out more about the new features we have added in the oVirt 3.3 release, have a look at our [release notes](/develop/release-management/releases/3.3/).

To find out where to download oVirt 3.3 and try it out, visit the [download](/download/) page.

You can also find out more [about oVirt](/community/about.html) in general on [this site](/). Join the oVirt [community](/community/)! oVirt is an open source project with an open participation model, and we are always eager to hear from happy users and interested participants.

