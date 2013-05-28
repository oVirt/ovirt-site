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
*   Edit NFS, Posix connection properties in REST (Work in Progress)
*   Edit ISCSI connection properties in webadmin UI (Work in Progress)
*   Edit ISCSI connection properties in REST (Work in Progress)

## Detailed Description

<Category:Feature>
