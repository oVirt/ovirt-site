---
title: Installing PostgreSQL DB
category: documentation
authors: aglitke, alonbl, apevec, asaf, dougsland, jhernand, jumper45, lpeer, moti,
  msalem, quaid, ranglust
wiki_category: Documentation
wiki_title: Installing PostgreSQL DB
wiki_revision_count: 30
wiki_last_updated: 2013-12-19
---

# Installing

On your Fedora machine run the following commands:

      #> su -
      $> yum install -y postgresql-server postgresql-contrib pgadmin3

Make sure you are using PostgreSQL 8.4.8 or later.

Check your version with

      >psql --version

Note: for earlier PostgreSQL versions, a patch is needed.

# Running the service

      pg_ctl initdb # (first time only)
      service postgresql start

It is recommended to add this service to auto start by

      chkconfig postgresql on

# Connecting to the database

You should set security definitions in hba_conf file as described at
 <http://www.postgresql.org/docs/8.2/interactive/auth-pg-hba-conf.html>

Edit /var/lib/pgsql/data/pg_hba.conf' ''and set authentication parameters as follows: ''

      local   all         all                               trust
      host    all         all         127.0.0.1/32          trust
      host    all         all         ::1/128               trust

Run /etc/init.d/postgresql restart

# Setup PostgreSQL UUID support

PostgreSQL 8.4 does not install uuid generation functions by default.
In order to use those functions, you will have to install it manually:

      > psql -d engine -U postgres -f /usr/share/pgsql/contrib/uuid-ossp.sql

      on F16 / postgresql 9.1:
      > psql -U postgres -d engine -c 'create extension "uuid-ossp"' -1

The package installation distributes a library named uuid-ossp.so

      (on Fedora 14 64 bit its in /usr/lib64/pgsql/uuid-ossp.so)

The added functions are documented at
<http://www.postgresql.org/docs/8.3/static/uuid-ossp.html>

You can run those function from pgsql , for example:
 > select uuid_generate_v1();

# Connecting from other hosts

If you want to be able to connect to PostgreSQL from other hosts (i.e. not from localhost only) do the following:

      sudo vim /var/lib/pgsql/data/postgresql.conf
      listen_addresses = '0.0.0.0'

      sudo vim /var/lib/pgsql/data/pg_hba.conf
      add this line:
      host    all         all         10.35.0.0/16          trust

      restart postgres service
