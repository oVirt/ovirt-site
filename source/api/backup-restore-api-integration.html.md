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

This feature provides the ability for ISVs to backup and restore VMs. New set of APIs will be introduced in oVirt to facilitate taking full VM backup, as well as full or file level restore of VMs. Backup and Restore will be REST API driven (and not GUI/User driven).

### Owner

*   Feature owner: Ayal Baron <abaron@redhat.com>
*   Engine Component owner: Liron Aravot <laravot@redhat.com>
*   VDSM Component owner: Deepak C Shetty <deepakcs@linux.vnet.ibm.com>

### Current Status

*   Live snapshot : Done. Available in oVirt.
*   Live Merge: To be integrated in oVirt
*   Qemu-ga: To be integrated.
*   VDSM support : <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:backup-restore,n,z>
*   oVirt Engine / API support : <http://gerrit.ovirt.org/#/c/16284/3>
*   UI support : N/A

### Detailed Description

The backup machine will protect virtual machines by offloading backup workloads to a centralized server and providing multiple restore capabilities.

### High Level Architecture

There will be 1 Backup Appliance per DC. The Backup Appliance can be in the form of a Virtual Appliance (VirtApp) or Host Appliance (HostApp). **Currently we are targetting VirtApp usecase, HostApp usecase will be targetted later.** Backup & Restore will be driven by API and not GUI. Backup/Restore software from ISV will drive these APIs

### Full VM restore

The entire VM is restored to the state it existed when it was originally backed up.

### Full VM backups

Back up an entire virtual machine to the backup machine storage as a single object (image). This is an entire VM image snapshot, which is a single snapshot that contains all of the VM disks. All data is backed up at the disk block level. The data can then be restored to a disk, or mounted as a virtual volume for an individual file restore. These backups are managed and retained according to storage policies set up by the backup machine administrator.

### File level restore

File level restore can be performed in-guest or off-host. Mount the volumes of the VM backup as a virtual volume. Then, copy the files that you want to restore.

#### Full restore to source VM

#### Full restore to a new VM

#### Single file level restore (Typically to source VM, or other VM)

### Full restore to source VM

### Full restore to a new VM

### Single file level restore (Typically to source VM, or other VM)

### High level flow of Backup Process

1.  Contact the ovirt-engine containing the target virtual machine.
2.  Command that ovirt-engine to produce a snapshot of the target virtual machine.
3.  Use the ovirt-engine to gain access to the virtual disk(s) and files in the snapshot.
4.  Capture the virtual disk data and virtual machine configuration information.
5.  Command the ovirt-engine to remove the backup snapshot.

### High level flow of Restore Process

1.  Contact the ovirt-engine.
2.  Command the ovirt-engine to create a new virtual machine and its virtual disks using the configuration information in step 4 of the backup process above.
3.  Transfer the virtual disk data to the newly created virtual disk(s).

### REST API flow for VirtApp usecase

#### Following API calls will be needed for backup –

1.  create vm snapshot (the api call exists today)
2.  get VM Config (new API)
3.  Attach disk == Create a temp. r/w snapshot and hotplug it into the VirtApp
4.  <... The backup s/w will backup the data ...>
5.  Detach disk == Hotunplug the temp. snapshot from the VirtApp

#### Following API calls will be needed for restore (to confirm)–

1.  create vm (vmconfig)
2.  prepare restore (hostid)
3.  attach disk()
4.  tear down restore()
5.  detach disk()

### User interface

N/A

### This feature will be implemented in phases:

1.  Phase1 will cover Full backup/restore for VirtApp usecase. File level restore (non-agent based) should be possible (to confirm).
2.  Phase 2 will cover HostApp usecase and supporting qemu-ga for Win. guests (depends on the ongoing qemu-ga work in the community).
3.  Phase 3 will cover Change Block Tracking (CBT) to cover incremental backups. This also depends on the ongoing community work in qemu block layer to provide differential info.

### Benefits to oVirt

Add the ability to do full , file-level & incremental backups/restores of a running VM.

### Dependencies / Related Features and Projects

*   Live Snapshots - already available in oVirt.
*   Temp. / Transient snapshot - need to add support in oVirt.
*   LiveMerge - needs support in oVirt. Has some dependencies on Qemu supporting the same.

### Documentation / External references

*   <http://www.ovirt.org/Live_Snapshots>
*   <http://www.ovirt.org/Features/Design/LiveMerge>

### Comments and Discussion

### Recommendations:

*   In order to capture the virtual machine configuration information, a flat OVF new API will be required. The flat OVF will have no snapshots and will contain only current virtual hardware configuration. The following calls will need to be addressed:

1.  Create VM from flat OVF: a new API call for creating a VM from flat OVF (will create a VM entity and empty disks, (make all disks on block domains "preallocated". (thin provisioning will be covered in later phase). This API can be an extension of today's 'import' but without expecting to copy disk data.

*   Block Device ID management considerations: method to track the device ID once attached to the Backup virtual appliance.
*   Support for LAN-Free backup: oVirt provide SAN access to the disk devices out of the box.
*   We should just name the snapshot with a proper prefix (e.g. "TSM Backup") to make it clear what it's about.

### Future Work

See phases section above

#### Incremental VM backups

Back up only the virtual machine data that has changed since the last backup. All data is backed up at the disk block level.

#### Differential VM backups

Backup all the changes since the last full backup. Differential backup is a cumulative backup of all changes since last full backup. Incremental backup contains only the changes since the last incremental backup whereas differential backup contains all changes since the last FULL backup.

#### Guest Quiesce for application-level consistency

##### Windows:

The Backup and Restore API will provide integration with Microsoft Windows Volume Shadow Copy Service (VSS) using qeum-ga. The VSS provider registration will be made in the guest level as part of the Guest Tools deployment.

##### Linux:

Qemu-ga provides filesystem-level consistency for Linux, a hook can be executed to allow online disk snapshot for online-backup with application-level consistency of the snapshot image. A hook can provide the opportunity to quiesce applications before the snapshot is taken on fsfreeze-freeze/thaw.

#### Portability of VMs

*   The backup product should be able to recover a virtual machine to another location (host, storage, network etc.) without having to manually edit the OVF information. There should be a mechanism to indicate that virtual machine configuration information is going to be applied to a new location. The backup product should have the ability to indicate " use this OVF file to define the configuration and use this new host destination". Not every single parameter inside the configuration should be allowed to be overwrittten - the most important are the host, storage and network paramenters which could be set to alternate locations.
*   virtual machine configuration information should be documented clearly for the customer so that the user understands what parameters can be preserved by a backup product.

### Open Issues

<Category:Feature>
