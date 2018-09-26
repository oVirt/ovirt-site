---
title: Changing the Data Warehouse Sampling Scale
---

## Changing the Data Warehouse Sampling Scale

Data Warehouse is required in oVirt. It can be installed and configured on the same machine as the Engine, or on a separate machine with access to the Engine. The default data retention settings may not be required for all setups, so `engine-setup` offers two data sampling scales: `Basic` and `Full`.


* `Full` uses the default values for the data retention settings listed in the "Application Settings for the Data Warehouse service in ovirt-engine-dwhd.conf" section (recommended when Data Warehouse is installed on a remote host).

* `Basic` reduces the values of `DWH_TABLES_KEEP_HOURLY` to `720` and `DWH_TABLES_KEEP_DAILY` to `0`, easing the load on the Engine machine (recommended when the Engine and Data Warehouse are installed on the same machine).

The sampling scale is configured by `engine-setup` during installation:

        --== MISC CONFIGURATION ==--

        Please choose Data Warehouse sampling scale:
        (1) Basic
        (2) Full
        (1, 2)[1]:

You can change the sampling scale later by running `engine-setup` again with the `--reconfigure-dwh-scale` option.

**Changing the Data Warehouse Sampling Scale**

        # engine-setup --reconfigure-dwh-scale
        [...]
        Welcome to the oVirt 4.2 setup/upgrade.
        Please read the oVirt 4.2 install guide

        Would you like to proceed? (Yes, No) [Yes]:
        [...]
        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:
        [...]
        Setup can backup the existing database. The time and space required for the database backup depend on its size. This process takes time, and in some cases (for instance, when the size is few GBs) may take several hours to complete.
        If you choose to not back up the database, and Setup later fails for some reason, it will not be able to restore the database and all DWH data will be lost.
        Would you like to backup the existing database before upgrading it? (Yes, No) [Yes]:
        [...]
        Please choose Data Warehouse sampling scale:
        (1) Basic
        (2) Full
        (1, 2)[1]: 2
        [...]
        During execution engine service will be stopped (OK, Cancel) [OK]:
        [...]
        Please confirm installation settings (OK, Cancel) [OK]:

You can also adjust individual data retention settings if necessary, as documented in "Application Settings for the Data Warehouse service in ovirt-engine-dwhd.conf" section.

**Prev:** [Migrating Data Warehouse Service to a Separate Machine](../Migrating_Data_Warehouse_to_a_Separate_Machine)<br>
**Next:** [Chapter 2: About the History Database](../chap-About_History_Database_Reports_and_Dashboards)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/changing_the_data_warehouse_sampling_scale)
