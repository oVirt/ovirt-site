---
title: Migration of local DWH Reports to remote
category: feature
authors: sradco
feature_name: Migrating local DWH and Reports to remote
feature_modules: engine
feature_status: Design
---

# Migration of local DWH Reports to remote

## Separate DWH Host

### Summary

Allow ovirt-engine-dwh and ovirt-engine-reports to be migrated and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

### Owner

*   Name: Shirly (Shirly)

<!-- -->

*   Email: <sradco@redhat.com>

### Current status

Implemented, should be available in 3.5.

### Detailed Description

We assume that engine, DWH and Reports are already setup and running on machine A and in version 3.5 and above.

We assume that user wants to migrate DWH to machine B and Reports to Machine C.

DWH needs access to the engine's database. If on separate host, user will be prompted for credentials.

Reports needs access to DWH's database. If on separate host, user will be prompted for credentials.

### Upgrade procedure of DWH from local setup to remote

On the engine machine A:

Run:

      service ovirt-engine-dwhd stop

Machine B needs access to both the engine and dwh databases:

*   If both of them are local and were configured during a clean setup of 3.5, by default this is

already configured.

*   If one or both of them are remote, you have to manually take care of that on the remote

db server(s).

*   If one or both of them are local, and were configured by a previous version (<=3.4) and then upgraded, you have to open access:
    -   Edit file **/var/lib/pgsql/data/postgresql.conf**
    -   Find the line containing 'listen_addresses' and change it to

<!-- -->

    listen_addresses = '*'

*   -   If there is no such line there, or only a commented one, add a new such line.
    -   Restart postgresql

<!-- -->

    service postgresql restart

On new DWH machine B:

Run:

      yum install ovirt-engine-dwh
      engine-setup

*   If you want to use the current DWH database:
    -   Choose to use Remote DWH database.
    -   Supply DWH and engine database credentials from the engine machine A at: **/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf**
    -   Note that if db was local, its host will be 'localhost' there - and you'll have to provide the fqdn or ip address of it
*   Allow to change the DWH to the new one.

On the engine machine A:

      yum remove ovirt-engine-dwh

If you want to migrate the dwh database from the engine machine A,

*   Create database backup using pg_dump
*   Create a new database in the new location
*   Restore using the backup file.
*   Then provide the correct credentials for it during the engine-setup.

### Upgrade procedure of Reports from local setup to remote

After the engine and dwh are setup successfully.

On the new reports machine C:

      yum install ovirt-engine-reports
      engine-setup

*   DWH credentials are located on the DWH machine at **/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf**

On the engine machine A:

*   If the user wants to remove the other reports installation
    -   "Saved Reports" can be migrated to the new installation ,by following the steps of export and import saved reports, according to the Jasper documentations .
*   Only after that run on machine A:

      service ovirt-engine-reportsd stop
      yum remove ovirt-engine-reports

There may be more than one reports instance. And they will all show the reports. But, The engine will direct to and have SSO with only the last reports instance that it was configured to work with.

### Benefit to oVirt

DWH and Reports sometimes causes a significant load on the engine machine. Installing them on a separate machines will allow distributing the load. Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

### Dependencies / Related Features

### Documentation / External references

An annotated [example setup](/develop/release-management/features/engine/separate-reports-host/#example-setup) on three machines

### Testing



[Separate DWH Host](/develop/release-management/features/) [Separate DWH Host](/develop/release-management/releases/3.5/feature/)
