---
title: dbfacade-dao-and-transaction
authors: emesika, lhornyak
wiki_title: OVirt-DB-Issues/dbfacade-dao-and-transaction
wiki_revision_count: 30
wiki_last_updated: 2012-08-23
---

# dbfacade-dao-and-transaction

## What is the usage of DbFacadeLocator?

Create a datasource from the standalone.xml configuration
Create the DbFacade instance and configure it
Create a dialect
Create a jdbcTemplate and associate it with the DbFacade instance

## What is the usage of Db Facade?

Holds a map of all entity as a key and DAO implementation as a value.
Used mainly to get a DAO object to work with

## What is a dialect used for?

A dialect is used in order to handle in a generic way DB engine differences on multi DB engine applications
We had used that in the past to handle both MS SQL & Postgres
Example

       A table T with columns c1 and c2 where c1 is the primary key
       Suppose that we have a getT(c1) function that returns a record that matches the key
       In Postgres function parameters can not have the same name as table columns so we will have to choose another name for c1 parameter.
       we can achieve that by defining the function as get(v_c1) and implementing getParamNamePrefix in the PostgresDbEngineDialect to add the "v_" prefix.

We will see that a dialect is also used in the search engine to identify and prevent SQL Injection

## How do we do postgres catalog caching?

## Business Entities

### How to create a new BE ?

### How to Modify an existing BE ?

## DAO

### How to write a new DAO ?

### How to modify an existing DAO?

### How to write a new test class for my DAO?

### How to test my changes?

## Queries

### How to create a new query?

## Commands

### How to get data on command execution via DAOs ?

## Search Engine

### A brief overview

### What should I do if I have to change something?

[step-by-step Guide](http://wiki.ovirt.org/wiki/Development/Introducing_Entity_Search)

### SQL Injection prevention.

## Trouble Shooting

### Can not connect to the database.

Check that you postgresql service is up
If you are using remote database, check Postgres configuration for listening to remote connections
Check JBOSS standalone.xml and verify that user/database
 and all relevant settings are OK
Check the JBOSS server log for detailed error message. Check the postgres error log for detailed error message.

### JBoss is crashing on start giving a SQL Error

Check server log Check engine log Compensation & async tasks data Check schema version

### My database is deleted each time I run the tests.

Verify that your database engine name is not engine
When you run mvn with tests the fixtures.xml is used to create a engine database for each test, this will drop and create your engine database.
You can rename your default database in JBOSS standalone.xml configuration file.
