---
title: Mixed Types Data Center
category: feature
authors: tnisan
feature_name: Mixed Type Data Center
feature_modules: engine
feature_status: Released in oVirt 3.4
wiki_title: Mixed Types Data Center
wiki_revision_count: 5
wiki_last_updated: 2014-02-03
---

# Mixed Types Data Center

## Allow Mixed Type Storage Domain in a Single Data Center

### Summary

Up until oVirt 3.3 every data center had a specific storage type and all attached domains had to be from the same storage type with the exception of ISO & export domains. This feature removes most storage types from the data center and will allow the user to mix storage domains from any storage type except local domains. Mixing shared and local domains will only be possible once the storage pool concept is removed from the system

### Owner

*   Name: Tal Nisan
*   Email <tnisan at redhat.com>

### Current Status

*   Engine support - Done
*   Webadmin support - Done
*   REST support - Done

### Limitations

*   Data centers of version 3.0 can not contain mixed types (again with the exception of ISO & import/export domains) , if a block domain is the first to be attached to the data center, file domains will not be able to be attached and vice versa
*   Gluster domains can only be attached to data centers with compatibility version 3.3 or higher
*   Posix domains can only be attached to data centers with conpatibility version 3.2 or higher
*   Live storage migration will only be supported between block domains and between file domains but not from block to file or file to block

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
