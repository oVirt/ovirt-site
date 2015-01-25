---
title: Cinder Integration
category: feature
authors: derez, sandrobonazzola
wiki_category: Feature|Cinder_Integration
wiki_title: Features/Cinder Integration
wiki_revision_count: 62
wiki_last_updated: 2015-06-11
feature_name: Cinder Integration
feature_modules: engine/vdsm
feature_status: Design
---

# Cinder Integration

### Summary

OpenStack Cinder(/ceph) Integration

### Owner

*   [Daniel Erez](User:DanielErez) (<derez@redhat.com>)
*   [Maor Lipchuk](User:MaorLipchuk) (<mlipchuk@redhat.com>)
*   [Nir Soffer](User:NirSoffer) (<nsoffer@redhat.com>)
*   [Federico Simoncelli](User:FedericoSimoncelli) (<fsimonce@redhat.com>)

### Detailed Description

Managing OpenStack Cinder volumes provisioned by ceph storage through oVirt engine. For initial phase, the integration should ensure support for creating/deleting volumes from a Cinder storage domain, while monitoring relevant statuses using [CoCo](CommandCoordinator) mechanism. The engine/vdsm should allow running VMs with attached ceph volumes via librbd library using libvirt support ([using libvirt with ceph rbd](http://ceph.com/docs/master/rbd/libvirt/)). As for security, when required, running VMs can authenticate using [CEPHX](http://ceph.com/docs/v0.69/rados/operations/auth-intro/) protocol (secret management will be handled in engine/vdsm).

### Dependencies / Related Features

*   [https://github.com/woorea/openstack-java-sdk woorea](https://github.com/woorea/openstack-java-sdk woorea) openstack-java-sdk should be updated and expanded to include cinder-model/cinder-client modules (needed for having an interface to interact with cinder rest-api commands.

### Documentation / External references

*   Ceph documentation: <http://ceph.com/docs/master/>
*   Ceph for Cinder: <http://techs.enovance.com/6572/brace-yourself-devstack-ceph-is-here>
*   Libvirt with CEPH: <http://ceph.com/docs/master/rbd/libvirt/>
*   Cinder REST API: <http://developer.openstack.org/api-ref-blockstorage-v2.html>
*   OpenStack Java SDK: <https://github.com/woorea/openstack-java-sdk>
*   Introducing Ceph to OpenStack: <http://www.sebastien-han.fr/blog/2012/06/10/introducing-ceph-to-openstack/>

### Phases

*   CRUD for OpenStack Volume (Cinder) provider.
*   CRUD for adding/deleting Cinder disks (including monitoring).
*   CRUD for snapshots with Cinder disks.
*   Fetching Volume Types - ceph/lvm/etc.
*   Running VMs with Cinder disks attached.
*   CEPHX integration for using volumes securely.
*   Import (from Cinder to engine DB).
*   Permissions (MLA).
*   Templates
    -   Add template - clone volume/create volume from snapshot - use [clone volume](http://blueprints.launchpad.net/cinder/+spec/add-cloning-support-to-cinder) and [flat volume](https://blueprints.launchpad.net/cinder/+spec/add-flat-volume-api) (if available).
    -   Add VM from template - create volume from source volume (thin).

### Future Work?

*   Move VM disk/Copy Template disk (cinder-to-cinder?/cinder-to-vdsm?/vdsm-to-cinder?).
*   Retype volume [volume-retype](https://blueprints.launchpad.net/cinder/+spec/volume-retype) (not supported for rbd yet).
*   Upload to Image (glance).
*   CRUD for volume types.
*   Quota (Cinder/Engine).
*   Import/Export (VMs/Templates).
*   Disk profiles.
*   Live snapshots.
*   Sync Cinder data with engine DB.
*   Cinder storage domain monitoring.

### Relevant Flows

*   Add/Remove/Update/Extend Cinder Disk
*   Remove VM
*   Add Template
*   Remove Template
*   Add VM from Template
*   Attach Cinder Disks
*   Plug/Unplug (Cold/Hot)
*   List Cinder Disks
*   Register Cinder Disks
*   Run VM - [multiple ceph monitors support / Cephx auth (secrets)]
*   Add/Remove Snapshot
*   Preview/Undo/Commit Snapshot
*   Custom Preview Snapshot
*   Clone VM from Snapshot
*   Clone VM

### Open Issues

*   Verify limits/quota against Cinder on Disk creation.
*   VM removal - deleted disks remain in 'locked' status (as opposed to images which are deleted immediately). I.e. failure would caused to disks in status 'illegal'.

### Patches

[Topic Branch: Cinder](http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:cinder,n,z)

### Implementation

#### Flow Illustration

![](cinder_flow_illustration.png "cinder_flow_illustration.png")

#### Engine

#### VDSM

*   Add [librbd1 package](https://apps.fedoraproject.org/packages/librbd1) as dependency to vdsm.spec file.
*   Refactor 'Dirve -> getXML()' to support multiple hosts (represents Ceph monitors) in disk's source element:

<disk type='network' device='disk'>
             

`               `<host name='{monitor-host}' port='6789'/>
                     ...
             

</source>
`       `<target dev='vda' bus='virtio'/>
</disk>

*   [TBD] [CEPHX](http://ceph.com/docs/v0.69/rados/operations/auth-intro/) secret handling - [Libvirt with CEPH (Configuring the VM section)](http://ceph.com/docs/master/rbd/libvirt/#configuring-the-vm).

#### UI

##### OpenStack Volume Providers

![](cinder_providers.png "cinder_providers.png")

##### OpenStack Volume Provider Dialog

![](cinder_new_provider.png "cinder_new_provider.png")

##### Cinder Storage Domains

![](cinder_domains.png "cinder_domains.png")

##### Register Cinder Disks (under Storage)

![](cinder_storage_register_disks.png "cinder_storage_register_disks.png")

##### Cinder Disks List (under Storage)

![](cinder_storage_disks.png "cinder_storage_disks.png")

##### Cinder Disk Dialog

![](cinder_new_disk.png "cinder_new_disk.png")

##### Cinder Disks List

![](cinder_disks_storage.png "cinder_disks_storage.png")

##### Cinder Disks attached to a VM

![](cinder_vms_disks.png "cinder_vms_disks.png")

[Cinder_Integration](Category:Feature) [Cinder_Integration](Category:oVirt 3.6 Proposed Feature)
