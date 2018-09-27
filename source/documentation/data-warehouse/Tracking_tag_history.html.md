---
title: Tracking Tag History
---

## Tracking Tag History

The ETL Service collects tag information as displayed in the Administration Portal every minute and stores this data in the tags historical tables. The ETL Service tracks five types of changes:

* A tag is created in the Administration Portal - the ETL Service copies the tag details, position in the tag tree and relation to other objects in the tag tree.

* A entity is attached to the tag tree in the Administration Portal - the ETL Service replicates the addition to the `ovirt_engine_history` database as a new entry.

* A tag is updated - the ETL Service replicates the change of tag details to the `ovirt_engine_history` database as a new entry.

* An entity or tag branch is removed from the Administration Portal - the `ovirt_engine_history` database flags the corresponding tag and relations as removed in new entries. Removed tags and relations are only flagged as removed or detached.

* A tag branch is moved - the corresponding tag and relations are updated as new entries. Moved tags and relations are only flagged as updated.

**Prev:** [Application Settings for the Data Warehouse Service in ovirt-engine-dwhd.conf](../Application_Settings_for_the_Data_Warehouse_service_in_ovirt-engine-dwhd.conf) <br>
**Next:** [Allowing Read Only Access to the History Database](../Allowing_Read_Only_Access_to_the_History_Database)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/tracking_tag_history)
