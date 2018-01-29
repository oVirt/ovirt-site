# Allowing Read-Only Access to the History Database

To allow access to the history database without allowing edits, you must create a read-only PostgreSQL user that can log in to and read from the `ovirt_engine_history` database. This procedure must be executed on the system on which the history database is installed.

**Note:** In oVirt 4.2 we ship postgres 9.5 through the Software Collection.
 In order to run psql you will need to run:

    su - postgres 
    scl enable rh-postgresql95 -- psql engine
    

**Allowing Read-Only Access to the History Database**

1. Create the user to be granted read-only access to the history database:

        # psql -U postgres -c "CREATE ROLE [user name] WITH LOGIN ENCRYPTED PASSWORD '[password]';" -d ovirt_engine_history

2. Grant the newly created user permission to connect to the history database:

        # psql -U postgres -c "GRANT CONNECT ON DATABASE ovirt_engine_history TO [user name];"

3. Grant the newly created user usage of the `public` schema:

        # psql -U postgres -c "GRANT USAGE ON SCHEMA public TO [user name];" ovirt_engine_history

4. Generate the rest of the permissions that will be granted to the newly created user and save them to a file:

        # psql -U postgres -c "SELECT 'GRANT SELECT ON ' || relname || ' TO [user name];' FROM pg_class JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE nspname = 'public' AND relkind IN ('r', 'v');" --pset=tuples_only=on  ovirt_engine_history > grant.sql

5. Use the file you created in the previous step to grant permissions to the newly created user:

        # psql -U postgres -f grant.sql ovirt_engine_history

6. Remove the file you used to grant permissions to the newly created user:

        # rm grant.sql

You can now access the `ovirt_engine_history` database with the newly created user using the following command:

    # psql -U [user name] ovirt_engine_history

`SELECT` statements against tables and views in the `ovirt_engine_history` database succeed, while modifications fail.

**Prev:** [Tracking Tag History](../Tracking_tag_history) <br>
**Next:** [Statistics History Views](../Statistics_history_views)
