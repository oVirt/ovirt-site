---
title: Secure boot NVRAM data persistence
category: feature
authors:
  - tgolembi
  - mzamazal
---

# Secure boot NVRAM data persistence

## Summary

This feature allows retaining Secure Boot NVRAM data across VM restarts.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com

## Description

Secure boot non-volatile memory may contain keys inserted there by the guest OS.  They are used for validation of the software components loaded during boot.  In order to perform such a validation, the recently stored keys must be available also on the next VM start.  This feature adds the required functionality.

All the problems, security considerations, limitations, and implementation options are very similar to [TPM data persistence](tpm-device.html).  The implementation is also almost the same.  This feature page discusses only significant differences to TPM.

Unlike TPM, where libvirt and QEMU use external software to provide TPM emulation, NVRAM data is handled directly by libvirt and QEMU.

## Prerequisites

There are no special prerequisites for this feature.

## User Experience

NVRAM data is stored whenever UEFI SecureBoot firmware is enabled for the given VM.  It could be stored also for UEFI without SecureBoot, but since there can be some limitations initially (e.g. preventing snapshots with memory) it's better not to put unneeded restrictions on all UEFI VMs.

If the firmware is changed to a different type than UEFI SecureBoot, contingent NVRAM data is deleted from the Engine database.

NVRAM data is stored only for VMs run from oVirt.  When VMs originating from external systems are imported their secure boot data is not imported.

## Testing

It's the same as for TPM data persistence.  Note that unlike TPM, there is no special device created.
