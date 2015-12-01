---
title: IOThreads Support
category: ovirt-3.6-proposed-feature
authors: tjelinek
wiki_category: oVirt 3.6 Proposed Feature
wiki_title: Features/IOThreads Support
wiki_revision_count: 4
wiki_last_updated: 2015-10-15
---

# IOThreads Support

## Support IO Threads

### Summary

Allow to configure the quemu's IO Threads from oVirt. IO Thread is a new feature of qemu - it is a separate thread outside of qemu's global mutex to which the block devices can be pinned to significantly enhancing the VM's performance.

### Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

### Current status

*   Target Release: 3.6
*   Status: done

### Detailed Description

A new checkbox has been added to new/edit VM/pool/template/instance type widget into the "resource allocation" tab. If checked, the IO Threads is enabled and by default one qemu IO Thread will be created. The user may choose to create more than one IO Thread. It is supported only in cluster level 3.6+. The IO Threads are part of instance types and are "marked" - e.g. if the VM is based on a specific instance type, this field can not be changed.

In case the IO Threads are enabled, all the disks which have virtio interface will be pinned to an IO thread using a round robin algorithm, e.g. for 4 disks and 2 threads it will be:

        disk 1 -> iothread 1
        disk 2 -> iothread 2
        disk 3 -> iothread 1
        disk 4 -> iothread 2

### External Sources

nice explanation: <http://wiki.mikejung.biz/KVM_/_Xen> patches: <https://gerrit.ovirt.org/#/q/topic:iothreads> BZ: <https://bugzilla.redhat.com/show_bug.cgi?id=1214311>

[Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature) [Category:oVirt 3.6 Feature](Category:oVirt 3.6 Feature)
