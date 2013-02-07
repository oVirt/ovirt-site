---
title: Memory-aware Even-distribution Policy
category: sla
authors: ofri
wiki_category: SLA
wiki_title: Features/Design/Memory-aware Even-distribution Policy
wiki_revision_count: 4
wiki_last_updated: 2013-02-19
---

# Memory-aware Even-distribution Policy

This document describes the design for a new policy which seeks even distribution on Virtual Machines over Hosts by using host memory usage state as well as its CPU usage state.

### Motivation

In current implementation the user can select between two policies for optimizing the distribution on Virtual-Machines over the Hosts in the Cluster.

*   Even-Distribution - Even Distribution
*   Power Saving

The current Even-Distribution policy takes into consideration only the state of the host's CPU and the VMs CPU usage. This solution can potentially lead to a situation where heavy memory using VMs would be crowded into into the same host. Which would lead to heavy memory use on the host and degradation in the host and the VMs performance.

By adding the state of the host memory and the memory usage of each VM to the policy considerations we could avoid situations as described above.

### GUI

Changes to the UI will be minor. The current radio button list for selecting policy includes:

*   None
*   Even Distribution
*   Power Saving

The new list will include:

*   None
*   Even Distribution - CPU Only (this is the old policy)
*   Even Distribution - CPU and Memory aware
*   Power Saving

### REST API

### Backend

This section describes the backend design for this feature.

#### Logic Design

### Tests

Unit-tests for testing the new policy will be added.

#### Special considerations

No special considerations.

<Category:SLA> [Category: Feature](Category: Feature)
