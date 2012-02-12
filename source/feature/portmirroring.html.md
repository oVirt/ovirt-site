---
title: PortMirroring
category: feature
authors: moti, ovedo, shaharh
wiki_category: Feature
wiki_title: Features/PortMirroring
wiki_revision_count: 16
wiki_last_updated: 2012-11-19
---

# Port Mirroring

## Promiscuous Mode

### Summary

The purpose of the feature is to allow monitoring (mirroring and redirecting) network traffic to a specific VM

### Owner

*   Name: [ Shahar Havivi](User:Shaharh)
*   Email: <shavivi@redhat.com>

### Current status

*   In progress of defining the requirements from the ovirt engine
*   VDSM - patch sent (mirror mode only): <http://gerrit.ovirt.org/#change,956>

### Detailed Description

The promiscuous mode feature is about allowing a certain VM NIC to monitor the network traffic of a specific logical network, on the host the VM resides on. There are two possible modes for this monitoring:

1.  Mirror - the ability to send all VMs traffic of a specific network to a single VM
2.  Redirect - the ability to redirect all the traffic of VMs in a network to a single VM and it will decide to forward it or to a abort, common use case is a Firewall, IDS and etc.

In first phase we will only support mirroring.

### User work-flows

1.  Upon creating/editing a VM NIC:
    -   Choose the logical network of the NIC (same as today)
    -   Choose whether this NIC should be in promiscuous mode

2.  Also, it is recommended that the VM containing the promiscuous NIC will be pinned to a single host (the host which we would like to monitor). One will probably want to define such a VM for each host in the cluster.

Notes:

1.  We shouldn't limit the VM to be pinned to host, although it is the common use-case.
2.  More than one VM can monitor the same logical network
3.  A VM can monitor more than one logical network
4.  It will not be supported when when hot-plugging a nic
5.  It will be supported only for bridged networks

### Design Notes

Engine-level notes:

*   need to figure out a way to security the process of adding a promiscuous mode NIC. Today, the engine has the ability to set permissions on the VM level, but not for on the interface level.

### User work-flows

1.  Upon creating/editing a VM NIC:
    -   Choose the logical network of the NIC (same as today)
    -   Choose whether this NIC should be in promiscuous mode

2.  Also, it is recommended that the VM containing the promiscuous NIC will be pinned to a single host (the host which we would like to monitor). One will probably want to define such a VM for each host in the cluster.

### Benefit to oVirt

The ability to integrate the security world with the virtualization one, allowing to easily monitor and secure networks in a virtualized environment, same as done today in non-virtualized environments.

### Documentation / External references

### Comments and Discussion

Open issues:

1.  Currently, there are no permissions in the VM NIC level, allowing every VM NIC to become a promiscuous one. Such support will have to be added in order to support promiscuous mode (see design notes).
2.  Do we need to have a flag on the logical network level specifying whether this network can be monitored or not?
3.  How would we treat the promiscuous flag When importing/Exporting/Templating a VM?

<Category:Feature> <Category:Template>
