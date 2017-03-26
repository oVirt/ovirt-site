---
title: Migrating Databases
---

# Chapter 8: Migrating Databases

## Migrating the Self-Hosted Engine Database to a Remote Server Database

You can migrate the `engine` database of a self-hosted engine to a remote database server after the oVirt Engine has been initially configured.

This task is split into two procedures. The first procedure, preparing the remote PostgreSQL database, is a necessary prerequisite for the migration itself and presumes that the server has Enterprise Linux installed and has been configured with the appropriate subscriptions.

The second procedure, migrating the database, uses PostgreSQL `pg_dump` and `pg_restore` commands to handle the database backup and restore. As such, it is necessary to edit the `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` file with the updated information. At a minimum, you must update the location of the new database server. If the database name, role name, or password are modified for the new database server, these values must also be updated in the `10-setup-database.conf` file. This procedure uses the default `engine` database settings to minimize modification of this file.

**Preparing the Remote PostgreSQL Database for use with the oVirt Engine**

1. Log in to the remote database server and install the PostgreSQL server package:

        # yum install postgresql-server

2. Initialize the PostgreSQL database, start the `postgresql` service, and ensure that this service starts on boot:

        # postgresql-setup initdb
        # systemctl start postgresql.service
        # systemctl enable postgresql.service

3. Connect to the `psql` command line interface as the `postgres` user:

        # su - postgres
        $ psql

4. Create a user for the Engine to use when it writes to and reads from the database. The default user name on the Engine is `engine`:

        postgres=# create role user_name with login encrypted password 'password';

    **Note:** The password for the `engine` user is located in plain text in `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf`. Any password can be used when creating the role on the new server, however if a different password is used then this file must be updated with the new password.

5. Create a database in which to store data about the oVirt environment. The default database name on the Engine is `engine`, and the default user name is `engine`:

        postgres=# create database database_name owner user_name template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

6. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the `/var/lib/pgsql/data/pg_hba.conf` file, and add the following line immediately underneath the line starting with `local` at the bottom of the file, replacing `X.X.X.X` with the IP address of the Engine:

        host    database_name    user_name    X.X.X.X/32   md5

7. Allow TCP/IP connections to the database. Edit the `/var/lib/pgsql/data/postgresql.conf` file and add the following line:

        listen_addresses='*'

    This example configures the `postgresql` service to listen for connections on all interfaces. You can specify an interface by giving its IP address.

8. Open the default port used for PostgreSQL database connections, and save the updated firewall rules:

        # iptables -I INPUT 5 -p tcp --dport 5432 -j ACCEPT
        # service iptables save

9. Restart the `postgresql` service:

        # systemctl restart postgresql.service

Optionally, set up SSL to secure database connections using the instructions at [http://www.postgresql.org/docs/8.4/static/ssl-tcp.html#SSL-FILE-USAGE](http://www.postgresql.org/docs/8.4/static/ssl-tcp.html#SSL-FILE-USAGE).

**Migrating the Database**

1. Log in to one of the hosted-engine hosts and place the environment into `global` maintenance mode. This disables the High Availability agents and prevents the Engine virtual machine from being migrated occurring during the procedure:

        # hosted-engine --set-maintenance --mode=global

2. Log in to the Engine virtual machine and stop the `ovirt-engine` service so that it does not interfere with the engine backup:

        # systemctl stop ovirt-engine.service

3. Create the `engine` database backup using the PostgreSQL `pg_dump` command:

        # su - postgres -c 'pg_dump -F c engine -f /tmp/engine.dump'

4. Copy the backup file to the new database server. The target directory must allow write access for the `postgres` user:

        # scp /tmp/engine.dump root@new.database.server.com:/tmp/engine.dump

5. Log in to the new database server and restore the database using the PostgreSQL `pg_restore` command:

        # su - postgres -c 'pg_restore -d engine /tmp/engine.dump'

6. Log in to the Engine virtual machine and update the `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` and replace the `localhost` value of `ENGINE_DB_HOST` with the IP address of the new database server. If the engine name, role name, or password differ on the new database server, update those values in this file.

7. Now that the database has been migrated, start the `ovirt-engine` service:

        # systemctl start ovirt-engine.service

8. Log in to a hosted-engine host and turn off maintenance mode, enabling the High Availability agents:

        # hosted-engine --set-maintenance --mode=none

## Migrating Data Warehouse to a Separate Machine

Migrate the Data Warehouse service from the oVirt Engine to a separate machine. Hosting the Data Warehouse service on a separate machine reduces the load on each individual machine, and allows each service to avoid potential conflicts caused by sharing CPU and memory with other processes.

Migrate the Data Warehouse service and connect it with the existing `ovirt_engine_history` database, or optionally migrate the `ovirt_engine_history` database to a new database machine before migrating the Data Warehouse service. If the `ovirt_engine_history` database is hosted on the Engine, migrating the database in addition to the Data Warehouse service further reduces the competition for resources on the Engine machine. You can migrate the database to the same machine onto which you will migrate the Data Warehouse service, or to a machine that is separate from both the Engine machine and the new Data Warehouse service machine.

## Migrating the Data Warehouse Database to a Separate Machine

Optionally migrate the `ovirt_engine_history` database before you migrate the Data Warehouse service. This procedure uses `pg_dump` to create a database backup, and `psql` to restore the backup on the new database machine. The `pg_dump` command provides flexible options for backing up and restoring databases; for more information on options that may be suitable for your system, see the `pg_dump` manual page.

The following procedure assumes that a PostgreSQL database has already been configured on the new machine. To migrate the Data Warehouse service only, see Migrating the Data Warehouse Service to a Separate Machine section below.

**Migrating the Data Warehouse Database to a Separate Machine**

1. On the existing database machine, dump the `ovirt_engine_history` database into a SQL script file:

        # pg_dump ovirt_engine_history > ovirt_engine_history.sql

2. Copy the script file from the existing database machine to the new database machine.

3. Restore the `ovirt_engine_history` database on the new database machine:

        # psql -d ovirt_engine_history -f ovirt_engine_history.sql

    The command above assumes that the database on the new machine is also named `ovirt_engine_history`.

## Migrating the Data Warehouse Service to a Separate Machine

Migrate a Data Warehouse service that was installed and configured on the oVirt Engine to a dedicated host machine. Hosting the Data Warehouse service on a separate machine helps to reduce the load on the Engine machine. Note that this procedure migrates the Data Warehouse service only; to migrate the Data Warehouse database (also known as the `ovirt_engine_history` database) prior to migrating the Data Warehouse service, see [Migrating the Data Warehouse Database to a Separate Machine](Migrating_the_Data_Warehouse_Database_to_a_Separate_Machine).

Installing this scenario involves four key steps:

1. Set up the new Data Warehouse machine.

2. Stop the Data Warehouse service on the Engine machine.

3. Configure the new Data Warehouse machine.

4. Remove the Data Warehouse package from the Engine machine.

**Prerequisites**

Ensure that you have completed the following prerequisites:

1. You must have installed and configured the Engine and Data Warehouse on the same machine.

2. To set up the new Data Warehouse machine, you must have the following:

    * A virtual or physical machine with Enterprise Linux 7 installed.

    * The password from the Engine's `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` file.

    * Allowed access from the Data Warehouse machine to the Engine database machine's TCP port 5432.

    * The `ovirt_engine_history` database credentials from the Engine's `/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf` file. If you migrated the `ovirt_engine_history` database using the Migrating the Data Warehouse Database to a Separate Machine section above, retrieve the credentials you defined during the database setup on that machine.

**Step 1: Setting up the New Data Warehouse Machine**

1. Ensure that all packages currently installed are up to date:

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated.

2. Install the `ovirt-engine-dwh-setup` package:

        # yum install ovirt-engine-dwh-setup

**Step 2: Stopping the Data Warehouse Service on the Engine Machine**

1. Stop the Data Warehouse service:

        # systemctl stop ovirt-engine-dwhd.service

2. If the `ovirt_engine_history` database, the Engine database, or both are hosted on the Engine machine and were configured by a previous version (oVirt 3.4 or prior) that was then upgraded, you must allow the new Data Warehouse machine to access them. Edit the `/var/lib/pgsql/data/postgresql.conf` file and modify the `listen_addresses` line so that it matches the following:

        listen_addresses = '*'

    If the line does not exist or has been commented out, add it manually.

    If one or both databases are hosted on a remote machine, you must manually grant access by editing the `postgres.conf` file on each machine, and adding the `listen_addresses` line, as above. If both databases are hosted on the Engine machine and were configured during a clean setup of oVirt Engine, access is granted by default.

3. Restart the postgresql service:

        # systemctl restart postgresql.service

**Step 3: Configuring the New Data Warehouse Machine**

1. Run the `engine-setup` command to begin configuration of Data Warehouse on the machine:

        # engine-setup

2. Press **Enter** to configure Data Warehouse:

        Configure Data Warehouse on this host (Yes, No) [Yes]:

3. Press **Enter** to automatically configure the firewall, or type `No` and press **Enter** to maintain existing settings:

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

    If you choose to automatically configure the firewall, and no firewall managers are active, you are prompted to select your chosen firewall manager from a list of supported options. Type the name of the firewall manager and press **Enter**. This applies even in cases where only one option is listed.

4. Press **Enter** to accept the automatically detected hostname, or enter an alternative hostname and press **Enter**:

        Host fully qualified DNS name of this server [autodetected host name]:

5. Answer the following question about the location of the `ovirt_engine_history` database:

        Where is the DWH database located? (Local, Remote) [Local]: Remote

    Type the alternative option as shown above and then press **Enter**.

6. Enter the fully qualified domain name and password for your `ovirt_engine_history` database host. Press **Enter** to accept the default values in each other field:

        DWH database host []: dwh-db-fqdn
        DWH database port [5432]:
        DWH database secured connection (Yes, No) [No]:
        DWH database name [ovirt_engine_history]:
        DWH database user [ovirt_engine_history]:
        DWH database password: password

7. Enter the fully qualified domain name and password for the Engine database machine. Press **Enter** to accept the default values in each other field:

        Engine database host []: engine-db-fqdn
        Engine database port [5432]:
        Engine database secured connection (Yes, No) [No]:
        Engine database name [engine]:
        Engine database user [engine]:
        Engine database password: password

8. Press **Enter** to create a backup of the existing Data Warehouse database:

        Would you like to backup the existing database before upgrading it? (Yes, No) [Yes]:

    The time and space required for the database backup depends on the size of the database. It may take several hours to complete. If you choose not to back up the database here, and `engine-setup` fails for any reason, you will not be able to restore the database or any of the data within it. The location of the backup file appears at the end of the setup script.

9. Confirm that you want to permanently disconnect the existing Data Warehouse service from the Engine:

        Do you want to permanently disconnect this DWH from the engine? (Yes, No) [No]:

10. Confirm your installation settings:

        Please confirm installation settings (OK, Cancel) [OK]:

**Step 4: Removing the Data Warehouse Package from the Engine Machine**

1. Remove the Data Warehouse package:

        # yum remove ovirt-engine-dwh

    This step prevents the Data Warehouse service from attempting to automatically restart after an hour.

2. Remove the Data Warehouse files:

        # rm -rf /etc/ovirt-engine-dwh /var/lib/ovirt-engine-dwh

The Data Warehouse service is now hosted on a separate machine from that on which the Engine is hosted.

**Prev:** [Chapter 7: Installing Additional Hosts to a Self-Hosted Environment](../chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment) <br>
**Next:** [Chapter 9: Data Warehouse and Reports](../chap-Data_Warehouse_and_Reports)
