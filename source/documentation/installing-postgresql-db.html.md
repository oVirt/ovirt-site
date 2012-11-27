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

Please take into account that installing and starting a database is a system administration task, so all the commands suggested in this page are to be executed with the `root` user.

**Fedora**

    # yum install -y postgresql-server

**Debian**

    # apt-get install postgresql

Make sure you are using PostgreSQL 8.4.8 or later. Check your version with:

    # psql --version

Note: for earlier PostgreSQL versions, a patch is needed.

# Running the service

#### From PostgreSQL 9

Before starting the database for the first time you need to initialize it using the `postgresql-setup` command with the `initdb` option:

**Fedora**

    # postgresql-setup initdb

Once it is initialized you can start and stop it with the `systemctl` command. For example, to start it:

    # systemctl start postgresql.service

It is recommended to configure the service so that it is automatically started the next time the machine is rebooted:

    # systemctl enable postgresql.service

If the database needs to be recreated from scratch the way to do it is to stop the service, remove the data directory, run the `postgresql-setup` command again, and start the service:

    # systemctl stop postgresql.service
    # rm -rf /var/lib/pgsql/data
    # postgresql-setup initdb
    # systemctl start postgresql.service

**Debian**

The database is automatically initialized, started and configured to start during boot as part of the installation of the package, no need to perform any additional initialization.

To start, stop or restart it use the `/etc/init.d/postgresql` script:

    # /etc/init.d/postgresql start

#### For PostgreSQL 8 or earlier (not recommended)

Before starting the database for the first time you need to initialize it running the `initdb` command with the `postgres` user:

    # su - postgres -c 'initdb -U postgres -D /var/lib/pgsql/data/'

Once it is initialized you can start and stop it with the `service` command. For example, to start it run the following command:

    # service postgresql start

It is recommended to configure the service so that it is automatically started the next time the machine is rebooted:

    # chkconfig postgresql on

# Connecting to the database

Edit the `/var/lib/pgsql/data/pg_hba.conf` file and set authentication parameters as follows (for reference see [this](http://www.postgresql.org/docs/9.2/interactive/auth-pg-hba-conf.html)):

    local   all         all                               trust
    host    all         all         127.0.0.1/32          trust
    host    all         all         ::1/128               trust

After that run `systemctl restart postgresql.service` so that the new settings will take effect.

# Connecting from other hosts (optional)

If you want to be able to connect to PostgreSQL from other hosts (i.e. not from localhost only) you will need to change the `listen_addresses` parameter in the `/var/lib/pgsql/data/postgresql.conf` file:

    listen_addresses = '0.0.0.0'

And you will need also to allow access from external hosts in the `/var/lib/pgsql/data/pg_hba.conf` file:

    host    all         all         10.35.0.0/16          trust

The `10.35.0.0/16` network address and mask are just an example, make sure you replace it with what you want to give permissions to.

After all these changes restart the PostgreSQL service:

    # systemctl restart postgresql.service

# External Resources

*   If you upgraded/installed Fedora 16, then check this blog for more info: <http://asaf-shakarchi.blogspot.com/2011/11/fedora-15-16-postgresql-issues.html>

<Category:Documentation> <Category:Installation> <Category:Database> <Category:PostgreSQL>
