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

The storage domain version 3 has been introduced in VDSM on the 30th of January with the commit 8665716c: Use SANLock for the SPM resource [1]. The new format has been introduced to overcome some of the limitations present in the previous formats (with regard to live snapshots, live merges and internationalization) and mainly to introduce the use of SANLock [2].

### Changes

*   Use SANLock to acquire the SPM resource [3]
*   Use SANLock to acquire the volume resources (virtualization subsystem, libvirt) [4]
*   In block domains the permissions of the LVs in the metadata are always RW (to allow live snapshots and live merges)
*   Support unicode in the domain and pool description [5]
*   New mailbox format (in progress)

### Required Actions On Upgrade

*   Initialize the resources for all the volumes in the domain
*   Set all the LVs to RW

### Upgrade

At the moment it is planned to support an automatic upgrade to version 3 from the previous versions.

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
