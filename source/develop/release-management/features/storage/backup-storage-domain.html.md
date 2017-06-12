---
title: BackupStorageDomain
category: feature
authors: mlipchuk, shubham0d
feature_name: Backup Storage Domain
feature_modules: engine/vdsm
feature_status: Yet to Impelement
--- 


# Backup Storage Domain

This feature will add another functionality layer to the oVirt Disaster Recovery solution. It will allow any data storage domain to use as a backup domain and hence will remove the limitations of export storage domain. Adding functionality of backup storage domain deprecate the use of export storage domain and in future may replace it.


## Owner

* Maor Lipchuk <mlipchuk@redhat.com>
* Shubham Dubey <sdubey504@gmail.com>


## Current status

* Yet to Implement


## Summary

Until now, one of the solutions to backup VMs and Templates in oVirt was to use an export storage domain.
Export storage domain is a dedicated storage domain which is used to store and restore VMs and Templates.
The drawback of Export storage domain is its two stage process. Transferring a VM required first copying it into the export storage domain and then into other storage domain to start using them. Since in background transfer from one domain to other take place using normal copy or dd utility (in case of disks) this process take a large time for a complete transfer. Hence, for a better backup experience we decided to create a whole dedicated storage domain to be used only for backup which obviously will call as backup storage domain.


## GSOC

This feature is being developed as part of the Google Summer of Code [GSOC](https://developers.google.com/open-source/gsoc/).
Google Summer of Code is a global program focused on introducing students to open source software
development. Students work on a 3 month programming project with an open source organization
during their break from university.<br />
The oVirt organization has chosen Shubham Dubey, a student from The LNM Institute of Information Technology from India, to work  on this project for the upcoming summer and Maor Lipchuk, a senior software developer in the oVirt storage team, to be the mentor.


## Backup Storage Domain - Functionality

* You can select any data storage domain as backup storage.
* Once the storage domain is configured as backup the engine will block any running VMs or any other action that may invalidate the backup which might be in the storage domain.
* A backup storage domain can be detached and attached to a data center as every data storage domain.
* The backup indication will only be configured using the DataBase and will not be configured in the storage domain metadata - The user will be able to configure a storage domain as backup once a data storage domain is being imported or added to oVirt.
* There is no obligation regarding data center version in oVirt to a backup storage domain. A backup storage domain can be part of every Data Center version.
* A user can run a VM based on a Template which one of its disks is part of a backup storage domain while all the VM's disks are not part of the backup storage domain.

#### Advantages

* Much more dedicated storage domain for backup and disaster recovery purposes.
* One step process-If you want a backup of VM/Template then just transfer it to backup storage domain.
* For huge amount of VMs/Templates and OVFs migration the time taken for copying through export will be high which will be minimized by using backup storage domain.
* Large amount of extra space is used in export storage domain. It may be suitable for small datacenter but for large datacenter the storage required to store those OVFs and VMs in export storage domain will become a headache.
* Multiple storage domain can be used for backup purposes only.
* Backup storage domain will support both File storage(NFS , Gluster) as well as block storage(Fiber Channel and iSCSI) as compared to export storage domain which only has support for file storage.

#### Restrictions

* A data storage domain can not be configured as backup while there are running VMs with disks reside on that storage domain.
* User can not run VMs with disks reside on a storage domain configured as backup, since running VM might manipulate the disk's data.
* VMs with disks residing on a backup storage domain can not be previewed.
* Live move of disks to the backup storage domain will be restricted.
* A backup domain cannot be elected as the master domain.
* The Hosted Engine's domain can't be configured as a backup domain.
* The backup domain cannot be the target of memory volumes.


#### Open Issues

* Preview will be restricted for VMs with disks residing on a backup storage. - We think it should be restricted since currently oVirt does not support import storage domain with previewed unregistered entities.
* Shared disk will be restricted in the backup storage domain since those are not specified in the VM's OVF.
* VM pool will be eligible in a backup storage domain although, the user must keep in mind that import storage domain will not preserve its pool reference after import.
* Should the backup indication needs to be configured in the storage domain meta data? If so should we add the backup indication as part of V4 storage domain meta data.


## Current progress

DAL implementation:

  Changes | Values
  ---------|----------
  status | open
  gerrit link | https://gerrit.ovirt.org/#/c/77142/
  DB table changed | storage_domain_static
  Field name | backup
  Type | True / False (Default would be false, not null)


## Phases for Implementation

- [x] Phase 1 (under review): Add dal layer with new field -
  * introducing new field 'backup' in table storage_domain_static
  * Add field changes in fixtures.xml for dao tests
  * Test class added for dao test
- [ ] Phase 2: Add command validations for configuring backup storage domain - [see restrictions]
- [ ] Phase 3: Add REST command to update storage domain as backup - Introduce the ability to update the storage domain as backup through REST.


## Future plans

* Add GUI support for backup storage domain - Once backend configuration get complete and REST changes get implemented we will make this ready for user to use it through GUI.
* Convert Export storage domain to backup domain - If community agree then we will remove the export storage domain and replace it with the backup storage domain.


## GUI Mockups

 An Import storage domain (NFS, iSCSI) screen:
![](/images/wiki/Import_with_backup_NFS.png)

 An Add New Storage Domain (NFS, iSCSI) screen:
![](/images/wiki/Add_new_domain_with_backup_NFS.png)


## REST Requests

### Import block Storage Domain

#### Discover the targets in your iSCSI Storage Server

```xml
POST /api/hosts/052a880a-53e0-4fe3-9ed5-01f939d1df66/iscsidiscover
Accept: application/xml
Content-Type: application/xml

<action>
    <iscsi>
        <address>iscsi.server</address>
    </iscsi>
    <iscsi_target>iqn.iscsi.120.01</iscsi_target>
    <iscsi_target>iqn.iscsi.120.02</iscsi_target>
    <iscsi_target>iqn.iscsi.120.03</iscsi_target>
</action>
```

#### Get a candidates Storage Domains list to be imported

After the iscsilogin operation, the host is already connected to the targets in the iSCSI and we can fetch the Storage Domains which are candidates to be imported.

```xml
POST /api/hosts/052a880a-53e0-4fe3-9ed5-01f939d1df66/unregisteredstoragedomainsdiscover HTTP/1.1
Accept: application/xml
Content-type: application/xml

<action>
    <iscsi>
        <address>iscsiHost</address>
    </iscsi>
    <iscsi_target>iqn.name1.120.01</iscsi_target>
    <iscsi_target>iqn.name2.120.02</iscsi_target>
    <iscsi_target>iqn.name3.120.03</iscsi_target>
</action>
```

The response which should returned as a list of Storage Domains, as follows:

```xml
<action>
    <iscsi>
        <address>iscsiHost</address>
    </iscsi>
    <storage_domains>
        <storage_domain id="6ab65b16-0f03-4b93-85a7-5bc3b8d52be0">
            <name>scsi4</name>
            <type>data</type>
            <backup>true</backup>
            <master>false</master>
            <storage>
                <type>iscsi</type>
                <volume_group id="OLkKwa-VmEM-abW7-hPiv-BGrw-sQ2E-vTdAy1"/>
            </storage>
            <available>0</available>
            <used>0</used>
            <committed>0</committed>
            <storage_format>v3</storage_format>
        </storage_domain>
    <status>
        <state>complete</state>
    </status>
    <iscsi_target>iqn.name1.120.01</iscsi_target>
    <iscsi_target>iqn.name2.120.02</iscsi_target>
    <iscsi_target>iqn.name3.120.03</iscsi_target>
</action>
```

#### Import the iSCSI Storage Domains to the setup

```xml
POST /api/storagedomains/ HTTP/1.1
Accept: application/xml
Content-type: application/xml

<storage_domain id="39baf524-380e-407c-8625-50709fcaa9c2">
    <import>true</import>
    <host id="052a880a-53e0-4fe3-9ed5-01f939d1df66" />
    <type>data</type>
    <backup>true</backup>
    <storage>
        <type>iscsi</type>
    </storage>
</storage_domain>
```

#### Import the FCP Storage Domains to the setup

```xml
POST /api/storagedomains/ HTTP/1.1
Accept: application/xml
Content-type: application/xml

<storage_domain id="ecf053fc-fe65-4d64-883e-c38ca898951c">
    <import>true</import>
    <host id="9d05868b-d40d-4a8c-9a81-dbf09d654fba" />
    <type>data</type>
    <backup>true</backup>
    <storage>
        <type>fcp</type>
    </storage>
</storage_domain>
```

#### Import NFS Storage Domain

Importing a Storage Domain requires a POST request, with the storage domain representation included, sent to the URL of the storage domain collection.

```xml
POST /api/storagedomains HTTP/1.1
Accept: application/xml
Content-type: application/xml

<storage_domain>
    <name>data1</name>
    <type>data</type>
    <backup>true</backup>
    <host id="052a880a-53e0-4fe3-9ed5-01f939d1df66"/>
    <storage>
        <type>nfs</type>
        <address>10.35.16.2</address>
        <path>/export/images/rnd/maor/data9</path>
    </storage>
</storage_domain>
```

The API creates an NFS data storage domain called data1 with an export path of 10.35.16.2:/export/images/rnd/maor/data9 and sets access to the storage domain through the hypervisor host.
