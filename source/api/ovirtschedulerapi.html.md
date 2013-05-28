---
title: oVirtSchedulerAPI
category: api
authors: doron, gchaplik, lhornyak, nslomian
wiki_category: Feature
wiki_title: Features/oVirtSchedulerAPI
wiki_revision_count: 57
wiki_last_updated: 2014-06-30
---

# oVirt Scheduler API

### Summary

High level design can be found in the following page: [Features/oVirtScheduler](Features/oVirtScheduler)

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

Called periodically. Each cluster may use a single balancing logic at any given time. oVirt's load balance supports built in VM balancing.

Signature

         `<VM, Host[]>` balance(Host[], properties)

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
`       return `<vm, non_utilized_hosts>
         }

### Design

Cluster's policy will have a set of filters, cost functions and a single balancing logic implementation. To allow easy coupling between the logic of these three, a single class will be provided.

         Class PolicyUnit
             filter
             cost_function
             balance

In this class only a single method ought to be implemented, but when balance is implemented it is advised to implement a cost-function, since it later influences migration processes, and being aligned with overall selection policy.

         Class ClusterPolicy
             `<Filter, filterSequence(first,last,no-order), customParameters>`[]
             `<CostFunction, factor, customParameters>`[]
`       `<Balance, customParameters>

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

### DB Scheme

#### policy_unit table

| Name                       | Type    | Description                     | Relations |
|----------------------------|---------|---------------------------------|-----------|
| id                         | UUID    |                                 |           |
| name                       | string  | Class/File name                 |           |
| is_internal               | boolean | java = true, python = false     |           |
| has_filter                | boolean | Does filter method implemented? |           |
| has_cost_function        | boolean | Does filter method implemented? |           |
| has_balance               | boolean | Does filter method implemented? |           |
| filter_parameters         | string  |                                 |           |
| cost_function_parameters | string  |                                 |           |
| balance_parameters        | string  |                                 |           |

#### policy table

| Name        | Type    | Description  | Relations |
|-------------|---------|--------------|-----------|
| id          | UUID    |              |           |
| name        | string  |              |           |
| is_locked  | boolean | non-editable |           |
| is_default | boolean |              |           |

#### policy-cluster table

| Name           | Type | Description | Relations        |
|----------------|------|-------------|------------------|
| Id             | UUID |             |                  |
| policy_id     | UUID |             | Policy table     |
| vds_group_id | UUID |             | vds_group table |

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

### Concurrent Scheduler Invocations – and Pending Resources (memory, CPU)

When a scheduler call is invoked there is a need to dis-allow any other scheduler requests on that cluster. The scheduler decision is based on shared resources and those resources state should be visible only to a single selection at a time. Therefore there should be a lock protecting a single scheduler invocation and waiting for shared state to be updated. There are two timeouts: one on trying to acquire the lock, and the other on time the lock is held (both are configurable). In case a filtering process ended with no hosts and there is enough pending memory, the request should try to reacquire the lock and hopefully can be rescheduled when pending resources will become available. We can later consider a priory queue to give advantage to schedule VM requests that are likely to be scheduled successfully (give VM requests with less constraints and resources, higher priority).

### Permissions

Action Groups:

1) CreatePolicy(also 'clone' in the UI): Containing role should be attached to Cluster or higher.

2) Edit/Delete Policy: Containing role should be attached to all Clusters or higher attached to that policy.

2) Attach Policy to a Cluster: will be part of cluster add/new command, currently a permission for those command is sufficient.

### UI

![](clusterPolicyList.png "clusterPolicyList.png")

*   Policies will be configured on a system level in configure screen.

![](ClusterPolicy.png "ClusterPolicy.png")

*   pencil button, is used to update the custom property of the unit, derived from plugin's config default_value (optional)

![](attach_cluster_policy.png "attach_cluster_policy.png")

*   custom properties values are derived from policy configuration.

### REST

*   In Progress

### Packaging and Installation

*   In Progress

### External Scheduler

The external scheduler is a daemon and its purpose is for oVirt users to extend the scheduling process with custom python filters, scoring functions and load balancing functions. As mentioned above any plugin file {NAME}.py must implement at least one of the functions. The service will be started by the installer, and the engine will be able to communicate with it using XML-RPC.

*   Scheduler conf file (etc/ovirt/scheduler/schecduler.conf), optional (defaults):

listerning port=# (18781) ssl=true/false (true) plugins_path=/path ($PYTHONPATH/ovirt_scheduler/plugins) Additionally for every python plugin an optional config file can be added (etc/ovirt/scheduler/plugins/{NAME}.conf).

#### External Daemon RPCs

Engine and external scheduler API:

*   Discover(void): returns a JSON containing all available policy units and configurations (configuration is optional).

Dicover will iterate all plugins and config files and extract the data.

Sample:

         {
           "PolicyUnits": {
             "Filters": {
               "Filter": [
                 { "name": "Memory" },
                 {
                   "name": "Heat",
                   "filter_custom_properties": "server_ip=\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b;threshold={0-99}",
                   "default_values": "127.0.0.1;70"
                 }
               ]
             },
             "CostFunctions": {
               "CostFunction": { "name": "Memory" }
             },
             "Balances": {
               "Balance": { "name": "Memory" }
             }
           }
         }

note: name is the file name and filter_custom_properties and default_values are fetched from plugin config file.

The engine will call this method during initialization to expose all plugins. It will compare its persistent data (policy unit table) with returned plugins/configurations, and handle changes:

         * additional plugins: audit log.
         * deleted plugins: need to make sure that the plugins isn't in use, if so disable the policy and audit log.
         * edited plugins: save checksum?

The following methods are similar to the engine's flow explained above with one exception: serialization.

* Returns UUID instead of a full business entity (no need for serialization).

* Prior to invoking the remote procedure, the engine translates Host and VM business entities to their REST representations (rest mappers) and then convert it to XML string (using JAXB marshaling), then in the daemon it will be serialized back to python entity using ovirt-python-sdk (import ovirtsdk.xml.params.parseString auto generated module). This is similar to the way REST-API works.

*   List<UUID> runFilters(filtersList, Hosts(as xml), VM(as xml), properties_map)

runFilters will execute a set of filters plugins sequentially (provided as a name list).

*   List<UUID, int> runCostFunctions(<costFunction,Factor>List, Hosts(as xml), VM(as xml), properties_map)

runCostFunctions will execute a set of cost function plugins sequentially (provided as a name list), then calculate a cost table (using factors) and return it to the engine.

*   <UUID, List<UUID>> runLoadBalancing(balanceName, Hosts(as xml), properties_map)

Will execute the balance plugin named balance name on the hosts and properties_map.

<Category:Feature> <Category:SLA>
