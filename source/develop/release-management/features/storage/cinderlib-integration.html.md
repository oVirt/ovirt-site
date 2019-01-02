---
title: Managed Block Storage
category: feature
authors: frolland, bzlotnik, eshenitz
feature_name: Managed Block Storage - Cinderlib integration
feature_modules: storage,engine,vdsm
feature_status: WIP 4.3
---

# Managed Block Storage

## Summary

Many storage vendors provide a offloading API allowing to do fast storage side actions with minimal network usage from the virt management side. Such APIs already are integrated in Cinder.

This feature enables the user to be able to consume any storage backend supported in Cinder in order to create virtual disks for its VMs, without the need of a full Openstack deployment.


### Owner

*   Fred Rolland (<frolland@redhat.com>)
*   Benny Zlotnik (<bzlotnik@redhat.com>)
*   Eyal Shenitzky (<eshenitz@redhat.com>)

### Detailed Description

Cinder Library [1] provides a Python library that give the possibility to use the Cinder drivers directly without the need of a full Openstack/Cinder deployment supporting over 80 storage drivers.

- The user is able to configure a Storage Domain with the name of the Cinder driver and a set of parameters needed by the driver implementation.
- The user is able to create/delete disks on that Storage Domain.
- The user is able to create/delete snapshots of the disks created on that Storage Domain.
- The user is able to run VMs with disks created on that Storage Domain.


### Benefit to oVirt

With this feature the user will be able to use any storage vendor supported in Cinder (over 80 storage drivers) and beneficiate from the offloading features the storage vendors has implemented.

### User Experience

On the UX side, the storage flows are without any changes, except for the new Storage Domain type, where the user will have to provide a set of parameters needed by the driver (name/value pairs).
Sensitive fields, such as passwords, will be separated from others and masked in the GUI. These fields will be stored encrypted in the DB.

For example:
- volume_driver='cinder.volume.drivers.dell_emc.xtremio.XtremIOISCSIDriver'
- san_ip='10.10.10.1'
- xtremio_cluster_name='xtremio_cluster'
- san_login='xtremio_user'
- san_password='xtremio_password'

Here is a mock of the UI for the Storage Domain:

![](/images/wiki/CinderLibStorageDomain.png)

### High level flow

Cinderlib needs to persist volumes metadata in order to perform some of the operation. The persistency of the volumes will be stored in a Postgres DB in a new database.

The Cinderlib APIs will be invoked by the Engine, along with the DB parameters and the Drivers parameters.
The Engine needs access to the Storage Management API network.

Provisioning operations are done only on the Engine side.

#### Create Storage Domain
The user configures a new Storage Domain with all the needed parameters for the Cinder driver:
  - The Engine calls a Cinderlib API to test the given parameters.
  - If the call to Cinderlib API is successful, the Engine stores the data in the DB.

#### Create Disk

The user creates a disk on the storage domain:
  - The Engine calls a Cinderlib API with the driver backend parameters, the volume id, the volume size and the DB URL.
  - If the call to Cinderlib API is successful, the Engine creates the Disk in the DB.

#### Delete Disk

The user delete a disk on the storage domain:
  - The Engine calls a Cinderlib API with the driver backend parameters, the volume id and the DB URL to delete the volume.
  - If the call to Cinderlib API is successful, the Engine deletes the disk in the DB

#### Extend Disk size
  The user update a disk size on the storage domain:
    - The Engine calls a Cinderlib API with the driver backend parameters, the volume id, the new size and the DB URL.
    - If the call to Cinderlib API is successful, the Engine updates the disk size in the DB

### Connection information from Vdsm host

In order to be able to expose the volume to a host, Cinderlib needs to have its connection information.

As part of GetCapabilities Verb a new entry will be added to provide the needed information.

The Vdsm uses the Cinder's 'os_brick' library to collect the data.


#### Run VM

The user runs a VM with a Cinderlib disk :
  - The Engine calls a Cinderlib API to connect the volume using the connection information for the specific host and return the needed data for the attachment.
  - The Engine calls a Vdsm verb to attach the volume with the data needed. The Vdsm stores locally the attachment details that will be needed for detach, and then return the path.
  - The Engine uses the returned path for the volume in the VM XML.


#### Stop VM

The user stops a VM with a Cinderlib disk :
  - The Engine calls a Vdsm verb to detach the volume with the data needed. The Vdsm use the attachment details provided by the Engine and disconnect the volume.
  - The Engine calls a Cinderlib API to disconnect the volume.


### VDSM

- Add connection information as part of GetCapabilities verb using 'os_brick'.
- Add an 'attach' verb that will get the details of the volume, attach to the local host, and return the data of the attachment to the Engine.
- Add a 'detach' verb that will get the details of the details of the attachment and will disconnect the volume

// TODO describe additional changes needed

### Engine

- Add DB support for additional Storage Domain information.
- Block not supported storage operations.
- Python executable giving API to Cinderlib

// TODO describe additional changes needed

### Installation

Cinderlib will be packaged in RPM.
The Cinder drivers and Cinderlib needs to be installed in the Engine.
OS-Brick needs to installed on the hosts


### Open Issues / Limitations

- Cinderlib needs to be packaged in RPM that will be required by the Engine.
- os-brick needs to be installed on the hosts.
- Currently, for installing Cinderlib it will be necessary to install the whole openstack-cinder libraries.
- The Engine in oVirt will need to have access to the Storage Management API network.
- Not all storage flows are supported in the first release of these feature. For example :
    - Storage migration (cold & live)
    - OVF
    - Master domain
    - Leases
    - Storage Domain monitoring
- Some drivers requires additional packages that will need to be installed on the hosts. See: https://github.com/openstack/cinder/blob/master/driver-requirements.txt


### Documentation / External references
[1] [Cinder Library](https://github.com/Akrog/cinderlib)
