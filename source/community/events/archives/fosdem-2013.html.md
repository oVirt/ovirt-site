---
title: FOSDEM 2013
category: events
authors: dneary
---

# oVirt at FOSDEM 2013

There were several oVirt or oVirt related talks in the [Virtualization DevRoom](//fosdem.org/2013/schedule/track/virtualisation/):

*   [QEMU USB status report 2012](//fosdem.org/2013/schedule/event/qemu_usb_2012/) - Hans Goede

    This talk gives an overview on the state of the qemu usb subsystem. What happened last year? What are the plans for the future? Where do we stand in terms of USB 3.0 support? The intended audience are people who are interested in usb in virtual machines (vusb) both developers and users.

*   [oVirt Live Storage Migration - Under the Hood](//fosdem.org/2013/schedule/event/ovirt_live_migration/) - Federico Simoncelli

    Live storage migration, one of the newest features introduced in oVirt, is the capability of moving virtual disks from one storage device to another without interrupting the guest operations.

*   [oVirt SLA- MoM as host level enforcement agent](//fosdem.org/2013/schedule/event/virt_sla_mom/) - Doron Fediuck

    Maintaining QoS in cloud computing requires host-level monitoring and policy enforcement. In order to be able to scale up large setups, a host-level agent is needed to supervise and dynamically handle the VMs resource consumption based on the SLA policy. In this session we'll look at MoM, and get a in-dept view of it's integration with VDSM and functionalities. Participants will be able to get insights on memory overcommitment in hypervisors and the way memory balloon device is being used to achieve overcommitment.

*   [Automated OS installation? That's easy!](https://fosdem.org/2013/schedule/event/automated_os_install/) - Zeeshan Ali

    Boxes is a GNOME 3 application that aims to make management of virtual and remote machines very easy. As an important part of that goal, Boxes not only makes it possible to create a virtual machine in a few clicks, given an installation media but it also gives user a choice to launch automated (AKA unattended) installation of operating system in question on it.

*   [oVirt introduction](//fosdem.org/2013/schedule/event/ovirt_intro/) - Doron Fediuck

    The oVirt Project is an open virtualization project providing a feature-rich server and desktop virtualization management platform with advanced capabilities for hosts and guests, including high availability, live migration, storage management, system scheduler, and more. oVirt provides an integration point for several open source virtualization technologies, including kvm, libvirt, spice and oVirt node.

*   [oVirt and GlusterFS integration](//fosdem.org/2013/schedule/event/ovirt_glusterfs/) - Doron Fediuck

    GlusterFS is a distributed file system that can scale to several PetaBytes. oVirt is a management platform for Kernel based Virtual Machine (KVM) and can be used to manage GlusterFS as well. This focussed on GlusterFS integration with oVirt.

*   [Using Foreman from the oVirt-engine Administrator UI](//fosdem.org/2013/schedule/event/ovirt_foreman/) - Oved Ourfalli

    In this presentation Oved showed how one can use the new oVirt-Engine UI-Plugin infrastructure, to add a Foreman-UI-plugin, that allows querying Foreman information on oVirt entities, and perform different Foreman-related operations on them.

*   [Supporting and Using EC2/CIMI on top of Cloud Environments](https://fosdem.org/2013/schedule/event/ec2_cimi_cloud/) - Oved Ourfalli

    In this presentation Oved described some standard and common cloud APIs such as EC2 and CIMI, and showed how one can use Deltacloud in order to support them on top of cloud environments. As an example, he showed how to add this support and use it on top of the oVirt engine.

