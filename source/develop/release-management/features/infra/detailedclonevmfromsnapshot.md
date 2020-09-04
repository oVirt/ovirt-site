---
title: DetailedCloneVmFromSnapshot
category: feature
authors: yair zaslavsky
---

# Detailed Clone Vm From Snapshot

## Clone VM from Snapshot

### Summary

The feature will allow oVirt users to clone VM from a snapshot of another VM.
A clone from snapshot will create disks at destination VM that are a collapsed copy of the images at snapshot chain
(the start of the chain is the first snapshot, the end of the chain is a the selected snapshot)
 Main feature page can be found at: [CloneVmFromSnapshot](/develop/release-management/features/virt/clonevmfromsnapshot.html)

### Owner

*   Name: Yair Zaslavsky (Yair Zaslavsky)


### Current status

*   Target Release: ...
*   Status: In progress
*   Last updated date: Jan 18th, 2012

### Detailed Description

Clone from Snapshot will give the ability to perform a clone of a VM or a VM template , based on a snapshot of a given VM.
oVirt-engine core will copy and collapse the images in the snapshot chain (the chain begins with the 1st snapshot, and ends with the selected snapshot).
In order to provide information on the VM or VM template to be created for the UI, UI will execute a query that will retrieve the VM and its disks configuration given a snapshot ID.
The UI will use the retrieved configuration as default values for the user to be modified.

#### User Experience

The UI will run a query called GetVmConfigurationBySnapshotID in order to get a VM configuration for a given snapshot.
The UI will provide two options for creating the clone:
.1. Presenting resent a window holding the configuration data. The configuration data will be used as defaults for the user, and the user may alter the data.
The UI will also present the disk list in order to allow disk format and type, and to select different storage domains to hold the destination disks.
2. The UI will allow the user to enter the target VM (or template) name, and the clone operation will use the VM configuration for the given snapshot as the values to create the VM (or template).

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Example of flow (assuming a VM was created with two disks):
![](/images/wiki/Clone_flow_1.png)
The next figure shows a snapshot was made, having now two images serving as the active images:
![](/images/wiki/Clone_flow_2.png)
In a similar way, more snapshots are created (Snaphost2 will be the one used for performing the clone):
![](/images/wiki/Clone_flow_3.png)

The Clone from snapshot will be performed the following way:
 .1. A user selects snapshot2 and selects a "clone from snapshot" operation from UI.
.2. oVirt-engine core queries for VM configuration, providing the VM configuration as default values for the user to use in order to provide the new VM information.
.3. The user will override the default data values (the user will have to provide a new name. UI will suggest a new name in a format of "copy_of_OLD_NAME")
.4. The user will initiate the beginning of the clone operation.
.5. New VM entity based on the passed data will be created. Some VM related data will be cloned from the original VM (i.e NICs)
.6. Copy & collapse all images at snaphsot2 and their ancestors will be carried out by oVirt-engine
.7. Association the copies of the disks with the VM clone will be created
 This can be seen in the next figure:
![](/images/wiki/Clone_flow_4.png)

#### Events

1. In case a snapshot is performed , and one of the disks is erased from the original VM, cloning from the snapshot should report that the disk is missing using the audit log.

### Dependencies / Related Features and Projects

The feature depends on the following projects:
1. oVirt web-admin - to supply the UI parts for this feature
2. oVirt API - to supply REST modeling
The feature depends on the following features:
1. Stable device addresses - on introduction of VM devices, which will have to be a part of the clone. See also [StableDeviceAddresses](/develop/release-management/features/virt/stabledeviceaddresses.html)
2. Multiple storage domains - on introduction of multiple storage domains. When performing the clone the user should be able to select the storage domains containing the disks of the cloned VM. See also [Multiple storage domains](/develop/release-management/features/storage/multiplestoragedomains.html)
3. Live snapshots - on introducing of snapshot entity and the association of snapshot and VM configuration (needed for querying VM configuration by snapshot). 
4. Direct LUN -on introduction of LUN-based disks (maybe this can postponed for later phase).
5. Hot plug/unplug - this feature may depend on hot plug/unplug - see open issues section. See also [Features/HotPlug](/develop/release-management/features/storage/hotplugdisk.html)
6. Quota - this feature needs the Quota feature in order to check the destination storage domains have suitable quota for the user to perform the clone operation. See Also [Features/Quota](/develop/release-management/features/sla/quota.html) <BR<BR>

### Clone VM from snapshot commands Class diagram and detailed description

In order to implement clone VM form snapshot two new commands are going to be introduced -
1. AddVmFromSnapshotCommand which will be responsible for performing business entities cloning and persistance (VmStatic, VmDevice objects, Interface objects (for NICs)).
At canDoAction the command will perform the following checks:
a. Check the snapshot exists
b. Retrieve a list of all images participating in the desired snapshot chain, and check if they are available for copying
c. Check there is no VM with the given name at the vmStatic parameter.
d. Check if the source and target storage domains exist and available.
e. Check for destination storage domains that the quota for the user is sufficient for performing the operation.
 At execution phase the command will perform the following for cloning a VM from snapshot:
a. Try to lock the snapshot (use getSnapshot method to retrieve it). If locking fails - the command fails (this is to avoid having concurrent operations on the same snapshot, such as merge, during the copy).
b. Try to lock the images participating in the desired snapshot chain (even if canDoAction passed -another command may have already locked some of them) . If locking fails - the command fails.
c Obtain a VM static object in one of the following ways (determined by a boolean flag passed in the command parameters):
c.1. The VM static object should be used - it will be stored in DB.
c.2. The given name should be used - based on the VM source ID, the VM static will be obtained by the given snapshot ID. The name field will be overridden by the value from the parameters.
d. Retrieve a list of the images to be cloned from the configuration provided by the parameters.
e. The command will check if the status of the snapshot is partial (as a result of disk deletion), and if this is the case, a sutiable audit log message indicating that a clone from partial snapshot is starting will be issued to the audit log. f. For each image of the retrieved images, run the CopyImage BLL command.
 2. CopyImageCommand will be responsible for running the CopyImageVDSCommand in order to perform the image copying.
The command will clone the image entity , and the required parameters (such as the source and target storage domain for the given image) to CopyImageVDSCommand.
A concrete task to monitor the progress of the copy image (asynchronous operation at VDSM) will be created, using the new VM as the entity for which all the tasks will be created.
 The diagram below presents the class diagram for the commands + changes in the existing design (prior to introduction of this feature)
![](/images/wiki/Clone_flow_vm_from_snapshot_new_2.png)
 a. BaseImagesCommand
This existing class will undergo the following changes:
\* Introducing the performImageVdsmOperation.
This method will replace the "CreateSnapshotInIRSServer" as in some cases, the overridden versions of this method invoke the CopyImage and not the CreateSnapshot VDSM verb.
\* Introducing the method handleImagesAfterVdsmOperation.
This method will be overridden by sub classes to provide logic for handling the images, after successful invocation of image releated VDSM operation.
In case of CreateSnapshotCommand the overridden method will replace the existing methods of ProcessImageFromDB and AddDiskImageToDB.
In case of CopyImageCommand the overridden method will add the new image to DB.
b. DiskImageUtils
This new class will include helper methods for image related commands.
An example for such a helper method is the method DiskImageUtils.cloneDiskImage that is responsible for performing image business entity cloning.
c. CopyImageCommand
This new class will concentrate BLL logic for performing image copying.
The command will be run internally only.
The command will receive as parameters information on source and target disk images and storage domains.
The command will invoke the CopyImageVDS command in order to perform the image copying via the SPM.
d. AddVmFromSnapshotCommand The new class will concrentrate BLL logic for creating a VM clone from a snapshot.
The command will invoke the CopyImage BLL command for each Disk Image that should be cloned.

### Clone VM from snapshot command parameters Class diagram

The diagram provided below is a class diagram of the command parameters that relate with the above command class diagram.
![](/images/wiki/Clone_flow_vm_from_snapshot_params.png)
The design introduces new parameter class and usages:

*   Introduction of AddVmFromSnapshotParameters

This class is the parameters class for the AddVmFromSnapshotCommand
This class uses the following fields:

*   VmStatic vmStatic - holds the static representation of the Vm.

In case the VmStatic object is filled only with name for the clone, the command should query the DB and get the vm static by the sourceVmId, and set the new name (the object will be used for the new cloned VM.)
In case the VmStatic object is filled with fields - the object will be used as the VmStatic object for the new cloned VM.
\* GUID vmSourceID - holds the unique identifier of the source VM
\* Guid snapshotID - holds the unique identifier of the snapshot ID

### GetVMConfigurationBySnapshotId

The diagram provided below is a class diagram for the GetVmConfiguraitonBySnapshotId.
This query will be used in order to obtain the Vm configuration (VmStatic + disk info list) by the snapshot the user has selected , to be used as a source for the clone.
![](/images/wiki/Get_vm_configuration_by_snapshot_id.png)

=== Documentation / External references === Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.



### Open Issues

