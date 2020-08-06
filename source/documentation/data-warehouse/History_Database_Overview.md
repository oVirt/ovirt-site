---
title: History Database Overview
---

## History Database Overview

oVirt includes a comprehensive management history database, which can be used by reporting applications to generate reports at data center, cluster and host levels. This chapter provides information to enable you to set up queries against the history database.

oVirt Engine uses `PostgreSQL 9.5.x` as a database platform to store information about the state of the virtualization environment, its configuration and performance. At install time,oVirt Engine creates a PostgreSQL database called `engine`.

Installing the `ovirt-engine-dwh` package creates a second database called `ovirt_engine_history`, which contains historical configuration information and statistical metrics collected every minute over time from the `engine` operational database. Tracking the changes to the database provides information on the objects in the database, enabling the user to analyze activity, enhance performance, and resolve difficulties.

   **Warning:** The replication of data in the `ovirt_engine_history` database is performed by the oVirt Engine Extract Transform Load Service, `ovirt-engine-dwhd`. The service is based on Talend Open Studio, a data integration tool. This service is configured to start automatically during the data warehouse package setup. It is a Java program responsible for extracting data from the `engine` database, transforming the data to the history database standard and loading it to the `ovirt_engine_history` database.
   The `ovirt-engine-dwhd` service must not be stopped.
   {:.alert.alert-warning}


The `ovirt_engine_history` database schema changes over time. The database includes a set of database views to provide a supported, versioned API with a consistent structure. A view is a virtual table composed of the result set of a database query. The database stores the definition of a view as a `SELECT` statement. The result of the `SELECT` statement populates the virtual table that the view returns. A user references the view name in `PL/PGSQL` statements the same way a table is referenced.

**Prev:** [Chapter 2: About the History Database](chap-About_History_Database_Reports_and_Dashboards)
**Next:** [Tracking Configuration History](Tracking_configuration_history)

 [Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/chap-about_history_database)
