---
title: oVirt-engine-backup
category: feature
authors:
  - bobdrad
  - bproffitt
  - didi
  - emesika
  - mlipchuk
  - oschreib
---

# oVirt-engine-backup

## Summary

A simple utility to backup and restore a complete ovirt-engine environment.

## Owner

*   Name: Ofer Schreiber

## Current status


### Phase

First version released in ovirt 3.3.

DWH/Reports support added in ovirt 3.4.1.

DB provisioning, speed/size tuning options, [engine notification](/develop/release-management/features/infra/backupawareness.html) added in oVirt 3.6.

## Howto

### Backup

Backup is straightforward. See `--help` for details.

Example:
```
engine-backup --mode=backup --file=backup1 --log=backup1.log
```

### Restore

Requirements:

*   A clean machine
*   oVirt installed but not set up

To restore:

*   Run restore (`--help` for details)
*   Run engine-setup

Example:

With a backup file `backup1`, taken on a 4.0 engine+dwh machine in a default setup, this should restore the engine and dwh on a new machine:
```
yum install ovirt-engine ovirt-engine-dwh
engine-backup --mode=restore --log=restore1.log --file=backup1 --provision-db --provision-dwh-db --no-restore-permissions
engine-setup
```

#### Details

If backed up databases were provisioned by engine-setup ("Automatic" was accepted for the questions "Setup can configure the local postgresql server automatically for X..."), engine-backup can provision them too on restore if requested, since 3.6, using these options: `--provision-db`, `--provision-dwh-db`, `--provision-reports-db`.

When restoring a backup taken using the (default) `custom` dump format, the user must pass one of the options `--restore-permissions` or `--no-restore-permissions` - there is no default.
With `--no-restore-permissions`, only the database owner will have access to it, which is enough for the normal functioning of oVirt.

If extra users were added and granted access to the database, for example for integration with ManageIQ, they will not be created and will not have access. If they are manually created, passing `--restore-permissions` will run the extra GRANT commands.

In 4.0.4 and later, if passing both `--provision*db` and `--restore-permissions`, the extra users will be created automatically with random passwords. See [BZ 1369757 Comment 1](https://bugzilla.redhat.com/show_bug.cgi?id=1369757#c1) for details.

Provisionoing is done using a utility based on the same code used by engine-setup, that is called by engine-backup. In particular, this means that these options will:

*   work either if a database does not exist (including if postgresql was not initialized at all) or if it exists and is empty (e.g. right after engine-cleanup). This should work even if the user exists and has a different password (it will be changed).
*   fail if a database exists and is not empty. In such a case a new empty database will be created named BASENAME_TIMESTAMP (e.g. engine_20150506120000), as does engine-setup in such a case, but unlike engine-setup, restore will be aborted asking the user to clean up and retry.

**The text below applies to versions <= 3.5**, as well as to 3.6 if `--provision-\*db` is not used.

#### DB credentials

If it happens that the credentials used during backup still work during restore, they can be used, and in this case restore is as simple as backup. Example scenarios where this is the case:

*   engine was setup with a local database, backup was created, some time later engine-cleanup was called, and we now want to restore to the state saved by backup. This works because engine-cleanup does not drop the user and/or database in postgresql, just the database's content.
*   engine was setup with a remote database, backup was created, engine-cleanup was ran, and now we want to restore the engine on another machine, but using the same database server. This will work too without supplying different credentials, for the same reason, provided that we make sure the new engine host has access to the database server/instance/etc.

In most other cases, we have to manually create the database, make it accessible to the engine, and use the credentials we have chosen when calling restore. An example scenario that requires this:

*   engine was setup with a local database, backup was done, now we want to restore this backup on another machine (for testing or whatever).

Due to some misunderstanding about the previous points, it was sometimes suggested on various places to do:

*   setup engine with local database on machineA
*   backup
*   Copy backup to machineB
*   On machineB:

       * engine-setup
       * engine-cleanup
       * restore

This "almost" works. engine-setup/engine-cleanup on machineB create a user/database for us. What's missing? The password is generated randomly by setup, and so will be different on both machines and restore will not be able to connect. What can we do to continue and save us from manually doing all the work (2x create, edit pg_hba, restart postgresql)? Generally, two options:

1. change the password:

       * Open the backup in some temporary directory (it's a tar file)
       * look at the file "files/etc/ovirt-engine/engine.conf.d/10-setup-database.conf" and find the password used when doing backup
       * as user postgres, run psql, and there do:
          alter role engine ENCRYPTED PASSWORD 'MYPASSWORD';
         replace MYPASSWORD with the password you found inside the backup file.

2. manually create with existing credentials:

       * instead of doing setup/cleanup to merely create a database, do that yourself manually, but instead of inventing a new password (and other credentials), use the ones found inside the backup file (as explained in the previous option "change the password"). This is a bit more work than running setup/cleanup, but is probably much faster (especially if scripted).

3. After running engine-setup and before engine-cleanup, check what random password was chosen by setup:

      grep ENGINE_DB_PASSWORD /etc/ovirt-engine/engine.conf.d/10-setup-database.conf

Then use this password on restore (after cleanup). Note that you must provide more credentials than just the password:

      engine-backup --mode=restore --file=BACKUP_FILE --log=LOG_FILE --change-db-credentials --db-host=localhost --db-user=engine --db-name=engine --db-password

## DWH/Reports

The 3.4.1 release added support for DWH and Reports. On backup, whatever that's installed/setup - among engine, DWH and Reports - is backed up, and on restore, you should install whatever packages that were used during backup (engine/dwh/reports), then restore and setup. Running engine-setup is now mandatory after restore.

The notes and discussion above about DB credentials apply also to the DWH and Reports databases - they are never created by restore but are expected to exist, and be usable with the credentials saved in the backup or passed using the various options.

### DWH up during backup

**Update for 3.6**: `engine-backup --mode=restore` will automatically reset DwhCurrentlyRunning in the engine's database.

The text below applies to versions <= 3.5.

If dwhd is running during backup, 'engine-setup' after restore will emit the following error and exit:

      [ ERROR ] dwhd is currently running. Its hostname is `*`hostname`*`. Please stop it before running Setup.
      [ ERROR ] Failed to execute stage 'Transaction setup': dwhd is currently running

This will be emitted whether or not dwh is setup on the same machine as the engine or on a different one. To "fix" this, connect to the engine db using psql and run:

      UPDATE dwh_history_timekeeping SET var_value=0 WHERE var_name ='DwhCurrentlyRunning';

Then run 'engine-setup' again and it should succeed.

## Speed/Size tuning

In version 3.6, several options were added that can affect the size of the generated backup file, as well as the speed of backup/restore:

### Compression

Each of 'files' (which are now always tarred into their own tar file inside the final archive), 'db' (engine database) 'dwhdb' (DWH database) and 'reportsdb' (Reports database) and the final archive (`--file=FILE`) can be separately either left uncompressed, or compressed with one of gzip, bzip2, xz.

### Database dump format

For each of the databases:

*   The dump format can be selected - either 'plain' or 'custom' are accepted.
*   If, during backup, 'custom' format and no compression (None) are selected, then during restore, the number of restore jobs can be set, and is passed to pg_restore's `--jobs` option.

### Defaults and discussion

The defaults are currently (on the master branch):

*   Final archive compressed with gzip
*   Files tar is compressed with xz
*   Databases are using the 'custom' dump format, and are not compressed further (this format uses gzip internally)
*   On restore, number of restore jobs is 2

See [bug 1213153](https://bugzilla.redhat.com/show_bug.cgi?id=1213153) about adding other "collections" of options.

For smallest size (e.g. for archiving), probably everything should be compressed with xz, with 'plain' dump format for databases.

For fastest restore, number of restore jobs should be set somewhere between N and 1.5\*N, where N is the number of available cpu cores.

Also for fastest restore (and general good performance), each of the Engine/DWH/Reports can have its database on its own machine. In such a case, in principle, restore can be done in parallel. `engine-backup` currently does not support that natively, but a user can try to achieve that manually, by backing up each 'scope' (using `--scope=`) to its own file, and then, on restore, first restore the files, and after that restore the databases in parallel.

See also the documentation of PostgreSQL - on [postgresql.org](http://www.postgresql.org/) and in the pg_restore man page.

## Detailed Description

Backup logic:

      * Create Temporary directory
      * Copy configuration files into temp directory
         1. /etc/ovirt-engine/  (ovirt engine configuration)
         2. /etc/sysconfig/ovirt-engine (ovirt engine configuration)
         3. /etc/exports.d  (NFS export created on setup)
         4. /etc/pki/ovirt-engine (ovirt-engine keys)
         5. Firewall
         6. Other
       * Create tar file from that directory
       * Create database backup using pg_dump (database configuration should be read from /etc and written into temporary .pgpass file)

Restore: Phase one (BASH)

      1. Request user to run engine-setup
      2. Override DB and PKI directories

Phase two (??)

      * Gather all needed information from the backup
      *  Run otopi based ovirt-engine-setup with special parameters (use pg_dump, don't create new PKI)

## Benefit to oVirt

*   Easy to use backup utility
*   Easy restore of existing environments.

## Dependencies / Related Features

TBD

## Documentation / External references

See output of `engine-backup --help`.



