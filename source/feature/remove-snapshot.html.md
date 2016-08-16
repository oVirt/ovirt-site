---
title: Remove Snapshot
category: feature
authors: ahino
wiki_category: Feature
wiki_title: Remove Snapshot
wiki_revision_count: 20
wiki_last_updated: 2016-08-11
feature_name: Remove Snapshot
feature_modules: engine,vdsm
feature_status: Released
---

# Remove Snapshot

## Summary

Use qemu-img commit instead of qemu-img rebase when deleting snapshots while the VM is down.

## Owner

*   Name: Ala Hino
*   Email: <ahino@redhat.com>

## Terminology

This feature page is about removing snapshots when the VM is down. As today we use 'Live Merge' when removing snapshots while the VM is running, I will use 'Cold Merge' when referring to removing snapshots while the VM is down.

## Detailed Description

Initially, when Cold Merge feature implemented, qemu-img didn't support 'commit' operations hence, qemu-img 'rebase' performed. In certian use cases, qemu-img rebase could take long time, especially when the base volume is significantly larger than the top volume. In these use cases, Live Merge was faster!

Now that qemu-img support 'commit' operations, we want to use this support to implement Cold Merge.

## Benefit to oVirt

Removing snapshots will work faster also when the VM is not running.

## User Experience

TBD

User experience changes as now we are going to copy top volume data into base. The main change is related to failures and recovery from failures.

## Design

Today, the Engine uses Async task mechanism, invokes 'mergeSnapshots' verb and monitor the task. At Vdsm side, Vdsm calls qemu-image rebase deletes the volume after rebase completes. In case of failure, no special recovery is required and the admin can simply try again to remove the snapshot.

Now, that we want to enhance removing snapshots, we have to keep in mind the following inputs:

* Spm is a bottleneck and we want to reduce Spm tasks as much as possible
* Live and cold merge flows are equivalent so it is a good chance to have a single the implementatin for both flows. The flow is basically contains following steps:

    * Merge
    * Monitor merge job
    * Check merge status
    * Destroy image

By using a single flow we will have the major advantage of maintaining a single code base rather than two and, moving forward, when we add a progess bar for these operations, we don't have to do the support for two different flows.

### Engine

As the engine needs to be backward compatible, the engine has to identify based on the DC level whether this feature is supported or not. For DC level 4.0 and above the engine will run the new flow described below:

* Merge

  Use new Vdsm verb to do the Cold Merge

* Monitor

  Use host jobs to monitor this operation. TBD
* Status

  After the job completes, verify that the volume removed from the chain
* Destroy

  Remove the volume after merge successfully completed


### Vdsm

TBD; points to keep in mind:

* New a-la SDM verb to support this feature
* Host task

### Recovery

As briefly mentioned before, today no recovery special handling is required because we copy data from base volume to top. This copy cannot end with data corruption hence, on failures, the admin simply needs to retry. However, when using qemu-img commit, data is copied from top to base, similar to Live Merge. In this case, recovery isn't as trivial as today because we have to identify when that failure happened:

* Engine reboot during Cold Merge

  If engine goes down during Cold Merge, there are two options when it comes up again:

  * The job still exists at the storage. In this case, we continue monitoring the job

  * The job doesn't exist at the storage. In this case, as done in Live Merge, we continue to Merge Status and check whether the volume exists in the chain. If not, we continue the flow. Otherwise, we fail the operation

* Vdsm reboot during Cold Merge

  TBD

* Vdsm fails to get Engine command

  Operation fails and the admin needs to try again

* Vdsm fails to return response to Engine

  Usually engine gets timeout once fails to get Vdsm response. In this case, again as done in Live Merge, the operation fails and the admin needs to try merge again. However, where in Live Merge reporting errors to engine was naive, in this case Vdsm will report the exact errors to the engine: a job is running, base/top doesn't exist, etc.

## Security

No new consequences here; what run before this feature will behave the same wrt security and according to TLM

## Upgrade

Following table describes the behavior of the available deployments:

|             | Old Engine      | New Engine                 |
|-------------|-----------------|----------------------------|
| Old Vdsm    | qemu-img rebase | qemu-img rebase            |
| New Vdsm    | qemu-img rebase | qemu-img commit            |


## Hosted Engine

No effects is expected on hosted engine deployments

