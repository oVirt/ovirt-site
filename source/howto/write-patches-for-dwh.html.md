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

*   Have a cloned ovirt-engine git repository
*   Setup a postgreSQL "engine" DB.
*   Make the necessary changes in:

        ./ovirt-engine/packaging/dbscripts/create_dwh_views.sql

### If a change to the "ovirt_engine_history" DB is required

Follow the following steps:

*   Have a cloned ovirt-dwh git repository
*   Setup a postgreSQL "ovirt_engine_history" DB.
*   Create an upgrade sql file in the following folder:

         ./ovirt-dwh/packaging/dbscripts/upgrade/

When necessary, update the new column values before removing a related column.

*   Test to verify the expected results

Please not the following :

*   Upgrade runs are written to "schema_version" table.

In order to rerun an upgrade file, please remove from the "schema_version" table the corresponding line

and change for the previous line the "current" column to TRUE.

-
