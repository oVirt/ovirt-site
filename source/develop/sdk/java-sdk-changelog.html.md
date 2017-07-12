---
title: Java-sdk-changelog
authors: michael pasternak
---

# Java-sdk-changelog

      * Tue  Dec 25 2013 Michael Pasternak `<mpastern@redhat.com>`  - 3.4.0.1-1
      - to vms.add() added [action.vm.initialization.cloud-init]
      - to NIC added OnBoot/BootProtocol properties
      - to VersionCaps added a list of supported payload-encodings
      - to Step added externalType
      - to NIC added vnicProfile and bootProtocol
      - to CPU added architecture 
      - to VnicProfilePermission added delete() method
      - to Disk added readOnly
      - to VMs.add() added [vm.cpu.architecture], [action.vm.initialization.cloud_init.*] arguments
      - to Templates.add() added [template.cpu.architecture], [action.template.initialization.cloud_init.*] arguments
      - to UserRoles.add() added permit.id|name arguments
      - at VMSnapshot removed preview/undo/commit methods
      - to DataCenterClusterGlusterVolumeGlusterBricks added activate/stopmigrate/migrate actions
      - to NetworkVnicProfile added Permissions sub-collection
      - to Cluster added [cluster.cpu.architecture]
      - to DataCenter added Networks sub-collection
      - to ClusterGlusterVolumeGlusterBricks added activate method
      - to ClusterGlusterVolume added stoprebalance method
      - to entry-point API added Permissions collection (for managing system-permissions)
      - to host.install() added ssh related arguments
      - to template added virtio_scsi.enabled
      - to vm added virtio_scsi.enabled
      - added ability to attach a disk snapshot to the virtual machine
      - to File class added 'content' field
      - Payload class now reuses Files instead of own PayloadFile collection

      * Wed  Oct 30 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.19-1
      - to host.install() added ssh related arguments
      - to template added virtio_scsi.enabled
      - to vm added virtio_scsi.enabled
      - added ability to attach a disk snapshot to the virtual machine
      - to File class added 'content' field
      - Payload class now reuses Files instead of own PayloadFile collection

      * Wed  Oct 9 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.18-1
      - added fqdn property to GuestInfo
      - refine host add()/update() documentation
      - to DataCenterStorageDomainDisk added exportDisk() action
      - to StorageDomainDisk added exportDisk() action
      - to TemplateDisk added exportDisk() action
      - to VMDisk added exportDisk() action
      - to Disk added exportDisk() action
      - update function doesn't have overloading methods #1008176
      - setupnetworks doesn't work #1008458
      - apache PropertyUtilsBean throws NoSuchMethodException #1007266
      - session_timeout parameter doesn't exists in API constructor #1007231

      * Wed  Sep 11 2013 Michael Pasternak `<mpastern@redhat.com>`  - 1.0.0.17 -1
      - VCpuPin renamed to VCpuPin
      - Host.getRebootAfterInstallation() returns False (null was expected) #985842
      - make all sdk exceptions serializable

      * Tue  Sep 3 2013 Michael Pasternak `<mpastern@redhat.com>`  - 1.0.0.16 -1
      - mvn compile with jdk 1.7

      * Tue  Sep 3 2013 Michael Pasternak `<mpastern@redhat.com>`  - 1.0.0.15 -1
      - added StorageDomainStorageConnection.delete() signature
      - added StorageDomainStorageConnection.delete(Boolean async) signature
      - added StorageDomainStorageConnections.add(StorageConnection storageconnection) signature
      - added StorageDomainStorageConnections.add(StorageConnection storageconnection,
                                                 String expect, String correlationId) signature
      - add ParameterSet descriptions
      - implement AutoCloseable interface
      - in Cluster added glusterhooks (ClusterGlusterHooks) sub-collection
      - in DataCenterCluster added glusterhooks (DataCenterClusterGlusterhooks)
        sub -collection
      - in StorageDomain added images (StorageDomainImages) sub-collection

      * Tue  Aug 13 2013 Michael Pasternak `<mpastern@redhat.com>`  - 1.0.0.14 -1
      - added VnicProfiles root -collection
      - to network added VnicProfiles sub -collection
      - to storagedomain added StorageConnections sub-collection
      - to VnicProfile added Permission sub -collection
      - to network.add()/.updated added [network.profile_required]
      - to NICs.add() added new overload with [nic.vnic_profile.id]
      - to NIC.update() added new overload with [nic.vnic_profile.id]
      - to VMSnapshots.list()/.get() added [String allContent] parameter
      - to VMs.add() added new overload based on [vm.initialization.configuration.type|data]
      - added root collection StorageConnections
      - added [host.override_iptables]
      - added [template.cpu_shares]
      - added [template.display.single_qxl_pci]
      - added [vm.display.single_qxl_pci]
      - added [vm.cpu_shares]
      - to template added:
      - [@param template.console.enabled: boolean] #878459
      - to vm added:
      - [@param vm.console.enabled: boolean] #878459
      - to Cluster added:    
        *[@param cluster.comment: string]
        *[@param cluster.ballooning_enabled: boolean]
        *[@param cluster.tunnel_migration: boolean]
      - to Host added:
        *[@param host.comment: string]
        *[@param host.ssh.port: int]
        *[@param host.ssh.fingerprint: string]
        *[@param host.ssh.authentication_type: string]
        *[@param host.ssh.password: string]
        *forceselectspm() action
      - to Network added:
        *[@param network.comment: string]
      - to StorageDomain
        *[@param storagedomain.comment: string]
      - to Template added:
        *[@param template.comment: string]
        *[@param template.permissions.clone: boolean]
      - to VM added:
        *[@param vm.comment: string]
        *[@param vm.permissions.clone: boolean]

      * Thu  Jul 18 2013 Michael Pasternak `<mpastern@redhat.com>`  - 1.0.0.13 -1
      - dependencies changes

      * Tue  Jul 16 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.11-1
      - added "watchdog" feature #947977
      - added "external tasks" feature #872719
      - snapshot can persist/restore memory state now #960931

       * Thu  Jul 8 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.10-1
       - to cluster.add()/.update() added [trusted_service] property
       - implement Secure Socket Layer (SSL) host verification (CA certificate) [1]
       - allow nullifying headers via passing NULL as header value
       
` [1] `[`http://www.ovirt.org/Java-sdk#Working_with_SSL_.28Secure_Socket_Layer.29`](/Java-sdk#Working_with_SSL_.28Secure_Socket_Layer.29)

        * Fri  Jun 28 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.9-1
        - configure log4j programmatically

        * Thu  Jun 25 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.8-1
        - implement support for the /capabilities resource
        - implement basic debugging capabilities
        - added VMApplications sub-collection
        - to datacenter added new field [comment]
        - to disk added [sgio] field to enable|disable filtering for the ScsiGenericIo
        - to StorageDomain.delete() added storagedomain.host.id|name
        - to VmPool added MaxUserVMs property
        - to cluster.update() added [cluster.data_center.id]
        - to host.fence() added action.fence_type
        - to storagedomain.delete() added [storagedomain.format]
        - to nic added [nic.custom_properties.custom_property]
        - to vm.add(), vm.update() added [vm.memory_policy.guaranteed]

        * Thu  June 4 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.7-1
         - updated storagedomain add()/update() docs
         - updated tag update() docs
         - enable correct generation of Boolean getters/setters to enable Bean Introspection apis
           (bollean getters will be prefixed with getX())
         - fixed docs for GlusterBricks add|update
         - fixed docs for add|update Tag
         - added [network.usages.usage] to ClusterNetworks
         - in add TemplateNICs, network.id|name is no longer mandatory
         - StorageDomainVM can be removed asynchronously now
         - removed DataCenterQuota.add|delete (yet not supported)

        * Thu  Apr 4 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.6-1
         - added new collection ClusterGlusterVolumeGlusterBrickStatistics
         - added new properties to the GlusterBrick
         - to vm added cpu.mode
         - to host install action added "image" parameter
         - ignore case in factory method lookup

        * Thu  Mar 7 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.5-1
         - use explicit classloader for JAXBContext
         - implement support for (user defined) session authentication
         - implement generic JAXBElement generation
         - to DataCenterStorageDomain added Disks sub-collection
         - to StorageDomain added Disks sub-collection
         - to host added display.address property
         - to vms.add() added overload for creating vm from snapshot

        * Sun  Feb 24 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.4-1
         - implement SSL support (without host verification)
         - implement shutdown() to deallocate system resources
         - to cluster added tunnel_migration property
         - to DataCenter added Clusters sub-collection
         - to root collection resource Disk added Permissions sub-collectio
         - to root collection resource Disk added Statistic sub-collection
         - host can be attached to cluster now either by id or name
         - to StorageDomainTemplate added Disks sub-collection
         - to StorageDomainVM added Disks sub-collection
         - to template.display added keyboard_layout property
         - to template added tunnel_migration property
         - to vm.display added keyboard_layout property
         - to vm added tunnel_migration property
         - to VMSnapshot added preview method
         - to VMSnapshot added undo method
         - to VMSnapshot added commit method

        * Wed  Jan 30 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.3-1
         - added persistent authentication support
         - added support for the method overloads based on url/headers params
         - added delete methods overloads with body as parameters holder
         - to host added overrideable [display.address] property
         - user can specify own ticket now in vm.ticket() via [action.ticket.value]

        * Wed  Jan 16 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.2-1
         - in vm/vmnic device property renamed to reportedDevice
         - to host added libvirtVersion
         - addresses an issue when API constructor when NULLs used as parameters

        * Tue Jan  15 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.1-1
         - implement parametrized list() methods
         - events can be added now (user defined events)
         - events can be removed now
         - host can be added now by using cluster.name (not only cluster-id)
         - NIC now has "linked" property
         - NIC now has "plugged" property
         - VM has now ReportedDevices sub-collection
         - VMNIC has now ReportedDevices sub-collection
         - to host add/update added power_management.agents parameter
         - to disk added permissions sub-collection
         - to PowerManagement added Agents collection
         - to VMDisk added move() action
         - to host added hooks sub-collection
         - to cluster added threads_as_cores property
         - to host added hardwareInformation property
         - to host added OS property
         - added force flag to the host.delete() method
         - added host.power_management.pm_proxy sub-collection
         - added permissions sub-collection to the network
         - added search capabilities to api.networks collection
         - added deletion protection support to template/vm via .delete_protected property

`   Author: Michael Pasternak `<mpastern@redhat.com>
         Date:   Sun Dec 2 11:05:26 2012 +0200
         Initial Import
