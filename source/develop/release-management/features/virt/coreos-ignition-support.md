---
title: CoreOS ignition support
category: feature
authors: rgolan, lrotenbe
feature_name: CoreOS ignition support
feature_modules: engine
feature_status: Merged
---

# CoreOS ignition support

## Overview
From ignition documentation:
> Ignition is a new provisioning utility designed specifically for CoreOS Container Linux. At the most basic level,
> it is a tool for manipulating disks during early boot. This includes partitioning disks, formatting partitions,
> writing files (regular files, systemd units, networkd units, etc.), and configuring users. On first boot, Ignition
> reads its configuration from a source-of-truth (remote [URL, network metadata service, hypervisor bridge, etc.) and
> applies the configuration.


## Summary

This feature will enable us to bootstrap ignition-enabled distros, like RHCOS, FCOS, which are optimized for running
containerized workloads, and by that be a platform provider for OKD 4.x . OKD 4 is heavily reliant on RHCOS to manage nodes
lifecycle. While being very important for OKD, it is not exclusively for it - ignition has several notable
adavantages over cloud-init, it lets you customize your OS fully, and fear-free update it, with the ability to rollback.

## Owner

Roy Golan https://github.com/rgolangh

## Detailed Description

The main driver of this feature is making oVirt a platform provider for OKD 4.X installation. OKD 4.x is a release
which is operator-centric and one which allows managing the openshift cluster using openshift. 'master' and 'worker'
nodes are added using openshift api, and its lifecycle is controlled by a cluster-api specific controller, and the
machine configuration is server by another operator `machine-config-operator`. This means that when you want to roll-out
updates to your cluster workers, you do that with the cluster, its all native.  What enables that is RHCOS OS and its
ignition-enabled customization capability.

## Prerequisites

The VM in hand must be based on an RHCOS images which has openstack provider enabled in the kernel args, in order
to read the ignition config from cloud-init disk `/dev/disk/by-label/config-2`
If you are using a custom made image make sure to include openstack provider in your ignition provider, and
tweak the kernel args to include it `coreos.oem.id=openstack`

## Limitations

There are small differences between the user experience in 4.3 to 4.4.

#### 4.3

At the moment the extra argument in `Initial Boot` or the 'VM.initialization' API object are not inserted into the
ignition config, except for 'hostname' - which will drop the hostname value in `/etc/hostname` and 'custom script' - which contains the full ignition JSON.

#### 4.4

The extra arguments in 'VM.initialization' API object that are not - 'hostname', user details and 'custom script' are not inserted into the ignition config.

## Benefit to oVirt

Make oVirt a viable platform provider for Openshift or Kubernetes deployments.

## Entity Description

No change to entities, the VmInit internal object is reused.

## CRUD

To start working with ignition first import the Fedora CoreOS image as a template from the ovirt 
glance provider, call the template 'fcos'.

Now create a VM from that template using this python snippet. 
It will ignite the VM and change the password of user `core` to `changeme`:

```python

mport time
import ovirtsdk4 as sdk
import ovirtsdk4.types as types

connection = sdk.Connection(
    url='https://ovirt-engine-fqdn/ovirt-engine/api',
    username='admin@internal',
    password='password',
    insecure=True,
    debug=True
)

system_service = connection.system_service()
sds_service = system_service.storage_domains_service()
templates_service = connection.system_service().templates_service()
sd = sds_service.list(search='name=ovirt-image-repository')[0]
sd_service = sds_service.storage_domain_service(sd.id)
images_service = sd_service.images_service()

if len(templates_service.list(search='name=fcos')) == 0:
    images = images_service.list()
    image = next(
        (i for i in images if i.name == 'Fedora CoreOS 30.337 for x86_64'),
        None
    )
    
    # Import the fcos image as template named 'fcos' to domain 'mydata;
    image_service = images_service.image_service(image.id)

    image_service.import_(
        import_as_template=True,
        template=types.Template(
            name='fcos'
        ),
        cluster=types.Cluster(
            name='Default'
        ),
        storage_domain=types.StorageDomain(
            name='iscsi_new'
        )
    )

    ok = False
    while not ok:
        time.sleep(5)
        templates = templates_service.list(search='name=fcos')
        for t in templates:
            if t.status == types.TemplateStatus.OK:
              ok = True
              break

vms_service = connection.system_service().vms_service()
vm = vms_service.add(
    types.Vm(
        name='fcosvm',
        template=types.Template(
            name='fcos',
        ),
        cluster=types.Cluster(
            name='Default'
        ),
    ),
)

vm_service = vms_service.vm_service(vm.id)
while True:
    time.sleep(5)
    vm = vm_service.get()
    if vm.status == types.VmStatus.DOWN:
        break

# ignition file to boot coreos with user core and password changeme
ignition='''
{
  "ignition": { "version": "3.0.0" },
  "passwd": {
    "users": [
      {
        "name": "core",
        "passwordHash": "$y$j9T$skCa2x5kFis7p58gYjz3C1$ykelHfCckRToZKAVYK7GDdLOCi3pcF2WMioI.vmYkj5"
      }
    ]
  }
}
'''

vm_service.start(
    use_cloud_init=True,
    vm=types.Vm(
        initialization=types.Initialization(
            custom_script=ignition,
        )
    )
)
```

## How to create and validate ignition configurations?

Configuration documentation and examples are in https://coreos.com/ignition/docs

See the Fedora CoreOS config transpiler https://github.com/coreos/fcct

To validate a config use [Ignition config validator]()

## User work-flows

User creates a VM from RHCOS/FCOS [image](), and pastes a valid ignition configuration into the 'custom script' section
of `Initial Boot` section Boot the VM When the VM finishes booting all the changes made by ignition shall be applied.

Differences between 4.3 to 4.4:

#### 4.3
See limitations for 4.3 and the above work-flow.
#### 4.4
In 4.4, the only way to enable ignition to a VM is by selecting the RedHat CoreOS Operation System Type.
As a result, the section of `Initial Boot` will changed to ignition and show only the available options for ignition.
It is not required to insert custom script if it is not needed. A ignition version will be automatically added from the engine.
- In case the user added user in the Web-Admin `Initial Boot` section and the user is different from users in the custom script, it will configure all of them.
- If the user configured hostname in the Web-Admin `Initial Boot` section and in the custom script, the UI will be ignored.
- Sending custom script will always be "the stronger" entity and will win in cases of collusion with the engine.
- The same changes apply to API use.

For 4.4, `use_ignition` is added to the API to force select initialization with ignition.
Note that `use_cloud_init` won't work in 4.4.

- In both 4.3 and 4.4 `use_initialization` flag added, selecting 'RedHat CoreOS' Operation System for the VM and using this flag will automatically select the initialization type for the VM.


## Event Reporting

There are no special ovirt-engine events for this activity.


## Documentation & External references

[CoreOS ignition docs](https://coreos.com/ignition/docs/latest/)

[Ignition example configs](https://coreos.com/ignition/docs/latest/examples.html)

[Ignition config validator](https://github.com/coreos/container-linux-userdata-validator)

#### Related bugs:

[Add RHCOS to the list of operating systems](https://bugzilla.redhat.com/1726907)

[Have a generic way to initialize a VM in run-once](https://bugzilla.redhat.com/1797659)

## Testing

- Prepare a FCOS or RHCOS template. An image can be found here:
https://ci.centos.org/artifacts/fedora-coreos/prod/builds/latest/
- Create a VM from that template, like shown in section [CRUD](#CRUD)
- Verify that a file name /foo/bar exists with content 'example file'

For a negative test, make sure that cloud-init keep working for Centos or any other cloud-init ready OS.


## Future work
- This feature doesn't support all the `VM.initialization` properties, and we would certainly want to include some of
  them, without letting the admin specifying an ignition config.
- Network configuration which are currently cloud-init specific protocol will not work with ignition. Ignition simply
  manipulate the disk therefore the desired network state will be achieved through laying configuration files.
- Better user experience with the Web-Admin UI. Currently we made some changes to make it more friendly but, we would like     to add JSON validator to the custom script section. 
