---
title: PythonApi
category: api
authors: mgoldboi, mkollaro, moti, mpavlik, rvaknin
wiki_title: Testing/PythonApi
wiki_revision_count: 36
wiki_last_updated: 2014-03-27
---

# Python Api

## Create a Basic Environment using ovirt-engine-sdk

Ovirt-Engine-SDK is an auto-generated python API which uses REST-API to perform operations against ovirt-engine. In order to connect to ovirt-engine using ovirt-engine-sdk and get the API proxy (reference instance to REST-API), the following connection information is required:

*   URL - The URL consists of HTTP method, ovirt-engine's IP or FQDN, ovirt-engine's TCP PORT and the REST-API's entry point. The HTTP method and the PORT are usually HTTPS/8443 for secure connection (default installation option), or HTTP/8080 for insecure connection (in use mostly in development environments). The REST-API's entry point is fixed - "/api"

<!-- -->

*   User and Password - The user consists of a username, the "@" sign and domain name. You can use either the default internal user's account or any of your LDAP users that has both login permissions and of course also has permissions to execute the desired operations.

Below you can find ovirt-engine-sdk sample code-snippets for the following basic operations:

*   Import the relevant modules and obtain an API object
*   Create iSCSI Data Center
*   Create Cluster
*   Install Host
*   Create iSCSI Storage Domain on Data Center
*   Attach ISO domain to Data Center
*   Attach Export domain to Data Center
*   Create VM with one NIC and one Disk
*   Start/hibernate/resume/stop vm
*   Export vm (into Export Domain)
*   Delete vm
*   Import vm (from Export Domain)
*   Create a snapshot to vm
*   Create a Template from VM
*   Create VM from Template

<!-- -->

*   **Importing the relevant modules and obtaining an API object**

Add the following to you python script, remember to set the URL/USERNAME/PASSWORD constants accordingly

         #! /usr/bin/python
         
         from ovirtsdk.api import API
         from ovirtsdk.xml import params
         
         URL = '`[`https://192.168.1.1:8443/api`](https://192.168.1.1:8443/api)`'
         USERNAME = 'my_user@my.domain.com'
         PASSWORD = 'my_password'
         
         api = API(url=URL, username=USERNAME, password=PASSWORD)

*   **Create iSCSI Data Center**

         try:
             if api.datacenters.add(params.DataCenter(name='my_datacenter', storage_type='iscsi', version=params.Version(major='3', minor='0'))):
                 print 'iSCSI Data Center was created successfully'
         except Exception as e:
             print 'Failed to create iSCSI Data Center:\n%s' % str(e)

*   **Create Cluster**

Note that the CPU type should be chosen according to your host's CPU.

         CPU_TYPE = 'Intel Nehalem Family'
         
         try:
             if api.clusters.add(params.Cluster(name='my_cluster', cpu=params.CPU(id=CPU_TYPE), data_center=api.datacenters.get('my_datacenter'), version=params.Version(major='3', minor='0'))):
                 print 'Cluster was created successfully'
         except Exception as e:
             print 'Failed to create Cluster:\n%s' % str(e)

*   **Install Host**

         HOST_ADDRESS = 'hostname.my.domain.com'
         ROOT_PASSWORD = 'root_password'
         
         try:
                 if api.hosts.add(params.Host(name='my_host', address=HOST_ADDRESS, cluster=api.clusters.get('my_cluster'), root_password=ROOT_PASSWORD)):
                     print 'Host was installed successfully'
         except Exception as e:
                 print 'Failed to install Host:\n%s' % str(e)
         
         print 'Waiting for host to reach the Up status'
         while 1:
             try:
                 if api.hosts.get('my_host').status.state == 'up':
                     break
             except:
                 pass

*   **Create iSCSI Storage Domain on Data Center**

         STORAGE_ADDRESS = 'storage_server.my.domain.com'
         TARGET_NAME = 'target_name'
         LUN_GUID = 'lun_guid'
         
         sdParams = params.StorageDomain(name='my_iscsi',
                           data_center=api.datacenters.get('my_datacenter'),
                           storage_format='v2',
                           type_='data',
                           host=api.hosts.get('my_host'),
                           storage = params.Storage(type_='iscsi',
                                            volume_group=params.VolumeGroup(logical_unit=[params.LogicalUnit(id=LUN_GUID,
                                                                address=STORAGE_ADDRESS,
                                                                port=3260,
                                                                target=TARGET_NAME)]))  )
         
         try:
             if api.storagedomains.add(sdParams):
                 print 'iSCSI Storage Domain was created successfully'
         except Exception as e:
             print 'Failed to create iSCSI Storage Domain:\n%s' % str(e)
         
         try:
             if api.datacenters.get(name='my_datacenter').storagedomains.add(api.storagedomains.get(name='my_iscsi')):
                 print 'iSCSI Storage Domain was attached successfully'
         except Exception as e:
             print 'Failed to attach iSCSI Storage Domain:\n%s' % str(e)

*   **Attach ISO domain to Data Center**

You can either create a new ISO Storage Domain or import an existing ISO Storage Domain that was configured during ovirt-engine's installation wizard (both options uses the same code below). Please upload the following ISO file to the ISO Storage Domain once the ISO Storage Domain was created: <http://distro.ibiblio.org/tinycorelinux/4.x/x86/release/TinyCore-current.iso>

         ISO_ADDRESS = 'my_ovirt_engine_ip'
         ISO_PATH = '/path/to/iso/domain'
         
         isoParams = params.StorageDomain(name='my_iso',
                                             data_center=api.datacenters.get('my_datacenter'),
                                             type_='iso',
                                             host=api.hosts.get('my_host'),
                                             storage = params.Storage(   type_='nfs',
                                                                         address=ISO_ADDRESS,
                                                                         path=ISO_PATH  )  )
         
         try:
             if api.storagedomains.add(isoParams):
                 print 'ISO Domain was created/imported successfully'
         except Exception as e:
             print 'Failed to create/import an ISO Domain:\n%s' % str(e)
         
         try:
             if api.datacenters.get('my_datacenter').storagedomains.add(api.storagedomains.get('my_iso')):
                 print 'ISO Domain was attached successfully'
         except Exception as e:
             print 'Failed to attach ISO Domain:\n%s' % str(e)
         
         try:
             if api.datacenters.get('my_datacenter').storagedomains.get('my_iso').activate():
                 print 'ISO Domain was activated successfully'
         except Exception as e:
             print 'Failed to activate ISO Domain:\n%s' % str(e)

*   **Attach Export domain to Data Center**

         EXPORT_ADDRESS = 'ip_of_export_domain_storage'
         EXPORT_PATH = '/path/to/export/domain'
         
         isoParams = params.StorageDomain(name='my_export',
                                             data_center=api.datacenters.get('my_datacenter'),
                                             type_='export',
                                             host=api.hosts.get('my_host'),
                                             storage = params.Storage(   type_='nfs',
                                                                         address=EXPORT_ADDRESS,
                                                                         path=EXPORT_PATH  )  )
         try:
             if api.storagedomains.add(isoParams):
                 print 'Export Domain was created/imported successfully'
         except Exception as e:
             print 'Failed to create/import an Export Domain:\n%s' % str(e)
         
         try:
             if api.datacenters.get('my_datacenter').storagedomains.add(api.storagedomains.get('my_export')):
                 print 'Export Domain was attached successfully'
         except Exception as e:
             print 'Failed to attach Export Domain:\n%s' % str(e)
         
         try:
             if api.datacenters.get('my_datacenter').storagedomains.get('my_export').activate():
                 print 'Export Domain was activated successfully'
         except Exception as e:
             print 'Failed to activate Export Domain:\n%s' % str(e)

*   **Create VM with one NIC and one Disk**

         VDISKSIZE = 5368709120
         
         
         try:
             if api.vms.add( params.VM(name='my_vm',
                                       memory=2147483648,
                                       cluster=api.clusters.get('my_cluster'),
                                       template=api.templates.get('Blank')) ):
                 print 'vm created successfully'
         except Exception as e:
             print 'Failed to create vm:\n%s' % str(e)
         
         
         try:
             if api.vms.get('my_vm').nics.add( params.NIC(name='eth0',
                                                          network=params.Network(name='ovirtmgmt'),
                                                          interface='virtio')):
                 print 'NIC was added to vm successfully'
         except Exception as e:
             print 'Failed to add NIC to vm:\n%s' % str(e)
         
         
         try:
             if api.vms.get('my_vm').disks.add( params.Disk(storage_domains=params.StorageDomains(storage_domain=[api.storagedomains.get('my_iscsi')]),
                                                            size=VDISKSIZE,
                                                            type_='system',
                                                            status=None,
                                                            interface='virtio',
                                                            format='cow',
                                                            sparse=True,
                                                            bootable=True)  ):
                 print 'Disk was added to vm successfully'
         except Exception as e:
             print 'Failed to add disk to vm:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

*   **Start/hibernate/resume/stop vm**

         try:
             if api.vms.get('my_vm').start():
                 print 'Start VM'
         except Exception as e:
             print 'Failed to Start VM:\n%s' % str(e)
         
         print 'Waiting for vm to reach Up status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'up':
                     break
             except:
                 pass

         try:
             if api.vms.get('my_vm').suspend():
                 print 'Hibernate VM'
         except Exception as e:
             print 'Failed to Hibernate VM:\n%s' % str(e)
         
         print 'Waiting for vm to reach Suspended status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'suspended':
                     break
             except:
                 pass

         try:
             if api.vms.get('my_vm').start():
                 print 'Resume VM'
         except Exception as e:
             print 'Resume VM:\n%s' % str(e)
         
         print 'Waiting for vm to Resume'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'up':
                     break
             except:
                 pass

         try:
             if api.vms.get('my_vm').stop():
                 print 'Stop VM'
         except Exception as e:
             print 'Stop VM:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

*   **Export vm (into Export Domain)**

         try:
             if api.vms.get('my_vm').export(params.Action(storage_domain=api.storagedomains.get('my_export'))):
                 print 'VM was exported successfully'
         except Exception as e:
             print 'Failed to export vm:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

*   **Delete vm**

         try:
             if api.vms.get('my_vm').delete():
                 print 'VM was removed successfully'
         except Exception as e:
             print 'Failed to remove VM:\n%s' % str(e)
         
         print 'Waiting for vm to be deleted'
         while 1:
             try:
                 if 'my_vm' not in [vm.name for vm in api.vms.list()]:
                     break
             except:
                 pass

*   **Import vm (from Export Domain)**

         try:
             if api.storagedomains.get('my_export').vms.get('my_vm').import_vm(params.Action(storage_domain=api.storagedomains.get('my_iscsi'), cluster=api.clusters.get(name='my_cluster'))):
                 print 'VM was imported successfully'
         except Exception as e:
             print 'Failed to import VM:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

*   **Create a snapshot to vm**

         try:
             if api.vms.get('my_vm').snapshots.add(params.Snapshot(description='my_snapshot', vm=api.vms.get('my_vm'))):
                 print 'Creating a Snapshot'
         except Exception as e:
             print 'Failed to Create a Snapshot:\n%s' % str(e)
         
         print 'Waiting for Snapshot creation to finish'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'image_locked':
                     break
             except:
                 pass

*   **Create a Template from VM**

         try:
             if api.templates.add(params.Template(name='my_template', vm=api.vms.get('my_vm'), cluster=api.clusters.get('my_cluster'))):
                 print 'Creating a Template from vm'
         except Exception as e:
             print 'Failed to Create a Template from vm:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

*   **Create VM from Template**

         try:
             if api.vms.add( params.VM(name='my_vm_from_template',
                                      cluster=api.clusters.get('my_cluster'),
                                      template=api.templates.get('my_template')) ):
                 print 'VM was created from Template successfully'
         except Exception as e:
             print 'Failed to create VM from Template:\n%s' % str(e)
         
         print 'Waiting for vm to reach Down status'
         while 1:
             try:
                 if api.vms.get('my_vm').status.state == 'down':
                     break
             except:
                 pass

## Here are all the commands aggregated in one block for easy copy-paste:

    #! /usr/bin/python

    import time
    from ovirtsdk.api import API
    from ovirtsdk.xml import params

    # Constants - need to be adjusted to your environment

    URL = 'https://192.168.1.1:8443/api'
    USERNAME = 'my_user@my.domain.com'
    PASSWORD = 'my_password'

    CPU_TYPE = 'Intel Nehalem Family'

    HOST_ADDRESS = 'hostname.my.domain.com'
    ROOT_PASSWORD = 'root_password'

    STORAGE_ADDRESS = 'storage_server.my.domain.com'
    TARGET_NAME = 'target_name'
    LUN_GUID = 'lun_guid'

    ISO_ADDRESS = 'my_ovirt_engine_ip'
    ISO_PATH = '/path/to/iso/domain'

    EXPORT_ADDRESS = 'ip_of_export_domain_storage'
    EXPORT_PATH = '/path/to/export/domain'

    VDISKSIZE = 5368709120

    # Get an API object

    api = API(url=URL, username=USERNAME, password=PASSWORD)

    # Create iSCSI Data Center

    try:
        if api.datacenters.add(params.DataCenter(name='my_datacenter', storage_type='iscsi', version=params.Version(major='3', minor='0'))):
            print 'iSCSI Data Center was created successfully'
    except Exception as e:
        print 'Failed to create iSCSI Data Center:\n%s' % str(e)

    # Create Cluster

    try:
        if api.clusters.add(params.Cluster(name='my_cluster', cpu=params.CPU(id=CPU_TYPE), data_center=api.datacenters.get('my_datacenter'), version=params.Version(major='3', minor='0'))):
            print 'Cluster was created successfully'
    except Exception as e:
        print 'Failed to create Cluster:\n%s' % str(e)

    # Install Host

    try:
        if api.hosts.add(params.Host(name='my_host', address=HOST_ADDRESS, cluster=api.clusters.get('my_cluster'), root_password=ROOT_PASSWORD)):
            print 'Host was installed successfully'
    except Exception as e:
        print 'Failed to install Host:\n%s' % str(e)

    print 'Waiting for host to reach the Up status'
    while 1:
        try:
            if api.hosts.get('my_host').status.state == 'up':
                break
        except:
            pass

    # Create iSCSI Storage Domain on Data Center

    sdParams = params.StorageDomain(name='my_iscsi',
                     data_center=api.datacenters.get('my_datacenter'),
                     storage_format='v2',
                     type_='data',
                     host=api.hosts.get('my_host'),
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
        if api.datacenters.get(name='my_datacenter').storagedomains.add(api.storagedomains.get(name='my_iscsi')):
            print 'iSCSI Storage Domain was attached successfully'
    except Exception as e:
        print 'Failed to attach iSCSI Storage Domain:\n%s' % str(e)

    # Attach ISO domain to Data Center

    isoParams = params.StorageDomain(name='my_iso',
                                       data_center=api.datacenters.get('my_datacenter'),
                                       type_='iso',
                                       host=api.hosts.get('my_host'),
                                       storage = params.Storage(   type_='nfs',
                                                                   address=ISO_ADDRESS,
                                                                   path=ISO_PATH  )  )

    try:
        if api.storagedomains.add(isoParams):
            print 'ISO Domain was created/imported successfully'
    except Exception as e:
        print 'Failed to create/import an ISO Domain:\n%s' % str(e)

    try:
        if api.datacenters.get('my_datacenter').storagedomains.add(api.storagedomains.get('my_iso')):
            print 'ISO Domain was attached successfully'
    except Exception as e:
        print 'Failed to attach ISO Domain:\n%s' % str(e)

    try:
        if api.datacenters.get('my_datacenter').storagedomains.get('my_iso').activate():
            print 'ISO Domain was activated successfully'
    except Exception as e:
        print 'Failed to activate ISO Domain:\n%s' % str(e)

    # Attach Export domain to Data Center

    isoParams = params.StorageDomain(name='my_export',
                                       data_center=api.datacenters.get('my_datacenter'),
                                       type_='export',
                                       host=api.hosts.get('my_host'),
                                       storage = params.Storage(   type_='nfs',
                                                                   address=EXPORT_ADDRESS,
                                                                   path=EXPORT_PATH  )  )
    try:
        if api.storagedomains.add(isoParams):
            print 'Export Domain was created/imported successfully'
    except Exception as e:
        print 'Failed to create/import an Export Domain:\n%s' % str(e)

    try:
        if api.datacenters.get('my_datacenter').storagedomains.add(api.storagedomains.get('my_export')):
            print 'Export Domain was attached successfully'
    except Exception as e:
        print 'Failed to attach Export Domain:\n%s' % str(e)

    try:
        if api.datacenters.get('my_datacenter').storagedomains.get('my_export').activate():
            print 'Export Domain was activated successfully'
    except Exception as e:
        print 'Failed to activate Export Domain:\n%s' % str(e)

    # Create VM with one NIC and one Disk

    try:
        if api.vms.add( params.VM(name='my_vm',
                                 memory=2147483648,
                                 cluster=api.clusters.get('my_cluster'),
                                 template=api.templates.get('Blank')) ):
            print 'vm created successfully'
    except Exception as e:
        print 'Failed to create vm:\n%s' % str(e)

    try:
        if api.vms.get('my_vm').nics.add( params.NIC(name='eth0',
                                                    network=params.Network(name='ovirtmgmt'),
                                                    interface='virtio')):
            print 'NIC was added to vm successfully'
    except Exception as e:
        print 'Failed to add NIC to vm:\n%s' % str(e)

    try:
        if api.vms.get('my_vm').disks.add( params.Disk(storage_domains=params.StorageDomains(storage_domain=[api.storagedomains.get('my_iscsi')]),
                                                      size=VDISKSIZE,
                                                      type_='system',
                                                      status=None,
                                                      interface='virtio',
                                                      format='cow',
                                                      sparse=True,
                                                      bootable=True)  ):
            print 'Disk was added to vm successfully'
    except Exception as e:
        print 'Failed to add disk to vm:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass

    # Start VM

    try:
        if api.vms.get('my_vm').start():
            print 'Start VM'
    except Exception as e:
        print 'Failed to Start VM:\n%s' % str(e)

    print 'Waiting for vm to reach Up status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'up':
                break
        except:
            pass

    time.sleep(20) # workaround for bug that vm is reported as Up before it's actually Up

    # Hibernate VM

    try:
        if api.vms.get('my_vm').suspend():
            print 'Hibernate VM'
    except Exception as e:
        print 'Failed to Hibernate VM:\n%s' % str(e)

    print 'Waiting for vm to reach Suspended status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'suspended':
                break
        except:
            pass

    # Resume VM

    try:
        if api.vms.get('my_vm').start():
            print 'Resume VM'
    except Exception as e:
        print 'Resume VM:\n%s' % str(e)

    print 'Waiting for vm to Resume'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'up':
                break
        except:
            pass

    time.sleep(20) # workaround for bug that vm is reported as Up before it's actually Up

    # Stop VM

    try:
        if api.vms.get('my_vm').stop():
            print 'Stop VM'
    except Exception as e:
        print 'Stop VM:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass

    # Export vm (into Export Domain)

    try:
        if api.vms.get('my_vm').export(params.Action(storage_domain=api.storagedomains.get('my_export'))):
            print 'VM was exported successfully'
    except Exception as e:
        print 'Failed to export vm:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass

    # Delete vm

    try:
        if api.vms.get('my_vm').delete():
            print 'VM was removed successfully'
    except Exception as e:
        print 'Failed to remove VM:\n%s' % str(e)

    print 'Waiting for vm to be deleted'
    while 1:
        try:
            if 'my_vm' not in [vm.name for vm in api.vms.list()]:
                break
        except:
            pass

    # Import vm (from Export Domain)

    try:
        if api.storagedomains.get('my_export').vms.get('my_vm').import_vm(params.Action(storage_domain=api.storagedomains.get('my_iscsi'), cluster=api.clusters.get(name='my_cluster'))):
            print 'VM was imported successfully'
    except Exception as e:
        print 'Failed to import VM:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass

    # Create a snapshot to vm

    try:
        if api.vms.get('my_vm').snapshots.add(params.Snapshot(description='my_snapshot', vm=api.vms.get('my_vm'))):
            print 'Creating a Snapshot'
    except Exception as e:
        print 'Failed to Create a Snapshot:\n%s' % str(e)

    print 'Waiting for Snapshot creation to finish'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'image_locked':
                break
        except:
            pass

    # Create a Template from VM

    try:
        if api.templates.add(params.Template(name='my_template', vm=api.vms.get('my_vm'), cluster=api.clusters.get('my_cluster'))):
            print 'Creating a Template from vm'
    except Exception as e:
        print 'Failed to Create a Template from vm:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass

    # Create VM from Template

    try:
        if api.vms.add( params.VM(name='my_vm_from_template',
                                cluster=api.clusters.get('my_cluster'),
                                template=api.templates.get('my_template')) ):
            print 'VM was created from Template successfully'
    except Exception as e:
        print 'Failed to create VM from Template:\n%s' % str(e)

    print 'Waiting for vm to reach Down status'
    while 1:
        try:
            if api.vms.get('my_vm').status.state == 'down':
                break
        except:
            pass
