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

When needed, update the new column values before removing a related column.

*   Test to verify the expected results

Please not the following :

*   Upgrade runs are written to "schema_version" table.

In order to rerun an upgrade file, please remove from the "schema_version" table the corresponding line

and change for the previous line the "current" column to TRUE.

### If a change to the history views is required

Follow the following steps:

*   Have a cloned ovirt-engine git repository
*   Setup a postgreSQL "engine" DB.
*   Make the necessary changes for the latest views:

        ./ovirt-dwh/packaging/dbscripts/create_views_X_Y.sql

#### Maintain Legacy views - Make the necessary changes to former views

*   If a column that existed in former versions was **removed** or its **type was changed**,

It is **mandatory** to make the change to former views so the API will not brake.

*   -   If Removed , add the column as Null value casted to the column type
    -   If the type of the column changed, make sure to cast the column to the previous type.

### Update ETL process in Talend Open Studio

*   Have the Talend open Studio installed in the project version.
*   Update the Jobs with the required changes.
*   Close all open jobs.
*   Build the Job from the "History ETL" job.

![](BuildJob.jpg "BuildJob.jpg")

*   Open the zip file and copy the java files from:

       ./HistoryETL/src/ovirt_engine_dwh

To the git repository :

       ./ovirt-dwh/etl_export/src/ovirt_engine_dwh

*   When changing the context - for example added a variable ,

copy the context from the zip file:

       ./HistoryETL/ovirt_engine_dwh/

To the git repository:

       ./ovirt-dwh/etl_export/ovirt_engine_dwh

*   When upgrading a Talend version, copy the routines from the zip file:

       ./HistoryETL/src/routines/

To the git repository:

      . /ovirt-dwh/etl_export/src/routines
