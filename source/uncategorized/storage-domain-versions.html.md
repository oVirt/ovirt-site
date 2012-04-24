---
title: Storage Domain Versions
authors: fsimonce, smizrahi
wiki_title: Storage Domain Versions
wiki_revision_count: 11
wiki_last_updated: 2012-05-08
wiki_warnings: references
---

# Storage Domain Version 0

# Storage Domain Version 2

# Storage Domain Version 3

The storage domain version 3 has been introduced in VDSM on the 30th of January 2012 with the commit 8665716c: Use SANLock for the SPM resource [1]. The new format has been introduced to overcome some of the limitations present in the previous formats (with regard to live snapshots, live merges and internationalization) and mainly to introduce the use of SANLock [2].

### Changes

#### VDSM and Format

*   Use SANLock to acquire the SPM resource [3]
*   Use SANLock to acquire the volume resources (virtualization subsystem, libvirt) [4]
*   In block domains the permissions of the LVs in the metadata are always RW (to allow live snapshots and live merges)
*   Support unicode in the domain and pool description [5]
*   New mailbox format (in progress)

#### Engine and GUI

*   Display the Storage Domain Version (already present in the "Storage" tab)
*   Support the creation of Storage Domain V3
*   Accept unicode strings for the descriptions (only V3)
*   Block the import of VM containing unicode to V2 domains
*   Prevent moving Storage Domain Version V3 to 3.0 Data Centers

### Required Actions On Upgrade

#### VDSM

*   Initialize the resources for all the volumes in the domain
*   Set all the LVs to RW
*   Check that the volume SIZE in the metadata is consistent with the block size (RAW) or with the qcow2 virtual size (COW) [BZ811880](https://bugzilla.redhat.com/show_bug.cgi?id=811880), [BZ611183](https://bugzilla.redhat.com/show_bug.cgi?id=611183), [BZ706014](https://bugzilla.redhat.com/show_bug.cgi?id=706014)

#### Engine and GUI

### REST API

The operation is driven by pool compatibility change. So there is no need for a new REST API.

### Requirements

*   All nodes in the cluster must have 5a0b2c9 "Do not lock the image when preparing the VM path" (vdsm >= 4.9.4) to avoid the LVM mda corruption

### Upgrade

At the moment it is planned to support an automatic upgrade to version 3 from the previous versions.

![](DomainUpgrade1.png "DomainUpgrade1.png")

### References

<references>
` `[6]

</references>

[1] 

[2] <https://fedorahosted.org/sanlock>

[3] 

[4] <http://gerrit.ovirt.org/1253>

[5] <http://gerrit.ovirt.org/637>

[6] [`http://gerrit.ovirt.org/726`](http://gerrit.ovirt.org/726)
