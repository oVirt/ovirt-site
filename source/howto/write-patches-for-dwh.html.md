---
title: How to write patches for dwh
category: howto
authors: sradco
wiki_category: Documentation
wiki_title: How to write patches for dwh
wiki_revision_count: 13
wiki_last_updated: 2014-11-25
---

# How to write patches for DWH

### If a change to the engine views is required

Follow the following steps:

1.  Have a cloned ovirt-engine git repository
2.  Setup a postgreSQL "engine" DB.
3.  Make the necessary changes in:

        ./ovirt-engine/packaging/dbscripts/create_dwh_views.sql
