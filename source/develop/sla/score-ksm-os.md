---
title: Score KSM OS
authors: nslomian
---

# Score KSM OS

This function gives each host as score by how similar are the operating systems of already running VMs to the operating system of the scheduled VM.

      from ovirtsdk.xml import params
      from ovirtsdk.api import API
      import sys
      class ksm_same_os_score():
`   `**`rank` `hosts` `higher` `the` `more` `vms` `they` `have` `with` `similar` `os` `to` `the` `scored` `vm`**
         properties_validation = ''
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
         def _get_hosts(self, host_ids, connection):
             #get all the hosts with the given ids
             engine_hosts = connection.hosts.list(
                 query=" or ".join(["id=%s" % u for u in host_ids]))
             return engine_hosts
         def _get_vms(self, host_name, connection):
             #get all the vms with the given host
             host_vms = connection.vms.list('host='+host_name)
             return host_vms
         def score_host(self, vm, host, connection):
             score = 0
             host_vms = self._get_vms(host.name, connection)
             if not host_vms:
                 return (host.id, 0)
             for host_vm in host_vms:
                     if(vm.get_os().get_type() == host_vm.get_os().get_type()):
                         if(vm.get_os().get_version() == host_vm.get_os().get_version()):
                             score += 100
                         else:
                             score += 20
             return (host.id, score / len(host_vms))
`   def do_score(self, hosts_ids, vm_id, args_map): //<-- `**`This` `is` `the` `function` `that` `will` `be` `called` `by` `the` `external` `scheduler` `proxy`**
             conn = self._get_connection()
             if conn is None:
                 return
             engine_hosts = self._get_hosts(hosts_ids, conn)
             vm = conn.vms.get(id=vm_id)
             host_scores = []
             for host in engine_hosts:
                 host_scores.append(self.score_host(vm, host, conn))
             print host_scores
