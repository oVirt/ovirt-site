---
title: Mixed Types Data Center
category: feature
authors: tnisan
---

# Mixed Types Data Center

## Allow Mixed Type Storage Domain in a Single Data Center

### Summary

Up to oVirt 3.3 every data center had a specific storage type and all attached data domains had to be from the same storage type. This feature removes most storage type restrictions from the data center allows the user to mix storage domains from any storage type except local domains. Mixing shared and local domains will only be possible once the storage pool concept is removed from the system.

### Owner

*   Name: Tal Nisan
*   Email <tnisan@redhat.com>

### Current Status

*   Released in oVirt 3.4

### Limitations

#### Limitations relating to DC compatibility levels:

*   Data centers of version 3.0 can not contain mixed types (with the exception of ISO and import/export domains, of course), if a block domain is the first to be attached to the data center, file domains will not be eligible to be attached and vice versa
*   Gluster domains can only be attached to data centers with compatibility version 3.3 or higher
*   POSIX domains can only be attached to data centers with compatibility version 3.2 or higher

Note: oVirt 4.0 removed the support for DC compatibility levels below 3.6, so the aforementioned limitations are a mute point in newer oVirt versions.

#### Other limitations

*   Live storage migration will only be supported between block domains and between file domains but not from block to file or file to block. This limitation was removed in oVirt 3.6. See [Live Storage Migration Between Mixed Domains](live-storage-migration-between-mixed-domains.html) for additional details.

### User Experience

Webadmin:

*   Go to the "Data Centers" main tab
*   Click on "New"
*   Fill in the details and select "Shared" for a data center of shared storage domains (iSCSI, NFS etc..) or "Local" for a data center of local on host storage

![](/images/wiki/MixedTypesDataCenter_CreateNewDataCenterDialog.png)

REST API:

Standard creation of a new data center:

```xml
PUT /api/datacenters HTTP/1.1
Accept: application/xml
Content-type: application/xml

<data_center>
        <name>{name}</name>
        <local>{true/false}</local>
        <version major="{version major}" minor="{version minor}"/>
</data_center>
```

From then on you can continue to create storage domains in your data center according to the chosen type (local/shared), webadmin example:

*   Local data center

![](/images/wiki/MixedTypesDataCenter_CreateStorageOnLocalDC.png)

*   Shared data center

![](/images/wiki/MixedTypesDataCenter_CreateStorageOnSharedDC.png)
