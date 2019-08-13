---
title: Data Warehouse and Reports
---

# Chapter 9: Data Warehouse and Reports

## Overview of Configuring Data Warehouse

The oVirt Engine includes a comprehensive management history database, which can be utilized by any application to extract a range of information at the data center, cluster, and host levels. Installing Data Warehouse creates the `ovirt_engine_history` database, to which the Engine is configured to log information for reporting purposes. The Data Warehouse component is optional.

It is recommended that you set the system time zone for all machines in your Data Warehouse deployment to UTC. This ensures that data collection is not interrupted by variations in your local time zone: for example, a change from summer time to winter time.

## Data Warehouse Configuration Notes

**Behavior**

The following behavior is expected in `engine-setup`:

Install the Data Warehouse package, run `engine-setup`, and answer `No` to configuring Data Warehouse:

    Configure Data Warehouse on this host (Yes, No) [Yes]: No

Run `engine-setup` again; setup no longer presents the option to configure those services.

**Workaround**

To force `engine-setup` to present both options again, run `engine-setup --reconfigure-optional-components`.

**Note:** To configure only the currently installed Data Warehouse packages, and prevent setup from applying package updates found in enabled repositories, add the `--offline` option .

**Prev:** [Chapter 8: Migrating Databases](chap-Migrating_Databases)
