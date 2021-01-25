---
title: dbfacade-dao-and-transaction
authors: emesika, lhornyak
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

       A table T with columns c1 and c2 where c1 is the primary key
       Suppose that we have a getT(c1) function that returns a record that matches the key
       In Postgres function parameters can not have the same name as table columns so we will have to choose another name for c1 parameter.
       we can achieve that by defining the function as get(v_c1) and implementing getParamNamePrefix in the PostgresDbEngineDialect to add the "v_" prefix.

We will see that a dialect is also used in the search engine to identify and prevent SQL Injection

## How do we cache postgres catalog objects?

We had found that Postgres uses heavily its PG CATALOG objects and this affected performance in mid to large systems
Solution was to cache those calls and use the cache when possible
This is done by the SimpleJdbcCallsHandler

## Business Entities

### How to create a new BE ?

Create BE tables as an upgrade script
Create BE views in original create_views.sql file
Create BE CRUD Stored Procedures file
Create BE Class
Create DAO interface and implementation for the BE , inherit GenericDAO, ReadDAO or ModificationDAO
ADD DAO to DB Facade
Create tests for all DAO implementation calls, inherit BaseGenericDaoTestCase/BaseReadDaoTestCase/BaseDaoTestCase
Create test data for your BE in fixtures.xml file
ADD DAO to engine-daos.properties
ADD any Query and Query Parameter objects needed for accessing the BE data from clients and add them to VdcQueryType
Run the upgrade script
Run the BE tests and verify that your BE is working as expected

### How to Modify an existing BE ?

Most of BE modifications are adding a field to a BE (removing is very similar)
Create BE tables changes as an upgrade script
Modify BE views in original create_views.sql file to reflect the changes
Modify BE CRUD Stored Procedures file to reflect the changes
Modify the BE Class to reflect the changes
Modify DAO interface and implementation for the BE
Modify tests for all relevant DAO implementation calls
Modify test data for your BE in fixtures.xml file
Modify any Query objects/parameters needed for accessing the BE data from clients
Run the upgrade script
Run the BE tests and verify that your BE is working as expected

## Queries

### How to create a new query?

Add the function/SP in database that returns the requested data
Test your function/SP from psql
Add a method that access your new function/SP from the relevant DAO and DAO implementation class
Add a test method in the DAO test class that access your new DAO method
Create your Query class
Create your Query parameters class
Add your query type to the VdcQueryType enum
Run the relevant DAO tests and verify that all tests are passed
Implement UI/REST API calls to your query and test that it works

## Commands

### How to get data on command execution via DAOs ?

All data accessed by commands are done via a call to DBFacade to get the relevant DAO and then calling directly the DAO method.

## Search Engine

### A brief overview

To perform a search, enter the search query (free-text or syntax-based) in the Search Bar at the top of the Administration Portal. Search queries can be saved as a Bookmarks for future reuse (This eliminates the need to reenter a search query each time the specific search results are needed).

You can specify the search criteria after the colon in the query. The syntax of {criteria} is as follows:
<prop><operator><value>
or
<obj-type><prop><operator><value>

*Examples*

*Hosts: Vms.status = up* (Displays a list of all hosts running virtual machines that are up.)
*Vms: domain = qa.company.com* (Displays a list of all virtual machines running on the specified domain.)
''Vms: users.name = Mary '' (Displays a list of all virtual machines belonging to users with the username Mary.)
*Events: severity > normal sortby time* (Displays the list of all Events whose severity is higher than Normal sorted by time)
 The Administration Portal provides auto-completion to help you create valid and powerful search queries. As you type each part of a search query, a drop-down list of choices for the next part of the search opens below the Search Bar. You can either select from the list and then continue typing/selecting the next part of the search, or ignore the options and continue entering your query manually.

### Objects, properties and supported operators

*List of obj-types*

       DataCenter,Cluster,Host,Storage,Disks,VMs,Pools,Template,Volumes,Events

*List of properties*

      General (applied to all objects) : sortby, page

*`DataCenter`*
      Clusters, Storage, name, description, type, status

*`Cluster`*
      DataCenter, Storage, name, description, initialized

*`Host`*
      Vms, Templates, Events, Users, Storage, name, status, cluster, address, cpu_usage, mem_usage, network_usage, load,version, cpus, memory, cpu_speed,
      cpu_model, active_vms, migrating_vms, committed_mem, tag, type, datacenter

*`Storage`*
      Hosts, Clusters, name, status, datacenter, type, size, used, committed

*`Disks`*
      Datacenter, Storages, alias, description, provisioned_size, size, actual_size, 
      creation_date, bootable, shareable, allow_snapshot, format, status, disk_type

*`VMs`*
      Hosts,Templates, Events, Users, Storage, name, status, ip, uptime, domain,
      os, creationdate, address, cpu_usage, mem_usage, network_usage, memory, apps, cluster, pool, loggedinuser, tag, datacenter, type

*`Pools`*
      name, description, type

*`Template`*
      Vms, Hosts, Events, Users, Storage, name, domain, os, creationdate, childcount,mem, description, status, cluster, datacenter 

*`Volumes`*
      Cluster, name, type, transport_type, replica_count, stripe_count, status

*`Events`*
      Vms, Hosts, Templates, Users, Clusters, Volumes, type, severity, message, time,usrname, event_ host, event_vm, event_template, event_storage, event_datacenter, event_volume, correlation_id

*List of operators*

       Logical operators {and | or}
       Regular operators { = | != }

### What should I do if I have to change something?

[step-by-step Guide](http://wiki.ovirt.org/wiki/Development/Introducing_Entity_Search)

### SQL Injection prevention.

Since search queries are based on free text typed by the user, there is a chance that malicious code will be sent in order to see secured data or to damage the database
The method of abusing a SQL interface that allows free text is called "SQL Injection"
To prevent that, each search query is checked by a engine specific class inherited from SqlInjectionChecker
Our Postgres implementation class is PostgresSqlInjectionChecker

## Trouble Shooting

### Can not connect to the database.

Check that your postgresql service is up
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
