---
title: Entity comment
authors: nslomian
wiki_title: Entity comment
wiki_revision_count: 2
wiki_last_updated: 2013-03-20
---

# Entity comment

## Concept

A new free text comment field will be added to many of the key entities in Ovirt.

This field is meant to be used as a place for users and administrators to leave reminders and clarifications about the current state of the entity.

The field will be searchable as per default field behaviour.

## Comment VS Description

Some entities in Ovirt already possess the description field, while this field may fulfil a similar role today, they are designed for different purpose.

Description is used to identify the entity and its usage, while the comment field is meant to be used as a more dynamic text regarding the current state of the entity.

## Usage example

A host named hw2.corp.com has malfunctioned and an admin has moved it to maintenance state while it is being repaired.

To prevent confusion he changes the comment field of the host to: "I've placed this host in maintenance since there is an issue with its fan".

This information is not relevant to its description which should remain: "Test environment machine" .

## List of entities changed

Still not fully decided, probable candidates are:

      Snapshot
      Data centre
      Logical network
      Storage domain
      Cluster
      VM
      Template
      Pools
      Host
      Volumes

## Status

In development
