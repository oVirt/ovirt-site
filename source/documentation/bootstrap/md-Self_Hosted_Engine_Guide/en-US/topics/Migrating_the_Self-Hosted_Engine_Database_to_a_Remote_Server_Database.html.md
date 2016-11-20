# Migrating the Self-Hosted Engine Database to a Remote Server Database

You can migrate the `engine` database of a self-hosted engine to a remote database server after the Red Hat Virtualization Manager has been initially configured.

This task is split into two procedures. The first procedure, preparing the remote PostgreSQL database, is a necessary prerequisite for the migration itself and presumes that the server has Red Hat Enterprise Linux installed and has been configured with the appropriate subscriptions.

The second procedure, migrating the database, uses PostgreSQL `pg_dump` and `pg_restore` commands to handle the database backup and restore. As such, it is necessary to edit the `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` file with the updated information. At a minimum, you must update the location of the new database server. If the database name, role name, or password are modified for the new database server, these values must also be updated in the `10-setup-database.conf` file. This procedure uses the default `engine` database settings to minimize modification of this file.

**Preparing the Remote PostgreSQL Database for use with the Red Hat Virtualization Manager**

1. Log in to the remote database server and install the PostgreSQL server package:

        # yum install postgresql-server

2. Initialize the PostgreSQL database, start the `postgresql` service, and ensure that this service starts on boot:

        # postgresql-setup initdb
        # systemctl start postgresql.service
        # systemctl enable postgresql.service

3. Connect to the `psql` command line interface as the `postgres` user:

        # su - postgres
        $ psql

4. Create a user for the Manager to use when it writes to and reads from the database. The default user name on the Manager is `engine`:

        postgres=# create role user_name with login encrypted password 'password';

    **Note:** The password for the `engine` user is located in plain text in `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf`. Any password can be used when creating the role on the new server, however if a different password is used then this file must be updated with the new password.

5. Create a database in which to store data about the Red Hat Virtualization environment. The default database name on the Manager is `engine`, and the default user name is `engine`:

        postgres=# create database database_name owner user_name template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

6. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the `/var/lib/pgsql/data/pg_hba.conf` file, and add the following line immediately underneath the line starting with `local` at the bottom of the file, replacing `X.X.X.X` with the IP address of the Manager:

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

1. Log in to one of the hosted-engine hosts and place the environment into `global` maintenance mode. This disables the High Availability agents and prevents the Manager virtual machine from being migrated occurring during the procedure:

        # hosted-engine --set-maintenance --mode=global

2. Log in to the Manager virtual machine and stop the `ovirt-engine` service so that it does not interfere with the engine backup:

        # systemctl stop ovirt-engine.service

3. Create the `engine` database backup using the PostgreSQL `pg_dump` command:

        # su - postgres -c 'pg_dump -F c engine -f /tmp/engine.dump'

4. Copy the backup file to the new database server. The target directory must allow write access for the `postgres` user:

        # scp /tmp/engine.dump root@new.database.server.com:/tmp/engine.dump

5. Log in to the new database server and restore the database using the PostgreSQL `pg_restore` command:

        # su - postgres -c 'pg_restore -d engine /tmp/engine.dump'

6. Log in to the Manager virtual machine and update the `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` and replace the `localhost` value of `ENGINE_DB_HOST` with the IP address of the new database server. If the engine name, role name, or password differ on the new database server, update those values in this file.

7. Now that the database has been migrated, start the `ovirt-engine` service:

        # systemctl start ovirt-engine.service

8. Log in to a hosted-engine host and turn off maintenance mode, enabling the High Availability agents:

        # hosted-engine --set-maintenance --mode=none
