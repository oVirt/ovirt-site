---
title: ideas for backend clustering
authors: lhornyak
wiki_title: Lhornyak/ideas for backend clustering
wiki_revision_count: 4
wiki_last_updated: 2013-09-09
---

# Ideas for backend clustering

### Problems of backend clustering

Backend stored caches some data in local instances. These instances never actually refresh from the background, so with the traditional JEE clustering, it would not work correctly.

### JEE clustering

One solution could be to remove the local caches and in-memory data. I don't know if anyone has an estimation for how much work it would take.

*   Cache-like hashmaps could be replaced with distributed caches like ehcache or infinispan.
*   Local data, like counters should be replaced either to database or infinispan.

### Terracotta?

Could all this work be saved with a terracotta configuration?

*   Support?
*   How should users configure this?
*   Deployment complexity?
