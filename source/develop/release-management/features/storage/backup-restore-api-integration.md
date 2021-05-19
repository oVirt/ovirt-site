---
title: Backup-Restore API Integration
category: feature
authors: adahms, aglitke, dpkshetty, laravot, mlipchuk, scohen, snmishra, ydary
---

# Backup-Restore API Integration

## Backup and Restore API for Independent Software Vendors

### Summary

This feature provides the ability for ISVs to back up and restore virtual machines.
A new set of APIs will be introduced in oVirt to facilitate taking full virtual machine backups, and full or file-level restoration of virtual machines.
Backup and Restore will be REST API driven (and not GUI/User driven).

### Owner

*   Feature owner: Ayal Baron <abaron@redhat.com>
*   Engine Component owner: Liron Aravot <laravot@redhat.com>
*   VDSM Component owner: Federico Simoncelli <fsimonce@redhat.com>

### Detailed Description

The backup API provides a set of operations that can be used for implementing a backup solution for virtual machines and data using oVirt.

### High Level Architecture

The Backup Appliance can be in the form of a Virtual Appliance (VirtApp) or Host Appliance (HostApp). **Currently we are targetting VirtApp usecase, HostApp usecase will be targetted later.** Backup & Restore API will can be driven by API while some functionalities would be available by GUI as well. Backup/Restore software from ISV will drive these APIs.

## VM Backup/Restore suggested flows

### General Background

The oVirt snapshot feature provides the ability to capture the status of a virtual machine at a specific point in time.
The snapshot contains the virtual machine configuration and its disks data in a static way
The underlying operation is to create for each disk in the virtual machine a new volume that will be based on the previous volume using qcow2 format, the original volume will becomes R/O and the new volume will only indicate the differences from the original volume.

The backup API use the snapshot feature to provide a temporary volume on the backup appliance.
The temporary volume will act as an active volume based on the destination snapshot of the virtual machine about to be backed up.
The new temporary volume will provide the backup appliance access to the virtual machine data.
This snapshot which is created as part of the backup API will not be exposed to the user, but will only be exposed at the system level and by the API to the backup appliance.

### Full VM Backups

Full VM backup can be implemented for example by using the following oVirt capabilities:

1.  Take a snapshot of the virtual machine to be backed up - (existing oVirt REST API operation)
2.  Back up the virtual machine configuration at the time of the snapshot (the disk configuration can be backed up as well if needed) - (added capability to oVirt as part of the Backup API)
3.  Attach the disk snapshots that were created in (1) to the virtual appliance for data backup - (added capability to oVirt as part of the Backup API)
4.  Data can be backed up
5.  Detach the disk snapshots that were attached in (3) from the virtual appliance - (added capability to oVirt as part of the Backup API)

#### Example for VM Backup

*   Use existing VM Snapshot/Create a vm snapshot (example):

`URL = SERVER:PORT/api/vms/VM_ID/snapshots`
`Method = POST (with Content-Type:application/xml header)`

```xml
<snapshot>
  <description>Virtual Machine 1 - Snapshot For Backup</description>
</snapshot>
```

*   Grab the wanted vm configuration from the needed snapshot - it'll be under initialization/configuration/data

`URL = SERVER:PORT/api/vms/VM_ID/snapshots/ID`
`Method = GET  (with All-Content:true header)`

*   Navigate to the wanted disk snapshot by accessing: ([Example](#get-disk-snapshot-data))

`SERVER:PORT/api/vms/GUID/snapshots/GUID/disks`

*   Attach the disk snapshot to the vm using the disk id and the snapshot id: ([Example](#attach-disk-to-backup-vm))

`URL = SERVER:PORT/api/vms/GUID/disks/`
`Method = POST (with Content-Type:application/xml header)`

```xml
<disk id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
  <snapshot id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"/>
</disk>
```

 **note**: you can attempt to plug the disk to the vm by adding `<active>true</active>` to the request body,
 otherwise you'll need to plug/activate it manually so that the data will be available for the backup.

*   if needed activate/plug the disk manually (depending on how the previous step was executed):

`URL = SERVER:PORT/api/vms/VM_ID/disks/DISK_ID/activate`
`Method = POST`

*   After copying the data from the disk detach the disk snapshot from the VM using the REST with the following parameters ([Example](#detach-disk-from-backup-vm)):

`URL = SERVER:PORT/api/vms/GUID/disks/GUID`
`Method = DELETE`

```xml
<action>
 <detach>true</detach>
</action>
```

### Full Virtual Machine Restoration

1.  Create disks for restore
2.  Attach the disks for restore to the virtual appliance (Restore the data to it)
3.  Detach the disks from the virtual appliance.
4.  Create a vm using the configuration that was saved as part of the backup flow - (added capability to oVirt as part of the Backup API)
5.  Attach the restored disks to the created vm.

#### Example of Virtual Machine Restoration

1. Create a disk to restore the data to:

2. Attach the disk to the virtual appliance:

`URL = SERVER:PORT/api/vms/GUID/disks/`
`Method = POST (with Content-Type:application/xml header)`

```xml
<disk id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"></disk>
```

3. After copying the data from the disk detach the disk from the VM: ([Example](#detach-disk-from-backup-vm)):

`URL = SERVER:PORT/api/vms/GUID/disks/GUID`
`Method = DELETE`

```xml
<action>
 <detach>true</detach>
</action>
```

4. Create a vm using the configuration that was saved as part of the backup flow:

`URL = SERVER:PORT/api/vms/`
`Method = POST(with Content-Type:application/xml header)`

```xml
<vm>
 <cluster>
  <name>cluster_name</name>
 </cluster>
 <initialization>
  <configuration>
   <type>ovf</type>
    <data>
     <![CDATA[..... ]]>
    </data>
  </configuration>
 </initialization>
 <name>OVERRIDING_NAME</name>
</vm>
```

  * The OVF configuration should be passed within CDATA block or after
    escaping to prevent error in the parsing of the request.
    
  * Note that any of the vm properties can be modified during that request by specifying it within the value (the given 
    example is with the vm name overridden).

#### Difference between Virtual appliance and Host appliance

Currently per the design, the difference is in the way that the data is would be exposed/restored. Backup - the disks snapshot for backup should be exposed on some host so it could be mounted and backed up through the needed HostApp with the backup software. Restore - an ability to restore the data to an ovirt disk should be introduced.

### File-Level Backup and Restoration

File level backup and restoration is essentially the same as the described virtual machine backup and restoration flows - as soon as the data is accessible by the backup provider, the required files can be backed up or restored.

### LAN Free Backup

Support for LAN-Free backup: oVirt provides SAN access to the disk devices out of the box.

### User Interface

N/A

### Current Status

*   Live snapshot : Done. Available in oVirt.
*   Live Merge: Done. Available in oVirt.
*   Guest Quiesce for Application-Level Consistency in Windows/Linux via Guest Agent: Done. Available in oVirt.
*   VDSM support : <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:backup-restore,n,z>
*   oVirt Engine / API support :
    -   Attach/Detach/Hotplug/Hotunplug Disk snapshot to a vm: <http://gerrit.ovirt.org/#/c/17679/>
    -   Add VM from configuration : <http://gerrit.ovirt.org/15894>
    -   Get snapshot vm ovf configuration: <http://gerrit.ovirt.org/#/c/16176/>
*   UI support : N/A

### This feature will be implemented in phases:

1.  Phase 1 will cover full backup and restoration for VirtApp use case and single-file-level restoration, as well will cover HostApp use case and guest quiesce for application-level consistency. The oVirt Backup and Restore API will provide integration with Microsoft Windows Volume Shadow Copy Service (VSS) using QEMU-GA. QEMU-GA provides VSS support, and live snapshot automatically tries to quiesce whenever possible. (The VSS provider registration will be made in the guest level as part of the Guest Tools deployment.)
2.  Phase 2 will cover Change Block Tracking (CBT) to cover incremental backups. This also depends on the ongoing community work in qemu block layer to provide differential information.

### Recommendations:

*   Block Device ID management considerations: method to track the device ID once attached to the Backup virtual appliance.
*   We should just name the snapshot with a proper prefix (e.g. "TSM Backup") to make it clear what it's about.

### Future Work

See phases section above

#### Incremental Virtual Machine Backups

Back up only the virtual machine data that has changed since the last backup. All data is backed up at the disk block level.

#### Differential Virtual Machine Backups

Backup all the changes since the last full backup. Differential backup is a cumulative backup of all changes since last full backup. Incremental backup contains only the changes since the last incremental backup whereas differential backup contains all changes since the last FULL backup.

### Open Issues

### Benefits to oVirt

Complete API providing ability to do full , file-level & incremental backups/restores of a running VM.

### Documentation / External references

*   [LiveMerge](/develop/release-management/features/storage/live-merge.html)

## Appendix

#### Python SDK examples

<https://github.com/laravot/backuprestoreapi/>

#### Get disk snapshot data

Navigate to the wanted disk snapshot from REST by accessing: ![](/images/wiki/FileRestDesc.png)

#### Attach disk to backup VM

POST the copied disk with the disk id and the snapshot id: ![](/images/wiki/AttachDisk.png)

#### Detach disk from backup VM

After the backup VM copy the data from the disk, detach the disk snapshot from the VM using the REST : ![](/images/wiki/DetachDisk.png)

#### Add disk from scratch

Adding a disk from scratch for restore VM ![](/images/wiki/AddDiskFromScratch.png)


