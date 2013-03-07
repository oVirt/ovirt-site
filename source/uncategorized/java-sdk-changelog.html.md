---
title: Java-sdk-changelog
authors: michael pasternak
wiki_title: Java-sdk-changelog
wiki_revision_count: 32
wiki_last_updated: 2013-12-25
---

# Java-sdk-changelog

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
