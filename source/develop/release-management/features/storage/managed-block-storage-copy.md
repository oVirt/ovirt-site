---
title: Managed Block Storage Copy
category: feature
authors: bzlotnik
feature_name: Managed Block Storage - Copying
feature_modules: storage,engine,vdsm
feature_status: WIP 4.4.6
---

# Managed Block Storage Copy

## Summary
The motivation for this feature is to allow users to copy disks from regular Storage Domains to Managed Block Storage Domains. 

### Owner
*   Benny Zlotnik (<bzlotnik@redhat.com>)

### Benefit to oVirt

This enables migrating existing VMs to Managed Block Storage domains, as well as enabling usage of features not yet available for Managed Block Storage, like Import from Glance and Image Upload.

### User Experience

At the time of writing this page it is only possible to perform the copying with the REST API, for example:
`POST http://engine:8080/ovirt-engine/api/disks/51b7f988-1c96-4d3c-892c-622499930e5f/copy`
```xml
<action>
  <storage_domain id="33a0885e-2672-414a-8b79-c7026b0b1570"/>
  <disk>
    <name>centos83</name>
  </disk>
</action>
```

Eventually copying using the UI will be possible as well.

### High Level Flow

The general flow of copying from a regular Storage Domain (Block/File) to Managed Block Storage Domain is:
1. Create a Managed Block Storage disk
2. Attach the disk to a Vdsm host that will perform the copying
3. Create an external lease, writing relevant metadata on the lease's LVB storage
4. Perform the copy
5. Detach the Managed Block disk from the host
6. Remove the lease

This features offers similar semantics to those of `SDM.copy_data`, and is implemented using storage jobs.
The progress of the copy is monitored using the `Host.get_jobs` Vdsm verb.
If the connection with the host is lost and it is not longer reporting the job's status, the lease will be used to determine the jobs status.

#### LVB

LVB (Lock Value Block), is a block on a sanlock lease the can be written and read from using [set_lvb](https://pagure.io/sanlock/c/2ea4446a06079a71266fd9f5066dd2909c7546d6?branch=master) and [get_lvb](https://pagure.io/sanlock/c/9034b7b9c7bae930c57de9d96dd8280343baf5f1?branch=master). The size of the block is the sector size of the storage, in Vdsm we use only 512 bytes which is compatible with all storage types.
To write or read LVB, the lease has to be acquired with the [LVB flag](https://pagure.io/sanlock/c/4e36aad261de84c44318f4e14549cacb2578d913?branch=master)

Since Managed Block Storage copy aims to offer similar semantics as regular disk copy, the state of the copy_data job has to be stored on shared storage. In regular copy this is done using volume leases where the state of the job (generation) is stored on the volume's metadata. Because Managed Block Storage disks are not managed by vdsm, so instead, the state is stored on an external lease's LVB area.

#### Vdsm

##### CopyDataExternalEndpoint
A new endpoint `CopyDataExternalEndpoint` was [added](https://gerrit.ovirt.org/c/vdsm/+/112801/20/lib/vdsm/api/vdsm-api.yml) to represent a target volume that is not managed by vdsm. This endpoint is meant to be a general purpose endpoint for volumes that are not managed by Vdsm.

##### Lease.create
The `Lease.create` verb was [modified](https://gerrit.ovirt.org/c/vdsm/+/113672) to accept to receive a `metadata` parameter


#### Lease.status
`Lease.status` which was previously not implmeneted is now [used](https://gerrit.ovirt.org/c/vdsm/+/113718/19), it is used to determine the job's status when we cannot receive information from the host using `Host.getJobs`.

#### Lease.fence
A new verb `Lease.fence` was added to perform fencing on the lease. The only type of fencing currently implemented is job fencing, in which the job's status is updated to `FENCED` and the generation is increased by 1.

#### Engine

A new sublcass `CopyManagedBlockDiskCommand` to handle copy operations involving Managed Block Storage disks. This class is responsible for coordinating the operations required for the copy:
1. Create target disk using `AddManagedBlockStorageDiskCommand`
2. Attach the disk to the host using `ManagedBlockStorageCommandUtil#attachManagedBlockStorageDisk`
3. Create lease using `AddExternalLease`, this creates an external lease with metadata that looks like:
    ```json
    {
    "generation": 0,
    "job_status": "PENDING",
    "job_id": "20e62244-19ad-46b7-afcc-a5fe2007a259",
    "type": "job",
    "host_hardware_id": "6e11cad3-2214-4e1a-aadc-e050accfe3c0",
    "created": 1614073237,
    "modified": 1614073237
    }
    ```

    Engine passes the `job_status`, `job_id` and `type` fields, the rest is added internally in Vdsm by `Lease.create`.
4. Run the `SDM.copy_data` verb with `CopyDataCommand`. Similar to `CopyImageGroupWithDataCommand`, the status `SDM.copy_data` is polled using `Host.get_jobs`.
 * If we couldn't get information using `Host.get_jobs`, the polling will use `ExternalLeasePoller`.
   * `ExternalLeasePoller` uses `Lease.status` to check the status of the job:
     * If the lease is owned, the job is considered still running
     * If the lease is free:
       * Job status is "SUCCEEDED", the operation will complete successfully
       * Job status is "FAILED" or "FENCED" the operation will fail
   * If we couldn't get the job's status using `ExternalLeasePoller` (`Lease.status` failed), `Lease.fence` will be invoked, updating the job's status and increasing the generation
1. When `SDM.copy_data` completes, detach the volume using `ManagedBlockStorageCommandUtil#disconnectManagedBlockStorageDeviceFromHost`
2. Remove the external lease with `RemoveExternalLeaseCommand`

### Open Issues / Limitations
- No UI support currently, will be added soon.
- There is currently no proper handling when detaching the Managed Block Storage volume fails. This affects other flows, such as VM power-off and will fixed along with it.
