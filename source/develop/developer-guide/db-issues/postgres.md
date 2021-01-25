---
title: Postgres
authors: emesika
---

# Postgres

This page is obsolete.

## Installation

We are using version 9.1.x

## Authentication

Trust
Password
GSSAPI
SSPI
Kerberos
Ident
Peer
LDAP
RADIUS
Certificate
PAM
 details:
[Authentication Methods](http://www.postgresql.org/docs/9.1/static/auth-methods.html)

## Creating a new user

[Create Role](http://www.postgresql.org/docs/9.1/static/sql-createrole.html)
[Create User](http://www.postgresql.org/docs/9.0/static/sql-createuser.html)
[The password file](http://www.postgresql.org/docs/9.0/static/libpq-pgpass.html)

## Configuration

Default postgres configuration files are under */var/lib/pgsql/data*

### postgresql.conf

`  `[`defaults`](http://www.postgresql.org/docs/current/static/view-pg-settings.html)
`   `[`reset`](http://www.postgresql.org/docs/current/static/sql-reset.html)
      === reload configuration ===

If you are making modifications to the Postgres configuration file postgresql.conf (or similar), and you want to new settings to take effect without needing to restart the entire database, there are two ways to accomplish this.

option 1
 su - postgres /usr/bin/pg_ctl reload option 2
 echo "SELECT pg_reload_conf();" | psql -U <user> <database>

### Connection

[Connection parameters](http://www.postgresql.org/docs/current/static/runtime-config-connection.html)

### Remote access (listen_addresses)

` `[`pg_hba.conf`](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html)

### max_connections

The maximum number of client connections allowed. This is very important to some of the below parameters (particularly work_mem) because there are some memory resources that are or can be allocated on a per-client basis, so the maximum number of clients suggests the maximum possible memory use. Generally, PostgreSQL on good hardware can support a few hundred connections. If you want to have thousands instead, you should consider using connection pooling software to reduce the connection overhead.

### shared_buffers

The shared_buffers configuration parameter determines how much memory is dedicated to PostgreSQL use for caching data. One reason the defaults are low because on some platforms (like older Solaris versions and SGI) having large values requires invasive action like recompiling the kernel. Even on a modern Linux system, the stock kernel will likely not allow setting shared_buffers to over 32MB without adjusting kernel settings first.

If you have a system with 1GB or more of RAM, a reasonable starting value for shared_buffers is 1/4 of the memory in your system. If you have less ram you'll have to account more carefully for how much RAM the OS is taking up, closer to 15% is more typical there. There are some workloads where even larger settings for shared_buffers are effective, but given the way PostgreSQL also relies on the operating system cache it's unlikely you'll find using more than 40% of RAM to work better than a smaller amount.

### work_mem

Specifies the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. The value defaults to one megabyte (1MB). Note that for a complex query, several sort or hash operations might be running in parallel; each operation will be allowed to use as much memory as this value specifies before it starts to write data into temporary files. Also, several running sessions could be doing such operations concurrently. Therefore, the total memory used could be many times the value of work_mem; it is necessary to keep this fact in mind when choosing the value. Sort operations are used for ORDER BY, DISTINCT, and merge joins. Hash tables are used in hash joins, hash-based aggregation, and hash-based processing of IN subqueries.

### maintenance_work_mem

Specifies the maximum amount of memory to be used by maintenance operations, such as VACUUM, CREATE INDEX, and ALTER TABLE ADD FOREIGN KEY. It defaults to 16 megabytes (16MB). Since only one of these operations can be executed at a time by a database session, and an installation normally doesn't have many of them running concurrently, it's safe to set this value significantly larger than work_mem. Larger settings might improve performance for vacuuming and for restoring database dumps.

### synchronous_commit

Asynchronous commit is an option that allows transactions to complete more quickly, at the cost that the most recent transactions may be lost if the database should crash. In many applications this is an acceptable trade-off.

Asynchronous commit introduces the risk of data loss. There is a short time window between the report of transaction completion to the client and the time that the transaction is truly committed (that is, it is guaranteed not to be lost if the server crashes).

The risk that is taken by using asynchronous commit is of data loss, not data corruption. If the database should crash, it will recover by replaying WAL up to the last record that was flushed. The database will therefore be restored to a self-consistent state, but any transactions that were not yet flushed to disk will not be reflected in that state. The net effect is therefore loss of the last few transactions.

The user can select the commit mode of each transaction, so that it is possible to have both synchronous and asynchronous commit transactions running concurrently. This allows flexible trade-offs between performance and certainty of transaction durability.

### Guidlines for Dedicated/Shared server

For the following , a good understanding of the database clock lifecycle is needed.

      page request --> changes --> dirty --> commit to WAL --> Statistics (pg_stat_user_tables etc.) (*) --> Write to disk & clean dirty flag (*)
      (*) - async

Dedicated

        logging can be more verbose
        shared_buffers - 25% of RAM
        work_mem should be `<OS cache size>` / (max_connections * 2)
        maintenance_work_mem - 50MB per each 1GB of RAM
        checkpoint_segments - at least 10 [1]
        checkpoint_timeout
        wal_buffers - 16MB  [2]
        
`  [1] `[`http://www.postgresql.org/docs/9.1/static/pgbuffercache.html` `pg_buffercache`](http://www.postgresql.org/docs/9.1/static/pgbuffercache.html pg_buffercache)
        [2] `[`http://www.postgresql.org/docs/9.1/static/wal-configuration.html` `WAL` `Configuration`](http://www.postgresql.org/docs/9.1/static/wal-configuration.html WAL Configuration)`   

Shared

        reduce logging 
        shared_buffers - 10% of RAM
        be very stingy about increasing work_mem 
        all other recomendations from the Dedicated section may apply

### pgtune

pgtune takes the default postgresql.conf and expands the database server to be as powerful as the hardware it's being deployed on.

[How to tune your database](http://sourcefreedom.com/tuning-postgresql-9-0-with-pgtune/)

## VACCUM

Cleans up after old transactions, including removing information that is no longer visible and reuse free space.
 ANALYSE looks at tables in the database and collects statistics about them like number of distinct values etc.
Many aspects of query planning depends on this statistics data being accurate.
 From 8.1 , there is a autovaccum daemon that runs in the background and do this work automatically.

## Logging

General logging is important especially if you have unexpected behaviour and you want to find the reason for that
The default logging level is only Errors but this can be easily changed.

### log_line_prefix

Controls the line prefix of each log message.

       %t timestamp
       %u user
       %r remote host connection
       %d database connection
       %p pid of connection

### log_statement

Controls which statements are logged

       none
       ddl
       mod
       all

### log_min_duration_statement

Controls how long should a query being executed to be logged
Very usefull to find most expensive queries
