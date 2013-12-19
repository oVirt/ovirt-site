---
title: HA VM reservation detailedDesign
category: feature
authors: doron, kianku
wiki_category: Feature
wiki_title: Features/HA VM reservation detailedDesign
wiki_revision_count: 24
wiki_last_updated: 2014-01-12
---

# HA VM reservation detailedDesign

**HA VM reservation detailed design for host failover - phase 1**

## Summary

High level design can be found at [Features/HA_VM_reservation](Features/HA_VM_reservation)

## Owner

*   Name: [Kobi Ianko](User:kianku)
*   Email: kobi@redhat.com

## Current status

*   Target Release: 3.4
*   Status: design
*   Last updated: ,

## Detailed Description

##### concepts

The HA VM reservation feature purpose is to inform the end user on scenarios that a failover of a host might cause a performance downgrade. To do that, the oVirt engine will monitor the hosts on each cluster and raise alerts in cases it uncovers such a scenario. The monitoring will be perform:

*   As a background task, tracking changes in the VMs that might cause a scenario as described above.
*   For each run/migrate command, tracking the changes cause by the command.

##### measuring the vm resources

For us to begin monitoring the cluster, we need to decide how this monitoring will be performed. The aspects of a VM that are relevant for our monitoring are the CPU and RAM usage of the VM.

A VM resources will be a combination of: RAM usage can be the current RAM usage of the VM in Mbytes. CPU usage can be the current CPU usage of the VM, (percentage will serve the cause as well since in the cluster the CPU should be of the same kind).

##### monitoring background task

Once we know how to calculate the VM resource, we can monitor it, the following pseudo code will show the monitoring strategy.

The monitoring procedure can be logically be divided into two. The first logical unit will search for a single host that can contain all of VMs from the failover host.

*   A pseudo code for that:

         1. for each host x in the cluster do:
          2.     calculate the host x HA resources -> resourceHA(x)
          3.     for each host y in the cluster, y<>x do:
          4.         calculate the host y free resources -> resourceFree(y);
          5.         if  resourceHA(x) < resourceFree(x) return ClusterHAStateOK;
          6. ClusterHAStateFailed, raise Alert

In case we did not find a match, the second logical unit will split the host into VMs and will try to find several host that will replace the failover host.

*   A pseudo code for that:

         1. for each host x in the cluster do:
          2.     calculate HA VMs resources -> resourceHA(x,vm(i))
          3.     for each host y in the cluster, y<>x do:
          4.         calculate the host y free resources -> resourceFree(y);
          5.         for each HA VM v for host x do:
          6.             while resourceFree(y) >= resourceHA(x,vm(v))
          7.                 resourceFree(y) = resourceFree(y) - resourceHA(x,vm(v));
          8.                 mark v as migrated;
          9  if all HA VMs are marked as migrated -> ClusterHAStateOK else ClusterHAStateFailed(raise Alert)

##### acting on run/migrate actions

This part is a bit more tricky, we would like oVirt to have the capability of not only monitor the current state of the cluster but to actually make an active decision when running/migrating a VM. by selecting the best host to place the VM.

For that we will add a new weight function to the existing one presented in the scheduling feature [Features/oVirtScheduler](Features/oVirtScheduler). The existing one combined with the new weight function will present a result for the best host to apply the VM into.

*   The scoring method

The scoring method will enable the Ovirt engine to make the best decision to where should the VM run(on which host).
F(VMi) = the amount of HA VM resources that is currently used in the host.

*   Adding a HA VM

using the already existing mechanism when adding a VM the system do the following: 1. filter out non relevant hosts, using the hard constraints filters. 2. apply the weight function to scoring the hosts based on the cluster policy. 3. apply the HA reservation weight function scoring the hosts taking into account the HA resources taken for each host. 4. merge (2) and (3) to a single number representing the score of the host based on the cluster policy and HA resources. 5. the host that will score the lowest will be the one to receive the VM.

#### UI

Overall the UI will be changed at two places:
One UI change will be a configuration change, enable the user to switch this feature On and Off.

A sketch of the Configure window:
![](configurewin.png "fig:configurewin.png")

A second UI change will be at the Alert window, in case the system will recognize the scenario in which a HA VM cannot be migrated after a Host failover without causing a performance downgrade, a new alert will show specifying the problematic cluster and list of problematic Hosts in that cluster.

The message to be presented to the user:
Cluster <clusterName> might suffer some performance downgrade in case of failover in hosts: <hostName1>, <hostName2>, ...
Adding a new tab at the configure popup (ConfigurePopupView.ui.xml)

`   `<t:tab>
`       `<t:DialogTab ui:field="HAVMReservationTab">
`           `<t:content>
`               `<g:SimplePanel addStyleNames="{style.panel}" ui:field="haVmReservationTabPanel" />
`           `</t:content>
`       `</t:DialogTab>
`   `</t:tab>

#### ENGINE

The engine will implement the logic of this feature, it will be responsible for the scoring mechanism shown above, and maintaining the background task of monitoring the state of the clusters. for the monitoring task we will use Quartz to run a job every 5 minutes. the job will implement the pseudo code shown above for the monitoring task.

<todo: Add quartz Impl notes here> <todo: Add run/migrate Impl notes here>

#### DB

Since there is no use of persisting the data, because it is relevant for a short period of time, no DB changes are needed. On the other hand the configuration should be persistent.

for saving the configuration we will add a new record to the vdc_options table

         insert into vdc_options(option_name,option_value) values ('EnableHaVmReservation','true');

possible values for this field are true/false according to the user selection in the checkbox at the popup window (shown at the UI section).

#### Rest API

Since the configuration does not have a Rest api, no changes in the Rest api are needed.

#### Backwards Compatibility

For this feature there are no changes in APIs to the host and all the logic will be done by the engine, there isn't any backwards compatibility issues, the feature will be supported by all host versions.

## Benefit to oVirt

Provide assurance to the end user that critical VMs will have access to the required resources in the event of a host failure without negatively impacting the collective performance of existing workloads

## Comments and Discussion

<Category:Feature> <Category:SLA>
