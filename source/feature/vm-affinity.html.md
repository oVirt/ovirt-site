---
title: VM-Affinity
category: feature
authors: adahms, gchaplik
wiki_category: Feature
wiki_title: Features/VM-Affinity
wiki_revision_count: 19
wiki_last_updated: 2014-07-31
---

# VM Affinity

### Summary

The oVirt scheduler capabilities introduced in version 3.3 have opened opportunities to enhance how VM Workloads are scheduled to run within a cluster. By using the filtering and weighing mechanisms introduced in the Scheduler, it is now possible to apply Affinity and Anti-Affinity rules to VMs to manually dictate scenarios in which VMs should run together on the same, or separately on different hypervisor hosts.

#### Owners

*   Name: [ Scott Herold](User:sherold)
*   Email: <sherold@redhat.com>
*   Name: [ Gilad Chaplik](User:gchaplik)
*   Email: <gchaplik@redhat.com>

#### Current status

*   status: design phase
*   Last updated: ,

### Benefits to oVirt

--------------------------------MISSING--------------------------------

#### Terminology

*   Affinity Group – A group of two or more VMs for which a set of identical conditions and parameters are applied.
*   Affinity Policy – The combination of an Affinity Group, a Condition statement, and optional Parameters.

ie. VM A, VM B, and VM C Must Run Together on Host 1.

*   VM Affinity – Affinity that is applied at the VM entity level regardless of its workload characteristics.
*   Positive Affinity (Run Together) - An affinity policy can be set as a Run Together policy to dictate that the identified VMs are to be run on the same hypervisor host.
*   Anti (Negative) Affinity (Run Independently)- An affinity policy can be set as Run Independently to dictate that the identified VMs are to be run on separate hypervisor hosts.
*   Must Condition (enforce = hard) – This is a hard condition which indicates that two or more VMs are required to run either on the same hypervisor host or on independent hypervisor hosts, regardless of external circumstances.
*   Should Condition (enforce = soft) – This is a soft condition which indicates that there is a preference that two or more VMs run either on the same hypervisor host or on independent hypervisor hosts, but is not a hard requirement.

### Detailed Description

Define a new entity in the system called Relation. Relation can be categorized according to type, and currently will be in use by VM-affinity, later we can generalize it to other entities.

#### Engine

##### Queries

*   getAllRelationsByClusterId

Populates Relations subtab in clusters main tab

*   getRelationsByVmId

Populates Relations subtab in VMs main tab

##### Commands

Adding CRUD actions for relations, only supported in admin portal (user portal support will be added later- if needed) MLA: new action group for manipulate relations (including all CRUD commads), this action group will be added to ClusterAdmin Role and above.

*   AddRelation

Adds a relation to engine.

*   RemoveRelation

Removes a relation from engine.

*   EditRelation

Edits a relation, allow to add/remove VMs to/from the relation.

#### Data Base

Tables: relations: id, name, cluster_id (foreign key to vds_groups + delete cascade), relation_type (positive/negative), enforcement(hard/soft).

open Q: generate cluster_id in the SP with join or update it when VM is changing cluster. relation_members: relation_id (foreign key to relations + delete cascade), member_id (foreign key to vm_static + delete cascade).

#### UI

![Relations sub tab under clusters](relation-cluster.png "Relations sub tab under clusters")

An overview of all relations in cluster.

![Relations sub tab under clusters](relation-vm.png "Relations sub tab under clusters")

All relations per a single VM.

![Add/Edit Relation Dialog](relation-dialog.png "Add/Edit Relation Dialog")

Dialog for adding/editing a single relation, specifying Name, polarity, enforcement mode, and members (VMs).

#### Scheduling

Add affinity filter and weight module to oVirt's scheduler, and to all defined cluster policies (inc. user defined).

##### Affinity Filter

Filters out host according to affinity enforce mode (hard).

*   Fetches all (schedule) VM <big>hard</big> relations.
*   Fetches all VMs in the scheduled VM affinity groups (relations).
*   Removes all hosts that doesn't meet the relation hard enforce.

##### Affinity Weight Module

*   Fetches all (schedule) VM <big>soft</big> relations.
*   Fetches all VMs in the scheduled VM affinity groups (relations).
*   Score the hosts according to the affinity rules (positive/negative/no affinity).

#### REST API

TBD

<Category:SLA>
