---
title: Entity comment
authors: nslomian
---

# Entity comment

## Concept

A new free text comment field will be added to many of the key entities in Ovirt.

This field is meant to be used as a place for users and administrators to leave reminders and clarifications about the current state of the entity.

The field will be searchable as per default field behaviour.

### Comment VS Description

Some entities in Ovirt already possess the description field, while this field may fulfil a similar role today, It is designed for a different purpose.

Description is used to identify the entity and its usage, while the comment field is meant to be used as a more dynamic text regarding the current state of the entity.

### Usage example

A host named hw2.corp.com has malfunctioned and an admin has moved it to maintenance state while it is being repaired.

To prevent confusion he changes the comment field of the host to: "I've placed this host in maintenance since there is an issue with its fan".

This information is not relevant to its description which should remain: "Test environment machine" .

## Code change

For us to add a comment field an entry must be added to the Data base and this entry must be reflected throughout the system all the way up to the UI

### Effected entities

Still not fully decided, currently adding

*   Data center
*   Logical network
*   Storage domain
*   Cluster
*   Host
*   VM
*   Template
*   Pool
*   User

### Changed DB tables

To the following tables a comment column will be added

*   storage_pool (Data center)
*   network (Logical network)
*   storage_domain_static (Storage domain)
*   vds_groups (Cluster)
*   vds_static (Host)
*   vm_static (VM, Template)
*   vm_pools (Pool)
*   users (User)

## Status

In development
