---
title: Preparing a Remote PostgreSQL Database
---

# Appendix D: Preparing a Remote PostgreSQL Database

By default, the Engine's configuration script, `engine-setup`, creates and configures the engine_host database locally on the Engine machine.

To set up the Manager database with custom values on the Manager machine, see [Appendix E, Preparing a Local Manually-Configured PostgreSQL Database](appe-Local_Manually-Configured_PostgreSQL_Database). You should set up a Engin database before you configure the Engine. You must supply the database credentials during `engine-setup`.

The Data Warehouse’s configuration script offers the choice of creating a local or remote database. However, situations may arise where you might want to configure a remote database for Data Warehouse manually.

Use this procedure to configure the database on a machine that is separate from the machine where the Manager is installed.

**Note:** The `engine-setup` and `engine-backup --mode=restore` commands only support system error messages in the `en_US.UTF8` locale, even if the system locale is different.

The locale settings in the `postgresql.conf` file must be set to `en_US.UTF8`.

**Important:** The database name must contain only numbers, underscores, and lowercase letters.

**Initializing the PostgreSQL Database**

1. Install the PostgreSQL server package:

        # yum install rh-postgresql95 rh-postgresql95-postgresql-contrib

2. Initialize the PostgreSQL database, start the `postgresql` service, and ensure that this service starts on boot:

        # scl enable rh-postgresql95 -- postgresql-setup --initdb
        # systemctl enable rh-postgresql95-postgresql
        # systemctl start rh-postgresql95-postgresql

3. Connect to the `psql` command line interface as the `postgres` user:

        # su - postgres -c 'scl enable rh-postgresql95 -- psql'

4. Create a default user. The Engine’s default user is `engine` and the Data Warehouse’s default user is `ovirt_engine_history`:

        postgres=# create role *user_name* with login encrypted password '*password*';

5. Create database. The Engine’s default user is `engine` and the Data Warehouse’s default user is `ovirt_engine_history`:

        postgres=# create database *database_name* owner *user_name* template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

6. Connect to the new database:

        postgres=# \c *database_name*

7. Add the `uuid-ossp` extension:

        *database_name*=# CREATE EXTENSION "uuid-ossp";

8. Add the `plpgsql` language if it does not exist:

        *database_name*=# CREATE LANGUAGE plpgsql;

9. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the **/var/lib/pgsql/data/pg_hba.conf** file, and add the following line immediately underneath the line starting with `local` at the bottom of the file, replacing `X.X.X.X` with the IP address of the Engine or the Data Warehouse machine:

        host    *database name*    *user name*    *::0/32*     md5
        host    *database name*    *user name*    *::0/128*    md5

10. Allow TCP/IP connections to the database. Edit the **/var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf** file and add the following line:

        listen_addresses='\*'

11. Update the PostgreSQL server’s configuration. Edit the **/var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf** file and add the following lines:

        autovacuum_vacuum_scale_factor='0.01'
        autovacuum_analyze_scale_factor='0.075'
        autovacuum_max_workers='6'
        maintenance_work_mem='65536'
        max_connections='150'
        work_mem='8192'

12. Open the default port used for PostgreSQL database connections, and save the updated firewall rules:

        # firewall-cmd --zone=public --add-service=postgresql
        # firewall-cmd --permanent --zone=public --add-service=postgresql

13. Restart the `postgresql` service:

        # systemctl rh-postgresql95-postgresql restart

Optionally, set up SSL to secure database connections using the instructions at [http://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-FILE-USAGE](http://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-FILE-USAGE.).

**Prev:** [Appendix C: Enabling Gluster Processes on Gluster Storage Nodes](appe-Enabling_Gluster_Processes_on_Gluster_Storage_Nodes) <br>
**Next:** [Appendix E: Preparing a Local Manually-Configured PostgreSQL Database](appe-Preparing_a_Local_Manually-Configured_PostgreSQL_Database)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-preparing_a_remote_postgresql_database)
