---
title: Python-sdk
category: sdk
authors: adahms, bproffitt, michael pasternak
wiki_category: SDK
wiki_title: Python-sdk
wiki_revision_count: 36
wiki_last_updated: 2015-03-25
---

# Python-sdk

oVirt SDK package a software development kit for the oVirt engine api.

[Notes from workshop in November 2011](API - oVirt workshop November 2011 Notes).

__TOC__

## Concepts

*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Auto-completion.
*   Self descriptive.
*   Auto-Generated
*   Intuitive and easy to use.

## IDE Examples

### Creating the proxy & Listing all collections

![](1.jpg "1.jpg")

### Listing collection's methods

![](2.jpg "2.jpg")

### Querying collection with oVirt search engine query & custom constraint

![](3.jpg "3.jpg")

### Accessing resource methods and properties

![](4.jpg "4.jpg")

### Creating resource

![](create_sdk_resource.jpg "create_sdk_resource.jpg")

### Accessing resource properties and sub-collections

![](5.jpg "5.jpg")

### Accessing sub-collection methods

![](6.jpg "6.jpg")

### Querying sub-collection by custom constraint.

![](7.jpg "7.jpg")

### Retrieving sub-collection resource.

![](8.jpg "8.jpg")

### Accessing sub-collection resource properties and methods

![](9.jpg "9.jpg")

## Examples

from ovirtsdk.xml import params

from ovirtsdk.api import API

*   create proxy

api = API(url='[http://host:port](http://host:port)', username='user@domain', password='password')

*   list entities

       vms1 = api.vms.list()

*   list entities using query

       vms2 = api.vms.list(query='name=python_vm')

*   search vms by property constraint

       vms3 = api.vms.list(memory=1073741824)

*   update resource

       vm1 = api.vms.get(name='python_vm')
       
       vm1.description = 'updated_desc'
       
       vm2 = vm1.update()

*   list by constraints

       vms4 = api.vms.list(name='pythond_sdk_poc2')

*   get by name

       vm4 = api.vms.get(name='pythond_sdk_poc2')

*   get by constraints

       vm5 = api.vms.get(id='02f0f4a4-9738-4731-83c4-293f3f734782')

*   add resource

       param = params.VM(name='my_vm',
                         cluster=api.clusters.get(name='xxx'),
                         template=api.templates.get(name='yyy'),
                         ...)
       
       my_vm = api.vms.add(param)

*   add sub-resource to resource

       network = params.Network(name='rhevm')
       
       nic = params.NIC(name='eth0', network=network, interface='e1000')
       
       vm6.nics.add(nic)

*   add sub-resource to resource where one of the parameters is collection

       sd = api.storagedomains.get('nfs_data')
       diskParam = params.Disk(storage_domains=params.StorageDomains(storage_domain=[sd]), 
                               size=5368709120, 
                               type_='data', 
                               interface='virtio', 
                               format='cow')
       
       myVm = api.vms.get(name='nfs_desktop')
       neDisk = myVm.disks.add(diskParam)

*   note: params.Disk(storage_domains=..., => this is means that Disk constructor should receive collection (params.StorageDomains()) as parameter

<!-- -->

*   list sub-resources

       nics1 = vm6.nics.list()

*   list sub-resources using constraint/s

       nics2 = vm6.nics.list(name='eth0')
       
       nics3 = vm6.nics.list(interface='e1000')

*   get sub-resource

       nic1 = vm6.nics.get(name='eth0')

*   update sub-resource

       nic1.name = 'eth01'
       
       nic2 = nic1.update()
       
       nic3 = vm6.nics.get(name='eth01')
       
       nic4 = vm6.nics.get(name='eth0')

*   [more examples](http://www.ovirt.org/wiki/Testing/PythonApi)

## Development tips

If you find difficult locating appropriate type while constructing

parameter environment, like in [1] for instance, you can reuse internal

params lookup as shown in [2].

       [1] VMs.add(self, vm, ...):
                [@param vm.cpu.topology.cores: int]

       [2] topology = params.findRootClass("topology") 
           in this case will be returned CpuTopology type.

## Repository

*   <git://gerrit.ovirt.org/ovirt-engine-sdk>

## Deployment

### pypi

<http://pypi.python.org/pypi/ovirt-engine-sdk>

      easy_install ovirt-engine-sdk

### rpm

To build rpm and install it, from ovirt-engine-sdk repo:

      yum install -y rpm-build python-devel python-setuptools

      make rpm

      yum localinstall rpmtop/RPMS/noarch/ovirt-engine-sdk-x.y-z.noarch.rpm

### development deployment (using distro package manager)

For local install in site-packages, from ovirt-engine-sdk repo:

*   Fedora

      yum install python-lxml
      cd ovirt-engine-sdk
      python setup.py install

*   Debian/Ubuntu

      apt-get install python-lxml
      cd ovirt-engine-sdk
      python setup.py install

*   Arch linux

      pacman -S python2
      cd ovirt-engine-sdk
      python2 setup.py install

*   note: both deployment procedures require super-user permissions.

### development deployment (using pip and virtualenvwrapper package manager)

*   Fedora

      yum install python-pip

*   Debian/Ubuntu

      apt-get install python-pip libxml2-dev libxslt1-dev build-essential

*   Arch linux

      pacman -S python 2 python-pip

*   Common among the previous distributions

      pip install virtualenvwrapper
      cat >> ~/.bashrc << EOF
      export WORKON_HOME=$HOME/.virtualenvs
      export WORKON_HOME=$HOME/yourprojectdir
      source /usr/local/bin/virtualenvwrapper.sh # omit the local part for Arch Linux
      EOF
      mkvirtualenv -p /usr/bin/python2.7 ovirt
      cd ovirt-engine-sdk
      python setup.py install

Then, every time you want to use it:

      workon ovirt

will make ovirt and its dependencies available to your python execution environment.

## Known issues

## TODO list

### Bugs/RFEs

[Bugzila](https://bugzilla.redhat.com/buglist.cgi?list_id=363325&classification=Community&query_based_on=ovirt_sdk_bugs&query_format=advanced&token=1343748821-516898cbb4251bbe2a7856f547f55f74&bug_status=NEW&bug_status=ASSIGNED&component=ovirt-engine-sdk&product=oVirt&known_name=ovirt_sdk_bugs)

### codegen

*   interface for task polling

<!-- -->

*   supporting off-line codegen mode

### sdk

*   supporting several proxy instances in application (i.e cache peer proxy instance)

<!-- -->

*   refactoring internal exceptions for better error handling on client side

## Change Log

[python-sdk-changelog](python-sdk-changelog)

## Maintainer

Michael Pasternak: mpastern@redhat.com

<Category:SDK>
