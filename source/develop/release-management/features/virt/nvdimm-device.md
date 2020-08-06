---
title: NVDIMM devices
category: feature
authors: mzamazal
feature_name: NVDIMM devices
feature_modules: engine,vdsm
feature_status: In development
---

# NVDIMM devices

## Summary

This feature allows adding NVDIMM (non-volatile memory) devices to VMs.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com

## Description

NVDIMM devices provide persistent RAM.  QEMU and libvirt allow to add an emulated NVDIMM device to a VM, backed by a real NVDIMM device on the host to ensure data persistence.

This feature allows assigning host NVDIMM devices to VMs.  A new NVDIMM category of host devices is added (although technically NVDIMM devices are treated as memory rather than host devices by libvirt).

The NVDIMM device in the guest is emulated so its mode, partitioning, etc. can be reconfigured in the guest independently of the host device settings.

Information about the emulation details can be found in
[QEMU NVDIMM documentation](https://github.com/qemu/qemu/blob/master/docs/nvdimm.txt).

## Prerequisites

NVDIMM hardware is needed to test this feature.  To a limited extent, QEMU emulated devices in VMs used as hosts can be used for testing during implementation.

## Limitations

Memory snapshots are disabled when an NVDIMM device is present in a VM.  There is no way to make a snapshot of NVDIMM content and a memory snapshot cannot work correctly without having the corresponding NVDIMM data.

In oVirt, each NVDIMM device passed to a VM has an automatically assigned label area of a fixed size of 128 KB.  Having a label is required on POWER and 128 KB is the minimum label size allowed by QEMU.

The guest device size is not user configurable.  If the whole host NVDIMM device size should not be used, the device should be partitioned accordingly on the host and the corresponding partition should be used.

The guest device size may be a bit lower to be in compliance with libvirt and QEMU alignment and size adjustments.  Precise sizing is also needed in order to make memory hot plug work.

libvirt and QEMU perform their own size and label placement adjustments.  If those internal arrangements ever get changed, data loss may be experienced.

NVDIMM hot plug is not supported by the platform.

VMs with NVDIMM devices must be pinned to a host and cannot be migrated.

SELinux currently prevents access to NVDIMM devices in devdax mode, see https://bugzilla.redhat.com/1855336.

## User Experience

An NVDIMM device is added or removed to or from the VM the same way as a host device.  There is a special NVDIMM category of host devices containing NVDIMM devices available on the host.

TODO: Add a screenshot.

## Testing

A host with one or more NVDIMM devices is needed.  Testing should cover:

- Checking with the NVDIMM device on the host in all the possible NVDIMM modes.
- Checking with different NVDIMM sizes (should be achievable by partitioning).

The following should be checked:

- NVDIMM devices are visible in host devices in the Web UI.
- They can be added to the VM.
- The VM can be started and the NVDIMM device is present there (its mode is independent of the host device mode and can be changed in the guest OS).
- The NVDIMM device can be partitioned etc. in the guest OS.
- Data written to the NVDIMM device is still available after VM restart (assuming configuration of the device on the host hasn't been changed in the meantime).

Other tests common to host devices can be applied.  NVDIMM devices aren't technically host devices but they are handled as such by oVirt.

## Implementation considerations

Vdsm must report NVDIMM devices present on the host and their attributes (path, mode, size, alignment, ...).  Vdsm uses ndctl tool for that purpose and is dependent on the content of its JSON output.  Contingent changes to the ndctl output could break the functionality in future.

NVDIMM size computation on the Engine side is dependent on libvirt and QEMU internal size adjustments in order to ensure that:

- It can fit into the size of the backing device (which is a bit more complicated than just using size <= size of the backing device).
- It is properly aligned in the end result (to the architecture minimum DIMM size) to make regular memory hot plug work in the guest OS.

If the libvirt or QEMU internal adjustments ever change, it can break, misplace the label or trim data, possibly resulting in data loss.  There is currently no way to deal with that problem.  Options such as implementing automated tests to detect contingent changes or improving the QEMU and libvirt implementations are being discussed.
