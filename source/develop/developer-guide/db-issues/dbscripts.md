---
title: dbscripts
authors: emesika
---

# Scripts

All scripts resides under the *dbscripts* directory
All scripts can get parameters for server, port, user and database
If those parameters are not given, defaults defined in *dbcustomfunctions.sh* *set_defaults* are used

## How to create a new database?

From root account perform:

      su - postgres -c "psql -d template1 -c "create database `<database_name>`  owner engine;""

## How to upgrade a database?

       upgrade.sh [-h] [-s SERVERNAME] [-p PORT] [-d DATABASE] [-u USERNAME] [-f VERSION] [-c] [-v]

## How to refresh my stored procedures & views?

       refreshStoredProcedures.sh [-h] [-s SERVERNAME] [-d DATABASE] [-u USERNAME] [-v]

## How to backup/restore my database ?

       backup.sh [-h] [-s SERVERNAME] [-p PORT] [-d DATABASE] [-l DIR] -u USERNAME [-v]
       restore.sh [-h] [-s SERVERNAME] [-p PORT] -u USERNAME -d DATABASE -f FILE [-r]

## Remote database support

In all scripts SERVERNAME and PORT are optional
If you are using a local DB then SERVERNAME defaults to *localhost* and PORT is defaulted to 5432
For remote access you should give the server name in SERVERNAME and verify that your remote database is listening on the default port (or give the PORT value in the command line)
