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
