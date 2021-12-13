---
title: oVirt External Scheduling Proxy
category: feature
authors:
  - doron
  - lhornyak
---

# External Scheduler Proxy

> IMPORTANT: The oVirt Scheduler Proxy project has been dropped from oVirt starting with oVirt 4.5 release.
> The oVirt Scheduler Proxy project development has been discontinued.
>
> See also:
> - https://bugzilla.redhat.com/show_bug.cgi?id=2028192
>
> Keeping the following section only for reference.


## Summary

## Owner

*   Name: Martin Sivak (msivak)
*   Email: <msivak at redhat dot com>

## Current status

*   Specification phase

## Detailed Description

The external scheduler is a daemon and its purpose is for oVirt users to extend the scheduling process with custom python filters, scoring functions and load balancing functions. As mentioned above any plugin file `{NAME}.py` must implement at least one of the functions. The service will be started by the installer, and the engine will be able to communicate with it using XML-RPC.

*   Scheduler conf file (`/etc/ovirt/scheduler/scheduler.conf`), optional (defaults):
```
      #listerning port=18781
      #ssl=true
      #plugins_path=$PYTHONPATH/ovirt_scheduler/plugins
```
*   Additionally for every python plugin an optional config file can be added (`/etc/ovirt/scheduler/plugins/{NAME}.conf`).

## Benefit to oVirt

The external scheduler will allow system administrators to extend the scheduling logic by writing host selection filters in python.

## Dependencies / Related Features

This feature is building on

*   [oVirt scheduler API](/develop/release-management/features/sla/ovirtschedulerapi.html) feature.

This feature will also allow new feaures to build on it.

## Documentation / External references

*   All except discover function returns only UUID instead of a full business entity since there is no need for serialization.
*   Prior to invoking the remote procedure, the engine translates Host and VM business entities to their REST representations (rest mappers) and then convert it to XML string (using JAXB marshaling), then in the daemon it will be serialized back to python entity using ovirt-python-sdk (import ovirtsdk.xml.params.parseString auto generated module). This is similar to the way REST-API works.

### discover

Engine and external scheduler API:

*   `Discover(void)`: returns a XML containing all available policy units and configurations (configuration is optional).

Discover will iterate all plugins and config files and extract the data.

Sample of data returned by the discover function:

{% highlight xml %}
<PolicyUnits>
  <Filters>
    <Filter>
      <name>Memory</name>
      <Properties>
        <name>Heat</name>
        <CustomProperties>server_ip=\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b;threshold={0-99}</CustomProperties>
        <default_values>127.0.0.1;70</default_values>
      </Properties>
   </Filter>
  </Filters>
  <CostFunctions>
    <CostFunction name="Memory"/>
  </CostFunctions>
  <Balances>
    <Balance name="Memory"/>
  </Balances>
</PolicyUnits>
{% endhighlight %}

note: name is the file name and customProperties and defaultValues are fetched from plugin config file.

The engine will call this method during initialization to expose all plugins. It will compare its persistent data (policy unit table) with returned plugins/configurations, and handle changes:

         * additional plugins: audit log.
         * deleted plugins: need to make sure that the plugins isn't in use, if so disable the policy and audit log.
         * edited plugins: save checksum?

### runFilters

*   `List<UUID> runFilters(filtersList, Hosts(as xml), VM(as xml), properties_map)`

runFilters will execute a set of filters plugins sequentially (provided as a name list).

### runCostFunctions

*   `Map<UUID, int> runCostFunctions(<costFunction,Factor>List, Hosts(as xml), VM(as xml), properties_map)`

runCostFunctions will execute a set of cost function plugins sequentially (provided as a name list), then calculate a cost table (using factors) and return it to the engine.

### runLoadBalancing

*   `Map <UUID, List<UUID>> runLoadBalancing(balanceName, Hosts(as xml), properties_map)`

Will execute the balance plugin named balance name on the hosts and properties_map.

## Testing


