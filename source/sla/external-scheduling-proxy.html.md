---
title: oVirt External Scheduling Proxy
category: sla
authors: doron, lhornyak
wiki_category: SLA
wiki_title: Features/oVirt External Scheduling Proxy
wiki_revision_count: 22
wiki_last_updated: 2013-10-07
---

# oVirt External Scheduling Proxy

## External scheduler

### Summary

### Owner

*   Name: [ Laszlo Hornyak](User:Lhornyak) --[Lhornyak](User:Lhornyak) ([talk](User talk:Lhornyak)) 08:13, 17 June 2013 (GMT)
*   Email: <lhornyak at redhat dot com>

### Current status

*   Specification phase
*   Last updated: ,

### Detailed Description

The external scheduler is a daemon and its purpose is for oVirt users to extend the scheduling process with custom python filters, scoring functions and load balancing functions. As mentioned above any plugin file {NAME}.py must implement at least one of the functions. The service will be started by the installer, and the engine will be able to communicate with it using XML-RPC.

*   Scheduler conf file (etc/ovirt/scheduler/scheduler.conf), optional (defaults):

      listerning port=# (18781)
      ssl=true/false (true)
      plugins_path=/path ($PYTHONPATH/ovirt_scheduler/plugins)

*   Additionally for every python plugin an optional config file can be added (etc/ovirt/scheduler/plugins/{NAME}.conf).

### Benefit to oVirt

The external scheduler will allow system administrators to extend the scheduling logic by writing host selection filters in python.

### Dependencies / Related Features

### Documentation / External references

### Testing

### Comments and Discussion

<Category:Feature>
