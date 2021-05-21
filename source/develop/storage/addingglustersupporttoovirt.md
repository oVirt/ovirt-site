---
title: AddingGlusterSupportToOvirt
authors:
  - ekohl
  - ovedo
---

<!-- TODO: Content review -->

# Adding Gluster Support to oVirt

## Overview

Gluster file system allows the creation of a shared namespaces from clusters of hosts, utilizing each host local storage.

There are two main use cases for deployment:

*   Provisioning the gluster storage on a separate cluster from the cluster running the virtual machines<sup>1</sup>.
*   Provisioning the gluster storage on the same hosts running the virtual machines<sup>2</sup>.

This document suggests a multi-phased approach to adding gluster support to ovirt.

While this focuses on gluster, it shouldn't preclude other local storage based approaches, such as sheepdog.

The relevant features will be added to engine and vdsm.

The suggested steps are:

1.  Allow defining a cluster as a gluster-storage cluster without VMs on the same cluster.
2.  Allow defining a cluster as shared for both storage and VMs.
3.  Review the concepts of storage (with the move to SDMs), networks (with the introduction of advanced network virtualization support) and resource pools (with the intro of SLA) for a more generalized service driven approach.

An orthogonal action item would be to modularize engine/api/ui/vdsm so they would allow better support for pluggable code which may not be deployed by all users (part of a generally much needed modularization of these components).
This would also allow the gluster community to re-use the modules for managing gluster storage clusters.

This document focuses mostly on the first step (quite enough work to start with this, learn from it, and plan the next step).

## User Actions

The following user actions / use cases should be covered:

1.  Adding a storage cluster
    -   Allow adding a cluster of type 'gluster-storage'<sup>3</sup> (i.e., cluster would have a checkbox if it is for virt or for cluster. In phase I it will be either/or. In phase II it will could be both).
    -   Need to define: A gluster cluster will be monitored for gluster related services.
    -   The cluster will be monitored for all info to be cached in the db volumes table. Monitoring should be optimized to detect deltas.

2.  Adding a host to a gluster cluster
    -   Fail if host is already part of a gluster cluster with a different name.
    -   Provision all packages/configuration as needed as part of bootstrap.
    -   If host is not part of the gluster cluster already (at gluster level), invite it via another gluster node.
    -   Need to define host level monitoring aspects (service status wise, networks, etc.)
    -   Unmanaged nodes – since a gluster cluster could have nodes not provisioned via the admin ui, standing on the cluster should show a to-do link for each host that should be added to the management system.

3.  Configure local storage on the host
    -   Detect physical and logical layout of disks/partitions on the host
    -   Allow configuring LVM/file systems as relevant (this should be relevant to configuring local block/fs storage for virt storage domains as well)

4.  Adding a gluster volume
    -   when standing on a gluster cluster, a volumes collection will be shown in tree and as a main tab with search.
    -   User would be able to perform basic volume operations (add/edit/delete/start/stop/etc.)
    -   A volume should have an action to create a storage domain from.
    -   Permissions on volumes would be inherited from DC or Cluster, or can be defined at gluster level directly.
    -   Roles and actions should be annotated if relevant to gluster only as part of modular/pluggable concepts.

5.  Qemu-kvm integration
    -   Need to decide on implementation: normal nfs domain, native-gluster client, directly from qemu

## Notes

1.  Currently, ovirt treats clusters as migration domain for the service provisioned on top of it, namely running virtual machines. Hence, same approach is assumed for a storage cluster providing a storage service. Going forward, it looks as if it will make sense to generalize the concept of services and the resources providing them (see the next footnote on host-groups as well).
2.  The current set of managed resources for a service in the system is a cluster. Going forward, the notion of a “dyanmic cluster” may make more sense. A “dynamic cluster” would be comprised of the set of hosts that are/can/should provide a certain service (dubbed “hosts-groups”). This could be defined more statically at host level, or more dynamically, based on the set of hosts that can provide a certain service (say, all hosts which can run what a specific VM needs, hence also dubbed “vm-view”).
3.  We could limit the cluster to a data center of type 'gluster' for phase I, but it will mean phase II would be blocked on the move to SDMs.
