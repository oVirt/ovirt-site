---
title: Manage Storage Connections
category: feature
authors: abonas, derez, sgotliv, amureini
---

# Manage storage connections

## Summary

This feature adds the ability to add, edit and delete storage connections. This is required in order to support configuration changes including adding paths for multipathing, changes of hardware, and ease failover to remote sites by quickly switching to work with another storage that holds a backup/sync of the contents of the current storage in case of primary storage failure.

The storage types that are in scope of this feature are iSCSI and the file based storage types (NFS, POSIX, GlusterFS and local storage). It does not, however, allow mixing or converting between block and file based storage.

## Owner

Name: Alissa Bonas<br/>
Email: abonas@redhat.com

## Current Status and gaps

Update July 3rd, 2016

The feature was released in oVirt 3.3. Some implementation gaps still exists, though, as they were deprioritized since:

### GUI

*   Edit ISCSI connection properties in webadmin GUI
*   Add "connectivity test" functionality

### Server (backend)

*   Extract common validations regarding storage connections to the `StorageConnectionValidator` (already partially done).
*   Finer grained MLA control (not sure if there's actually an interesting usecase for this).
*   Refactor `AddSANStorageDomainCommand` so it will not add storage server connection, and rather use existing one (that was either created right before by add connection command, or in the past). This will involve rewriting San domain creation in webadmin (`StorageListModel`) to call `AddStorageServerConnection` before `AddSANStorageDomainCommand`.
*   Rethink - should the "delete connection" action disconnect from just one host, or all hosts when deleting a connection?

### REST (backend)

*   Add connections subresource to LUN disks - For each LUN disk (Direct LUN) view (GET) its storage connections by approaching it via a specific subresource: `/api/disks/<diskId>/connections`.


# Detailed Description

While the UI and REST present a storage domain and its related storage connection[s] as one united entity to the user, the backend implementation actually manages them separately. In order to allow the user to edit the connection details, there's a need to separate the notion of storage domain from its connection details, and allow editing just the connection details without editing the storage domain itself.

A connection may be edited whether there are no storage domains connected to it (an orphan connection), or when there are storage domains using it. The number of the storage domains using a connection can vary based on storage type. For file domains, there will be a 1:1 relation between storage domain and its connection, while for iSCSI, there can be several storage domains using the same target.

If there are storage domains using a connection, it may only be edited when all storage domains referencing it are set to maintenance state, or the storage domain is in unattached status. During this update operation, the domains (if such exist) will become locked (status=locked) and then their statistics will be updated based on the new pointed connection's properties (the new storage location). The domains will be unlocked once the update will be completed.

For Direct LUN (LUN disks), in order to edit their storage connection, all VMs using those disks (disks that are plugged) should be powered off. It is the user's responsibility to make sure that after editing the connection the system can indeed reach the data/LUNs of the relevant storage domains. To ease the administration process, an optional connectivity test may be run to make sure that the storage is indeed accessible, although this is currently out of scope.

Removing a connection is possible only if there are no storage domains nor LUN disks using it.

For iSCSI domains, there's an additional option to add (attach) an additional storage connection (target) to same domain. Similarly, there's an option to detach a connection from iSCSI domain. The attach/detach options are available only via REST api.

# GUI

Storage domains and connections are managed together in the webadmin UI in under the Storage tab. Till now, s storage domain's edit was enabled only for active storage domains and allowed to update only their name and description.

In order to allow editing the connection details, the edit button will now be enabled when storage domain is set in maintenance or unattached mode. However, editing the domain name and description will be disabled when in this state as it requires connectivity to the storage. N.B. There will not be an option (in the scope of this feature in 3.3) to edit iSCSI connection details via the webadmin UI.

# REST

## Get existing connection (GET)

1.  All storage connections that exist in the oVirt setup will be accessible in a new root resource: `api/storageconnections`.
2.  A specific storage connection can be viewed in `api/storageconnections/<connectionid>`
3.  For each storage domain it should be possible to view (GET) its storage connections by approaching it via a specific subresource: `/api/storagedomains/<storageDomainId>/storageconnections`.

<b>example:</b>

    Request type - GET
    http://host:port/api/storageconnections

## New connection (POST)

It will be possible to create a new connection without adding a storage domain along with it, and only later reference it from any domain by providing the connection id.
Passing host id/name is optional. Providing it will lead to attempt to connect to the storage via the host.
Not providing host will lead to just persisting storage details in the database.

<b>Example</b>

    Request type - POST
    http://host:port/api/storageconnections

Example of request body - NFS:

    <storage_connection>
        <type>nfs</type>
        <address>nfsserver.lab.somecompanyname.com</address>
        <path>/export/storagedata/username/data20</path>
        <host>
            <name>vdsm_host_to_use</name>
        </host>
    </storage_connection>

Example of request body - POSIX:

    <storage_connection>
        <type>posixfs</type>
        <address>fileserver.lab.somecompanyname.com</address>
        <path>/export/storagedata/username/dataNewData</path>
        <vfs_type>nfs</vfs_type>
    </storage_connection>

## Delete connection (DELETE)

Deletion of connection will be possible only if no storage domain nor LUN disks is referencing it (orphan connection).

<b>Example</b>

    Request type is DELETE
    http://host:port/api/storageconnections/<connectionId>

Connection ID is of format GUID, for instance - `ffb489f6-b144-4770-84d0-22167024bb5c`.
A host is optional for the deletion process. Supplying it will disconnect (unmount) the connection from that host. If host is passed, there's a need in request body in deletion request to contain host details.
Example of host element structure in the body (it can contain either host id or name):

    <host>
        <name>vdsm_host_to_use</name>
    </host>

Example passing host id (in this case - empty):

    <host id="00000000-0000-0000-0000-000000000000">
    </host>

## Update existing connection (PUT)

It will only be possible to update connection details when all storage domains referencing it are in maintenance mode. Most of the connection fields may be updated (such as path/iqn/address/port/user/password) - each storage type has its relevant set of fields.
Host section is optional. Specifying host (vdsm) will lead the host to attempt to connect to the newly specified storage details.
Not specifying host will lead to just update the details in the engine's database.
Connection ID however, will be immutable.


    Request type - PUT
    http://host:port/api/storageconnections

Example body - changing the address:

    <storage_connection>
        <address>dhcp-1-120.my.lab.a.com</address>
        <host>
            <name>vdsm_host_to_use</name>
        </host>
    </storage_connection>

## Add new file (nfs/posix/local) storage domain with existing storage connection (POST)

    Request type - POST
    http://host:port/api/storagedomains

    <storage_domain>
        <name>mynewdomain</name>
        <type>data</type>
        <storage id="ad3ca1ff-26a6-482e-ac6b-16ee23f12529"/> <!-- Referes to an existing connection -->
        <host>
            <name>vdsm_host_to_use</name>
        </host>
    </storage_domain>

## Attach an additional storage connection to an existing iSCSI storage domain (POST)

    Request type - POST
    http://host:port/api/storagedomains/<storageDomainid>/storageconnections

    <storage_connection id="">
    </storage_connection>

## Detach a storage connection from iSCSI storage domain (DELETE)

    Request type - DELETE
    http://host:port/api/storagedomains/<storageDomainid>/storageconnections/<connection_id>

# Database

This feature doesn't require any database structure change nor upgrade. The below is a description of the existing structure as it is today, and how it will be used in the scope of this feature.

Storage connections are managed today in `storage_server_connections` table. The edit action will update an existing record in this table. The connection id will remained unchanged, thus the references to the connection will remain correct and will not need a modification.

For NFS/gluster/POSIX/local connections a reference to a record in this table is made in `storage_domain_static` table --> column "storage" holds the connection id.

For iSCSI, the reference to connection id is made via `lun_storage_server_connection_map` table.

`physical_volume_id` is the id used by lvm, and since it will be copied by LUN replication, it will be the same in the new (backup) LUN, so it needs no update in the database. lun_id can be the same or change during LUN replication (setup dependent) - in the scope of this feature, the lun_id will remain the same cross the source and the target system, thus there is no need to update lun_id in the database.

# MLA (permissions)

Administrative permission on the "System" level are required to directly manage connections.
Editing the connections of an existing domain requires permissions on that domain.

# Testing

1. NFS - edit in webadmin UI:
Preparation: copy the contents of the storage domain manually from the current path to the new (target) path
Scenario:

*   -   maintenance the data domain
    -   right click - edit the storage domain
    -   change the mount path to another storage server
    -   edit NFS advanced options: retransmissions, timeout
    -   activate the domain

2. POSIX - edit in webadmin UI:
Preparation: copy the contents of the storage domain manually from the current path to the new (target) path
Scenario:

*   -   maintenance the data domain
    -   right click - edit the storage domain
    -   change the mount path to another storage server
    -   edit mount options
    -   activate the domain

