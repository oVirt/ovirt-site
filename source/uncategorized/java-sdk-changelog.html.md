---
title: Java-sdk-changelog
authors: michael pasternak
wiki_title: Java-sdk-changelog
wiki_revision_count: 32
wiki_last_updated: 2013-12-25
---

# Java-sdk-changelog

        * Tue Wed  16 2013 Michael Pasternak `<mpastern@redhat.com>` - 1.0.0.2-1
         - in vm/vmnic device property renamed to reported_device
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
