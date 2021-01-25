---
title: PythonApi
category: api
authors: mgoldboi, mkollaro, moti, mpavlik, rvaknin
---

# Python API

## Create a Basic Environment using ovirt-engine-sdk

Ovirt-Engine-SDK is an auto-generated python API which uses REST-API to perform operations against ovirt-engine. In order to connect to ovirt-engine using ovirt-engine-sdk and get the API proxy (reference instance to REST-API), the following connection information is required:

*   URL - The URL consists of HTTP method, ovirt-engine's IP or FQDN, ovirt-engine's TCP PORT and the REST-API's entry point. The HTTP method and the PORT are usually HTTPS/8443 for secure connection (default installation option), or HTTP/8080 for insecure connection (in use mostly in development environments). The REST-API's entry point is fixed - "/api"

*   User and Password - The user consists of a username, the "@" sign and domain name. You can use either the default internal user's account or any of your LDAP users that has both login permissions and of course also has permissions to execute the desired operations.

### Importing the relevant modules and obtaining an API object

Add the following to you python script, remember to set the URL/USERNAME/PASSWORD constants accordingly

    #! /usr/bin/python
    
    from ovirtsdk.api import API
    from ovirtsdk.xml import params
    
    VERSION = params.Version(major='3', minor='0')
     
    URL =           'https://192.168.1.1:8443/api'
    USERNAME =      'my_user@my.domain.com'
    PASSWORD =      'my_password'
    
    DC_NAME =       'my_datacenter'
    CLUSTER_NAME =  'my_cluster'
    HOST_NAME =     'my_host'
    STORAGE_NAME =  'my_storage'
    EXPORT_NAME =   'my_export'
    VM_NAME =       'my_vm'
    
    api = API(url=URL, username=USERNAME, password=PASSWORD)

### Create iSCSI Data Center

    try:
        if api.datacenters.add(params.DataCenter(name=DC_NAME, storage_type='iscsi', version=VERSION)):
            print 'iSCSI Data Center was created successfully'
    except Exception as e:
        print 'Failed to create iSCSI Data Center:\n%s' % str(e)

### Create Cluster

Note that the CPU type should be chosen according to your host's CPU.

    CPU_TYPE = 'Intel Nehalem Family'
    
    try:
        if api.clusters.add(params.Cluster(name=CLUSTER_NAME, cpu=params.CPU(id=CPU_TYPE), data_center=api.datacenters.get(DC_NAME), version=VERSION)):
            print 'Cluster was created successfully'
    except Exception as e:
        print 'Failed to create Cluster:\n%s' % str(e)

### Install Host

    HOST_ADDRESS = 'hostname.my.domain.com'
    ROOT_PASSWORD = 'root_password'
    
    try:
        if api.hosts.add(params.Host(name=HOST_NAME, address=HOST_ADDRESS, cluster=api.clusters.get(CLUSTER_NAME), root_password=ROOT_PASSWORD)):
            print 'Host was installed successfully'
            print 'Waiting for host to reach the Up status'
            while api.hosts.get(HOST_NAME).status.state != 'up':
                sleep(1)
            print "Host is up"
    except Exception as e:
        print 'Failed to install Host:\n%s' % str(e)

## Working with storages

### Create iSCSI Storage Domain on Data Center

    STORAGE_ADDRESS = 'storage_server.my.domain.com'
    TARGET_NAME = 'target_name'
    LUN_GUID = 'lun_guid'
    
    sdParams = params.StorageDomain(name=STORAGE_NAME,
                      data_center=api.datacenters.get(DC_NAME),
                      storage_format='v2',
                      type_='data',
                      host=api.hosts.get(HOST_NAME),
                      storage = params.Storage(type_='iscsi',
                                       volume_group=params.VolumeGroup(logical_unit=[params.LogicalUnit(id=LUN_GUID,
                                                           address=STORAGE_ADDRESS,
                                                           port=3260,
                                                           target=TARGET_NAME)]))  )
    
    try:
        if api.storagedomains.add(sdParams):
            print 'iSCSI Storage Domain was created successfully'
    except Exception as e:
        print 'Failed to create iSCSI Storage Domain:\n%s' % str(e)
    
    try:
        if api.datacenters.get(name=DC_NAME).storagedomains.add(api.storagedomains.get(name=STORAGE_NAME)):
            print 'iSCSI Storage Domain was attached successfully'
    except Exception as e:
        print 'Failed to attach iSCSI Storage Domain:\n%s' % str(e)

### Attach ISO domain to Data Center

You can either create a new ISO Storage Domain or import an existing ISO Storage Domain that was configured during ovirt-engine's installation wizard (both options uses the same code below). Please upload the following ISO file to the ISO Storage Domain once the ISO Storage Domain was created: <http://distro.ibiblio.org/tinycorelinux/4.x/x86/release/TinyCore-current.iso>

    ISO_ADDRESS = 'my_ovirt_engine_ip'
    ISO_PATH = '/path/to/iso/domain'
    ISO_NAME = 'my_iso'
    
    isoParams = params.StorageDomain(name=ISO_NAME,
                                        data_center=api.datacenters.get(DC_NAME),
                                        type_='iso',
                                        host=api.hosts.get(HOST_NAME),
                                        storage = params.Storage(   type_='nfs',
                                                                    address=ISO_ADDRESS,
                                                                    path=ISO_PATH  )  )
    
    try:
        if api.storagedomains.add(isoParams):
            print 'ISO Domain was created/imported successfully'
    
        if api.datacenters.get(DC_NAME).storagedomains.add(api.storagedomains.get(ISO_NAME)):
            print 'ISO Domain was attached successfully'
    
        if api.datacenters.get(DC_NAME).storagedomains.get(ISO_NAME).activate():
            print 'ISO Domain was activated successfully'
    except Exception as e:
        print 'Failed to add ISO domain:\n%s' % str(e)

### Attach Export domain to Data Center

    EXPORT_ADDRESS = 'ip_of_export_domain_storage'
    EXPORT_PATH = '/path/to/export/domain'
    
    isoParams = params.StorageDomain(name=EXPORT_NAME,
                                        data_center=api.datacenters.get(DC_NAME),
                                        type_='export',
                                        host=api.hosts.get(HOST_NAME),
                                        storage = params.Storage(   type_='nfs',
                                                                    address=EXPORT_ADDRESS,
                                                                    path=EXPORT_PATH  )  )
    try:
        if api.storagedomains.add(isoParams):
            print 'Export Domain was created/imported successfully'
    
        if api.datacenters.get(DC_NAME).storagedomains.add(api.storagedomains.get(EXPORT_NAME)):
            print 'Export Domain was attached successfully'
    
        if api.datacenters.get(DC_NAME).storagedomains.get(EXPORT_NAME).activate():
            print 'Export Domain was activated successfully'
    
    except Exception as e:
        print 'Failed to add export domain:\n%s' % str(e)

## Virtual Machines

### Create VM with one NIC and one Disk

    MB = 1024*1024
    GB = 1024*MB
       
    try:
        api.vms.add(params.VM(name=VM_NAME, memory=2*GB, cluster=api.clusters.get(CLUSTER_NAME), template=api.templates.get('Blank')))
        print 'VM created'
    
        api.vms.get(VM_NAME).nics.add(params.NIC(name='eth0', network=params.Network(name='ovirtmgmt'), interface='virtio'))
        print 'NIC added to VM'
     
        api.vms.get(VM_NAME).disks.add(params.Disk(storage_domains=params.StorageDomains(storage_domain=[api.storagedomains.get(STORAGE_NAME)]),
                                                    size=512*MB,
                                                    # type_='system', - disk type is deprecated
                                                    status=None,
                                                    interface='virtio',
                                                    format='cow',
                                                    sparse=True,
                                                    bootable=True))
        print 'Disk added to VM'
        print 'Waiting for VM to reach Down status'
        while api.vms.get(VM_NAME).status.state != 'down':
            sleep(1)
    
    except Exception as e:
        print 'Failed to create VM with disk and NIC\n%s' % str(e)

### Start/hibernate/resume/stop VM

#### Start VM

    try:
        if api.vms.get(VM_NAME).status.state != 'up':
            print 'Starting VM'
            api.vms.get(VM_NAME).start()
            print 'Waiting for VM to reach Up status'
            while api.vms.get(VM_NAME).status.state != 'up':
                sleep(1)
        else:
            print 'VM already up'
    except Exception as e:
        print 'Failed to Start VM:\n%s' % str(e)

#### Suspend VM

    while api.vms.get(VM_NAME).status.state != 'suspended':
        try:
            print 'Suspend VM'
            api.vms.get(VM_NAME).suspend()
            print 'Waiting for VM to reach Suspended status'
            while api.vms.get(VM_NAME).status.state != 'suspended':
                sleep(1)
     
        except Exception as e:
            if e.reason == 'Bad Request' \
                and 'asynchronous running tasks' in e.detail:
                print 'VM has asynchronous running tasks, trying again'
                sleep(1)
            else:
                print 'Failed to Suspend VM:\n%s' % str(e)
                break

#### Resume VM (identical to start up)

    try:
        if api.vms.get(VM_NAME).status.state != 'up':
            print 'Resume VM'
            api.vms.get(VM_NAME).start()
            print 'Waiting for VM to Resume'
            while api.vms.get(VM_NAME).status.state != 'up':
                sleep(1)
        else:
            print 'VM already up'
    except Exception as e:
        print 'Failed to Resume VM:\n%s' % str(e)

#### Stop VM

    try:
        if api.vms.get(VM_NAME).status.state != 'down':
            print 'Stop VM'
            api.vms.get(VM_NAME).stop()
            print 'Waiting for VM to reach Down status'
            while api.vms.get(VM_NAME).status.state != 'down':
                sleep(1)
        else:
            print 'VM already down'
    except Exception as e:
        print 'Stop VM:\n%s' % str(e)

### Export, delete and import VM

#### Export VM (into Export Domain)

    try:
        api.vms.get(VM_NAME).export(params.Action(storage_domain=api.storagedomains.get(EXPORT_NAME)))
        print 'VM was exported successfully'
        print 'Waiting for VM to reach Down status'
        while api.vms.get(VM_NAME).status.state != 'down':
            sleep(1)
    except Exception as e:
       print 'Failed to export VM:\n%s' % str(e)

#### Delete VM

    try:
        api.vms.get(VM_NAME).delete()
        print 'VM was removed successfully'
        print 'Waiting for VM to be deleted'
        while VM_NAME in [vm.name for vm in api.vms.list()]:
            sleep(1)
    except Exception as e:
        print 'Failed to remove VM:\n%s' % str(e)

#### Import VM (from Export Domain)

    try:
        api.storagedomains.get(EXPORT_NAME).vms.get(VM_NAME).import_vm(params.Action(storage_domain=api.storagedomains.get(STORAGE_NAME), cluster=api.clusters.get(name=CLUSTER_NAME)))
        print 'VM was imported successfully'
        print 'Waiting for VM to reach Down status'
        while api.vms.get(VM_NAME).status.state != 'down':
            sleep(1)
    except Exception as e:
        print 'Failed to import VM:\n%s' % str(e)

### Create a snapshot to VM

    SNAPSHOT_NAME = 'my_snapshot'
    
    try:
        api.vms.get(VM_NAME).snapshots.add(params.Snapshot(description=SNAPSHOT_NAME, vm=api.vms.get(VM_NAME)))
        print 'Creating a Snapshot'
        print 'Waiting for Snapshot creation to finish'
        while api.vms.get(VM_NAME).status.state == 'image_locked':
            sleep(1)
    except Exception as e:
        print 'Failed to Create a Snapshot:\n%s' % str(e)

### Create a Template from VM

    TEMPLATE_NAME = 'my_template'
    
    try:
        api.templates.add(params.Template(name=TEMPLATE_NAME, vm=api.vms.get(VM_NAME), cluster=api.clusters.get(CLUSTER_NAME)))
        print 'Creating a Template from VM'
        print 'Waiting for VM to reach Down status'
        while api.vms.get(VM_NAME).status.state != 'down':
            sleep(1)
    except Exception as e:
        print 'Failed to Create a Template from VM:\n%s' % str(e)

### Create VM from Template

    NEW_VM_NAME = 'my_vm_from_template'
    
    try:
        api.vms.add(params.VM(name=NEW_VM_NAME, cluster=api.clusters.get(CLUSTER_NAME), template=api.templates.get(TEMPLATE_NAME)) )
        print 'VM was created from Template successfully'
        print 'Waiting for VM to reach Down status'
        while api.vms.get(VM_NAME).status.state != 'down':
            sleep(1)
    except Exception as e:
        print 'Failed to create VM from Template:\n%s' % str(e)

## Networking

### Add VM network to the data-center

    DATA_CENTER_NAME = 'my_dc_name'
    vmVlan400 = params.Network(name = 'VM_VLAN_400',
                           data_center = api.datacenters.get(name = DATA_CENTER_NAME), 
                           description = 'a tagged vm network',
                           vlan = params.VLAN(id = '400'))
    
    vmVlan400 = api.networks.add(vmVlan400)

### Add Non-VM network to the data-center

    DATA_CENTER_NAME = 'my_dc_name'
    nonVmVlan500 = params.Network(name = 'NON_VM_VLAN_500',
                           data_center = api.datacenters.get(name = DATA_CENTER_NAME), 
                           description = 'a tagged non-vm network',
                           vlan = params.VLAN(id = '500'),
                           usages = params.Usages())
    
    nonVmVlan500 = api.networks.add(nonVmVlan500)

### Attach network to cluster

    CLUSTER_NAME = 'my_cluster_name'
    api.clusters.get(CLUSTER_NAME).networks.add(vmVlan400)

### Configure bond with several networks

The target configuration of the following program is:

    eth0 ---| 
            |          |------ ovirtmgmt
            |--- bond0 |------ bond0.100 ----- NON_VM_VLAN_100
            |          |------ bond0.200 ----- VM_VLAN_200
    eth4 ---|

    nic0 = params.HostNIC(name = 'eth0', network =  params.Network(), boot_protocol='none', ip=params.IP(address=`*`,` `netmask=`*`, gateway=''))
    nic1 = params.HostNIC(name = 'eth4', network =  params.Network(), boot_protocol='none', ip=params.IP(address=`*`,` `netmask=`*`, gateway=''))
    
    # bond 
    bond = params.Bonding(
       slaves = params.Slaves(host_nic = [ nic0, nic1 ]),
                options = params.Options(
                            option = [
                              params.Option(name = 'miimon', value = '100'),
                              params.Option(name = 'mode', value = '1'),
                              params.Option(name = 'primary', value = 'eth0')]
                            )
                          )
    
    # management network on top of the bond
    managementNetwork = params.HostNIC(network = params.Network(name = 'ovirtmgmt'),
                          name = 'bond0',
                          boot_protocol = 'static',
                              ip = params.IP(
                              address = '10.1.1.1',
                              netmask = '255.255.254.0',
                              gateway = '10.1.1.254'),
                          override_configuration = 1,
                          bonding = bond)
    
    # create vlan device for network with vlan tag 100
    networkName = 'NON_VM_VLAN_100'
    clusterNetwork = api.clusters.get('nettest').networks.get(name = networkName)
    vlanNetwork = params.HostNIC(network = params.Network(name = networkName), name = "bond0.%s" % clusterNetwork.vlan.id)
    
    # create vlan device for network with vlan tag 200
    networkName = 'VM_VLAN_200'
    clusterNetwork = api.clusters.get('nettest').networks.get(name = networkName)
    vlanNetwork2 = params.HostNIC(network = params.Network(name = networkName), name = "bond0.%s" % clusterNetwork.vlan.id)
    
    # Now apply the configuration
    host = api.hosts.get('my-host-name')
    host.nics.setupnetworks(params.Action(force = 0,
                                          check_connectivity = 1,
                                          host_nics = params.HostNics(host_nic = [ managementNetwork, 
                                                                                   vlanNetwork, 
                                                                                   vlanNetwork2 ])))
