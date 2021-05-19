---
title: Remove Snapshot
category: feature
authors: ahino
---

# Remove Snapshot

## Summary

Use `qemu-img commit` instead of 'qemu-img rebase' when deleting snapshots while the VM is down.

## Owner

*   Name: Ala Hino
*   Email: <ahino@redhat.com>

## Terminology

This feature page is about removing snapshots when the VM is down. Today, the term 'Live Merge' is used to describe removing snapshots while the VM is running. I will use 'Cold Merge' when referring to removing snapshots while the VM is down.

## Background

Initially, when Cold Merge feature was implemented, qemu-img didn't support `commit` operations hence, qemu-img `rebase` performed. When running `qemu-img rebase`, a temporary volume is created, and data is copied from base volume to the temporary volume. In certain, is not in most, use cases, `qemu-img rebase` could take long time, because the base volume is significantly larger than the top volume.

## Benefit to oVirt

Removing snapshots will work faster when the VM is not running.

## Design

### Design considerations:

* SPM is a bottleneck and we want to reduce SPM tasks as much as possible
* Live and Cold merge flows are equivalent so it is a good chance to have a single implementation for both flows. 

### Flow:

* Prepare

    Prepare step updates Vdsm metadata and must be run as SPM task.

    * Mark base volume as ILLEGAL

        Mark base volume as ILLEGAL in order to prevent running the VM while cold merge is running.

    * Update base capacity

        If top volume is larger than base volume size, update base volume capacity:
        If base volume is block and RAW, extend LV. Otherwise, update Vdsm volume metadata.

    * Update base allocation

        For now, base volume allocation is updated to worse case, i.e. to minimum of top-size + size and to maximum allocation:

        potential-alloc = base-size + top-size
        max-alloc = base-capacity * 1.1 (QCOW-OVERHEAD)
        new-alloc = min(potential-alloc, max-alloc)

        In the future the plan is to use `qemu-img map` to calculate the accurate allocation size.

* Merge

    Merge step is another data operation command and is implements as an SDM job.
    In this step, `qemu-img commit` is used to perform the merge.

* Finalize

    Finalize step updates Vdsm and qemu metadata and must be run as SPM task.

    * Update qemu metadata
    
        Update qemu metadata to reflect the chain after the merge. If the top volume is not the leaf, update its child parent to be the base volume. This is done by performing qemu-img rebase -u.

    * Update Vdsm metadata

        Update Vdsm chain to reflect the cgain after mergre. This is done by execute Image.syncVolumeChain, providing a list without the removed volume.

    * Mark base volume as LEGAL

        At this point, merge successfully completed, Vdsm and qemu chains updated, hence it is safe now to mark the base volume as LEGAL.

* Destroy image
    Remove the top volume that was merged.

### Recovery

Today, no recovery special handling is required because data is copied from base volume to top. This copy cannot end with data corruption hence, on failures, the admin simply needs to retry. However, when using `qemu-img commit`, data is copied from top to base, similar to Live Merge. In this case, recovery isn't as trivial and recovery is performed based on the failure step:

* Engine reboot during Cold Merge

  If engine goes down during Cold Merge, there are two options when it comes up again:

  * The job still exists at the storage. In this case, we continue monitoring the job

  * The job doesn't exist at the storage. In this case, as done in Live Merge, we continue to Merge Status and check whether the volume exists in the chain. If not, flow continues; oOtherwise, the opeartion fails

* No connectivity to host during Cold Merge

  Once connectivity reestablished, the engine tries to continue monitoring the job on the host. There are two options:
  
  * The job exists on the host. In this case, the engine continues to monitor it
  
  * The job wasn't found on the host. In this case, the engine checks the base value state, if it is LEGAL, the merge didn't start and the engine has to send merge command again; if the state is ILLEGAL, the engine fails the merge operation and the admin has to retry

* Vdsm fails to get Engine command

  Operation fails and the admin needs to try again

* Vdsm fails to return response to Engine

  Usually engine gets timeout when failing to get Vdsm response. In this case, as done in Live Merge, the operation fails and the admin needs to try merge again. However, where in Live Merge reporting errors to engine was naive, in this case Vdsm will report the exact errors to the engine: a job is running, base/top doesn't exist, etc.

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

