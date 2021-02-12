---
title: TPM devices
category: feature
authors: mzamazal
feature_name: TPM devices
feature_modules: engine,vdsm
feature_status: In development
---

# TPM devices

## Summary

This feature allows adding emulated TPM (Trusted Platform Module) devices to VMs.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com

## Description

TPM devices are useful to perform certain cryptographic operations (generating cryptographic keys, random numbers, hashes, etc.) or to store data that can be used to verify current software configuration securely.  QEMU and libvirt implement, among other, support for emulated TPM 2.0 devices, which is what oVirt uses to add TPM devices to VMs.

Once an emulated TPM device is added to the VM, it can be used as a normal TPM 2.0 device in the guest OS.

## Prerequisites

There are no special prerequisites for this feature.  Software TPM emulation in QEMU is implemented with the help of [swtpm](https://github.com/stefanberger/swtpm) package, which is installed on the host automatically together with Vdsm.

## Security

TPM device data is managed by swtpm and stored in the host file system (until the VM stops running there), in the Engine database and in exported VMs.  TPM data can also be leaked in Engine and Vdsm logs.  Whoever has access to those locations has access to the TPM data.  This is necessary to provide the data to the currently running VM or on its next start.  libvirt provides an option to encrypt the data with a key, but the key still must be stored somewhere in Engine and in the domain XML, so it's more obfuscation rather than real security and it's currently not used by oVirt.

Availability of data stored in TPM shouldn't be critical.  Its loss can cause operational problems such as a need to initialize and set up TPM data again, to audit the operating system after the TPM data is reset (lost) or perhaps even to reinstall the whole system but it shouldn't cause real data loss.  When using bare metal, one can't rely on TPM data availability either because if the hardware stops working, the data is no longer accessible.  If one uses for example a private key stored only in TPM to encrypt and decrypt file system encryption keys, then the risk of losing data stored in the file system without having proper backups is at least as big with hardware TPM as with virtual TPM.

## Limitations

TPM devices can be used only with UEFI BIOS.

Until <https://bugzilla.redhat.com/1855367> is implemented in libvirt, VMs with TPM devices cannot have snapshots with memory.  The problem is that we need swtpm data snapshot consistent with the VM snapshot, which is not possible to get without libvirt assistance.

Since the emulated TPM is a software rather than a hardware device, its data updates can get lost, e.g. when a host suddenly crashes.  Engine retrieves and stores TPM data periodically but that doesn't ensure Engine has always the latest version of the data.

There is apparently no guarantee that new swtpm versions can still read its old data.  That should be watched in testing.

## User Experience

Ideally, a TPM device would be added to each VM automatically and would be automatically available to the guest OS.  However, TPM support is a new feature and we cannot guarantee that everything is correctly supported in the underlying platform (for example, snapshots with memory are currently not working as expected).  For that reason, it's better to not add TPM devices to VMs by default for now and to make a VM option to enable or disable them per VM as needed, defaulting to the VM's template setting.

A TPM device can be enabled or disabled in the VM edit dialog, Resource Allocation tab.  If there is TPM data stored for the VM and the TPM device is disabled in the VM, the TPM data is irrecoverably deleted.

## Testing

There are two areas to test: TPM presence and data persistence.

TPM devices should be present in VMs running in clusters of versions >= 4.4 (TODO: re-check the version) when the corresponding VM option is checked.  A TPM device is present as ``<tpm>`` device in the domain XML and as a corresponding device in the guest OS (``/dev/tpm0`` on Linux systems).

Newly created VMs, or VMs that didn't have a TPM device previously, get uninitialized TPM data, there is nothing to test about it.  Once TPM data is modified by the guest OS, the modified data must be present after different operations: VM stop & start, reboot, migration, export/import, cloning, start from snapshot, etc.  TPM data updates followed by common failure scenarios (disconnected host, crashed VM, etc.) can be tested in situations where it's reasonable to assume the data updates should be available.  The data can be checked in the guest OS (most reliably) or alternatively comparing swtpm data with expected contents.

It should be also tested that VMs with TPM data created on hosts running older systems are unchanged when the VM is started on a host running the newest system.  This must be tested in the guest OS.

## Changes to Engine and Vdsm

There are no special changes needed in order to add a TPM device as such, it's just another kind of device added to Engine.

### Data persistence

A very different thing is ensuring TPM data persistence.  TPM data is managed using an external tool, swtpm.  Once the VM domain XML is deleted on the host, the TPM data is deleted as well by libvirt and it must be restored before the VM is run again, whether on this or another host (live host migrations are handled transparently and don't require any special actions on the oVirt side).

There are several options how to provide TPM data on the VM start:

- As a parameter to a VM.create API call.
- In metadata section of the domain XML.
- On a shared storage.

The hard part is how to store updated TPM data from the host reliably, making sure that:

- Data updates are not lost.
- The updated data is consistent, i.e. it can be read by swtpm correctly on the next VM start.

We cannot handle all erroneous situations (e.g. faulty hardware corrupting data) but a reasonable level of resistance against common failures should be granted.  Ideally, the following situations should be handled:

- When a VM stops for any reason on a connected host, we store the latest state of the data.
- When a host or a storage get disconnected, we store the latest known state of the data.
- When a VM is restarted without Engine assistance, it uses the final data from the last run.
- We don't store inconsistent data.  Currently used swtpm version [doesn't store changes atomically](https://github.com/stefanberger/swtpm/blob/609dfd873a31fc0402752c50d1d5cfa58949507f/src/swtpm/swtpm_nvfile.c#L492), so whether we copy swtpm data or let swtpm write to shared storage, we are at risk of race with swtpm writes on copying or when the storage gets suddenly disconnected.  This has been fixed upstream so once the update reaches Advanced Virt, there should be no longer problem with TPM data consistency within a single file.
- Temporary network disconnections, lost events sent from Vdsm to Engine or temporary failures when delivering or processing Vdsm responses to Engine don't cause permanent loss of data updates.

The options to deliver updated TPM data are similar to obtaining TPM data on VM start, with the important distinction that this time they are write instead of read operations, with the risk of data loss.  We can:

- Send the updated data to Engine in events, current API call responses (stats, destroy) or using a new Vdsm API call for the given purpose.
- Store the data in metadata, to be read and processed in Engine monitoring.
- Attach the data to dumpxmls.
- Store the data to shared storage from Vdsm.
- Let swtpm store the data directly to the shared storage.
- Some combination of the options above.

We can assume that TPM data updates are not going to be very frequent.  We mustn't forget about reboots, snapshots, imports and exports.

After considering all the options discussed in the following subsections, the following solution was selected:

- TPM data is stored in the Engine database, in a separate table.
- A new parameter providing TPM data is added to VM.create call.
- A new API call VM.getExternalData to retrieve TPM data is introduced.
- Engine calls VM.getExternalData to update the data in the database after a VM is stopped but before it is destroyed.
- If a VM is powered off rather than shut down from Engine or from within the guest, the latest available stable data is retrieved.  It may not correspond to the very final data, but this is always a risk with unclean shutdown.
- TPM data for VM snapshots is stored in `snapshots` database table.
- On VM export / import, the data is stored to / retrieved from the exported / imported VM.  The data can be stored either in OVF or as a separate resource in the OVA.  Storing the data in OVF is easier implementation wise but then the OVF could contain relatively large data (typically a few KB to tens of KB).  Storing the data as a separate resource is harder to implement but data size is not a problem.  (TODO: Update according to the actual implementation.)
- There is no support for importing TPM data when importing VMs originating from external systems.

The same approach can be used for storing secure boot NVRAM data.

#### Using API calls

TPM data can be stored in the Engine database and transferred in both the directions using Vdsm API calls.  It can be provided to the VM as an additional parameter to VM.create call.  Data changes can be reported back to Engine using:

- Events sent from Vdsm.
- As a return value parameter of VM.destroy call.
- As an additional value in VM stats.
- On a request from Engine using a newly introduced Vdsm API call.

TPM data can be copied to swtpm data location before the VM is created.  Once VM is started, updated TPM data can be read from the swtpm data location.  A problem is how to read data from swtpm consistently, avoiding collisions with swtpm writes.  Considering TPM data is small, written locally and not updated frequently, a good enough approach should be to have a periodic Vdsm job watching for swtpm data changes.  If it detects a data change, it keeps watching the data and once it detects the same data in two consecutive job runs, it can report it as changed data relatively safely (unless there is some fatal condition such as a full local disk).  This mechanism would be common to all the approaches except for shared storage directly used by swtpm.

There are some problems specific to this approach though:

- Events are not reliable and Vdsm can't be sure Engine has received and processed the updated data.
- The same applies to reporting the data in VM stats, unless we are willing to send the data, even when unmodified, on each VM stats query.
- Data read after the VM stops can be considered stable and reported directly.  However, if it is attached to VM.destroy response and the response fails for any reason, it can't be reported again in a response to a repeated VM.destroy call, because the data is already deleted after the libvirt domain has been undefined.
- A specific API call would solve most of the problems.  Vdsm could include TPM data into the computation of the VM device hash sent within VM stats and Engine could request TPM data itself if the device hash changes.  Alternatively, Engine could make the API call periodically, providing TPM data hashes as an argument, and Vdsm would respond only with data not matching the hashes.  An additional call would happen in either case just before calling VM.destroy to get the ultimate final version of TPM data.
- It is fully dependent on Engine cooperation, it's not possible to start a VM without Engine explicitly providing the data.  But if we needed just to restart a VM on the same host without Engine then we could retain TPM data by either not undefining the domain XML or by making a local copy of the data between the restarts.

This approach should be feasible with introducing a new Vdsm API call as outlined above but it has the drawback that Engine assistance is needed.

#### Storing the data in domain XML metadata

Using domain XML metadata, it's possible to transfer TPM data in all the directions.  TPM data can be read from the data on VM start, with or without Engine assistance, updates can be stored there atomically and Engine can update the data in monitoring.

Ensuring data consistency read from swtpm is the same as with API calls.

The only problem with using metadata is that it increases domain XML size significantly.  TPM data shouldn't be large although to know the size limits would require further investigation.  But initial swtpm data for a VM takes about 4 KB encoded.  It would "pollute" the domain XML and would have to be transferred each time Engine asks for the domain XML, even when there are no changes to data, which means it would be waste most of the time.

This approach is a bit simpler and more flexible than using API calls but has the data size drawback.

#### Attach the data to dumpxmls

Since TPM data is not supposed to change frequently, it can be attached to Host.dumpxmls response.  The computation of the device hash can take TPM data into account.  When Engine calls dumpxml after the hash change, it will get not only the domain XML but also the TPM data, as another item in the dictionary.  (The same approach may possibly be used also for reporting the secure boot data in future.)

Ensuring data consistency read from swtpm is the same as with API calls.

This mechanism is similar to metadata but it puts the TPM data outside of the domain XML.  It shares the property of transferring the data each time Engine asks for the domain XML (in theory, it could be optimized by not sending unchanged data if a sufficiently robust mechanism was found).

#### Using shared storage

A somewhat similar approach to using domain XML metadata would be to store the data to a shared storage.  Instead of writing to or reading it from the metadata, it would be written to or read from the storage.  The benefit would be avoiding domain XML pollution and unnecessary data transfers.  Additionally, Engine wouldn't have to process the data and maintain it in the database and the data could be updated even when Engine was temporarily unavailable.

However, there are also drawbacks:

- A volume for TPM data must be created, arranged and maintained properly.
- Vdsm is responsible for arranging atomic data updates, to avoid ending up with partially written data in case storage gets disconnected.
- Unless direct I/O is used, Vdsm can't be sure the data was actually written.

This approach would be more complicated than using metadata but it would have the advantages mentioned above.

#### Making swtpm to use shared storage directly

The swtpm data location is selected by libvirt automatically but we could probably make a symbolic link to the desired shared location.  This approach would avoid data handling on the Vdsm side and all the updates would be stored immediately.  But it shares some of the drawbacks of using shared storage and there are additional risks:

- Data consistency is at risk when storage gets disconnected during swtpm write.
- swtpm reacts to write failures [by deleting the data completely](https://github.com/stefanberger/swtpm/blob/609dfd873a31fc0402752c50d1d5cfa58949507f/src/swtpm/swtpm_nvfile.c#L563), which may fail as well, but a question is if the data is ever attempted to write again without further updates.
- We can't depend on all the swtpm implementation details.
- libvirt removes the data after domain gets undefined.  We would have to prevent that, perhaps by removing the symbolic link before undefining the libvirt domain.

The possible data consistency race would have to be solved some way (how?) to be able to use this approach.  The overall benefit of this approach depends on whether resolving the data consistency problem is easier than copying the data.

## Future work

In a future cluster version, TPM data transferred to Engine is going to be compressed to reduce the amount of data stored and transferred.

Power-off operation could be changed to call ungraceful shutdown rather than direct destroy, with destroy operation called separately once the VM gets down.  Then final TPM data could be retrieved reliably also after power-off (from the point of hypervisor, there are still no guarantees in the guest OS in case of ungraceful shutdown).  This change would require changes on the Vdsm side to be meaningful but it can be implemented (without the hypervisor guarantees) also with current Vdsm if invoking guest shutdown followed by hard destroy immediately is acceptable as a power-off operation.
