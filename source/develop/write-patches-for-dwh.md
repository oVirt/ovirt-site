---
title: How to write patches for dwh
category: howto
authors: sradco
---

<!-- TODO: Content review -->

# How to write patches for DWH

## Install Talend and import the project

*   Follow instructions within [oVirt DWH Readme](https://github.com/oVirt/ovirt-dwh#etl-project-development)

*   Import the oVirt DWH project from the path: `<repository folder path>/ovirt-dwh/tos_project`

*   You may now edit the project using the studio.
*   Setup connections context in the Talend Open Studio for the `ovirt_engine_history` database.

For details on this refer to Talend's documentation.

*   You may now run the project and test it in the Talend DI.

## If a change to the engine views is required

Follow the following steps:

*   Have a cloned [ovirt-engine git repository](https://github.com/oVirt/ovirt-engine)
*   Setup a postgreSQL "`engine`" DB.
*   Make the necessary changes in: `./ovirt-engine/packaging/dbscripts/create_dwh_views.sql`

## If a change to the "ovirt_engine_history" DB is required

Follow the following steps:

*   Have a cloned [ovirt-dwh git repository](https://github.com/oVirt/ovirt-dwh)
*   Setup a postgreSQL "`ovirt_engine_history`" DB.
*   Create an upgrade sql file in the following folder: `./ovirt-dwh/packaging/dbscripts/upgrade/`

When needed, update the new column values before removing a related column.

*   Test to verify the expected results

Please not the following :

*   Upgrade runs are written to "schema_version" table.

In order to rerun an upgrade file, please remove from the "schema_version" table the corresponding line

and change for the previous line the "current" column to TRUE.

## If a change to the history views is required

Follow the following steps:

*   Have a cloned ovirt-engine git repository
*   Setup a postgreSQL "engine" DB.
*   Make the necessary changes for the latest views: `./ovirt-dwh/packaging/dbscripts/create_views_X_Y.sql`

### Maintain Legacy views - Make the necessary changes to former views

*   If a column that existed in former versions was **removed** or its **type was changed**,

It is **mandatory** to make the change to former views so the API will not brake.

*   -   If Removed , add the column as Null value casted to the column type
    -   If the type of the column changed, make sure to cast the column to the previous type.

## Update ETL process in Talend Open Studio

*   Have the Talend open Studio installed in the project version.
*   Update the Jobs with the required changes.
*   Close all open jobs.

First,

*   Build the Job from the "History ETL" job.

![](/images/wiki/BuildJob.png)

*   -   Open the zip file and copy the java files from: `./HistoryETL/src/ovirt_engine_dwh`

To the git repository : `./ovirt-dwh/etl_export/src/ovirt_engine_dwh`

*   -   When changing the context - for example added a variable ,

copy the context from the zip file: `./HistoryETL/ovirt_engine_dwh/`

To the git repository: `./ovirt-dwh/etl_export/ovirt_engine_dwh`

*   -   When upgrading a Talend version, copy the routines from the zip file: `./HistoryETL/src/routines/`

To the git repository: `./ovirt-dwh/etl_export/src/routines`

Second,

*   Export the project :

![](/images/wiki/ExportTalendProject.png)

*   Copy from the zip file to the git repository : `./ovirt-dwh/tos_project`

**Important** ! Copy only into the folders that already exist in the `tos_project` folder. Do not copy : `Metadata`, `sqlPatterns` and `temp`.

