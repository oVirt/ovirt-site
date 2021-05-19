---
title: Python-sdk
category: feature
authors: adahms, bproffitt, michael pasternak
---

# Python-SDK (API v3)

The oVirt Python-SDK is an automatically generated software development kit for the oVirt engine API.
This software development kit allows you to develop Python-based applications for automating a variety of complex administrative tasks in oVirt.

**Note:** please note that in this page examples refers to the version 3 of the API.

**Note:** if you're looking for the version 4 of the API please refer to the [oVirt Engine API Python SDK Documentation](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/README.adoc).

__TOC__

## Concepts

*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Auto-completion.
*   Self descriptive.
*   Auto-Generated
*   Intuitive and easy to use.

## IDE Examples

### Creating the proxy and listing all collections:

![](/images/wiki/1psdk.png "proxy")

### Listing the methods of a collection:

![](/images/wiki/2psdk.png "list methods")

### Querying a collection using the oVirt search engine query and custom constraints:

![](/images/wiki/3psdk.png "query")

### Accessing resource methods and properties:

![](/images/wiki/4psdk.png "methods")

### Creating a resource:

![](/images/wiki/Create_sdk_resource.png)

### Accessing resource properties and sub-collections:

![](/images/wiki/5psdk.png "properties")

### Accessing sub-collection methods:

![](/images/wiki/6psdk.png "sub-collection")

### Querying a sub-collection using a custom constraint:

![](/images/wiki/7psdk.png "query")

### Retrieving a sub-collection resource:

![](/images/wiki/8psdk.png "retrieve sub-collection")

### Accessing sub-collection resource properties and methods:

![](/images/wiki/9psdk.png "sub-collection resource properties")

## Examples
```python
from ovirtsdk.xml import params

from ovirtsdk.api import API
```

*   create proxy

```python
api = API(url='[http://host:port/api](http://host:port/api)', username='user@domain', password='password')
```

*   list entities

```python
vms1 = api.vms.list()
```

*   list entities using query

```python
vms2 = api.vms.list(query='name=python_vm')
```

*   search vms by property constraint

```python
vms3 = api.vms.list(memory=1073741824)
```

*   update resource

```python
vm1 = api.vms.get(name='python_vm')

vm1.description = 'updated_desc'

vm2 = vm1.update()
```

*   list by constraints

```python
vms4 = api.vms.list(name='pythond_sdk_poc2')
```

*   get by name

```python
vm4 = api.vms.get(name='pythond_sdk_poc2')
```

*   get by constraints

```python
vm5 = api.vms.get(id='02f0f4a4-9738-4731-83c4-293f3f734782')
```

*   add resource

```python
param = params.VM(name='my_vm',
                  cluster=api.clusters.get(name='xxx'),
                  template=api.templates.get(name='yyy'),
                  ...)

my_vm = api.vms.add(param)
```

*   add sub-resource to resource

```python
network = params.Network(name='rhevm')

nic = params.NIC(name='eth0', network=network, interface='e1000')

vm6.nics.add(nic)
```

*   add sub-resource to resource where one of the parameters is collection

```python
sd = api.storagedomains.get('nfs_data')
diskParam = params.Disk(storage_domains=params.StorageDomains(storage_domain=[sd]), 
                        size=5368709120, 
                        type_='data', 
                        interface='virtio', 
                        format='cow')

myVm = api.vms.get(name='nfs_desktop')
neDisk = myVm.disks.add(diskParam)
```

*   note: params.Disk(storage_domains=..., => this is means that Disk constructor should receive collection (params.StorageDomains()) as parameter

<!-- -->

*   list sub-resources

```python
nics1 = vm6.nics.list()
```

*   list sub-resources using constraint/s

```python
nics2 = vm6.nics.list(name='eth0')

nics3 = vm6.nics.list(interface='e1000')
```

*   get sub-resource

```python
nic1 = vm6.nics.get(name='eth0')
```

*   update sub-resource

```python
nic1.name = 'eth01'
      
nic2 = nic1.update()

nic3 = vm6.nics.get(name='eth01')

nic4 = vm6.nics.get(name='eth0')
```



## Development tips

### Parameters holder type location

If you find difficult locating appropriate type while constructing

parameter environment, like in [1] for instance, you can reuse internal

params lookup as shown in [2].

```python
#[1]
VMs.add(self, vm, ...):[@param vm.cpu.topology.cores: int]

#[2]
topology = params.findRootClass("topology")
#in this case will be returned CpuTopology type.
```

### Releasing resources when SDK proxy is no longer needed

```python
try:
    api = API(url='...', username='...', password='...')
    #...
finally:
    api.disconnect()
```

## Deployment

### pypi

<http://pypi.python.org/pypi/ovirt-engine-sdk-python>

    easy_install ovirt-engine-sdk-python

### rpm

To build rpm and install it, from ovirt-engine-sdk repo:

    yum install -y rpm-build python-devel python-setuptools

    make rpm

    yum install rpmtop/RPMS/noarch/ovirt-engine-sdk-x.y-z.noarch.rpm

### development deployment (using distro package manager)

For local install in site-packages, from ovirt-engine-sdk repo:

*   Fedora

        yum install python-lxml
        cd ovirt-engine-sdk
        python setup.py install

*   Debian/Ubuntu

        apt-get install python-lxml
        cd ovirt-engine-sdk
        python setup.py install

*   Arch linux

        pacman -S python2
        cd ovirt-engine-sdk
        python2 setup.py install

*   note: both deployment procedures require super-user permissions.

### development deployment (using pip and virtualenvwrapper package manager)

*   Fedora

        yum install python-pip

*   Debian/Ubuntu

        apt-get install python-pip libxml2-dev libxslt1-dev build-essential

*   Arch linux

        pacman -S python 2 python-pip

*   Common among the previous distributions

        pip install virtualenvwrapper
        cat >> ~/.bashrc << EOF
        export WORKON_HOME=$HOME/.virtualenvs
        export WORKON_HOME=$HOME/yourprojectdir
        source /usr/local/bin/virtualenvwrapper.sh # omit the local part for Arch Linux
        EOF
        mkvirtualenv -p /usr/bin/python2.7 ovirt
        cd ovirt-engine-sdk
        python setup.py install

Then, every time you want to use it:

    workon ovirt

will make ovirt and its dependencies available to your python execution environment.

## codegen

install generateDS

    easy_install generateDS

note: currently we support only 2.9a

codegen

      1. compile + deploy new ovirt-engine
      2. run jboss
      3. run codegen.main.py

## Known issues

## TODO list

### Bugs/RFEs

[Bugzila](https://bugzilla.redhat.com/buglist.cgi?list_id=363325&classification=Community&query_based_on=ovirt_sdk_bugs&query_format=advanced&token=1343748821-516898cbb4251bbe2a7856f547f55f74&bug_status=NEW&bug_status=ASSIGNED&component=ovirt-engine-sdk&classificiation=oVirt&known_name=ovirt_sdk_bugs)

### codegen

*   interface for task polling

<!-- -->

*   supporting off-line codegen mode

### sdk

*   supporting several proxy instances in application (done)

<!-- -->

*   refactor caching mechanism

<!-- -->

*   implement __exit__ in proxy

<!-- -->

*   refactoring internal exceptions for better error handling on client side


## Maintainers

Michael Pasternak: mishka8520@yahoo.com, Juan Hernandez: juan.hernandez@redhat.com

