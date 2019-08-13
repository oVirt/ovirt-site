---
title: Migrating Data Warehouse to a Separate Machine
---

## Migrating Data Warehouse to a Separate Machine

Migrate the Data Warehouse service from the oVirt Engine to a separate machine. Hosting the Data Warehouse service on a separate machine reduces the load on each individual machine, and allows each service to avoid potential conflicts caused by sharing CPU and memory with other processes.

Migrate the Data Warehouse service and connect it with the existing `ovirt_engine_history` database, or optionally migrate the `ovirt_engine_history` database to a new database machine before migrating the Data Warehouse service. If the `ovirt_engine_history` database is hosted on the Engine, migrating the database in addition to the Data Warehouse service further reduces the competition for resources on the Engine machine. You can migrate the database to the same machine onto which you will migrate the Data Warehouse service, or to a machine that is separate from both the Engine machine and the new Data Warehouse service machine.

### Migrating the Data Warehouse Database to a Separate Machine

Optionally migrate the `ovirt_engine_history` database before you migrate the Data Warehouse service. Use `engine-backup` to create a database backup and restore it on the new database machine. For more information on `engine-backup`, run `engine-backup --help`.

Attach the required repositories to your system.

To migrate the Data Warehouse service only, see the "Migrating the Data Warehouse Service to a Separate Machine" section below.

**Migrating the Data Warehouse Database to a Separate Machine**

1. Create a backup of the Data Warehouse database and configuration files:

        # engine-backup --mode=backup --scope=dwhdb --scope=files --file=file_name --log=log_file_name

2. Copy the backup file from the Engine to the new machine:

        # scp /tmp/file_name root@new.dwh.server.com:/tmp

3. Install `engine-backup` on the new machine:

        # yum install ovirt-engine-tools-backup

4. Restore the Data Warehouse database on the new machine. `file_name` is the backup file copied from the Engine.

        # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --provision-dwh-db --no-restore-permissions

The Data Warehouse database is now hosted on a separate machine from that on which the Engine is hosted. Proceed to the next section to complete the migration.

## Migrating the Data Warehouse Service to a Separate Machine

Migrate a Data Warehouse service that was installed and configured on the oVirt Engine to a dedicated host machine. Hosting the Data Warehouse service on a separate machine helps to reduce the load on the Engine machine. Note that this procedure migrates the Data Warehouse service only; to migrate the Data Warehouse database (also known as the `ovirt_engine_history` database) prior to migrating the Data Warehouse service, see the "Migrating the Data Warehouse Database to a Separate Machine" section above.

**Prerequisites**

Ensure that you have completed the following prerequisites:

1. You must have installed and configured the Engine and Data Warehouse on the same machine.

2. To set up the new Data Warehouse machine, you must have the following:

    * A virtual or physical machine with Enterprise Linux 7 installed.

    * Attached the required repositories to your system.

    * The password from the Engine's **/etc/ovirt-engine/engine.conf.d/10-setup-database.conf** file.

    * Allowed access from the Data Warehouse machine to the Engine database machine's TCP port 5432.

    * The `ovirt_engine_history` database credentials from the Engine's **/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf** file. If you migrated the `ovirt_engine_history` database using the steps from the "Migrating the Data Warehouse Database to a Separate Machine" section, retrieve the credentials you defined during the database setup on that machine.

Installing this scenario involves four key steps:

1. Set up the new Data Warehouse machine.

2. Stop the Data Warehouse service on the Engine machine.

3. Configure the new Data Warehouse machine.

4. Remove the Data Warehouse package from the Engine machine.

#### Setting up the New Data Warehouse Machine

1. Attach the required repositories to your system.

2. Ensure that all packages currently installed are up to date:

        # yum update

3. Install the `ovirt-engine-dwh-setup` package:

        # yum install ovirt-engine-dwh-setup

#### Stopping the Data Warehouse Service on the Engine Machine

1. Stop the Data Warehouse service:

        # systemctl stop ovirt-engine-dwhd.service

2. If the database is hosted on a remote machine, you must manually grant access by editing the **postgres.conf** file. Edit the **/var/lib/pgsql/data/postgresql.conf** file and modify the `listen_addresses` line so that it matches the following:

        listen_addresses = '\*'

    If the line does not exist or has been commented out, add it manually.

    If the database is hosted on the Engine machine and was configured during a clean setup of the oVirt Engine, access is granted by default.

    See “Migrating the Data Warehouse Database to a Separate Machine” for more information on how to configure and migrate the Data Warehouse database.

3. Restart the postgresql service:

        # systemctl restart postgresql.service

#### Configuring the New Data Warehouse Machine

The questions shown in this step only appear if you are migrating the `ovirt_engine_history` database to one machine and Data Warehouse service to a different machine. The order of the questions may differ depending on your environment.

1. If you are migrating both the `ovirt_engine_history` database and the Data Warehouse service to the *same* machine, run the following, otherwise proceed to the next step.

        # sed -i '/^ENGINE_DB_/d' \
                /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf

        # sed -i \
             -e 's;^\(OVESETUP_ENGINE_CORE/enable=bool\):True;\1:False;' \
             -e '/^OVESETUP_CONFIG\/fqdn/d' \
             /etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf

2. Run the `engine-setup` command to begin configuration of Data Warehouse on the machine:

        # engine-setup

3. Press `Enter` to configure Data Warehouse:

        Configure Data Warehouse on this host (Yes, No) [Yes]:

4. Press `Enter` to accept the automatically detected hostname, or enter an alternative hostname and press `Enter`:

        Host fully qualified DNS name of this server [autodetected host name]:

5. Press `Enter` to automatically configure the firewall, or type `No` and press `Enter` to maintain existing settings:

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

    If you choose to automatically configure the firewall, and no firewall Engines are active, you are prompted to select your chosen firewall Engine from a list of supported options. Type the name of the firewall Engine and press `Enter`. This applies even in cases where only one option is listed.

6. Enter the fully qualified domain name and password for the Engine. Press `Enter` to accept the default values in each other field:

        Host fully qualified DNS name of the engine server []: engine-fqdn
        Setup needs to do some actions on the remote engine server. Either automatically, using ssh as root to access it, or you will be prompted to manually perform each such action.
        Please choose one of the following:
        1 - Access remote engine server using ssh as root
        2 - Perform each action manually, use files to copy content around
        (1, 2) [1]:
        ssh port on remote engine server [22]:
        root password on remote engine server engine-fqdn: password

7. Answer the following question about the location of the `ovirt_engine_history` database:

        Where is the DWH database located? (Local, Remote) [Local]: Remote

   Type the alternative option as shown above and then press **Enter**.

8. Enter the fully qualified domain name and password for your `ovirt_engine_history` host. Press `Enter` to accept the default values in each other field:

        DWH database host []: dwh-db-fqdn
        DWH database port [5432]:
        DWH database secured connection (Yes, No) [No]:
        DWH database name [ovirt_engine_history]:
        DWH database user [ovirt_engine_history]:
        DWH database password: password

   See “Migrating the Data Warehouse Database to a Separate Machine” for more information on how to configure and migrate the Data Warehouse database.

9. Enter the fully qualified domain name and password for the Engine database machine. Press `Enter` to accept the default values in each other field:

        Engine database host []: engine-db-fqdn
        Engine database port [5432]:
        Engine database secured connection (Yes, No) [No]:
        Engine database name [engine]:
        Engine database user [engine]:
        Engine database password: password

10. Choose how long Data Warehouse will retain collected data::

        Please choose Data Warehouse sampling scale:
        	(1) Basic
        	(2) Full
        	(1, 2)[1]:

    `Full` uses the default values for the data storage settings listed in “Application Settings for the Data Warehouse service in ovirt-engine-dwhd.conf” (recommended when Data Warehouse is installed on a remote host).

      **Note:** If you migrate from `Basic` to `Full`, initially only the existing basic data will be available.

    `Basic` reduces the values of `DWH_TABLES_KEEP_HOURLY` to `720` and `DWH_TABLES_KEEP_DAILY` to `0`, easing the load on the Engine machine but with a less detailed history.

11. Confirm that you want to permanently disconnect the existing Data Warehouse service from the Engine:

        Do you want to permanently disconnect this DWH from the engine? (Yes, No) [Yes]:

12. Confirm your installation settings:

        Please confirm installation settings (OK, Cancel) [OK]:

#### Disabling the Data Warehouse Package on the Engine Machine

1. On the Engine machine, restart the Engine:

        # service ovirt-engine restart

2. Disable the Data Warehouse service:

        # systemctl disable ovirt-engine-dwhd.service

3. Remove the Data Warehouse files:

        # rm -f /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/* .conf /var/lib/ovirt-engine-dwh/backups/*

The Data Warehouse service is now hosted on a separate machine from that on which the Engine is hosted.

**Prev:** [Installing and Configuring Data Warehouse on a Separate Machine](Data_Warehouse_and_Reports_Configuration_Notes)<br>
**Next:** [Changing the Data Warehouse Sampling Scale](Changing_the_Data_Warehouse_Sampling_Scale)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/sect-migrating_data_warehouse_to_a_separate_machine)
