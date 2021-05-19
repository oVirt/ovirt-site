---
title: NumaAwareKsmSupport
category: feature
authors: maroshi
---

## NUMA aware KSM support

### Summary

The KSM feature is optimizing shared memory pages across all NUMA nodes. The consequences is: a shared memory pages (controlled by KSM) to be read from many CPUs across NUMA nodes. Hence degrading (could totally eliminate) the NUMA performance gain. The optimal behavior is for KSM feature to optimize memory usage per NUMA nodes. This feature is implemented in KSM since [RHEL 6.5](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/chap-KSM.html). We want to introduce a new feature to oVirt that will allow host administrator to control NUMA aware KSM policy.

### Owner

*   Feature Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>
*   GUI Component Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>
*   Engine Component Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>
*   VDSM Component Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>
*   MoM Component Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>
*   REST Component Owner: Dudi Maroshi <dmaroshi (at) redhat (dot) com>

### General Description

The information flow is presented in the diagram bellow:

![](/images/wiki/Ksm-merge_across-node-data-flow.png)
The implementation activities are the following:
# Update Database and entities with new attribute.

1.  Update REST api and its translation system with new attribute
2.  Update GUI with new widget
3.  Test GUI and REST api
4.  Update oVirt-engine business logic to transmit KSM changes to host
5.  Test oVirt-engine
6.  Update MoM subsystem with new attribute
7.  Test MoM subsystem to track new attribute, and update KSM policy
8.  Update VDSM agent to update new MoM policy with new attribute

### Detailed Description

We want to introduce a new feature to HREV-M that will allow host administrator to control NUMA aware KSM.

#### Kernel level solution

Since RHEL 6.5 there is a kernel flag that controls KSM's NUMA awareness. The flag **/sys/kernel/mm/ksm/merge_across_nodes** has strict logic for enabling/disabling NUMA awareness in KSM. Especially this documented lifecycle constraint:
 “*merge_across_nodes setting can be changed only when there are no ksm shared pages in system: set run 2 to unmerge pages first, then to 1 after changing merge_across_nodes, to remerge according to the new setting. Default = 1 (merging across NUMA nodes as in earlier releases)*”
 The initial life-cycle of KSM service with NUMA awareness is presented in the pic bellow:
![](/images/wiki/Ksm-merge-nodes-statechart.png)
The skilled hypervisor/host administrator may control merge_across_nodes life-cycle using scripts. Outside oVirt control.
=== oVirt feature design === Add cluster level property to store and manage the NUMA aware KSM policy.
This requires adding new boolean column to vds_group table.
Updating the corresponding insert and update stored procedure.
Refactoring the DAO command and refactoring VDSGroup class.
 Refactor all usage scenarios to guarantee that change to above cluster property will percolate at runtime to all active hosts. And NUMA aware KSM policy will be effective on every host activation. Using GUI and REST api.
 Eventually achieving NUMA aware KSM policy conformance on all hosts in cluster. The initial default to all hosts in data center is merge_across_nodes = 1 (NUMA performance loss) this is RHEL default initial state.

##### A) Activate host with NUMA aware KSM policy

1.  Refactor engine class InitVdsOnUpCommand to send VDSM the current NUMA aware KSM policy value.
2.  Refactor VDSM command SetMOMPolicyParameters to accept NUMA aware KSM policy. And make the VDSM side modification to receive the command. Preserving host performance.
3.  On MoM update KSM controller and collector to identify new parameter. Also update the KSM policy to reflect the KSM with **ksm_across_nodes** flag life-cycle logic.

##### B) Update cluster with NUMA aware KSM policy using REST api

1.  Refactor engine class UpdateVdsGroupCommand. At execution: concurrently distributed the NUMA aware KSM policy values to each active host (calling VDSM command SetMOMPolicyParameters as in section A above).
2.  Update REST api.xsd rsdl file and mapping classes
3.  On VDSM and MoM side use the design from section A above.

##### C) Update cluster with NUMA aware KSM policy using GUI

In addition to the design from section B) above. Add radio buttons to engine GUI ClusterPopup at the bottom enabled by KSM checkbox.
As in the picture bellow:
![](/images/wiki/KSM-Policy-for-Numa-GUI.png)
==== D) Adding new cluster with NUMA aware KSM policy using REST api ==== Refactor engine class AddVdsGroupCommand. Add validation to NUMA aware KSM policy value.

##### E) Adding new cluster with NUMA aware KSM policy using GUI

Apply the GUI changes in section C above. And the design in section D above.

### Benefit to oVirt

1.  Optimize host performance, by optimizing NUMA performance with KSM memory saving.
2.  Effectively apply KSM policy to all active host at request time, not requiring maintenance-activation.

### Dependencies / Related Features

#### Data and entities

*   Database – update vds_groups table (boolean, default = true, not null)
*   Database – update stored procedure insertvdsgroups
*   Database – update stored procedure updatevdsgroups
*   Database – Schema upgrade script.
*   Class VdsGroupDAODbFacadeImpl - update
*   Class VDSGroup – update

#### REST api

*   File api.xsd - update
*   File rsdl_metadata.yaml - update
*   Class ClusterMapper – update

#### oVirt engine backend

*   Class MomPolicyVDSParameters – update
*   Class InitVdsOnUpCommand – update
*   Class AddVdsGroupCommand – update
*   Class UpdateVdsGroupCommad – update
*   Class SetMOMPolicyParametersVDSCommand – update
*   Class VDSProperties - update

#### oVirt engine GUI

*   Class ClusterPopupView – update
*   File clusterPopupView.ui.xml – update
*   Class ClusterModel – update

#### VDSM

*   File supervdsmServer – update
*   Class vdsm/momIF.py – update

#### MoM

*   Class controller file KSM.py – update
*   Class collector file HostKSM.py – update
*   Policy file File KSM.rules -update

### Testing

Following are test scenarios for this feature.
Required: A cluster with 2 NUMA capable hosts

#### Activate host with NUMA aware KSM policy

This test can be performed with REST or GUI.
**Initial set up:**
Take all hosts in clusters on maintenance.
Set cluster with with NUMA aware KSM policy = KSM share NUMA nodes (the default).
==== Test 1 – system test ====

1.  Using oVirt engine, activate 1 host
2.  When host is up
    :Verify: On host file /sys/kernel/mm/ksm/merge_across_nodes contains 1 .
3.  Take host 1 on maintenance
4.  When host is on maintenance

    Update cluster with with NUMA aware KSM policy = KSM per each NUMA nodes.

5.  Using oVirt engine, activate 1 host
6.  When host is up

    Verify: On host file /sys/kernel/mm/ksm/merge_across_nodes contains 0 .

    Verify: received info event from host about NUMA aware KSM policy change.

7.  Take host 1 on maintenance
8.  When host is on maintenance

    Update cluster with with NUMA aware KSM policy = KSM share NUMA nodes.

9.  Using oVirt engine, activate 1 host
10. When host is up

    Verify: On host file /sys/kernel/mm/ksm/merge_across_nodes contains 1 .

    Verify: received info event from host about NUMA aware KSM policy change.

#### Update cluster with NUMA aware KSM policy using REST

Initial set up:
Set cluster with with NUMA aware KSM policy = KSM share NUMA nodes (the default).
Take all hosts in clusters up.

##### Test 1 – system test

1.  Update cluster with KSM disabled and NUMA aware KSM policy = KSM per each NUMA nodes

    Wait for 20 secs

2.  Verify: received from each host info event about NUMA aware KSM policy change.
3.  Verify: on each host /sys/kernel/mm/ksm/merge_across_nodes contains 0 .

##### Test 2 – system test

1.  Update cluster with KSM disabled and NUMA aware KSM policy = KSM share NUMA nodes

    Wait for 20 secs

2.  Verify: received from each host info event about NUMA aware KSM policy change.
3.  Verify: on each host /sys/kernel/mm/ksm/merge_across_nodes contains 1

### Comments and Discussion

*   No visible feedback about individual host NUMA awareness for KSM (not in RFE requirements)
*   Host administrator's manual configuration for /sys/kernel/mm/ksm/merge_across_nodes kernel flag. Is effective till next MoM collection cycle (important for manually trials and testing).
*   Reusing and dependent on existing oVirt engine mechanisms, and reusing VDSM host mechanisms.

<!-- -->


