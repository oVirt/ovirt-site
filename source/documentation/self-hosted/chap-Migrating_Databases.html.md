---
title: Migrating the Self-Hosted Engine Database to a Remote Server Database
---

# Chapter 8: Migrating the Self-Hosted Engine Database to a Remote Server Database

You can migrate the engine database of a self-hosted engine to a remote database server after the oVirt Engine has been initially configured. Use `engine-backup` to create a database backup and restore it on the new database server. This procedure assumes that the new database server has Enterprise Linux 7 installed and the appropriate subscriptions configured.

**Migrating the Database**

1. Log in to a self-hosted engine node and place the environment into `global` maintenance mode. This disables the High Availability agents and prevents the Manager virtual machine from being migrated during the procedure:

        # hosted-engine --set-maintenance --mode=global

2. Log in to the oVirt Engine machine and stop the `ovirt-engine` service so that it does not interfere with the engine backup:

        # systemctl stop ovirt-engine.service

3. Create the `engine` database backup:

        # engine-backup --scope=files --scope=db --mode=backup --file=file_name --log=backup_log_name

4. Copy the backup file to the new database server:

        # scp /tmp/engine.dump root@new.database.server.com:/tmp

5. Log in to the new database server and install `engine-backup`:

        # yum install ovirt-engine-tools-backup

6. Restore the database on the new database server. file_name is the backup file copied from the Engine.

        # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=restore_log_name --provision-db --no-restore-permissions

7. Now that the database has been migrated, start the `ovirt-engine` service:

        # systemctl start ovirt-engine.service

8. Log in to a self-hosted engine node and turn off maintenance mode, enabling the High Availability agents:

        # hosted-engine --set-maintenance --mode=none

**Prev:** [Chapter 7: Backing up and Restoring an EL-Based Self-Hosted Environment](../chap-Backing_up_and_Restoring_an_EL-Based_Self-Hosted_Environment)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-migrating_databases)
