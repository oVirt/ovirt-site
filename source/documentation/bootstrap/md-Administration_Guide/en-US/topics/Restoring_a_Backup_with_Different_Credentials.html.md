# Restoring a Backup with Different Credentials

The `engine-backup` command can restore a backup to a machine on which the Red Hat Virtualization Manager has already been installed and set up, but the credentials of the database in the backup are different to those of the database on the machine on which the backup is to be restored. This is useful when you have taken a backup of an installation and want to restore the installation from the backup to a different system.

**Important:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-cleanup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist. However, if the credentials for the owner of the engine database are not known, you must change them before you can restore the backup.

**Restoring a Backup with Different Credentials**

1. Log on to the machine on which the Red Hat Virtualization Manager is installed.

2. Run the following command and follow the prompts to remove the configuration files for and clean the database associated with the Manager:

        # engine-cleanup

3. Change the password for the owner of the engine database if the credentials of that user are not known:

    1. Enter the postgresql command line:

            # su postgres
            $ psql

    2. Change the password of the user that owns the `engine` database:

            postgres=# alter role user_name encrypted password 'new_password';

        Repeat this for the user that owns the `ovirt_engine_dwh` database if necessary.

4. Restore a complete backup or a database-only backup with the `--change-db-credentials` parameter to pass the credentials of the new database. The `database_location` for a database local to the Manager is `localhost`.

    **Note:** The following examples use a `--*password` option for each database without specifying a password, which will prompt for a password for each database. Passwords can be supplied for these options in the command itself, however this is not recommended as the password will then be stored in the shell history. Alternatively, `--*passfile=password_file` options can be used for each database to securely pass the passwords to the `engine-backup` tool without the need for interactive prompts.

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --no-restore-permissions

        If Data Warehouse is also being restored as part of the complete backup, include the revised credentials for the additional database:

            engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password --no-restore-permissions

    * Restore a database-only backup by restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --no-restore-permissions

        The example above restores a backup of the Manager database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password --no-restore-permissions

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

5. Run the following command and follow the prompts to reconfigure the firewall and ensure the `ovirt-engine` service is correctly configured:

        # engine-setup
