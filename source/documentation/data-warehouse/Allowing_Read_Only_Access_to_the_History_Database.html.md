---
title: Allowing Read-Only Access to the History Database
---

## Allowing Read-Only Access to the History Database

To allow access to the history database without allowing edits, you must create a read-only PostgreSQL user that can log in to and read from the `ovirt_engine_history` database. This procedure must be executed on the system on which the history database is installed.

**Allowing Read-Only Access to the History Database**

1. Enable `psql` commands:

        # . scl_source enable rh-postgresql95

2. Create the user to be granted read-only access to the history database:

        # psql -U postgres -c "CREATE ROLE [user name] WITH LOGIN ENCRYPTED PASSWORD '[password]';" -d ovirt_engine_history

3. Grant the newly created user permission to connect to the history database:

        # psql -U postgres -c "GRANT CONNECT ON DATABASE ovirt_engine_history TO [user name];"

4. Grant the newly created user usage of the `public` schema:

        # psql -U postgres -c "GRANT USAGE ON SCHEMA public TO [user name];" ovirt_engine_history

5. Generate the rest of the permissions that will be granted to the newly created user and save them to a file:

        # psql -U postgres -c "SELECT 'GRANT SELECT ON ' || relname || ' TO [user name];' FROM pg_class JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE nspname = 'public' AND relkind IN ('r', 'v');" --pset=tuples_only=on  ovirt_engine_history > grant.sql

6. Use the file you created in the previous step to grant permissions to the newly created user:

        # psql -U postgres -f grant.sql ovirt_engine_history

7. Remove the file you used to grant permissions to the newly created user:

        # rm grant.sql

8. Add the following lines for the newly created user to `/var/lib/pgsql/data/pg_hba.conf`:

        # TYPE  DATABASE                USER           ADDRESS                 METHOD
        host    ovirt_engine_history    username    0.0.0.0/0               md5
        host    ovirt_engine_history    username    ::0/0                   md5

9. Reload the PostgreSQL service:

        # systemctl reload rh-postgresql95-postgresql

10. You can test the read-only user’s access permissions:

        # psql -U username ovirt_engine_history -h localhost
        Password for user username:
        psql (9.2.23)
        Type "help" for help.

        ovirt_engine_history=>

11. To exit the `ovirt_engine_history` database, enter `\q`.

The read-only user’s `SELECT` statements against tables and views in the `ovirt_engine_history` database succeed, while modifications fail.

**Prev:** [Tracking Tag History](Tracking_tag_history) <br>
**Next:** [Statistics History Views](Statistics_history_views)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/allowing_read_only_access_to_the_history_database)
