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

### Stored Procedures

### Helper functions
