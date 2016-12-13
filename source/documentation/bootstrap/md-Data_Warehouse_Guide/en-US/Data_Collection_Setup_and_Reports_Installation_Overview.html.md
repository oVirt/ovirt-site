# Overview of Configuring Data Warehouse

The oVirt Engine includes a comprehensive management history database, which can be utilized by any application to extract a range of information at the data center, cluster, and host levels. Installing Data Warehouse creates the `ovirt_engine_history` database, to which the Engine is configured to log information for reporting purposes. The Data Warehouse component is optional.

  It is recommended that you set the system time zone for all machines in your Data Warehouse deployment to UTC. This ensures that data collection is not interrupted by variations in your local time zone: for example, a change from summer time to winter time.

To calculate an estimate of the space and resources the `ovirt_engine_history` database will use, factor your estimate based on the number of entities and the length of time you chose to retain the history records.

**Next:** [Data Warehouse and Reports Configuration Notes](Data_Warehouse_and_Reports_Configuration_Notes)
