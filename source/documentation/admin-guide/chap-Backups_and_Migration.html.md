---
title: Backups and Migration
---

# Chapter 12: Backups and Migration

## Backing Up and Restoring the oVirt Engine

### Backing up oVirt Engine - Overview

Use the `engine-backup` tool to take regular backups of the oVirt Engine. The tool backs up the engine database and configuration files into a single file and can be run without interrupting the `ovirt-engine` service.

### Syntax for the engine-backup Command

The `engine-backup` command works in one of two basic modes:

    # engine-backup --mode=backup

    # engine-backup --mode=restore

These two modes are further extended by a set of parameters that allow you to specify the scope of the backup and different credentials for the engine database. Run `engine-backup --help` for a full list of parameters and their function.

**Basic Options**

`--mode`
: Specifies whether the command will perform a backup operation or a restore operation. Two options are available - `backup`, and `restore`. This is a required parameter.

`--file`
: Specifies the path and name of a file into which backups are to be taken in backup mode, and the path and name of a file from which to read backup data in restore mode. This is a required parameter in both backup mode and restore mode.

`--log`
: Specifies the path and name of a file into which logs of the backup or restore operation are to be written. This parameter is required in both backup mode and restore mode.

`--scope`
: Specifies the scope of the backup or restore operation. There are four options: `all`, which backs up or restores all databases and configuration data; `files`, which backs up or restores only files on the system; `db`, which backs up or restores only the Engine database; and `dwhdb`, which backs up or restores only the Data Warehouse database. The default scope is `all`.

  The `--scope` parameter can be specified multiple times in the same `engine-backup` command.

**Engine Database Options**

The following options are only available when using the `engine-backup` command in `restore` mode. The option syntax below applies to restoring the Engine database. The same options exist for restoring the Data Warehouse database. See `engine-backup --help` for the Data Warehouse option syntax.

`--provision-db`
: Creates a PostgreSQL database for the Engine database backup to be restored to. This is a required parameter when restoring a backup on a remote host or fresh installation that does not have a PostgreSQL database already configured.

`--change-db-credentials`
: Allows you to specify alternate credentials for restoring the Engine database using credentials other than those stored in the backup itself. See `engine-backup --help` for the additional parameters required by this parameter.

`--restore-permissions` or `--no-restore-permissions`
: Restores (or does not restore) the permissions of database users. One of these parameters is required when restoring a backup.

    **Note:** If a backup contains grants for extra database users, restoring the backup with the `--restore-permissions` and `--provision-db` (or `--provision-dwh-db`) options will create the extra users with random passwords. You must change these passwords manually if the extra users require access to the restored system.

### Creating a Backup with the engine-backup Command

The oVirt Engine can be backed up using the `engine-backup` command while the Engine is active. Append one of the following options to `--scope` to specify which backup to perform:

* `all`: A full backup of all databases and configuration files on the Engine

* `files`: A backup of only the files on the system

* `db`: A backup of only the Engine database

* `dwhdb`: A backup of only the Data Warehouse database

    **Important:** To restore a database to a fresh installation of oVirt Engine, a database backup alone is not sufficient; the Engine also requires access to the configuration files. Any backup that specifies a scope other than the default, `all`, must be accompanied by the `files` scope, or a filesystem backup.

**Example Usage of the engine-backup Command**

1. Log on to the machine running the oVirt Engine.

2. Create a backup:

    **Creating a Full Backup**

        # engine-backup --scope=all --mode=backup --file=file_name --log=log_file_name

    **Creating a Engine Database Backup**

        # engine-backup --scope=files --scope=db --mode=backup --file=file_name --log=log_file_name

    Replace the `db` option with `dwhdb` to back up the Data Warehouse database.

    A `tar` file containing a backup is created using the path and file name provided.

The `tar` files containing the backups can now be used to restore the environment.

### Restoring a Backup with the engine-backup Command

Restoring a backup using the engine-backup command involves more steps than creating a backup does, depending on the restoration destination. For example, the `engine-backup` command can be used to restore backups to fresh installations of oVirt, on top of existing installations of oVirt, and using local or remote databases.

**Important:** Backups can only be restored to environments of the same major release as that of the backup. For example, a backup of a oVirt version 4.0 environment can only be restored to another oVirt version 4.0 environment. To view the version of oVirt contained in a backup file, unpack the backup file and read the value in the `version` file located in the root directory of the unpacked files.

### Restoring a Backup to a Fresh Installation

The `engine-backup` command can be used to restore a backup to a fresh installation of the oVirt Engine. The following procedure must be performed on a machine on which the base operating system has been installed and the required packages for the oVirt Engine have been installed, but the `engine-setup` command has not yet been run. This procedure assumes that the backup file or files can be accessed from the machine on which the backup is to be restored.

**Restoring a Backup to a Fresh Installation**

1. Log on to the Engine machine. If you are restoring the engine database to a remote host, you will need to log on to and perform the relevant actions on that host. Likewise, if also restoring the Data Warehouse to a remote host, you will need to log on to and perform the relevant actions on that host.

2. Restore a complete backup or a database-only backup.

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --restore-permissions

        If Data Warehouse is also being restored as part of the complete backup, provision the additional database:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --provision-dwh-db --restore-permissions

    * Restore a database-only backup by restoring the configuration files and database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --provision-db --restore-permissions

        The example above restores a backup of the Engine database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --provision-dwh-db --restore-permissions

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

3. Run the following command and follow the prompts to configure the restored Engine:

        # engine-setup

The oVirt Engine has been restored to the version preserved in the backup. To change the fully qualified domain name of the new oVirt system, see [Ovirt Engine Rename Tool](Ovirt_Engine_Rename_Tool).

### Restoring a Backup to Overwrite an Existing Installation

The `engine-backup` command can restore a backup to a machine on which the oVirt Engine has already been installed and set up. This is useful when you have taken a backup up of an installation, performed changes on that installation, and then want to restore the installation from the backup.

    **Important:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-cleanup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist.

**Restoring a Backup to Overwrite an Existing Installation**

1. Log on to the oVirt Engine machine.

2. Remove the configuration files and clean the database associated with the Engine:

        # engine-cleanup

3. Restore a full backup or a database-only backup:

    * Restore a full backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --restore-permissions

    * Restore a database-only backup by restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --restore-permissions

        The example above restores a backup of the Engine database. If necessary, also restore the Data Warehouse database:

            # engine-backup --mode=restore --scope=dwhdb --file=file_name --log=log_file_name --restore-permissions

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4. Run the following command and follow the prompts to reconfigure the firewall and ensure the <literal>ovirt-engine</literal> service is correctly configured:

        # engine-setup

### Restoring a Backup with Different Credentials

The `engine-backup` command can restore a backup to a machine on which the oVirt Engine has already been installed and set up, but the credentials of the database in the backup are different to those of the database on the machine on which the backup is to be restored. This is useful when you have taken a backup of an installation and want to restore the installation from the backup to a different system.

    **Important:** When restoring a backup to overwrite an existing installation, you must run the `engine-cleanup` command to clean up the existing installation before using the `engine-backup` command. Because the `engine-cleanup` command only cleans the engine database, and does not drop the database or delete the user that owns that database, you do not need to create a new database or specify the database credentials because the user and database already exist. However, if the credentials for the owner of the engine database are not known, you must change them before you can restore the backup.

**Restoring a Backup with Different Credentials**

1. Log on to the machine on which the oVirt Engine is installed.

2. Run the following command and follow the prompts to remove the configuration files for and clean the database associated with the Engine:

        # engine-cleanup

3. Change the password for the owner of the engine database if the credentials of that user are not known:

    1. Enter the postgresql command line:

            # su postgres
            $ psql

    2. Change the password of the user that owns the `engine` database:

            postgres=# alter role user_name encrypted password 'new_password';

        Repeat this for the user that owns the `ovirt_engine_dwh` database if necessary.

4. Restore a complete backup or a database-only backup with the `--change-db-credentials` parameter to pass the credentials of the new database. The `database_location` for a database local to the Engine is `localhost`.

    **Note:** The following examples use a `--*password` option for each database without specifying a password, which will prompt for a password for each database. Passwords can be supplied for these options in the command itself, however this is not recommended as the password will then be stored in the shell history. Alternatively, `--*passfile=password_file` options can be used for each database to securely pass the passwords to the `engine-backup` tool without the need for interactive prompts.

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --no-restore-permissions

        If Data Warehouse is also being restored as part of the complete backup, include the revised credentials for the additional database:

            engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password --no-restore-permissions

    * Restore a database-only backup by restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --no-restore-permissions

        The example above restores a backup of the Engine database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=log_file_name --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password --no-restore-permissions

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

5. Run the following command and follow the prompts to reconfigure the firewall and ensure the `ovirt-engine` service is correctly configured:

        # engine-setup

### Migrating the Engine Database to a Remote Server Database

You can migrate the `engine` database to a remote database server after the oVirt Engine has been initially configured. Use `engine-backup` to create a database backup and restore it on the new database server. This procedure assumes that the new database server has Enterprise Linux 7 installed and the appropriate subscriptions configured. See "Subscribing to the Required Entitlements" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

**Migrating the Database**

1. Log in to the oVirt Engine machine and stop the `ovirt-engine` service so that it does not interfere with the engine backup:

        # systemctl stop ovirt-engine.service

2. Create the `engine` database backup:

        # engine-backup --scope=files --scope=db --mode=backup --file=file_name --log=log_file_name

3. Copy the backup file to the new database server:

        # scp /tmp/engine.dump root@new.database.server.com:/tmp

4. Log in to the new database server and install `engine-backup`:

        # yum install ovirt-engine-tools-backup

5. Restore the database on the new database server. `file_name` is the backup file copied from the Engine.

        # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=log_file_name --provision-db --no-restore-permissions

6. Now that the database has been migrated, start the `ovirt-engine` service:

        # systemctl start ovirt-engine.service

## Backing Up and Restoring Virtual Machines Using the Backup and Restore API

### The Backup and Restore API

The backup and restore API is a collection of functions that allows you to perform full or file-level backup and restoration of virtual machines. The API combines several components of oVirt, such as live snapshots and the REST API, to create and work with temporary volumes that can be attached to a virtual machine containing backup software provided by an independent software provider.

### Backing Up a Virtual Machine

Use the backup and restore API to back up a virtual machine. This procedure assumes you have two virtual machines: the virtual machine to back up, and a virtual machine on which the software for managing the backup is installed.

**Backing Up a Virtual Machine**

1. Using the REST API, create a snapshot of the virtual machine to back up:

        POST /api/vms/11111111-1111-1111-1111-111111111111/snapshots/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <snapshot>
            <description>BACKUP</description>
        </snapshot>

    **Note:** When you take a snapshot of a virtual machine, a copy of the configuration data of the virtual machine as at the time the snapshot was taken is stored in the `data` attribute of the `configuration` attribute in `initialization` under the snapshot.

    **Important:** You cannot take snapshots of disks that are marked as shareable or that are based on direct LUN disks.

2. Retrieve the configuration data of the virtual machine from the `data` attribute under the snapshot:

        GET /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

3. Identify the disk ID and snapshot ID of the snapshot:

        GET /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111/disks HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

4. Attach the snapshot to the backup virtual machine and activate the disk:

        POST /api/vms/22222222-2222-2222-2222-222222222222/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <disk id="11111111-1111-1111-1111-111111111111">
            <snapshot id="11111111-1111-1111-1111-111111111111"/>
            <active>true</active>
        </disk>

5. Use the backup software on the backup virtual machine to back up the data on the snapshot disk.

6. Detach the snapshot disk from the backup virtual machine:

        DELETE /api/vms/22222222-2222-2222-2222-222222222222/disks/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <action>
            <detach>true</detach>
        </action>

7. Optionally, delete the snapshot:

        DELETE /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

You have backed up the state of a virtual machine at a fixed point in time using backup software installed on a separate virtual machine.

### Restoring a Virtual Machine

Restore a virtual machine that has been backed up using the backup and restore API. This procedure assumes you have a backup virtual machine on which the software used to manage the previous backup is installed.

**Restoring a Virtual Machine**

1. In the Administration Portal, create a floating disk on which to restore the backup. See [Creating Unassociated Virtual Machine Hard Disks](Creating_Unassociated_Virtual_Machine_Hard_Disks) for details on how to create a floating disk.

2. Attach the disk to the backup virtual machine:

        POST /api/vms/22222222-2222-2222-2222-222222222222/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <disk id="11111111-1111-1111-1111-111111111111">
        </disk>

3.  Use the backup software to restore the backup to the disk.

4. Detach the disk from the backup virtual machine:

        DELETE /api/vms/22222222-2222-2222-2222-222222222222/disks/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <action>
            <detach>true</detach>
        </action>

5. Create a new virtual machine using the configuration data of the virtual machine being restored:

        POST /api/vms/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <vm>
            <cluster>
                <name>cluster_name</name>
            </cluster>
            <name>NAME</name>
            ...
        </vm>

6. Attach the disk to the new virtual machine:

        POST /api/vms/33333333-3333-3333-3333-333333333333/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

        <disk id="11111111-1111-1111-1111-111111111111">
        </disk>

You have restored a virtual machine using a backup that was created using the backup and restore API.

**Prev:** [Chapter 11: External Providers](chap-External_Providers)<br>
**Next:** [Chapter 13: Errata Management with Foreman](chap-Errata_Management_with_Foreman)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-backups_and_migration)
