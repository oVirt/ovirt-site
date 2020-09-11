---
title: VM-Affinity
category: feature
authors: adahms, gchaplik
---

# VM Affinity

## Summary

The oVirt scheduler capabilities introduced in version 3.3 have opened opportunities to enhance how virtual machine workloads are scheduled to run in a cluster. By using the filtering and weighing mechanisms introduced in the Scheduler, it is now possible to apply Affinity and Anti-Affinity rules to virtual machines to manually dictate scenarios in which virtual machines should run together on the same hypervisor host, or separately on different hypervisor hosts.

### Owners

*   Name: Scott Herold (sherold)
*   Email: <sherold@redhat.com>
*   Name: Yanir Quinn (yquinn)
*   Email: <yquinn@redhat.com>

### Current status

*   Status: merged, version: 3.4
*   Last updated: ,

## Benefits to oVirt

*   Leverages the oVirt Scheduler to manually assign virtual machine workload affinity policies
*   Enables users to accommodate advanced workload scenarios
    -   Strict licensing requirements
    -   High Availability Workload planning

### Terminology

*   Affinity Group - A group of two or more virtual machine for which a set of identical conditions and parameters are applied.
*   Affinity Policy - The combination of an Affinity Group, a Condition statement, and optional Parameters. For example, VM A, VM B, and VM C Must Run Together on Host 1.
*   VM Affinity - Affinity that is applied at the virtual machine entity level regardless of its workload characteristics.
*   Positive Affinity (Run Together) - An affinity policy can be set as a Run Together policy to dictate that the identified virtual machines are to be run on the same hypervisor host.
*   Anti (Negative) Affinity (Run Independently) - An affinity policy can be set as Run Independently to dictate that the identified virtual machines are to be run on separate hypervisor hosts.
*   Must Condition (enforce = hard) - This is a hard condition which indicates that two or more virtual machines are required to run either on the same hypervisor host or on independent hypervisor hosts, regardless of external circumstances.
*   Should Condition (enforce = soft) - This is a soft condition which indicates that there is a preference that two or more virtual machines run either on the same hypervisor host or on independent hypervisor hosts, but is not a hard requirement.

## Detailed Description

A new entity has been defined in the system called Affinity Group. An Affinity Group will hold a set of virtual machines (could be other entities later on) and properties. Each virtual machine can be associated with multiple groups. The virtual machine will be scheduled according to the rules defined in the affinity groups (properties and members) to which that virtual machine belongs.

### Engine

#### Queries

*   getAllAffinityGroupsByClusterId

Populates Affinity Groups subtab in clusters main tab

*   getAffinityGroupsByVmId

Populates Affinity Groups subtab in VMs main tab

#### Commands

Adding CRUD actions for Affinity Groups, currently supported only in the admin portal (user portal support will be added later- if needed) MLA: adding new action group for manipulate Affinity Groups (including all CRUD commands), this action group will be added to ClusterAdmin Role and above.

New commands:

*   AddAffinityGroup

Adds a Affinity Group to the engine.

*   RemoveAffinityGroup

Removes a Affinity Group from the engine.

*   EditAffinityGroup

Edits a Affinity Group, making it possible to add or remove virtual machines to or from an Affinity Group. Altered Commands:

*   ChangeVmCluster

When a virtual machine is moved from one cluster to another, we need to remove its reference from all Affinity Groups (open question: should such actions fail if the virtual machine is associated with an Affinity Group?).

### Data Base

Tables: affinity_groups: id, name, cluster_id (foreign key to vds_groups + delete cascade), affinity_group_type (positive/negative), enforcement (hard/soft).

affinity_group_members: affinity_group_id (foreign key to affinity_groups + delete cascade), member_id (foreign key to vm_static + delete cascade).

### UI

![Relations sub tab under clusters](/images/wiki/Relation-cluster.png "Relations sub tab under clusters")

An overview of all Affinity Groups in the cluster.

![Relations sub tab under clusters](/images/wiki/Relation-vm.png "Relations sub tab under clusters")

All Affinity Groups associated with a single virtual machine.

![Add/Edit Relation Dialog](/images/wiki/Relation-dialog.png "Add/Edit Relation Dialog")

Dialog for adding or editing a single relation, specifying Name, polarity, enforcement mode, and members (virtual machines). The virtual machine drop-down menu should support typing (a suggestion combo box) for quick selection.

### Scheduling

Add affinity filter and weight module to oVirt's scheduler, and add those to all cluster policies (inc. user defined).

#### Affinity Filter

Filters out host according to affinity enforce mode (hard).

*   Fetches all (scheduled) VM <big>hard</big> Affinity Groups.
*   Fetches all VMs who are members in the scheduled VM Affinity Groups.
*   Removes all hosts that doesn't meet the Affinity Group hard enforce:
    -   for positive affinity, in case a VM of the group is running on a certain host, remove all other hosts.
    -   for negative affinity, for each running VM in the group, remove its host.

#### Affinity Weight Module

*   Fetches all (schedule) VM <big>soft</big> Affinity Groups.
*   Fetches all VMs who are members in the scheduled VM Affinity Groups.
*   Score the hosts according to the soft enforcement Affinity Groups:
    -   for positive affinity, in case a VM of the group is running on a certain host, give all other hosts a higher weight.
    -   for negative affinity, for each running VM in the group, give the VM's host higher weight.

### REST API

A new type was added to the engine's API model - **AffinityRule** . It has two attributes: one for virtual machines and another for hosts.

```xml
<vms_rule>
  <positive>true|false</positive>
  <enforcing>true|false</enforcing>
  <enabled>true|false</enabled>
</vms_rule>
<hosts_rule>
  <positive>true|false</positive>
  <enforcing>true|false</enforcing>
  <enabled>true|false</enabled>
</hosts_rule>
```

  >**NOTE** : The existing positive and enforcing attributes (for vms) will be preserved, and marked as deprecated.
   They will have the same meaning that they had before.

Here are more examples:


GET /api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups

```xml
<affinity_groups>
  <affinity_group href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f" id="31ef70c1-e636-45a6-9492-aa4fad753e6f">
    <name>Test_aff_group</name>
    <link href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/vms" rel="vms"/>
    <cluster href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222" id="00000002-0002-0002-0002-000000000222"/>
    <positive>true</positive>
    <enforcing>true</enforcing>
    <vms_rule>
      <positive>true</positive>
      <enforcing>true</enforcing>
      <enabled>true</enabled>
    </vms_rule>
  </affinity_group>
</affinity_groups>
```

GET /api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/vms

```xml
<vms>
  <vm href="/ovirt-engine/api/vms/d4532fce-787b-4e45-ab35-018a1df55e35" id="d4532fce-787b-4e45-ab35-018a1df55e35"/>
</vms>
```

POST /api/clusters/00000002-0002-0002-0002-00000000017a/affinitygroups

```xml
<affinity_group>
    <name>Affinity_Group_A</name>
    <vms>
        <vm id="adf661d2-747e-4e74-a6bc-25fa2a457c5e"/>
        <vm id="1b0a1ceb-525c-4a12-afee-907c99fac106"/>
    </vms>
    <positive>true</positive>
    <enforcing>true</enforcing>
    <vms_rule>
        <enabled>true</enabled>
        <enforcing>true</enforcing>
        <positive>true</positive>
    </vms_rule>
    <cluster id="00000002-0002-0002-0002-00000000017a"/>
</affinity_group>
```

PUT /api/clusters/00000002-0002-0002-0002-00000000017a/affinitygroups/e7237677-ff5c-47a4-877c-194d525d5f92

DELETE /api/clusters/00000002-0002-0002-0002-00000000017a/affinitygroups/e7237677-ff5c-47a4-877c-194d525d5f92



[Affinity Rules Enforcement Manager](/develop/release-management/features/sla/affinity-rules-enforcement-manager.html)
[VM to host Affinity](/develop/release-management/features/sla/soft-host-to-vm-affinity-support.html)
