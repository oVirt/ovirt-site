---
title: RemoteDB
category: feature
authors: alourie
---

# Remote DB

## Summary

Remote DB feature means working with a Postgres instance on a remote host.

## Owner

*   Name: Alex Lourie (Alourie)

## Current status

The code is developed and is a part of the upstream code.

## Design and flow

### Setup

*   During the engine-setup operation, user is asked to select 'remote' or 'local' installation. Default value 'local' is offered.

      * If entered 'local', the installation will continue and perform installation on the local machine.
      * If entered 'remote', the additional set of questions will be presented.
        * Additional questions include: DB Admin username, DB Port, Remote Db password and "Security usage" parameters.

*   Installation proceeds with normal flow.
*   During the normal flow, additional parameters (if entered by user) are used during DB creation and JBoss configuration.

DB configuration parameters are stored in **~/.pgpass file**, including remote host, port and username/password. JBoss configuration is stored in **/usr/share/jboss-as/standalone/configuration/standalone.xml** file.

*   If setup is rerun, the same parameters are used in "upgradeDb" function. Also, see next section for the upgrade logic.

### Upgrade

*   During the upgrade, the DB connection values are received from ~/.pgpass file and used for connection.
*   The upgrade works as follows:

      * First, the packages are upgraded if necessary.
      * Before performing the DB upgrade, a backup is taken.
`* After the backup, the default DB (engine) is renamed to engine-`<date>
       * If renaming fails, yum rollback is performed, and user is notified about possible active connections.
       * If renaming succeeds, DB upgrade is started.
      * If upgrade fails, the renamed DB is removed and yum rollback is performed.
      * If upgrade succeeds, the engine-`<date>` is renamed back to 'engine'.

### Cleanup

*   During the upgrade, the DB connection values are received from ~/.pgpass file and used for connection.
*   If DB drop fails user is notified about possible active connections.

### Unattended (silent) installation

It is possible to use an answer file for the silent installation. The values for the RemoteDb are:

      DB_REMOTE_INSTALL=local
      DB_HOST=10.1.1.1
      DB_PORT=5433
      DB_ADMIN=remotedb_test
      DB_REMOTE_PASS=54321
      DB_SECURE_CONNECTION=no
      DB_LOCAL_PASS=admin!ad

To use with local installation, only DB_REMOTE_INSTALL=local and DB_LOCAL_PASS values are required.

To use with remote installation, use DB_REMOTE_INSTALL=remote and configure DB_HOST, DB_PORT, DB_ADMIN, DB_REMOTE_PASS and DB_SECURE_CONNECTION values as needed.

It is recommended to generate the answer file automatically:

`engine-setup --gen-answer-file=`<answer file full path>

...and then update its parameters accordingly with the installation requirements. After that, proceed with installation using the answer file:

`engine-setup --answer-file=`<answer file full path>


