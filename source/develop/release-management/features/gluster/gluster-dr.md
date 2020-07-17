---
title: Disaster Recovery for Gluster based storage domains
category: feature
authors: Sahina Bose
feature_name: Disaster recovery for gluster storage domains
feature_modules: engine,gluster,geo-replication,storage
feature_status: Design
---

# Disaster Recovery for Gluster based storage domains

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>

## Current Status

*   Status: Design
*   Last updated date: 09 Dec 2016

## Background

There are currently DR and backup solutions available with oVirt, but these solutions either rely on backup agents running on the virtual machines or elaborate steps to configure and use the Backup APIs. In almost all cases, these rely on some third party software to sync the backed up content to a remote site. We need a fully integrated disaster recovery solution that is easy to setup and manage. In addition, the steps for recovery of data in case of disaster should be simple and clearly outlined.

If using gluster as storage backend, there is no need for third party software, as gluster provides a way to sync data from one site to any other site (remote or local). This feature page aims to provide details for this integration

## Requirements

* Data to be mirrored/synced to a secondary site (at a remote location), so that in case of disaster, the data at the secondary site can be used to bring the enviroment back online
* The data at secondary site should be in a consistent state and has to be recoverable.
* The syncing of data should be periodic and user should be able to configure the frequency. This frequency will determine how far behind the data at secondary site is.
* User should be able to monitor the progress/status of sync
* The DR syncing process should not affect the functioning of the primary site - i.e, no downtime for guests

## Solution

### Sync to secondary site

Gluster provides a way to replicate/mirror a gluster volume to another remote location using a feature called [Geo-replication](https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Geo%20Replication/). This offers a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet. Since glusterfs 3.7.9, there's a periodic geo-replication script available that will checkpoint the data at any given time and ensure all checkpointed data is replicted to configured secondary site.(known as `slave gluster volume` in gluster parlance)

Since oVirt uses gluster volume as storage domains, we can make use of this feature to provide a DR solution for gluster storage domains.
However, simply enabling geo-replication on gluster volumes used as storage domain will not ensure consistency of data. Geo-replication will continue syncing all I/O even after the checkpoint time until all data at checkpoint has been transferred. This could lead to data inconsistencies at the secondary site. To avoid this and to ensure that all IO has been coalesced to disk before syncing to secondary site (or slave), we will need to take a snapshot of the VMs running on the storage domain. Any data that is written post the snapshot, though transferred to secondary site will be discarded as it is in a separate overlay image file.


To setup disaster recovery, the first step is to configure geo-replication on gluster volume. This is a one-time activity. Master volume refers to the gluster volume used as storage domain at the primary site (source), and slave volume is the volume configured at secondary site (sync target). Steps to configure geo-replication is at [Geo-replication](https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Geo%20Replication/).

Some points to consider when setting up geo-replication

* A slave volume is required for every gluster storage domain (aka gluster volume) that needs to be backed up
* Slave volume and master volume need not be the same topology. This means that if the master volume is a replica 3 gluster volume, slave volume can be a distribute volume type
* If sharding is enabled on the master volume, then the slave volume should also have sharding enabled. The shard block sizes at master and slave does not have to match, but it is recommended that they are the same.
* Slave volume needs to have similar capacity as the master volume

![Gluster-Geo-replication](/images/wiki/gluster-dr-georep.png) 

Once the geo-replication session is configured, following steps can be scripted to ensure periodic sync

1. Establish connection to running oVirt engine 
2. Query for list of running VMs
3. Create snapshot of all running VMs to ensure that data is quiesced and in a consistent state at the secondary site
4. Execute the georep_scheduler script that:
    - creates a checkpoint
    - starts geo-replication, copying files from master volume (storage domain) to the slave volume located at central backup site
    - Stops the geo-replication session once checkpoint is completed
5. Mount the slave volume from secondary site and delete the external snapshot image file (overlay image) that was created as part of script
6. At oVirt engine, merge the created snapshots via API that will call live merge of image
7. On completion, post an event to oVirt. The event is an Alert with error message in case the process did not complete successfully. Successful completions are noted as normal events. Administrator can subscribe to external events to receive the events via email.

Such a script is already available at [ovirt-georep-backup](https://github.com/sabose/ovirt-georep-backup)

### Recovery on disaster

In the event of a disaster, the storage domain can be attached to a running instance of oVirt. 

1. A new instance of oVirt is setup with a master storage domain. A master storage domain needs to be active in oVirt to initialize the Data Center and perform further operations
2. Use the [Import Storage Domain](/develop/release-management/features/storage/importstoragedomain.html) feature to import the gluster volume from secondary site (the one setup as slave gluster volume in previous setup)
    - In case the storage domain contains the VMs and all its disks, the VMs can be imported to the new oVirt instance
    - In case the storage domain contains only floating disks (i.e not attached to any VMs or where the storage domain does not contain the VM's OS disks), the disks can be registered via GUI (see [Bug 1138139](https://bugzilla.redhat.com/show_bug.cgi?id=1138139))
        * There's currently an issue where disks with snapshots cannot be registered. The overlay image file needs to be manually deleted from the storage domain before this is possible (see [Bug 1334256](https://bugzilla.redhat.com/show_bug.cgi?id=1334256))


To integrate this solution better into oVirt and provide users a seamless way of managing and monitoring the DR solution, we need enhancements to this approach. Sections below will outline the design to do so.

## Enhancements

### UX

* Show a sub-tab for setting up data synchronization for disaster recovery on storage domain. This will currently be available for gluster storage domains alone, but can be extended to cover other storage domain types later
    - Change the path option to enable choosing gluster volume that's managed by oVirt
    - DR sync can be enabled only if the gluster volume is managed via oVirt. A warning will be displayed to user if the gluster volume is not managed by this instance of oVirt

![StorageDomain-DR](/images/wiki/storagedomain-dr.png)

* Create a sub-tab under Storage domain for **DR setup**
    - DR sub-tab only shown for glusterfs storage types
    - If the gluster storage domain is not linked to an oVirt managed gluster volume, an alert is shown in sub-tab that this feature cannot be used for selected storage domain.
    - Display the current schedule for sync, sync location and the last run status. A storage domain can possibly be backed to multiple destinations, this will be listed in table here
    - Provide a way for user to edit the schedule for sync. Clicking on an existing row and edit button will open the dialog in edit mode.
    - Clicking on Setup will open the below dialog where user can select from existing geo-rep sessions for volume and setup the schedule for data synchronisation.
        * If there are no geo-replication sessions created, instead of the drop down, an alert is shown that geo-replication session needs to be setup.A link will be provided for user to navigate to **Create Geo-replication Session**

![StorageDomain-DR-Setup](/images/wiki/storage-domain-dr-setup.png)

### Database changes

* Extend the storage domain table `storage_server_connections` with following additional columns
    - gluster_volume_id UUID *stores the gluster volume uuid if the gluster volume is managed by oVirt, this will allow to check and alert for geo-rep session*

* Additional table `storage_domain_dr` with following columns
    - storage_domain_id uuid
    - georep_session_id uuid
    - sync_schedule varchar *stores the cron expression for recurring schedule*
    - qrtz_job_id varchar *stores the quartz job created*

### Design changes

* Scheduling of the DR sync process will use the Quartz scheduler internally. (ovirt-georep-backup script used crontab to achieve this - but could only be setup on one of the hosts and HA for schedule was an issue)
* oVirt will orchestrate snapshotting the VMs, setting a geo-replication checkpoint, starting geo-replication, monitoring for checkpoint completion and deleting the snapshots created as part of process. Steps are detailed in the sequence diagram below

![DR-Sequence-Diagram](/images/wiki/gluster-dr-seq-diagram.png)

## Future work

* Sync can be configured currently per storage domain. We want to make this more granular, at VM or disk level. Support needs to be added to both GlusterFS and oVirt to enable this.
