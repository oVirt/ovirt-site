# Migrating the Engine Database to a Remote Server Database

You can migrate the `engine` database to a remote database server after the Red Hat Virtualization Manager has been initially configured. Use `engine-backup` to create a database backup and restore it on the new database server. This procedure assumes that the new database server has Red Hat Enterprise Linux 7 installed and the appropriate subscriptions configured. See [Subscribing to the Required Entitlements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Subscribing_to_the_Red_Hat_Enterprise_Virtualization_Manager_Channels_using_Subscription_Manager) in the *Installation Guide*.

**Migrating the Database**

1. Log in to the Red Hat Virtualization Manager machine and stop the `ovirt-engine` service so that it does not interfere with the engine backup:

        # systemctl stop ovirt-engine.service

2. Create the `engine` database backup:

        # engine-backup --scope=files --scope=db --mode=backup --file=file_name --log=log_file_name

3. Copy the backup file to the new database server:

        # scp /tmp/engine.dump root@new.database.server.com:/tmp

4. Log in to the new database server and install `engine-backup`:

        # yum install ovirt-engine-tools-backup

5. Restore the database on the new database server. `file_name` is the backup file copied from the Manager. 

        # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --provision-db --no-restore-permissions

6. Now that the database has been migrated, start the `ovirt-engine` service:

        # systemctl start ovirt-engine.service
