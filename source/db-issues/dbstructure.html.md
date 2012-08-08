---
title: dbstructure
authors: emesika
wiki_title: OVirt-DB-Issues/dbstructure
wiki_revision_count: 47
wiki_last_updated: 2012-12-05
---

# dbstructure

## Database structure and dependencies

![](DB.png "DB.png")

## Jboss

### Where do I define my db connection?

in JBoss 7.x the database configuration is defined in $BOSS_HOME/standalone/configuration/standalone.xml

`             `<datasources>
`               `<datasource jndi-name="java:/ENGINEDataSource" pool-name="ENGINEDataSource" enabled="true">
`                   `<connection-url>`jdbc:postgresql://localhost:5432/ovirt`</connection-url>
`                   `<driver>`postgresql`</driver>
`                   `<transaction-isolation>`TRANSACTION_READ_COMMITTED`</transaction-isolation>
`                   `<pool>
`                       `<min-pool-size>`1`</min-pool-size>
`                       `<max-pool-size>`100`</max-pool-size>
`                       `<prefill>`true`</prefill>
`                   `</pool>
`                   `<security>
`                       `<user-name>`postgres`</user-name>
`                   `</security>
`                   `<statement>
`                       `<prepared-statement-cache-size>`100`</prepared-statement-cache-size>
`                   `</statement>
`               `</datasource>
`               `<drivers>
`                   `<driver name="postgresql" module="org.postgresql">
`                       `<xa-datasource-class>`org.postgresql.xa.PGXADataSource`</xa-datasource-class>
`                   `</driver>
`               `</drivers>
`           `</datasources>

## Database objects

All database objects are defined under the *dbscripts* directory

### Tables

All table definitions are defined in *create_tables.sql* script
This includes only the baseline of the database while each addition to this structure is done via an upgrade script.

### Constrains

The *create_tables.sql* script includes also constrains definitions of 3 types

       Foreign keys
       Default value for a column
       Value validation

### Indexes

Generally, *postgres* implies an index on the table PK
Apart of that this file has also some secondary index definitions to boost related queries
Since our application is mostly for *read* operations, adding an index does not affect the application performance

### Views

All table definitions are defined in *create_views.sql* script
Any modification to a view is done directly on this file.

### Stored Procedures

All application store procedure definitions are defined in files that match the \*_sp.sql pattern
Any modification to a those files is done directly in the relevant file.

### Helper functions

Helper functions are defined in *common_sp.sql* script and have the *fn_db_* prefix
Those functions are mostly used in upgrade scripts (explained later on)
Application general functions are defined in *create_functions.sql*
Script helper functions are defined in *dbfunctions.sh* and *dbcustomfunctions.sh*

Some of those stored procedure implement horizonal/vertical filter according to the user that is accessing the database.
Example:

       Create or replace FUNCTION GetVdsByVdsId(v_vds_id UUID, v_user_id UUID, v_is_filtered BOOLEAN) RETURNS SETOF vds
        AS $procedure$
        DECLARE
        v_columns text[];
        BEGIN
         BEGIN
           if (v_is_filtered) then
               RETURN QUERY SELECT DISTINCT (rec).*
               FROM fn_db_mask_object('vds') as q (rec vds)
               WHERE (rec).vds_id = v_vds_id
               AND EXISTS (SELECT 1
                   FROM   user_vds_permissions_view
                   WHERE  user_id = v_user_id AND entity_id = v_vds_id);
           else
               RETURN QUERY SELECT DISTINCT vds.*
               FROM vds
               WHERE vds_id = v_vds_id;
           end if;
         END;
        RETURN;
       END; $procedure$

## Scripts

All scripts resides under the *dbscripts* directory
All scripts can get parameters for server, port, user and database
If those parameters are not given, defaults defined in *dbcustomfunctions.sh* *set_defaults* are used

### How to create a new database?

       create_db.sh [-h] [-s SERVERNAME [-p PORT]] [-d DATABASE] [-u USERNAME] [-f UUID] [-l LOGFILE] [-v]

### How to create a new database for developers?

       create_db_devel.sh [-h] [-s SERVERNAME [-p PORT]] [-d DATABASE] [-u USERNAME] [-f UUID] [-l LOGFILE] [-v]

### How to upgrade a database?

       upgrade.sh [-h] [-s SERVERNAME] [-p PORT] [-d DATABASE] [-u USERNAME] [-f VERSION] [-c] [-v]

### How to refresh my stored procedures & views?

       refreshStoredProcedures.sh [-h] [-s SERVERNAME] [-d DATABASE] [-u USERNAME] [-v]

### How to backup/restore my database ?

       backup.sh [-h] [-s SERVERNAME] [-p PORT] [-d DATABASE] [-l DIR] -u USERNAME [-v]
       restore.sh [-h] [-s SERVERNAME] [-p PORT] -u USERNAME -d DATABASE -f FILE [-r]

### Remote database support

In all scripts SERVERNAME and PORT are optional
If you are using a local DB then SERVERNAME defaults to *localhost* and PORT is defaulted to 5432
For remote access you should give the server name in SERVERNAME and verify that your remote database is listening on the default port (or give the PORT value in the command line)

## Upgrade

We have here our home-made infrastructures based on concepts of an existing tool named [Flyway](http://code.google.com/p/flyway/), however, Flyway has it own limitations and is also bundled with a relatively big set of other dependant libraries that makes it hard to integrate & customise to our needs. In order to handle DB upgrades, we maintain a fixed schema plus initial data and from that point on All schema & data changes will be done via upgrade scripts.

Since upgrade run only new scripts, upgrade scripts do not need to be re-entrant. New upgrade scripts should be pushed into git with a higher version than the latest script.

      ovirt=# \d schema_version
                                          Table "public.schema_version"
         Column    |            Type             |                        Modifiers                         
      --------------+-----------------------------+----------------------------------------------------------
      id           | integer                     | not null default nextval('schema_version_seq'::regclass)
      version      | character varying(10)       | not null
      script       | character varying(255)      | not null
      checksum     | character varying(128)      | 
      installed_by | character varying(30)       | not null
      started_at   | timestamp without time zone | default now()
      ended_at     | timestamp without time zone | 
      state        | character varying(15)       | not null
      current      | boolean                     | not null
      comment      | text                        | default ''::text
      Indexes:
         "schema_version_primary_key" PRIMARY KEY, btree (id)

### What is my database version?

       select version,script,current from schema_version order by id desc limit 1;

### What are the upgrade script naming conventions?

Each upgrade change should be in a separate file formatted by MM_mm_nnnn_[Name].sql where:

           MM  indicates Major Version number
           mm indicates Minor Version number
           nnnn are numbers starting from 0010, each having an offset of 10 from previous script(i.e 0010 0020 ....)
           [Name] is a short descriptive name for the script.(Please do not put your BZ # as part of the Name)

### What is done in the pre-upgrade step?

       configuration changes
       schema_version table changes
       special fixes

### What is done in the post-upgrade step?

       Modifications that are using views/stored procedures
       Example:
         Object column white list

### how does the upgrade script works

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

### How do I upgrade db configuration?

All changes to the configuration stored in the vdc_options table will be done using one script named
**config.sql** under **dbscripts/upgrade/pre_upgrade** directory.
**config.sql** script file is categorized to the following sections:

         Add Section
         Update section (w/o overriding current value)
         Delete section
         Simple upgrades not available using a fn_db* function call
         Complex upgrades using temporary functions

**Please note that the config.sql is re-entrant.**

### How do I upgrade db schema?

When the DB schema is changed (using DDL), the change must be introduced via an upgrade script. That means that the create_tables.sql is stable and all modifications are done using upgrade scripts.

### How do I upgrade db data?

When the DB data is changed (using DML), the change must be introduced via an upgrade script.

### How do I cherry-pick a commit from upstream to z-stream?

### How to prevent script collisions?

Upgrade scripts have the MM_mm_nnnn prefix, this uniquely defines the upgrade script
The *upgrade.sh* script check for such duplications and fails with a detailed error pointing on the duplicate version if found.
In addition we have a *pom/xml* under *dbscripts* that uses the *Maven Exec Plugin* to run a script that checks for duplications each time the engine is compiled
In short , please follow
 verify that your upgrade script is running OK

      compile 
      In case that you messed up, `*`Jenkins`*` will find the duplicate script and will send you a nice note.

### What helper functions can I use in upgrade scripts

       fn_db_add_column                  Adds a column to a table
       fn_db_change_column_type          Changes a column type,decimal precision etc. (Several formats)
       fn_db_add_config_value            Adds a new value to vdc_options
       fn_db_update_default_config_value     Updates the value of an option in vdc_options if given default was not   changed.You can also define if your condition is case-sensitive or not
       fn_db_delete_config_value             Deletes an option from vdc_options
       fn_db_split_config_value          Given general configuration entry, creates new entries for each old cluster version, with the old value, and a new entry for the newest cluster version with the input value

Examples:

       select fn_db_add_column('users', 'group_ids', 'VARCHAR(2048)');
       select fn_db_change_column_type('storage_pool','storage_pool_format_type','integer','varchar(50)');
       select fn_db_change_column_type('users','age','int2','int4 not null default 0');
       select fn_db_change_column_type('vm_statistics','cpu_user',18,0,'decimal(18,3)');-- change decimal scale.
       select fn_db_add_config_value('VdcVersion','3.0.0.0','general');
       select fn_db_update_config_value('DBEngine','Postgres','general');
       select fn_db_update_default_config_value('LDAPSecurityAuthentication','GSSAPI','default:GSSAPI','general',false);
       select fn_db_delete_config_value('ENMailEnableSsl','general');
       select fn_db_split_config_value('SpiceSecureChannels','all');

### I need to run a shell script as an upgrade step, is this possible?

Yes, just:

`write `<MM_mm_nnnn_your_script.sh>
      keep in mind that script follows sane naming conventions and numbering as SQL upgrade script.
`chmod +x `<MM_mm_nnnn_your_script.sh>

The ability to run shell scripts cover also the content of the pre/post upgrade directories.
