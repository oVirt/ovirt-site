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
