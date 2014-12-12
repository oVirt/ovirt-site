---
title: GlusterHostDiskManagement
authors: rnahcimu
wiki_title: Features/Design/GlusterHostDiskManagement
wiki_revision_count: 34
wiki_last_updated: 2014-12-22
feature_name: Gluster Host Disk Management
feature_modules: Engine
feature_status: Inception
---

# Gluster Host Disk Management

# Summary

Disk Management feature was the long time awaited feature for Gluster in Ovirt. This helps the admin to provision the storage directly from Ovirt Web admin portal instead of going to the node and do all the stuffs manually. This feature enables to configure disk and storage devices in host. On Gluster cluster, this helps to identify bricks. The configuration includes

1.  identify disk and storage devices those are not having file system.
2.  create new brick by creating new Linux logical volume or expand existing brick by exapnding Linux logical volume used for the brick with those devices.
3.  format the logical volume with xfs or selected file system if necessary.
4.  update fstab entry for the logical volume.
5.  mount the logical volume.

This document describes the design of a Disk Management feature for Gluster in Ovirt.

# Owner

*   Feature owner: Balamurugan Arumugam <rnacihmu@redhat.com>
*   Engine Component Owner: Ramesh Nachimuthu <rnachimu @redhat.com>

`*VDSM Owner: Timothy Asir `<tjeyasin@redhat.com>

# Current Status

*   Status: Inception
*   Last updated date: Fri December 12th 2014
