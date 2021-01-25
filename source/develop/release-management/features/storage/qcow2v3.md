---
title: QCOW2 compat levels
category: feature
authors: mlipchuk
feature_name: QCOW2 compat levels
feature_modules: engine,vdsm
feature_status:  Released in oVirt 4.1
---

# QCOW2 compat levels


## Overview

The QCOW image format includes a version number to allow introducing new features that change the image format in an incompatible way.
Newer QEMU versions (1.7 and above) support a new format of QCOW2 version 3, which is not backwards compatible and introduce
many improvements like zero clusters, and performance improvement.

## Owner

- Name: [Maor Lipchuk](https://github.com/maorlipchuk)
- Email: <mlipchuk@redhat.com>


## Detailed Description

The Storage Domain's version dictated the maximum supported compat level of QCOW volumes.
V3 Storage Domains (or older) support only 0.10 QCOW compat level, while V4 Storage Domains also support 1.1 QCOW compat level.
For more information about features of the different QCOW versions, see [QCOW3](http://wiki.qemu.org/Features/Qcow3)

### Installation/Upgrade

As previously described, only 4.1 DC supports V4 Storage Domains.
Once the Data Center is upgraded to 4.1 all the Storage Domains' version in this Data Center should be updated to V4,
and every new Storage Domain will be created with V4 version.

After the upgrade, all the newly created QCOW volumes will be created with 1.1 compatibility level,
while all the existing QCOW volumes that were created before the upgrade, will stay unchanged.

The following are REST API examples of 4.1 upgrade and adding new 4.1 Storage Domains:

#### Upgrading an exiting 4.0 Data Center to 4.1

First, all the clusters' version in the Data Center should be upgraded to 4.1:

##### Upgrading existing 4.0 clusters

```xml
PUT http://localhost:8080/ovirt-engine/api/clusters/123 HTTP/1.1
Accept: application/xml
Content-type: application/xml

<cluster>
  <version>
     <major>4</major>
     <minor>1</minor>
  </version>
</cluster>
```

Then, the Data Center's version should be updated to 4.1:

##### Upgrading existing 4.0 Data Center

```xml
PUT http://localhost:8080/ovirt-engine/api/datacenters/111111 HTTP/1.1
Accept: application/xml
Content-type: application/xml

<data_center>
  <version>
     <major>4</major>
     <minor>1</minor>
  </version>
</data_center>
```

#### Creating a new 4.1 Data Center with new Storage Domains.

Only 4.1 Data Centers support V4 storage domains.
A new Data Center can be added with explicit version although the default should be the latest (4.1)

##### Add a new 4.1 Data Center

```xml
POST http://localhost:8080/ovirt-engine/api/datacenters HTTP/1.1
Accept: application/xml
Content-type: application/xml

<data_center>
  <name>mydc</name>
  <local>true</local>
  <version>
     <major>4</major>
     <minor>1</minor>
  </version>
</data_center>
```

##### Add a storage domain with storage format V4

You can use explicit `storageFormat` V4 in the request for adding a new Storage Domain or not mention it and the default will be V4.

```xml
POST http://localhost:8080/ovirt-engine/api/storagedomains HTTP/1.1
Accept: application/xml
Content-type: application/xml

<storage_domain>
  <name>storage_name</name>
  <type>data</type>
  <description>description</description>
  <storage>
    <type>nfs</type>
    <storageFormat>V4</storageFormat>
    <address>storage.host.address</address>
    <path>/path/nfs</path>
  </storage>
  <host>
    <name>host_name</name>
  </host>
</storage_domain>
```

The following is an example of the response once adding a storage domain (The storage_format can be noticed):

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<storage_domain href="/ovirt-engine/api/storagedomains/1234" id="1234">
    <actions>
        <link href="/ovirt-engine/api/storagedomains/1234/updateovfstore" rel="updateovfstore"/>
        <link href="/ovirt-engine/api/storagedomains/1234/refreshluns" rel="refreshluns"/>
        <link href="/ovirt-engine/api/storagedomains/1234/reduceluns" rel="reduceluns"/>
        <link href="/ovirt-engine/api/storagedomains/1234/isattached" rel="isattached"/>
    </actions>
    <name>storage_name</name>
    <description>description</description>
    <link href="/ovirt-engine/api/storagedomains/1234/diskprofiles" rel="diskprofiles"/>
    <link href="/ovirt-engine/api/storagedomains/1234/disks" rel="disks"/>
    <link href="/ovirt-engine/api/storagedomains/1234/storageconnections" rel="storageconnections"/>
    <link href="/ovirt-engine/api/storagedomains/1234/permissions" rel="permissions"/>
    <link href="/ovirt-engine/api/storagedomains/1234/templates" rel="templates"/>
    <link href="/ovirt-engine/api/storagedomains/1234/vms" rel="vms"/>
    <link href="/ovirt-engine/api/storagedomains/1234/disksnapshots" rel="disksnapshots"/>
    <available>16106127360</available>
    <committed>0</committed>
    <critical_space_action_blocker>5</critical_space_action_blocker>
    <external_status>ok</external_status>
    <master>false</master>
    <status>unknown</status>
    <storage>
        <address>storage.host.address</address>
        <path>/export/data3</path>
        <type>nfs</type>
    </storage>
    <storage_format>v4</storage_format>
    <supports_discard>false</supports_discard>
    <supports_discard_zeroes_data>false</supports_discard_zeroes_data>
    <type>data</type>
    <used>4294967296</used>
    <warning_low_space_indicator>10</warning_low_space_indicator>
    <wipe_after_delete>false</wipe_after_delete>
</storage_domain>
```

### Functionality

New QCOW volumes that will be created on a V4 Storage Domains will be created with 1.1 compatibility level.
That also includes snapshots, so theoratically we could have an old disk with a chain of volumes that some of the volumes will be with
compatibility level of 0.10, and others (like new snapshots) that will be with 1.1 compatibility level based on those 0.10 volumes.
Those types of chains are supported by QEMU, and oVirt will also introduce the user the ability to upgrade any disk, so all its volumes
will be with the same QCOW compatibility version through a REST update command which will be described later in this document.

### Fetch QCOW compat for a disk through REST API

Important: The disk's attribute `QcowCompat` will only be presented for QCOW volumes only as opposed to RAW disks.
The QCOW compat can be fetched using the following REST APIs:

```xml
GET http://localhost:8080/ovirt-engine/api/storagedomains/123/disks/111 HTTP/1.1
Accept: application/xml
Content-type: application/xml
```

```xml
GET http://localhost:8080/ovirt-engine/api/disks/111 HTTP/1.1
Accept: application/xml
Content-type: application/xml
```

Only the active volume of the disk is being presented, therefore the query will only return the relevant QCOW version of the active volume.
Here is an example of the reponse output:

```xml
<disk href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b" id="2edfbc96-8c1b-4689-a582-bb7d7782e87b">
<actions>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/sparsify" rel="sparsify"/>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/export" rel="export"/>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/move" rel="move"/>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/copy" rel="copy"/>
</actions>
<name>VM_Disk1</name>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/permissions" rel="permissions"/>
<link href="/ovirt-engine/api/disks/2edfbc96-8c1b-4689-a582-bb7d7782e87b/statistics" rel="statistics"/>
<vms>
<vm id="7999ec9f-1c5b-4db7-b3d7-71528375f7b4"/>
</vms>
<actual_size>200704</actual_size>
<alias>VM_Disk1</alias>
<format>cow</format>
<image_id>2baf2249-14ac-411b-9392-f97fd80a1c2d</image_id>
<propagate_errors>false</propagate_errors>
<provisioned_size>1073741824</provisioned_size>
<qcow_version>qcow2_v3</qcow_version>
<shareable>false</shareable>
<sparse>true</sparse>
<status>ok</status>
<storage_type>image</storage_type>
<wipe_after_delete>false</wipe_after_delete>
<disk_profile href="/ovirt-engine/api/diskprofiles/5df1d6a4-4ac8-4dd3-88e0-9bb3d7774f10" id="5df1d6a4-4ac8-4dd3-88e0-9bb3d7774f10"/>
<quota id="7f5514f2-5085-412e-a137-45e5493668a4"/>
<storage_domain href="/ovirt-engine/api/storagedomains/c0c1ee3e-1447-42f9-9a71-e0c7d9df8475" id="c0c1ee3e-1447-42f9-9a71-e0c7d9df8475"/>
<storage_domains>
<storage_domain id="c0c1ee3e-1447-42f9-9a71-e0c7d9df8475"/>
</storage_domains>
</disk>
```

These operations will be disabled if the VM is running or if those disks are locked (for example copy, move, delete).

#### Troubleshooting

If an exception will occur or a volume will not seem to be updated here are few operations that might help diagnose the operation more intensly:

1. Check the DB for the volume format and QCOW version with the following command:
  `SELECT image_guid,volume_type,volume_format,qcow_compat FROM images;`
volume_format=4 means the volume is QCOW
volume_format=5 means the volume is RAW
RAW volumes (volume_format=5) should have qcow_compat field equals to 0 (Undefined),
while QCOW volumes (volume_format=4) should have qcow_compat field equals to 1 (QCOW2_V2) or 2 (QCOW2_V3)

2. Once the volume is created you can check the QemuImageInfo call in the vdsm.log on the Host.
the call should indicate the format of the volume and its compat, it should look like this:
   2016-12-14 23:18:53,818 INFO  (jsonrpc/4) [dispatcher] Run and protect: getQemuImageInfo, Return response: {'info': {'compat': u'1.1', 'clustersize': 65536, 'backingfile': u'bc7a3e50-a965-45
df-8699-ac47a0e20aa5', 'virtualsize': 1073741824, 'format': u'qcow2'}} (logUtils:52)

In this example the volume that is returned is with compat 1.1 and the format is QCOW2.

### Upgrade(amend) API

Here is how the amend operation should be performed through the REST API:

After a Data Center upgrade, old disks will keep their old QCOW compat (0.10),
if the user will desire to upgrade an old disk with old compat one can do so by using the upgrade API option.
There are two types of QCOW_versions:
 qcow2_v2 (QCOW compat 0.10)
 qcow2_v3 (QCOW compat 1.1)

```xml
PUT http://localhost:8080/ovirt-engine/api/storagedomains/123/disks/111 HTTP/1.1
Accept: application/xml
Content-type: application/xml

<disk>
    <qcow_version>qcow2_v3</qcow_version>
</disk>
```

The upgrade volume operation amends all the QCOW volumes in the image,
that also include old snapshots even if new active volume created upon them with compat level 1.1.

The amend should not be performed on Template's disks, the operation should fail in case of a Template disk.
Once the amend operation starts the disk will be locked and could not be used to avoid data corruption.
After the amend operation will be finished an audit log should be presented to the user indicating whether the operation succeed or failed:
"${DiskAlias} has been amended successfully." or "Failed to amend ${DiskAlias}."

### New VDSM API

 There are two new APIs that will be introduced in oVirt 4.1:
`amend_volume` - Support amending an old QCOW compat to a new compat level.
`getQcowVolumeInfo` - Returns the output with the compatibliity level of the volume by qemu-img info.
