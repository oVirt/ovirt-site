---
title: compensation
authors: emesika
wiki_title: OVirt-DB-Issues/compensation
wiki_revision_count: 11
wiki_last_updated: 2012-08-22
---

# Compensation mechanism

### What is compensation all about?

*Isolation level: what changes of a transaction T are exposed to other transactions
*

Postgres does not implement the READ-UNCOMMITTED isolation level. We have to notify the clients ASAP on entities that are changing status, this implies committing database changes ASAP before the asynchronous tasks associated with the relevant command are complete and in order to keep transactions as short as possible, create a entity change log which we can use to revert the changes if any asynchronous task fails.
 The process of logging those changes and roll back them if something fails is called compensation.

### Compensation change log

Change log is recorded in the database in the business_entity_snapshot table

           Column      |          Type          | Modifiers 
      -----------------+------------------------+-----------
      id              | uuid                   | not null
      command_id      | uuid                   | not null
      command_type    | character varying(256) | not null
      entity_id       | character varying(128) | 
      entity_type     | character varying(128) | 
      entity_snapshot | text                   | 
      snapshot_class  | character varying(128) | 
      snapshot_type   | integer                | 
      insertion_order | integer                |

Each command may affect multiple entities
A parent command may call other commands as part of its execution.

### What changes are logged

       Insertion – the ID of the new entity (compensation = delete entity by Id)
       Deletion – the deleted entity (compensation = re-insertion of the entity)
       Update – the entity before the change (compensation = update entity with “old values”)
       UpdateStatus – the status before change (compensation = update entity with “old status” - this is an optimization)

### BusinessEntity interface

All compensatable entities must implement BusinessEntity interface
This interface exposes the get/set of the entity ID
The business entity must be serializable, so does the type of the ID in order to log the changes

### BusinessEntitySnapshot

       CHANGED_ENTITY – update/delete
       NEW_ENTITY_ID – insert
       CHANGED_STATUS_ONLY – update status 

### CompensationContext

CompensationContext provides the API for adding entries to the “change log” and to flush the “change log” to DB

### When to compensate?

       Exception in execution has occurred
       The status of the transaction is inactive (if code is run in transaction)
       Failure in execution
       Server restart with existing entries at business_entity_snapshot
