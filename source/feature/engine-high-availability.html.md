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
