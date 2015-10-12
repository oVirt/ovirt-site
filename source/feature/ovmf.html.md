---
title: OVMF
category: feature
authors: mpolednik
wiki_category: Feature|OVMF
wiki_title: Features/OVMF
wiki_revision_count: 10
wiki_last_updated: 2015-10-12
wiki_warnings: references
---

# OVMF

### Summary

This feature will add support for running VMs with UEFI (OVMF[1]).

OVMF is an EDK II based project to enable UEFI support for Virtual Machines. OVMF contains a sample UEFI firmware for QEMU and KVM.[2]

### Owner

*   name: [ Martin Polednik](User:Martin Polednik)
*   email: <mpolednik@redhat.com>

### Current Status

*   planning phase
*   last updated date: Fri Sep 18 2015

### Requirements

*   tianocore (the UEFI) binary - possibly SLOF[3] package
*   (possibly) q35 machine type for a VM with OVMF enabled

### Theory

What we get on our level is an OVMF binary. There are two kinds of OVMF binaries:

*   with embedded non-volatile store and
*   separate non-volatile store.

The implication of embedded non-volatile store is that for each VM we would need a separate firmware image. The size of image is:

*   non-volatile data store (128 KB),
*   main firmware volume (1712 KB),
*   firmware volume containing the reset vector code and the SEC phase code (208 KB).

The total image size is therefore 128 KB + 1712 KB + 208 KB == 2 MB[4]. For each VM, this means 2 MB of storage and separate firmware - total size equals to (numVMs \* 2) MB. Using separate non-volatile storage, only 128 KB of space is needed and single firmware image can be used for all VMs - the total size of OVMF-related files is (1920 + numVMs \* 128) KB. The size difference may not be major, but there is additional benefit of separating the non-volatile store and firmware image - the image can be updated/changed without affecting stored data.

Using the split approach is more suitable for oVirt for reasons stated above. The problem to solve is finding a way of storing the

*   firmware images on the host and
*   non-volatile storage files that are related to a VM.

Non-volatile storage files need to take into account the fact that a domain is transient, can be started on any (suitable) host in a cluster and a VM can be migrated, cloned, snapshotted... They need to be present while VM is running (from before XML creation to destruction) and readable/writable.

Libvirt supports both OVMF binary types[5]. The relevant elements are `loader` and `nvram` children in `os` element. `loader` is used for the UEFI image, `nvram` for the non-volatile store.

### Implementation Details

### Final Goal

Allow user to start secure boot enabled VM without the need to know the underlying details.

### References

<references/>
[OVMF](Category:Feature) [OVMF](Category:oVirt 4.0 Proposed Feature)

[1] <http://www.linux-kvm.org/downloads/lersek/ovmf-whitepaper-c770f8c.txt>

[2] <http://www.tianocore.org/ovmf/>

[3] <http://koji.fedoraproject.org/koji/packageinfo?packageID=14405>

[4] 

[5] <https://libvirt.org/formatdomain.html#elementsOSBIOS>
