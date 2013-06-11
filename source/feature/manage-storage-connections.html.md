---
title: Manage Storage Connections
category: feature
authors: abonas, derez, sgotliv
wiki_category: Feature
wiki_title: Features/Manage Storage Connections
wiki_revision_count: 207
wiki_last_updated: 2014-07-13
---

# Manage storage connections

### Summary

This feature adds the ability to add, edit and delete storage connections. This is required in order to support configuration changes including adding paths for multipathing, changes of hardware, and ease failover to remote sites, by quickly switching to work with another storage that holds a backup/sync of the contents of the current storage in case of primary storage failure. The storage types that are in scope of this feature are: NFS, Posix, local, iSCSI. The new connection details should be of the same storage type as the original connection. For example, an NFS storage connection cannot be edited to point to iSCSI

### Owner

         Name: Alissa Bonas
`   Email: `<abonas@redhat.com>

### Current Status and tasks

Updated June 10 2013

#### GUI

*   Edit NFS connection properties in webadmin UI - ready (http://gerrit.ovirt.org/#/c/12372/)
*   Edit Posix connection properties in webadmin UI -ready (http://gerrit.ovirt.org/#/c/13640/)
*   Edit local storage connection properties in webadmin UI (in implementation)
*   Edit ISCSI connection properties in webadmin UI (not started)
*   Add "connectivity test" functionality - not started.

#### Server (backend)

*   Allow deleting a connection only when it is not in use by any storage domain/direct lun. (in review) <http://gerrit.ovirt.org/#/c/15269/>
*   Changes in new connection creation flow - Prevent addition of duplicate connections in AddStorageServerConnection command for file domains. (in review) <http://gerrit.ovirt.org/#/c/15388/>
*   Extend functionality of existing AddStorageServerConnection command to create also iSCSI connections. (Currently a connection for block domains is created via AddSanStorageDomain command directly). Check connection validity to target. (in implementation)
*   Extend functionality of existing UpdateStorageServerConnection command to update iSCSI connections. Check connection validity to target, VG properties - whether they are correct. (not started)
*   Add validations to AddStorageServerCommand that for each storage type only the relevant properties are populated. (not started)
*   MLA (permissions) - not started

#### REST (backend)

*   Create root resource for connections that will perform GET (not started)
*   Add functionality to root resource for add/delete/edit NFS, Posix connection properties in REST (design phase)
*   Add functionality to root resource for add/delete/edit ISCSI connection properties in REST (design phase)
*   Create subresource for connections under domains (api/storagedomains/<domainId>/connections (not started)

#### Blockers

*   Blocking bug in vdsm : <https://bugzilla.redhat.com/show_bug.cgi?id=950055>

# Detailed Description

While in UI and REST storage domain and the storage connection are presented as one united entity to the user, current backend implementation actually manages them separately. In order to allow user to edit the connection details, there's a need to separate the notion of storage domain from its connection details, and allow editing just the connection details without editing the storage domain itself.

In the first phase, a connection may only be edited when all storage domains referencing it are set to maintenance state. For direct lun (lun disks), in order to edit their storage connection, all VMs using those disks should be powered off. It is the user's responsibility to make sure that after editing the connection the system can indeed reach the data/luns of the relevant storage domains.To ease the administration process, an optional connectivity test may be run to make sure that the storage is indeed accessible.

# GUI

Storage domain and connection are managed together in webadmin UI in Storage tab . Till now, storage domain's edit was enabled only for active storage domains and allowed updating only their name and description.

In order to allow editing the connection details, the edit button will now be enabled when storage domain is set in maintenance mode. However, editing the domain name and description will be disabled when in this state as it requires connectivity to the storage. N.B. There will not be an option (in the scope of this feature in 3.3) to edit iSCSI connection details via the webadmin UI.

# REST

TBD: model the new connection entity. Should represent several storage types.

### Get existing connection (GET)

All storage connections will be accessible in a new root resource: api/connections. For each storage domain it should be possible to view (GET) its storage connections by approaching it via a specific subresource: /api/storagedomains/<storageDomainId>/connections. For each lun disk (direct lun) it should be possible to view (GET) its storage connections by approaching it via a specific subresource: /api/disks/<diskId>/connections. . Note - connections subresource for lun disks is not in scope for 3.3

### New connection (POST)

It will be possible to create a new connection without adding a storage domain along with it, and only later reference it from any domain by providing the connection id.

### Delete connection

Deletion of connection will be possible only if no storage domain is referencing it (orphan connection).

### Update existing connection (PUT)

It will only be possible to update connection details when all storage domains referencing it are in maintenance mode. Most of the connection fields may be updated (such as path/iqn/address/port/user/password) - each storage type has its relevant set of fields. Connection ID however, will be immutable.

# Database

This feature doesn't require any database structure change nor upgrade. The below is a description of the existing structure as it is today, and how it will be used in the scope of this feature.

Storage connections are managed today in storage_server_connections table. The edit action will update an existing record in this table. The connection id will remained unchanged, thus the references to the connection will remain correct and will not need a modification.

For NFS/gluster/Posix/local connections a reference to a record in this table is made in storage_domain_static table --> column "storage" holds the connection id.

For iSCSI, the reference to connection id is made via lun_storage_server_connection_map table.

physical_volume_id is the id used by lvm, and since it will be copied by lun replication, it will be the same in the new (backup) lun, so it needs no update in db. lun_id can be the same or change during lun replication (setup dependent) - in the scope of this feature, the lun_id will remain the same cross the source and the target system, thus there is no need to update lun_id in db.

# MLA (permissions)

TBD

<Category:Feature>
