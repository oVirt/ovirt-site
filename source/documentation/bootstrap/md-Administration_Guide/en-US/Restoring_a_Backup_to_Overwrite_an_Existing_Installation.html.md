# Restoring a Backup to Overwrite an Existing Installation

The `engine-backup` command can restore a backup to a machine on which the Red Hat Virtualization Manager has already been installed and set up. This is useful when you have taken a backup up of an installation, performed changes on that installation, and then want to restore the installation from the backup.

**Important:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-cleanup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist.

**Restoring a Backup to Overwrite an Existing Installation**

1. Log on to the Red Hat Virtualization Manager machine.

2. Remove the configuration files and clean the database associated with the Manager:

        # engine-cleanup

3. Restore a full backup or a database-only backup:

    * Restore a full backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --restore-permissions

    * Restore a database-only backup by restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --restore-permissions

        The example above restores a backup of the Manager database. If necessary, also restore the Data Warehouse database:

            # engine-backup --mode=restore --scope=dwhdb --file=file_name --log=log_file_name --restore-permissions

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4. Run the following command and follow the prompts to reconfigure the firewall and ensure the <literal>ovirt-engine</literal> service is correctly configured:

        # engine-setup
