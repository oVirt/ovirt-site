---
title: Postgres
authors: emesika
wiki_title: OVirt-DB-Issues/Postgres
wiki_revision_count: 31
wiki_last_updated: 2012-08-09
---

# Postgres

## Installation

We are using version 9.1.x
[Installation Guide](http://www.ovirt.org/wiki/Installing_PostgreSQL_DB)

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

### postgresql.conf

`  `[`defaults`](http://www.postgresql.org/docs/current/static/view-pg-settings.html)
`   `[`reset`](http://www.postgresql.org/docs/current/static/sql-reset.html)
      === reload configuration ===

If you are making modifications to the Postgres configuration file postgresql.conf (or similar), and you want to new settings to take effect without needing to restart the entire database, there are two ways to accomplish this.

option 1
 su - postgres /usr/bin/pg_ctl reload option 2
 echo "SELECT pg_reload_conf();" | psql -U <user> <database>

### SIGHUP

       pg_ctl reload

[Connection parameters](http://www.postgresql.org/docs/current/static/runtime-config-connection.html)
=== Remote access (listen_addresses) ===

` `[`pg_hba.conf`](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html)

### max_connections

The maximum number of client connections allowed. This is very important to some of the below parameters (particularly work_mem) because there are some memory resources that are or can be allocated on a per-client basis, so the maximum number of clients suggests the maximum possible memory use. Generally, PostgreSQL on good hardware can support a few hundred connections. If you want to have thousands instead, you should consider using connection pooling software to reduce the connection overhead.

### shared_buffers

The shared_buffers configuration parameter determines how much memory is dedicated to PostgreSQL use for caching data. One reason the defaults are low because on some platforms (like older Solaris versions and SGI) having large values requires invasive action like recompiling the kernel. Even on a modern Linux system, the stock kernel will likely not allow setting shared_buffers to over 32MB without adjusting kernel settings first.

If you have a system with 1GB or more of RAM, a reasonable starting value for shared_buffers is 1/4 of the memory in your system. If you have less ram you'll have to account more carefully for how much RAM the OS is taking up, closer to 15% is more typical there. There are some workloads where even larger settings for shared_buffers are effective, but given the way PostgreSQL also relies on the operating system cache it's unlikely you'll find using more than 40% of RAM to work better than a smaller amount.

### work_mem

### effective_cache_size

### synchronous_commit

### Guidlines dedicated / shared

### pgtune
