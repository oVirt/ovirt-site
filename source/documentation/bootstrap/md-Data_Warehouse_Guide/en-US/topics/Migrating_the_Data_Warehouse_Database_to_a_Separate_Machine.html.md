# Migrating the Data Warehouse Database to a Separate Machine

Optionally migrate the `ovirt_engine_history` database before you migrate the Data Warehouse service. Use `engine-backup` to create a database backup and restore it on the new database machine. For more information on `engine-backup`, run `engine-backup --help`. 

This procedure assumes that the new database server has Red Hat Enterprise Linux 7 installed and the appropriate subscriptions configured. See [Subscribing to the Required Entitlements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Subscribing_to_the_Red_Hat_Enterprise_Virtualization_Manager_Channels_using_Subscription_Manager) in the *Installation Guide*.

To migrate the Data Warehouse service only, see [Migrating the Data Warehouse Service to a Separate Machine](Migrating_the_Data_Warehouse_Service_to_a_Separate_Machine).

**Migrating the Data Warehouse Database to a Separate Machine**

1. Create a backup of the Data Warehouse database and configuration files:

        # engine-backup --mode=backup --scope=dwhdb --scope=files --file=file_name --log=log_file_name

2. Copy the backup file from the Manager to the new machine:

        # scp /tmp/file_name root@new.dwh.server.com:/tmp

3. Install `engine-backup` on the new machine:

        # yum install ovirt-engine-tools-backup

4. Restore the Data Warehouse database on the new machine. `file_name` is the backup file copied from the Manager. 

        # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --provision-dwh-db --no-restore-permissions
