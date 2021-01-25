---
title: oVirt-database-upgrade-procedure
authors: emesika, ovedo
---

<!-- TODO: Content review -->

# O Virt-database-upgrade-procedure

## Upgrade Procedure

In order to handle DB upgrades, we will maintain a fixed schema plus initial data and from that point on All schema & data changes will be done via upgrade scripts.

Each upgrade change should be in a separate file formatted by MM_mm_nnnn_[Name].sql where:

           MM  indicates Major Version number
           mm indicates Minor Version number
           nnnn are numbers starting from 0010, each having an offset of 10 from previous script(i.e 0010 0020 ....)
           [Name] is a short descriptive name for the script.(Please do not put your BZ # as part of the Name)

### Assumptions

      * The following assumes that there are no schema changes in Z-stream. Exception description will follow.
      * From now on , since upgrade run only new scripts, upgrade scripts do not need to be re-entrant.
      * This assumption requires that new upgrade scripts should be pushed into git with a higher version than the latest script.

### schema_version table

We now have a schema_version table that hold the db upgrade history and current version The upgrade script checks for the current version and run only new upgrade scripts. The current upgrade schema is updated on each upgrade run and available as one file named .schema

### Configuration changes

All changes to the configuration stored in the vdc_options table will be done using one script named
**config.sql** under **dbscripts/upgrade/pre_upgrade** directory.
**config.sql** script file is categorized to the following sections:

         Add Section
         Update section (w/o overriding current value)
         Delete section
         Simple upgrades not available using a fn_db* function call
         Complex upgrades using temporary functions

**Please note that the config.sql is now re-entrant.**

The pre_upgrade directory hosts hook scripts that are executed before the upgrade executes
Scripts in the pre_upgrade directory are executed lexicography.
 This change implies also that all upgrade scrips that modify vdc_options will be squashed to config_sql
Squashing is actually taking all the content of upgrade scripts that handle configuration and inserting it to config.sql in the same order
After doing so, the original upgrade scripts will be removed from the schema_version table leaving holes in the numbering (so we could have 0070 and after it 0100 for example).
This removal will be done using a regular upgrade script in order to execute it only once.

The pre_upgrade directory will be used only to resolve cases as we have already upstream where patch 0130 was installed (for 3.1) and after that 0250 was cherry picked, blocking the possibility of the upgrade procedure to install patches 0140 to 0240. In this case we will add a script to the pre_upgrade directory that will remove the 0250 entry from schema_version, since 0250 is a configuration patch we have no problems with it, but we should avoid such situation following this :

### Version Squashing

To avoid high number of upgrade script files we can squash each version files to a single file after it is published.
Since upgrade scripts contains both schema and data changes, this issue is open for suggestion and will be implemented in future.

### Temporary Functions in Upgrade scripts

Temporary functions in upgrade scripts should be renamed __temp_<name> This is in order to distinguish them from real persistent functions and preventing the chance to drop such a function by mistake in an upgrade script.

## Where are upgrade scripts located ?

All changes should be located under the upgrade/ directory

In which order upgrade scripts are called ? Upgrade scripts are sorted and executed alphabetically, that's why it is important to follow the upgrade script naming convention.

## When upgrade scripts are called ?

Clean Install In clean install this is done after initial (default) data is inserted to the database This makes sure that default data is inserted on initial schema before any upgrade script change it.

Upgrade In upgrade we first drop all SPs & Views and then run all upgrade scripts and finally restore views & SPs

## Which files should not be changed?

       create_tables.sql
       insert_data.sql
       insert_predefined_roles.sql
       fill_config.sql

## What should I do if I have to ?

       Add or change a column                      Add an upgrade script
       Add/Delete/Modify/Split configuration values     Modify config.sql script in pre_upgrade directory using common fn_db* functions
       Add/Delete/Modify any default data              Add an upgrade script
       Add/Delete/Modify a SP                      Change only the relevant *_sp.sql file
       Add/Delete/Modify a View                    Change only the relevant code in create_views.sql file

Please note that if you change configuration value it is safer to use fn_db_update_default_config_value rather than fn_db_update_config_value
onsider the following example:

       1) we have a comma delimited configuration value for key X "a,b,c"
        2) user u1 creates an upgrade script adding d using fn_db_update_config_value => value in db is "a,b,c,d"
        3) user u2 creates an upgrade script adding e using fn_db_update_config_value => value in db is "a,b,c,e" , "d" is lost.
      calling fn_db_update_default_config_value in 2) & 3) will result with 2) success and 3)fail

since 3) will look for "a,b,c" that was already updated by 2) to "a,b,c,d"
Then the writer of 3) (u2) will check the script failure and update it to include the correct value :

       select fn_db_update_default_config_value('X', 'a,b,c,d', 'a,b,c,d,e', '`<version>`');

## What are the helper functions I can use in my upgrade scripts?

       fn_db_add_column                  Adds a column to a table
       fn_db_change_column_type          Changes a column type,decimal precision etc. (Several formats)
       fn_db_add_config_value            Adds a new value to vdc_options
       fn_db_update_default_config_value     Updates the value of an option in vdc_options if given default was not   changed.You can also define if your condition is case-sensitive or not
       fn_db_delete_config_value             Deletes an option from vdc_options
       fn_db_split_config_value          Given general configuration entry, creates new entries for each old cluster version, with the old value, and a new entry for the newest cluster version with the input value
         

## Examples

       select fn_db_add_column('users', 'group_ids', 'VARCHAR(2048)');
       select fn_db_change_column_type('storage_pool','storage_pool_format_type','integer','varchar(50)');
       select fn_db_change_column_type('users','age','int2','int4 not null default 0');
       select fn_db_change_column_type('vm_statistics','cpu_user',18,0,'decimal(18,3)');-- change decimal scale.
       select fn_db_add_config_value('VdcVersion','3.0.0.0','general');
       select fn_db_update_config_value('DBEngine','Postgres','general');
       select fn_db_update_default_config_value('LDAPSecurityAuthentication','GSSAPI','default:GSSAPI','general',false);
       select fn_db_delete_config_value('ENMailEnableSsl','general');
       select fn_db_split_config_value('SpiceSecureChannels','all');
