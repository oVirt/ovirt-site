---
title: oVirtSchedulerAPI
category: api
authors: doron, gchaplik, lhornyak, nslomian
wiki_category: Feature
wiki_title: Features/oVirtSchedulerAPI
wiki_revision_count: 57
wiki_last_updated: 2014-06-30
---

# oVirt Scheduler API [WIP]

### Summary

Link to scheduler API summary.

### Owner

Name: [ Gilad Chaplik](User:gchaplik) Email: <gchaplik@redhat.com>

### Current status

Status: design

Last updated: ,

### Detailed Description

#### oVirt Scheduler Concepts

*   Supports filters for hard constraints; filters out hosts according to a specific logic, then chained to allow complete filtering. This allows clearer code and robustness. Existing logic (pin-to-host, memory limitations, etc.) will be translated into filters.
*   Supports Cost Functions for soft constraints; scores filtered hosts according to a specific logic. Cost Functions also allows chaining for the same reasons.
*   Load balancing policies related to filters and cost functions. Balancing logic allows auto selection of a VM for migration (from over utilized host to non-over utilized hosts). Existing load balancing policies will be translated to the new format.
*   Additional policies, filters and cost functions may be added by users.
*   Supports Python (we may be able to allow others as well).

### API

#### Schedule

Called by Engine's commands: Run VM and Migrate VM- replaces current VdsSelector logic.

##### Filter

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

##### Cost Function

Signature:

         `<Host, Integer>`[] score(Host[], properties)

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

Explanation: memory cost function, will score hosts according to available memory, this will cause memory even distribution among the hosts. ![](Hosts.png "fig:Hosts.png")

Flow:

         schedule(filters, cost_functions, factors, hosts[], properties) {
             # go over all filters
             for (filter in filters)
                 hosts = filter(hosts, properties)
             # init cost table
             for (host in hosts)
`           map += `<host, 0>
             # go over all cost functions
             for (cost_function in cost_functions)
                 result = cost_function(hosts, properties)
                 # aggregate factored scores for all hosts               
                 for (host in hosts)
`               map += `<host, map[host] + result[host] * factors[cost_function]>
         }

#### Balance

Called periodically. Each cluster may use a single balancing logic at any given time. oVirt's load balance supports built in VM balancing. Signature

         `<VM, Hosts>` balance(Host[], properties)

*   Input: Hosts, properties (initial host list, custom properties map).
*   Output: VM, hosts (a VM to migrate, balance over utilized hosts).
*   Perform single balancing policy logic- replaces a manual selection of scheduled VM.
*   Select a VM to migrate based on balance logic.
*   For the returned VM, a migration command will be invoked, which ultimately triggers a schedule call (see schedule), the initial schedule hosts list will exclude the balance over utilized hosts list (to prevent redundant migration to other over utilized hosts).
*   A user may provide a filter and/or a cost function. We strongly advice on making sure the selected balancing policy is aligned with the filters and cost functions lists. A cost function is a good way to correlate the logic. A filter may be used if filtering under-utilized hosts is needed in scheduling process.

For example: for power saving policy, a CPU load cost-function is needed.

*   Performance/implementation open-issue: split balance into 2 methods:

Host BalanceHosts(Host[], properties) <VM, Hosts> BalanceVM(VM[], properties) Currently the user is responsible to fetch the relevant VM. Code sample:

         balance(hosts[], vms[], properties) {
             max_host = max(hosts, key=lambda host: host['usage_mem_percent']))
             vms_on_host = filter(key=lambda vm: vm['run_on_host'] = max_host['id'], vms)
             vm = return vms_on_host[0]
             return vm
         }

### Design

Cluster's policy will have a set of filters, cost functions and a single balancing logic implementation. To allow easy coupling between the logic of these three, a single class will be provided.

         Class PolicyUnit
             filter
             cost_function
             balance

In this class only a single method ought to be implemented, but when balance is implemented it is advised to implement a cost-function, since it later influences migration processes, and being aligned with overall selection policy.

         Class ClusterPolicy
             `<Filter, filterSequence(first,last,no-order), filterParameters>`[]
             `<CostFunction, factor, filterParameters>`[]
`       `<Balance, balanceParameters>

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

### Concurrent Scheduler Invocations – and Pending Resources (memory, CPU)

When a scheduler call is invoked there is a need to dis-allow any other scheduler requests on that cluster. The scheduler decision is based on shared resources and those resources state should be visible only to a single selection at a time. Therefore there should be a lock protecting a single scheduler invocation and waiting for shared state to be updated. There are two timeouts: one on trying to acquire the lock, and the other on time lock held. In case a filtering process ended with no hosts and there is enough pending memory, the request should try to reacquire the lock and hopefully can be rescheduled when pending resources will become available.

The lock considers cluster's hosts available and pending resources:

Lock Conditions:

| Lock status               | Available resources | No Available resources + Available pending resources | No available resources |
|---------------------------|---------------------|------------------------------------------------------|------------------------|
| unlocked                  | acquire lock        | wait till timeout                                    | fail                   |
| Locked                    | wait till timeout   | wait till timeout                                    | fail                   |
| Pending resources changed | acquire lock        | wait till timeout                                    | fail                   |

We can later consider a priory queue to give advantage to VMs that are likely to be scheduled successfully (give VMs with less constraints and resources higher priority).

### DB Scheme

#### policy_unit table

| Name                       | Type    | Description                     | Relations |
|----------------------------|---------|---------------------------------|-----------|
| id                         | UUID    |                                 |           |
| name                       | string  | Class/File name                 |           |
| has_filter                | boolean | Does filter method implemented? |           |
| has_cost_function        | boolean | Does filter method implemented? |           |
| has_balance               | boolean | Does filter method implemented? |           |
| filter_parameters         | string  |                                 |           |
| cost_function_parameters | string  |                                 |           |
| balance_parameters        | string  |                                 |           |

#### policy table

| Name        | Type    | Description | Relations |
|-------------|---------|-------------|-----------|
| id          | UUID    |             |           |
| name        | string  |             |           |
| is_default | boolean |             |           |

*   'edit policy' action for policies attached to other cluster(s), will clone and edit current policy.

#### policy-cluster table

| Name           | Type | Description | Relations        |
|----------------|------|-------------|------------------|
| Id             | UUID |             |                  |
| policy_id     | UUID |             | Policy table     |
| vds_group_id | UUID |             | vds_group table |

*   policy_id can be added to cluster table (I prefer not).

#### policy-policy unit table

| Name                     | Type     | Description                                                      | Relations         |
|--------------------------|----------|------------------------------------------------------------------|-------------------|
| id                       | UUID     |                                                                  |                   |
| policy_id               | UUID     |                                                                  | Policy table      |
| policy_unit_id         | UUID     |                                                                  | Policy Unit table |
| filter_selected         | boolean  |                                                                  |                   |
| filter_sequence         | int/enum | execute filter first, last or no-order (for performance reasons) |                   |
| cost_function_selected | boolean  |                                                                  |                   |
| factor                   | int      |                                                                  |                   |
| balance_selected        | boolean  |                                                                  |                   |

#### policy parameters table

| Name                       | Type   | Description | Relations                |
|----------------------------|--------|-------------|--------------------------|
| id                         | UUID   |             |                          |
| policy-cluster-id          | UUID   |             | policy-cluster table     |
| policy-policy_unit-id     | UUID   |             | policy-policy unit table |
| filter_parameters         | string |             |                          |
| cost_function_parameters | string |             |                          |
| balance_parameters        | string |             |                          |

### MLA

Action Groups:

1) Create/EditPolicy (including edit custom properties; to get impact, containing role should be attached to Cluster/DC/System level).

2) DeletePolicy (to get impact, containing role should be attached to System level).

### In Progress

1.  UI
2.  REST

### TBD

1.  Upgrade DB to new architecture

### Later Phases

1.  External Scheduler.
2.  External scheduler invocation – first run internal filters/cost-functions, and then external.

<Category:Feature> <Category:SLA>
