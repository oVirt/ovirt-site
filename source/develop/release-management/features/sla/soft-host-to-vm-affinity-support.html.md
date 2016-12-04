---
title: soft-host-to-vm-affinity-support
category: feature
authors: yquinn,msivak
feature_name: Soft host to VM affinity support
feature_modules: sla
feature_status: Design / partly implementaion stage
---

# Soft host to VM affinity support and Rack use case

## Summary
Certain set of VMs form a logical management unit and should run on a certain set of hosts for SLA or management (e.g. a separate rack for each customer). The VMs can run anywhere in case the dedicated rack needs to be turned off, but should return to their dedicated hosts once the rack is back up.

This would be best implemented by enhancing the current VM to VM soft affinity rules to support hosts as well. The other piece that is needed is to add affinity based balancing operation to allow the VMs to return to the proper host when it becomes available.

### Owners

*   Name: Yanir Quinn (yquinn)
*   Email: <yquinn@redhat.com>
    
## Detailed Description
 
Add additional affinity lists and relationships to the existing affinity object so it would contain:

*   Vms_affinity_enabled flag (true/false)
*   VM list
*   VM to VM affinity rule (positive weak, pos. strong, negative weak, neg. strong,disabled)
*   Host list
*   VM to Host affinity rule (positive weak, pos. strong, negative weak, neg. strong)
*   Any other additional resource
*   Rule for the additional resource (positive weak, pos. strong, negative weak, neg. strong)

### Benefit to oVirt
Enhance affinity groups to support vm to host affinity.

### Data Base

the plan is to add more resources like hosts to affinity groups.

The table structure of *affinity_group_members* will be altered

*From* :  affinity_group_id (foreign key to affinity_groups + delete cascade) |  vm_id (foreign key to vm_static + delete cascade)

*To* :      affinity_group_id (foreign key to affinity_groups + delete cascade) | vm_id (foreign key to vm_static + delete cascade) - **change modifier to enable null**   | **vds_id (foreign key to vds_static + delete cascade)**
(any additional future resource can be added here with an index and a foreign key)

* Added a constraint to check that at least one column out of vm_id and vds_id is not null for each entry.

The table structure of affinity_groups will altered by adding a new none column:

*affinity_groups*: id, name, cluster_id (foreign key to vds_groups + delete cascade), **positive -> vm_positive
,enforcing -> vm_enforcing ,vds_positive,vds_enforcing ,vms_affinity_enabled (true/false  - default false)**

>**NOTE** : The additional “vms_affinity_enabled”  flag is needed for affinity group to be able to express that VMs in an affinity group have no relationship to each other.

>**NOTE** : for each affinity group there must be at least one entry with a vm_id in affinity_group_members table (even only for a vm to host affinity).


### Scheduler
*   Modify VmAffinity filter and weight policy units to exclude affinity groups with vms_affinity_enabled = false;
*   Add new filter policy unit **VmToHostAffinityFilterPolicyUnit** which:
Enables Affinity Groups hard enforcement for VMs to hosts; VMs in group are required to run either on one of the hosts in group (positive) or on independent hosts which are excluded from the hosts in group (negative).                              
*   Add new weight policy unit **VmToHostAffinityWeightPolicyUnit** which:
Enables Affinity Groups soft enforcement for VMs to hosts; VMs in group are most likely to run either on one of the hosts in group (positive) or on independent hosts which are excluded from the hosts in group (negative)
*   Add new Load balancer - vms To Hosts Affinity Balancer  (Future development to be done) 

#### Affinity Rules Enforcement Manager
Enhance or rewrite AREM to properly enforce violated affinity rules
TBD

####UI
First stage - Inorder no to break the current vm to vm affinity functionality, an additional 
check box will be added to the Affinity group panel : **Vm Affinity Enabled** 

When checked - the original behavior of vm to vm affinity will be preserved.

When unchecked - vm to vm affinity rules will not apply. 

Host to vm affinity settings will be provided currently only via the rest api.

#### REST API
The current solution will be enhanced to support the additional hosts list and the new attributes
for vms and hosts lists.

A new type will be added - **AffinityGroupEntitiesConfiguration** with two arrtibutes of that type,
one for virtual machines and another for hosts:
```xml
<vms_configuration>
  <positive>true|false</positive>
  <enforcing>true|false</enforcing>
  <enabled>true|false</enabled>
</vms_configuration>
<hosts_configuration>
  <positive>true|false</positive>
  <enforcing>true|false</enforcing>
  <enabled>true|false</enabled>
</hosts_configuration>
```

>**NOTE** : The existing positive and enforcing attributes (for vms) will be preserved, and marked as deprecated.
They will have the same meaning that they had before.

See example:

GET /api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups

```xml

<affinity_groups>
  <affinity_group href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f" id="31ef70c1-e636-45a6-9492-aa4fad753e6f">
    <name>Test_aff_group</name>
    <link href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/vms" rel="vms"/>
    <link href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/vms" rel="hosts"/>
    <cluster href="/ovirt-engine/api/clusters/00000002-0002-0002-0002-000000000222" id="00000002-0002-0002-0002-000000000222"/>     
    <positive>true</positive>
    <enforcing>true</enforcing>
    <vms_configuration>
      <positive>true</positive>
      <enforcing>true</enforcing>
      <enabled>true</enabled>
    </vms_configuration>
    <hosts_configuration>
      <positive>true</positive>
      <enforcing>false</enforcing>
      <enabled>true</enabled>
    </hosts_configuration>
  </affinity_group>
</affinity_groups>
```
GET /api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/vms

```xml
<vms>
  <vm href="/ovirt-engine/api/vms/d4532fce-787b-4e45-ab35-018a1df55e35" id="d4532fce-787b-4e45-ab35-018a1df55e35"/>
</vms>
```

GET /api/clusters/00000002-0002-0002-0002-000000000222/affinitygroups/31ef70c1-e636-45a6-9492-aa4fad753e6f/hosts
```xml
<hosts>
  <host href="/ovirt-engine/api/hosts/d4532fce-787b-4e45-ab35-018a1df55e35" id="d4532fce-787b-4e45-ab35-018a1df55e35"/>
</hosts>
```




For more information see the following BugZilla link:
<https://bugzilla.redhat.com/show_bug.cgi?id=1392393>


[Affinity Rules Enforcement Manager](/develop/release-management/features/affinity-rules-enforcement-manager/) 
[VM Affinity] (/develop/release-management/features/sla/vm-affinity/)
