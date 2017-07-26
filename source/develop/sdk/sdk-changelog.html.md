---
title: Sdk-changelog
authors: michael pasternak
---

<!-- TODO: Content review -->

# Sdk-changelog

         * wed Nov  21 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.5-1
         - httpsconnection.source_address is not supported on python26 #877897

         * Sun Nov  18 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.4-1
         - cannot create simultaneous connections to multiple servers #853947
         - to StorageDomainVM.import() added action.exclusive parameter
         - to StorageDomainTemplate.import() added action.exclusive parameter
         - added /current argument to VmCdRom.update() acorrding to #869257
         - implemented support for #869257
         - added /async argument to VmCdRom.update()
         - added /async argument to ClusterNetworks.update()
         - removed Disk.update() method
         - added parameters overload for adding direct-lun disk
         - added vm/template.display.smartcard_enabled
         - added correlation_id to VMDisk.activate()/deactivate()
         - added correlation_id to VMNic.activate()/deactivate()
         - added certificate property to vm
         - Disk.lunStorage renamed to Disk.lun_storage

         * Thu Nov  1 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.3-1
         - do not send /max header on name-based search
         - Cannot fetch the disk using /alias #865407
         - restrict .get() methods to id/name
         - defend against disconnected mode when no proxy cached
         - allow persistent_auth via localhost
         - rebase to latest api
           - gluster action refactored to lowercase
           - added StorageDomainTemplate.delete()
           - added StorageDomainVM.delete()
           - template/vm.display.allow_reconnect renamed to template/vm.display.allow_override
           - added TemplateDisk.copy()
           - added template.cpu.cpu_tune.vcpu_pin: at Templates.add()/VMs.add()
           - added VmPool.allocatevm()
           - added size property to VmPools.add()
           - from ClusterGlusterVolumes.add() params removed
             access_protocols/access_control_list

         * Thu Sep  20 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.2-1
         - make /filter header global rather than method driven #857018
         - to host added max_scheduling_memory property
         - throw error when connecting to ssl site using http protocol

         * Sun Sep  9 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.1-1
         - to Disks.add() added /name arg
         - to disk.install() added r/oot_password arg
         - to Template.delete() added async/correlation_id args
         - to Template.update added documentation
         - to HostTags.add() added expect/correlation_id args
         - to VM.start added /filter header
         - raise NoCertificatesError only when no ca_file
         - use cached /filter argument rather than demanding it in methods
         - added correlation_id to:
           - restore snapshot
           - detach HostNIC
           - added create/update/delete methods to template.nics
         - clean context on disconnect
         - add filter parameter to proxy ctr.
         - support app. server errors

         * Tue Aug  21 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.6-1
         - make request error being capable to handle any type of response
         - verify credentials before storing proxy in cache
         - implement insecure flag #848046
         - implement server identity check
         - do not require optional params

         * Sun Aug  5 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.5-1
         - implemented http header support
         - added custom_configuration flag to host NIC
         - added override_configuration flag for setupnetworks action
         - added Correlation-Id header params
         - do not allow sending empty headers
         - refactor url params documentation
         - removed disk.allow_snapshot param documentation
         - to network.update() added [@param network.name: string]
         - fixed vm/template os.boot documentation

         * Mon Jul 9 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.4-1
         - fix typo in 'storage' based args documentation
         - make 'name' optional in storagedomains.add() to allow importing existent SD
         - make api.storagedomains collection searchable
         - Host object doesnt expose storage collection #838269
         - to DC.delete() method added [@param action.force: boolean]
         - api.networks no longer searchable collection
         - to create SD added [@param storagdomain.storage.override_luns: boolean]
         - VM.delete() no longer requires Action() parameter as mandatory
         - SDK should expose api root resource /api #830513
         - perform get() request on proxy construction to validate user credentials #827878
         - extract error body #827881
         - do not show brackets in error.detail
         - fix api.capabilities get/list methods

         * Mon Jun 25 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.3-1
         - to all collection added optional /max/ param. which is signals engine
           to override default amount of returned objects with user defined value
         - to Disk type added provisioned_size property and removed /type/ (not supported in 3.1)
         - to StorageDomainTemplate/VM import candidates params added clone, name
           properties for clonging imported object.
         - to StorageDomainTemplate/VM import candidates params added 
           collapse_snapshots property
         - to VM added vcpu_pin collection for vm cpu pinning

         * Thu Jun 7 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.2-1alpha
         - prevent stack overflow caused by comparisons creating infinite loops
         - fix error handling regression
         - implement support for 3+ period based URLs, new capabilities:    
             - vm.snapshot.disks/nics collections support
             - host/vm.nics.statistics collections support
             - collection/resource.permits support
         - rebase to latest api, new capabilities:
             - gluster collections/resources
             - quota support
             - remove template disk (by storage domain)
             - vm.payload support
             - floating disk support
         - add __eqals__ to business entities #782891

         * Wed May 16 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.1-1alpha
         - Version format refactoring to align with oVirt version schema 
         - Alpha release

         * Thu May 10 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.6.5
         - Added session based auth. support
         - Infinite recursion when calling non-existent method #808124
         - at Network/.add() added [@param network.usages: collection]
         - at HostNIC/.add() added [@param hostnic.ip.mtu: int]
         - at StorageDomainTemplate/StorageDomainVM.import() added:
           [@param action.storagedomain.id|name: string]
           [@param action.vm.disks.disk: collection]
         - at StorageDomains.add() method added:
           Overload 4:
             @param storagdomain.name: string
             @param storagdomain.host.id|name: string
             @param storagdomain.type: string
             @param storagdomain.storage.type: string
             @param storagdomain.format: boolean
             @param storagdomain.storage.path: string
             @param storagedomain.storage.vfs_type: string
             [@param storagdomain.storage.address: string]
             [@param storagdomain.storage.mount_options: string]
         - at Template/VM added:
           [@param template/vm.display.allow_reconnect: boolean]
         -at Template/VM.add() added:
           [@param template/vm.display.allow_reconnect: boolean]
           [@param template/vm.vm.disks.disk: collection]
         -added VMDisk.activate() method
         -added VMDisk.deactivate() method
         -added VMNic.activate() method
         -added VMNic.deactivate() method

         * Wed Mar 28 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.6.4
         - get rid of papyon dep.
         - implement ordereddict
         - lower lxml dep.

         * Wed Mar 21 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.6.3
         - few methods argumets documentation fixes

         * Wed Mar 14 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.6.2
         - add papyon dependency (needed for odict)

         * Tue Mar 13 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.6.1
         - rebase to latest api
           - refactored storage.create() parameters sets
           - added documentation for��UPDATE methods arguments
           - implemented ars-doc support for collection based arguments
           - added vm.delete(Action) signature, to force vm removal
           - implemented support for collection based actions
           - added setupnetworks action on collection of HostNics
           - added prestarted_vms property to vmpool
           - added support for new rsdl section describing url parameters
           - added 'reboot' property in host (used to disable reboot after installation)
           - added 'plugged' property in vm disk (to plug/unplug the disk at runtime)
         - implement support for documentation of netsed collection based args
         - support actions on collection
         - refactor documentation for collection based arguments
         - implement support for collection based parameters
         - implement url matrix parameters support
         - Cluster with NULL DC cannot be attached to DC #782828
         - use secured connection if no protocol specified
         - add documentation for api proxy arguments
         - add debugging capabilities

         * Wed Feb 15 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.5
         - several minor improvements

         * Fri Feb 10 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.4
         - added get_product_info() method to entry point

         * Tue Feb 7 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.3
         - rebased to latest ovirt-engine-api:
           - added update() for role resource
           - various parameter wrapping improvements

         * Thu Jan 19 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.2-1
         - use direct URI on get(id=x) rather than search pattern
         - extention for #782707

         * Mon Jan 16 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.1-1
         - add connectivity check and disconnect methods for #781820
`     `[`https://bugzilla.redhat.com/show_bug.cgi?id=781820`](https://bugzilla.redhat.com/show_bug.cgi?id=781820)
