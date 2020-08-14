---
title: dbstructure
authors: emesika
---

# dbstructure

## ERD

[oVirt 3.1 ERD](/images/wiki/rhevm-3-1.png)

## Database structure and dependencies

![](/images/wiki/DB.png)

## Jboss

### Where do I define my db connection?

in JBoss 7.x the database configuration is defined in $JBOSS_HOME/standalone/configuration/standalone.xml

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

       Primary keys
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
