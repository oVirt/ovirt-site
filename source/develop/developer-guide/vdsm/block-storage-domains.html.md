---
title: Vdsm Block Storage Domains
category: vdsm
authors: danken
---

# Vdsm Block Storage Domains

For block domains we use LVM for logical volume management inside the domain. We don't support just any LVM VG.

*   The VG must have it's metadata only on 1 PV. This limitation is because even when LVM reads the metadata, if it will notice discrepancy between the MD on 2 PVs it will try and reconcile it. This could cause metadata corruption when commands are being run on two hosts.
*   You must allocate at least 100MB of metadata space. VDSM boasts support for 1000s of images, this cannot happen if there is not enough room on the PV for all the volume metadata.
*   We allocate 5 "special" volumes:
    1.  metadata - contains the domain\\pool and volume metadata
    2.  inbox and outbox - used for the [mailbox](mailbox)
    3.  leases - current used by [safelease](/develop/developer-guide/vdsm/safelease/) but in the future will be used more extensively by [sanlock](/develop/developer-guide/vdsm/sanlock/)
    4.  ids - Used for nothing, exists for legacy purposes

Because we use LVM instead of a clustered file system on block device it allows us to scale linearly when multiple hosts are connected. This is done because LVM preallocates the sectors for the volumes and when the VM writes to the volume you know this sector is reserved.

