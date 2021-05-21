---
title: Data Path operations on any host
category: feature
authors:
  - aglitke
  - nsoffer
  - laravot
  - frolland
---

# Data Path Operations On Any Host

## Summary

Until now almost all data path operations on the hosts were performed only on the elected SPM, causing a potential bottleneck.
This feature enables data path operations on any host. 

### Owner

*   Adam Litke (<alitke@redhat.com>)
*   Liron Aravot (<laravot@redhat.com>)
*   Nir Soffer (<nsoffer@redhat.com>)
*   Fred Rolland (<frolland@redhat.com>)

### Detailed Description

There are a lot of data path operations in oVirt. For example: move disk, create VM from template, create template from VM, live storage migration and more.
These operations are performed on the SPM host, potentially creating a bottleneck in scale setups or if the operations are performed frequently.

By adding the new framework on VDSM, the engine is capable to convert the data path operations flows to run on any host.

### Benefit to oVirt

With this feature the load of the data operations is spread between all the hosts, preventing the throttling of the SPM host. 

### User Experience

A progress indication of the operation is available on the disks status for the "Move Disk" operation.
Otherwise, there are no changes in the user experience.


### High level flow

Here is the high level flow for "Move Disk" operation
- User starts disk move operation via UI or REST, no change is needed
- Engine clone image structure via the SPM host and existing VDSM apis
- Engine select hosts for copying volume
- Engine starts copy_data operation on selected hosts
- On each host, VDSM schedule copy_data job, copying data from source volume to destination volume
- Engine monitor jobs progress
- Engine wait until all jobs are done

For "Create VM from Template (Clone/Independent)" operation, the flow is the same as above.
The only difference is that Templates have only one volume.

### VDSM

The following verb is added:

```
SDM.copy_data:
    added: '4.1'
    description: Copy data from one volume to another.
    params:
    -   description: A UUID to be used for tracking the job progress
        name: job_id
        type: *UUID

    -   description: The source endpoint
        name: source
        type: *CopyDataEndpoint

    -   description: The destination endpoint
        name: destination
        type: *CopyDataEndpoint
```

### Engine

The engine will monitor the operation using the `Job` API.
In case the job is not present, the lease status on the volume information is retrieved from VDSM.
If the lease is not free, the job is still running.
If the lease is free, the status of the copy operation will be determined by checking the volume legality.

A configuration value is available to disable this feature: `DataOperationsByHSM`.

The following commands are added:

- CopyImageGroupWithDataCommand
- CloneImageGroupVolumesStructureCommand
- CreateVolumeContainerCommand
- CopyImageGroupVolumesDataCommand
- CopyDataCommand

In addition, the framework for tracking progress on entities is added to the infrastructure.

### Testing

- Move a disk between storage domains. Check that the operation may run on none-SPM hosts.
- Create a VM from template with clone provisioning.  Check that the operation may run on none-SPM hosts.
- Start a 'Move Disk' operation, and take down the network of the VDSM host after the operation has started.
Make sure engine can recover when the host comes back (check if the job failed or succeeded).
Make sure engine can recover if the host never comes back.


### Open Issues

- The host that will perform the data operation is currently selected randomly. A better mechanism may be needed in the future.
- In case of multiple volumes, the operation is currently performed in a serial way. In the future, it can be performed in parallel.
