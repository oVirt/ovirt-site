---
title: Mixed Types Data Center
authors: tnisan
wiki_title: Features/Mixed Types Data Center
wiki_revision_count: 5
wiki_last_updated: 2014-02-03
---

# Mixed Types Data Center

## Allow Mixed Type Storage Domain in a Single Data Center

### Summary

Up until oVirt 3.3 every data center had a specific storage type and with the exception of ISO & import/export domains, all attached domains had to be from the same storage type. This feature removes the storage type property from the data center and allows it to contain mixed storage domains from any storage types with the exception of local domains, mixing shared and local domains will only be possible after we get rid of the storage pool concept

### Owner

*   Name: Tal Nisan
*   Email <tnisan at redhat.com>

### Current Status

*   Engine support - Done
*   Webadmin support - Done
*   REST support - Done

### Limitations

*   Data centers of version 3.0 can not contain mixed types (again with the exception of ISO & import/export domains) , if a block domain is the first to be attached to the data center, file domains will not be able to be attached and vice versa
*   Gluster & Posix domains will not be able to be attached to data centers with a version that does not support the respective storage type (<3.3 for Gluster and <3.2 for Posix)
*   Live storage migration from a block storage domain is only allowed to a destination of a block storage domain, same goes for live storage migration from file storage domain

### User Experience

Webadmin:

*   Go to the "Data Centers" main tab
*   Click on "New"
*   Fill in the details and select "Shared" for a data center of shared storage domains (iSCSI, NFS etc..) or "Local" for a data center of local on host storage

![](MixedTypesDataCenter_CreateNewDataCenterDialog.png "MixedTypesDataCenter_CreateNewDataCenterDialog.png")

REST API:

Standard creation of a new data center:

    PUT /api/datacenters HTTP/1.1
    Accept: application/xml
    Content-type: application/xml
    <data_center>
            <name>{name}</name>
            <local>{true/false}</local>
            <version major="{version major}" minor="{version minor}"/>
    </data_center>

From then on you can continue to create storage domains in your data center according to the chosen type (local/shared), webadmin example:

*   Local data center

![](MixedTypesDataCenter_CreateStorageOnLocalDC.png "MixedTypesDataCenter_CreateStorageOnLocalDC.png")

*   Shared data center

![](MixedTypesDataCenter_CreateStorageOnSharedDC.png "MixedTypesDataCenter_CreateStorageOnSharedDC.png")
