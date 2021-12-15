---
title: Managed Block Storage
category: feature
authors:
  - frolland
  - bzlotnik
  - eshenitz
---

# Managed Block Storage

## Summary

Many storage vendors provide a offloading API allowing to do fast storage side actions with minimal network usage from the virt management side. Such APIs already are integrated in Cinder.

This feature enables the user to be able to consume any storage backend supported in Cinder in order to create virtual disks for its VMs, without the need of a full OpenStack deployment.


### Owner

*   Fred Rolland (<frolland@redhat.com>)
*   Benny Zlotnik (<bzlotnik@redhat.com>)
*   Eyal Shenitzky

### Detailed Description

Cinder Library [1] provides a Python library that give the possibility to use the Cinder drivers directly without the need of a full OpenStack/Cinder deployment supporting over 80 storage drivers.

- The user is able to configure a Storage Domain with the name of the Cinder driver and a set of parameters needed by the driver implementation.
- The user is able to create/delete/clone disks on that Storage Domain.
- The user is able to create/delete snapshots of the disks created on that Storage Domain.
- The user is able to run VMs with disks created on that Storage Domain.
- The user is able to create a VM from a template with disks on that storage domain.

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

Here is a screenshot of the UI for the Storage Domain:

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

In case that some of the driver parameters contains sensitive information like passwords, the user can specify them as `driver_sensitive_options`. These parameters will be stored encrypted in the DB ans masked in the UI.

Here are examples of the REST API usage:

HP 3PAR:

```XML
<storage_domain>
   <name>cinder-hp3par</name>
   <type>managed_block_storage</type>
   <storage>
      <type>managed_block_storage</type>
      <driver_options>
         <property>
            <name>volume_driver</name>
            <value>cinder.volume.drivers.hpe.hpe_3par_fc.HPE3PARFCDriver</value>
         </property>
          <property>
            <name>hpe3par_api_url</name>
            <value>https://3par-cli.mgmt.acme.com:8080/api/v1</value>
         </property>
          <property>
            <name>san_ip</name>
            <value>10.10.10.10</value>
         </property>
      </driver_options>
      <driver_sensitive_options>
          <property>
            <name>san_login</name>
            <value>admin</value>
         </property>
         <property>
            <name>san_password</name>
            <value>my_secret</value>
         </property>
      </driver_sensitive_options>
   </storage>
   <host>
      <name>vdsm-01</name>
   </host>
</storage_domain>
```

Ceph:

```XML
<storage_domain>
   <name>ceph-cinder</name>
   <type>managed_block_storage</type>
   <storage>
      <type>managed_block_storage</type>
      <driver_options>
         <property>
            <name>rbd_ceph_conf</name>
            <value>/etc/ceph/ceph.conf</value>
         </property>
         <property>
            <name>rbd_pool</name>
            <value>volumes</value>
         </property>
         <property>
            <name>rbd_user</name>
            <value>admin</value>
         </property>
         <property>
            <name>use_multipath_for_image_xfer</name>
            <value>true</value>
         </property>
         <property>
            <name>volume_driver</name>
            <value>cinder.volume.drivers.rbd.RBDDriver</value>
         </property>
         <property>
            <name>rbd_keyring_conf</name>
            <value>/etc/ceph/ceph.client.admin.keyring</value>
         </property>
      </driver_options>
   </storage>
   <host>
      <name>vdsm-01</name>
   </host>
</storage_domain>

```


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

### Connector information from Vdsm host

In order to be able to expose the volume to a host, Cinderlib needs to have its connector information.

As part of GetCapabilities Verb a new entry will be added to provide the needed information.

#### Run VM

The user runs a VM with a Cinderlib disk :
  - The Engine calls a Cinderlib API to connect the volume using the connector information for the specific host and return the data needed for the attachment.
  - The Engine calls a Vdsm verb to attach the volume with the data needed. The Vdsm stores locally the attachment details that will be needed for detach, and then return the path.
  - The Engine stores the result in the DB and uses the returned path for the volume in the VM XML.


#### Stop VM

The user stops a VM with a Cinderlib disk :
  - The Engine calls a Vdsm verb to detach the volume with the volume ID. The Vdsm use the ID provided by the Engine, fetches the needed data from its local DB and disconnect the volume.
  - The Engine calls a Cinderlib API to disconnect the volume.


### VDSM

#### Host.GetCapabilities

The Vdsm uses the Cinder's 'os_brick' library to collect the data. If the 'os_brick' library is not installed on the host, the 'connector_info' will not be available and VMs with MBS disk will not able to run on that host.

Here an example of the 'connector_info'

```json
"connector_info": {
        "initiator": "iqn.1994-05.com.acme:b82360563cee",
        "ip": "10.10.10.1",
        "platform": "x86_64",
        "host": "vdsm02",
        "do_local_attach": false,
        "os_type": "linux2",
        "multipath": true
    }
```

#### ManagedVolume.attach_volume

When the user wants to run a VM, Engine will first call CinderLib API to expose the volume to the host according to the "connector_info".
The Storage Management API will provide the connection information needed by the host to attach.  Then Engine calls the ManagedVolume.attach_volume with this information and the volume ID. The structure of the data is according to os_brick/Cinder format.

Here an example of the connection information (iSCSI volume):

```json
{
    "driver_volume_type": "iscsi",
    "data":
    {
        "target_lun": 26,
        "target_iqn": "iqn.2009-01.com.kaminario:storage.k2.22612",
        "target_portal": "3.2.1.1:3260",
        "target_discovered": "True"
    }
}
```

Vdsm will call an os_brick API to attach the volume and will return the volume information data to Engine that will persist it in the DB.
The volume information consists of the volume path that Engine will use in the VM XML and of the volume attachment as returned from os_brick. The structure of the volume attachment data is according to os_brick/Cinder
format.

Here examples of the volume information:

For iSCSI volume with multipath:

```json
{
  "path" : "/dev/mapper/20024f400585401ce",
  "attachment":
  {
    "path": "/dev/dm-25",
    "scsi_wwn": "20024f400585401ce",
    "type": "block",
    "multipath_id": "20024f400585401ce"
  }
}
```

For RBD volume:

```json
{
  "path" : "/dev/rbd1",
  "attachment":
  {
    "path": "/dev/rbd1",
    "type": "block",
    "conf": "/tmp/brickrbd_WimcIm"
  }
}
```

Vdsm stores the volume information along with the connection information of the attached volumes in a local DB.
The volume ID will be the key of the data in the DB.
The stored data is used to be able to filter them from GetDeviceList result and to detach a volume.

#### ManagedVolume.detach_volume

When the user wants to stop a VM, Engine will call Vdsm to detach the volume with the volume ID using ManagedVolume.detach_volume.

The needed data (device info and connection info) for performing the detachment is retrieved from the local DB.

#### ManagedVolume.volumes_info


The user is able to get the information of specific volumes using ManagedVolume.volumes_info with the volume IDs. List of all volumes can be obtained by using ManagedVolume.volumes_info without specifying a volume id.
Vdsm will return the volume information, similar to the attach flow.
Besides information contained in attach flow, it also includes volume ID and parameter `exists`, which is set to `True` if multipath device is connected and path exists on local machine.

For example:

```json
[{
  "vol_id": "01713ade-9688-43ff-a46c-0e2e35974dce",
  "exists": "True",
  "path" : "/dev/mapper/20024f400585401ce",
  "attachment":
  {
    "path": "/dev/sda",
    "scsi_wwn": "20024f400585401ce",
    "type": "block"
  }
}]
```

### Engine

- Add DB support for additional Storage Domain information.
- Block not supported storage operations.
- Python executable giving API to Cinderlib
- Setup an additional DB.


### Installation

Cinderlib will be packaged in RPM.
The Cinder drivers and Cinderlib needs to be installed in the Engine.
OS-Brick needs to installed on the hosts

#### Manual Install

Since that some of the required libraries are currently not part of oVirt installation, the following steps are required:

On Engine:

```
$ yum install -y centos-release-openstack-pike
$ yum-config-manager --enable openstack-pike
$ yum install -y openstack-cinder python-pip
$ pip install cinderlib
```

On all the hosts: (Vdsm needs to be restarted after installing the packages)

```
$ yum install -y centos-release-openstack-pike
$ yum-config-manager --enable openstack-pike
$ yum install -y python2-os-brick
```


For Ceph backend, the following package is needed in the Engine and in all the hosts:

```
$ yum install -y ceph-common
```

Also for Ceph backend, a keyring file and ceph.conf file is needed in the Engine.

#### Enable Managed Block Domain in Engine

Managed Block Domain is not enabled by default in the Engine. In order to enable it, run the following command and restart the Engine:

```
$ engine-config -s ManagedBlockDomainSupported=true

Please select a version:

    1. 4.3
    2. 4.1
    3. 4.2
# Select 1
```

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
- Some drivers requires additional packages that will need to be installed on the hosts. See here :[2]


### Documentation / External references
[1] [Cinder Library](https://github.com/openstack/cinderlib)

[2] [Additional Drivers required package](https://github.com/openstack/cinder/blob/master/driver-requirements.txt)
