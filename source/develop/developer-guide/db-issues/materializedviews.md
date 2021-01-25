---
title: MaterializedViews
authors: emesika
---

# Materialized Views

## Overview

A materialized view is a table that actually contains rows, but behaves like a view. That is, the data in the table changes when the data in the underlying tables changes. There are several different types of materialized views:

         `**`Snapshot` `materialized` `views`**` are the simplest to implement. They are only updated when manually refreshed.
         `**`Eager` `materialized` `views`**` are updated as soon as any change is made to the database that would affect it. Eagerly updated materialized views may have incorrect data if the view it is based on has dependencies on mutable functions like now().
         `**`Lazy` `materialized` `views`**`' are updated when the transaction commits. They too may fall out of sync with the base view if the view depends on mutable functions like now().
         `**`Very` `Lazy` `materialized` `views`**` are functionally equivalent to Snapshot materialized views. 
         The only difference is that changes are recorded incrementally and applied when the table is manually refreshed.
         (This may be faster than a full snapshot upon refresh.) 

**In this document we will only discuss the Snapshot Materialized Views implementation.**

## Why Materialized Views ?

Before we get too deep into how to implement materialized views, let's first examine why we may want to use materialized views. You may notice that certain queries are very slow. You may have exhausted all the techniques in the standard bag of techniques to speed up those queries. In the end, you realize that getting the queries to run as fast as you like simply isn't possible without completely restructuring the data. What you end up doing is storing pre-queried bits of information so that you don't have to run the real query when you need the data. This is typically called "caching" outside of the database world. What you are really doing is creating a materialized view. You are taking a view and turning it into a real table that holds real data, rather than a gateway to a SELECT query.

## Implementation

Candidates for Snapshot Materialized Views are views that are based on slowly-changing data. The Snapshot Materialized Views is actually functioning as a cache. The Snapshot Materialized View is refreshed per request. The Snapshot Materialized View definitions are stored in the materialized_views table.

             Column        |           Type           |     Modifiers      
       ---------------------+--------------------------+--------------------
      mv_name                 | name                     | not null
      v_name                  | name                     | not null
      refresh_rate_in_sec     | integer                  | 
      last_refresh            | timestamp with time zone | 
      avg_cost_ms             | integer                  | not null default 0
      min_refresh_rate_in_sec | integer                  | default 0
      custom                  | boolean                  | default false
      active                  | boolean                  | default true

**mv_name** is the Materialized View name
**v_name** is the original view name on which mv_name is based
*' refresh_rate_in_sec*' is the Materialized View refresh rate in seconds
*' last_refresh*' is the timestamp of the last refresh
**avg_cost_ms** is the average cost of a refresh operation on the Materialized View in miliseconds.
**\1** is the min refresh rate allowed when refresh is called with teh force flag
**custom** is a flag indicating if a Materialized View is custom
**active** is a flag indicating if a Materialized View is active

## Flow

1) Create the Materialized View by calling:

        `**`CreateMaterializedView`**` - if you are creating a new product view
        `**`CreateMaterializedViewAs`**` - preserves the original view name, The original view will be renamed and the new product  Materialized View will have the original  view name.
        `**`CreateCustomMaterializedView`**` - if you are creating a new custom view
        `**`CreateCustomMaterializedViewAs`**` - preserves the original view name, The original view will be renamed and the new custom  Materialized View will have the original  view name.

2) If your Snapshot Materialized View is my_mt you should create Stored Procedures:

         MtDropmy_mtIndexes - Drops indexes on my_mt
         MtCreatemy_mtIndexes - Creates needed indexes on my_mt
         Those indexes should be defined in the "Snapshot Materialized Views Index Definitions Section"
         in post_upgrade/0020_create_materialized_views.sql file.

Those SP are called automatically when a Snapshot Materialized View is refreshed to boost refresh performance. 3) You can call **IsMaterializedViewRefreshed** to check if it is time to refresh the view and if yes call **RefreshMaterializedView** manually.
or
You can define a cron job that calls **RefreshAllMaterializedViews** that loops over all Snapshot Materialized Views and refreshes it automatically
 **RefreshAllMaterializedViews** recieves a boolean v_force flag, Please set this flag to false when calling it from a cron job

        in order to update the materialized views only when needed.
        (This SP is called with v_force = true after create/upgrade DB)

There are 4 additional functions :

        `**`CreateAllMaterializedViewsiIndexes`**` - Creates indexes for all Snapshot Materialized views
        `**`DropMaterializedView`**` - Drops the Materialized View
        `**`DropAllMaterializedViews`**` - Drop all Materialized Views
        `**`UpdateMaterializedViewRefreshRate`**` - Updates the Materialized View refresh rate
        `**`UpdateMaterializedViewRefreshRate`**` - Updates the Materialized View refresh rate
        `**`UpdateMaterializedViewMinRefreshRate`**` - Updates the Materialized View minimal refresh rate
        `**`ActivateMaterializedView`**` - activates/decativates a  Materialized View
        `**`ActivateAllMaterializedViews`**` - activates/decativates all Materialized Views

### Example of possible post_upgrade/0020_create_materialized_views.sql

This file includes only product Materialized Views for Custom Materialized Views please refer to the **Customization** section
 /\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

                               Snapshot Materialized Views Definitions Section
      ******************************************************************************************************/
      select CreateMaterializedViewAs('vms', 300);
      /******************************************************************************************************
                               Snapshot Materialized Views Index Definitions Section
      ******************************************************************************************************/
      create or replace function MtCreatevmsIndexes()
      returns void
      as $procedure$
      begin
      create index vms_index on vms (vm_guid);
      end; $procedure$
      language plpgsql;
      create or replace function MtDropvmsIndexes()
      returns void
      as $procedure$
      begin
      drop index if exists vms_index cascade;
      end; $procedure$
      language plpgsql;
      select RefreshMaterializedView('vms');

## Upgrade

When the DB is upgraded, all Materilized Views are dropped in the pre-upgrade step in order to reflect any change that may be done in the original views. The Materilized Views are recreated in the post-upgrade step insuring that after the upgrade the Materilized Views are updated and play the same role as before it. **NOTE : Materialized Views are automatically refreshed upon create/upgrade**

## Customization

In addition, you can create a file named create_materialized_views.sql under dbscripts/upgrade/post_upgrade/custom/ This file may include other custom materialized views settings and is executed by the create/upgrade database scripts.

**NOTE: If from any reason you want to drop a Snapshot Materialized View that was setup in the product context, you can always do that by calling DropMaterializedView in create_materialized_views.sql**

If create_materialized_views.sql is executed manually :

       1) verify that the the user that runs the psql is engine so the objects created will have the same credentials
       2) the custom dir and create_materialized_views.sql file under it should have the following permissions 

       drwxr-xr-x 2 root root  custom
       -rw-r--r-- 1 root root  create_materialized_views.sql

### Example

This is an example of how **\1** may look like:

      /******************************************************************************************************
                               Snapshot Materialized Views Definitions Section
      ******************************************************************************************************/
      select CreateCustomMaterializedViewAs('vds', 300);
      /******************************************************************************************************
                               Snapshot Materialized Views Index Definitions Section
      ******************************************************************************************************/
      create or replace function MtCreatevdsIndexes()
      returns void
      as $procedure$
      begin
      create index vds_index2 on vds (vds_id);
      end; $procedure$
      language plpgsql;
      create or replace function MtDropvdsIndexes()
      returns void
      as $procedure$
      begin
      drop index if exists vds_index2 cascade;
      end; $procedure$
      language plpgsql;
      select RefreshMaterializedView('vds');

## Schedule

The simplest way to schedule all Materialized Views updates is via a **cron** job that will perform the following command

`  psql -U `<user>` -c "select RefreshAllMaterializedViews(false);" `<db>

You can also call

` psql -U `<user>` -c "select RefreshAllMaterializedViews(true);" `<db>

In this case all Materialized Views will be refreshed but if for example the crom run every minute and the minimun update rate for a view is 5 minutes, the minimum update rate is honored(so, in this example this view will be updated once in each 5 cron invocation of teh refresh SP.
