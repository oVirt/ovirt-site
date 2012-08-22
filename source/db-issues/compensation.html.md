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

### What changes are logged

       Insertion – the ID of the new entity (compensation = delete entity by Id)
       Deletion – the deleted entity (compensation = re-insertion of the entity)
       Update – the entity before the change (compensation = update entity with “old values”)
       UpdateStatus – the status before change (compensation = update entity with “old status” - this is an optimization)

### BusinessEntity interface

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
