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

### Detailed Description

The Backup API provides set of operations that can be used for implemenating backup solution for VMs/Data using oVirt.

### High Level Architecture

The Backup Appliance can be in the form of a Virtual Appliance (VirtApp) or Host Appliance (HostApp). **Currently we are targetting VirtApp usecase, HostApp usecase will be targetted later.** Backup & Restore API will can be driven by API while some functionallities would be available by GUI as well. Backup/Restore software from ISV will drive these APIs.

## VM Backup/Restore possible flows

### Full VM backups

Full VM backup can be implemented for example by using the following oVirt capabillities:

1.  Take a vm snapshot for the vm targeted for backup - (existing oVirt REST API operation)
2.  Backup the vm configuration at the time of the snapshot (Disks configuration can be backed up as well if needed) - (added capabillity to oVirt as part of the Backup API)
3.  Attach the disk snapshots that were created in (1) to the virtual appliance for data backup - (added capabillity to oVirt as part of the Backup API)
4.  <data can be backed up>
5.  Detach the disk snapshots that were attached in (4) from the virtual appliance - (added capabillity to oVirt as part of the Backup API)

### Full VM restore

1.  Create disks for restore
2.  Attach the disks for restore to the virtual appliance (Restore the data to it)
3.  Detach the disks from the virtual appliance.
4.  Create a vm using the configuration that was saved as part of the backup flow - (added capabillity to oVirt as part of the Backup API)
5.  Attach the restored disks to the created vm.

#### DIfference between Virtual appliance and Host appliance

Currently per the design, the difference is in the way that the data is would be exposed/restored. Backup - the disks snapshot for backup should be exposed on some host so it could be mounted and backed up through the needed HostApp with the backup software. Restore - an abillity to restore the data to an ovirt disk should be introduced.

### File level backup/restore

File level restore/backed is essentially the same as the described VM backup/restore flows - as soon as the data is accessible by the backup provider the needed files can be backed up/restored.

### LAN Free backup

Support for LAN-Free backup: oVirt provides SAN access to the disk devices out of the box.

### User interface

N/A

### Current Status

*   Live snapshot : Done. Available in oVirt.
*   Live Merge: To be integrated in oVirt
*   Qemu-ga: To be integrated.
*   VDSM support : <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:backup-restore,n,z>
*   oVirt Engine / API support :
    -   Attach/Detach/Hotplug/Hotunplug Disk snapshot to a vm: <http://gerrit.ovirt.org/#/c/17679/>
    -   Add VM from configuration : <http://gerrit.ovirt.org/15894>
    -   Get snapshot vm ovf configuration: <http://gerrit.ovirt.org/#/c/16176/>
*   UI support : N/A

### This feature will be implemented in phases:

1.  Phase1 will cover Full backup/restore for VirtApp usecase as well as single file level restore
2.  Phase 2 will cover HostApp usecase and guest quiesce for application-level consistency. (depends on the ongoing qemu-ga work in the community)
3.  Phase 3 will cover Change Block Tracking (CBT) to cover incremental backups. This also depends on the ongoing community work in qemu block layer to provide differential info

### Recommendations:

*   Block Device ID management considerations: method to track the device ID once attached to the Backup virtual appliance.
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

### Open Issues

### Benefits to oVirt

Complete API providing abillity to do full , file-level & incremental backups/restores of a running VM.

### Documentation / External references

*   <http://www.ovirt.org/Live_Snapshots>
*   <http://www.ovirt.org/Features/Design/LiveMerge>

### Comments and Discussion

<Category:Feature>
