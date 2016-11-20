# Migrating the Data Warehouse Database to a Separate Machine

Optionally migrate the `ovirt_engine_history` database before you migrate the Data Warehouse service. This procedure uses `pg_dump` to create a database backup, and `psql` to restore the backup on the new database machine. The `pg_dump` command provides flexible options for backing up and restoring databases; for more information on options that may be suitable for your system, see the `pg_dump` manual page.

The following procedure assumes that a PostgreSQL database has already been configured on the new machine. To migrate the Data Warehouse service only, see [Migrating the Data Warehouse Service to a Separate Machine](Migrating_the_Data_Warehouse_Service_to_a_Separate_Machine).

**Migrating the Data Warehouse Database to a Separate Machine**

1. On the existing database machine, dump the `ovirt_engine_history` database into a SQL script file:

        # pg_dump ovirt_engine_history > ovirt_engine_history.sql

2. Copy the script file from the existing database machine to the new database machine.

3. Restore the `ovirt_engine_history` database on the new database machine:

        # psql -d ovirt_engine_history -f ovirt_engine_history.sql

    The command above assumes that the database on the new machine is also named `ovirt_engine_history`.
