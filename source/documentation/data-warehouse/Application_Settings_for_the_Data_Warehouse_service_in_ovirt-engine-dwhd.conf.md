---
title: Application Settings for the Data Warehouse Service in ovirt-engine-dwhd.conf
---

## Application Settings for the Data Warehouse Service in ovirt-engine-dwhd.conf

The following is a list of options for configuring application settings for the Data Warehouse service. These options are available in the **/usr/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.conf** file. Configure any changes to the default values in an override file under **/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/**. Restart the Data Warehouse service after saving the changes.

**ovirt-engine-dwhd.conf application settings variables**

| Variable name | Default Value | Remarks |
|-
| `DWH_DELETE_JOB_HOUR` | `3` | The time at which a deletion job is run. Specify a value between `0` and `23`, where `0` is midnight. |
| `DWH_SAMPLING` | `60` | The interval, in seconds, at which data is collected into statistical tables. |
| `DWH_TABLES_KEEP_SAMPLES` | `24` | The number of hours that data from `DWH_SAMPLING` is stored. Data more than two hours old is aggregated into hourly data. |
|`DWH_TABLES_KEEP_HOURLY` | `1440` | The number of hours that hourly data is stored. The default is 60 days. Hourly data more than two days old is aggregated into daily data. |
| `DWH_TABLES_KEEP_DAILY` | `43800` | The number of hours that daily data is stored. The default is five years. |
| `DWH_ERROR_EVENT_INTERVAL` | `300000` | The minimum interval, in milliseconds, at which errors are pushed to the Engine's <b>audit.log</b>. |

**Prev:** [Recording Statistical History](Recording_statistical_history) <br>
**Next:** [Tracking Tag History](Tracking_tag_history)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/application_settings_for_the_data_warehouse_service_in_ovirt-engine-dwhd_file)
