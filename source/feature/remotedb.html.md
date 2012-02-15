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

The details are still being worked out.

### Comments and Discussion

Currently there are two questions we need to get answer to:

      1. What if potential customer asks us to create certificate for her DB?
      2. What kind of permissions we can receive on remote DB?

The current recommended design items are:

      1. User provided by remote DB must have "CREATE" privileges on the server, so it create 'engine' and other DBs; and enough permissions to check active connections to our DBs.
      2. During operations that require "DROP/ALTER" privileges the setup will check first if there are active connections to the DB.If there are, the operation will stop and warn the user.
      3. If there are no users connected to the DB, the DB name will be altered to a different one to avoid new connections. After the completion of operations (upgrade, rollback, etc), the DB will be renamed back.

### FAQ:

      Q. Can DB admin close active connections?
      A. No, this requires superuser privileges.

      Q. Can DB admin rename the DB?
      A. Only if DB admin is the DB owner.

      Q. Can DB be renamed when there are active connections to the DB?
      A. No (still being verified).

<Category:Feature>
