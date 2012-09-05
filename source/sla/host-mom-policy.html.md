---
title: host-mom-policy
category: sla
authors: aglitke
wiki_category: SLA
wiki_title: Sla/host-mom-policy
wiki_revision_count: 3
wiki_last_updated: 2012-09-06
---

# host-mom-policy

Maintaining SLA requires dynamic management of each virtualization host according to a policy. The exact policy depends on the goals set by the administrator and/or users. For example, a policy may try to aggressively pack as many VMs on hosts in order to maximize host resource utilization and minimize the number of hosts which must be powered on. In another policiy example, an administrator may wish to favor a certain class of golden VMs over other VMs in order to provide guaranteed performance for the golden class and best-effort service for the others.

## Flow overview

Dynamic SLA policy enforcement requires several components in order to have a complete implementation: A policy, a policy engine or manager, information to use for decision making, and tuning "knobs". The proposed solution in oVirt uses the Memory Overcommitment Manager (MOM) policy engine and policy language. MOM retrieves information via the vdsm API. The tuning knobs are also available to MOM as vdsm API calls.

![](mom-flow.png "mom-flow.png")

## About MOM

## About policies
