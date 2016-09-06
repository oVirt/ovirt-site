---
title: Disaster recovery for gluster storage domains
category: feature
authors: Sahina Bose
wiki_category: Feature|DR for gluster storage domains
wiki_title: Features/Gluster DR
wiki_revision_count: 122
wiki_last_updated: 2015-10-14
feature_name: Disaster recovery for gluster storage domains
feature_modules: engine,gluster,geo-replication,storage
feature_status: Design
---

# Disaster recovery for gluster storage domains

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>

## Current Status

*   Status: Design
*   Last updated date: 2 Sep 2016

## Requirements

* Provide a mirror of the oVirt DC to a secondary site at a different location, so that in case of disaster, the data at the secondary site can be used to bring the enviroment back online
* The replication/mirroring of data is periodic which is configurable by the user. The replication interval will determine how far behind the data at the secondary site is. The solution does not aim to provide continuous data protection
* Allow monitoring the progress/status of replication
* DR solution should not affect the functioning of the oVirt deployment - that is, no performance hits, no VMs being stopped or paused.

## Solution
Gluster provides a way to replicate/mirror a gluster volume to another remote location using a feature called [Geo-replication](https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Geo%20Replication/). This offers a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet. Since glusterfs 3.7.9, there's a periodic geo-replication script available that will checkpoint the data at any given time and ensure all checkpointed data is replicted to configured secondary site.(known as `slave gluster volume` in gluster parlance)

Since oVirt uses gluster volume as storage domains, we can make use of this feature to provide a DR solution for gluster storage domains.
However, simply enabling geo-replication on gluster volumes used as storage domain will not suffice. Geo-replication will continue syncing all I/O even after the checkpoint time until all data at checkpoint has been transferred. This could lead to data inconsistencies at the secondary site. To avoid this and to ensure that all IO has been coalesced to disk before syncing to secondary site (or slave), we will need to take a snapshot of the VMs running on the storage domain. Any data that is written post the snapshot, though transferred to secondary site will be discarded as it is in a separate overlay image file.

If we were to perform the above via script, the steps would be:

1. Establish connection to running oVirt engine 
2. Query for list of running VMs
3. Create snapshot of all running VMs to ensure that data is quiesced and in a consistent state at the secondary site
4. Execute the georep_scheduler script that:
    - creates a checkpoint
    - starts geo-replication, copying files from master volume (storage domain) to the slave volume located at central backup site
    - Stops the geo-replication session once checkpoint is completed
5. Mount the slave volume from secondary site and delete the external snapshot image file (overlay image) that was created as part of script
6. At oVirt engine, delete the created snapshots via API that will call live merge of image
7. On completion, post an event to oVirt. The event is an Alert with error message in case the process did not complete successfully. Successful completions are noted as normal events. Administrator can subscribe to external events to receive the events via email.

Such a script is already available at [ovirt-georep-backup](https://github.com/sabose/ovirt-georep-backup)

To integrate this better into oVirt and provide users a seamless way of managing and monitoring the DR solution, we need enhancements to this approach. Sections below will outline the design to do so.

## Enhancements

### UX

* Allow enabling sync for disaster recovery on storage domain. This will currently be available for gluster storage domains alone, but can be extended to cover other storage domain types later

![StorageDomain-DR](storagedomain-dr.png)

* If a gluster storage domain is enabled for sync, check that a geo-replication session has been created. If not, provide an alert that geo-replication session needs to be setup. Geo-replication session can be setup from the UI using the Geo-replication sub-tab under Gluster volumes. The **Create Geo-replication Session** will also be opened on clicking the suggestion provided in the alert

![StorageDomain-DR-Alert](storagedomain-dr-alert.png)

* Create a sub-tab under Storage domain for **DR setup**
    - DR sub-tab only shown for glusterfs storage types
    - Display the current schedule for sync and the last run status
    - Provide a way for user to edit the schedule for sync. Clicking on the ... button will open a dialog

![StorageDomain-DR-Setup](dr-setup.png)

### Database changes

* Extend the storage domain table `storage_domain_static` with following additional columns
    - enable_sync boolean
    - gluster_volume_id UUID *stores the gluster volume uuid if the gluster volume is managed by oVirt, this will allow to check and alert for geo-rep session*

* Additional table `storage_domain_dr` with following columns
    - storage_domain_id uuid
    - sync_schedule varchar *stores the cron expression for recurring schedule*
    - qrtz_job_id varchar *stores the quartz job created*

### Design changes

![DR-Sequence-Diagram](gluster-dr-seq-diagram.png)
