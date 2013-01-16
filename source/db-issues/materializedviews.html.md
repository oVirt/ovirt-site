---
title: MaterializedViews
authors: emesika
wiki_title: OVirt-DB-Issues/MaterializedViews
wiki_revision_count: 32
wiki_last_updated: 2013-05-22
---

# Materialized Views

## Overview

A materialized view is a table that actually contains rows, but behaves like a view. That is, the data in the table changes when the data in the underlying tables changes. There are several different types of materialized views:

         `**`Snapshot` `materialized` `views`**` are the simplest to implement. They are only updated when manually refreshed.
         `**`Eager` `materialized` `views`**` are updated as soon as any change is made to the database that would affect it. Eagerly updated materialized views may have incorrect data if the view it is based on has dependencies on mutable functions like now().
         `**`Lazy` `materialized` `views`**`' are updated when the transaction commits. They too may fall out of sync with the base view if the view depends on mutable functions like now().
         `**`Very` `Lazy` `materialized` `views`**` are functionally equivalent to Snapshot materialized views. The only difference is that changes are recorded incrementally and applied when the table is manually refreshed. (This may be faster than a full snapshot upon refresh.) 

In this document we will only discuss the Snapshot Materialized Views implementation.

## Why Materialized Views ?

Before we get too deep into how to implement materialized views, let's first examine why we may want to use materialized views. You may notice that certain queries are very slow. You may have exhausted all the techniques in the standard bag of techniques to speed up those queries. In the end, you realize that getting the queries to run as fast as you like simply isn't possible without completely restructuring the data. What you end up doing is storing pre-queried bits of information so that you don't have to run the real query when you need the data. This is typically called "caching" outside of the database world. What you are really doing is creating a materialized view. You are taking a view and turning it into a real table that holds real data, rather than a gateway to a SELECT query.

## Implementation

Candidates for Snapshot Materialized Views are views that are based on slowly-changing data. The Snapshot Materialized Views is actually functioning as a cache. The Snapshot Materialized View is refreshed per request. The Snapshot Materialized View definitions are stored in the materialized_views table.

             Column        |           Type           |     Modifiers      
       ---------------------+--------------------------+--------------------
       mv_name             | name                     | not null
       v_name              | name                     | not null
       refresh_rate_in_sec | integer                  | 
       last_refresh        | timestamp with time zone | 
       avg_cost_ms         | integer                  | not null default 0
