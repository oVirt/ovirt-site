# Creating a Backup with the engine-backup Command

The Red Hat Virtualization Manager can be backed up using the `engine-backup` command while the Manager is active. Append one of the following options to `--scope` to specify which backup to perform:

* `all`: A full backup of all databases and configuration files on the Manager

* `files`: A backup of only the files on the system

* `db`: A backup of only the Manager database

* `dwhdb`: A backup of only the Data Warehouse database

**Important:** To restore a database to a fresh installation of Red Hat Virtualization Manager, a database backup alone is not sufficient; the Manager also requires access to the configuration files. Any backup that specifies a scope other than the default, `all`, must be accompanied by the `files` scope, or a filesystem backup.

**Example Usage of the engine-backup Command**

1. Log on to the machine running the Red Hat Virtualization Manager.

2. Create a backup: 

    **Creating a Full Backup**

        # engine-backup --scope=all --mode=backup --file=file_name --log=log_file_name

    **Creating a Manager Database Backup**

        # engine-backup --scope=files --scope=db --mode=backup --file=file_name --log=log_file_name

    Replace the `db` option with `dwhdb` to back up the Data Warehouse database.

    A `tar` file containing a backup is created using the path and file name provided.

The `tar` files containing the backups can now be used to restore the environment.
