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

2.  It is recommended that the VM containing the promiscuous NIC will be pinned to a single host (the host which we would like to monitor). One will probably want to define such a VM for each host in the cluster.

Notes:

1.  A VM NIC resides only on VM Networks, thus promiscuous mode is also only available for VM Networks.
2.  We shouldn't limit the VM to be pinned to host, although it is the common use-case.
3.  More than one VM can monitor the same logical network
4.  A VM can monitor more than one logical network
5.  It will be supported when when hot-plugging/unplugging a nic (can set an offline nic to be in promiscuous mode, and then activate it)

### Permissions

1.  Permissions support

*   Add a "Manipulate promiscuous network", on the DC level, which means the user can check/uncheck the promiscuous flag on the VM nic for every logical network in the DC, on every cluster (assuming he has permissions on the cluster/VM, of course)
*   In the engine-core we will have the same permission also in the network level, although for now it will only inherit the permission from the DC, as we won't enable setting this permission via the UI/API.
*   Grant this permission automatically to Super User, and DC admin(?).

### UI mockups

Will be available soon.

### Benefit to oVirt

The ability to integrate the security world with the virtualization one, allowing to easily monitor and secure networks in a virtualized environment, same as done today in non-virtualized environments.

### Documentation / External references

### Comments and Discussion

Open issues:

1.  Do we need to have a flag on the logical network level specifying whether VMs can have promiscuous mode VM nic on top of it or not?
2.  How would we treat the promiscuous flag When importing/Exporting/Templating a VM?
3.  Is this okay to return the promiscuous flag from the engine-core? Does that pose a security issue? If we
    -   if we can't then it is problematic, as there is no infrastructure for that at the engine-core side.

4.  Will we allow users to edit this VM nic from the user portal?

*   Will we allow users to uncheck this flag with no promiscuous permissions in the User Portal? API? Webadmin?

<Category:Feature> <Category:Template>
