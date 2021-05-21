---
title: Backup engine db
authors:
  - dougsland
  - herrold
---

<!-- TODO: Content review -->

# Backup engine db

## Backup manually

Stop jboss-as service

      # /bin/systemctl stop jboss-as.service

Backup the engine db

      # pg_dump -C -E UTF8 --column-inserts --disable-dollar-quoting --disable-triggers -U postgres --format=p -f "/path/dump.sql" engine

Start jboss-as service

      # /bin/systemctl start jboss-as.service

## Restore manually

Stop jboss-as service

      # /bin/systemctl stop jboss-as.service

Drop any existing engine db:

      # dropdb -U postgres engine

Create an engine db:

      # createdb -U postgres engine

Restore the backup file:

      # psql -U postgres -d engine -w < "/path/dump.sql"

Start jboss-as service

      # /bin/systemctl start jboss-as.service

## Others

### engine-db-tool.py

engine-db-tool helps to backup/restore engine database
Download: <https://raw.github.com/dougsland/misc-rhev/master/engine-db-tool.py> The preceding link is stale as of October 2013; see instead: <https://github.com/dougsland/misc-rhev> and link: <https://github.com/dougsland/misc-rhev/raw/master/engine-db-tool.py>

Example of usage:

      # mkdir /engine-db-backup
      # chmod +x engine-db-tool.py
      # ./engine-db-tool.py

#### backup manually

      # ./engine-db-tool.py --backup --path=/engine-db-backup
      Stopping jboss-as service...
      Backuping database: /engine-db-backup/dump_ENGINEDB_BACKUP_2012-04-03-15:05.sql
      Starting jboss-as service...
      Done

#### restore manually

      # ./engine-db-tool.py --restore --path=/engine-db-backup/dump_ENGINEDB_BACKUP_2012-04-03-15:05.sql
      Stopping jboss-as service...
      Restoring database: /engine-db-backup/dump_ENGINEDB_BACKUP_2012-04-03-15:05.sql
      Starting jboss-as service...
      Done

#### Crontab example

      # crontab -e  (adding to my crontab user)

      # Every day 18:00 backup db
      00 18 * * * /path-to/engine-db-tool.py --backup --path=/engine-backup-db
