---
title: oVirtSchedulerAPI
category: api
authors: doron, gchaplik, lhornyak, nslomian
---

# oVirt Scheduler API

## Summary

High level design can be found in the following page: [Features/oVirtScheduler](/develop/release-management/features/sla/ovirtscheduler.html)

## Owner

Name: Gilad Chaplik (gchaplik)

## Current status

Status: design

Last updated: ,

## Detailed Description

### oVirt Scheduler Concepts

*   Supports filters for hard constraints; filters out hosts according to a specific logic, then chained to allow complete filtering. This allows clearer code and robustness. Existing logic (pin-to-host, memory limitations, etc.) will be translated into filters.
*   Supports Cost Functions for soft constraints; scores filtered hosts according to a specific logic. Cost Functions also allows chaining for the same reasons.
*   Load balancing policies related to filters and cost functions. Balancing logic allows auto selection of a VM for migration (from over utilized host to non-over utilized hosts). Existing load balancing policies will be translated to the new format.
*   Additional policies, filters and cost functions may be added by users.
*   Supports Python (we may be able to allow others as well).

## API

Note on pending resources: whatever usage data is passed over to the engine, it must pass over the used and the pending resources together.

### Schedule

Called by Engine's commands: Run VM and Migrate VM- replaces current VdsSelector logic.

#### Filter

Signature:

         Host[] filter(Host[], properties)

*   Input: set of hosts, properties.
*   Output: set of Hosts (filtered according to filter logic).
*   Filters out all hosts that don't meet the filter requirements (hard constraint), similar to validations.
*   Filters support custom properties.
*   Filters are chained; by that the hosts list may decrease from one filter to another.

Code sample:

         filter(hosts[], properties) {
             vm = properties['vm']
             minimal_ram = vm['mem_size']
             filter(key=lambda host: host['available_mem'] > minimal_ram, hosts)
             return hosts
         }

Explanation: memory filter, the filter will exclude hosts that don't have enough RAM.

#### Cost Function

Signature:

         <Host, Integer>[] score(Host[], properties)

*   Input: set of hosts, properties.
*   Output: set of pairs, pair of host and its score → logically orders the Hosts.
*   The cost functions score each host according to its logic; different hosts may have the same score, and the same host may have different scores in different iterations.
*   Functions can be prioritized using Factors; default factor is 1.
*   Ultimately, using the filtered hosts, cost functions and factors, we will construct a cost table (see figure), which will order the hosts (we will try to run the VM on the first host, then second and so-forth).

Code sample:

         score(hosts[], properties) {
             costs = []
             for host in hosts:
                 costs += (host, host[usage_mem_percent])
             sorted(costs, key=lambda pair: pair[1])
             return costs #list of pairs
         }

Explanation: memory cost function, will score hosts according to available memory, this will cause memory even distribution among the hosts. ![](/images/wiki/Hosts.png)

Flow:

         schedule(filters, cost_functions, factors, hosts[], properties) {
             # go over all filters
             for (filter in filters)
                 hosts = filter(hosts, properties)
             # init cost table
             for (host in hosts)
           map += <host, 0>
             # go over all cost functions
             for (cost_function in cost_functions)
                 result = cost_function(hosts, properties)
                 # aggregate factored scores for all hosts               
                 for (host in hosts)
               map += <host, map[host] + result[host] * factors[cost_function]>
         }

### Balance

Called periodically. Each cluster may use a single balancing logic at any given time. oVirt's load balance supports built in VM balancing.

Signature

         <VM, Host[]> balance(Host[], properties)

*   Input: Hosts, properties (initial host list, custom properties map).
*   Output: VM, hosts (a VM to migrate, filtered hosts (non-over utilized hosts)).
*   Perform single balancing policy logic- replaces a manual selection of scheduled VM.
*   Select a VM to migrate based on balance logic, later the engine will try to migrate on one of the hosts returned by balance.
*   For the returned VM, a migration command will be invoked, which ultimately triggers a schedule call (see schedule), the initial schedule hosts list will be the balance non-over utilized hosts list (to prevent redundant migration to other over utilized hosts).
*   A user may provide a filter and/or a cost function. We strongly advice on making sure the selected balancing policy is aligned with the filters and cost functions lists. A cost function is a good way to correlate the logic. A filter may be used if filtering out over-utilized hosts is needed in scheduling process.

For example: for power saving policy, a CPU load cost-function is needed.

*   Performance/implementation open-issue: split balance into 2 methods:

Host BalanceHosts(Host[], properties)

<VM, Host[]> BalanceVM(VM[], properties)

Currently the user is responsible to fetch the relevant VMs.

Code sample:

         balance(hosts[], properties) {
             max_host = max(hosts, key=lambda host: host['usage_mem_percent']))
             vms_on_host = filter(key=lambda vm: vm['run_on_host'] = max_host['id'], vms)
             vm = vms_on_host[random(vms_on_host.size)]
             non_utilized_hosts =filter(key=lambda host: host['usage_mem_percent'] > properties['mem_threshold'], hosts)
       return <vm, non_utilized_hosts>
         }

## Design

Cluster's policy will have a set of filters, cost functions and a single balancing logic implementation. To allow easy coupling between the logic of these three, a single class will be provided.

         Class PolicyUnit
             filter
             cost_function
             balance

In this class only a single method ought to be implemented, but when balance is implemented it is advised to implement a cost-function, since it later influences migration processes, and being aligned with overall selection policy.

         Class ClusterPolicy
             <Filter, filterSequence(first,last,no-order), customParameters>[]
             <CostFunction, factor, customParameters>[]
       <Balance, customParameters>

Move current selection process into new arch: Policy Units and Cluster Policies:

| Policy Unit       | Filter                                                                        | Cost function                                    | Balance           | Parameters                                                           |
|-------------------|-------------------------------------------------------------------------------|--------------------------------------------------|-------------------|----------------------------------------------------------------------|
| Migration Domain  | Hosts that doesn't belong to the VM's cluster                                 |                                                  |                   |                                                                      |
| Migration         | Host that the VM is currently running                                         |                                                  |                   |                                                                      |
| Pin-to-host       | Other Hosts except the pinned host                                            |                                                  |                   |                                                                      |
| Memory            | Hosts that doesn't have sufficient Memory to run the VM, and have swap memory | Order Hosts according to available memory        |                   |                                                                      |
| CPU               | Hosts that doesn't meet the VM's CPU topology                                 |                                                  |                   |                                                                      |
| Network Policy    | Host that doesn't have all required networks installed                        |                                                  |                   |                                                                      |
| Even distribution |                                                                               | Order Hosts according to CPU usage (low to high) | Even distribution | HighCpuUtilization, CpuOverCommitDurationMinutes                     |
| Power saving      |                                                                               | Order Hosts according to CPU usage (high to low) | Power saving      | HighCpuUtilization , LowCpuUtilization, CpuOverCommitDurationMinutes |

Current Policies:

*   None (all above filters, without Even Distribution and Power Saving policy units).
*   Power Saving (all above except Even Distribution policy unit)
*   Even Distribution (all above except Power Saving policy unit)

## DB Scheme

### policy_unit table

| Name                       | Type    | Description                     | Relations |
|----------------------------|---------|---------------------------------|-----------|
| id                         | UUID    |                                 |           |
| name                       | string  | Class/File name                 |           |
| is_internal                | boolean | java = true, python = false     |           |
| has_filter                 | boolean | Does filter method implemented? |           |
| has_cost_function          | boolean | Does filter method implemented? |           |
| has_balance                | boolean | Does filter method implemented? |           |
| filter_parameters          | string  |                                 |           |
| cost_function_parameters   | string  |                                 |           |
| balance_parameters         | string  |                                 |           |

### policy table

| Name        | Type    | Description  | Relations |
|-------------|---------|--------------|-----------|
| id          | UUID    |              |           |
| name        | string  |              |           |
| is_locked   | boolean | non-editable |           |
| is_default  | boolean |              |           |

### policy-cluster table

| Name           | Type | Description | Relations        |
|----------------|------|-------------|------------------|
| Id             | UUID |             |                  |
| policy_id      | UUID |             | Policy table     |
| vds_group_id   | UUID |             | vds_group table  |

### policy-policy unit table

| Name                     | Type     | Description                                                      | Relations         |
|--------------------------|----------|------------------------------------------------------------------|-------------------|
| id                       | UUID     |                                                                  |                   |
| policy_id                | UUID     |                                                                  | Policy table      |
| policy_unit_id           | UUID     |                                                                  | Policy Unit table |
| filter_selected          | boolean  |                                                                  |                   |
| filter_sequence          | int/enum | execute filter first, last or no-order (for performance reasons) |                   |
| cost_function_selected   | boolean  |                                                                  |                   |
| factor                   | int      |                                                                  |                   |
| balance_selected         | boolean  |                                                                  |                   |

### policy parameters table

| Name                       | Type   | Description | Relations                |
|----------------------------|--------|-------------|--------------------------|
| id                         | UUID   |             |                          |
| policy-cluster-id          | UUID   |             | policy-cluster table     |
| policy-policy_unit-id      | UUID   |             | policy-policy unit table |
| filter_parameters          | string |             |                          |
| cost_function_parameters   | string |             |                          |
| balance_parameters         | string |             |                          |

## Concurrent Scheduler Invocations – and Pending Resources (memory, CPU)

When a scheduler call is invoked there is a need to dis-allow any other scheduler requests on that cluster. The scheduler decision is based on shared resources and those resources state should be visible only to a single selection at a time. Therefore there should be a lock protecting a single scheduler invocation and waiting for shared state to be updated. There are two timeouts: one on trying to acquire the lock, and the other on time the lock is held (both are configurable). In case a filtering process ended with no hosts and there is enough pending memory, the request should try to reacquire the lock and hopefully can be rescheduled when pending resources will become available. We can later consider a priory queue to give advantage to schedule VM requests that are likely to be scheduled successfully (give VM requests with less constraints and resources, higher priority).

## Permissions

Action Groups:

1) CreatePolicy(also 'clone' in the UI): Containing role should be attached to Cluster or higher.

2) Edit/Delete Policy: Containing role should be attached to all Clusters or higher attached to that policy.

2) Attach Policy to a Cluster: will be part of cluster add/new command, currently a permission for those command is sufficient.

## UI

![](/images/wiki/ClusterPolicyList.png)

*   Policies will be configured on a system level in configure dialog, much like Roles.

![](/images/wiki/ClusterPolicy.png)

*   pencil button, is used to update the custom property of the unit, derived from plugin's config default_value (optional)

![](/images/wiki/Attach_cluster_policy.png)

*   custom properties values are derived from policy configuration.

## REST

*   methods:

1.  api/schedulingpolicies; add; POST; type: SchedulingPolicy; response: SchedulingPolicy
2.  api/schedulingpolicies; get; GET; response: SchedulingPolicies
3.  api/schedulingpolicies/{schedulingpolicie:id}; get; GET; response: SchedulingPolicy
4.  api/schedulingpolicies/{schedulingpolicie:id}: update: PUT; type: SchedulingPolicy; response: SchedulingPolicy
5.  api/schedulingpolicies/{schedulingpolicie:id}/balances: add: POST; type: BaseResource; response: BaseResource
6.  api/schedulingpolicies/{schedulingpolicie:id}/balances: get: GET; response: Balances
7.  api/schedulingpolicies/{schedulingpolicie:id}/balances/{balance:id}: delete: DELETE
8.  api/schedulingpolicies/{schedulingpolicie:id}/balances/{balance:id}: get: GET; response: Balance
9.  api/schedulingpolicies/{schedulingpolicie:id}/filters: add: POST; type: BaseResource; response: BaseResource
10. api/schedulingpolicies/{schedulingpolicie:id}/filters: get: GET; response: Filters
11. api/schedulingpolicies/{schedulingpolicie:id}/filters/{filter:id}: delete: DELETE
12. api/schedulingpolicies/{schedulingpolicie:id}/filters/{filter:id}: get: GET; response: Filter
13. api/schedulingpolicies/{schedulingpolicie:id}/weights: add: POST; type: BaseResource; response: BaseResource
14. api/schedulingpolicies/{schedulingpolicie:id}/weights: get: GET; response: Weights
15. api/schedulingpolicies/{schedulingpolicie:id}/weights/{weight:id}: delete: DELETE
16. api/schedulingpolicies/{schedulingpolicie:id}/weights/{weight:id}: get: GET; response: Weight
17. api/schedulingpolicyunits: get: GET; response: SchedulingPolicyUnits
18. api/schedulingpolicyunits/{schedulingpolicyunit:id}: delete: DELETE
19. api/schedulingpolicyunits/{schedulingpolicyunit:id}: get: GET; response: SchedulingPolicyUnit

*   Elements (samples):
{% highlight xml %}
 <scheduling_policy_unit type="load_balancing" href="/ovirt-engine/api/schedulingpolicyunits/d58c8e32-44e1-418f-9222-52cd887bf9e0" id="d58c8e32-44e1-418f-9222-52cd887bf9e0">
   <name>OptimalForEvenGuestDistribution</name>
   <description>Even VM count distribution policy</description>
   <internal>true</internal>
   <enabled>true</enabled>
   <properties>
       <property>
           <name>HighVmCount</name>
           <value>^([0-9]|[1-9][0-9]+)$</value>
       </property>
       <property>
           <name>MigrationThreshold</name>
           <value>^([2-9]|[1-9][0-9]+)$</value>
       </property>
       <property>
           <name>SpmVmGrace</name>
           <value>^([0-9]|[1-9][0-9]+)$</value>
       </property>
   </properties>
 </scheduling_policy_unit>
 <scheduling_policy href="/ovirt-engine/api/schedulingpolicies/8d5d7bec-68de-4a67-b53e-0ac54686d579" id="8d5d7bec-68de-4a67-b53e-0ac54686d579">
   <name>vm_evenly_distributed</name>
   <description/>
   <link href="/ovirt-engine/api/schedulingpolicies/8d5d7bec-68de-4a67-b53e-0ac54686d579/filters" rel="filters"/>
   <link href="/ovirt-engine/api/schedulingpolicies/8d5d7bec-68de-4a67-b53e-0ac54686d579/weights" rel="weights"/>
   <link href="/ovirt-engine/api/schedulingpolicies/8d5d7bec-68de-4a67-b53e-0ac54686d579/balances" rel="balances"/>
   <link href="/ovirt-engine/api/schedulingpolicies/8d5d7bec-68de-4a67-b53e-0ac54686d579/clusters" rel="clusters"/>
   <locked>true</locked>
   <default_policy>false</default_policy>
   <properties>
       <property>
           <name>HighVmCount</name>
           <value>10</value>
       </property>
       <property>
           <name>MigrationThreshold</name>
           <value>5</value>
       </property>
       <property>
           <name>SpmVmGrace</name>
           <value>5</value>
       </property>
   </properties>
 </scheduling_policy>
 <filters>
   <filter id="84e6ddee-ab0d-42dd-82f0-c297779db566">
       <scheduling_policy_unit href="/ovirt-engine/api/schedulingpolicyunits/84e6ddee-ab0d-42dd-82f0-c297779db566" id="84e6ddee-ab0d-42dd-82f0-c297779db566"/>
       <position>0</position>
   </filter>
         ...
 </filters>
 <cluster href="/ovirt-engine/api/clusters/00000001-0001-0001-0001-000000000086" id="00000001-0001-0001-0001-000000000086">
       ...
   <scheduling_policy href="/ovirt-engine/api/schedulingpolicies/20d25257-b4bd-4589-92a6-c4c5c5d3fd1a" id="20d25257-b4bd-4589-92a6-c4c5c5d3fd1a">
       <name>evenly_distributed</name>
       <policy>evenly_distributed</policy>
       <thresholds high="80" duration="120"/>
       <properties>
           <property>
               <name>CpuOverCommitDurationMinutes</name>
               <value>2</value>
           </property>
           <property>
               <name>HighUtilization</name>
               <value>80</value>
           </property>
       </properties>
   </scheduling_policy>
       ...
 </cluster>
{% endhighlight %}
## External Scheduler

See [External Scheduler](/develop/release-management/features/sla/external-scheduling-proxy.html)

