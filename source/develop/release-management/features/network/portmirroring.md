---
title: PortMirroring
category: feature
authors: moti, ovedo, shaharh
---

# Port Mirroring

## Summary

The purpose of the feature is to allow mirroring network traffic to a specific VM

## Owner

*   Name: Shahar Havivi (Shaharh)
*   Email: <shavivi@redhat.com>

## Current status

*   In progress of defining the requirements from the ovirt engine
*   VDSM - patch sent (mirror mode only): <http://gerrit.ovirt.org/#change,956>

## Detailed Description

The port mirroring feature is about allowing a certain VM NIC to monitor the network traffic of a specific logical network, on the host the VM resides on. The method for doing that is to mirror all the VM network traffic on a specific host to a specific VM running on that host. (As opposed to using in-lining/redirect - which is the ability to redirect all the traffic of VMs in a network to a single VM)

## User work-flows

1.  Upon creating/editing a VM NIC:
    -   Choose the logical network of the NIC (same as today)
    -   Choose whether this NIC should get mirrored traffic

2.  It is recommended that the VM containing this NIC will be pinned to a single host (the host which we would like to monitor). One will probably want to define such a VM for each host in the cluster.

Notes:

1.  A VM NIC resides only on VM Networks, thus port mirroring is only supported on these networks.
2.  We shouldn't limit the VM to be pinned to host, although it is the common use-case.
3.  More than one VM can monitor the same logical network
4.  A VM can monitor more than one logical network
5.  It will be supported when when hot-plugging/unplugging a nic (can set an offline nic to be in mirrored mode, and then activate it)

## Permissions

1.  Permissions support
    -   Add a "Manipulate port mirroring" action group, which means the user can check/uncheck the port mirroring flag on the VM NIC.
    -   No pre-defined role will be added for that. In order to use this feature administrators will have to define a custom role containing this action group, and assign it to a user on the DC level.
    -   A user which has this permission on the DC level, will be able to check this flag for every logical network in the DC, on every cluster (assuming he has permissions on the cluster/VM, of course).
    -   In the engine-core we will test for this permission on the network level, although for now it will only inherit the permission from the DC, as we won't enable setting this permission via the UI/API.
    -   The role will allow users to check the port mirroring flag on the VM NIC. However, everyone with edit permissions on the VM will be able to uncheck it.

## Import/Export/Templates

1.  This flag will not be exported/imported.
2.  This flag will not be a part of a VM template

## UI mockups

Will be available soon.

## REST API

The only change is the ability to set whether the VM NIC should get mirrored traffic or not, so we add the following element to the NIC type:

```xml
<xs:element name="mirror_to_port" type="xs:boolean" minOccurs="0"/>
```

## Benefit to oVirt

The ability to integrate the security world with the virtualization one, allowing to easily monitor and secure networks in a virtualized environment, same as done today in non-virtualized environments.

