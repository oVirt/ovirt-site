---
title: Backup-Restore API Integration
category: api
authors: adahms, aglitke, dpkshetty, laravot, mlipchuk, scohen, snmishra
wiki_category: Feature
wiki_title: Features/Backup-Restore API Integration
wiki_revision_count: 100
wiki_last_updated: 2014-12-28
---

# Backup-Restore API Integration

## Backup and Restore API for Independent Software Vendors

### Summary

This feature allows oVirt users to backup and restore VMs using Independent Software Vendors. New set of APIs will be introduced in oVirt to facilitate taking full VM backup, as well as full or file level restore of VMs.

### Owner

*   Feature owner: Ayal Baron <abaron@redhat.com>
*   Engine Component owner: Sharad Mishra <snmishra@linux.vnet.ibm.com>
*   VDSM Component owner: Deepak C Shetty <deepakcs@linux.vnet.ibm.com>

### Current Status

*   Live snapshot : Done. Available in oVirt.
*   Qemu-nbd : To be integrated.
*   VDSM support : To be implemented.
*   oVirt Engine support : To be implemented.
*   UI support : To be implemented.
*   API support: To be implemented.

### Detailed Description

The backup machine will protect virtual machines by offloading backup workloads to a centralized server and providing multiple restore capabilities.

### Full VM restore

The entire VM is restored to the state it existed when it was originally backed up.

### Full VM backups

Back up an entire virtual machine to the backup machine storage as a single object (image). This is an entire VM image snapshot, which is a single snapshot that contains all of the VM disks. All data is backed up at the disk block level. The data can then be restored to a disk, or mounted as a virtual volume for an individual file restore. These backups are managed and retained according to storage policies set up by the backup machine administrator.

### File level restore

File level restore can be performed in-guest or off-host. Mount the volumes of the VM backup as a virtual volume. Then, copy the files that you want to restore.

### Overview of Backup Process

1.  Contact the ovirt-engine containing the target virtual machine.
2.  Command that ovirt-engine to produce a snapshot of the target virtual machine.
3.  Use the ovirt-engine to gain access to the virtual disk(s) and files in the snapshot.
4.  Capture the virtual disk data and virtual machine configuration information.
5.  Command the ovirt-engine to remove the backup snapshot.

### Overview of Restore Process

1.  Contact the ovirt-engine.
2.  Command the ovirt-engine to create a new virtual machine and its virtual disks using the configuration information in step 4 of the backup process above.
3.  Transfer the virtual disk data to the newly created virtual disk(s).

### REST API Support

#### Two new API calls will be added –

1.  Prepare backup disk
2.  Teardown backup disk

#### Prepare backup disk

1.  Lock disk
2.  Live snapshot
3.  qemunbd,with temp snap
4.  Optional: Attach disk to VM

#### Teardown backup disk

1.  Detach
2.  Stop qemunbd
3.  Unlock

![](Tsm-int.JPG "Tsm-int.JPG")

### User interface

#### This feature will be implemented in phases:

1.  Backup will be driven by API and not GUI.
2.  Specific Independent Software Vendors Plugins

### Benefits to oVirt

Add the ability to do full and incremental disk backups of a running VM.

### Dependencies / Related Features and Projects

*   Live Snapshots
*   QEMU-NBD
*   LiveMerge

### Documentation / External references

*   <http://www.ovirt.org/Live_Snapshots>
*   <http://wiki.qemu.org/Features/Asynchronous_NBD>
*   <http://www.ovirt.org/Features/Design/LiveMerge>

### Comments and Discussion

### Recommendations:

*   Use QEMU-NBD support for temp snapshots.
*   Use LiveMerge in the Teardown backup disk unlock phase.

### Future Work

#### Incremental VM backups

Back up only the virtual machine data that has changed since the last backup. All data is backed up at the disk block level.

#### Differential VM backups

Backup all the changes since the last full backup. Differential backup is a cumulative backup of all changes since last full backup. Incremental backup contains only the changes since the last incremental backup whereas differential backup contains all changes since the last FULL backup.

### Open Issues
