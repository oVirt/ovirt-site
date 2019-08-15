---
title: Recording Statistical History
---

## Recording Statistical History

The ETL service collects data into the statistical tables every minute. Data is stored for every minute of the past 24 hours, at a minimum, but can be stored for as long as 48 hours depending on the last time a deletion job was run. Minute-by-minute data more than two hours old is aggregated into hourly data and stored for two months. Hourly data more than two days old is aggregated into daily data and stored for five years.

Hourly data and daily data can be found in the hourly and daily tables.

Each statistical datum is kept in its respective aggregation level table: samples, hourly, and daily history. All history tables also contain a history_id column to uniquely identify rows. Tables reference the configuration version of a host in order to enable reports on statistics of an entity in relation to its past configuration.

**Prev:** [Tracking Configuration History](Tracking_configuration_history) <br>
**Next:** [Application Settings for the Data Warehouse Service in ovirt-engine-dwhd.conf](Application_Settings_for_the_Data_Warehouse_service_in_ovirt-engine-dwhd.conf)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/recording_statistical_history)
