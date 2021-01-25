---
title: Cinder Integration
category: feature
authors: derez, sandrobonazzola
feature_name: Cinder Integration
feature_modules: engine/vdsm
feature_status: Released in oVirt 3.6
---

# Cinder Integration

## Summary

OpenStack Cinder(/ceph) Integration

## Owner

*   Daniel Erez (DanielErez) (<derez@redhat.com>)
*   Maor Lipchuk (MaorLipchuk) (<mlipchuk@redhat.com>)
*   Nir Soffer (NirSoffer) (<nsoffer@redhat.com>)
*   Federico Simoncelli (FedericoSimoncelli) (<fsimonce@redhat.com>)

## Detailed Description

Managing OpenStack Cinder volumes provisioned by ceph storage through oVirt engine. For initial phase, the integration should ensure support for creating/deleting volumes from a Cinder storage domain, while monitoring relevant statuses using [CoCo](/develop/release-management/features/infra/commandcoordinator.html) mechanism. The engine/vdsm should allow running VMs with attached ceph volumes via librbd library using libvirt support ([using libvirt with ceph rbd](https://docs.ceph.com/en/latest/rbd/libvirt/)). As for security, when required, running VMs can authenticate using [CEPHX](https://web.archive.org/web/20150112075731/http://docs.ceph.com/docs/v0.69/rados/operations/auth-intro/) protocol (secret management will be handled in engine/vdsm).
There is a known issue with OpenStack when deleting a snapshot which has dependent volumes based on it. to avoid this bug the OpenStack Cinder should configure the ceph backend with this attribute rbd_flatten_volume_from_snapshot as True.

## Dependencies / Related Features

*   [Woorea - OpenStack Java SDK](https://github.com/woorea/openstack-java-sdk) should be updated and expanded to include cinder-model/cinder-client modules (needed for having an interface to interact with cinder rest-api commands.

## Documentation / External references

*   Ceph documentation: <https://docs.ceph.com/en/latest/>
*   Libvirt with Ceph: <https://docs.ceph.com/en/latest/rbd/libvirt/>
*   Cinder REST API: <http://developer.openstack.org/api-ref-blockstorage-v2.html>
*   OpenStack Java SDK: <https://github.com/woorea/openstack-java-sdk>
*   Introducing Ceph to OpenStack: <http://www.sebastien-han.fr/blog/2012/06/10/introducing-ceph-to-openstack/>
*   Configure OpenStack Ceph Client: <https://docs.ceph.com/en/latest/rbd/rbd-openstack/#configure-openstack-ceph-clients>

## Phases

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

## Future Work?

*   Move VM disk/Copy Template disk (cinder-to-cinder?/cinder-to-vdsm?/vdsm-to-cinder?).
*   Retype volume [volume-retype](https://blueprints.launchpad.net/cinder/+spec/volume-retype) (not supported for rbd yet).
*   Upload to Image (glance).
*   CRUD for volume types.
*   Quota (Cinder/Engine).
*   Import/Export (VMs/Templates).
*   Disk profiles.
*   Live snapshots.
*   Live storage migration.
*   Sync Cinder data with engine DB.
*   Cinder storage domain monitoring.
*   Support multiple backends (lvm/etc).
*   OVF disk / disaster recovery support

## Relevant Flows

*   Add/Remove/Edit OpenStack volume provider
*   Add/Remove/Update/Extend Cinder Disk
*   Attach/Detach Storage Domain
*   Activate/Deactivate Storage Domain
*   Remove VM
*   Add Template
*   Remove Template
*   Add VM from Template
*   Add VM Pool
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
*   Remove Disk Snapshots

## Open Issues

*   Verify limits/quota against Cinder on Disk creation.
*   VM removal - deleted disks remain in 'locked' status (as opposed to images which are deleted immediately). I.e. failure would caused to disks in status 'illegal'.
*   There is a known issue with OpenStack when deleting a snapshot which has dependent volumes based on it. to avoid this bug the OpenStack Cinder should configure the ceph backend with this attribute rbd_flatten_volume_from_snapshot as True.

## Patches

[Topic Branch: Cinder](http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:cinder,n,z)

## Implementation

### Flow Illustration

![](/images/wiki/Cinder_flow_illustration.png)

### Engine

### REST-API

#### Add Provider: `POST /api/openstackvolumeproviders`

```xml
<openstack_volume_provider>
    <name></name>
    <url>[fqdn]:8776</url>
    <data_center>
        <name></name>
    </data_center>
    <requires_authentication>true|false</requires_authentication>
    <username></username>
    <password></password>
    <tenant_name></tenant_name>
</openstack_volume_provider>
```

#### Get Volume Provider: `GET /api/openstackvolumeproviders/{provider_id} (All-Content: true)`

```xml
<openstack_volume_providers>
    <openstack_volume_provider href="/api/openstackvolumeproviders/{id}" id="{id}">
        <name>cinder2</name>
        <requires_authentication>true</requires_authentication>
        <username>cinder</username>
        <data_center href="/api/datacenters/{id}" id="{id}">
            ...
        </data_center>
    </openstack_volume_provider>
</openstack_volume_providers>
```

#### Get Volume Type: `GET /api/openstackvolumeproviders/{provider_id}/volumetypes`

```xml
<openstack_volume_types>
    <openstack_volume_type href="/api/openstackvolumeproviders/{id}/volumetypes/{volume_type_id}" id="{id}">
        <name>ceph</name>
        <properties>
            <property>
            <name>volume_backend_name</name>
            <value>ceph</value>
            </property>
        </properties>
        <openstack_volume_provider href="/api/openstackvolumeproviders/{provider_id}" id="{id}"/>
    </openstack_volume_type>
</openstack_volume_types>
```

#### Get Authentication Keys: `GET /api/openstackvolumeproviders/{provider_id}/authenticationkeys`

```xml
<openstack_volume_authentication_keys>
    <openstack_volume_authentication_key>
    <description>my ceph secret</description>
    <uuid>c50352a3-0700-48e9-9189-ed359c09bcf8</uuid>
    <usage_type>ceph</usage_type>
    <creation_date>2015-05-31T15:28:25.525+03:00</creation_date>
   </openstack_volume_authentication_key>
</openstack_volume_authentication_keys>
```

#### Create an Authentication Key: `POST /api/openstackvolumeproviders/{provider_id}/authenticationkeys`

```xml
<openstack_volume_authentication_key>
    <uuid>0e6fff8d-8af9-49e2-b04f-1a5dbbe883a2</uuid>
    <description>my ceph secret</description>
    <usage_type>ceph</usage_type>
    <value>YQo=</value>
</openstack_volume_authentication_key>
```

#### Create a Cinder disk on a specific Volume Type: `POST /api/vms/{vm_id}/disks`

```xml
<disk>
    <openstack_volume_type>
        <name>my_ceph</name>
    </openstack_volume_type>
    <storage_domains>
        <storage_domain>
            <name>cinder</name>
        </storage_domain>
    </storage_domains> 
    <provisioned_size>1073741824</provisioned_size>
    <interface>virtio</interface>
    <format>raw</format>
</disk>
```

#### Get Unregistered Disks: `GET /api/storagedomains/{storage_domain_id}/disks;unregistered`

```xml
<disks>
      ...
</disks>
```

#### Register Disk: `POST /api/storagedomains/{storage_domain_id}/disks;unregistered`

```xml
<disk id="{disk_id}"></disk>
```

#### Delete Entity (DIsk/VM/Template)

Cinder disks are deleted asynchronously, hence ';async' flag could be passed as part of the URL for getting 202-Accepted return status.

E.g. 
    `DELETE /api/disks/{disk_id};async`
    
```xml
<action></action>
```

### VDSM

*   Add [librbd1 package](https://apps.fedoraproject.org/packages/librbd1) as dependency to vdsm.spec file.
*   Refactor `Drive -> getXML()` to support multiple hosts (represents Ceph monitors) in disk's source element:

```xml
<disk type="network" device="disk">
    <host name="{monitor-host}" port="6789"/>
                     ...

    </source>
    <target dev="vda" bus="virtio"/>
</disk>
```

*   [TBD] [CEPHX](https://web.archive.org/web/20150112075731/http://docs.ceph.com/docs/v0.69/rados/operations/auth-intro/) secret handling - [Libvirt with CEPH (Configuring the VM section)](https://docs.ceph.com/en/latest/rbd/libvirt/#configuring-the-vm).

### UI

#### OpenStack Volume Providers

![](/images/wiki/Cinder_providers.png)

#### OpenStack Volume Provider Dialog

![](/images/wiki/Cinder_new_provider.png)

#### Cinder Storage Domains

![](/images/wiki/Cinder_domains.png)

#### Cinder Disk Dialog

![](/images/wiki/Cinder_new_disk.png)

#### Cinder Disks attached to a VM

![](/images/wiki/Cinder_vms_disks.png)

#### Cinder Disks List (under Storage)

![](/images/wiki/Cinder_storage_disks.png)

#### Register Cinder Disks (under Storage)

![](/images/wiki/Cinder_storage_register_disks.png)

#### Cinder Disks List

![](/images/wiki/Cinder_disks_storage.png)

#### Cinder Authentication Keys

![](/images/wiki/Cinder_auth_keys.png)

#### Authentication Key Dialog

![](/images/wiki/Cinder_new_auth_key.png)

## Authentication Keys

When client Ceph authentication (Cephx) is enabled, authentication keys should be configured as follows:

*   (1) Create a new secret key on ceph using 'ceph auth get-or-create' - see example in [Configuring client for Nova/Cinder](http://docs.ceph.com/docs/master/rbd/libvirt/#configuring-the-vm)
    -   E.g.1. ceph auth get-or-create client.cinder | ssh {your-nova-compute-server} sudo tee /etc/ceph/ceph.client.cinder.keyring
    -   E.g.2. ceph auth get-or-create client.vdsm | tee 'my_pass'
*   (2) Navigate to 'Authentication Keys' sub-tab (under 'Providers' main-tab): ![Authentication Keys](/images/wiki/Cinder_Authentication_Keys.png)
*   (3) Click 'New' to open the create dialog: ![Screenshot](/images/wiki/Authentication_Key_Dialog.png)
*   (4) In 'Value' text-box, enter the value of the secret key created on step (1).
    -   Can be retrieved by 'ceph auth get client.cinder'
*   (5) From 'UUID' text-box, copy the automatically generated UUID (or create a new one), and add to cinder.conf.

         E.g. '/etc/cinder/cinder.conf':
         rbd_secret_uuid = 148eb4bc-c47c-4ffe-b14e-3a0fb6c76833
         rbd_user = cinder

Note: client authentication keys are only used upon running a VM; i.e. authentication for ceph volume manipulation should be configured solely on Cinder side.

