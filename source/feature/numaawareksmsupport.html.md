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

# NUMA aware KSM support

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

![](Ksm-merge_across-node-data-flow.png "fig:Ksm-merge_across-node-data-flow.png") The implementation flow is as following: Update Database and entities with new attribute. Update REST api and its translation system with new attribute Update GUI with new widget Test GUI and REST api Update oVirt-engine business logic to transmit KSM changes to host Test oVirt-engine Update MoM subsystem with new attribute Test MoM subsystem to track new attribute, and update KSM policy Update VDSM agent to update new MoM policy with new attribute

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

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
