---
title: VM Leases
category: feature
authors: nsoffer
feature_name: VM Leases
feature_modules: engine,vdsm
feature_status: Design
---

# VM Leases


## Overview

This feature adds the ability to acquire a lease per VM on shared
storage without attaching the lease to a disk. With a VM lease, we gain
two important capabilities; avoiding split-brain, and starting a VM on
another host if the original host becomes non-responsive.  The later
capability will be used to improve availability of HA VMs.


## Owner

- Name: [Nir Soffer](https://github.com/nirs)
- Email: <nsoffer@redhat.com>


## Detailed Description


### How it works

When creating or upgrading a storage domain to version 4, vdsm will
create a new special volume for external leases, named "xleases". This
volume will be used for external leases such as VM leases. Vdsm uses
this volume to create sanlock resources, and maintain the mapping from
lease id to lease offset on the volume.

When creating a new VM, a user will be able to add a lease on one of the
storage domains. During VM creation, engine will ask the SPM to create a
lease for the VM. Vdsm will create a new sanlock resource on the
selected storage domain. Vdsm will also update the mapping from the
lease id to the lease offset in the xleases volume.

When starting a VM with a lease, engine will add a lease device to the
VM device list with the storage domain. Vdsm will fetch the lease
details from the xleases volume, and complete the lease device XML.

When libvirt starts a VM with lease devices, the QEMU process is
acquiring the sanlock resource.  If the VM is already running on another
host, sanlock will fail to acquire the lease, and starting the VM will
fail. If a host loses access to storage, sanlock will terminate the QEMU
process, ensuring that the VM cannot access any disks.

If a host becomes non-responsive, and fencing the host is not possible,
for example, because the host lost power, the host does not have a power
management device, or fencing the host fails, the system will be able to
learn about the VM lease state, and if the lease is not acquired, start
the VM on another host. This capability is based on the fact that
sanlock will terminate processes holding a resource on storage when
storage it not reachable.

When a VM is deleted, engine will ask the SPM to remove the lease for
this VM. Vdsm will remove the sanlock resource and the mapping from
lease id to lease offset on the xleases volume.

If the mapping from lease id to lease offset becomes stale, vdsm can
rebuild the mapping by reading the sanlock resources in the xleases
volume. This should not be needed normally.


### New vdsm API

We will add these types and methods to Vdsm API:


#### LeaseDescriptor

Identifier for a lease, used to create or remove leases.

A mapping with these keys:
- sd_id (uuid): storage domain where lease is stored
- lease_id (uuid): unique id of this lease


#### LeaseInfo

Information about a lease.

A mapping with these keys:
- sd_id (uuid): storage domain id where lease is stored
- lease_id (uuid): unique id of this lease
- path (string): path to disk with this lease
- offset (uint): offset in path
- status (LeaseStatus): whether lease is free or acquired


#### LeaseSatus

The status of a lease reported by sanlock.

Enum with these values:
- "FREE": lease is not acquired by anyone
- "EXCLUSIVE": lease is acquired by one owner
- "SHARED": lease is acquired my multiple owners (not supported yet)


#### Lease.create(job_id, lease)

Starts a job creating a lease on the xleases volume in the lease storage
domain.  Can be used only on the SPM.

Creates a sanlock resource on the domain xleases volume, and mapping
from lease_id to the resource offset in the volume.

Arguments:
- job_id (uuid): identifier for tracking job status
- lease (LeaseDescriptor): lease descriptor

This is an asynchronous operation, the caller must check the job status
using using Host.getJobs.

If the job does not exist, the caller can use Lease.info to check the
lease status.

If the SPM host becomes unresponsive, the caller must wait until the SPM
move to another host.


#### Lease.delete(job_id, lease)

Starts a job removing a lease on the xleases volume of lease storage
domain. Can be used only on the SPM.

Clear the sanlock resource allocated for lease_id, and remove the
mapping from lease_id to resource offset in the volume.

Arguments:
- job_id (uuid): identifier for tracking job status
- lease (LeaseDescriptor): lease descriptor

This is an asynchronous operation, the caller must check the job status
using using Host.getJobs.

If the job does not exist, the caller can use Lease.info to check the
lease status.

If the SPM host becomes unresponsive, the caller must wait until the SPM
move to another host.


#### Lease.info(lease)

Returns info about a lease

This will return errors if no lease is allocated, the mapping for lease
is stale and needs update, or storage cannot be accessed.

Arguments:
- lease (LeaseDescriptor): lease descriptor

Returns: LeaseInfo


#### Lease.rebuild(job_id, sd_id)

Starts a job rebuilding the mapping from lease ids to offset in the
xleases volume in the specified storage domain.  This may be needed if the
mapping becomes stale. Can be used only by the SPM.


#### Lease.host_status(host_ids)

Returns host lease status on each storage domain specified in host_ids
map.

host_ids is a map from storage domain id (uuid) to host id (int).

Returns a mapping from storage domain id (uuid) to host status (enum)
for each storage domain specified.

Lease status becoming DEAD implies that no process is holding a
sanlock resource on the storage domain. VMs with a lease were terminated
by sanlock on that host. If sanlock could not terminate a process
holding a resource, sanlock rebooted the host using the host watchdog.

Engine can use this API to tell if it is possible to start a VM
using a VM lease on another host.

This verb is implemented since ovirt-3.5 as internal verb, we will make
this API public in 4.1.
See https://gerrit.ovirt.org/29157


### xleases volume operation


#### volume format

The first lease slot (offset 0) in the xleases volume is used for the
index, mapping from lease id to lease offset.

The first block of the index (offset 0) is used for index metadata:
- format (string): "1"
- status (string): "legal"| "illegal" whether index needs rebuilding
- modified (int): last modification time of the metadata block

The next 3 blocks after the metadata block are reserved for future
extension. The first lease record block is block 4.

Each record block contains 8 lease records when using block size of 512
megabytes, or 64 lease records with block size of 4096.

A record is 63 bytes string with these fields:
- state: The state of this record. Possible values are:
         - "USED" - a sanlock resource exists for this offset.
         - "FREE" - a sanlock resource does not exits for this offset
         - "STAL" - record needs update from storage
- lease_id: use as sanlock resource name
- modified: last modification time of this record formatted as string.
- padding: the rest of the record is filled with "0" characters

The fields are separated by ":", and terminated by "\n". This make it
easy to inspect the index using standard tools such as less or grep.


#### xleases volume thin provisioning

On block storage, the volume will be created during creation of a
storage domain, when we create the special lvs. The initial size will be
1G, holding 1023 leases.

Upon request to create the 1024th lease, we will extend the volume,
adding the next 1G chunk. We can support about 16G xleases volume, the
size is limited by the size of the index (1M).

On file storage, we will create a sparse file.


#### Formatting xleases volume

Formatting the xleases volume include these operations:

- mark index as illegal, writing metadata block with "ILLEGAL" state.
- clear lease area on volume
- mark all records as free
- mark index as legal by writing metadata block with "LEGAL" state.

Possible failures:

- error accessing storage - operation can be retried


#### Adding a lease

Adding a lease include these operations:

- check index state
- lookup lease in index
- find first free lease record
- extend the xleases volume if needed
- add stale record for lease id
- add sanlock resource at the associated offset
- mark lease record as used

Possible failures:

- index is illegal - index needs rebuilding
- lease already exists - caller can use the lease
- no space for new lease - the index is full, caller should create a
  lease on another storage domain.
- error extending the xleases volume - there is space in the index for
  new lease record but extending the xleases volume failed, caller should
  retry the operation
- error accessing storage - a stale record and sanlock resource may
  exists, caller may retry the operation or remove the lease.


#### Removing a lease

Removing a lease include these operations:

- check index state
- lookup lease in index
- mark lease record as stale
- clear sanlock resource at the associated offset
- mark lease record as free

Possible failures:

- index is illegal - index needs rebuilding
- lease does not exist - caller can use the lease
- error accessing storage - a used record, stale record and sanlock
  resource may exists, caller may retry the operation


#### Handling stale lease record

If a record becomes stale, for example ,storage error in the middle of
adding or removing a lease, we can rebuild the lease record by reading
storage using sanlock.read_resource(). If the resource exists on storage
we can mark the record as "USED". If the resource does not exists on
storage, we can mark the record as "FREE". This is a very fast
operation, reading 2 blocks from storage and writing one block.

We can rebuild single lease automatically when adding or removing a
lease, so caller can recover from storage error by retrying the
operation.


#### Rebuilding the xleases index

To rebuild the entire index by reading all the resources on storage
using sanlock.read_resource(). This takes only couple of seconds for
4000 leases when using local SSD.


### New engine API

In the REST API a user should be able to:

- Create a lease for a VM
- Delete a lease for a VM

These operations will be disabled if the VM is running.

## Benefit to oVirt

- Avoiding split-brain situation when the same VM is started twice on
  two different hosts, corrupting VM disks.

- Being able to start a VM on a another host when the original host
  becomes non-responsive. This makes oVirt usable on a stretched cluster
  setup where users had to use non-free software before.

- Using VM lease instead of disk lease, hosted engine will be able to
  use all the interesting features (e.g. snapshots, live storage
  migration, hotplug/unplug disk) that are not available when using disk
  leases. This also make it possible to put the hosted engine disk on
  Ceph storage.

- Using VM lease on storage, we will be able to fence a VM on an
  non-responsive host without fencing a host, or if fencing the host is
  not possible.


## User Experience

When a user create or edit a VM, a new "storage lease" option will be
available. The user will be able to activate this option, and select the
storage domain where the lease should be located from a list of available
storage domain. This resemble the way a user creates a new disk directly
from the create/edit VM dialog.

The default storage domain for the lease may be the storage domain where
the boot disk is located.

This option is related to HA VMs, so should probably be in the HA tab.

This option will be disabled if the VM is running, until we support live
plugging and unplugging leases from a VM.


## Installation/Upgrade

This feature does not affect engine or vdsm installation or upgrades

Upgrading of storage domain to version 4 will create a new empty xleases
special volume and format it.


## User work-flows

Once a user created a lease, the lease should be transparent to user
workflows.


## Dependencies / Related Features

This is a requirement for improving HA VMs failover feature. See
[vm-failover-with-vm-leases](../virt/vm-failover-with-vm-leases)


### Entity Description

- VM lease field
- the value is the storage domain where the lease is stored
- null means there is no lease


## CRUD

- add VM lease
- remove VM lease


## Event Reporting

- errors adding/removing leases
- VM cannot be started because lease is held by another instance
- VM lease status changes (e.g. lease becomes FAIL/DEAD)


## Documentation / External references

This feature is required for resolving
[Bug 1317429](https://bugzilla.redhat.com/1317429)


## Testing

- create VM with a lease
  - Lease.info(sd_id, vm_id) -> "FREE"

- start VM with a lease
  - Lease.info(sd_id, vm_id) -> "EXCLUSIVE"

- stop VM with a lease
  - Lease.info(sd_id, vm_id) -> "FREE"

- edit VM, remove lease
  - Lease.info(sd_id, vm_id) -> NoSuchLease error

- starting same VM twice should fail with some libvirt error about
  failing to acquire the lease

- loosing access to storage where lease is kept
  - after x timeout:
    - Lease.host_status({sd_id: host_id}) -> fail
  - after y timeout:
    - Lease.host_status({sd_id: host_id}) -> dead
    - VM will be terminated by sanlock after sanlock timeout

- sanlock cannot terminate a VM after access to storage was lost
  - host should reboot after sanlock timeout

- deactivating storage domain when VM has leases on the storage
  - VMs removed from system, or operation fails

- importing storage domain with VM leases

- OVF store must include VMs with leases on this storage, even if they
  do not have any disk on the storage.

- export VM with a lease
  - keep lease domain in the OVF?

- import VM with a lease
  - create new lease for the new VM id

- delete VM with a lease
  - remove the lease


### negative flows

- create lease failure
- remove lease failure?
- VM lease does not exists when starting a VM
- repair VM leases index


## Release Notes

XXX Write me


## Open Issues

- Support live lease updates. May be possible using current libvirt API,
  not tested yet
