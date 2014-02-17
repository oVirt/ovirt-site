---
title: Ovirt-engine-backup
category: feature
authors: bobdrad, bproffitt, didi, emesika, mlipchuk, oschreib
wiki_category: Feature
wiki_title: Ovirt-engine-backup
wiki_revision_count: 16
wiki_last_updated: 2015-05-06
wiki_warnings: references, table-style
---

# Ovirt-engine-backup

## Ovirt backup and restore utility

### Summary

A simple utility to create and restore a complete ovirt-engine environment.

### Owner

*   Name: [Ofer Schreiber](User:oschreib)
*   Email: <oschreib@redhat.com>

### Current status

*   Last updated: ,

#### Phase

First version released in ovirt 3.3.

#### Features

| Feature | Existing implementation | Otopi implementation | Owner                                       | Priority | Target date |
|---------|-------------------------|----------------------|---------------------------------------------|----------|-------------|
| TBD     | Done                    | Not implemented      |                                             |          |             |
| TBD     | Done                    | Done [1]             | [ Ofer Schreiber](User:Oschreib) |          |             |

<references>
[2]

</references>
### Howto

Backup is strait-forward. See '--help' (also copied below) for details.

Restore usually requires a bit more work, because it never creates the user and/or database for you. That's the main point to understand when trying to solve restore issues.

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

       * engine-setup
       * engine-cleanup
       * restore

This "almost" works. engine-setup/engine-cleanup on machineB create a user/database for us. What's missing? The password is generated randomly by setup, and so will be different on both machines and restore will not be able to connect. What can we do to continue and save us from manually doing all the work (2x create, edit pg_hba, restart postgresql)? Generally, two options:

1. change the password:

       * Open the backup in some temporary directory (it's a tar file)
       * look at the file "files/etc/ovirt-engine/engine.conf.d/10-setup-database.conf" and find the password used when doing backup
       * as user postgres, run psql, and there do:
          alter role engine ENCRYPTED PASSWORD 'MYPASSWORD';
         replace MYPASSWORD with the password you found inside the backup file.

2. manually create with existing credentials:

       * instead of doing setup/cleanup to merely create a database, do that yourself manually, but instead of inventing a new password (and other credentials), use the ones found inside the backup file (as explained in the previous option "change the password"). This is a bit more work than running setup/cleanup, but is probably much faster (especially if scripted).

### Detailed Description

Backup logic:

      * Create Temporary directory
      * Copy configuration files into temp directory
         1. /etc/ovirt-engine/  (ovirt engine configuration)
         2. /etc/sysconfig/ovirt-engine (ovirt engine configuration)
         3. /etc/exports.d  (NFS export created on setup)
         4. /etc/pki/ovirt-engine (ovirt-engine keys)
         5. Firewall
         6. Other
       * Create tar file from that directory
       * Create database backup using pgdump (database configuration should be read from /etc and written into temporary .pgpass file)

Restore: Phase one (BASH)

      1. Request user to run engine-setup
      2. Override DB and PKI directories

Phase two (??)

      * Gather all needed information from the backup
      *  Run otopi based ovirt-engine-setup with special parameters (use pgdump, don't create new PKI)

### Benefit to oVirt

*   Easy to use backup utility
*   Easy restore of existing environments.

### Dependencies / Related Features

TBD

### Documentation / External references

      # engine-backup --help
      engine-backup: backup and restore ovirt-engine environment
      USAGE:
          /usr/bin/engine-backup [--mode=MODE] [--scope=SCOPE] [--file=FILE] [--log=FILE]
       MODE is one of the following:
          backup                  backup system into FILE
          restore                 restore system from FILE
       SCOPE is one of the following:
          all                     complete backup/restore (default)
          db                      database only
       --file=FILE                file to use during backup or restore
       --log=FILE                 log file to use
       --change-db-credentials    activate the following options, to restore
                                  the database to a different location etc.
                                  If used, existing credentials are ignored.
       --db-host=host             set database host
       --db-port=port             set database port
       --db-user=user             set database user
       --db-passfile=file         set database password - read from file
       --db-password=pass         set database password
       --db-password              set database password - interactively
       --db-name=name             set database name
       --db-secured               set a secured connection
       --db-secured-validation    validate host
       ENVIRONMENT VARIABLES
       OVIRT_ENGINE_DATABASE_PASSWORD
           Database password as if provided by --db-password=pass option.
       To create a new user/database:
       create user `<user>` password '`<password>`';
       create database `<database>` owner `<user>` template template0
       encoding 'UTF8' lc_collate 'en_US.UTF-8 lc_ctype 'en_US.UTF-8';
       Open access in the firewall/iptables/etc. to the postgresql port,
       5432/tcp by default.
       Locate pg_hba.conf within your distribution,
       common locations are:
        - /var/lib/pgsql/data/pg_hba.conf
        - /etc/postgresql-*/pg_hba.conf
        - /etc/postgresql/*/main/pg_hba.conf
       and open access there by adding the following lines:
       host    `<database>`      `<user>`          0.0.0.0/0               md5
       host    `<database>`      `<user>`          ::0/0                   md5
       Replace `<user>`, `<password>`, `<database>` with appropriate values.

### Comments and Discussion

*   Refer to <Talk:Features/ovirt-engine-backup>

<Category:Feature>

[1] 

[2] Placeholder
