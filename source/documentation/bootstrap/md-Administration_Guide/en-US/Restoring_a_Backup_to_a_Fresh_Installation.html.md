# Restoring a Backup to a Fresh Installation

The `engine-backup` command can be used to restore a backup to a fresh installation of the Red Hat Virtualization Manager. The following procedure must be performed on a machine on which the base operating system has been installed and the required packages for the Red Hat Virtualization Manager have been installed, but the `engine-setup` command has not yet been run. This procedure assumes that the backup file or files can be accessed from the machine on which the backup is to be restored.

**Restoring a Backup to a Fresh Installation**

1. Log on to the Manager machine. If you are restoring the engine database to a remote host, you will need to log on to and perform the relevant actions on that host. Likewise, if also restoring the Data Warehouse to a remote host, you will need to log on to and perform the relevant actions on that host.

2. Restore a complete backup or a database-only backup. 

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --restore-permissions

        If Data Warehouse is also being restored as part of the complete backup, provision the additional database:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --provision-dwh-db --restore-permissions

    * Restore a database-only backup by restoring the configuration files and database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --provision-db --restore-permissions

        The example above restores a backup of the Manager database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --provision-dwh-db --restore-permissions

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

3. Run the following command and follow the prompts to configure the restored Manager:

        # engine-setup

The Red Hat Virtualization Manager has been restored to the version preserved in the backup. To change the fully qualified domain name of the new Red Hat Virtualization system, see [Ovirt Engine Rename Tool](Ovirt_Engine_Rename_Tool).
