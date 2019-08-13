---
title: Tracking Configuration History
---

## Tracking Configuration History

Data from the oVirt History Database (called `ovirt_engine_history`) can be used to track the `engine` database.

The ETL service, `ovirt-engine-dwhd`, tracks three types of changes:

* A new entity is added to the `engine` database - the ETL Service replicates the change to the `ovirt_engine_history` database as a new entry.

* An existing entity is updated - the ETL Service replicates the change to the `ovirt_engine_history` database as a new entry.

* An entity is removed from the `engine` database - A new entry in the `ovirt_engine_history` database flags the corresponding entity as removed. Removed entities are only flagged as removed.

The configuration tables in the `ovirt_engine_history` database differ from the corresponding tables in the `engine` database in several ways. The most apparent difference is they contain fewer **configuration** columns. This is because certain configuration items are less interesting to report than others and are not kept due to database size considerations. Also, columns from a few tables in the `engine` database appear in a single table in `ovirt_engine_history` and have different column names to make viewing data more convenient and comprehensible. All configuration tables contain:

* A `history_id` to indicate the configuration version of the entity;

* A `create_date` field to indicate when the entity was added to the system;

* An `update_date` field to indicate when the entity was changed; and

* A `delete_date` field to indicate the date the entity was removed from the system.

**Prev:** [History Database Overview](History_Database_Overview)<br>
**Next:** [Recording Statistical History](Recording_statistical_history)

 [Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/tracking_configuration_history)
