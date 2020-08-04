---
title: Overview of Configuring Data Warehouse
---

## Overview of Configuring Data Warehouse

The oVirt Engine includes a comprehensive management history database, which can be utilized by any application to extract a range of information at the data center, cluster, and host levels. Installing Data Warehouse creates the `ovirt_engine_history` database, to which the Engine is configured to log information for reporting purposes. The Data Warehouse component is optional.

Data Warehouse is required in oVirt. It can be installed and configured on the same machine as the Engine, or on a separate machine with access to the Engine:

1. **Install and configure Data Warehouse on the Engine machine.**

   This configuration requires only a single registered machine, and is the simplest to configure; however, it increases the demand on the host machine. Users who require access to the Data Warehouse service will require access to the Engine machine itself. See Configuring the oVirt Engine in the Installation Guide for more information on this configuration.

2. **Install and configure Data Warehouse a separate machine.**

   This configuration requires two registered machines. It reduces the load on the Engine machine and avoids potential CPU and memory-sharing conflicts on that machine. Administrators can also allow user access to the Data Warehouse machine, without the need to grant access to the Engine machine. See the “Installing and Configuring Data Warehouse on a Separate Machine” section for more information on this configuration.

It is recommended that you set the system time zone for all machines in your Data Warehouse deployment to UTC. This ensures that data collection is not interrupted by variations in your local time zone: for example, a change from summer time to winter time.

To calculate an estimate of the space and resources the `ovirt_engine_history` database will use, use the oVirt Engine History Database Size Calculator tool. The estimate is based on the number of entities and the length of time you have chosen to retain the history records.

   **Important:** The following behavior is expected in `engine-setup`:

   * Install the Data Warehouse package, run `engine-setup`, and answer `No` to configuring Data Warehouse:

            Configure Data Warehouse on this host (Yes, No) [Yes]: No

   * Run `engine-setup` again; setup no longer presents the option to configure those services.

     To force `engine-setup` to present both options again, run `engine-setup --reconfigure-optional-components`.

     To configure only the currently installed Data Warehouse packages, and prevent setup from applying package updates found in enabled repositories, add the `--offline` option.

**Next:** [Installing and Configuring Data Warehouse on a Separate Machine](Data_Warehouse_and_Reports_Configuration_Notes)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/chap-installing_and_configuring_data_warehouse#Overview_of_Configuring_Data_Warehouse)
