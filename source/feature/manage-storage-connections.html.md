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

This feature supports the disaster recovery agenda, and should allow quickly switching to work with another storage that holds a backup/sync of the contents of the current storage in case of primary storage failure. The feature introduces the ability to edit (update) connection properties of an existing storage domain, rather than delete the old one and create a new one.

### Owner

         Name: Alissa Bonas
`   Email: `<abonas@redhat.com>
         Last updated: June 2 2013

### Current Status

*   Edit NFS connection properties in webadmin UI - ready (http://gerrit.ovirt.org/#/c/12372/)
*   Edit Posix connection properties in webadmin UI -ready (http://gerrit.ovirt.org/#/c/13640/)
*   Allow deletion of connection only if no storage domains (nor lun disk in Iscsi case) are using it. (implementation phase) <http://gerrit.ovirt.org/#/c/15269/>
*   Edit NFS, Posix connection properties in REST (design phase)
*   Edit ISCSI connection properties in webadmin UI (not started)
*   Edit ISCSI connection properties in REST (design phase)
*   Blocking bug in vdsm : <https://bugzilla.redhat.com/show_bug.cgi?id=950055>

## Detailed Description

While in UI and REST storage domain and the storage connection are presented as one united entity to the user, current backend implementation actually manages them separately.

In order to allow user to edit the connection details, there's a need to separate the notion of storage domain from its connection details, and allow editing just the connection details without editing the storage domain itself. Since the storage domain is not changed, it will continue to point to the same connection entity which connectoin details (such as path, for example) will be updated by the user.

Connection is allowed to be edited when the storage domain is set to maintenance state, and in condition that the new location where it will point already has a sync/backup with the original storage contents.

The storage types that are in scope of this feature are: NFS, Posix, local, iSCSI.

The new connection details should be of the same storage type as the original connection. Meaning - NFS storage connection cannot be edited to point to iSCSI.

Open issue: do lun_id and physical_volume_id need also to be updated for iSCSI?

## GUI

Storage domain and connection are managed together in webadmin UI in Storage tab --> specific storage entry open in a popup dialog. Till now, storage domain's edit was enabled only for active storage domains and allowed updating only their name and description.

In the scope of this feature, in order to allow editing the connection's details such as path for Posix and NFS storage domains, the edit button is now enabled for storage domains that are in maintenance state as well. In that case, name and description are disabled for edit.

For iSCSI there will not be an option (in the scope of this feature) to edit the connection (target) details in webadmin UI.

## REST

In order to allow editing connections, a new root resource will be introduced that will allow add/edit/delete/get of connections to storage.

TODO: model the new connection entity. Should represent several storage types.

### New connection (POST)

It will be possible to create a new connection without adding a storage domain along with it, and later on create a storage domain and relate it to existing connection by providing the connection id.

### Delete connection

Deletion of connection will be possible only if no storage domain is connected to it (orphan connection).

### Update existing connection (PUT)

It will be possible to update connection details when storage domain connected to it is in maintenance state. Most of connection fields can be updated (such as path/iqn/address/port/user/password) - each storage type has its relevant set of fields, id of connection will be immutable.

In addition, for each storage domain it should be possible to view (GET) its storage connections by approaching it via a specific subresource: /api/storagedomains/<storageDomainId>/connections

## Database

Storage connections are managed today in storage_server_connections table. The edit action will update an existing record in this table. The connection id will remained unchanged, thus the references to the connection will remain correct and will not need a modification.

For NFS/gluster/Posix/local connections a reference to a record in this table is made in storage_domain_static table --> column "storage" holds the connection id.

For iSCSI, the reference to connection id is made via lun_storage_server_connection_map table.

<Category:Feature>
