---
title: HelperUtilities
authors: emesika
wiki_title: OVirt-DB-Issues/HelperUtilities
wiki_revision_count: 13
wiki_last_updated: 2014-10-29
---

# Helper Utilities

## fkvalidator

**fkvalidaor.sh** is a script that must be run on a customer database before an upgrade
The utility checks that all data inside the database is consistent and does not break any FK constraint
**fkvalidaor.sh** lists the found problems and can fix those problem is the **-f** switch is used

## Usage

Usage: fkvalidator.sh [-h] [-s SERVERNAME [-p PORT]] [-d DATABASE] [-u USERNAME] [-l LOGFILE] [-f] [-v]

             -s SERVERNAME - The database servername for the database  (def. localhost)
             -p PORT       - The database port for the database        (def. 5432)
             -d DATABASE   - The database name                         (def. engine)
             -u USERNAME   - The admin username for the database.
             -l LOGFILE    - The logfile for capturing output          (def. fkvalidator.sh.log)
             -f            - Fix the non consistent data by removing it from DB.
             -v            - Turn on verbosity                         (WARNING: lots of output)
             -h            - This help text.

## taskcleaner

## unlock_entity
