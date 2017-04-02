---
title: Preparing a Remote PostgreSQL Database for Use with the oVirt Engine
---

# Appendix D: Preparing a Remote PostgreSQL Database for Use with the oVirt Engine

Optionally configure a PostgreSQL database on a remote Enterprise Linux 7 machine to use as the Engine database. By default, the oVirt Engine's configuration script, `engine-setup`, creates and configures the Engine database locally on the Engine machine. To set up the Engine database with custom values on the Engine machine, see [Appendix E: Preparing a Local Manually-Configured PostgreSQL Database for Use with the oVirt Engine](../appe-Preparing_a_Local_Manually-Configured_PostgreSQL_Database_for_Use_with_the_oVirt_Engine).

Use this procedure to configure the database on a machine that is separate from the machine where the Engine is installed. Set up this database before you configure the Engine; you must supply the database credentials during `engine-setup`.

**Note:** The `engine-setup` and `engine-backup --mode=restore` commands only support system error messages in the `en_US.UTF8` locale, even if the system locale is different.

The locale settings in the `postgresql.conf` file must be set to `en_US.UTF8`.

**Important:** The database name must contain only numbers, underscores, and lowercase letters.

**Preparing a Remote PostgreSQL Database for use with the oVirt Engine**

1. Install the PostgreSQL server package:

        # yum install postgresql-server

2. Initialize the PostgreSQL database, start the `postgresql` service, and ensure that this service starts on boot:

        # su -l postgres -c "/usr/bin/initdb --locale=en_US.UTF8 --auth='ident' --pgdata=/var/lib/pgsql/data/"
        # systemctl start postgresql.service
        # systemctl enable postgresql.service

3. Connect to the `psql` command line interface as the `postgres` user:

        # su - postgres
        $ psql

4. Create a user for the Engine to use when it writes to and reads from the database. The default user name on the Engine is `engine`:

        postgres=# create role user_name with login encrypted password 'password';

5. Create a database in which to store data about the Red Hat Virtualization environment. The default database name on the Engine is `engine`:

        postgres=# create database database_name owner user_name template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

6. Connect to the new database and add the `plpgsql` language:

        postgres=# \c database_name
        database_name=# CREATE LANGUAGE plpgsql;

7. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the `/var/lib/pgsql/data/pg_hba.conf` file, and add the following line immediately underneath the line starting with `local` at the bottom of the file, replacing *X.X.X.X* with the IP address of the Engine:

        host    database_name    user_name    X.X.X.X/32   md5

8. Allow TCP/IP connections to the database. Edit the `/var/lib/pgsql/data/postgresql.conf` file and add the following line:

        listen_addresses='*'

    This example configures the `postgresql` service to listen for connections on all interfaces. You can specify an interface by giving its IP address.

9. Open the default port used for PostgreSQL database connections, and save the updated firewall rules:

        # yum install iptables-services
        # iptables -I INPUT 5 -p tcp --dport 5432 -j ACCEPT
        # service iptables save

10. Restart the `postgresql` service:

        # systemctl restart postgresql.service

Optionally, set up SSL to secure database connections using the instructions at [http://www.postgresql.org/docs/8.4/static/ssl-tcp.html#SSL-FILE-USAGE](http://www.postgresql.org/docs/8.4/static/ssl-tcp.html#SSL-FILE-USAGE).

**Prev:** [Appendix C: Enabling Gluster Processes on Gluster Storage Nodes](../appe-Enabling_Gluster_Processes_on_Gluster_Storage_Nodes) <br>
**Next:** [Appendix E: Preparing a Local Manually-Configured PostgreSQL Database for Use with the oVirt Engine](../appe-Preparing_a_Local_Manually-Configured_PostgreSQL_Database_for_Use_with_the_oVirt_Engine)
