---
title: Cluster maintenance scheduling policy
category: feature
authors: msivak
---
# Cluster maintenance scheduling policy

There are situations where it is necessary to limit the amount of newly started virtual machines. For example a maintenance window that only affects some hosts and limits the overall capacity of the cluster.

So we decided to implement a simple scheduling policy that would disallow starting of new virtual machines, while still maintaining the already running ones. This is especially important for highly available VMs.

## Owner

*   Feature Owner: [Martin Sivák](User:msivak)
*   Email: <msivak@redhat.com>

## Current status

* Available in oVirt 4.1.4 and higher

## What it does and does not do

- no user can start new virtual machine
- with the exception of VMs marked as highly available
- migration is not blocked in any way
- balancing is set to Equally balanced

## How do I put cluster to maintenance

Select the cluster, click edit and select cluster_maintenance scheduling policy from the dropdown.

![Edit cluster dialog showing how to enable maintenance](/images/wiki/ClusterInMaintenance_enable.png)

## How do I quit the maintenance mode

Just edit the cluster again and select any other scheduling policy.

## What if I need power saving or equal VM count based maintenance policy?

The functionality is provided by ClusterInMaintenance policy unit so just clone the Power saving scheduling policy and enable the ClusterInMaintenance unit in the clone.

![Scheduling policy edit dialog showing how to enable ClusterInMaintenance unit](/images/wiki/ClusterInMaintenance_PowerSavingClone.png)
