---
title: Migration of DWH&Reports
authors: didi, sradco
wiki_title: Features/Migration of DWH&Reports
wiki_revision_count: 50
wiki_last_updated: 2015-01-04
feature_name: Migrating DWH and Reports
feature_modules: engine
feature_status: Design
---

# Migration of DWH&Reports

## Separate DWH Host

### Summary

Allow ovirt-engine-dwh and ovirt-engine-reports to be migrated and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

### Owner

*   Name: [ Shirly](User:Shirly)

<!-- -->

*   Email: <sradco@redhat.com>

### Current status

Implemented, should be available in 3.5.

### Detailed Description

We assume that engine, DWH and Reports are already setup and running on machine A and in version 3.5 and above.

We assume that user wants to migrate DWH to machine B and Reports to Machine C.

We need access to the engine's database. If on separate host, user will be prompted for them.

### Upgrade procedure of DWH from local setup to remote

On new DWH machine B:

*   yum install ovirt-engine-dwh

On the engine machine A:

*   service ovirt-engine-dwhd stop

If the ovirt_engine_history database remains on the same host as the engine, machine A, Edit file **/var/lib/pgsql/data/postgresql.conf**

       Find there the line containing 'listen_addresses' and change it to be:
       listen_addresses = '*'
       If there is no such line there, or only a commented one, add a new such line.

       Restart postgresql with:
       service postgresql restart 

On the new dwh machine:

*   engine-setup - supply existing credentials

       * User should choose to use Remote DWH database.
       * Get DWH and engine database credentials from the engine machine at:
         /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf
       * Allow to change the DWH to the new one.

On the engine machine:

*   yum remove ovirt-engine-dwh (or rhevm-dwh)- Must (or after an hour the service will try to restart).

This is the scenario for etl process migration to a separate host. The ovirt_engine_history database remains on the same host as the engine.

If the user also wants to migrate the ovirt_engine_history database then he should create database backup using pg_dump , create a new database in the new location and restore using the backup file. Then provide the correct credentials for it during the engine-setup.

### Upgrade procedure of Reports from local setup to remote

After the engine and dwh are setup successfully.

On the new reports machine:

*   yum install ovirt-engine-reports
*   engine-setup - supply existing credentials

       DWH credentials are located at /etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf 

On the engine machine:

      If the user wants to remove the other reports installation
       * "Saved Reports" can be migrated to the new installation ,by following the steps 
         of export and import saved reports, according to the documentations .
      Only after that run on the old machine:
       * service ovirt-engine-reportsd stop
       * yum remove ovirt-engine-reports (or rhevm-reports)

       There may be more than one reports instance. And they will all show the reports.
      But, The engine will direct to and have SSO with only with the last reports instance that run engine-setup.

### Benefit to oVirt

DWH and Reports sometimes causes a significant load on the engine machine. Installing them on a separate machines will allow distributing the load. Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1156009> <https://bugzilla.redhat.com/1156015>

An annotated [example setup](Separate-Reports-Host#Example_setup) on three machines

### Testing

### Comments and Discussion

*   Refer to <Talk:Separate-DWH-Host>

[Separate DWH Host](Category:Feature) [Separate DWH Host](Category:oVirt 3.5 Feature)
