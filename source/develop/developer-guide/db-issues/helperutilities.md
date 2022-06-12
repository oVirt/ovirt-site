---
title: HelperUtilities
authors: emesika
---

# Helper Utilities

The directory ```/usr/share/ovirt-engine/setup/dbutils``` or on
developer setup ```$PREFIX/share/ovirt-engine/setup/dbutils``` contains
useful scripts to help with various database issues.

## fkvalidator

**fkvalidaor.sh** is a script that must be run on a customer database before an upgrade
The utility checks that all data inside the database is consistent and does not break any FK constraint
**fkvalidaor.sh** lists the found problems and can fix those problem is the **-f** switch is used

### Usage

Usage: fkvalidator.sh [-h] [-s SERVERNAME [-p PORT]] [-d DATABASE] [-u USERNAME] [-l LOGFILE] [-f] [-v]

       -s SERVERNAME - The database servername for the database  (def. localhost)
       -p PORT       - The database port for the database        (def. 5432)
       -d DATABASE   - The database name                         (def. engine)
       -u USERNAME   - The admin username for the database.
       -l LOGFILE    - The logfile for capturing output          (def. fkvalidator.sh.log)
       -f            - Fix the non consistent data by removing it from DB.
       -v            - Turn on verbosity                         (WARNING: lots of output)
       -h            - This help text.

## taskcleaner

**taskcleaner.sh** is a utility for clean async tasks and related Job Steps/Compensation data.
The utility enables to:
**Display**

       All async tasks
       Only Zombie tasks

**Delete**

       All tasks
       All Zombie tasks
       A task related to a given task id
       A Zombie task related to a given task id
       All tasks related to a given command id
       All Zombie tasks related to a given command id

Flags may be added (-C, -J) to specify if Job Steps & Compensation data should be cleaned as well.

### Usage

       Usage: taskcleaner.sh [-h] [-s server] [-p PORT]] [-d DATABASE] [-u USERNAME] [-l LOGFILE] [-t taskId] [-c commandId]
       [-z] [-R] [-C][-J] [-q] [-v]
       -s SERVERNAME - The database servername for the database (def.localhost)
       -p PORT - The database port for the database (def. 5432)
       -d DATABASE - The database name (def.engine)
       -u USERNAME - The admin username for the database.
       -l LOGFILE - The logfile for capturing output (def.taskcleaner.sh.log)
       -t TASK_ID - Removes a task by its Task ID.
       -c COMMAND_ID - Removes all tasks related to the given Command Id.
       -z - Removes/Displays a Zombie task.
       -R - Removes all Zombie tasks.
       -C - Clear related compensation entries.
       -J - Clear related Job Steps.
       -q - Quite mode, do not prompt for confirmation.
       -v - Turn on verbosity (WARNING: lots of output)
       -h - Help text.

## unlock_entity

**unlock_entity.sh** is a utility for unlocking **VM** , **Template** and/or their associated **Disks** or a specific **Disk**
**VM** , **Template** are given by their names while a specific disk is given by its **UUID**

### Usage

       Usage: ./unlock_entity.sh [options] [ENTITIES]
         -h            - This help text.
         -v            - Turn on verbosity                         (WARNING: lots of output)
         -l LOGFILE    - The logfile for capturing output          (def. )
         -s HOST       - The database servername for the database  (def. localhost)
         -p PORT       - The database port for the database        (def. 5432)
         -u USER       - The username for the database             (def. engine)
         -d DATABASE   - The database name                         (def. engine)
         -t TYPE       - The object type {vm | template | disk | snapshot}
         -r            - Recursive, unlocks all disks under the selected vm/template.
         -q            - Query db and display a list of the locked entites.
         ENTITIES      - The list of object names in case of vm/template, UUIDs in case of a disk
         NOTE: This utility access the database and should have the
               corresponding credentals.
               In case that a password is used to access the database PGPASSWORD
               or PGPASSFILE should be set.
         Example:
             $ PGPASSWORD=xxxxxx ./unlock_entity.sh -t disk -q
