---
title: Engine High Availability
authors: emesika, liran.zelkha, plysan
wiki_title: Features/Engine High Availability
wiki_revision_count: 8
wiki_last_updated: 2014-05-08
---

# Engine High Availability

This page was created as a result of a [http://lists.ovirt.org/pipermail/engine-devel/2013-August/005436.html discussion](http://lists.ovirt.org/pipermail/engine-devel/2013-August/005436.html discussion) that started at @engine_devel. As we are considering an active/active architecture for Engine, we'll use this page to document required features and code changes that will be required.

## Architecture

![](engine_ha_architecture.jpg "engine_ha_architecture.jpg")

## Issues with current implementation

1.  Locking. Currently Engine makes extensive use of Java synchronized capabilities to lock multiple requests hitting the same VDSM at the same time. This should be extended to be cross-machine.

<sub>However,\\ if\\ we\\ replace\\ HTTP\\ transport\\ protocol\\ (and\\ use\\ push\\ notifications),\\ and\\ since\\ VDSM\\ can\\ support\\ multiple\\ concurrent\\ requests,\\ is\\ the\\ entire\\ locking\\ mechanism\\ still\\ necessary?</sub>

1.  Singletons. We need to find a mechanism to migrate our singletons to be cross-cluster.

<sub>This is a major issue, since if the Engine running the Singleton crashes, we need to migrate the Singleton. The best solution is to probably dump the Singleton approach. We can ride on the CDI [http://gerrit.ovirt.org/#/c/5575/ change](http://gerrit.ovirt.org/#/c/5575/_change) and the code-refactor it requires.

1.  EJB. Again as part of CDI change we should drop EJB.
2.  State clustering. We can use Infinispan, already integrated in Engine, for state replication.

<sub>We will need to consider which state needs to be replicated.

1.  Quartz. DB configuration for Quartz should enable High Availability.
2.  Database. DB clustering should be out of scope of this task.

[Eli] We may consider that as well , please see [PostgresSQL HA](http://www.openscg.com/postgresql-ha-automatic-failover/)

1.  Configuration. All configuration files should be placed in shared storage/database
2.  VDSM "Sharding". Should all engines be able to handle all VDSMs, or should we divide VDSMs between running engines (and rebalance once an engine goes down)?

<sub>For now I think this is a complex task that we can push for a later stage

## Possible solutions

1.  To add infinispan clustered cache, we can add replicate or distribute cache in jboss configuration file(ovirt-engine.xml)
    -   perhapse also need to add jgroups configuration
    -   if we consider multiple jboss instance in one machine(convenient for developing purpose), we may need to customize jboss.node.name, port-offset and engine-debug-port property to solve conflicts

2.  engine-setup
    -   all nodes should share one copy of pki, we may offer an option to use existing pki files in CA setup
    -   all nodes should connect to one database, we may offer an option to use a existing DB connection in DB setup

3.  Use CDI to inject cache into java code
4.  For Singletons, we can use infinispan to replicate the variables in singleton instances.
    -   For instance, EventQueueMonitor, we can put poolsLockMap, poolsEventsMap, and poolCurrentEventMap to clustered cache, if these three map are all that need to be synchronized among the cluster, it should work.
    -   Other singletons can be much more complex than EventQueueMonitor, but using the same trick might work...

5.  For command locking, we can still use infinispan tricks, like event listeners. But this may have performance problem
    -   For instance, if engine A is invoking on a vdsm, it can put a corresponding entry in clustered synchronized cache. other engines would be noticed and can block or fail on invoking the same command on that vdsm, after engine A's invocation is complete, it can remove that entry, and other engines can be noticed for free invoking.

6.  thingking more...
