---
title: oVirt Grafana Integration
category: feature
authors: sradco
---
# oVirt Grafana Integration

## Summary

Starting with this release, the Grafana dashboard for the Data Warehouse is installed by default, to enable easy monitoring of Red Hat Virtualization metrics.

Grafana includes pre-built dashboards for datacenter, cluster, host, and VM data, Executive overview, Trend analysis and detailed view for per-object statistics.

**NOTE:** The Data Warehouse is installed by default at Basic scale resource use. 

To obtain the full benefits of Grafana, it is recommended to update the Data Warehouse scale to Full.

Full scaling may require migrating the Data Warehouse to a separate virtual machine.

For Data Warehouse scaling instructions, see [Changing the Data Warehouse Sampling Scale](/documentation/data_warehouse_guide/)

For instructions on migrating to or installing on a separate machine, see [Migrating Data Warehouse to a Separate Machine](/documentation/data_warehouse_guide/)
