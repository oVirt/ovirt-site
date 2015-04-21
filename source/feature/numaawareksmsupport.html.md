---
title: NumaAwareKsmSupport
category: feature
authors: maroshi
wiki_category: Feature
wiki_title: NumaAwareKsmSupport
wiki_revision_count: 14
wiki_last_updated: 2015-04-21
feature_name: NUMA aware KSM support
feature_modules: engine, vdsm, MoM, GUI, REST
feature_status: Design
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

![](Ksm-merge_across-node-data-flow.png "fig:Ksm-merge_across-node-data-flow.png")
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
![](ksm-merge-nodes-statechart.png "fig:ksm-merge-nodes-statechart.png")
The skilled hypervisor/host administrator may control merge_across_nodes life-cycle using scripts. Outside oVirt control.
=== oVirt feature design === Add cluster level property to store and manage the NUMA aware KSM policy.
This requires adding new boolean column to vds_group table.
Updating the corresponding insert and update stored procedure.
Refactoring the DAO command and refactoring VDSGroup class.
 Refactor all usage scenarios to guarantee that change to above cluster property will percolate at runtime to all active hosts. And NUMA aware KSM policy will be effective on every host activation. Using GUI and REST api.
 Eventually achieving NUMA aware KSM policy conformance on all hosts in cluster. The initial default to all hosts in data center is merge_across_nodes = 1 (NUMA performance loss) this is RHEL default initial state.

##### A) Activate host with NUMA aware KSM policy

*   Refactor engine class InitVdsOnUpCommand to send VDSM the current NUMA aware KSM policy value.
*   Refactor VDSM command SetMOMPolicyParameters to accept NUMA aware KSM policy. And make the kernel modification to the host. Preserving host performance.
*   Update cluster with NUMA aware KSM policy using REST api
*   Refactor engine class UpdateVdsGroupCommand. At execution: concurrently distributed the NUMA aware KSM policy values to each active host (calling VDSM command SetMOMPolicyParameters as in section A above).
*   On VDSM side update setMoMPolicy command with new parameter.
*   On MoM update KSM controller and collector to identify new parameter. Also update the KSM policy to reflect the KSM with **ksm_across_nodes** flage lifecycle logic.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
