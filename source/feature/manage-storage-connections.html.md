---
title: Manage Storage Connections
category: feature
authors: abonas, derez, sgotliv
wiki_category: Feature
wiki_title: Features/Manage Storage Connections
wiki_revision_count: 207
wiki_last_updated: 2014-07-13
---

# Manage Storage Connections

## Edit Connection Properties

### Summary

Allow edit (update) connection properties of an existing storage domain, rather than delete/create a new one. This feature supports the disaster recovery agenda, and should allow quickly switching to work with another server (that holds a backup/sync of the contents of the storage) in case of primary storage failure. Connection can be edited when the storage domain is set to maitenance state, and in condition that the new location where it will point already has a sync/backup with the original storage contents.

### Owner

         Name: Alissa Bonas
`   Email: `<abonas@redhat.com>

### Current Status

*   Edit NFS connection properties in webadmin UI (http://gerrit.ovirt.org/#/c/12372/)
*   Edit Posix connection properties in webadmin UI (http://gerrit.ovirt.org/#/c/13640/)
*   Edit NFS, Posix connection properties in REST (design phase)
*   Edit ISCSI connection properties in webadmin UI (not started)
*   Edit ISCSI connection properties in REST (design phase)

## Detailed Description

While in UI and REST they are presented as one entity to the user, current backend implementation actually manages them separately. In order to allow user to edit the connection details, there's a need to separate the notion of storage domain from its connection details, and allow editing just the connection details without editing the storage domain itself.

<Category:Feature>
