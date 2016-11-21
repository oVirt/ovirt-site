# Installing and Configuring Data Warehouse

* [Data Collection Setup and Reports Installation Overview](Data_Collection_Setup_and_Reports_Installation_Overview)
* [Data Warehouse and Reports Configuration Notes](Data_Warehouse_and_Reports_Configuration_Notes)

## Migrating Data Warehouse to a Separate Machine

Migrate the Data Warehouse service from the Red Hat Virtualization Manager to a separate machine. Hosting the Data Warehouse service on a separate machine reduces the load on each individual machine, and allows each service to avoid potential conflicts caused by sharing CPU and memory with other processes.

Migrate the Data Warehouse service and connect it with the existing `ovirt_engine_history` database, or optionally migrate the `ovirt_engine_history` database to a new database machine before migrating the Data Warehouse service. If the `ovirt_engine_history` database is hosted on the Manager, migrating the database in addition to the Data Warehouse service further reduces the competition for resources on the Manager machine. You can migrate the database to the same machine onto which you will migrate the Data Warehouse service, or to a machine that is separate from both the Manager machine and the new Data Warehouse service machine.

* [Migrating the Data Warehouse Database to a Separate Machine](Migrating_the_Data_Warehouse_Database_to_a_Separate_Machine)
* [Migrating the Data Warehouse Service to a Separate Machine](Migrating_the_Data_Warehouse_Service_to_a_Separate_Machine)

<!-- end section -->

* [Changing the Data Warehouse Sampling Scale](Changing_the_Data_Warehouse_Sampling_Scale)
