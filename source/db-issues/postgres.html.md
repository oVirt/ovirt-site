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
=== Remote access (listen_addresses) === [pg_hba.conf](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html)
=== max_connections ===

### shared_buffers

### work_mem

### effective_cache_size

### synchronous_commit

### Guidlines dedicated / shared

### pgtune
