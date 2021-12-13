---
title: Host Memory balance
authors: nslomian
---

> IMPORTANT: The oVirt Scheduler Proxy project has been dropped from oVirt starting with oVirt 4.5 release.
> The oVirt Scheduler Proxy project development has been discontinued.
>
> See also:
> - https://bugzilla.redhat.com/show_bug.cgi?id=2028192
>
> Keeping the following section only for reference.



# Host Memory balance

This external load balancer will move a VM from a host that has less free memory than the specified amount:

This one is quite large, so lets break it down

Loading of the RESTAPI sdk, so we can do rest calls

      from ovirtsdk.xml import params
      from ovirtsdk.api import API
      import sys

Our lovely class

      class host_memory_balance(object):
`   `**`migrate` `vms` `from` `over` `utilized` `hosts`**

What are the values a user can pass to this load balancer. (they will be shown as options in the UI)

In this instance the minimum memory threshold and should we be safe with the migration (try to move the smallest VM)

         #What are the values this module will accept, used to present
         #the user with options
         properties_validation = 'minimum_host_memoryMB=[0-9]*;safe_selection=True|False'

Class members

         TO_BYTES = 1024 * 1024
         MINIMUM_MEMORY_DEFAULT = 500
         SAFE_SELECTION_DEFAULT = 'True'
         free_memory_cache = {}

Connect to the REST webservice

         def _get_connection(self):
             #open a connection to the rest api
             connection = None
             try:
                 connection = API(url='`[`http://host:port`](http://host:port)`',
                                  username='user@domain', password='')
             except BaseException as ex:
                 #letting the external proxy know there was an error
                 print >> sys.stderr, ex
                 return None
             return connection

Query the REST for these hosts

         def _get_hosts(self, host_ids, connection):
             #get all the hosts with the given ids
             engine_hosts = connection.hosts.list(
                 query=" or ".join(["id=%s" % u for u in host_ids]))
             return engine_hosts

Get a hosts free memory, this requires a REST call, so we cache the results

         def getFreeMemory(self, host):
             #getiing free memory requires a REST call, so cache results
             if not host.id in self.free_memory_cache:
                 try:
                     self.free_memory_cache[host.id] = host.get_statistics().get(
                         'memory.free').get_values().get_value()[0].get_datum()
                 except Exception:
                     self.free_memory_cache[host.id] = -1
             return self.free_memory_cache[host.id]

Passes over the hosts deciding which one needs a migration the most, and what hosts are valid options as the migration destination

         def getOverUtilizedHostAndUnderUtilizedList(self, engine_hosts, minimum_host_memory):
             **\1**
             over_utilized_host = None
             under_utilized_hosts = []
             for host in engine_hosts:
                 if not host:
                     continue
                 free_memory = self.getFreeMemory(host)
                 if(free_memory <= 0):
                     continue
                 if free_memory > minimum_host_memory:
                         under_utilized_hosts.append(host)
                         continue
                     #take the host with least amount of free memory
                 if (over_utilized_host is None or
                         self.getFreeMemory(over_utilized_host)
                         > free_memory):
                         over_utilized_host = host
             return over_utilized_host, under_utilized_hosts

This passes over the hosts marked valid as migration destination, figuring how much free memory the most underused host have

(this number is the maximum possible memory size of a VM to migrate)

         def getMaximumVmMemory(self, hosts, minimum_host_memory):
             **\1**
             maximum_vm_memory = 0
             for host in hosts:
                 available_memory = self.getFreeMemory(host) - minimum_host_memory
                 available_memory = min(available_memory,
                                        host.get_max_scheduling_memory())
                 if available_memory > maximum_vm_memory:
                     maximum_vm_memory = available_memory
             return maximum_vm_memory

Now according to the option selected (safe/aggressive) , get from the overused Host a VM to migrate

         def getBestVmForMigration(self, vms, maximum_vm_memory, memory_delta, safe):
             #safe -> select the smallest vm
             #not safe -> try and select the smallest vm larger then the delta,
             #   if no such vm exists take the largest one
             #migrating a small vm is more likely to succeeded and puts less strain
             #on the network
             selected_vm = None
             best_effort_vm = None
             for vm in vms:
                     if vm.memory > maximum_vm_memory:
                         #never select a vm that will send all the under
                         #utilized hosts over the threshold
                         continue
                     if safe:
                         if (selected_vm is None or
                                 vm.memory < selected_vm.memory):
                             selected_vm = vm
                     else:
                         if vm.memory > memory_delta:
                             if (selected_vm is None or
                                     vm.memory < selected_vm.memmory):
                                 selected_vm = vm
                     if (best_effort_vm is None or
                             vm.memory > best_effort_vm.memory):
                         best_effort_vm = vm
             if not safe and selected_vm is None:
                 selected_vm = best_effort_vm
             return selected_vm

**This function will be called by the external scheduler**

It will get a list of host ids to check, and will return a VM to migrate and a list of possible host targets.

         def do_balance(self, hosts_ids, args_map): 
             **\1**
             conn = self._get_connection()
             if conn is None:
                 return
             #get our parameters from the map
             minimum_host_memory = long(args_map.get('minimum_host_memoryMB',
                                                     self.MINIMUM_MEMORY_DEFAULT))
             minimum_host_memory = minimum_host_memory * self.TO_BYTES
             safe = bool(args_map.get('safe_selection',
                                      self.SAFE_SELECTION_DEFAULT))
             #get all the hosts with the given ids
             engine_hosts = self._get_hosts(hosts_ids, conn)
             over_utilized_host, under_utilized_hosts = (
                 self.getOverUtilizedHostAndUnderUtilizedList(engine_hosts,
                                                              minimum_host_memory))
             if over_utilized_host is None:
                 return
             maximum_vm_memory = self.getMaximumVmMemory(under_utilized_hosts,
                                                         minimum_host_memory)
             #amount of memory the host is missing
             memory_delta = (
                 minimum_host_memory -
                 self.getFreeMemory(over_utilized_host))
             host_vms = conn.vms.list('host=' + over_utilized_host.name)
             if host_vms is None:
                 return
             #get largest/smallest vm that will
             selected_vm = self.getBestVmForMigration(host_vms, maximum_vm_memory,
                                                      memory_delta, safe)
             if selected_vm is None:
                 return
             under_utilized_hosts_ids = [host.id for host in under_utilized_hosts]
             print (selected_vm.id, under_utilized_hosts_ids)
