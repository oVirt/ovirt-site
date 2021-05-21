---
title: dbupgrade
authors:
  - emesika
  - moolit
---

# Upgrade

We have here our home-made infrastructures based on concepts of an existing tool named [Flyway](http://flywaydb.org/), however, Flyway has it own limitations and is also bundled with a relatively big set of other dependant libraries that makes it hard to integrate & customise to our needs. In order to handle DB upgrades, we maintain a fixed schema plus initial data and from that point on All schema & data changes will be done via upgrade scripts.

Since upgrade run only new scripts, upgrade scripts do not need to be re-entrant. New upgrade scripts should be pushed into git with a higher version than the latest script.

      ovirt=# \d schema_version
                                          Table "public.schema_version"
         Column    |            Type             |                        Modifiers                         
      --------------+-----------------------------+----------------------------------------------------------
      id           | integer                     | not null default nextval('schema_version_seq'::regclass)
      version      | character varying(10)       | not null
      script       | character varying(255)      | not null
      checksum     | character varying(128)      | 
      installed_by | character varying(30)       | not null
      started_at   | timestamp without time zone | default now()
      ended_at     | timestamp without time zone | 
      state        | character varying(15)       | not null
      current      | boolean                     | not null
      comment      | text                        | default ''::text
      Indexes:
         "schema_version_primary_key" PRIMARY KEY, btree (id)

**NOTE : If you are testing upgrade, you must compile the origin and upgraded branch to the same PREFIX.**

In production, you should

       1. install ovirt-engine with remote database
       2. reinstall machine
       3. install ovirt-engine with database of (1)

or:

       1. install ovirt-engine
       2. execute engine-cleanup without cleaning up database
       3. install ovirt-engine reuse database

## What is my database version?

       select version,script,current from schema_version order by id desc limit 1;

## What are the upgrade script naming conventions?

Each upgrade change should be in a separate file formatted by MM_mm_nnnn_[Name].sql where:

           MM  indicates Major Version number
           mm indicates Minor Version number
           nnnn are numbers starting from 0010, each having an offset of 10 from previous script(i.e 0010 0020 ....)
           [Name] is a short descriptive name for the script.(Please do not put your BZ # as part of the Name)

Upgrade scripts are sorted and executed lexicography, that's why it is important to follow the upgrade script naming convention.

Temporary functions in upgrade scripts should be renamed __temp_<name> This is in order to distinguish them from real persistent functions and preventing the chance to drop such a function by mistake in an upgrade script.

## When upgrade scripts are called ?

*Clean Install*
In clean install this is done after initial (default) data is inserted to the database
This makes sure that default data is inserted on initial schema before any upgrade script change it.
 *Upgrade*
In upgrade we first drop all SPs & Views and then run all upgrade scripts and finally restore views & SPs

## What is done in the pre-upgrade step?

       configuration changes
       schema_version table changes
       special fixes

## What is done in the post-upgrade step?

       Modifications that are using views/stored procedures
       Example:
         Object column white list

## How does the upgrade script works

validates scripts for changes & version duplication
drops views & stored procedures
runs pre-upgrade scripts
checks for gaps
check for already installed scripts
run the upgrade script
updates schema_version
restore views & stored procedures
run post upgrade scripts
generate .schema file

## How do I upgrade db configuration?

All changes to the configuration stored in the vdc_options table will be done using one script named
**config.sql** under **dbscripts/upgrade/pre_upgrade** directory.
**config.sql** script file is categorized to the following sections:

         Add Section
         Update section (w/o overriding current value)
         Delete section
         Simple upgrades not available using a fn_db* function call
         Complex upgrades using temporary functions

**Please note that the config.sql is re-entrant.**

## How do I upgrade db schema?

When the DB schema is changed (using DDL), the change must be introduced via an upgrade script. That means that the create_tables.sql is stable and all modifications are done using upgrade scripts.

## How do I upgrade db data?

When the DB data is changed (using DML), the change must be introduced via an upgrade script.

## How do I cherry-pick a commit from upstream to?

Assume upstream installed patches 0010 0020 0030 0040 0050 0060 and z-stream installed 0010 and 0020 when 0030 0040 0050 belongs to f1 feature and 0060 belongs to f2 feature Now , we would like to merge f2 changes to Z-stream There can be two cases here :

      In case that f2 depends on f1 , we will have to insert both f1 & f2 patches (0030 - 0060)
      In case that f2 is independent , we will add 0060 as 0021 in Z-stream

When we will add f1 to Z-stream it will run without any problem since it version is bigger than the last installed version.

When we will add the real f2 to Z-stream , the upgrade will compare its checksum with existing scripts and it will be skipped (and will be marked as SKIPPED in the schema_version table)

This assumes of course that f2 script were not changed from the time it was cherry-picked to the time the real script is taken.

## How to prevent script collisions?

Upgrade scripts have the MM_mm_nnnn prefix, this uniquely defines the upgrade script
The *upgrade.sh* script check for such duplications and fails with a detailed error pointing on the duplicate version if found.
In addition we have a *pom.xml* under *dbscripts* that uses the *Maven Exec Plugin* to run a script that checks for duplications each time the engine is compiled
In short , please follow
 verify that your upgrade script is running OK

         compile 
         In case that you messed up, `*`Jenkins`*` will find the duplicate script and will send you a nice note.

## What helper functions can I use in upgrade scripts

       fn_db_add_column                  Adds a column to a table
       fn_db_change_column_type          Changes a column type,decimal precision etc. (Several formats)
       fn_db_add_config_value            Adds a new value to vdc_options
       fn_db_update_default_config_value     Updates the value of an option in vdc_options if given default was not   changed.You can also define if your condition is case-sensitive or not
       fn_db_delete_config_value     Deletes an option from vdc_options
       fn_db_split_config_value          Given general configuration entry, creates new entries for each old cluster version, with the old value, 
       and a new entry for the newest cluster version with the input  value
       fn_db_create_constraint             Creates a constraint
       fn_db_drop_constraint                Drops a constraint

Examples:

       select fn_db_add_column('users', 'group_ids', 'VARCHAR(2048)');
       select fn_db_change_column_type('storage_pool','storage_pool_format_type','integer','varchar(50)');
       select fn_db_change_column_type('users','age','int2','int4 not null default 0');
       select fn_db_change_column_type('vm_statistics','cpu_user',18,0,'decimal(18,3)');-- change decimal scale.
       select fn_db_add_config_value('VdcVersion','3.0.0.0','general');
       select fn_db_update_config_value('DBEngine','Postgres','general');
       select fn_db_update_default_config_value('LDAPSecurityAuthentication','GSSAPI','default:GSSAPI','general',false);
       select fn_db_delete_config_value('ENMailEnableSsl','general');
       select fn_db_split_config_value('SpiceSecureChannels','all');
      select fn_db_create_constraint('vds_static', 'vds_static_vds_name_unique', 'UNIQUE(vds_name)');
      select fn_db_drop_constraint ( 'vds_static_vds_name_unique');

## What should I do if I have to ?

       Add or change a column                      Add an upgrade script
       Add/Delete/Modify/Split configuration values     Modify config.sql script in pre_upgrade directory using common fn_db* functions
       Add/Delete/Modify any default data              Add an upgrade script
       Add/Delete/Modify a SP                      Change only the relevant *_sp.sql file
       Add/Delete/Modify a View                    Change only the relevant code in create_views.sql file

## I need to run a shell script as an upgrade step, is this possible?

Yes, just:

`write `<MM_mm_nnnn_your_script.sh>
      keep in mind that script follows same naming conventions and numbering as SQL upgrade script.
`chmod +x `<MM_mm_nnnn_your_script.sh>

The ability to run shell scripts cover also the content of the pre/post upgrade directories.
