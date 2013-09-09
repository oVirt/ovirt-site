---
title: ideas for backend clustering
authors: lhornyak
wiki_title: Lhornyak/ideas for backend clustering
wiki_revision_count: 4
wiki_last_updated: 2013-09-09
---

# ideas for backend clustering

## outdated

<big>this page is not maintained and outdated, at the time of writing this, there is no plan for clustering the engine for failover or load balancing</big>

--[Lhornyak](User:Lhornyak) ([talk](User talk:Lhornyak)) 07:25, 9 September 2013 (GMT)

## Ideas for backend clustering

### Problems of backend clustering

Backend stored caches some data in local instances. These instances never actually refresh from the background, so with the traditional JEE clustering, it would not work correctly.

### JEE clustering

One solution could be to remove the local caches and in-memory data. I don't know if anyone has an estimation for how much work it would take.

*   Cache-like hashmaps could be replaced with distributed caches like ehcache or infinispan.
*   Local data, like counters should be replaced either to database or infinispan.
*   quartz can be easily configured to use JDBC-jobstore, and in that way it is clusterable

### Terracotta?

Could all this work be saved with a terracotta configuration?

*   Support?
*   How should users configure this?
*   Deployment complexity?
