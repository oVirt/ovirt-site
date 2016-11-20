# Migrating Data Warehouse to a Separate Machine

Migrate the Data Warehouse service from the Red Hat Virtualization Manager to a separate machine. Hosting the Data Warehouse service on a separate machine reduces the load on each individual machine, and allows each service to avoid potential conflicts caused by sharing CPU and memory with other processes.

Migrate the Data Warehouse service and connect it with the existing ovirt_engine_history` database, or optionally migrate the ovirt_engine_history` database to a new database machine before migrating the Data Warehouse service. If the ovirt_engine_history` database is hosted on the Manager, migrating the database in addition to the Data Warehouse service further reduces the competition for resources on the Manager machine. You can migrate the database to the same machine onto which you will migrate the Data Warehouse service, or to a machine that is separate from both the Manager machine and the new Data Warehouse service machine.

