---
title: RemoteDB
category: feature
authors: alourie
wiki_category: Feature
wiki_title: Features/RemoteDB
wiki_revision_count: 6
wiki_last_updated: 2012-05-08
---

# Remote DB

### Summary

Remote DB feature means working with a Postgres instance on a remote host.

### Owner

*   Name: [ Alex Lourie](User:Alourie)
*   Email: <alourie@redhat.com>

### Current status

The code was developed and is waiting for code review.

### Design and flow

The flow of installation is as follows:

#### Setup

*   During the engine-setup operation, user is asked to enter DB hostname or an IP. Default value 'localhost' is offered.

      * If entered 'localhost' or '127.0.0.1', the installation will continue with default flow present today.
      * If entered a hostname or IP of the remote host, the additional set of questions will be presented.
        * Additional questions include: DB Admin username, DB Port and "Security usage" parameters.

*   Installation proceeds with normal flow.
*   During the normal flow, additional parameters (if entered by user) are used during DB creation and JBoss configuration.

DB configuration parameters are stored in **~/.pgpass file**, including remote host, port and username/password. JBoss configuration is stored in **/usr/share/jboss-as/standalone/configuration/standalone.xml** file.

*   If setup is rerun, the same parameter are used in "upgradeDb" function. Also, see next section for the upgrade logic.

#### Upgrade

*   During the upgrade, the DB connection values are received from ~/.pgpass file and used for connection.
*   The upgrade works as follows:

      * First, the packages are upgraded is necessary.
      * Before performing the DB upgrade, a backup is taken.
`* After the backup, the default DB (engine) is renamed to engine-`<date>
       * If renaming fails, yum rollback is performed, and user is notified about possible active connections.
       * If renaming succeeds, DB upgrade is started.
      * If upgrade fails, the renamed DB is removed and yum rollback is performed.
      * If upgrade succeeds, the engine-`<date>` is renamed back to 'engine'.

#### Cleanup

*   During the upgrade, the DB connection values are received from ~/.pgpass file and used for connection.
*   If DB drop fails user is notified about possible active connections.

### Comments and Discussion

Currently there are two questions we need to get answer to:

      1. What if potential customer asks us to create certificate for the DB?
      2. What kind of permissions we can receive on remote DB?

### FAQ:

      Q. Can DB admin close active connections?
      A. No, this requires superuser privileges.

      Q. Can DB admin rename the DB?
      A. Only if DB admin is the DB owner.

<Category:Feature>
