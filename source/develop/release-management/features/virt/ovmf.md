---
title: OVMF
category: feature
authors: mpolednik
---

# OVMF

## Summary

This feature will add support for running VMs with UEFI (OVMF[1]) and Q35 chipset.

## Owner

*   name: Martin Polednik (Martin Polednik)

## Current Status

*   planning phase
*   last updated date: Tue Jan 19 2016

## Q35 machine type

Q35 is QEMU's "new" virtual chipset (MCH northbridge / ICH9 southbridge). Although Q35 and OVMF are not dependant on each other, both are in the scope of this page and feature. The difference in QEMU supported chipsets (I440FX and Q35) is nicely shown at [2] and [3].

### Advantages

*   internal PCIe support
*   "future proof" for a while

### Issues

*   IDE is not supported - the cdrom has to be moved to SCSI (AHCI) bus
*   missing USB controller by default
*   SCSI (AHCI) bus has issues being detected in windows - needs more research
*   -> possibly switch to USB media for driver installation when USB controller issue is solved

## OVMF

OVMF is an EDK II based project to enable UEFI support for Virtual Machines. OVMF contains a sample UEFI firmware for QEMU and KVM.[4]

### Theory

What we get on our level is an OVMF binary. There are two kinds of OVMF binaries:

*   with embedded non-volatile store and
*   separate non-volatile store.

The implication of embedded non-volatile store is that for each VM we would need a separate firmware image. The size of image is:

*   non-volatile data store (128 KB),
*   main firmware volume (1712 KB),
*   firmware volume containing the reset vector code and the SEC phase code (208 KB).

The total image size is therefore 128 KB + 1712 KB + 208 KB == 2 MB[5]. For each VM, this means 2 MB of storage and separate firmware - total size equals to (numVMs \* 2) MB. Using separate non-volatile storage, only 128 KB of space is needed and single firmware image can be used for all VMs - the total size of OVMF-related files is (1920 + numVMs \* 128) KB. The size difference may not be major, but there is additional benefit of separating the non-volatile store and firmware image - the image can be updated/changed without affecting stored data.

Using the split approach is more suitable for oVirt for reasons stated above. The problem to solve is finding a way of storing the

*   firmware images on the host and
*   non-volatile storage files that are related to a VM.

Non-volatile storage files need to take into account the fact that a domain is transient, can be started on any (suitable) host in a cluster and a VM can be migrated, cloned, snapshotted... They need to be present while VM is running (from before XML creation to destruction) and readable/writable.

Libvirt supports both OVMF binary types[6]. The relevant elements are `loader` and `nvram` children in `os` element. `loader` is used for the UEFI image, `nvram` for the non-volatile store.

### Advantages

*   VFIO GPU assignment without VGA arbitration
*   secure boot

### Issues

*   <https://support.microsoft.com/en-us/kb/888929> - GPT support in non-server Windows (needs more research)

## Final Goal

Allow user to start secure boot enabled VM without the need to know the underlying details and use VFIO GPU assignment without VGA arbitration.

## References

<references/>
[OVMF](/develop/release-management/features/) [OVMF](Category:oVirt 4.0 Proposed Feature)

[1] <http://www.linux-kvm.org/downloads/lersek/ovmf-whitepaper-c770f8c.txt>

[2] <http://wiki.qemu.org/Features/Q35>

[3] <http://www.linux-kvm.org/images/0/06/2012-forum-Q35.pdf>

[4] <http://www.tianocore.org/ovmf/>

[5] 

[6] <https://libvirt.org/formatdomain.html#elementsOSBIOS>
