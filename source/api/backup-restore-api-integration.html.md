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
*   Qemu-nbd : To be integrated.
*   Qemu-ga: To be integrated.
*   VDSM support : To be implemented.
*   oVirt Engine support : To be implemented.
*   UI support : To be implemented.
*   API support: To be implemented.

### Detailed Description

The backup machine will protect virtual machines by offloading backup workloads to a centralized server and providing multiple restore capabilities.

### High Level Architecture

There will be 1 Backup Appliance per DC. The Backup Appliance can be in the form of a Virtual Appliance (VirtApp) or Host Appliance (HostApp). qemu-nbd will be used to export the snapshot to the external world, since it provides ability to access the snapshot as a block devices and can work in both VirtApp and HostApp scenarios.

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

#### Following API calls will be needed for backup –

1.  create vm snapshot (the api call exists today)
2.  get VM Config (new API)
3.  prepare backup disk (new api, should probably accept: hostid, disk;

      - return: paths to device on host as well as map of changed blocks, eg. below
      -                 {'GUID': `<guid-of-dm-device>`, 'cbtInfo':{...}}
      - this should be called for every disk that needs to be backed up.  Note that VM snapshot takes a snap of *all* disks of the VM.

1.  attach disk to backup vm (the api call exists today. This assumes virt app) - also has to be called per disk to back up
2.  detach disk (symmetric to attach disk)
3.  teardown backup disk (symmetric to prepare backup disk)
4.  delete snap - This can only be called if VM is down today and is not mandatory in any event. Once we have live merge, it should be policy driven ( user should be able to choose whether to keep or delete)

#### Following API calls will be needed for restore –

1.  create vm (vmconfig)
2.  prepare restore (hostid)
3.  attach disk()
4.  tear down restore()
5.  detach disk()

#### Prepare backup disk

1.  Lock disk
2.  Live snapshot
3.  qemunbd,with temp snap
4.  Map the qemunbd device to the backup server (Optional: Attach disk to VM)

#### Teardown backup disk

1.  Detach the qemunbd device
2.  Stop qemunbd (this should delete the temp snap?)
3.  Unlock disk
4.  Remove backup snapshot

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
*   In order to capture the virtual machine configuration information, a flat OVF new API will be required. The flat OVF will have no snapshots and will contain only current virtual hardware configuration. The following calls will need to be addressed:

1.  Create VM from flat OVF: a new API call for creating a VM from flat OVF (will create a VM entity and empty disks, (make all disks on block domains "preallocated". (thin provisioning will be covered in later phase). This API can be an extension of today's 'import' but without expecting to copy disk data.
2.  Prepare disks for restore: same as for backup but no temp snapshot on top - need to make the nbd device available to the backup app to dump the data into.

*   The Lock disk phase in the Prepare Backup disk call, should block the certain operations during the lock state, such as delete and allow only certain operations such as disk clone.
*   Block Device ID management considerations: method to track the device ID once attached to the Backup virtual appliance.
*   Support for LAN-Free backup: oVirt provide SAN access to the disk devices out of the box.

<!-- -->

*   Please note that there are actually 2 snapshots during the backup - first snapshot is a regular VM snapshot and second snapshot is the temporary qemu-nbd snapshot.
*   Since we don't have 'live merge' then I believe we will have to present the regular snapshot as it will take up space on storage as well as prevent user from doing things.
*   Also in case of problems (even if we had live merge) it would be much more difficult for the user to take corrective action without seeing the snapshot.
*   We should just name the snapshot with a proper prefix (e.g. "TSM Backup") to make it clear what it's about.

### Future Work

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
