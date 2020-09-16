---
title: Engine database performance monitoring
authors: lspevak
---

# Engine database performance monitoring

## Introduction

An extensive or improper usage of database calls can cause an application performance bottleneck. The PostgreSQL database provides several tools, which can monitor or provide statistics for possible problems. Useful tools:

1.  pg_statements_stat module
2.  pg_top tool
3.  database debug logging

## pg_statements_stat module

The **pg_stat_statements** module provides basic statistics of all SQL statements executed by a server. First, before usage, it must be activated.

More information can be found here:

*   <http://www.postgresql.org/docs/9.1/static/pgstatstatements.html>

Increase maximum shared memory used by the kernel (Fedora 17). Current values can be displayed:

    # cat /proc/sys/kernel/shmmax
    # 33554432
    # cat /proc/sys/kernel/shmall
    # 2097152

Or increase memory temporarily:

    # sysctl -w kernel.shmmax=134217728

You can also increase the shared memory permanently by editing /etc/sysctl.conf file:

    kernel.shmmax=134217728
    kernel.shmall=2097152

Reload to activate the changes:

    # sysctl -p

Load pg_stat_module module to the database. Edit db configuration file:

*   /var/lib/pgsql/data/postgresql.conf

<!-- -->

    shared_preload_libraries = 'pg_stat_statements'
    custom_variable_classes = 'pg_stat_statements'
    pg_stat_statements.max = 10000
    pg_stat_statements.track = all

Restart the db service:

    # service postgresql restart
    # systemctl status postgresql

Activate pg_stat_module

    $ psql engine -U postgres -c "CREATE EXTENSION pg_stat_statements;"

Do not forget to deactivate the extention before the oVirt Engine db upgrade, else the upgrade is not possible:

    $ psql engine -U postgres -c "DROP EXTENSION pg_stat_statements;"

From now you can watch the queries statistics by running:

    $ psql engine -U postgres -c "select query, calls, rows from pg_stat_statements() order by calls desc;"

The statistics can be reset by the command:

    $ psql engine -U postgres -c "SELECT pg_stat_statements_reset();"

## pg_top tool

**pg_top** allows to monitor PostgreSQL processes. The usage is similar to Unix top command for monitoring of OS processes. Instalation on **Fedora**:

    # yum install pg_top

Project site:

*   <https://pg_top.gitlab.io/>

Usage:

    pg_top -U postgres -d engine -p 5432

Purpose:

1.  running SQL statement of a process
2.  query plan of a currently running SQL statement
3.  locks held by a process.
4.  user table statistics
5.  user index statistics

## Database debug logging

Edit PostgreSQL configuration file:

    # vi /var/lib/pgsql/data/postgresql.conf

Set the following values inside the file:

    log_line_prefix = '%t %c %u ' # time sessionid user
    log_statement = 'all'  # none, ddl, mod, all

Restart the service:

    # service postgresql restart

And watch the log files:

    # cd /var/lib/pgsql/data/pg_log
    # tail -f postgresql-Wed.log
