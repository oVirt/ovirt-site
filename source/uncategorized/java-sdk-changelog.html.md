---
title: Java-sdk-changelog
authors: michael pasternak
wiki_title: Java-sdk-changelog
wiki_revision_count: 32
wiki_last_updated: 2013-12-25
---

# Java-sdk-changelog

        * Thu  Jun 25 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.8-1
        - implement support for the /capabilities resource
        - implement basic debugging capabilities
        - added VMApplications sub-collection
        - to datacenter added new field [comment]
        - to disk added [sgio] field to enable|disable filtering for the ScsiGenericIo
        - to StorageDomain.delete() added storagedomain.host.id|name
        - implement basic debugging capabilities
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
