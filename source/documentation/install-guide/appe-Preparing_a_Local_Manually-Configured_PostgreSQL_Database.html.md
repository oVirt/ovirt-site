---
title: Preparing a Local Manually-Configured PostgreSQL Database
---

# Appendix E: Preparing a Local Manually-Configured PostgreSQL Database

You have the option of configuring a local PostgreSQL database on the Engine machine to use as the Engine database. By default, the oVrt Engine’s configuration script, `engine-setup`, creates and configures the Engine database locally on the Engine machine.

To configure the Engine database on a machine that is separate from the machine where the Engine is installed, see [Appendix D: Preparing a Remote PostgreSQL Database](appe-Preparing_a_Remote_PostgreSQL_Database).

Use this procedure to set up the Engine database with custom values. Set up this database before you configure the Engine; you must supply the database credentials during `engine-setup`. To set up the database, you must first install the `ovirt-engine` package on the Engine machine; the `postgresql-server` package is installed as a dependency.

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

4. Create a user for the Engine to use when it writes to and reads from the database. The default user name on the Engine is `engine`:

        postgres=# create role *user_name* with login encrypted password '*password*';

5. Create a database in which to store data about the oVirt environment. The default database name on the Engine is `engine`:

        postgres=# create database *database_name* owner *user_name* template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

6. Connect to the new database:

        postgres=# \c *database_name*

7. Add the `uuid-ossp` extension:

        *database_name*=# CREATE EXTENSION "uuid-ossp";

8. Add the `plpgsql` language if it does not exist:

        *database_name*=# CREATE LANGUAGE plpgsql;

9. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the **/var/lib/pgsql/data/pg_hba.conf** file, and add the following line immediately underneath the line starting with `local` at the bottom of the file, replacing `::0/32` or `::0/128` with the IP address of the Engine:

        host    *database name*    *user name*    *0.0.0.0/0*  md5
        host    *database name*    *user name*    *::0/32*     md5
        host    *database name*    *user name*    *::0/128*    md5

10. Update the PostgreSQL server’s configuration. Edit the **/var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf** file and add the following lines:

        autovacuum_vacuum_scale_factor='0.01'
        autovacuum_analyze_scale_factor='0.075'
        autovacuum_max_workers='6'
        maintenance_work_mem='65536'
        max_connections='150'
        work_mem='8192'

11. Restart the `postgresql` service:

        # systemctl rh-postgresql95-postgresql restart

Optionally, set up SSL to secure database connections using the instructions at [http://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-FILE-USAGE](http://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-FILE-USAGE.).

**Prev:** [Appendix D: Preparing a Remote PostgreSQL Database](appe-Preparing_a_Remote_PostgreSQL_Database) <br>
**Next:** [Appendix F: Installing the Websocket Proxy on a Separate Machine](appe-Installing_the_Websocket_Proxy_on_a_Separate_Machine)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-preparing_a_local_manually-configured_postgresql_database)
