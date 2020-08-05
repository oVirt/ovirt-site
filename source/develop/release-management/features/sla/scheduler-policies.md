---
title: oVirt Scheduler Policies
category: feature
authors: tsaban
---

# oVirt Scheduler Policies

## Summary

This page describes the scheduler policies currently supported by oVirt.
This scheduler controls scheduling in the cluster level.
Last update: 03/30/2015.

## Owner

Name: Tomer Saban (tsaban)
Email: <tsaban@redhat.com>

## Getting Started with Scheduler Policies

This is the easiest explanation to active an internal scheduler policy.

### Create scheduling policy

*   Enter the "Administrator portal".
*   Click "configure"(At the top right edge of the screen). A dialog should open.
*   Click the tab "Scheduling policies" at the left side of the dialog.
*   Click "new" and create a new policy(Giving a name is enough in order to create A non-filtering policy).
*   Close the dialog.

### Attach scheduling policy to a cluster

*   Click the "Clusters" tab.
*   Click a cluster to attach the policy to, from the table below("Default" cluster is fine).
*   Click "edit". A dialog should open.
*   Click "Scheduling Policy" on the left tab from the dialog.
*   In the "Select Policy" combo-box choose the name you gave the policy eariler.

Now the scheduling policy is attached to the cluster you choose and it's working.

## Current status of filter and weight policies

| Policy                          | Kind   | Status                                  | Description                                                                                                                                                                                                                                                         |
|---------------------------------|--------|-----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PinToHost                       | Filter | Working                                 | Filters every host which the vm is not pinned to(Meaning the vm will migrate only to the host it is pinned to).                                                                                                                                                     |
| Migration                       | Filter | Working                                 | Filters the host which the vm is currently resides on. Meaning, This policy encourages migrations.                                                                                                                                                                  |
| CPU-Level                       | Filter | Working                                 | Filters hosts by CPU level(manufacturer, model, etc).                                                                                                                                                                                                               |
| CPU                             | Filter | Working                                 | Filters hosts by CPU cores(Number of Virtual CPUs).                                                                                                                                                                                                                 |
| VmAffinityGroups                | Filter | Working                                 | Filters hosts by taking into consideration Affinity groups(positive affinity group means that all VMs should be on the same host and negative means that they should be on separated hosts).                                                                        |
| Emulated-Machine                | Filter | Working                                 | Filters hosts by emulated machine(isapc, pc, etc).                                                                                                                                                                                                                  |
| Network                         | Filter | Working                                 | Filters hosts who doesn't have the necessary network interfaces to run the vm.                                                                                                                                                                                      |
| None                            | Filter | Working                                 | No host is being filtered(The vm will migrate to the first available host).                                                                                                                                                                                         |
| None                            | Weight | Using even distribution policy instead. | Hosts receives score based on even distribution weight policy.                                                                                                                                                                                                      |
| OptimalForEvenGuestDistribution | Weight | Working                                 | Sets host scores based on the number of VMs on each host.                                                                                                                                                                                                           |
| OptimalForEvenDistribution      | Weight | Working                                 | Sets hosts scores so that there will be even CPU usage distribution.                                                                                                                                                                                                |
| VmAffinityGroups                | Weight | Working                                 | Sets host scores based on affinity group (Hosts which are at the same affinity group as the vm and their affinity is positive or has different affinity group and their affinity is negative gets a specified score, bigger than 1 and the other gets a score of 1. |
| OptimalForHaReservation         | Weight | Working                                 | Sets scores for hosts according to the number of highly available vms on them and a scale down parameter.                                                                                                                                                           |
| OptimalForPowerSaving           | Weight | Working                                 | Sets host scores so that minimum number of hosts will need to stay on. Has influence only when used with hosted engine.                                                                                                                                             |
| HA                              | Weight | Working                                 | Weight are being set by the number of HA VMs on the host and a scale down parameter. Has influence only when used with hosted engine.                                                                                                                               |
| HA                              | Filter | Working                                 | Filters hosts whose high availability score is negative(See [ovirt-ha-agent](https://resources.ovirt.org/old-site-files/wiki/Hosted_Engine_Deep_Dive.pdf) for more details on how this score is calculated). Has influence only when used with hosted engine.       |
| Memory                          | Filter | N/A                                     | Filters hosts based on memory usage.                                                                                                                                                                                                                                |

## See Also

See [Features/oVirtSchedulerAPI](/develop/release-management/features/sla/ovirtschedulerapi.html)

